/*
    Reload the mission state from profileNamespace.
*/
params [
    ["_identifier", missionNameSource, [""]]
];

private _hashMap = profileNamespace getVariable ["X39_Persistency_var_MissionData@" + _identifier, createHashMap];
[missionNamespace, "X39_Persistency_EH_LoadState", [_hashMap]] call BIS_fnc_callScriptedEventHandler;
private _data = _hashMap getOrDefault ["X39_Persistency_Data", []];

{
    private _vehicle = [0, 0, 1000] createVehicle (_x # 0);
    [_vehicle, _x # 1] call X39_Persistency_fnc_SetState;
} forEach _data;