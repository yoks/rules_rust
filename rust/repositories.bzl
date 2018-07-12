load(":toolchain_fetching.bzl", "rust_toolchain_repository")
load(":triple_mappings.bzl", "define_platforms")

def rust_repositories():
    """Defines the common toolchains with default features.

    Use rust_toolchain_repository(..) directly if the defaults are not suitable.
    """

    rust_toolchain_repository(
        name = "rust_toolchain__x86_64_apple_darwin",
        version="1.27.0",
        exec_triple = "x86_64-apple-darwin",
        extra_stdlib_triples = [
          #"x86_64-apple-darwin",
          #"x86_64-unknown-linux-gnu",
          #"x86_64-unknown-freebsd",
          #"x86_64-pc-windows-gnu",
          #"x86_64-pc-windows-msvc",
        ]
    )

    rust_toolchain_repository(
        name = "rust_toolchain__x86_64_unknown_linux_gnu",
        version="1.27.0",
        exec_triple = "x86_64-unknown-linux-gnu",
        extra_stdlib_triples = [
          #"x86_64-apple-darwin",
          #"x86_64-unknown-linux-gnu",
          "x86_64-unknown-freebsd",
          "x86_64-pc-windows-gnu",
          #"x86_64-pc-windows-msvc",
        ]
    )

    rust_toolchain_repository(
        name = "rust_toolchain__x86_64_unknown_freebsd",
        version="1.27.0",
        exec_triple = "x86_64-unknown-freebsd",
        extra_stdlib_triples = [
          #"x86_64-apple-darwin",
          #"x86_64-unknown-linux-gnu",
          #"x86_64-unknown-freebsd",
          #"x86_64-pc-windows-gnu",
          #"x86_64-pc-windows-msvc",
        ]
    )

    native.register_toolchains(
        #"@rust_toolchain__x86_64_apple_darwin//:rust_for_x86_64-apple-darwin_on_x86_64-apple-darwin",
        "@rust_toolchain__x86_64_unknown_linux_gnu//:rust_for_x86_64-unknown-linux-gnu_on_x86_64-unknown-linux-gnu",
        "@rust_toolchain__x86_64_unknown_linux_gnu//:rust_for_x86_64-unknown-freebsd_on_x86_64-unknown-linux-gnu",
        #"@rust_toolchain__x86_64_unknown_freebsd//:rust_for_x86_64-unknown-freebsd_on_x86_64-unknown-freebsd",
    )
