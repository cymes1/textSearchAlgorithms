const std = @import("std");
const algorithms = @import("algorithms.zig");
const SearchError = algorithms.SearchError;
const Result = algorithms.Result;

pub fn search(pattern: []const u8, text: []const u8) SearchError!bool {
    if (pattern.len == 0 or text.len == 0)
        return error.EmptyString;
    if (pattern.len > text.len)
        return error.PatternTooLong;

    for (0..text.len) |i| {
        for (pattern, 0..) |pattern_char, j| {
            const text_char = text[i + j];
            if (text_char != pattern_char) {
                break;
            }

            if (j == pattern.len - 1)
                return true;
        }
    }

    return false;
}

pub fn searchAllOccurances(pattern: []const u8, text: []const u8) SearchError!Result {
    if (pattern.len == 0 or text.len == 0)
        return error.EmptyString;
    if (pattern.len > text.len)
        return error.PatternTooLong;

    var result = Result{};
    var firstOccuranceLine: u16 = 1;
    for (0..text.len) |i| {
        if (result.occuranceCount == 0 and text[i] == '\n')
            firstOccuranceLine += 1;

        for (pattern, 0..) |pattern_char, j| {
            const text_char = text[i + j];
            if (text_char != pattern_char) {
                break;
            }

            if (j == pattern.len - 1) {
                result.occuranceCount += 1;
            }
        }
    }

    if (result.occuranceCount > 0)
        result.firstOccuranceLine = firstOccuranceLine;
    return result;
}
