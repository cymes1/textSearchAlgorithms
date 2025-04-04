const std = @import("std");
const expect = std.testing.expect;
const expectEqualSlices = std.testing.expectEqualSlices;

const SearchError = @import("../algorithms/algorithms.zig").SearchError;
const kmp = @import("../algorithms/kmp.zig");

// ============
// preprocess
// ============
test "kmp_lps_empty_pattern" {
    const pattern = "";
    var buf: [pattern.len]u8 = undefined;
    kmp.pref(pattern, &buf) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "kmp_lps_buffer_too_small" {
    const pattern = "testPattern";
    var buf: [3]u8 = undefined;
    kmp.pref(pattern, &buf) catch |err| {
        try expect(err == SearchError.BufferTooSmall);
        return;
    };

    try expect(false);
}

test "kmp_lps_correct" {
    const pattern = "ababcabab";
    var buf: [pattern.len]u8 = undefined;
    try kmp.pref(pattern, &buf);

    const expectedResult = [9]u8{ 0, 0, 1, 2, 0, 1, 2, 3, 4 };
    try std.testing.expectEqualSlices(u8, &buf, &expectedResult);
}

// ============
// search
// ============
//test "naive_search_empty_text" {
//    const text = "";
//    const pattern = "";
//
//    _ = kmp.search(pattern, text) catch |err| {
//        try expect(err == SearchError.EmptyString);
//        return;
//    };
//
//    try expect(false);
//}
