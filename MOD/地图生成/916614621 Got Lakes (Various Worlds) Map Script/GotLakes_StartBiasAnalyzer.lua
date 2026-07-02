-- Start Bias Analyzer for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_StartBiasAnalyzer = {};

function GotLakes_StartBiasAnalyzer.Create(logLevel)
	-- Constructor.
	local iW, iH, numTiles = GetMapGridSize();
	local numWaterTiles = 0;
	for i = 0, numTiles -1 do
		local plot = Map.GetPlotByIndex(i);
		if plot:IsWater() then
			numWaterTiles = numWaterTiles + 1;
		end
	end
	
	local resourceTypeNames = {};
	for row in GameInfo.Resources() do
		table.insert(resourceTypeNames, row.ResourceType);
	end
	
	local logLevel = logLevel or LogLevels.INFO;
	
	-- create instance data
	local instance = 
	{
		-- Methods
		AddBias                 = GotLakes_StartBiasAnalyzer.AddBias,
		AddBiasTable            = GotLakes_StartBiasAnalyzer.AddBiasTable,
		AddBiases               = GotLakes_StartBiasAnalyzer.AddBiases,
		BiasPrint				= GotLakes_StartBiasAnalyzer.BiasPrint,
		GetCoastalLandWaterArea = GotLakes_StartBiasAnalyzer.GetCoastalLandWaterArea,
		
		-- Relevance scoring: 0 = not relevant; 1 = most relevant
		GetCoastBiasAtPlot    = GotLakes_StartBiasAnalyzer.GetCoastBiasAtPlot,
		GetFeatureBiasAtPlot  = GotLakes_StartBiasAnalyzer.GetFeatureBiasAtPlot,
		GetResourceBiasAtPlot = GotLakes_StartBiasAnalyzer.GetResourceBiasAtPlot,
		GetRiverBiasAtPlot    = GotLakes_StartBiasAnalyzer.GetRiverBiasAtPlot,
		GetTerrainBiasAtPlot  = GotLakes_StartBiasAnalyzer.GetTerrainBiasAtPlot,
		GetTierBiasAtPlot     = GotLakes_StartBiasAnalyzer.GetTierBiasAtPlot,
		GetCivBiasAtPlot      = GotLakes_StartBiasAnalyzer.GetCivBiasAtPlot,
		GetBiasAtPlot         = GotLakes_StartBiasAnalyzer.GetBiasAtPlot,
		HasBiasAtPlot         = GotLakes_StartBiasAnalyzer.HasBiasAtPlot,
		PlayerHasBias         = GotLakes_StartBiasAnalyzer.PlayerHasBias,
		CheckPlayers          = GotLakes_StartBiasAnalyzer.CheckPlayers,
	
		-- Args
		logLevel = logLevel,
	
		-- Maximum coast area to scan when determining whether a plot is
		-- relevant to a coastal-bias civ.
		-- 
		-- Must be large enough to be salt water, or a significant proportion
		-- of the world's water, whichever is bigger.
		coastMaxArea = math.max(LAKE_MAXNUMTILES+1, Round(numWaterTiles/4)),
		
		-- Map of memoized water areas to avoid excessive traversal of ocean tiles.
		waterAreas = table.fill(-1, numTiles),
		
		resourceTypeNames = resourceTypeNames,
		
		-- Mapping of civ types => bias tiers => bias info (fcn, desc)
		-- Includes both major and minor civs.
		civs = {},
	};
	
	-- Initialize biases.
	instance:AddBiases();
	
	return instance;
end

