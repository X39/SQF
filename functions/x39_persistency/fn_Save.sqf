/*
    Stores the current state to the profileNameSpace.
    Takes the vehicles of the given area for persistence.
    
    _identifier - The identifier of the state.
    _ignoreMarkers - A list of markers, marking the areas to ignore in persistency
*/
params [
    ["_identifier", missionNameSource, [""]],
    ["_ignoreMarkers", [], [[]]]
];
if ({_x isEqualType ""} count _ignoreMarkers != count _ignoreMarkers) exitWith { ["%1: Passed in _ignoreMarkers is not exclusively containing markers", _fnc_scriptName] call BIS_fnc_error; };


private _data = [];
{
    private _vehicleClass = typeOf _x;
    private _payload = [_x] call X39_Persistency_fnc_GetState;
    _data pushBack [_vehicleClass, _payload];
} forEach (((8 + 16) allObjects (1 + 4)) select { private _obj = _x; (!isPlayer _obj) && { _ignoreMarkers findIf { _obj inArea _x } == -1 } });


private _stateHashMap = createHashMap;
_stateHashMap set ["X39_Persistency_Data", _data];
[missionNamespace, "X39_Persistency_EH_SaveState", [_stateHashMap]] call BIS_fnc_callScriptedEventHandler;


profileNamespace setVariable ["X39_Persistency_var_MissionData@" + _identifier, _stateHashMap];
saveProfileNamespace;