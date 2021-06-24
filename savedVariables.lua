--------------------==≡≡[ UTILS ]≡≡==-----------------------------------

function table.Count(t)
	local i = 0
	for k in pairs(t) do i = i + 1 end
	return i
end

local function lookup(t, ...)
    for _, k in ipairs{...} do
		t = t[k]
        if t == nil then
            return nil
        end
    end
    return t
end

local function AddSelectItemToTable(t, item, start, finish)
	if item ~= nil then
		-- If end is null, auto count regions
		local RegionCount = table.Count({ item:GetRegions() })
		for i = start, finish or RegionCount do
			local Value = select(i, item:GetRegions())
			table.insert(t, Value)
		end
	end
end

local function SetVertexColors(textures, red, green, blue)
	for _, Texture in ipairs(textures) do
		if Texture:GetObjectType() == "Texture" then
			Texture:SetVertexColor(red, green, blue)
		end
	end
end

local function SetDesaturations(textures, desaturation)
	for _, Texture in ipairs(textures) do
		if Texture:GetObjectType() == "Texture" then
			Texture:SetDesaturation(desaturation)
		end
	end
end



--------------------==≡≡[ CREATE SAVED VARIABLES ]≡≡==-----------------------------------

local function AddToOptions(name, value)
	if lookup(RUI_SavedVars, "Options", name) == nil then
		RUI_SavedVars["Options"][name] = value
	end
end

local function AddToKeybindText(name, value)
	if lookup(RUI_SavedVars, "Options", "KeybindText", name) == nil then
		RUI_SavedVars["Options"]["KeybindText"][name] = value
	end
end

local function AddToComponents(name, value)
	if lookup(RUI_SavedVars, "Options", "Components", name) == nil then
		RUI_SavedVars["Options"]["Components"][name] = value
	end
end

local function Create_SavedVariables()
	-------------------------
	--[[ Expected output ]]--
	-------------------------
	-- RUI_SavedVars["Options"] = {
	-- 	["TidyIcons"] = false,
	-- 	["DarkTheme"] = false,
	-- 	["AlwaysShowExpBarText"] = GetCVarBool("xpBarText"),
	-- 	["KeybindText"] = {
	-- 		["PrimaryBar"] = true,
	-- 		["BottomLeftBar"] = true,
	-- 		["BottomRightBar"] = true,
	-- 		["RightBar"] = true,
	-- 		["RightBar2"] = true,
	-- 	},
	-- 	["Components"] = {
	-- 		["Gryphons"] = true,
	-- 		["Bags"] = true,
	--		["BagSpaceText"] = true,
	-- 		["MicroMenu"] = true,
	-- 		["MicroAndBagsBackground"] = true,
	-- 	}
	-- }

	-- AddToOptions("PixelPerfect", false)
	AddToOptions("TidyIcons", false)
	AddToOptions("DarkTheme", false)
	AddToOptions("AlwaysShowExpBarText", GetCVarBool("xpBarText"))
	AddToOptions("KeybindText", {})
	AddToKeybindText("PrimaryBar", true)
	AddToKeybindText("BottomLeftBar", true)
	AddToKeybindText("BottomRightBar", true)
	AddToKeybindText("RightBar", true)
	AddToKeybindText("RightBar2", true)
	AddToOptions("Components", {})
	AddToComponents("Gryphons", true)
	AddToComponents("Bags", true)
	AddToComponents("BagSpaceText", true)
	AddToComponents("MicroMenu", true)
	AddToComponents("MicroAndBagsBackground", true)
end

local function Apply_SavedVariables()
	if RUI_SavedVars ~= nil then
		-- Add any missing saved variables
		Create_SavedVariables()

		-- Apply Saved Variables
		-- Update_PixelPerfect()
		Update_TidyIcons()
		Update_KeybindText()
		Update_DarkTheme()
		Update_Gryphons()
		Update_Bags()
		Update_BagSpaceText()
		Update_MicroMenu()
		Update_MicroAndBagsBackground()
	else
		-- No saved variables exist, show popup and acreate default saved variables
		StaticPopup_Show("Welcome_Popup")
		-- Create default saved variables
		RUI_SavedVars = {}
		RUI_SavedVars["Options"] = {}
		Create_SavedVariables()
	end