function GotLakes_StartBiasAnalyzer:AddBias(biasRow)
	-- Add a bias-check function for a specific civ, tier, and thing to check.
	-- Args:
	--   biasRow: a single row from a StartBias table.
	local civType = biasRow.CivilizationType;
	local civBiases = self.civs[civType];
	if not civBiases then
		-- Add the first bias for a civ.
		civBiases = {tiers={}};
		self.civs[civType] = civBiases;
	end
	
	local tier = biasRow.Tier;
	local tierBiases = civBiases.tiers[tier];
	if not tierBiases then
		-- Add the first bias for a civ's tier.
		tierBiases = {biases={}};
		civBiases.tiers[tier] = tierBiases;
	end
	
	-- Get corresponding bias function.
	local terrainTypeName = biasRow.TerrainType;
	local featureTypeName = biasRow.FeatureType;
	local resourceTypeName = biasRow.ResourceType;
	local biasFcn = nil;
	local biasDesc = "unknown bias";
	if (terrainTypeName ~= nil) then
		local terrainType = GetGameInfoIndex("Terrains", terrainTypeName);
		if (terrainType == nil) then
			self:BiasPrint(LogLevels.ERROR,
				terrainTypeName .. " does not exist in the current ruleset.");
			return;
		end
		if (terrainType == g_TERRAIN_TYPE_COAST) then
			biasFcn = function(plot) return self:GetCoastBiasAtPlot(plot); end;
		else
			biasFcn = function(plot)
				return self:GetTerrainBiasAtPlot(plot, terrainType); end;
		end
		biasDesc = terrainTypeName;
		
	elseif (featureTypeName ~= nil) then
		local featureType = GetGameInfoIndex("Features", featureTypeName);
		if (featureType == nil) then
			self:BiasPrint(LogLevels.ERROR,
				featureTypeName .. " does not exist in the current ruleset.");
			return;
		end
		biasFcn = function(plot) return self:GetFeatureBiasAtPlot(plot, featureType); end;
		biasDesc = featureTypeName;
		
	elseif (resourceTypeName ~= nil) then
		biasFcn = function(plot) return self:GetResourceBiasAtPlot(plot, resourceTypeName); end;
		biasDesc = resourceTypeName;
	else
		biasFcn = function(plot) return self:GetRiverBiasAtPlot(plot); end;
		biasDesc = "RIVER";
	end
	
	self:BiasPrint(LogLevels.FINER, 
		"Adding T" .. tier .. " bias towards " .. biasDesc .. " for " .. civType);
	table.insert(tierBiases.biases, {fcn=biasFcn, desc=biasDesc});
end

function GotLakes_StartBiasAnalyzer:AddBiasTable(biasTable)
	if biasTable ~= nil then
		for row in biasTable do
			self:AddBias(row);
		end
	end
end

function GotLakes_StartBiasAnalyzer:AddBiases()
	-- Add biases for all civs
	self:AddBiasTable(GameInfo.StartBiasResources());
	self:AddBiasTable(GameInfo.StartBiasFeatures());
	self:AddBiasTable(GameInfo.StartBiasTerrains());
	self:AddBiasTable(GameInfo.StartBiasRivers());
end

function GotLakes_StartBiasAnalyzer:BiasPrint(level, str)
	-- Master-switch wrapper to enable/disable printing debug messages to console.
	-- Because this class could potentially spew a lot of debug messages.
	if level <= self.logLevel then
		print(NonNilStr(str));
	end
end

function GotLakes_StartBiasAnalyzer:GetCoastalLandWaterArea(plot)
	-- Get the maximum of a land plot's adjacent passable water areas.
	-- If the plot to check is water, then just get that plot's passable water area.
	--
	-- Intended for checking whether a land plot is relevant to coastal civ bias.
	if ((not plot) or plot:IsWater()) then
		return 0;
	end
	
	-- Determine the largest amount of nearby water to the plot.
	local waterArea = 0;
	for i, direction in ipairs(HexDirections) do
		local adjPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		waterArea = math.max(waterArea, 
			GetPassableWaterArea(adjPlot, self.coastMaxArea, self.waterAreas));
	end
	return waterArea;
end

