"""
load(
    "//:this.bzl",
    "rust_toolchain_repository",
    "rust_tool_bundle_repository"
)

rust_toolchain_repository(
    name = "rust_1p26p2",
    extra_stdlib_triples = [
        "x86_64-pc-windows-gnu",
        "x86_64-unknown-freebsd",
    ],
    exec_triple = "x86_64-unknown-linux-gnu",
    version = "1.26.2",
)

rust_tool_bundle_repository(
    name = "rust_tools__x86_64_unknown_linux_gnu",
    cargo_iso_date = "2018-07-11",
    cargo_version = "nightly",
    clippy_iso_date = "2018-07-11",
    clippy_version = "nightly",
    exec_triple = "x86_64-unknown-linux-gnu",
    llvm_tools_iso_date = "2018-07-11",
    llvm_tools_version = "nightly",
    rls_iso_date = "2018-07-11",
    rust_docs_version = "nightly",
    rust_docs_iso_date = "2018-07-11",
    rust_analysis_version = "nightly",
    rust_analysis_iso_date = "2018-07-11",
    rls_version = "nightly",
    rustfmt_iso_date = "2018-07-11",
    rustfmt_version = "nightly",
)
"""

load(":known_shas.bzl", "FILE_KEY_TO_SHA")
load(":triple_mappings.bzl", "triple_to_system",
                             "triple_to_constraint_set",
                             "system_to_dylib_ext",
                             "system_to_staticlib_ext")


def _BUILD_for_compiler(target_triple):
    """Yields the BUILD content for a Rust compiler"""
    return """package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_rust//rust:toolchain.bzl", "rust_toolchain")


exports_files([
    "bin/rust-gdb",
    "bin/rust-lldb",
])


filegroup(
    name = "rustc",
    srcs = glob(["bin/rustc*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustdoc",
    srcs = glob(["bin/rustdoc*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustc_lib",
    srcs = glob([
        "lib/*.so",
        "lib/*.dylib",
        "lib/*.dll",
        "lib/*.rlib",
        "lib/*.a",
    ]),
    visibility = ["//visibility:public"],
)
""".format(target_triple = target_triple)

def _BUILD_for_stdlib(target_triple):
    """Yields the BUILD content for a Rust standard library including mingw"""

    base_stdlib_content = """filegroup(
    name = "rust-std_{target_triple}",
    srcs = glob([
        "lib/rustlib/{target_triple}/*.dylib",
        "lib/rustlib/{target_triple}/*.dll",
        "lib/rustlib/{target_triple}/*.so",
        "lib/rustlib/{target_triple}/*.rlib",
        "lib/rustlib/{target_triple}/*.a",
    ]),
    visibility = ["//visibility:public"],
)
""".format(target_triple = target_triple)

    if not "windows" in target_triple:
        return base_stdlib_content

    mingw_content = """exports_files([
    "lib/rustlib/{target_triple}/bin/libwinpthread-1.dll",
    "lib/rustlib/{target_triple}/bin/dlltool.exe",
    "lib/rustlib/{target_triple}/bin/gcc.exe",
    "lib/rustlib/{target_triple}/bin/ld.exe",
])
""".format(target_triple = target_triple)

    return base_stdlib_content + "\n" + mingw_content

def _BUILD_for_toolchain(exec_triple, target_triples, version, iso_date):
  version_str = _version_str(version, iso_date)

  triple_to_constraint_values = {}
  triple_to_constraint_values[exec_triple] = triple_to_constraint_set(exec_triple)
  for target_triple in target_triples:
    if not triple_to_constraint_values.get(target_triple):
      triple_to_constraint_values[target_triple] = triple_to_constraint_set(target_triple)

  all_toolchain_decls = []
  for target_triple in target_triples:
    toolchain_name = "rust_for_{}_on_{}".format(target_triple, exec_triple)
    target_system = triple_to_system(target_triple)
    target_staticlib_ext = system_to_staticlib_ext(target_system)
    target_dylib_ext = system_to_dylib_ext(target_system)
    toolchain_decl = """native.toolchain(
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
    rust_doc = ":rustdoc",
    rustc = ":rustc",
    rustc_lib = [":rustc_lib"],
    rust_lib = [":rust-std_{target_triple}"],
    staticlib_ext = "{target_staticlib_ext}",
    dylib_ext = "{target_dylib_ext}",
    os = "{target_system}",
    exec_triple = "{exec_triple}",
    target_triple = "{target_triple}",
    visibility = ["//visibility:public"],
)
""".format(toolchain_name=toolchain_name,
            exec_triple=exec_triple,
            target_triple=target_triple,
            exec_compatible_with = triple_to_constraint_values[exec_triple],
            target_compatible_with = triple_to_constraint_values[target_triple],
            target_staticlib_ext=target_staticlib_ext,
            target_dylib_ext=target_dylib_ext,
            target_system=target_system)
    all_toolchain_decls.append(toolchain_decl)

  return "\n".join(all_toolchain_decls)

