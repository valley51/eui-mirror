﻿if IsAddOnLoaded("ShaOfFearAssist") then return end

ShaOfFearAssistEnabled = true
-----------------------------------------------------------------------
-- Locals
--
-- upvalues
local min = math.min
local pi = math.pi
local cos = math.cos
local sin = math.sin
local rad = math.rad
local atan = atan
local GameTooltip = GameTooltip
local CreateFrame = CreateFrame
local GetPlayerMapPosition = GetPlayerMapPosition
local SetMapToCurrentZone = SetMapToCurrentZone
local UnitClass = UnitClass
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local type = type
local unpack = unpack
local tonumber = tonumber
local print = print
local UnitAffectingCombat = UnitAffectingCombat
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local UIParent = UIParent
local IsInInstance = IsInInstance
local GetRealZoneText = GetRealZoneText
local GetCurrentMapAreaID = GetCurrentMapAreaID
local UnitIsUnit = UnitIsUnit
local GetPlayerFacing = GetPlayerFacing
local LibStub = LibStub

local addon = CreateFrame("Frame")
--[===[@debug@
-- XXX debug
sha = addon
--@end-debug@]===]

local defaults = {
	profile = {
		posx = nil,
		posy = nil,
		lock = nil,
		width = 100,
		height = 80,
		style = "spinning",
	}
}

local windowShown = nil
local range = 20
local myblip = nil
local platform = false
local dreadSprayCounter = 0
local sprayedPieVerySoon = nil
local sprayedPieSoon = nil
local suggestedSafePie = nil
local shootCounter = 0

local mapData = { 702.083984375,468.75 }

local platformPieSprayOrder = {
	[61046] = {5, 6, 8, 1, 7, 8, 2, 3, 1, 2, 4, 5, 3, 4, 6, 7}, -- Jinlun Kun (Right) other line + 3
	--[61046] = {3, 4, 6, 7, 5, 6, 8, 1, 7, 8, 2, 3, 1, 2, 4, 5}, -- Jinlun Kun (Right)
	[61038] = {7, 3, 3, 7, 6, 2, 2, 7, 5, 1, 1, 5, 4, 8, 8, 4}, -- Yang Goushi (Left)
	[61042] = {7, 2, 3, 4, 1, 4, 5, 6, 3, 6, 7, 8, 5, 8, 1, 2}, -- Cheng Kang (Back) -- looked correct
	["test"] = {5, 1, 4, 5, 3, 4, 6, 7, 5, 6, 8, 1, 7, 8, 2, 3}, -- TEST
}

local platformSuggestedSafeZone = {
	[61046] = {4, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 8, 8}, -- Jinlun Kun (Right)  -- old
	[61038] = {4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}, -- Yang Goushi (Left)  -- old
	[61042] = {8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4}, -- Cheng Kang (Back)   -- looked correct
	["test"] = {2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}  -- TEST
}

