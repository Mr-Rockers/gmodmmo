--allInventories
----players
--------id
----------|STEAM ID
--------bags
----------|MASTER BAG
----------|BAG 1
----------|BAG 2 etc.


--------SERVERSIDE--------

local allInventories = {}

function SavePlayerInventories()
	if allInventories != nil and next(allInventories) != nil then
		local jsonTable = util.TableToJSON(allInventories, true)
		
		if jsonTable != nil then
			print("Saving inventories...")
			file.CreateDir("gmodmmo_save")
			file.Write("gmodmmo_save/inventories.txt", jsonTable)
			print("Saved!")
		end
	end
end

function LoadPlayerInventories()

	if file.Exists("gmodmmo_save/inventories.txt", "DATA") then
		local jsonRawTable = file.Read("gmodmmo_save/inventories.txt", "DATA")
		if jsonRawTable != nil then
			print("Loading inventories...")
			local jsonTable = util.JSONToTable(jsonRawTable)
			allInventories = jsonTable != nil and jsonTable or {}
			print("Loaded!")
		end
	end
	
end

--Add player SteamID64 to inventories table if it's not already there.
local function OnPlayerSpawn(ply)
	local spawnedPlayerID = ply:SteamID64()
	
	spawnedPlayerID = spawnedPlayerID != nil and spawnedPlayerID or "client"
	
	print("Player spawned! " .. spawnedPlayerID)
	
	if allInventories["players"] == nil then
		allInventories["players"] = {}
	end
	
	if allInventories["players"][spawnedPlayerID] == nil then
		allInventories["players"][spawnedPlayerID] = {}
	end
	
end


function SendInventoryToPlayer(ply, inv)
end
hook.Add( "Initialize", "sr_inventory_LoadPlayerInventoriesOnInit", LoadPlayerInventories)
hook.Add( "PlayerSpawn", "sr_inventory_OnPlayerSpawn", OnPlayerSpawn)
hook.Add( "ShutDown", "sr_inventory_SavePlayerInventoriesOnClose", SavePlayerInventories)
