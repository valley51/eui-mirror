local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LO = E:NewModule('Layout', 'AceEvent-3.0');

local PANEL_HEIGHT = 22;
local SIDE_BUTTON_WIDTH = 16;

E.Layout = LO;

local function Panel_OnShow(self)
	self:SetFrameLevel(0)
	self:SetFrameStrata('BACKGROUND')
end

function LO:Initialize()
	self:CreateChatPanels()
	self:CreateMinimapPanels()
	self:CreateActionbarInfobar()
	self:LocXY()
	self:InfoBar()	
	
	self.BottomPanel = CreateFrame('Frame', 'ElvUI_BottomPanel', E.UIParent)
	self.BottomPanel:SetTemplate('Transparent')
	self.BottomPanel:Point('BOTTOMLEFT', E.UIParent, 'BOTTOMLEFT', -1, -1)
	self.BottomPanel:Point('BOTTOMRIGHT', E.UIParent, 'BOTTOMRIGHT', 1, -1)
	self.BottomPanel:Height(PANEL_HEIGHT)
	self.BottomPanel:SetScript('OnShow', Panel_OnShow)
	E.FrameLocks['ElvUI_BottomPanel'] = true;
	Panel_OnShow(self.BottomPanel)
	self:BottomPanelVisibility()
	
	self.TopPanel = CreateFrame('Frame', 'ElvUI_TopPanel', E.UIParent)
	self.TopPanel:SetTemplate('Transparent')
	self.TopPanel:Point('TOPLEFT', E.UIParent, 'TOPLEFT', -1, 1)
	self.TopPanel:Point('TOPRIGHT', E.UIParent, 'TOPRIGHT', 1, 1)
	self.TopPanel:Height(PANEL_HEIGHT)
	self.TopPanel:SetScript('OnShow', Panel_OnShow)
	Panel_OnShow(self.TopPanel)
	E.FrameLocks['ElvUI_TopPanel'] = true;
	self:TopPanelVisibility()	
end

function LO:BottomPanelVisibility()
	if E.db.general.bottomPanel then
		self.BottomPanel:Show()
	else
		self.BottomPanel:Hide()
	end
end

function LO:TopPanelVisibility()
	if E.db.general.topPanel then
		self.TopPanel:Show()
	else
		self.TopPanel:Hide()
	end
end

local function ChatPanelLeft_OnFade(self)
	LeftChatPanel:Hide()
end

local function ChatPanelRight_OnFade(self)
	RightChatPanel:Hide()
end

local function ChatButton_OnEnter(self, ...)
	if E.db[self.parent:GetName()..'Faded'] then
		self.parent:Show()
		UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(L['Left Click:'], L['Toggle Chat Frame'], 1, 1, 1)
	GameTooltip:Show()
end

local function ChatButton_OnLeave(self, ...)
	if E.db[self.parent:GetName()..'Faded'] then
		UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
	GameTooltip:Hide()
end

local function ChatButton_OnClick(self, btn)
	GameTooltip:Hide()
	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	else
		E.db[self.parent:GetName()..'Faded'] = true
		UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
end

function HideLeftChat()
	ChatButton_OnClick(LeftChatToggleButton)
end

function HideRightChat()
	ChatButton_OnClick(RightChatToggleButton)
end

function HideBothChat()
	ChatButton_OnClick(LeftChatToggleButton)
	ChatButton_OnClick(RightChatToggleButton)
end

function LO:ToggleChatTabPanels(rightOverride, leftOverride)
	if leftOverride or not E.db.chat.panelTabBackdrop then
		LeftChatTab:Hide()
	else	
		LeftChatTab:Show()
	end
	
	if rightOverride or not E.db.chat.panelTabBackdrop then
		RightChatTab:Hide()
	else
		RightChatTab:Show()	
	end	
end

