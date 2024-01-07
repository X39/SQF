#include "macros.hpp"
/*
 *  Internal method, called to create the objectives.
 *  Creates a bunch of supply boxes to be blown up by players.
 *  
 *  @arg 0 The intel object.
 *  @locality server
 */
ALLOW_SERVER_ONLY();

private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;
private _supplyObjectiveClassNames = X39_Insurgency_var_ObjectiveClassNames;


private _objectives = _insurgency getOrDefault ["Objectives", [], true];
private _gridKeys = keys _insurgency select { _x isEqualTypeArray  [0, 0] };
for "_i" from 0 to X39_Insurgency_var_ObjectiveCount do {
    // Get random supply box class
    private _className = _supplyObjectiveClassNames select floor random count _supplyObjectiveClassNames;
    
    // Get random grid
    if (count _gridKeys == 0) exitWith { /* All available grids are exhausted */ };
    private _randomGridKey = _gridKeys select floor random count _gridKeys;
    _gridKeys deleteAt (_gridKeys find _randomGridKey);
    if isNil "_randomGridKey" exitWith {
        ["Failed to get random grid key"] call BIS_fnc_error;
    };
    private _randomGrid = _insurgency get _randomGridKey;
    if isNil "_randomGrid" exitWith {
        ["Failed to get random grid from key %1", _randomGridKey] call BIS_fnc_error;
    };
    if !(_randomGrid isEqualType createHashMap) exitWith {
        ["Failed to get random grid from key %1", _randomGridKey] call BIS_fnc_error;
    };
    
    // Get random building in grid
    private _buildings = _randomGrid get "Buildings";
    if isNil "_buildings" exitWith {
        ["Failed to get 'Buildings' of grid %1 (%2)", _randomGrid  get "grid", _randomGrid] call BIS_fnc_error;
    };
    private _randomBuilding = _buildings select floor random count _buildings;
    
    // Get random building position in building
    private _buildingPositions = _randomBuilding buildingPos -1;
    private _randomBuildingPosition = _buildingPositions select floor random count _buildingPositions;
    
    // Create objective object
    private _cache = createVehicle [_className, _randomBuildingPosition];
    private _objective = createHashMapFromArray [
        ["Type", "Supply"],
        ["Position", _randomBuildingPosition],
        ["Grid", _randomGrid],
        ["Building", _randomBuilding],
        ["Cache", _cache],
        ["CacheClass", _className],
        ["Markers", []],
        ["DistanceIndex", count X39_Insurgency_var_Distances - 1]
    ];
    _cache setVariable ["X39_Insurgency_var_Objective", _objective];
    _objectives pushBack _objective;
    _cache addEventHandler ["HandleDamage", {
        params ["_cache", "", "_damage"];
        DEBUG_MSG2("Cache %1 received damage of %2", _cache, _damage);
        _cache setVariable ["X39_Insurgency_var_LastDamageReceived", _damage];
        0
    }];
    _cache addEventHandler ["Explosion", {
        params ["_cache", "_damage"];
        private _lastDamage = _cache getVariable ["X39_Insurgency_var_LastDamageReceived", _damage];
        DEBUG_MSG3("Cache %1 received explosion damage of %2 (last damage: %3)", _cache, _damage, _lastDamage);
        if (_lastDamage < X39_Insurgency_var_ObjectiveMinExplosionDamage) exitWith {};
        [_cache getVariable "X39_Insurgency_var_Objective"] remoteExecCall ["X39_Insurgency_fnc_OnObjectiveDestroyed", 2, false];
    }];
    
    // Output debug message
    DEBUG_MSG1("Created cache at %1", _randomBuildingPosition);
};