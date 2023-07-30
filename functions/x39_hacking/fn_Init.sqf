if isNil "X39_Hacking_var_ActiveHacks" then { X39_Hacking_var_ActiveHacks = []; };

{
    _x call X39_Hacking_fnc_StartHackProgress;
} forEach X39_Hacking_var_ActiveHacks;