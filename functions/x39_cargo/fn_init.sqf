#include "..\macros.hpp"
[missionNamespace, "X39_Persistency_EH_SetState", {
    params ["_object", "_state"];
    if (_object getVariable ["X39_Cargo_var_IsLoadableContainer", false]) then {
        [_object] remoteExecCall ["X39_Cargo_fnc_LoadableContainer", 0, _object];
    };
    if (_object getVariable ["X39_Cargo_var_IsCargoObject", false]) then {
        [_object] remoteExecCall ["X39_Cargo_fnc_InitializeCargoObject", 0, _object];
    };
    if (_object getVariable ["X39_Cargo_var_IsVehicleObject", false]) then {
        [_object] remoteExecCall ["X39_Cargo_fnc_InitializeVehicleObject", 0, _object];
    };
}] call BIS_fnc_addScriptedEventHandler;

if hasInterface then {
    X39_Cargo_var_SelectedVehicle = objNull;
};