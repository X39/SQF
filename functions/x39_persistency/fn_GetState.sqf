/*
    Stores the inventory, position and everything else required to recreate that exact object in an array.
    
    _self - the object to save the state of
*/
params [
    ["_self", objNull, [objNull]]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };

private _fnc_zip = {
    params ["_left", "_right"];
    private _result = [];
    if (count _left != count _right) exitWith {
        ["%1: Failed to zip as left and right are not of the same length [%2, %3]", _fnc_scriptName, _left, _right] call BIS_fnc_error;
        []
    };
    for "_i" from 0 to count _left do {
        _result pushBack [_left select _i, _right select _i];
    };
    _result
};


private _fnc_recurseContainer = {
    params ["_container"];
    private _result = createHashMap;
    private _everyContainer = everyContainer _container;
    private _backpacks = [];
    _result set ["BACKPACKS", _backpacks];
    {
        _backpacks pushBack [_x#0, ([_x#1] call _fnc_recurseContainer)];
    } forEach (_everyContainer select { _x#0 isKindOf "Bag_Base" });
    private _uniforms = [];
    _result set ["UNIFORMS", _uniforms];
    {
        _uniforms pushBack [_x#0, ([_x#1] call _fnc_recurseContainer)];
    } forEach (_everyContainer select { _x#0 isKindOf ["Uniform_Base", configFile >> "CfgWeapons"] });
    private _vests = [];
    _result set ["VESTS", _vests];
    {
        _vests pushBack [_x#0, ([_x#1] call _fnc_recurseContainer)];
    } forEach (_everyContainer select { _x#0 isKindOf ["Vest_NoCamo_Base", configFile >> "CfgWeapons"] || {_x#0 isKindOf ["Vest_Camo_Base", configFile >> "CfgWeapons"]} });
    _result set ["WEAPONS", weaponsItemsCargo _container];
    _result set ["MAGAZINES", magazinesAmmoCargo _container];
    
    _result set ["ITEMS", (getItemCargo _container call _fnc_zip) select {
        !((_x#0 isKindOf ["Uniform_Base", configFile >> "CfgWeapons"]) || {_x#0 isKindOf ["Vest_NoCamo_Base", configFile >> "CfgWeapons"]} || {_x#0 isKindOf ["Vest_Camo_Base", configFile >> "CfgWeapons"]})
    }];
    _result
};

private _result = [_self] call _fnc_recurseContainer;
_result set ["POSITION_WORLD", getPosWorld _self];
_result set ["VECTOR_UP", vectorUp _self];
_result set ["VECTOR_DIR", vectorDir _self];
_result set ["DAMAGE", damage _self];
_result set ["HIT_POINT_DAMAGE", getAllHitPointsDamage _self call { if (count _this == 0) exitWith {}; [_this#0, _this#2] call _fnc_zip }];
_result set ["VARIABLES", allVariables _self apply { [_x, _self getVariable _x] }];

[missionNamespace, "X39_Persistency_EH_GetState", [_self, _result]] call BIS_fnc_callScriptedEventHandler;
_result