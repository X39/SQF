// #define DEBUG

#ifdef DEBUG
    #define DEBUG_MSG(TXT) diag_log TXT
    #define DEBUG_MSG1(TXT, ARG1) diag_log format [TXT, ARG1]
    #define DEBUG_MSG2(TXT, ARG1, ARG2) diag_log format [TXT, ARG1, ARG2]
    #define DEBUG_MSG3(TXT, ARG1, ARG2, ARG3) diag_log format [TXT, ARG1, ARG2, ARG3]
#else
    #define DEBUG_MSG(TXT)
    #define DEBUG_MSG1(TXT, ARG1)
    #define DEBUG_MSG2(TXT, ARG1, ARG2)
    #define DEBUG_MSG3(TXT, ARG1, ARG2, ARG3)
#endif

#define ACCEPT_SERVER_ONLY() if !isServer exitWith { DEBUG_MSG1("Exiting function %1 as locality only accepts server", _fnc_scriptName); }
#define ACCEPT_INTERFACE_ONLY() if !hasInterface exitWith { DEBUG_MSG1("Exiting function %1 as locality only accepts server", _fnc_scriptName); }

#define ALLOW_SERVER_ONLY() if !isServer exitWith { ["%1: isServer was expected to be true (wrong locality).", _fnc_scriptName] call BIS_fnc_error; }
#define ALLOW_INTERFACE_ONLY() if !hasInterface exitWith { ["%1: hasInterface was expected to be true (no interface).", _fnc_scriptName] call BIS_fnc_error; }

#define FORCE_SERVER_ONLY() if !isServer exitWith { _this remoteExecCall [_fnc_scriptName, 2, false]; }

#define ASSIGN_IF_NIL(VARIABLE, VALUE) if isNil #VARIABLE then { VARIABLE =VALUE; }