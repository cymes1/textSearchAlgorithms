const std = @import("std");
const Timer = std.time.Timer;
const sh = @import("file.zig");
const utils = @import("utils/utils.zig");

const pattern = "Tincidunt";

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa_state = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    // read a file
    var timer = try std.time.Timer.start();
    std.time.Timer.reset(&timer);
    const file = try sh.openFile("res/example-text", gpa);
    defer gpa.free(file);
    const nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    const mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("Text Searching Algorithms demo\n", .{});
    try stdout.print("file read time: {d:.3} miliseconds\n", .{mili_sec});
    try stdout.print("file length: {d} characters\n", .{file.len});

    var shouldLeave = false;
    while (!shouldLeave) {
        const chosenOption = askUser();
        if (chosenOption == AlgorithmOptions.exit)
            shouldLeave = true;
        if (chosenOption == AlgorithmOptions.invalid)
            try stdout.print("Provided number is invalid.\n", .{});
        if (chosenOption == AlgorithmOptions.naive)
            try runNaive(file);
        if (chosenOption == AlgorithmOptions.kmp)
            try runKMP(file);
        if (chosenOption == AlgorithmOptions.compare) {
            try stdout.print("======== Naive algorithm ========", .{});
            try runNaive(file);
            try stdout.print("======== KMP algorithm ========", .{});
            try runKMP(file);
        }
    }
}

fn askUser() AlgorithmOptions {
    const stdout = std.io.getStdOut().writer();
    stdout.print("\n", .{}) catch {
        return AlgorithmOptions.invalid;
    };
    inline for (std.meta.fields(AlgorithmOptions)) |option| {
        if (option.value == @intFromEnum(AlgorithmOptions.invalid))
            continue;

        stdout.print("{d}) {s}\n", .{ option.value, option.name }) catch {
            return AlgorithmOptions.invalid;
        };
    }
    stdout.print("Choose a number please: ", .{}) catch {
        return AlgorithmOptions.invalid;
    };

    var buf: [3]u8 = undefined;
    const exitValue = @intFromEnum(AlgorithmOptions.exit);
    const b = std.fmt.bufPrint(&buf, "{}", .{exitValue}) catch {
        return AlgorithmOptions.invalid;
    };
    const line = utils.get_line();
    if (std.mem.eql(u8, line, @tagName(AlgorithmOptions.exit)) or std.mem.eql(u8, line, b))
        return AlgorithmOptions.exit;
    if (std.mem.eql(u8, line, "2"))
        return AlgorithmOptions.naive;
    if (std.mem.eql(u8, line, "3"))
        return AlgorithmOptions.kmp;
    if (std.mem.eql(u8, line, "4"))
        return AlgorithmOptions.compare;

    return AlgorithmOptions.invalid;
}

fn runNaive(file: [:0]u8) !void {
    // single
    const stdout = std.io.getStdOut().writer();
    const naive = @import("algorithms/naive.zig");
    var timer = try std.time.Timer.start();
    try stdout.print("\nNaive algorithm - single variant:", .{});
    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    if (try naive.search(pattern, file)) {
        try stdout.print("pattern found\n", .{});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    var nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    var mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});

    // multiple
    try stdout.print("\nNaive algorithm - multi variant:", .{});
    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    const result = try naive.searchAllOccurances(pattern, file);
    if (result.occuranceCount > 0) {
        try stdout.print("pattern found {d} times\n", .{result.occuranceCount});
        try stdout.print("pattern first found at line {d}\n", .{result.firstOccuranceLine});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});
}

fn runKMP(file: [:0]u8) !void {
    // single
    const stdout = std.io.getStdOut().writer();
    const kmp = @import("algorithms/kmp.zig");
    var timer = try std.time.Timer.start();
    try stdout.print("\nKMP algorithm - single variant:", .{});
    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    if (try kmp.search(pattern, file)) {
        try stdout.print("pattern found\n", .{});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    var nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    var mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});

    // multiple
    try stdout.print("\nKMP algorithm - multi variant:", .{});
    try stdout.print("\nSearching for pattern: {s}\n", .{pattern});
    std.time.Timer.reset(&timer);
    const result = try kmp.searchAllOccurances(pattern, file);
    if (result.occuranceCount > 0) {
        try stdout.print("pattern found {d} times\n", .{result.occuranceCount});
        try stdout.print("pattern first found at line {d}\n", .{result.firstOccuranceLine});
    } else {
        try stdout.print("pattern not found\n", .{});
    }
    nano_sec = @as(f64, @floatFromInt(Timer.lap(&timer)));
    mili_sec = utils.nanoToMili(nano_sec);
    try stdout.print("search time: {d:.3} miliseconds\n", .{mili_sec});
}

const AlgorithmOptions = enum(u8) {
    invalid,
    exit,
    naive,
    kmp,
    compare,
};
