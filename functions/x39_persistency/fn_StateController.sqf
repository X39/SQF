/*
    Initializes an object for controlling the persistency state.
    
    _self - The vehicle object to make "cargoable".
    _identifier - The identifier of the state.
    _markers - A list of markers, marking the area of persistency
*/

params [
    ["_self", objNull, [objNull]],
    "_identifier",
    ["_markers", [], [[]]]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };
if isNil "_identifier" exitWith { ["%1: Passed in _identifier is nil", _fnc_scriptName] call BIS_fnc_error; };
if (count _markers == 0) exitWith { ["%1: Passed in _markers is empty", _fnc_scriptName] call BIS_fnc_error; };
if ({_x isEqualType ""} count _markers != count _markers) exitWith { ["%1: Passed in _markers is not exclusively containing markers", _fnc_scriptName] call BIS_fnc_error; };

_self addAction [
    "<t color='#00FF00'>Speichern</t>",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments remoteExec ["X39_Persistency_fnc_Save", 2, false];
    },
    [_identifier, _markers],
    1.5,
    false,
    false,
    "",
    "true",
    10
];
if isServer then {
    [_identifier] call X39_Persistency_fnc_Load;
};