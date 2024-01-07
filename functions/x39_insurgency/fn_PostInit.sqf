#include "macros.hpp"

#define INS_ASSIGN(VAR, VALUE) ASSIGN_IF_NIL(CONCAT(X39_Insurgency_var_,VAR),VALUE)
#define COMMA ,

// These two flags may be used to disable the insurgency system to a certain degree, making it possible to use the system as a framework for other missions
// or as auto-spawn system. All of theese variables can be considered to be "constants" and should not be changed during runtime (restarting the mission is required)
INS_ASSIGN(EnableInsurgencySystem, true);                       // If set to false, the insurgency system will not be enabled at all.
INS_ASSIGN(CreateMarkers, true);                                // If set to false, no markers will be created.
INS_ASSIGN(CreateIntel, true);                                  // If set to false, no intel will be created (or picked up).

if !X39_Insurgency_var_EnableInsurgencySystem exitWith {};

// Recapture
INS_ASSIGN(AdjacentRecapture, true);                            // If set to false, adjacent recapture will not be enabled. If set to true, adjacent objectives may be recaptured.
INS_ASSIGN(RandomRecapture, true);                              // If set to false, random recapture will not be enabled. If set to true, a random objective may be recaptured every X seconds.
INS_ASSIGN(MinRecaptureDistance, 1000);                         // Minimum distance of any player to the objective to recapture it.
INS_ASSIGN(MinAdjacentRecaptureTime, 60 * 10);                  // Determines the minimum time (in seconds) needed to recapture an adjacent objective.
INS_ASSIGN(MedAdjacentRecaptureTime, 60 * 25);                  // Determines the medium time (in seconds) needed to recapture an adjacent objective.
INS_ASSIGN(MaxAdjacentRecaptureTime, 60 * 30);                  // Determines the maximum time (in seconds) needed to recapture an adjacent objective.
INS_ASSIGN(RecaptureRandomChance, 0.01);                        // Determines the chance of a recapture to be random (true) or based on the time (false).
INS_ASSIGN(RecaptureRandomTimeout, 300);                        // Determines the time (in seconds) needed to pass before a random recapture can happen again.

// // Random Vehicle Patrols
// ASSIGN_IF_NIL(X39_Insurgency_var_RandomPatrols, true);      // If set to false, random patrols will not be enabled. If set to true, random patrols will be enabled.
// X39_Insurgency_var_MinRandomPatrolDistance = 1000;          // Minimum distance of any player to the objective to spawn a random patrol.
// X39_Insurgency_var_MinRandomPatrolTime = 300;               // Determines the minimum time needed to spawn a random patrol.
// X39_Insurgency_var_MedRandomPatrolTime = 600;               // Determines the medium time needed to spawn a random patrol.
// X39_Insurgency_var_MaxRandomPatrolTime = 900;               // Determines the maximum time needed to spawn a random patrol.
// X39_Insurgency_var_MaxPatrolsActive = 10;                   // Determines the maximum amount of patrols that can be active at the same time.
// X39_Insurgency_var_PatrolSpawnChance = 1.0;                 // Determines the chance of a patrol to be spawned.
// X39_Insurgency_var_PatrolConfigurations = [];               // Array of patrol configurations: [[<"UNIT"|"VEHICLE">, <CLASSNAME>, <COUNT>], ...]

// // Side Objectives
// ASSIGN_IF_NIL(X39_Insurgency_var_SideObjectives, true);      // If set to false, side objectives will not be enabled. If set to true, side objectives will be enabled.
// X39_Insurgency_var_MinSideObjectiveDistance = 1000;          // Minimum distance of any player to the objective to spawn a side objective.
// X39_Insurgency_var_MinSideObjectiveTime = 300;               // Determines the minimum time needed to spawn a side objective.
// X39_Insurgency_var_MedSideObjectiveTime = 600;               // Determines the medium time needed to spawn a side objective.
// X39_Insurgency_var_MaxSideObjectiveTime = 900;               // Determines the maximum time needed to spawn a side objective.
// X39_Insurgency_var_MaxSideObjectivesActive = 2;              // Determines the maximum amount of side objectives that can be active at the same time.
// X39_Insurgency_var_SideObjectiveSpawnChance = 0.25;          // Determines the chance of a side objective to be spawned.
// X39_Insurgency_var_SideObjectiveMarkers = [];                // The markers containing the side objectives. The markers will be deleted once the side objectives are gathered.
//                                                              // If the markers text (not name!) is "KEEP_POSITION", the side objective will always be spawned at the marker position.
//                                                              // If the marker is not existing, the entry will be ignored and no error will be thrown.

