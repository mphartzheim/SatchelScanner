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

local _, C = ...

-- Define local variables
local oldConfig = {}
local checkboxes = {}

-- Function to copy table contents and inner table
local function copyTable(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			target[key] = {}
			for k, v in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end

local function addSubCategory(parent, name)
	local header = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	header:SetText(name)

	local line = parent:CreateTexture(nil, "ARTWORK")
	line:SetSize(600, 1)
	line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	line:SetTexture(1, 1, 1, .2)

	return header
end

local function toggle(f)
	SellSwordCharDB[f.value] = f:GetChecked()
	SellSwordOptions.refresh()
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
title:SetPoint("TOP", 0, 0)
title:SetText("SellSword "..GetAddOnMetadata("SellSword", "Version"))

local features = addSubCategory(SellSwordOptions, "Features")
features:SetPoint("TOPLEFT", 16, -20)

local autoStartBox = createToggleBox(SellSwordOptions, "sso_autoStart", "Auto Start")
autoStartBox:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -15)
autoStartBox.tooltip = "Start scanning for queue rewards automatically on logging in"

local intervalTimerSlider = CreateFrame("Slider", "sso_intervalTimer", SellSwordOptions, "OptionsSliderTemplate")
local intervalTimerValueText = SellSwordOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
intervalTimerSlider:SetPoint("LEFT", autoStartBox, "RIGHT", 195, 0)
BlizzardOptionsPanel_Slider_Enable(intervalTimerSlider)
intervalTimerSlider:SetMinMaxValues(1,10)
intervalTimerSlider:SetValueStep(1)
intervalTimerSlider:SetObeyStepOnDrag(true)
sso_intervalTimerText:SetText("Interval to Scan (in seconds)")
intervalTimerValueText:SetPoint("LEFT", intervalTimerSlider, "RIGHT", 10, 0)

local raidWarnBox = createToggleBox(SellSwordOptions, "sso_raidWarn", "Play Raid Warnings")
raidWarnBox:SetPoint("TOPLEFT", autoStartBox, "BOTTOMLEFT", 0, -8)
raidWarnBox.tooltip = "Display a Raid Warning message when a queue reward is found"

local soundWarnBox = createToggleBox(SellSwordOptions, "sso_soundWarn", "Play Sound Warnings")
soundWarnBox:SetPoint("LEFT", raidWarnBox, "RIGHT", 180, 0)
soundWarnBox.tooltip = "Play a Raid Warning sound when a queue reward is found"

local queueTypes = addSubCategory(SellSwordOptions, "Queue Types")
queueTypes:SetPoint("TOPLEFT", raidWarnBox, "BOTTOMLEFT", 0, -15)

local scanForTankBox = createToggleBox(SellSwordOptions, "sso_scanForTanks", "Scan Tank Queues")
scanForTankBox:SetPoint("TOPLEFT", queueTypes, "BOTTOMLEFT", 0, -15)

local scanForHealBox = createToggleBox(SellSwordOptions, "sso_scanForHeal", "Scan Healer Queues")
scanForHealBox:SetPoint("LEFT", scanForTankBox, "Right", 180, 0)

local scanForDPSBox = createToggleBox(SellSwordOptions, "sso_scanForDPS", "Scan DPS Queues")
scanForDPSBox:SetPoint("LEFT", scanForHealBox, "Right", 180, 0)

local dungeonTypes = addSubCategory(SellSwordOptions, "Dungeon Types")
dungeonTypes:SetPoint("TOPLEFT", scanForTankBox, "BOTTOMLEFT", 0, -15)

local scanForWoDBox = createToggleBox(SellSwordOptions, "sso_scanForWoD", "Scan WoD Heroics")
scanForWoDBox:SetPoint("TOPLEFT", dungeonTypes, "BOTTOMLEFT", 0, -15)

local scanForTWBox = createToggleBox(SellSwordOptions, "sso_scanForTW", "Scan TimeWalking")
scanForTWBox:SetPoint("TOPLEFT", scanForWoDBox, "BOTTOMLEFT", 0, -8)

local scanForTW_BCBox = createToggleBox(SellSwordOptions, "sso_scanForTW_BC", "Burning Crusade")
scanForTW_BCBox:SetPoint("TOPLEFT", scanForTWBox, "BOTTOMLEFT", 10, -5)

