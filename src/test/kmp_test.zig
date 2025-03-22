const std = @import("std");
const expect = std.testing.expect;

const SearchError = @import("../algorithms/algorithms.zig").SearchError;
const kmp = @import("../algorithms/kmp.zig");

// ============
// search
// ============
test "naive_search_empty_text" {
    const text = "";
    const pattern = "";

    _ = kmp.search(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);

