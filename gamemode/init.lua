AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

AddCSLuaFile( "render/r_playerview.lua" )
AddCSLuaFile( "render/r_playerhud.lua" )

include( "shared.lua" )
include( "_serverside/sr_inventory.lua" )
include( "_serverside/sr_physics.lua" )

--Precache Messages--
util.AddNetworkString("RENDER_SwitchThirdperson")
util.AddNetworkString("RENDER_FootstepType")
util.AddNetworkString("PLAYER_Inventory_ToServer")
util.AddNetworkString("PLAYER_Inventory_ToClient")
---------------------


function GM:PlayerButtonDown(ply, button)

	if button == KEY_V then
		net.Start("RENDER_SwitchThirdperson")
		net.Send(ply)
	end
end

--Disable player noclip.
function GM:PlayerNoClip(ply, desiredState) return false end

lastFootstepType = 0
function GM:PlayerStepSoundTime(ply, type, walking)
	
	if lastFootstepType != type then
		net.Start("RENDER_FootstepType")
		net.WriteInt(type,3)
		net.Send(ply)
		lastFootstepType = type	
	end
	
	crouchMod = 1 / (ply:Crouching() and FOOTSTEP_CROUCH_MOD or 1)
	
	if type == 0 then
		return FOOTSTEP_DEFAULT_SPEED * crouchMod
	elseif type == 1 then
		return FOOTSTEP_LADDER_SPEED
	elseif type == 2 then
		return FOOTSTEP_WADE_SPEED * crouchMod
	elseif type == 3 then
		return FOOTSTEP_UNDERWATER_SPEED * crouchMod
	end

end