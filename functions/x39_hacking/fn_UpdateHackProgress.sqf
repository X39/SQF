if !hasInterface exitWith {};
params [
    ["_hackTarget", objNull, [objNull]],
    ["_hackTimeTotal", 60, [0]],
    ["_hackTimeRemaining", 60, [0]],
    ["_hackText", "", [""]]
];

[
    parseText format [
        _hackText,
        _hackTimeTotal,
        _hackTimeRemaining,
        str (ceil ((_hackTimeRemaining / _hackTimeTotal) * 100)) + " %"
    ]
] remoteExec ["hint", 0, false];