-- Common Utilities for Got Lakes Map Script and its helper LUA files.
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "MapEnums"
include "MapUtilities"
------------------------------------------------------------------------------
-- Common utilities for Got Lakes and its helper LUA files.
-- These utils are decoupled from GL global state.
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Constants - Map Traversal
------------------------------------------------------------------------------
-- Directions for traversing to a hex tile's neighbors.
--
-- For some reason, DirectionTypes becomes undefined
-- after hard-killing WB, so for easier debugging let's
-- use internally-defined constants instead.
DIRECTION_NE = 0;
DIRECTION_E  = 1;
DIRECTION_SE = 2;
DIRECTION_SW = 3;
DIRECTION_W  = 4;
DIRECTION_NW = 5;

-- All six plot adjacency directions in a table for convenience.
HexDirections = 
{
	DIRECTION_NE, 
	DIRECTION_E, 
	DIRECTION_SE, 
	DIRECTION_SW, 
	DIRECTION_W, 
	DIRECTION_NW
};

-- Directions for flowing rivers between tiles.
FlowDirections = 
{
	FlowDirectionTypes.FLOWDIRECTION_NORTH,
	FlowDirectionTypes.FLOWDIRECTION_NORTHEAST,
	FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST,
	FlowDirectionTypes.FLOWDIRECTION_SOUTH,
	FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST,
	FlowDirectionTypes.FLOWDIRECTION_NORTHWEST
};
------------------------------------------------------------------------------
-- Constants - Non-Tunable
------------------------------------------------------------------------------
-- Common arrays for mapping user inputs to offsets.
DOWN_TO_UP = {-1, 0,  1};
UP_TO_DOWN = { 1, 0, -1};

DOWN_TO_UP2 = {-2, -1, 0,  1,  2};
UP_TO_DOWN2 = { 2,  1, 0, -1, -2};

-- Trig constants
TAU = 2*math.pi;

-- Possible values for donut fillings.
FILLING_NO  = 0; -- Ignored by donut filling algos
FILLING_YES = 1; -- Special donut plot

-- Possible values for the circumnavigation ice channels map.
CIRCUMNAV_ALLOW_ICE   = 0;
CIRCUMNAV_PREVENT_ICE = 1; 

-- Bounds for fractal granularity.
FRACTAL_MAX_GRAIN = 5; -- any higher causes bad height fields.

-- The maximum number of tiles that a fresh-water lake can have.
-- Any bigger and the lake becomes a salt-water ocean.
LAKE_MAXNUMTILES = 9;

-- Possible values for the startOnWater arg.
ASP_START_ON_LAND  = false;
ASP_START_ON_WATER = true;

-- Possible values for the isMinor arg.
ASP_START_MAJOR = false;
ASP_START_MINOR = true;

ASP_NO_FALLBACKS     = false;
ASP_ENABLE_FALLBACKS = true;

ASP_NO_FORCED_STARTS     = false;
ASP_ENABLE_FORCED_STARTS = true;

-- Regional division methods.
DIVMETHOD_BIGGEST  = 1;
DIVMETHOD_STANDARD = 2;
DIVMETHOD_SEPARATE = 3;
DIVMETHOD_NONE     = 4;

-- Debug logging levels
LogLevels = 
{ 
	ERROR  = 1,
	WARN   = 2,
	INFO   = 3,
	FINE   = 4,
	FINER  = 5,
	FINEST = 6
};

-- Tundra floodplains from JNR's Wetlands (with HD disabled)
g_FEATURE_FLOODPLAINS_TUNDRA = GetGameInfoIndex("Features", "FEATURE_FLOODPLAINS_TUNDRA");

