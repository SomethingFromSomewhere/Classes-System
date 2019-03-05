public void OnClientPutInServer(int iClient)
{
	g_bRandom[iClient] = false;
	g_sNewClass[iClient][0] = '\0';
	
	if(IsFakeClient(iClient))
	{
		Function_SetRandomClass(iClient);
		return;
	}
	
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	GetClientCookie(iClient, g_hClass, sBuffer, MAX_CLASS_NAME_LENGTH);
	if(sBuffer[0])
	{
		if(g_hClasses.FindString(sBuffer) != -1)
		{
			Function_SetClass(iClient, sBuffer);	
			return;
		}
	
		SetClientCookie(iClient, g_hClass, "");
		Function_SetRandomClass(iClient);
		g_bRandom[iClient] = true;
	}
}

public void Hook_PlayerSpawn(Event hEvent, const char[] name, bool bDonBroadcast)
{
	RequestFrame(Function_FrameSpawn, hEvent.GetInt("userid"));
}
