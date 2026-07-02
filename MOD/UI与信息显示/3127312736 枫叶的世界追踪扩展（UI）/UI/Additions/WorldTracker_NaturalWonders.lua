-- WorldTracker_NaturalWonders
-- Author: yiboy
-- DateCreated: 12/30/2023 5:02:16 PM
--------------------------------------------------------------
-- ===========================================================================
--	INCLUDE
-- ===========================================================================
include("InstanceManager");
include("SupportFunctions");
include("GameCapabilities");
--include("Cheat_Menu_Panel_Functions");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

-- ===========================================================================
--	VARIABLES
-- ===========================================================================
--local Controls.NaturalWonderListGrid		:table		= {};
local m_NaturalWonderEntryIM			:table		= {};

local m_hideNaturalWonderList				= false;
local m_foldNaturalWonderList				= true;
local m_IsLoading:boolean					= false;
local m_IsAttached:boolean					= false;

local m_IsExpansion2Active:boolean			= false;
local m_IsExpansion1Active:boolean			= false;
-- ===========================================================================
function AttachPanelToWorldTracker()
	if (m_IsLoading) then
		return;
	end
	if (not m_IsAttached) then
		--Controls.NaturalWonderListGrid = Controls.NaturalWonderListGrid

		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");
		if (worldTrackerPanel ~= nil) then
			--Controls.NaturalWonderListGrid:ChangeParent(worldTrackerPanel);
			worldTrackerPanel:AddChildAtIndex(Controls.NaturalWonderListGrid, 1);
			worldTrackerPanel:CalculateSize();
			worldTrackerPanel:ReprocessAnchoring();
			m_IsAttached = true;
			print("NaturalWonderListGrid Attached!")
		end
	end
end

-- ===========================================================================
-- // Attach List To WorldTracker
-- ===========================================================================
function OnLoadGameViewStateDone()
	AttachPanelToWorldTracker();

	Events.ImprovementAddedToMap.Add( 		On_ImprovementAddedToMap_WTE );

	Events.UnitMoveComplete.Add(			On_UnitMoveComplete_WTE )
	Events.CityAddedToMap.Add(				On_CityAddedToMap_WTE );
	Events.CityMadePurchase.Add(			On_CityMadePurchase_WTE );

	Events.CityVisibilityChanged.Add(		On_CityVisibilityChanged_WTE );
	Events.UnitVisibilityChanged.Add(		On_UnitVisibilityChanged_WTE );
	Events.LocalPlayerChanged.Add(			On_LocalPlayerChanged_WTE);
	
end

-- ===========================================================================
-- // List Control and Checkbox Attach
-- ===========================================================================
function UpdateNaturalWonderList(hideNaturalWonderList:boolean, foldNaturalWonderList:boolean)
	m_hideNaturalWonderList = hideNaturalWonderList; 
	Controls.NaturalWonderListGrid:SetHide(m_hideNaturalWonderList);
	--Controls.NaturalWonderListGrid:SetHide(false);
	Controls.ToggleNaturalWonderListCheck:SetCheck(not m_hideNaturalWonderList);

	Refresh_NW(hideNaturalWonderList, foldNaturalWonderList)

end
function InitDropdown()
	local researchCheckButton = ContextPtr:LookUpControl("/InGame/WorldTracker/ResearchCheckButton");
	if researchCheckButton == nil then 
		return 
	end

	--Controls.NaturalWonderListStack:ChangeParent(researchCheckButton);
	researchCheckButton:AddChildAtIndex(Controls.NaturalWonderListStack, 1);
	researchCheckButton.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
	print("NaturalWonderList InitDropdown")
end

