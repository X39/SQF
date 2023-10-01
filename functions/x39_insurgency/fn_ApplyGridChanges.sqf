#include "macros.hpp"
/*
 *  Internal method, called once a player exits a grid.
 *  
 *  @arg 0 The player object which caused the movement.
 *  @arg 1 The grid position to apply the changes on.
 *  @arg 3 The network id of the player which caused the movement.
 *  @locality server
 */

ALLOW_SERVER_ONLY();
params ["_player", "_gridPos", "_netId"];
private _insurgency = [] call X39_Insurgency_fnc_GetServerObject;

private _hashMap = _insurgency get _gridPos;
if isNil "_hashMap" exitWith { /* Grid is not existing */ };
DEBUG_MSG2("Applying changes on grid %1 caused by player %2", _gridPos, _netId);
private _isActive = _hashMap get "IsActive";
if isNil "_isActive" exitWith { ["Failed to get 'IsActive' for grid %1", _gridPos] call BIS_fnc_error; };
if !_isActive exitWith { DEBUG_MSG1("Grid %1 is inactive", _gridPos); };

private _playerCount = _hashMap getOrDefault ["PlayerCount", 0, false];
private _activeUnitCount = _hashMap getOrDefault ["ActiveUnitCount", 0, false];
private _targetUnits = [
	(
		(_playerCount * X39_Insurgency_var_InsurgentsPerPlayer) max X39_Insurgency_var_MinInsurgentsPerGridOnPresent
	) min X39_Insurgency_var_MaxInsurgentsPerGrid, 0] select (_playerCount == 0);

private _deltaUnits = _targetUnits - _activeUnitCount;
DEBUG_MSG3("Player count: %1, Active unit count: %2, Target unit count: %3", _playerCount, _activeUnitCount, _targetUnits);
if (_deltaUnits < 0) then
{
	for "_i" from _activeUnitCount to (_targetUnits - 1) step -1 do {
		[[_hashMap, _gridPos], {
			params ["_hashMap", "_gridPos"];
			DEBUG_MSG1("Deleting unit for grid %1", _gridPos);
			private _units = _hashMap getOrDefault ["Units", [], false];
			private _lastUnit = objNull;
			{
				scopeName "LOOP_BODY";
				if (!([getPosASL _x] call X39_Insurgency_fnc_IsVisibleToPlayer)) then {
					private _index = _units find _x;
					if (_index == -1) exitWith { ["Failed to get index of unit %1 for grid %2", _lastUnit, _gridPos] call BIS_fnc_error; };
					DEBUG_MSG1("Deleting unit %1", _x);
					deleteVehicle _x;
					_units deleteAt _index;
					_lastUnit = objNull;
					breakOut "LOOP_BODY";
				};
				_lastUnit = _x;
			} forEach _units;
			if !isNull _lastUnit then {
				private _index = _units find _lastUnit;
				if (_index == -1) exitWith { ["Failed to get index of unit %1 for grid %2", _lastUnit, _gridPos] call BIS_fnc_error; };
				DEBUG_MSG1("Deleting unit %1", _lastUnit);
				deleteVehicle _lastUnit;
				_units deleteAt _index; 
			};
			_hashMap set ["Units", _units];
		}] call X39_Insurgency_fnc_PushToServerDelayedQueue;
		DEBUG_MSG1("Scheduled unit deletion for grid %1", _gridPos);
		_activeUnitCount = _activeUnitCount - 1;
	};
}
else
{
	if (_targetUnits - _activeUnitCount > 0) then {
		for "_i" from _activeUnitCount to (_targetUnits - 1) step 1 do {
			[[_hashMap, _gridPos], {
				params ["_hashMap", "_gridPos"];
				DEBUG_MSG1("Creating unit for grid %1", _gridPos);
				private _units = _hashMap getOrDefault ["Units", [], false];
				if !(_hashMap getOrDefault ["IsActive", false]) exitWith {
					DEBUG_MSG1("Grid %1 is inactive", _gridPos);
				};
				scopeName "LOOP_BODY";
				private _unit = [_hashMap] call X39_Insurgency_fnc_CreateInsurgent;
				if (isNull _unit) then {
					DEBUG_MSG1("Failed to create unit for grid %1", _gridPos);
					breakOut "LOOP_BODY";
				};
				_units pushBack _unit;
				DEBUG_MSG1("Created unit %1", _unit);
				_hashMap set ["Units", _units];
			}] call X39_Insurgency_fnc_PushToServerDelayedQueue;
			DEBUG_MSG1("Scheduled unit creation for grid %1", _gridPos);
			_activeUnitCount = _activeUnitCount + 1;
		};
	};
};
_hashMap set ["PlayerCount", _playerCount];
_hashMap set ["TargetUnits", _targetUnits];
_hashMap set ["ActiveUnitCount", _activeUnitCount];