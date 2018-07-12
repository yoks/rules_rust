package(default_visibility = ["//visibility:public"])

load(":triple_mappings.bzl", "define_platforms", "CONFIGURED_TRIPLES")

exports_files([
    "rust.bzl",
    "toolchain.bzl",
    "repositories.bzl",
])

define_platforms(CONFIGURED_TRIPLES)
