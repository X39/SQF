#include "macros.hpp"
ALLOW_INTERFACE_ONLY();

private _previousGridPosition = 0;
private _previousDistanceModifier = 0;
private _previousSpeed = 0;
while { true } do {
    sleep 1;
    private _player = player;
    if (
        !isNil "_player"
        && {!isNull _player}
        && {speed vehicle _player < X39_Insurgency_var_MaxSpeedToRegisterGridChangeInKmh} // Prevent fast-moving objects from spawning in thousands of objects
    ) then {
        // Preparations
        private _speed = abs speed vehicle player;
        private _distanceModifier = 1 / (0.1 * _speed + 1);
        private _netId = _player call BIS_fnc_NetId;
        private _currentPlayerNetId = _player getVariable ["X39_Insurgency_var_NetId", -1];
        if (_currentPlayerNetId IsNotEqualTo _netId) then { _player setVariable ["X39_Insurgency_var_NetId", _netId, true]; };
        private _gridPos = position _player call X39_Insurgency_fnc_ToGridPosition;

        // Handle grid-changes
        if (
            isNil "_previousGridPosition"
            || { _gridPos isNotEqualTo _previousGridPosition}
        ) then {
            [
                _player,
                _previousGridPosition,
                _gridPos,
                _netId,
                X39_Insurgency_var_MaxSpawnDistance * _previousDistanceModifier,
                X39_Insurgency_var_MaxSpawnDistance * _distanceModifier
            ] remoteExecCall ["X39_Insurgency_fnc_PlayerMovedGrid", 2];
            _previousGridPosition = _gridPos;
            _previousDistanceModifier = _distanceModifier;
        };
        _previousSpeed = _speed;

        // Handle intel pickup
        {
            if (_x getVariable ["X39_Insurgency_var_IsIntel", true]) then {
                [_x] remoteExecCall ["X39_Insurgency_fnc_OnIntelPickedUp", 2];
            }
        } forEach nearestObjects [_player, X39_Insurgency_var_IntelClassNames, 5];
    };
};