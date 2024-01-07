#include "macros.hpp"
/*
 *  Internal method, called once an ammo-cache was exploded.
 *  
 *  @arg 0 The cache that exploded.
 */

ALLOW_SERVER_ONLY();
params [
    ["_hashMap", nil, [createHashMap]]
];
if isNil "_hashMap" exitWith {
    ["OnObjectiveDestroyed got passed a nil hashmap"] call BIS_fnc_error;
};

private _cache = _hashMap get "Cache";
private _markers = _hashMap get "Markers";

DEBUG_MSG1("Objective destroyed at %1", (_hashMap get "Position"));
private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;
private _objectives = _insurgency getOrDefault ["Objectives", [], true];

// Delete Cache
private _index = _objectives find _hashMap; if (_index != -1) then { _objectives deleteAt _index; };
if !isNull _cache then { deleteVehicle _cache; };

// Delete markers of cache
{ deleteMarker _x; } forEach _markers;

// Announce the destroyed objective
[count _objectives] remoteExecCall ["X39_Insurgency_fnc_AnnounceObjectiveDestroyed", 0, false];

// End mission if done
if (count _objectives == 0) then {
    ["end1", true, true, true, true] remoteExecCall ["BIS_fnc_endMission", 0, false];
};