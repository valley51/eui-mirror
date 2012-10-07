local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LO = E:GetModule('Layout');
local LSM = LibStub("LibSharedMedia-3.0")

local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = MOUNTS_AND_PETS,
	func = function()
		TogglePetJournal();
	end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end
		
		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},		
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = L["calendar_string"],
	func = function() GameTimeFrame:Click() end},
	{text = PLAYER_V_PLAYER,
	func = function() ToggleFrame(PVPFrame) end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = LFG_TITLE,
	func = function() PVEFrame_ToggleFrame(); end},
	{text = ENCOUNTER_JOURNAL, 
	func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},	
	{text = L["GameMenu"],
    func = function() ToggleFrame(GameMenuFrame) end},	
	{text = HELP_BUTTON,
	func = function() ToggleHelpFrame() end},
}

local function HideChildren(parent)
	for i = 1, parent:GetNumChildren() do
		local f = select(i, parent:GetChildren())
		if f:IsShown() then
			UIFrameFadeOut(f, 0.3)
			f.fadeInfo.finishedFunc = function() f:Hide(); f:SetAlpha(1); end
		end
	end
end

local function FadeShow(f)
	if f:IsShown() then
		UIFrameFadeOut(f, 0.3)
		f.fadeInfo.finishedFunc = function() f:Hide(); f:SetAlpha(1); end
	else
		UIFrameFadeIn(f, 0.3)
		f.fadeInfo.finishedFunc = function() f:Show(); f:SetAlpha(1); end
	end
end

--Change border when mouse is inside the button
local function ButtonEnter(self)
	self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))	
end

--Change border back to normal when mouse leaves button
local function ButtonLeave(self)
	self:SetBackdropBorderColor(unpack(E["media"].bordercolor))
end

local function CreateButton(name, func, parent)
	if not name then return end

	local f = CreateFrame("Button", nil, parent)
	f:SetHeight(28)
	f:SetWidth(74)
	f:SetToplevel(true)
	f:SetFrameStrata("DIALOG")	
	f:SetFrameLevel(6)
	f:SetTemplate("Transparent")
	f:StyleButton()
	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize - 2, E.db.datatexts.fontOutline)
	f.text:SetPoint("CENTER")
	f.text:SetText(name)
	f:SetScript("OnClick", function()
		if func then func(); end
		HideChildren(EuiInfoBar.Menu);
		HideChildren(EuiInfoBar.RaidTool);
		HideChildren(EuiInfoBar.Shortcuts);
	end)
	f:HookScript("OnEnter", ButtonEnter)
	f:HookScript("OnLeave", ButtonLeave)
	f:Hide()
	
	return f
end

local function CreateMenu(parent)
	for k, v in pairs(menuList) do
		if menuList[k].text then
			local f = CreateButton(menuList[k].text, menuList[k].func, parent)
			f:SetPoint("TOP", parent, "TOP", 0, -(k * 30))
		end
	end
end

local function CreateRaidTool(parent)
	for i = 1, 4 do
		local f = CreateButton("raidtool".. i, nil, parent)
		parent['raidtool'..i] = f
		f:SetPoint("TOP", parent, "TOP", 0, -(i * 30))
	end
end

