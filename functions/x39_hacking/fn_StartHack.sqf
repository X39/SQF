params [
    ["_hackTarget", objNull, [objNull]],
    ["_hackTime", 60, [0]],
    ["_hackText", "Hacking", [""]],
    ["_hackCallbackFunction", "", [""]]
];

[_hackTarget, _hackTime, _hackText, _hackCallbackFunction] call remoteExec ["X39_Hacking_fnc_Hackloop", 2];