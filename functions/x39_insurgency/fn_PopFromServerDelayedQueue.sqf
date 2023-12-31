#include "macros.hpp"
/*
 *  Allows to push something to the delayed server queue, allowing to slow eg. spawning process of units.
 *  
 *  @arg 0 Arguments to pass into _this for arg 1.
 *  @arg 1 The code to execute.
 *  @locality server
 */
ALLOW_SERVER_ONLY();

if (count X39_Insurgency_var_ServerDelayedQueue == 0) exitWith { nil };
private _element = X39_Insurgency_var_ServerDelayedQueue select 0;
X39_Insurgency_var_ServerDelayedQueue deleteAt 0;
_element