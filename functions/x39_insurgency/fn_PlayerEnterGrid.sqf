#include "macros.hpp"
/*
 *  Internal method, called once a player enters a grid.
 *  
 *  @arg 0 The player object which caused the movement.
 *  @arg 1 The grid position entered.
 *  @arg 3 The network id of the player which caused the movement.
 *  @locality server
 */

ALLOW_SERVER_ONLY();

params ["_player", "_gridPos", "_netId"];
private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;

private _hashMap = _insurgency get _gridPos;
if isNil "_hashMap" exitWith { /* Grid is not existing */ };
DEBUG_MSG2("Player %1 entered grid %2", _netId, _gridPos);
private _isActive = _hashMap get "IsActive";
if isNil "_isActive" exitWith { ["Failed to get isActive for grid %1", _gridPos] call BIS_fnc_error; };
if !_isActive exitWith { DEBUG_MSG2("Grid %1 is inactive", _gridPos); };

private _playerCount = _hashMap getOrDefault ["PlayerCount", 0, false];
_playerCount = _playerCount + 1;
_hashMap set ["PlayerCount", _playerCount];