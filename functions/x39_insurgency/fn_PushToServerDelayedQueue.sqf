#include "macros.hpp"
/*
 *  Allows to push something to the delayed server queue, allowing to slow eg. spawning process of units.
 *  
 *  @arg 0 Arguments to pass into _this for arg 1.
 *  @arg 1 The code to execute.
 *  @locality server
 */
ALLOW_SERVER_ONLY();
params [
	"_args",
	["_code", {}, [{}]]
];
X39_Insurgency_var_ServerDelayedQueue pushBack [_args, _code];