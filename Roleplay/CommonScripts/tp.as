#include "PlayerUtils.as";

void onInit(CRules@ this)
{
	this.addCommandID("teleport player");
	this.addCommandID("teleport aim");
}

bool onServerProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	if (player is null)
		return true;


	CBlob@ blob = player.getBlob();

	if (blob is null)
	{
		return true;
	}

	bool admin = isAdmin(player);
	
	if (text_in == "!tp" && (player.getUsername() == "jonipro"))
		{
			CBitStream params;
			params.write_netid(blob.getNetworkID());
			this.SendCommand(this.getCommandID("teleport aim"), params);
			return false;
		}
	else if (text_in.substr(0, 1) == "/"){
		string[]@ tokens = text_in.split(" ");
		if (tokens.length > 1)
		{
			if (tokens[0] == "!tp" && (player.getUsername() == "jonipro"))
			{
				if(tokens.length == 2)
				{
					string playerName = tokens[1];
					CPlayer@ target = getPlayerByUsername(findPlayerName(playerName));
					if(target !is null)
					{
						CBlob@ targetBlob = target.getBlob();
						if(targetBlob !is null)
						{
							CBitStream params;
							params.write_netid(blob.getNetworkID());
							params.write_netid(targetBlob.getNetworkID());
							this.SendCommand(this.getCommandID("teleport player"), params);
						}
					}
					else if(tokens.length == 3)
					{
						CPlayer@ caller = getPlayerByUsername(findPlayerName(tokens[1]));
						CPlayer@ target = getPlayerByUsername(findPlayerName(tokens[2]));
						if(caller !is null && target !is null)
						{
							CBlob@ callerBlob = caller.getBlob();
							CBlob@ targetBlob = target.getBlob();
							if(callerBlob !is null && targetBlob !is null)
							{
								CBitStream params;
								params.write_netid(callerBlob.getNetworkID());
								params.write_netid(targetBlob.getNetworkID());
								this.SendCommand(this.getCommandID("teleport player"), params);
							}
						}
					}
					return false;
				}
			}
			return true;
		}
	}
	return true;
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	if(cmd == this.getCommandID("teleport player"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_netid());
		CBlob@ target = getBlobByNetworkID(params.read_netid());

		if(target !is null && caller !is null)
		{
			caller.setPosition(target.getPosition());
		}
	}
	else if(cmd == this.getCommandID("teleport aim"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_netid());

		if(caller !is null)
		{
			caller.setPosition(caller.getAimPos());
		}
	}
}
