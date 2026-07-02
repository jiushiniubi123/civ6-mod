-- AWAW_NORESTART
-- Author: Awase
-- DateCreated: 1/28/2026 3:23:38 PM
--------------------------------------------------------------

function Unlock_Heroes_OnStart()
    if Game.GetProperty("AWAW_MOD_HERO_UNLOCK_EXECUTED") == 1 then return end

    local bHasHeroClasses = false
    for _ in GameInfo.HeroClasses() do
        bHasHeroClasses = true
        break
    end
    if not bHasHeroClasses then return end

    -- 获取所有人类玩家
    local tHumanIDs = {}
    for _, id in ipairs(PlayerManager.GetAliveMajorIDs()) do
        if Players[id]:IsHuman() then
            table.insert(tHumanIDs, id)
        end
    end

    if #tHumanIDs == 0 then return end

-- 获取玩家选择
local configValues = GameConfiguration.GetValue("AWAW_START_HEROES_SELECTED")

if configValues and #configValues > 0 then
    local hManager = Game.GetHeroesManager()

    for _, heroClassType in ipairs(configValues) do            
        local heroClassInfo = GameInfo.HeroClasses[heroClassType]
        if heroClassInfo then
            local heroIndex = heroClassInfo.Index
            for _, playerID in ipairs(tHumanIDs) do
                local pPlayer = Players[playerID]
                if pPlayer then
                    hManager:SetHeroDiscovered(playerID, heroIndex, true)
                end
            end
        end
    end
end

-- ===== 新增：强制解锁固定英雄 =====
local hManager = Game.GetHeroesManager()  -- 如果上面没拿到，再拿一次
local fixedHeroes = {
    "HEROCLASS_HERCULES",
    "HEROCLASS_HIMIKO",
    "HEROCLASS_BEOWULF"
}

for _, heroClassType in ipairs(fixedHeroes) do
    local heroClassInfo = GameInfo.HeroClasses[heroClassType]
    if heroClassInfo then
        local heroIndex = heroClassInfo.Index
        for _, playerID in ipairs(tHumanIDs) do
            local pPlayer = Players[playerID]
            if pPlayer then
                hManager:SetHeroDiscovered(playerID, heroIndex, true)
            end
        end
    end
end
-- ===================================

    Game.SetProperty("AWAW_MOD_HERO_UNLOCK_EXECUTED", 1)
end

Events.LoadGameViewStateDone.Add(Unlock_Heroes_OnStart)

