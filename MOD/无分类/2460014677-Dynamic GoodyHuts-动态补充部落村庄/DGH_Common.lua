-- =======================================================================
-- Common helper functions to be used by other files.
-- =======================================================================
include "MapUtilities"

Utils = {}

Utils.PlaceGoodyHut = function(aPositions)
    local NO_PLAYER = -1
    local aShuffledPositions = GetShuffledCopyOfTable(aPositions)
    -- print(aShuffledPositions)
    local improvement = GameInfo.Improvements['IMPROVEMENT_GOODY_HUT']
    if improvement ~= nil then
        local improvementID = improvement.RowId - 1
        for i, pos in ipairs(aShuffledPositions) do
            local plot = Map.GetPlotByIndex(pos)
            local x = plot:GetX()
            local y = plot:GetY()
            local bGoody = CanPlaceGoodyAt(improvement, plot)
            if bGoody then
                ImprovementBuilder.SetImprovementType(plot, improvementID, NO_PLAYER)
                print('New DynamicGoodyHut placed at', x, y)
                return {x = x, y = y}
            end
        end
    end
    return nil
end

Utils.SetPlayerProperty = function(playerID, key, value)
    local player = Players[playerID]
    player:SetProperty(key, value)
end

Utils.SetGameProperty = function(key, value)
    Game.SetProperty(key, value)
end

ExposedMembers.DGH = ExposedMembers.DGH or {}
ExposedMembers.DGH.Utils = Utils
