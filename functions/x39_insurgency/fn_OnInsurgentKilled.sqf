#include "macros.hpp"
/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The intel object.
 *  @locality server
 */

ALLOW_SERVER_ONLY();

params ["_unit"];
private _gridHashMap = _unit getVariable "X39_Insurgency_var_Grid";
if isNil "_gridHashMap" exitWith {
    ["Failed to get grid of unit %1", _unit] call BIS_fnc_error;
};
[position _unit, _gridHashMap] call X39_Insurgency_fnc_CreateIntelChanced;
private _activeUnits = _gridHashMap get "Units";
private _unitIndex = _activeUnits find _unit;
if (_unitIndex == -1) exitWith {
    ["Failed to find unit %1 in %2", _unit, _activeUnits] call BIS_fnc_error;
};
_activeUnits deleteAt _unitIndex;

if (count _activeUnits == 0) then {
    if X39_Insurgency_var_CreateMarkers then {
        private _marker = _gridHashMap get "Marker";
        if isNil "_marker" exitWith {
            ["Failed to get grid Marker of grid %1", _gridHashMap] call BIS_fnc_error;
        };
        _marker setMarkerColor "ColorGreen";
    };
    _gridHashMap set ["IsActive", false];
};
DEBUG_MSG2("Unit killed in %1, remaining: %2", _gridHashMap, count _activeUnits);