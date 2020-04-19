"""
cargo-raze crate workspace functions

DO NOT EDIT! Replaced on runs of cargo-raze
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def _new_http_archive(name, **kwargs):
    if not native.existing_rule(name):
        http_archive(name = name, **kwargs)

def _new_git_repository(name, **kwargs):
    if not native.existing_rule(name):
        new_git_repository(name = name, **kwargs)

def raze_fetch_remote_crates():
    _new_http_archive(
        name = "raze__autocfg__1_0_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/autocfg/autocfg-1.0.0.crate",
        type = "tar.gz",
        strip_prefix = "autocfg-1.0.0",
        build_file = Label("//proto/raze/remote:autocfg-1.0.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__base64__0_9_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/base64/base64-0.9.3.crate",
        type = "tar.gz",
        sha256 = "489d6c0ed21b11d038c31b6ceccca973e65d73ba3bd8ecb9a2babf5546164643",
        strip_prefix = "base64-0.9.3",
        build_file = Label("//proto/raze/remote:base64-0.9.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__bitflags__1_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bitflags/bitflags-1.2.1.crate",
        type = "tar.gz",
        strip_prefix = "bitflags-1.2.1",
        build_file = Label("//proto/raze/remote:bitflags-1.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__byteorder__1_3_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/byteorder/byteorder-1.3.4.crate",
        type = "tar.gz",
        sha256 = "08c48aae112d48ed9f069b33538ea9e3e90aa263cfa3d1c24309612b1f7472de",
        strip_prefix = "byteorder-1.3.4",
        build_file = Label("//proto/raze/remote:byteorder-1.3.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__bytes__0_4_12",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bytes/bytes-0.4.12.crate",
        type = "tar.gz",
        sha256 = "206fdffcfa2df7cbe15601ef46c813fce0965eb3286db6b56c583b814b51c81c",
        strip_prefix = "bytes-0.4.12",
        build_file = Label("//proto/raze/remote:bytes-0.4.12.BUILD"),
    )

    _new_http_archive(
        name = "raze__bytes__0_5_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bytes/bytes-0.5.4.crate",
        type = "tar.gz",
        sha256 = "130aac562c0dd69c56b3b1cc8ffd2e17be31d0b6c25b61c96b76231aa23e39e1",
        strip_prefix = "bytes-0.5.4",
        build_file = Label("//proto/raze/remote:bytes-0.5.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__cfg_if__0_1_10",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cfg-if/cfg-if-0.1.10.crate",
        type = "tar.gz",
        sha256 = "4785bdd1c96b2a846b2bd7cc02e86b6b3dbf14e7e53446c4f54c92a361040822",
        strip_prefix = "cfg-if-0.1.10",
        build_file = Label("//proto/raze/remote:cfg-if-0.1.10.BUILD"),
    )

    _new_http_archive(
        name = "raze__cloudabi__0_0_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cloudabi/cloudabi-0.0.3.crate",
        type = "tar.gz",
        strip_prefix = "cloudabi-0.0.3",
        build_file = Label("//proto/raze/remote:cloudabi-0.0.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__crossbeam_deque__0_7_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-deque/crossbeam-deque-0.7.3.crate",
        type = "tar.gz",
        sha256 = "9f02af974daeee82218205558e51ec8768b48cf524bd01d550abe5573a608285",
        strip_prefix = "crossbeam-deque-0.7.3",
        build_file = Label("//proto/raze/remote:crossbeam-deque-0.7.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__crossbeam_epoch__0_8_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-epoch/crossbeam-epoch-0.8.2.crate",
        type = "tar.gz",
        sha256 = "058ed274caafc1f60c4997b5fc07bf7dc7cca454af7c6e81edffe5f33f70dace",
        strip_prefix = "crossbeam-epoch-0.8.2",
        build_file = Label("//proto/raze/remote:crossbeam-epoch-0.8.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__crossbeam_queue__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-queue/crossbeam-queue-0.2.1.crate",
        type = "tar.gz",
        sha256 = "c695eeca1e7173472a32221542ae469b3e9aac3a4fc81f7696bcad82029493db",
        strip_prefix = "crossbeam-queue-0.2.1",
        build_file = Label("//proto/raze/remote:crossbeam-queue-0.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__crossbeam_utils__0_7_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-utils/crossbeam-utils-0.7.2.crate",
        type = "tar.gz",
        sha256 = "c3c7c73a2d1e9fc0886a08b93e98eb643461230d5f1925e4036204d5f2e261a8",
        strip_prefix = "crossbeam-utils-0.7.2",
        build_file = Label("//proto/raze/remote:crossbeam-utils-0.7.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__fnv__1_0_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/fnv/fnv-1.0.6.crate",
        type = "tar.gz",
        sha256 = "2fad85553e09a6f881f739c29f0b00b0f01357c743266d478b68951ce23285f3",
        strip_prefix = "fnv-1.0.6",
        build_file = Label("//proto/raze/remote:fnv-1.0.6.BUILD"),
    )

    _new_http_archive(
        name = "raze__fuchsia_zircon__0_3_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/fuchsia-zircon/fuchsia-zircon-0.3.3.crate",
        type = "tar.gz",
        strip_prefix = "fuchsia-zircon-0.3.3",
        build_file = Label("//proto/raze/remote:fuchsia-zircon-0.3.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__fuchsia_zircon_sys__0_3_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/fuchsia-zircon-sys/fuchsia-zircon-sys-0.3.3.crate",
        type = "tar.gz",
        strip_prefix = "fuchsia-zircon-sys-0.3.3",
        build_file = Label("//proto/raze/remote:fuchsia-zircon-sys-0.3.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__futures__0_1_29",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/futures/futures-0.1.29.crate",
        type = "tar.gz",
        sha256 = "1b980f2816d6ee8673b6517b52cb0e808a180efc92e5c19d02cdda79066703ef",
        strip_prefix = "futures-0.1.29",
        build_file = Label("//proto/raze/remote:futures-0.1.29.BUILD"),
    )

    _new_http_archive(
        name = "raze__futures_cpupool__0_1_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/futures-cpupool/futures-cpupool-0.1.8.crate",
        type = "tar.gz",
        sha256 = "ab90cde24b3319636588d0c35fe03b1333857621051837ed769faefb4c2162e4",
        strip_prefix = "futures-cpupool-0.1.8",
        build_file = Label("//proto/raze/remote:futures-cpupool-0.1.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__grpc__0_6_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/grpc/grpc-0.6.2.crate",
        type = "tar.gz",
        sha256 = "2aaf1d741fe6f3413f1f9f71b99f5e4e26776d563475a8a53ce53a73a8534c1d",
        strip_prefix = "grpc-0.6.2",
        build_file = Label("//proto/raze/remote:grpc-0.6.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__grpc_compiler__0_6_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/grpc-compiler/grpc-compiler-0.6.2.crate",
        type = "tar.gz",
        sha256 = "907274ce8ee7b40a0d0b0db09022ea22846a47cfb1fc8ad2c983c70001b4ffb1",
        strip_prefix = "grpc-compiler-0.6.2",
        build_file = Label("//proto/raze/remote:grpc-compiler-0.6.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__hermit_abi__0_1_11",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/hermit-abi/hermit-abi-0.1.11.crate",
        type = "tar.gz",
        strip_prefix = "hermit-abi-0.1.11",
        build_file = Label("//proto/raze/remote:hermit-abi-0.1.11.BUILD"),
    )

    _new_http_archive(
        name = "raze__httpbis__0_7_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/httpbis/httpbis-0.7.0.crate",
        type = "tar.gz",
        sha256 = "7689cfa896b2a71da4f16206af167542b75d242b6906313e53857972a92d5614",
        strip_prefix = "httpbis-0.7.0",
        build_file = Label("//proto/raze/remote:httpbis-0.7.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__iovec__0_1_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/iovec/iovec-0.1.4.crate",
        type = "tar.gz",
        sha256 = "b2b3ea6ff95e175473f8ffe6a7eb7c00d054240321b84c57051175fe3c1e075e",
        strip_prefix = "iovec-0.1.4",
        build_file = Label("//proto/raze/remote:iovec-0.1.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__kernel32_sys__0_2_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/kernel32-sys/kernel32-sys-0.2.2.crate",
        type = "tar.gz",
        strip_prefix = "kernel32-sys-0.2.2",
        build_file = Label("//proto/raze/remote:kernel32-sys-0.2.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__lazy_static__1_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lazy_static/lazy_static-1.4.0.crate",
        type = "tar.gz",
        sha256 = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646",
        strip_prefix = "lazy_static-1.4.0",
        build_file = Label("//proto/raze/remote:lazy_static-1.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__libc__0_2_69",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/libc/libc-0.2.69.crate",
        type = "tar.gz",
        sha256 = "99e85c08494b21a9054e7fe1374a732aeadaff3980b6990b94bfd3a70f690005",
        strip_prefix = "libc-0.2.69",
        build_file = Label("//proto/raze/remote:libc-0.2.69.BUILD"),
    )

    _new_http_archive(
        name = "raze__lock_api__0_3_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lock_api/lock_api-0.3.4.crate",
        type = "tar.gz",
        sha256 = "c4da24a77a3d8a6d4862d95f72e6fdb9c09a643ecdb402d754004a557f2bec75",
        strip_prefix = "lock_api-0.3.4",
        build_file = Label("//proto/raze/remote:lock_api-0.3.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__log__0_4_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/log/log-0.4.8.crate",
        type = "tar.gz",
        sha256 = "14b6052be84e6b71ab17edffc2eeabf5c2c3ae1fdb464aae35ac50c67a44e1f7",
        strip_prefix = "log-0.4.8",
        build_file = Label("//proto/raze/remote:log-0.4.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__maybe_uninit__2_0_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/maybe-uninit/maybe-uninit-2.0.0.crate",
        type = "tar.gz",
        sha256 = "60302e4db3a61da70c0cb7991976248362f30319e88850c487b9b95bbf059e00",
        strip_prefix = "maybe-uninit-2.0.0",
        build_file = Label("//proto/raze/remote:maybe-uninit-2.0.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__memoffset__0_5_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/memoffset/memoffset-0.5.4.crate",
        type = "tar.gz",
        sha256 = "b4fc2c02a7e374099d4ee95a193111f72d2110197fe200272371758f6c3643d8",
        strip_prefix = "memoffset-0.5.4",
        build_file = Label("//proto/raze/remote:memoffset-0.5.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__mio__0_6_21",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/mio/mio-0.6.21.crate",
        type = "tar.gz",
        sha256 = "302dec22bcf6bae6dfb69c647187f4b4d0fb6f535521f7bc022430ce8e12008f",
        strip_prefix = "mio-0.6.21",
        build_file = Label("//proto/raze/remote:mio-0.6.21.BUILD"),
    )

    _new_http_archive(
        name = "raze__mio_uds__0_6_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/mio-uds/mio-uds-0.6.7.crate",
        type = "tar.gz",
        sha256 = "966257a94e196b11bb43aca423754d87429960a768de9414f3691d6957abf125",
        strip_prefix = "mio-uds-0.6.7",
        build_file = Label("//proto/raze/remote:mio-uds-0.6.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__miow__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/miow/miow-0.2.1.crate",
        type = "tar.gz",
        strip_prefix = "miow-0.2.1",
        build_file = Label("//proto/raze/remote:miow-0.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__net2__0_2_33",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/net2/net2-0.2.33.crate",
        type = "tar.gz",
        sha256 = "42550d9fb7b6684a6d404d9fa7250c2eb2646df731d1c06afc06dcee9e1bcf88",
        strip_prefix = "net2-0.2.33",
        build_file = Label("//proto/raze/remote:net2-0.2.33.BUILD"),
    )

    _new_http_archive(
        name = "raze__num_cpus__1_13_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/num_cpus/num_cpus-1.13.0.crate",
        type = "tar.gz",
        sha256 = "05499f3756671c15885fee9034446956fff3f243d6077b91e5767df161f766b3",
        strip_prefix = "num_cpus-1.13.0",
        build_file = Label("//proto/raze/remote:num_cpus-1.13.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__parking_lot__0_9_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/parking_lot/parking_lot-0.9.0.crate",
        type = "tar.gz",
        sha256 = "f842b1982eb6c2fe34036a4fbfb06dd185a3f5c8edfaacdf7d1ea10b07de6252",
        strip_prefix = "parking_lot-0.9.0",
        build_file = Label("//proto/raze/remote:parking_lot-0.9.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__parking_lot_core__0_6_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/parking_lot_core/parking_lot_core-0.6.2.crate",
        type = "tar.gz",
        sha256 = "b876b1b9e7ac6e1a74a6da34d25c42e17e8862aa409cbbbdcfc8d86c6f3bc62b",
        strip_prefix = "parking_lot_core-0.6.2",
        build_file = Label("//proto/raze/remote:parking_lot_core-0.6.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__pin_project_lite__0_1_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/pin-project-lite/pin-project-lite-0.1.4.crate",
        type = "tar.gz",
        strip_prefix = "pin-project-lite-0.1.4",
        sha256 = "237844750cfbb86f67afe27eee600dfbbcb6188d734139b534cbfbf4f96792ae",
        build_file = Label("//proto/raze/remote:pin-project-lite-0.1.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__protobuf__2_8_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/protobuf/protobuf-2.8.2.crate",
        type = "tar.gz",
        sha256 = "70731852eec72c56d11226c8a5f96ad5058a3dab73647ca5f7ee351e464f2571",
        strip_prefix = "protobuf-2.8.2",
        build_file = Label("//proto/raze/remote:protobuf-2.8.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__protobuf_codegen__2_8_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/protobuf-codegen/protobuf-codegen-2.8.2.crate",
        type = "tar.gz",
        sha256 = "3d74b9cbbf2ac9a7169c85a3714ec16c51ee9ec7cfd511549527e9a7df720795",
        strip_prefix = "protobuf-codegen-2.8.2",
        build_file = Label("//proto/raze/remote:protobuf-codegen-2.8.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__redox_syscall__0_1_56",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/redox_syscall/redox_syscall-0.1.56.crate",
        type = "tar.gz",
        strip_prefix = "redox_syscall-0.1.56",
        build_file = Label("//proto/raze/remote:redox_syscall-0.1.56.BUILD"),
    )

    _new_http_archive(
        name = "raze__rustc_version__0_2_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rustc_version/rustc_version-0.2.3.crate",
        type = "tar.gz",
        strip_prefix = "rustc_version-0.2.3",
        build_file = Label("//proto/raze/remote:rustc_version-0.2.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__safemem__0_3_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/safemem/safemem-0.3.3.crate",
        type = "tar.gz",
        sha256 = "ef703b7cb59335eae2eb93ceb664c0eb7ea6bf567079d843e09420219668e072",
        strip_prefix = "safemem-0.3.3",
        build_file = Label("//proto/raze/remote:safemem-0.3.3.BUILD"),
    )

    _new_http_archive(
        name = "raze__scoped_tls__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/scoped-tls/scoped-tls-0.1.2.crate",
        type = "tar.gz",
        sha256 = "332ffa32bf586782a3efaeb58f127980944bbc8c4d6913a86107ac2a5ab24b28",
        strip_prefix = "scoped-tls-0.1.2",
        build_file = Label("//proto/raze/remote:scoped-tls-0.1.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__scopeguard__1_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/scopeguard/scopeguard-1.1.0.crate",
        type = "tar.gz",
        sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd",
        strip_prefix = "scopeguard-1.1.0",
        build_file = Label("//proto/raze/remote:scopeguard-1.1.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__semver__0_9_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/semver/semver-0.9.0.crate",
        type = "tar.gz",
        strip_prefix = "semver-0.9.0",
        build_file = Label("//proto/raze/remote:semver-0.9.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__semver_parser__0_7_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/semver-parser/semver-parser-0.7.0.crate",
        type = "tar.gz",
        strip_prefix = "semver-parser-0.7.0",
        build_file = Label("//proto/raze/remote:semver-parser-0.7.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__slab__0_3_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/slab/slab-0.3.0.crate",
        type = "tar.gz",
        sha256 = "17b4fcaed89ab08ef143da37bc52adbcc04d4a69014f4c1208d6b51f0c47bc23",
        strip_prefix = "slab-0.3.0",
        build_file = Label("//proto/raze/remote:slab-0.3.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__slab__0_4_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/slab/slab-0.4.2.crate",
        type = "tar.gz",
        sha256 = "c111b5bd5695e56cffe5129854aa230b39c93a305372fdbb2668ca2394eea9f8",
        strip_prefix = "slab-0.4.2",
        build_file = Label("//proto/raze/remote:slab-0.4.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__smallvec__0_6_13",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/smallvec/smallvec-0.6.13.crate",
        type = "tar.gz",
        sha256 = "f7b0758c52e15a8b5e3691eae6cc559f08eee9406e548a4477ba4e67770a82b6",
        strip_prefix = "smallvec-0.6.13",
        build_file = Label("//proto/raze/remote:smallvec-0.6.13.BUILD"),
    )

    _new_http_archive(
        name = "raze__tls_api__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tls-api/tls-api-0.2.1.crate",
        type = "tar.gz",
        sha256 = "3e15c6068100102facee1f30ab43e4a9feb6f5bdbe1888e27e2265f3827ea4d5",
        strip_prefix = "tls-api-0.2.1",
        build_file = Label("//proto/raze/remote:tls-api-0.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__tls_api_stub__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tls-api-stub/tls-api-stub-0.2.1.crate",
        type = "tar.gz",
        sha256 = "4a12d2d36ac4b0a2f7d6a0ee39a2beef5304f01e4955f4b34097c2c547e06c21",
        strip_prefix = "tls-api-stub-0.2.1",
        build_file = Label("//proto/raze/remote:tls-api-stub-0.2.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio__0_1_22",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio/tokio-0.1.22.crate",
        type = "tar.gz",
        sha256 = "5a09c0b5bb588872ab2f09afa13ee6e9dac11e10a0ec9e8e3ba39a5a5d530af6",
        strip_prefix = "tokio-0.1.22",
        build_file = Label("//proto/raze/remote:tokio-0.1.22.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio__0_2_18",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio/tokio-0.2.18.crate",
        type = "tar.gz",
        sha256 = "34ef16d072d2b6dc8b4a56c70f5c5ced1a37752116f8e7c1e80c659aa7cb6713",
        strip_prefix = "tokio-0.2.18",
        build_file = Label("//proto/raze/remote:tokio-0.2.18.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_codec__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-codec/tokio-codec-0.1.2.crate",
        type = "tar.gz",
        sha256 = "25b2998660ba0e70d18684de5d06b70b70a3a747469af9dea7618cc59e75976b",
        strip_prefix = "tokio-codec-0.1.2",
        build_file = Label("//proto/raze/remote:tokio-codec-0.1.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_core__0_1_17",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-core/tokio-core-0.1.17.crate",
        type = "tar.gz",
        sha256 = "aeeffbbb94209023feaef3c196a41cbcdafa06b4a6f893f68779bb5e53796f71",
        strip_prefix = "tokio-core-0.1.17",
        build_file = Label("//proto/raze/remote:tokio-core-0.1.17.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_current_thread__0_1_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-current-thread/tokio-current-thread-0.1.7.crate",
        type = "tar.gz",
        sha256 = "b1de0e32a83f131e002238d7ccde18211c0a5397f60cbfffcb112868c2e0e20e",
        strip_prefix = "tokio-current-thread-0.1.7",
        build_file = Label("//proto/raze/remote:tokio-current-thread-0.1.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_executor__0_1_10",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-executor/tokio-executor-0.1.10.crate",
        type = "tar.gz",
        sha256 = "fb2d1b8f4548dbf5e1f7818512e9c406860678f29c300cdf0ebac72d1a3a1671",
        strip_prefix = "tokio-executor-0.1.10",
        build_file = Label("//proto/raze/remote:tokio-executor-0.1.10.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_fs__0_1_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-fs/tokio-fs-0.1.7.crate",
        type = "tar.gz",
        sha256 = "297a1206e0ca6302a0eed35b700d292b275256f596e2f3fea7729d5e629b6ff4",
        strip_prefix = "tokio-fs-0.1.7",
        build_file = Label("//proto/raze/remote:tokio-fs-0.1.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_io__0_1_13",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-io/tokio-io-0.1.13.crate",
        type = "tar.gz",
        sha256 = "57fc868aae093479e3131e3d165c93b1c7474109d13c90ec0dda2a1bbfff0674",
        strip_prefix = "tokio-io-0.1.13",
        build_file = Label("//proto/raze/remote:tokio-io-0.1.13.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_reactor__0_1_12",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-reactor/tokio-reactor-0.1.12.crate",
        type = "tar.gz",
        sha256 = "09bc590ec4ba8ba87652da2068d150dcada2cfa2e07faae270a5e0409aa51351",
        strip_prefix = "tokio-reactor-0.1.12",
        build_file = Label("//proto/raze/remote:tokio-reactor-0.1.12.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_sync__0_1_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-sync/tokio-sync-0.1.8.crate",
        type = "tar.gz",
        sha256 = "edfe50152bc8164fcc456dab7891fa9bf8beaf01c5ee7e1dd43a397c3cf87dee",
        strip_prefix = "tokio-sync-0.1.8",
        build_file = Label("//proto/raze/remote:tokio-sync-0.1.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_tcp__0_1_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-tcp/tokio-tcp-0.1.4.crate",
        type = "tar.gz",
        sha256 = "98df18ed66e3b72e742f185882a9e201892407957e45fbff8da17ae7a7c51f72",
        strip_prefix = "tokio-tcp-0.1.4",
        build_file = Label("//proto/raze/remote:tokio-tcp-0.1.4.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_threadpool__0_1_18",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-threadpool/tokio-threadpool-0.1.18.crate",
        type = "tar.gz",
        sha256 = "df720b6581784c118f0eb4310796b12b1d242a7eb95f716a8367855325c25f89",
        strip_prefix = "tokio-threadpool-0.1.18",
        build_file = Label("//proto/raze/remote:tokio-threadpool-0.1.18.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_timer__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-timer/tokio-timer-0.1.2.crate",
        type = "tar.gz",
        sha256 = "6131e780037787ff1b3f8aad9da83bca02438b72277850dd6ad0d455e0e20efc",
        strip_prefix = "tokio-timer-0.1.2",
        build_file = Label("//proto/raze/remote:tokio-timer-0.1.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_timer__0_2_13",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-timer/tokio-timer-0.2.13.crate",
        type = "tar.gz",
        sha256 = "93044f2d313c95ff1cb7809ce9a7a05735b012288a888b62d4434fd58c94f296",
        strip_prefix = "tokio-timer-0.2.13",
        build_file = Label("//proto/raze/remote:tokio-timer-0.2.13.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_tls_api__0_1_22",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-tls-api/tokio-tls-api-0.1.22.crate",
        type = "tar.gz",
        sha256 = "68d0e040d5b1f4cfca70ec4f371229886a5de5bb554d272a4a8da73004a7b2c9",
        strip_prefix = "tokio-tls-api-0.1.22",
        build_file = Label("//proto/raze/remote:tokio-tls-api-0.1.22.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_udp__0_1_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-udp/tokio-udp-0.1.6.crate",
        type = "tar.gz",
        sha256 = "e2a0b10e610b39c38b031a2fcab08e4b82f16ece36504988dcbd81dbba650d82",
        strip_prefix = "tokio-udp-0.1.6",
        build_file = Label("//proto/raze/remote:tokio-udp-0.1.6.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_uds__0_1_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-uds/tokio-uds-0.1.7.crate",
        type = "tar.gz",
        sha256 = "65ae5d255ce739e8537221ed2942e0445f4b3b813daebac1c0050ddaaa3587f9",
        strip_prefix = "tokio-uds-0.1.7",
        build_file = Label("//proto/raze/remote:tokio-uds-0.1.7.BUILD"),
    )

    _new_http_archive(
        name = "raze__tokio_uds__0_2_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tokio-uds/tokio-uds-0.2.6.crate",
        type = "tar.gz",
        sha256 = "5076db410d6fdc6523df7595447629099a1fdc47b3d9f896220780fa48faf798",
        strip_prefix = "tokio-uds-0.2.6",
        build_file = Label("//proto/raze/remote:tokio-uds-0.2.6.BUILD"),
    )

    _new_http_archive(
        name = "raze__unix_socket__0_5_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unix_socket/unix_socket-0.5.0.crate",
        type = "tar.gz",
        sha256 = "6aa2700417c405c38f5e6902d699345241c28c0b7ade4abaad71e35a87eb1564",
        strip_prefix = "unix_socket-0.5.0",
        build_file = Label("//proto/raze/remote:unix_socket-0.5.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__void__1_0_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/void/void-1.0.2.crate",
        type = "tar.gz",
        sha256 = "6a02e4885ed3bc0f2de90ea6dd45ebcbb66dacffe03547fadbb0eeae2770887d",
        strip_prefix = "void-1.0.2",
        build_file = Label("//proto/raze/remote:void-1.0.2.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi__0_2_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi/winapi-0.2.8.crate",
        type = "tar.gz",
        strip_prefix = "winapi-0.2.8",
        build_file = Label("//proto/raze/remote:winapi-0.2.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi__0_3_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi/winapi-0.3.8.crate",
        type = "tar.gz",
        strip_prefix = "winapi-0.3.8",
        build_file = Label("//proto/raze/remote:winapi-0.3.8.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_build__0_1_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-build/winapi-build-0.1.1.crate",
        type = "tar.gz",
        strip_prefix = "winapi-build-0.1.1",
        build_file = Label("//proto/raze/remote:winapi-build-0.1.1.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_i686_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-i686-pc-windows-gnu/winapi-i686-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        strip_prefix = "winapi-i686-pc-windows-gnu-0.4.0",
        build_file = Label("//proto/raze/remote:winapi-i686-pc-windows-gnu-0.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__winapi_x86_64_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-x86_64-pc-windows-gnu/winapi-x86_64-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        strip_prefix = "winapi-x86_64-pc-windows-gnu-0.4.0",
        build_file = Label("//proto/raze/remote:winapi-x86_64-pc-windows-gnu-0.4.0.BUILD"),
    )

    _new_http_archive(
        name = "raze__ws2_32_sys__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/ws2_32-sys/ws2_32-sys-0.2.1.crate",
        type = "tar.gz",
        strip_prefix = "ws2_32-sys-0.2.1",
        build_file = Label("//proto/raze/remote:ws2_32-sys-0.2.1.BUILD"),
    )
