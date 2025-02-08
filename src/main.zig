const std = @import("std");
const Timer = std.time.Timer;
const sh = @import("file.zig");
const naive = @import("algorithms/naive.zig");
const utils = @import("utils/utils.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("\n", .{});

    var gpa_state = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    var timer = try std.time.Timer.start();
    std.time.Timer.reset(&timer);
    const a = try sh.openFile("res/example-text", gpa);
    defer gpa.free(a);
    var nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    var mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("file read time: {d:.3} miliseconds\n", .{mili_sec});
    try stdout.print("file length: {d} characters\n", .{a.len});

    const pattern = "Tincidunt";
    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    if (try naive.search(pattern, a)) {
        try stdout.print("pattern found\n", .{});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});

    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    const result = try naive.searchAllOccurances(pattern, a);
    if (result.occuranceCount > 0) {
        try stdout.print("pattern found {d} times\n", .{result.occuranceCount});
        try stdout.print("pattern first found at line {d}\n", .{result.firstOccuranceLine});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});

    try stdout.print("\n\n", .{});
    var shouldLeave = true;
    while (shouldLeave) {
        const b = ask_user();
        if (b == 0)
            shouldLeave = false;
    }
}

fn ask_user() i64 {
    const stdout = std.io.getStdOut().writer();

    //var buf: [10]u8 = undefined;

    stdout.print("A number please: ", .{}) catch {
        return @as(i64, -1);
    };

    const line = utils.get_line();
    //stdout.print("{s}", .{line}) catch return 0;
    std.debug.print("{s}\n", .{line});
    //_ = line;
    //stdout.print("\n\n{s}\n", .{line}) catch return 0;
    //stdout.print("\n\n{s}\n", .{line}) catch return 0;
    return 0;

    //if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
    //    return std.fmt.parseInt(i64, user_input, 10);
    //} else {
    //    stdout.print("Not a valid number", .{}) catch {
    //        return @as(i64, -1);
    //    };
    //    return @as(i64, -1);
    //}
}
