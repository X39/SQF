#include "macros.hpp"

params ["_positionToCheck"];
private _res = {
    private _positionPlayer = getPosASL _x;
    private _distance = _positionToCheck distance _positionPlayer;
    if (_distance < X39_Insurgency_var_MinSpawnDistance) exitWith { true };
    if (_distance < X39_Insurgency_var_MaxSpawnDistance && count lineIntersectsObjs [_positionToCheck, _positionPlayer, objNull, objNull, false, 4 + 16 + 8] != 0) exitWith { true };
    if (_distance < X39_Insurgency_var_MaxSpawnDistance && count lineIntersectsObjs [_positionToCheck vectorAdd [0, 0, 1], _positionPlayer vectorAdd [0, 0, 1], objNull, objNull, false, 4 + 16 + 8] != 0) exitWith { true };
    false
} forEach allPlayers;
_res