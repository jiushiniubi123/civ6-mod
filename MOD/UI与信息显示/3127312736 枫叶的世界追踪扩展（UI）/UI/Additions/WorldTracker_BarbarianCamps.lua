-- WorldTracker_BarbarianCamps
-- Author: yiboy
-- DateCreated: 12/31/2023 11:32:04 AM
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
local my_improvement_barbarian_camp_item = GameInfo.Improvements['IMPROVEMENT_BARBARIAN_CAMP']

local m_list_undiscovered_barbarian_camps = false
-- ===========================================================================
--	VARIABLES
-- ===========================================================================
--local Controls.BarbarianCampListGrid		:table		= {};
local m_BarbarianCampEntryIM			:table		= {};

local m_hideBarbarianCampList				= false;
local m_foldBarbarianCampList				= true;
local m_IsLoading:boolean					= false;
local m_IsAttached:boolean					= false;

local m_IsExpansion2Active:boolean			= false;
local m_IsExpansion1Active:boolean			= false;
local m_IsBarbarianClansModeOn:boolean		= false;
-- ===========================================================================
function AttachPanelToWorldTracker()
	if (m_IsLoading) then
		return;
	end
	if (not m_IsAttached) then
		--Controls.BarbarianCampListGrid = Controls.BarbarianCampListGrid

		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");
		if (worldTrackerPanel ~= nil) then
			--Controls.BarbarianCampListGrid:ChangeParent(worldTrackerPanel);
			worldTrackerPanel:AddChildAtIndex(Controls.BarbarianCampListGrid, 1);
			worldTrackerPanel:CalculateSize();
			worldTrackerPanel:ReprocessAnchoring();
			m_IsAttached = true;
			print("BarbarianCampListGrid Attached!")
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
function UpdateBarbarianCampList(hideBarbarianCampList:boolean, foldBarbarianCampList:boolean)
	m_hideBarbarianCampList = hideBarbarianCampList; 
	Controls.BarbarianCampListGrid:SetHide(m_hideBarbarianCampList);
	--Controls.BarbarianCampListGrid:SetHide(false);
	Controls.ToggleBarbarianCampListCheck:SetCheck(not m_hideBarbarianCampList);

	Refresh_BC(hideBarbarianCampList, foldBarbarianCampList)

end
function InitDropdown()
	local researchCheckButton = ContextPtr:LookUpControl("/InGame/WorldTracker/ResearchCheckButton");
	if researchCheckButton == nil then 
		return 
	end

	--Controls.BarbarianCampListStack:ChangeParent(researchCheckButton);
	researchCheckButton:AddChildAtIndex(Controls.BarbarianCampListStack, 1);
	researchCheckButton.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
	print("BarbarianCampListGrid InitDropdown")
end

