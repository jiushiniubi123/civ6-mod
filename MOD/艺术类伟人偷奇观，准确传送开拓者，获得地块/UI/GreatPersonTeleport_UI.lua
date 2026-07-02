-- GreatPersonTeleport_UI
-- Author: SbF6HSO3F (modified)
-- 大作家、大艺术家、大音乐家：召唤奇观学家 + 传送开拓者 + 文化炸弹
-- 奇观学家：移动奇观
--------------------------------------------------------------
--||====================ExposedMembers====================||--

include("PopupDialog")

GameEvents = ExposedMembers.GameEvents

--||===================global variables====================||--

G_wonderDetial = { Index = -1, Name = 'NONE' }

--||===================local variables====================||--

local GP_UNITS = {
    GameInfo.Units['UNIT_GREAT_WRITER'].Index,
    GameInfo.Units['UNIT_GREAT_ARTIST'].Index,
    GameInfo.Units['UNIT_GREAT_MUSICIAN'].Index
}

local WONDER_THEFT_INDEX = GameInfo.Units['UNIT_WONDER_THEFT'].Index
local SETTLER_INDEX = GameInfo.Units['UNIT_SETTLER'].Index
local wonderType = GameInfo.Districts['DISTRICT_WONDER'].Index
local eReason_1 = DB.MakeHash("BRITAIN_ARCHAEOLOGIST")
local WONDER_BLACKLIST = ExposedMembers.GreatPersonTeleport.WonderBlacklist or {}

-- GP great work usage tracking (本地追踪，避免跨域时序问题)
local m_GPUsedGreatWorks = {}

--||===================helper functions====================||--

local function IsGPUnit(unitType)
    for _, unitIndex in ipairs(GP_UNITS) do
        if unitType == unitIndex then
            return true
        end
    end
    return false
end

local function GPHasUsedGreatWork(pUnit)
    if pUnit and m_GPUsedGreatWorks[pUnit:GetID()] then
        return true
    end
    return false
end

local function GetSpeedAdjustedCost(buildingIndex)
    local iSpeed = GameConfiguration.GetGameSpeedType()
    local multiplier = GameInfo.GameSpeeds[iSpeed].CostMultiplier
    return math.floor(GameInfo.Buildings[buildingIndex].Cost * multiplier / 100)
end

local function GetGreatWorksInBuilding(pCityBldgs, buildingIndex)
    local index = 0
    local results = {}
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

--||===============奇观学家偷取/安置功能函数===================||--

function ArchaeologistGetPlotWonder(pCity, plotID)
    local cityBuildings = pCity and pCity:GetBuildings()
    local wonder = { Index = -1, Name = 'NONE' }
    if cityBuildings then
        for _, type in ipairs(cityBuildings:GetBuildingsAtLocation(plotID)) do
            if GameInfo.Buildings[type].IsWonder == true then
                wonder.Index = type
                wonder.Name = GameInfo.Buildings[type].Name
            end
        end
    end
    return wonder
end

function ArchaeologistWonderPlot()
    local w, h = Map.GetGridSize()
    local localplayer = Game.GetLocalPlayer()
    local visibility = PlayersVisibility[localplayer]

    local plots = {}
    for i = 1, (w * h) - 1, 1 do
        local pPlot = Map.GetPlotByIndex(i)
        if visibility:IsRevealed(pPlot:GetX(), pPlot:GetY()) then
            local wonder = pPlot:GetWonderType()
            if wonder and wonder ~= -1 and pPlot:IsWonderComplete() then
                table.insert(plots, pPlot:GetIndex())
            end
        end
    end
    return plots
end

