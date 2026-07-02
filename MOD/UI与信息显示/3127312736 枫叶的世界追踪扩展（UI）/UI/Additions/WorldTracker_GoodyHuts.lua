-- WorldTracker_GoodyHuts
-- Author: yiboy
-- DateCreated: 12/28/2023 10:33:05 PM
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
local my_improvement_goody_hut_item = GameInfo.Improvements['IMPROVEMENT_GOODY_HUT']

local m_list_undiscovered_goody_huts = false
-- ===========================================================================
--	VARIABLES
-- ===========================================================================
--local Controls.GoodyHutListGrid		:table		= {};
local m_GoodyHutEntryIM			:table		= {};

local m_hideGoodyHutList				= false;
local m_foldGoodyHutList				= true;
local m_IsLoading:boolean				= false;
local m_IsAttached:boolean				= false;

local m_IsExpansion2Active:boolean		= false;
local m_IsExpansion1Active:boolean		= false;
-- ===========================================================================
function AttachPanelToWorldTracker()
	if (m_IsLoading) then
		return;
	end
	if (not m_IsAttached) then
		--Controls.GoodyHutListGrid = Controls.GoodyHutListGrid

		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");
		if (worldTrackerPanel ~= nil) then
			--Controls.GoodyHutListGrid:ChangeParent(worldTrackerPanel);
			worldTrackerPanel:AddChildAtIndex(Controls.GoodyHutListGrid, 1);
			worldTrackerPanel:CalculateSize();
			worldTrackerPanel:ReprocessAnchoring();
			m_IsAttached = true;
			print("GoodyHutListGrid Attached!")
		end
	end
end

-- ===========================================================================
-- // Attach List To WorldTracker
-- ===========================================================================
function OnLoadGameViewStateDone()
	AttachPanelToWorldTracker();

	Events.ImprovementRemovedFromMap.Add(	On_ImprovementRemovedFromMap_WTE )
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
function UpdateGoodyHutList(hideGoodyHutList:boolean, foldGoodyHutList:boolean)
	m_hideGoodyHutList = hideGoodyHutList; 
	Controls.GoodyHutListGrid:SetHide(m_hideGoodyHutList);
	--Controls.GoodyHutListGrid:SetHide(false);
	Controls.ToggleGoodyHutListCheck:SetCheck(not m_hideGoodyHutList);

	Refresh_GH(hideGoodyHutList, foldGoodyHutList)

end
function InitDropdown()
	local researchCheckButton = ContextPtr:LookUpControl("/InGame/WorldTracker/ResearchCheckButton");
	if researchCheckButton == nil then 
		return 
	end

	--Controls.GoodyHutListStack:ChangeParent(researchCheckButton);
	researchCheckButton:AddChildAtIndex(Controls.GoodyHutListStack, 1);
	researchCheckButton.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
	print("GoodyHutListGrid InitDropdown")
end

