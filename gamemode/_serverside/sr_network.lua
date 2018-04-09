--Precache Messages--
util.AddNetworkString("RENDER_SwitchThirdperson")
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

local lastFootstepType = 0
function Srnet_UpdatePlayerFootstepType(ply, footstepType)
	if lastFootstepfootstepType != footstepType then
		net.Start("RENDER_FootstepType")
		net.WriteInt(footstepType,3)
		net.Send(ply)
		lastFootstepfootstepType = footstepType	
	end

end