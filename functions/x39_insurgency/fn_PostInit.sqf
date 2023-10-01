#include "macros.hpp"

X39_Insurgency_var_ObjectiveClassNames = ["Box_FIA_Wps_F"];
X39_Insurgency_var_ObjectiveMinExplosionDamage = 8;
X39_Insurgency_var_Distances = [
    [50,25],
    [100,50],
    [150,100],
    [200,150],
    [300,200],
    [400,300],
    [500,400],
    [600,500],
    [750,500],
    [1000,750]
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
X39_Insurgency_var_InsurgentClassNames = [
        "I_C_Soldier_Bandit_1_F",
        "I_C_Soldier_Bandit_2_F",
        "I_C_Soldier_Bandit_3_F",
        "I_C_Soldier_Bandit_4_F",
        "I_C_Soldier_Bandit_5_F",
        "I_C_Soldier_Bandit_6_F",
        "I_C_Soldier_Bandit_7_F",
        "I_C_Soldier_Bandit_8_F"
];
X39_Insurgency_var_MaxSpawnDistance = 300;
X39_Insurgency_var_IntelDropChance = 0.25;
X39_Insurgency_var_InsurgentsPerPlayer = 1.5;
X39_Insurgency_var_MinInsurgentsPerGridOnPresent = 2;
X39_Insurgency_var_MaxInsurgentsPerGrid = 5;
X39_Insurgency_var_MaxSpeedToRegisterGridChangeInKmh = 30;
X39_Insurgency_var_InsurgentSide = independent;
X39_Insurgency_var_ServerDelayedQueue = [];
X39_Insurgency_var_ServerDelayedDelay = 0.25;

if (isServer) then {
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


if (hasInterface) then {

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