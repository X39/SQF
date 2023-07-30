#include "macros.hpp";
/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The intel object.
 *  @locality server
 */

ALLOW_SERVER_ONLY();
params ["_intel"];

private _intelPosition = position _intel;
deleteVehicle _intel;
private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;
private _objectives = _insurgency get "Objectives";

// Find closest objective
private _closestObjective = nil;
private _distance = 99999999;
{
    private _dst = _intelPosition distance _x;
    if (_distance > _dst) then {
        _closestObjective = _x;
        _distance = _dst;
    };
} forEach _objectives;
if isNil "_closestObjective" exitWith
{
    ["$1: No ammo cache found for intel pickup", _fnc_scriptName] call BIS_fnc_error;
};


private _markers = _closestObjective getVariable ["X39_Insurgency_var_Markers", []];
private _distanceIndex = _closestObjective getVariable ["X39_Insurgency_var_DistanceIndex", count X39_Insurgency_var_Distances - 1];
private _distanceTuple = X39_Insurgency_var_Distances select _distanceIndex;
if (_distanceIndex > 0) then {
    _distanceIndex = _distanceIndex - 1;
};
_closestObjective setVariable ["X39_Insurgency_var_DistanceIndex", _distanceIndex];
private _closestObjectivePosition = position _closestObjective;
private _marker = format ["X39_Insurgency_IntelMarker_x%1_y%2_%3", _closestObjectivePosition # 0, _closestObjectivePosition # 1, count _markers + 1];
private _randomDir = random 360;
private _randomDistance = random (_distanceTuple # 1) + _distanceTuple # 0;
private _positionVector = [cos _randomDir * _randomDistance, sin _randomDir * _randomDistance];
_closestObjectivePosition set [2, 0];
private _markerPosition = _positionVector vectorAdd _closestObjectivePosition;
createMarker [_marker, _markerPosition];
_marker setMarkerColor X39_Insurgency_var_IntelMarkerColor;
_marker setMarkerShape "ICON";
_marker setMarkerType X39_Insurgency_var_IntelMarkerType;
_marker setMarkerText str (_distanceTuple # 0);
_markers pushBack [_marker];
_closestObjective setVariable ["X39_Insurgency_var_Markers", _markers];
remoteExecCall ["X39_Insurgency_fnc_AnnounceIntelPickUp", 0, false];
DEBUG_MSG3("Added intel at %1 for objective at %2 from pickup at %3", _markerPosition, _closestObjectivePosition, _intelPosition);