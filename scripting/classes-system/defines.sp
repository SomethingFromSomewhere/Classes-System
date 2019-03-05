Handle 		g_hClass, 						g_hForward_OnPluginStart, 
			g_hForward_OnClassChange, 		g_hForward_OnPlayerSpawn, 
			g_hForward_OnMenuSelectClass, 	g_hForward_OnMenuDisplayClass, 
			g_hForward_OnMenuDrawClass;

Menu 		g_hMenu;
ArrayList 	g_hClasses, 					g_hSorting;
StringMap 	g_hClassesTrie;
char 		g_sPlayerClass[MAXPLAYERS+1][MAX_CLASS_NAME_LENGTH], 
			g_sNewClass[MAXPLAYERS+1][MAX_CLASS_NAME_LENGTH];

bool 		g_bRandom[MAXPLAYERS+1], 		g_bStarted;

#define	PLUGIN_HANDLE					0
//#define	SELECT_FUNCTION					9
#define	DISPLAY_ITEM_FUNCTION			18
#define	DRAW_ITEM_FUNCTION				27

#define Plugin_PrintToChat				PrintToChat