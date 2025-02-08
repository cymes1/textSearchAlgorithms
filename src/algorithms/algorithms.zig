pub const SearchError = error{
    EmptyString,
    PatternTooLong,
};

pub const Result = struct {
    occuranceCount: u16 = 0,
    firstOccuranceLine: u16 = 0,
};