end



--------------------==≡≡[ TIDY ICONS ]≡≡==-----------------------------------

local function Update_TidyIcons_MacroPopupFrame()
	if (MacroPopupFrame:IsShown()) then
		for i = 1, 90 do
			local button = _G["MacroPopupButton" .. i]
			local name = button:GetName()
			local icon = _G[name .. "Icon"]

			if RUI_SavedVars.Options.TidyIcons then
				-- Trim icon borders
				icon:SetTexCoord(.08, .92, .08, .92)
			else
				-- Restore icon borders
				icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			end
		end
	end
end
-- Ensure MacroPopupFrame frame is loaded first, so we don't get an error
if not IsAddOnLoaded("Blizzard_MacroUI") then
	LoadAddOn("Blizzard_MacroUI")
end
-- hooksecurefunc("MacroFrame_OnShow", Update_TidyIcons_MacroPopupFrame)
MacroPopupFrame:HookScript("OnShow", Update_TidyIcons_MacroPopupFrame)

function Update_TidyIcons()
	-- Tidy action bar icons
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		for _, v in pairs({
			"ActionButton",
			"MultiBarBottomLeftButton",
			"MultiBarBottomRightButton",
			"MultiBarRightButton",
			"MultiBarLeftButton"
		}) do
			local button = _G[v .. i]
			local name = button:GetName()
			local icon = _G[name .. "Icon"]

			if RUI_SavedVars.Options.TidyIcons then
				-- Trim icon borders
				icon:SetTexCoord(.04, .96, .04, .96)
			else
				-- Restore icon borders
				icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			end
		end
	end

	-- Tidy macro icons
	for i = 1, 120 do
		local button = _G["MacroButton" .. i]
		local name = button:GetName()
		local icon = _G[name .. "Icon"]

		if RUI_SavedVars.Options.TidyIcons then
			-- Trim icon borders
			icon:SetTexCoord(.08, .92, .08, .92)
		else
			-- Restore icon borders
			icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		end
	end

	Update_TidyIcons_MacroPopupFrame()
end



--------------------==≡≡[ GRYPHONS ]≡≡==-----------------------------------

function Update_Gryphons()
	if RUI_SavedVars.Options.Components.Gryphons then
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
	else
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	end
end



--------------------==≡≡[ BAGS AND KEYRING ]≡≡==-----------------------------------

local function Update_KeyRing()
	if RUI_SavedVars.Options.Components.Bags then
		KeyRingButton:Show()
	else
		KeyRingButton:Hide()
	end
end
hooksecurefunc("MainMenuBar_UpdateKeyRing", Update_KeyRing)

function Update_Bags()
	if RUI_SavedVars.Options.Components.Bags then
		Update_KeyRing()
		MainMenuBarBackpackButton:Show()
		for i = 0, 3 do
			_G["CharacterBag" .. i .. "Slot"]:Show()
		end
	else
		Update_KeyRing()
		MainMenuBarBackpackButton:Hide()
		for i = 0, 3 do
			_G["CharacterBag" .. i .. "Slot"]:Hide()
		end
	end
end



--------------------==≡≡[ BAG SPACE TEXT ]≡≡==-----------------------------------

function Update_BagSpaceText()
	if RUI_SavedVars.Options.Components.BagSpaceText then
		BagSpaceDisplay:Show()
	else
		BagSpaceDisplay:Hide()
	end
end



--------------------==≡≡[ MICRO MENU ]≡≡==-----------------------------------

function Update_MicroMenu()
	if RUI_SavedVars.Options.Components.MicroMenu then
		for i = 1, #MICRO_BUTTONS do
			_G[MICRO_BUTTONS[i]]:Show()
		end
		MainMenuBarPerformanceBarFrame:Show()
	else
		for i = 1, #MICRO_BUTTONS do
			_G[MICRO_BUTTONS[i]]:Hide()
		end
		MainMenuBarPerformanceBarFrame:Hide()
	end
