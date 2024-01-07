X39_CheckPoint_var_Spawner = "CHECKPOINT_SPAWNER";
X39_CheckPoint_var_SpawnRoute = ["CHECKPOINT_ROUTE_%1", 11];
X39_CheckPoint_var_Queue = ["CHECKPOINT_QUEUE_%1", 7];
X39_CheckPoint_var_LeaveRoute = ["CHECKPOINT_LEAVE_%1", 6];
X39_CheckPoint_var_DespawnRoute = ["CHECKPOINT_DESPAWN_%1", 7];
// Sign_Arrow_Green_F for dbg

// private _mCheckpointSpawner = getMarkerPos "CHECKPOINT_SPAWNER";
// [getMarkerPos "CHECKPOINT_SPAWNER", getMarkerPos "WP_4"]

// CUP_C_Golf4_yellow_Civ C_man_1


X39_CheckPoint_fnc_CreateRandomUnitAndVehicle = {
    params [
        "_position",
        "_direction",
        "_vehicleClasses",
        "_unitClasses",
        "_side"
    ];
    private _vehicle = createVehicle [selectRandom _vehicleClasses, _position, [], 0, "NONE"];
    _vehicle setDir _direction;
    private _group = createGroup _side;
    private _unit = _group createUnit [selectRandom _unitClasses, _position, [], 20, "NONE"];
    _unit moveInDriver _vehicle;
    _unit
};
X39_CheckPoint_fnc_SetDriveOnPath = {
    params [
        ["_vehicle", objNull, [objNull]],
        ["_positions", [], [[]]],
        ["_speed", nil, [0]]
    ];
    if isNull _vehicle then { ["Unit is null"] call BIS_fnc_error };
    if (count _positions == 0) then { ["No positions"] call BIS_fnc_error };
    if !(_positions isEqualTypeArray [0,0,0]) exitWith {
        ["Positions must be provided as array of positions"] call BIS_fnc_error;
    };
    private _drivePath = [[
        getPosASL _vehicle select 0,
        getPosASL _vehicle select 1,
        position _vehicle select 2
    ]];
    _drivePath append _positions;
    _drivePath append _positions # (count _positions - 1);
    {
        _pos = +_x;
        _pos set [2, 5];
        createVehicle [
            "Sign_Arrow_Green_F",
            _pos,
            [],
            0,
            "CAN_COLLIDE"
        ];
    } forEach _drivePath;
    if !isNil "_speed" then {
        if (_speed < 3) then { _speed = 3; };
        _drivePath = _drivePath select {
            private _arr = +_x;
            _arr set [3, _speed];
        };
    };
    _vehicle setDriveOnPath _drivePath;
};

X39_CheckPoint_fnc_DestinationReached = {
    params [
        ["_vehicle", objNull, [objNull]],
        ["_positions", [], [[]]],
        ["_distance", 10, [0]],
        ["_speed", nil, [0]]
    ];
    if !(_positions isEqualTypeArray [0,0,0]) then {
        _positions = _positions select count _positions - 1;
    };
    private _distanceOk = position _vehicle distance _positions < _distance;
    private _speedOk = if !isNil "_speed" then { speed _vehicle < _speed } else { true };
    _distanceOk && _speedOk
};

X39_CheckPoint_fnc_GetRoutePositions = {
    params [
        ["_markerFormat", "", [""]],
        ["_markerCount", 0, [0]]
    ];
    private _positions = [];
    for "_i" from 1 to _markerCount do {
        _positions pushBack getMarkerPos (format[_markerFormat, _i]);
    };
    _positions
};
X39_CheckPoint_fnc_SetDriveOnPathAndWaitOnDestinationReached = {
    if !canSuspend exitWith { ["Not in a suspended context"] call BIS_fnc_error };
    params [
        ["_vehicle", objNull, [objNull]],
        ["_positions", [], []],
        ["_speed", nil, [0]],
        ["_reachDistance", 10, [0]],
        ["_reachSpeed", nil, [0]]
    ];
    private _time = time;
    private _remainingPositions = +_positions;
    while {
        private _res = [
            _vehicle,
            _positions,
            _reachDistance,
            if !isNil "_reachSpeed" then { _reachSpeed } else { nil }
        ] call X39_CheckPoint_fnc_DestinationReached;
        !_res
    } do {
        {
            if ([_vehicle, _x, _reachDistance, if !isNil "_reachSpeed" then { _reachSpeed } else { nil }] call X39_CheckPoint_fnc_DestinationReached) then {
                _remainingPositions deleteAt _forEachIndex;
            };
        } forEach _remainingPositions;
        if (time - _time > 1) then {
            _time = time;
            [
                _vehicle,
                _remainingPositions,
                if !isNil "_speed" then { _speed } else { nil }
            ] call X39_CheckPoint_fnc_SetDriveOnPath;
            
        };
    };
    sleep 1;
};



[] spawn {
    private _unit = [
        getMarkerPos X39_CheckPoint_var_Spawner,
        markerDir X39_CheckPoint_var_Spawner,
        ["CUP_C_Golf4_yellow_Civ"],
        ["C_man_1"],
        civilian
    ] call X39_CheckPoint_fnc_CreateRandomUnitAndVehicle;
    _unit = vehicle _unit;
    sleep 1;
    [
        _unit,
        X39_CheckPoint_var_SpawnRoute call X39_CheckPoint_fnc_GetRoutePositions
    ] call X39_CheckPoint_fnc_SetDriveOnPathAndWaitOnDestinationReached;
    private _queuePositions = X39_CheckPoint_var_Queue call X39_CheckPoint_fnc_GetRoutePositions;
    {
        [
            _unit,
            [_x],
            5
        ] call X39_CheckPoint_fnc_SetDriveOnPathAndWaitOnDestinationReached;
    } forEach _queuePositions;
    [
        _unit,
        X39_CheckPoint_var_LeaveRoute call X39_CheckPoint_fnc_GetRoutePositions
    ] call X39_CheckPoint_fnc_SetDriveOnPathAndWaitOnDestinationReached;
    [
        _unit,
        X39_CheckPoint_var_DespawnRoute call X39_CheckPoint_fnc_GetRoutePositions
    ] call X39_CheckPoint_fnc_SetDriveOnPathAndWaitOnDestinationReached;
    private _vehicle = vehicle _unit;
    deleteVehicle _unit;
    deleteVehicle _vehicle;
};