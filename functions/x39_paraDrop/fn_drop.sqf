/*
    Performs the parachute drop for the player.

    _position: Position where the player should be dropped.
    _height: Height at which the player should be dropped.
    _triggerHeight: Height at which the parachute should be deployed.
*/

_this spawn {
    params [
        ["_position", nil, [[0,0,0]], []],
        ["_height", 1000, [0]],
        ["_triggerHeight", 300, [0]],
        ["_steerable", false, [false]]
    ];
    [0, "BLACK", 1, 1] call BIS_fnc_fadeEffect; // Needs unscheduled environment
    _position set [2, _height];
    player setPos _position;
    addMissionEventHandler ["EachFrame", {
        _thisArgs params ["_triggerHeight", "_steerable"];
        if (position player select 2 < _triggerHeight) then {
            private _parachute = createVehicle [["NonSteerable_Parachute_F", "Steerable_Parachute_F"] select _steerable, position player, [], 50, "NONE"];
            player moveInDriver _parachute;
            removeMissionEventHandler ["EachFrame", _thisEventHandler];
        };
    }, [_triggerHeight, _steerable]];
    [1, "BLACK", 1, 1] call BIS_fnc_fadeEffect; // Needs unscheduled environment
};