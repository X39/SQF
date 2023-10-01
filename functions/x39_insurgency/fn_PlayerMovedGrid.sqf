#include "macros.hpp"
/*
 *  Internal method, called once a player moves from one grid to another or when a player joins/leaves by any means including death.
 *
 *  The method computes the delta between the new and old position and updates the grids affected.
 *  
 *  @arg 0 The player object which caused the movement.
 *  @arg 1 The old grid position or nil.
 *  @arg 2 The new grid position or nil.
 *  @arg 3 The network id of the player which caused the movement.
 *  @locality server
 */

ALLOW_SERVER_ONLY();

params [
    ["_player", objNull, [objNull]],
    ["_oldGridPos", nil, [[0,0,0], nil, 0]],
    ["_newGridPos", nil, [[0,0,0], nil, 0]],
    ["_netId", nil, ["", 0]],
    ["_distanceOld", 0, [0]],
    ["_distanceNew", 0, [0]]
];
DEBUG_MSG3("Player %1 changed grid from %2 to %3", _netId, _oldGridPos, _newGridPos);

if !(_oldGridPos isEqualType []) then { _oldGridPos = nil; };
if !(_newGridPos isEqualType []) then { _newGridPos = nil; };

private _deduplicateOld = [];
private _deduplicateNew = [];
private _oldGrids = [];
private _newGrids = [];

// Given we have an old grid-pos, add it to the list of previous grid positions
if !isNil "_oldGridPos" then {
    // Calculate the grid position deltas
    for "_x" from -_distanceOld to _distanceOld step 100 do {
        for "_y" from -_distanceOld to _distanceOld step 100 do {
            private _old = [_oldGridPos # 0 * 100 + _x, _oldGridPos # 1 * 100 + _y] call X39_Insurgency_fnc_ToGridPosition;
            if !(_old in _deduplicateOld) then {
                _deduplicateOld pushBack _old;
                _oldGrids pushBack _old;
            };
        };
    };
};

// Given we have an new grid-pos, add it to the list of new grid positions
if !isNil "_newGridPos" then {
    // Calculate the grid position deltas
    for "_x" from -_distanceNew to _distanceNew step 100 do {
        for "_y" from -_distanceNew to _distanceNew step 100 do {
            private _new = [_newGridPos # 0 * 100 + _x, _newGridPos # 1 * 100 + _y] call X39_Insurgency_fnc_ToGridPosition;
            if !(_new in _deduplicateNew) then {
                _deduplicateNew pushBack _new;
                _newGrids pushBack _new;
            };
        };
    };
};

private _changedGrids = [];
{
    _changedGrids pushBack _x;
    [_player, _x, _netId] call X39_Insurgency_fnc_PlayerExitGrid;
} forEach (_oldGrids select { !(_x in _newGrids) });
{
    _changedGrids pushBack _x;
    [_player, _x, _netId] call X39_Insurgency_fnc_PlayerEnterGrid;
} forEach (_newGrids select { !(_x in _oldGrids) });


if (count _changedGrids != count (_changedGrids arrayIntersect _changedGrids)) exitWith
{
    ["Computed _changedGrids (%1) contains duplicates (old: %2, new: %3)", _changedGrids, _oldGrids, _newGrids] call BIS_fnc_error;
};

{
    [_player, _x, _netId] call X39_Insurgency_fnc_ApplyGridChanges;
} forEach _changedGrids;