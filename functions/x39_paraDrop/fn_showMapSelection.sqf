/*
 * Shows the map and allows the player to select a position on the map to para drop to.
 * This script will not require any input parameters.
 */

if (vehicle player != player) exitWith {};
private _arr = [];
private _mapSingleClickEh = addMissionEventHandler ["MapSingleClick", {
    params ["_units", "_pos", "_alt", "_shift"];
    _thisArgs params ["_mapSingleClickEh", "_mapEh"];
    openMap false;
    [_pos, 1000, 200] call x39_ParaDrop_fnc_Drop;
    removeMissionEventHandler ["MapSingleClick", _mapSingleClickEh];
    removeMissionEventHandler ["Map", _mapEh];
}, _arr];
_arr set [0, _mapSingleClickEh];
private _mapEh = addMissionEventHandler ["Map", {
    params ["_mapIsOpened", "_mapIsForced"];
    if _mapIsOpened exitWith {};
    _thisArgs params ["_mapSingleClickEh", "_mapEh"];
    removeMissionEventHandler ["MapSingleClick", _mapSingleClickEh];
    removeMissionEventHandler ["Map", _mapEh];
}, _arr];
_arr set [1, _mapEh];
openMap true;