-- ===========================================================================
function Refresh_BC(hideBarbarianCampList, foldBarbarianCampList)
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
	
	m_BarbarianCampEntryIM:ResetInstances();

	if hideBarbarianCampList then
		return
	end
	if foldBarbarianCampList then
		return
	end

	--print("refreshing 002")

	local barbarianCamp_num = 0
	local barbarianCamp_plotIndex_List = {}
	local ur_barbarianCamp_num = 0
	local ur_barbarianCamp_plotIndex_List = {}
	barbarianCamp_num, barbarianCamp_plotIndex_List, ur_barbarianCamp_num, ur_barbarianCamp_plotIndex_List = findBarbarianCamps()


	--print("barbarianCamp_num = ", barbarianCamp_num)
	--print("ur_barbarianCamp_num = ", ur_barbarianCamp_num)

	--local pPlayer : table = Players[ePlayer];
	--local pPlayerUnits : table = pPlayer:GetUnits();
	--local numUnits : number = pPlayerUnits:GetCount();
	--local playerVis = PlayersVisibility[ePlayer];

	if (barbarianCamp_num > 0) then
		--print("refreshing 003")
		

		for key, value in pairs(barbarianCamp_plotIndex_List) do
			local plotIndex = value

			AddBarbarianCampToList(plotIndex, true)
		end	
	end
	
	if ur_barbarianCamp_num > 0 then
		--print("refreshing 004")
		for key, value in pairs(ur_barbarianCamp_plotIndex_List) do
			local plotIndex = value
			if m_list_undiscovered_barbarian_camps then
				AddBarbarianCampToList(plotIndex, false)
			end
		end	
	end

	if m_list_undiscovered_barbarian_camps then
		if (barbarianCamp_num == 0) and (ur_barbarianCamp_num == 0) then
			Controls.NoBarbarianCampsLabel:SetHide(false);
			--Controls.BarbarianCampsSearchBox:SetDisabled(true);
			--Controls.BarbarianCampsSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_NO_BARBARIAN_CAMPS");
		else
			Controls.NoBarbarianCampsLabel:SetHide(true);
			--Controls.BarbarianCampsSearchBox:LocalizeAndSetToolTip("LOC_WORLDTRACKER_BARBARIAN_CAMPS_SEARCH_TT");
		end
	else
		if (barbarianCamp_num == 0) then
			Controls.NoBarbarianCampsLabel:SetHide(false);
		else
			Controls.NoBarbarianCampsLabel:SetHide(true);
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
function findBarbarianCamps()
	--print("fg001")
	local BarbarianCamp_PlotIndex_List = {}
	local BarbarianCamp_PlotIndex_Distance_Map = {}

	local unrevealed_BarbarianCamp_PlotIndex_List = {}

	if my_improvement_barbarian_camp_item == nil then
		return 0, BarbarianCamp_PlotIndex_List, 0, unrevealed_BarbarianCamp_PlotIndex_List
	end

	local ePlayer		:number = Game.GetLocalPlayer();
	local playerVis = PlayersVisibility[ePlayer];

	--print("fg002")
	local iW, iH = Map.GetGridSize();
	for i = 0, (iW * iH) - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		local pImprovementType = plot:GetImprovementType()

		if pImprovementType ~= nil and pImprovementType == my_improvement_barbarian_camp_item.Index then
			
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
				table.insert(BarbarianCamp_PlotIndex_List, i)

				local iDistance = Map.GetPlotDistance(pX, pY, plot:GetX(), plot:GetY());
				--print("iDistance = ", iDistance)
				BarbarianCamp_PlotIndex_Distance_Map["Plot"..tostring(i)] = iDistance
			else
				table.insert(unrevealed_BarbarianCamp_PlotIndex_List, i)
			end
		end			
	end

	--print("fg003")
	--for k, v in pairs(BarbarianCamp_PlotIndex_Distance_Map) do
		--print("key = ", k)
		--print("value = ", v)
	--end

	if #BarbarianCamp_PlotIndex_List > 2 then
		--对能看到的单元格按远近排序
		table.sort(BarbarianCamp_PlotIndex_List, 
			function(a, b)
				if not a or not b then
					return false
				end

				local iDistance_a = BarbarianCamp_PlotIndex_Distance_Map["Plot"..tostring(a)]
				local iDistance_b = BarbarianCamp_PlotIndex_Distance_Map["Plot"..tostring(b)]

				return iDistance_a < iDistance_b
			end
		)
	end

	return #BarbarianCamp_PlotIndex_List, BarbarianCamp_PlotIndex_List, #unrevealed_BarbarianCamp_PlotIndex_List, unrevealed_BarbarianCamp_PlotIndex_List
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
function AddBarbarianCampToList(plotIndex, revealed)
	local uiBarbarianCampEntry : table = m_BarbarianCampEntryIM:GetInstance();

	local barbarianCampName : string = Locale.Lookup("LOC_IMPROVEMENT_BARBARIAN_CAMP_NAME")

	local plot = Map.GetPlotByIndex(plotIndex);
	local continentType = plot:GetContinentType()
	local continentDesc = GameInfo.Continents[continentType].Description
	local continentDescStr = Locale.Lookup(continentDesc)

	local buttonText = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TEXT", barbarianCampName, continentDescStr, tostring(plotIndex) )
	local buttonText_unrevealed = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TEXT_UNREVEALED", barbarianCampName)

	
	--蛮族氏族模式开启时
	local buttonText_ClanMode = ""
	local buttonText_unrevealed_ClanMode = ""
	local clan_name = ""
	if m_IsBarbarianClansModeOn then
		local success = false
		local pBarbManager = Game.GetBarbarianManager();
		local iTribeIndex = pBarbManager:GetTribeIndexAtLocation(plot:GetX(), plot:GetY());
		if (iTribeIndex >= 0) then
			local eTribeName = pBarbManager:GetTribeNameType(iTribeIndex);
			if (GameInfo.BarbarianTribeNames[eTribeName] ~= nil) then
				local tribeName = GameInfo.BarbarianTribeNames[eTribeName].TribeDisplayName
				clan_name = tribeName

				buttonText_ClanMode = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TEXT_CLANMODE", tribeName, continentDescStr, tostring(plotIndex));

				--氏族大类
				local eTribeType = pBarbManager:GetTribeType(iTribeIndex);
				local pBarbTribe = GameInfo.BarbarianTribes[eTribeType];
				if (pBarbTribe ~= nil and pBarbTribe.Name ~= nil) then
					local strClanType : string = Locale.Lookup(pBarbTribe.Name);
					buttonText_ClanMode = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TEXT_CLANMODE_DETAILED", tribeName, strClanType, continentDescStr, tostring(plotIndex));
				end	
				
				buttonText_unrevealed_ClanMode = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TEXT_UNREVEALED_CLANMODE")
				success = true
			end
		end
		if success then
			UpdateBarbarianCampIcon_ClanMode(uiBarbarianCampEntry, iTribeIndex);
		else
			buttonText_ClanMode = buttonText
			buttonText_unrevealed_ClanMode = buttonText_unrevealed
			UpdateBarbarianCampIcon(uiBarbarianCampEntry);
		end
	else
		UpdateBarbarianCampIcon(uiBarbarianCampEntry);
	end
	
	--Locale.ToUpper(uniqueName)

	--UpdateBarbarianCampIcon(uiBarbarianCampEntry);

	-- Update status icon
	--uiBarbarianCampEntry.BarbarianCampStatusIcon:SetIcon("ICON_DEFENSE");


	-- Update entry color if unrevealed
	if revealed then
		if m_IsBarbarianClansModeOn then
			uiBarbarianCampEntry.Button:SetText( buttonText_ClanMode );

			--为最右侧按钮注册函数
			uiBarbarianCampEntry.ToggleTreatWithTribePopup:SetHide(false)
			uiBarbarianCampEntry.ToggleTreatWithTribePopup:SetEnabled(true)
			local treat_tooltip = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_TREAT_POPUP_TOOLTIP_UNREVEALED_CLANMODE", clan_name)
			uiBarbarianCampEntry.ToggleTreatWithTribePopup:SetToolTipString(treat_tooltip);
			uiBarbarianCampEntry.ToggleTreatWithTribePopup:RegisterCallback(Mouse.eLClick, 
				function() 
					OnBarbarianCamp_ToggleTreatPopup_Clicked(plotIndex) 
				end
			);

		else
			uiBarbarianCampEntry.Button:SetText( buttonText );
		end

		uiBarbarianCampEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				OnBarbarianCampEntryClicked(plotIndex) 
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TOOLTIP");
		uiBarbarianCampEntry.Button:SetToolTipString(tooltip);

		uiBarbarianCampEntry.Button:GetTextControl():SetColorByName("UnitPanelTextCS");
		uiBarbarianCampEntry.BarbarianCampTypeIcon:SetColorByName("UnitPanelTextCS");

	else	
		if m_IsBarbarianClansModeOn then
			uiBarbarianCampEntry.Button:SetText( buttonText_unrevealed_ClanMode );
		else
			uiBarbarianCampEntry.Button:SetText( buttonText_unrevealed );
		end

		uiBarbarianCampEntry.Button:RegisterCallback(Mouse.eLClick, 
			function() 
				local takeplace = 0
			end
		);

		local tooltip = Locale.Lookup("LOC_WORLDTRACKER_BARBARIAN_CAMP_BUTTON_TOOLTIP_UNREVEALED");
		uiBarbarianCampEntry.Button:SetToolTipString(tooltip);

		uiBarbarianCampEntry.Button:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		uiBarbarianCampEntry.BarbarianCampTypeIcon:SetColorByName("UnitPanelTextDisabledCS");
	end
