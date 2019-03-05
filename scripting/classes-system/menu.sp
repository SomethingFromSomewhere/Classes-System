void Menu_DisplayClassesMenu(int iClient)
{
	if(GetMenuItemCount(g_hMenu) > 1)
	{
		g_hMenu.Display(iClient, MENU_TIME_FOREVER);
	}
	else	Plugin_PrintToChat(iClient, "Empty_Menu");
}

public int Menu_Handle(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	static char sBuffer[MAX_CLASS_NAME_LENGTH+64];
	DataPack hPack;
	static Function Func;
	static Handle hPlugin;
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(iItem)
			{
				case 0:
				{
					g_hMenu.DisplayAt(iClient, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
					g_bRandom[iClient] = true;
					SetClientCookie(iClient, g_hClass, "");
				}
				default:
				{		
					hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
					if(!Forward_OnMenuSelectClass(iClient, sBuffer))
					{
						return 0;
					}
					
					g_hClassesTrie.GetValue(sBuffer, hPack);
					hPack.Reset(false);
					hPlugin = hPack.ReadCell();
					Func = hPack.ReadFunction();
					if (Func != INVALID_FUNCTION)
					{
						bool bResult;
						Call_StartFunction(hPlugin, Func);
						Call_PushCell(iClient);
						Call_Finish(bResult);
						if(bResult)
						{
							Function_SetClass(iClient, sBuffer, _, true);
							g_hMenu.DisplayAt(iClient, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
						}
					}
					else
					{
						Function_SetClass(iClient, sBuffer, _, true);
						g_hMenu.DisplayAt(iClient, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
					}
				}
			}
		}
		case MenuAction_Display:
        {
            FormatEx(sBuffer, sizeof(sBuffer), "%T", "Main_Menu_Title", iClient);
            (view_as<Panel>(iItem)).SetTitle(sBuffer);
        }
		case MenuAction_DisplayItem:
		{
			switch(iItem)
			{
				case 0:
				{
					FormatEx(sBuffer, sizeof(sBuffer), "%T", "Random", iClient);
					return RedrawMenuItem(sBuffer);
				}
				default:
				{
					hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
					Forward_OnMenuDisplayClass(iClient, sBuffer);
					
					g_hClassesTrie.GetValue(sBuffer, hPack);
					hPack.Reset(false);
					hPlugin = hPack.ReadCell();
					Func = Function_GetFunction(hPack, DISPLAY_ITEM_FUNCTION);
					if (Func != INVALID_FUNCTION)
					{
						bool bResult;
						Call_StartFunction(hPlugin, Func);
						Call_PushCell(iClient);
						Call_PushStringEx(sBuffer, sizeof(sBuffer), SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
						Call_PushCell(sizeof(sBuffer));
						Call_Finish(bResult);
						
						if(bResult)
						{
							if(!strcmp(g_sPlayerClass[iClient], sBuffer)) Format(sBuffer, sizeof(sBuffer), "%s [+]", sBuffer);
							return RedrawMenuItem(sBuffer);
						}
					}
					
					FormatEx(sBuffer, sizeof(sBuffer), "%T%s", sBuffer, iClient, (strcmp(g_sPlayerClass[iClient], sBuffer) == 0) ? "":" [+]");
					return RedrawMenuItem(sBuffer);
				}
			}
		}
		case MenuAction_DrawItem:
		{
			switch(iItem)
			{
				case 0:
				{

				}
				default:
				{
					static int iStyle;
					hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer), iStyle);
					iStyle = Forward_OnMenuDrawClass(iClient, sBuffer);
					
					g_hClassesTrie.GetValue(sBuffer, hPack);
					hPack.Reset(false);
					hPlugin = hPack.ReadCell();
					Func = Function_GetFunction(hPack, DRAW_ITEM_FUNCTION);
					if (Func != INVALID_FUNCTION)
					{
						Call_StartFunction(hPlugin, Func);
						Call_PushCell(iClient);
						Call_PushCell(iStyle);
						Call_Finish(iStyle);
					}
					return iStyle;
				}
			}
		}
	}
	return 0;
}