const std = @import("std");

pub fn nanoToMili(nano: f64) f64 {
    return nano * 0.000001;
}

pub fn get_line() []const u8 {
    var buf: [64]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const result = stdin.readUntilDelimiter(buf[0..], '\n') catch {
        stdin.skipUntilDelimiterOrEof('\n') catch return "";
        return "";
    };
    return result;
}
