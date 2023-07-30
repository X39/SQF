#include "macros.hpp"
/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The cache that exploded.
 *  @locality interface
 */

ACCEPT_INTERFACE_ONLY();

params ["_remainingObjectives"];

[playerSide, "HQ"] commandChat ["Ein Ziel wurde zerstört, verbleibend: %1", _remainingObjectives];