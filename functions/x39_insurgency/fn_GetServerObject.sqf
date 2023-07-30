#include "macros.hpp";
/*
 *  Internal method, called to receive the server-side game-mode object.
 *  
 *  @locality server
 */

ALLOW_SERVER_ONLY();

if isNil "X39_Insurgency_var_ServerGrid" then {
    ["$1: Server object is not initialized (X39_Insurgency_var_ServerGrid is nil).", _fnc_scriptName] call BIS_fnc_error;
};
X39_Insurgency_var_ServerGrid