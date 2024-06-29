const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addStaticLibrary(.{
        .name = "kernel",
        .root_source_file = b.path("kernel.zig"),
        .target = b.resolveTargetQuery(std.Target.Query{
            .cpu_arch = .spirv64,
            .os_tag = .vulkan,
            .cpu_features_add = std.Target.spirv.featureSet(&.{
                .Int64,
                .Int16,
                .Int8,
                .Float64,
                .Float16,
                .Vector16,
            }),
        }),
        .optimize = b.standardOptimizeOption(.{}),
        .use_llvm = false,
        .use_lld = false,
    });

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
