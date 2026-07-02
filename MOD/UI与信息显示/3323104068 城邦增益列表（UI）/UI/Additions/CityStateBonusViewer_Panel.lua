-- CityStateBonusViewer_Panel
-- Author: yiboy
-- DateCreated: 8/1/2024 6:27:49 PM
--------------------------------------------------------------
include("InstanceManager");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

local SIZE_BELIEF_ICON_LARGE					:number = 64;
local SIZE_CIVILIZATION_ICON_44					:number = 44;

local BELIEFS_PANEL_RELATIVE_SIZE_UNSELECTED	:number = -236;
local BELIEFS_PANEL_RELATIVE_SIZE_SELECTED		:number = -326;

local DATA_FIELD_BELIEF_INDEX:string = "DataField_BeliefIndex";


local m_propertyKey				= "PlayerCanGetFanciaHopeTraits"
local m_maxCountPropertyKey		= "PlayerFanciaHope_MaxTraitsCount"
local m_usingCountPropertyKey	= "PlayerFanciaHope_UsingTraitsCount"
local m_usingTraitsPropertyKey	= "PlayerFanciaHope_TraitsInUse"


local panel_debug_mode = false


--0代表所有城邦，1代表仅遇到的城邦
local currrentViewMode = 0
local cityStateBonusViewModeNum = 1

--0代表按名称排序，1代表按类型排序
local currrentSortMode = 0
local cityStateBonusSortModeNum = 1

--ALL代表所有
local currentFilterMode = "ML_CS_ALL"
local cityStateTypes_List = {}


--强制一种城邦拥有一种颜色，兼容工商科文宗军，以及娱乐、领事、农业、海洋
local cityStateColorMatch_List = {
	"SCIENTIFIC", "RELIGIOUS", "TRADE", "CULTURAL", "MILITARISTIC", "INDUSTRIAL", "CSE_AGRICULTURAL", "CSE_CONSULAR", "CSE_ENTERTAINMENT", "CSE_MARITIME"
}

local cityStateColorMatch_Map = {
	SCIENTIFIC			= {50,202,237,255}, 
	RELIGIOUS			= {255,246,235,255}, 
	TRADE				= {255,206,108,255}, 
	CULTURAL			= {214,102,255,255}, 
	MILITARISTIC		= {255,92,92,255},
	INDUSTRIAL			= {255,149,77,255}, 
	CSE_AGRICULTURAL	= {159,226,100,255},
	CSE_CONSULAR		= {144,128,255,255},
	CSE_ENTERTAINMENT	= {255,100,170,255},
	CSE_MARITIME		= {88,220,195,255},
}
-- ===========================================================================
--	VARIABLES
-- ===========================================================================

local m_pSelectBeliefsIM:table = InstanceManager:new("BeliefSlot", "BeliefButton", Controls.BeliftStack);

local m_pChosenTraitsIM:table = InstanceManager:new("BeliefSlot", "BeliefButton", Controls.ChosenBeliefStack);

local m_uiSelectedBeliefInstance:table = nil;

local canChooseTraitsNum = 0
-- ===========================================================================
function Realize()
	Populate_ViewModeSlider()
	Populate_SortModeSlider()
	Populate_CityStateList()

