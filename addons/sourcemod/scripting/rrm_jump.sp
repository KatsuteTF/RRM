/*
 *	============================================================================
 *
 *	[RRM] Jump Modifier
 *
 *	Written by Tak (Chaosxk)
 *	https://forums.alliedmods.net/member.php?u=87026
 *
 *	This plugin is FREE and can be distributed to anyone.
 *	If you have paid for this plugin, get your money back.
 *
 *	Modifier that changes the jump height of players.
 *
 *	============================================================================
 */
#pragma semicolon 1

#define RRM_VERSION "1.0"

#include <sourcemod>
#include <sdkhooks>
#include <tf2attributes>
#include <tf2>
#include <tf2_stocks>
#include <rrm>

#pragma newdecls required

int gEnabled = 0;
float gJump = 0.0;
ConVar cMin = null, cMax = null;
float gMin = 0.0, gMax = 0.0;

public Plugin myinfo =
{
	name = "[RRM] Jump Modifier",
	author = RRM_AUTHOR,
	description = "Modifier that changes the jump height of players.",
	version = RRM_VERSION,
	url = RRM_URL
};

public void OnPluginStart()
{
	cMin = CreateConVar("rrm_jump_min", "0.5", "Minimum value for the random number generator.");
	cMax = CreateConVar("rrm_jump_max", "3.0", "Maximum value for the random number generator.");

	cMin.AddChangeHook(OnConvarChanged);
	cMax.AddChangeHook(OnConvarChanged);

	gMin = cMin.FloatValue;
	gMax = cMax.FloatValue;

	if(RRM_IsRegOpen())
		RegisterModifiers();

	AutoExecConfig(true, "rrm_jump", "rrm");
}

public void OnPluginEnd()
{
	RemoveJump();
}

public int RRM_OnRegOpen()
{
	RegisterModifiers();
}

void RegisterModifiers()
{
	RRM_Register("Jump height", gMin, gMax, false, RRM_Callback_Jump);
}

public void OnConvarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	if (StrEqual(oldValue, newValue, true))
		return;

	float fNewValue = StringToFloat(newValue);

	if(convar == cMin)
		gMin = fNewValue;
	else if(convar == cMax)
		gMax = fNewValue;
}

public void OnClientPostAdminCheck(int i)
{
	if(!gEnabled)
		return;
	TF2Attrib_SetByDefIndex(i, 326, gJump);
}

public int RRM_Callback_Jump(bool enable, float value)
{
	gEnabled = enable;
	if(gEnabled)
	{
		gJump = value;
		SetJump();
	}
	else
		RemoveJump();
	return gEnabled;
}

void SetJump()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
		TF2Attrib_SetByDefIndex(i, 326, gJump);
	}
}

void RemoveJump()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
		TF2Attrib_RemoveByDefIndex(i, 326);
	}
}