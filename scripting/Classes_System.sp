#include <classes-system>
#include <clientprefs>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name 		=	"Classes System",
	author 		=	"Someone",
	version 	=	"1.0.0",
	description	=	"Provides simple feutures to make classes",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

#include "classes-system/defines.sp"
#include "classes-system/natives.sp"
#include "classes-system/forwards.sp"
#include "classes-system/menu.sp"
#include "classes-system/functions.sp"
#include "classes-system/hooks.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNatives();
	CreateForwards();
	
	RegPluginLibrary("classes-system");
	
	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadTranslations("classes-system.core.phrases");
	LoadTranslations("classes-system.modules.phrases");
	
	g_hClasses = new ArrayList(ByteCountToCells(MAX_CLASS_NAME_LENGTH));
	g_hClassesTrie = new StringMap();
	
	g_hMenu = new Menu(Menu_Handle, MenuAction_Select|MenuAction_Display|MenuAction_DisplayItem|MenuAction_DrawItem);
	g_hMenu.AddItem("Random", "Random");
	
	Function_LoadSortings();
	g_hClass = RegClientCookie("CSC_Class", "Player Class", CookieAccess_Protected);
	
	HookEvent("player_spawn", Hook_PlayerSpawn);
	RegConsoleCmd("sm_class", CMD_CLASS);
	
	Forward_OnPluginStart();
}

public Action CMD_CLASS(int iClient, int iArgs)
{
	Menu_DisplayClassesMenu(iClient);
	return Plugin_Handled;
}