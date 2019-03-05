void CreateForwards()
{
	g_hForward_OnPluginStart 		= 	CreateGlobalForward("CSC_OnCoreStarted",		ET_Ignore);
	g_hForward_OnClassChange 		= 	CreateGlobalForward("CSC_OnClassChange",		ET_Event, 		Param_Cell, 	Param_String, 	Param_String);
	g_hForward_OnPlayerSpawn 		= 	CreateGlobalForward("CSC_OnPlayerSpawn",		ET_Ignore, 		Param_Cell, 	Param_String);
	g_hForward_OnMenuSelectClass 	= 	CreateGlobalForward("CSC_OnMenuSelectClass", 	ET_Single, 		Param_Cell, 	Param_String);
	g_hForward_OnMenuDisplayClass 	= 	CreateGlobalForward("CSC_OnMenuDisplayClass", 	ET_Single, 		Param_Cell, 	Param_String);
	g_hForward_OnMenuDrawClass 		= 	CreateGlobalForward("CSC_OnMenuDrawClass", 		ET_Single, 		Param_Cell, 	Param_String);
}

void Forward_OnPluginStart()
{
	Call_StartForward(g_hForward_OnPluginStart);
	Call_Finish();
	g_bStarted = true;
}

void Forward_OnClassChange(int iClient, const char[] sNewClass, Action &iEvent)
{
	Call_StartForward(g_hForward_OnClassChange);
	Call_PushCell(iClient);

	char sTemporaryClass[MAX_CLASS_NAME_LENGTH];
	strcopy(sTemporaryClass, sizeof(sTemporaryClass), sNewClass);
	Call_PushStringEx(sTemporaryClass, sizeof(sTemporaryClass), SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	
	iEvent = Plugin_Continue;
	Call_Finish(iEvent);
	
	switch(iEvent)
	{
		case Plugin_Continue: 	strcopy(g_sPlayerClass[iClient], sizeof(g_sPlayerClass), sNewClass);
		case Plugin_Changed:	strcopy(g_sPlayerClass[iClient], sizeof(g_sPlayerClass), sTemporaryClass);
	}
}

void Forward_OnPlayerSpawn(int iClient)
{
	Call_StartForward(g_hForward_OnPlayerSpawn);
	Call_PushCell(iClient);
	Call_PushString(g_sPlayerClass[iClient]);
	Call_Finish();
}

bool Forward_OnMenuSelectClass(int iClient, const char[] sClass)
{
	bool bResult;
	Call_StartForward(g_hForward_OnMenuSelectClass);
	Call_PushCell(iClient);
	Call_PushString(sClass);
	Call_Finish(bResult);
	return bResult;
}

bool Forward_OnMenuDisplayClass(int iClient, char[] sClass)
{
	bool bResult;
	Call_StartForward(g_hForward_OnMenuDisplayClass);
	Call_PushCell(iClient);
	
	char sTempClass[MAX_CLASS_NAME_LENGTH+64];
	strcopy(sTempClass, sizeof(sTempClass), sClass);
	Call_PushStringEx(sTempClass, MAX_CLASS_NAME_LENGTH+64, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	
	Call_Finish(bResult);
	
	if(bResult)
	{
		strcopy(sClass, MAX_CLASS_NAME_LENGTH+64, sTempClass);
	}
}

int Forward_OnMenuDrawClass(int iClient, const char[] sClass)
{
	Call_StartForward(g_hForward_OnMenuDrawClass);
	Call_PushCell(iClient);
	Call_PushString(sClass);
	int iDraw = ITEMDRAW_DEFAULT;
	Call_Finish(iDraw);

	return iDraw;
}

