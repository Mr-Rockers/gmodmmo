local freeCursorLastEnabledState = false
local function freeCursor(enable)
	if freeCursorLastEnabledState != enable then
		gui.EnableScreenClicker(enable)
		freeCursorLastEnabledState = enable
	end
end

hook.Add( "Initialize", "r_playerhud_loadfonts", function()

	surface.CreateFont( "MMOCourierNew_25", {
		font = "Courier New",
		extended = false,
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	})
end)

local compassWidth  = 0.15   -- As ratio of screen size.
local compassHeight = 0.05   -- As ratio of screen size.
local compassLineHeight = 20 -- As ration of compass height.

local compassBackgroundColor = Color(0, 0, 0, 64)
local compassColor = Color(255, 255, 255, 64)

hook.Add( "HUDPaint", "r_playerhud_drawcompass", function()
	
	--Get dimensions.
	local actualCompassWidth = ScrW() * compassWidth
	local actualCompassHeight = ScrH() * compassHeight
	local actualCompassLineHeight = actualCompassHeight / compassLineHeight


	surface.SetDrawColor( compassBackgroundColor )
	surface.DrawRect( (ScrW() - actualCompassWidth) / 2, actualCompassHeight / 2, actualCompassWidth, actualCompassHeight)
	
	surface.SetDrawColor( compassColor )
	surface.DrawRect( (ScrW() - actualCompassWidth) / 2, actualCompassHeight * 0.5, actualCompassWidth, actualCompassLineHeight)
	surface.DrawRect( (ScrW() - actualCompassWidth) / 2, actualCompassHeight * 1.5, actualCompassWidth, actualCompassLineHeight)
	
	local rawYaw = LocalPlayer():EyeAngles().y
	
	local textYaw = math.floor(rawYaw + 0.5)
	textYaw = textYaw < 0 and textYaw * -1 or 360 - textYaw --Used to fix signing issues in the yaw angles. Could be incorrect and needs further checking down the road.
	draw.SimpleText( string.format("%0003u", textYaw == 360 and 0 or textYaw)  .. "°", "MMOCourierNew_25", ScrW() / 2, actualCompassHeight * 0.5 + actualCompassLineHeight, Color(255, 255, 255, 255), 1)
	
	draw.SimpleText( "N", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw		))) / 2, actualCompassHeight * 1.5, 	Color(255, 128, 128, 255 * math.max(0, math.cos(math.rad(rawYaw)))), 		1, 4)
	draw.SimpleText( "W", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw - 90	))) / 2, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw - 90)))), 	1, 4)
	draw.SimpleText( "E", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw + 90	))) / 2, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw + 90)))),	1, 4)
	draw.SimpleText( "S", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw + 180	))) / 2, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw + 180)))), 	1, 4)
	
	--surface.DrawRect(ScrW() - compassWidth, 25, 100, 100)
		
end)

hook.Add( "HUDPaint", "r_playerhud_drawinventory", function()

	freeCursor(CLNET_LOCALPLAYER_INVENTORY_OPEN)

	if CLNET_LOCALPLAYER_INVENTORY_OPEN then
		surface.DrawRect(0, 0, 25, 25, compassColor) --example
	end

end)