def _BUILD_for_cargo(target_triple):
    # TODO(acmcarther): Handle target-specific file extensions
    return """exports_files([
    "bin/cargo",
])"""

def _BUILD_for_rustfmt(target_triple):
    # TODO(acmcarther): Handle target-specific file extensions
    return """exports_files([
    "bin/rustfmt",
    "bin/cargo-fmt",
])"""

def _BUILD_for_rust_docs(target_triple):
    # TODO(acmcarther): Consider how to expose Rust documentation.
    return ""

def _BUILD_for_rust_analysis(target_triple):
    return """filegroup(
    name = "rust_analysis",
    srcs = glob(["lib/rustlib/{target_triple}/analysis/*.json"]),
    visibility = ["//visibility:public"],
)""".format(target_triple = target_triple)

def _BUILD_for_rls(target_triple):
    return """exports_files([
    "bin/rls",
])"""

def _BUILD_for_llvm_tools(target_triple):
    # TODO(acmcarther): Handle target-specific file extensions
    return """exports_files([
    "lib/rustlib/{target_triple}/bin/llvm-nm",
    "lib/rustlib/{target_triple}/bin/llvm-objcopy",
    "lib/rustlib/{target_triple}/bin/llvm-objdump",
    "lib/rustlib/{target_triple}/bin/llvm-profdata",
    "lib/rustlib/{target_triple}/bin/llvm-size",
])""".format(target_triple = target_triple)

def _BUILD_for_clippy(target_triple):
    # TODO(acmcarther): Handle target-specific file extensions
    return """exports_files([
    "bin/clippy-driver",
])"""

def _check_version_valid(version, iso_date, param_prefix = ""):
    """Verifies that the provided rust version and iso_date make sense."""

    if not version and iso_date:
        fail("{param_prefix}iso_date must be paired with a {param_prefix}version".format(param_prefix = param_prefix))

    if version in ("beta", "nightly") and not iso_date:
        fail("{param_prefix}iso_date must be specified if version is 'beta' or 'nightly'".format(param_prefix = param_prefix))

    if version not in ("beta", "nightly") and iso_date:
        print("{param_prefix}iso_date is ineffective if an exact version is specified".format(param_prefix = param_prefix))

def _version_str(version, iso_date):
    """Emits a Rust tool version string for use within Bazel"""

    if version in ("beta", "nightly"):
        return "{}-{}".format(version, iso_date)
    else:
        return _sanitize_for_name(version)

def _produce_tool_path(tool_name, target_triple, version):
    """Produces a qualified Rust tool name"""

    return "{}-{}-{}".format(tool_name, version, target_triple)

def _produce_tool_suburl(tool_name, target_triple, version, iso_date):
    """Produces a fully qualified Rust tool name for URL"""

    if iso_date:
        return "{}/{}-{}-{}".format(iso_date, tool_name, version, target_triple)
    else:
        return "{}-{}-{}".format(tool_name, version, target_triple)

def _sanitize_for_name(some_string):
    """Cleans a tool name for use as a bazel workspace name"""

    return some_string.replace("-", "_").replace('.', 'p')

def _load_rust_compiler(ctx):
    """Downloads the Rust compiler for this rust_toolchain_repository"""

    tool_suburl = _produce_tool_suburl(
        "rustc",
        ctx.attr.exec_triple,
        ctx.attr.version,
        ctx.attr.iso_date,
    )
    url = "https://static.rust-lang.org/dist/{}.tar.gz".format(tool_suburl)

    tool_path = _produce_tool_path(
        "rustc",
        ctx.attr.exec_triple,
        ctx.attr.version,
    )
    ctx.download_and_extract(
        url,
        output = "",
        sha256 = FILE_KEY_TO_SHA.get(tool_suburl) or '',
        type = "tar.gz",
        stripPrefix = "{}/rustc".format(tool_path),
    )