function LO:ToggleChatPanels()
	LeftChatDataPanel:ClearAllPoints()
	RightChatDataPanel:ClearAllPoints()
	local SPACING = (E.PixelMode and 3 or 5)

	if E.db.datatexts.leftChatPanel then
		LeftChatDataPanel:Show()
		LeftChatToggleButton:Show()
	else
		LeftChatDataPanel:Hide()
		LeftChatToggleButton:Hide()
	end
	
	if E.db.datatexts.rightChatPanel then
		RightChatDataPanel:Show()
		RightChatToggleButton:Show()
	else
		RightChatDataPanel:Hide()
		RightChatToggleButton:Hide()
	end	
	
	if E.db.chat.panelBackdrop == 'SHOWBOTH' then
		LeftChatPanel.backdrop:Show()
		RightChatPanel.backdrop:Show()		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING + SIDE_BUTTON_WIDTH, SPACING)
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -SPACING, (SPACING + PANEL_HEIGHT))		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)		
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SPACING, SPACING)
		LO:ToggleChatTabPanels()
	elseif E.db.chat.panelBackdrop == 'HIDEBOTH' then
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Hide()		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, 0)
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, PANEL_HEIGHT)		
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT')
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, PANEL_HEIGHT)		
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT')
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT')
		LO:ToggleChatTabPanels(true, true)
	elseif E.db.chat.panelBackdrop == 'LEFT' then
		LeftChatPanel.backdrop:Show()
		RightChatPanel.backdrop:Hide()		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING + SIDE_BUTTON_WIDTH, SPACING)
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -SPACING, (SPACING + PANEL_HEIGHT))			
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT')
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SIDE_BUTTON_WIDTH, PANEL_HEIGHT)			
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT')
		LO:ToggleChatTabPanels(true)
	else
		LeftChatPanel.backdrop:Hide()
		RightChatPanel.backdrop:Show()		
		LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH, 0)
		LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, PANEL_HEIGHT)			
		RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
		RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)		
		LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT')
		RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SPACING, SPACING)
		LO:ToggleChatTabPanels(nil, true)
	end
end

function LO:GetLocTextColor()
	local pvpType = GetZonePVPInfo()
	if pvpType == "arena" then
		return 0.84, 0.03, 0.03
	elseif pvpType == "friendly" then
		return 0.05, 0.85, 0.03
	elseif pvpType == "contested" then
		return 0.9, 0.85, 0.05
	elseif pvpType == "hostile" then 
		return 0.84, 0.03, 0.03
	elseif pvpType == "sanctuary" then
		return 0.035, 0.58, 0.84
	elseif pvpType == "combat" then
		return 0.84, 0.03, 0.03
	else
		return 0.84, 0.03, 0.03
	end	
end

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", E.UIParent, "UIDropDownMenuTemplate")
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
LO.menuList = menuList

