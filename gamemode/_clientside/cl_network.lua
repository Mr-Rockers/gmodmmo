CLNET_CURRENT_FOOTSTEP_TYPE = 0
CLNET_VIEW_THIRDPERSON = false
CLNET_LOCALPLAYER_INVENTORY_OPEN = false

net.Receive("RENDER_FootstepType", function(len, ply)
	CLNET_CURRENT_FOOTSTEP_TYPE = net.ReadInt(3)
end )

net.Receive("RENDER_SwitchThirdperson", function(len, ply)
	CLNET_VIEW_THIRDPERSON = !CLNET_VIEW_THIRDPERSON
end )

net.Receive("PLAYER_Inventory_ToClient", function(len, ply)
	CLNET_LOCALPLAYER_INVENTORY_OPEN = net.ReadBool()
end )