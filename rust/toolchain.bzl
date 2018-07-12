"""
Toolchain rules used by Rust.
"""

load(":utils.bzl", "relative_path",
                   "workspace_safe_str")
load(":known_shas.bzl", "FILE_KEY_TO_SHA")
load(":triple_mappings.bzl", "triple_to_system",
                             "triple_to_constraint_set",
                             "system_to_dylib_ext",
                             "system_to_staticlib_ext")

ZIP_PATH = "/usr/bin/zip"

def _get_rustc_env(ctx):
  version = ctx.attr.version if hasattr(ctx.attr, "version") else "0.0.0"
  v1, v2, v3 = version.split(".")
  if "-" in v3:
    v3, pre = v3.split("-")
  else:
    pre = ""
  return [
    "CARGO_PKG_VERSION=" + version,
    "CARGO_PKG_VERSION_MAJOR=" + v1,
    "CARGO_PKG_VERSION_MINOR=" + v2,
    "CARGO_PKG_VERSION_PATCH=" + v3,
    "CARGO_PKG_VERSION_PRE=" + pre,
    "CARGO_PKG_AUTHORS=",
    "CARGO_PKG_NAME=" + ctx.label.name,
    "CARGO_PKG_DESCRIPTION=",
    "CARGO_PKG_HOMEPAGE=",
  ]

def _get_comp_mode_codegen_opts(ctx, toolchain):
  comp_mode = ctx.var["COMPILATION_MODE"]
  if not comp_mode in toolchain.compilation_mode_opts:
    fail("Unrecognized compilation mode %s for toolchain." % comp_mode)

  return toolchain.compilation_mode_opts[comp_mode]

def _check_triples(exec_triples, target_triples):
  """Verifies that the provided execution platform and target platform triples make sense.

  The primary property checked is that the execution platform triples are included in the
  target platform triples so that all libraries can be compiled for the execution platform, if
  necessary.

  Args:
    exec_triples: The Bazel execution platform or "host" that the toolchain must run on, in the
        form of a Rust-style triple. More than one triple may be provided.
    target_triples: The supported compilation targets for the toolchains in the form of a Rust-
        style triple. More than one triple may be provided, but this list must include all
        values of exec_triples.
  """

  missing_execs_in_targets = []
  for triple in exec_triples:
    if triple not in target_triples:
      missing_execs_in_targets.append(triple)

  if missing_execs_in_targets:
    fail("target_triples must contain all exec_triples so build scripts can run. It was missing {}"
         .format(missing_execs_in_targets))

def _check_version(version, iso_date):
  """Verifies that the version components (version + date) are sensible

  Args:
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
  """

  if version in ("nightly", "beta"):
    if not iso_date:
      fail("iso_date must be provided if version is nightly or beta", iso_date)
  elif iso_date:
    print("iso_date has no effect when a fixed version is provided")


def _version_str(version, iso_date=None):
  """Produces a unique version string for a given version id and iso_date.

  Args:
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
  """

  if version in ("nightly", "beta"):
    if not iso_date:
      fail('iso_date must be specified to generate version str for "nightly" or "beta"',
           iso_date)

    return "{}-{}".format(version, iso_date)

  # TODO(acmcarther): Pick a better placeholder for "p"
  return version.replace(".", "p")