end
-- ===========================================================================
function Populate_CityStateList()

	m_pSelectBeliefsIM:ResetInstances();
	m_pChosenTraitsIM:ResetInstances();

	--print("003")

	local localPlayer = Players[Game.GetLocalPlayer()]
	--local traits_in_use = localPlayer:GetProperty( m_usingTraitsPropertyKey ) or {};

	local cityStateData_list = {}

	if currrentViewMode == 0 then
		--所有城邦

		--首先找到文明
		for row in GameInfo.Civilizations() do
			if row.StartingCivilizationLevelType == "CIVILIZATION_LEVEL_CITY_STATE" then
				
				local cityStateData, success = GetCityStateData_FromDatabase(row)
				if success then
					table.insert(cityStateData_list, cityStateData)
				end
			end
		end

	elseif currrentViewMode == 1 then
		--仅遇到的城邦

		--local cityStateData_list = {}
		for i, iPlayer in ipairs(PlayerManager.GetWasEverAliveIDs()) do
			--print("004")
			local hasMet = localPlayer:GetDiplomacy():HasMet(iPlayer);
			local pPlayer = Players[iPlayer]

			if iPlayer ~= localPlayer:GetID() and hasMet and pPlayer:IsMinor() then
				local cityStateData, success = GetCityStateData_FromMinorPlayer(iPlayer)
				if success then
					table.insert(cityStateData_list, cityStateData)
				end
			end
		
		end
	end

	--做排序
	if #cityStateData_list > 1 then

		if currrentSortMode == 0 then
			--按名称排序
			table.sort(cityStateData_list, 
				function(a, b)
					if not a or not b then
						return false
					end

					return Locale.Compare(a.Name, b.Name) == -1
				end
			)

		elseif currrentSortMode == 1 then
			--按类型排序
			table.sort(cityStateData_list, 
				function(a, b)
					if not a or not b then
						return false
					end

					return a.CityStateType < b.CityStateType
				end
			)

		end

	end

	--筛选
	Populate_FilterPulldown(cityStateData_list)

	--正式创建实例
	for key, value in ipairs(cityStateData_list) do
			
		if currentFilterMode ~= "ML_CS_ALL" then
			if currentFilterMode == value.CityStateType then
				Populate_CityStateInst_FromDatabase(value)
			end
		else
			Populate_CityStateInst_FromDatabase(value)
		end
			
	end

	--print("0051")

	--print("006")

	--RealizeCurrentSelection();

	--print("007")
end

-- ===========================================================================
function GetCityStateData_FromDatabase(row)
	local civType = row.CivilizationType
	local leaderType = "ML_CS_LEADER_ERROR"
	for tRow in GameInfo.CivilizationLeaders() do
		if tRow.CivilizationType == civType then
			leaderType = tRow.LeaderType
		end
	end

	local cs_name = Locale.Lookup(row.Name)

	local bonusText = GetSuzerainBonusText_FromLeaderType( leaderType, cs_name )

	local cityStateType = "ML_CS_TYPE_ERROR"
	for kRow in GameInfo.TypeProperties() do
		if kRow.Name == "CityStateCategory" and kRow.Type == civType then
			cityStateType = kRow.Value
			--print("cityStateType=\t", cityStateType)
		end
	end

	local primaryColor = UI.GetColorValue("COLOR_BLACK")
	local secondaryColor = UI.GetColorValue("COLOR_WHITE")
	if TableIncludeValue_CSBV(cityStateColorMatch_List, cityStateType) then
		--print("include")
		local colors = cityStateColorMatch_Map[cityStateType]
		--print("color_0=\t", colors[1])
		primaryColor = UI.GetColorValue("COLOR_PLAYER_CITY_STATE_PRIMARY")
		secondaryColor = UI.GetColorValue(colors[1]/255, colors[2]/255, colors[3]/255, colors[4]/255) or UI.GetColorValue("COLOR_WHITE")

		--print("secondaryColor=\t", secondaryColor)
		--print("primaryColor=\t", primaryColor)
	end

	local cityStateData :table	= {
		CivType = row.CivilizationType,
		Name = cs_name,
		LeaderType = leaderType,
		CityStateType = cityStateType,
		BonusText = bonusText,
		PrimaryColor = primaryColor,
		SecondaryColor = secondaryColor,
	};
	if leaderType ~= "ML_CS_LEADER_ERROR" and cityStateType ~= "ML_CS_TYPE_ERROR" then
		return cityStateData, true
	else
		return {}, false
	end
end