function LO:LocXY()
	if not E.db.euiscript.oldtopinfobar then return end
	
	local f = CreateFrame("Frame", "ElvuiTopPanel", E.UIParent)
	f:SetHeight(16)
	f:SetWidth(E.UIParent:GetWidth() + (E.mult * 2))
	f:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", -E.mult, E.mult)
	f:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", E.mult, E.mult)
	f:SetFrameStrata("BACKGROUND")
	f:SetFrameLevel(0)
	E.FrameLocks['ElvuiTopPanel'] = true;
	
	local f = CreateFrame("Frame", "ElvuiLoc", ElvuiTopPanel)
	f:SetHeight(23)
	f:SetWidth(E.MinimapSize)
	f:SetFrameLevel(2)
	f:SetTemplate("Default", true)
	f:CreateShadow("Default")
	f:Point("CENTER", ElvuiTopPanel, "BOTTOM")
	
	E:CreateMover(ElvuiLoc, "ElvuiLocMover", L["Top Infobar"], nil, nil, nil, "ALL,EUI")
	
	local f = CreateFrame("Frame", "ElvuiLocX", ElvuiLoc)
	f:SetHeight(23)
	f:SetWidth(E.MinimapSize / 6)
	f:SetFrameLevel(2)
	f:SetTemplate("Default", true)
	f:CreateShadow("Default")
	f:Point("RIGHT", ElvuiLoc, "LEFT", -2, 0)	
	
	local f = CreateFrame("Frame", "ElvuiLocY", ElvuiLoc)
	f:SetHeight(23)
	f:SetWidth(E.MinimapSize / 6)
	f:SetFrameLevel(2)
	f:SetTemplate("Default", true)
	f:CreateShadow("Default")
	f:Point("LEFT", ElvuiLoc, "RIGHT", 2, 0)

	local x,y = GetPlayerMapPosition("player")
	x = math.floor(100 * x)
	y = math.floor(100 * y)	
	
	ElvuiLoc.zone = ElvuiLoc:CreateFontString(nil, 'OVERLAY')
	ElvuiLoc.zone:FontTemplate(nil, nil, "THICKOUTLINE")
	ElvuiLoc.zone:SetPoint("CENTER")
	ElvuiLoc:EnableMouse(true)
	ElvuiLoc:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			ToggleFrame(WorldMapFrame)
		elseif button == "MiddleButton" then
			ToggleFrame(GameMenuFrame)
		else
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		end
	end)
	
	ElvuiLocX.coord = ElvuiLocX:CreateFontString(nil, 'OVERLAY')
	ElvuiLocX.coord:FontTemplate(nil, nil, "OUTLINE")
	ElvuiLocX.coord:SetPoint("CENTER", ElvuiLocX, "CENTER", 0, 0)
	ElvuiLocX.coord:SetText(x)	
	ElvuiLocX.coord:SetTextColor(23/255, 132/255, 209/255)
	
	ElvuiLocY.coord = ElvuiLocY:CreateFontString(nil, 'OVERLAY')
	ElvuiLocY.coord:FontTemplate(nil, nil, "OUTLINE")
	ElvuiLocY.coord:SetPoint("CENTER", ElvuiLocY, "CENTER", 0, 0)
	ElvuiLocY.coord:SetText(y)	
	ElvuiLocY.coord:SetTextColor(23/255, 132/255, 209/255)
	
	ElvuiLoc:SetScript("OnUpdate", function(self, elapsed)
		if(self.elapsed and self.elapsed > 0.2) then
			local x,y = GetPlayerMapPosition("player")
			local subZoneText = GetMinimapZoneText() or ""
			local zoneText = GetRealZoneText() or ""		
			local displayLine = ''
			if (subZoneText ~= "") and (subZoneText ~= zoneText) then
				displayLine = zoneText .. ": " .. subZoneText
			end
			if displayLine == '' then
				displayLine = zoneText
			end
			
			self.zone:SetText(displayLine)
			self.zone:SetTextColor(LO:GetLocTextColor())

			x = math.floor(100 * x)
			y = math.floor(100 * y)
			if x ==0 and y==0 then
				ElvuiLocX.coord:SetText("??")
				ElvuiLocY.coord:SetText("??")
			else
				ElvuiLocX.coord:SetText(x)
				ElvuiLocY.coord:SetText(y)				
			end
			self.elapsed = 0
		else
			self.elapsed = (self.elapsed or 0) + elapsed
		end	
	end)
end

function LO:CreateActionbarInfobar()
	local db = E.db.actionbar
	local backdrop = 0
	
	local mbar = CreateFrame('Frame', 'MainABInfobar', E.UIParent)
	mbar:SetFrameLevel(2)
	mbar:SetTemplate("Default", true)
	mbar:CreateShadow("Default")
	mbar:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 4)
	E:GetModule('DataTexts'):RegisterPanel(mbar, 3, 'ANCHOR_TOPLEFT', -17, 4)
	
	local num = (min(db.bar1.buttons, db.bar1.buttonsPerRow)) / 2
	
	local lbar = CreateFrame('Frame', 'ABLeftInfobar', E.UIParent)
	lbar:SetFrameLevel(2)
	lbar:SetTemplate("Default", true)
	lbar:CreateShadow("Default")
	lbar:Point('BOTTOMRIGHT', 'ElvUIParent', 'BOTTOM', -(4 + db['bar1'].buttonsize * num + db['bar1'].buttonspacing * (num + 1)), 4)
	E:GetModule('DataTexts'):RegisterPanel(lbar, 1, 'ANCHOR_TOPLEFT', -17, 4)

	local rbar = CreateFrame('Frame', 'ABRightInfobar', E.UIParent)
	rbar:SetFrameLevel(2)
	rbar:SetTemplate("Default", true)
	rbar:CreateShadow("Default")
	rbar:Point('BOTTOMLEFT', 'ElvUIParent', 'BOTTOM', 4 + db['bar4'].buttonsize * num + db['bar4'].buttonspacing * (num + 1), 4)
	E:GetModule('DataTexts'):RegisterPanel(rbar, 1, 'ANCHOR_TOPLEFT', -17, 4)
	
	self:UpdateActionbarInfobar()