end



--------------------==≡≡[ MICRO AND BAGS BACKGROUND ]≡≡==-----------------------------------

function Update_MicroAndBagsBackground()
	if RUI_SavedVars.Options.Components.MicroAndBagsBackground then
		MicroButtonAndBagsBar:Show()
	else
		MicroButtonAndBagsBar:Hide()
	end
end



--------------------==≡≡[ KEYBIND TEXT ]≡≡==-----------------------------------

local function BooleanToNumber(value)
	return value and 1 or 0
end

function Update_KeybindText()
	for i = 1, 12 do
		_G["ActionButton" .. i .. "HotKey"]:SetAlpha(
			BooleanToNumber(RUI_SavedVars.Options.KeybindText.PrimaryBar)
		)
		_G["MultiBarBottomLeftButton" .. i .. "HotKey"]:SetAlpha(
			BooleanToNumber(RUI_SavedVars.Options.KeybindText.BottomLeftBar)
		)
		_G["MultiBarBottomRightButton" .. i .. "HotKey"]:SetAlpha(
			BooleanToNumber(RUI_SavedVars.Options.KeybindText.BottomRightBar)
		)
		_G["MultiBarRightButton" .. i .. "HotKey"]:SetAlpha(
			BooleanToNumber(RUI_SavedVars.Options.KeybindText.RightBar)
		)
		_G["MultiBarLeftButton" .. i .. "HotKey"]:SetAlpha(
			BooleanToNumber(RUI_SavedVars.Options.KeybindText.RightBar2)
		)
	end
end



--------------------==≡≡[ DARK THEME ]≡≡==-----------------------------------

-- Create borders for dark theme minimap
-- Minimap gametime border
RetailUI_GameTimeFrame = CreateFrame("Frame", "RetailUI_GameTimeFrame", GameTimeFrame)
RetailUI_GameTimeBorder = RetailUI_GameTimeFrame:CreateTexture()
RetailUI_GameTimeBorder:SetTexture("Interface\\AddOns\\RetailUI\\art\\GameTimeBorder")
RetailUI_GameTimeBorder:SetPoint("CENTER", GameTimeFrame, -1, 1)
RetailUI_GameTimeBorder:SetSize(64, 64)

-- Minimap zoom in button border
RetailUI_ZoomInFrame = CreateFrame("Frame", "RetailUI_ZoomInFrame", MinimapZoomIn)
RetailUI_ZoomInBorder = RetailUI_ZoomInFrame:CreateTexture()
RetailUI_ZoomInBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
RetailUI_ZoomInBorder:SetPoint("CENTER", MinimapZoomIn, 11, -11)
RetailUI_ZoomInBorder:SetSize(54, 54)

-- Minimap zoom out button border
RetailUI_ZoomOutFrame = CreateFrame("Frame", "RetailUI_ZoomOutFrame", MinimapZoomOut)
RetailUI_ZoomOutBorder = RetailUI_ZoomOutFrame:CreateTexture()
RetailUI_ZoomOutBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
RetailUI_ZoomOutBorder:SetPoint("CENTER", MinimapZoomOut, 11, -11)
RetailUI_ZoomOutBorder:SetSize(54, 54)

-- Replace default backpack container background texture and portrait
local function Set_BackpackTextures(...)
	local Frame, Size, Id = ...
	local FrameName = Frame:GetName()
	local BackpackId = 0

	if Id == BackpackId then
		if RUI_SavedVars.Options.DarkTheme then
			_G[FrameName .. "Portrait"]:ClearAllPoints()
			_G[FrameName .. "Portrait"]:SetPoint("TOPLEFT", FrameName, "TOPLEFT", 5, -3)
			_G[FrameName .. "BackgroundTop"]:SetTexture("Interface\\AddOns\\RetailUI\\art\\UI-BackpackBackground")
			SetPortraitToTexture(FrameName .. "Portrait", "Interface\\Buttons\\Button-Backpack-Up")
		else
			_G[FrameName .. "BackgroundTop"]:SetTexture("Interface\\ContainerFrame\\UI-BackpackBackground")
		end
	end
