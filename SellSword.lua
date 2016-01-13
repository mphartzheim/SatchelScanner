-- Coded by: joypunk aka Seintefie / US-Thrall
-- Based on: Satchel Scanner by Exzu / EU-Aszune with modifications inspired by curse.com user dardack

-- This file is part of SellSword.

-- SellSword is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- SellSword is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with SellSword.  If not, see <http://www.gnu.org/licenses/>.

local addon, C = ...

SellSwordDB = {}
SellSwordCharDB = {}

C.charDefaults = {
  ["sso_autoStart"] = true,
  ["sso_intervalTimer"] = 3,
  ["sso_raidWarn"] = false,
  ["sso_soundWarn"] = false,
  ["sso_scanForTanks"] = true,
  ["sso_scanForHeal"] = true,
  ["sso_scanForDPS"] = true,
  ["sso_scanForWoD"] = true,
  ["sso_scanForTW"] = true,
  ["sso_scanForTW_BC"] = true,
  ["sso_scanForTW_LK"] = true,
  ["sso_scanForTW_CT"] = true,
  ["sso_scanForLFR"] = true,
  ["sso_scanForLFR_HM"] = true,
  ["sso_scanForLFR_HM_WC"] = true,
  ["sso_scanForLFR_HM_AS"] = true,
  ["sso_scanForLFR_HM_IR"] = true,
  ["sso_scanForLFR_BRF"] = true,
  ["sso_scanForLFR_BRF_SW"] = true,
  ["sso_scanForLFR_BRF_BF"] = true,
  ["sso_scanForLFR_BRF_IA"] = true,
  ["sso_scanForLFR_BRF_BC"] = true,
  ["sso_scanForLFR_HFC"] = true,
  ["sso_scanForLFR_HFC_HB"] = true,
  ["sso_scanForLFR_HFC_HoB"] = true,
  ["sso_scanForLFR_HFC_BoS"] = true,
  ["sso_scanForLFR_HFC_DR"] = true,
  ["sso_scanForLFR_HFC_BG"] = true,
}

