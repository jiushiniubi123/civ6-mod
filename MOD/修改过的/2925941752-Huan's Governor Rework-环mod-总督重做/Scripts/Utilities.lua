Utilities = {};

Utilities.RemoveBuilding = function(playerID, cityID, buildingID)
    local city = CityManager.GetCity(playerID, cityID)
    if city ~= nil then
        local buildings = city:GetBuildings()
        buildings:RemoveBuilding(buildingID)
    end
end

Utilities.CreateBuilding = function(playerID, cityID, buildingID)
    local city = CityManager.GetCity(playerID, cityID)
    if city ~= nil then
        local buildingQueue = city:GetBuildQueue()
        buildingQueue:CreateBuilding(buildingID)
    end
end

Utilities.RestoreCityUnitMovement = function (playerID,cityID,theunitType)
    local pUnits = Players[playerID]:GetUnits()
    for _,pUnit in pUnits:Members() do
        local pUnitInfo = GameInfo.Units[pUnit:GetType()]
        if pUnitInfo then
            local pUnitType = pUnitInfo.UnitType
            local city = CityManager.GetCity(playerID, cityID)
            if city ~= nil then
                if (pUnitType == theunitType) and (pUnit:GetX() == city:GetX()) and (pUnit:GetY() == city:GetY()) then
                    UnitManager.RestoreMovementToFormation(pUnit)
                end
            end
        end
    end
end

Utilities.CityAttachModifier = function (playerID,cityID,modifierID)
    local city = CityManager.GetCity(playerID,cityID)
    if city ~= nil then
        city:AttachModifierByID(modifierID)
        print("it's utility ok")
    end
end




ExposedMembers.HMOD = ExposedMembers.HMOD or {};
ExposedMembers.HMOD.Utilities = Utilities;



