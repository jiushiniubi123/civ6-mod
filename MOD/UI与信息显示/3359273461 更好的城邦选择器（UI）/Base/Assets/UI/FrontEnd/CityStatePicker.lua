-- CityStatePicker
-- Author: Maple_Leaves
-- DateCreated: 10/23/2024 11:23:40 PM
--------------------------------------------------------------

include("InstanceManager");
include("PlayerSetupLogic");
include("Civ6Common");

-- ===========================================================================
-- CONSTANTS
-- ===========================================================================

local XP2_RULESETUP:string = "RULESET_EXPANSION_2";
local XP1_RULESETUP:string = "RULESET_EXPANSION_1";

-- ===========================================================================
-- Members
-- ===========================================================================

local m_pItemIM:table = InstanceManager:new("ItemInstance",	"Button", Controls.ItemsPanel);

local m_kParameter:table = nil		-- Reference to the parameter being used. 
local m_kSelectedValues:table = nil	-- Table of string->boolean that represents checked off items.
local m_kItemList:table = nil;		-- Table of controls for select all/none

local m_bInvertSelection:boolean = false;

local m_kCityStateDataCache:table = {};
local m_kBannedCityStates:table = {};	-- Table of civType->boolean for banned city states

local m_kCityStateCountParam:table = nil;

local m_RulesetType:string = "";

local m_numSelected:number = 0;

-- Track the number of city-states to spawn when opening the picker
-- Used to revert to that number in case the user modifies the parameter then backs out of the picker
local m_OriginalCityStateCount:number = 0;

-- ===========================================================================
local m_cityStatesMaxNum = 10;
local m_CityStateTotalNum = 10;
local m_cityStatesMinNum = 0;

local m_firstTimeOpenCityStatePicker = true;

--数据库中的城邦
local m_Industrial_CityStates		= {};
local m_Militaristic_CityStates		= {};
local m_Scientific_CityStates		= {};
local m_Trade_CityStates			= {};
local m_Cultural_CityStates			= {};
local m_Religious_CityStates		= {};
local m_Agrarian_CityStates			= {};
local m_Entertainment_CityStates	= {};
local m_Maritime_CityStates			= {};
local m_Consular_CityStates			= {};

--数据库中的城邦数量
local m_Industrial_Num_InConfig		= 0;
local m_Militaristic_Num_InConfig	= 0;
local m_Scientific_Num_InConfig		= 0;
local m_Trade_Num_InConfig			= 0;
local m_Cultural_Num_InConfig		= 0;
local m_Religious_Num_InConfig		= 0;
local m_Agrarian_Num_InConfig		= 0;
local m_Entertainment_Num_InConfig	= 0;
local m_Maritime_Num_InConfig		= 0;
local m_Consular_Num_InConfig		= 0;

--每种类型的城邦数量
local m_Industrial_Num				= 0;
local m_Militaristic_Num			= 0;
local m_Scientific_Num				= 0;
local m_Trade_Num					= 0;
local m_Cultural_Num				= 0;
local m_Religious_Num				= 0;
local m_Agrarian_Num				= 0;
local m_Entertainment_Num			= 0;
local m_Maritime_Num				= 0;
local m_Consular_Num				= 0;

--选中的每种类型的城邦数量
local m_selected_Industrial_Num =  0;
local m_selected_Militaristic_Num =  0;
local m_selected_Scientific_Num = 0;
local m_selected_Trade_Num =  0;
local m_selected_Cultural_Num = 0;
local m_selected_Religious_Num =  0;

local m_UseSelectedCityStates = false;
-- ===========================================================================
--[[
思路：
城邦的选择，本质是让你选择哪个城邦不选，并且可用的城邦数大于游戏中城邦总数即可


我们要引入新机制，也就是可以单独控制每类城邦有几个，这样势必不能再去调节城邦总数了
能否禁用滑块的滑动功能？还真可以
Controls._Slider:SetEnabled(false)

城邦数量参数，应该是有一个最小值，最大值，以及默认值（一般是和地图大小有关，但是我不确定对于.Civ6Map会发生什么）
当我们创建新游戏的时候，先获取城邦数量范围，然后除一下城邦类型总数
一般来说，城邦类型只有工军科贸文宗，加上农业，领事，娱乐，航海，6+4=10种
特别地，领事城邦需要至少xp1
设置一下每种slider的起始值


注意，丝路未央城邦包的config写的很混乱
]]
-- ===========================================================================
function Close()	
	-- Clear any temporary global variables.
	m_kParameter = nil;
	m_kSelectedValues = nil;

	ContextPtr:SetHide(true);
end

-- ===========================================================================
function IsItemSelected(item: table) 
	return m_kSelectedValues[item.Value] == true;
end

-- ===========================================================================
function OnBackButton()
	Close();
	if m_UseSelectedCityStates then
		LuaEvents.CityStatePicker_SetParameterValue(m_kCityStateCountParam.ParameterId, m_OriginalCityStateCount);
	else
		LuaEvents.CityStatePicker_SetParameterValue(m_kCityStateCountParam.ParameterId, m_CityStateTotalNum);
	end
end

