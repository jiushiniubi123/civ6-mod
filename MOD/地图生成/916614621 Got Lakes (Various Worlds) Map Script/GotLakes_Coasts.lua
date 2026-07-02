-- Coastal Expansion for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_CoastGenerator = {};

function GotLakes_CoastGenerator.Create(terrainTypes, coastPlots)
	-- Coast-Gen constructor.
	-- Args:
	--   terrainTypes: work-in-progress terrain map
	--   coastPlots: a map of plots to turn into coast
	local iW, iH, numTiles = GetMapGridSize();
	
	local coastExp  = UserInput.coastExp or CoastalExpansion.STANDARD;
	local isoCoasts = UserInput.isoCoasts;
	
	-- create instance data
	local instance = 
	{
		-- Methods
		IsShallowWater          = GotLakes_CoastGenerator.IsShallowWater,
		IsPotentialCoastBridge  = GotLakes_CoastGenerator.IsPotentialCoastBridge,
		ExpandCoastsOnce        = GotLakes_CoastGenerator.ExpandCoastsOnce,
		ExpandCoastsToEntireMap = GotLakes_CoastGenerator.ExpandCoastsToEntireMap,
		ExpandCoasts            = GotLakes_CoastGenerator.ExpandCoasts,
		
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles,
		
		-- Args
		terrainTypes = terrainTypes,
		coastPlots   = coastPlots,
		
		-- User inputs
		coastExp  = coastExp,
		isoCoasts = isoCoasts,
	};
	
	return instance;
end

function GotLakes_CoastGenerator:IsShallowWater(plot)
	-- Args:
	--   plot: the plot to check against terrain types.
	--
	-- Return true iff the plot is a shallow water tile in the terrain map.
	if (not plot) then
		-- Beyond the edge of the map: not shallow water.
		return false;
	end
	
	local i = GetPlotIndexLua(plot:GetX(), plot:GetY());
	return self.terrainTypes[i] == g_TERRAIN_TYPE_COAST;
end

function GotLakes_CoastGenerator:IsPotentialCoastBridge(x, y)
	-- Check whether the plot at {x,y} could potentially merge two regions of coastal water.
	--
	-- Args:
	--   x,y: location of the plot to check
	--
	-- Returns true iff {x,y} is surrounded by at least two
	-- distinct groups of shallow water tiles which could be connected
	-- by turning {x,y} into shallow water.
	local prevIsShallow = self:IsShallowWater(Map.GetAdjacentPlot(x, y, HexDirections[6]));
	local numDiffs = 0;
	
	for i, direction in ipairs(HexDirections) do
		local curIsShallow = self:IsShallowWater(Map.GetAdjacentPlot(x, y, direction));
		
		if (prevIsShallow ~= curIsShallow) then
			-- Coast/Non-Coast changed.
			numDiffs = numDiffs + 1;
			
			if (numDiffs > 2) then
				-- C,*,C,* or *,C,*,C pattern detected.
				-- Two distinct sets of shallow water tiles would
				-- merge if we made {x,y} a coast tile.
				--
				-- Therefore, this tile is a potential coast bridge.
				--print("Potential coast bridge detected at " .. CoordString(x,y));
				return true;
			end
		end
		
		prevIsShallow = curIsShallow;
	end
	return false;
end

function GotLakes_CoastGenerator:ExpandCoastsOnce(randMax)
	-- Apply a single pass of coastal expansion to the map.
	-- Args:
	--   randMax: max value for coastal-expansion dice (results in 1/randMax 
	--     chance of expansion to each eligible plot)
	local shallowWaterPlots = {};
	
	for iX = 0, self.iW - 1 do
		for iY = 0, self.iH - 1 do
			local index = GetPlotIndexLua(iX,iY);
			if ( (self.terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) and
				 IsAdjacentToShallowWater(self.terrainTypes, iX, iY) and 
				 (TerrainBuilder.GetRandomNumber(randMax, 
					"coastal expansion") == 0) ) then
				table.insert(shallowWaterPlots, {x = iX, y = iY});
			end
		end
	end
		
	-- Shuffle shallow water plots before checking for coastal bridges
	-- in order to avoid directional bias in coastal isolation.
	shallowWaterPlots = GetShuffledCopyOfTable(shallowWaterPlots);
	
	for i, coords in ipairs(shallowWaterPlots) do
		if not (self.isoCoasts and self:IsPotentialCoastBridge(coords.x, coords.y)) then
			self.terrainTypes[GetPlotIndexLua(coords.x,coords.y)] = g_TERRAIN_TYPE_COAST;
		end
	end
