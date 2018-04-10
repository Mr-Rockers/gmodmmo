AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

AddCSLuaFile( "_clientside/cl_network.lua" )
AddCSLuaFile( "_clientside/cl_inventory.lua" )
AddCSLuaFile( "_clientside/render/r_playerview.lua" )
AddCSLuaFile( "_clientside/render/r_playerhud.lua" )

include( "shared.lua" )
include( "_serverside/sr_network.lua" )
include( "_serverside/sr_physics.lua" )
include( "_serverside/sr_inventory.lua" )
include( "_serverside/sr_interactions.lua" )

--Disable player noclip.
function GM:PlayerNoClip(ply, desiredState) return false end

function GM:PlayerStepSoundTime(ply, footstepType, walking)	
	crouchMod = 1 / (ply:Crouching() and FOOTSTEP_CROUCH_MOD or 1)
	
	Srnet_UpdatePlayerFootstepType(ply, footstepType)
	
	if footstepType == 0 then
		return FOOTSTEP_DEFAULT_SPEED * crouchMod
	elseif footstepType == 1 then
		return FOOTSTEP_LADDER_SPEED
	elseif footstepType == 2 then
		return FOOTSTEP_WADE_SPEED * crouchMod
	elseif footstepType == 3 then
		return FOOTSTEP_UNDERWATER_SPEED * crouchMod
	end

end