-- ===========================================================================
function OnConfirmChanges()
	
	local values = {}

	if m_UseSelectedCityStates then
		--如果使用选定的城邦，则逻辑不变
		--print("=====================================")

		-- Generate sorted list from selected values.
		
		for k,v in pairs(m_kSelectedValues) do
			if(v) then
				table.insert(values, k);
				--print("k=\t", k)
				--print("v=\t", v)
			end
		end
	else
		--如果使用指定数量的随机城邦，则新写逻辑
		--print("=====================================")
		--print("situation 2")

		local citystates_in_config_list = {}
		local cityState_CsTypeMap = {}

		for i, v in ipairs(m_kParameter.Values) do
			local civType = v.Value

			if not IsCityStateBanned(civType) then
				table.insert(citystates_in_config_list, civType);
				--print("i=\t", i)
				--print("v=\t", v)

				--从城邦名获取城邦类型
				local csType = GetCSTypeFromCivType(civType)
				cityState_CsTypeMap[civType] = csType;
			end

		end

		--随机排序
		RandSort_CityStatePicker(citystates_in_config_list)

		local m_Industrial_Num_InUse	= 0;
		local m_Militaristic_Num_InUse	= 0;
		local m_Scientific_Num_InUse	= 0;
		local m_Trade_Num_InUse			= 0;
		local m_Cultural_Num_InUse		= 0;
		local m_Religious_Num_InUse		= 0;
		local m_Agrarian_Num_InUse		= 0;
		local m_Entertainment_Num_InUse	= 0;
		local m_Maritime_Num_InUse		= 0;
		local m_Consular_Num_InUse		= 0;

		--随机抽取一定数量的城邦

		--需要注意，这里需要全部反转一次
		local inverse_values = {}
		--print("=====================================")
		for k, v in ipairs(citystates_in_config_list) do
			--print("k=\t", k)
			--print(v)

			if cityState_CsTypeMap[v] == "INDUSTRIAL" and m_Industrial_Num_InUse < m_Industrial_Num then
				m_Industrial_Num_InUse = m_Industrial_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "MILITARISTIC" and m_Militaristic_Num_InUse < m_Militaristic_Num then
				m_Militaristic_Num_InUse = m_Militaristic_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "SCIENTIFIC" and m_Scientific_Num_InUse < m_Scientific_Num then
				m_Scientific_Num_InUse = m_Scientific_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "TRADE" and m_Trade_Num_InUse < m_Trade_Num then
				m_Trade_Num_InUse = m_Trade_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "CULTURAL" and m_Cultural_Num_InUse < m_Cultural_Num then
				m_Cultural_Num_InUse = m_Cultural_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "RELIGIOUS" and m_Religious_Num_InUse < m_Religious_Num then
				m_Religious_Num_InUse = m_Religious_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "CSE_AGRICULTURAL" and m_Agrarian_Num_InUse < m_Agrarian_Num then
				m_Agrarian_Num_InUse = m_Agrarian_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "CSE_ENTERTAINMENT" and m_Entertainment_Num_InUse < m_Entertainment_Num then
				m_Entertainment_Num_InUse = m_Entertainment_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "CSE_MARITIME" and m_Maritime_Num_InUse < m_Maritime_Num then
				m_Maritime_Num_InUse = m_Maritime_Num_InUse + 1
				table.insert(inverse_values, v);

			elseif cityState_CsTypeMap[v] == "CSE_CONSULAR" and m_Consular_Num_InUse < m_Consular_Num then
				m_Consular_Num_InUse = m_Consular_Num_InUse + 1
				table.insert(inverse_values, v);

			end

		end
		--print("=====================================")

		--最后进行反选
		for i, v in ipairs(m_kParameter.Values) do
			local civType = v.Value
			if not TableIncludeValue_CityStatePicker(inverse_values, civType) then
				table.insert(values, civType);
				--print("civType=\t", civType)
			end

		end
		
	end

	LuaEvents.CityStatePicker_SetParameterValues(m_kParameter.ParameterId, values);
	Close();
end

function GetCSTypeFromCivType(civType)
	local kCityStateData:table = GetCityStateData(civType);

	return kCityStateData.CityStateCategory
end

-- ===========================================================================
-- Ban Functions
-- ===========================================================================
function IsCityStateBanned(civType)
	return m_kBannedCityStates[civType] == true;
end

function ToggleBanCityState(item :table, banCheckBox :table)
	local civType = item.Value;
	m_kBannedCityStates[civType] = not m_kBannedCityStates[civType];
	banCheckBox:SetCheck(m_kBannedCityStates[civType]);
end

function OnClearAllBans()
	m_kBannedCityStates = {};
	-- Update all visual indicators
	for _, node in ipairs(m_kItemList) do
		if node["bancheckbox"] then
			node["bancheckbox"]:SetCheck(false);
		end
	end
end

-- ===========================================================================
function RandSort_CityStatePicker(ttable)
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)))
	table.sort(ttable,function (a,b)
	  return math.random(1,10) < 5
	end)
end