function GetCityStateData_FromMinorPlayer(iPlayer)
	local pPlayer = Players[iPlayer]

	local pPlayerInfluence			:table	= pPlayer:GetInfluence();		
	if pPlayerInfluence == nil then
		return {}, false
	end
	local isCanReceiveInfluence		= pPlayerInfluence:CanReceiveInfluence();

	--print("0041")
	if not isCanReceiveInfluence then
		return {}, false
	end
	local details = GetSuzerainBonusText( iPlayer );

	local pPlayerConfig:table = PlayerConfigurations[iPlayer];
	local p_CivType = pPlayerConfig:GetCivilizationTypeName()
	local p_LeaderType = pPlayerConfig:GetLeaderTypeName()
	local p_Name = pPlayerConfig:GetCivilizationShortDescription()
	local primaryColor, secondaryColor = UI.GetPlayerColors( iPlayer );	

	local cityStateType = "ML_CS_TYPE_ERROR"
	for kRow in GameInfo.TypeProperties() do
		if kRow.Name == "CityStateCategory" and kRow.Type == p_CivType then
			cityStateType = kRow.Value
			--print("cityStateType=\t", cityStateType)
		end
	end

	--相比于数据库，需要额外搞一个首都
	local pCapital = pPlayer:GetCities():GetCapitalCity()
	local kX = -9999
	local kY = -9999
	if pCapital ~= nil then
		kX = pCapital:GetX()
		kY = pCapital:GetY()
	end

	local cityStateData :table	= {
		CivType = p_CivType,
		Name = p_Name,
		LeaderType = p_LeaderType,
		CityStateType = cityStateType,
		BonusText = details,
		PrimaryColor = primaryColor,
		SecondaryColor = secondaryColor,
		CapitalX = kX,
		CapitalY = kY,
	};

	--local citystate_Inst:table = m_pSelectBeliefsIM:GetInstance();
	--citystate_Inst[DATA_FIELD_BELIEF_INDEX] = 0;
	--citystate_Inst.BeliefLabel:LocalizeAndSetText(Locale.ToUpper(p_Name));
	--citystate_Inst.BeliefDescription:SetText(details);
--
	----print("0042")
	--SetCityStateIcon(citystate_Inst.BeliefIconButton, citystate_Inst.BeliefIcon, primaryColor, secondaryColor, p_CivType, SIZE_CIVILIZATION_ICON_44);
--
	----print("0043")
	--citystate_Inst.BeliefButton:SetSelected(citystate_Inst == m_uiSelectedBeliefInstance);
	--citystate_Inst.BeliefButton:RegisterCallback( Mouse.eLClick, function() OnCityStateSelected(citystate_Inst); end );
	--citystate_Inst.BeliefButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end );
	
	return cityStateData, true
end

function Populate_CityStateInst_FromDatabase(cityStateData)
	local citystate_Inst:table = m_pSelectBeliefsIM:GetInstance();
	citystate_Inst[DATA_FIELD_BELIEF_INDEX] = 0;
	citystate_Inst.BeliefLabel:LocalizeAndSetText(Locale.ToUpper(cityStateData.Name));
	citystate_Inst.BeliefDescription:SetText(cityStateData.BonusText);

	--print("0042")

	SetCityStateIcon(citystate_Inst.BeliefIconButton, citystate_Inst.BeliefIcon, 
		cityStateData.PrimaryColor, cityStateData.SecondaryColor, 
		cityStateData.CivType, SIZE_CIVILIZATION_ICON_44
	);

	--print("0043")
	citystate_Inst.BeliefButton:SetSelected(citystate_Inst == m_uiSelectedBeliefInstance);
	citystate_Inst.BeliefButton:RegisterCallback( Mouse.eLClick, function() OnCityStateSelected(citystate_Inst, cityStateData.CapitalX, cityStateData.CapitalY); end );
	--右键打开百科
	citystate_Inst.BeliefButton:RegisterCallback( Mouse.eRClick, 
										function() 
												LuaEvents.OpenCivilopedia(cityStateData.CivType); 
												UI.PlaySound("Civilopedia_Open");
										end 
	);
	
	citystate_Inst.BeliefButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end );

