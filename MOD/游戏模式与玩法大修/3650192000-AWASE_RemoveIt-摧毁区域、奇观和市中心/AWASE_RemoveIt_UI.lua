-- AWASE_RemoveIt_UI
-- Author: Awase
-- DateCreated: 1/20/2026 8:12:49 AM
--------------------------------------------------------------
include("InstanceManager")
include("PopupDialog")

-- ===========================================================================
-- 日志配置
-- ===========================================================================
local DEBUG_MODE = true
local LOG_LEVEL = { ERROR = 1, WARN = 2, INFO = 3, DEBUG = 4 }
local CURRENT_LOG_LEVEL = LOG_LEVEL.WARN

function LogMessage(message, level)
    level = level or LOG_LEVEL.INFO
    if level <= CURRENT_LOG_LEVEL and DEBUG_MODE then
        print("[REMOVEIT_UI][" .. os.date("%H:%M:%S") .. "][" .. level .. "] " .. tostring(message))
    end
end

-- ===========================================================================
-- 常量与变量
-- ===========================================================================
local ALLOWED_UNITS = {
    ['UNIT_BUILDER'] = true
}

-- 需定义的文本 Key
local TXT_KEY_CONFIRM_DISTRICT_WONDER = "LOC_AWASE_REMOVEIT_CONFIRM_DISTRICT_WONDER"
local TXT_KEY_CONFIRM_CAPITAL_CITY    = "LOC_AWASE_REMOVEIT_CONFIRM_CAPITAL_CITY"
local TXT_KEY_CONFIRM_NORMAL_CITY     = "LOC_AWASE_REMOVEIT_CONFIRM_NORMAL_CITY"

-- ===========================================================================
-- 辅助函数
-- ===========================================================================

-- 检查建筑内是否有巨作
function GetGreatWorksInBuilding(pCityBldgs, pBuildingInfo)
    local index = 0
    local results = {}
    local buildingIndex = pBuildingInfo.Index
    
    local numSlots = pCityBldgs:GetNumGreatWorkSlots(buildingIndex)
    if numSlots and numSlots > 0 then
        for _ = 0, numSlots - 1 do
            local greatWorkIndex = pCityBldgs:GetGreatWorkInSlot(buildingIndex, index)
            if greatWorkIndex ~= -1 then
                table.insert(results, greatWorkIndex)
            end
            index = index + 1
        end
    end
    return results
end

-- ===========================================================================
-- 初始化
-- ===========================================================================
function Initialize()
    LogMessage("开始初始化 RemoveIt UI...", LOG_LEVEL.INFO)

    local ActionStack = ContextPtr:LookUpControl("/InGame/UnitPanel/StandardActionsStack")
    if ActionStack ~= nil then
        Controls.AWASE_REMOVEIT_ActionGrid:ChangeParent(ActionStack)
        Controls.AWASE_REMOVEIT_RemoveButton:RegisterCallback(Mouse.eLClick, OnRemoveButtonClicked)
    end

    Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
    Events.UnitMoveComplete.Add(OnUnitMoveComplete)
    Events.CityProductionChanged.Add(RefreshUI)
end

-- ===========================================================================
-- 刷新逻辑
-- ===========================================================================
function RefreshUI()
    local unit = UI.GetHeadSelectedUnit()
    if unit == nil then 
        Controls.AWASE_REMOVEIT_ActionGrid:SetHide(true)
        return 
    end
    if ShouldHideButton(unit) then
        Controls.AWASE_REMOVEIT_ActionGrid:SetHide(true)
    else
        Controls.AWASE_REMOVEIT_ActionGrid:SetHide(false)
        local disabled, tooltip = IsButtonDisabled(unit)
        Controls.AWASE_REMOVEIT_RemoveButton:SetDisabled(disabled)
        Controls.AWASE_REMOVEIT_RemoveButton:SetToolTipString(tooltip)
    end
end

function ShouldHideButton(unit)
    if not unit then return true end
    local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
    if unit:GetOwner() ~= playerID or not pPlayer:IsHuman() then return true end
    local unitType = GameInfo.Units[unit:GetType()].UnitType
    if not ALLOWED_UNITS[unitType] then return true end
    if unit:GetBuildCharges() <= 0 then return true end
    if unit:GetMovesRemaining() <= 0 then return true end
    return false
end