C.dungeonVar = {
  [789]  = {sVarKey = "sso_ScanForWoD",         enabled = true, type = "WoD", dungeon = " Heroic ", }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [744]  = {sVarKey = "sso_ScanForTW_BC",       enabled = true, type = "TW",  dungeon = " BC ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [995]  = {sVarKey = "sso_ScanForTW_LK",       enabled = true, type = "TW",  dungeon = " LK ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [1146] = {sVarKey = "sso_ScanForTW_CT",       enabled = true, type = "TW",  dungeon = " Cata ",   }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [849]  = {sVarKey = "sso_ScanForLFR_HM_WC",   enabled = true, type = "LFR", dungeon = " WC ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [850]  = {sVarKey = "sso_ScanForLFR_HM_AS",   enabled = true, type = "LFR", dungeon = " AS ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [851]  = {sVarKey = "sso_ScanForLFR_HM_IR",   enabled = true, type = "LFR", dungeon = " IR ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [847]  = {sVarKey = "sso_ScanForLFR_BRF_SW",  enabled = true, type = "LFR", dungeon = " SW ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [846]  = {sVarKey = "sso_ScanForLFR_BRF_BF",  enabled = true, type = "LFR", dungeon = " BF ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [848]  = {sVarKey = "sso_ScanForLFR_BRF_IA",  enabled = true, type = "LFR", dungeon = " IA ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [823]  = {sVarKey = "sso_ScanForLFR_BRF_BC",  enabled = true, type = "LFR", dungeon = " BC ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [982]  = {sVarKey = "sso_ScanForLFR_HFC_HB",  enabled = true, type = "LFR", dungeon = " HB ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [983]  = {sVarKey = "sso_ScanForLFR_HFC_HoB", enabled = true, type = "LFR", dungeon = " HoB ",    }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [984]  = {sVarKey = "sso_ScanForLFR_HFC_BoS", enabled = true, type = "LFR", dungeon = " BoS ",    }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [985]  = {sVarKey = "sso_ScanForLFR_HFC_DR",  enabled = true, type = "LFR", dungeon = " DR ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
  [986]  = {sVarKey = "sso_ScanForLFR_HFC_BG",  enabled = true, type = "LFR", dungeon = " BG ",     }, -- Future use: tank = true, heal = true, dps = true, raidWarn = false, soundWarn = false},
}

local sellSword = CreateFrame("Frame", "sellSwordFrame", UIParent)
sellSwordFrame:RegisterEvent("ADDON_LOADED")
sellSwordFrame:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "SellSword" then
    local function copyCharDefaults(sv, df)
      if type(sv) ~= "table" then sv = {} end
      if type(df) ~= "table" then return sv end
      for k, v in pairs(df) do
        if type(v) == "table" then
          sv[k] = copyCharDefaults(sv[k], v)
        elseif type(v) ~= type(sv[k]) then
          sv[k] = v
        end
      end
      return sv
    end

    SellSwordCharDB = copyCharDefaults(SellSwordCharDB, C.charDefaults)
    self.charDB = SellSwordCharDB
    self:UnregisterEvent("ADDON_LOADED")
  end

end)

-- Testing GUI Stuff
local ssf = sellSwordFrame
ssf.width = 250
ssf.height = 150
ssf:SetFrameStrata("BACKGROUND")
ssf:SetSize(ssf.width, ssf.height)
ssf:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
ssf:SetBackdrop({
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	-- edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	-- tile     = true,
	-- tileSize = 32,
	-- edgeSize = 32,
	-- insets   = { left = 8, right = 8, top = 8, bottom = 8 }
})
ssf:SetBackdropColor(1, 0, 1, 0.75)
ssf:EnableMouse(true)
ssf:EnableMouseWheel(true)

-- Make movable/resizable
ssf:SetMovable(true)
ssf:SetResizable(enable)
ssf:SetMinResize(100, 100)
ssf:RegisterForDrag("LeftButton")
ssf:SetScript("OnDragStart", ssf.StartMoving)
ssf:SetScript("OnDragStop", ssf.StopMovingOrSizing)
ssf:SetScript("OnHide", ssf.StopMovingOrSizing)

-- -- Close button
-- local closeButton = CreateFrame("Button", nil, ssf, "UIPanelButtonTemplate")
-- closeButton:SetPoint("BOTTOM", 0, 10)
-- closeButton:SetHeight(25)
-- closeButton:SetWidth(70)
-- closeButton:SetText(CLOSE)
-- closeButton:SetScript("OnClick", function(self)
-- 	HideParentPanel(self)
-- end)
-- ssf.closeButton = closeButton

local tankMessageFrame = CreateFrame("ScrollingMessageFrame", nil, ssf)
local tmf = tankMessageFrame
tmf:SetPoint("TOPLEFT", ssf, "TOPLEFT", 0, 0) -- Annoying arbitrary numbers!
tmf:SetSize(80, ssf.height - 20) -- Annoying arbitrary numbers!
tmf:SetFontObject(GameFontNormal)
tmf:SetTextColor(1, 1, 1, 1) -- default color
tmf:SetJustifyH("LEFT")
tmf:SetHyperlinksEnabled(true)
tmf:SetFading(false)
tmf:SetMaxLines(300)
ssf.tankMessageFrame = tankMessageFrame

for i = 1, 25 do
	tmf:AddMessage(i .. "Scanning...")
end

local healMessageFrame = CreateFrame("ScrollingMessageFrame", nil, ssf)
local hmf = healMessageFrame
hmf:SetPoint("TOPLEFT", tmf, "TOPRIGHT", 5, 0) -- Annoying arbitrary numbers!
hmf:SetSize(80, ssf.height - 20) -- Annoying arbitrary numbers!
hmf:SetFontObject(GameFontNormal)
hmf:SetTextColor(1, 1, 1, 1) -- default color
hmf:SetJustifyH("LEFT")
hmf:SetHyperlinksEnabled(true)
hmf:SetFading(false)
hmf:SetMaxLines(300)
ssf.healMessageFrame = healMessageFrame

for i = 1, 10 do
	hmf:AddMessage(i .. "Scanning...")
end

local dpsMessageFrame = CreateFrame("ScrollingMessageFrame", nil, ssf)
local dmf = dpsMessageFrame
dmf:SetPoint("TOPLEFT", hmf, "TOPRIGHT", 5, 0) -- Annoying arbitrary numbers!
dmf:SetSize(80, ssf.height - 20) -- Annoying arbitrary numbers!
dmf:SetFontObject(GameFontNormal)
dmf:SetTextColor(1, 1, 1, 1) -- default color
dmf:SetJustifyH("LEFT")
dmf:SetHyperlinksEnabled(true)
dmf:SetFading(false)
dmf:SetMaxLines(300)
ssf.dpsMessageFrame = dpsMessageFrame

for i = 1, 5 do
	dmf:AddMessage(i .. "Scanning...")
end

-------------------------------------------------------------------------------
-- Scroll bar
-------------------------------------------------------------------------------
local tankScrollBar = CreateFrame("Slider", nil, ssf, "UIPanelScrollBarTemplate")
local tsb = tankScrollBar
tsb:SetMinMaxValues(0, ssf.height / 10) -- Max Value needs to adjust based on frame height and # of lines to show
tsb:SetValueStep(1)
tsb.scrollStep = 1
ssf.tankScrollBar = tankScrollBar

tsb:SetScript("OnValueChanged", function(self, value)
	tmf:SetScrollOffset(select(2, tsb:GetMinMaxValues()) - value)
end)

tsb:SetValue(select(2, tsb:GetMinMaxValues()))

local healScrollBar = CreateFrame("Slider", nil, ssf, "UIPanelScrollBarTemplate")
local hsb = healScrollBar
hsb:SetMinMaxValues(0, ssf.height / 10) -- Max Value needs to adjust based on frame height and # of lines to show
hsb:SetValueStep(1)
hsb.scrollStep = 1
ssf.healScrollBar = healScrollBar

hsb:SetScript("OnValueChanged", function(self, value)
	hmf:SetScrollOffset(select(2, hsb:GetMinMaxValues()) - value)
end)

hsb:SetValue(select(2, hsb:GetMinMaxValues()))

local dpsScrollBar = CreateFrame("Slider", nil, ssf, "UIPanelScrollBarTemplate")
local dsb = dpsScrollBar
dsb:SetMinMaxValues(0, ssf.height / 10) -- Max Value needs to adjust based on frame height and # of lines to show
dsb:SetValueStep(1)
dsb.scrollStep = 1
ssf.dpsScrollBar = dpsScrollBar

dsb:SetScript("OnValueChanged", function(self, value)
	dmf:SetScrollOffset(select(2, dsb:GetMinMaxValues()) - value)
end)

dsb:SetValue(select(2, dsb:GetMinMaxValues()))

--ssf:SetScript("OnMouseWheel", function(self, delta)
tmf:SetScript("OnMouseWheel", function(self, delta)
	local cur_val = tsb:GetValue()
	local min_val, max_val = tsb:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math.min(max_val, cur_val + 1)
		tsb:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math.max(min_val, cur_val - 1)
		tsb:SetValue(cur_val)
	end
end)

hmf:SetScript("OnMouseWheel", function(self, delta)
	local cur_val = hsb:GetValue()
	local min_val, max_val = hsb:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math.min(max_val, cur_val + 1)
		hsb:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math.max(min_val, cur_val - 1)
		hsb:SetValue(cur_val)
	end
end)

dmf:SetScript("OnMouseWheel", function(self, delta)
	local cur_val = dsb:GetValue()
	local min_val, max_val = dsb:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math.min(max_val, cur_val + 1)
		dsb:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math.max(min_val, cur_val - 1)
		dsb:SetValue(cur_val)
	end
end)

-- Scanner
-- function satchelFinder(id)
--   local eligible, forTank, forHealer, forDamage, itemCount, money, xp = GetLFGRoleShortageRewards(id, 1)
--   local satchelQueues = {forTank, forHealer, forDamage}
--   if (itemCount ~= 0 or money ~= 0 or xp ~= 0) then
--     return satchelQueues
--   else
--     return {false, false, false}
--   end
-- end
--
--
-- if event == "LFG_UPDATE_RANDOM_INFO" then
--   -- Reset flags to pick up any changes
--   for id in pairs(dungeonVar) do
--     dungeonVar[id].Tank = false
--     dungeonVar[id].Heal = false
--     dungeonVar[id].DPS = false
--   end
--   -- Scan WoD Heroics
--   if scanForWoD then
--     classScanner(789)
--   end
--   -- Scan TW Dungeons
--   if scanForTW then
--     classScanner(744) -- The Burning Crusade
--     classScanner(995) -- Wrath of the Lich King
--     classScanner(1146) -- Cataclysm
--   end
--   -- Scan LFR Raids
--   if scanForLFR then
--     classScanner(849) -- Walled City
--     classScanner(850) -- Arcane Sanctum
--     classScanner(851) -- Imperator's Rise
--     classScanner(847) -- Slagworks
--     classScanner(846) -- The Black Forge
--     classScanner(848) -- Iron Assembly
--     classScanner(823) -- Blackhand's Crucible
--     classScanner(982) -- Hellbreach
--     classScanner(983) -- Halls of Blood
--     classScanner(984) -- Bastion of Shadows
--     classScanner(985) -- Destructor's Rise
--     classScanner(986) -- The Black Gate
--   end
--   -- Build Queue Text
--   buildQueueText()
-- end
--
-- function classScanner(id)
--   classQueues = satchelFinder(id)
--   if scanForTank and classQueues[1] and dungeonVar[id].Enabled then
--     dungeonVar[id].Tank = true
--   else
--     dungeonVar[id].Tank = false
--     textDatabase.tankScanningText.textFrame:SetText(classScan[2])
--     textDatabase.tankScanningText.textFrame:SetTextColor(unpack(yellowColor))
--   end
--   if scanForHeal and classQueues[2] and dungeonVar[id].Enabled  then
--     dungeonVar[id].Heal = true
--   else
--     dungeonVar[id].Heal = false
--     textDatabase.healScanningText.textFrame:SetText(classScan[2])
--     textDatabase.healScanningText.textFrame:SetTextColor(unpack(yellowColor))
--   end
--   if scanForDps and classQueues[3] and dungeonVar[id].Enabled  then
--     dungeonVar[id].DPS = true
--   else
--     dungeonVar[id].DPS = false
--     textDatabase.dpsScanningText.textFrame:SetText(classScan[2])
--     textDatabase.dpsScanningText.textFrame:SetTextColor(unpack(yellowColor))
--   end
-- end
--
-- function buildQueueText()
--   local tankQueueText = ""
--   local healQueueText = ""
--   local dpsQueueText = ""
--
--   for id in pairs(dungeonVar) do -- Need to make this iterate in order, really pissing me off that it's random.
--     if dungeonVar[id].Tank then
--       tankQueueText = tankQueueText .. dungeonVar[id].Type .. dungeonVar[id].Dungeon .. "| "
--       -- Temporarily concatenating the Type and Dungeon. Ideally, if this could iterate in order then this
--       -- would list the Type once with the Dungeons in that type behind it.
--       -- Ex. "WoD - Heroic // LFR - HB BoS TBG"
--       textDatabase.tankScanningText.textFrame:SetText(classScan[3])
--       textDatabase.tankScanningText.textFrame:SetTextColor(unpack(greenColor))
--     end
--     if dungeonVar[id].Heal then
--       healQueueText = healQueueText .. dungeonVar[id].Type .. dungeonVar[id].Dungeon .. "| "
--       textDatabase.healScanningText.textFrame:SetText(classScan[3])
--       textDatabase.healScanningText.textFrame:SetTextColor(unpack(greenColor))
--     end
--     if dungeonVar[id].DPS then
--       dpsQueueText = dpsQueueText .. dungeonVar[id].Type .. dungeonVar[id].Dungeon .. "| "
--       textDatabase.dpsScanningText.textFrame:SetText(classScan[3])
--       textDatabase.dpsScanningText.textFrame:SetTextColor(unpack(greenColor))
--     end
--   end
--
--   -- Raid Warning, Sounds, and resetting Queue Variable if nothing found
--   if tankQueueText == "" then
--     tankQueueText = scanVar[2]
--   else
--     -- Remove final "|" character - for use with temporary concatenation
--     tankQueueText = string.sub(tankQueueText,1,-3)
--     if raidWarnNotify then
--       RaidNotice_AddMessage(RaidWarningFrame, ctaVar[1], ChatTypeInfo["RAID_WARNING"])
--     end
--   end
--   if healQueueText == "" then
--     healQueueText = scanVar[2]
--   else
--     -- Remove final "|" character - for use with temporary concatenation
--     healQueueText = string.sub(healQueueText,1,-3)
--     if raidWarnNotify then
--       RaidNotice_AddMessage(RaidWarningFrame, ctaVar[2], ChatTypeInfo["RAID_WARNING"])
--     end
--   end
--   if dpsQueueText == "" then
--     dpsQueueText = scanVar[2]
--   else
--     -- Remove final "|" character - for use with temporary concatenation
--     dpsQueueText = string.sub(dpsQueueText,1,-3)
--     if raidWarnNotify then
--       RaidNotice_AddMessage(RaidWarningFrame, ctaVar[3], ChatTypeInfo["RAID_WARNING"])
--     end
--   end
--   if tankQueueText ~= "" or healQueueText ~= "" or dpsQueueText ~= "" then
--     satchelFound = true
--     if not MainFrame:IsShown() then
--       MainFrame:Show()
--     end
--   end
--
--   textDatabase.tankdg1.textFrame:SetText(tankQueueText)
--   textDatabase.healdg1.textFrame:SetText(healQueueText)
--   textDatabase.dpsdg1.textFrame:SetText(dpsQueueText)
-- end
