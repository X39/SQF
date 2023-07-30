#include "macros.hpp"
ALLOW_INTERFACE_ONLY();

while { true } do {
    sleep 0.1;
    private _res = [] call X39_Insurgency_call_PopFromServerDelayedQueue;
    if !isNil "_res" then {
        isNil {
            (_res # 0) call (_res # 1);
            false
        };
    };
};