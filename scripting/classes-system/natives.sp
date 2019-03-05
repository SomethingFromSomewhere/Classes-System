void CreateNatives()
{
	CreateNative("CSC_ShowClassesMenu",	Native_ShowClassesMenu);
	CreateNative("CSC_IsCoreStarted",	Native_IsCoreStarted);
	
	CreateNative("CSC_SetPlayerClass",	Native_SetPlayerClass);
	CreateNative("CSC_GetPlayerClass",	Native_GetPlayerClass);
	CreateNative("CSC_IsPlayingAs",		Native_IsPlayingAs);
	
	CreateNative("CSC_CreateClass",		Native_CreateClass);
	CreateNative("CSC_DeleteClass",		Native_DeleteClass);
}

public int Native_ShowClassesMenu(Handle hPlugin, int numParams)
{
	int iClient = GetNativeCell(1);
	if(IsClientInGame(iClient) && !IsFakeClient(iClient))
	{
		Menu_DisplayClassesMenu(iClient);
	}
}

public int Native_IsCoreStarted(Handle hPlugin, int numParams)
{
	return g_bStarted;
}

public int Native_SetPlayerClass(Handle hPlugin, int iClient)
{
	if(Function_IsValidClient((iClient = GetNativeCell(1))))
	{
		char sBuffer[MAX_CLASS_NAME_LENGTH];
		GetNativeString(2, sBuffer, MAX_CLASS_NAME_LENGTH);
		Function_SetClass(iClient, sBuffer);
		return true;
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[SetPlayerClass] Client index \"%i\" invalid or not in game.", iClient);
	return false;
}

public int Native_GetPlayerClass(Handle hPlugin, int iClient)
{
	if(Function_IsValidClient((iClient = GetNativeCell(1))))
	{
		if(g_sPlayerClass[iClient][0])
		{
			SetNativeString(2, g_sPlayerClass[iClient], GetNativeCell(3), true);
			return true;
		}
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[GetPlayerClass] Client index \"%i\" invalid or not in game.", iClient);
	return false;
}

public int Native_IsPlayingAs(Handle hPlugin, int iClient)
{
	if(Function_IsValidClient((iClient = GetNativeCell(1))))
	{
		char sBuffer[MAX_CLASS_NAME_LENGTH];
		GetNativeString(2, sBuffer, MAX_CLASS_NAME_LENGTH);
		if(!strcmp(sBuffer, g_sPlayerClass[iClient]))	return true;
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[IsPlayingAs] Client index \"%i\" invalid or not in game.", iClient);
	return false;
}

public int Native_CreateClass(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_CLASS_NAME_LENGTH);
	if(sBuffer[0])
	{
		if(g_hClasses.FindString(sBuffer) == -1)
		{	
			Function_AddClassToMenu(sBuffer);
			DataPack hPack = new DataPack();
			hPack.WriteCell(hPlugin);
			hPack.WriteFunction(GetNativeCell(2));
			hPack.WriteFunction(GetNativeCell(3));
			hPack.WriteFunction(GetNativeCell(4));
			g_hClassesTrie.SetValue(sBuffer, hPack);
			g_hClasses.PushString(sBuffer);
		}
		else	ThrowNativeError(SP_ERROR_NATIVE, "[CreateClass] Class '%s' already exists.", sBuffer);
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[CreateClass] Empty class name.");
}

public int Native_DeleteClass(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_CLASS_NAME_LENGTH);
	if(sBuffer[0])
	{
		if(!Function_Delete(sBuffer))	ThrowNativeError(SP_ERROR_NATIVE, "[DeleteClass] Class '%s' not found.", sBuffer);
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[DeleteClass] Empty class name.");
}
