# Random round modifier

This plugin runs on SourceMod and is only for TF2.

This plugin will pick a random modifier(sub-plugin) and a random value for that modifier for each round. The possibilities are endless and every round will have a unique twist.

What are modifiers?
They modify/add certain effects on every player on server to make the round different and more fun.

For example, one of the modifiers is called Random Head-shot explosion. The first round could make all head shots create an explosion. The second round could make melee damage increase to 350%. The third round could increase everyone speed to 150%. It's all random!

There can only be 1 active modifier per round. And will work for any map.
You can also write your own modifier!

More info and how to set up can be read here:
https://forums.alliedmods.net/showthread.php?t=282668

## Convars

|cvar|param|description|
|---|:-:|---|
|sm_rrm_cap|(**0** \| 1)|Enable/disable rerolling the active modifier when a point or flag is captured|
|sm_rrm_vote_enabled|(1 \| **0**)|Enable/disable voting for the next round's modifier. When disabled the modifier is always chosen at random|
|sm_rrm_vote_choices|`3`|Maximum number of modifiers offered in the next round's vote (minimum 2)|