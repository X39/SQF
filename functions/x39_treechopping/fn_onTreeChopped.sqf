#include "..\macros.hpp"
/*
    Adds the chop action to the playable unit. Should only be called once.
    
    _treePositionAGL - the position (from `position _tree`) of the tree.
*/
ALLOW_SERVER_ONLY();

params ["_treePositionAGL"];
X39_TreeChopping_var_ChoppedTrees pushBack _treePositionAGL;