-- ===========================================================================
function Refresh_GH(hideGoodyHutList, foldGoodyHutList)
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
	
	m_GoodyHutEntryIM:ResetInstances();

	if hideGoodyHutList then
		return
	end
	if foldGoodyHutList then
		return
	end

	--print("refreshing 002")

	local goodyHut_num = 0
	local goodyHut_plotIndex_List = {}
	local ur_goodyHut_num = 0
	local ur_goodyHut_plotIndex_List = {}
	goodyHut_num, goodyHut_plotIndex_List, ur_goodyHut_num, ur_goodyHut_plotIndex_List = findGoodyHuts()


	--print("goodyHut_num = ", goodyHut_num)
	--print("ur_goodyHut_num = ", ur_goodyHut_num)

	--local pPlayer : table = Players[ePlayer];
	--local pPlayerUnits : table = pPlayer:GetUnits();
	--local numUnits : number = pPlayerUnits:GetCount();
	--local playerVis = PlayersVisibility[ePlayer];

	if (goodyHut_num > 0) then
		--print("refreshing 003")
		

		for key, value in pairs(goodyHut_plotIndex_List) do
			local plotIndex = value

			AddGoodyHutToList(plotIndex, true)
		end	
	end
	
	if ur_goodyHut_num > 0 then
		--print("refreshing 004")
		for key, value in pairs(ur_goodyHut_plotIndex_List) do
			local plotIndex = value

			if m_list_undiscovered_goody_huts then
				AddGoodyHutToList(plotIndex, false)
			end
		end	
	end

	if m_list_undiscovered_goody_huts then
		if (goodyHut_num == 0) and (ur_goodyHut_num == 0) then
			Controls.NoGoodyHutsLabel:SetHide(false);
			--Controls.GoodyHutsSearchBox:SetDisabled(true);
			--Controls.GoodyHutsSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_NO_GOODY_HUTS");
		else
			Controls.NoGoodyHutsLabel:SetHide(true);
			--Controls.GoodyHutsSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_GOODY_HUTS_SEARCH_TT");
		end
	else
		if (goodyHut_num == 0) then
			Controls.NoGoodyHutsLabel:SetHide(false);
		else
			Controls.NoGoodyHutsLabel:SetHide(true);
		end
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
function findGoodyHuts()
	--print("fg001")
	local GoodyHut_PlotIndex_List = {}
	local GoodyHut_PlotIndex_Distance_Map = {}

	local unrevealed_GoodyHut_PlotIndex_List = {}

	if my_improvement_goody_hut_item == nil then
		return 0, GoodyHut_PlotIndex_List, 0, unrevealed_GoodyHut_PlotIndex_List
	end

	local ePlayer		:number = Game.GetLocalPlayer();
	local playerVis = PlayersVisibility[ePlayer];

	--print("fg002")
	local iW, iH = Map.GetGridSize();
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		local pImprovementType = plot:GetImprovementType()

		if pImprovementType ~= nil and pImprovementType == my_improvement_goody_hut_item.Index then
			
			local pX, pY = findCapitalOrSettlerLocation(ePlayer)
			local revealed = false
			if pX ~= -9999 then
				if playerVis:IsRevealed(plot:GetX(), plot:GetY()) then
					revealed = true
				end
			end
			--print("revealed = ", revealed)
			--print("pX = ", pX)
			if revealed then
				table.insert(GoodyHut_PlotIndex_List, i)

				local iDistance = Map.GetPlotDistance(pX, pY, plot:GetX(), plot:GetY());
				--print("iDistance = ", iDistance)
				GoodyHut_PlotIndex_Distance_Map["Plot"..tostring(i)] = iDistance
			else
				table.insert(unrevealed_GoodyHut_PlotIndex_List, i)
			end
		end			
	end

	--print("fg003")
	--for k, v in pairs(GoodyHut_PlotIndex_Distance_Map) do
		--print("key = ", k)
		--print("value = ", v)
	--end

	if #GoodyHut_PlotIndex_List > 2 then
		--对能看到的单元格按远近排序
		table.sort(GoodyHut_PlotIndex_List, 
			function(a, b)
				if not a or not b then
					return false
				end

				local iDistance_a = GoodyHut_PlotIndex_Distance_Map["Plot"..tostring(a)]
				local iDistance_b = GoodyHut_PlotIndex_Distance_Map["Plot"..tostring(b)]

				return iDistance_a < iDistance_b
			end
		)
	end

	return #GoodyHut_PlotIndex_List, GoodyHut_PlotIndex_List, #unrevealed_GoodyHut_PlotIndex_List, unrevealed_GoodyHut_PlotIndex_List
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
function AddGoodyHutToList(plotIndex, revealed)
	local uiGoodyHutEntry : table = m_GoodyHutEntryIM:GetInstance();

	local goodyHutName : string = Locale.Lookup("LOC_IMPROVEMENT_GOODY_HUT_NAME")

	local plot = Map.GetPlotByIndex(plotIndex);
	local continentType = plot:GetContinentType()
	local continentDesc = GameInfo.Continents[continentType].Description
	local continentDescStr = Locale.Lookup(continentDesc)

	local buttonText = Locale.Lookup("LOC_WORLDTRACKER_GOODY_HUT_BUTTON_TEXT", goodyHutName, continentDescStr, tostring(plotIndex) )
	local buttonText_unrevealed = Locale.Lookup("LOC_WORLDTRACKER_GOODY_HUT_BUTTON_TEXT_UNREVEALED", goodyHutName)

	
	--Locale.ToUpper(uniqueName)

	UpdateGoodyHutIcon(uiGoodyHutEntry);

	-- Update status icon
	--uiGoodyHutEntry.GoodyHutStatusIcon:SetIcon("ICON_DEFENSE");


	-- Update entry color if unrevealed
	if revealed then
		uiGoodyHutEntry.Button:SetText( buttonText );

		uiGoodyHutEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				OnGoodyHutEntryClicked(plotIndex) 
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_GOODY_HUT_BUTTON_TOOLTIP");
		uiGoodyHutEntry.Button:SetToolTipString(tooltip);

		uiGoodyHutEntry.Button:GetTextControl():SetColorByName("UnitPanelTextCS");
		uiGoodyHutEntry.GoodyHutTypeIcon:SetColorByName("UnitPanelTextCS");

	else
		uiGoodyHutEntry.Button:SetText( buttonText_unrevealed );

		uiGoodyHutEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				local takeplace = 0
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_GOODY_HUT_BUTTON_TOOLTIP_UNREVEALED");
		uiGoodyHutEntry.Button:SetToolTipString(tooltip);

		uiGoodyHutEntry.Button:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		uiGoodyHutEntry.GoodyHutTypeIcon:SetColorByName("UnitPanelTextDisabledCS");
	end
