// show menu that only allows to join spectator

const int BUTTON_SIZE = 4;

void onInit(CRules@ this)
{
	this.addCommandID("pick teams");
	this.addCommandID("pick spectator");
	this.addCommandID("pick none");

/*	AddIconToken("$BLUE_TEAM$", "GUI/TeamIcons.png", Vec2f(96, 96), 0);
	AddIconToken("$RED_TEAM$", "GUI/TeamIcons.png", Vec2f(96, 96), 1);
	AddIconToken("$TEAMGENERIC$", "GUI/TeamIcons.png", Vec2f(96, 96), 2);
*/	AddIconToken("$HUMAN$", "GUI/RaceIcons.png", Vec2f(64, 64), 2);
	AddIconToken("$DWARF$", "GUI/RaceIcons.png", Vec2f(64, 64), 3);
//   AddIconToken("$HUMAN$", "GUI/RaceIcons.png", Vec2f(64, 64), 8);
}

void ShowTeamMenu(CRules@ this)
{
	if (getLocalPlayer() is null)
	{
		return;
	}

	getHUD().ClearMenus(true);

	CGridMenu@ main_menu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0, -128), null, Vec2f(((this.getTeamsCount() - 2) + 0.8f) * BUTTON_SIZE, BUTTON_SIZE), "Pick your race");

	if (menu !is null)
	{
		CBitStream exitParams;
		menu.AddKeyCommand(KEY_ESCAPE, this.getCommandID("pick none"), exitParams);
		menu.SetDefaultCommand(this.getCommandID("pick none"), exitParams);

		bool enabled;
		string icon, name;

		for (int i = 0; i < 4; i++)
		{
			CBitStream params;
			params.write_u16(getLocalPlayer().getNetworkID());
			params.write_u8(i);

			if (i == 0)
			{
				icon = "$HUMAN$";
				name = "Human: Homosapiens";
			}
			else if (i == 1)
			{
				icon = "$DWARF$";
				name = "Red Team";
			}
			else
			{
				icon = "$TEAMGENERIC$";
				name = "Generic";
			}
			CBitStream params;
            params.write_u16(player.getNetworkID());
            params.write_u8(i);
			params.write_bool(enabled);
			CGridButton@ button =  menu.AddButton(icon, name, this.getCommandID("pick teams"), Vec2f(BUTTON_SIZE, BUTTON_SIZE), params);
		}

		// spectator
        CBitStream params;
        params.write_u16(getLocalPlayer().getNetworkID());
        params.write_u8(this.getSpectatorTeamNum());
		params.write_bool(true);
		
        main_menu.AddButton("$SPECTATOR$", "Spectate", this.getCommandID("pick spectator"), Vec2f(2, BUTTON_SIZE), params);
	}
}
// the actual team changing is done in the player management script -> onPlayerRequestTeamChange()

void ReadChangeTeam(CRules@ this, CBitStream @params)
{
	CPlayer@ player = getPlayerByNetworkId(params.read_u16());
	u8 team = params.read_u8();

	if (player is getLocalPlayer())
	{
		player.client_ChangeTeam(team);
		// player.client_RequestSpawn(0);
		getHUD().ClearMenus();
	}
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("pick teams"))
	{
		ReadChangeTeam(this, params);
	}
	else if (cmd == this.getCommandID("pick spectator"))
	{
		ReadChangeTeam(this, params);
	}
	else if (cmd == this.getCommandID("pick none"))
	{
		getHUD().ClearMenus();
	}
}
