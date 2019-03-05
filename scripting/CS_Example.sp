#include <classes-system>

#pragma semicolon 1
#pragma newdecls required

ArrayList g_hArray;

public Plugin myinfo =
{
	name = "[CS] Example",
	author = "Someone",
	version = "1.0",
	url = "http://hlmod.ru | https://discord.gg/UfD3dSa"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_myclass", CMD_CLASS);
	if(CSC_IsCoreStarted())
	{
		CSC_OnCoreStarted();
	}
}

public void CSC_OnCoreStarted()
{
	CSC_CreateClass("Example", SelectCallback, DisplayCallback, ItemDrawCallback);
}

public void OnPluginEnd()
{
	CSC_DeleteClass("Example");
}

public Action CMD_CLASS(int iClient, int iArgs)
{
	char sBuffer[128];
	CSC_GetPlayerClass(iClient, sBuffer, 128);
	PrintToChatAll(sBuffer);
	
	return Plugin_Handled;
}

public bool SelectCallback(int iClient)
{
	CSC_SetPlayerClass(iClient, "Example");
	PrintToChatAll("[INFO] SelectCallback"); 
	return true;
}

public bool DisplayCallback(int iClient, char[] sDisplay, int iMaxLength)
{
	FormatEx(sDisplay, iMaxLength, "Тут будет дисплеится моя хуйня");
	PrintToChat(iClient, "[INFO] DisplayCallback");
	return true;
}

public int ItemDrawCallback(int iClient, int iStyle)
{
	PrintToChat(iClient, "[INFO] ItemDrawCallback");
	return iStyle;
}

public void CSC_OnPlayerSpawn(int iClient, const char[] sClass)
{
	PrintToChat(iClient, "Your class is %s", sClass);
}