-- ===========================================================================
function Refresh_NW(hideNaturalWonderList, foldNaturalWonderList)
	--print("refreshing 001")
	-- If not an actual player (observer, tuner, etc...) then we're done here...
	local ePlayer		:number = Game.GetLocalPlayer();
	if (ePlayer == PlayerTypes.NONE or ePlayer == PlayerTypes.OBSERVER) then
		return;
	end
	local pPlayerConfig : table = PlayerConfigurations[ePlayer];

	if (ePlayer == PlayerTypes.NONE or (not pPlayerConfig:IsAlive()) ) then
		--Controls.CivicsCheck:SetHide(true);
		return;
	end
	
	m_NaturalWonderEntryIM:ResetInstances();

	if hideNaturalWonderList then
		return
	end
	if foldNaturalWonderList then
		return
	end

	--print("refreshing 002")

	local naturalWonder_num = 0
	local naturalWonder_plotIndex_List = {}
	local ur_naturalWonder_num = 0
	local ur_naturalWonder_plotIndex_List = {}
	naturalWonder_num, naturalWonder_plotIndex_List, ur_naturalWonder_num, ur_naturalWonder_plotIndex_List = findNaturalWonders()


	--print("naturalWonder_num = ", naturalWonder_num)
	--print("ur_naturalWonder_num = ", ur_naturalWonder_num)

	--local pPlayer : table = Players[ePlayer];
	--local pPlayerUnits : table = pPlayer:GetUnits();
	--local numUnits : number = pPlayerUnits:GetCount();
	--local playerVis = PlayersVisibility[ePlayer];

	if (naturalWonder_num > 0) then
		--print("refreshing 003")
		

		for key, value in pairs(naturalWonder_plotIndex_List) do
			local plotIndex = value

			AddNaturalWonderToList(plotIndex, true)
		end	
	end
	
	if ur_naturalWonder_num > 0 then
		--print("refreshing 004")
		for key, value in pairs(ur_naturalWonder_plotIndex_List) do
			local plotIndex = value

			AddNaturalWonderToList(plotIndex, false)
		end	
	end

	if (naturalWonder_num == 0) and (ur_naturalWonder_num == 0) then
		Controls.NoNaturalWondersLabel:SetHide(false);
		--Controls.NaturalWondersSearchBox:SetDisabled(true);
		--Controls.NaturalWondersSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_NO_NATURAL_WONDERS");
	else
		Controls.NoNaturalWondersLabel:SetHide(true);
		--Controls.NaturalWondersSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_NATURAL_WONDERS_SEARCH_TT");
	end

	--print("refreshing 005")
