/*
    @version 10.01.2023
    @param 0 The spawning object.
    @param 1 The vehicles to be spawnable.
    @param 2 An optional script to execute for the vehicles spawned.
*/
params [
    ["_spawner", objNull, [objNull]],
    ["_vehicles", objNull, [[objNull]]],
    ["_initScript", nil, [{}]],
    ["_clearance", -1, [0]]
];
if isNull _spawner exitWith {
    ["%1 was passed a null object for _spawner (0) parameter", _fnc_scriptName] call BIS_fnc_error;
};
if ({ !isNull _x } count _vehicles == 0) exitWith {
    ["%1 was passed an empty or null array for _vehicles (1) parameter", _fnc_scriptName] call BIS_fnc_error;
};

private _spawnable = [];

{
    private _diameter = if (_clearance >= 0) then [{_clearance}, {boundingBox _x select 2}];
    _spawnable pushBack [
        typeOf _x,                  // 0 - ClassName
        position _x,                // 1 - Vehicle Position
        direction _x,               // 2 - Vehicle Direction
        _diameter,                  // 3 - Vehicle Diameter (space needed)
        _initScript                 // 4 - Init script variable
    ];
    if isServer then
    { // We only do this on the server as everything is kept client-side
        _x allowDamage false;
        _x enableSimulation false;
        _x setPos [0,0,10000];
    }
} foreach _vehicles;

{
    _spawner addAction [
        format ["%1 Erschaffen", getText (configFile >> "CfgVehicles" >> _x # 0 >> "displayName")], // ToDo: Localize
        {
            _this # 3 params ["_className", "_position", "_direction", "_diameter", "_initScript"];
            private _nearest = nearestObject _position;
            if (_nearest distance _position <= _diameter) then
            {
                hint "Spawnbereich nicht frei"; // ToDo: Localize
            }
            else
            {
                isNil { // Force non-scheduled
                    private _veh = createVehicle [
                        _className,
                        _position
                    ];
                    _veh setDir _direction;
                    if !isNil "_initScript" then
                    {
                        [_veh, _initScript] remoteExecCall ["call", 0, _veh];
                    };
                }
            }
        },
        _x
    ];
} foreach _spawnable;