function ArchaeologistButtonDisabled(pUnit)
    if pUnit then
        if pUnit:GetMovesRemaining() == 0 then
            return true, Locale.Lookup('LOC_GREAT_PERSON_NO_MOVEMENT')
        end
    end
    if pUnit and pUnit:GetType() == WONDER_THEFT_INDEX then
        local wonder = pUnit:GetProperty('StealWonder')
        local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
        if pPlot == nil then
            return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLOT')
        end
        local pPlayer = Players[pPlot:GetOwner()]
        if pPlayer == nil then
            return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLAYER')
        end
        local districtID, pDistrict = pPlot:GetDistrictID(), nil
        if districtID > 0 then
            pDistrict = pPlayer:GetDistricts():FindID(districtID)
        end
        if wonder then
            if pUnit:GetOwner() == pPlot:GetOwner() then
                if pDistrict == nil then
                    local wonderCost = GetSpeedAdjustedCost(wonder.Index)
                    local unitOwner = Players[pUnit:GetOwner()]
                    if unitOwner then
                        local treasury = unitOwner:GetTreasury()
                        if treasury and treasury:GetGoldBalance() < wonderCost then
                            return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_GOLD', wonderCost)
                        end
                    end
                    return false
                else
                    return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_NEED')
                end
            else
                return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_MACTH')
            end
        else
            if pUnit:GetActionCharges() < 1 then
                return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_CHARGES')
            end
            if pUnit:GetOwner() == pPlot:GetOwner() then
                if pDistrict and pDistrict:GetType() == wonderType then
                    G_wonderDetial = ArchaeologistGetPlotWonder(pDistrict:GetCity(), pPlot:GetIndex())
                    if G_wonderDetial.Name ~= 'NONE' then
                        if WONDER_BLACKLIST[G_wonderDetial.Index] then
                            return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_BLACKLIST')
                        end
                        return false, G_wonderDetial
                    else
                        return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_WONDER')
                    end
                else
                    return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_NEED')
                end
            else
                return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_MACTH')
            end
        end
    else
        return true, Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_UNIT')
    end
end

function ArchaeologistResetButton(pUnit)
    if pUnit:GetType() ~= WONDER_THEFT_INDEX then
        Controls.Archaeologist_Button:SetHide(true)
        return
    end
    local hasStoredWonder = pUnit:GetProperty('StealWonder')
    if pUnit:GetActionCharges() < 1 and not hasStoredWonder then
        Controls.Archaeologist_Button:SetHide(true)
        return
    end
    Controls.Archaeologist_Button:SetHide(false)
    local wonderDetail, string = hasStoredWonder, nil
    local disabled, reason = ArchaeologistButtonDisabled(pUnit)
    Controls.Archaeologist_Button:SetDisabled(disabled)
    Controls.Archaeologist_Button:SetAlpha((disabled and 0.4) or 1)
    if wonderDetail then
        string = Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE')
        local wonderCost = GetSpeedAdjustedCost(wonderDetail.Index)
        if not disabled then
            string = string ..
                Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_WONDER_DETAIL', wonderDetail.Name) ..
                '[NEWLINE][NEWLINE]' ..
                Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_DETAIL', wonderDetail.Name) ..
                '[NEWLINE]' ..
                Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_COST', wonderCost)
        else
            string = string .. '[NEWLINE][NEWLINE]' ..
                Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_NOUSE', wonderDetail.Name)
        end
        Controls.Archaeologist_Icon:SetIcon('ICON_PLACE_WONDER')
    else
        string = Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL')
        if not disabled and reason then
            string = string .. Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_WONDER_DETAIL', reason.Name) ..
                '[NEWLINE][NEWLINE]' ..
                Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_DETAIL', reason.Name)
        else
            string = string .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_NOUSE')
        end
        Controls.Archaeologist_Icon:SetIcon('ICON_STEAL_WONDER')
    end
    if disabled and reason then
        string = string .. '[NEWLINE][NEWLINE]' ..
            Locale.Lookup('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NOTUSE') .. '[NEWLINE]' .. reason
    end
    if string then
        Controls.Archaeologist_Button:SetToolTipString(string)
    end
end

function CheckGreatWorksBeforeSteal(param)
    local pPlot = Map.GetPlot(param.x, param.y)
    if not pPlot then
        ExecuteStealWonder(param)
        return
    end
    local pCity = Cities.GetPlotPurchaseCity(pPlot:GetIndex())
    if not pCity then
        ExecuteStealWonder(param)
        return
    end
    local cityBuildings = pCity:GetBuildings()
    if not cityBuildings then
        ExecuteStealWonder(param)
        return
    end
    local wonder = param.wonder
    local hasGreatWorks = false
    if wonder and wonder.Index ~= -1 then
        local gws = GetGreatWorksInBuilding(cityBuildings, wonder.Index)
        if #gws > 0 then
            hasGreatWorks = true
        end
    end
    if hasGreatWorks then
        local m_kPopupDialog = PopupDialogInGame:new("GPTELEPORT_GW_WARNING")
        m_kPopupDialog:AddTitle(Locale.Lookup("LOC_GREAT_PERSON_GW_WARNING_TITLE"))
        m_kPopupDialog:AddText(Locale.Lookup("LOC_GREAT_PERSON_GW_WARNING_BODY"))
        m_kPopupDialog:AddCancelButton(Locale.Lookup("LOC_GREAT_PERSON_MOVEGW_CANCEL"), function()
            LuaEvents.LaunchBar_OpenGreatWorksOverview()
        end)
        m_kPopupDialog:AddConfirmButton(Locale.Lookup("LOC_GREAT_PERSON_GW_IGNORE"), function()
            ExecuteStealWonder(param)
        end)
        m_kPopupDialog:Open()
    else
        ExecuteStealWonder(param)
    end
