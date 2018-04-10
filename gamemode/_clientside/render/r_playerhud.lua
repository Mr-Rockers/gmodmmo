--LOAD FONTS
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

--LOAD MATERIALS
hook.Add( "Initialize", "r_playerhud_loadmats", function()
MATERIAL_CROSSHAIR_DEFAULT = Material("crosshairs/default.png", "noclamp smooth")
MATERIAL_CROSSHAIR_DOOR = Material("crosshairs/door.png", "noclamp smooth")
end )

--FREE CURSOR STATE MANAGER
local freeCursorLastEnabledState = false
local function freeCursor(enable)
	if freeCursorLastEnabledState != enable then
		gui.EnableScreenClicker(enable)
		freeCursorLastEnabledState = enable
	end
end


local guiLineHeight = 500 -- As ratio of screen height
local guiBackgroundColor = Color(0, 0, 0, 192)
local guiForegroundColor = Color(255, 255, 255, 64)

local compassWidth  = 0.15   -- As ratio of screen size.
local compassHeight = 0.05   -- As ratio of screen size.

local function getGuiLineHeight()
	return ScrH() / guiLineHeight
end

hook.Add( "HUDPaint", "r_playerhud_drawcompass", function()
	
	--Get dimensions.
	local actualCompassWidth = ScrW() * compassWidth
	local actualCompassHeight = ScrH() * compassHeight
	local actualGuiLineHeight = getGuiLineHeight()

	--Draw background.
	surface.SetDrawColor( guiBackgroundColor )
	surface.DrawRect( (ScrW() - actualCompassWidth) * 0.5, actualCompassHeight * 0.5, actualCompassWidth, actualCompassHeight)
	
	--Draw lines.
	surface.SetDrawColor( guiForegroundColor )
	surface.DrawRect( (ScrW() - actualCompassWidth) * 0.5, (actualCompassHeight * 0.5), actualCompassWidth, actualGuiLineHeight)
	surface.DrawRect( (ScrW() - actualCompassWidth) * 0.5, (actualCompassHeight * 1.5), actualCompassWidth, actualGuiLineHeight)
	
	local rawYaw = LocalPlayer():EyeAngles().y
	
	local textYaw = math.floor(rawYaw + 0.5)
	textYaw = textYaw < 0 and textYaw * -1 or 360 - textYaw --Used to fix signing issues in the yaw angles. Could be incorrect and needs further checking down the road.
	draw.SimpleText( string.format("%0003u", textYaw == 360 and 0 or textYaw)  .. "°", "MMOCourierNew_25", ScrW() * 0.5, actualCompassHeight * 0.5 + actualGuiLineHeight, Color(255, 255, 255, 255), 1)
	
	draw.SimpleText( "N", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw		))) * 0.5, actualCompassHeight * 1.5, 	Color(255, 128, 128, 255 * math.max(0, math.cos(math.rad(rawYaw)))), 		1, 4)
	draw.SimpleText( "W", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw - 90	))) * 0.5, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw - 90)))), 	1, 4)
	draw.SimpleText( "E", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw + 90	))) * 0.5, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw + 90)))),	1, 4)
	draw.SimpleText( "S", "MMOCourierNew_25", (ScrW() + (actualCompassWidth - 25) * math.sin(math.rad(rawYaw + 180	))) * 0.5, actualCompassHeight * 1.5, 	Color(255, 255, 255, 255 * math.max(0, math.cos(math.rad(rawYaw + 180)))), 	1, 4)
	
	--surface.DrawRect(ScrW() - compassWidth, 25, 100, 100)
		
end)

local inventoryWidth  = 0.4 -- As ratio of screen size.
local inventoryHeight = 1.1 -- Multiplier of inventoryWidth
local inventoryOpacity = 0.0
local inventoryFadeSpeed = 20

