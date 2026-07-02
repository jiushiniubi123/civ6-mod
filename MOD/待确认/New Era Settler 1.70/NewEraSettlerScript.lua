-- New Era Settler -- 1.70
-- Author: Das_Capitolin --
----------------------------------------------------------------------------------------------------
	-- Grants player a settler when they enter a new era.
local function GrantSettlerEachEra(playerID, eraID)
    print("[New Era Settler] PlayerEraChanged: " .. tostring(playerID) .. ", era=" .. tostring(eraID));
    local player = Players[playerID];
    if player == nil then return end
    if player.IsAlive == nil or not player:IsAlive() then return end
    if player.IsMajor == nil or not player:IsMajor() then return end
    if player.GetCities == nil then return end
    local cities = player:GetCities();
    if cities == nil or cities.GetCapitalCity == nil then return end
    local capitalCity = cities:GetCapitalCity();
    if capitalCity == nil then return end
    if capitalCity.GetX == nil or capitalCity.GetY == nil then return end
    local x = capitalCity:GetX();
    local y = capitalCity:GetY();
    if UnitManager ~= nil and UnitManager.InitUnit ~= nil then
        UnitManager.InitUnit(playerID, "UNIT_SETTLER", x, y);
        print("[New Era Settler] Granted Settler to player " .. tostring(playerID));
    else
        print("[New Era Settler] ERROR: UnitManager.InitUnit unavailable.");
    end
end
if Events ~= nil and Events.PlayerEraChanged ~= nil and Events.PlayerEraChanged.Add ~= nil then
    Events.PlayerEraChanged.Add(GrantSettlerEachEra);
    print("[New Era Settler] PlayerEraChanged handler registered.");
end