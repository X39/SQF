#include "macros.hpp";
/*
 *  Internal method, called once a player enters a grid.
 *  
 *  @arg 0 The grid to spawn the insurgent in.
 *  @locality server
 */

ALLOW_SERVER_ONLY();

params ["_gridHashMap"];
DEBUG_MSG1("Creating Insurgent in grid %1", _gridHashMap);

private _buildings = _gridHashMap get "Buildings";
if isNil "_buildings" exitWith {
    ["Failed to get 'Buildings' for grid %1", _gridHashMap] call BIS_fnc_error;
};
_buildings = +_buildings;

// Get or create group for grid
private _group = _gridHashMap get "Group";
if (isNil "_group" || {isNull _group}) then {
    private _center = _gridHashMap get "Center";
    if isNil "_center" exitWith {
        ["Failed to get 'Center' for grid %1", _gridHashMap] call BIS_fnc_error;
    };
    _group = createGroup [X39_Insurgency_var_InsurgentSide, true];
    if isNil "_group" exitWith {
        ["Failed to create group for grid %1", _gridHashMap] call BIS_fnc_error;
    };
    private _atlCenter = [_center#0, _center#1, 0];
    private _waypoint = _group addWaypoint [_atlCenter, -1];
    _waypoint setWaypointBehaviour "AWARE";
    _waypoint setWaypointType "MOVE";
    _waypoint = _group addWaypoint [_atlCenter, -1];
    _waypoint setWaypointBehaviour "AWARE";
    _waypoint setWaypointType "SAD";
    _waypoint = _group addWaypoint [_atlCenter, -1];
    _waypoint setWaypointType "CYCLE";
    _gridHashMap set ["Group", _group];
    DEBUG_MSG1("Created Group, guarding grid %1", _atlCenter);
};



// Find free building position
private _buildingPosition = nil;
while {isNil "_buildingPosition" && count _buildings > 0} do {
    private _randomHouse = _buildings select floor random count _buildings;
    private _buildingPositions = _randomHouse buildingPos -1;
    while {isNil "_buildingPosition" && count _buildingPositions > 0} do {
        _buildingPosition = _buildingPositions select floor random count _buildingPositions;
        if ([_buildingPosition] call X39_Insurgency_fnc_IsVisibleToPlayer) then {
            _buildingPositions deleteAt (_buildingPositions find _buildingPosition);
            DEBUG_MSG2("Skipping position %1 of house %1 as IsVisibleToPlayer returned true", _buildingPosition, _randomHouse);
            _buildingPosition = nil;
        };
    };
    if isNil "_buildingPosition" then {
        _buildings deleteAt (_buildings find _randomHouse);
        DEBUG_MSG1("Skipping house %1 as all building positions returned true for IsVisibleToPlayer", _randomHouse);
    };
};
if isNil "_buildingPosition" exitWith { /* No available buildingPos */ objNull };

// Create the actual unit
private _unitClass = X39_Insurgency_var_InsurgentClassNames select floor random count X39_Insurgency_var_InsurgentClassNames;
private _unit = _group createUnit [_unitClass, _buildingPosition, [], 0, "NONE"];
_unit addEventHandler ["KILLED", { _this call X39_Insurgency_fnc_OnInsurgentKilled; }];
_unit setVariable ["X39_Insurgency_var_Grid", _gridHashMap];
_unit switchMove "AmovPpneMstpSrasWrflDnon"; // Will make any stuck unit unstuck
DEBUG_MSG3("Created unit %1 being part of group %2 at position %3", _unit, _group, _buildingPosition);
if (isNull _unit) then {
    ["Failed to create unit in group %1 at position %2", _group, _buildingPosition] call BIS_fnc_error;
};
_unit 