-- Swamp from Harmony in Diversity (with JNR's Wetlands enabled)
g_FEATURE_HD_SWAMP = GetGameInfoIndex("Features", "FEATURE_HD_SWAMP");

-- Savannah from JNR's Savannah
g_FEATURE_JNR_SAVANNAH = GetGameInfoIndex("Features", "FEATURE_JNR_SAVANNAH");

-- Fungal forests feature from Ophidy's Fungalfield Biome (requires GS).
g_FEATURE_OPH_FUNGAL_FOREST = GetGameInfoIndex("Features", "FEATURE_OPH_FUNGAL_FOREST");

-- Kelp forests feature from Sukritact's Oceans.
g_FEATURE_SUK_KELP = GetGameInfoIndex("Features", "FEATURE_SUK_KELP");

------------------------------------------------------------------------------
-- Data structures
------------------------------------------------------------------------------
Queue = {}

function Queue:Create()
	local queue = {first = 0, last = -1};
	setmetatable(queue, self);
	self.__index = self;
    return queue;
end

function Queue:IsEmpty()
    return self.first > self.last;
end

function Queue:Peek()
    return self[self.first];
end

function Queue:Size()
    return self.last - self.first + 1;
end

function Queue:Enqueue(item)
	local last = self.last + 1;
	self.last = last;
	self[last] = item;
end

function Queue:Dequeue()
    local first = self.first
	if self:IsEmpty() then error("Attempt to remove from an empty queue") end
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1;
	return value;
end

Stack = {}

function Stack:Create()
    local stack = {}
    setmetatable(stack, self)
    self.__index = self
    return stack
end

function Stack:IsEmpty()
    return #self == 0
end

function Stack:Peek()
    return self[#self]
end

function Stack:Pop()
    return table.remove(self)
end

function Stack:Push(item)
    table.insert(self, item)
end

function Stack:Size()
    return #self;
end

------------------------------------------------------------------------------
-- Utilities
------------------------------------------------------------------------------
function AnalyzeLandmass()
	-- Calculate debug stats for land/water plots
	local iW, iH, numTiles = GetMapGridSize();
	local countWater = 0;
	local countDeep  = 0;
	local countMtn   = 0;
	local countHill  = 0;
	local countFlat  = 0;
	
	-- Histogram of non-mountain land tiles
	local adjMntHist = {0, 0, 0, 0, 0, 0, 0};
    
	local countLake  = 0;
    local countRiver = 0;
    local countFresh = 0;
    local countSalty = 0;
    local countDry   = 0;
	
	-- Compute a histogram of plot types.
	for y = 0, iH - 1, 1 do
		for x = 0, iW - 1, 1 do
			local plot = Map.GetPlot(x, y);
			
			if not plot:GetTerrainType() then
				print("No terrain at " .. CoordString(x,y));
			end
			
			if(plot:IsWater()) then
				countWater = countWater + 1;
				if(plot:GetTerrainType() == g_TERRAIN_TYPE_OCEAN) then
					countDeep = countDeep + 1;
				end
            elseif (plot:IsMountain() or plot:IsImpassable()) then
				-- Treat impassable non-water tiles as mountains.
                countMtn = countMtn + 1;
            else
                -- Habitable land.
				
				-- Count the number of adjacent mountains 
				-- and update the histogram accordingly.
				local histIndex = 1 + CountAdjacentMountains(x,y);
				adjMntHist[histIndex] = adjMntHist[histIndex] + 1;
				
                -- plot type analysis
                if plot:IsHills() then
                    countHill = countHill + 1;
                else
                    countFlat = countFlat + 1;
                end
                
                -- Fresh-water availability
				local plotNearLake = IsAdjacentToLake(x,y);
				if plot:IsRiver() or plotNearLake then
					-- Access to fresh water.
					countFresh = countFresh + 1;
					
					-- It's possible for a plot to be adjacent to both river and lake.
					if plotNearLake then
						countLake = countLake + 1;
					end
					if plot:IsRiver() then
						countRiver = countRiver + 1;
					end
					
				elseif IsAdjacentToWater(x,y) then
                    -- Access to salt water only.
                    countSalty = countSalty + 1;
                else
                    -- Completely dry land.
                    countDry = countDry + 1;
                end
			end
		end
	end
	
	local countLand      = numTiles   - countWater;
	local countShallow   = countWater - countDeep;
	local countHabitable = countHill  + countFlat;
    
	print("===========================================");
	print("Landmass Analysis:");
	print("-------------------------------------------");
	print("Map Elevation:");
	print("  Mountains  ", PercentString(countMtn, numTiles));
	print("  Hills      ", PercentString(countHill, numTiles));
	print("  Flats      ", PercentString(countFlat, numTiles));
	print("  Deep       ", PercentString(countDeep, numTiles));
	print("  Shallow    ", PercentString(countShallow, numTiles));
	print("-------------------------------------------");
	print("Land Elevation:");
	print("  Mountains  ", PercentString(countMtn, countLand));
	print("  Hills      ", PercentString(countHill, countLand));
	print("  Flats      ", PercentString(countFlat, countLand));
	print("-------------------------------------------");
	print("Water Elevation:");
	print("  Deep       ", PercentString(countDeep, countWater));
	print("  Shallow    ", PercentString(countShallow, countWater));
	print("-------------------------------------------");
	print("Mountain Adjacency on Habitable Land:");
	for i, count in ipairs(adjMntHist) do
		if count > 0 then
			print("  " .. tostring(i-1) .. " Adjacent ", PercentString(count, countHabitable));
		end
	end
	print("-------------------------------------------");
	print("Water Adjacency on Habitable Land:");
	print("  Lake       ", PercentString(countLake, countHabitable));
	print("  River      ", PercentString(countRiver, countHabitable));
	print("  Fresh      ", PercentString(countFresh, countHabitable));
	print("  Salty      ", PercentString(countSalty, countHabitable));
	print("  Dry        ", PercentString(countDry, countHabitable));
	print("-------------------------------------------");
	print("Misc:");
	print("  Habitable  ", PercentString(countHabitable, numTiles));
	print("  Water      ", PercentString(countWater, numTiles));
	print("===========================================");
end

function AnalyzeClimate()
	-- Calculate debug stats for terrain and features
    -- Returns:
    --   landTerrainHist: a histogram of non-mountain land terrains
	local iW, iH = GetMapGridSize();
	
	-- Land and water for terrain/feature coverage stats.
	local countLand   = 0; -- Includes flat land and hills.
	local countWater  = 0; -- Includes ocean, coast, and lakes.
	local countMtn    = 0;
	
	-- Land terrain types.
	local countGrass  = 0;
	local countPlains = 0;
	local countDesert = 0;
	local countTundra = 0;
	local countSnow   = 0;
	
	-- Land features (not including wonders).
	local countFNone    = 0; -- Land without features.
	local countFlood    = 0;
	local countJungle   = 0;
	local countForest   = 0;
	local countOasis    = 0;
	local countMarsh    = 0;
    local countSavannah = 0;
	local countFungal   = 0;
    local countSwamp    = 0;
	local countFissure  = 0;
	local countSoil     = 0;
	
	-- Water features (not including wonders).
	local countIce  = 0;
	local countReef = 0;
	local countKelp = 0;
	
	-- Mountain features (not including wonders).
	local countVolcano = 0;
	
	-- Earth features (not including wonders)
	
	-- Compute a histogram of terrain and features
	for y = 0, iH - 1, 1 do
		for x = 0, iW - 1, 1 do
			local plot = Map.GetPlot(x, y);
			local featureType = plot:GetFeatureType();

			if plot:IsMountain() then
				-- Mountain plot.
				countMtn = countMtn + 1;
				
				if g_FEATURE_VOLCANO and
					(featureType == g_FEATURE_VOLCANO) then
					countVolcano = countVolcano + 1;
				end
				
			elseif plot:IsWater() then
				-- Water plot.
				countWater = countWater + 1;
				
				if (featureType == g_FEATURE_ICE) then
					countIce = countIce + 1;
					
				elseif g_FEATURE_REEF and (featureType == g_FEATURE_REEF) then
					countReef = countReef + 1;
					
				elseif g_FEATURE_SUK_KELP and (featureType == g_FEATURE_SUK_KELP) then
					countKelp = countKelp + 1;
				end
			else
				-- Land plot.
				countLand = countLand + 1;
			
				local terrainType = plot:GetTerrainType();

				if (IsBaseTerrainType(g_TERRAIN_TYPE_GRASS, terrainType)) then
					countGrass = countGrass + 1;
				
				elseif (IsBaseTerrainType(g_TERRAIN_TYPE_PLAINS, terrainType)) then
					countPlains = countPlains + 1;
				
				elseif (IsBaseTerrainType(g_TERRAIN_TYPE_DESERT, terrainType)) then
					countDesert = countDesert + 1;

				elseif (IsBaseTerrainType(g_TERRAIN_TYPE_TUNDRA, terrainType)) then
					countTundra = countTundra + 1;

				elseif (IsBaseTerrainType(g_TERRAIN_TYPE_SNOW, terrainType)) then
					countSnow = countSnow + 1;
				else
					print("Unexpected terrain at " .. 
					CoordString(x,y) .. ": " .. NonNilStr(terrainType));
				end
					
				if (featureType == g_FEATURE_NONE) then
					countFNone = countFNone + 1;
					
				elseif IsFloodplains(featureType) then
					countFlood = countFlood + 1;
					
				elseif (featureType == g_FEATURE_JUNGLE) then
					countJungle = countJungle + 1;
					
				elseif (featureType == g_FEATURE_FOREST) then
					countForest = countForest + 1;
					
                elseif g_FEATURE_JNR_SAVANNAH and
					(featureType == g_FEATURE_JNR_SAVANNAH) then
					countSavannah = countSavannah + 1;    
                
				elseif g_FEATURE_OPH_FUNGAL_FOREST and
					(featureType == g_FEATURE_OPH_FUNGAL_FOREST) then
					countFungal = countFungal + 1;   

				elseif (featureType == g_FEATURE_OASIS) then
					countOasis = countOasis + 1;
					
				elseif (featureType == g_FEATURE_MARSH) then
					countMarsh = countMarsh + 1;
                    
                elseif g_FEATURE_HD_SWAMP and
					(featureType == g_FEATURE_HD_SWAMP) then
					countSwamp = countSwamp + 1;
                
				elseif g_FEATURE_GEOTHERMAL_FISSURE and
					(featureType == g_FEATURE_GEOTHERMAL_FISSURE) then
					countFissure = countFissure + 1;
					
				elseif g_FEATURE_VOLCANIC_SOIL and
					(featureType == g_FEATURE_VOLCANIC_SOIL) then
					countSoil = countSoil + 1;
				end	
			end
		end
	end
	
	local countNonVolc = countMtn - countVolcano;
    
    local countWNone = countWater - countIce - countReef - countKelp;
	
	local countCold      = countTundra + countSnow;
	local countTemperate = countGrass  + countPlains;
	local countWarm      = countDesert;
	
	-- Terrain Fertility
	local countExtreme  = countSnow + countDesert;
	local countModerate = countGrass + countPlains + countTundra;
	
	-- Vegetation
	local countTrees   = countJungle + countForest + countSavannah + countFungal;
	local countWet     = countOasis  + countMarsh + countSwamp;
	local countFertile = countTrees + countWet;
	local countOther   = countLand - countTrees - countWet;

	print("===========================================");
	print("Climate Analysis:");
	print("-------------------------------------------");
	print("Land Terrain:");
	print("  Grass              ", PercentString(countGrass,	countLand));
	print("  Plains             ", PercentString(countPlains, 	countLand));
	print("  Desert             ", PercentString(countDesert, 	countLand));
	print("  Tundra             ", PercentString(countTundra, 	countLand));
	print("  Snow               ", PercentString(countSnow, 	countLand));
	print("-------------------------------------------");
	print("Land Temperature:");
	print("  Cold               ", PercentString(countCold, 	 countLand));
	print("  Temperate          ", PercentString(countTemperate, countLand));
	print("  Warm               ", PercentString(countWarm, 	 countLand));
	print("  Extreme:           ", PercentString(countExtreme,   countLand));
	print("  Moderate:          ", PercentString(countModerate,  countLand));
    if g_FEATURE_VOLCANO then
        print("-------------------------------------------");
        print("Mountain Features:");
        print("  None               ", PercentString(countNonVolc, 	countMtn));
        print("  Volcano (GS)       ", PercentString(countVolcano, 	countMtn));
    end
	print("-------------------------------------------");
	print("Land Features:");
	print("  None               ", PercentString(countFNone, 	countLand));
	print("  Floodplains        ", PercentString(countFlood, 	countLand));
	print("  Jungle             ", PercentString(countJungle, 	countLand));
	print("  Forest             ", PercentString(countForest, 	countLand));
    if g_FEATURE_JNR_SAVANNAH then
        print("  Savannah (JNR)     ", PercentString(countSavannah,	countLand));
    end
	if g_FEATURE_OPH_FUNGAL_FOREST then
        print("  Fungalfield (OPH)  ", PercentString(countFungal,	countLand));
    end
	print("  Oasis              ", PercentString(countOasis, 	countLand));
	print("  Marsh              ", PercentString(countMarsh, 	countLand));
    if g_FEATURE_HD_SWAMP then
        print("  Swamp (HD)         ", PercentString(countSwamp, 	countLand));
    end
    if g_FEATURE_GEOTHERMAL_FISSURE then
        print("  Fissures (GS)      ", PercentString(countFissure, 	countLand));
    end
    if g_FEATURE_VOLCANIC_SOIL then
        print("  Volcanic Soil (GS) ", PercentString(countSoil, 	countLand));
    end
	print("-------------------------------------------");
	print("Land Vegetation:");
	print("  Trees              ", PercentString(countTrees, 	countLand));
	print("  Wetlands           ", PercentString(countWet, 		countLand));
	print("  Fertile            ", PercentString(countFertile, 	countLand));
	print("  Other              ", PercentString(countOther, 	countLand));
	print("-------------------------------------------");
	print("Water Features:");
    print("  None               ", PercentString(countWNone, 	countWater));
	print("  Ice                ", PercentString(countIce, 		countWater));
    if g_FEATURE_SUK_KELP then
        print("  Kelp (SO)          ", PercentString(countKelp, 	countWater));
    end
    if g_FEATURE_REEF then
        print("  Reef (R&F)         ", PercentString(countReef, 	countWater));
    end
	print("===========================================");
    
    local landTerrainHist = 
    {
        terrains = { countGrass, countPlains, countDesert, countTundra, countSnow },
        total = countLand
    };

    return landTerrainHist;
end

function CheckForNilPlotTypes(plotTypes)
	-- Check for nil plots in the plot type map.
	local iW, iH = GetMapGridSize();
	for y = 0, iH - 1, 1 do
		for x = 0, iW - 1, 1 do
			local i = GetPlotIndexLua(x,y);
			local plotType = plotTypes[i];
			
			if (plotType == nil) then
				print("Nil plot type at " .. CoordString(x, y));
				-- Treat nil plots as ocean so that water-heavy maps can ignore them
				-- and land-heavy maps get extra lakes.
				plotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
end

function CompareScoredPlots(a,b)
    -- Common scored-plot comparator for NW and Resource generator overrides.
    if (a.Score == b.Score) then
        -- Use index as a tie-breaker to avoid MP desyncs.
        return a.MapIndex < b.MapIndex;
    end
    return a.Score > b.Score;
end

function CoordString(x,y)
	return "(" .. x .. "," .. y .. ")";
end

function CoordStringPlot(plot)
	return CoordString(plot:GetX(),plot:GetY());
end

function CountAdjacent(x, y, PlotConditionFcn)
	-- Count the number of plots adjacent to (x,y) that pass the specified condition.
	local count = 0;
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if ((adjacentPlot ~= nil) and PlotConditionFcn(adjacentPlot)) then
			count = count + 1;
		end
	end
	return count;
end

function CountAdjacentLakes(x,y)
	return CountAdjacent(x, y, function(plot) return plot:IsLake(); end);
end

function CountAdjacentMountains(x,y)
	return CountAdjacent(x, y, function(plot) return plot:IsMountain(); end);
end

function CountAdjacentPassable(x,y)
	return CountAdjacent(x, y, IsPassable);
end

function CountAdjacentPassableLand(x,y)
	return CountAdjacent(x, y, IsPassableLand);
end

function CountAdjacentPassableOceans(x,y)
	return CountAdjacent(x, y, IsPassableOcean);
end

function CountAdjacentVolcanoes(x,y)
	return CountAdjacent(x, y, function(plot) return IsVolcano(plot); end);
end

function Count(PlotConditionFcn)
	-- Count the number of plots on the map that pass the specified condition.
    local iW, iH, numTiles = GetMapGridSize();
    local count = 0;
	for i = 0, numTiles - 1 do
        if PlotConditionFcn(Map.GetPlotByIndex(i)) then
            count = count + 1;
        end
    end
    return count;
end

function CountMountains()
	return Count(function(plot) return plot:IsMountain(); end);
end

function CountWater()
	return Count(function(plot) return plot:IsWater(); end);
end

function CreateLandBridge(plotTypes, visited, iX, iY, lakeSizeMax, waterArea)
	-- Create a random path of land (or random land/sea) from one edge of the
	-- lake to another.
	--
	-- Args: 
	--   plotTypes: map of plot types
	--   visited: map indicating which tiles are part of the lake.
	--   iX, iY: where to begin the land bridge
	--   lakeSizeMax: the maximum number of water tiles to allow in the lake
	--     at the specified location; must be >= 9
	--   waterArea: the number of water tiles in the lake.
	--
	-- Returns:
	--   landBridgeSize: the number of tiles turned into land.
	
	--print("Creating a land bridge at " .. CoordString(iX, iY));	
	if (IsStrait(plotTypes, iX, iY)) then
		--print("Land bridge complete (single-tile bridge).");
		plotTypes[GetPlotIndexLua(iX, iY)] = g_PLOT_TYPE_LAND;
		return 1;
	end
	
	-- Use this value in the visited map to indicate land near the 
	local waterUnvisited = 1;
	local pathVisited    = 2;
	
	-- Scan the starting point's neighbors for adjacent lake-edges
	-- so that we don't simply walk along the lake's edge.
	local prevPlot    = Map.GetAdjacentPlot(iX, iY, HexDirections[6]);
	local prevIsWater = IsWater(plotTypes, prevPlot);
	for i, direction in ipairs(HexDirections) do
		local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
		
		local curIsWater = IsWater(plotTypes, adjacentPlot);
		
		if (curIsWater ~= prevIsWater) then
			-- Water next to land.
			local waterPlot = adjacentPlot;
			if (curIsWater == false) then
				waterPlot = prevPlot;
			end
			
			local aX, aY = waterPlot:GetX(), waterPlot:GetY();
			local iCouldVisit = GetPlotIndexLua(aX, aY);
			
			-- Mark plot as visited so that the path
			-- avoids the lake's edge.
			visited[iCouldVisit] = pathVisited;
			--print("Avoiding plot at " .. CoordString(aX,aY));
		end
		
		prevIsWater = curIsWater;
		prevPlot    = adjacentPlot;
	end
	
	local x = iX;
	local y = iY;
	
	local landBridgeSize = 0;
	local prevDirectionIndex = nil;
	
	while (waterArea > lakeSizeMax) do
	
		waterArea = waterArea - 1;
	
		iVisited = GetPlotIndexLua(x, y);
		visited[iVisited]   = pathVisited;
		
		plotTypes[iVisited] = g_PLOT_TYPE_LAND;
		
		landBridgeSize = landBridgeSize + 1;
		
		if (waterArea <= lakeSizeMax) then
			-- Check water area before exploring neighbors.
			--print("Land bridge complete: lake is now fresh.");
			return landBridgeSize;
		end
		
		if (IsStrait(plotTypes, x, y)) then
			-- We successfully crossed the lake.
			--print("Land bridge complete: lake divided.");
			return landBridgeSize;
		end
		
		-- Search for neighbors that could extend the path.
		local adjacentCoords = {};
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited water.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
				
				if (visited[iCouldVisit] == waterUnvisited) then
					-- Unvisited water.
					table.insert(adjacentCoords, {iDir=i,x=aX,y=aY});
				end
			end
		end
		
		local numCoords = #adjacentCoords;
		if (numCoords == 0) then
			-- No way to extend the path. Not sure how we didn't notice
			-- that the prev tile was a chokepoint.
			--
			-- Maybe we tried too hard to avoid the start of the bridge.
			--print("Can't extend the path at " .. CoordString(x,y));
			return landBridgeSize;
		end
		
		local adjacentCoordsSimilarD = {};
		if (prevDirectionIndex ~= nil) then
			-- Look for adjacent coords within prevDirection +/- 1 to 
			-- straighten the land-bridge a bit.
			local dirLeft     = (prevDirectionIndex - 1) % 6;
			local dirStraight = prevDirectionIndex;
			local dirRight    = (prevDirectionIndex + 1) % 6;
			
			--print("Searching for adjacent coords in similar direction.");
			for i, coord in ipairs(adjacentCoords) do
				local iDir = coord.iDir;
				
				if ((iDir == dirLeft) or
				    (iDir == dirStraight) or
					(iDir == dirRight)) then
					table.insert(adjacentCoordsSimilarD, coord);
				end
			end
		end
		local numCoordsSimilarD = #adjacentCoordsSimilarD;
		
		if (numCoordsSimilarD > 0) then
			-- Limit selection of adjacent coords to similar direction.
			--print("Got " .. numCoordsSimilarD .. " adjacent coord(s) in similar direction.");
			adjacentCoords = adjacentCoordsSimilarD;
			numCoords      = numCoordsSimilarD;
		end

		-- Choose a random set of adjacent coords.
		local iCoord = 1 + TerrainBuilder.GetRandomNumber(numCoords, 
			"Lake Freshening: extending land bridge");
		local coord = adjacentCoords[iCoord];
		x = coord.x;
		y = coord.y;
		prevDirectionIndex = coord.iDir;

		--print("Extending land bridge to " .. CoordString(x,y));
	end
	
	--print("Land bridge complete: lake is now fresh (exited loop).");
	return landBridgeSize;
end

function DirectionString(dir)
	-- Stringify a plot direction.
	if not dir then
		return "nil";
	elseif dir == DIRECTION_NE then 
		return "NE";
	elseif dir == DIRECTION_E then 
		return "E";
	elseif dir == DIRECTION_SE then 
		return "SE";
	elseif dir == DIRECTION_SW then 
		return "SW";
	elseif dir == DIRECTION_W then 
		return "W";
	elseif dir == DIRECTION_NW then 
		return "NW";
	end
	return "unknown";
end

function Distance(x1, y1, x2, y2)
	-- Euclidian distance
	
	-- Shift x by half a plot on odd rows to account for hex grid.
	local x1 = x1;
	local x2 = x2;
	if ((y1 % 2) == 1) then
		x1 = x1 + 0.5;
	end
	
	if ((y2 % 2) == 1) then
		x2 = x2 + 0.5;
	end
	
	-- Works well for things like donut and tilted axis region.
	 return math.sqrt(((x1 - x2)*(x1 - x2)) + ((y1 - y2)*(y1 - y2)));
end

function FindWaterEdges(plotTypes, iX, iY)
	-- Traverse a lake to find all water tiles that are adjacent to at least one 
	-- land tile and at least two water tiles.
	--
	-- Args:
	--   plotTypes: map of plot types (search space)
	--   iX, iY: starting location; exclude this tile from results
	--
	-- Returns:
	--   waterEdges: a list of water tiles that are in the lake and adjacent
	--     to at least one land tile.
	--   visited: a map indicating which tiles belong to the lake.
	local iW, iH, numTiles = GetMapGridSize();

	local waterEdges = {};
	
	local visited = table.fill(0, numTiles);
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- covered all of the water tiles that share the same body of water.
	local stack = Stack:Create();
	
	local iVisited = GetPlotIndexLua(iX, iY);
	
	stack:Push({x=iX, y=iY});
	visited[iVisited] = 1;
	
	while (not stack:IsEmpty()) do
	
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		if ((x ~= iX) or (y ~= iY)) then
			-- Check neighbors for land. Ignore the starting tile.
			local isWaterEdge = false;
			local numLandNeighbors = 0;
			local numWaterNeighbors = 0;
			for i, direction in ipairs(HexDirections) do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				
				if (adjacentPlot) then
					-- We have an adjacent plot.
					-- Let's see if it's land.
					local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
					local iCouldVisit = GetPlotIndexLua(aX, aY);
				
					if (plotTypes[iCouldVisit] == g_PLOT_TYPE_OCEAN) then
						-- Got an adjacent water tile.
						numWaterNeighbors = numWaterNeighbors + 1;
					else
						-- Got an adjacent land tile.
						numLandNeighbors = numLandNeighbors + 1;
					end
				else
					-- Treat edges of the map as potential lake edges.
					numLandNeighbors = numLandNeighbors + 1;
				end
			end
			
			if (numLandNeighbors > 0) then 
				-- Next to land or map edge.
				if (((numWaterNeighbors == 2) and IsStrait(plotTypes, x, y)) or 
					(numWaterNeighbors > 2)) then
					-- Also next to at least two water tiles.
					--
					-- If next to only two water tiles, then the water tiles must be separated by land.
					--   Otherwise, it's possible that we're at the corner of a lake.
					--
					-- If next to three more more water tiles, then we can start a land bridge without
					-- simply erasing the lake's coast.
					table.insert(waterEdges, {x=x, y=y});
				end
			end
		end
		
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited water.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
			
				if ((plotTypes[iCouldVisit] == g_PLOT_TYPE_OCEAN) and 
					(visited[iCouldVisit] == 0)) then
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end

	return waterEdges, visited;
end

function FlowDirStr(flowDirection)
    -- Returns a human readable string corresponding to flow direction.
    if (not flowDirection) then
        return "null";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTH then
        return "N";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST then
        return "NE";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST then
        return "SE";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTH then
        return "S";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST then
        return "SW";
    
    elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST then
        return "NW";
    end
    return "no direction";
end

function FreshenLake(plotTypes, x, y, lakeSizeMax)
	-- Add land until the specified tile is either land or part of a 
	-- body of water that is within the maximum size.
	--
	-- Args:
	--   plotTypes: map of plot types
	--   x, y: location of a salt-water tile.
	--   lakeSizeMax: the maximum number of water tiles to allow in the lake
	--     at the specified location; must be >= 9
	local waterArea = GetWaterArea(plotTypes, x, y);
	if (waterArea <= lakeSizeMax) then
		-- Already fresh enough.
		return;
	end
		
	--print("Freshening lake at " .. CoordString(x,y) .. ": water area is " .. waterArea);
	local totalLandAdded = 0;
	
	while (waterArea > lakeSizeMax) do
	
		-- Detect all water tiles at the edge of the lake (BFS/DFS traversal).
		local waterEdges, visited = FindWaterEdges(plotTypes, x, y);
		if (not waterEdges) then
			print("Failed to compute water edges; replacing water with land at " .. 
				CoordString(x,y));
			-- The Brute-force approach: replace the salt water with land.
			local i = GetPlotIndexLua(x,y);
			plotTypes[i] = g_PLOT_TYPE_LAND;
			return;
		end

		local numWaterEdges = #waterEdges;
		if (numWaterEdges == 0) then
			print("No water edges, so replacing water with land at " .. CoordString(x,y));
			-- The Brute-force approach: replace the salt water with land.
			local i = GetPlotIndexLua(x,y);
			plotTypes[i] = g_PLOT_TYPE_LAND;
			return;
		end
		--print("Found " .. numWaterEdges .. " water edges at " .. CoordString(x,y));
		
		-- Choose an edge tile at random, but not (x,y)
		local bridgeStart = waterEdges[1 + TerrainBuilder.GetRandomNumber(numWaterEdges,
			"Lake Freshening: bridge start")];
		
		-- Draw a random path of land or maybe rand mix of land/water from
		-- the edge tile to a non-adjacent edge tile.
		local landBridgeSize = CreateLandBridge(
			plotTypes, visited, bridgeStart.x, bridgeStart.y, lakeSizeMax, waterArea);
		--print("Land bridge size: ", landBridgeSize);
		totalLandAdded = totalLandAdded + landBridgeSize;
		
		-- Repeat until (x,y) is fresh water.
		waterArea = GetWaterArea(plotTypes, x, y);
	end
	
	--print("Added " .. totalLandAdded .. " land tile(s) for freshening.");
end

function FreshenLakes(plotTypes, lakeSizeMax, verbose)
	-- Ensure that all bodies of water are within the max lake size.
	--
	-- Args:
	--   plotTypes: map to freshen
	--   lakeSizeMax: target max lake size; some lakes may become smaller
	--     than this target.
	--   verbose: enable/disable debug messages
	local iW, iH, numTiles = GetMapGridSize();

	if (verbose == true) then
		print("Freshening lakes.");
	end
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if (plotTypes[i] == g_PLOT_TYPE_OCEAN) then
				-- Check the freshness of each water tile.
				-- Add land to salt-water lakes until they are fresh.
				FreshenLake(plotTypes, x, y, lakeSizeMax);
			end
		end
	end
	
	-- Do another pass just to make sure we didn't miss any salty lakes.
	if (verbose == true) then
		print("Verifying that lakes are now fresh.");
	end
	local numBruteForceTiles = 0;
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if (plotTypes[i] == g_PLOT_TYPE_OCEAN) then
				-- Check the freshness of each water tile.
				-- Use brute-force freshening in this pass.
				if (GetWaterArea(plotTypes, x, y) > lakeSizeMax) then
					plotTypes[i] = g_PLOT_TYPE_LAND;
					numBruteForceTiles = numBruteForceTiles + 1;
				end
			end
		end
	end
	if (verbose == true) then
		if (numBruteForceTiles > 0) then
			print("Lakes are now fresh, but had to use brute force on " .. 
				numBruteForceTiles .. " tile(s).");
		else
			print("Lakes are now fresh.");
		end
	end
end

function GenerateLakesFractal(lakeLevel, lakeGrain, fracFlags)
	-- Use a lake fractal to add water to a land-heavy map.
	-- For lakes-family landmasses with global world wrap.
	--
	-- Args:
	--   lakeLevel: lake water level
	--   lakeGrain:  lake fractal granularity
	--   fracFlags:  fractal flags
	-- Returns:
	--   plotTypes: a map of generated lakes
	local iW, iH, numTiles = GetMapGridSize();
	
	local plotTypes = table.fill(g_PLOT_TYPE_LAND, numTiles);
	
	local fracXExp = -1;
	local fracYExp = -1;
	local lakesFrac = Fractal.Create(iW, iH, lakeGrain, fracFlags, fracXExp, fracYExp);
	local lakesThreshold = GetFractalHeight(lakesFrac, lakeLevel);
	
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			local lakeVal = lakesFrac:GetHeight(x, y);
			if lakeVal >= lakesThreshold then
				plotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
	return plotTypes;
end

function GetAdjacentXY(x, y, direction)
    -- Compute adjacent (x,y) coordinates for specified direction
    -- without relying on the global map.
    -- Allows for out-of-bounds coordinates.
    
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;
    
    if (direction == DIRECTION_NE) then
        return x + oddRowOffset, y + 1;
    
    elseif (direction == DIRECTION_E) then
        return x + 1, y;
        
    elseif (direction == DIRECTION_SE) then
        return x + oddRowOffset, y - 1;
        
    elseif (direction == DIRECTION_SW) then
        return x - evenRowOffset, y - 1;
        
    elseif (direction == DIRECTION_W) then
        return x - 1, y;
        
    elseif (direction == DIRECTION_NW) then
        return x - evenRowOffset, y + 1;
    end
    
    print("Invalid direction " .. tostring(direction));
    return x, y;
end

function GetConfigInfo(default, args)
	-- Apply overrides to a default config struct.
	--
	-- Args:
	--   default: a config struct which contains a default value for all 
	--     possible config fields.
	--   args: overrides to apply to the defaults; can be empty or nil
	-- Returns:
	--   config: a shallow copy of default with args overriding defaults
	local config = {};
		
	-- This assumes that the default struct has a non-nil value for
	-- all acceptable fields in args.
	for k,v in SortedPairs(default) do
		if (args[k] ~= nil) then
			config[k] = args[k];
		else
			config[k] = v;
		end
	end
	
	--PrintContentsOfTable(config);
	return config;
end

function GetFractalHeight(frac, percent, name)
	-- Get a fractal's value based on a percentage.
	-- Args:
	--   frac: get a value for this fractal
	--   percent: fractal height percentile
	--   name: name of the fractal for debugging
	local name = name or "unnamed fractal";
	if (percent == nil) then
		-- Note: passing nil into Fractal:GetHeight() results in 0.
		print("WARNING: attempt to get fractal height for " .. 
			  name .. " with a nil percentage.");
	end
	
	-- Sanitize the percentile to be a whole number in [0,100].
	-- Note: this might not be necessary; when I experimented with float values and 
	-- values outside [0,100], the Fractal API handled them gracefully. But maybe
	-- they break for other people or for certain fractal instances?
	local percent = math.clamp(Round(percent), 0, 100);

	local height = frac:GetHeight(percent);
	
	-- Check for abnormal fractal values.
	if ((height == nil) or (height < 0) or (height > 255)) then
		print("WARNING: fractal height for " .. name .. 
			  " at " .. PercentString(percent) .. " is " .. NonNilStr(height));
	end
	return height;
end

function GetMapGridSize()
	-- Returns the global map grid's width, height, and number of tiles.
	local iW, iH = Map.GetGridSize();
	local numTiles = iW * iH;
	return iW, iH, numTiles;
end

function GetPassableWaterArea(plot, maxArea, waterAreas)
	-- Count the number of passable water tiles that are reachable via water
	-- from the specified coordinate.
	--
	-- Args:
	--  plot: start location
	--  maxArea: maximum area to measure.
	--  waterAreas: map of memoized areas to improve performance
	--    where -1 indicates not-yet-computed.
	if not IsPassableWater(plot) then
		-- This check is simple enough that we don't need to memoize it.
		return 0;
	end

	local iX = plot:GetX();
	local iY = plot:GetY();	
	if waterAreas then
		local memoizedArea = waterAreas[GetPlotIndexLua(iX,iY)];
		if memoizedArea >= 0 then
			-- We already computed water area for this plot.
			return memoizedArea;
		end
	end
	
	local maxArea = maxArea or math.huge;
	local iW, iH, numTiles = GetMapGridSize();
	
	local visited = table.fill(0, numTiles);
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- covered all of the water tiles that share the same body of water.
	local stack = Stack:Create();
	local count = 0;
	local iVisited = GetPlotIndexLua(iX,iY);
	
	stack:Push({x=iX, y=iY});
	visited[iVisited] = 1;
	
	while (not stack:IsEmpty()) do
	
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		-- Increase the water count.
		count = count + 1;
		if count >= maxArea then
			break;
		end
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited water.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
			
				if (IsPassableWater(adjacentPlot) and 
					(visited[iCouldVisit] == 0)) then
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end
	
	if waterAreas then
		-- Fill all reachable water plots in our memoization table with the computed area.
		waterAreas[GetPlotIndexLua(iX,iY)] = count;
		stack:Push({x=iX, y=iY});
	
		while (not stack:IsEmpty()) do
		
			local coord = stack:Pop();
			local x, y = coord.x, coord.y;
			
			for i, direction in ipairs(HexDirections) do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's unvisited water.
					local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
					local iCouldVisit = GetPlotIndexLua(aX, aY);
				
					if (IsPassableWater(adjacentPlot) and 
						(waterAreas[iCouldVisit] < 0)) then
						-- Add to the stack of plots to visit.
						stack:Push({x=aX, y=aY});
						waterAreas[iCouldVisit] = count;
					end
				end
			end
		end
	end
	
	return count;
end

function GetPlotIndexLua(x,y)
	-- Map (x,y) to a Lua (1-based) plot array index.
	-- Args: (x,y) where (0,0) is SW corner of the map and (iW-1, iH-1) is NE corner.
	-- Returns: plot array index where 1 is SW corner and iW*iH is NE corner.
	local iW, iH = GetMapGridSize();
	return iW*y + x + 1;
end

function GetWaterArea(plotTypes, iX, iY)
	-- Count the number of water tiles in the body of water that contains
	-- the specified coordinate.
	--
	-- Args:
	--  plotTypes: grid of plot types
	--  iX: coordinate
	--  iY: coordinate
	local iW, iH, numTiles = GetMapGridSize();

	local numIgnoredRows = 0;
	
	local visited = table.fill(0, numTiles);
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- covered all of the water tiles that share the same body of water.
	local stack = Stack:Create();
	local count = 0;
	local iVisited = GetPlotIndexLua(iX,iY);
	
	stack:Push({x=iX, y=iY});
	visited[iVisited] = 1;
	
	while (not stack:IsEmpty()) do
	
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		-- Increase the water count.
		count = count + 1;
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited water.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
			
				if ((aY >= numIgnoredRows) and 
				    (aY < (iH - numIgnoredRows)) and
					(plotTypes[iCouldVisit] == g_PLOT_TYPE_OCEAN) and 
					(visited[iCouldVisit] == 0)) then
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end
	return count;
end

function HasCliff(plot)
	if (not plot) then 
		return false;
	end
	
	local x = plot:GetX();
	local y = plot:GetY();
	
	local plotNW = Map.GetAdjacentPlot(x, y, DIRECTION_NW);
	local plotW  = Map.GetAdjacentPlot(x, y, DIRECTION_W);
	local plotNE = Map.GetAdjacentPlot(x, y, DIRECTION_NE);

	local isSEOfCliff = (plotNW ~= nil) and plotNW:IsNWOfCliff();
	local isEOfCliff  = (plotW  ~= nil) and plotW:IsWOfCliff();
	local isSWOfCliff = (plotNE ~= nil) and plotNE:IsNEOfCliff();
	
	-- Why couldn't the Plot API just have getters for all 6 directions?
	return  plot:IsNWOfCliff()    or 
			plot:IsWOfCliff()     or 
			plot:IsNEOfCliff()    or
			(isSEOfCliff == true) or
			(isEOfCliff  == true) or
			(isSWOfCliff == true);
end

function Interpolate(x, xMin, xMax, yMin, yMax, bias)
	-- Interpolate from one range to another.
	--
	-- Intended for mapping latitude ranges to fractal percentage thresholds
	-- in order to get a gradual fade-out of a latitude-based climate factal.
	--
	-- A sqrt bias creates a more drastic change towards the lower-side of
	-- the x-range so that fade-out is noticeable even with a low-grain fractal.
	-- A Square bias, on the other hand, puts a more drastic change on the 
	-- upper-end of the x-range.
	--
	-- Args:
	--   x: value to interpolate from
	--   xMin, xMax: range of values for x where xMin < xMax
	--   yMin, yMax: range of values for y where yMin < yMax
	--   bias: optional bias function f(x) to apply to the interpolation
	-- Returns:
	--   y: the corresponding interpolated value for the range [yMin, yMax]
	
	-- Unbiased linear interpolation by default.
	local bias = bias or function(x) return x; end
	
	if (x < xMin) then
		return yMin;
	end
	
	if (x > xMax) then
		return yMax;
	end
	
	local interp = bias((x - xMin) / (xMax - xMin));
	
	return (yMin + (interp * (yMax - yMin)));
end

function IsAdjacent(x, y, PlotConditionFcn)
	-- Check whether a plot at (x,y) has an adjacent plot that passes the specified condition.
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if ((adjacentPlot ~= nil) and PlotConditionFcn(adjacentPlot)) then
			return true;
		end
	end
	return false;
end

function IsAdjacentToGeoFissure(x, y)
	-- Returns true iff the plot at (x, y) is any type of land adjacent to at least one geothermal fissure.  
	return IsAdjacent(x, y, IsGeoFissure);
end

function IsAdjacentToKelpForest(x, y)
	-- Returns true iff the plot at (x, y) is adjacent to at least one kelp.  
	return IsAdjacent(x, y, IsKelpForest);
end

function IsAdjacentToLake(x, y)
	-- Returns true iff the plot at (x, y) is any type of land adjacent to at least one 
	-- body of fresh water.
	local plot = Map.GetPlot(x, y);    
	return ((not plot:IsWater()) and 
	        IsAdjacent(x, y, function(adjPlot) return adjPlot:IsLake(); end));
end

function IsAdjacentToMountain(x, y)
	return IsAdjacent(x, y, function(plot) return plot:IsMountain(); end);
end

function IsAdjacentToNaturalWonder(x, y)
	return IsAdjacent(x, y, function(plot) return plot:IsNaturalWonder(); end);
end

function IsAdjacentToNonIceLake(x, y)
	-- Checks a plot (x, y) to see if it is any type of land adjacent to 
	-- at least one unfrozen like tile
	local plot = Map.GetPlot(x, y);
	local testFcn = function(adjPlot)
		return (adjPlot:IsLake() and (adjPlot:GetFeatureType() ~= g_FEATURE_ICE));
	end
	return ((not plot:IsWater()) and IsAdjacent(x, y, testFcn));
end

function IsAdjacentToOasis(x, y)
	-- Returns true iff the plot at (x, y) is any type of land adjacent to at least one oasis.  
	return IsAdjacent(x, y, IsOasis);
end

function IsAdjacentToPassableLand(iX, iY)
	-- Check whether a plot is adjacent to at least one passable land tile.
	return IsAdjacent(x, y, IsPassableLand);
end

function IsAdjacentToReef(x, y)
	-- Returns true iff the plot at (x, y) is adjacent to at least one reef.  
	return IsAdjacent(x, y, IsReef);
end

function IsAdjacentToSaltWater(x, y)
	-- Checks a plot (x, y) to see if it is any type of land adjacent to 
	-- at least one body of salt water.
	local plot = Map.GetPlot(x, y);
	local testFcn = function(adjPlot)
		return (adjPlot:IsWater() and (not adjPlot:IsLake()));
	end
	return ((not plot:IsWater()) and IsAdjacent(x, y, testFcn));
end

function IsAdjacentToVolcano(x, y)
	return IsAdjacent(x, y, IsVolcano);
end

function IsAdjacentToWater(x, y)
	-- Checks a plot (x, y) to see if it is any type of land adjacent 
	-- to at least one body of water.
	local plot = Map.GetPlot(x, y);
	return ((not plot:IsWater()) and 
	        IsAdjacent(x, y, function(adjPlot) return adjPlot:IsWater(); end));
end

function IsBaseTerrainType(baseTerrain, terrainType)
	-- Return true iff baseTerrain == terrainType, or 
	-- terrainType matches either the land, hills, or mountains equivalent of the base.
	
	if (baseTerrain == terrainType) then
		return true;
	end
	
	if (baseTerrain == g_TERRAIN_TYPE_GRASS) then
		return (terrainType == g_TERRAIN_TYPE_GRASS_HILLS) or 
			   (terrainType == g_TERRAIN_TYPE_GRASS_MOUNTAIN);
	end
	
	if (baseTerrain == g_TERRAIN_TYPE_PLAINS) then
		return (terrainType == g_TERRAIN_TYPE_PLAINS_HILLS) or 
			   (terrainType == g_TERRAIN_TYPE_PLAINS_MOUNTAIN);
	end
	
	if (baseTerrain == g_TERRAIN_TYPE_DESERT) then
		return (terrainType == g_TERRAIN_TYPE_DESERT_HILLS) or 
			   (terrainType == g_TERRAIN_TYPE_DESERT_MOUNTAIN);
	end
	
	if (baseTerrain == g_TERRAIN_TYPE_TUNDRA) then
		return (terrainType == g_TERRAIN_TYPE_TUNDRA_HILLS) or 
			   (terrainType == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN);
	end
	
	if (baseTerrain == g_TERRAIN_TYPE_SNOW) then
		return (terrainType == g_TERRAIN_TYPE_SNOW_HILLS) or 
			   (terrainType == g_TERRAIN_TYPE_SNOW_MOUNTAIN);
	end

	return false;
end

function IsCityFriendly(plot)
	-- Return true iff the plot at (x,y) is a valid location for building a city.
	-- Must be passable land and meet certain terrain/feature requirements.
	return (IsPassableLand(plot) and 
		    (not plot:IsNaturalWonder()) and
		    (not IsOasis(plot)));
end

function IsCloseToMapEdge(x, y, d, wrapX, wrapY)
	-- Checks whether (x,y) is a certain number of plots away from the edge of the map.
	local iW, iH = GetMapGridSize();
	local d = d or 1;
	return (((wrapX == false) and ((x-d <= 0) or (x+d >= iW-1))) or 
		    ((wrapY == false) and ((y-d <= 0) or (y+d >= iH-1))) );
end

function IsConnectedToRiver(x,y)
	-- Return true iff the plot at (x,y) is a river plot or has a river flowing to/from the plot.
	local plot = Map.GetPlot(x, y);
	if not plot then
		return false;
	end

	if plot:IsRiver() then
		return true;
	end

	-- Check for rivers flowing to/from the plot
	local adjPlot;
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_NW);
	if adjPlot and adjPlot:IsWOfRiver() then
		-- N river
		return true;
	end
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_NE);
	if adjPlot and adjPlot:IsNWOfRiver() then
		-- NE river
		return true;
	end
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_E);
	if adjPlot and adjPlot:IsNEOfRiver() then
		-- SE river
		return true;
	end
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_SW);
	if adjPlot and adjPlot:IsWOfRiver() then
		-- S river
		return true;
	end
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_W);
	if adjPlot and adjPlot:IsNWOfRiver() then
		-- SW river
		return true;
	end
	
	adjPlot	= Map.GetAdjacentPlot(x, y, DIRECTION_NW);
	if adjPlot and adjPlot:IsNEOfRiver() then
		-- NW river
		return true;
	end
	return false;