end

-- ===========================================================================
function GetSuzerainBonusText( playerID:number )
	
	local leader	:string = PlayerConfigurations[playerID]:GetLeaderTypeName();
	local leaderInfo:table	= GameInfo.Leaders[leader];
	if leaderInfo == nil then
		UI.DataError("GetSuzerainBonusText, cannot determine the type of city state suzerain bonus for player #: "..tostring(playerID) );
		return "UNKNOWN";
	end

	local name = PlayerConfigurations[playerID]:GetCivilizationShortDescription();
	local text		:string = GetSuzerainBonusText_FromLeaderType( leader, name )
	
	--local comma_separator = Locale.Lookup("LOC_GRAMMAR_COMMA_SEPARATOR");

	return text;
end

function GetSuzerainBonusText_FromLeaderType( leader, name )
	local text		:string = "";
	
	-- Unique Bonus
	for leaderTraitPairInfo in GameInfo.LeaderTraits() do
		if (leader ~= nil and leader == leaderTraitPairInfo.LeaderType) then
			local traitInfo : table = GameInfo.Traits[leaderTraitPairInfo.TraitType];
			if (traitInfo ~= nil) then
				
				text = text .. "[COLOR:Science]" .. Locale.Lookup("LOC_CITY_STATES_SUZERAIN_UNIQUE_BONUS", name) .. "[ENDCOLOR] ";
				if traitInfo.Description ~= nil then
					
					local traitDesc = Locale.Lookup(traitInfo.Description)
					--local startIndex, endIndex = string.find(traitDesc, "[NEWLINE][NEWLINE]")
					--if startIndex ~= nil then
						--print("startIndex=\t", startIndex)
						--print("endIndex=\t", endIndex)
						--print("traitDesc[startIndex]=\t", traitDesc[startIndex])
						--print("traitDesc[endIndex]=\t", traitDesc[endIndex])
						--local part_1 = string.sub(traitDesc, 1, startIndex-1)
						--local part_2 = string.sub(traitDesc, endIndex)
						--print("part_1=\t", part_1)
						--print("part_2=\t", part_2)
						--traitDesc = part_1..part_2
					--end

					text = text .. traitDesc

				end
			end
		end
	end	

	return text;
end

