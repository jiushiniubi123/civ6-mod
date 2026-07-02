-- AWASE_RemoveIt_Gameplay
-- Author: Awase
-- DateCreated: 1/20/2026 8:19:45 AM
--------------------------------------------------------------
ExposedMembers.AWASE_REMOVEIT_Gameplay = {}

-- ===========================================================================
-- 日志配置
-- ===========================================================================
local DEBUG_MODE = false
local LOG_LEVEL = { INFO = 3, DEBUG = 4 }
function LogMessage(message)
    if DEBUG_MODE then print("[REMOVEIT_GAMEPLAY] " .. tostring(message)) end
end

-- ===========================================================================
-- 核心逻辑
-- ===========================================================================
function ExecuteRemoval(playerID, params)
    LogMessage("ExecuteRemoval Called for Player: " .. tostring(playerID))
    
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    -- 获取单位和城市
    local pUnit = pPlayer:GetUnits():FindID(params.UnitID)
    local pCity = CityManager.GetCity(playerID, params.CityID)
    
    if not pUnit or not pCity then return end

    -- 1. 消耗劳动力 (2点)
    LogMessage("消耗2点劳动力...")
    local unitAbility = pUnit:GetAbility()
    for i = 1, 12 do
        local abilityName = "ABILITY_AWASE_REMOVEIT_REDUCE_CHARGE_" .. i
        -- 尝试查找未使用的 charge ability slot
        if unitAbility:GetAbilityCount(abilityName) == 0 then
            unitAbility:ChangeAbilityCount(abilityName, 1)
            break
        end
    end
    
    -- 也可以选择消耗移动力
    UnitManager.FinishMoves(pUnit)

    -- 2. 执行摧毁
    if params.TargetType == "CITY" then
        LogMessage("目标类型: 城市 (市中心)")
        Cities.DestroyCity(pCity)
        LogMessage("城市已摧毁。")
        
    elseif params.TargetType == "WONDER" then
        LogMessage("目标类型: 奇观 Index " .. tostring(params.TargetIndex))
        pCity:GetBuildings():RemoveBuilding(params.TargetIndex)
        LogMessage("奇观已移除。")
        
    elseif params.TargetType == "DISTRICT" then
        LogMessage("目标类型: 区域 Index " .. tostring(params.TargetIndex))
        pCity:GetDistricts():RemoveDistrict(params.TargetIndex)
        LogMessage("区域已移除。")
    end
    
end

ExposedMembers.AWASE_REMOVEIT_Gameplay.ExecuteRemoval = ExecuteRemoval