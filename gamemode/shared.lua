GM.Name = "Garry's Mod MMO Engine"
GM.Author = "OneMerryMile"
GM.Email = "wioussaiden@gmail.com"
GM.Website = "N/A"

FOOTSTEP_DEFAULT_SPEED = 300
FOOTSTEP_LADDER_SPEED = 400
FOOTSTEP_WADE_SPEED = 400
FOOTSTEP_UNDERWATER_SPEED = 500
FOOTSTEP_CROUCH_MOD = 0.75
FOOTSTEP_TRIGGER_VELOCITY = 90 --Found from experimenting in-game.

function GetPlayerID(ply)

	local spawnedPlayerID = ply:SteamID64()
	spawnedPlayerID = spawnedPlayerID != nil and spawnedPlayerID or "client"
	return spawnedPlayerID

end

function GM:Initialize()

end

--Disables default TAB scoreboard.
hook.Add("ScoreboardShow", "shared_scoreboarddisable", function() return false end)
