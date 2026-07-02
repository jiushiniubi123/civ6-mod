-- Start Bias Solver (constraint satisfier) for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_StartBiasAnalyzer"
include "GotLakes_Utils"

-- Region interest score multiplier for each bias tier.
-- Powers of 10 for simplicity
-- and to ensure that lower tier generally trumps higher tier.
-- Start with 2 so that Tier 5 always trumps an unbiased player.
local interestTierMults = {20000, 2000, 200, 20, 2};

-- Limit on the number of guesses for constraint satisfaction backtracking
-- to avoid extremely long run times for huge maps.
--
-- Recommended setings to exercise backtracking:
--   Ruleset: GS
--   Map Size: Tiny
--   Major Civs: Netherlands, Mali, Canada, Russia
--   Landmass: Continents
--   Extras: None
--   World Wrap, Climate Wrap: Globe
--   Climate, Biome, Sunlight, Icy Poles: Standard
local MAX_NUM_GUESSES = 10000;

-- Possible values for assignAll param.
local ASSIGN_ONE = false;
local ASSIGN_ALL = true;

local BIAS_UNWANTED  = 0.5;
local BIAS_SATISFIED = 0.75;
local BIAS_UNBIASED  = 1;

function CompareBiases(a,b)
	-- Comparator for sorting biases.
    -- Avoid ties to prevent MP desyncs.
	if (a.bias == b.bias) then
		-- Use unbiased fertility as a tie-breaker (descending order).
        if (a.fert == b.fert) then
            -- Fall-back to region ID (ascending order)
            if ((a.regionId == nil) or (a.regionId == b.regionId)) then
                -- Region ID is missing or both objects have the same region ID.
                if ((a.playerId == nil) or (a.playerId == b.playerId)) then
                    -- Somehow a and b are identical.
                    return false;
                end
                -- Fall-back to player ID (ascending order)
                return a.playerId < b.playerId;
            else
                return a.regionId < b.regionId;
            end
        end
		return a.fert > b.fert;
	end
	return a.bias > b.bias;
end

GotLakes_StartBiasSolver = {};

function GotLakes_StartBiasSolver.Create(
	analyzer, regionData, regionAssignList, divMethod, isMinor, startOnWater, logLevel)
	-- Constructor.
	-- Args:
	--   analyzer: start bias analyzer to inject
	--   regionData: info about each region
	--   regionAssignList: regions sorted by fertility
	--   divMethod: method used for dividing the world into regions
	--   isMinor: whether to assign city states (true) or major civs (false).
	--   startOnWater: whether players to assign start on water (true) or land (false).
	--   logLevel: level at which to log additional debug messages
	
	local iW, iH, numTiles = GetMapGridSize();
	
	local logLevel = logLevel or LogLevels.INFO;
	local analyzer = analyzer or GotLakes_StartBiasAnalyzer.Create(false);
		
	local instance = 
	{
		-- Methods
		AddPlayers             = GotLakes_StartBiasSolver.AddPlayers,
		BiasPrint		       = GotLakes_StartBiasSolver.BiasPrint,
		BiasPrintBiases	       = GotLakes_StartBiasSolver.BiasPrintBiases,
		SolveArbitrarily       = GotLakes_StartBiasSolver.SolveArbitrarily,
		GetBiases              = GotLakes_StartBiasSolver.GetBiases,
		GetBiasesByPlayer      = GotLakes_StartBiasSolver.GetBiasesByPlayer,
		GetBiasesByRegion      = GotLakes_StartBiasSolver.GetBiasesByRegion,
		GetFertility           = GotLakes_StartBiasSolver.GetFertility,
		GetTopBiases           = GotLakes_StartBiasSolver.GetTopBiases,
		ScanRegionsForBias     = GotLakes_StartBiasSolver.ScanRegionsForBias,
		FixUnbiasedPlayers     = GotLakes_StartBiasSolver.FixUnbiasedPlayers,
		FixUnwantedRegions     = GotLakes_StartBiasSolver.FixUnwantedRegions,
		IsSolvable             = GotLakes_StartBiasSolver.IsSolvable,
		SolvePlayer            = GotLakes_StartBiasSolver.SolvePlayer,
		FindConstrainedPlayer  = GotLakes_StartBiasSolver.FindConstrainedPlayer,
		FindConstrainedRegion  = GotLakes_StartBiasSolver.FindConstrainedRegion,
		FindMaxBias      	   = GotLakes_StartBiasSolver.FindMaxBias,
		GetSnapshot            = GotLakes_StartBiasSolver.GetSnapshot,
		Solve                  = GotLakes_StartBiasSolver.Solve,
		AssignPlayersToRegions = GotLakes_StartBiasSolver.AssignPlayersToRegions,
		
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles,
		
		-- Args
		logLevel         = logLevel,
		isMinor          = isMinor,
		regionAssignList = regionAssignList,
		divMethod        = divMethod,
		regionData       = regionData,
		startOnWater     = startOnWater,
		
		-- Helper utils
		analyzer = analyzer,
		
		-- State
		players         = {}, -- List of player IDs
		playersBiased   = {}, -- List of biased players.
		playersUnbiased = {}, -- List of IDs of unbiased players.
		numExtraRegions = #regionAssignList, -- Number of regions that we don't need to assign.
	};
	
	instance:AddPlayers();
	
	return instance;
