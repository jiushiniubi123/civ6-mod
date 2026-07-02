-- GreatPersonTeleport
-- Author: SbF6HSO3F (modified)
-- 大作家、大艺术家、大音乐家：召唤奇观学家 + 传送开拓者 + 文化炸弹
-- 奇观学家：移动奇观
--------------------------------------------------------------
--||====================ExposedMembers====================||--

GameEvents = ExposedMembers.GameEvents
if ExposedMembers.GreatPersonTeleport == nil then
    ExposedMembers.GreatPersonTeleport = {}
end

--||===================local variables====================||--

local WONDER_BLACKLIST_TYPES = {
    ["BUILDING_GOLDEN_GATE_BRIDGE"] = true,
    ["BUILDING_PANAMA_CANAL"] = true,
    ["BUILDING_TOWER_BRIDGE"]      = true,
}

local WONDER_BLACKLIST = {}

ExposedMembers.GreatPersonTeleport.WonderBlacklist = WONDER_BLACKLIST

--||=================GameEvents functions=================||--

--||===============奇观学家偷取/安置功能===================||--

function ArchaeologistStealWonder(playerID, param)
    local pPlayer = Players[playerID]
    if pPlayer then
        local pUnit = UnitManager.GetUnit(playerID, param.unitID)
        if pUnit:GetActionCharges() < 1 then
            return
        end
        local pPlot = Map.GetPlot(param.x, param.y)
        if pPlot == nil then
            return
        end
        local pPlotID = pPlot:GetIndex()
        local pCity = Cities.GetPlotPurchaseCity(pPlotID)
        if pCity and pCity:GetOwner() == playerID then
            local cityBuildings, building = pCity:GetBuildings(), nil
            if cityBuildings then
                building = param.wonder
            end
            if building and building.Name ~= 'NONE' then
                if WONDER_BLACKLIST[building.Index] then
                    return
                end
                pUnit:SetProperty('StealWonder', building)
                pUnit:ChangeActionCharges(-1)
                UnitManager.ReportActivation(pUnit, "BRITAIN_ARCHAEOLOGIST")
                UnitManager.FinishMoves(pUnit)
                cityBuildings:RemoveBuilding(building.Index)
                pCity:GetBuildQueue():RemoveBuilding(building.Index)
            end
        end
    end
end

function ArchaeologistPlaceWonder(playerID, param)
    local pPlayer = Players[playerID]
    if pPlayer then
        local pUnit = UnitManager.GetUnit(playerID, param.unitID)
        local Wonder = pUnit:GetProperty('StealWonder')
        if Wonder then
            local pPlot = Map.GetPlot(param.x, param.y)
            if pPlot == nil then
                return
            end
            local pPlotID = pPlot:GetIndex()
            local pCity = Cities.GetPlotPurchaseCity(pPlotID)
            if pCity and pCity:GetOwner() == playerID then
                local iSpeed = GameConfiguration.GetGameSpeedType()
                local multiplier = GameInfo.GameSpeeds[iSpeed].CostMultiplier
                local wonderCost = math.floor(GameInfo.Buildings[Wonder.Index].Cost * multiplier / 100)
                local treasury = pPlayer:GetTreasury()
                if treasury and treasury:GetGoldBalance() < wonderCost then
                    return
                end
                pUnit:SetProperty('StealWonder', false)
                UnitManager.ReportActivation(pUnit, "BRITAIN_ARCHAEOLOGIST")
                UnitManager.FinishMoves(pUnit)
                if pUnit:GetActionCharges() == 0 then
                    UnitManager.Kill(pUnit, false)
                end
                treasury:ChangeGoldBalance(-wonderCost)
                local cityBuildQueue = pCity:GetBuildQueue()
                cityBuildQueue:CreateIncompleteBuilding(Wonder.Index, pPlotID, 100)
            end
        end
    end
end

--||=================传送开拓者功能===================||--

function GreatPersonTeleportSettler(playerID, param)
    local pPlayer = Players[playerID]
    if pPlayer then
        local pSettler = UnitManager.GetUnit(playerID, param.unitID)
        if pSettler then
            UnitManager.PlaceUnit(pSettler, param.x, param.y)
        end
        if param.gpUnitID then
            local pGP = UnitManager.GetUnit(playerID, param.gpUnitID)
            if pGP then
                UnitManager.FinishMoves(pGP)
                UnitManager.Kill(pGP, false)
            end
        end
    end
end

--||=================文化炸弹功能===================||--

-- 检查目标地块是否与玩家领土接壤（六边形网格）
-- 返回 isAdjacent, cityID
local function IsAdjacentToPlayerTerritory(targetX, targetY, playerID)
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local nx, ny = targetX + dx, targetY + dy
                local neighborPlot = Map.GetPlot(nx, ny)
                if neighborPlot and Map.GetPlotDistance(targetX, targetY, nx, ny) == 1 then
                    if neighborPlot:GetOwner() == playerID then
                        local pCity = Cities.GetPlotPurchaseCity(neighborPlot:GetIndex())
                        local cityID = -1
                        if pCity then
                            cityID = pCity:GetID()
                        end
                        return true, cityID
                    end
                end
            end
        end
    end
    return false, -1