local scanForTW_LKBox = createToggleBox(SellSwordOptions, "sso_scanForTW_LK", "Lich King")
scanForTW_LKBox:SetPoint("LEFT", scanForTW_BCBox, "Right", 180, 0)

local scanForTW_CTBox = createToggleBox(SellSwordOptions, "sso_scanForTW_CT", "Cataclysm")
scanForTW_CTBox:SetPoint("LEFT", scanForTW_LKBox, "Right", 180, 0)

local scanForLFRBox = createToggleBox(SellSwordOptions, "sso_scanForLFR", "Scan Looking for Raid")
scanForLFRBox:SetPoint("TOPLEFT", scanForTW_BCBox, "BOTTOMLEFT", -10, -8)

local scanForLFR_HMBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HM", "Highmaul")
scanForLFR_HMBox:SetPoint("TOPLEFT", scanForLFRBox, "BOTTOMLEFT", 10, -5)

local scanForLFR_HM_WCBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HM_WC", "Walled City")
scanForLFR_HM_WCBox:SetPoint("TOPLEFT", scanForLFR_HMBox, "BOTTOMLEFT", 15, -5)

local scanForLFR_HM_ASBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HM_AS", "Arcane Sanctum")
scanForLFR_HM_ASBox:SetPoint("TOPLEFT", scanForLFR_HM_WCBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_HM_IRBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HM_IR", "Imperator's Rise")
scanForLFR_HM_IRBox:SetPoint("TOPLEFT", scanForLFR_HM_ASBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_BRFBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_BRF", "Blackrock Foundry")
scanForLFR_BRFBox:SetPoint("LEFT", scanForLFR_HMBox, "Right", 180, 0)

local scanForLFR_BRF_SWBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_BRF_SW", "Slagworks")
scanForLFR_BRF_SWBox:SetPoint("TOPLEFT", scanForLFR_BRFBox, "BOTTOMLEFT", 15, -5)

local scanForLFR_BRF_BFBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_BRF_BF", "The Black Forge")
scanForLFR_BRF_BFBox:SetPoint("TOPLEFT", scanForLFR_BRF_SWBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_BRF_IABox = createToggleBox(SellSwordOptions, "sso_scanForLFR_BRF_IA", "Iron Assembly")
scanForLFR_BRF_IABox:SetPoint("TOPLEFT", scanForLFR_BRF_BFBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_BRF_BCBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_BRF_BC", "Blackhand's Crucible")
scanForLFR_BRF_BCBox:SetPoint("TOPLEFT", scanForLFR_BRF_IABox, "BOTTOMLEFT", 0, -5)

local scanForLFR_HFCBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC", "Hellfire Citadel")
scanForLFR_HFCBox:SetPoint("LEFT", scanForLFR_BRFBox, "Right", 180, 0)

local scanForLFR_HFC_HBBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC_HB", "Hellbreach")
scanForLFR_HFC_HBBox:SetPoint("TOPLEFT", scanForLFR_HFCBox, "BOTTOMLEFT", 15, -5)

local scanForLFR_HFC_HoBBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC_HoB", "Halls of Blood")
scanForLFR_HFC_HoBBox:SetPoint("TOPLEFT", scanForLFR_HFC_HBBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_HFC_BoSBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC_BoS", "Bastion of Shadows")
scanForLFR_HFC_BoSBox:SetPoint("TOPLEFT", scanForLFR_HFC_HoBBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_HFC_DRBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC_DR", "Destructor's Rise")
scanForLFR_HFC_DRBox:SetPoint("TOPLEFT", scanForLFR_HFC_BoSBox, "BOTTOMLEFT", 0, -5)

local scanForLFR_HFC_BGBox = createToggleBox(SellSwordOptions, "sso_scanForLFR_HFC_BG", "The Black Gate")
scanForLFR_HFC_BGBox:SetPoint("TOPLEFT", scanForLFR_HFC_DRBox, "BOTTOMLEFT", 0, -5)

local credits = SellSwordOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("SellSword by joypunk aka Seintefie / US-Thrall")
credits:SetPoint("BOTTOM", 0, 0)

-- Create Functions
SellSwordOptions.refresh = function()
	intervalTimerSlider:SetValue(SellSwordCharDB.sso_intervalTimer)

	for i = 1, #checkboxes do
		checkboxes[i]:SetChecked(SellSwordCharDB[checkboxes[i].value] == true)
	end

	-- Enable/Disable sub-categories when master is or is not selected
	if not scanForTWBox:GetChecked() then
		scanForTW_BCBox:Disable()
		scanForTW_BCBox:SetChecked(false)
		scanForTW_LKBox:Disable()
		scanForTW_LKBox:SetChecked(false)
		scanForTW_CTBox:Disable()
		scanForTW_CTBox:SetChecked(false)
	else
		scanForTW_BCBox:Enable()
		scanForTW_LKBox:Enable()
		scanForTW_CTBox:Enable()
	end

	if not scanForLFRBox:GetChecked() then
		scanForLFR_HMBox:Disable()
		scanForLFR_HMBox:SetChecked(false)
		scanForLFR_BRFBox:Disable()
		scanForLFR_BRFBox:SetChecked(false)
		scanForLFR_HFCBox:Disable()
		scanForLFR_HFCBox:SetChecked(false)
	else
		scanForLFR_HMBox:Enable()
		scanForLFR_BRFBox:Enable()
		scanForLFR_HFCBox:Enable()
	end

	if not scanForLFR_HMBox:GetChecked() then
		scanForLFR_HM_WCBox:Disable()
		scanForLFR_HM_WCBox:SetChecked(false)
		scanForLFR_HM_ASBox:Disable()
		scanForLFR_HM_ASBox:SetChecked(false)
		scanForLFR_HM_IRBox:Disable()
		scanForLFR_HM_IRBox:SetChecked(false)
	else
		scanForLFR_HM_WCBox:Enable()
		scanForLFR_HM_ASBox:Enable()
		scanForLFR_HM_IRBox:Enable()
	end

	if not scanForLFR_BRFBox:GetChecked() then
		scanForLFR_BRF_SWBox:Disable()
		scanForLFR_BRF_SWBox:SetChecked(false)
		scanForLFR_BRF_BFBox:Disable()
		scanForLFR_BRF_BFBox:SetChecked(false)
		scanForLFR_BRF_IABox:Disable()
		scanForLFR_BRF_IABox:SetChecked(false)
		scanForLFR_BRF_BCBox:Disable()
		scanForLFR_BRF_BCBox:SetChecked(false)
	else
		scanForLFR_BRF_SWBox:Enable()
		scanForLFR_BRF_BFBox:Enable()
		scanForLFR_BRF_IABox:Enable()
		scanForLFR_BRF_BCBox:Enable()
	end

	if not scanForLFR_HFCBox:GetChecked() then
		scanForLFR_HFC_HBBox:Disable()
		scanForLFR_HFC_HBBox:SetChecked(false)
		scanForLFR_HFC_HoBBox:Disable()
		scanForLFR_HFC_HoBBox:SetChecked(false)
		scanForLFR_HFC_BoSBox:Disable()
		scanForLFR_HFC_BoSBox:SetChecked(false)
		scanForLFR_HFC_DRBox:Disable()
		scanForLFR_HFC_DRBox:SetChecked(false)
		scanForLFR_HFC_BGBox:Disable()
		scanForLFR_HFC_BGBox:SetChecked(false)
	else
		scanForLFR_HFC_HBBox:Enable()
		scanForLFR_HFC_HoBBox:Enable()
		scanForLFR_HFC_BoSBox:Enable()
		scanForLFR_HFC_DRBox:Enable()
		scanForLFR_HFC_BGBox:Enable()
	end
end

SellSwordOptions:RegisterEvent("ADDON_LOADED")
SellSwordOptions:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "SellSword" then return end
	copyTable(SellSwordCharDB, oldConfig)
	self:UnregisterEvent("ADDON_LOADED")
end)

SellSwordOptions.okay = function()
	copyTable(SellSwordCharDB, oldConfig)
end

SellSwordOptions.cancel = function()
	copyTable(oldConfig, SellSwordCharDB)
	SellSwordOptions.refresh()
end

SellSwordOptions.default = function()
	copyTable(C.defaults, SellSwordCharDB)
	SellSwordOptions.refresh()
end

intervalTimerSlider:SetScript("OnValueChanged", function(_, value)
	SellSwordCharDB.sso_intervalTimer = value
	intervalTimerValueText:SetText(intervalTimerSlider:GetValue())
end)

SlashCmdList.SellSword = function()
	InterfaceOptionsFrame_OpenToCategory(SellSwordOptions)
end
SLASH_SellSword1 = "/SellSword"
SLASH_SellSword2 = "/ss"
