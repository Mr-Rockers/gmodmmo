
local physUpdateTime = 5 --In seconds
local physUpdateTimer = -1.0


local function tickPhysics()	
	
	if physUpdateTimer >= physUpdateTime or physUpdateTimer == -1.0 then
		--Adjust some values to make the physics feel more realistic and less space like.
		
		for _, ply in ipairs (player.GetAll()) do
			ply:SetGravity(2)
			ply:SetJumpPower(275) --200 is the default
		end
		
		physUpdateTimer = 0.0
	end
	
	physUpdateTimer = physUpdateTimer + FrameTime()
end

hook.Add("Tick", "sr_physics_tick", tickPhysics)

--OVERRIDE DEFAULT FALL DAMAGE
function GM:GetFallDamage(ply, speed)
	if speed > 2500 then
		ply:Kill()
		return 1000
	elseif speed > 1500 then
		return 50
	elseif speed > 900 then
		return 10
	else
		return 0
	end
end

hook.Add("Initialize", "sr_physics_init", function() print ("Physics tick set to update every " .. tostring(physUpdateTime) .. " seconds.") end)