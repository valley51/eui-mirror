﻿local mod	= DBM:NewMod(679, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7771 $"):sub(12, -3))
mod:SetCreatureID(60051, 60043, 59915, 60047)--Cobalt: 60051 Jade: 60043 Jasper: 59915
mod:SetModelID(41892)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local warnCobaltOverload			= mod:NewSpellAnnounce(115840, 4)
local warnJadeOverload				= mod:NewSpellAnnounce(115842, 4)
local warnJasperOverload			= mod:NewSpellAnnounce(115843, 4)
local warnAmethystOverload			= mod:NewSpellAnnounce(115844, 4)
--local warnCobaltGrasp				= mod:NewTargetAnnounce(116281, 3)
local warnJadeShards				= mod:NewSpellAnnounce(116223, 3)
local warnJasperChains				= mod:NewTargetAnnounce(130395, 4)
local warnAmethystPool				= mod:NewSpellAnnounce(116235, 3, nil, mod:IsMelee())
local warnGSD						= mod:NewSpellAnnounce(116008)
local warnBSD						= mod:NewSpellAnnounce(115861)
local warnPSD						= mod:NewSpellAnnounce(116060)
local warnRSD						= mod:NewSpellAnnounce(116038)

local specWarnOverloadSoon			= mod:NewSpecialWarning("SpecWarnOverloadSoon", nil, nil, nil, true)
--local specWarnCobaltGrasp			= mod:NewSpecialWarningDispel(116281, false)
local specWarnJasperChains			= mod:NewSpecialWarningYou(130395)
local yellJasperChains				= mod:NewYell(130395)
local specWarnAmethystPool			= mod:NewSpecialWarningMove(130774)

--local timerCobaltOverload			= mod:NewCastTimer(7, 115840)
--local timerJadeOverload			= mod:NewCastTimer(7, 115842)
--local timerJasperOverload			= mod:NewCastTimer(7, 115843)
--local timerAmethystOverload		= mod:NewCastTimer(7, 115844)
--local timerGobaltGrasp			= mod:NewTargetTimer(6, 116281)
--local timerGobaltGraspCD			= mod:NewCDTimer(12, 116281)--12-15second variations
local timerPetrification			= mod:NewNextTimer(76, 125091)
local timerJadeShardsCD				= mod:NewNextTimer(20.5, 116223)--Always 20.5 seconds
local timerJasperChainsCD			= mod:NewCDTimer(12, 130395)--11-13
local timerAmethystPoolCD			= mod:NewCDTimer(6, 116235, nil, mod:IsMelee())

local expectedBosses = 3
local Jade = EJ_GetSectionInfo(5773)
local Jasper = EJ_GetSectionInfo(5774)
local Cobalt = EJ_GetSectionInfo(5771)
local Amethyst = EJ_GetSectionInfo(5691)
local Overload = {
	["Cobalt"] = GetSpellInfo(115840),
	["Jade"] = GetSpellInfo(115842),
	["Jasper"] = GetSpellInfo(115843),
	["Amethyst"] = GetSpellInfo(115844)
}
local activePetrification = nil
local jasperChainsTargets = {}
mod:AddBoolOption("InfoFrame", true, "sound")

local RPN, GPN, BPN, PPN = 0, 0, 0, 0
local Nextoverloadboss
local SDSTAT, NOSTAT

local SDNOW = {
	["Rsdnow"] = {true} ,
	["Gsdnow"] = {true} ,
	["Bsdnow"] = {true} ,
	["Psdnow"] = {true}
}


local function 	ChecknextOverload()
	for i = 1, 4 do
		if UnitName("boss"..i) == Jasper then
			RPN = UnitPower("boss"..i)
		elseif UnitName("boss"..i) == Jade then
			GPN = UnitPower("boss"..i)
		elseif UnitName("boss"..i) == Cobalt then
			BPN = UnitPower("boss"..i)
		elseif UnitName("boss"..i) == Amethyst then
			PPN = UnitPower("boss"..i)
		end
	end
	if SDNOW["Rsdnow"] then RPN = 0 end
	if SDNOW["Gsdnow"] then GPN = 0 end
	if SDNOW["Bsdnow"] then BPN = 0 end
	if SDNOW["Psdnow"] then PPN = 0 end
	if RPN == 0 and GPN == 0 and BPN == 0 and PPN == 0 then return end
	Nextoverloadboss = math.max(RPN, GPN, BPN, PPN)
	if Nextoverloadboss == RPN then
		NOSTAT = L.NEXTR
	elseif Nextoverloadboss == GPN then
		NOSTAT = L.NEXTG
	elseif Nextoverloadboss == BPN then
		NOSTAT = L.NEXTB
	elseif Nextoverloadboss == PPN then
		NOSTAT = L.NEXTP
	end
	if mod.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(NOSTAT.."  "..SDSTAT)
		DBM.InfoFrame:Show(4, "cobalypower", SDNOW)
	end
end

local function warnJasperChainsTargets()
	warnJasperChains:Show(table.concat(jasperChainsTargets, "<, >"))
	table.wipe(jasperChainsTargets)
end

function mod:OnCombatStart(delay)
	activePetrification = nil
	table.wipe(jasperChainsTargets)
	if self:IsDifficulty("normal25", "heroic25") then
--		timerGobaltGraspCD:Start(-delay)
		timerJasperChainsCD:Start(-delay)
		timerJadeShardsCD:Start(-delay)
		timerAmethystPoolCD:Start(-delay)
		expectedBosses = 4--Only fight all 4 at once on 25man (excluding LFR)
	else
		expectedBosses = 3--Else you get a random set of 3/4
		--Timers here will require more work (IE scanning boss1-4 to determine which boss is NOT up then start timers for all but him)
	end	
	SDSTAT = L.SDNOT
	RPN, GPN, BPN, PPN = 0, 0, 0, 0
	SDNOW = {
	["Rsdnow"] = {true} ,
	["Gsdnow"] = {true} ,
	["Bsdnow"] = {true} ,
	["Psdnow"] = {true}
	}
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(SDSTAT)
		DBM.InfoFrame:Show(4, "cobalypower", SDNOW)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		SDSTAT = nil
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(130395) then
		jasperChainsTargets[#jasperChainsTargets + 1] = args.destName
		timerJasperChainsCD:Start()
		self:Unschedule(warnJasperChainsTargets)
		self:Schedule(0.3, warnJasperChainsTargets)
		if args:IsPlayer() then
			specWarnJasperChains:Show()
			yellJasperChains:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lx.mp3")--連線 快靠近
		end
	elseif args:IsSpellID(130774) and args:IsPlayer() then
		specWarnAmethystPool:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	elseif args:IsSpellID(115745) then
		if args.destName == Jasper then SDNOW["Rsdnow"] = true end
		if args.destName == Jade then SDNOW["Gsdnow"] = true end
		if args.destName == Cobalt then SDNOW["Bsdnow"] = true end
		if args.destName == Amethyst then SDNOW["Psdnow"] = true end
		if SDSTAT ~=nil then
			ChecknextOverload()
		end
		if args.sourceGUID == UnitGUID("target") then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_mbsh.mp3")--目標石化
		end
	end	
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(115745) then
		if args.destName == Jasper then SDNOW["Rsdnow"] = false end
		if args.destName == Jade then SDNOW["Gsdnow"] = false end
		if args.destName == Cobalt then SDNOW["Bsdnow"] = false end
		if args.destName == Amethyst then SDNOW["Psdnow"] = false end	
		ChecknextOverload()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(115840) then -- Cobalt
		warnCobaltOverload:Show()
		if activePetrification == "Cobalt" then
			timerPetrification:Cancel()
			SDSTAT = L.SDNOT
			ChecknextOverload()
		else
			ChecknextOverload()
		end
	elseif args:IsSpellID(115842) then -- Jade
		warnJadeOverload:Show()
		if activePetrification == "Jade" then
			timerPetrification:Cancel()
			SDSTAT = L.SDNOT
			ChecknextOverload()
		else
			ChecknextOverload()
		end
	elseif args:IsSpellID(115843) then -- Jasper
		warnJasperOverload:Show()
		if activePetrification == "Jasper" then
			timerPetrification:Cancel()
			SDSTAT = L.SDNOT
			ChecknextOverload()
		else
			ChecknextOverload()
		end
	elseif args:IsSpellID(115844) then -- Amethyst
		warnAmethystOverload:Show()
		if activePetrification == "Amethyst" then
			timerPetrification:Cancel()
			SDSTAT = L.SDNOT
			ChecknextOverload()
		else
			ChecknextOverload()
		end
	elseif args:IsSpellID(116223) then
		warnJadeShards:Show()
		timerJadeShardsCD:Start()
	elseif args:IsSpellID(116235) then
		warnAmethystPool:Show()
		timerAmethystPoolCD:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg, boss)
	if msg == L.Overload or msg:find(L.Overload) then--Cast trigger is an emote 5 seconds before, CLEU only shows explosion. Just like nefs electrocute
		self:SendSync("Overload", boss == Cobalt and "Cobalt" or boss == Jade and "Jade" or boss == Jasper and "Jasper" or boss == Amethyst and "Amethyst" or "Unknown")
	end
end

function mod:OnSync(msg, boss)
	-- if boss aprats from 10 yard and get Solid Stone, power no longer increase. If this, overlord not casts. So timer can be confusing. Disabled for find better way. 
	if msg == "Overload" and self:AntiSpam(2, 2) then
		specWarnOverloadSoon:Show(Overload[boss])
		if boss == "Cobalt" then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lscz.mp3") --藍色超載		
		elseif boss == "Jade" then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lvscz.mp3") --綠色超載
		elseif boss == "Jasper" then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_hscz.mp3") --紅色超載
		elseif boss == "Amethyst" then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zscz.mp3") --紫色超載
		end
		ChecknextOverload()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 60051 or cid == 60043 or cid == 59915 or cid == 60047 then--Fight is over. NYI, amethyst guardian CID is not yet known.
		expectedBosses = expectedBosses - 1
		if expectedBosses == 0 then
			DBM:EndCombat(self)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 115852 and self:AntiSpam(2) then
		activePetrification = "Cobalt"
		timerPetrification:Start()
		warnBSD:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lssh.mp3") --藍色石化
		SDSTAT = L.SDBLUE		
		ChecknextOverload()
	elseif spellId == 116006 and self:AntiSpam(2) then
		activePetrification = "Jade"
		timerPetrification:Start()
		warnGSD:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_lvssh.mp3") --綠色石化
		SDSTAT = L.SDGREEN
		ChecknextOverload()
	elseif spellId == 116036 and self:AntiSpam(2) then
		activePetrification = "Jasper"
		timerPetrification:Start()
		warnRSD:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_hssh.mp3") --紅色石化
		SDSTAT = L.SDRED
		ChecknextOverload()
	elseif spellId == 116057 and self:AntiSpam(2) then
		activePetrification = "Amethyst"
		timerPetrification:Start()
		warnPSD:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\ex_mop_zssh.mp3") --紫色石化
		SDSTAT = L.SDPURPLE
		ChecknextOverload()
	end
end
