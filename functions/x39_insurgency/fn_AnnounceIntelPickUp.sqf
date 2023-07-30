/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The cache that exploded.
 *  @locality interface
 */

if !hasInterface exitWith {};

[playerSide, "HQ"] commandChat "Eine neue Information wurde ihrer Karte hinzugefügt";