/*
    Stringifies code, so it can be used in various operators.
    @param 0 The code to stringify
*/
params [
    ["_code", {}, [{}]]
];

private _str = str _code;
private _len = count _str;
_str select [1, _len - 2]