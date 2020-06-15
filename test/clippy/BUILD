load(
    "@build_bazel_integration_testing//tools:bazel_py_integration_test.bzl",
    "bazel_py_integration_test",
)

py_library(
    name = "common",
    srcs = ["testutil.py"],
    data = glob(["workspace/**"]),
)

bazel_py_integration_test(
    name = "clippy_test",
    size = "medium",
    srcs = ["clippy_test.py"],
    data = [],
    tags = [ "no-sandbox" ],
    deps = [
        ":common",
    ],
)