function TableIncludeValue_CityStatePicker(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then
			return true
		end
	end
	return false
end

-- ===========================================================================
function OnItemSelect(item :table, checkBox :table)
	local value = item.Value;
	local selected:boolean = not m_kSelectedValues[value];

	m_kSelectedValues[item.Value] = selected;
	if m_bInvertSelection then
		checkBox:SetCheck(not selected);
	else
		checkBox:SetCheck(selected);
	end

	RefreshCountWarning();
end

-- ===========================================================================
function OnItemFocus(item :table)
	if(item) then
		Controls.FocusedItemName:SetText(item.Name);

		local backColor:number, frontColor:number = UI.GetPlayerColorValues(item.Value, 0);
		local kCityStateData:table = GetCityStateData(item.Value);

		local description:string = Locale.ToUpper("LOC_CITY_STATES_SUZERAIN_BONUSES");

        if kCityStateData ~= nil then
            if kCityStateData.Bonus_XP2 ~= nil and m_RulesetType == XP2_RULESETUP and IsExpansion2Enabled() then
                description = description .. "[NEWLINE]" .. Locale.Lookup(kCityStateData.Bonus_XP2);
            elseif kCityStateData.Bonus_XP1 ~= nil and (m_RulesetType == XP1_RULESETUP or m_RulesetType == XP2_RULESETUP) and IsExpansion1Enabled() then
                description = description .. "[NEWLINE]" .. Locale.Lookup(kCityStateData.Bonus_XP1);
            elseif kCityStateData ~= nil then
                description = description .. "[NEWLINE]" .. Locale.Lookup(kCityStateData.Bonus);
            end
        end

		Controls.FocusedItemDescription:LocalizeAndSetText(description);

		-- Icon
		Controls.FocusedItemIcon:SetIcon(item.Icon);
		Controls.FocusedItemIcon:SetHide(false);
		Controls.FocusedItemIcon:SetColor(frontColor);
	end
end

-- ===========================================================================
function GetCityStateData( civType:string )
	-- Refresh the cache if needed
	if m_kCityStateDataCache[civType] == nil then

		m_kCityStateDataCache[civType] = {};

		local query:string = "SELECT CityStateCategory, Bonus, Bonus_XP1, Bonus_XP2 from CityStates where CivilizationType = ?";
		local kResults:table = DB.ConfigurationQuery(query, civType);
		if(kResults) then
			for i,v in ipairs(kResults) do
				for name, value in pairs(v) do
					m_kCityStateDataCache[civType][name] = value;
				end
			end
		end
	end

	return m_kCityStateDataCache[civType];
end

-- ===========================================================================
function SetAllItems(bState: boolean)
	for _, node in ipairs(m_kItemList) do
		local item:table = node["item"];
		local checkBox:table = node["checkbox"];

		checkBox:SetCheck(bState);
		if m_bInvertSelection then
			m_kSelectedValues[item.Value] = not bState;
		else
			m_kSelectedValues[item.Value] = bState;
		end
	end
end

-- ===========================================================================
function OnSelectAll()
	SetAllItems(true);
	RefreshCountWarning();
end

-- ===========================================================================
function OnSelectNone()
	SetAllItems(false);
	RefreshCountWarning();
end

-- ===========================================================================
function OnSelectVanilla()
	
	for _, node in ipairs(m_kItemList) do
		local item:table = node["item"];
		local checkBox:table = node["checkbox"];

		local bState = IsFiraxisCityState(item.Value)

		checkBox:SetCheck(bState);
		if m_bInvertSelection then
			m_kSelectedValues[item.Value] = not bState;
		else
			m_kSelectedValues[item.Value] = bState;
		end
	end

	RefreshCountWarning();
end

function OnSelectMod()
	for _, node in ipairs(m_kItemList) do
		local item:table = node["item"];
		local checkBox:table = node["checkbox"];

		local bState = not IsFiraxisCityState(item.Value)

		checkBox:SetCheck(bState);
		if m_bInvertSelection then
			m_kSelectedValues[item.Value] = not bState;
		else
			m_kSelectedValues[item.Value] = bState;
		end
	end

	RefreshCountWarning();
end

function IsFiraxisCityState(civType)
	local cityStates :table = DB.ConfigurationQuery("SELECT * from BCSP_FiraxisCityStates");

	if cityStates == nil or #cityStates == 0 then
		--如果新建的表不存在，则总是为真
		return true
	end

	for i=1, #cityStates do
		local cityState = cityStates[i]

		if civType == cityState.CivilizationType then
			return true
		end
	end

	return false
end

-- ===========================================================================
function ParameterInitialize(parameter : table, pGameParameters:table)
	--print(000)
	m_kParameter = parameter;
	m_kSelectedValues = {};

	m_kCityStateCountParam = pGameParameters.Parameters["CityStateCount"];
	m_OriginalCityStateCount = m_kCityStateCountParam.Value;

	local kRulesetParam = pGameParameters.Parameters["Ruleset"];
	m_RulesetType = kRulesetParam.Value.Value;

	if (parameter.UxHint ~= nil and parameter.UxHint == "InvertSelection") then
		m_bInvertSelection = true;
	else
		m_bInvertSelection = false;
	end

	if(parameter.Value) then
		for i,v in ipairs(parameter.Value) do
			m_kSelectedValues[v.Value] = true;
		end
	end

	Controls.TopDescription:SetText(parameter.Description);
	Controls.WindowTitle:SetText(parameter.Name);
	m_pItemIM:ResetInstances();

	RefreshList();	
	--print(001)

	InitCityStateCountSlider(pGameParameters);

	InitCityStateTypeCountSlider(pGameParameters);

	--print(002)
	InitUseSelectedCSCheck(pGameParameters);
	--print(003)

	InitSortByFilter();

	OnItemFocus(parameter.Values[1]);
	--print(004)
	RefreshCountWarning();

	m_firstTimeOpenCityStatePicker = false;

	Controls.SelectAllButton:SetDisabled(true);
	Controls.SelectNoneButton:SetDisabled(true);
	Controls.SelectVanillaButton:SetDisabled(true);
	Controls.SelectModButton:SetDisabled(true);

	--显示禁用checkbox，隐藏选中checkbox
	for _, node in ipairs(m_kItemList) do
		if node["bancheckbox"] then
			node["bancheckbox"]:SetCheck(false);
			node["bancheckbox"]:SetHide(false);
		end
		if node["checkbox"] then
			node["checkbox"]:SetHide(true);
		end
	end
end

-- ===========================================================================
function RefreshList( sortByFunc )

	m_numSelected = 0;
	m_kItemList = {};

	-- Sort list
	table.sort(m_kParameter.Values, sortByFunc ~= nil and sortByFunc or SortByName);

	-- Update UI
	m_pItemIM:ResetInstances();
	for i, v in ipairs(m_kParameter.Values) do
		InitializeItem(v);
	end
end

-- ===========================================================================
function RefreshCountWarning()
	if m_kParameter ~= nil then

		--检查当前模式，
		if m_UseSelectedCityStates then
			--如果使用选中的城邦，则验证选中的城邦数量是否大于等于城邦总数
			--此时逻辑不变

			local numSelected:number = 0;

			for i, v in ipairs(m_kParameter.Values) do
				if not IsItemSelected(v) then
					numSelected = numSelected + 1;
				end
			end

			if numSelected < m_kCityStateCountParam.Value then
				Controls.ConfirmButton:SetDisabled(true);
				Controls.CountWarning:SetText(Locale.ToUpper(Locale.Lookup("LOC_CITY_STATE_PICKER_COUNT_WARNING", m_kCityStateCountParam.Value, m_kCityStateCountParam.Value - numSelected)));
				return
			end

			--local num_matches = true
			--local tooltip = Locale.ToUpper(Locale.Lookup("LOC_CITY_STATE_PICKER_COUNT_WARNING_SELECTED_CS_NOT_MATCH"));
--
			--m_selected_Industrial_Num = GetSelectedNum_ForCertainCSType("INDUSTRIAL")
			--m_selected_Militaristic_Num = GetSelectedNum_ForCertainCSType("MILITARISTIC")
			--m_selected_Scientific_Num = GetSelectedNum_ForCertainCSType("SCIENTIFIC")
			--m_selected_Trade_Num = GetSelectedNum_ForCertainCSType("TRADE")
			--m_selected_Cultural_Num = GetSelectedNum_ForCertainCSType("CULTURAL")
			--m_selected_Religious_Num = GetSelectedNum_ForCertainCSType("RELIGIOUS")
--
			--if m_Industrial_Num ~= m_selected_Industrial_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_INDUSTRIAL_NAME") .. ","
			--end
			----print("m_selected_Militaristic_Num=\t", m_selected_Militaristic_Num)
			----print("m_Militaristic_Num=\t", m_Militaristic_Num)
			--if m_Militaristic_Num ~= m_selected_Militaristic_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_MILITARISTIC_NAME") .. ","
			--end
			--if m_Scientific_Num ~= m_selected_Scientific_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_SCIENTIFIC_NAME") .. ","
			--end
			--if m_Trade_Num ~= m_selected_Trade_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_TRADE_NAME") .. ","
			--end
			--if m_Cultural_Num ~= m_selected_Cultural_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_CULTURAL_NAME") .. ","
			--end
			--if m_Religious_Num ~= m_selected_Religious_Num then
				--num_matches = false
				--tooltip = tooltip .. Locale.Lookup("LOC_CITYSTATE_PICKER_RELIGIOUS_NAME") .. ","
			--end
--
			--if not num_matches then
				--Controls.ConfirmButton:SetDisabled(true);
				--Controls.CountWarning:SetText(tooltip);
				--return
			--end

		else
			--如果不使用选中的城邦，则检查城邦总数是否超出上限
			if m_CityStateTotalNum > m_cityStatesMaxNum then
				Controls.ConfirmButton:SetDisabled(true);
				Controls.CountWarning:SetText(Locale.ToUpper(Locale.Lookup("LOC_CITY_STATE_PICKER_COUNT_WARNING_TOO_MANY_NUM", m_CityStateTotalNum, m_cityStatesMaxNum, m_CityStateTotalNum-m_cityStatesMaxNum)));
				return
			end
		end

		Controls.ConfirmButton:SetDisabled(false);
		Controls.CountWarning:SetText("");

	end
end

function GetSelectedNum_ForCertainCSType(csType)
	local cityStateNum = 0;
	for i, v in ipairs(m_kParameter.Values) do
		if not IsItemSelected(v) then
			local civType, cityStateType = GetCityStateData_FromValue(v);
			if cityStateType == csType then
				cityStateNum = cityStateNum + 1
				--if "MILITARISTIC" == cityStateType then
					--print("civType=\t", civType)
				--end
			end
		end
	end

	return cityStateNum
end
-- ===========================================================================
function SortByName(kItemA:table, kItemB:table)
	return Locale.Compare(kItemA.Name, kItemB.Name) == -1;
end

-- ===========================================================================
function SortByType(kItemA:table, kItemB:table)
	local kItemDataA:table = GetCityStateData(kItemA.Value);
	local kItemDataB:table = GetCityStateData(kItemB.Value);

	if kItemDataA.CityStateCategory ~= nil and kItemDataB.CityStateCategory ~= nil then
		return Locale.Compare(kItemDataA.CityStateCategory, kItemDataB.CityStateCategory) == -1;
	else
		return false;
	end
end

-- ===========================================================================
function InitCityStateCountSlider( pGameParameters:table )

	local kValues:table = m_kCityStateCountParam.Values;

	Controls.CityStateCountNumber:SetText(m_kCityStateCountParam.Value);
	Controls.CityStateCountSlider:SetNumSteps(kValues.MaximumValue - kValues.MinimumValue);
	Controls.CityStateCountSlider:SetStep(m_kCityStateCountParam.Value - kValues.MinimumValue);

	--禁用城邦数量滑块
	Controls.CityStateCountSlider:SetEnabled(false)
	--初始化城邦数量
	m_cityStatesMaxNum = kValues.MaximumValue;
	m_CityStateTotalNum = m_kCityStateCountParam.Value;
	m_cityStatesMinNum = kValues.MinimumValue;
	print("m_cityStatesMaxNum=\t", m_cityStatesMaxNum)
	print("m_CityStateTotalNum=\t", m_CityStateTotalNum)
	print("m_cityStatesMinNum=\t", m_cityStatesMinNum)

	Controls.CityStateCountSlider:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider:GetStep();
		local value:number = m_kCityStateCountParam.Values.MinimumValue + stepNum;
			
		-- This method can get called pretty frequently, try and throttle it.
		if(m_kCityStateCountParam.Value ~= value) then
			pGameParameters:SetParameterValue(m_kCityStateCountParam, value);
			Controls.CityStateCountNumber:SetText(value);
			Network.BroadcastGameConfig();
			RefreshCountWarning();
		end
	end);