# Utility methods that use the toolchain provider.
def build_rustc_command(ctx, toolchain, crate_name, crate_type, src, output_dir,
                         depinfo, output_hash=None, rust_flags=[]):
  """
  Constructs the rustc command used to build the current target.
  """

  # Paths to cc (for linker) and ar
  cpp_fragment = ctx.fragments.cpp
  cc = cpp_fragment.compiler_executable
  ar = cpp_fragment.ar_executable
  # Currently, the CROSSTOOL config for darwin sets ar to "libtool". Because
  # rust uses ar-specific flags, use /usr/bin/ar in this case.
  # TODO(dzc): This is not ideal. Remove this workaround once ar_executable
  # always points to an ar binary.
  ar_str = "%s" % ar
  if ar_str.find("libtool", 0) != -1:
    ar = "/usr/bin/ar"

  rpaths = _compute_rpaths(toolchain, ctx.bin_dir, output_dir, depinfo)

  # Construct features flags
  features_flags = _get_features_flags(ctx.attr.crate_features)

  extra_filename = ""
  if output_hash:
    extra_filename = "-%s" % output_hash
    
  codegen_opts = _get_comp_mode_codegen_opts(ctx, toolchain)

  return " ".join(
      ["set -e;"] +
      # If TMPDIR is set but not created, rustc will die.
      ['if [ ! -z "${TMPDIR+x}" ]; then mkdir -p $TMPDIR; fi;'] +
      depinfo.setup_cmd +
      _out_dir_setup_cmd(ctx.file.out_dir_tar) +
      _get_rustc_env(ctx) +
      [
          "LD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          "DYLD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          "OUT_DIR=$(pwd)/out_dir",
          toolchain.rustc.path,
          src.path,
          "--crate-name %s" % crate_name,
          "--crate-type %s" % crate_type,
          "--codegen opt-level=%s" % codegen_opts.opt_level,
          "--codegen debuginfo=%s" % codegen_opts.debug_info,
          # Disambiguate this crate from similarly named ones
          "--codegen metadata=%s" % extra_filename,
          "--codegen extra-filename='%s'" % extra_filename,
          "--codegen ar=%s" % ar,
          "--codegen linker=%s" % cc,
          "--codegen link-args='%s'" % ' '.join(cpp_fragment.link_options),
          "--target=%s" % toolchain.target_triple,
          "--out-dir %s" % output_dir,
          "--emit=dep-info,link",
          "--color always",
      ] +
      ["--codegen link-arg='-Wl,-rpath={}'".format(rpath) for rpath in rpaths] +
      features_flags +
      rust_flags +
      ["-L all=%s" % dir for dir in _get_dir_names(toolchain.rust_lib)] +
      depinfo.search_flags +
      depinfo.link_flags +
      ctx.attr.rustc_flags)

def build_rustdoc_command(ctx, toolchain, rust_doc_zip, depinfo, lib_rs, target, doc_flags):
  """
  Constructs the rustdoc command used to build the current target.
  """

  docs_dir = rust_doc_zip.dirname + "/_rust_docs"
  return " ".join(
      ["set -e;"] +
      depinfo.setup_cmd + [
          "rm -rf %s;" % docs_dir,
          "mkdir %s;" % docs_dir,
          "LD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          "DYLD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          toolchain.rust_doc.path,
          lib_rs.path,
          "--crate-name %s" % target.name,
      ] + ["-L all=%s" % dir for dir in _get_dir_names(toolchain.rust_lib)] + [
          "-o %s" % docs_dir,
      ] +
      doc_flags +
      depinfo.search_flags +
      depinfo.link_flags + [
          "&&",
          "(cd %s" % docs_dir,
          "&&",
          ZIP_PATH,
          "-qR",
          rust_doc_zip.basename,
          "$(find . -type f) )",
          "&&",
          "mv %s/%s %s" % (docs_dir, rust_doc_zip.basename, rust_doc_zip.path),
      ])

def build_rustdoc_test_command(ctx, toolchain, depinfo, lib_rs):
  """
  Constructs the rustdocc command used to test the current target.
  """
  return " ".join(
      ["#!/usr/bin/env bash\n"] +
      ["set -e\n"] +
      depinfo.setup_cmd +
      [
          "LD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          "DYLD_LIBRARY_PATH=%s" % _get_path_str(_get_dir_names(toolchain.rust_lib)),
          toolchain.rust_doc.path,
      ] + ["-L all=%s" % dir for dir in _get_dir_names(toolchain.rust_lib)] + [
          lib_rs.path,
      ] +
      depinfo.search_flags +
      depinfo.link_flags)

def _compute_rpaths(toolchain, bin_dir, output_dir, depinfo):
  """
  Determine the artifact's rpaths relative to the bazel root
  for runtime linking of shared libraries.
  """
  if not depinfo.transitive_dylibs:
    return []
  if toolchain.os != 'linux':
    fail("Runtime linking is not supported on {}, but found {}".format(
            toolchain.os, depinfo.transitive_dylibs))

  # Multiple dylibs can be present in the same directory, so deduplicate them.
  return depset(["$ORIGIN/" + relative_path(output_dir, dylib.dirname)
                    for dylib in depinfo.transitive_dylibs])

def _get_features_flags(features):
  """
  Constructs a string containing the feature flags from the features specified
  in the features attribute.
  """
  features_flags = []
  for feature in features:
    features_flags += ["--cfg feature=\\\"%s\\\"" % feature]
  return features_flags

def _get_dir_names(files):
  dirs = {}
  for f in files:
    dirs[f.dirname] = None
  return dirs.keys()

def _get_path_str(dirs):
  return ":".join(dirs)

def _get_first_file(input):
  if hasattr(input, "files"):
    for f in input.files:
      return f
  return input

def _get_files(input):
  files = []
  for i in input:
    if hasattr(i, "files"):
      files += [f for f in i.files]
  return files