-- ===========================================================================
function TableIncludeValue_CSBV(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then
			return true
		end
	end
	return false
end
-- ===========================================================================

-- ===========================================================================

function Populate_ViewModeSlider()
	--初始化查看模式滑块
	Controls.CityStateBonus_ViewMode_Slider:RegisterSliderCallback(function()
        On_UpdateViewModeSlider()
    end)
	Controls.CityStateBonus_ViewMode_Slider:SetEnabled(true)
    Controls.CityStateBonus_ViewMode_Slider:SetHide(false)
    Controls.CityStateBonus_ViewMode_Slider:SetNumSteps(cityStateBonusViewModeNum)
    Controls.CityStateBonus_ViewMode_Slider:SetStep(currrentViewMode)
end
------------ 用户拖动滑块 ------------
function On_UpdateViewModeSlider()
    local stepNum = Controls.CityStateBonus_ViewMode_Slider:GetStep() 

	--print("now stepnum=\t", stepNum)

	currrentViewMode = stepNum

	local modeText;

	if currrentViewMode == 0 then
		modeText = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_VIEWMODE_ALL")
	elseif currrentViewMode == 1 then
		modeText = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_VIEWMODE_HASMET")
	end	

    Controls.CityStateBonus_ViewMode_Mode_Label:SetText( modeText );

	--刷新
	Populate_CityStateList()
end

-- ===========================================================================

function Populate_SortModeSlider()
	--初始化排序模式滑块
	Controls.CityStateBonus_SortMode_Slider:RegisterSliderCallback(function()
        On_UpdateSortModeSlider()
    end)
	Controls.CityStateBonus_SortMode_Slider:SetEnabled(true)
    Controls.CityStateBonus_SortMode_Slider:SetHide(false)
    Controls.CityStateBonus_SortMode_Slider:SetNumSteps(cityStateBonusSortModeNum)
    Controls.CityStateBonus_SortMode_Slider:SetStep(currrentSortMode)
end
------------ 用户拖动滑块 ------------
function On_UpdateSortModeSlider()
    local stepNum = Controls.CityStateBonus_SortMode_Slider:GetStep() 

	--print("now stepnum=\t", stepNum)

	currrentSortMode = stepNum

	local modeText;

	if currrentSortMode == 0 then
		modeText = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_SORTMODE_BY_NAME")
	elseif currrentSortMode == 1 then
		modeText = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_SORTMODE_BY_TYPE")
	end	

    Controls.CityStateBonus_SortMode_Mode_Label:SetText( modeText );

	--刷新
	Populate_CityStateList()
end

-- ===========================================================================

function Populate_FilterPulldown(cityStateData_list)

	local uiButton:object = Controls.CityStateBonus_Filter_PullDown:GetButton();

	if currentFilterMode == "ML_CS_ALL" then
		uiButton:SetText(Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_FILTER_TYPE_ALL"));
	else
		local item_text = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_FILTER_TYPE_".. currentFilterMode)
	end

	Controls.CityStateBonus_Filter_PullDown:ClearEntries();

	cityStateTypes_List = {}
	for key, value in ipairs(cityStateData_list) do
		if not TableIncludeValue_CSBV(cityStateTypes_List, value.CityStateType) then
			table.insert(cityStateTypes_List, value.CityStateType)
		end
	end

	--所有
	local pEntryInst:object = {};
	Controls.CityStateBonus_Filter_PullDown:BuildEntry( "InstanceOne", pEntryInst );
	local item_text = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_FILTER_TYPE_ALL")
	pEntryInst.Button:SetText(item_text);
	pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
		function() 
			Controls.CityStateBonus_Filter_PullDown:GetButton():SetText(item_text);
			currentFilterMode = "ML_CS_ALL"
			Populate_CityStateList()
		end 
	);

	for key, value in ipairs(cityStateTypes_List) do
		local pEntryInst:object = {};
		Controls.CityStateBonus_Filter_PullDown:BuildEntry( "InstanceOne", pEntryInst );

		local item_text = Locale.Lookup("LOC_MAPLE_CITY_STATE_BONUS_VIEWER_FILTER_TYPE_".. value)

		pEntryInst.Button:SetText(item_text);
		pEntryInst.Button:RegisterCallback( Mouse.eLClick, 
			function() 
				Controls.CityStateBonus_Filter_PullDown:GetButton():SetText(item_text);
				currentFilterMode = value
				Populate_CityStateList()
			end 
		);
	end

	Controls.CityStateBonus_Filter_PullDown:CalculateInternals();

end

-- ===========================================================================

function AddCheatPoint()
	local kParameters:table = {};
	kParameters.OnStart = "AddNFDCount";
	kParameters.Count = 5;

	UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)

	Close()
end
-- ===========================================================================
function SetCityStateIcon(primaryControl:table, secondaryControl:table, primaryColor, secondaryColor, CivType:string, iconSize:number)
	--local textureOffsetX=0
	--local textureOffsetY=0
	--local textureSheet=""
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas("ICON_" .. CivType, iconSize);

	if(textureSheet == nil or textureSheet == "") then
		print("set icon error for\t", CivType)
	else    
		secondaryControl:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		secondaryControl:SetSizeVal(iconSize, iconSize); 
		secondaryControl:SetColor( secondaryColor );
	end

	primaryControl:SetColor( primaryColor );
end