end
-- ===========================================================================
function TableIncludeValue(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then 
		return true;
		end
	end
	return false;
end
-- ===========================================================================
function findNaturalWonders()
	--print("fn001")
	local NaturalWonder_PlotIndex_List = {}
	local NaturalWonder_PlotIndex_Distance_Map = {}
	local NaturalWonder_FeatureType_List = {}

	local unrevealed_NaturalWonder_PlotIndex_List = {}
	local unrevealed_NaturalWonder_FeatureType_List = {}

	local ePlayer		:number = Game.GetLocalPlayer();
	local playerVis = PlayersVisibility[ePlayer];

	--print("fn002")
	--先遍历所有单元格，寻找能看到的自然奇观
	local iW, iH = Map.GetGridSize();
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		local pFeatureType = plot:GetFeatureType()

		if pFeatureType ~= nil and ( plot:IsNaturalWonder() ) then
			local pFeatureTypeStr = GameInfo.Features[pFeatureType].FeatureType

			local pX, pY = findCapitalOrSettlerLocation(ePlayer)
			local revealed = false
			if pX ~= -9999 then
				if playerVis:IsRevealed(plot:GetX(), plot:GetY()) then
					revealed = true
				end
			end
			--print("revealed = ", revealed)
			--print("pX = ", pX)

			--不能重复统计
			if (not TableIncludeValue(NaturalWonder_FeatureType_List, pFeatureTypeStr)) then
				if revealed then
					table.insert(NaturalWonder_PlotIndex_List, i)
					table.insert(NaturalWonder_FeatureType_List, pFeatureTypeStr)

					local iDistance = Map.GetPlotDistance(pX, pY, plot:GetX(), plot:GetY());
					--print("iDistance = ", iDistance)
					NaturalWonder_PlotIndex_Distance_Map["Plot"..tostring(i)] = iDistance

				end
			end

		end			
	end

	--再先遍历所有单元格，寻找看不到的自然奇观
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		local pFeatureType = plot:GetFeatureType()

		if pFeatureType ~= nil and ( plot:IsNaturalWonder() ) then
			local pFeatureTypeStr = GameInfo.Features[pFeatureType].FeatureType

			local pX, pY = findCapitalOrSettlerLocation(ePlayer)
			local revealed = false
			if pX ~= -9999 then
				if playerVis:IsRevealed(plot:GetX(), plot:GetY()) then
					revealed = true
				end
			end
			--print("revealed = ", revealed)
			--print("pX = ", pX)

			--必须不是能看到的自然奇观，且必须未统计过
			if (not TableIncludeValue(NaturalWonder_FeatureType_List, pFeatureTypeStr)) and (not TableIncludeValue(unrevealed_NaturalWonder_FeatureType_List, pFeatureTypeStr)) then
				if not revealed then
					table.insert(unrevealed_NaturalWonder_PlotIndex_List, i)
					table.insert(unrevealed_NaturalWonder_FeatureType_List, pFeatureTypeStr)
				end
			end

		end			
	end

	--print("fn003")
	--for k, v in pairs(NaturalWonder_PlotIndex_Distance_Map) do
		--print("key = ", k)
		--print("value = ", v)
	--end

	if #NaturalWonder_PlotIndex_List > 2 then
		--对能看到的单元格按远近排序
		table.sort(NaturalWonder_PlotIndex_List, 
			function(a, b)
				if not a or not b then
					return false
				end

				local iDistance_a = NaturalWonder_PlotIndex_Distance_Map["Plot"..tostring(a)]
				local iDistance_b = NaturalWonder_PlotIndex_Distance_Map["Plot"..tostring(b)]

				return iDistance_a < iDistance_b
			end
		)
	end

	return #NaturalWonder_PlotIndex_List, NaturalWonder_PlotIndex_List, #unrevealed_NaturalWonder_PlotIndex_List, unrevealed_NaturalWonder_PlotIndex_List
end
-- ===========================================================================
function findCapitalOrSettlerLocation(playerID)
	local pPlayer = Players[playerID]
	if pPlayer == nil then
		return -9999, -9999
	end
	local kCapital = pPlayer:GetCities():GetCapitalCity()
	local kX 
	local kY 
	if kCapital ~= nil then
		--print("capital not nil")
		kX = kCapital:GetX()
		kY = kCapital:GetY()
		--print("X=", kCapitalX)
		--print("Y=", kCapitalY)
	else
		local pPlayerUnits : table = pPlayer:GetUnits();
		if (pPlayerUnits:GetCount() > 0) then

			for i, pUnit in pPlayerUnits:Members() do
				local pUnitInfo : table = GameInfo.Units[pUnit:GetUnitType()];
				if pUnitInfo.UnitType == "UNIT_SETTLER" then
					kX = pUnit:GetX()
					kY = pUnit:GetY()
					break
				end			
			end
		else
			kX = 1
			kY = 1
		end
	end
	return kX, kY
end
-- ===========================================================================
function AddNaturalWonderToList(plotIndex, revealed)
	local uiNaturalWonderEntry : table = m_NaturalWonderEntryIM:GetInstance();

	local plot = Map.GetPlotByIndex(plotIndex);

	local pFeatureType = plot:GetFeatureType()
	local naturalWonderInfo = GameInfo.Features[pFeatureType]
	local naturalWonderName = Locale.Lookup(naturalWonderInfo.Name)
	local naturalWonderTypeStr = naturalWonderInfo.FeatureType

	local continentType = plot:GetContinentType()
	local continentInfo = GameInfo.Continents[continentType]
	
	local buttonText = ""
	if continentInfo ~= nil then
		local continentDesc = continentInfo.Description
		local continentDescStr = Locale.Lookup(continentDesc)
		buttonText = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TEXT", naturalWonderName, continentDescStr, tostring(plotIndex) )

	else		
		buttonText = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TEXT_WATER", naturalWonderName, tostring(plotIndex) )

		local territory = Territories.GetTerritoryAt(plotIndex);
		if territory ~= nil then
			local territoryName = territory:GetName();
			if territoryName ~= nil then
				buttonText = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TEXT_TERRITORY", naturalWonderName, territoryName, tostring(plotIndex) )
			end
		end
		
	end

	local buttonText_unrevealed = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TEXT_UNREVEALED")
	
	--Locale.ToUpper(uniqueName)

	UpdateNaturalWonderIcon(uiNaturalWonderEntry, naturalWonderTypeStr, revealed);

	-- Update status icon
	--uiNaturalWonderEntry.NaturalWonderStatusIcon:SetIcon("ICON_DEFENSE");


	-- Update entry color if unrevealed
	if revealed then
		uiNaturalWonderEntry.Button:SetText( buttonText );

		uiNaturalWonderEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				OnNaturalWonderEntryClicked(plotIndex) 
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TOOLTIP");
		uiNaturalWonderEntry.Button:SetToolTipString(tooltip);

		uiNaturalWonderEntry.Button:GetTextControl():SetColorByName("UnitPanelTextCS");
		uiNaturalWonderEntry.NaturalWonderTypeIcon:SetColorByName("UnitPanelTextCS");

	else
		uiNaturalWonderEntry.Button:SetText( buttonText_unrevealed );

		uiNaturalWonderEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				local takeplace = 0
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_NATURAL_WONDER_BUTTON_TOOLTIP_UNREVEALED");
		uiNaturalWonderEntry.Button:SetToolTipString(tooltip);

		uiNaturalWonderEntry.Button:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		uiNaturalWonderEntry.NaturalWonderTypeIcon:SetColorByName("UnitPanelTextDisabledCS");
	end
end
-- ===========================================================================
function UpdateNaturalWonderIcon(uiEntry:table, naturalWonderTypeStr:string, revealed:boolean)
	local featureTypeStr = naturalWonderTypeStr
	if not revealed then
		featureTypeStr = "FEATURE_ICE"
	end

	local iconInfo={}
	iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas("ICON_"..featureTypeStr, 50); 
	if iconInfo.textureSheet then
		uiEntry.NaturalWonderTypeIcon:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	end
end
-- ===========================================================================
function OnNaturalWonderEntryClicked(plotIndex:number)
	local plot = Map.GetPlotByIndex(plotIndex);
	if plot then
		UI.LookAtPlot(plot:GetX(), plot:GetY());
	end
end
-- ===========================================================================
--	If the official Civ6 Expansion "Rise and Fall" (XP1) and "Gathering Storm" (XP2) is active.
-- ===========================================================================
function IsExpansion1Active()
	local isActive1:boolean  = Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9");
	--print("xp1 is "..tostring(isActive1))
	return isActive1;
end
-- ===========================================================================
function IsExpansion2Active()
	local isActive2:boolean  = Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68");
	--print("xp2 is "..tostring(isActive2))
	return isActive2;
end
-- ===========================================================================
--展开和合上面板
function OnPanelTitleClicked()
	OnPanelTitleClicked_Base();

end

function OnPanelTitleClicked_Base()
    if m_foldNaturalWonderList then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.NaturalWonderListGrid:SetSizeY(207);

		UpdateNaturalWonderList(false, false)
		
		--Controls.CheatResourcesLuximg:SetHide(true);
		--Controls.CheatResourcesLux:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesStr:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesBonus:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatButtonEra:SetToolTipString("Disabled - Requires R&F DLC");

		m_foldNaturalWonderList = false
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.NaturalWonderListGrid:SetSizeY(25);

		UpdateNaturalWonderList(false, true)

		m_foldNaturalWonderList = true
	end	
end
-- ===========================================================================
--快捷键，现在没用到
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then 
		return KeyHandler( pInputStruct:GetKey() ); 
	end
	return false;
end
-- ===========================================================================
local function InitializeControls()


	Controls.NaturalWonder_HeaderTitle:RegisterCallback(Mouse.eLClick, OnPanelTitleClicked);
	
	Controls.ToggleNaturalWonderListCheck:RegisterCheckHandler(
		function() 
			UpdateNaturalWonderList(not m_hideNaturalWonderList, true); 
		end
	);

	Controls.ToggleNaturalWonderListCheck:SetCheck(true);
	--UpdateNaturalWonderList(true);
	--Controls.NaturalWonderListGrid:SetSizeY(207);
end

-- ===========================================================================
--刷新的函数
function On_ImprovementAddedToMap_WTE(iX, iY, eImprovementID, playerID)

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_UnitMoveComplete_WTE(playerID, unitID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_CityAddedToMap_WTE(playerID, cityID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_CityMadePurchase_WTE(playerID:number, cityID:number, plotX:number, plotY:number, purchaseType, objectType)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if purchaseType ~= EventSubTypes.PLOT then
		return
    end

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_CityVisibilityChanged_WTE( playerID: number, cityID : number, eVisibility : number)
    if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_UnitVisibilityChanged_WTE( playerID:number, unitID:number )
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end

function On_LocalPlayerChanged_WTE( localPlayerID:number , prevLocalPlayerID:number )
	if (not m_foldNaturalWonderList) and (not m_hideNaturalWonderList) then
		UpdateNaturalWonderList(false, false)
	end
end
-- ===========================================================================
-- // Init
-- ===========================================================================
function Initialize()
	m_IsLoading = true;
		
	m_NaturalWonderEntryIM = InstanceManager:new( "NaturalWonderListEntry", "Button", Controls.NaturalWonderStack);
		
	Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
	Events.LoadGameViewStateDone.Add(InitDropdown);
	--Events.InputActionTriggered.Add( OnInputActionTriggered );
	--ContextPtr:SetInputHandler( OnInputHandler, true );
	InitializeControls();
	
	m_IsExpansion2Active	= IsExpansion2Active();
	m_IsExpansion1Active	= IsExpansion1Active();		

	if  GameConfiguration.IsNetworkMultiplayer() then
		UpdateNaturalWonderList(true, true);
		Controls.ToggleNaturalWonderListCheck:SetHide(true);
	else
		UpdateNaturalWonderList(false, true);
	end
	m_IsLoading = false;
end
Initialize();