end

-- ===========================================================================
function InitCityStateTypeCountSlider(pGameParameters)
	
	m_Industrial_CityStates		= {};
	m_Militaristic_CityStates	= {};
	m_Scientific_CityStates		= {};
	m_Trade_CityStates			= {};
	m_Cultural_CityStates		= {};
	m_Religious_CityStates		= {};
	m_Agrarian_CityStates		= {};
	m_Entertainment_CityStates	= {};
	m_Maritime_CityStates		= {};
	m_Consular_CityStates		= {};

	for i, v in ipairs(m_kParameter.Values) do
		--print("v=\t", v)
		local civType, cityStateType = GetCityStateData_FromValue(v);
		if cityStateType == "INDUSTRIAL" then
			table.insert(m_Industrial_CityStates, civType)
		elseif cityStateType == "MILITARISTIC" then
			table.insert(m_Militaristic_CityStates, civType)
		elseif cityStateType == "SCIENTIFIC" then
			table.insert(m_Scientific_CityStates, civType)
		elseif cityStateType == "TRADE" then
			table.insert(m_Trade_CityStates, civType)
		elseif cityStateType == "CULTURAL" then
			table.insert(m_Cultural_CityStates, civType)
		elseif cityStateType == "RELIGIOUS" then
			table.insert(m_Religious_CityStates, civType)
		elseif cityStateType == "CSE_AGRICULTURAL" then
			table.insert(m_Agrarian_CityStates, civType)
		elseif cityStateType == "CSE_ENTERTAINMENT" then
			table.insert(m_Entertainment_CityStates, civType)
		elseif cityStateType == "CSE_MARITIME" then
			table.insert(m_Maritime_CityStates, civType)
		elseif cityStateType == "CSE_CONSULAR" then
			table.insert(m_Consular_CityStates, civType)
		end
	end


	m_Industrial_Num_InConfig = #m_Industrial_CityStates
	m_Militaristic_Num_InConfig =  #m_Militaristic_CityStates
	m_Scientific_Num_InConfig =  #m_Scientific_CityStates
	m_Trade_Num_InConfig = #m_Trade_CityStates
	m_Cultural_Num_InConfig =  #m_Cultural_CityStates
	m_Religious_Num_InConfig =  #m_Religious_CityStates
	m_Agrarian_Num_InConfig =  #m_Agrarian_CityStates
	m_Entertainment_Num_InConfig = #m_Entertainment_CityStates
	m_Maritime_Num_InConfig =  #m_Maritime_CityStates
	m_Consular_Num_InConfig =  #m_Consular_CityStates

	if m_firstTimeOpenCityStatePicker then
		if m_CityStateTotalNum < 6 then
			m_Industrial_Num = m_CityStateTotalNum;
			m_Militaristic_Num = 0;
			m_Scientific_Num = 0;
			m_Trade_Num = 0;
			m_Cultural_Num = 0;
			m_Religious_Num = 0;
		else
			local ave_num = math.floor(m_CityStateTotalNum / 6)
			local rest_num = m_CityStateTotalNum % 6
			m_Industrial_Num = ave_num + rest_num;
			m_Militaristic_Num = ave_num;
			m_Scientific_Num = ave_num;
			m_Trade_Num = ave_num;
			m_Cultural_Num = ave_num;
			m_Religious_Num = ave_num;
		end
	end	

	Controls.CityStateCountNumber_Industrial:SetText(m_Industrial_Num);
	Controls.CityStateCountSlider_Industrial:SetNumSteps(math.min(m_Industrial_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Industrial:SetStep(m_Industrial_Num );

	Controls.CityStateCountNumber_Militaristic:SetText(m_Militaristic_Num);
	Controls.CityStateCountSlider_Militaristic:SetNumSteps(math.min(m_Militaristic_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Militaristic:SetStep(m_Militaristic_Num );

	Controls.CityStateCountNumber_Scientific:SetText(m_Scientific_Num);
	Controls.CityStateCountSlider_Scientific:SetNumSteps(math.min(m_Scientific_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Scientific:SetStep(m_Scientific_Num );

	Controls.CityStateCountNumber_Trade:SetText(m_Trade_Num);
	Controls.CityStateCountSlider_Trade:SetNumSteps(math.min(m_Trade_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Trade:SetStep(m_Trade_Num );

	Controls.CityStateCountNumber_Cultural:SetText(m_Cultural_Num);
	Controls.CityStateCountSlider_Cultural:SetNumSteps(math.min(m_Cultural_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Cultural:SetStep(m_Cultural_Num );

	Controls.CityStateCountNumber_Religious:SetText(m_Religious_Num);
	Controls.CityStateCountSlider_Religious:SetNumSteps(math.min(m_Religious_Num_InConfig, m_cityStatesMaxNum) );
	Controls.CityStateCountSlider_Religious:SetStep(m_Religious_Num );

	Controls.CityStateCountSlider_Industrial:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Industrial:GetStep();
		local value:number = stepNum;
		if m_Industrial_Num ~= value then
			m_Industrial_Num = value
			Controls.CityStateCountNumber_Industrial:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);

	Controls.CityStateCountSlider_Militaristic:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Militaristic:GetStep();
		local value:number = stepNum;
		if m_Militaristic_Num ~= value then
			m_Militaristic_Num = value
			Controls.CityStateCountNumber_Militaristic:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);

	Controls.CityStateCountSlider_Scientific:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Scientific:GetStep();
		local value:number = stepNum;
		if m_Scientific_Num ~= value then
			m_Scientific_Num = value
			Controls.CityStateCountNumber_Scientific:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);
	
	Controls.CityStateCountSlider_Trade:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Trade:GetStep();
		local value:number = stepNum;
		if m_Trade_Num ~= value then
			m_Trade_Num = value
			Controls.CityStateCountNumber_Trade:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);

	Controls.CityStateCountSlider_Cultural:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Cultural:GetStep();
		local value:number = stepNum;
		if m_Cultural_Num ~= value then
			m_Cultural_Num = value
			Controls.CityStateCountNumber_Cultural:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);

	Controls.CityStateCountSlider_Religious:RegisterSliderCallback(function()
		local stepNum:number = Controls.CityStateCountSlider_Religious:GetStep();
		local value:number = stepNum;
		if m_Religious_Num ~= value then
			m_Religious_Num = value
			Controls.CityStateCountNumber_Religious:SetText(value);
			On_UpdateCityStateCountParam(pGameParameters);
			RefreshCountWarning();
		end
	end);

	--如果没有相应种类的城邦，则隐藏相应的控件
	if m_Agrarian_Num_InConfig == 0 then
		Controls.Stack_Agrarian:SetHide(true)
	else
		m_Agrarian_Num = 0
		Controls.Stack_Agrarian:SetHide(false)

		Controls.CityStateCountNumber_Agrarian:SetText(m_Agrarian_Num);
		Controls.CityStateCountSlider_Agrarian:SetNumSteps(math.min(m_Agrarian_Num_InConfig, m_cityStatesMaxNum) );
		Controls.CityStateCountSlider_Agrarian:SetStep(m_Agrarian_Num );
		
		Controls.CityStateCountSlider_Agrarian:RegisterSliderCallback(function()
			local stepNum:number = Controls.CityStateCountSlider_Agrarian:GetStep();
			local value:number = stepNum;
			if m_Agrarian_Num ~= value then
				m_Agrarian_Num = value
				Controls.CityStateCountNumber_Agrarian:SetText(value);
				On_UpdateCityStateCountParam(pGameParameters);
				RefreshCountWarning();
			end
		end);
	end

	if m_Entertainment_Num_InConfig == 0 then
		Controls.Stack_Entertainment:SetHide(true)
	else
		m_Entertainment_Num = 0
		Controls.Stack_Entertainment:SetHide(false)

		Controls.CityStateCountNumber_Entertainment:SetText(m_Entertainment_Num);
		Controls.CityStateCountSlider_Entertainment:SetNumSteps(math.min(m_Entertainment_Num_InConfig, m_cityStatesMaxNum) );
		Controls.CityStateCountSlider_Entertainment:SetStep(m_Entertainment_Num );
		
		Controls.CityStateCountSlider_Entertainment:RegisterSliderCallback(function()
			local stepNum:number = Controls.CityStateCountSlider_Entertainment:GetStep();
			local value:number = stepNum;
			if m_Entertainment_Num ~= value then
				m_Entertainment_Num = value
				Controls.CityStateCountNumber_Entertainment:SetText(value);
				On_UpdateCityStateCountParam(pGameParameters);
				RefreshCountWarning();
			end
		end);
	end

	if m_Maritime_Num_InConfig == 0 then
		Controls.Stack_Maritime:SetHide(true)
	else
		m_Maritime_Num = 0
		Controls.Stack_Maritime:SetHide(false)

		Controls.CityStateCountNumber_Maritime:SetText(m_Maritime_Num);
		Controls.CityStateCountSlider_Maritime:SetNumSteps(math.min(m_Maritime_Num_InConfig, m_cityStatesMaxNum) );
		Controls.CityStateCountSlider_Maritime:SetStep(m_Maritime_Num );
		
		Controls.CityStateCountSlider_Maritime:RegisterSliderCallback(function()
			local stepNum:number = Controls.CityStateCountSlider_Maritime:GetStep();
			local value:number = stepNum;
			if m_Maritime_Num ~= value then
				m_Maritime_Num = value
				Controls.CityStateCountNumber_Maritime:SetText(value);
				On_UpdateCityStateCountParam(pGameParameters);
				RefreshCountWarning();
			end
		end);
	end

	if m_Consular_Num_InConfig == 0 then
		Controls.Stack_Consular:SetHide(true)
	else
		m_Consular_Num = 0
		Controls.Stack_Consular:SetHide(false)

		Controls.CityStateCountNumber_Consular:SetText(m_Consular_Num);
		Controls.CityStateCountSlider_Consular:SetNumSteps(math.min(m_Consular_Num_InConfig, m_cityStatesMaxNum) );
		Controls.CityStateCountSlider_Consular:SetStep(m_Consular_Num );
		
		Controls.CityStateCountSlider_Consular:RegisterSliderCallback(function()
			local stepNum:number = Controls.CityStateCountSlider_Consular:GetStep();
			local value:number = stepNum;
			if m_Consular_Num ~= value then
				m_Consular_Num = value
				Controls.CityStateCountNumber_Consular:SetText(value);
				On_UpdateCityStateCountParam(pGameParameters);
				RefreshCountWarning();
			end
		end);
	end

end

function On_UpdateCityStateCountParam(pGameParameters)
	m_CityStateTotalNum = m_Industrial_Num  + m_Militaristic_Num + m_Scientific_Num + m_Trade_Num + m_Cultural_Num + m_Religious_Num + m_Agrarian_Num + m_Entertainment_Num + m_Maritime_Num + m_Consular_Num;

	if m_CityStateTotalNum <= m_cityStatesMaxNum then
		pGameParameters:SetParameterValue(m_kCityStateCountParam, m_CityStateTotalNum);
		Controls.CityStateCountNumber:SetText(m_CityStateTotalNum);
		Controls.CityStateCountSlider:SetStep(m_CityStateTotalNum - m_cityStatesMinNum);
		Network.BroadcastGameConfig();
	else
		pGameParameters:SetParameterValue(m_kCityStateCountParam, m_cityStatesMaxNum);
		Controls.CityStateCountNumber:SetText(m_cityStatesMaxNum);
		Controls.CityStateCountSlider:SetStep(m_cityStatesMaxNum - m_cityStatesMinNum);
		Network.BroadcastGameConfig();
	end

end

function GetCityStateData_FromValue(item :table)
	if (item) then
		local kCityStateData:table = GetCityStateData(item.Value);

		local cityStateType = kCityStateData.CityStateCategory
		local civType = item.Value

		return civType, cityStateType
	else
		return nil, nil
	end
end

-- ===========================================================================
function InitUseSelectedCSCheck(pGameParameters)
	Controls.UseSelectedCSCheck:SetCheck(m_UseSelectedCityStates);

	if m_UseSelectedCityStates then
		Controls.CheckDescription:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_CHECK_MODE_USE_SELECTED_CITY_STATES"));
	else
		Controls.CheckDescription:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_CHECK_MODE_NOT_USE_SELECTED_CITY_STATES"));
	end

	Controls.UseSelectedCSButton:RegisterCallback( Mouse.eLClick, function() OnModeCheckSelect(pGameParameters); end );
	Controls.UseSelectedCSCheck:RegisterCallback( Mouse.eLClick, function() OnModeCheckSelect(pGameParameters); end );

end

function OnModeCheckSelect(pGameParameters)
	m_UseSelectedCityStates = not m_UseSelectedCityStates
	Controls.UseSelectedCSCheck:SetCheck(m_UseSelectedCityStates);

	if m_UseSelectedCityStates then
		Controls.CheckDescription:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_CHECK_MODE_USE_SELECTED_CITY_STATES"));
		--启用城邦数量滑块
		Controls.CityStateCountSlider:SetEnabled(true);

		--隐藏单独类型城邦的数量滑块
		Controls.Stack_Row1:SetHide(true);
		Controls.Stack_Row2:SetHide(true);
		Controls.Stack_Row3:SetHide(true);
		Controls.Stack_Row4:SetHide(true);

		--隐藏禁用checkbox，显示选中checkbox
		for _, node in ipairs(m_kItemList) do
			if node["bancheckbox"] then
				node["bancheckbox"]:SetCheck(false);
				node["bancheckbox"]:SetHide(true);
			end
			if node["checkbox"] then
				node["checkbox"]:SetHide(false);
			end
		end

		Controls.SelectAllButton:SetDisabled(false);
		Controls.SelectNoneButton:SetDisabled(false);
		Controls.SelectVanillaButton:SetDisabled(false);
		Controls.SelectModButton:SetDisabled(false);

	else
		Controls.CheckDescription:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_CHECK_MODE_NOT_USE_SELECTED_CITY_STATES"));
		--禁用城邦数量滑块
		Controls.CityStateCountSlider:SetEnabled(false);

		--显示单独类型城邦的数量滑块
		Controls.Stack_Row1:SetHide(false);
		Controls.Stack_Row2:SetHide(false);
		Controls.Stack_Row3:SetHide(false);
		Controls.Stack_Row4:SetHide(false);


		--显示禁用checkbox，隐藏选中checkbox
		for _, node in ipairs(m_kItemList) do
			if node["bancheckbox"] then
				node["bancheckbox"]:SetCheck(false);
				node["bancheckbox"]:SetHide(false);
			end
			if node["checkbox"] then
				node["checkbox"]:SetHide(true);
			end
		end

		--禁用button
		Controls.SelectAllButton:SetDisabled(true);
		Controls.SelectNoneButton:SetDisabled(true);
		Controls.SelectVanillaButton:SetDisabled(true);
		Controls.SelectModButton:SetDisabled(true);

		--刷新城邦数量
		On_UpdateCityStateCountParam(pGameParameters)

	end
	RefreshCountWarning()
end

-- ===========================================================================
function InitSortByFilter()

	local uiButton:object = Controls.SortByPulldown:GetButton();
	uiButton:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_SORT_NAME"));

	Controls.SortByPulldown:ClearEntries();

	local pNameEntryInst:object = {};
	Controls.SortByPulldown:BuildEntry( "InstanceOne", pNameEntryInst );
	pNameEntryInst.Button:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_SORT_NAME"));
	pNameEntryInst.Button:RegisterCallback( Mouse.eLClick, 
		function() 
			Controls.SortByPulldown:GetButton():SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_SORT_NAME"));
			RefreshList(SortByName);
		end );

	local pTypeEntryInst:object = {};
	Controls.SortByPulldown:BuildEntry( "InstanceOne", pTypeEntryInst );
	pTypeEntryInst.Button:SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_SORT_TYPE"));
	pTypeEntryInst.Button:RegisterCallback( Mouse.eLClick, 
		function() 
			Controls.SortByPulldown:GetButton():SetText(Locale.Lookup("LOC_CITY_STATE_PICKER_SORT_TYPE"));
			RefreshList(SortByType);
		end );

	Controls.SortByPulldown:CalculateInternals();
end

-- ===========================================================================
function InitializeItem(item:table)
	local c: table = m_pItemIM:GetInstance();
	c.Name:SetText(item.Name);

	local backColor, frontColor = UI.GetPlayerColorValues(item.Value, 0);

	c.Icon:SetIcon(item.Icon);
	c.Icon:SetColor(frontColor);
	c.IconBacking:SetColor(backColor);

	c.Button:RegisterCallback( Mouse.eMouseEnter, function() OnItemFocus(item); end );
	c.Button:RegisterCallback( Mouse.eLClick, function() OnItemSelect(item, c.Selected); end );
	c.Selected:RegisterCallback( Mouse.eLClick, function() OnItemSelect(item, c.Selected); end );
	if m_bInvertSelection then
		c.Selected:SetCheck(not IsItemSelected(item));
	else
		c.Selected:SetCheck(IsItemSelected(item));
		m_numSelected = m_numSelected + 1;
	end

	-- Ban checkbox
	if c.BanCheck then
		c.BanCheck:SetCheck(IsCityStateBanned(item.Value));
		c.BanCheck:RegisterCallback( Mouse.eLClick, function() ToggleBanCityState(item, c.BanCheck); end );
	end

	local listItem:table = {};
	listItem["item"] = item;
	listItem["checkbox"] = c.Selected;
	listItem["bancheckbox"] = c.BanCheck;
	table.insert(m_kItemList, listItem);
end

-- ===========================================================================
function OnShutdown()
	Close();
	m_pItemIM:DestroyInstances();
	LuaEvents.CityStatePicker_Initialize.Remove( ParameterInitialize );
end

-- ===========================================================================
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then
		local key:number = pInputStruct:GetKey();
		if key == Keys.VK_ESCAPE then
			OnBackButton();
		end
	end
	return true;
end

-- ===========================================================================
function Initialize()
	ContextPtr:SetShutdown( OnShutdown );
	ContextPtr:SetInputHandler( OnInputHandler, true );

	local OnMouseEnter = function() UI.PlaySound("Main_Menu_Mouse_Over"); end;

	Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnBackButton );
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);
	Controls.ConfirmButton:RegisterCallback( Mouse.eLClick, OnConfirmChanges );
	Controls.ConfirmButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);
	Controls.SelectAllButton:RegisterCallback( Mouse.eLClick, OnSelectAll);
	Controls.SelectAllButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);
	Controls.SelectNoneButton:RegisterCallback( Mouse.eLClick, OnSelectNone);
	Controls.SelectNoneButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);

	Controls.SelectVanillaButton:RegisterCallback( Mouse.eLClick, OnSelectVanilla);
	Controls.SelectVanillaButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);
	Controls.SelectModButton:RegisterCallback( Mouse.eLClick, OnSelectMod);
	Controls.SelectModButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);

	if Controls.ClearBansButton then
		Controls.ClearBansButton:RegisterCallback( Mouse.eLClick, OnClearAllBans);
		Controls.ClearBansButton:RegisterCallback( Mouse.eMouseEnter, OnMouseEnter);
	end

	LuaEvents.CityStatePicker_Initialize.Add( ParameterInitialize );
end
Initialize();