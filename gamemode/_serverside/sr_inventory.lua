--allInventories
----players
--------id
----------|STEAM ID
--------bags
----------|MASTER BAG
----------|BAG 1
----------|BAG 2 etc.


--------SERVERSIDE--------

AllInventories = {}
InventoryStates = {}

local function savePlayerInventories()
	if AllInventories != nil and next(AllInventories) != nil then
		local jsonTable = util.TableToJSON(AllInventories, true)
		
		if jsonTable != nil then
			print("Saving inventories...")
			file.CreateDir("gmodmmo_save")
			file.Write("gmodmmo_save/inventories.txt", jsonTable)
			print("Saved!")
		end
	end
end

local function loadPlayerInventories()

	if file.Exists("gmodmmo_save/inventories.txt", "DATA") then
		local jsonRawTable = file.Read("gmodmmo_save/inventories.txt", "DATA")
		if jsonRawTable != nil then
			print("Loading inventories...")
			local jsonTable = util.JSONToTable(jsonRawTable)
			AllInventories = jsonTable != nil and jsonTable or {}
			print("Loaded!")
		end
	end
	
end

--Add player SteamID64 to inventories table if it's not already there. 
local function onPlayerSpawn(ply)

	local spawnedPlayerID = GetPlayerID(ply)
	print("Player spawned! " .. spawnedPlayerID)
	
	if AllInventories["players"] == nil then
		AllInventories["players"] = {}
	end
	
	if AllInventories["players"][spawnedPlayerID] == nil then
		AllInventories["players"][spawnedPlayerID] = {}
	end
	
	InventoryStates[spawnedPlayerID] = false --Closes the player's inventory when spawned in.
	
end

hook.Add( "Initialize", "sr_inventory_loadPlayerInventoriesOnInit", loadPlayerInventories)
hook.Add( "PlayerSpawn", "sr_inventory_onPlayerSpawn", onPlayerSpawn)
hook.Add( "ShutDown", "sr_inventory_savePlayerInventoriesOnClose", savePlayerInventories)
