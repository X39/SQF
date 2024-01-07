#include "../macros.hpp"
/*
 * Description:
 *      Returns a position where the player is aiming at.
 * 
 * Parameters:
 *      [
 *          0, // SCALAR, max distance - Maximum distance to check for objects (engine limit is 5000)
 *      ]
 *
 * Return:
 *      [
 *          [0,0,0], // intersectPosASL, ARRAY, position ASL -  the actual position where line intersects surface
 *          [0,0,0], // surfaceNormal, ARRAY, vector3D - a normal to the intersected surface
 *          objNull, // intersectObject, OBJECT - the object the surface belongs to (could be proxy object) - objNull if terrain
 *          objNull, // parentObject, OBJECT - the object proxy object belongs to (not always the same as intersect object) - objNull if terrain
 *          ["", ...], // selectionNames, ARRAY; Array of Strings - Names of the intersected selections (bones). Returns [] if there is no intersection with a selection.
 *          "", // pathToBisurf, STRING - path to intersected surface properties (.bisurf) file. Returns "" if surface has no special properties. Terrain surface properties begin with #, and the surface properties are defined in CfgSurfaces. For example, if it returns #GdtVRsurface01, properties are defined in: configFile >> "CfgSurfaces" >> "GdtVRsurface01"
 *      ]
 * 
 */

params [
    ["_distance", viewDistance, [0]],
    ["_ignoreObject", objNull, [objNull]]
];

if !hasInterface exitWith { ["Must be called on player"] call BIS_fnc_error; };
if (_distance <= 0) exitWith { ["Distance must be greater than 0"] call BIS_fnc_error; };


private _origin = AGLToASL positionCameraToWorld [0, 0, 0];
private _target = AGLToASL positionCameraToWorld [0, 0, _distance];

private _default = _origin vectorAdd (_origin vectorFromTo _target vectorMultiply _distance);
private _result = lineIntersectsSurfaces [
    _origin, // begPosASL
    _target, // endPosASL
    cameraOn, // ignoreObj1
    _ignoreObject, // ignoreObj2
    true, // sortMode (true = nearest, false = farthest)
    1, // maxResults
    "VIEW", // LOD1
    "FIRE", // LOD2
    true // returnUnique
];

_result