end

function IsFloodplains(featureType)
    -- True iff the feature type is a type of floodplains.
    return (featureType == g_FEATURE_FLOODPLAINS) or
		 (g_FEATURE_FLOODPLAINS_GRASSLAND and (featureType == g_FEATURE_FLOODPLAINS_GRASSLAND)) or
		 (g_FEATURE_FLOODPLAINS_PLAINS and (featureType == g_FEATURE_FLOODPLAINS_PLAINS)) or
         (g_FEATURE_FLOODPLAINS_TUNDRA and (featureType == g_FEATURE_FLOODPLAINS_TUNDRA));
end

function IsGeoFissure(plot)
	local featureType = plot:GetFeatureType();
	return ((featureType ~= nil) and 
			g_FEATURE_GEOTHERMAL_FISSURE and 
			(featureType == g_FEATURE_GEOTHERMAL_FISSURE));
end

function IsIce(plot)
	local featureType = plot:GetFeatureType();
	return (featureType ~= nil) and (featureType == g_FEATURE_ICE);
end

function IsKelpForest(plot)
	local featureType = plot:GetFeatureType();
	return (featureType ~= nil) and g_FEATURE_SUK_KELP and (featureType == g_FEATURE_SUK_KELP);
end

function IsLakeOrWonderLake(plot)
	-- Check whether a plot is a fresh lake, or a lake natural wonder.
	if (not plot) then
		-- off the map.
		return false;
	end
	
	if plot:IsLake() then
		-- regular lake.
		return true;
	end
	
	if (not plot:IsNaturalWonder()) then
		--not a wonder, so not a wonder-lake.
		return false;
	end
	
	-- Got a natural wonder. Return true iff the wonder happens to be a lake wonder.
	local eFeature = plot:GetFeatureType();
	return ((eFeature ~= -1) and (GameInfo.Features[eFeature].Lake == true));
