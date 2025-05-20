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
test "kmp_search_empty_text" {
    const text = "";
    const pattern = "";

    _ = kmp.search(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "kmp_search_empty_pattern" {
    const text = "";
    const pattern = "";

    _ = kmp.search(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "kmp_search_pattern_longer_than_text" {
    const text = "text";
    const pattern = "longText";

    _ = kmp.search(pattern, text) catch |err| {
        try expect(err == SearchError.PatternTooLong);
        return;
    };

    try expect(false);
}

test "kmp_search_pattern_found" {
    const text = "This is text for tests";
    const pattern = "te";

    try expect(try kmp.search(pattern, text));
}

test "kmp_search_pattern_not_found" {
    const text = "This is text for tests";
    const pattern = "This is text for testx";

    try expect(!try kmp.search(pattern, text));
}
