#if defined _classes_system_included
 #endinput
#endif
#define _classes_system_included

#define MAX_CLASS_NAME_LENGTH			128

/**
 *	Called once core loaded.
 *	-
 * @noparams
 *	-
 * @noreturn
*/
forward void CSC_OnCoreStarted();

/**
 *	Called once player try to change class.
 *	-
 * @param iClient			Client index.
 * @param sOldClass			Old class.
 * @param sNewClass			New class.
 *	-
 * @return					Plugin_Continue to allow;
 *							Plugin_Changed	to allow with changes;
 *							any other value to cancel.
*/
forward Action CSC_OnClassChange(int iClient, const char[] sOldClass, const char[] sNewClass);

/**
 *	Called once player spawned.
 *	-
 * @param iClient			Client index.
 * @param sClass			Player class.
 *	-
 * @noreturn
*/
forward void CSC_OnPlayerSpawn(int iClient, const char[] sClass);

/**
 *	Called once player choose class in main menu.
 *	-
 * @param iClient			Client index.
 * @param sClass			Class name.
 *	-
 * @return					true to allow, else false.
*/
forward bool CSC_OnMenuSelectClass(int iClient, const char[] sClass);


/**
 *	Called once player choose class in main menu.
 *	-
 * @param iClient			Client index.
 * @param sClass			Class name.
 *	-
 * @return					true to allow, else false.
*/
forward bool CSC_OnMenuDisplayClass(int iClient, const char[] sClass);


/**
 *	Called once class drawed in main menu to player.
 *	-
 * @param iClient			Client index.
 * @param sClass			Class name.
 *	-
 * @return					ITEMDRAW_ value. ITEMDRAW_DEFAULT is default value.
*/
forward int CSC_OnMenuDrawClass(int iClient, const char[] sClass);

/**
 *	Called once player select class in menu.
 *	-
 * @param iClient			Client index.
 *	-
 * @return					true for reopen main menu.
*/
typedef ItemSelectCallback = function bool (int iClient);

/**
 *	Called once menu text displayed to player.
 *	-
 * @param iClient			Client index.
 * @param sDisplay			Display buffer.
 * @param iMaxLength		Размер буфера.
 *	-
 * @return					true for send sDisplay, false otherwise.
*/
typedef ItemDisplayCallback = function bool (int iClient, char[] sDisplay, int iMaxLength);

/**
 *	Called once menu drawed to player.
 *	-
 * @param iClient			Client index.
 * @param iStyle			Menu style.
 *	-
 * @return					ITEMDRAW_ value.
*/
typedef ItemDrawCallback = function int (int iClient, int iStyle);

/**
 *	Adds new class to core.
 *	-
 * @param sClass					Unique class name.
 * @param Item_select_callback		Callback for class select.
 * @param Item_display_callback		Callback for display item.
 * @param Item_draw_callback		Callback for item draw.
 *	-
 * @noreturn
*/
native void CSC_CreateClass(const char[] sClass, 
								ItemSelectCallback		Item_select_callback	= INVALID_FUNCTION,
								ItemDisplayCallback		Item_display_callback	= INVALID_FUNCTION,
								ItemDrawCallback		Item_draw_callback		= INVALID_FUNCTION);

/**
 *	Deletes class from core
 *	-
 * @param sClass			Class name.
 *	-
 * @noreturn
*/
native void CSC_DeleteClass(const char[] sClass);			

/**
 *	Returns whether or not core loaded.
 *	-
 * @noparam
 *	-
 * @return					true if loaded, false otherwise.
*/
native bool CSC_IsCoreStarted();

/**
 *	Returns whether or not player playing as specifig class.
 *	-
 * @param iClient			Client index.
 * @param sClass			Class name.
 *	-
 * @noreturn
*/
native bool CSC_IsPlayingAs(int iClient, const char[] sClass);

/**
 *	Gets player class.
 *	-
 * @param iClient			Client index.
 * @param sClass			Buffer for store class name.
 * @param iMaxLength		Buffer length.
 *	-
 * @return					false if invalid player, true otherwise.
*/
native bool CSC_GetPlayerClass(int iClient, char[] sClass, int iMaxLength);

/**
 *	Sets player class.
 *	-
 * @param iClient			Client index.
 * @param sClass			Class name
 *	-
 * @return					false if invalid player, true otherwise.
*/
native bool CSC_SetPlayerClass(int iClient, const char[] sClass);

/**
 *	Display main menu to player.
 *	-
 * @param iClient			Client index.
 *	-
 * @noreturn
*/
native void CSC_ShowClassesMenu(int iClient);


public SharedPlugin __pl_classes_system= 
{
	name = "classes-system",
	file = "Classes_System.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_classes_system_SetNTVOptional()
{
	MarkNativeAsOptional("CSC_IsPlayingAs");
	MarkNativeAsOptional("CSC_CreateClass");
	MarkNativeAsOptional("CSC_DeleteClass");
	MarkNativeAsOptional("CSC_IsCoreStarted");
	MarkNativeAsOptional("CSC_GetPlayerClass");
	MarkNativeAsOptional("CSC_SetPlayerClass");
	MarkNativeAsOptional("CSC_ShowClassesMenu");
}
#endif