end

function LO:UpdateActionbarInfobar()
	if E.db.datatexts.panels.MainABInfobar.left == '' and E.db.datatexts.panels.MainABInfobar.middle == '' and E.db.datatexts.panels.MainABInfobar.right == '' and E.db.datatexts.panels.LeftABInfobar == '' and E.db.datatexts.panels.RightABInfobar == '' then return; end

	local db = E.db.actionbar
	local backdrop = 0
	
	if db.bar1.backdrop then backdrop = 8 else backdrop = 0 end
	MainABInfobar:Size(min(db.bar1.buttons, db.bar1.buttonsPerRow) * (db.bar1.buttonsize + db.bar1.buttonspacing) - db.bar1.buttonspacing + backdrop, 23)
	if db.bar5.backdrop then backdrop = 4 else backdrop = 0 end
	ABLeftInfobar:Size(min(db.bar5.buttons, db.bar5.buttonsPerRow) * (db.bar5.buttonsize + db.bar5.buttonspacing) + backdrop, 23)
	if db.bar3.backdrop then backdrop = 4 else backdrop = 0 end
	ABRightInfobar:Size(min(db.bar3.buttons, db.bar3.buttonsPerRow) * (db.bar3.buttonsize + db.bar3.buttonspacing) + backdrop, 23)
end