end

function IsLand(plotTypes, plot)
	-- Args:
	--   plotTypes: map of plot types.
	--   plot: plot to check against plot types.
	--
	-- Return true iff the plot is a land tile in the specified map.
	
	if (not plot) then
		-- Beyond the edge of the map: not land.
		return false;
	end
	
	local i = GetPlotIndexLua(plot:GetX(), plot:GetY());
	
	return plotTypes[i] == g_PLOT_TYPE_LAND;
end

function IsMarshOrSwamp(featureType)
    return (featureType == g_FEATURE_MARSH) or 
        (g_FEATURE_HD_SWAMP and (featureType == g_FEATURE_HD_SWAMP));
end

function IsNearby(x, y, plotConditionFcn, d)
	-- Determine if plotConditionFcn is true for any plot that is 
	-- at most d tiles away from (x,y)
	--
	-- Calling this with d < 1 is equivalent to calling
	-- plotConditionFcn(Map.GetPlot(x,y)).
	--
	-- Calling this with d = 1 is equivalent to calling 
	-- isAdjacent(x,y,plotConditionFcn).
	--
	-- Args:
	--   x, y: nearby location: recursion begins here.
	--   plotConditionFunction: the condition to check at each nearby plot
	--   d: test plots that are at most this many hexes from (x,y)
	-- Returns: true iff the specified condition is true for at least one plot within d hexes 
	--   of (x,y).
	if (d < 1) then
		return plotConditionFcn(Map.GetPlot(x,y));
	end
	
	if (d == 1) then
		return IsAdjacent(x, y, plotConditionFcn);
	end

	local iW, iH, numTiles = GetMapGridSize();

	-- Use a map to memoize visited plots 
	-- to avoid repeatedly testing the same plots.
	local visitedPlots = table.fill(0, numTiles);
	
	return IsNearbyRecursive(x, y, plotConditionFcn, d, visitedPlots);