end

function GotLakes_StartBiasSolver:AddPlayers()
	local playerIds = {};
	
	if self.isMinor then
		-- All minor civs.
		playerIds = PlayerManager.GetAliveMinorIDs();
	else
		local allMajorIds = PlayerManager.GetAliveMajorIDs();
		
		if self.startOnWater then
			-- Isolate the water players.
			local numMajorCivsTotal = PlayerManager.GetAliveMajorsCount();
			for i = 1, numMajorCivsTotal do
				local majorCiv = allMajorIds[i];
				local leaderType = PlayerConfigurations[majorCiv]:GetLeaderTypeName();
				if ((GameInfo.Leaders_XP2 ~= nil) and 
					(GameInfo.Leaders_XP2[leaderType] ~= nil) and 
					(GameInfo.Leaders_XP2[leaderType].OceanStart == true)) then
					table.insert(playerIds, majorCiv);
				end
			end
		else
			-- All major civs.
			playerIds = allMajorIds;
		end
	end
	
	-- Shuffle players to avoid player-order bias.
	self.players = GetShuffledCopyOfTable(playerIds);
	
	self.numExtraRegions = self.numExtraRegions - #playerIds;
	
	self:BiasPrint(LogLevels.INFO, "Got " .. tostring(#playerIds) .. " players and " ..
				   self.numExtraRegions .. " extra region(s).");
end

function GotLakes_StartBiasSolver:BiasPrint(level, str)
	-- Master-switch wrapper to enable/disable printing debug messages to console.
	-- Because this class could potentially spew a lot of debug messages.
	if level <= self.logLevel then
		print(NonNilStr(str));
	end
end

function GotLakes_StartBiasSolver:BiasPrintBiases(level, biases)
	-- Print a list of {reginId, playerId, bias, fert} biases.
	for i, biasInfo in ipairs(biases) do
		self:BiasPrint(level, "Region #" .. biasInfo.regionId .. 
			  " + Player #" .. biasInfo.playerId ..
			  " => [Bias " .. biasInfo.bias .. ", Fert " .. biasInfo.fert .. "] (" .. 
			  PlayerConfigurations[biasInfo.playerId]:GetCivilizationTypeName() ..
			  ")");
	end
end

function GotLakes_StartBiasSolver:SolveArbitrarily()
	-- Simply loop through players and arbitrarily assign a region.
	-- Returns: a list of {playerId, regionId} tuples.
	local assignments = {};
	for i = 1, #self.players do
		table.insert(assignments, 
			{playerId=self.players[i], regionId=self.regionAssignList[i].regionId});
	end
	return assignments;
end

function GotLakes_StartBiasSolver:GetBiases(biasesByPlayer, unassignedPlayers)
	-- Recompute table of {playerId, regionId, bias} based on biases by player
	-- Args:
	--   biasesByPlayer: map of players to {regionId, bias, fert} tuples
	--   unassignedPlayers: optional list of unassigned player IDs to include
	-- Returns: a list of {playerId, regionId, bias, fert}
	local biases = {};
	
	for playerId, playerBiases in SortedPairs(biasesByPlayer) do
		for i, playerBiasInfo in ipairs(playerBiases) do
			if (((not unassignedPlayers) or (unassignedPlayers[playerId])) and
				(playerBiasInfo.bias > 0)) then
				table.insert(biases, {
					playerId=playerId, 
					regionId=playerBiasInfo.regionId,
					bias=playerBiasInfo.bias,
					fert=playerBiasInfo.fert});
			end
		end
	end
	
	-- Sort by descending order of bias
	table.sort(biases, CompareBiases);
	return biases;
end

function GotLakes_StartBiasSolver:GetBiasesByPlayer(biasesByRegion, unassignedRegions)
	-- Recompute biases by player based on biases by region
	local biasesByPlayer = {};
	
	for regionId, regionBiases in SortedPairs(biasesByRegion) do
		if ((not unassignedRegions) or (unassignedRegions[regionId])) then
			for i, regionBiasInfo in ipairs(regionBiases) do
				local playerId = regionBiasInfo.playerId;
				local playerBiases = biasesByPlayer[regionBiasInfo.playerId];
				if not playerBiases then
					playerBiases = {};
					biasesByPlayer[regionBiasInfo.playerId] = playerBiases;
				end
				if (regionBiasInfo.bias > 0) then
					table.insert(playerBiases, 
					{
						regionId=regionId, 
						bias=regionBiasInfo.bias,
						fert=regionBiasInfo.fert,
					});
				end
			end
		end
	end
	
	-- Sort by descending order of bias
	for playerId, playerBiases in SortedPairs(biasesByPlayer) do
		table.sort(playerBiases, CompareBiases);
	end
	
	return biasesByPlayer;
end

function GotLakes_StartBiasSolver:GetBiasesByRegion(biasesByPlayer, unassignedPlayers)
	-- Recompute biases by region based on biases by player
	local biasesByRegion = {};
	
	for playerId, playerBiases in SortedPairs(biasesByPlayer) do
		if ((not unassignedPlayers) or (unassignedPlayers[playerId])) then
			for i, playerBiasInfo in ipairs(playerBiases) do
				local regionBiases = biasesByRegion[playerBiasInfo.regionId];
				if not regionBiases then
					regionBiases = {};
					biasesByRegion[playerBiasInfo.regionId] = regionBiases;
				end
				if (playerBiasInfo.bias > 0) then
					table.insert(regionBiases, 
					{
						playerId=playerId,
						bias=playerBiasInfo.bias,
						fert=playerBiasInfo.fert,
					});
				end
			end
		end
	end
	
	-- Sort by descending order of bias
	for regionId, regionBiases in SortedPairs(biasesByRegion) do
		table.sort(regionBiases, CompareBiases);
	end
	
	return biasesByRegion;
end

function GotLakes_StartBiasSolver:GetFertility(regionId)
	return self.regionData[regionId][6];
end

function GotLakes_StartBiasSolver:GetTopBiases(
	biasesByPlayer, unassignedPlayers, numBiasesToGet)
	-- Recompute table of top {playerId, regionId, bias} based on biases by player.
	-- Intended for logging/debugging.
	-- Args:
	--   biasesByPlayer: map of players to {regionId, bias, fert} tuples
	--   unassignedPlayers: optional list of unassigned player IDs to include
	--   numBiasesToGet: upper bound on size of biases to return
	-- Returns: a truncated list of {playerId, regionId, bias, fert}
	local numBiasesToGet = numBiasesToGet or #self.players;

	local biases = self:GetBiases(biasesByPlayer, unassignedPlayers);
	
	if (numBiasesToGet >= #biases) then
		return biases;
	end
	
	local topBiases = {};
	for i = 1, numBiasesToGet do
		table.insert(topBiases, biases[i]);
	end
	return topBiases;
end

function GotLakes_StartBiasSolver:ScanRegionsForBias()
	-- Determine each player's interest in each region.
	--
	-- Returns:
	--   biasesByPlayer: a map of player ID to lists of {regionId, bias, fert}
	--   biasesByRegion: a map of region ID to lists of {playerId, bias, fert}
	
	-- Map of region ID to {playerId, bias, fert}.
	local biasesByRegion = {};
	self:BiasPrint(LogLevels.INFO, "Scanning regions for biases...");
	for iRegion, region in ipairs(self.regionAssignList) do
		local regionId = region.regionId;
		local regionData = self.regionData[regionId];
		
		local iWestX = regionData[1];
		local iSouthY = regionData[2];
		local iWidth = regionData[3];
		local iHeight = regionData[4];
		local iAreaID = regionData[5];
		
		-- Use unbiased fertility as a tie-breaker.
		local fertility = regionData[6];
		
		local regionMaxBias = 0;
		local regionBiases = {};
				
		-- Calculate each biased player's interest in the region.
		for iPlayer = 1, #self.playersBiased do
			local playerId = self.playersBiased[iPlayer];			
			local bias = 0;
			-- When handling global plot indices, process Y first.
			for region_y = 0, iHeight - 1 do 
				for region_x = 0, iWidth - 1 do
					-- Actual coords, adjusted for world wrap, if any.
					local x = (region_x + iWestX) % self.iW; 
					local y = (region_y + iSouthY) % self.iH;
					local plot = Map.GetPlot(x, y);
					local area_of_plot = plot:GetArea():GetID();
					
					-- Include impassable plots so that we can count things like mountains.
					if (plot:IsImpassable() or 
					    (area_of_plot == iAreaID) or 
						(iAreaID == -1)) then
						-- Plot is either impassable or a member of the region.
						bias = bias + self.analyzer:GetBiasAtPlot(
							plot, playerId, interestTierMults);
					end
				end
			end			
			if (bias > 0) then
				table.insert(regionBiases, {playerId=playerId, bias=bias, fert=fertility});
			end
		end
		
		-- Give each unbiased player an interest of 1 for the region.
		for iPlayer = 1, #self.playersUnbiased do
			local playerId = self.playersUnbiased[iPlayer];
			table.insert(regionBiases, {playerId=playerId, bias=BIAS_UNBIASED, fert=fertility});
		end
		
		if (#regionBiases > 0) then
			-- Sort region biases by descending order of bias
			table.sort(regionBiases, CompareBiases);
			biasesByRegion[regionId] = regionBiases;
		end
	end
	
	--[[
	-- Fake bias table for testing backtracking. Requires 4 players and 4 regions.
	local region1 = self.regionAssignList[1].regionId;
	local region2 = self.regionAssignList[2].regionId;
	local region3 = self.regionAssignList[3].regionId;
	local region4 = self.regionAssignList[4].regionId;
	local player1 = self.players[1];
	local player2 = self.players[2];
	local player3 = self.players[3];
	local player4 = self.players[4];
	-- Initially no players or regions are constrained.
	-- But after guessing that player 1 takes region 1,
	-- then players 2 and 3 will both want only region 2,
	-- resulting in an unsolvable guess that requires backtracking.
	-- Expected solution:
	--   p1 -> r3
	--   p2 -> r2
	--   p3 -> r1
	--   p4 -> r4
	biasesByRegion = 
	{
		[region1] = 
		{
			{playerId=player1, bias=35, fert=1},
			{playerId=player2, bias=25, fert=1},
			{playerId=player3, bias=15, fert=1},
		},
		[region2] = 
		{
			{playerId=player2, bias=30, fert=1},
			{playerId=player1, bias=20, fert=1},
			{playerId=player3, bias=10, fert=1},
		},
		[region3] = 
		{
			{playerId=player1, bias=5, fert=1},
			{playerId=player4, bias=4, fert=1},
		},
		[region4] = 
		{
			{playerId=player4, bias=3, fert=1},
			{playerId=player1, bias=2, fert=1},
		},
	};
	--]]
	
	-- Map of player ID to {regionId, bias}.
	local biasesByPlayer = self:GetBiasesByPlayer(biasesByRegion);
	return biasesByPlayer, biasesByRegion;
end

function GotLakes_StartBiasSolver:FixUnbiasedPlayers(
	biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions)
	-- Ensure that every player has at least one region bias.
	-- Args
	--   biasesByPlayer: already filtered to unassigned players
	--   biasesByRegion: map of region IDs to {playerId, bias}
	--   unassignedPlayers: list of unassigned player IDs
	--   unassignedRegions: list of unassigned region IDs
	
	-- Check for biased players that have no preferred region.
	local recomputeRegionBiases = false;
	for playerId, isUnassigned in SortedPairs(unassignedPlayers) do		
		if (not biasesByPlayer[playerId]) then
			self:BiasPrint(LogLevels.FINE, "Player #" .. playerId .. 
						   " doesn't like any regions and is effectively unbiased.");
			
			-- Set all of the player's biases as if the player were unbiased.
			local playerBiases = {};
			for regionId, regionBiases in SortedPairs(unassignedRegions) do
				table.insert(playerBiases, 
					{regionId=regionId, bias=BIAS_UNWANTED, fert=self:GetFertility(regionId)});
			end
			biasesByPlayer[playerId] = playerBiases;
			recomputeRegionBiases = true;
		end
	end
	
	if recomputeRegionBiases then
		-- Recompute biases by region and update state.
		biasesByRegion = self:GetBiasesByRegion(biasesByPlayer, unassignedPlayers);
	end
	
	return biasesByPlayer, biasesByRegion;
end

function GotLakes_StartBiasSolver:FixUnwantedRegions(
	biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions)
	-- Ensure that we don't have an excess of unassigned regions.

	-- Keep track of any players that we assign to an unwanted region
	-- to avoid assigning the same player multiple times.
	local assignedPlayers = {};
	
	local unwantedRegions = Queue:Create();
	
	for regionId, isUnassigned in SortedPairs(unassignedRegions) do
		if (not biasesByRegion[regionId]) then
			-- Found an unwanted region.
			unwantedRegions:Enqueue(regionId);
		end
	end
		
	while unwantedRegions:Size() > self.numExtraRegions do
		local regionId = unwantedRegions:Dequeue();
		-- Find the player with the lowest max bias.
		-- That is, the player who would be least disappointed with the unwanted region.
		local minMaxBias = math.huge;
		local minMaxBiasPlayerId = nil;
		for playerId, isUnassigned in SortedPairs(unassignedPlayers) do
			if (not assignedPlayers[playerId]) then
				-- Taking advantage of player-biases sort order (descending order by bias).
				local playerMaxBias = biasesByPlayer[playerId][1].bias;
				if playerMaxBias < minMaxBias then
					minMaxBias = playerMaxBias;
					minMaxBiasPlayerId = playerId;
				end
			end
		end
		self:BiasPrint(LogLevels.FINE, "Nobody wants region #" .. regionId .. 
					   "; assigning to player #" .. minMaxBiasPlayerId);
		
		local oldPlayerBiases = biasesByPlayer[minMaxBiasPlayerId];
		biasesByPlayer[minMaxBiasPlayerId] = 
			{{regionId=regionId, bias=BIAS_UNWANTED,fert=self:GetFertility(regionId)}};
		assignedPlayers[minMaxBiasPlayerId] = true;
		
		-- Recompute biases by region.
		biasesByRegion = self:GetBiasesByRegion(biasesByPlayer, unassignedPlayers);

		-- Check the player's old biases for new unwanted regions.		
		for i, biasInfo in ipairs(oldPlayerBiases) do
			local otherRegionId = biasInfo.regionId;
			if ((otherRegionId ~= regionId) and
				(not biasesByRegion[otherRegionId])) then
				-- Another region has become unwanted as a result of
				-- assigning a player to an unwanted region.
				unwantedRegions:Enqueue(otherRegionId);
			end
		end
	end
	return biasesByPlayer, biasesByRegion;
end

function GotLakes_StartBiasSolver:IsSolvable(
	biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions)
	-- Check whether the problem space allows for a 1-1 mapping of players to regions.
	for playerId, isUnassigned in SortedPairs(unassignedPlayers) do		
		if (not biasesByPlayer[playerId]) then
			self:BiasPrint(LogLevels.FINE,
				"Player #" .. playerId .. " doesn't like any remaining regions.");
			return false;
		end
	end
	local numUnwantedRegions = 0;
	for regionId, isUnassigned in SortedPairs(unassignedRegions) do
		if (not biasesByRegion[regionId]) then
			numUnwantedRegions = numUnwantedRegions + 1;
		end
	end
	if (numUnwantedRegions > self.numExtraRegions) then
		self:BiasPrint(LogLevels.FINE,
			"Found " .. numUnwantedRegions .. " region(s) unwanted by remaining players.");
		return false;
	end
	
	return true;
end

function GotLakes_StartBiasSolver:SolvePlayer(
	assignment, assignments, biasesByPlayer, unassignedPlayers, unassignedRegions)
	-- Update biases to reflect a newly-solved player.
	-- Args:
	--   assignment: {playerId, regionId, bias} tuple representing newly-solved player
	--   assignments: list of assignments to update
	--   biasesByPlayer: map of player to region bias tuples
	--   unassignedPlayers: list of unassigned player IDs
	--   unassignedRegions: list of unassigned region IDs
	-- Returns:
	--   biasesByPlayer: recomputed
	--   biasesByRegion: recomputed
	local playerId = assignment.playerId;
	local regionId = assignment.regionId;
	
	-- Update unassigned players and regions.
	unassignedPlayers[playerId] = nil;
	unassignedRegions[regionId] = nil;
	
	-- Update assignments.
	table.insert(assignments, 
		{
			playerId = playerId,
			regionId = regionId,
			bias     = assignment.bias,
			fert     = self:GetFertility(regionId)
		});
	
	-- Recompute biases by region.
	local biasesByRegion = self:GetBiasesByRegion(biasesByPlayer, unassignedPlayers);
	
	-- Remove interest from other players in the region.
	biasesByRegion[regionId] = nil;
	
	-- Recompute biases by player.
	return self:GetBiasesByPlayer(biasesByRegion, unassignedRegions), biasesByRegion;
end

function GotLakes_StartBiasSolver:FindConstrainedPlayer(biasesByPlayer)
	-- Find a player that wants exactly one region.
	-- Args:
	--   biasesByPlayer: map of players to {regionId, bias, fert}
	-- Returns:
	--   {playerId, regionId, bias, fert} or nil	
	for playerId, playerBiases in SortedPairs(biasesByPlayer) do
		if (#playerBiases == 1) then
			local biasInfo = playerBiases[1];
			self:BiasPrint(LogLevels.FINE, "Found a constrained player.");
			return {
				playerId = playerId,
				regionId = biasInfo.regionId,
				bias     = biasInfo.bias,
				fert     = biasInfo.fert
			};
		end
	end
	
	-- No constrained players.
	return nil;
end

function GotLakes_StartBiasSolver:FindConstrainedRegion(biasesByRegion, numRemainingPlayers)
	-- Find a region that exactly one player wants.
	-- Args:
	--   biasesByRegion: map of regions to {playerId, bias, fert}
	--   numRemainingPlayers: number of players that haven't yet been assigned a region.
	-- Returns:
	--   {playerId, regionId, bias, fert} or nil    
    local numRegions = 0;
    for regionId, regionBiases in SortedPairs(biasesByRegion) do
		if (#regionBiases > 0) then
			numRegions = numRegions + 1;
            if (numRegions > numRemainingPlayers) then
                -- We have extra regions (more regions available than unassigned players).
                return nil;
            end
		end
	end
	
	for regionId, regionBiases in SortedPairs(biasesByRegion) do
		if (#regionBiases == 1) then
			local biasInfo = regionBiases[1];
			self:BiasPrint(LogLevels.FINE, "Found a constrained region.");
			return {
				playerId = biasInfo.playerId,
				regionId = regionId,
				bias     = biasInfo.bias,
				fert     = biasInfo.fert
			};
		end
	end
	
	-- No constrained regions.
	return nil;
end

function GotLakes_StartBiasSolver:FindMaxBias(
	biasesByPlayer, unassignedPlayers, unassignedRegions)
	-- Find the player-region combo with the highest bias 
	-- Args:
	--   biasesByPlayer: map of players to {regionId, bias, fert}
	--   unassignedPlayers: set of playerIds indicating which players still need a region.
	--   unassignedRegions
	-- Returns:
	--   {playerId, regionId, bias, fert}
	local biases = self:GetBiases(biasesByPlayer, unassignedPlayers);
	for i, biasInfo in ipairs(biases) do
		local playerId = biasInfo.playerId;
		local regionId = biasInfo.regionId;
		if (unassignedPlayers[playerId] and unassignedRegions[regionId]) then
			return {
				playerId = playerId,
				regionId = biasInfo.regionId,
				bias     = biasInfo.bias,
				fert     = biasInfo.fert
			};
		end
	end
	
	-- Somehow failed to assign a player.
	print("Failed to find a player using max bias.");
	return {playerId=1, regionId=1, bias=BIAS_UNWANTED, fert=1};
end

function GotLakes_StartBiasSolver:GetSnapshot(
	assignments, biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions, guess)
	-- Clone the entire problem space.
	
	local newAssignments = {};
	for i, assignment in ipairs(assignments) do
		table.insert(newAssignments, 
			{
				playerId = assignment.playerId,
				regionId = assignment.regionId,
				bias     = assignment.bias,
				fert     = assignment.fert
			});
	end
	
	local newBiasesByPlayer = self:GetBiasesByPlayer(biasesByRegion, unassignedRegions);
	local newBiasesByRegion = self:GetBiasesByRegion(biasesByPlayer, unassignedPlayers);
	
	local newUnassignedPlayers = {};
	for playerId, isUnassigned in SortedPairs(unassignedPlayers) do
		newUnassignedPlayers[playerId] = isUnassigned;
	end
	
	local newUnassignedRegions = {};
	for regionId, isUnassigned in SortedPairs(unassignedRegions) do
		newUnassignedRegions[regionId] = isUnassigned;
	end
	
	local newGuess = 
	{
		playerId = guess.playerId,
		regionId = guess.regionId,
		bias     = guess.bias,
		fert     = guess.fert
	};
	
	local snapshot =
	{
		assignments       = newAssignments,
		biasesByPlayer    = newBiasesByPlayer,
		biasesByRegion    = newBiasesByRegion,
		unassignedPlayers = newUnassignedPlayers,
		unassignedRegions = newUnassignedRegions,
		guess             = newGuess
	};
	return snapshot
end

function GotLakes_StartBiasSolver:Solve()
	-- Solve the start-biased region assignment problem.
	-- Returns: a list of {playerId, regionId} tuples.
	
	-- Analyze regions to determine player preferences.
	local biasesByPlayer, biasesByRegion = self:ScanRegionsForBias();
	
	-- Create a set of remaining players to assign.
	local unassignedPlayers = {};
	for i, playerId in ipairs(self.players) do
		unassignedPlayers[playerId] = true;
	end
	
	-- Create a set of remaining regions to assign.
	local unassignedRegions = {};
	for i, region in ipairs(self.regionAssignList) do
		unassignedRegions[region.regionId] = true;
	end
	
	local numPlayers = #self.players;
	local assignments = {};

	local numIterations = 0;
	local numGuesses = 0;
    local numBacktracks = 0;
	
	--[ Initial Table of {regionId, playerId, bias, fert} objects for debugging.
	self:BiasPrint(LogLevels.FINE, "Initial Biases:");
	self:BiasPrintBiases(LogLevels.FINE, self:GetBiases(biasesByPlayer, unassignedPlayers));
	--]
	
	-- Initialize solution snapshot stack for backtracking.
	--  {assignments, biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions, guess}
	local snapshots = Stack:Create();
	
	while (#assignments < numPlayers) do
		numIterations = numIterations + 1;

		--[ Truncated Table of {regionId, playerId, bias, fert} objects for debugging.
		if (numIterations > 1) then
			self:BiasPrint(LogLevels.FINE, "Top Biases at guess #" .. numGuesses .. 
						   ", iteration #" .. numIterations .. ":");
			self:BiasPrintBiases(
				LogLevels.FINE, self:GetTopBiases(biasesByPlayer, unassignedPlayers));
		end
		--]

		local solvable = true;

		if snapshots:IsEmpty() then
			-- Unable to backtrack.
			-- Fix biases so that the problem is solvable.
			biasesByPlayer, biasesByRegion = self:FixUnbiasedPlayers(
				biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions);

			if (#self.playersUnbiased == 0) then
				biasesByPlayer, biasesByRegion = self:FixUnwantedRegions(
					biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions);
			end
		else
			solvable = self:IsSolvable(
				biasesByPlayer, biasesByRegion, unassignedPlayers, unassignedRegions);
		end
		
		if solvable then
			-- Look for an arleady-constrained players or region.
			local assignment = nil;
			local numRemainingPlayers = numPlayers - #assignments;
			
			if (numRemainingPlayers <= 1) then
				-- Only one player left to assign. Pick the player's favorite remaining region.
				self:BiasPrint(LogLevels.FINE, "One player remains.");
				assignment = 
					self:FindMaxBias(biasesByPlayer, unassignedPlayers, unassignedRegions);
			else
				assignment = self:FindConstrainedPlayer(biasesByPlayer) or 
							 self:FindConstrainedRegion(biasesByRegion, numRemainingPlayers);
			end
			
			if assignment then
				self:BiasPrint(LogLevels.FINE, 
					"Constrained assignment: player #" .. assignment.playerId ..
					", region #" .. assignment.regionId .. 
					", bias " .. assignment.bias ..
					", fert " .. assignment.fert);
			else
				-- No obvious choices, so choose the combo with the highest bias.
				assignment = self:FindMaxBias(
					biasesByPlayer, unassignedPlayers, unassignedRegions);
					
				if (numGuesses < MAX_NUM_GUESSES) then
					-- This is a guess, so push a copy of the problem space to the stack
					-- in case this renders the rest of the problem unsolvable.
					numGuesses = numGuesses + 1;
					self:BiasPrint(LogLevels.FINE, "Guess #" .. numGuesses .. 
								   ": player #" .. assignment.playerId ..
								   ", region #" .. assignment.regionId .. 
								   ", bias " .. assignment.bias ..
							       ", fert " .. assignment.fert);
								   
					-- Push current state to the stack.
					snapshots:Push(self:GetSnapshot(
						assignments,
						biasesByPlayer,
						biasesByRegion,
						unassignedPlayers,
						unassignedRegions,
						assignment));
				end
			end
			
			-- Apply the assignment / guess.
			biasesByPlayer, biasesByRegion = self:SolvePlayer(
				assignment, assignments, biasesByPlayer, unassignedPlayers, unassignedRegions);
		else
            numBacktracks = numBacktracks + 1;
        
			-- Restore state from before we applied the guess.
			local snapshot = snapshots:Pop();
			assignments       = snapshot.assignments;
			biasesByPlayer    = snapshot.biasesByPlayer;
			biasesByRegion    = snapshot.biasesByRegion;
			unassignedPlayers = snapshot.unassignedPlayers;
			unassignedRegions = snapshot.unassignedRegions;

			-- Rule-out the guess.
			local guess = snapshot.guess;
			self:BiasPrint(LogLevels.FINE, 
				"Solution is no longer solvable. Backtracking from player #" ..	guess.playerId ..
				", region #" .. guess.regionId .. 
				", bias " .. guess.bias ..
				", fert " .. guess.fert);
			for i, playerBias in ipairs(biasesByPlayer[guess.playerId]) do
				if (playerBias.regionId == guess.regionId) then
					playerBias.bias = 0;
					break;
				end
			end
			biasesByRegion = self:GetBiasesByRegion(biasesByPlayer, unassignedPlayers);
			biasesByPlayer = self:GetBiasesByPlayer(biasesByRegion, unassignedRegions);
		end
	end
	
	local numPlayersSatisfied = 0;
	for i, assignment in ipairs(assignments) do
		if (assignment.bias > BIAS_SATISFIED) then
			numPlayersSatisfied = numPlayersSatisfied + 1;
		end
	end	
	self:BiasPrint(LogLevels.INFO,
		"Solved with " .. tostring(numPlayersSatisfied) .. " of " .. tostring(numPlayers) ..
		" players satisfied after " .. numIterations .. " iterations, " ..
		numGuesses .. " guess(es), and " .. numBacktracks .. " backtrack(s)!");
	
	return assignments;
end

function GotLakes_StartBiasSolver:AssignPlayersToRegions()
	-- Assign each player to a region.
	-- Returns: a list of {playerId, regionId} tuples.
	local numPlayers = #self.players;		
	if (numPlayers > #self.regionAssignList) then
		self:BiasPrint(LogLevels.ERROR,	"Got " .. numPlayers .. " players but only " .. 
			#self.regionAssignList .. " region(s)...");
		return self:SolveArbitrarily();
	end
	
	if self.startOnWater then
		self:BiasPrint(LogLevels.INFO,
			"Water civs have no bias; assigning players to regions arbitrarily.");
		return self:SolveArbitrarily();
	end
	
	if (self.divMethod == DIVMETHOD_NONE) then
		self:BiasPrint(LogLevels.INFO,
			"The world was not divided into regions; assigning players arbitrarily.");
		return self:SolveArbitrarily();
	end
	
	local biased, unbiased = self.analyzer:CheckPlayers(self.players);
	if (#biased == 0) then
		self:BiasPrint(LogLevels.INFO, 
			"All civs are unbiased; assigning players to regions arbitrarily.");
		return self:SolveArbitrarily();
	end
	self.playersBiased = biased;
	self.playersUnbiased = unbiased;

	-- At least one player has start bias.
	return self:Solve();
end
