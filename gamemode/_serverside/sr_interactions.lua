hook.Add("PlayerTick", "sr_interactions_onplayertick", function(ply, mv)
	
	local playerEyeTrace = ply:GetEyeTrace()
	local crosshairType = 0
	--print("---------------")
	
	if IsValid(playerEyeTrace.Entity) then
		
		if playerEyeTrace.Entity:GetClass() == "prop_door_rotating" and ply:GetPos():DistToSqr(playerEyeTrace.Entity:GetPos()) <= 20000 then --TODO FIX THIS
			
			crosshairType = 1
		
		end
	
	end
	
	Srnet_UpdateCrosshairType(ply, crosshairType)
	
end )