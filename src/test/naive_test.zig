const std = @import("std");
const expect = std.testing.expect;

const SearchError = @import("../algorithms/algorithms.zig").SearchError;
const naive = @import("../algorithms/naive.zig");

// =====================
// search
// =====================
test "naive_search_empty_text" {
    const text = "";
    const pattern = "";

    _ = naive.search(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "naive_search_empty_pattern" {
    const text = "";
    const pattern = "";

    _ = naive.search(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "naive_search_pattern_longer_than_text" {
    const text = "text";
    const pattern = "longText";

    _ = naive.search(pattern, text) catch |err| {
        try expect(err == SearchError.PatternTooLong);
        return;
    };

    try expect(false);
}

test "naive_search_pattern_found" {
    const text = "This is text for tests";
    const pattern = "te";

    try expect(try naive.search(pattern, text));
}

test "naive_search_pattern_not_found" {
    const text = "This is text for tests";
    const pattern = "This is text for testx";

    try expect(!try naive.search(pattern, text));
}

// =====================
// search all occurances
// =====================
test "naive_search_all_occurances_empty_text" {
    const text = "";
    const pattern = "";

    _ = naive.searchAllOccurances(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "naive_search_all_occurances_empty_pattern" {
    const text = "";
    const pattern = "";

    _ = naive.searchAllOccurances(pattern, text) catch |err| {
        try expect(err == SearchError.EmptyString);
        return;
    };

    try expect(false);
}

test "naive_search_all_occurances_pattern_longer_than_text" {
    const text = "text";
    const pattern = "longText";

    _ = naive.searchAllOccurances(pattern, text) catch |err| {
        try expect(err == SearchError.PatternTooLong);
        return;
    };

    try expect(false);
}

test "naive_search_all_occurances_pattern_found" {
    const text1 = "This is text for tests";
    const pattern1 = "te";
    var result = try naive.searchAllOccurances(pattern1, text1);
    try expect(result.occuranceCount == 2);
    try expect(result.firstOccuranceLine == 1);

    const text2 = "Kiwi \non \nthe banana";
    const pattern2 = "na";
    result = try naive.searchAllOccurances(pattern2, text2);
    try expect(result.occuranceCount == 2);
    try expect(result.firstOccuranceLine == 3);
}

test "naive_search_all_occurances_pattern_not_found" {
    const text = "This is text for tests";
    const pattern = "This is text for testx";
    const result = try naive.searchAllOccurances(pattern, text);
    try expect(result.occuranceCount == 0);
}