function IsButtonDisabled(unit)
    local playerID = Game.GetLocalPlayer()
    local iX = unit:GetX()
    local iY = unit:GetY()
    local pPlot = Map.GetPlot(iX, iY)
    if not pPlot then return true, "Error" end

    local pCity = Cities.GetPlotPurchaseCity(pPlot)
    if not pCity or pCity:GetOwner() ~= playerID then
        return true, Locale.Lookup("LOC_AWASE_REMOVEIT_ERROR_NOT_OWNED")
    end

    local charges = unit:GetBuildCharges()
    if charges < 2 then
        return true, Locale.Lookup("LOC_AWASE_REMOVEIT_NOT_ENOUGH_CHARGES")
    end

    local hasValidObject = false
    local objectName = ""

    local districtID = pPlot:GetDistrictType()
    
    -- 判定逻辑
    if districtID >= 0 then
        local districtInfo = GameInfo.Districts[districtID]
        if districtInfo then
            if districtInfo.DistrictType == "DISTRICT_CITY_CENTER" then
                -- 情况1: 市中心
                hasValidObject = true
                objectName = Locale.Lookup("LOC_DISTRICT_CITY_CENTER_NAME")
                
            elseif districtInfo.DistrictType == "DISTRICT_WONDER" then
                -- 情况2: 奇观
                hasValidObject = true
                
                -- 尝试获取具体奇观名字
                local buildingList = pCity:GetBuildings():GetBuildingsAtLocation(pPlot:GetIndex())
                local foundNamedWonder = false
                for _, buildingIndex in ipairs(buildingList) do
                    local buildingInfo = GameInfo.Buildings[buildingIndex]
                    if buildingInfo and buildingInfo.IsWonder then
                        objectName = Locale.Lookup(buildingInfo.Name)
                        foundNamedWonder = true
                        break
                    end
                end
                
                -- 如果是未建成的奇观
                if not foundNamedWonder then
                    return true, Locale.Lookup("LOC_AWASE_REMOVEIT_NOT_COMPLETED_WONDER")
                end

            else
                -- 情况3: 普通区域 (包括未建成的和已建成的)
                -- 只要有区域ID存在，就允许拆除（包括未建成的地基）
                local pDistrict = pCity:GetDistricts():GetDistrict(districtID)
                if pDistrict then
                    hasValidObject = true
                    objectName = Locale.Lookup(districtInfo.Name)
                end
            end
        end
    end

    if hasValidObject then
        return false, Locale.Lookup("LOC_AWASE_REMOVEIT_BUTTON_TOOLTIP", objectName)
    else
        return true, Locale.Lookup("LOC_AWASE_REMOVEIT_ERROR_NO_TARGET")
    end
end

function OnUnitSelectionChanged(playerID, unitID, plotX, plotY, plotZ, bSelected, bEditable)
    if playerID ~= Game.GetLocalPlayer() then return end
    if bSelected then RefreshUI() else Controls.AWASE_REMOVEIT_ActionGrid:SetHide(true) end
end

function OnUnitMoveComplete(playerID, unitID, iX, iY)
    if playerID ~= Game.GetLocalPlayer() then return end
    RefreshUI()
end

-- ===========================================================================
-- 点击与交互逻辑
-- ===========================================================================
function OnRemoveButtonClicked()
    LogMessage("按钮被点击。", LOG_LEVEL.INFO)

    local pUnit = UI.GetHeadSelectedUnit()
    if not pUnit then return end
    local iX = pUnit:GetX()
    local iY = pUnit:GetY()
    local pPlot = Map.GetPlot(iX, iY)
    local pCity = Cities.GetPlotPurchaseCity(pPlot)
    if not pCity then return end

    -- 1. 识别目标类型
    local targetType = nil -- "CITY", "WONDER", "DISTRICT"
    local targetIndex = nil
    
    local districtID = pPlot:GetDistrictType()
    local districtInfo = GameInfo.Districts[districtID]
    
    if districtInfo then
        if districtInfo.DistrictType == "DISTRICT_CITY_CENTER" then
            -- 1. 市中心
            targetType = "CITY"
            
        elseif districtInfo.DistrictType == "DISTRICT_WONDER" then
            -- 2. 奇观
            targetType = "WONDER"
            
            -- 尝试查找建筑索引 (针对已建成奇观)
            local buildingList = pCity:GetBuildings():GetBuildingsAtLocation(pPlot:GetIndex())
            for _, buildingIndex in ipairs(buildingList) do
                if GameInfo.Buildings[buildingIndex].IsWonder then 
                    targetIndex = buildingIndex
                    break 
                end
            end
            
            -- -- 如果没找到建筑索引 (说明是未建成的奇观地基)
            -- if targetIndex == nil then
            --     LogMessage("检测到未建成的奇观，使用 DistrictID 作为临时索引。", LOG_LEVEL.DEBUG)
            --     targetIndex = districtID
            -- end
            
        else
            -- 3. 普通区域 (未建成 或 已建成)
            targetType = "DISTRICT"
            targetIndex = districtID
        end
    end

    if not targetType then return end

    -- 2. 准备执行参数
    local params = {
        UnitID = pUnit:GetID(),
        CityID = pCity:GetID(),
        TargetType = targetType,
        TargetIndex = targetIndex, -- 如果是 City，此值为 nil
        PlotIndex = pPlot:GetIndex()
    }

    -- 3. 巨作检查
    CheckGreatWorks(pCity, params)
end

