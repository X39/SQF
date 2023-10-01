/*
    @version 28.06.2023
    @param 0 The auto-respawn object.
    @param 1 The minimum distance prior to respawning.
    @param 2 An optional script to execute for the vehicles spawned.
*/
if !isServer exitWith { /* Server only */ };
params [
    ["_vehicle", objNull, [objNull]],
    ["_minDistance", 200, [0]],
    ["_initScript", nil, [{}]]
];
if isNull _vehicle exitWith {
    ["%1 was passed a null object for _vehicle (0) parameter", _fnc_scriptName] call BIS_fnc_error;
};
if (_minDistance < (boundingBox _vehicle select 2)) exitWith {
    ["%1 was passed a _minDistance (1) parameter that is smaller then the bounding box diameter", _fnc_scriptName] call BIS_fnc_error;
};


[
    _vehicle,
    _minDistance,
    _initScript,
    getPosASL _vehicle,
    direction _vehicle,
    typeOf _vehicle
] spawn {
    params ["_vehicle", "_minDistance", "_initScript", "_position", "_direction", "_className"];
    while {true} do
    {
        waitUntil
        {
            sleep 1;
            isNull _vehicle || { getPosASL _vehicle distance _position > _minDistance }
        };
        isNil
        {
            _vehicle = createVehicle [_className, [0, 0, 10000]];
            _vehicle allowDamage false;
            _vehicle setDir _direction;
            _vehicle setPosASL _position;
            _vehicle allowDamage true;
            if !isNil "_initScript" then
            {
                [_vehicle, _initScript] remoteExecCall ["call", 0, _vehicle];
            };
        };
    };
}