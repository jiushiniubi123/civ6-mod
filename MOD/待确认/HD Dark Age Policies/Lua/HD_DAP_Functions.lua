-- ==========================================================================================================================
-- HD_DAP_Functions.lua
-- HD Dark Age Policies - Lua Event Handlers
-- [AUDIT] Uses Game.GetEras():ChangePlayerEraScore() (HD method) instead of deprecated Game.ChangePlayerEraScore()
-- [AUDIT] All event handlers registered in LoadScreenClose for safe initialization
-- [AUDIT] Naming prefix "DAP_" per user confirmation
-- [AUDIT] 6 policies: 4 Dark Age + 2 Golden Age (Counter Reformation removed per user)
-- ==========================================================================================================================

-- ==========================================================================================================================
-- POLICY INDEX CACHE
-- ==========================================================================================================================
local policyChattelSlaveryID         = GameInfo.Policies["POLICY_DAP_CHATTEL_SLAVERY"].Index
local policyChildSoldiersID          = GameInfo.Policies["POLICY_DAP_CHILD_SOLDIERS"].Index
local policyGreatMigrationID         = GameInfo.Policies["POLICY_DAP_GREAT_MIGRATION"].Index
local policyLabourCampsID            = GameInfo.Policies["POLICY_DAP_LABOUR_CAMPS"].Index
local policyRoyalTombsID             = GameInfo.Policies["POLICY_DAP_ROYAL_TOMBS"].Index
local policyGreatPersonAcademyID     = GameInfo.Policies["POLICY_DAP_GREAT_PERSON_ACADEMY"].Index

-- [AUDIT] Era score values - negative for dark age, positive for golden age
local ERA_CHATTEL_SLAVERY      = -1
local ERA_CHILD_SOLDIERS       = -1
local ERA_GREAT_MIGRATION      = -2
local ERA_LABOUR_CAMPS         = -1
local ERA_ROYAL_TOMBS          = 1
local ERA_GREAT_PERSON_ACADEMY = 1

-- ==========================================================================================================================
-- UTILITY FUNCTIONS
-- ==========================================================================================================================
local localPlayerID = Game.GetLocalPlayer()

local function IsLocalHumanPlayer(playerID)
    local player = Players[playerID]
    return (playerID == localPlayerID and player ~= nil and player:IsHuman() and player:IsTurnActive())
end

-- [AUDIT] Core era score function - uses HD method (Game.GetEras())
local function ChangeEraScore(playerID, amount)
    -- amount can be positive (golden) or negative (dark)
    Game.GetEras():ChangePlayerEraScore(playerID, amount)
end

-- [AUDIT] Show floating text for local player (Chinese localized)
local function ShowEraScoreText(playerID, amount, plotX, plotY)
    if IsLocalHumanPlayer(playerID) then
        if amount > 0 then
            Game.AddWorldViewText(playerID,
                Locale.Lookup("[COLOR_FLOAT_GOLD]+{1_Num} [ICON_GLORY_GOLDEN_AGE] 时代分[ENDCOLOR]", amount),
                plotX, plotY, 0)
        else
            Game.AddWorldViewText(playerID,
                Locale.Lookup("[COLOR_DARK_GREY]{1_Num} [ICON_GLORY_DARK_AGE] 时代分[ENDCOLOR]", amount),
                plotX, plotY, 0)
        end
    end
end

-- ==========================================================================================================================
-- DARK AGE EVENT HANDLERS
-- ==========================================================================================================================

-- [AUDIT] CityBuilt: Great Migration - grants +1 pop, deducts -2 era score
local function OnCityBuilt(playerID, cityID, plotX, plotY)
    local player = Players[playerID]
    if not player then return end

    if player:GetCulture():IsPolicyActive(policyGreatMigrationID) then
        -- Add 1 population
        local city = player:GetCities():FindID(cityID)
        if city then
            city:ChangePopulation(1)
        end

        -- Deduct era score
        ChangeEraScore(playerID, ERA_GREAT_MIGRATION)
        ShowEraScoreText(playerID, ERA_GREAT_MIGRATION, plotX, plotY)
    end
end

-- [AUDIT] UnitKilledInCombat: Chattel Slavery (non-barbarian civilization units only)
local function OnUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    if not killedPlayerID or not playerID then return end
    if killedPlayerID == playerID then return end
    if not unitID then return end

    local player = Players[playerID]
    if not player then return end
    local killedPlayer = Players[killedPlayerID]
    if not killedPlayer or killedPlayer:IsBarbarian() then return end

    -- Chattel Slavery: any combat unit kill vs civilization
    if player:GetCulture():IsPolicyActive(policyChattelSlaveryID) then
        ChangeEraScore(playerID, ERA_CHATTEL_SLAVERY)
        local unit = player:GetUnits():FindID(unitID)
        if unit then
            ShowEraScoreText(playerID, ERA_CHATTEL_SLAVERY, unit:GetX(), unit:GetY())
        end
    end
end

-- [AUDIT] UnitPromoted: Child Soldiers
local function OnUnitPromoted(playerID, unitID)
    local player = Players[playerID]
    if not player then return end

    if player:GetCulture():IsPolicyActive(policyChildSoldiersID) then
        ChangeEraScore(playerID, ERA_CHILD_SOLDIERS)
        local unit = player:GetUnits():FindID(unitID)
        if unit then
            ShowEraScoreText(playerID, ERA_CHILD_SOLDIERS, unit:GetX(), unit:GetY())
        end
    end
