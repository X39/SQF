/*
    Allows to control whether this should be persisted or not.
    
    _self - The object to change the persistence mode on.
    _persist - If true, object will be persisted. If false, object will not be persisted.
*/

params [
    ["_self", objNull, [objNull]],
    ["_persist", false, [false]]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };
_self setVariable ["X39_Persistency_var_Persist", _persist];