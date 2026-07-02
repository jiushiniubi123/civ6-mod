--------------------------------
--     Dynamic GoodyHuts      --
--------------------------------

Utils = ExposedMembers.DGH.Utils

local PROP_KEY_NUM_OF_GOODYHUTS_VISITED = 'NumOfGoodyHutsVisited'

function RevealedToPlayer(x, y, playerID)
    local playerVis = PlayerVisibilityManager.GetPlayerVisibility(playerID)
    if (playerVis ~= nil) then
        return playerVis:IsRevealed(x, y)
    end
    return false
end

function VisibleToPlayer(x, y, playerID)
    local playerVis = PlayerVisibilityManager.GetPlayerVisibility(playerID)
    if (playerVis ~= nil) then
        return playerVis:IsVisible(x, y)
    end
    return false
end

function VisibleToAnyPlayer(x, y)
    local majorList = PlayerManager.GetAliveMajorIDs()
    for _, playerIndex in ipairs(majorList) do
        if VisibleToPlayer(x, y, playerIndex) then
            return true
        end
    end
    local minorList = PlayerManager.GetAliveMinorIDs()
    for _, playerIndex in ipairs(minorList) do
        if VisibleToPlayer(x, y, playerIndex) then
            return true
        end
    end
    return false
end

function OnGoodyHutReward( ePlayer:number, unitID:number, eRewardType:number, eRewardSubType:number )
    local localPlayerID = Game.GetLocalPlayer()
    local num = (Game.GetProperty(PROP_KEY_NUM_OF_GOODYHUTS_VISITED) or 0) + 1
    print('number of goodyhuts collected', num)
    Utils.SetGameProperty(PROP_KEY_NUM_OF_GOODYHUTS_VISITED, num)
    local every = GameInfo.GlobalParameters['GENERATE_NEW_GOODY_HUTS_FOR_EVERY'].Value
    if (every == 0) or (num % every ~= 0) then
        return
    end

    local m = GameInfo.Maps[Map.GetMapSize()]
    local iW = m.GridWidth
    local iH = m.GridHeight

    -- Get all positions out of visibility.
    local iTiles = iW * iH
    local aPositions = {}
    for x = 0, iW - 1 do
        for y = 0, iH - 1 do
            local i = y * iW + x
            if not VisibleToAnyPlayer(x, y) then
                table.insert(aPositions, i)
            end
        end
    end
    local place = Utils.PlaceGoodyHut(aPositions)
    if place ~= nil then
        if RevealedToPlayer(place.x, place.y, localPlayerID) then
            local message = Locale.Lookup('LOC_NOTIFICATION_DISCOVER_GOODY_HUT_MESSAGE')
            local summary = Locale.Lookup('LOC_NOTIFICATION_DISCOVER_GOODY_HUT_SUMMARY')
            local notificationHash = GameInfo.Types['NOTIFICATION_DISCOVER_GOODY_HUT'].Hash
            NotificationManager.SendNotification(localPlayerID, notificationHash, message, summary, place.x, place.y)
        end
    end
end

Events.GoodyHutReward.Add(OnGoodyHutReward)
