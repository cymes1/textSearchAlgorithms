const std = @import("std");

pub fn openFile(path: []const u8, gpa: std.mem.Allocator) ![:0]u8 {
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const mbSize = 1048576;
    const content = try file.readToEndAllocOptions(gpa, mbSize, null, @alignOf(u8), 0);
    return content;
}