-- it is assumed that all pies are equal in size and they don't overlap
-- this is the biggest source of inaccuraccy (the only unless mapdata us fucked)
local platformData = { -- this data is based on a few point of reference then generated by drawing shit then looking up coordinates of points on a picture
-- reference points were: boss in middle of platform, the position where you enter, edge of platform
-- points are meant to be roughly as the hours are on the clock when facing towards north
	["test"] = {
		[10] = { 0.56441903114319, 0.46709984540939 },
		[11] = { 0.57575696706772, 0.45102655887604 },
		[1] = { 0.6021317243576, 0.45170402526855 },
		[2] = { 0.6135094165802, 0.46685117483139 },
		[4] = { 0.61374545097351, 0.50771379470825 },
		[5] = { 0.60232824087143, 0.52308487892151 },
		[7] = { 0.57563626766205, 0.52302396297455 },
		[8] = { 0.56478691101074, 0.50713908672333 },
		["boss"] = { 0.58890211582184, 0.48720079660416 },
		--[1] = { 0.43257997299335, 0.45531824631467 },
		--[2] = { 0.46318117380143, 0.40879055908267 },
		--[4] = { 0.50678537421238, 0.40829993572267 },
		--[5] = { 0.5378498250265, 0.454133776768 },
		--[7] = { 0.53817739223372, 0.519443239744 },
		--[8] = { 0.50757619142564, 0.565970926976 },
		--[10] = { 0.4639719910147, 0.56646155031467 },
		--[11] = { 0.43290754020057, 0.52062770926933 },
		--["boss"] = { 0.48537868261337, 0.48738074302673 },
	},
	[61046] = { -- Jinlun Kun (Right)
		-- right of enterance: 11
		-- left of enterance: 1
		[1] = { 0.36511522073559, 0.0073186877653333 },
		[2] = { 0.40097359641469, 0.044480834197333 },
		[4] = { 0.40878491776948, 0.10873568008533 },
		[5] = { 0.38397341866441, 0.162443608128 },
		[7] = { 0.34107333880173, 0.17414324251733 },
		[8] = { 0.30521496310838, 0.136981096064 },
		[10] = { 0.29740364176784, 0.072726250197333 },
		[11] = { 0.32221514085866, 0.019018322133333 },
		["boss"] = { 0.35309427976608, 0.090730965137482 }, -- might want to double check
	},
	[61038] = { -- Yang Goushi (Left)
		-- right of enterance: 4
		-- left of enterance: 5
		[1] = { 0.50592280328998, 0.847146740736 },
		[2] = { 0.52219793842239, 0.90773840740267 },
		[4] = { 0.50510065916927, 0.96782001546667 },
		[5] = { 0.46464631982797, 0.99219657380267 },
		[7] = { 0.42453252374833, 0.96658862513067 },
		[8] = { 0.40825738861592, 0.905996958464 },
		[10] = { 0.42535466786904, 0.8459153504 },
		[11] = { 0.46580900721034, 0.821538792064 },
		["boss"] = { 0.465227663517, 0.90686768293381 },
	},
	[61042] = { -- Cheng Kang (Back)
		-- right of enterance: 8
		-- left of enterance: 10
		[1] = { 0.12637842469656, 0.525899113792 },
		[2] = { 0.16179988858616, 0.563989657856 },
		[4] = { 0.16886396688786, 0.62843825115733 },
		[5] = { 0.14343261832079, 0.681491781824 },
		[7] = { 0.10040318198221, 0.692072211136 },
		[8] = { 0.064981718078377, 0.653981667072 },
		[10] = { 0.057917639790913, 0.58953307377067 },
		[11] = { 0.083348988357986, 0.53647954308267 },
		["boss"] = { 0.1133908033371, 0.60898566246033 },
	},
}

for k, v in pairs(platformData) do
	for r, s in pairs(v) do
		s[1], s[2] = s[1]*mapData[1], s[2]*mapData[2]
	end
end

local function getPiePoints(index, platform)
	local pies = {
		-- pies are indexed from north going east, south, west (aka clockwise)
		[1] = { 11, 1 },
		[2] = { 1, 2 },
		[3] = { 2, 4 },
		[4] = { 4, 5 },
		[5] = { 5, 7 },
		[6] = { 7, 8 },
		[7] = { 8, 10 },
		[8] = { 10, 11 },
	}
	return platformData[platform]["boss"], platformData[platform][pies[index][1]], platformData[platform][pies[index][2]]
end

--- XXX MAKE THIS LOCAL AFTER DEBUGGING
local display = nil

local unlock = "Interface\\AddOns\\DBM-TerraceofEndlessSpring\\Textures\\icons\\lock"
local lock = "Interface\\AddOns\\DBM-TerraceofEndlessSpring\\Textures\\icons\\un_lock"

local window = nil

-----------------------------------------------------------------------
-- Display Window
--

-- Mostly ripped from the Atramedes addon, which ripped it from BigWigs proximity display
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	addon.db.profile.posx = self:GetLeft() * s
	addon.db.profile.posy = self:GetTop() * s
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	addon.db.profile.width = width
	addon.db.profile.height = height
	local width, height = display:GetWidth(), display:GetHeight()
	local ppy = min(width, height) / (range*3) -- pixel per yard
	display.rangeCircle:SetSize(range*2*ppy, range*2*ppy)
	display.boss:SetSize(range*0.2*ppy, range*0.2*ppy)
	display.pie1:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie2:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie3:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie4:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie5:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie6:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie7:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie8:SetSize(ppy * range * 2, ppy * range * 2)
end

local locked = nil
local function lockDisplay()
	if locked then return end
	window:EnableMouse(false)
	window:SetMovable(false)
	window:SetResizable(false)
	window:RegisterForDrag()
	window:SetScript("OnSizeChanged", nil)
	window:SetScript("OnDragStart", nil)
	window:SetScript("OnDragStop", nil)
	window.drag:Hide()
	locked = true