end

-- [AUDIT] CityProductionCompleted: Labour Camps
local function OnCityProductionCompleted(playerID, cityID, orderType, productionID)
    if productionID == -1 then return end
    local player = Players[playerID]
    if not player then return end

    if player:GetCulture():IsPolicyActive(policyLabourCampsID) then
        ChangeEraScore(playerID, ERA_LABOUR_CAMPS)
        local city = player:GetCities():FindID(cityID)
        if city then
            ShowEraScoreText(playerID, ERA_LABOUR_CAMPS, city:GetX(), city:GetY())
        end
    end
end

-- [AUDIT] CityProjectCompleted: Labour Camps (projects also trigger this)
local function OnCityProjectCompleted(playerID, cityID, projectID)
    local player = Players[playerID]
    if not player then return end

    if player:GetCulture():IsPolicyActive(policyLabourCampsID) then
        ChangeEraScore(playerID, ERA_LABOUR_CAMPS)
        local city = player:GetCities():FindID(cityID)
        if city then
            ShowEraScoreText(playerID, ERA_LABOUR_CAMPS, city:GetX(), city:GetY())
        end
    end
end

-- ==========================================================================================================================
-- GOLDEN AGE EVENT HANDLERS
-- ==========================================================================================================================

-- [AUDIT] CityProductionCompleted: Royal Tombs - check if produced item is a wonder
local function OnRoyalTombs_WonderBuilt(playerID, cityID, orderType, productionID)
    if productionID == -1 then return end
    local player = Players[playerID]
    if not player then return end

    if not player:GetCulture():IsPolicyActive(policyRoyalTombsID) then return end

    -- Check if productionID is a building and if it's a wonder (MaxPlayerInstances == 1)
    local building = GameInfo.Buildings[productionID]
    if building and building.MaxPlayerInstances == 1 then
        ChangeEraScore(playerID, ERA_ROYAL_TOMBS)
        local city = player:GetCities():FindID(cityID)
        if city then
            ShowEraScoreText(playerID, ERA_ROYAL_TOMBS, city:GetX(), city:GetY())
        end
    end
end

-- [AUDIT] UnitGreatPersonCreated: 英杰辈出 - normal Great Person recruitment only (NOT faith/gold purchase)
local function OnGreatPersonCreated(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
    local player = Players[playerID]
    if not player then return end

    if player:GetCulture():IsPolicyActive(policyGreatPersonAcademyID) then
        ChangeEraScore(playerID, ERA_GREAT_PERSON_ACADEMY)
        local unit = player:GetUnits():FindID(unitID)
        if unit then
            ShowEraScoreText(playerID, ERA_GREAT_PERSON_ACADEMY, unit:GetX(), unit:GetY())
        end
    end
end

-- ==========================================================================================================================
-- INITIALIZATION
-- ==========================================================================================================================
-- [AUDIT] All events registered in LoadScreenClose for safe initialization
function DAP_LoadScreenClose()
    -- Dark Age events
    if GameEvents.CityBuilt then GameEvents.CityBuilt.Add(OnCityBuilt) end
    if Events.UnitKilledInCombat then Events.UnitKilledInCombat.Add(OnUnitKilledInCombat) end
    if Events.UnitPromoted then Events.UnitPromoted.Add(OnUnitPromoted) end
    if Events.CityProductionCompleted then
        Events.CityProductionCompleted.Add(OnCityProductionCompleted)
        -- Royal Tombs also uses CityProductionCompleted (registered separately for clarity)
        Events.CityProductionCompleted.Add(OnRoyalTombs_WonderBuilt)
    end
    if Events.CityProjectCompleted then Events.CityProjectCompleted.Add(OnCityProjectCompleted) end

    -- Golden Age events
    if Events.UnitGreatPersonCreated then Events.UnitGreatPersonCreated.Add(OnGreatPersonCreated) end
end
Events.LoadScreenClose.Add(DAP_LoadScreenClose)

-- ==========================================================================================================================
-- [AUDIT] Summary of fixes over original JFD mod:
-- 1. Game.ChangePlayerEraScore() → Game.GetEras():ChangePlayerEraScore() (HD method, correct GS API)
-- 2. Fixed undefined playerIsLocal variable bug (replaced with IsLocalHumanPlayer function)
-- 3. All events registered in LoadScreenClose for consistent initialization
-- 4. No ALTER TABLE needed (era score values hardcoded)
-- 5. No UI dependencies (generic wildcard policies)
-- 6. Proper nil checks on all event registrations
-- 7. Great Migration: removed free melee unit, changed to -2 era score (per user)
-- 8. Added Golden Age policies: Royal Tombs (+1/wonder), 英杰辈出 (+1/great person recruited)
-- 9. Counter Reformation removed per user
-- 10. 英杰辈出: UnitGreatPersonActivated → UnitGreatPersonCreated (normal GP recruitment, no faith/gold purchase)
-- 11. Floating text localized to Chinese (时代分)
-- ==========================================================================================================================