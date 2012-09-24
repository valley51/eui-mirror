local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

skadaWindows = {}
S.AddonPoints = {
	['Recount'] = {},
	['Omen'] = {},
	['Skada'] = {},
}

function S:EmbedSkadaWindow(window, width, height, point, relativeFrame, relativePoint, ofsx, ofsy)
	local barheight = E.private.skins.skada.barHeight
	window.db.barwidth = width
	window.db.barheight = barheight
	if window.db.enabletitle then 
		height = height - barheight
	end
	window.db.background.height = height
	window.db.spark = false
	window.db.barslocked = true
	window.bargroup:ClearAllPoints()
	window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	window.bargroup:SetFrameStrata('MEDIUM')
	
	Skada.displays["bar"].ApplySettings(Skada.displays["bar"], window)
end

function S:SaveEmbeddedAddonPoints(addon)
	if not IsAddOnLoaded(addon) then return; end
	
	if addon == 'Recount' then
		local point, _, anchor, x, y = Recount_MainWindow:GetPoint()
		S.AddonPoints[addon] = {point, E.UIParent, anchor, x, y}
	elseif addon == 'Omen' then
		local point, _, anchor, x, y = OmenAnchor:GetPoint()
		S.AddonPoints[addon] = {point, E.UIParent, anchor, x, y}
	end	
end

--Reset points of previous addon
function S:RemovePrevious(current)
	local lastAddon = self.lastAddon

	if lastAddon == 'Recount' then
		Recount_MainWindow:ClearAllPoints()
		local point, attachTo, anchor, x, y = unpack(S.AddonPoints[lastAddon])
		Recount_MainWindow:SetPoint(point, attachTo, anchor, x, y)
		Recount:LockWindows(false)
		Recount_MainWindow:SetParent(UIParent)
	elseif lastAddon == 'Omen' then
		OmenAnchor:ClearAllPoints()
		local point, attachTo, anchor, x, y = unpack(S.AddonPoints[lastAddon])
		OmenAnchor:SetPoint(point, attachTo, anchor, x, y)
		OmenAnchor:SetParent(UIParent)	
		OmenAnchor.SetFrameStrata = OmenAnchor.SetFrameStrataOld
		
		if Omen.db.profile.Locked ~= true then
			Omen.Grip:Show()
			Omen.VGrip1:Show()
			if Omen.db.profile.Bar.ShowTPS then
				Omen.VGrip2:Show()
			else
				Omen.VGrip2:Hide()
			end			
		end
	elseif lastAddon == 'Skada' then
		if not Skada.CreateWindow_ then
			Skada.CreateWindow_ = Skada.CreateWindow
			Skada.DeleteWindow_ = Skada.DeleteWindow
		end
		for _, window in pairs(skadaWindows) do
			window.bargroup:SetParent(UIParent)
		end		
	end
end