-- 步骤 3.1: 检查巨作
function CheckGreatWorks(pCity, params)
    local hasGreatWorks = false
    local pCityBuildings = pCity:GetBuildings()
    
    if params.TargetType == "WONDER" then
        local bInfo = GameInfo.Buildings[params.TargetIndex]
        local gws = GetGreatWorksInBuilding(pCityBuildings, bInfo)
        if #gws > 0 then hasGreatWorks = true end
        
    elseif params.TargetType == "DISTRICT" then
        -- 检查区域内所有建筑（例如剧院广场内的博物馆）
        local buildingsAtPlot = pCityBuildings:GetBuildingsAtLocation(params.PlotIndex)
        for _, bIndex in ipairs(buildingsAtPlot) do
             local bInfo = GameInfo.Buildings[bIndex]
             local gws = GetGreatWorksInBuilding(pCityBuildings, bInfo)
             if #gws > 0 then hasGreatWorks = true; break end
        end
        
    elseif params.TargetType == "CITY" then
        -- 摧毁市中心等于摧毁城市，必须遍历全城所有建筑检查巨作
        for buildingInfo in GameInfo.Buildings() do
            if pCityBuildings:HasBuilding(buildingInfo.Index) then
                local gws = GetGreatWorksInBuilding(pCityBuildings, buildingInfo)
                if #gws > 0 then 
                    hasGreatWorks = true 
                    LogMessage("在城市建筑中发现巨作: " .. Locale.Lookup(buildingInfo.Name), LOG_LEVEL.DEBUG)
                    break 
                end
            end
        end
    end

    if hasGreatWorks then
        local m_kPopupDialog = PopupDialogInGame:new("REMOVEIT_GW_WARNING")
        m_kPopupDialog:AddTitle(Locale.Lookup("LOC_AWASE_REMOVEIT_GW_WARNING_TITLE"))
        m_kPopupDialog:AddText(Locale.Lookup("LOC_AWASE_REMOVEIT_GW_WARNING_BODY"))
        
        -- m_kPopupDialog:AddCancelButton(Locale.Lookup("LOC_AWASE_REMOVEIT_CANCEL"), function() end)
        m_kPopupDialog:AddCancelButton(Locale.Lookup("LOC_AWASE_REMOVEIT_MOVEGW_CANCEL"), function() 
            LogMessage("Popup: 用户转移巨作。", LOG_LEVEL.INFO)
            LuaEvents.LaunchBar_OpenGreatWorksOverview()
        end)
        m_kPopupDialog:AddConfirmButton(Locale.Lookup("LOC_AWASE_REMOVEIT_IGNORE"), function()
            DetermineConfirmationType(pCity, params)
        end)
        m_kPopupDialog:Open()
    else
        DetermineConfirmationType(pCity, params)
    end
end

-- 步骤 3.2 ~ 3.5: 根据类型显示确认弹窗
function DetermineConfirmationType(pCity, params)
    local title = Locale.Lookup("LOC_AWASE_REMOVEIT_CONFIRM_TITLE")
    local bodyText = ""
    
    if params.TargetType == "DISTRICT" or params.TargetType == "WONDER" then
        -- Step 3.3: 区域或奇观
        bodyText = Locale.Lookup(TXT_KEY_CONFIRM_DISTRICT_WONDER)
        
    elseif params.TargetType == "CITY" then
        -- Step 3.4: 检查是否为原始首都
        if pCity:IsOriginalCapital() then
            -- Step 3.5: 原始首都
            bodyText = Locale.Lookup(TXT_KEY_CONFIRM_CAPITAL_CITY)
        else
            -- Step 3.5: 普通城市
            bodyText = Locale.Lookup(TXT_KEY_CONFIRM_NORMAL_CITY)
        end
    end

    -- 显示最终确认弹窗
    local m_kPopupDialog = PopupDialogInGame:new("REMOVEIT_FINAL_CONFIRM")
    m_kPopupDialog:AddTitle(title)
    m_kPopupDialog:AddText(bodyText)
    
    -- 按钮1: 中止
    m_kPopupDialog:AddCancelButton(Locale.Lookup("LOC_AWASE_REMOVEIT_CANCEL"), function() end)
    
    -- 按钮2: 执行摧毁
    m_kPopupDialog:AddConfirmButton(Locale.Lookup("LOC_AWASE_REMOVEIT_DESTROY"), function()
        ExecuteRemoval(params)
    end)
    
    m_kPopupDialog:Open()
end

function ExecuteRemoval(params)
    LogMessage("UI层确认摧毁，调用 Gameplay...", LOG_LEVEL.INFO)
    Controls.AWASE_REMOVEIT_ActionGrid:SetHide(true)
    UI.PlaySound("Confirm_Civic") -- 播放一个音效
    
    -- 调用 Gameplay
    ExposedMembers.AWASE_REMOVEIT_Gameplay.ExecuteRemoval(Game.GetLocalPlayer(), params)
end

Events.LoadGameViewStateDone.Add(Initialize)