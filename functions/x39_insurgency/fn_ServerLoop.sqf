#include "macros.hpp"
ACCEPT_SERVER_ONLY();

private _recaptureRemaining = serverTime + X39_Insurgency_var_RecaptureRandomTimeout;
private _ticks = 0;
while { true } do {
    sleep 0.001;
    _ticks = (_ticks mod 1000) + 1;
    DEBUG_MSG("Server loop tick");
    private _res = [] call X39_Insurgency_fnc_PopFromServerDelayedQueue;
    if !isNil "_res" then {
        isNil {
            (_res # 0) call (_res # 1);
            false
        };
    } else {
        sleep X39_Insurgency_var_ServerDelayedDelay;
    }

    if (_ticks mod 1000) then {
        if (X39_Insurgency_var_RandomRecapture && _recaptureRemaining < serverTime) then {
            scopeName "OutOfLoop";
            _recaptureRemaining = serverTime + X39_Insurgency_var_RecaptureRandomTimeout;
            {
                private _isActive = _y get "IsActive";
                if !_isActive then {
                    private _position = _x;
                    private _distanceOk = {
                        if (_x distance _position > X39_Insurgency_var_MinRecaptureDistance) exitWith { false };
                        true
                    } forEach allPlayers;
                    if _distanceOk then {
                        private _chance = random 1;
                        if (_chance < X39_Insurgency_var_RecaptureRandomChance) then {
                            _y set ["IsActive", true];
                        };
                        breakTo "OutOfLoop";
                    };
                };
            } forEach _serverObject;
        };

        if X39_Insurgency_var_AdjacentRecapture then {
            private _serverObject  = X39_Insurgency_fnc_GetServerObject;
            {
                private _isActive = _y get "IsActive";

                if (!_isActive) then {
                    private _distanceOk = {
                        if (_x distance _position > X39_Insurgency_var_MinRecaptureDistance) exitWith { false };
                        true
                    } forEach allPlayers;
                    if _distanceOk then {
                        private _adjacentFound = false;
                        scopeName "OutOfLoop";
                        // Check if any active objective is around this one
                        for "_offX" from -100 to 100 step 100 do {
                            for "_offY" from -100 to 100 step 100 do {
                                private _newKey = [_x#0 + _offX, _x#1 + _offY];
                                private _objective = _serverObject get _newKey;
                                if (!isNil "_objective" && {_objective get "IsActive"}) then {
                                    // Found an active objective
                                    _adjacentFound = true;
                                    if (_y getOrDefault ["RecaptureActive", false]) then {
                                        if (_y get "RecaptureTime" < serverTime) then {
                                            _y set ["RecaptureActive", false];
                                            _y set ["IsActive", true];
                                        };
                                    } else {
                                        _y set ["RecaptureActive", true];
                                        _y set ["RecaptureTime", serverTime + random [
                                            X39_Insurgency_var_MinAdjacentRecaptureTime,
                                            X39_Insurgency_var_MedAdjacentRecaptureTime,
                                            X39_Insurgency_var_MaxAdjacentRecaptureTime
                                        ]];
                                    };

                                    breakTo "OutOfLoop";
                                };
                            };
                        };
                        if !_adjacentFound then {
                            _y set ["RecaptureActive", false];
                        };
                    };
                };
            } forEach _serverObject;
        };
    };
};