end

function ExecuteStealWonder(param)
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param)
end

function ArchaeologistOnButtonClicked()
    local pUnit, param = UI.GetHeadSelectedUnit(), {}
    param.unitID = pUnit:GetID()
    param.x = pUnit:GetX()
    param.y = pUnit:GetY()
    if pUnit:GetProperty('StealWonder') then
        param.OnStart = 'PlaceWonder'
        UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, param)
    else
        param.wonder = G_wonderDetial
        param.OnStart = 'StealWonder'
        CheckGreatWorksBeforeSteal(param)
    end
end

--||=================传送开拓者功能函数===================||--

function GetRandomPlot(pUnit)
    if not pUnit then
        return nil
    end

    local pCurrentPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    if not pCurrentPlot then
        return nil
    end

    local currentContinent = pCurrentPlot:GetContinentType()
    local targetPlots = {}
    local w, h = Map.GetGridSize()
    for i = 0, (w * h) - 1 do
        local pPlot = Map.GetPlotByIndex(i)
        if pPlot and not pPlot:IsWater() and pPlot:GetContinentType() ~= currentContinent and pPlot:GetOwner() == -1 and not pPlot:IsImpassable() then
            table.insert(targetPlots, pPlot)
        end
    end

    if #targetPlots == 0 then
        return nil
    end

    return targetPlots[math.random(1, #targetPlots)]
end

function GetNearestSettler(pUnit)
    if not pUnit then
        return nil
    end

    local playerID = pUnit:GetOwner()
    local uX, uY = pUnit:GetX(), pUnit:GetY()
    local nearestSettler = nil
    local nearestDist = 999

    local pPlayer = Players[playerID]
    if not pPlayer then
        return nil
    end

    local units = pPlayer:GetUnits()
    for i, pOtherUnit in units:Members() do
        if pOtherUnit and pOtherUnit:GetType() == SETTLER_INDEX and pOtherUnit:GetID() ~= pUnit:GetID() then
            local dist = Map.GetPlotDistance(uX, uY, pOtherUnit:GetX(), pOtherUnit:GetY())
            if dist <= 1 and dist < nearestDist then
                nearestSettler = pOtherUnit
                nearestDist = dist
            end
        end
    end

    return nearestSettler
end

function TeleportDisabled(pUnit)
    if pUnit then
        if pUnit:GetMovesRemaining() == 0 then
            return true, Locale.Lookup('LOC_GREAT_PERSON_NO_MOVEMENT')
        end
    end
    if pUnit and IsGPUnit(pUnit:GetType()) then
        local pSettler = GetNearestSettler(pUnit)
        if not pSettler then
            return true, Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_NO_SETTLER_NEARBY')
        end
        local pPlot = GetRandomPlot(pUnit)
        if not pPlot then
            return true, Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_NO_PLOTS')
        end
        return false
    else
        return true, Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_NO_UNIT')
    end
end

function ResetTeleportButton(pUnit)
    -- Only show for GP units (not Wonderologist)
    if not IsGPUnit(pUnit:GetType()) then
        Controls.Teleport_Button:SetHide(true)
        return
    end
    -- Hide completely if GP has already produced a Great Work
    if GPHasUsedGreatWork(pUnit) then
        Controls.Teleport_Button:SetHide(true)
        return
    end
    Controls.Teleport_Button:SetHide(false)
    local disabled, reason = TeleportDisabled(pUnit)
    Controls.Teleport_Button:SetDisabled(disabled)
    Controls.Teleport_Button:SetAlpha((disabled and 0.4) or 1)

    local string = Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_REBACK') ..
        '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_REBACK_EFFECT')
    if disabled and reason then
        string = string .. '[NEWLINE][NEWLINE]' ..
            Locale.Lookup('LOC_GREAT_PERSON_TELEPORT_NOTUSE') .. '[NEWLINE]' .. reason
    end

    Controls.Teleport_Button:SetToolTipString(string)
end

function OnTeleportClicked()
    local pUnit = UI.GetHeadSelectedUnit()
    if not pUnit then
        return
    end

    local pSettler = GetNearestSettler(pUnit)
    if not pSettler then
        return
    end

    local pPlot = GetRandomPlot(pUnit)
    if pPlot then
        UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, {
            OnStart = 'PlaceUnits',
            unitID = pSettler:GetID(),
            gpUnitID = pUnit:GetID(),
            x = pPlot:GetX(),
            y = pPlot:GetY(),
        })
        UI.PlaySound("Unit_Relocate")
    end