def _out_dir_setup_cmd(out_dir_tar):
  if out_dir_tar:
    return [
        "mkdir ./out_dir/\n",
        "tar -xzf %s -C ./out_dir\n" % out_dir_tar.path,
    ]
  else:
     return []

# The rust_toolchain rule definition and implementation.
def _rust_toolchain_impl(ctx):
  compilation_mode_opts = {}
  for k, v in ctx.attr.opt_level.items():
     if not k in ctx.attr.debug_info:
       fail("Compilation mode %s is not defined in debug_info but is defined opt_level" % k)
     compilation_mode_opts[k] = struct(opt_level = v, debug_info = ctx.attr.debug_info[k])
  for k, v in ctx.attr.debug_info.items():
     if not k in ctx.attr.opt_level:
       fail("Compilation mode %s is not defined in opt_level but is defined debug_info" % k)
  
  toolchain = platform_common.ToolchainInfo(
      rustc = _get_first_file(ctx.attr.rustc),
      rust_doc = _get_first_file(ctx.attr.rust_doc),
      rustc_lib = _get_files(ctx.attr.rustc_lib),
      rust_lib = _get_files(ctx.attr.rust_lib),
      staticlib_ext = ctx.attr.staticlib_ext,
      dylib_ext = ctx.attr.dylib_ext,
      target_triple = ctx.attr.target_triple,
      exec_triple = ctx.attr.exec_triple,
      os = ctx.attr.os,
      compilation_mode_opts = compilation_mode_opts,
      crosstool_files = ctx.files._crosstool)
  return [toolchain]

rust_toolchain = rule(
    _rust_toolchain_impl,
    attrs = {
        "rustc": attr.label(allow_files = True),
        "rust_doc": attr.label(allow_files = True),
        "rustc_lib": attr.label_list(allow_files = True),
        "rust_lib": attr.label_list(allow_files = True),
        "staticlib_ext": attr.string(mandatory = True),
        "dylib_ext": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "exec_triple": attr.string(mandatory = True),
        "target_triple": attr.string(mandatory = True),
        "_crosstool": attr.label(
            default = Label("//tools/defaults:crosstool"),
        ),
        "opt_level": attr.string_dict(default = {"opt": "3", "dbg": "0", "fastbuild": "0"}),
        "debug_info": attr.string_dict(default = {"opt": "0", "dbg": "2", "fastbuild": "0"}),
    },
)


def gen_toolchain_details(exec_triples, target_triples, version_str):
  """Generates a list of toolchains and BUILD file contents for a toolchain workspace

  Each toolchain supports exactly one execution triple and exactly one target triple. One
  toolchain is declared for each combination of execution triple and target triple.

  This defines the default toolchain separately from the actual repositories, so that the remote
  repositories will only be downloaded if they are actually used. It also allows individual
  toolchains to reuse compilers and stdlibs as appropriate.
  """

  triple_to_constraint_values = {}
  for exec_triple in exec_triples:
    triple_to_constraint_values[exec_triple] = triple_to_constraint_set(exec_triple)
  for target_triple in target_triples:
    if not triple_to_constraint_values.get(target_triple):
      triple_to_constraint_values[target_triple] = triple_to_constraint_set(target_triple)

  all_toolchain_names = []
  all_toolchain_decls = []
  for exec_triple in exec_triples:
    for target_triple in target_triples:
      toolchain_name = "rust_for_{}_on_{}".format(target_triple, exec_triple)
      compiler_workspace_name = "@rustc__{}__{}".format(version_str, workspace_safe_str(exec_triple))
      stdlib_workspace_name = "@rust_std__{}__{}".format(version_str, workspace_safe_str(target_triple))
      target_system = triple_to_system(target_triple)
      target_staticlib_ext = system_to_staticlib_ext(target_system)
      target_dylib_ext = system_to_dylib_ext(target_system)
      all_toolchain_names.append(toolchain_name)
      toolchain_decl = """
native.toolchain(
    name = "{toolchain_name}",
    exec_compatible_with = {exec_compatible_with},
    target_compatible_with = {target_compatible_with},
    toolchain = ":{toolchain_name}_impl",
    toolchain_type = "@io_bazel_rules_rust//rust:toolchain"
)

# TODO(acmcarther): Linker Executable: If not specified,
# ctx.host_fragments.cpp.compiler_executable will be used
rust_toolchain(
    name = "{toolchain_name}_impl",
    rust_doc = "{compiler_workspace_name}//:rustdoc",
    rustc = "{compiler_workspace_name}//:rustc",
    rustc_lib = ["{compiler_workspace_name}//:rustc_lib"],
    rust_lib = ["{stdlib_workspace_name}//:rust_lib"],
    staticlib_ext = "{target_staticlib_ext}",
    dylib_ext = "{target_dylib_ext}",
    os = "{target_system}",
    exec_triple = "{exec_triple}",
    target_triple = "{target_triple}",
    visibility = ["//visibility:public"],
)""".format(toolchain_name=toolchain_name,
            exec_triple=exec_triple,
            target_triple=target_triple,
            exec_compatible_with = triple_to_constraint_values[exec_triple],
            target_compatible_with = triple_to_constraint_values[target_triple],
            compiler_workspace_name=compiler_workspace_name,
            stdlib_workspace_name=stdlib_workspace_name,
            target_staticlib_ext=target_staticlib_ext,
            target_dylib_ext=target_dylib_ext,
            target_system=target_system)
      all_toolchain_decls.append(toolchain_decl)

  build_file_content = """
load("@io_bazel_rules_rust//rust:toolchain.bzl", "rust_toolchain")

{toolchain_decls}
""".format(version_str=version_str, toolchain_decls=("\n".join(all_toolchain_decls)))

  return struct(
      toolchain_names = all_toolchain_names,
      build_file_content = build_file_content
  )


