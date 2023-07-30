/*
    Initializes an object for the arma3 cargo system.
    
    _self - The vehicle object to make "cargoable".
    _unloadText - Optional custom text. Defaults to orange text in german.
    _selectText - Optional custom text. Defaults to orange text in german.
    _selectedText - Optional custom text. Defaults to orange text in german.
*/

params [
    ["_self", objNull, [objNull]],
    ["_unloadText", "<t color='#FFAA00'>Fahrzeug entladen</t>"],
    ["_selectText", "<t color='#FFAA00'>Fahrzeug wählen</t>"],
    ["_selectedText", "<t color='#FFAA00'>Fahrzeug %1 wurde ausgewählt</t>"]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };
_self setVariable ["X39_Cargo_var_IsVehicleObject", true];

_self addAction [
    "<t color='#FFAA00'>Fahrzeug entladen</t>",
    { objNull setVehicleCargo (getVehicleCargo (_this select 0) select 0); },
    [],
    1.5,
    false,
    false,
    "",
    "count getVehicleCargo _target > 0",
    10
];

_self addAction [
    _selectText,
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        X39_Cargo_var_SelectedVehicle = _target;
        hint parseText format [_arguments, getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "displayName")];
    },
    _selectedText,
    0,
    false,
    true,
    "",
    "true",
    10
];