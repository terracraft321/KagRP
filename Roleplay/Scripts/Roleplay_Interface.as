#include "TDM_Structs.as";
#include "TeamColour.as";
#include "TeamSColour.as";

/*
void onTick( CRules@ this )
{
    //see the logic script for this
}
*/

void onRender(CRules@ this)
{
	CPlayer@ p = getLocalPlayer();

	if (p is null || !p.isMyPlayer()) { return; }

	GUI::SetFont("menu");
	string propname = "tdm spawn time " + p.getUsername();
	if (p.getBlob() is null && this.exists(propname))
	{
		u8 spawn = this.get_u8(propname);

		if (spawn != 255)
		{
			if (spawn == 254)
			{
				GUI::DrawText(getTranslatedString("In Queue to Respawn...") , Vec2f(getScreenWidth() / 2 - 70, getScreenHeight() / 3 + Maths::Sin(getGameTime() / 3.0f) * 5.0f), SColor(255, 255, 255, 55));
			}
			else if (spawn == 253)
			{
				GUI::DrawText(getTranslatedString("No Respawning - Wait for the Game to End.") , Vec2f(getScreenWidth() / 2 - 180, getScreenHeight() / 3 + Maths::Sin(getGameTime() / 3.0f) * 5.0f), SColor(255, 255, 255, 55));
			}
			else
			{
				GUI::DrawText(getTranslatedString("Respawning in:") + " " + spawn , Vec2f(getScreenWidth() / 2 - 70, getScreenHeight() / 3 + Maths::Sin(getGameTime() / 3.0f) * 5.0f), SColor(255, 255, 255, 55));
			}
		}
	}
}
 
void onRenderScoreboard(CRules@ this)
{
    GUI::SetFont("menu");
    //sort players
    CPlayer@[] sortedplayers;
    CPlayer@[] spectators;

    for (u32 i = 0; i < getPlayersCount(); i++)
    {
        CPlayer@ p = getPlayer(i);
        s8 team = p.getTeamNum();
        bool inserted = false;
        for (u32 j = 0; j < sortedplayers.length; j++)
        {
            if (sortedplayers[j].getTeamNum() < team)
            {
                sortedplayers.insert(j, p);
                inserted = true;
                break;
            }
        }
        if (!inserted)
            sortedplayers.push_back(p);
    }

    //draw board

    Vec2f topleft(600, 150);
    Vec2f bottomright(getScreenWidth() - 600, topleft.y + sortedplayers.length * 20 + 56 +(getPlayersCount()-1)*4);
    GUI::DrawWindow(topleft, bottomright);
	GUI::DrawFramedPane(topleft-Vec2f(4,0), Vec2f(getScreenWidth() - 596,topleft.y + 32));

    //offset border

    topleft.x += 16;
    bottomright.x -= 16;
    topleft.y += 16;

    //draw player table header

    GUI::DrawText("User", Vec2f(topleft.x+20, topleft.y - 8), SColor(0xffffffff));
    GUI::DrawText("Character name", Vec2f(bottomright.x - 300, topleft.y - 8), SColor(0xffffffff));
	GUI::DrawText("Ping", Vec2f(bottomright.x - 60, topleft.y - 8), SColor(0xffffffff));

    //topleft.y += 32;
    //draw players
    for (u32 i = 0; i < sortedplayers.length; i++)
    {
        
		int num = sortedplayers.length-1-i;
		
		CPlayer@ p = sortedplayers[num];
        CPlayer@ localp = getLocalPlayer();
		topleft.y = i * 24 + 8 + 182;
        bottomright.y = topleft.y + 20;
 
        GUI::DrawPane(Vec2f(topleft.x, topleft.y), Vec2f(bottomright.x, bottomright.y), SColor(getTeamColor(p.getTeamNum())) );
		GUI::DrawPane(Vec2f(topleft.x, topleft.y), Vec2f(bottomright.x, bottomright.y-6), SColor(getTeamSColor(int((p.getTeamNum())/8))) );

        /*string tex = p.getScoreboardTexture();
        if(tex != "" && p.getBlob() != null && localp.getBlob() != null && !p.getBlob().hasTag("dead") && p.getBlob().getTeamNum() == localp.getBlob().getTeamNum())
        {
                u16 frame = p.getScoreboardFrame();
            Vec2f framesize = p.getScoreboardFrameSize();
                GUI::DrawIcon( tex, frame, framesize, Vec2f(topleft.x+4, topleft.y-3), 0.5f, p.getTeamNum() );
        }*/
		s32 ping_in_ms = s32(p.getPing() * 1000.0f / 30.0f);
		
		if(p.getUsername() == "jonipro" || p.getUsername() == "ToughBlade")
		{
		GUI::DrawText(p.getUsername(), topleft + Vec2f(20, -2), SColor(0xff264AFF));
        GUI::DrawText(p.getCharacterName(), Vec2f(bottomright.x - 300, topleft.y-2), SColor(0xff264AFF));
		}
		else if(p.getUsername() == "ollimarrex")
		{
		GUI::DrawText(p.getUsername(), topleft + Vec2f(20, -2), SColor(0xffFEA53D));
        GUI::DrawText(p.getCharacterName(), Vec2f(bottomright.x - 300, topleft.y-2), SColor(0xffFEA53D));
		}
		else if(p.getUsername() == "AgentHightower" || p.getUsername() == "gray_guard")
		{
		GUI::DrawText(p.getUsername(), topleft + Vec2f(20, -2), SColor(0xffFF0000));
        GUI::DrawText(p.getCharacterName(), Vec2f(bottomright.x - 300, topleft.y-2), SColor(0xffFEA53D));
		}
		else
		{
		GUI::DrawText(p.getUsername(), topleft + Vec2f(20, -2), SColor(0xffffffff));
        GUI::DrawText(p.getCharacterName(), Vec2f(bottomright.x - 300, topleft.y-2), SColor(0xffffffff));
		}
		GUI::DrawText("" + ping_in_ms, Vec2f(bottomright.x - 60, topleft.y-2), SColor(0xffffffff));
    }
}