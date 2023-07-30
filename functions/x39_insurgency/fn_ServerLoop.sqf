#include "macros.hpp"
ALLOW_INTERFACE_ONLY();

private _previousGridPosition = 0;
private _previousDistanceModifier = 0;
private _previousSpeed = 0;
while { true } do {
    sleep 0.25;
    private _res = [] call X39_Insurgency_call_PopFromServerDelayedQueue;
    if !isNil "_res" then {
        (_res # 0) call (_res # 1);
    };
};