end

function GotLakes_CoastGenerator:ExpandCoastsToEntireMap(randMax)
	-- Expand coasts to the entire map.
	-- Args:
	--   randMax: max value for coastal-expansion dice (results in 1/randMax 
	--     chance of expansion to each eligible plot)
	if not self.isoCoasts then
		-- Coastal expansion with no restrictions.
		-- Just turn all ocean plots into coast.
		print("Expanding coasts to the entire map.");
		for iX = 0, self.iW - 1 do
			for iY = 0, self.iH - 1 do
				local index = GetPlotIndexLua(iX,iY);
				if (self.terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					self.terrainTypes[index] = g_TERRAIN_TYPE_COAST;
				end
			end
		end
		return;
	end
	
	print("Expanding coasts to the entire map, but maintaining coastal isolation.");

	-- Repeat the normal coastal expansion process until there is no more room to expand.
	-- This allows snaky ocean trenches to form randomly.
	local keepExpanding = true;
	local numIters = 0;
	local maxNumIters = self.numTiles * 100; -- Prevent infinite loop.
	
	-- Stop rolling dice if there are this many or fewer eligible plots
	-- for expansion (to minimize number of passes when we're almost done).
	local numPlotsToRemoveDice = math.min(10, math.ceil(self.numTiles/100));
	
	while (keepExpanding and (numIters < maxNumIters)) do
		self:ExpandCoastsOnce(randMax);

		numIters = numIters + 1;

		local numEligiblePlots = 0;
		for x = 0, self.iW - 1 do
			for y = 0, self.iH - 1 do
				local index = GetPlotIndexLua(x,y);
				
				if ((self.terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) and
					IsAdjacentToShallowWater(self.terrainTypes, x, y) and 
					(not self:IsPotentialCoastBridge(x, y))) then
					-- Found an eligible plot for expansion.
					numEligiblePlots = numEligiblePlots + 1;
				end
			end	
		end
		if ((randMax > 1) and (numEligiblePlots < numPlotsToRemoveDice)) then
			-- Looks like we're almost done or at a bottle-neck.
			-- Guarantee coastal expansion at all eligible plots
			-- so that we're not just rolling the dice.
			print("Removing randomness after " .. numIters .. 
			      " iteration(s) to expedite coastal expansion.");
			randMax = 1;
		end
		
		keepExpanding = (numEligiblePlots > 0);
	end
	
	if(numIters >= maxNumIters) then
		print("Failed to expand coasts to entire map after " .. numIters .. " iteration(s).");
	else
		print("Expanded coasts everywhere after " .. numIters .. " iteration(s).");
	end
end

function GotLakes_CoastGenerator:ExpandCoasts()
	-- Run coastal expansion.
	
	if (self.coastExp == CoastalExpansion.NONE) then
		-- Coastal expansion is disabled.
		print("Not expanding coasts.");
		return;
	end
		
	-- Chance for each eligible plot to become an expansion is 1 / randMax.
	-- Default expansion rate is three passes at 1/4 chance per eligible plot on each pass.
	local randMax = 4;
	
	if (self.coastExp == CoastalExpansion.EVERYWHERE) then
		-- Coastal expansion to the entire map.
		self:ExpandCoastsToEntireMap(randMax);
		return;
	end
	
	-- Normal coastal expansion.
	local numItersList = {0,1,2,3,5,7,50};
	local numIters = numItersList[self.coastExp] or 3;
	print("Expanding coasts " .. numIters .. " time(s)");
	
	for iI = 1, numIters do
		self:ExpandCoastsOnce(randMax);
	end
	
	-- Add coasts from the global coast map.
	local shallowWaterPlots = {};
	
	for iX = 0, self.iW - 1 do
		for iY = 0, self.iH - 1 do
			local index = GetPlotIndexLua(iX,iY);
			if ((self.terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) and 
				(self.coastPlots[index] == g_PLOT_TYPE_LAND)) then
				table.insert(shallowWaterPlots, {x = iX, y = iY});
			end
		end
	end
	
	-- Shuffle shallow water plots before checking for coastal bridges
	-- in order to avoid directional bias in coastal isolation.
	shallowWaterPlots = GetShuffledCopyOfTable(shallowWaterPlots);
	for i, coords in ipairs(shallowWaterPlots) do
		if not (self.isoCoasts and 
			    self:IsPotentialCoastBridge(coords.x, coords.y)) then
			self.terrainTypes[GetPlotIndexLua(coords.x,coords.y)] = g_TERRAIN_TYPE_COAST;
		end
	end
end
