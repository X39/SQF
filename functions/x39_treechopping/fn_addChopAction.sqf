/*
    Adds the chop action to the playable unit.
    
    _self - The vehicle object to make "cargoable".
    _actionText - Optional custom text. Defaults to orange text in german.
*/

params ["_playableUnit"];
if (_playableUnit getVariable ["X39_TreeChopping_var_ChopActionAdded", objNull] isEqualTo _playableUnit) exitWith {
    ["%1: Passed in _playableUnit was already added a chop action to", _fnc_scriptName] call BIS_fnc_error;
};

[
    _playableUnit,
    "Fällen",
    "", // "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",
    "", // "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",
    "call { private _target = cursorObject; alive _target && {private _modelPath = getModelInfo _target select 1; _modelPath find ""\tree\"" != -1 || { _modelPath find ""\bush\"" != -1 } } && {private _pos = (aimPos _target); _pos set [2, 0]; _pos distance player < 3} }",
    "private _obj = _caller getVariable ""X39_TreeChopping_var_TreeToChop""; !isNull _obj && { alive _obj }",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _caller setVariable ["X39_TreeChopping_var_TreeToChop", cursorObject, false];
    },
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _tree = _caller getVariable ["X39_TreeChopping_var_TreeToChop", objNull];
        if isNull _tree exitWith {};
        _caller setVariable ["X39_TreeChopping_var_TreeToChop", objNull, false];
        private _position = position _tree;
        [_position] remoteExecCall ["X39_TreeChopping_fnc_OnTreeChopped", 2, false];
        _tree setDamage [1, true, _caller, _caller];
        _tree spawn {
            sleep 5;
            [_this, true] remoteExec ["hideObjectGlobal", 2];
        };
    },
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _caller setVariable ["X39_TreeChopping_var_TreeToChop", objNull, false];
    },
    [],
    5,
    1000,
    false,
    false,
    false
] call BIS_fnc_holdActionAdd;
_playableUnit setVariable ["X39_TreeChopping_var_ChopActionAdded", _playableUnit];