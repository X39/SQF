#include "macros.hpp";
/*
 *  Transforms a position to a 2d grid-position.
 *  
 *  @arg 0 3d or 2d position.
 */

params ["_x", "_y"];
[floor ((_x + X39_Insurgency_var_XOffset) / 100), floor ((_y + X39_Insurgency_var_YOffset) / 100)]