/*
    Stores the inventory, position and everything else required to recreate that exact object in an array.
    
    _self - the object to save the state of
    _state - the state data generated using X39_Persistency_fnc_getState
*/
params [
    ["_self", objNull, [objNull]],
    "_state",
    ["_vectorUpOverride", nil, [nil, [0,0,0]]],
    ["_vectorDirOverride", nil, [nil, [0,0,0]]],
    ["_positionWorldOverride", nil, [nil, [0,0,0]]]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };

private _vectorUp = [_vectorUpOverride, (_state get "VECTOR_UP")] select isNil "_vectorUpOverride";
private _vectorDir = [_vectorDirOverride, (_state get "VECTOR_DIR")] select isNil "_vectorDirOverride";
private _positionWorld = [_positionWorldOverride, (_state get "POSITION_WORLD")] select isNil "_positionWorldOverride";
_self setVectorUp _vectorUp;
_self setVectorDir _vectorDir;
_self setPosWorld _positionWorld;

if isNil "_state" exitWith {};

clearWeaponCargoGlobal _self;
clearBackpackCargoGlobal _self;
clearMagazineCargoGlobal _self;
clearItemCargoGlobal _self;
_self setDamage (_state get "DAMAGE");
{
    _self setHitPointDamage [_x # 0, _x # 1, false, objNull, objNull];
} forEach (_state get "HIT_POINT_DAMAGE");
{
    _self setVariable [_x # 0, _x # 1, true];
} forEach (_state get "VARIABLES");

private _iterations = 0;
private _fnc_recurseContainer = {
    params ["_container", "_state"];
    _iterations = _iterations + 1;
    if (_iterations + 1 > 50) exitWith {};
    
    private _backpacks = _state get "BACKPACKS";
    {
        _x params ["_className", "_contents"];
        _container addBackpackCargoGlobal [_className, 1];
    } forEach _backpacks;
    private _actualBackpacks = everyContainer _container select { _x#0 isKindOf "Bag_Base" };
    if (count _actualBackpacks != count _backpacks) exitWith {
        ["%1: The number of expected backpacks (%2) is not equivalent to the number of added backpacks (%3)", _fnc_scriptName, count _backpacks, count _actualBackpacks] call BIS_fnc_error;
    };
    {
        _x params ["_className", "_contents"];
        private _backpack = _actualBackpacks select _forEachIndex;
        [_backpack#1, _contents] call _fnc_recurseContainer;
    } forEach _backpacks;
    
    
    private _uniforms = _state get "UNIFORMS";
    {
        _x params ["_className", "_contents"];
        _container addItemCargoGlobal [_className, 1];
    } forEach _uniforms;
    private _actualUniforms = everyContainer _container select { _x#0 isKindOf ["Uniform_Base", configFile >> "CfgWeapons"] };
    if (count _actualUniforms != count _uniforms) exitWith {
        ["%1: The number of expected uniforms (%2) is not equivalent to the number of added uniforms (%3)", _fnc_scriptName, count _uniforms, count _actualUniforms] call BIS_fnc_error;
    };
    {
        _x params ["_className", "_contents"];
        private _uniform = _actualUniforms select _forEachIndex;
        [_uniform#1, _contents] call _fnc_recurseContainer
    } forEach _uniforms;
    
    
    private _vests = _state get "VESTS";
    {
        _x params ["_className", "_contents"];
        _container addItemCargoGlobal [_className, 1];
    } forEach _vests;
    private _actualVests = everyContainer _container select { _x#0 isKindOf ["Vest_NoCamo_Base", configFile >> "CfgWeapons"] || {_x#0 isKindOf ["Vest_Camo_Base", configFile >> "CfgWeapons"]} };
    if (count _actualVests != count _vests) exitWith {
        ["%1: The number of expected vests (%2) is not equivalent to the number of added vests (%3)", _fnc_scriptName, count _vests, count _actualVests] call BIS_fnc_error;
    };
    {
        _x params ["_className", "_contents"];
        private _vest = _actualVests select _forEachIndex;
        [_vest#1, _contents] call _fnc_recurseContainer;
    } forEach _vests;
    
    
    {
        _container addWeaponWithAttachmentsCargoGlobal [_x, 1];
    } forEach (_state get "WEAPONS");
    {
        _container addMagazineAmmoCargo [_x#0, 1, _x#1];
    } forEach (_state get "MAGAZINES");
    {
        _container addItemCargoGlobal _x;
    } forEach (_state get "ITEMS");
};

[_self, _state] call _fnc_recurseContainer;
[missionNamespace, "X39_Persistency_EH_SetState", [_self, _state]] call BIS_fnc_callScriptedEventHandler;