end

function CultureBomb(playerID, param)
    local pPlayer = Players[playerID]
    if pPlayer then
        local pUnit = UnitManager.GetUnit(playerID, param.unitID)
        if pUnit then
            local x, y = pUnit:GetX(), pUnit:GetY()
            local pCurrentPlot = Map.GetPlot(x, y)
            if not pCurrentPlot then
                return
            end

            -- Step 1: 如果GP站在中立地块上，先吞并GP所在的地块
            -- 这样GP脚下就是玩家领土，跟游戏文化炸弹（触发地块是己方领土）一致
            if pCurrentPlot:GetOwner() == -1 then
                local isAdjacent, cityID = IsAdjacentToPlayerTerritory(x, y, playerID)
                if isAdjacent then
                    pCurrentPlot:SetOwner(playerID, cityID, true)
                else
                    -- 不接壤，不能炸
                    UnitManager.Kill(pUnit, false)
                    return
                end
            end

            -- Step 2: 1-ring 文化炸弹（六边形网格，6邻居）
            -- 先收集所有符合条件的地块，再统一吞并（避免连锁反应）
            local plotsToAcquire = {}
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if dx ~= 0 or dy ~= 0 then
                        local tx, ty = x + dx, y + dy
                        local adjPlot = Map.GetPlot(tx, ty)
                        -- 只处理六边形距离 == 1 的真正邻居（不是方形网格的8邻居）
                        if adjPlot and Map.GetPlotDistance(x, y, tx, ty) == 1 then
                            local adjOwner = adjPlot:GetOwner()
                            if adjOwner ~= playerID then
                                -- 检查该地块是否与玩家领土接壤
                                local isAdjacentToPlayer, assignCityID = IsAdjacentToPlayerTerritory(tx, ty, playerID)

                                if isAdjacentToPlayer then
                                    -- 检查障碍物：区域（含市中心）或奇观
                                    local hasObstacle = false
                                    local districtID = adjPlot:GetDistrictID()
                                    if districtID > 0 then
                                        hasObstacle = true
                                    end
                                    if not hasObstacle then
                                        local wonderType = adjPlot:GetWonderType()
                                        if wonderType and wonderType ~= -1 then
                                            hasObstacle = true
                                        end
                                    end

                                    if not hasObstacle then
                                        -- Fallback: 用GP所在地块的城市
                                        if assignCityID == -1 then
                                            local gpCity = Cities.GetPlotPurchaseCity(pCurrentPlot:GetIndex())
                                            if gpCity then
                                                assignCityID = gpCity:GetID()
                                            end
                                        end
                                        table.insert(plotsToAcquire, {
                                            plot = adjPlot,
                                            cityID = assignCityID
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- 统一吞并所有收集到的地块（避免连锁反应）
            for _, entry in ipairs(plotsToAcquire) do
                entry.plot:SetOwner(playerID, entry.cityID, true)
            end

            -- Kill the GP
            UnitManager.ReportActivation(pUnit, "BRITAIN_ARCHAEOLOGIST")
            UnitManager.FinishMoves(pUnit)
            UnitManager.Kill(pUnit, false)
        end
    end
end

--||=================召唤奇观学家功能===================||--

function SummonWonderTheft(playerID, param)
    local pPlayer = Players[playerID]
    if pPlayer then
        local pGP = UnitManager.GetUnit(playerID, param.unitID)
        if pGP then
            local x, y = pGP:GetX(), pGP:GetY()
            local pNewUnit = UnitManager.InitUnit(playerID, GameInfo.Units['UNIT_WONDER_THEFT'].Index, x, y)
            if pNewUnit then
                UnitManager.ReportActivation(pGP, "BRITAIN_ARCHAEOLOGIST")
                UnitManager.FinishMoves(pGP)
                UnitManager.Kill(pGP, false)
            end
        end
    end
end

--||======================initialize======================||--

function Initialize()
    ---------------GameEvents---------------
    GameEvents.StealWonder.Add(ArchaeologistStealWonder)
    GameEvents.PlaceWonder.Add(ArchaeologistPlaceWonder)
    GameEvents.PlaceUnits.Add(GreatPersonTeleportSettler)
    GameEvents.CultureBomb.Add(CultureBomb)
    GameEvents.SummonWonderTheft.Add(SummonWonderTheft)
    ----------------------------------------
    for row in GameInfo.Buildings() do
        if row.IsWonder and WONDER_BLACKLIST_TYPES[row.BuildingType] then
            WONDER_BLACKLIST[row.Index] = true
        end
    end
    print('GreatPersonTeleport Initial success!')
end

Initialize()