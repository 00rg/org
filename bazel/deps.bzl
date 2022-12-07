"""Provides dependency loading functions."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def org_base_dependencies():
    """Declare base dependencies."""

    bazel_skylib_version = "1.3.0"
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/{v}/bazel-skylib-{v}.tar.gz".format(v = bazel_skylib_version)],
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
    )

def org_binary_dependencies():
    """Declare binary tool dependencies."""

    helm_version = "3.10.2"
    maybe(
        http_archive,
        name = "helm",
        urls = ["https://get.helm.sh/helm-v{v}-darwin-arm64.tar.gz".format(v = helm_version)],
        sha256 = "460441eea1764ca438e29fa0e38aa0d2607402f753cb656a4ab0da9223eda494",
        strip_prefix = "darwin-arm64",
        build_file = "//bazel/third_party:BUILD.helm.bazel",
    )

    istio_version = "1.16.0"
    maybe(
        http_archive,
        name = "istioctl",
        urls = ["https://github.com/istio/istio/releases/download/{v}/istioctl-{v}-osx-arm64.tar.gz".format(v = istio_version)],
        sha256 = "6089c88b47f24de89ae164afb5d1fc5006d1341b85cb777633a6a599d63414e6",
        build_file = "//bazel/third_party:BUILD.istioctl.bazel",
    )

    k3d_version = "5.4.6"
    http_file(
        name = "k3d",
        urls = ["https://github.com/k3d-io/k3d/releases/download/v{v}/k3d-darwin-arm64".format(v = k3d_version)],
        sha256 = "486baa195157183fb6e32b781dd0a638f662ed5f9c4d80510287ce9630a80081",
        executable = True,
    )

    kubectl_version = "1.25.4"
    http_file(
        name = "kubectl",
        urls = ["https://dl.k8s.io/release/v{v}/bin/darwin/arm64/kubectl".format(v = kubectl_version)],
        sha256 = "61ee3edabfb4db59c102968bd2801d3f0818cff5381e5cb398b0ac5dc72e2ce9",
        executable = True,
    )

def org_manifest_dependencies():
    """Declare Kubernetes manifest dependencies."""

    argocd_version = "2.5.2"
    maybe(
        http_archive,
        name = "argocd",
        urls = ["https://github.com/argoproj/argo-cd/archive/refs/tags/v{v}.tar.gz".format(v = argocd_version)],
        sha256 = "a210784ae3ee017d1bd83772b04ee125e4bdccf0eb6fc15aa796d009b56440ec",
        strip_prefix = "argo-cd-{}/manifests".format(argocd_version),
        build_file = "//bazel/third_party:BUILD.argocd.bazel",
    )

    crossplane_version = "1.10.1"
    maybe(
        http_archive,
        name = "crossplane",
        urls = ["https://charts.crossplane.io/stable/crossplane-{v}.tgz".format(v = crossplane_version)],
        sha256 = "0b93a206fd298f9c6c015eaf0cbf66f4235be5e9084abe4aa3d66f57f2c0e40d",
        strip_prefix = "crossplane",
        build_file = "//bazel/third_party:BUILD.crossplane.bazel",
    )

    vector_chart_version = "0.17.0"
    maybe(
        http_archive,
        name = "vector",
        urls = ["https://github.com/vectordotdev/helm-charts/releases/download/vector-{v}/vector-{v}.tgz".format(v = vector_chart_version)],
        sha256 = "4c12b5d95b03983c42208de2fa2b28f05089c40f518bce0b050a4a3480bafd9a",
        strip_prefix = "vector",
        build_file = "//bazel/third_party:BUILD.vector.bazel",
    )

def org_python_dependencies():
    """Declare Python dependencies."""

    rules_python_version = "0.14.0"
    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "a868059c8c6dd6ad45a205cca04084c652cfe1852e6df2d5aca036f6e5438380",
        strip_prefix = "rules_python-{v}".format(v = rules_python_version),
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/{v}.tar.gz".format(v = rules_python_version),
    )

def org_go_dependencies():
    """Declare Go dependencies."""

    # Golang stuff which is required for building Golang code but is also required
    # by rules_docker as a workaround for https://github.com/bazelbuild/rules_docker/issues/2036
    # and https://github.com/bazelbuild/bazel/issues/10134#issuecomment-1193395705.
    # TODO: Move below out into a go_deps.bzl file and go_dependencies() function.
    # Probably want: k8s_deps.bzl/k8s_dependencies(), container_deps.bzl/container_dependencies(), etc.

    rules_go_version = "0.36.0"
    maybe(
        http_archive,
        # All dependencies are named after their official workspace name. In the case of
        # io_bazel_rules_go, this is strictly required since bazel_gazelle expects to be
        # able to resolve @io_bazel_rules_go references.
        name = "io_bazel_rules_go",
        sha256 = "ae013bf35bd23234d1dea46b079f1e05ba74ac0321423830119d3e787ec73483",
        urls = ["https://github.com/bazelbuild/rules_go/releases/download/v{v}/rules_go-v{v}.zip".format(v = rules_go_version)],
    )

    bazel_gazelle_version = "0.27.0"
    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "efbbba6ac1a4fd342d5122cbdfdb82aeb2cf2862e35022c752eaddffada7c3f3",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/v{v}/bazel-gazelle-v{v}.tar.gz".format(v = bazel_gazelle_version)],
    )

def org_rust_dependencies():
    """Declare Rust dependencies."""

    # Note: I have tried unsuccesfully to get Cargo Raze working through Bazel as described in
    # https://github.com/google/cargo-raze#using-cargo-raze-through-bazel. Different version
    # combinations of Raze and rules_rust produce different errors but it doesn't seem ready
    # to run on Apple M1 yet.

    rules_rust_version = "0.14.0"
    maybe(
        http_archive,
        name = "rules_rust",
        sha256 = "dd79bd4e2e2adabae738c5e93c36d351cf18071ff2acf6590190acf4138984f6",
        urls = ["https://github.com/bazelbuild/rules_rust/releases/download/{v}/rules_rust-v{v}.tar.gz".format(v = rules_rust_version)],
    )

def org_container_dependencies():
    """Declare container dependencies."""

    rules_docker_version = "0.25.0"
    maybe(
        http_archive,
        name = "io_bazel_rules_docker",
        sha256 = "b1e80761a8a8243d03ebca8845e9cc1ba6c82ce7c5179ce2b295cd36f7e394bf",
        urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v{v}/rules_docker-v{v}.tar.gz".format(v = rules_docker_version)],
    )
