
--HEAD BOB
local currentFootstepType = 0
net.Receive("RENDER_FootstepType", function(len, ply)
	currentFootstepType = net.ReadInt(3)
	print("currentFootstepType: " .. tostring(currentFootstepType))
end )

local bobHeadRaw = 0.0
local bobHeadToIdleSpeed = 5
local bobHeadMaxAdj = 1.5
local bobHeadCurAdj = 0.0

local function updateHeadBob(isWalking, isCrouching)

	if isWalking and (currentFootstepType == 0) then
		bobHeadRaw = bobHeadRaw + (FrameTime() / math.pi) * 20 * (1000 / FOOTSTEP_DEFAULT_SPEED) * (isCrouching and FOOTSTEP_CROUCH_MOD or 1)
	else
		if bobHeadRaw <= math.pi then
			bobHeadRaw = Lerp(FrameTime() * bobHeadToIdleSpeed, bobHeadRaw, 0.0)
		else
			bobHeadRaw = Lerp(FrameTime() * bobHeadToIdleSpeed, bobHeadRaw, math.pi * 2)
		end
	end
	
	if bobHeadRaw >= (math.pi * 2) then
		bobHeadRaw = 0
	end
	
	bobHeadCurAdj = math.sin(bobHeadRaw) * bobHeadMaxAdj
end

--THIRD PERSON CALCULATIONS
local thirdperson = false
net.Receive("RENDER_SwitchThirdperson", function(len, ply)
	thirdperson = !thirdperson
	print("thirdperson: " .. tostring(thirdperson))
end )

--FOV INCREASE ON SPRINT
local fovMaxAdj = 1.15
local fovCurAdj = 1.0
local fovChangeSpeed = 7.5
local function updateFovSprint(isSprinting)

	if isSprinting then
		fovCurAdj = Lerp(FrameTime() * fovChangeSpeed, fovCurAdj, fovMaxAdj)
	else
		fovCurAdj = Lerp(FrameTime() * fovChangeSpeed, fovCurAdj, 1.0)
	end
end

local function playerView(ply, pos, angles, fov)
	local view = {}
	
	updateHeadBob(ply:IsOnGround() and ply:GetVelocity():Length() > FOOTSTEP_TRIGGER_VELOCITY and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)), ply:Crouching())
	
	if thirdperson then
		view.origin = pos - angles:Forward()*100
	else
		local fwdVec = (Angle(0, angles.yaw, 0)):Forward() * 10
		view.origin = pos + Vector(fwdVec.x, fwdVec.y, -10 + bobHeadCurAdj)
	end
	
	updateFovSprint(!ply:Crouching() and ply:GetVelocity():Length() > FOOTSTEP_TRIGGER_VELOCITY and ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)))
	view.fov = fov * fovCurAdj
	
	view.angles = angles
	view.drawviewer = true

	return view

end

hook.Add( "CalcView", "r_playerview_playerview", playerView )
