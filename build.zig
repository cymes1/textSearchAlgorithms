const std = @import("std");

const content_dir = "res/";
const main_file = "src/main.zig";
const main_test_file = "src/test.zig";

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "Text Search",
        .root_source_file = .{ .path = main_file },
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    configureTests(b);

    const install_content_step = b.addInstallDirectory(.{
        .source_dir = .{ .path = thisDir() ++ "/" ++ content_dir },
        .install_dir = .{ .custom = "" },
        .install_subdir = "bin/" ++ content_dir,
    });
    b.getInstallStep().dependOn(&install_content_step.step);
    b.step("content", "Install content").dependOn(&install_content_step.step);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(&install_content_step.step);
    b.step("run", "Run demo").dependOn(&run_cmd.step);
}

fn configureTests(b: *std.Build) void {
    const test_target = std.Target.Query{
        .cpu_arch = .x86_64,
        .os_tag = .linux,
    };
    const tests = b.addTest(.{
        .root_source_file = b.path(main_test_file),
        .target = b.resolveTargetQuery(test_target),
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