end

--||=================文化炸弹功能函数===================||--

function CultureBombDisabled(pUnit)
    if pUnit then
        if pUnit:GetMovesRemaining() == 0 then
            return true, Locale.Lookup('LOC_GREAT_PERSON_NO_MOVEMENT')
        end
    end
    if pUnit and IsGPUnit(pUnit:GetType()) then
        local playerID = pUnit:GetOwner()
        local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
        if pPlot == nil then
            return true, Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_NO_PLOT')
        end
        local plotOwner = pPlot:GetOwner()
        -- Must be player's own tile OR unowned tile adjacent to player territory
        if plotOwner == playerID then
            return false
        elseif plotOwner == -1 then
            -- Check if unowned tile is adjacent to player territory (hex grid)
            local isAdjacent = false
            local ux, uy = pUnit:GetX(), pUnit:GetY()
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if dx ~= 0 or dy ~= 0 then
                        local adjPlot = Map.GetPlot(ux + dx, uy + dy)
                        if adjPlot and Map.GetPlotDistance(ux, uy, ux + dx, uy + dy) == 1 then
                            if adjPlot:GetOwner() == playerID then
                                isAdjacent = true
                                break
                            end
                        end
                    end
                end
                if isAdjacent then break end
            end
            if isAdjacent then
                return false
            else
                return true, Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_NOT_ADJACENT')
            end
        else
            return true, Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_FOREIGN')
        end
    else
        return true, Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_NO_UNIT')
    end
end

function ResetCultureBombButton(pUnit)
    -- Only show for GP units (not Wonderologist)
    if not IsGPUnit(pUnit:GetType()) then
        Controls.CultureBomb_Button:SetHide(true)
        return
    end
    -- Hide completely if GP has already produced a Great Work
    if GPHasUsedGreatWork(pUnit) then
        Controls.CultureBomb_Button:SetHide(true)
        return
    end
    Controls.CultureBomb_Button:SetHide(false)
    local disabled, reason = CultureBombDisabled(pUnit)
    Controls.CultureBomb_Button:SetDisabled(disabled)
    Controls.CultureBomb_Button:SetAlpha((disabled and 0.4) or 1)

    local string = Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB')
    if not disabled then
        string = string .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_EFFECT')
    else
        string = string .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_NOUSE')
    end
    if disabled and reason then
        string = string .. '[NEWLINE][NEWLINE]' ..
            Locale.Lookup('LOC_GREAT_PERSON_CULTURE_BOMB_NOTUSE') .. '[NEWLINE]' .. reason
    end

    Controls.CultureBomb_Button:SetToolTipString(string)
end

function OnCultureBombClicked()
    local pUnit = UI.GetHeadSelectedUnit()
    if not pUnit then
        return
    end
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, {
        OnStart = 'CultureBomb',
        unitID = pUnit:GetID(),
        x = pUnit:GetX(),
        y = pUnit:GetY(),
    })
    UI.PlaySound("Unit_Relocate")
end

--||=================召唤奇观学家功能函数===================||--

function SummonDisabled(pUnit)
    if pUnit then
        if pUnit:GetMovesRemaining() == 0 then
            return true, Locale.Lookup('LOC_GREAT_PERSON_NO_MOVEMENT')
        end
    end
    if pUnit and IsGPUnit(pUnit:GetType()) then
        return false
    else
        return true, Locale.Lookup('LOC_GREAT_PERSON_SUMMON_NO_UNIT')
    end
end

function ResetSummonButton(pUnit)
    -- Only show for GP units (not Wonderologist)
    if not IsGPUnit(pUnit:GetType()) then
        Controls.Summon_Button:SetHide(true)
        return
    end
    -- Hide completely if GP has already produced a Great Work
    if GPHasUsedGreatWork(pUnit) then
        Controls.Summon_Button:SetHide(true)
        return
    end
    Controls.Summon_Button:SetHide(false)
    local disabled, reason = SummonDisabled(pUnit)
    Controls.Summon_Button:SetDisabled(disabled)
    Controls.Summon_Button:SetAlpha((disabled and 0.4) or 1)

    local string = Locale.Lookup('LOC_GREAT_PERSON_SUMMON')
    if not disabled then
        string = string .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_GREAT_PERSON_SUMMON_EFFECT')
    else
        string = string .. '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_GREAT_PERSON_SUMMON_NOUSE')
    end
    if disabled and reason then
        string = string .. '[NEWLINE][NEWLINE]' ..
            Locale.Lookup('LOC_GREAT_PERSON_SUMMON_NOTUSE') .. '[NEWLINE]' .. reason
    end

    Controls.Summon_Button:SetToolTipString(string)
