
local physUpdateTime = 5 --In seconds
local physUpdateTimer = -1.0

print ("Physics tick set to update every " .. tostring(physUpdateTime) .. " seconds.")

local function tickPhysics()	
	
	if physUpdateTimer >= physUpdateTime or physUpdateTimer == -1.0 then
		--Adjust some values to make the physics feel more realistic and less space like.
		local physMod = 2
		local jumpPower = 275 --200 is the default
		
		for _, ply in ipairs (player.GetAll()) do
			ply:SetGravity(physMod)
			ply:SetJumpPower(jumpPower)
		end
		
		physUpdateTimer = 0.0
	end
	
	physUpdateTimer = physUpdateTimer + FrameTime()
end

hook.Add("Tick", "sr_physics_tick", tickPhysics)