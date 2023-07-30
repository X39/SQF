#include "gui_teleportRename.hpp"

class X39_Teleport_UI_TeleportRename {
	idd = IDC_X39_TELEPORT_GUI_TELEPORTRENAME_IDD;
	onLoad = "uiNamespace setVariable['X39_Teleport_UI_TeleportRename', _this select 0];";
	onUnload = "uiNamespace setVariable['X39_Teleport_UI_TeleportRename', displayNull];";
	duration = 32000;
	fadeIn = 0;
	fadeOut = 0;
	enableSimulation = 1;

	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by X39, v1.063, #Jefexo)
		////////////////////////////////////////////////////////

		class RscMenuButton: RscButtonMenuOK
		{
			text = "Umbenennen"; //--- ToDo: Localize;
			x = 0.611577 * safezoneW + safezoneX;
			y = 0.448998 * safezoneH + safezoneY;
			w = 0.207213 * safezoneW;
			h = 0.0340013 * safezoneH;
		};
		class RscCancelButton: RscButtonMenuCancel
		{
			x = 0.181209 * safezoneW + safezoneX;
			y = 0.448998 * safezoneH + safezoneY;
			w = 0.207213 * safezoneW;
			h = 0.0340013 * safezoneH;
		};
		class IGUIBack_2200: IGUIBack
		{
			idc = IDC_X39_TELEPORT_GUI_TELEPORTRENAME_IGUIBACK_2200;
			x = 0.181209 * safezoneW + safezoneX;
			y = 0.346994 * safezoneH + safezoneY;
			w = 0.637581 * safezoneW;
			h = 0.0850033 * safezoneH;
		};
		class RscTextBox: RscEdit
		{
			idc = IDC_X39_TELEPORT_GUI_TELEPORTRENAME_RSCTEXTBOX;
			x = 0.181209 * safezoneW + safezoneX;
			y = 0.346994 * safezoneH + safezoneY;
			w = 0.637581 * safezoneW;
			h = 0.0850033 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};