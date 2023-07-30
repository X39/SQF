/*
    Initializes an object for the arma3 cargo system.
    
    _self - The vehicle object to make "cargoable".
    _actionText - Optional custom text. Defaults to orange text in german.
*/

params [
    ["_self", objNull, [objNull]],
    ["_actionText", "<t color='#FFAA00'>In gewähltes Fahrzeug laden</t>"]
];
if isNull _self exitWith { ["%1: Passed in _self is null", _fnc_scriptName] call BIS_fnc_error; };
_self setVariable ["X39_Cargo_var_IsCargoObject", true];
private _condition = [{
        !isNil "X39_Cargo_var_SelectedVehicle"
        && {X39_Cargo_var_SelectedVehicle distance _target < 10}
        && {
            if (X39_Cargo_var_SelectedVehicle getVariable ["X39_Cargo_var_IsLoadableContainer", false]
                && { _target getVariable ["X39_Cargo_var_AllowLoadingIntoLoadableContainer", true] }) then {
                private _maxCargo = X39_Cargo_var_SelectedVehicle getVariable ["X39_Cargo_var_LoadableContainer_CargoMax", 0];
                private _cargo = X39_Cargo_var_SelectedVehicle getVariable ["X39_Cargo_var_LoadableContainer_Cargo", []];
                [false, true] select (count _cargo < _maxCargo)
            } else {
                X39_Cargo_var_SelectedVehicle canVehicleCargo _target select 0
            }
        }
    }] call X39_Util_fnc_CodeToString;
[
    _self,
    _actionText,
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa",
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa",
    _condition,
    _condition,
    {},
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        if (X39_Cargo_var_SelectedVehicle getVariable ["X39_Cargo_var_IsLoadableContainer", false]) then {
            private _data = [_target] call X39_Persistency_fnc_GetState;
            private _nowLoaded = X39_Cargo_var_SelectedVehicle getVariable ["X39_Cargo_var_LoadableContainer_Cargo", []];
            _nowLoaded pushBack [typeOf _target, _data];
            X39_Cargo_var_SelectedVehicle setVariable ["X39_Cargo_var_LoadableContainer_Cargo", _nowLoaded, true];
            deleteVehicle _target;
        } else {
            X39_Cargo_var_SelectedVehicle setVehicleCargo _target;
        };
    },
    {},
    [],
    getNumber (configFile >> "CfgVehicles" >> (typeOf _self) >> "mapSize"),
    10,
    false,
    true,
    true
] call BIS_fnc_holdActionAdd;