function S:EmbedSkada()
	local barSpacing = E:Scale(1)
	local borderWidth = E:Scale(2)
	local widthOffset = 4
	local heightOffset = 33
	local numBars = 8
	
	if E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'SHOWRIGHT' then
		widthOffset = 14
		heightOffset = 39
	end

	for _, window in pairs(skadaWindows) do
		window.bargroup:SetParent(RightChatPanel)
	end
	if #skadaWindows == 1 then
		self:EmbedSkadaWindow(skadaWindows[1], E.db.chat.rightpanelWidth - widthOffset, E.db.chat.rightpanelHeight - heightOffset, "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 6)
	elseif #skadaWindows == 2 then
		self:EmbedSkadaWindow(skadaWindows[1], ((E.db.chat.rightpanelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.chat.rightpanelHeight - heightOffset,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 6)
		self:EmbedSkadaWindow(skadaWindows[2], ((E.db.chat.rightpanelWidth - widthOffset) / 2) - (borderWidth + E.mult), E.db.chat.rightpanelHeight - heightOffset,  "BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 2, 6)
	elseif #skadaWindows > 2 then
		self:EmbedSkadaWindow(skadaWindows[1], ((E.db.chat.rightpanelWidth - widthOffset) / 2) - (borderWidth + E.mult) + 1, E.db.chat.rightpanelHeight - heightOffset,  "BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -2, 6)
		self:EmbedSkadaWindow(skadaWindows[2], ((E.db.chat.rightpanelWidth - widthOffset) / 2) - (borderWidth + E.mult), (E.db.chat.rightpanelHeight - heightOffset) / 2 - 3,  "BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 2, 6)
		self:EmbedSkadaWindow(skadaWindows[3], skadaWindows[2].db.barwidth, (E.db.chat.rightpanelHeight - heightOffset) / 2 - 2,  "BOTTOMLEFT", skadaWindows[2].bargroup.backdrop, "TOPLEFT", 2, 3)
	end	
end

function S:SetEmbedRight(addon)
	self:RemovePrevious(addon)
	if not IsAddOnLoaded(addon) then return; end
	if self.lastAddon == nil then self.lastAddon = addon; end

	if addon == 'Recount' then
		Recount:LockWindows(true)
		
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 0, 4)

		if E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'SHOWRIGHT' then
			Recount_MainWindow:SetWidth(E.db.chat.rightpanelWidth - 10)
			Recount_MainWindow:SetHeight(E.db.chat.rightpanelHeight - 26)
		else
			Recount_MainWindow:SetWidth(E.db.chat.rightpanelWidth)
			Recount_MainWindow:SetHeight(E.db.chat.rightpanelHeight - 20)		
		end		
		Recount_MainWindow:SetParent(RightChatPanel)	
		self.lastAddon = addon
	elseif addon == 'Omen' then
		Omen.db.profile.Locked = true
		Omen:UpdateGrips()
		if not Omen.oldUpdateGrips then
			Omen.oldUpdateGrips = Omen.UpdateGrips
		end
		Omen.UpdateGrips = function(...)
			local db = Omen.db.profile
			if E.global.skins.embedRight == 'Omen' then
				Omen.VGrip1:ClearAllPoints()
				Omen.VGrip1:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip1, 0)
				Omen.VGrip1:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip1, 0)
				Omen.VGrip2:ClearAllPoints()
				Omen.VGrip2:SetPoint("TOPLEFT", Omen.BarList, "TOPLEFT", db.VGrip2, 0)
				Omen.VGrip2:SetPoint("BOTTOMLEFT", Omen.BarList, "BOTTOMLEFT", db.VGrip2, 0)
				Omen.Grip:Hide()
				if db.Locked then
					Omen.VGrip1:Hide()
					Omen.VGrip2:Hide()
				else
					Omen.VGrip1:Show()
					if db.Bar.ShowTPS then
						Omen.VGrip2:Show()
					else
						Omen.VGrip2:Hide()
					end
				end			
			else
				Omen.oldUpdateGrips(...)
			end
		end
		
		if not Omen.oldSetAnchors then
			Omen.oldSetAnchors = Omen.SetAnchors
		end
		Omen.SetAnchors = function(...)
			if E.global.skins.embedRight == 'Omen' then return; end
			Omen.oldSetAnchors(...)
		end
		
		OmenAnchor:ClearAllPoints()
		OmenAnchor:SetPoint("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 0, 4)
		
		if E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'SHOWRIGHT' then
			OmenAnchor:SetWidth(E.db.chat.rightpanelWidth - 10)
			OmenAnchor:SetHeight(E.db.chat.rightpanelHeight - 35)
		else
			OmenAnchor:SetWidth(E.db.chat.rightpanelWidth)
			OmenAnchor:SetHeight(E.db.chat.rightpanelHeight - 29)		
		end
		
		OmenAnchor:SetParent(RightChatPanel)
		OmenAnchor:SetFrameStrata('LOW')
		if not OmenAnchor.SetFrameStrataOld then
			OmenAnchor.SetFrameStrataOld = OmenAnchor.SetFrameStrata
		end
		OmenAnchor.SetFrameStrata = E.noop
		
		local StartMoving = Omen.Title:GetScript('OnMouseDown')
		local StopMoving = Omen.Title:GetScript('OnMouseUp')
		Omen.Title:SetScript("OnMouseDown", function()
			if E.global.skins.embedRight == 'Omen' then return end
			StartMoving()
		end)
		
		Omen.Title:SetScript("OnMouseUp", function()
			if E.global.skins.embedRight == 'Omen' then return end
			StopMoving()
		end)	

		Omen.BarList:SetScript("OnMouseDown", function()
			if E.global.skins.embedRight == 'Omen' then return end
			StartMoving()
		end)
		
		Omen.BarList:SetScript("OnMouseUp", function()
			if E.global.skins.embedRight == 'Omen' then return end
			StopMoving()
		end)				
		
		self.lastAddon = addon
	elseif addon == 'Skada' then
		-- Update pre-existing displays
		table.wipe(skadaWindows)
		for _, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
			tinsert(skadaWindows, window)
		end
	
		self:RemovePrevious(addon)

		function Skada:CreateWindow(name, db)
			Skada:CreateWindow_(name, db)
			
			table.wipe(skadaWindows)
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(skadaWindows, window)
			end	
			
			if E.global.skins.embedRight == 'Skada' then
				S:EmbedSkada()
			end
		end
		
		function Skada:DeleteWindow(name)
			Skada:DeleteWindow_(name)
			
			table.wipe(skadaWindows)
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(skadaWindows, window)
			end	
			
			if E.global.skins.embedRight == 'Skada' then
				S:EmbedSkada()
			end
		end
		
		self:EmbedSkada()
		self.lastAddon = addon
	end
end