local E, L, V, P, G, _ = unpack(select(2, ...)); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

function E:EnableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		EnableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end	
end

function E:DisableAddon(addon)
	local _, _, _, _, _, reason, _ = GetAddOnInfo(addon)
	if reason ~= "MISSING" then 
		DisableAddOn(addon) 
		ReloadUI() 
	else 
		print("|cffff0000Error, Addon '"..addon.."' not found.|r") 
	end
end

function E:ResetGold()
	ElvData.gold = nil;
	ReloadUI();
end

function FarmMode()
	if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT); return; end
	if E.private.general.minimap.enable ~= true then return; end
	if Minimap:IsShown() then
		UIFrameFadeOut(Minimap, 0.3)
		UIFrameFadeIn(FarmModeMap, 0.3) 
		Minimap.fadeInfo.finishedFunc = function() Minimap:Hide(); _G.MinimapZoomIn:Click(); _G.MinimapZoomOut:Click(); Minimap:SetAlpha(1) end
		FarmModeMap.enabled = true
	else
		UIFrameFadeOut(FarmModeMap, 0.3)
		UIFrameFadeIn(Minimap, 0.3) 
		FarmModeMap.fadeInfo.finishedFunc = function() FarmModeMap:Hide(); _G.MinimapZoomIn:Click(); _G.MinimapZoomOut:Click(); Minimap:SetAlpha(1) end
		FarmModeMap.enabled = false
	end
end

function E:FarmMode(msg)
	if E.private.general.minimap.enable ~= true then return; end
	if msg and type(tonumber(msg))=="number" and tonumber(msg) <= 500 and tonumber(msg) >= 20 and not InCombatLockdown() then
		E.db.farmSize = tonumber(msg)
		FarmModeMap:Size(tonumber(msg))
	end
	
	FarmMode()
end

local channel = 'PARTY'
local target = nil;
function E:ElvSaysChannel(chnl)
	channel = chnl
	E:Print(string.format('ElvSays channel has been changed to %s.', chnl))
end

function E:ElvSaysTarget(tgt)
	target = tgt
	E:Print(string.format('ElvSays target has been changed to %s.', tgt))
end

function E:ElvSays(msg)
	if channel == 'WHISPER' and target == nil then
		E:Print('You need to set a whisper target.')
		return
	end
	SendAddonMessage('ElvSays', msg, channel, target)
end

function E:Grid(msg)
	if msg and type(tonumber(msg))=="number" and tonumber(msg) <= 256 and tonumber(msg) >= 4 then
		E.db.gridSize = msg
		E:Grid_Show()
	else 
		if EGrid then		
			E:Grid_Hide()
		else 
			E:Grid_Show()
		end
	end
end

function E:LuaError(msg)
	msg = string.lower(msg)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
		E:Print("Lua errors off.")
	else
		E:Print("/luaerror on - /luaerror off")
	end
end

function E:FoolsHowTo()
	E:Print('Thank you for using ElvUI and participating in this years april fools day joke. Type "/aprilfools" in chat without quotes to fix your UI back to normal. If you liked this years joke please let us know about it at tukui.org.')
end

function E:DisableAprilFools()
	E.global.aprilFools = true;
	ReloadUI();
end

function E:BGStats()
	local DT = E:GetModule('DataTexts')
	DT.ForceHideBGStats = nil;
	DT:LoadDataTexts()
	
	E:Print(L['Battleground datatexts will now show again if you are inside a battleground.'])
end

local print = print
local tonumber = tonumber
local MacroEditBox = MacroEditBox
local MacroEditBox_OnEvent = MacroEditBox:GetScript("OnEvent")

local function OnCallback(command)
	MacroEditBox_OnEvent(MacroEditBox, "EXECUTE_CHAT_LINE", command)
end

