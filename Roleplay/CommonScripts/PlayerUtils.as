// Is a player an admin?

bool isSuperAdmin(CPlayer@ player)
{
	return getSecurity().getPlayerSeclev(player).getName().toLower() == "super admin";
}

bool isAdmin(CPlayer@ player)
{
	return isSuperAdmin(player) || getSecurity().getPlayerSeclev(player).getName().toLower() == "admin";
}

string findPlayerName(const string& in closeName)
{
	string result;
	int matchCount = 0;

	for(int i = 0; i < getPlayerCount(); i++)
	{
		string username = getPlayer(i).getUsername();
		if(username == closeName) return username;

		int index = username.findFirst(closeName);
		if(index == -1) continue;

		result = username;
		matchCount++;
	}

	if(matchCount != 1)
		return "";
	return result;
}