end
-- ===========================================================================
function UpdateBarbarianCampIcon(uiEntry:table)
	local iconInfo={}
	iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas("ICON_CIVILIZATION_BARBARIAN", 36); 
	if iconInfo.textureSheet then
		uiEntry.BarbarianCampTypeIcon:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	end
end

function UpdateBarbarianCampIcon_ClanMode(uiEntry:table, iTribeIndex)
	local pBarbManager = Game.GetBarbarianManager();
	local eTribeName = pBarbManager:GetTribeNameType(iTribeIndex);
	local pBarbTribe = GameInfo.BarbarianTribeNames[eTribeName]

	local iconInfo={}
	iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas("ICON_" .. pBarbTribe.TribeNameType, 36); 
	if iconInfo.textureSheet then
		uiEntry.BarbarianCampTypeIcon:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	end
end

-- ===========================================================================
function OnBarbarianCampEntryClicked(plotIndex:number)
	local plot = Map.GetPlotByIndex(plotIndex);
	if plot then
		UI.LookAtPlot(plot:GetX(), plot:GetY());
	end
end

function OnBarbarianCamp_ToggleTreatPopup_Clicked(plotIndex:number)
	LuaEvents.CityBannerManager_OpenTreatWithTribePopup(plotIndex);
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
function IsBarbarianClansModeOn()
	local tribe_type_kind_item = GameInfo.Kinds["KIND_BARBARIAN_TRIBE_TYPE"]
	if tribe_type_kind_item ~= nil then
		return true
	else
		return false
	end
