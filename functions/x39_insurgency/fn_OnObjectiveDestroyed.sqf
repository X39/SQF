#include "macros.hpp"
/*
 *  Internal method, called once an ammo-cache was exploded.
 *  
 *  @arg 0 The cache that exploded.
 */

ALLOW_SERVER_ONLY();
params [
    ["_cache", objNull, [objnull]],
    ["_position", nil, [[0,0,0], nil]],
    ["_markers", nil, [[], nil]]
];

if isNil "_position" then { _position = getPosWorld _cache; };
if isNil "_markers" then { _markers = _cache getVariable ["X39_Insurgency_var_Markers", []]; };


DEBUG_MSG1("Objective destroyed at %1", _position);
private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;
private _caches = _insurgency getOrDefault ["Objectives", [], true];


// Delete NULL caches
{ private _index = _caches find _x; if (_index != -1) then { _caches deleteAt _index; }; } forEach (_caches select { isNull _x });

// Delete Cache
if !isNull _cache then { private _index = _caches find _cache; if (_index != -1) then { _caches deleteAt _index; }; deleteVehicle _cache; };

// Delete markers of cache
{ deleteMarker _x; } forEach _markers;

// Announce the destroyed objective
[count _caches] remoteExecCall ["X39_Insurgency_fnc_AnnounceObjectiveDestroyed", 0, false];

// End mission if done
if ({!isNull _x && {alive _x}} count _caches == 0) then {
    ["end1", true, true, true, true] call BIS_fnc_endMission;
};