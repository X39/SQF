#include "../macros.hpp"
#define DIK_Q 0x10
#define DIK_E 0x12

/*
 * Description:
 *      Returns a position where the player is aiming at.
 * 
 * Parameters:
 *      [
 *          "", // STRING, _className - The class name of the object to be placed
 *      ]
 *
 * Return:
 *      [
 *          [0,0,0], // ARRAY, 3D position ATL - The position where the object is desired to be placed
 *          [0,0,0], // ARRAY, 3D vector - The up vector where the object is desired to be placed
 *          [0,0,0] // ARRAY, 3D vector - The direction vector where the object is desired to be placed
 *      ]
 * 
 */

params [
    ["_className", "", [""]]
];

if !isNil "X39_Util_var_AimSelectLocationForObject_HashMap" exitWith {["This function is already running"] call BIS_fnc_error;};

X39_Util_var_AimSelectLocationForObject_HashMap = createHashMap;
private _localVehicle = _className createVehicleLocal [0,0,0];
_localVehicle enableSimulation false;
_localVehicle setVariable ["Z-Offset", 0];
_localVehicle setVariable ["UP-Offset", vectorUp _localVehicle];
_localVehicle setVariable ["DIR-Offset", vectorDir _localVehicle];
X39_Util_var_AimSelectLocationForObject_HashMap set ["LocalVehicle", _localVehicle];
X39_Util_var_AimSelectLocationForObject_HashMap set ["EHEachFrame", addMissionEventHandler ["EachFrame", {
    private _localVehicle = X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle";
    private _aimPositionResult = [nil, _localVehicle] call X39_Util_fnc_GetPlayerAimPosition;
    if (count _aimPositionResult == 0) exitWith {};
    _aimPositionResult = _aimPositionResult select 0;
    
    private _posASL = _aimPositionResult#0;
    _posASL = _posASL vectorAdd [0, 0, _localVehicle getVariable "Z-Offset"];
    _localVehicle setPosASL _posASL;

    private _vectorUp = _aimPositionResult#1;
    _vectorUp = _vectorUp vectorAdd (_localVehicle getVariable "UP-Offset");
    _localVehicle setVectorUp _vectorUp;

    private _vectorDir = _localVehicle getVariable "DIR-Offset";
    _localVehicle setVectorDir _vectorDir;
}]];

// KeyDown EH
X39_Util_var_AimSelectLocationForObject_HashMap set ["EHKeyDown", findDisplay 46 displayAddEventHandler ["KeyDown", {
	params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    if (_key == DIK_Q) then { // Rotate left (yaw)
        private _coef = [[0.01, 0.1] select _ctrl, [0.1, 1] select _ctrl] select _shift;
        private _localVehicle = X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle";
        _localVehicle setVariable ["DIR-Offset", (_localVehicle getVariable "DIR-Offset") vectorAdd [0, _coef, 0]];
    };
    if (_key == DIK_E) then { // Rotate right (yaw)
        private _coef = [[0.01, 0.1] select _ctrl, [0.1, 1] select _ctrl] select _shift;
        private _localVehicle = X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle";
        _localVehicle setVariable ["DIR-Offset", (_localVehicle getVariable "DIR-Offset") vectorAdd [0, -_coef, 0]];
    };
}]];

// mouseZChanged EH
X39_Util_var_AimSelectLocationForObject_HashMap set ["EHMouseZChanged", findDisplay 46 displayAddEventHandler ["MouseZChanged", {
    params ["_displayOrControl", "_z", "_shift", "_ctrl", "_alt"];
    private _coef = [[0.01, 0.1] select _ctrl, [0.1, 1] select _ctrl] select _shift;
    private _localVehicle = X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle";
    _localVehicle setVariable ["Z-Offset", (_localVehicle getVariable "Z-Offset") + (_z * _coef)];
}]];

// mouseButtonClick EH
X39_Util_var_AimSelectLocationForObject_HashMap set ["EHMouseClick", findDisplay 46 displayAddEventHandler ["MouseButtonDown", {
    params ["_displayOrControl", "_button", "_shift", "_ctrl", "_alt"];
    if (_button == 0) then {
        private _localVehicle = X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle";
        private _vectorUp = vectorUp _localVehicle;
        private _vectorDir = vectorDir _localVehicle;
        private _positionASL = getPosASL _localVehicle;
        private _className = typeOf _localVehicle;
        deleteVehicle _localVehicle;
        private _actual = createVehicle [_className, _positionASL, [], 0, "NONE"];
        _actual setVectorUp _vectorUp;
        _actual setVectorDir _vectorDir;
        _actual setPosASL _positionASL;
    };
    deleteVehicle (X39_Util_var_AimSelectLocationForObject_HashMap get "LocalVehicle");
    removeMissionEventHandler ["EachFrame", (X39_Util_var_AimSelectLocationForObject_HashMap get "EHEachFrame")];
    findDisplay 46 displayRemoveEventHandler ["KeyDown", (X39_Util_var_AimSelectLocationForObject_HashMap get "EHKeyDown")];
    findDisplay 46 displayRemoveEventHandler ["MouseZChanged", (X39_Util_var_AimSelectLocationForObject_HashMap get "EHMouseZChanged")];
    findDisplay 46 displayRemoveEventHandler ["MouseButtonDown", (X39_Util_var_AimSelectLocationForObject_HashMap get "EHMouseClick")];
    X39_Util_var_AimSelectLocationForObject_HashMap = nil;
}]];