end

local function unlockDisplay()
	if not locked then return end
	window:EnableMouse(true)
	window:SetMovable(true)
	window:SetResizable(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnSizeChanged", onResize)
	window:SetScript("OnDragStart", onDragStart)
	window:SetScript("OnDragStop", onDragStop)
	window.drag:Show()
	locked = nil
end

local function updateLockButton()
	if not window then return end
	window.lock:SetNormalTexture(addon.db.profile.lock and unlock or lock)
end

local function toggleLock()
	if addon.db.profile.lock then
		unlockDisplay()
	else
		lockDisplay()
	end
	addon.db.profile.lock = not addon.db.profile.lock
	updateLockButton()
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end
local function closeWindow() if window then window:Hide() windowShown = false end end

local function ensureDisplay()
	if window then return end

	display = CreateFrame("Frame", "ShaAssistAnchor", UIParent)
	display:SetWidth(addon.db.profile.width)
	display:SetHeight(addon.db.profile.height)
	display:SetMinResize(100, 30)
	display:SetClampedToScreen(true)
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close.tooltipHeader = "關閉"
	close:SetNormalTexture("Interface\\AddOns\\DBM-TerraceofEndlessSpring\\Textures\\icons\\close")
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", closeWindow)

	local lock = CreateFrame("Button", nil, display)
	lock:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	lock:SetHeight(16)
	lock:SetWidth(16)
	lock.tooltipHeader = "鎖定"
	lock:SetScript("OnEnter", onControlEnter)
	lock:SetScript("OnLeave", onControlLeave)
	lock:SetScript("OnClick", toggleLock)
	display.lock = lock

	local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	header:SetText("恐怖噴散")
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)

	local rangeCircle = display:CreateTexture(nil, "ARTWORK")
	rangeCircle:SetPoint("CENTER")
	rangeCircle:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\alert_circle]])
	rangeCircle:SetBlendMode("ADD")
	display.rangeCircle = rangeCircle
	display.rangeCircle:SetAlpha(0.5)

	-- fucking ugly, but one of the easiest ways
	local pie1 = display:CreateTexture(nil, "ARTWORK")
	pie1:SetPoint("CENTER")
	pie1:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\1]])
	pie1:SetBlendMode("ADD")
	display.pie1 = pie1
	local pie2 = display:CreateTexture(nil, "ARTWORK")
	pie2:SetPoint("CENTER")
	pie2:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\2]])
	pie2:SetBlendMode("ADD")
	display.pie2 = pie2
	local pie3 = display:CreateTexture(nil, "ARTWORK")
	pie3:SetPoint("CENTER")
	pie3:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\3]])
	pie3:SetBlendMode("ADD")
	display.pie3 = pie3
	local pie4 = display:CreateTexture(nil, "ARTWORK")
	pie4:SetPoint("CENTER")
	pie4:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\4]])
	pie4:SetBlendMode("ADD")
	display.pie4 = pie4
	local pie5 = display:CreateTexture(nil, "ARTWORK")
	pie5:SetPoint("CENTER")
	pie5:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\5]])
	pie5:SetBlendMode("ADD")
	display.pie5 = pie5
	local pie6 = display:CreateTexture(nil, "ARTWORK")
	pie6:SetPoint("CENTER")
	pie6:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\6]])
	pie6:SetBlendMode("ADD")
	display.pie6 = pie6
	local pie7 = display:CreateTexture(nil, "ARTWORK")
	pie7:SetPoint("CENTER")
	pie7:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\7]])
	pie7:SetBlendMode("ADD")
	display.pie7 = pie7
	local pie8 = display:CreateTexture(nil, "ARTWORK")
	pie8:SetPoint("CENTER")
	pie8:SetTexture([[Interface\AddOns\DBM-TerraceofEndlessSpring\Textures\8]])
	pie8:SetBlendMode("ADD")
	display.pie8 = pie8

	local boss = display:CreateTexture(nil, "ARTWORK")
	boss:SetPoint("CENTER")
	boss:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcon_8]])
	boss:SetBlendMode("ADD")
	display.boss = boss


	--local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	--text:SetFont("Fonts\\FRIZQT__.TTF", 12)
	--text:SetText("")
	--text:SetAllPoints(display)
	--display.text = text
	--display:SetScript("OnShow", function() text:SetText("|cff777777:-P|r") end)

	local drag = CreateFrame("Frame", nil, display)
	drag.frame = display
	drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
	drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
	drag:SetAlpha(0.5)
	display.drag = drag

	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\DBM-TerraceofEndlessSpring\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)

	window = display

	local x = addon.db.profile.posx
	local y = addon.db.profile.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		display:ClearAllPoints()
		display:SetPoint("CENTER", UIParent)
	end

	updateLockButton()
	if addon.db.profile.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end

	myblip = display:CreateTexture(nil, "OVERLAY")
	myblip:SetSize(56, 56)
	myblip:SetTexture([[Interface\Minimap\MinimapArrow]])
