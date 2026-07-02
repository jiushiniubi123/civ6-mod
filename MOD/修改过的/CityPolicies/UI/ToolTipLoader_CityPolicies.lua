-- 缓存原版 GetBuildingToolTip
local Base_GetBuildingToolTip = ToolTipHelper.GetBuildingToolTip

-- 城市政策专用工具提示
ToolTipHelper.GetCityPolicyToolTip = function(buildingHash, playerId, city)
    local building = GameInfo.Buildings[buildingHash]
    if building == nil then return end
    local toolTipLines = {}
    local name = building.Name
    local description = building.Description
    table.insert(toolTipLines, Locale.ToUpper(name))
    table.insert(toolTipLines, Locale.Lookup("LOC_CITY_POLICY_NAME"))
    if not Locale.IsNilOrWhitespace(description) then
        table.insert(toolTipLines, "[NEWLINE]" .. Locale.Lookup(description))
    end
    return table.concat(toolTipLines, "[NEWLINE]")
end

-- 覆盖 GetBuildingToolTip，为城市政策建筑返回专门提示
ToolTipHelper.GetBuildingToolTip = function(buildingHash, playerId, city)
    local building = GameInfo.Buildings[buildingHash]
    if building == nil then return end
    if building.BuildingType:match("^BUILDING_CITY_POLICY_") then
        return ToolTipHelper.GetCityPolicyToolTip(buildingHash, playerId, city)
    else
        return Base_GetBuildingToolTip(buildingHash, playerId, city)
    end
end

g_ToolTipGenerators.KIND_CITY_POLICY = ToolTipHelper.GetCityPolicyToolTip
g_ToolTipGenerators.KIND_BUILDING = ToolTipHelper.GetBuildingToolTip

-- =====================================================
-- 关键桥接：当 CityPanelOverview 刷新建筑数据后，自动触发城市政策面板的更新
-- 该事件会被 CityPanelOverview_CityPolicies_Instances.lua 监听
-- =====================================================
local function TriggerCityPoliciesFromOverview()
    -- CityPanel_LiveCityDataChanged 事件在每次城市数据更新时触发，并携带最新的 data 表
    LuaEvents.CityPanel_LiveCityDataChanged.Add(function(data, isSelected)
        if data and isSelected then
            LuaEvents.CityPanelOverview_CityPolicies(data)
        end
    end)
end

-- 确保在游戏加载完成后执行，避免过早注册
Events.LoadGameViewStateDone.Add(function()
    TriggerCityPoliciesFromOverview()
end)