end
hooksecurefunc("ContainerFrame_GenerateFrame", Set_BackpackTextures)

-- Ensure KeyBinding frame is loaded first, so we don't get an error
if not IsAddOnLoaded("Blizzard_BindingUI") then
	LoadAddOn("Blizzard_BindingUI")
end
local function KeyBindingFrame_Theme()
	local Textures = {
		KeyBindingFrameTopLeftCorner,
		KeyBindingFrameTopBorder,
		KeyBindingFrameTopRightCorner,
		KeyBindingFrameRightBorder,
		KeyBindingFrameBottomRightCorner,
		KeyBindingFrameBottomBorder,
		KeyBindingFrameBottomLeftCorner,
		KeyBindingFrameLeftBorder,
		KeyBindingFrameRockBg,
	}
	AddSelectItemToTable(Textures, KeyBindingFrame, 1)
	AddSelectItemToTable(Textures, KeyBindingFrameCategoryList, 1, 8)
	AddSelectItemToTable(Textures, KeyBindingFrame.bindingsContainer, 1, 8)
	-- Set vertex colours
	SetVertexColors(Textures, Color.R, Color.G, Color.B)
end
KeyBindingFrame:HookScript("OnShow", KeyBindingFrame_Theme)

-- Ensure Macro frame is loaded first, so we don't get an error
if not IsAddOnLoaded("Blizzard_MacroUI") then
	LoadAddOn("Blizzard_MacroUI")
end
local function MacroFrame_Theme()
	local Textures = {
		MacroFramePortraitFrame,
		MacroFrameTopBorder,
		MacroFrameTopRightCorner,
		MacroFrameRightBorder,
		MacroFrameBtnCornerRight,
		MacroFrameButtonBottomBorder,
		MacroFrameBottomBorder,
		MacroFrameBtnCornerLeft,
		MacroFrameLeftBorder,
	
		MacroButtonScrollFrameTop,
		MacroButtonScrollFrameMiddle,
		MacroButtonScrollFrameBottom,
		MacroHorizontalBarLeft,
		select(21, MacroFrame:GetRegions()), -- MacroHorizontalBarRight

		MacroPopupScrollFrameTop,
		MacroPopupScrollFrameMiddle,
		MacroPopupScrollFrameBottom,
	}

	local LighterTextures = {
		MacroFrameTitleBg,
		MacroFrameBg,
	}

	local LightestTextures = {
		MacroButtonScrollFrameScrollBarThumbTexture,
		MacroFrameScrollFrameScrollBarThumbTexture,
		MacroPopupScrollFrameScrollBarThumbTexture,
	}

	local DesaturateTextures = {
		MacroFramePortraitFrame,
		MacroFrameTitleBg,
		MacroFrameBg,
	}

	-- Macro buttons' textures
	for i = 1, 120 do
		local Item = _G["MacroButton" .. i]
		AddSelectItemToTable(LighterTextures, Item, 1, 2)
	end

	AddSelectItemToTable(LightestTextures, MacroFrameTab1, 1, 7)
	AddSelectItemToTable(LightestTextures, MacroFrameTab2, 1, 7)
	AddSelectItemToTable(DesaturateTextures, MacroFrameTab1, 1, 7)
	AddSelectItemToTable(DesaturateTextures, MacroFrameTab2, 1, 7)
	AddSelectItemToTable(Textures, MacroFrameInset, 1, 9)
	AddSelectItemToTable(Textures, MacroFrameTextBackground, 1, 9)
	AddSelectItemToTable(Textures, MacroPopupFrame.BorderBox, 1, 8)
	AddSelectItemToTable(LightestTextures, MacroButtonScrollFrameScrollBarScrollUpButton, 1, 4)
	AddSelectItemToTable(LightestTextures, MacroButtonScrollFrameScrollBarScrollDownButton, 1, 4)
	AddSelectItemToTable(LightestTextures, MacroFrameScrollFrameScrollBarScrollUpButton, 1, 4)
	AddSelectItemToTable(LightestTextures, MacroFrameScrollFrameScrollBarScrollDownButton, 1, 4)
	AddSelectItemToTable(LightestTextures, MacroPopupScrollFrameScrollBarScrollUpButton, 1, 4)
	AddSelectItemToTable(LightestTextures, MacroPopupScrollFrameScrollBarScrollDownButton, 1, 4)

	-- Set vertex colours and desaturations
	SetVertexColors(Textures, Color.R, Color.G, Color.B)
	SetVertexColors(LighterTextures, Color.R + 0.1, Color.G + 0.1, Color.B + 0.1)
	SetVertexColors(LightestTextures, Color.R + 0.3, Color.G + 0.3, Color.B + 0.3)
	SetDesaturations(DesaturateTextures, Desaturation)
