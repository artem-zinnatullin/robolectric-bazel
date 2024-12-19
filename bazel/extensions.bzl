"""Definitions for bzlmod module extensions."""

load("@bazel_skylib//lib:modules.bzl", "modules")
load(":robolectric.bzl", "robolectric_repositories", "robolectric_repository")

def _robolectric_repository_extensions_impl(mctx):
    robolectric_repositories()
    return modules.use_all_repos(mctx, reproducible = True)

robolectric_repository_extensions = module_extension(implementation = _robolectric_repository_extensions_impl)

def _robolectric_repository_extensions2_impl(mctx):
    for module in mctx.modules:
        for robolectric_version in module.tags.robolectric_version:
            name = "org_robolectric_android_all_instrumented_%s" % robolectric_version.version.replace(".", "_").replace("-", "_")
            robolectric_repository(name, robolectric_version.url, robolectric_version.version, robolectric_version.sha256)

    return modules.use_all_repos(mctx, reproducible = True)

_robolectric_version = tag_class(attrs = {"version": attr.string(), "sha256": attr.string(), "url": attr.string()})

robolectric_repository_extensions2 = module_extension(
    implementation = _robolectric_repository_extensions2_impl,
    tag_classes = {"robolectric_version": _robolectric_version},
)