function E:SlashIn(msg)
	self.ScheduleTimer = LibStub("AceTimer-3.0").ScheduleTimer

	local secs, command = msg:match("^([^%s]+)%s+(.*)$")
	secs = tonumber(secs)
	if (not secs) or (#command == 0) then
		local prefix = "|cff33ff99EUI|r:"
		print(prefix, "usage:\n /in <seconds> <command>")
		print(prefix, "example:\n /in 1.5 /say hi")
	else
		self:ScheduleTimer(OnCallback, secs, command)
	end
end

function E:EuiAt(input)
	local UF = E:GetModule('UnitFrames')
	
	DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP1"],34/255,177/255,76/255)
	
	local name, realm = UnitName("target")

	if name == nil then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP2"],1,0,0)
		return
	end
	
	local atname = name.. (realm and realm ~= "" and "-"..realm or "")

	if UF.db.units.attention.enable ~= true then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP3"],1,0,0)
		return
	end
	if InCombatLockdown() then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP4"],1,0,0)
		return
	end
	
	local findit
	for k, v in pairs(E.AttentionList) do
		if v == atname then
			findit = k
			break
		end
	end
	
	if findit then
		DEFAULT_CHAT_FRAME:AddMessage(atname.. L["ATTENTION_TIP5"],1,0,0)
		return
	else
		table.insert(E.AttentionList, atname)
		DEFAULT_CHAT_FRAME:AddMessage(atname.. L["ATTENTION_TIP6"], 34/255,177/255,76/255);
		UF:CreateAndUpdateHeaderGroup('attention')
	end
end

function E:EuiDt(input)
	local UF = E:GetModule('UnitFrames')
	
	DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP7"],34/255,177/255,76/255)
	
	local name, realm = UnitName("target")
	
	if name == nil then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP2"],1,0,0)
		return
	end
	
	local atname = name.. (realm and realm ~= "" and "-"..realm or "")
	
	if UF.db.units.attention.enable ~= true then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP3"],1,0,0)
		return
	end
	if InCombatLockdown() then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP4"],1,0,0)
		return
	end
	
	local findit
	for k, v in pairs(E.AttentionList) do
		if v == atname then
			findit = k
			break
		end
	end
	if findit == nil then
		DEFAULT_CHAT_FRAME:AddMessage(L["ATTENTION_TIP9"],1,0,0)
		return
	else
		table.remove(E.AttentionList, findit)
		DEFAULT_CHAT_FRAME:AddMessage(atname.. L["ATTENTION_TIP10"],34/255,177/255,76/255)
		UF:CreateAndUpdateHeaderGroup('attention')
	end
end

function E:LoadCommands()
	self:RegisterChatCommand("ec", "ToggleConfig")
	self:RegisterChatCommand("elvui", "ToggleConfig")
	self:RegisterChatCommand("eui", "ToggleConfig")
	
	self:RegisterChatCommand('in', 'SlashIn')
	self:RegisterChatCommand('euiat', 'EuiAt')
	self:RegisterChatCommand('euidt', 'EuiDt')
	self:RegisterChatCommand('bgstats', 'BGStats')
	self:RegisterChatCommand('moreinfo', 'FoolsHowTo')
	self:RegisterChatCommand('aprilfools', 'DisableAprilFools')
	self:RegisterChatCommand('luaerror', 'LuaError')
	self:RegisterChatCommand('egrid', 'Grid')
	self:RegisterChatCommand("moveui", "ToggleConfigMode")
	self:RegisterChatCommand("resetui", "ResetUI")
	self:RegisterChatCommand("enable", "EnableAddon")
	self:RegisterChatCommand("disable", "DisableAddon")
	self:RegisterChatCommand('resetgold', 'ResetGold')
	self:RegisterChatCommand('farmmode', 'FarmMode')
	self:RegisterChatCommand('elvsays', 'ElvSays')
	self:RegisterChatCommand('elvsayschannel', 'ElvSaysChannel')
	self:RegisterChatCommand('elvsaystarget', 'ElvSaysTarget')
	if E.ActionBars then
		self:RegisterChatCommand('kb', E.ActionBars.ActivateBindMode)
	end
end