end
MacroFrame:HookScript("OnShow", MacroFrame_Theme)

function Update_DarkTheme()
	-- Prevents error when getting clock texture (TimeManagerClockButton)
	if not IsAddOnLoaded("Blizzard_TimeManager") then
		LoadAddOn("Blizzard_TimeManager")
	end

	local Textures = {
		-- ActionBar background
		RetailUIArtFrame.BackgroundSmall,
		RetailUIArtFrame.BackgroundLarge,

		-- Bags
		MicroButtonAndBagsBarTexture,
		
		-- Gryphons
		MainMenuBarLeftEndCap,
		MainMenuBarRightEndCap,
		
		-- Status bars
		RetailUIStatusBars.SingleBarSmallUpper,
		RetailUIStatusBars.SingleBarSmall,
		RetailUIStatusBars.SingleBarLargeUpper,
		RetailUIStatusBars.SingleBarLarge,

		-- Minimap
		MinimapBorder,
		MinimapBorderTop,
		MiniMapBattlefieldBorder,
		MiniMapTrackingBorder,
		MiniMapMailBorder,
		RetailUI_GameTimeBorder,
		-- Texture next to the minimap toggle
		MiniMapWorldMapButton:GetRegions(),
		-- Minimap zoom in and out button borders
		RetailUI_ZoomInBorder,
		RetailUI_ZoomOutBorder,
		-- Minimap clock
		TimeManagerClockButton:GetRegions(),

		-- Casting bars
		CastingBarFrame.Border,
		TargetFrameSpellBar.Border,
		FocusFrameSpellBar.Border,

		-- Breath bar
		MirrorTimer1Border,
		MirrorTimer2Border,
        MirrorTimer3Border,

		-- Unit frames
		PlayerFrameTexture,
		TargetFrameTextureFrameTexture,
		FocusFrameTextureFrameTexture,
		-- TODO: Causes error
		-- FocusFrameToTTextureFrameTexture,
		PetFrameTexture,
		PartyMemberFrame1Texture,
		PartyMemberFrame2Texture,
		PartyMemberFrame3Texture,
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture,
		PartyMemberFrame2PetFrameTexture,
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
		TargetFrameToTTextureFrameTexture,

		-- Pet bar
		SlidingActionBarTexture0,
		SlidingActionBarTexture1,

		-- Stance bar
		StanceBarLeft,
		StanceBarMiddle,
		StanceBarRight,

		-- Chat box
		ChatFrame1EditBoxLeft,
		ChatFrame1EditBoxMid,
		ChatFrame1EditBoxRight,

		-- Compact raid frame manager
		CompactRaidFrameManagerDisplayFrameHeaderDelineator,
		CompactRaidFrameManagerBorderTopLeft,
		CompactRaidFrameManagerBorderTop,
		CompactRaidFrameManagerBorderTopRight,
		CompactRaidFrameManagerBorderRight,
		CompactRaidFrameManagerBorderBottomRight,
		CompactRaidFrameManagerBorderBottom,
		CompactRaidFrameManagerBorderBottomLeft,
		CompactRaidFrameManagerBg,
		-- Ready check button border
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckTopLeft,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckTopMiddle,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckTopRight,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckMiddleRight,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckBottomRight,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckBottomMiddle,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckBottomLeft,
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheckMiddleLeft,
		-- Convert to raid button border
		CompactRaidFrameManagerDisplayFrameConvertToRaidTopLeft,
		CompactRaidFrameManagerDisplayFrameConvertToRaidTopMiddle,
		CompactRaidFrameManagerDisplayFrameConvertToRaidTopRight,
		CompactRaidFrameManagerDisplayFrameConvertToRaidMiddleRight,
		CompactRaidFrameManagerDisplayFrameConvertToRaidBottomRight,
		CompactRaidFrameManagerDisplayFrameConvertToRaidBottomMiddle,
		CompactRaidFrameManagerDisplayFrameConvertToRaidBottomLeft,
		CompactRaidFrameManagerDisplayFrameConvertToRaidMiddleLeft,
		-- Toggle lock button border
		CompactRaidFrameManagerDisplayFrameLockedModeToggleTopLeft,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleTopMiddle,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleTopRight,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleMiddleRight,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleBottomRight,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleBottomMiddle,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleBottomLeft,
		CompactRaidFrameManagerDisplayFrameLockedModeToggleMiddleLeft,
		-- Toggle visibility button border
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleTopLeft,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleTopMiddle,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleTopRight,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleMiddleRight,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleBottomRight,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleBottomMiddle,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleBottomLeft,
		CompactRaidFrameManagerDisplayFrameHiddenModeToggleMiddleLeft,

		-- Raid frame
		CompactRaidFrameContainerBorderFrameBorderTopLeft,
		CompactRaidFrameContainerBorderFrameBorderTop,
		CompactRaidFrameContainerBorderFrameBorderTopRight,
		CompactRaidFrameContainerBorderFrameBorderRight,
		CompactRaidFrameContainerBorderFrameBorderBottomRight,
		CompactRaidFrameContainerBorderFrameBorderBottom,
		CompactRaidFrameContainerBorderFrameBorderBottomLeft,
		CompactRaidFrameContainerBorderFrameBorderLeft,

		-- Retail UI options frame
		RUIOptionsFrameHeader,

		-- Game menu
		GameMenuFrameHeader,

		-- Interface options
		InterfaceOptionsFrameHeader,

		-- Dialog edit box border
		StaticPopup1EditBoxLeft,
		StaticPopup2EditBoxLeft,
		StaticPopup3EditBoxLeft,
		StaticPopup4EditBoxLeft,
		StaticPopup1EditBoxMid,
		StaticPopup2EditBoxMid,
		StaticPopup3EditBoxMid,
		StaticPopup4EditBoxMid,
		StaticPopup1EditBoxRight,
		StaticPopup2EditBoxRight,
		StaticPopup3EditBoxRight,
		StaticPopup4EditBoxRight,		

		-- Interface options - Tab borders
		InterfaceOptionsFrameTab1TabSpacer,

		-- Interface options - Categories border
		InterfaceOptionsFrameCategoriesTopLeft,
		InterfaceOptionsFrameCategoriesTop,
		InterfaceOptionsFrameCategoriesTopRight,
		InterfaceOptionsFrameCategoriesRight,
		InterfaceOptionsFrameCategoriesBottomRight,
		InterfaceOptionsFrameCategoriesBottom,
		InterfaceOptionsFrameCategoriesBottomLeft,
		InterfaceOptionsFrameCategoriesLeft,

		-- Interface options - AddOns borders
		InterfaceOptionsFrameAddOnsTopLeft,
		InterfaceOptionsFrameTab2TabSpacer1,
		InterfaceOptionsFrameTab2TabSpacer2,
		InterfaceOptionsFrameAddOnsTopRight,
		InterfaceOptionsFrameAddOnsRight,
		InterfaceOptionsFrameAddOnsBottomRight,
		InterfaceOptionsFrameAddOnsBottom,
		InterfaceOptionsFrameAddOnsBottomleft,
		InterfaceOptionsFrameAddOnsLeft,

		-- System options
		VideoOptionsFrameHeader
	}

	local LighterTextures = {
		ExhaustionTickNormal,
	}

	local DesaturateTextures = {
		-- Unit frames
		PlayerFrameTexture,
		--TargetFrameTextureFrameTexture,
		PetFrameTexture,
		PartyMemberFrame1Texture,
		PartyMemberFrame2Texture,
		PartyMemberFrame3Texture,
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture,
		PartyMemberFrame2PetFrameTexture,
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
		TargetFrameToTTextureFrameTexture,

		MinimapBorder,
		MiniMapBattlefieldBorder,
		MiniMapTrackingBorder,
		MiniMapMailBorder,
		RetailUI_GameTimeBorder,
		-- Minimap zoom in and out button borders
		RetailUI_ZoomInBorder,
		RetailUI_ZoomOutBorder,
		-- Minimap clock
		TimeManagerClockButton:GetRegions()
	}

	-- Bags and bank bags' background textures
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "BackgroundTop"])
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "BackgroundTop"])
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "BackgroundMiddle1"])
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "BackgroundMiddle2"])
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "BackgroundBottom"])
		table.insert(DesaturateTextures, _G["ContainerFrame" .. i .. "Background1Slot"]) -- For the 1 slot bag's background texture
		table.insert(LighterTextures, _G["ContainerFrame" .. i .. "BackgroundTop"])
		table.insert(LighterTextures, _G["ContainerFrame" .. i .. "BackgroundMiddle1"])
		table.insert(LighterTextures, _G["ContainerFrame" .. i .. "BackgroundMiddle2"])
		table.insert(LighterTextures, _G["ContainerFrame" .. i .. "BackgroundBottom"])
		table.insert(LighterTextures, _G["ContainerFrame" .. i .. "Background1Slot"]) -- For the 1 slot bag's background texture
	end

	-- Bags' slot borders
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local Name = _G["ContainerFrame" .. i]:GetName()
		for i = 1, MAX_CONTAINER_ITEMS, 1 do
			table.insert(Textures, _G[Name .. "Item" .. i .. "NormalTexture"])
		end
	end

	-- Dialog border
	for i = 1, 4 do
		local Item = _G["StaticPopup" .. i]
		AddSelectItemToTable(Textures, Item, 4, 12)
	end

	-- RUI options frame borders
	AddSelectItemToTable(Textures, RUIOptionsFrame, 1, 10)
	AddSelectItemToTable(Textures, RUIOptionsFramePanelContainer, 1, 8)

	-- Game menu border
	AddSelectItemToTable(Textures, GameMenuFrame, 1, 10)

	-- Interface options border
	AddSelectItemToTable(Textures, InterfaceOptionsFrame, 1, 10)

	-- Interface options - Panel container border
	AddSelectItemToTable(Textures, InterfaceOptionsFramePanelContainer, 1, 9)

	-- System options borders
	AddSelectItemToTable(Textures, VideoOptionsFrame, 1)
	AddSelectItemToTable(Textures, VideoOptionsFrameCategoryFrame, 1, 8)
	AddSelectItemToTable(Textures, VideoOptionsFramePanelContainer, 1, 8)
	AddSelectItemToTable(Textures, Display_, 1, 8)
	AddSelectItemToTable(Textures, Graphics_, 1, 8)

	-- Key ring
	local KeyRingTextures = {}
	AddSelectItemToTable(KeyRingTextures, KeyRingButton, 1, 2)

	MerchantBuyBackItemItemButtonNormalTexture:Hide()

	if RUI_SavedVars.Options.DarkTheme then
		Color = { R = 0.4, G = 0.4, B = 0.4 }
		Desaturation = 1
		--BuybackBG:SetAlpha(.075)
		-- Raid frame manager toggle button texture
		CompactRaidFrameManagerToggleButton:SetNormalTexture(
			"Interface\\AddOns\\RetailUI\\art\\RaidPanel-Toggle"
		)
	else
		Color = { R = 1, G = 1, B = 1 }
		Desaturation = 0
		--BuybackBG:SetAlpha(1)
		-- Raid frame manager toggle button restore texture
		CompactRaidFrameManagerToggleButton:SetNormalTexture(
			"Interface\\RaidFrame\\RaidPanel-Toggle"
		)
	end

	-- Set vertex colours and desaturations
	SetVertexColors(Textures, Color.R, Color.G, Color.B)
	SetVertexColors(LighterTextures, Color.R + 0.1, Color.G + 0.1, Color.B + 0.1)
	SetVertexColors(KeyRingTextures, Color.R + 0.4, Color.G + 0.4, Color.B + 0.4)
	SetDesaturations(DesaturateTextures, Desaturation)

	KeyBindingFrame_Theme()
	MacroFrame_Theme()

	-- Update bag textures
	if GetBackpackFrame() ~= nil then
		Set_BackpackTextures(GetBackpackFrame(), nil, 0)
	end
