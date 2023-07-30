#include "..\macros.hpp"
[missionNamespace, "X39_Persistency_EH_SetState", {
    params ["_object", "_state"];
    if (_object getVariable ["X39_Teleport_var_IsTeleporter", false]) then {
        [_object] remoteExecCall ["X39_Teleport_fnc_InitializeTeleporter", 0, _object];
    };
}] call BIS_fnc_addScriptedEventHandler;