--Shortcuts
--1.
local ShortcutsList = {
	{text = L["Setup Chat"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(3); end},
	{text = L['Theme Setup'],
	func = function() E:Install(); ElvUIInstallFrame.SetPage(4); end},
	{text = L["UF Style"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(7); end},
	{text = L["AB Style"], 
	func = function() E:Install(); ElvUIInstallFrame.SetPage(8); end},
	{text = L["Toggle Anchors"],
	func = function()
		if ElvUIMoverPopupWindow and ElvUIMoverPopupWindow:IsShown() then
			E:ToggleConfigMode(false)
		else
			E:ToggleConfigMode()
		end
	end},
	{text = L["Reset Anchors"],
	func = function() E:ResetUI() end},
}

local function CreateShortcuts(parent)
	for k, v in pairs(ShortcutsList) do
		if ShortcutsList[k].text then
			local f = CreateButton(ShortcutsList[k].text, ShortcutsList[k].func, parent)
			f:SetPoint("TOP", parent, "TOP", 0, -(k * 30))
		end
	end
end

local function CreateInfoBarButton(id, name, parent)
	local f = CreateFrame("Button", nil, parent)
	f:SetHeight(28)
	f:SetWidth(74)
	f:SetFrameLevel(2)
	f:StyleButton()
	f:SetTemplate("Transparent")
	f:Point("LEFT", parent, "RIGHT", (id - 1) * 74 + id * 2, 0)
	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	f.text:SetTextColor(23/255, 132/255, 209/255)
	f.text:SetPoint("CENTER")
	f.text:SetText(name)
	f:SetScript("OnClick", function(self)
		if InCombatLockdown() then return; end
		for i = 1, self:GetNumChildren() do
			local f = select(i, self:GetChildren())
			FadeShow(f)
		end
		for k, v in pairs({EuiInfoBar.Menu, EuiInfoBar.Shortcuts, EuiInfoBar.RaidTool}) do
			if self ~= v then HideChildren(v) end
		end				
	end)
	f:HookScript("OnEnter", ButtonEnter)
	f:HookScript("OnLeave", ButtonLeave)
	
	return f
end

function LO:InfoBar()
	local f = CreateFrame("Frame", "EuiInfoBar", E.UIParent)
	f:SetHeight(28)
	f:SetWidth(E.UIParent:GetWidth() + (E.mult * 2))
	f:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", -E.mult, -E.mult)
	f:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", E.mult, -E.mult)
	f:SetFrameStrata("BACKGROUND")
	f:SetFrameLevel(0)
	
	local anchor = CreateFrame("Button", nil, E.UIParent)
	anchor:SetHeight(28)
	anchor:SetWidth(14)
	anchor:SetFrameLevel(2)
	anchor:SetTemplate("Transparent")
	anchor:StyleButton()
	anchor:Point("LEFT", EuiInfoBar, "LEFT", 2, 0)
	anchor.text = anchor:CreateFontString(nil, "OVERLAY")
	anchor.text:FontTemplate(nil, 12, 'OUTLINE')
	anchor.text:SetTextColor(23/255, 132/255, 209/255)
	anchor.text:SetPoint("CENTER")
	anchor.text:SetText('<')
	
	if not E.db.InfoBarStep then
		E.db.InfoBarStep = 3
	end

	if E.db.InfoBarStep < 3 then
		anchor.text:SetText('>')
	elseif E.db.InfoBarStep == 3 then
		anchor.text:SetText('<')
	end
	
	anchor:SetScript("OnClick", function(self)
		if E.db.InfoBarStep == 3 and self.text:GetText() == '<' then
			FadeShow(EuiInfoBar.RaidTool);
			E.db.InfoBarStep = 2;
		elseif E.db.InfoBarStep == 2 and self.text:GetText() == '<' then
			FadeShow(EuiInfoBar.Shortcuts);
			E.db.InfoBarStep = 1;
		elseif E.db.InfoBarStep == 1 and self.text:GetText() == '<' then
			FadeShow(EuiInfoBar.Menu);
			E.db.InfoBarStep = 0;
			self.text:SetText('>');
		elseif E.db.InfoBarStep == 0 then
			FadeShow(EuiInfoBar.Menu);
			E.db.InfoBarStep = 1;
		elseif E.db.InfoBarStep == 1 and self.text:GetText() == '>' then
			FadeShow(EuiInfoBar.Shortcuts);
			E.db.InfoBarStep = 2;
		elseif E.db.InfoBarStep == 2 and self.text:GetText() == '>' then
			FadeShow(EuiInfoBar.RaidTool);
			E.db.InfoBarStep = 3;
			self.text:SetText('<');
		end
	end)
	
	E:CreateMover(anchor, 'EuiInfoBarMover', L['EuiInfoBar'], nil, nil, nil, 'ALL,GENERAL')
	
	local menu = CreateInfoBarButton(1, L["Menu"], anchor)
	CreateMenu(menu);
	
	local shortcuts = CreateInfoBarButton(2, L["Shortcuts"], anchor)
	CreateShortcuts(shortcuts);

	local raid = CreateInfoBarButton(3, L["RaidTool"], anchor)
	CreateRaidTool(raid);	
	
	EuiInfoBar.Menu = menu
	EuiInfoBar.Shortcuts = shortcuts
	EuiInfoBar.RaidTool = raid
	
	if E.db.InfoBarStep == 1 then
		EuiInfoBar.RaidTool:Hide()
		EuiInfoBar.Shortcuts:Hide()
	elseif E.db.InfoBarStep == 2 then
		EuiInfoBar.RaidTool:Hide()
	elseif E.db.InfoBarStep == 0 then
		EuiInfoBar.RaidTool:Hide()
		EuiInfoBar.Shortcuts:Hide()
		EuiInfoBar.Menu:Hide()		
	end	
end