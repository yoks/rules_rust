# Not used, but useful as a reference.
#
# Identified from a random 20XX-XX-XX index entry e.g.:
# https://static.rust-lang.org/dist/2018-06-29/index.html
KNOWN_TOOL_IDENTS = [
  # The default dependency resolver and loader for Rust.
  "cargo",

  # LLVM utilities useful for evaluating performance and output size.
  # This may contain the linker (lld) once the Rust toolchain officially switches to LLD
  "llvm-tools",

  # The "Rust Language Server", a Language Server Protocol compatible service for IDE
  # integrations. Generally not compatible with Bazel as it uses Cargo internally.
  "rls",

  # A all-inclusive bundle of tools including the compiler, standard library, formatter, and 
  # other utilities (dependent on platform).
  "rust",

  # An RLS dependency used for processing analysis results from RLS (??)
  "rust-analysis",

  # The Rust documentation
  "rust-docs",

  # The Windows MingW utilities required for compiing for a Windows target.
  # Not available for any triple except Windows-related triples.
  "rust-mingw",

  # The source code for Rust
  "rust-src",

  # The standard library for Rust
  "rust-std",

  # The Rust compiler
  "rustc",

  # The standard Rust formatter. Prefer the nightly version, regardless of toolchain.
  "rustfmt",
]

CONFIGURED_TRIPLES = [
  # Sourced from: https://forge.rust-lang.org/platform-support.html
  # Keep alphabetized (per tier)
  #
  # Tier 1 Plats
  "i686-apple-darwin",
  "i686-pc-windows-gnu",
  "i686-pc-windows-msvc",
  "i686-unknown-linux-gnu",
  "x86_64-apple-darwin",
  "x86_64-pc-windows-gnu",
  "x86_64-pc-windows-msvc",
  "x86_64-unknown-linux-gnu",
  # Tier 2 Plats
  "x86_64-unknown-freebsd",
]

# Consider editing the call in root BUILD instead of editing this.
DEFAULT_EXTENDED_PLATFORM_DETAILS = {
  "cpu_arch_to_platform_constraints": {},
  "vendor_to_platform_constraints": {},
  "system_to_platform_constraints": {},
  "abi_to_platform_constraints": {},
}

CPU_ARCH_TO_BUILTIN_PLAT_SUFFIX = {
  "x86_64": "x86_64",
  "powerpc": "ppc",
  "powerpc64": "ppc",
  "powerpc64le": "ppc",
  "aarch64": "arm",
  "arm": "arm",
  "armv7": "arm",
  "armv7s": "arm",
  "i386": "x86_32",
  "i586": "x86_32",
  "i686": "x86_32",
  "asmjs": None,
  "le32": None,
  "mips": None,
  "mipsel": None,
}

SYSTEM_TO_BUILTIN_SYS_SUFFIX = {
  "freebsd": "freebsd",
  "linux": "linux",
  "darwin": "osx",
  "windows": "windows",
  "ios": None,
  "android": None,
  "androideabi": None,
  "emscripten": None,
  "nacl": None,
  "bitrig": None,
  "dragonfly": None,
  "netbsd": None,
  "openbsd": None,
  "solaris": None,
}

SYSTEM_TO_BINARY_EXT = {
  "freebsd": "",
  "linux": "",
  # TODO(acmcarther): To be verified
  "darwin": "",
  "windows": ".exe",
}

SYSTEM_TO_STATICLIB_EXT = {
  "freebsd": ".a",
  "linux": ".a",
  "darwin": ".a",
  # TODO(acmcarther): To be verified
  "windows": ".lib",
}

SYSTEM_TO_DYLIB_EXT = {
  "freebsd": ".so",
  "linux": ".so",
  "darwin": ".dylib",
  # TODO(acmcarther): To be verified
  "windows": ".dll",
}

def _cpu_arch_to_constraints(cpu_arch):
  plat_suffix = CPU_ARCH_TO_BUILTIN_PLAT_SUFFIX[cpu_arch]

  if not plat_suffix:
      fail("CPU architecture \"{}\" is not supported by rules_rust".format(cpu_arch))

  return ["@bazel_tools//platforms:{}".format(plat_suffix)]

def _vendor_to_constraints(vendor):
  # TODO(acmcarther): Review:
  #
  # My current understanding is that vendors can't have a material impact on
  # constraint sets.
  return []

def _system_to_constraints(system):
  sys_suffix = SYSTEM_TO_BUILTIN_SYS_SUFFIX[system]

  if not sys_suffix:
      fail("System \"{}\" is not supported by rules_rust".format(sys_suffix))

  return ["@bazel_tools//platforms:{}".format(sys_suffix)]

def _abi_to_constraints(abi):
  # TODO(acmcarther): Review:
  #
  # The ABI (gnu, musl, etc) can have an impact, but it's not clear how to
  # apply it in a Bazel context.
  return []

def triple_to_system(triple):
  component_parts = triple.split("-")
  if len(component_parts) < 3:
      fail("Expected target triple to contain at least three sections separated by '-'")

  return component_parts[2]

def system_to_dylib_ext(system):
  return SYSTEM_TO_DYLIB_EXT[system]

def system_to_staticlib_ext(system):
  return SYSTEM_TO_STATICLIB_EXT[system]

def system_to_binary_ext(system):
  return SYSTEM_TO_BINARY_EXT[system]

def triple_to_constraint_set(triple):
  component_parts = triple.split("-")
  if len(component_parts) < 3:
      fail("Expected target triple to contain at least three sections separated by '-'")

  cpu_arch = component_parts[0]
  vendor = component_parts[1]
  system = component_parts[2]
  abi = None

  if len(component_parts) == 4:
      abi = component_parts[3]

  constraint_set = []
  constraint_set += _cpu_arch_to_constraints(cpu_arch)
  constraint_set += _vendor_to_constraints(vendor)
  constraint_set += _system_to_constraints(system)
  constraint_set += _abi_to_constraints(abi)

  return constraint_set

def define_platforms(target_triples):
  for target_triple in target_triples:
      native.platform(
          name = "target-" + target_triple,
          constraint_values = triple_to_constraint_set(target_triple),
      )
