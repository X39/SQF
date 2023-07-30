#include "gui_teleportSelection.hpp"

class X39_Teleport_UI_TeleportView {
	idd = IDC_X39_TELEPORT_GUI_TELEPORTVIEW_IDD;
	onLoad = "uiNamespace setVariable['X39_Teleport_UI_TeleportView', _this select 0];";
	onUnload = "uiNamespace setVariable['X39_Teleport_UI_TeleportView', displayNull];";
	duration = 32000;
	fadeIn = 0;
	fadeOut = 0;
	enableSimulation = 1;

	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by X39, v1.063, #Nofyra)
		////////////////////////////////////////////////////////

		class TeleportPointsList: RscListbox
		{
			idc = IDC_X39_TELEPORT_GUI_TELEPORTVIEW_TELEPORTPOINTSLIST;
			x = 0.18125 * safezoneW + safezoneX;
			y = 0.16 * safezoneH + safezoneY;
			w = 0.6375 * safezoneW;
			h = 0.714 * safezoneH;
		};
		class RscMenuButton: RscButtonMenuOK
		{
			text = "Teleport"; //--- ToDo: Localize;
			x = 0.611562 * safezoneW + safezoneX;
			y = 0.891 * safezoneH + safezoneY;
			w = 0.207187 * safezoneW;
			h = 0.034 * safezoneH;
		};
		class RscCancelButton: RscButtonMenuCancel
		{
			x = 0.18125 * safezoneW + safezoneX;
			y = 0.891 * safezoneH + safezoneY;
			w = 0.207187 * safezoneW;
			h = 0.034 * safezoneH;
		};
		class RscStructuredText_1100: RscStructuredText
		{
			idc = IDC_X39_TELEPORT_GUI_TELEPORTVIEW_RSCSTRUCTUREDTEXT_1100;
			text = "Bitte selektiere einen Teleportpunkt"; //--- ToDo: Localize;
			x = 0.18125 * safezoneW + safezoneX;
			y = 0.075 * safezoneH + safezoneY;
			w = 0.6375 * safezoneW;
			h = 0.068 * safezoneH;
		};
		class RscRenameButton: RscButtonMenu
		{
			idc = IDC_X39_TELEPORT_GUI_TELEPORTVIEW_RSCRENAMEBUTTON;
			text = "Umbenennen"; //--- ToDo: Localize;
			x = 0.396406 * safezoneW + safezoneX;
			y = 0.891 * safezoneH + safezoneY;
			w = 0.207187 * safezoneW;
			h = 0.034 * safezoneH;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};