end

local function resetWindow()
	window:ClearAllPoints()
	window:SetPoint("CENTER", UIParent)
	window:SetWidth(defaults.profile.width)
	window:SetHeight(defaults.profile.height)
	addon.db.profile.posx = nil
	addon.db.profile.posy = nil
	addon.db.profile.width = nil
	addon.db.profile.height = nil
end

-------------------------------------------------------------------------------
-- Texture Updater
--

local function rotateTextureAroundCenterPoint(texture, hAngle)
	local s = sin(hAngle)
	local c = cos(hAngle)
	texture:SetTexCoord(
	0.5 - s, 0.5 + c,
	0.5 + c, 0.5 + s,
	0.5 - c, 0.5 - s,
	0.5 + s, 0.5 - c
	)
end

function addon:setPlatformOrientation(a)
	local width, height = display:GetWidth(), display:GetHeight()
	--local range = activeRange and activeRange or 10
	-- range * 3, so we have 3x radius space
	local pixperyard = min(width, height) / (range * 3)
	-- left platform is rotated compared to the other two
	-- tho we should probably not be rotating this much in onupdate
	local angle = nil
	if addon.db.profile.style == "fixed" then
		if platform == 61038 then
			angle = 112.5
			rotateTextureAroundCenterPoint(display.pie1, rad(angle))
			display.pie1:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie2, rad(angle))
			display.pie2:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie3, rad(angle))
			display.pie3:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie4, rad(angle))
			display.pie4:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie5, rad(angle))
			display.pie5:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie6, rad(angle))
			display.pie6:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie7, rad(angle))
			display.pie7:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie8, rad(angle))
			display.pie8:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.rangeCircle, rad(angle))
			display.rangeCircle:SetSize(pixperyard * range * 3, pixperyard * range * 3)
		else
			angle = a or 135
			rotateTextureAroundCenterPoint(display.pie1, rad(angle))
			display.pie1:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie2, rad(angle))
			display.pie2:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie3, rad(angle))
			display.pie3:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie4, rad(angle))
			display.pie4:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie5, rad(angle))
			display.pie5:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie6, rad(angle))
			display.pie6:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie7, rad(angle))
			display.pie7:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie8, rad(angle))
			display.pie8:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.rangeCircle, rad(angle))
			display.rangeCircle:SetSize(pixperyard * range * 3, pixperyard * range * 3)
		end
	else
		if not a then return end
		if platform == 61038 then
			angle = 112.5 + a
			rotateTextureAroundCenterPoint(display.pie1, rad(angle))
			display.pie1:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie2, rad(angle))
			display.pie2:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie3, rad(angle))
			display.pie3:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie4, rad(angle))
			display.pie4:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie5, rad(angle))
			display.pie5:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie6, rad(angle))
			display.pie6:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie7, rad(angle))
			display.pie7:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie8, rad(angle))
			display.pie8:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.rangeCircle, rad(angle))
			display.rangeCircle:SetSize(pixperyard * range * 3, pixperyard * range * 3)
		else
			angle = 135 + a
			rotateTextureAroundCenterPoint(display.pie1, rad(angle))
			display.pie1:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie2, rad(angle))
			display.pie2:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie3, rad(angle))
			display.pie3:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie4, rad(angle))
			display.pie4:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie5, rad(angle))
			display.pie5:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie6, rad(angle))
			display.pie6:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie7, rad(angle))
			display.pie7:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.pie8, rad(angle))
			display.pie8:SetSize(pixperyard * range * 3, pixperyard * range * 3)
			rotateTextureAroundCenterPoint(display.rangeCircle, rad(angle))
			display.rangeCircle:SetSize(pixperyard * range * 3, pixperyard * range * 3)
		end
	end
