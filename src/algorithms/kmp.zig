const std = @import("std");
const algorithms = @import("algorithms.zig");
const SearchError = algorithms.SearchError;
const Result = algorithms.Result;

pub fn pref(pattern: []const u8, lps: []u8) SearchError!void {
    if (pattern.len == 0)
        return error.EmptyString;
    if (lps.len < pattern.len)
        return error.BufferTooSmall;

    var j: u8 = 0;
    var i: u8 = 1;
    lps[0] = 0;
    while (i < pattern.len) {
        if (pattern[i] == pattern[j]) {
            j += 1;
            lps[i] = j;
            i += 1;
        } else if (j != 0) {
            j = lps[j - 1];
        } else {
            lps[i] = 0;
            i += 1;
        }
    }
}

pub fn search(pattern: []const u8, text: []const u8) SearchError!bool {
    if (pattern.len == 0 or text.len == 0)
        return error.EmptyString;
    if (pattern.len > text.len)
        return error.PatternTooLong;

    var lps: [64]u8 = undefined;
    try pref(pattern, &lps);

    var i: u32 = 0;
    while (i < text.len) {
        var j: u16 = 0;
        while (j < pattern.len) {
            const pattern_char = pattern[j];
            const text_char = text[i];
            if (text_char != pattern_char) {
                if (lps[j] == 0) {
                    i += 1;
                    break;
                }

                j = lps[j];
                continue;
            }

            j += 1;
            i += 1;
            if (j == pattern.len)
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

    var lps: [64]u8 = undefined;
    try pref(pattern, &lps);

    var result = Result{};
    var firstOccuranceLine: u16 = 1;

    var i: u32 = 0;
    while (i < text.len) {
        if (result.occuranceCount == 0 and text[i] == '\n')
            firstOccuranceLine += 1;

        var j: u16 = 0;
        while (j < pattern.len) {
            const pattern_char = pattern[j];
            const text_char = text[i];
            if (text_char != pattern_char) {
                if (lps[j] == 0) {
                    i += 1;
                    break;
                }

                j = lps[j];
                continue;
            }

            j += 1;
            i += 1;
            if (j == pattern.len) {
                result.occuranceCount += 1;
                break;
            }
        }
    }

    if (result.occuranceCount > 0)
        result.firstOccuranceLine = firstOccuranceLine;
    return result;
}
