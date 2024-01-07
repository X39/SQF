/*
 * Adds the paradrop action to the object
 */
params [
    ["_obj", objNull, [objNull]],
    ["_text", "Paradrop", [""]],
    ["_radius", 1.5, [1.5]],
    ["_condition", {true}, [{}]],
    ["_disableCondition", {count allPlayers >= 12}, [{}]],
    ["_disableConditionText", "Mehr als 12 Spieler vorhanden", [""]]
];
_obj addAction [
    _text,
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_disableCondition", "_disableConditionText"];
        if call _disableCondition then {
            hint _disableConditionText;
        } else {
            [] call X39_ShowParaDropScreen;
        };
    },
    [_disableCondition, _disableConditionText],
    1.5,
    true,
    true,
    "",
    "vehicle player == player && " + str _condition,
    _radius
];