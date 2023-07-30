/*
    Checks whether persisting the given object is allowed.
    
    _self - The object to check whether persistence is allowed.
*/

params [
    ["_self", objNull, [objNull]]
];
_self getVariable ["X39_Persistency_var_Persist", X39_Persistency_var_DefaultPersist]