def load_tool(name, triple, version, iso_date, tool_name, extra_shas, build_file_content):
  """Loads a rust tool from the standard download site.

  Args:
    name: The generated workspace name
    triple: The Rust-style triple for the tool
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
    tool_name: The name of the tool to load. See KNOWN_TOOL_IDENTS for the list of known tools,
        though this argument is not checked.
    extra_shas: A dict containing mappings from Rust download URLs to known or expected SHAs.
        See known_shas.bzl for the SHAs included in rules_rust, and to see what format is expected.
    build_file_content: The contents of the build file for the loaded tool.
  """

  archive_name = "{tool_name}-{version}-{triple}".format(tool_name=tool_name,
                                                          version=version,
                                                          triple=triple)
  file_key = None
  if version == "nightly":
    file_key = "{iso_date}/{archive_name}.tar.gz".format(iso_date=iso_date,
                                                         archive_name=archive_name)
  elif version == "beta":
    file_key = "{iso_date}/{archive_name}.tar.gz".format(iso_date=iso_date,
                                                         archive_name=archive_name)
  else:
    file_key = "{archive_name}.tar.gz".format(archive_name=archive_name)

  native.new_http_archive(
      name = name,
      url = "https://static.rust-lang.org/dist/{file_key}".format(file_key=file_key),
      strip_prefix = archive_name,
      sha256 = FILE_KEY_TO_SHA.get(file_key) or extra_shas.get(file_key),
      build_file_content = build_file_content
  )


def load_compiler(triple, version, iso_date, extra_shas):
  """Configures and loads the Rust compiler.

  Args:
    triple: A Rust-style platform identifying triple
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
    extra_shas: A dict containing mappings from Rust download URLs to known or expected SHAs.
        See known_shas.bzl for the SHAs included in rules_rust, and to see what format is expected.
  """

  load_tool(
      name = "rustc__{}__{}".format(_version_str(version, iso_date),
                                    workspace_safe_str(triple)),
      triple = triple,
      version = version,
      iso_date = iso_date,
      tool_name = "rustc",
      extra_shas = extra_shas,
      build_file_content = """
filegroup(
    name = "rustc",
    srcs = glob(["rustc/bin/rustc*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustdoc",
    srcs = glob(["rustc/bin/rustdoc*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustc_lib",
    srcs = glob([
        "rustc/lib/*.dll",
        "rustc/lib/*.dylib",
        "rustc/lib/*.so",
    ]),
    visibility = ["//visibility:public"],
)
""".format(triple=triple)
  )


def load_stdlib(triple, version, iso_date, extra_shas):
  """Configures and loads the Rust standard library.

  Args:
    triple: A Rust-style platform identifying triple
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
    extra_shas: A dict containing mappings from Rust download URLs to known or expected SHAs.
        See known_shas.bzl for the SHAs included in rules_rust, and to see what format is expected.
  """

  load_tool(
      name = "rust_std__{}__{}".format(_version_str(version, iso_date),
                                       workspace_safe_str(triple)),
      triple = triple,
      version = version,
      iso_date = iso_date,
      tool_name = "rust-std",
      extra_shas = extra_shas,
      build_file_content = """
filegroup(
    name = "rust_lib",
    srcs = glob([
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.a",
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.dll",
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.dylib",
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.lib",
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.rlib",
        "rust-std-{triple}/lib/rustlib/{triple}/lib/*.so",
    ]),
    visibility = ["//visibility:public"],
)""".format(triple=triple))


