if !hasInterface exitWith {};
params [
    ["_hackTarget", objNull, [objNull]],
    ["_holdTime", 60, [0]],
    ["_hackTime", 600, [0]],
    ["_hackText", "<t color='#FFAA00'>Hack wird ausgeführt (%3 - %2/%1)</t>", [""]],
    ["_hackCallbackFunction", "", [""]],
    ["_actionText", "<t color='#FFAA00'>Hacken</t>", [""]]
];
_hackTarget setVariable ["X39_Hacking_var_HackTime", _hackTime];
_hackTarget setVariable ["X39_Hacking_var_HackCallback", _hackCallbackFunction];
_hackTarget setVariable ["X39_Hacking_var_HackText", _hackText];
[
    _hackTarget,
    _actionText,
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa",
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_hack_ca.paa",
    "!(_target getVariable [""X39_Hacking_var_HackInProgress"", false])",
    "!(_target getVariable [""X39_Hacking_var_HackInProgress"", false])",
    { _target getVariable ["X39_Hacking_var_HackInProgress", true] },
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        
        private _hackTime = _target getVariable "X39_Hacking_var_HackTime";
        private _hackCallbackFunction = _target getVariable "X39_Hacking_var_HackCallback";
        private _hackText = _target getVariable "X39_Hacking_var_HackText";
        [_target, _hackTime, _hackText, _hackCallbackFunction] remoteExec ["X39_Hacking_fnc_HackLoop", 2, false];
    },
    { _target getVariable ["X39_Hacking_var_HackInProgress", false] },
    [],
    getNumber (configFile >> "CfgVehicles" >> (typeOf _self) >> "mapSize"),
    _holdTime,
    false,
    true,
    true
] call BIS_fnc_holdActionAdd;

