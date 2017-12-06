SColor getTeamSColor(int meam)
{
	SColor teamSCol;

	switch (meam)
	{
		case 0: teamSCol.set(0xffE6A796); break;
		
		case 1: teamSCol.set(0xff896359); break;

		case 2: teamSCol.set(0xff97A792); break;
		
		case 3: teamSCol.set(0xffBA7A2E); break;

		default: teamSCol.set(0xffffffff);
	}
	return teamSCol;
}