end

local function sign(p1, p2, p3)
	return (p1[1] - p3[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p3[2]);
end

local function pointInTriangle(pt, v1, v2, v3)
	local b1, b2, b3;

	b1 = sign(pt, v1, v2) < 0;
	b2 = sign(pt, v2, v3) < 0;
	b3 = sign(pt, v3, v1) < 0;

	return ((b1 == b2) and (b2 == b3));
end

function addon:updateData()
	if not platform then platform = "test" end -- XXX debug
	if platform == "test" and dreadSprayCounter == 0 then dreadSprayCounter = 1 end -- XXX debug
	if type(platform) == "number" or platform == "test" then
		local srcX, srcY = GetPlayerMapPosition("player")
		if srcX == 0 and srcY == 0 then
			SetMapToCurrentZone()
			srcX, srcY = GetPlayerMapPosition("player")
		end
		srcX, srcY = srcX*mapData[1], srcY*mapData[2]

		addon:setMyDot(srcX, srcY)

		for i=1, 8 do
			if type(platform) == "number" or platform == "test" then
				addon:setPieColor(i, "white")
			end
		end

		if platform == "test" then
			sprayedPieVerySoon, sprayedPieSoon, suggestedSafePie = 1, 2, 3 --XXX debug
		end
		addon:setPieColor(sprayedPieVerySoon, "red")
		addon:setPieColor(sprayedPieSoon, "orange")

		if suggestedSafePie then addon:setPieColor(suggestedSafePie, "green") end
	else
		addon:clearPieColors()
	end
end
	
do
	-- dx and dy are in yards
	-- facing is radians with 0 being north, counting up clockwise
	local setDot = function(dx, dy, blip)
		local width, height = display:GetWidth(), display:GetHeight()
		--local range = activeRange and activeRange or 10
		-- range * 3, so we have 3x radius space
		local pixperyard = min(width, height) / (range * 3)

		-- rotate relative to player facing
		local rotangle = 0
		local x = (dx * cos(rotangle)) - (-1 * dy * sin(rotangle))
		local y = (dx * sin(rotangle)) + (-1 * dy * cos(rotangle))
		local above0 = nil
		if y > 0 then
			above0 = true
		else
			above0 = false
		end

		if addon.db.profile.style == "spinning" then
			addon:setPlatformOrientation(above0 and -1*atan(dx/dy)+180 or -1*atan(dx/dy))
			x = 0
			y = -1*(dx^2 + dy^2)^0.5
		end

		x = x * pixperyard
		y = y * pixperyard

		blip:ClearAllPoints()
		-- Clamp to frame if out-of-bounds, mainly for reverse proximity
		if x < -(width / 2) then
			x = -(width / 2)
		elseif x > (width / 2) then
			x = (width / 2)
		end
		if y < -(height / 2) then
			y = -(height / 2)
		elseif y > (height / 2) then
			y = (height / 2)
		end

		blip:SetPoint("CENTER", display, "CENTER", x, y)
		if not blip.isShown then
			blip.isShown = true
			blip:Show()
		end

		blip:SetSize(12*pixperyard, 12*pixperyard)

		-- do some rotation
		local bearing = GetPlayerFacing()
		local hAngle = bearing - rad(225)
		if addon.db.profile.style == "spinning" then
			local adjustingAngle = nil
			if above0 then
				adjustingAngle = rad(atan(dx/dy)+180)
			else
				adjustingAngle = rad(atan(dx/dy))
			end
			hAngle = hAngle-adjustingAngle
		end
		rotateTextureAroundCenterPoint(blip, hAngle)
	end
	function addon:setMyDot(srcX, srcY)
		if not platform then platform = "test" end -- XXX debug
		local bossX, bossY = platformData[platform]["boss"][1], platformData[platform]["boss"][2]
		if not bossX or not bossY then return end

		local dx = (srcX - bossX)
		local dy = (srcY - bossY)

		setDot(dx, dy, myblip)
	end
end

-----------------------------------------------------------------------
-- Utility
--

function addon:getc(s)
	--print(platform, s, GetPlayerMapPosition("player"))
end

function addon:clearPieColors()
	for i=1, 8 do
		addon:setPieColor(i, "white")
	end
end

function addon:setPieColor(pie, color)
	if type(pie) ~= "number" then return end
	local pieIndex = ("pie%d"):format(pie)

	if color == "red" then color = {1,0,0} end
	if color == "red1" then color = {0.8,0,0} end
	if color == "red2" then color = {0.6,0,0} end
	if color == "red3" then color = {0.4,0,0} end
	if color == "orange" then color = {1,0.55,0} end
	if color == "green" then color = {0,1,0} end
	if color == "blue" then color = {0,0,1} end
	if color == "white" then color = {0.5,0.5,0.5} end

	display[pieIndex]:SetVertexColor(unpack(color))
end

local function updateDisplay()
	local width, height = display:GetWidth(), display:GetHeight()
	local ppy = min(width, height) / (range * 3)
	display.rangeCircle:SetSize(ppy * range * 2, ppy * range * 2)
	display.boss:SetSize(ppy * range * 0.2, ppy * range * 0.2)
	display.pie1:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie2:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie3:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie4:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie5:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie6:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie7:SetSize(ppy * range * 2, ppy * range * 2)
	display.pie8:SetSize(ppy * range * 2, ppy * range * 2)
	--updateBlipIcons()
	addon:clearPieColors()
end

local function checkForWipe()
	local w = true
	local num = GetNumGroupMembers()
	for i = 1, num do
		local name = GetRaidRosterInfo(i)
		if name then
			if UnitAffectingCombat(name) then
				w = false
			end
		end
	end
	if w and windowShown then
		platform = false
		dreadSprayCounter = 0
		updateDisplay()
		closeWindow()
	end
	if not w then addon:ScheduleTimer(checkForWipe, 2) end
end

local function openWindow()
	-- Make sure the window is there
	ensureDisplay()
	-- Start the show!
	window:Show()
	windowShown = true
	updateDisplay()
	addon:clearPieColors()
end

-----------------------------------------------------------------------
-- Slash command
--

local function slashCommand(input)
	input = input:trim()
	if input == "reset" then
		resetWindow()
	elseif input == "lock" or input == "unlock" then
		toggleLock()
	elseif input == "style" then
		if addon.db.profile.style == "spinning" then
			addon.db.profile.style = "fixed"
		else
			addon.db.profile.style = "spinning"
		end
		addon:setPlatformOrientation()
		print("Sha of Fear Assist: <style> = "..addon.db.profile.style)
	else
		openWindow()
	end
end

-----------------------------------------------------------------------
-- Event handler
--

local function registerEvents()
	addon:RegisterEvent("PLAYER_REGEN_ENABLED")
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function unregisterEvents()
	addon:UnregisterEvent("PLAYER_REGEN_ENABLED")
	addon:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function detectInstanceChange()
	if IsInInstance() then
		SetMapToCurrentZone()
	end
	local zone = GetRealZoneText()
	if zone == nil or zone == "" then
		-- zone hasn't been loaded yet, try again in 5 secs.
		addon:ScheduleTimer(detectInstanceChange, 5)
		return
	elseif GetCurrentMapAreaID() == 886 and IsInInstance() then
		registerEvents()
	else
		unregisterEvents()
	end
end

local function CLEU(...)
	if not ShaOfFearAssistEnabled then return end
	local timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, player, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType,  amountMissed = ...
	if etype == "SPELL_AURA_APPLIED" and spellId == 118977 then               --Fearless
		if UnitIsUnit("player", player) then
			--addon:getc("Fearless")-- XXX DEBUG
			closeWindow()
			platform = false
		end
	elseif etype == "SPELL_AURA_APPLIED" and spellId == 129378 then     --FadingLight
			closeWindow()
	elseif etype == "SPELL_AURA_REMOVED" and spellId == 129147 then   --OminousCackleRemoved
		if UnitIsUnit("player", player) then
			openWindow()
			platform = true
			shootCounter = 0
			sprayedPieVerySoon, sprayedPieSoon, suggestedSafePie = nil, nil, nil
			addon:clearPieColors()
		end
	elseif etype == "SPELL_CAST_SUCCESS" and spellId == 120047 then        --DreadSprayStart
		if not platform then return end
		--addon:getc("DreadSprayStart")-- XXX DEBUG
		dreadSprayCounter = 0
		shootCounter = 0
	elseif etype == "SPELL_CAST_SUCCESS" and spellId == 119983 then            --DreadSpray
		if not platform then return end
		dreadSprayCounter = dreadSprayCounter + 1
		--addon:getc(("%s %d"):format("dreadSprayCounter", dreadSprayCounter)) -- XXX DEBUG
		if platform == 61046 then-- Jinlun Kun
			suggestedSafePie = platformSuggestedSafeZone[platform][dreadSprayCounter]
			sprayedPieVerySoon = platformPieSprayOrder[platform][dreadSprayCounter]
			if platformPieSprayOrder[platform][dreadSprayCounter+1] then
				sprayedPieSoon = platformPieSprayOrder[platform][dreadSprayCounter+1]
			end
		elseif platform == 61038 then-- Yang Goushi
			suggestedSafePie = platformSuggestedSafeZone[platform][dreadSprayCounter]
			sprayedPieVerySoon = platformPieSprayOrder[platform][dreadSprayCounter]
			if platformPieSprayOrder[platform][dreadSprayCounter+1] then
				sprayedPieSoon = platformPieSprayOrder[platform][dreadSprayCounter+1]
			end
		elseif platform == 61042 then-- Cheng Kang
			suggestedSafePie = platformSuggestedSafeZone[platform][dreadSprayCounter]
			sprayedPieVerySoon = platformPieSprayOrder[platform][dreadSprayCounter]
			if platformPieSprayOrder[platform][dreadSprayCounter+1] then
				sprayedPieSoon = platformPieSprayOrder[platform][dreadSprayCounter+1]
			end
		end
		if dreadSprayCounter > 15 then
			sprayedPieVerySoon, sprayedPieSoon = nil, nil
			addon:clearPieColors()
		end
	elseif etype == "SPELL_CAST_START" and spellId == 119862 then                  --Shoot
		if not platform then return end -- this prevents people to get warning if they log back into a platform, so need to find a better platform detection
		shootCounter = shootCounter + 1
		local mobId = tonumber(sourceGUID:sub(7, 10), 16)
		if not mobId then return end
		if mobId == 61046 then-- Jinlun Kun
			platform = 61046
		elseif mobId == 61038 then-- Yang Goushi
			platform = 61038
		elseif mobId == 61042 then-- Cheng Kang
			platform = 61042
		end
		addon:setPlatformOrientation()
		--addon:getc(("%s %d"):format("shootCounter", shootCounter)) -- XXX DEBUG
		-- if you are delayed to get to the platform this counter can get out of sync of realizy hence why we check on multiple numbers
		-- another thing that a better platform detection could solve
		if shootCounter == 3 or shootCounter == 5 or shootCounter == 7 then
			dreadSprayCounter = 0
			if platform == 61046 then-- Jinlun Kun
				suggestedSafePie = platformSuggestedSafeZone[platform][1]
				sprayedPieVerySoon, sprayedPieSoon = platformPieSprayOrder[platform][1], platformPieSprayOrder[platform][2]
			elseif platform == 61038 then-- Yang Goushi
				suggestedSafePie = platformSuggestedSafeZone[platform][1]
				sprayedPieVerySoon, sprayedPieSoon = platformPieSprayOrder[platform][1], platformPieSprayOrder[platform][2]
			elseif platform == 61042 then-- Cheng Kang
				suggestedSafePie = platformSuggestedSafeZone[platform][1]
				sprayedPieVerySoon, sprayedPieSoon = platformPieSprayOrder[platform][1], platformPieSprayOrder[platform][2]
			end
		end
	end
end

addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if (...) == "DBM-TerraceofEndlessSpring" then
			LibStub("AceTimer-3.0"):Embed(addon)
			self.db = LibStub("AceDB-3.0"):New("ShaAssistDB", defaults, true)
			SlashCmdList.ShaAssist = slashCommand
			SLASH_ShaAssist1 = "/sha"
			detectInstanceChange()
			self:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		CLEU(...)
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		detectInstanceChange()
	elseif event == "PLAYER_REGEN_ENABLED" and windowShown then
		checkForWipe()
	end
end)

local total = 0
addon:SetScript("OnUpdate", function(self, elapsed)
	total = total + elapsed
	if total > 0.1 then
		if windowShown then
			addon:updateData()
		end
		total = 0
	end
end)

