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
    while (i < lps.len) {
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

//void KMP( string &T, string &W )
//{
//  string S = "#" + W + "#" + T;
//  vector<int> P;
//  Pref(P, S);
//
//  unsigned int i, ws = W.size();
//
//  for( i = ws + 2; i < S.size(); i++ )
//  {
//  //wypisz pozycje wzorca w tekscie
//  if( P[i] == ws ) printf("%d\n", i-ws-ws);
//  }
//}

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