end

function IsNearbyRecursive(x, y, plotConditionFcn, d, visitedPlots)
	-- Recursive helper function for IsNearby()
	local iPlot = GetPlotIndexLua(x,y);

	if (visitedPlots[iPlot] ~= 0) then
		-- We already visited this plot.
		return false;
	end
	
	-- Mark this plot as visited.
	visitedPlots[iPlot] = 1;
	
	if plotConditionFcn(Map.GetPlot(x,y)) then
		-- Found a plot that satisfies the condition.
		return true;
	end
	
	if (d <= 0) then
		-- Stop recursion.
		return false;
	end
	
	-- Recurse at neighboring plots.
	local adjD = d - 1;	
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjPlot = Map.GetAdjacentPlot(x, y, direction);
		if ((adjPlot ~= nil) and 
		    IsNearbyRecursive(
				adjPlot:GetX(), 
				adjPlot:GetY(), 
				plotConditionFcn, 
				adjD,
				visitedPlots)) then
			return true;
		end
	end
	
	-- Recursion has bubbled back and we found nothing.
	return false;
end

function IsOasis(plot)
	local featureType = plot:GetFeatureType();
	return (featureType ~= nil) and (featureType == g_FEATURE_OASIS);
end

function IsOcean(plot)
	return ((plot ~= nil) and 
	        (not plot:IsLake()) and 
			(plot:GetTerrainType() == g_TERRAIN_TYPE_OCEAN));
