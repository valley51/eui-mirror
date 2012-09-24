local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local Sticky = LibStub("LibSimpleSticky-1.0")

E.CreatedMovers = {}

local function SizeChanged(frame)
	if InCombatLockdown() then return; end
	frame.mover:Size(frame:GetSize())
end

local function GetPoint(obj)
	local point, anchor, secondaryPoint, x, y = obj:GetPoint()
	if not anchor then anchor = ElvUIParent end

	return string.format('%s\031%s\031%s\031%d\031%d', point, anchor:GetName(), secondaryPoint, E:Round(x), E:Round(y))
end

local function CreateMover(parent, name, text, overlay, snapOffset, postdrag, closeFunc, openFunc)
	if not parent then return end --If for some reason the parent isnt loaded yet
	if E.CreatedMovers[name].Created then return end
	
	if overlay == nil then overlay = true end
	local point, anchor, secondaryPoint, x, y = string.split('\031', GetPoint(parent))
	local f = CreateFrame("Button", name, E.UIParent)
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetClampedToScreen(true)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight())
	f.parent = parent
	f.name = name
	f.textSting = text
	f.postdrag = postdrag
	f.overlay = overlay
	f.snapOffset = snapOffset or -2
	f.closefunc = closeFunc
	f.openfunc = openFunc
	E.CreatedMovers[name].mover = f
	
	tinsert(E['snapBars'], f)
	
	--Create CloseButton X to close frame.
	if closeFunc and (type(closeFunc) == "function") then
		E.PopupDialogs[name] = {
			text = CLOSE.. ' '.. text.. '?',
			button1 = ACCEPT,
			button2 = CANCEL,
			OnAccept = function() f.closefunc(name); f:Hide(); end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = false,
		}	
		local c = CreateFrame("Button", nil, f)
		f.close = c
		c:Size(8)
		c:Point("TOPRIGHT", f, "TOPRIGHT", -1, -1)
		c:SetFrameLevel(f:GetFrameLevel()+1)
		E:GetModule('Skins'):HandleCloseButton(c)
		c.text:SetTextColor(1,0,0)
		c:SetScript("OnClick", function(self)
			E:StaticPopup_Show(self:GetParent().name)
		end)	
	end
	
	--Create OpenButton O to enabled frame.
	if openFunc and (type(openFunc) == 'function') then
		E.PopupDialogs[name..'open'] = {
			text = ENABLE.. ' '.. text.. '?',
			button1 = ACCEPT,
			button2 = CANCEL,
			OnAccept = function() f.openfunc(name); end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = false,
		}	
		local c = CreateFrame("Button", nil, f)
		f.open = c
		c:Size(8)
		c:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
		c:SetFrameLevel(f:GetFrameLevel()+1)
		E:GetModule('Skins'):HandleCloseButton(c)
		c.text:SetText('O')
		c.text:SetTextColor(.13,.69,.3)
		c:SetScript("OnClick", function(self)
			E:StaticPopup_Show(self:GetParent().name..'open')
		end)	
	end		
	
	if overlay == true then
		f:SetFrameStrata("DIALOG")
	else
		f:SetFrameStrata("BACKGROUND")
	end
	
	if E.db['movers'] and E.db['movers'][name] then
		if type(E.db['movers'][name]) == 'table' then
			f:SetPoint(E.db["movers"][name]["p"], E.UIParent, E.db["movers"][name]["p2"], E.db["movers"][name]["p3"], E.db["movers"][name]["p4"])
			E.db['movers'][name] = GetPoint(f)
			f:ClearAllPoints()
		end
		
		local point, anchor, secondaryPoint, x, y = string.split('\031', E.db['movers'][name])
		f:SetPoint(point, anchor, secondaryPoint, x, y)
	else

		f:SetPoint(point, anchor, secondaryPoint, x, y)
	end
	f:SetTemplate("Default", true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end	

		if E.db['general'].stickyFrames then
			Sticky:StartMoving(self, E['snapBars'], f.snapOffset, f.snapOffset, f.snapOffset, f.snapOffset)
		else
			self:StartMoving() 
		end
	end)
	
	f:SetScript("OnDragStop", function(self) 
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
		if E.db['general'].stickyFrames then
			Sticky:StopMoving(self)
		else
			self:StopMovingOrSizing()
		end

		--[[
			okay i'm too drunk to figure this out in my head, i need to adjust this so moving a mover to the topleft topright or bottomright corners of the screen calculates the point from their respective areas
			instead of the bottomleft always, this way moving a raid group to the topleft corner of the screen will cause the raid group to spawn to the right and down
			
			GetLeft(), GetTop(), GetRight(), GetBottom() all return values based on on the bottomleft corner of the screen
			
			top:
				need to calculate the distance from this point to the very top of the screen then make it negative
				-(screenHeight - 846)
				OMG YAY IT WORKS!!! NOW LETS TRY FOR THE RIGHT SIDE
				
			right:
				need to calculate the distance from this point to the far right of the screen then make it negative
				YAY SAME FORMULAR WORKS!@!
				
		]]
		
		local screenWidth, screenHeight, screenCenter = E.UIParent:GetRight(), E.UIParent:GetTop(), E.UIParent:GetCenter()
		local x, y = self:GetCenter()
		local point
		
		local LEFT = screenWidth / 3
		local RIGHT = screenWidth * 2 / 3
		local TOP = screenHeight / 2
		
		if y >= TOP then
			point = "TOP"
			y = -(screenHeight - self:GetTop())
		else
			point = "BOTTOM"
			y = self:GetBottom()
		end
		
		if x >= RIGHT then
			point = point..'RIGHT'
			x = self:GetRight() - screenWidth
		elseif x <= LEFT then
			point = point..'LEFT'
			x = self:GetLeft()
		else
			x = x - screenCenter
		end

		self:ClearAllPoints()
		self:Point(point, E.UIParent, point, x, y)

		E:SaveMoverPosition(name)
		
		if postdrag ~= nil and type(postdrag) == 'function' then
			postdrag(self, E:GetScreenQuadrant(self))
		end

		self:SetUserPlaced(false)
	end)	
	
	parent:SetScript('OnSizeChanged', SizeChanged)
	parent.mover = f
	parent:ClearAllPoints()

	parent:SetPoint(point, f, 0, 0)
	
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate()
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(unpack(E["media"].rgbvaluecolor))
	f:SetFontString(fs)
	f.text = fs
	
	f:SetScript("OnEnter", function(self) 
		self.text:SetTextColor(1, 1, 1)
		self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
	end)
	f:SetScript("OnLeave", function(self)
		self.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
		self:SetTemplate("Default", true)
	end)
	
	f:SetMovable(true)
	f:Hide()	
	
	if postdrag ~= nil and type(postdrag) == 'function' then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			postdrag(f, E:GetScreenQuadrant(f))
			self:UnregisterAllEvents()
		end)
	end	
	
	E.CreatedMovers[name].Created = true;