// Configuration
X39_Insurgency_var_ObjectiveClassNames = ["Box_FIA_Wps_F"];
X39_Insurgency_var_ObjectiveMinExplosionDamage = 8;
X39_Insurgency_var_Distances = [                                // Distances array, where the first distance is the smallest and the last distance is the largest.
    [50,25],                                                    // The first value is the distance in meters, the second value is the amount of randomnes (<) in meters
    [100,25],                                                   // (e.g. 50,25 means that the distance will be between 25 and 50 meters)
    [150,50],
    [200,50],
    [300,150],
    [400,150],
    [500,150],
    [600,250],
    [750,250],
    [1000,250]
];
X39_Insurgency_var_ObjectiveCount = 10;
X39_Insurgency_var_MinBuildingPos = 2;
X39_Insurgency_var_ExcludeMarkers = ["InsurgencyExcludeMarker1"];
X39_Insurgency_var_XOffset = 0;
X39_Insurgency_var_YOffset = 0;
X39_Insurgency_var_XMarkerOffset = 0;
X39_Insurgency_var_YMarkerOffset = 0;
X39_Insurgency_var_IntelMarkerColor = "ColorBlue";
X39_Insurgency_var_IntelMarkerType = "hd_dot";
X39_Insurgency_var_IntelClassNames = ["Intel_File1_F", "Intel_File2_F"];
INS_ASSIGN(InsurgentClassNames, [\
        "I_C_Soldier_Bandit_1_F" COMMA\
        "I_C_Soldier_Bandit_2_F" COMMA\
        "I_C_Soldier_Bandit_3_F" COMMA\
        "I_C_Soldier_Bandit_4_F" COMMA\
        "I_C_Soldier_Bandit_5_F" COMMA\
        "I_C_Soldier_Bandit_6_F" COMMA\
        "I_C_Soldier_Bandit_7_F" COMMA\
        "I_C_Soldier_Bandit_8_F"\
]);
X39_Insurgency_var_MaxSpawnDistance = 300;
X39_Insurgency_var_MinSpawnDistance = 50;
X39_Insurgency_var_IntelDropChance = 0.15;
X39_Insurgency_var_InsurgentsPerPlayer = 1.5;
X39_Insurgency_var_MinInsurgentsPerGridOnPresent = 2;
X39_Insurgency_var_MaxInsurgentsPerGrid = 5;
X39_Insurgency_var_MaxSpeedToRegisterGridChangeInKmh = 30;
INS_ASSIGN(InsurgentSide, independent);
X39_Insurgency_var_ServerDelayedQueue = [];
X39_Insurgency_var_ServerDelayedDelay = 0.25;

if isServer then {
    [] call X39_Insurgency_fnc_CreateServerObject;
    [] call X39_Insurgency_fnc_CreateObjectives;

    // Remove exclude markers
    {
        deleteMarker _x;
    } forEach X39_Insurgency_var_ExcludeMarkers;

    // Handle player disconnect
    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        private _netId = _unit getVariable "X39_var_InsurgencyNetId";
        private _gridPos = position _unit call X39_Insurgency_fnc_ToGridPosition;
        [_unit, _gridPos, 0, _netId] call X39_Insurgency_fnc_PlayerMovedGrid;
        false;
    }];
    X39_Insurgency_var_ServerLoop = [] spawn X39_Insurgency_fnc_ServerLoop;
    [] spawn {
        while {true} do {
            sleep 60;
            if (scriptDone X39_Insurgency_var_ServerLoop) then {
                diag_log "INSURGENCY PLAYER LOOP DIED, RESTARTING... Please report this to the developer with this RPT log!";
                X39_Insurgency_var_ServerLoop = [] spawn X39_Insurgency_fnc_ServerLoop;
            };
        }
    };
};


if hasInterface then {

    // Remove exclude markers
    {
        deleteMarker _x;
    } forEach X39_Insurgency_var_ExcludeMarkers;
    X39_Insurgency_var_PlayerLoop = [] spawn X39_Insurgency_fnc_PlayerLoop;
    [] spawn {
        while {true} do {
            sleep 60;
            if (scriptDone X39_Insurgency_var_PlayerLoop) then {
                diag_log "INSURGENCY PLAYER LOOP DIED, RESTARTING... Please report this to the developer with this RPT log!";
                X39_Insurgency_var_PlayerLoop = [] spawn X39_Insurgency_fnc_PlayerLoop;
            };
        }
    };
};