end

function IsPassable(plot)
	-- Return true iff the plot is passable by "normal" land units 
	-- that can cross both land and water.
	--
	-- Examples of tiles that are *not* passable:
	--   nil plots (off the edge of the map)
	--   mountains
	--   ice
	--   natural wonders
	if (not plot) then
		-- Nil plot: a phantom neighbor of an edge tile.
		return false;
	end
	
	if (plot:IsMountain()) then 
		-- Mountain
		return false;
	end
	
	if (plot:IsImpassable()) then
		-- Ice, natural wonders
		return false;
	end
	
	return true;
end

function IsPassableLand(plot)
	-- Return true iff the plot is passable and is not water.	
	return IsPassable(plot) and (plot:IsWater() == false);
end

function IsPassableOcean(plot) 
	return IsPassable(plot) and IsOcean(plot);
end

function IsPassableWater(plot) 
	return IsPassable(plot) and plot:IsWater();
end

function IsPassableWaterChokepoint(plot)
	-- Check whether a plot is a chokepoint that could prevent ships from passing
	-- if the plot became impassable to ships.
	return IsPassableWater(plot) and IsChokepoint(plot:GetX(), plot:GetY(), IsPassableWater);
end

function IsPeninsula(plotTypes, x, y)
	-- Check whether the plot at {x,y} is a peninsula.
	--
	-- Args:
	--   plotTypes: a map of work-in-progress plot types
	--   x,y location of the plot to check
	--
	-- Returns true iff {x,y} is adjacent to exactly one group of 
	-- three or fewer adjacent land tiles.
	
	if ((not IsLand(plotTypes, Map.GetPlot(x, y)))) then
		-- Off the map or a water tiles: not a peninsula.
		return false;
	end
	
	local prevIsLand = IsLand(plotTypes, Map.GetAdjacentPlot(x, y, HexDirections[6]));
	local numDiffs = 0;
	local numLand  = 0;
	
	for i, direction in ipairs(HexDirections) do
		local curIsLand = IsLand(plotTypes, Map.GetAdjacentPlot(x, y, direction));
		
		if (prevIsLand ~= curIsLand) then
			-- Water/Land changed.
			numDiffs = numDiffs + 1;
			
			if (numDiffs > 2) then
				-- L,W,L,W or W,L,W,L pattern detected.
				-- Not a peninsula.
				return false;
			end
		end
		prevIsLand = curIsLand;
		
		if curIsLand then
			-- Found adjacent land
			numLand = numLand + 1;
			if (numLand > 3) then
				-- Too much adjacent land. Not a peninsula.
				return false;
			end
		end		
	end
	return true;
end

function IsReef(plot)
	local featureType = plot:GetFeatureType();
	return (featureType ~= nil) and g_FEATURE_REEF and (featureType == g_FEATURE_REEF);
end

function IsSaltWater(plot)
    return (plot ~= nil) and (plot:IsWater() == true) and (plot:IsLake() == false);
end

function IsChokepoint(x, y, PlotConditionFcn)
	-- Check whether a plot at (x,y) is a chokepoint that could potentially
	-- separate two groups of plots that share something in common.
	--
	-- Args:
	--   plot the plot to check
	--   PlotConditionFcn a function to distinguish groups of plots (such as IsWater)
	--
	-- Returns true iff the plot is surrounded by at least two
	-- distinct groups according to the plot condition function
	
	local prevIsYes = PlotConditionFcn(Map.GetAdjacentPlot(x, y, HexDirections[6]));
	local numDiffs = 0;
	
	for i, direction in ipairs(HexDirections) do
		local curIsYes = PlotConditionFcn(Map.GetAdjacentPlot(x, y, direction));
		
		if (prevIsYes ~= curIsYes) then
			-- Test results changed.
			numDiffs = numDiffs + 1;
			
			if (numDiffs > 2) then
				-- Y,N,Y,N or N,Y,N,Y pattern detected
				-- Two distinct sets of tiles would
				-- become locally separated if we changed (x,y).
				--
				-- Therefore, this tile is a chokepoint.
				--print("Chokepoint detected at " .. CoordString(x,y));
				return true;
			end
		end
		
		prevIsYes = curIsYes;
	end
	
	return false;
end

function IsStrait(plotTypes, x, y)
	-- Check whether the plot at {x,y} could potentially break
	-- a lake into multiple lakes.
	--
	-- Args:
	--   plotTypes: a map of work-in-progress plot types
	--   x,y location of the plot to check
	--
	-- Returns true iff {x,y} is surrounded by at least two
	-- distinct groups of water tiles which are connected
	-- only by {x,y}.
	
	local prevIsWater = IsWater(plotTypes, Map.GetAdjacentPlot(x, y, HexDirections[6]));
	local numDiffs = 0;
	
	for i, direction in ipairs(HexDirections) do
	
		local curIsWater = IsWater(plotTypes, Map.GetAdjacentPlot(x, y, direction));
		
		if (prevIsWater ~= curIsWater) then
			-- Water/Land changed.
			numDiffs = numDiffs + 1;
			
			if (numDiffs > 2) then
				-- L,W,L,W or W,L,W,L pattern detected.
				-- Two distinct sets of water tiles would
				-- become locally separated if we made {x,y}
				-- a land tile.
				--
				-- Therefore, this tile is a lake chokepoint.
				--print("Lake chokepoint detected at " .. CoordString(x,y));
				return true;
			end
		end
		
		prevIsWater = curIsWater;
	end
	
	return false;
end

function IsVolcano(plot)
	return (plot ~= nil) and g_FEATURE_VOLCANO and (plot:GetFeatureType() == g_FEATURE_VOLCANO);
end

function IsWater(plotTypes, plot)
	-- Args:
	--   plotTypes: map of plot types.
	--   plot: plot to check against plot types.
	--
	-- Return true iff the plot is a water tile in the specified map.
	
	if (not plot) then
		-- Beyond the edge of the map: not water.
		return false;
	end
	
	local i = GetPlotIndexLua(plot:GetX(), plot:GetY());
	
	return plotTypes[i] == g_PLOT_TYPE_OCEAN;
end