end

function E:HasMoverBeenMoved(name)
	if E.db["movers"] and E.db["movers"][name] then
		return true
	else
		return false
	end
end

function E:SaveMoverPosition(name)
	if not _G[name] then return end
	if not E.db.movers then E.db.movers = {} end

	E.db.movers[name] = GetPoint(_G[name])
end

function E:SetMoverSnapOffset(name, offset)
	if not _G[name] or not E.CreatedMovers[name] then return end
	E.CreatedMovers[name].mover.snapOffset = offset or -2
	E.CreatedMovers[name]["snapoffset"] = offset or -2
end

function E:SaveMoverDefaultPosition(name)
	if not _G[name] then return end

	E.CreatedMovers[name]["point"] = GetPoint(_G[name])
	E.CreatedMovers[name]["postdrag"](_G[name], E:GetScreenQuadrant(_G[name]))
end

function E:CreateMover(parent, name, text, overlay, snapoffset, postdrag, moverTypes, closeFunc, openFunc)
	if not moverTypes then moverTypes = 'ALL,GENERAL' end
	local p, p2, p3, p4, p5 = parent:GetPoint()
	
	if E.CreatedMovers[name] == nil then 
		E.CreatedMovers[name] = {}
		E.CreatedMovers[name]["parent"] = parent
		E.CreatedMovers[name]["text"] = text
		E.CreatedMovers[name]["overlay"] = overlay
		E.CreatedMovers[name]["postdrag"] = postdrag
		E.CreatedMovers[name]["snapoffset"] = snapOffset
		E.CreatedMovers[name]["closefunc"] = closeFunc
		E.CreatedMovers[name]["openfunc"] = openFunc
		E.CreatedMovers[name]["point"] = GetPoint(parent)

		E.CreatedMovers[name]["type"] = {}
		local types = {string.split(',', moverTypes)}
		for i = 1, #types do
			local moverType = types[i]
			E.CreatedMovers[name]["type"][moverType] = true
		end
	end	
	
	CreateMover(parent, name, text, overlay, snapoffset, postdrag, closeFunc, openFunc)
