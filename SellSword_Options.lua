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
	SatchelScannerConfig[f.value] = f:GetChecked()
end

local function createToggleBox(parent, value, text)
	local f = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	f.value = value

	f.Text:SetText(text)

	f:SetScript("OnClick", toggle)

	tinsert(checkboxes, f)

	return f
end

local SatchelOptions = CreateFrame("Frame", "SatchelOptions", UIParent)
SatchelOptions.name = "Satchel"
InterfaceOptions_AddCategory(SatchelOptions)

local title = SatchelOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("Satchel Scanner "..GetAddOnMetadata("SatchelScanner", "Version"))

local features = addSubCategory(SatchelOptions, "Features")
features:SetPoint("TOPLEFT", 16, -80)

local autoStartBox = createToggleBox(SatchelOptions, "autoStart", "Auto Start")
autoStartBox:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)

local intervalTimerSlider = CreateFrame("Slider", "intervalTimer", SatchelOptions, "OptionsSliderTemplate")
local intervalTimerText2 = SatchelOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
intervalTimerSlider:SetPoint("LEFT", autoStartBox, "RIGHT", 195, 0)
BlizzardOptionsPanel_Slider_Enable(intervalTimerSlider)
intervalTimerSlider:SetMinMaxValues(1,10)
intervalTimerSlider:SetValueStep(1)
intervalTimerText:SetText("Interval to Scan (in seconds)")
intervalTimerText2:SetPoint("LEFT", intervalTimerSlider, "RIGHT", 10, 0)
intervalTimerSlider:SetScript("OnValueChanged", function(self) intervalTimerText2:SetText(intervalTimerSlider:GetValue()) end)

local raidWarnBox = createToggleBox(SatchelOptions, "raidWarn", "Play Raid Warnings")
raidWarnBox:SetPoint("TOPLEFT", autoStartBox, "BOTTOMLEFT", 0, -8)

local soundWarnBox = createToggleBox(SatchelOptions, "soundWarn", "Play Sound Warnings")
soundWarnBox:SetPoint("LEFT", raidWarnBox, "RIGHT", 180, 0)

local queueTypes = addSubCategory(SatchelOptions, "Queue Types")
queueTypes:SetPoint("TOPLEFT", raidWarnBox, "BOTTOMLEFT", 0, -30)

local scanForTankBox = createToggleBox(SatchelOptions, "scanForTanks", "Scan for Tank Satchels")
scanForTankBox:SetPoint("TOPLEFT", queueTypes, "BOTTOMLEFT", 0, -20)

local scanForHealBox = createToggleBox(SatchelOptions, "scanForHeal", "Scan for Healer Satchels")
scanForHealBox:SetPoint("LEFT", scanForTankBox, "Right", 180, 0)

local scanForDPSBox = createToggleBox(SatchelOptions, "scanForDPS", "Scan for DPS Satchels")
scanForDPSBox:SetPoint("TOPLEFT", scanForTankBox, "BOTTOMLEFT", 0, -8)

local dungeonTypes = addSubCategory(SatchelOptions, "Dungeon Types")
dungeonTypes:SetPoint("TOPLEFT", scanForDPSBox, "BOTTOMLEFT", 0, -30)

local scanForWoDBox = createToggleBox(SatchelOptions, "scanForWoD", "Scan for WoD Heroics")
scanForWoDBox:SetPoint("TOPLEFT", dungeonTypes, "BOTTOMLEFT", 0, -20)

local scanForTWBox = createToggleBox(SatchelOptions, "scanForTW", "Scan for TimeWalking")
scanForTWBox:SetPoint("LEFT", scanForWoDBox, "Right", 180, 0)

local scanForLFRBox = createToggleBox(SatchelOptions, "scanForLFR", "Scan for Looking for Raid")
scanForLFRBox:SetPoint("TOPLEFT", scanForWoDBox, "BOTTOMLEFT", 0, -8)

local credits = SatchelOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("Satchel Scanner by joypunk aka Seintefie / US-Thrall")
credits:SetPoint("BOTTOM", 0, 40)

SatchelOptions:RegisterEvent("ADDON_LOADED")
SatchelOptions:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "SatchelScanner" then return end

		self:UnregisterEvent("ADDON_LOADED")
end)

SlashCmdList.SatchelScanner = function()
	InterfaceOptionsFrame_OpenToCategory(SatchelOptions)
end
SLASH_SatchelScanner1 = "/satchel"