function MapGetPlotType(x,y)
	-- Get plot type from the global map.
	local plot = Map.GetPlot(x,y);
	
	if (plot:IsWater()) then
		return g_PLOT_TYPE_OCEAN;
		
	elseif plot:IsMountain() then
		return g_PLOT_TYPE_MOUNTAIN;
	
	elseif plot:IsHills() then
		return g_PLOT_TYPE_HILLS;
		
	else
		return g_PLOT_TYPE_LAND;
	end
end

function MapIsMultiplayer()
	-- Return true iff this is a multiplayer map.
	local numHumans = 0;
	
	for _, player_ID in ipairs(PlayerManager.GetWasEverAliveMajorIDs()) do
		local player = Players[player_ID]
		if player:IsHuman() then
			numHumans = numHumans + 1;
			
			if (numHumans > 1) then
				-- Found at least two human players => multiplayer map.
				return true;
			end
		end
	end
	-- Found at most 1 human player => singleplayer map.
	return false;
end

function MapSetPlotType(x,y, plotType)
	-- Set plot type for a global-map plot at (x,y).
	if (not plotType) then
		print("Attempt to set nil plotType at " .. CoordString(x,y));
		return;
	end
	local plot = Map.GetPlot(x,y);

	local newTerrain = plot:GetTerrainType();
	
	if (plotType == g_PLOT_TYPE_OCEAN) then
		if plot:IsWater() then
			-- Plot is already water, so no-op.
			return;
		end
		-- Turning land into water. Might as well use shallow water.
		newTerrain = g_TERRAIN_TYPE_COAST;
	else
		-- Normalize current terrain.
		if plot:IsWater() then
			-- Turning water into land.
			newTerrain = g_TERRAIN_TYPE_GRASS;
			
		elseif plot:IsHills() then
			newTerrain = newTerrain - g_TERRAIN_BASE_TO_HILLS_DELTA;
			
		elseif plot:IsMountain() then
			newTerrain = newTerrain - g_TERRAIN_BASE_TO_MOUNTAIN_DELTA;
		end
		
		-- Offset terrain type if plot type is hills or mountains.
		-- This assumes that terrain type enums are sorted by 
		-- base terrain, then plot type: 
		--   grass,  grass_hills,  grass_mountains,
		--   plains, plains_hills, plains_mountains,
		--   ...etc.
		if (plotType == g_PLOT_TYPE_HILLS) then
			newTerrain = newTerrain + g_TERRAIN_BASE_TO_HILLS_DELTA;
		elseif (plotType == g_PLOT_TYPE_MOUNTAIN) then
			newTerrain = newTerrain + g_TERRAIN_BASE_TO_MOUNTAIN_DELTA;
		end
	end
	TerrainBuilder.SetTerrainType(plot, newTerrain);
end

function NonNilStr(str)
	if (str == nil) then
		return "nil";
	elseif (str == false) then
        return "false";
    elseif (str == true) then
        return "true";
    end
	return str;
end

function PercentString(n,d)
	-- Pretty-percentage utility function.
	--
	-- Args:
	--   n numerator
	--   d denominator (optional); 100 if nil
	-- 
	-- Returns:
	--   a pretty percentage string for the fraction n/d, or "0%" if d is 0.
	local n = n or 0;
	local d = d or 100;
	
	if (d == 0) then
		return "0%";
	end
	
	local val = (100*n/d);
	if ((val < 1) and (val > 0.000001)) then
		-- Don't confuse fractions of a percent with 0.
		return "<1%";
	end
	return (Round(val) .. "%");
end

function RadString(theta)
	-- Pretty-print a value in radians.
	if (not theta) then
		return "nil";
	end
	
	return (theta/math.pi) .. " pi";
end

function RandomBool()
    -- Return a random boolean.
    return 1 == TerrainBuilder.GetRandomNumber(2, "Random boolean");
end