end
-- ===========================================================================
--展开和合上面板
function OnPanelTitleClicked()
	OnPanelTitleClicked_Base();

end

function OnPanelTitleClicked_Base()
    if m_foldBarbarianCampList then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.BarbarianCampListGrid:SetSizeY(207);

		UpdateBarbarianCampList(false, false)
		
		--Controls.CheatResourcesLuximg:SetHide(true);
		--Controls.CheatResourcesLux:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesStr:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatResourcesBonus:SetToolTipString("Disabled - Requires GS DLC");
		--Controls.CheatButtonEra:SetToolTipString("Disabled - Requires R&F DLC");

		m_foldBarbarianCampList = false
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.BarbarianCampListGrid:SetSizeY(25);

		UpdateBarbarianCampList(false, true)

		m_foldBarbarianCampList = true
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


	Controls.BarbarianCamp_HeaderTitle:RegisterCallback(Mouse.eLClick, OnPanelTitleClicked);
	
	Controls.ToggleBarbarianCampListCheck:RegisterCheckHandler(
		function() 
			UpdateBarbarianCampList(not m_hideBarbarianCampList, true); 
		end
	);

	Controls.ToggleBarbarianCampListCheck:SetCheck(true);
	--UpdateBarbarianCampList(true);
	--Controls.BarbarianCampListGrid:SetSizeY(207);
end

-- ===========================================================================
--一些刷新的函数
function On_ImprovementRemovedFromMap_WTE(iX, iY, eOwner)

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_ImprovementAddedToMap_WTE(iX, iY, eImprovementID, playerID)

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_UnitMoveComplete_WTE(playerID, unitID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_CityAddedToMap_WTE(playerID, cityID, iX, iY)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_CityMadePurchase_WTE(playerID:number, cityID:number, plotX:number, plotY:number, purchaseType, objectType)
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if purchaseType ~= EventSubTypes.PLOT then
		return
    end

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_CityVisibilityChanged_WTE( playerID: number, cityID : number, eVisibility : number)
    if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_UnitVisibilityChanged_WTE( playerID:number, unitID:number )
	if playerID ~= Game.GetLocalPlayer() then
		return
	end

	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end

function On_LocalPlayerChanged_WTE( localPlayerID:number , prevLocalPlayerID:number )
	if (not m_foldBarbarianCampList) and (not m_hideBarbarianCampList) then
		UpdateBarbarianCampList(false, false)
	end
end
-- ===========================================================================
-- // Init
-- ===========================================================================
function Initialize()
	m_IsLoading = true;
		
	m_BarbarianCampEntryIM = InstanceManager:new( "BarbarianCampListEntry", "Button", Controls.BarbarianCampStack);
		
	Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
	Events.LoadGameViewStateDone.Add(InitDropdown);
	--Events.InputActionTriggered.Add( OnInputActionTriggered );
	--ContextPtr:SetInputHandler( OnInputHandler, true );
	InitializeControls();
	
	m_IsExpansion2Active		= IsExpansion2Active();
	m_IsExpansion1Active		= IsExpansion1Active();
	m_IsBarbarianClansModeOn	= IsBarbarianClansModeOn()

	if  GameConfiguration.IsNetworkMultiplayer() then
		UpdateBarbarianCampList(true, true);
		Controls.ToggleBarbarianCampListCheck:SetHide(true);
	else
		UpdateBarbarianCampList(false, true);
	end
	m_IsLoading = false;
end
Initialize();