def _load_rust_stdlib(ctx, target_triple):
    """Downloads the Rust Stdlib for this rust_toolchain_repository and triple"""

    tool_suburl = _produce_tool_suburl(
        "rust-std",
        target_triple,
        ctx.attr.version,
        ctx.attr.iso_date,
    )
    url = "https://static.rust-lang.org/dist/{}.tar.gz".format(tool_suburl)

    tool_path = _produce_tool_path(
        "rust-std",
        target_triple,
        ctx.attr.version,
    )
    subcomponent = "{}-{}".format("rust-std", target_triple)
    ctx.download_and_extract(
        url,
        output = "",
        sha256 = FILE_KEY_TO_SHA.get(tool_suburl) or '',
        type = "tar.gz",
        stripPrefix = "{}/{}".format(tool_path, subcomponent),
    )

    if not "windows" in target_triple:
        return

    tool_suburl = _produce_tool_suburl(
        "rust-mingw",
        target_triple,
        ctx.attr.version,
        ctx.attr.iso_date,
    )
    url = "https://static.rust-lang.org/dist/{}.tar.gz".format(tool_suburl)

    tool_path = _produce_tool_path(
        "rust-mingw",
        target_triple,
        ctx.attr.version,
    )
    ctx.download_and_extract(
        url,
        output = "",
        sha256 = FILE_KEY_TO_SHA.get(tool_suburl) or '',
        type = "tar.gz",
        stripPrefix = "{}/rust-mingw".format(tool_path),
    )

def _rust_toolchain_repository_impl(ctx):
    """The implementation for a rust toolchain repository_rule"""

    _check_version_valid(ctx.attr.version, ctx.attr.iso_date)

    _load_rust_compiler(ctx)
    _load_rust_stdlib(ctx, ctx.attr.exec_triple)

    BUILD_components = [
        _BUILD_for_compiler(ctx.attr.exec_triple),
        _BUILD_for_stdlib(ctx.attr.exec_triple),
    ]

    for extra_stdlib_triple in ctx.attr.extra_stdlib_triples:
        _load_rust_stdlib(ctx, extra_stdlib_triple)
        BUILD_components.append(_BUILD_for_stdlib(extra_stdlib_triple))

    all_target_triples = [ctx.attr.exec_triple]
    for triple in ctx.attr.extra_stdlib_triples:
      all_target_triples.append(triple)

    BUILD_components.append(_BUILD_for_toolchain(ctx.attr.exec_triple, all_target_triples,
                                                 ctx.attr.version, ctx.attr.iso_date))

    ctx.file("WORKSPACE", "")
    ctx.file("BUILD", "\n".join(BUILD_components))

def _load_arbitrary_tool(ctx, tool_name, param_prefix, tool_subdirectory, version, iso_date, target_triple):
    """Loads a Rust tool, downloads, and extracts into the common workspace.

    Args:
      ctx: A repository_ctx.
      tool_name: The name of the given tool per the archive naming.
      param_prefix: The name of the versioning param if the repository rule supports multiple tools.
      tool_subdirectory: The subdirectory of the tool files (wo level below the root directory of
                         the archive. The root directory of the archive is expected to match
                         $TOOL_NAME-$VERSION-$TARGET_TRIPLE.
      version: The version of the tool among "nightly", "beta', or an exact version.
      iso_date: The date of the tool (or None, if the version is a specific version).
      target_triple: The rust-style target triple of the tool
    """

    _check_version_valid(version, iso_date, param_prefix)

    tool_suburl = _produce_tool_suburl(tool_name, target_triple, version, iso_date)
    url = "https://static.rust-lang.org/dist/{}.tar.gz".format(tool_suburl)

    tool_path = _produce_tool_path(tool_name, target_triple, version)
    ctx.download_and_extract(
        url,
        output = "",
        sha256 = FILE_KEY_TO_SHA.get(tool_suburl) or '',
        type = "tar.gz",
        stripPrefix = "{}/{}".format(tool_path, tool_subdirectory),
    )

def _maybe_load_cargo_yielding_BUILD(ctx):
    version = ctx.attr.cargo_version
    iso_date = ctx.attr.cargo_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "cargo_",
        target_triple = target_triple,
        tool_name = "cargo",
        tool_subdirectory = "cargo",
        version = version,
    )

    return _BUILD_for_cargo(target_triple)

def _maybe_load_rustfmt_yielding_BUILD(ctx):
    version = ctx.attr.rustfmt_version
    iso_date = ctx.attr.rustfmt_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "rusfmt_",
        target_triple = target_triple,
        tool_name = "rustfmt",
        tool_subdirectory = "rustfmt-preview",
        version = version,
    )

    return _BUILD_for_rustfmt(target_triple)