function RandomElement(incoming_table)
	-- Return a random table element, or nil if the table is null or empty.
	if ((not incoming_table) or (#incoming_table == 0)) then
		return nil;
	end
	return incoming_table[1+TerrainBuilder.GetRandomNumber(#incoming_table, "Random element")];
end

function RandomRadians(thetaLow, thetaHigh, granularity)
	-- A random float in the range [thetaLow,thetaHigh), 
	-- Args:
	--   thetaLow: lower bound inclusive
    --   thetaHigh: upper bound exclusive
	--   granularity: how many possible values to allow in the 
	--     random number genration; defaults to 100 if 0.
	
	local thetaLow    = thetaLow    or 0;
	local thetaHigh   = thetaHigh   or TAU;
	local granularity = granularity or 100;
	
	if (granularity == 0) then
		granularity = 100;
	end
	
	return thetaLow + (thetaHigh - thetaLow) * 
		TerrainBuilder.GetRandomNumber(granularity,"Random Angle") / granularity;
end

function Round(number)
	-- Round to the nearest integer.
	if number >= 0 then 
		return math.floor(number + 0.5);
	else 
		return math.ceil(number - 0.5);
	end
end

function SetBaseTerrain(plot, baseTerrain)
	-- Set the base terrain appropriate to the plot's plot type.
	if (not baseTerrain) then
		print("No terrain at " .. CoordString(plot:GetX(),plot:GetY()));
		return;
	end
	
	-- Offset terrain type if plot type is hills or mountains.
	-- This assumes that terrain type enums are sorted by 
	-- base terrain, then plot type: 
	--   grass,  grass_hills,  grass_mountains,
	--   plains, plains_hills, plains_mountains,
	--   ...etc.
	local terrainType = baseTerrain;
	if (plot:IsHills()) then
		terrainType = terrainType + 1;
	elseif (plot:IsMountain()) then
		terrainType = terrainType + 2;
	end
	TerrainBuilder.SetTerrainType(plot, terrainType);
end

function SetTerrainTypes(terrainTypes)
	-- Set terrain types for the Map/Plot API.
	local iW, iH = GetMapGridSize();
	for y = 0, iH - 1, 1 do
		for x = 0, iW - 1, 1 do
			local i = y * iW + x;
			local plot = Map.GetPlotByIndex(i);
			
			local terrainType = terrainTypes[i+1];
			if terrainType then
				TerrainBuilder.SetTerrainType(plot, terrainType);
			else
				print("Nil terrain type at " .. CoordString(x,y));
			end
		end
	end
	
	-- Each body of water, area of mountains, or area of hills+flatlands 
	-- is independently grouped and tagged.
	AreaBuilder.Recalculate();
end

function ShrinkPeninsulas(plotTypes, coastPlots, queue, curNumWaterTiles, targetNumWaterTiles)
	-- Remove land from peninsulas until there are no peninsulas left, or until sea
	-- level meets specifications.
	-- Args:
	--   plotTypes: land/water map
	--   coastPlots: a map to indicate which water tiles to turn into coast
	--   queue: peninsulas to shrink in BFS order
	--   curNumWaterTiles: current number of water tiles
	--   targetNumWaterTiles: target number of water tiles
	-- Returns:
	--   curNumWaterTiles: new number of water tiles.
		
	-- Use a queue to search neighboring tiles in BFS order until we've
	-- covered all of the water tiles that share the same body of water.
	while ((not queue:IsEmpty()) and (curNumWaterTiles < targetNumWaterTiles)) do
	
		local coord = queue:Dequeue();
		local x, y = coord.x, coord.y;
		
		local iVisited = GetPlotIndexLua(x, y);
		
		-- Perform a potentially-redundant peninsula check
		-- in case the tile at (x,y) is no longer a peninsula.
		if IsPeninsula(plotTypes, x, y) then
			-- Replace shrunken peninsulas with shallow water
			-- to create a maze for non-ocean units.
			--print("Removing peninsula at " .. CoordString(x,y));
			plotTypes[iVisited]  = g_PLOT_TYPE_OCEAN;
			coastPlots[iVisited] = g_PLOT_TYPE_LAND;
			curNumWaterTiles = curNumWaterTiles + 1;
		
			-- Randomize traversal by shuffling the order of adjacent tiles to visit.
			local shuffledDirs = GetShuffledCopyOfTable(HexDirections);
			for i, direction in ipairs(shuffledDirs) do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's now a peninsula.
					local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
					
					if IsPeninsula(plotTypes, aX, aY) then
						-- Add to the stack of plots to visit.
						queue:Enqueue({x=aX, y=aY});
					end
				end
			end
		end
	end
	return curNumWaterTiles;
end

function SortedPairs(t,order)
	-- Returns an iterator alternative to pairs()
	-- which iterates through a table in sorted-keys order.
	
	-- Collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- If order function given, sort by it by passing the table and keys a, b.
    -- Otherwise just sort the keys.
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- Return the iterator function.
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function Square(x)
	-- A simple x^2 function to pass as a bias into Interpolate().
	return x*x;
end

function TerrainString(terrain)
	if terrain == nil then
		return "nil";

	elseif terrain == g_TERRAIN_TYPE_DESERT then
		return "desert";
	elseif terrain == g_TERRAIN_TYPE_DESERT_HILLS then
		return "desert hills";
	elseif terrain == g_TERRAIN_TYPE_DESERT_MOUNTAIN then
		return "desert mountain"
		
	elseif terrain == g_TERRAIN_TYPE_GRASS then
		return "grass";
	elseif terrain == g_TERRAIN_TYPE_GRASS_HILLS then
		return "grass hills";
	elseif terrain == g_TERRAIN_TYPE_GRASS_MOUNTAIN then
		return "grass mountain";
		
	elseif terrain == g_TERRAIN_TYPE_PLAINS then
		return "plains";
	elseif terrain == g_TERRAIN_TYPE_PLAINS_HILLS then
		return "plains hills";
	elseif terrain == g_TERRAIN_TYPE_PLAINS_MOUNTAIN then
		return "plains mountain";
		
	elseif terrain == g_TERRAIN_TYPE_SNOW then
		return "snow";
	elseif terrain == g_TERRAIN_TYPE_SNOW_HILLS then
		return "snow hills";
	elseif terrain == g_TERRAIN_TYPE_SNOW_MOUNTAIN then
		return "snow mountain";
		
	elseif terrain == g_TERRAIN_TYPE_TUNDRA then
		return "tundra";
	elseif terrain == g_TERRAIN_TYPE_TUNDRA_HILLS then
		return "tundra hills";
	elseif terrain == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN then
		return "tundra mountain";
		
	elseif terrain == g_TERRAIN_TYPE_NONE then
		return "none";
	elseif terrain == g_TERRAIN_TYPE_COAST then
		return "coast";
	elseif terrain == g_TERRAIN_TYPE_OCEAN then
		return "ocean";
	end
	return "unknown";
end
------------------------------------------------------------------------------
-- MapUtilities Overrides
--
-- Override methods in MapUtilities to avoid interference from other mods.
-- GetLatitudeAtPlot() has its own section of methods.
-- Omit Goody-Hut methods for compatibility with goody-hut mods.
--
-- Unused by GL and dependencies as of Sep-2019
--   AdjacentToSaltWater
--   AdjacentToWater
--   IdentifyTableIndex
--   ObtainLandmassBoundaries
------------------------------------------------------------------------------
function DetermineXShift(plotTypes)
	--[[ This function will align the most water-heavy vertical portion of the map with the 
	vertical map edge. This is a form of centering the landmasses, but it emphasizes the
	edge not the middle. If there are columns completely empty of land, these will tend to
	be chosen as the new map edge, but it is possible for a narrow column between two large 
	continents to be passed over in favor of the thinnest section of a continent, because
	the operation looks at a group of columns not just a single column, then picks the 
	center of the most water heavy group of columns to be the new vertical map edge. ]]--
	local iW, iH = GetMapGridSize();
	
	-- First loop through the map columns and record land plots in each column.
	local land_totals = {};
	for x = 0, iW - 1 do
		local current_column = 0;
		for y = 0, iH - 1 do
			local i = GetPlotIndexLua(x,y);
			if (plotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
				current_column = current_column + 1;
			end
		end
		table.insert(land_totals, current_column);
	end
	
	-- Now evaluate column groups, each record applying to the center column of the group.
	local column_groups = {};
	-- Determine the group size in relation to map width.
	local group_radius = math.floor(iW / 10);
	-- Measure the groups.
	for column_index = 1, iW do
		local current_group_total = 0;
		for current_column = column_index - group_radius, column_index + group_radius do
			local current_index = current_column % iW;
			-- Modulo of the last column will be zero; this repairs the issue.
			if current_index == 0 then 
				current_index = iW;
			end
			current_group_total = current_group_total + land_totals[current_index];
		end
		table.insert(column_groups, current_group_total);
	end
	
	-- Identify the group with the least amount of land in it.
	local best_value = iH * (2 * group_radius + 1); -- Set initial value to max possible.
	local best_group = 1; -- Set initial best group as current map edge.
	for column_index, group_land_plots in ipairs(column_groups) do
		if group_land_plots < best_value then
			best_value = group_land_plots;
			best_group = column_index;
		end
	end
	
	-- Determine X Shift
	local x_shift = best_group - 1;
	return x_shift;
end

function DetermineYShift(plotTypes)
	-- Counterpart to DetermineXShift()
	-- First loop through the map rows and record land plots in each row.
	local iW, iH = GetMapGridSize();
	local land_totals = {};
	for y = 0, iH - 1 do
		local current_row = 0;
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if (plotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
				current_row = current_row + 1;
			end
		end
		table.insert(land_totals, current_row);
	end
	
	-- Now evaluate row groups, each record applying to the center row of the group.
	local row_groups = {};
	-- Determine the group size in relation to map height.
	local group_radius = math.floor(iH / 15);
	-- Measure the groups.
	for row_index = 1, iH do
		local current_group_total = 0;
		for current_row = row_index - group_radius, row_index + group_radius do
			local current_index = current_row % iH;
			-- Modulo of the last row will be zero; this repairs the issue.
			if current_index == 0 then
				current_index = iH;
			end
			current_group_total = current_group_total + land_totals[current_index];
		end
		table.insert(row_groups, current_group_total);
	end
	
	-- Identify the group with the least amount of land in it.
	local best_value = iW * (2 * group_radius + 1); -- Set initial value to max possible.
	local best_group = 1; -- Set initial best group as current map edge.
	for row_index, group_land_plots in ipairs(row_groups) do
		if group_land_plots < best_value then
			best_value = group_land_plots;
			best_group = row_index;
		end
	end
	
	-- Determine Y Shift
	local y_shift = best_group - 1;
	return y_shift;
end

function GenerateCoastalLandDataTable()
	local iW, iH, numTiles = GetMapGridSize();
	local plotDataIsCoastal = table.fill( false, numTiles);
	-- When generating a plot data table incrementally, process Y first so that plots go 
	-- row by row. Keeping plot data table indices consistent with the main plot database 
	-- could save you enormous grief. In this case, accessing by plot index, it doesn't matter.
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local plotIsAdjacent = IsAdjacentToSaltWater(x, y)
			if plotIsAdjacent then
				local i = GetPlotIndexLua(x,y);
				plotDataIsCoastal[i] = true;
			end
		end
	end
	-- returns table
	return plotDataIsCoastal;
end

function GenerateNextToCoastalLandDataTables()
	local iW, iH, numTiles = GetMapGridSize();

	-- Set up data table for IsCoastal
	local plotDataIsCoastal = GenerateCoastalLandDataTable()

	-- Set up data table for IsNextToCoast
	local plotDataIsNextToCoast = table.fill(false, numTiles);

	-- When generating a plot data table incrementally, process Y first so that plots go 
	-- row by row. Keeping plot data table indices consistent with the main plot database 
	-- could save you enormous grief. In this case, accessing by plot index, it doesn't matter.
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = GetPlotIndexLua(x,y);
			local plot = Map.GetPlot(x, y);
			if plotDataIsCoastal[i] == false and not plot:IsWater() then
				-- plot is not itself on the coast or in the water.
				for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
					local testPlot = Map.GetAdjacentPlot(x, y, direction);
					if testPlot ~= nil then
						local adjX = testPlot:GetX();
						local adjY = testPlot:GetY();
						local adjI = GetPlotIndexLua(adjX,adjY);
						if plotDataIsCoastal[adjI] == true then
							-- The current loop plot is not itself on the coast but is next 
							-- to a plot that is on the coast.
							plotDataIsNextToCoast[i] = true;
						end
					end
				end
			end
		end
	end
	-- returns table, table
	return plotDataIsCoastal, plotDataIsNextToCoast;
end

function GetShuffledCopyOfTable(incoming_table)
	-- Designed to operate on tables with no gaps. Does not affect original table.
	local len = table.maxn(incoming_table);
	local copy = {};
	local shuffledVersion = {};
	-- Make copy of table.
	for loop = 1, len do
		copy[loop] = incoming_table[loop];
	end
	-- One at a time, choose a random index from Copy to insert in to final table, 
	-- then remove it from the copy.
	local left_to_do = table.maxn(copy);
	for loop = 1, len do
		local random_index = 1 + 
			TerrainBuilder.GetRandomNumber(left_to_do, "Shuffling table entry - Lua");
		table.insert(shuffledVersion, copy[random_index]);
		table.remove(copy, random_index);
		left_to_do = left_to_do - 1;
	end
	return shuffledVersion
end

function IsAdjacentToIce(iX, iY)
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
		if (adjacentPlot ~= nil) then
	   		local featureType = adjacentPlot:GetFeatureType();
			if (featureType ~= nil and featureType == g_FEATURE_ICE) then
				return true;
			end
		end
	end
	return false;
end

function IsAdjacentToLand(plotTypes, x, y)
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if (adjacentPlot ~= nil) then
	   		local i = GetPlotIndexLua(adjacentPlot:GetX(), adjacentPlot:GetY());
			if (plotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
				return true;
			end
		end
	end
	return false;
end

function IsAdjacentToLandPlot(x, y)
	-- Computes IsAdjacentToLand from the plot
	return IsAdjacent(x, y, function(plot) return (not plot:IsWater()); end);
end

function IsAdjacentToRiver(x, y)
	-- Fixes a typo by using x,y everywhere instead of taking iX,iY and using x,y
	local adjacentPlot;	

	if (Map.GetPlot(x, y) == nil) then
			return false;
	end

	if (Map.GetPlot(x, y):IsRiver() == true) then
			return true;
	end

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if (adjacentPlot ~= nil) then
			if (adjacentPlot:IsRiver()) then
				return true;
			end
		end
	end
	return false;
end

function IsAdjacentToShallowWater(terrainTypes, iX, iY)
	local adjacentPlot;	

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
		if (adjacentPlot ~= nil) then
	   		local i = GetPlotIndexLua(adjacentPlot:GetX(), adjacentPlot:GetY());
			if (terrainTypes[i] == g_TERRAIN_TYPE_COAST) then
				return true;
			end
		end
	end
	return false;
end

function PrintContentsOfTable(incoming_table) 
	-- For debugging purposes. LOT of table data being handled here.
	print("--------------------------------------------------");
	print("Table printout for table ID:", incoming_table);
	for index, data in SortedPairs(incoming_table) do
		print(index .. " => ", data);
	end
	print("- - - - - - - - - - - - - - - - - - - - - - - - - -");
end

function ShiftPlotTypes(plotTypes)
	local shift_x = DetermineXShift(plotTypes);	 
	local shift_y = DetermineYShift(plotTypes);	
	ShiftPlotTypesBy(plotTypes, shift_x, shift_y);
end

function ShiftPlotTypesBy(plotTypes, xshift, yshift)
	if ((xshift <= 0) and (yshift <= 0)) then
		-- No-op.
		return;
	end

	local iW, iH, numTiles = GetMapGridSize();
	local buf = {};
	for i = 1, numTiles do
		buf[i] = plotTypes[i];
	end
	
	for iDestY = 0, iH-1 do
		for iDestX = 0, iW-1 do
			local iDestI = GetPlotIndexLua(iDestX, iDestY);
			local iSourceX = (iDestX + xshift) % iW;
			local iSourceY = (iDestY + yshift) % iH;
			
			local iSourceI = GetPlotIndexLua(iSourceX, iSourceY);

			plotTypes[iDestI] = buf[iSourceI];
		end
	end
end

function TestMembership(table, value)
	local testResult = false;
	for index, data in SortedPairs(table) do
		if data == value then
			testResult = true;
			break
		end
	end
	return testResult
end
