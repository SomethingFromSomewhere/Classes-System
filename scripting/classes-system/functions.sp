void Function_SetRandomClass(int iClient, bool bDelete = false)
{
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	g_hClasses.GetString(GetRandomInt(0, g_hClasses.Length-1), sBuffer, MAX_CLASS_NAME_LENGTH);
	Function_SetClass(iClient, sBuffer, bDelete);
}

void Function_SetClass(int iClient, const char[] sClass, bool bDelete = false, bool bSave = false, bool bIgnoreAlive = false)
{
	if(g_hClasses.FindString(sClass) != -1)
	{
		if(!bDelete && !bIgnoreAlive && IsPlayerAlive(iClient))
		{
			strcopy(g_sNewClass[iClient], sizeof(g_sNewClass), sClass);
			Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Respawn_Change_Class", sClass);
		}
		else
		{
			Action iEvent;
			Forward_OnClassChange(iClient, sClass, iEvent);
			if(IsClientInGame(iClient))	
			{
				switch(iEvent)
				{
					case 	Plugin_Continue:	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Change_Class", 			g_sPlayerClass[iClient]);
					case 	Plugin_Changed:		Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Edited_Change_Class", 	g_sPlayerClass[iClient]);
					case 	Plugin_Handled, 
							Plugin_Stop:		Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Class_Not_Changed");
				}
			}
		}
		if(bSave)
		{
			SetClientCookie(iClient, g_hClass, sClass);
		}
	}
}

bool Function_Delete(const char[] sClass)
{
	char sItem[MAX_CLASS_NAME_LENGTH];
	int i, b, iSize = GetMenuItemCount(g_hMenu);
	ArrayList hArray;
	
	for(i = 0; i < iSize; i++)
	{
		g_hMenu.GetItem(i, sItem, sizeof(sItem));
		if(!strcmp(sItem, sClass, true))
		{
			g_hClassesTrie.GetValue(sClass, hArray);
			delete hArray;
			g_hClassesTrie.Remove(sClass);
			g_hClasses.Erase(g_hClasses.FindString(sClass));
			g_hMenu.RemoveItem(i);
			for(b = 1; b <= MaxClients; b++)	if(!strcmp(g_sPlayerClass[b], sClass))
			{
				Function_SetRandomClass(b);
				if(IsPlayerAlive(b))	CS_RespawnPlayer(b);
			}
			return true;
		}
	}
	return false;
}

void Function_AddClassToMenu(const char[] sClass)
{
	if (g_hSorting != null)
	{
		Function_ResortClassesArray();
		
		g_hMenu.RemoveAllItems();
		
		int i, iSize = g_hClasses.Length;
		char sBuffer[MAX_CLASS_NAME_LENGTH];
		for (i = 0; i < iSize; i++)
		{
			g_hClasses.GetString(i, sBuffer, MAX_CLASS_NAME_LENGTH);
			g_hMenu.AddItem(sBuffer, sBuffer);
		}
	}
	else	g_hMenu.AddItem(sClass, sClass);
}

void Function_ResortClassesArray()
{
	if (g_hClasses.Length < 2)	return;
	
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	int i, x, iSize = g_hSorting.Length, iIndex;

	for (i = 0; i < iSize; i++)
	{
		g_hSorting.GetString(i, sBuffer, MAX_CLASS_NAME_LENGTH);
		iIndex = g_hClasses.FindString(sBuffer);
		if (iIndex != -1)
		{
			if (iIndex != x)
			{
				g_hClasses.SwapAt(iIndex, x);
			}
			
			x++;
		}
	}
}

Function Function_GetFunction(DataPack hPack, int iPosition)
{
	hPack.Position += view_as<DataPackPos>(iPosition);
	return	hPack.ReadFunction();
}

bool Function_IsValidClient(int iClient)
{
	return (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient));
}

public void Function_FrameSpawn(int iClient)
{
	if(IsPlayerAlive((iClient = GetClientOfUserId(iClient))))
	{
		if(g_sNewClass[iClient][0])
		{
			Function_SetClass(iClient, g_sNewClass[iClient], false, true, true);
			g_sNewClass[iClient][0] = '\0';
		}

		Forward_OnPlayerSpawn(iClient);
	}
}

void Function_LoadSortings()
{
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	Handle hFile = OpenFile("addons/sourcemod/data/classes-system/sorting.ini", "r");
	if (hFile != INVALID_HANDLE)
	{
		g_hSorting = new ArrayList(ByteCountToCells(MAX_CLASS_NAME_LENGTH));
		while (!IsEndOfFile(hFile) && ReadFileLine(hFile, sBuffer, MAX_CLASS_NAME_LENGTH))
		{
			TrimString(sBuffer);
			if (sBuffer[0])	g_hSorting.PushString(sBuffer);
		}
	}
}
