#include "gui_loadableContainer.hpp"

class X39_Cargo_UI_LoadableContainer {
	idd = IDC_X39_CARGO_GUI_LOADABLECONTAINER_IDD;
	onLoad = "uiNamespace setVariable['X39_Cargo_UI_LoadableContainer', _this select 0];";
	onUnload = "uiNamespace setVariable['X39_Cargo_UI_LoadableContainer', displayNull];";
	duration = 32000;
	fadeIn = 0;
	fadeOut = 0;
	enableSimulation = 1;

	class controls
	{
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by X39, v1.063, #Dobica)
		////////////////////////////////////////////////////////
		class RscListBox_CargoList: RscListbox
		{
			idc = IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCLISTBOX_CARGOLIST;
			x = 0.190625 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.61875 * safezoneW;
			h = 0.418 * safezoneH;
		};
		class RscButton_Unload: RscButton
		{
			idc = IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCBUTTON_UNLOAD;
			text = "Entladen"; //--- ToDo: Localize;
			x = 0.515469 * safezoneW + safezoneX;
			y = 0.731 * safezoneH + safezoneY;
			w = 0.293906 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class RscButton_Abort: RscButton
		{
			idc = IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCBUTTON_ABORT;
			text = "Abbrechen"; //--- ToDo: Localize;
			x = 0.190625 * safezoneW + safezoneX;
			y = 0.731 * safezoneH + safezoneY;
			w = 0.293906 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class RscStructuredText_NameAndSpaceDisplay: RscStructuredText
		{
			idc = IDC_X39_CARGO_GUI_LOADABLECONTAINER_RSCSTRUCTUREDTEXT_NAMEANDSPACEDISPLAY;
			text = "RscStructuredText_NameAndSpaceDisplay"; //--- ToDo: Localize;
			x = 0.190625 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.61875 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.3};
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////

	};
};