#include "macros.hpp"
/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The intel object.
 *  @locality server
 */

ALLOW_SERVER_ONLY();
params ["_position", "_gridHashMap"];
private _chance = random 1;
if (_chance > X39_Insurgency_var_IntelDropChance) exitWith
{
    DEBUG_MSG3("Did not spawn intel at %1 because change %2 is above %3", _position, _chance, X39_Insurgency_var_IntelDropChance);
};

private _intelClass = X39_Insurgency_var_IntelClassNames select floor random count X39_Insurgency_var_IntelClassNames;
private _intel = createVehicle [_intelClass, _position, []];
_intel setVariable ["X39_Insurgency_var_IsIntel", true, true];
_intel setVariable ["X39_Insurgency_var_Grid", _gridHashMap];
DEBUG_MSG3("Intel was spawned at %1 because change %2 is below or equal to %3", _position, _chance, X39_Insurgency_var_IntelDropChance);