-- ===========================================================================
function OnCityStateSelected( instance:table, iX , iY)
	-- Ignore select if this citystate_ is already selected
	--if m_uiSelectedBeliefInstance == instance then
		--return;
	--end
	--
	--SetSelectedBeliefInstance(instance);

	--如果是在遇见城邦模式，则点击左键代表前往首都
	if currrentViewMode == 1 then
		local capitalPlot = Map.GetPlot(iX , iY)
		if capitalPlot ~= nil then
			UI.LookAtPlot(iX , iY);
		end

		--打开城邦面板
		LuaEvents.PartialScreenHooks_CloseAllExcept("CityStates");
		LuaEvents.PartialScreenHooks_OpenCityStates()
		UI.PlaySound("CityStates_Panel_Open");
	end

end

-- ===========================================================================
function SetSelectedBeliefInstance( instance:table )
	-- Unselect the previous selection
	if m_uiSelectedBeliefInstance ~= nil then
		m_uiSelectedBeliefInstance.BeliefButton:SetSelected(false);
	end

	-- Select new citystate_ instance
	m_uiSelectedBeliefInstance = instance;
	m_uiSelectedBeliefInstance.BeliefButton:SetSelected(true);

	--RealizeCurrentSelection();
end

-- ===========================================================================
function ClearBeliefSelection()
	if m_uiSelectedBeliefInstance ~= nil then
		m_uiSelectedBeliefInstance.BeliefButton:SetSelected(false);
		m_uiSelectedBeliefInstance = nil;
	end

	--RealizeCurrentSelection();
end

-- ===========================================================================
function ConfirmTrait()
	if m_uiSelectedBeliefInstance ~= nil then
		local traitIndex:number = m_uiSelectedBeliefInstance[DATA_FIELD_BELIEF_INDEX];

		local kTraitDef = GameInfo.Mod_CityStateViewer_Traits[traitIndex]

		local kParameters:table = {};
		kParameters.OnStart = "AttachNFDTrait";
		kParameters.TraitType = kTraitDef.TraitType;

		UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)

		if canChooseTraitsNum == 1 then
			--????????????????????
			local kParameters:table = {};
			kParameters.OnStart = "AttachDiploVictoryPoints";

			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, kParameters)
		end

		UI.PlaySound("Confirm_Religion");

		LuaEvents.CityStateViewer_Panel_TraitConfirmed(Game.GetLocalPlayer(), kTraitDef.TraitType);

		Close();

		--LuaEvents.PantheonChooser_OpenReligionPanel();
	end
end

-- ===========================================================================

function OnCityLiberated()
	if not ContextPtr:IsHidden() then
		local localPlayerID = Game.GetLocalPlayer();
		if (localPlayerID == -1) then
			return;
		end
		Populate_CityStateList()
	end
end


function OnCityAddedToMap()
	if not ContextPtr:IsHidden() then
		local localPlayerID = Game.GetLocalPlayer();
		if (localPlayerID == -1) then
			return;
		end
		Populate_CityStateList()
	end
end

-- ===========================================================================
function Close()
	--print("close  001")
	if not ContextPtr:IsHidden() and not Controls.PantheonChooserSlideAnim:IsReversing() then
		Controls.PantheonChooserSlideAnim:SetToEnd();
        Controls.PantheonChooserSlideAnim:Reverse();

		--print("close  002")

		UI.PlaySound("Tech_Tray_Slide_Closed");

        LuaEvents.CityStateViewer_Panel_Closed();
		--print("close  003")
	end
end

-- ===========================================================================
function Open()
	--print("001")
	if ContextPtr:IsHidden() then
		ContextPtr:SetHide(false);
        m_uiSelectedBeliefInstance = nil;

        --LuaEvents.PantheonChooser_OpenReligion();

		--print("003")

		-- Play Open Animation
		Controls.PantheonChooserSlideAnim:SetToBeginning();
		Controls.PantheonChooserSlideAnim:Play();

		UI.PlaySound("Tech_Tray_Slide_Open");

		--print("002")
		Realize();

		--print("099")
	end