end
-- Ensures specific textures are themed
GameMenuFrame:HookScript("OnShow", Update_DarkTheme)
InterfaceOptionsFrame:HookScript("OnShow", Update_DarkTheme)
VideoOptionsFrame:HookScript("OnShow", Update_DarkTheme)
StaticPopup1:HookScript("OnShow", Update_DarkTheme)
StaticPopup2:HookScript("OnShow", Update_DarkTheme)
StaticPopup3:HookScript("OnShow", Update_DarkTheme)
StaticPopup4:HookScript("OnShow", Update_DarkTheme)
hooksecurefunc("ContainerFrame_Update", Update_DarkTheme)
local f = CreateFrame("Frame")
f:RegisterEvent("DISPLAY_SIZE_CHANGED")
f:RegisterEvent("SPELL_UPDATE_USABLE")
f:SetScript("OnEvent", Update_DarkTheme)



--------------------==≡≡[ PIXEL PERFECT ]≡≡==-----------------------------------

-- local function Update_PixelPerfectInterfaceWarnings()
-- 	if RUI_SavedVars.Options.PixelPerfect then
-- 		Advanced_UseUIScale:Disable()
-- 		Advanced_UIScaleSlider:Disable()
-- 		_G[Advanced_UseUIScale:GetName() .. "Text"]:SetTextColor(1, 0, 0, 1)
-- 		_G[Advanced_UseUIScale:GetName() .. "Text"]:SetText("The 'Use UI Scale' toggle is unavailable while Pixel Perfect mode is active. Type '/rui' for options.")
-- 		Advanced_UseUIScaleText:SetPoint("LEFT", Advanced_UseUIScale, "LEFT", 4, -40)
-- 	end
-- end

-- function Update_PixelPerfect(self)
-- 	if RUI_SavedVars.Options.PixelPerfect then
-- 		if not InCombatLockdown() then
-- 			local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
-- 			if scale < .64 then
-- 				UIParent:SetScale(scale)
-- 			else
-- 				self:UnregisterEvent("UI_SCALE_CHANGED")
-- 				SetCVar("uiScale", scale)
-- 			end
-- 		else
-- 			self:RegisterEvent("PLAYER_REGEN_ENABLED")
-- 		end

-- 		if event == "PLAYER_REGEN_ENABLED" then
-- 			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
-- 		end
-- 	end
-- end
-- local f = CreateFrame("Frame")
-- f:RegisterEvent("UI_SCALE_CHANGED")
-- f:SetScript("OnEvent", Update_PixelPerfect)



--------------------==≡≡[ GENERAL EVENTS ]≡≡==-----------------------------------

-- This event fires whenever an addon has finished loading and the
-- SavedVariables for that addon have been loaded from their file
local function AddonLoaded()
	Apply_SavedVariables()
end
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", AddonLoaded)
