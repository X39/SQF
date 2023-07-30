if !isServer exitWith { ["Function %1 is supposed to be only called on server", _fnc_scriptName] call BIS_fnc_error; };
if !canSuspend exitWith { _this spawn _fnc_scriptName; };

params [
    ["_hackTarget", objNull, [objNull]],
    ["_hackTime", 60, [0]],
    ["_hackText", "Hacking", [""]],
    ["_hackCallbackFunction", "", [""]]
];

private _remainingHackTime = _hackTime;
[_hackTarget, _hackTime, _hackText] call X39_Hacking_fnc_StartHackProgress;
while {_remainingHackTime > 0} do {
    _remainingHackTime = _remainingHackTime - 0.25;
    [_hackTarget, _hackTime, _remainingHackTime, _hackText] call X39_Hacking_fnc_UpdateHackProgress;
    sleep 0.25;
};
[_hackTarget, _hackText] call X39_Hacking_fnc_EndHackProgress;
_hackCallback = (missionNamespace getVariable _hackCallbackFunction);
if !isNil "_hackCallback" then {
    [_hackTarget] call _hackCallback;
};