end

-- ===========================================================================
-- Context Event
-- ===========================================================================
function OnInit( isReload:boolean )
	LateInitialize();

	if isReload and not ContextPtr:IsHidden() then
		Realize();
	end
end

-- ===========================================================================
-- Context Event
-- ===========================================================================
function OnInputHandler( pInputStruct:table )
	if pInputStruct:GetMessageType() == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then 
		Close();
		return true;
	end
	return false;
end

-- ===========================================================================
-- Context Event
-- ===========================================================================
function OnShutdown()
	--LuaEvents.NotificationPanel_OpenPantheonChooser.Remove( Open );
	--LuaEvents.LaunchBar_OpenPantheonChooser.Remove( Open );
	--LuaEvents.LaunchBar_ClosePantheonChooser.Remove( Close );
	local takeplace = 0
end

-- ===========================================================================
function OnAnimEnd()
	if Controls.PantheonChooserSlideAnim:IsReversing() then
		-- If we're reversing due to closing the panel then hide the context after that anim ends
		ContextPtr:SetHide(true);
	end
end

-- ===========================================================================
function LateInitialize()
	--LuaEvents.NotificationPanel_OpenPantheonChooser.Add( Open );
	--LuaEvents.LaunchBar_OpenPantheonChooser.Add( Open );
	--LuaEvents.LaunchBar_ClosePantheonChooser.Add( Close );

	--一些刷新的函数
	Events.CityLiberated.Add( OnCityLiberated );
	Events.CityAddedToMap.Add( OnCityAddedToMap );

	LuaEvents.CityStateViewer_Button_TogglePopup.Add(Open);
	
	LuaEvents.DiplomacyActionView_HideIngameUI.Add(Close)
    LuaEvents.EndGameMenu_Shown.Add(Close)
    LuaEvents.FullscreenMap_Shown.Add(Close)
    LuaEvents.NaturalWonderPopup_Shown.Add(Close)
    LuaEvents.ProjectBuiltPopup_Shown.Add(Close)
    LuaEvents.Tutorial_ToggleInGameOptionsMenu.Add(Close)
    LuaEvents.WonderBuiltPopup_Shown.Add(Close)
    LuaEvents.NaturalDisasterPopup_Shown.Add(Close)  
    LuaEvents.RockBandMoviePopup_Shown.Add(Close)
	LuaEvents.CivicsTree_OpenCivicsTree.Add(Close);	
	LuaEvents.Government_OpenGovernment.Add(Close);
	LuaEvents.GovernorPanel_Opened.Add(Close);	
	LuaEvents.GreatPeople_OpenGreatPeople.Add(Close);
	LuaEvents.GreatWorks_OpenGreatWorks.Add(Close);
	LuaEvents.HistoricMoments_Opened.Add(Close);
	LuaEvents.Religion_OpenReligion.Add(Close);	
	LuaEvents.PantheonChooser_OpenReligion.Add(Close);	
	LuaEvents.TechTree_OpenTechTree.Add(Close);
	LuaEvents.ClimateScreen_Opened.Add(Close);

	Controls.Header_CloseButton:RegisterCallback( Mouse.eLClick, Close );

	--Controls.ConfirmTraitButton:RegisterCallback( Mouse.eLClick, ConfirmTrait );
	--Controls.ConfirmTraitButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); 
	--Controls.CancelButton:RegisterCallback( Mouse.eLClick, ClearBeliefSelection );
	--Controls.CancelButton:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end); 

	Controls.PantheonChooserSlideAnim:RegisterEndCallback( OnAnimEnd );
end

-- ===========================================================================
function Initialize()
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
	ContextPtr:SetInputHandler( OnInputHandler, true );
end
Initialize();

print("City State Viewer Panel Initialized!")