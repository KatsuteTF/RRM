/*
 *	============================================================================
 *
 *	[RRM] Secondary Damage Modifier
 *
 *	Written by Tak (Chaosxk)
 *	https://forums.alliedmods.net/member.php?u=87026
 *
 *	This plugin is FREE and can be distributed to anyone.
 *	If you have paid for this plugin, get your money back.
 *
 *	Modifier that changes damage done from your secondary weapon.
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
float gDamage = 0.0;
ConVar cMin = null, cMax = null;
float gMin = 0.0, gMax = 0.0;

public Plugin myinfo =
{
	name = "[RRM] Secondary Damage Modifier",
	author = RRM_AUTHOR,
	description = "Modifier that changes damage done from your secondary weapon.",
	version = RRM_VERSION,
	url = RRM_URL
};

public void OnPluginStart()
{
	cMin = CreateConVar("rrm_secondarydamage_min", "1.5", "Minimum value for the random number generator.");
	cMax = CreateConVar("rrm_secondarydamage_max", "2.5", "Maximum value for the random number generator.");

	cMin.AddChangeHook(OnConvarChanged);
	cMax.AddChangeHook(OnConvarChanged);

	gMin = cMin.FloatValue;
	gMax = cMax.FloatValue;

	for (int i = 1; i < MaxClients; i++)
	{
		if(!IsClientInGame(i))
			continue;
		SDKHook(i, SDKHook_OnTakeDamageAlive, OnTakeDamage);
	}

	if(RRM_IsRegOpen())
		RegisterModifiers();

	AutoExecConfig(true, "rrm_secondarydamage", "rrm");
}

public int RRM_OnRegOpen()
{
	RegisterModifiers();
}

void RegisterModifiers()
{
	RRM_Register("Secondary damage", gMin, gMax, false, RRM_Callback_Secondary);
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

public void OnClientPostAdminCheck(int client)
{
	SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamage);
}

public int RRM_Callback_Secondary(bool enable, float value)
{
	gEnabled = enable;
	if(gEnabled)
		gDamage = value;
	return gEnabled;
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon,
	float damageForce[3], float damagePosition[3], int damagecustom)
{
	if(!gEnabled)
		return Plugin_Continue;

	if(!(1 <= attacker <= MaxClients) || !IsClientInGame(attacker))
		return Plugin_Continue;

	if (weapon == GetPlayerWeaponSlot(attacker, 1))
	{
		damage *= gDamage;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}