hook.Add( "HUDPaint", "r_playerhud_drawinventory", function()

	freeCursor(CLNET_LOCALPLAYER_INVENTORY_OPEN)

	inventoryOpacity = Lerp(FrameTime() * inventoryFadeSpeed, inventoryOpacity, CLNET_LOCALPLAYER_INVENTORY_OPEN and 1.0 or 0.0)

	local inventoryBackgroundColor = Color(guiBackgroundColor.r, guiBackgroundColor.g, guiBackgroundColor.b, guiBackgroundColor.a * inventoryOpacity)
	local inventoryForegroundColor = Color(guiForegroundColor.r, guiForegroundColor.g, guiForegroundColor.b, guiForegroundColor.a * inventoryOpacity)
	
	--Get dimensions.
	local actualInventoryWidth = ScrW() * inventoryWidth
	local actualInventoryHeight = actualInventoryWidth * inventoryHeight
	local actualGuiLineHeight = getGuiLineHeight()
	
	--Draw background
	surface.SetDrawColor( inventoryBackgroundColor )
	surface.DrawRect((ScrW() - actualInventoryWidth) * 0.5, (ScrH() - actualInventoryHeight) * 0.5, actualInventoryWidth, actualInventoryHeight)
	
	--Draw lines.
	surface.SetDrawColor( inventoryForegroundColor )
	surface.DrawRect((ScrW() - actualInventoryWidth) * 0.5, ((ScrH() - actualInventoryHeight) * 0.5), actualInventoryWidth, actualGuiLineHeight)
	surface.DrawRect((ScrW() - actualInventoryWidth) * 0.5, ((ScrH() - actualInventoryHeight) * 0.5) + actualInventoryHeight, actualInventoryWidth, actualGuiLineHeight)

end)

hook.Add("HUDPaint", "r_playerhud_drawcrosshair", function()

	if !CLNET_LOCALPLAYER_INVENTORY_OPEN then
	
		local cursorSize = 20
		
		surface.SetDrawColor(255, 255, 255, 64)
		
		if CLNET_CURRENT_CROSSHAIR_TYPE == 0 then surface.SetMaterial(MATERIAL_CROSSHAIR_DEFAULT)
		elseif CLNET_CURRENT_CROSSHAIR_TYPE == 1 then surface.SetMaterial(MATERIAL_CROSSHAIR_DOOR) surface.SetDrawColor(255, 255, 255, 64) cursorSize = 75
		else surface.SetMaterial(MATERIAL_CROSSHAIR_DEFAULT) end
		
		
		surface.DrawTexturedRect( (ScrW() - cursorSize) / 2, (ScrH() - cursorSize) / 2, cursorSize, cursorSize)
	end
end)

--Disables default HUD for showing a player's name when the crosshair is pointed at them.
function GM:HUDDrawTargetID()
end

local defaultHUDElementToHide = { --IF ELEMENT IS TRUE, IT WILL BE HIDDEN.
	["CHudAmmo"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = false, --DO NOT SET THIS TO TRUE OR IT WILL CAUSE BUGS. TRY AND DO SOMETHING WITH THIS IN THE FUTURE WHEN IT'S APPROPRIATE.
	["CHudCrosshair"] = true,
	["CHudDamageIndicator"] = true,
	["CHudGeiger"] = true,
	["CHudHealth"] = false, --TODO CHANGE AND UPDATE THIS
	["CHudHintDisplay"] = true,
	["CHudMenu"] = false, --TODO CHANGE AND UPDATE THIS
	["CHudMessage"] = false,
	["CHudPoisonDamageIndicator"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudSquadStatus"] = true,
	["CHudTrain"] = true,
	["CHudVehicle"] = true,
	["CHudWeapon"] = true,
	["CHudWeaponSelection"] = true,
	["CHudZoom"] = true,
	["NetGraph"] = false --User should be able to check net statistics.
}
hook.Add("HUDShouldDraw", "r_playerhud_drawdefaultelements", function(name) if (defaultHUDElementToHide[name]) then return false end end)