#include "..\macros.hpp"
#include "..\..\ui\x39_teleport\gui_teleportSelection.hpp"
#include "..\..\ui\x39_teleport\gui_teleportRename.hpp"
/*
    @description Allows to create a teleporter which is capable of taking objects and teleporting to them. If the object has a building position, one of those is chosen upon teleport
    @parameters
    _teleport - The teleport that is being initialized
    _targetClassNames - The class names for objects which are valid teleport targets.
    _condition - Allows to further narrow down the selection of teleport targets.
*/
params [
    ["_teleport", objNull, [objNull]],
    ["_targetClassNames", nil, [{}, nil, 0]],
    ["_condition", nil, [{}, nil, 0]]
];

if isNil "_targetClassNames" then { _targetClassNames = _teleport getVariable ["X39_Teleport_var_TargetClassNames", []]; } else { _teleport setVariable ["X39_Teleport_var_TargetClassNames", _targetClassNames]; };
if isNil "_condition" then { _condition = _teleport getVariable ["X39_Teleport_var_Condition", { true }]; } else { _teleport getVariable ["X39_Teleport_var_Condition", _condition]; };

_container addAction [
    "<t color='#55aaff'>Teleportieren</t>",
    {
        // ToDo: Implement changes
        params ["_container", "_caller", "_actionId", "_arguments"];
        private _containerDisplayName = getText (configFile >> "CfgVehicles" >> typeOf _container >> "displayName");
        private _dialog = createDialog ["X39_Cargo_UI_LoadableContainer", true];
        private _nameAndSpaceDisplay = _dialog displayCtrl IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCSTRUCTUREDTEXT_NAMEANDSPACEDISPLAY;
        private _abortButton = _dialog displayCtrl IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCBUTTON_ABORT;
        private _unloadButton = _dialog displayCtrl IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCBUTTON_UNLOAD;
        private _listBox = _dialog displayCtrl IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCLISTBOX_CARGOLIST;
        
        _nameAndSpaceDisplay ctrlSetStructuredText parseText _containerDisplayName;
        _abortButton ctrlAddEventHandler ["ButtonClick", { closeDialog 2; }];
        _unloadButton ctrlAddEventHandler ["ButtonClick", {
            params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
            private _container = _control getVariable "_container";
            private _dialog = ctrlParent _control;
            private _listBox = _dialog displayCtrl IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCLISTBOX_CARGOLIST;
            private _selectedIndex = lbCurSel _listBox;
            if (_selectedIndex == -1) exitWith {};
            
            // Remove _data
            private _nowLoaded = (_container getVariable ["X39_Cargo_var_LoadableContainer_Cargo", []]);
            private _data = _nowLoaded select _selectedIndex;
            _nowLoaded deleteAt _selectedIndex;
            _container setVariable ["X39_Cargo_var_LoadableContainer_Cargo", _nowLoaded, true];
            
            private _className = _data # 0;
            private _unpacked = _className createVehicleLocal (position player vectorAdd (vectorDir player vectorMultiply 10));
            _unpacked attachTo [player];
            private _actionsAdded = [];
            _actionsAdded pushBack (player addAction [
                "<t color='#00FF00'>Auspacken abschließen</t>",
                {
                    _this # 3 params ["_container", "_data", "_actionsAdded", "_unpacked"];
                    isNil {
                        private _vectorUp = vectorUp _unpacked;
                        private _vectorDir = vectorDir _unpacked;
                        private _positionWorld = getPosWorld _unpacked;
                        deleteVehicle _unpacked;
                        private _position = position _unpacked;
                        private _veh = createVehicle [_data#0, _position, [], 0, "CAN_COLLIDE"];
                        [_veh, _data#1, _vectorUp, _vectorDir, _positionWorld] call X39_Persistency_fnc_SetState;
                        {
                            player removeAction _x;
                        } foreach _actionsAdded;
                        nil
                    }
                },
                [_container, _data, _actionsAdded, _unpacked]
            ]);
            _actionsAdded pushBack (player addAction [
                "<t color='#FF0000'>Auspacken abbrechen</t>",
                {
                    _this # 3 params ["_container", "_data", "_actionsAdded", "_unpacked"];
                    isNil {
                        // Add _data
                        deleteVehicle _unpacked;
                        private _nowLoaded = (_container getVariable ["X39_Cargo_var_LoadableContainer_Cargo", []]);
                        _nowLoaded pushBack _data;
                        _container setVariable ["X39_Cargo_var_LoadableContainer_Cargo", _nowLoaded, true];
                        {
                            player removeAction _x;
                        } foreach _actionsAdded;
                        nil
                    }
                },
                [_container, _data, _actionsAdded, _unpacked]
            ]);
            
            closeDialog 1;
        }];
        _unloadButton setVariable ["_container", _container];
        [_container, _containerDisplayName, _listBox, _nameAndSpaceDisplay] spawn {
            params ["_container", "_containerDisplayName", "_listBox", "_nameAndSpaceDisplay"];
            private _currentLoaded = [];
            while {dialog} do {
                private _nowLoaded = (_container getVariable ["X39_Cargo_var_LoadableContainer_Cargo", []]);
                private _maxLoaded = (_container getVariable ["X39_Cargo_var_LoadableContainer_CargoMax", 0]);
                if (_nowLoaded isNotEqualTo _currentLoaded) then {
                    lbClear _listBox;
                    {
                        private _className = _x#0;
                        private _displayName = getText (configFile >> "CfgVehicles" >> _className >> "displayName");
                        private _index = _listBox lbAdd _displayName;
                    } forEach _nowLoaded;
                    _currentLoaded = +_nowLoaded;
                    private _currentLoadedCount = count _currentLoaded;
                    private _text = format [
                        "<t color='#FFAA00'>%1</t> %2(%3/%4)%5",
                        _containerDisplayName,
                        switch true do {
                            case (_currentLoadedCount >= _maxLoaded): {"<t color='#FF0000'>"};
                            case (_currentLoadedCount >= _maxLoaded / 4 * 3): {"<t color='#FFAA00'>"};
                            case (_currentLoadedCount >= _maxLoaded / 2): {"<t color='#FFFF00'>"};
                            case (_currentLoadedCount >= _maxLoaded / 4): {"<t color='#AAFF00'>"};
                            default {"<t color='#00FF00'>"};
                        },
                        _currentLoadedCount,
                        _maxLoaded,
                        "</t>"
                    ];
                    _nameAndSpaceDisplay ctrlSetStructuredText parseText _text;
                };
                sleep 0.001;
            };
        };
    },
    [_unpackable, _x],
    1.5,
    true,
    true,
    "",
    "count (_target getVariable [""X39_Cargo_var_LoadableContainer_Cargo"", []]) > 0"
];