function LO:CreateChatPanels()
	local SPACING = (E.PixelMode and 3 or 5)
	
	--Left Chat
	local lchat = CreateFrame('Frame', 'LeftChatPanel', E.UIParent)
	lchat:SetFrameStrata('BACKGROUND')
	lchat:Size(E.db.chat.leftpanelWidth, E.db.chat.leftpanelHeight)		
	lchat:Point('BOTTOMLEFT', E.UIParent, 4, 4)
	lchat:SetFrameLevel(lchat:GetFrameLevel() + 2)
	lchat:CreateBackdrop('Transparent')
	lchat.backdrop:SetAllPoints()
	E:CreateMover(lchat, 'LeftChatPanelMover', L['LeftChatPanel'], nil, nil, nil, 'ALL,CHAT')
	
	--Background Texture
	lchat.tex = lchat:CreateTexture(nil, 'OVERLAY')
	lchat.tex:SetInside()
	lchat.tex:SetTexture(E.db.chat.panelBackdropNameLeft)
	lchat.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)
	
	--Left Chat Tab
	local lchattab = CreateFrame('Frame', 'LeftChatTab', LeftChatPanel)
	lchattab:Point('TOPLEFT', lchat, 'TOPLEFT', 5, E.db["euiscript"].chatbar and -(5 + PANEL_HEIGHT) or -5)
	lchattab:Point('BOTTOMRIGHT', lchat, 'TOPRIGHT', -5, E.db["euiscript"].chatbar and -(5 + PANEL_HEIGHT)*2 or -(5 + PANEL_HEIGHT))
	lchattab:SetTemplate('Default', true)
	
	--Left Chat Data Panel
	local lchatdp = CreateFrame('Frame', 'LeftChatDataPanel', LeftChatPanel)
	lchatdp:Point('BOTTOMLEFT', lchat, 'BOTTOMLEFT', SPACING + SIDE_BUTTON_WIDTH, SPACING)
	lchatdp:Point('TOPRIGHT', lchat, 'BOTTOMRIGHT', -SPACING, (SPACING + PANEL_HEIGHT))
	lchatdp:SetTemplate('Default', true)
	
	E:GetModule('DataTexts'):RegisterPanel(lchatdp, 3, 'ANCHOR_TOPLEFT', -17, 4)
	
	--Left Chat Toggle Button
	local lchattb = CreateFrame('Button', 'LeftChatToggleButton', E.UIParent)
	lchattb.parent = LeftChatPanel
	LeftChatPanel.fadeFunc = ChatPanelLeft_OnFade
	lchattb:Point('TOPRIGHT', lchatdp, 'TOPLEFT', -(E.PixelMode and -1 or 1), 0)
	lchattb:Point('BOTTOMLEFT', lchat, 'BOTTOMLEFT', SPACING, SPACING)
	lchattb:SetTemplate('Default', true)
	lchattb:SetScript('OnEnter', ChatButton_OnEnter)
	lchattb:SetScript('OnLeave', ChatButton_OnLeave)
	lchattb:SetScript('OnClick', ChatButton_OnClick)
	lchattb.text = lchattb:CreateFontString(nil, 'OVERLAY')
	lchattb.text:FontTemplate()
	lchattb.text:SetPoint('CENTER')
	lchattb.text:SetJustifyH('CENTER')
	lchattb.text:SetText('<')
	
	--Right Chat
	local rchat = CreateFrame('Frame', 'RightChatPanel', E.UIParent)
	rchat:SetFrameStrata('BACKGROUND')
	rchat:Size(E.db.chat.rightpanelWidth, E.db.chat.rightpanelHeight)
	rchat:Point('BOTTOMRIGHT', E.UIParent, -4, 4)
	rchat:SetFrameLevel(lchat:GetFrameLevel() + 2)
	rchat:CreateBackdrop('Transparent')
	rchat.backdrop:SetAllPoints()	
	E:CreateMover(rchat, 'RightChatPanelMover', L['RightChatPanel'], nil, nil, nil, 'ALL,CHAT')
	
	--Background Texture
	rchat.tex = rchat:CreateTexture(nil, 'OVERLAY')
	rchat.tex:SetInside()
	rchat.tex:SetTexture(E.db.chat.panelBackdropNameRight)
	rchat.tex:SetAlpha(E.db.general.backdropfadecolor.a - 0.7 > 0 and E.db.general.backdropfadecolor.a - 0.7 or 0.5)	
	
	--Right Chat Tab
	local rchattab = CreateFrame('Frame', 'RightChatTab', RightChatPanel)
	rchattab:Point('TOPRIGHT', rchat, 'TOPRIGHT', -SPACING, -SPACING)
	rchattab:Point('BOTTOMLEFT', rchat, 'TOPLEFT', SPACING, -(SPACING + PANEL_HEIGHT))
	rchattab:SetTemplate('Default', true)
	
	--Right Chat Data Panel
	local rchatdp = CreateFrame('Frame', 'RightChatDataPanel', RightChatPanel)
	rchatdp:Point('BOTTOMLEFT', rchat, 'BOTTOMLEFT', SPACING, SPACING)
	rchatdp:Point('TOPRIGHT', rchat, 'BOTTOMRIGHT', -(SPACING + SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)
	rchatdp:SetTemplate('Default', true)
	E:GetModule('DataTexts'):RegisterPanel(rchatdp, 3, 'ANCHOR_TOPRIGHT', 17, 4)
	
	--Right Chat Toggle Button
	local rchattb = CreateFrame('Button', 'RightChatToggleButton', E.UIParent)
	rchattb.parent = RightChatPanel
	RightChatPanel.fadeFunc = ChatPanelRight_OnFade
	rchattb:Point('TOPLEFT', rchatdp, 'TOPRIGHT', (E.PixelMode and -1 or 1), 0)
	rchattb:Point('BOTTOMRIGHT', rchat, 'BOTTOMRIGHT', -SPACING, SPACING)
	rchattb:SetTemplate('Default', true)
	rchattb:RegisterForClicks('AnyUp')
	rchattb:SetScript('OnEnter', ChatButton_OnEnter)
	rchattb:SetScript('OnLeave', ChatButton_OnLeave)
	rchattb:SetScript('OnClick', ChatButton_OnClick)
	rchattb.text = rchattb:CreateFontString(nil, 'OVERLAY')
	rchattb.text:FontTemplate()
	rchattb.text:SetPoint('CENTER')
	rchattb.text:SetJustifyH('CENTER')
	rchattb.text:SetText('>')
	
	--Load Settings
	if E.db['LeftChatPanelFaded'] then
		LeftChatToggleButton:SetAlpha(0)
		LeftChatPanel:Hide()
	end	
	
	if E.db['RightChatPanelFaded'] then
		RightChatToggleButton:SetAlpha(0)
		RightChatPanel:Hide()
	end		
	
	self:ToggleChatPanels()
end

function LO:CreateMinimapPanels()
	local lminipanel = CreateFrame('Frame', 'LeftMiniPanel', Minimap)
	lminipanel:Point('TOPLEFT', Minimap, 'BOTTOMLEFT', -E.Border, (E.PixelMode and 0 or -3))
	lminipanel:Point('BOTTOMRIGHT', Minimap, 'BOTTOM', -E.Spacing, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
	lminipanel:SetTemplate('Default', true)
	E:GetModule('DataTexts'):RegisterPanel(lminipanel, 1, 'ANCHOR_BOTTOMLEFT', lminipanel:GetWidth() * 2, -4)
	
	local rminipanel = CreateFrame('Frame', 'RightMiniPanel', Minimap)
	rminipanel:Point('TOPRIGHT', Minimap, 'BOTTOMRIGHT', E.Border, (E.PixelMode and 0 or -3))
	rminipanel:Point('BOTTOMLEFT', lminipanel, 'BOTTOMRIGHT', (E.PixelMode and -1 or 1), 0)
	rminipanel:SetTemplate('Default', true)
	E:GetModule('DataTexts'):RegisterPanel(rminipanel, 1, 'ANCHOR_BOTTOM', 0, -4)
	
	if E.db.datatexts.minimapPanels then
		LeftMiniPanel:Show()
		RightMiniPanel:Show()
	else
		LeftMiniPanel:Hide()
		RightMiniPanel:Hide()
	end
	
	local configtoggle = CreateFrame('Button', 'ElvConfigToggle', Minimap)
	configtoggle:Point('TOPLEFT', rminipanel, 'TOPRIGHT', (E.PixelMode and -1 or 1), 0)
	configtoggle:Point('BOTTOMLEFT', rminipanel, 'BOTTOMRIGHT', (E.PixelMode and -1 or 1), 0)
	configtoggle:RegisterForClicks('AnyUp')
	configtoggle:Width(E.ConsolidatedBuffsWidth)
	configtoggle:SetTemplate('Default', true)
	configtoggle.text = configtoggle:CreateFontString(nil, 'OVERLAY')
	configtoggle.text:FontTemplate()
	configtoggle.text:SetText('C')
	configtoggle.text:SetPoint('CENTER')
	configtoggle.text:SetJustifyH('CENTER')
	configtoggle:SetScript('OnClick', function(self, btn) 
		if btn == 'LeftButton' then
			E:ToggleConfig()
		else
			E:BGStats()
		end
	end)
	configtoggle:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', 0, -4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L['Left Click:'], L['Toggle Configuration'], 1, 1, 1)
		
		if E.db.datatexts.battleground then
			GameTooltip:AddDoubleLine(L['Right Click:'], L['Show BG Texts'], 1, 1, 1)	
		end
		GameTooltip:Show()
	end)
	configtoggle:SetScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end

E:RegisterModule(LO:GetName())