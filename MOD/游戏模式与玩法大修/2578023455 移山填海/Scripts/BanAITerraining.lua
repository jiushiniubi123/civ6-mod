-- BanAITerraining
-- Author: Luximinous
-- DateCreated: 7/27/2024 3:24:26 PM
--------------------------------------------------------------

local terrainingUnits = { "UNIT_YUGONG", "UNIT_JINGWEI", "UNIT_TIAN_KUN_HAO" }
local enableAITerraining = GameConfiguration.GetValue("CONFIG_YAJ_AVAILABLE_FOR_AI");

function banTerrainingUnits(player, bDisabled)
	
	for k, v in pairs(terrainingUnits) do
		local m_iUnitIndex = GameInfo.Units[v].Index
		player:GetUnits():SetBuildDisabled(m_iUnitIndex, bDisabled);
	end
end

local function onBanTerrainingUnits(playerID)
	local pPlayer = Players[playerID];
	print("YAJ_Conf onBanTerrainingUnits: playerID = ", playerID);
	if not pPlayer:IsHuman() then
		local playerCfg = PlayerConfigurations[playerID]
		local leaderType = playerCfg:GetLeaderTypeName()
		local civType = playerCfg:GetCivilizationTypeName()
		print("BanAITerraining: forbidding AI player from building Terraining Unit: Leader = ", leaderType, ", Civ = ", civType);
		banTerrainingUnits(pPlayer, 1);
	end
end

function OnLoadScreenClose()
	
	if enableAITerraining==0 then
		print("YAJ_Conf OnLoadScreenClose: enableAITerraining = ", enableAITerraining);
		for k, v in pairs(PlayerManager.GetWasEverAliveIDs()) do
			onBanTerrainingUnits(v);
		end
	end
end

function DebugWonderMountainSQL()
	print("YAJ_Conf: WonderValidTerrain Expansion Debug Print.");
	for cc_row in GameInfo.YAJLandTerrainClasses() do
        print("YAJLandTerrainClasses: " .. cc_row.TerrainClassName .. " : " .. cc_row.TerrainType)
    end
	for cc_row in GameInfo.YAJMountainWonders() do
        print("YAJMountainWonders: " .. cc_row.BuildingType .. " : " .. tostring(cc_row.AdjacentToMountain))
    end
	for cc_row in GameInfo.YAJWonderValidTerrains() do
        print("YAJWonderValidTerrains: " .. cc_row.BuildingType .. " : " .. cc_row.TerrainType .. " : " .. cc_row.TerrainClassName)
    end
end

-- Event registration
local function Initialize()
	print( " ################ Start Initializing <BanAITerraining> Gameplay Script... ################ " );
	Events.LoadScreenClose.Add(OnLoadScreenClose);

	if enableAITerraining == nil then
		-- Set default state to 1
		enableAITerraining = true
	end
	print("YAJ_Conf: enableAITerraining = ", enableAITerraining);
	if enableAITerraining==0 or enableAITerraining == false then
		GameEvents.PlayerTurnStarted.Add(onBanTerrainingUnits);
	end
	-- Enable to print WondeTerrainRegister for debug
	--DebugWonderMountainSQL();
	print( " ################ End Initializing <BanAITerraining> Gameplay Script... ################ " );
end
Initialize();