def _maybe_load_rust_docs_yielding_BUILD(ctx):
    version = ctx.attr.rust_docs_version
    iso_date = ctx.attr.rust_docs_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "rust_docs_",
        target_triple = target_triple,
        tool_name = "rust-docs",
        tool_subdirectory = "rust-docs",
        version = version,
    )

    return _BUILD_for_rust_docs(target_triple)

def _maybe_load_rust_analysis_yielding_BUILD(ctx):
    version = ctx.attr.rust_analysis_version
    iso_date = ctx.attr.rust_analysis_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "rust_analysis_",
        target_triple = target_triple,
        tool_name = "rust-analysis",
        tool_subdirectory = "rust-analysis-{}".format(target_triple),
        version = version,
    )

    return _BUILD_for_rust_analysis(target_triple)

def _maybe_load_rls_yielding_BUILD(ctx):
    version = ctx.attr.rls_version
    iso_date = ctx.attr.rls_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "rls_",
        target_triple = target_triple,
        tool_name = "rls",
        tool_subdirectory = "rls-preview",
        version = version,
    )

    return _BUILD_for_rls(target_triple)

def _maybe_load_llvm_tools_yielding_BUILD(ctx):
    version = ctx.attr.llvm_tools_version
    iso_date = ctx.attr.llvm_tools_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "llvm_tools_",
        target_triple = target_triple,
        tool_name = "llvm-tools",
        tool_subdirectory = "llvm-tools-preview",
        version = version,
    )

    return _BUILD_for_llvm_tools(target_triple)

def _maybe_load_clippy_yielding_BUILD(ctx):
    version = ctx.attr.clippy_version
    iso_date = ctx.attr.clippy_iso_date
    if not version and not iso_date:
        return
    target_triple = ctx.attr.exec_triple

    _load_arbitrary_tool(
        ctx,
        iso_date = iso_date,
        param_prefix = "clippy_",
        target_triple = target_triple,
        tool_name = "clippy",
        tool_subdirectory = "clippy-preview",
        version = version,
    )

    return _BUILD_for_clippy(target_triple)

def _rust_tool_bundle_repository_impl(ctx):
    """The implementation for a rust tool bundle repository_rule"""

    BUILD_components = ["package(default_visibility = [\"//visibility:public\"])"]

    BUILD_components.append(_maybe_load_cargo_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_rustfmt_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_rust_docs_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_rust_analysis_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_rls_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_llvm_tools_yielding_BUILD(ctx))
    BUILD_components.append(_maybe_load_clippy_yielding_BUILD(ctx))

    BUILD_components_less_none = []
    for component in BUILD_components:
        if component:
            BUILD_components_less_none.append(component)

    ctx.file("WORKSPACE", "")
    ctx.file("BUILD", "\n".join(BUILD_components_less_none))

rust_toolchain_repository = repository_rule(
    attrs = {
        "version": attr.string(mandatory = True),
        "iso_date": attr.string(),
        "exec_triple": attr.string(mandatory = True),
        "extra_stdlib_triples": attr.string_list(),
    },
    implementation = _rust_toolchain_repository_impl,
)

rust_tool_bundle_repository = repository_rule(
    # Range annotations accurate as of 2018-07-11
    attrs = {
        "exec_triple": attr.string(mandatory = True),
        # Known Range: 0.16.0 -> 0.28.0
        "cargo_version": attr.string(),
        "cargo_iso_date": attr.string(),
        # Known Range: 0.2.16 -> 0.6.1
        "rustfmt_version": attr.string(),
        "rustfmt_iso_date": attr.string(),
        # Known Range: Matches rustc/stdlib versions
        "rust_docs_version": attr.string(),
        "rust_docs_iso_date": attr.string(),
        # Known Range: 1.18.0 -> 1.27.1
        "rust_analysis_version": attr.string(),
        "rust_analysis_iso_date": attr.string(),
        # Known Range: 0.1.0 -> 0.127.0
        "rls_version": attr.string(),
        "rls_iso_date": attr.string(),
        # Known Range: Nightly only
        "llvm_tools_version": attr.string(),
        "llvm_tools_iso_date": attr.string(),
        # Known Range: Nightly only
        "clippy_version": attr.string(),
        "clippy_iso_date": attr.string(),
    },
    implementation = _rust_tool_bundle_repository_impl,
)