function GotLakes_StartBiasAnalyzer:GetCoastBiasAtPlot(plot)
	-- Args:
	--   plot: the non-nil plot to measure.
	--
	-- Return: relevance score

	-- Determine the largest amount of nearby water to the plot.
	local waterArea = self:GetCoastalLandWaterArea(plot);
	
	if (waterArea >= self.coastMaxArea) then
		-- Coastal land with access to a plenty of water.
		return 1;
	end
	
	if (waterArea > LAKE_MAXNUMTILES) then
		-- Coastal land with access to some water (barely salty lakes that contain ice don't count).
		return 0.25;
	end
	
	-- No significant coast nearby.
	return 0;
end

function GotLakes_StartBiasAnalyzer:GetFeatureBiasAtPlot(plot, featureType)
	-- Args:
	--   plot: the non-nil plot to measure.
	--   featureType: the non-nil type of feature to check for
	--
	-- Return: relevance score	
	if (plot:GetFeatureType() == featureType) then
		return 1;
	end
	return 0;
end

function GotLakes_StartBiasAnalyzer:GetResourceBiasAtPlot(plot, resourceTypeName)
	-- Args:
	--   plot: the non-nil plot to measure.
	--   resourceTypeName: non-nil name of the type of resource to check for
	--
	-- Return: relevance score		
	if (self.resourceTypeNames[plot:GetResourceType()+1] == resourceTypeName) then
		return 1;
	end
	return 0;
end

function GotLakes_StartBiasAnalyzer:GetRiverBiasAtPlot(plot)
	-- Args:
	--   plot: the non-nil plot to measure.
	--
	-- Return: relevance score
	if plot:IsRiver() then
		-- Low score because GL already emphasizes rivers when placing all civs.
		-- But not too low or else T5 multiplier will round down to 0.
		return 0.5;
	end
	return 0;
end

function GotLakes_StartBiasAnalyzer:GetTerrainBiasAtPlot(plot, terrainType)
	-- Args:
	--   plot: the non-nil plot to measure.
	--   terrainType: the non-nil land terrain type to check for
	--
	-- Return: relevance score
	
	-- Check for exact match to specified land terrain type.
	if (plot:GetTerrainType() == terrainType) then
		return 1;
	end
	return 0;
end

function GotLakes_StartBiasAnalyzer:GetTierBiasAtPlot(plot, tierInfo)
	-- Args:
	--   plot: which non-nil plot to check
	--   tierInfo: bias functions for a civ's tier.
	--
	-- Return: aggregate relevance score		
	local relevance = 0;
	for i, biasInfo in ipairs(tierInfo.biases) do
		local bias = biasInfo.fcn(plot);
		self:BiasPrint(LogLevels.FINEST, "    " .. biasInfo.desc .. " => " .. bias);
		relevance = relevance + bias;
	end
	return relevance;
end

function GotLakes_StartBiasAnalyzer:GetCivBiasAtPlot(plot, civInfo, tierMults)
	-- Args:
	--   plot: which non-nil plot to check
	--   civInfo: bias functions for a civ.
	--   tierMults: multipliers to use when aggregating tiers
	--
	-- Return: aggregate relevance score		
	local relevance = 0;
	for tier, tierInfo in SortedPairs(civInfo.tiers) do
		self:BiasPrint(LogLevels.FINEST, "  Tier " .. tier);
		relevance = relevance + (tierMults[tier] * self:GetTierBiasAtPlot(plot, tierInfo));
	end
	
	return Round(relevance);
end

function GotLakes_StartBiasAnalyzer:GetBiasAtPlot(plot, playerIndex, tierMults)
	-- Args:
	--   plot: which plot to check
	--   playerIndex: which player to check
	--   tierMults: multipliers to use when aggregating tiers
	--
	-- Return: aggregate relevance score
	if (not plot) then
		-- Beyond the edge of the map.
		return 0;
	end
	
	local playerCfg = PlayerConfigurations[playerIndex];
	if (playerCfg == nil) then
		self:BiasPrint(LogLevels.ERROR,
			"Player index " .. tostring(playerIndex) .. " has no corresponding player config.");
		return 0;
	end
	
	if not self:PlayerHasBias(playerIndex) then
		self:BiasPrint(LogLevels.FINEST, "Player " .. tostring(playerIndex) .. 
					   " of civ " .. tostring(playerCfg:GetCivilizationTypeName()) .. " is unbiased.");
		return 0;
	end
	
	local civType = playerCfg:GetCivilizationTypeName();
	local civInfo = self.civs[civType];
	self:BiasPrint(LogLevels.FINEST,
				   "Checking bias for player " .. playerIndex .. " (" .. civType .. ") at " ..
				   CoordString(plot:GetX(),plot:GetY()) .. "...");
	
	return self:GetCivBiasAtPlot(plot, civInfo, tierMults);
end

function GotLakes_StartBiasAnalyzer:HasBiasAtPlot(plot, playerIndex, tierMults)
	-- Args:
	--   plot: which plot to check
	--   playerIndex: which player to check
	--   tierMults: multipliers to use when aggregating tiers
	--
	-- Return: true iff the player has nonzero bias at this plot
	return self:GetBiasAtPlot(plot, playerIndex, tierMults) > 0;
end

function GotLakes_StartBiasAnalyzer:PlayerHasBias(playerIndex)
	-- Args:
	--   playerIndex: which player to check
	--
	-- Return: true iff the player has at least one start bias.	
	local playerCfg = PlayerConfigurations[playerIndex];
	if (playerCfg == nil) then
		print("Player index " .. tostring(playerIndex) .. " has no corresponding player config.");
		return false;
	end
	return self.civs[playerCfg:GetCivilizationTypeName()] ~= nil;
end

function GotLakes_StartBiasAnalyzer:CheckPlayers(playerIndices)
	-- Args:
	--   playerIndices: which players to check
	--
	-- Return:
	--   biased: a list of players that have at least one start bias.
	--   unbiased: a list of unbiased players.
	local biased = {};
	local unbiased = {};
	
	for i = 1, #playerIndices do
		local playerId = playerIndices[i];
		if self:PlayerHasBias(playerId) then
			table.insert(biased, playerId);
		else
			table.insert(unbiased, playerId);		
		end
	end
	
	return biased, unbiased;
end
