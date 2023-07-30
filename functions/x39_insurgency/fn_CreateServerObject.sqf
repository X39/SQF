#include "macros.hpp";
/*
 *  Internal method, called once intel was picked up.
 *  Adds Intel to the map for the closest active objective.
 *  
 *  @arg 0 The intel object.
 *  @locality server
 */

ACCEPT_SERVER_ONLY();
private _centerAxis = worldSize / 2;
private _center = [_centerAxis, _centerAxis, 0];
private _houses = nearestTerrainObjects [_center, ["House"], 200000] select {count (_x buildingPos -1) >= X39_Insurgency_var_minBuildingPos};
// private _houses = (1 allObjects 0) select { _x isKindOf "House" && { count (_x buildingPos -1) >= X39_Insurgency_var_minBuildingPos } };
X39_Insurgency_var_ServerGrid = createHashMap;
{
    private _pos = position _x;
    if (X39_Insurgency_var_ExcludeMarkers findIf { _pos inArea _x } == -1) then {
        private _hashKey = _pos call X39_Insurgency_fnc_ToGridPosition;
        private _hashMap = X39_Insurgency_var_ServerGrid get _hashKey;
        if isNil "_hashMap" then {
            _hashMap = createHashMap;
            X39_Insurgency_var_ServerGrid set [_hashKey, _hashMap];
            _hashMap set ["Grid", _hashKey];
            _hashMap set ["IsActive", true];
            _hashMap set ["Buildings", []];
            
            private _markerName = format ["X39_Insurgency_grid_%1", _hashKey];
            private _center = [floor (_pos # 0 / 100) * 100 + 50 + X39_Insurgency_var_XMarkerOffset, floor (_pos # 1 / 100) * 100 + 50 + X39_Insurgency_var_YMarkerOffset];
            _hashMap set ["Center", _center];
            createMarker [_markerName, _center]; 
            _markerName setMarkerShape "RECTANGLE"; 
            _markerName setMarkerSize [50, 50];
            _markerName setMarkerColor "ColorRed"; 
            _hashMap set ["Marker", _markerName, true];
        };
        private _buildings = _hashMap getOrDefault ["Buildings", [], true];
        _buildings pushBack _x;
    };
} forEach _houses;

{
    private _buildings = _y getOrDefault ["Buildings", [], true];
    private _buildingPosTotal = 0;
    {
        _buildingPosTotal = _buildingPosTotal + count (_x buildingPos -1);
    } forEach _buildings;
    _y set ["buildingPositionsCount", _buildingPosTotal];
} forEach X39_Insurgency_var_ServerGrid;