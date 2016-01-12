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

local SellSword = CreateFrame("Frame", "SellSwordFrame", UIParent)
SellSwordFrame:RegisterEvent("ADDON_LOADED")
SellSwordFrame:SetScript("OnEvent", function(self, event, arg1)
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
-- Successfully creates a frame that's movable, but cannot get text to display on it yet.
-- the 't.text' variable stuff is supposed to display text but it ain't working.
SellSword:SetMovable(true)
SellSword:EnableMouse(true)
SellSword:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and not self.isMoving then
    self:StartMoving()
    self.isMoving = true
  end
end)
SellSword:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
    self:StopMovingOrSizing()
    self.isMoving = false
  end
end)
SellSword:SetScript("OnHide", function(self)
  if ( self.isMoving ) then
    self:StopMovingOrSizing()
    self.isMoving = false
  end
end)
SellSword:SetFrameStrata("BACKGROUND")
SellSword:SetPoint("CENTER"); SellSword:SetWidth(300); SellSword:SetHeight(300)
local t = SellSword:CreateTexture("ARTWORK")
t.text = SellSword:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
t.text:SetAllPoints(true)
t.text:SetTextColor(0, 0, 0, 1)
t.text:SetJustifyH("LEFT")
t.text:SetJustifyV("TOP")
t:SetAllPoints()
t:SetTexture(1.0, 0.5, 0); t:SetAlpha(0.5)


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