end

function E:ToggleMovers(show, moverType)
	for name, _ in pairs(E.CreatedMovers) do
		if not show then
			_G[name]:Hide()
		else
			if E.CreatedMovers[name]['type'][moverType] then
				_G[name]:Show()
			else
				_G[name]:Hide()
			end
		end
	end
end

function E:ResetMovers(arg)
	if arg == "" or arg == nil then
		for name, _ in pairs(E.CreatedMovers) do
			local f = _G[name]
			local point, anchor, secondaryPoint, x, y = string.split('\031', E.CreatedMovers[name]['point'])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
			
			for key, value in pairs(E.CreatedMovers[name]) do
				if key == "postdrag" and type(value) == 'function' then
					value(f, E:GetScreenQuadrant(f))
				end
			end
		end	
		self.db.movers = nil
	else
		for name, _ in pairs(E.CreatedMovers) do
			for key, value in pairs(E.CreatedMovers[name]) do
				local mover
				if key == "text" then
					if arg == value then 
						local f = _G[name]
						local point, anchor, secondaryPoint, x, y = string.split('\031', E.CreatedMovers[name]['point'])
						f:ClearAllPoints()
						f:SetPoint(point, anchor, secondaryPoint, x, y)				
						
						if self.db.movers then
							self.db.movers[name] = nil
						end
						
						if E.CreatedMovers[name]["postdrag"] ~= nil and type(E.CreatedMovers[name]["postdrag"]) == 'function' then
							E.CreatedMovers[name]["postdrag"](f, E:GetScreenQuadrant(f))
						end
					end
				end
			end	
		end
	end
end

--Profile Change
function E:SetMoversPositions()
	for name, _ in pairs(E.CreatedMovers) do
		local f = _G[name]
		local point, anchor, secondaryPoint, x, y
		if E.db["movers"] and E.db["movers"][name] and type(E.db["movers"][name]) == 'string' then
			point, anchor, secondaryPoint, x, y = string.split('\031', E.db["movers"][name])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		elseif f then
			point, anchor, secondaryPoint, x, y = string.split('\031', E.CreatedMovers[name]['point'])
			f:ClearAllPoints()
			f:SetPoint(point, anchor, secondaryPoint, x, y)
		end		
	end
end

--Called from core.lua
function E:LoadMovers()
	for n, _ in pairs(E.CreatedMovers) do
		local p, t, o, so, pd, cf, of
		for key, value in pairs(E.CreatedMovers[n]) do
			if key == "parent" then
				p = value
			elseif key == "text" then
				t = value
			elseif key == "overlay" then
				o = value
			elseif key == "snapoffset" then
				so = value
			elseif key == "postdrag" then
				pd = value
			elseif key == "closefunc" then
				cf = value
			elseif key == "openfunc" then
				of = value
			end
		end
		CreateMover(p, n, t, o, so, pd, cf, of)
	end
end