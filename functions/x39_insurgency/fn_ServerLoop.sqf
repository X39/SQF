#include "macros.hpp"
ACCEPT_SERVER_ONLY();

while { true } do {
    sleep 0.001;
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
};