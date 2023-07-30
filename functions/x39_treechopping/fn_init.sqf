if isServer then {
    X39_TreeChopping_var_ChoppedTrees = [];
    X39_TreeChopping_fnc_AddChoppedTree = {
        params ["_treePosition"];
        X39_TreeChopping_var_ChoppedTrees pushBack _treePosition;
    };
    [missionNamespace, "X39_Persistency_EH_GetWorldState", {
        params ["_state"];
        _state set ["X39_TreeChopping_var_ChoppedTrees", X39_TreeChopping_var_ChoppedTrees];
    }] call BIS_fnc_addScriptedEventHandler;
    [missionNamespace, "X39_Persistency_EH_SetWorldState", {
        params ["_state"];
        X39_TreeChopping_var_ChoppedTrees = _state getOrDefault ["X39_TreeChopping_var_ChoppedTrees", [], true];
        {
            private _objs = nearestTerrainObjects [_x, ["TREE"], 20, true, false];
            if (count _objs > 0) then {
                private _obj = _objs # 0;
                _obj hideObjectGlobal true;
            };
        } forEach X39_TreeChopping_var_ChoppedTrees;
    }] call BIS_fnc_addScriptedEventHandler;
};

if hasInterface then {
    [] spawn {
        waitUntil { sleep 0.001; !isNull player && { alive player } };
        [player] call X39_TreeChopping_fnc_AddChopAction;
        player addEventHandler ["Respawn", {
            params ["_unit", "_corpse"];
            [_unit] call X39_TreeChopping_fnc_AddChopAction;
        }];
    };
};