end

function OnSummonClicked()
    local pUnit = UI.GetHeadSelectedUnit()
    if not pUnit then
        return
    end
    UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, {
        OnStart = 'SummonWonderTheft',
        unitID = pUnit:GetID(),
    })
    UI.PlaySound("Unit_Relocate")
end

--||===================Reset 总控函数===================||--

function ArchaeologistReset(playerID)
    if playerID ~= Game.GetLocalPlayer() then
        Controls.Archaeologist_Grid:SetHide(true)
        return
    end
    local pUnit = UI.GetHeadSelectedUnit()
    if pUnit and (IsGPUnit(pUnit:GetType()) or pUnit:GetType() == WONDER_THEFT_INDEX) then
        Controls.Archaeologist_Grid:SetHide(false)
        ArchaeologistResetButton(pUnit)
        ResetTeleportButton(pUnit)
        ResetCultureBombButton(pUnit)
        ResetSummonButton(pUnit)
    else
        Controls.Archaeologist_Grid:SetHide(true)
    end
end

--||===================Events functions===================||--

function ArchaeologistOnUnitSelectChanged(playerId, unitId, locationX, locationY, locationZ, isSelected, isEditable)
    if isSelected then
        ArchaeologistReset(playerId)
    end
end

function ArchaeologistOnPhaseBegin()
    local pUnit = UI.GetHeadSelectedUnit()
    if pUnit then
        ArchaeologistReset(pUnit:GetOwner())
    end
end

function ArchaeologistActive(owner, unitID, x, y, eReason)
    local pUnit = UnitManager.GetUnit(owner, unitID);
    if eReason == eReason_1 then
        -- Our custom action (Wonderologist steal/place, culture bomb, teleport, summon)
        ArchaeologistResetButton(pUnit)
        SimUnitSystem.SetAnimationState(pUnit, "ACTION_1", "IDLE")
    elseif pUnit and IsGPUnit(pUnit:GetType()) then
        -- GP used their great work ability (any non-custom activation)
        m_GPUsedGreatWorks[unitID] = true
        print('GPTELEPORT_UI: GP unit ' .. unitID .. ' activated - marked as used great work')
    end
end

function ArchaeologistOnLoadGameViewStateDone()
    local pContext = ContextPtr:LookUpControl("/InGame/UnitPanel/StandardActionsStack")
    if pContext ~= nil then
        Controls.Archaeologist_Grid:ChangeParent(pContext)
        Controls.Archaeologist_Button:RegisterCallback(Mouse.eLClick, ArchaeologistOnButtonClicked)
        Controls.Teleport_Button:RegisterCallback(Mouse.eLClick, OnTeleportClicked)
        Controls.CultureBomb_Button:RegisterCallback(Mouse.eLClick, OnCultureBombClicked)
        Controls.Summon_Button:RegisterCallback(Mouse.eLClick, OnSummonClicked)
    end
end

--||======================initialize======================||--

function Initialize()
    Events.LoadGameViewStateDone.Add(ArchaeologistOnLoadGameViewStateDone)
    Events.UnitSelectionChanged.Add(ArchaeologistOnUnitSelectChanged)
    Events.UnitActivate.Add(ArchaeologistActive)
    ---------------------------------------------------------------
    Events.UnitOperationSegmentComplete.Add(ArchaeologistReset)
    Events.UnitCommandStarted.Add(ArchaeologistReset)
    Events.UnitDamageChanged.Add(ArchaeologistReset)
    Events.UnitMoveComplete.Add(ArchaeologistReset)
    Events.UnitChargesChanged.Add(ArchaeologistReset)
    Events.UnitPromoted.Add(ArchaeologistReset)
    Events.UnitOperationsCleared.Add(ArchaeologistReset)
    Events.UnitOperationAdded.Add(ArchaeologistReset)
    Events.UnitOperationDeactivated.Add(ArchaeologistReset)
    Events.UnitMovementPointsChanged.Add(ArchaeologistReset)
    Events.UnitMovementPointsCleared.Add(ArchaeologistReset)
    Events.UnitMovementPointsRestored.Add(ArchaeologistReset)
    Events.UnitAbilityLost.Add(ArchaeologistReset)
    ----------------------------------------------------------------
    Events.PhaseBegin.Add(ArchaeologistOnPhaseBegin)
    ----------------------------------------------------------------
    print('GreatPersonTeleport_UI Initial success!')
end

Initialize()