def load_mingw(triple, version, iso_date, extra_shas):
  """Configures and loads the Rust MinGW tool.

  It is not valid to call this function with a non-Windows (target) triple.

  Args:
    triple: A Rust-style platform identifying triple
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
    extra_shas: A dict containing mappings from Rust download URLs to known or expected SHAs.
        See known_shas.bzl for the SHAs included in rules_rust, and to see what format is expected.
  """

  if "windows" not in triple:
    fail("rust-mingw cannot be loaded for a non-Windows triple", triple)

  load_tool(
      name = "rust_mingw__{}__{}".format(_version_str(version, iso_date),
                                         workspace_safe_str(triple)),
      triple = triple,
      version = version,
      iso_date = iso_date,
      tool_name = "rust-mingw",
      extra_shas = extra_shas,
      # TODO(acmcarther): Define the BUILD file for rust-mingw
      build_file_content = """
filegroup(
    name = "dlltool",
    srcs = ["rust-mingw/lib/rustlib/{triple}/bin/dlltool.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "gcc",
    srcs = ["rust-mingw/lib/rustlib/{triple}/bin/gcc.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "ld",
    srcs = ["rust-mingw/lib/rustlib/{triple}/bin/ld.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "mingw_lib",
    srcs = glob([
      "rust-mingw/lib/rustlib/{triple}/lib/*.a",
      "rust-mingw/lib/rustlib/{triple}/bin/*.dll",
    ]),
    visibility = ["//visibility:public"],
)""".format(triple=triple))


def prepare_toolchains(name, version_str, exec_triples, target_triples):
  """Generates a toolchain-bearing workspace and registers the set of toolchains.

  This function expects the standard libraries and compilers to have already been declared.

  Args:
    name: The name for the generated toolchain-bearing workspace
    version_str: A sanitized version identifier
    exec_triples: The Bazel execution platform or "host" that the toolchain must run on, in the
        form of a Rust-style triple. More than one triple may be provided.
    target_triples: The supported compilation targets for the toolchains in the form of a Rust-
        style triple. More than one triple may be provided, but this list must include all
        values of exec_triples.
  """

  toolchain_details = gen_toolchain_details(exec_triples, target_triples, version_str)

  native.new_local_repository(
      name = name,
      path = ".",
      build_file_content = toolchain_details.build_file_content
  )

  qualified_toolchain_names = []
  for toolchain_name in toolchain_details.toolchain_names:
    qualified_toolchain_names.append("@{workspace_name}//:{toolchain_name}".format(
        workspace_name=name,
        toolchain_name=toolchain_name))

  native.register_toolchains(*qualified_toolchain_names)


def load_toolchains(version="1.27.0",
                    iso_date=None,
                    exec_triples=["x86_64-unknown-linux-gnu"],
                    target_triples=["x86_64-unknown-linux-gnu"],
                    extra_shas={}):
  """Configures and loads in the set of rust toolchains required to compile Rust.

  This rule loads remote workspaces for all rust compilers for the provided exec_triples, all
  rust stdlibs for the provided target triples, and assembles them together into a list of
  toolchains (one per exec and target) in another workspace. Those toolchains are loaded
  sequentially by this rule.

  It is not valid to call this function more than once for a given version and iso_date as
  this function generates repository rules that may not have unique names. To support multiple
  execution platforms and targets for the same version, specify all required values for
  "exec_triples" and "target_triples".

  Args:
    version: A known rust version or one of "nightly" or "beta"
    iso_date: The exact release date of the selected "nightly" or "beta" toolchain. Required if
        nightly or beta are specified, no effect otherwise.
    exec_triples: The Bazel execution platform or "host" that the toolchain must run on, in the
        form of a Rust-style triple. More than one triple may be provided.
    target_triples: The supported compilation targets for the toolchains in the form of a Rust-
        style triple. More than one triple may be provided, but this list must include all
        values of exec_triples.
    extra_shas: A dict containing mappings from Rust download URLs to known or expected SHAs.
        See known_shas.bzl for the SHAs included in rules_rust, and to see what format is expected.
  """

  _check_triples(exec_triples, target_triples)
  _check_version(version, iso_date)

  for triple in exec_triples:
    load_compiler(triple, version, iso_date, extra_shas)

  for triple in target_triples:
    load_stdlib(triple, version, iso_date, extra_shas)
    if "windows" in triple:
      load_mingw(triple, version, iso_date, extra_shas)

  version_str = _version_str(version, iso_date)
  workspace_name = "rust_toolchains_{}".format(version_str)
  prepare_toolchains(
      name = workspace_name,
      version_str = version_str,
      exec_triples = exec_triples,
      target_triples = target_triples
  )
