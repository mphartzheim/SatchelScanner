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

local checkboxes = {}

local function addSubCategory(parent, name)
	local header = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	header:SetText(name)

	local line = parent:CreateTexture(nil, "ARTWORK")
	line:SetSize(450, 1)
	line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	line:SetTexture(1, 1, 1, .2)

	return header
end

local function toggle(f)
	SellSwordConfig[f.value] = f:GetChecked()
end

local function createToggleBox(parent, value, text)
	local f = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	f.value = value

	f.Text:SetText(text)

	f:SetScript("OnClick", toggle)

	tinsert(checkboxes, f)

	return f
end

local SellSwordOptions = CreateFrame("Frame", "SellSwordOptions", UIParent)
SellSwordOptions.name = "SellSword"
InterfaceOptions_AddCategory(SellSwordOptions)

local title = SellSwordOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", -90, -26)
title:SetText("SellSword "..GetAddOnMetadata("SellSword", "Version"))

local features = addSubCategory(SellSwordOptions, "Features")
features:SetPoint("TOPLEFT", 16, -80)

local autoStartBox = createToggleBox(SellSwordOptions, "sso_autoStart", "Auto Start")
autoStartBox:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)

local intervalTimerSlider = CreateFrame("Slider", "sso_intervalTimer", SellSwordOptions, "OptionsSliderTemplate")
local intervalTimerValueText = SellSwordOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
intervalTimerSlider:SetPoint("LEFT", autoStartBox, "RIGHT", 195, 0)
BlizzardOptionsPanel_Slider_Enable(intervalTimerSlider)
intervalTimerSlider:SetMinMaxValues(1,10)
intervalTimerSlider:SetValueStep(1)
intervalTimerSlider:SetObeyStepOnDrag(true)
sso_intervalTimerText:SetText("Interval to Scan (in seconds)")
intervalTimerValueText:SetPoint("LEFT", intervalTimerSlider, "RIGHT", 10, 0)
intervalTimerSlider:SetScript("OnValueChanged", function(self) intervalTimerValueText:SetText(intervalTimerSlider:GetValue()) end)

local raidWarnBox = createToggleBox(SellSwordOptions, "sso_raidWarn", "Play Raid Warnings")
raidWarnBox:SetPoint("TOPLEFT", autoStartBox, "BOTTOMLEFT", 0, -8)

local soundWarnBox = createToggleBox(SellSwordOptions, "sso_soundWarn", "Play Sound Warnings")
soundWarnBox:SetPoint("LEFT", raidWarnBox, "RIGHT", 180, 0)

local queueTypes = addSubCategory(SellSwordOptions, "Queue Types")
queueTypes:SetPoint("TOPLEFT", raidWarnBox, "BOTTOMLEFT", 0, -30)

local scanForTankBox = createToggleBox(SellSwordOptions, "sso_scanForTanks", "Scan Tank Queues")
scanForTankBox:SetPoint("TOPLEFT", queueTypes, "BOTTOMLEFT", 0, -20)

local scanForHealBox = createToggleBox(SellSwordOptions, "sso_scanForHeal", "Scan Healer Queues")
scanForHealBox:SetPoint("LEFT", scanForTankBox, "Right", 180, 0)

local scanForDPSBox = createToggleBox(SellSwordOptions, "sso_scanForDPS", "Scan DPS Queues")
scanForDPSBox:SetPoint("TOPLEFT", scanForTankBox, "BOTTOMLEFT", 0, -8)

local dungeonTypes = addSubCategory(SellSwordOptions, "Dungeon Types")
dungeonTypes:SetPoint("TOPLEFT", scanForDPSBox, "BOTTOMLEFT", 0, -30)

local scanForWoDBox = createToggleBox(SellSwordOptions, "sso_scanForWoD", "Scan WoD Heroics")
scanForWoDBox:SetPoint("TOPLEFT", dungeonTypes, "BOTTOMLEFT", 0, -20)

local scanForTWBox = createToggleBox(SellSwordOptions, "sso_scanForTW", "Scan TimeWalking")
scanForTWBox:SetPoint("LEFT", scanForWoDBox, "Right", 180, 0)

local scanForLFRBox = createToggleBox(SellSwordOptions, "sso_scanForLFR", "Scan Looking for Raid")
scanForLFRBox:SetPoint("TOPLEFT", scanForWoDBox, "BOTTOMLEFT", 0, -8)

local credits = SellSwordOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("SellSword by joypunk aka Seintefie / US-Thrall")
credits:SetPoint("BOTTOM", -80, 40)

SellSwordOptions:RegisterEvent("ADDON_LOADED")
SellSwordOptions:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "SellSword" then return end
	self:UnregisterEvent("ADDON_LOADED")
end)

SlashCmdList.SellSword = function()
	InterfaceOptionsFrame_OpenToCategory(SellSwordOptions)
end
SLASH_SellSword1 = "/SellSword"
SLASH_SellSword2 = "/ss"
