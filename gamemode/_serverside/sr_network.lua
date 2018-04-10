--Precache Messages--
util.AddNetworkString("RENDER_SwitchThirdperson")
util.AddNetworkString("RENDER_CrosshairType")
util.AddNetworkString("RENDER_FootstepType")
util.AddNetworkString("PLAYER_Inventory_ToClient")
util.AddNetworkString("PLAYER_Inventory_ToServer")
---------------------


--SEND KEYS
function GM:PlayerButtonDown(ply, button)

	if button == KEY_V then
		net.Start("RENDER_SwitchThirdperson")
		net.Send(ply)
	end
	
	if button == KEY_TAB then
	
		playerID = GetPlayerID(ply) --From shared.lua
		InventoryStates[playerID] = !InventoryStates[playerID] --From sr_inventory.lua
	
		net.Start("PLAYER_Inventory_ToClient")
		net.WriteBool(InventoryStates[playerID])
		net.Send(ply)
	end
	
end

--Update crosshair type
local lastCrosshairType
function Srnet_UpdateCrosshairType(ply, crosshairType)
	local playerID = GetPlayerID(ply)
	
	if lastCrosshairType == nil then lastCrosshairType = {} end
	
	if lastCrosshairType[playerID] == nil or lastCrosshairType[playerID] != crosshairType then
		net.Start("RENDER_CrosshairType")
		net.WriteInt(crosshairType, 3)
		net.Send(ply)
		lastCrosshairType[playerID] = crosshairType
	end
end

--Update footstep type
local lastFootstepType
function Srnet_UpdatePlayerFootstepType(ply, footstepType)
	local playerID = GetPlayerID(ply)

	if lastFootstepType == nil then lastFootstepType = {} end
	
	if lastFootstepType[playerID] == nil or lastFootstepType[playerID] != footstepType then
		net.Start("RENDER_FootstepType")
		net.WriteInt(footstepType,3)
		net.Send(ply)
		lastFootstepType[playerID] = footstepType	
	end

end
