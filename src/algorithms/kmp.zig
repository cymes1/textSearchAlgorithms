const std = @import("std");
const algorithms = @import("algorithms.zig");
const SearchError = algorithms.SearchError;
const Result = algorithms.Result;

fn pref(P: []u8, s: []const u8) void {
    // P size needs to be s.len + 1 and initialized to 0

    const t: u8 = 0;
    const n = s.len;

    for(2..n) |i|
    {
        while (t > 0 and s[t + 1] != s[i])
            t = P[t];
        if( s[t+1] == s[i] )
            t+= 1;
        P[i] = t;
        i += 1;
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
