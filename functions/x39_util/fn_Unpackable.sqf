/*
    @version 10.01.2023
    @param 0 The unpackable object.
    @param 1 The class names that can be unpacked by this unpackable (0).
*/
params [
    ["_unpackable", objNull, [objNull]],
    ["_classNamesUnpackable", [], [[""]]]
];
if isNull _spawner exitWith {
    ["%1 was passed a null object for _unpackable (0) parameter", _fnc_scriptName] call BIS_fnc_error;
};

if (count _classNamesUnpackable == 0) exitWith {
    ["%1 was not passed any unpackable class names (1).", _fnc_scriptName] call BIS_fnc_error;
};
// https://github.com/X39/XInsurgency/blob/a19889986ac7a391ae09d4dcfd3f6802666ec13c/codeBase/Scripts/VehicleSpawner.sqf

{
    _unpackable addAction [
        format ["%1 auspacken", getText (configFile >> "CfgVehicles" >> _x >> "displayName")],
        {
            _this # 3 params ["_unpackable", "_className"];
            isNil {
                private _position = position _unpackable;
                _unpackable allowDamage false;
                _unpackable enableSimulation false;
                _unpackable setPos [0, 0, 0];
                private _unpacked = _className createVehicleLocal _position;
                _unpacked attachTo [player];
                private _actionsAdded = [];
                _actionsAdded pushBack (player addAction [
                    "Auspacken abschließen",
                    {
                        _this # 3 params ["_unpackable", "_unpacked", "_actionsAdded"];
                        isNil {
                            deleteVehicle _unpackable;
                            private _position = position _unpacked;
                            private _direction = direction _unpacked;
                            deleteVehicle _unpacked;
                            private _veh = createVehicle [typeof _unpacked, _position, [], 0, "CAN_COLLIDE"];
                            _veh setDir _direction;
                            _veh setPos _position;
                            [_veh, {
                                _this addAction ["Abreißen", {deleteVehicle (_this select 3)}, _this];
                            }] remoteExecCall ["call", 0, _veh];
                            {
                                player removeAction _x;
                            } foreach _actionsAdded;
                        }
                    },
                    [_unpackable, _unpacked, _actionsAdded]
                ]);
                _actionsAdded pushBack (player addAction [
                    "Auspacken abbrechen",
                    {
                        _this # 3 params ["_unpackable", "_position", "_unpacked", "_actionsAdded"];
                        isNil {
                            _unpackable setPos _position;
                            _unpackable allowDamage true;
                            _unpackable enableSimulation true;
                            deleteVehicle _unpacked;
                            {
                                player removeAction _x;
                            } foreach _actionsAdded;
                        }
                    },
                    [_unpackable, _position, _unpacked, _actionsAdded]
                ]);
            };
        },
        [_unpackable, _x]
    ];
} foreach _classNamesUnpackable;