end
-- ===========================================================================
function UpdateGoodyHutIcon(uiEntry:table)
	local iconInfo={}
	iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas("ICON_IMPROVEMENT_GOODY_HUT", 38); 
	if iconInfo.textureSheet then
		uiEntry.GoodyHutTypeIcon:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	end
end
-- ===========================================================================
function OnGoodyHutEntryClicked(plotIndex:number)
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
    if m_foldGoodyHutList then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.GoodyHutListGrid:SetSizeY(250);

		UpdateGoodyHutList(false, false)
		
		--Controls.CheatResourcesLuximg:SetHide(true);
		--Controls.CheatResourcesLux:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesStr:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesBonus:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatButtonEra:SetToolTipString("Disabled - Requires R&F DLC");

		m_foldGoodyHutList = false
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.GoodyHutListGrid:SetSizeY(25);

		UpdateGoodyHutList(false, true)

		m_foldGoodyHutList = true
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


	Controls.GoodyHut_HeaderTitle:RegisterCallback(Mouse.eLClick, OnPanelTitleClicked);
	
	Controls.ToggleGoodyHutListCheck:RegisterCheckHandler(
		function() 
			UpdateGoodyHutList(not m_hideGoodyHutList, true); 
		end
	);

	Controls.ToggleGoodyHutListCheck:SetCheck(true);
	--UpdateGoodyHutList(true);
	--Controls.GoodyHutListGrid:SetSizeY(250);
end

-- ===========================================================================
--一些刷新的函数
function On_ImprovementRemovedFromMap_WTE(iX, iY, eOwner)

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_ImprovementAddedToMap_WTE(iX, iY, eImprovementID, playerID)

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_UnitMoveComplete_WTE(playerID, unitID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_CityAddedToMap_WTE(playerID, cityID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_CityMadePurchase_WTE(playerID:number, cityID:number, plotX:number, plotY:number, purchaseType, objectType)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if purchaseType ~= EventSubTypes.PLOT then
		return
    end

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_CityVisibilityChanged_WTE( playerID: number, cityID : number, eVisibility : number)
    if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_UnitVisibilityChanged_WTE( playerID:number, unitID:number )
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end

function On_LocalPlayerChanged_WTE( localPlayerID:number , prevLocalPlayerID:number )
	if (not m_foldGoodyHutList) and (not m_hideGoodyHutList) then
		UpdateGoodyHutList(false, false)
	end
end
-- ===========================================================================
-- // Init
-- ===========================================================================
function Initialize()
	m_IsLoading = true;
		
	m_GoodyHutEntryIM = InstanceManager:new( "GoodyHutListEntry", "Button", Controls.GoodyHutStack);
		
	Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
	Events.LoadGameViewStateDone.Add(InitDropdown);
	--Events.InputActionTriggered.Add( OnInputActionTriggered );
	--ContextPtr:SetInputHandler( OnInputHandler, true );
	InitializeControls();

	m_IsExpansion2Active	= IsExpansion2Active();
	m_IsExpansion1Active	= IsExpansion1Active();	

	if  GameConfiguration.IsNetworkMultiplayer() then
		UpdateGoodyHutList(true, true);
		Controls.ToggleGoodyHutListCheck:SetHide(true);
	else
		UpdateGoodyHutList(false, true);
	end
	m_IsLoading = false;
end
Initialize();