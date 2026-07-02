-- Rivers and Lakes for Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"
------------------------------------------------------------------------------
-- Post-Landmass Lakes
-- Utilities for generating additional fresh lakes for an already-finished
-- landmass. Improves access to fresh water and adds potential river sources.
------------------------------------------------------------------------------
function CanHavePostLandmassLake(plot)
	-- Return true iff the plot is a valid candidate for a post-landmass lake.
	
	-- Avoid plots that are already water because adding a lake to that would have no effect.
	-- Avoid mountains because mountains might be surrounded by other mountains.
    -- Avoid adjacent mountains if we're not supposed to have coastal mountains.
	-- Avoid coastal land lest coastal water creeps into the landmass.
	-- Avoid rivers so that we don't cut through the middle of a river.
	-- Don't worry about natural wonders--we didn't add those yet.
	return (plot and not (-- Avoid NPE
		    plot:IsWater() or 
		    plot:IsMountain() or 
			plot:IsCoastalLand() or
		    IsAdjacentToRiver(plot:GetX(),plot:GetY()) or
            ((UserInput.noCoastMts == true) and 
				IsAdjacentToMountain(plot:GetX(),plot:GetY())) ));
end

function AddMoreLake(plot, lakePlots)
	-- Maybe expand a post-landmass lake plot into a multi-plot lake.
	-- Args: 
	--   plot: lake-plot from which to expand
	--   lakePlots: accumulator of plots to turn into water
	local largeLake = 0;
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		
		if CanHavePostLandmassLake(adjacentPlot) then
			local r = TerrainBuilder.GetRandomNumber(4 + largeLake, "Lake expansion");
			if r < 3 then
				--print("Expanding lake at " .. CoordString(adjacentPlot:GetX(),adjacentPlot:GetY()));
				-- Add to lake plots; don't turn land into water yet because that
				-- might prevent expansion to other adjacent plots.
				table.insert(lakePlots, adjacentPlot);
				largeLake = largeLake + 1;
			end		
		end
	end
end

function AddPostLandmassLake(plot, lakePlotRand)
	-- Turn this tile and maybe some adjacent tiles into a lake.
	-- Args: 
	--   plot: where to start adding a lake. 
	--     This plot must pass the CanHavePostLandmassLake() test.
	--   lakePlotRand: non-zero denominator for the chance of adding a lake
	--     i.e., the chance of adding a lake is 1/lakePlotRand.
	-- Returns: the number of lake tiles added to the map.
	local lakeDice = TerrainBuilder.GetRandomNumber(lakePlotRand, "fresh Lakes");
	if (lakeDice ~= 0) then
		return 0;
	end
	
	local numLakeTilesAdded = 0;
	
	-- Make a list of plots to turn into water so that we can add
	-- more lakes without confusing neighboring tiles with 
	-- "coastal land".
	local lakePlots = {plot};
		
	-- Try to expand the lake into adjacent tiles.
	AddMoreLake(plot, lakePlots);
	
	-- Turn lake plots into water.
	for i,lakePlot in ipairs(lakePlots) do 
		numLakeTilesAdded = numLakeTilesAdded + 1;
		TerrainBuilder.SetTerrainType(lakePlot, g_TERRAIN_TYPE_COAST);
	end
	return numLakeTilesAdded;
end

function GetLakePlotRand()
	-- Get the chance of spawning a freshwater lake.
	
	local lakePlotRand = GlobalParameters.LAKE_PLOT_RANDOM  or 40;
	
	-- Allow the user to raise/lower water-tables for lakes.
	local lakeLevel = UserInput.lakeLevel;
	
	-- More fresh water => smaller lake dice => higher frequency of random lakes.
	--
	-- Use larger dice than the base game because we're adding lakes before rivers,
	-- which means that there are more eligible tiles for lakes.
	local lakeMults = {6.0, 3.0, 1.5, 0.75, 0.5};
	local lakeMult = lakeMults[lakeLevel] or 1.5;
	
	return lakePlotRand * lakeMult;
end

function AddLakes()
    if UserInput.noAddLakes then
        print("Not adding lakes (no additional lakes).");
        return;
    end

	-- Add some fresh-water lakes.
	print("Adding lakes.");
	
	local iW, iH, numTiles = GetMapGridSize();
	
	-- Double the lake-plot dice 
	-- because we add lakes twice.
	local lakePlotRand = GetLakePlotRand();
	
	-- Turn the dice into a natural number.
	lakePlotRand = math.max(1,Round(lakePlotRand));
	
	print("Chance of lake plot: 1/" .. lakePlotRand);
	
	local numLakeTilesAdded  = 0;
	local numLakesAdded      = 0;
	local numLargeLakesAdded = 0;

	for i = 0, numTiles - 1, 1 do
		plot = Map.GetPlotByIndex(i);
		
		if CanHavePostLandmassLake(plot) then 
			-- This plot has lake potential.
			-- Roll dice to decide whether to make this plot a lake tile.
			local numNewLakeTilesAdded = AddPostLandmassLake(plot, lakePlotRand);
			
			numLakeTilesAdded = numLakeTilesAdded + numNewLakeTilesAdded;
			
			if (numNewLakeTilesAdded > 0) then
				numLakesAdded = numLakesAdded + 1;
			end
			if (numNewLakeTilesAdded > 3) then
				numLargeLakesAdded = numLargeLakesAdded + 1;
			end
		end
	end
	
	-- this is a minimalist update because lakes have been added
	if numLakeTilesAdded > 0 then
		print("Lake tiles added:  " .. numLakeTilesAdded)
		print("Total Lakes added: " .. numLakesAdded)
		print("Large Lakes added: " .. numLargeLakesAdded)
		AreaBuilder.Recalculate();
	end
end
------------------------------------------------------------------------------
-- River Patterns
-- Configurations for various river styles.
------------------------------------------------------------------------------
DefaultRiverPattern = 
{
	-- Debug name.
	name = "unknown",
	
	-- Toggle randomizing the river pattern for each river.
	isRandom = false,

	-- Toggle rivers creating branches (multi-recursion).
	allowBranch = true,
	
	-- Toggle Y-shaped merges with other rivers.
	allowYMerge = false;
	
	-- Toggle rivers flowing into fresh lakes.
	allowLakeMouths = true,
	
	-- Toggle generating lakes when generating inland rivers.
	allowCreateLakes = true,

	-- Chance of extending a river in both directions at each segment.
	-- Higher values lead to high-fanout rivers, and require a shorter 
	-- min-length in order to avoid covering the entire map.
	branchPct = 20,
	
	-- Chance of trying the fallback direction if the first-choice is fruitless.
	-- Higher values result in snaky rivers. Setting to 0 effectively disables this.
	fallbackPct = 20,
	
	-- Don't try as hard to extend any river that has grown to at least 
	-- this many river segments.
	--
	-- This has no effect on simple or branchy rivers.
	softMaxLength = 1, -- dummy value
	
	-- Stop extending the river after it reaches this length.
	hardMaxLength = 1, -- dummy value
	
	-- Affect of exceeding softMaxLength on river recursion chances.
	-- Lower number in [0,1] range results in more drastic reduction.
	longRiverFactor = 0.25,
	
	-- Chance of starting a river at a qualifying spot.
	-- Use this for responsiveness to user input.
	startPct = 1, -- dummy value
	
	-- A river must create at least this many segments in order to prevent
	-- other rivers from starting near its starting spot.
	--
	-- Any river smaller than this is considered "small" and will allow
	-- other rivers to start at a closer distance.
	smallRiverLength = 1, -- dummy value
};

function CreateRiverPattern_Simple(args)
	-- Create the Simple Rivers pattern.
	local args = args or {};
	args.name             = "simple";
	args.allowBranch      = true;  -- allow multiple sources
	args.allowYMerge      = false; -- enforce one mouth
	args.allowLakeMouths  = false;
	args.allowCreateLakes = false;
	args.softMaxLength    = args.softMaxLength * 2;
	args.hardMaxLength    = math.huge;
	args.branchPct        = 6;
	args.fallbackPct      = 0;
		
	if ((gotLakesFamily and UserInput.freshLakes and (not UserInput.connectSeas)) or
	    (UserInput.landmass == Landmasses.INVDONUT) or
        (UserInput.landmass == Landmasses.INVEXTRAS)) then
		-- A lakes family landmass with all fresh lakes,
        -- or the Inverted Donut landmass,
		-- or the Inverted Extras landmass.
		-- Allow starting at fresh lakes because much of the water is fresh.
		args.name            = "simple - allow lake mouths";
		args.allowLakeMouths = true;
		
	elseif (UserInput.landmass == Landmasses.INLANDSEA) then
		-- Inland sea rivers
		-- Allow y-merge, but not branching.
		args.name        = "simple - inland sea or inverted donut";
		args.allowBranch = false; -- force one source
		args.allowYMerge = args.enableRiverMerge;  -- allow multiple mouths
		args.branchPct   = 0;
	end
	
	-- Apply simple river overrides to the default pattern.
	return GetConfigInfo(DefaultRiverPattern, args);
end

function CreateRiverPattern_Detailed(args)
	-- Create the Detailed Rivers pattern.
	local args = args or {};
	args.name = "detailed";
	
	-- Apply arg overrides to the default pattern.
	return GetConfigInfo(DefaultRiverPattern, args);
end

function CreateRiverPattern_Branchy(args)
	-- Create the Branchy Rivers pattern.
	local args = args or {};
	args.name          = "branchy";
	args.hardMaxLength = 0.75 * args.softMaxLength;
	args.branchPct     = 90;
	args.fallbackPct   = 10;
	args.startPct      = args.startPct + 20;
	
	-- Apply arg overrides to the default pattern.
	return GetConfigInfo(DefaultRiverPattern, args);
end

function CreateRiverPattern_Snaky(args)
	-- Create the Snaky Rivers pattern.
	local args = args or {};
	args.name            = "snaky";
	args.allowYMerge     = false;
	args.hardMaxLength   = args.hardMaxLength + args.smallRiverLength;
	args.longRiverFactor = 0.1;
	args.branchPct       = 10;
	args.fallbackPct     = 100;
	-- Apply arg overrides to the default pattern.
	return GetConfigInfo(DefaultRiverPattern, args);
end

function CreateRiverPattern_Everything(args)
	-- Create the Everything Rivers pattern.
	local args = args or {};
	args.name     = "everything";
	args.isRandom = true;
	
	-- Apply arg overrides to the default pattern.
	return GetConfigInfo(DefaultRiverPattern, args);
end
------------------------------------------------------------------------------
-- River Generator
-- Replaces the base-game's river generator.
------------------------------------------------------------------------------
RiverGenerator = {};

function RiverGenerator.Create(
	gotGatheringStorm, 
	worldSizeInfo, 
	wrapX,
	wrapY,
	enableRiverDebug,
	enableRiverMerge)
	-- Constructor.
	-- Reuse this instance for both coastsal and inland river generation.
	--
	-- This generator creates all rivers by starting at the mouth
	-- and tracing backwards to the source.
	-- args:
	--   gotGatheringStorm: whether the gathering storm expansion is enabled
	--   worldSizeInfo: world size configuration for scaling river length
	--   wrapX: whether the world wraps east-west
	--   wrapY: whether the world wraps north-south
	--   enableRiverDebug: whether to enable debug log messages.
	--   enableRiverMerge: whether to allow river systems to merge.

	local iW, iH, numTiles = GetMapGridSize();

	-- Allow user to increase/decrease the number of river tiles.
	local waterLevel = UserInput.riverLevel;
	
	-- Higher river level => higher chance of river starting at a valid location
    -- Higher levels are more spaced out due to diminishing returns.
	local startPcts = {10, 20, 35, 50, 75};
	local startPct  = startPcts[waterLevel];
	
	local lakePlotRand = GetLakePlotRand();
	
	if (UserInput.landmass == Landmasses.INLANDSEA) then
		-- Increase rivers to compensate for few bodies of water
		print("Increasing rivers and lakes (inland sea)");
		lakePlotRand = lakePlotRand / 8;
		startPct     = startPct + 15;
	
    elseif ((UserInput.landmass == Landmasses.INVDONUT) and (not ExtrasGot.anything)) then
		-- Increase rivers to compensate for few bodies of water
		print("Increasing rivers and lakes (inverted donut + no extras)");
		lakePlotRand = lakePlotRand / 8;
		startPct     = startPct + 18;
    
	elseif ((UserInput.landmass == Landmasses.INVEXTRAS) and (not ExtrasGot.anything)) then
		-- Increase rivers to compensate for world that only has post-landmass lakes.
		print("Increasing rivers and lakes (inverted extras + no extras)");
		lakePlotRand = lakePlotRand / 8;
		startPct     = startPct + 20;
	end
	
	-- Turn the dice into a natural number.
	lakePlotRand = math.max(1,Round(lakePlotRand));
	
	-- Calculate bounds for river length.
	
	-- Allow user input to affect river bounds.
	local waterLengthMults = {0.25, 0.5, 1, 2, 4};
	local waterLengthMult  = waterLengthMults[waterLevel];
	
	-- Base Game uses Map.GetMapSize(), 
	-- which is inconsistent when there are custom map sizes.
	--
	-- Incrementing by 1/2 map size index seems to result in better 
	-- consistency across sizes.
	local smallRiverLength = 2 + Round(worldSizeInfo.index/2);
	print("Small River length: " .. smallRiverLength);
	
	-- Example [soft, hard] lengths for detailed rivers: 
	-- => sparse:   [8,  12]
	-- => standard: [12, 16]
	-- => abundant: [16, 20]
	local softMaxLength = Round((waterLengthMult + 1) * smallRiverLength);
	local hardMaxLength = softMaxLength + smallRiverLength;
	
    local noAddLakes = UserInput.noAddLakes;
    if noAddLakes then
        print("Preventing rivers from spawning lakes (no additional lakes).");
    end
    
	-- River pattern settings.
	local patternArgs = 
	{	
		-- Whether to allow rivers to merge.
		enableRiverMerge  = enableRiverMerge,
	
		-- Don't try as hard to extend any river that has grown to at least 
		-- this many river segments.
		--
		-- This has no effect on simple or branchy rivers.
		softMaxLength = softMaxLength,
		
		-- Stop extending the river after it reaches this length.
		hardMaxLength = hardMaxLength,
		
		-- Chance of starting a river at a qualifying spot.
		-- Use this for responsiveness to user input.
		startPct = startPct,
		
		-- A river must create at least this many segments in order to prevent
		-- other rivers from starting near its starting spot.
		--
		-- Any river smaller than this is considered "small" and will allow
		-- other rivers to start at a closer distance.
		smallRiverLength = smallRiverLength
	};
	
	-- Whether rivers can merge by default depends on args from the main map script.
	DefaultRiverPattern.allowYMerge = enableRiverMerge;
	
	print("Chance of river-start lake plot: 1/" .. lakePlotRand);
	
	local patterns = 
	{
		CreateRiverPattern_Simple(    GetConfigInfo(DefaultRiverPattern, patternArgs)),
		CreateRiverPattern_Detailed(  GetConfigInfo(DefaultRiverPattern, patternArgs)),
		CreateRiverPattern_Branchy(   GetConfigInfo(DefaultRiverPattern, patternArgs)),
		CreateRiverPattern_Snaky(     GetConfigInfo(DefaultRiverPattern, patternArgs)),
		CreateRiverPattern_Everything(GetConfigInfo(DefaultRiverPattern, patternArgs))
	};
	local pattern = patterns[UserInput.rivers];
		
	local stats = 
	{
		-- Number of rivers started.
		numRivers = 0,
		
		-- Number of lake tiles created for forward rivers.
		numLakeTiles = 0,
		
		-- Number of river segments added to the map.
		numSegments = 0,
	};
	
	-- Create data.
	local data = 
	{
		-- Helper functions
		AssignIDToLake           = RiverGenerator.AssignIDToLake,
		AssignIDToRiver          = RiverGenerator.AssignIDToRiver,
		ChooseNextFlowDir        = RiverGenerator.ChooseNextFlowDir,
		ChoosePattern            = RiverGenerator.ChoosePattern,
		GetIntersectInfo         = RiverGenerator.GetIntersectInfo,
		GetOppositeFlowDirection = RiverGenerator.GetOppositeFlowDirection,
		GetPlotElevation         = RiverGenerator.GetPlotElevation,
		GetRiverElevationAtPlot  = RiverGenerator.GetRiverElevationAtPlot,
		GetRiverIDs              = RiverGenerator.GetRiverIDs,
		GetRiverSegment          = RiverGenerator.GetRiverSegment,
		IsAdjacentRiver          = RiverGenerator.IsAdjacentRiver,
		IsCloseToAnotherStart    = RiverGenerator.IsCloseToAnotherStart,
		MergeRivers              = RiverGenerator.MergeRivers,
		PrintStats               = RiverGenerator.PrintStats,
		Reset                    = RiverGenerator.Reset,
		RiverPrint               = RiverGenerator.RiverPrint,
		SetRiver                 = RiverGenerator.SetRiver,
		Validate                 = RiverGenerator.Validate,
		ValidateTraverse         = RiverGenerator.ValidateTraverse,
		WouldFlowBetweenDryPlots = RiverGenerator.WouldFlowBetweenDryPlots,
		
		-- Top-Level functions
		AddCoastalRivers         = RiverGenerator.AddCoastalRivers,
		AddInlandRivers          = RiverGenerator.AddInlandRivers,
	
		-- River Propagation
		StartRiver               = RiverGenerator.StartRiver,
		DoRiver                  = RiverGenerator.DoRiver,
		DoNextRiver              = RiverGenerator.DoNextRiver,
	
		-- Parameters
		enableRiverDebug  = enableRiverDebug,
		gotGatheringStorm = gotGatheringStorm,
		wrapX             = wrapX,
		wrapY             = wrapY,
	
		-- Pattern-specific settings
		patterns = patterns,
		pattern  = pattern,
		
		-- Instrumentation.
		stats = stats,
	
		-- Keep track of places where we randomly decided not to start a river.
		-- So that we don't repeatedly roll dice for the same spot.
		skippedStartPlots = {},
		
		-- Keep track of starting locations for small rivers (mouths for reverse-
		-- river-gen) so that we can properly space them out.
		smallStartPlots = {},
		
		-- Keep track of river starting locations (mouths for reverse-river-gen) 
		-- so that we can properly space them out.
		normalStartPlots = {},
		
		-- Assign unique IDs to rivers so that we can allow certain kinds of merges
		-- but not self-merges.
		nextRiverID = 0,
		
		-- Map grid info
		iW       = iW,
		iH       = iH,
		numTiles = numTiles,
		
		-- Two maps of river plots for precise river-intersection detection
		--   S:  Which river is touching each plot's S  corner
		--   SE: Which river is touching each plot's SE corner
		riverPlots_S  = table.fill(-1, numTiles),	
		riverPlots_SE = table.fill(-1, numTiles),

		-- Assign IDs to the water plots of lakes as rivers flow into them
		-- so that no river flows both into and out of the same lake.
		lakeIDMap = table.fill(-1, numTiles),
		
		-- The chance of spawning a river-start lake.
		lakePlotRand = lakePlotRand,
        
        -- Whether to prevent spawning of additional lakes.
        noAddLakes = noAddLakes
	};
		
	return data;
end

function RiverGenerator:AssignIDToLake(lakePlot, id)
	-- Assign a unique lake ID to all plots in a lake.
	if (not (lakePlot and lakePlot:IsLake())) then
		return;
	end
		
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- assigned a lake ID to all water tiles in the lake.
	local stack = Stack:Create();
	local count = 0;
	local iVisited = GetPlotIndexLua(lakePlot:GetX(), lakePlot:GetY());
	
	stack:Push({x=lakePlot:GetX(), y=lakePlot:GetY()});
	self.lakeIDMap[iVisited] = id;
	
	while (not stack:IsEmpty()) do
	
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		-- Increase the water count.
		count = count + 1;
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot and adjacentPlot:IsLake()) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited water.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
			
				if (self.lakeIDMap[iCouldVisit] < 0) then
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					self.lakeIDMap[iCouldVisit] = id;
				end
			end
		end
	end

	self:RiverPrint("Assigned ID#" .. id .. " to lake of size " .. count);
end

function RiverGenerator:AssignIDToRiver(riverSegment)
	-- Assign an ID to a river and/or starting lake.
	-- 
	-- If the river starts from a lake, then the river and lake must
	-- have matching IDs to avoid the same river flowing both two 
	-- and from a lake.
	--
	-- Use lake ID if the river starting next to an already-ID'ed lake.
	--
	-- If the lake doesn't yet have an ID, assign a new ID to both 
	-- the lake and the river.
	--
	-- If the river is starting from salt water, just assign a new ID
	-- to the river.
	--
	-- Args: riverSegment: the river's first segment, i.e. the mouth
	-- Returns: the ID assigned to the river.
	
	local id = -1;
	local plot = riverSegment.lakeIDPlot;
	if (plot and plot:IsLake()) then
		-- Plot is starting at a lake.
		local plotIndex = GetPlotIndexLua(plot:GetX(), plot:GetY());
		local lakeID = self.lakeIDMap[plotIndex];
		
		if (lakeID < 0) then
			-- Lake with no ID.
			-- Use a new river ID and assign it to the lake.
			id = self.nextRiverID;
			self.nextRiverID = self.nextRiverID + 1;
			self:AssignIDToLake(plot, id);
		else
			-- Lake already has an ID.
			-- Use that for river ID.
			id = lakeID;
		end
	else
		-- Starting at a salty coast.
		-- Just use a new river ID.
		id = self.nextRiverID;
		self.nextRiverID = self.nextRiverID + 1;
	end
	return id;
end

function RiverGenerator:ChooseNextFlowDir(riverSegment, originalFlowDir)
	-- Decide which direction to take for the next segment of reverse-river gen.
	--
	-- Args: 
	--   riverSegment: current river segment; must have a next plot
	--   originalFlowDir: the river's original flow direction;
    --     use this to bias the river against extending back 
	--     towards the sea.	
	-- 
	-- Returns
	--   flowDir: the recommended flow direction; not necessarily a viable direction,
	--     but the best direction for this river segment.
	--   fallbackDir: the other flow direction to use as a fallback.
	local nextPlot = riverSegment.nextPlot;
	
	local directionIndex = 1 + TerrainBuilder.GetRandomNumber (2, "River Direction");

	local nextDirs = riverSegment.nextDirs;
	local flowDirA = nextDirs[1];
	local flowDirB = nextDirs[2];
	
	local flowDirAStr = FlowDirStr(flowDirA);
	local flowDirBStr = FlowDirStr(flowDirB);
	
	local riverInfoA = self:GetRiverSegment(nextPlot, flowDirA);
	local riverInfoB = self:GetRiverSegment(nextPlot, flowDirB);
		
	-- Check whether we have two directions to choose from.
	if (not (riverInfoB and riverInfoB.riverPlot)) then
		-- Direction B is no good.
		--
		-- We didn't check direction A, but even if A is not
		-- good, we still have to choose a direction, so just 
		-- go with direction A.
		self:RiverPrint("Choosing flowDir " .. flowDirAStr .. 
						" because " .. flowDirBStr .. " is no good.");
		return flowDirA, flowDirB;
	
	elseif (not (riverInfoA and riverInfoA.riverPlot)) then
		-- Direction A is no good, so just go with direction B.
		self:RiverPrint("Choosing flowDir " .. flowDirBStr .. 
						" because " .. flowDirAStr .. " is no good.");
		return flowDirB, flowDirA;
	end
	
	-- We have two directions, so compare elevation info.
	local valueA = self:GetRiverElevationAtPlot(riverInfoA.sourcePlot) +
		self:GetRiverElevationAtPlot(riverInfoA.riverPlot) +
		self:GetRiverElevationAtPlot(riverInfoA.otherSidePlot);

	local valueB = self:GetRiverElevationAtPlot(riverInfoB.sourcePlot) +
		self:GetRiverElevationAtPlot(riverInfoB.riverPlot) +
		self:GetRiverElevationAtPlot(riverInfoB.otherSidePlot);
	
	-- If we're flowing back towards the sea then we're going downhill,
	-- so slash elevation.
	local backwardsDir = self:GetOppositeFlowDirection(originalFlowDir);
	if (flowDirA == backwardsDir) then
		valueA = valueA / 4;
	
	elseif (flowDirB == backwardsDir) then
		valueB = valueB / 4;
	end
	
	-- Pick whichever flow direction leads to higher elevation,
	-- since we're generating the river in reverse.	
	if (valueA == valueB) then
		-- It's a tie, so randomly choose a direction.
		local flowDirIndex = 1 + TerrainBuilder.GetRandomNumber(2, "River Direction");
		return nextDirs[flowDirIndex], nextDirs[3-flowDirIndex];	
		
	elseif (valueB > valueA) then
		return flowDirB, flowDirA;
	end
	return flowDirA, flowDirB;
end

function RiverGenerator:ChoosePattern()
	-- Choose a river pattern for a potential river to start.
	if (self.pattern.isRandom) then
		-- Choose a random river pattern (not including the "everything" pattern).
		local randSize = (#self.patterns)-1;
		local riverDice = 1 + TerrainBuilder.GetRandomNumber(randSize, "Random river pattern");
		return self.patterns[riverDice];
	end
	
	-- Choose the user-specified non-random river pattern.
	return self.pattern;
end

function RiverGenerator:GetIntersectInfo(riverSegment, pattern)
	-- Analyze neighboring rivers to determine the type of intersection,
	-- of rivers if any, that would occur if a river existed at a
	-- certain segment.
	--
	-- Args: 
	--   riverSegment (must be non-nil): which river segment to check for 
	--     intersections
	--   pattern: the river pattern - affects which intersections are allowed
	--   
	-- Returns:
	--   isValid: true iff the intersection type is allowed
	--   isMerge: true iff the intersection would combine two different rivers
	--   typeStr: describes the type of interesction
	if (riverSegment.riverExists) then
		-- The river segment already exists. Complete overlap would occur.
		return false, false, "overlap";
		
	elseif ((riverSegment.riverPlot  == nil) or
		    (riverSegment.nextPlot   == nil) or 
	        (riverSegment.mouthPlot  == nil) or 
			(riverSegment.sourcePlot == nil)) then
		-- The river is either along or off the edge of the map.
		return true, false, "map edge";
	end
		
	-- Check river ID at each end of the segment.
	local mouthID, sourceID = self:GetRiverIDs(riverSegment);
	
	if (not (mouthID or sourceID)) then
		-- Unable to get river ID info.
		return false, false, "map edge (no river IDs)";
		
	elseif ((mouthID < 0) and (sourceID < 0)) then
		-- No rivers touching this segment.
		return true, false, "none";
			
	elseif (mouthID == sourceID) then
		-- River would intersect with itself.
		return false, true, "self";
	end
	
	-- The intersection is a merge if both ends already touch a river.
	local intersectIsMerge = (mouthID >= 0) and (sourceID >= 0);
		
	-- Mouth and Source are either different rivers, or one side
	-- doesn't exist yet.
	--
	-- Need to look at neighboring rivers to differentiate 
	-- various types of merges.
	local sourceRiverInfoA = 
		self:GetRiverSegment(riverSegment.nextPlot, riverSegment.nextDirs[1]);
		
	local sourceRiverInfoB = 
		self:GetRiverSegment(riverSegment.nextPlot, riverSegment.nextDirs[2]);
	
	-- Get info for the same river segment except in the opposite direction
	-- so that we can check which river segments are touching this 
	-- segment's mouth.
	local backwardsInfo = self:GetRiverSegment(
		riverSegment.nextPlot, self:GetOppositeFlowDirection(riverSegment.flowDir));
	
	local mouthRiverInfoA = nil;
	local mouthRiverInfoB = nil;
	
	if (backwardsInfo) then
		mouthRiverInfoA = self:GetRiverSegment(
			backwardsInfo.nextPlot, backwardsInfo.nextDirs[1]);
		
		mouthRiverInfoB = self:GetRiverSegment(
			backwardsInfo.nextPlot, backwardsInfo.nextDirs[2]);
	end
	
	local gotSourceA = sourceRiverInfoA and sourceRiverInfoA.riverExists;
	local gotSourceB = sourceRiverInfoB and sourceRiverInfoB.riverExists;
	local gotMouthA  = mouthRiverInfoA  and mouthRiverInfoA.riverExists;
	local gotMouthB  = mouthRiverInfoB  and mouthRiverInfoB.riverExists;
	
	local gotBothSource = gotSourceA and gotSourceB;
	local gotBothMouth  = gotMouthA  and gotMouthB;
	
	if (gotBothSource and gotBothMouth) then
		-- All four neighboring river segments exist.
		-- River would form an X-shaped merge
		return false, true, "inner x-merge";
		
	elseif (gotBothSource or gotBothMouth) then
		-- Either source or mouth branches off into two river segments.
		
		-- Need to further-analyze the side that has both 
		-- in order to detect the tip of an X-merge.
		local riverInfoA = sourceRiverInfoA;
		local riverInfoB = sourceRiverInfoB;
		if gotBothMouth then
			riverInfoA = mouthRiverInfoA;
			riverInfoB = mouthRiverInfoB;
		end
		
		local riverInfoAA = self:GetRiverSegment(
			riverInfoA.nextPlot, riverInfoA.nextDirs[1]);
		
		local riverInfoAB = self:GetRiverSegment(
			riverInfoA.nextPlot, riverInfoA.nextDirs[2]);
		
		local gotAA = riverInfoAA and riverInfoAA.riverExists;
		local gotAB = riverInfoAB and riverInfoAB.riverExists;
		
		if (gotAA and gotAB) then
			-- The last leg of an X-shaped merge would form.
			return false, intersectIsMerge, "outer x-merge-a";
		end
		
		local riverInfoBA = self:GetRiverSegment(
			riverInfoB.nextPlot, riverInfoB.nextDirs[1]);
		
		local riverInfoBB = self:GetRiverSegment(
			riverInfoB.nextPlot, riverInfoB.nextDirs[2]);
		
		local gotBA = riverInfoBA and riverInfoBA.riverExists;
		local gotBB = riverInfoBB and riverInfoBB.riverExists;
		
		if (gotBA and gotBB) then
			-- The last leg of an X-shaped merge would form.
			return false, intersectIsMerge, "outer x-merge-b";
		end
		
		if (intersectIsMerge == false) then
			-- An unclaimed vertex on one end two segments touching the other.
			-- And we've ruled-out the x-merge.
			-- So this segment would create a new branch off of another river.
			return pattern.allowBranch, false, "branch";
		end
		
		-- Both ends of the merge-side of the river have
		-- at most one river touching them each, so we've got
		-- a Y-shaped merge, which is OK.
		return pattern.allowYMerge, true, "y-merge"; 
	end
	
	if (intersectIsMerge == false) then
		-- An unclaimed vertex on one end one segment touching the other.
		-- Just a normal extension to a river.
		return true, false, "extension";
	end

	-- Both source and mouth is just one river segment.
	-- Merging rivers like this could form weird loops that 
	-- result in rivers with two mouths but no source.
	-- So don't allow this type of merge.
	return false, true, "end-to-end";
end

function RiverGenerator:GetOppositeFlowDirection(dir)
	local numTypes = FlowDirectionTypes.NUM_FLOWDIRECTION_TYPES;
	return ((dir + 3) % numTypes);
end

function RiverGenerator:GetPlotElevation(plot)

	if (plot:IsMountain()) then
		-- Mountains may be taller, but we don't want 
		-- rivers to hug them too much.
		-- Need a way to escape from mountain ranges.
		return 2;
	elseif (plot:IsHills()) then
		return 3;
	elseif (not plot:IsWater()) then
		return 2;
	else
		return 1;
	end
end

function RiverGenerator:GetRiverElevationAtPlot(plot)
	-- Custom method for reverse river propagation
	if (not plot) then
		-- Treat a map edge as a tall mountain.
		return 1000;
	end
	
	local sum = self:GetPlotElevation(plot) * 20;
	
	if IsAdjacentToSaltWater(plot:GetX(), plot:GetY()) then
		-- Saltwater coast is basically sea-level.
		-- We want the river to flow away from the sea,
		-- but possibly towards lakes.
		sum = sum - 1000;
	end

	-- Don't worry about cliffs or natural wonders. They don't exist yet.

	-- Factor neighboring plots into plot elevation.
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if (adjacentPlot) then
			sum = sum + self:GetPlotElevation(adjacentPlot);
		else
			sum = sum + 100;  -- Treat map edges as tall mountains.
		end
	end

	sum = sum + TerrainBuilder.GetRandomNumber(10, "River Rand");
	return sum;
end

function RiverGenerator:GetRiverIDs(riverSegment)
    -- Get river ID info for each end of a river segment.
	-- Args: riverSegment: which river segment to look-up.
	-- Returns:
	--   mouthID: which river, if any, would touch the mouth
	--   sourceID: which river, if any, would touch the source
	if (riverSegment == nil) then
		return nil, nil;
	end
	
	local mouthID  = nil;
	local sourceID = nil;
	
	local mouthPlot  = riverSegment.mouthIDPlot;
	if (mouthPlot) then
		local mouthIndex = GetPlotIndexLua(mouthPlot:GetX(), mouthPlot:GetY());
		mouthID = riverSegment.mouthIDMap[mouthIndex];
	end
	
	local sourcePlot  = riverSegment.sourceIDPlot;
	if (sourcePlot) then
		local sourceIndex = GetPlotIndexLua(sourcePlot:GetX(), sourcePlot:GetY());
		sourceID = riverSegment.sourceIDMap[sourceIndex];
	end
	
	return mouthID, sourceID;
end

function RiverGenerator:GetRiverSegment(targetPlot, flowDirection)
    -- Get all the direction-specific info about extending a river backwards 
    -- to flow in towards a target plot in a certain direction.
    -- Args:
    --   targetPlot: the S or SE plot corner where the next river segment would end
    --   flowDirection: the direction that the river would take to get to the
    --     target plot's SE edge. Must not be nil or "no direction"
    -- Returns:
    -- {
	--   targetPlot: the passed-in target plot
	--   flowDir: the passed-in flow direction
    --   nextPlot (can be nil): the next target plot for river propagation
	--   nextDirs: the directions that the river can take on the next plot.
    --   riverPlot (can be nil): where to place the river
    --   otherSidePlot (can be nil): shares the river edge with riverPlot
    --   sourcePlot (can be nil): where the new river would flow from
    --   mouthPlot (can be nil): where the new river would flow to
	--   sourceIDPlot (can be nil): which plot to use for getting the source-end's river ID
	--   mouthIDPlot (can be nil): which plot to use for getting the mouth-end's river ID
	--   lakeIDPlot (can be nil): which plot to use for getting the segment's lake ID
	--   mouthIDMap: which river ID map to use for the mouth (S or SE)
	--   sourceIDMap: which river ID map to use for the source (S or SE)
    --   riverExists: true iff riverPlot is non-nil and already has the river 
	--      that SetRiver would set.
    --   SetRiver: the direction-specific function to place the river on the plot;
    --      matches the signature of TerrainBuilder.Set__OfRiver() methods.
    -- }

    if (targetPlot == nil) then
        --self:RiverPrint("GetReverseRiverSegment: requires a non-nil target plot.");
        return nil;
    end
    
    local flowDirection = flowDirection or FlowDirectionTypes.NO_FLOWDIRECTION;
    if (flowDirection == FlowDirectionTypes.NO_FLOWDIRECTION) then
        self:RiverPrint("GetReverseRiverSegment: requires a meaninful flow direction.");
        return nil;
    end
    
	-- River propagation info
    local nextPlot = targetPlot;
	local nextDirs;
	
	-- Plots surrounding the river
	local riverPlot = targetPlot;
    local otherSidePlot;
    local sourcePlot;
    local mouthPlot;
	
	-- River intersection info
	local mouthIDMap;  -- Which map the mouth lives in (S or SE)
	local sourceIDMap; -- Which map the source lives in (S or SE)
	
	-- River state
    local riverExists = false;
    local SetRiver;

    -- Direction-specific logic:
    --   N and NW: riverPlot == nextPlot
    --   S and SE: riverPlot == targetPlot
    --   NE and SW: targetPlot == riverPlot == nextPlot
    if (flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
       
		nextPlot = Map.GetAdjacentPlot(
            targetPlot:GetX(), targetPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        
		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_NORTHWEST,
			FlowDirectionTypes.FLOWDIRECTION_NORTHEAST
		};
		
        riverPlot = nextPlot;
		mouthPlot = targetPlot;
		
		mouthIDMap  = self.riverPlots_S;
		sourceIDMap = self.riverPlots_SE;
        
        if (riverPlot ~= nil) then
            otherSidePlot = Map.GetAdjacentPlot(
                riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_EAST);
            
            sourcePlot = Map.GetAdjacentPlot(
                riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
				
            riverExists    = riverPlot:IsWOfRiver();
			SetRiver = TerrainBuilder.SetWOfRiver;
        end
			
	elseif (flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
		
		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_NORTH,
			FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST
		};
		
		otherSidePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);

		sourcePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
            
        mouthPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_EAST);

		mouthIDMap  = self.riverPlots_SE;
		sourceIDMap = self.riverPlots_S;
			
        riverExists    = riverPlot:IsNWOfRiver();
		SetRiver = TerrainBuilder.SetNWOfRiver;
		
	elseif (flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
		
        nextPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_WEST);
			
		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_SOUTH,
			FlowDirectionTypes.FLOWDIRECTION_NORTHEAST
		};
        
		otherSidePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
            
        sourcePlot = nextPlot;
        
        mouthPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);

		mouthIDMap  = self.riverPlots_S;
		sourceIDMap = self.riverPlots_SE;
			
        riverExists    = riverPlot:IsNEOfRiver();
		SetRiver = TerrainBuilder.SetNEOfRiver;
		
	elseif (flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
		
        nextPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
        
		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST,
			FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST
		};
		
		otherSidePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_EAST);
            
        sourcePlot = nextPlot;
        
        mouthPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);

		mouthIDMap  = self.riverPlots_SE;
		sourceIDMap = self.riverPlots_S;
			
        riverExists    = riverPlot:IsWOfRiver();
		SetRiver = TerrainBuilder.SetWOfRiver;
		
	elseif (flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then

		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_SOUTH,
			FlowDirectionTypes.FLOWDIRECTION_NORTHWEST
		};
	
		otherSidePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
            
		sourcePlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_EAST);
            
        mouthPlot = Map.GetAdjacentPlot(
            riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        
		mouthIDMap  = self.riverPlots_S;
		sourceIDMap = self.riverPlots_SE;
		
        riverExists    = riverPlot:IsNWOfRiver();
		SetRiver = TerrainBuilder.SetNWOfRiver;

	elseif (flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
		
		nextPlot = Map.GetAdjacentPlot(
            targetPlot:GetX(), targetPlot:GetY(), DirectionTypes.DIRECTION_EAST);
        
		nextDirs = 
		{
			FlowDirectionTypes.FLOWDIRECTION_NORTH,
			FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST
		};
		
        riverPlot = nextPlot;
        mouthPlot = targetPlot;
		
		mouthIDMap  = self.riverPlots_SE;
		sourceIDMap = self.riverPlots_S;
        
        if (riverPlot ~= nil) then
            otherSidePlot = Map.GetAdjacentPlot(
                riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
                
            sourcePlot = Map.GetAdjacentPlot(
                riverPlot:GetX(), riverPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
				
			riverExists    = riverPlot:IsNEOfRiver();
			SetRiver = TerrainBuilder.SetNEOfRiver;
		end        
	end
    
    return {
				targetPlot    = targetPlot,
				flowDir       = flowDirection,
				nextPlot      = nextPlot,
				nextDirs      = nextDirs,
                riverPlot     = riverPlot, 
                otherSidePlot = otherSidePlot, 
                sourcePlot    = sourcePlot,
                mouthPlot     = mouthPlot,
				sourceIDPlot  = nextPlot,
				mouthIDPlot   = targetPlot,
				lakeIDPlot    = mouthPlot,
				mouthIDMap    = mouthIDMap,
				sourceIDMap   = sourceIDMap,
                riverExists   = riverExists,
                SetRiver      = SetRiver
           };
end

function RiverGenerator:IsAdjacentRiver(riverSegment)
	-- Got enough river info to analyze neighboring river segments.
	local mouthID, sourceID = self:GetRiverIDs(riverSegment);
	return (((mouthID ~= nil) and (mouthID >= 0)) or
		    ((sourceID ~= nil) and (sourceID >= 0)));
end

function RiverGenerator:IsCloseToAnotherStart(pStartPlot)
	local iPlotIndex = pStartPlot:GetIndex();

	-- Distance threshold for skipped starts.
	local iNotAllowedAsCloseAs = 2;
	for i, riverPlotIndex in ipairs(self.skippedStartPlots) do
		if (Map.GetPlotDistance(iPlotIndex, riverPlotIndex) <= iNotAllowedAsCloseAs) then
		    return true;
		end
	end
	
	-- Distance threshold for small rivers.
	iNotAllowedAsCloseAs = 2;
	for i, riverPlotIndex in ipairs(self.smallStartPlots) do
		if (Map.GetPlotDistance(iPlotIndex, riverPlotIndex) <= iNotAllowedAsCloseAs) then
		    return true;
		end
	end

	-- Distance threshold for sufficiently-long rivers.
	iNotAllowedAsCloseAs = 4;
	for i, riverPlotIndex in ipairs(self.normalStartPlots) do
		if (Map.GetPlotDistance(iPlotIndex, riverPlotIndex) <= iNotAllowedAsCloseAs) then
		    return true;
		end
	end
	
	-- Also avoid map edges.
	return IsCloseToMapEdge(pStartPlot:GetX(), pStartPlot:GetY(), 1, self.wrapX, self.wrapY);
end

function RiverGenerator:MergeRivers(riverA, riverB)
	-- Merge two rivers into a single river system.
	-- Args: the ids of the rivers to merge.
	-- Returns: the id of the merged river.
	if ((riverA == nil) or 
		(riverB == nil) or 
		(riverA < 0) or 
		(riverB < 0)) then
		-- Programmer error.
		self:RiverPrint("MergeRivers: attempt to merge " .. 
			NonNilStr(riverA) .. " with " .. NonNilStr(riverB));
		return;
	end
	
	for y = 0, self.iH - 1, 1 do
		for x = 0, self.iW - 1, 1 do
			local i = GetPlotIndexLua(x,y);
			
			-- Replace all instances of riverA with riverB.
			if (self.riverPlots_S[i] == riverA) then
				self.riverPlots_S[i] = riverB;
			end
			if (self.riverPlots_SE[i] == riverA) then
				self.riverPlots_SE[i] = riverB;
			end
			if (self.lakeIDMap[i] == riverA) then
				self.lakeIDMap[i] = riverB;
			end
		end
	end
	self:RiverPrint("Merged river #" .. riverA .. " into river #" .. riverB);
	return riverB;
end

function RiverGenerator:PrintStats()
	print("Created " .. self.stats.numRivers .. " rivers and " .. 
		                self.stats.numSegments .. " river segments.");
						
	print("Created " .. self.stats.numLakeTiles .. " river-start lake plots.");
						
	print("River start-plot breakdown: " .. 
		tostring(table.maxn(self.skippedStartPlots)) .. " skipped, " ..
		tostring(table.maxn(self.smallStartPlots)) .. " small, " ..
		tostring(table.maxn(self.normalStartPlots)) .. " normal");
end

function RiverGenerator:Reset()
	-- Reset state. Call this before adding rivers.

	-- Ignore starts from previous rivers.
	self.skippedStartPlots = {};
	self.smallStartPlots   = {};
	self.normalStartPlots  = {};

	-- Reset stats.
	self.stats.numLakeTiles = 0;
	self.stats.numRivers    = 0;
	self.stats.numSegments  = 0;
end

function RiverGenerator:RiverPrint(str)
	-- Master-switch wrapper to enable/disable printing river debug messages to console.
	-- Because RiverGenerator has a lot of debug messages.
	if self.enableRiverDebug then
		print(NonNilStr(str));
	end
end

function RiverGenerator:SetRiver(riverSegment, riverID)
    -- Make the river at the river segment exist on the map.
	-- Also update river ID maps.
	-- Args: 
	--   riverSegment: which river segment to set.
	--   riverID: the ID of the river to which this segment belongs.
	if (not (riverSegment and riverSegment.riverPlot)) then
		-- Unable to set the river.
		self:RiverPrint("Attempt to extend river #" .. NonNilStr(riverID) .. 
						" at a non-existent river segment.");
		return;
	end
	
	-- Add the river to the global map.
	if self.gotGatheringStorm then
		-- Gathering Storm changed the signature of SetRiver().
		riverSegment.SetRiver(riverSegment.riverPlot, true, riverSegment.flowDir, riverID);
	else
		riverSegment.SetRiver(riverSegment.riverPlot, true, riverSegment.flowDir);	
	end
	
	-- Update river ID maps.
	local mouthPlot  = riverSegment.mouthIDPlot;
	if (mouthPlot) then
		local mouthIndex = GetPlotIndexLua(mouthPlot:GetX(), mouthPlot:GetY());
		riverSegment.mouthIDMap[mouthIndex] = riverID;
	end
	
	local sourcePlot  = riverSegment.sourceIDPlot;
	if (sourcePlot) then
		local sourceIndex = GetPlotIndexLua(sourcePlot:GetX(), sourcePlot:GetY());
		riverSegment.sourceIDMap[sourceIndex] = riverID;
	end
	
	-- Update stats.
	self.stats.numSegments = self.stats.numSegments + 1;
end

function RiverGenerator:Validate()
	-- Validate rivers on the map.
	-- In particular, detect cycles.
	self:RiverPrint("Validating rivers.");

	-- Map hex directions to river-detection methods.
	local IsRiverFunctions = {
		[DIRECTION_NE] = function(plot) 
			local plotNE = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), DIRECTION_NE);
			return plotNE and plotNE:IsNEOfRiver(); 
		end,
		
		[DIRECTION_E] = function(plot) 
			return plot:IsWOfRiver();
		end,
		
		[DIRECTION_SE] = function(plot) 
			return plot:IsNWOfRiver();
		end,
		
		[DIRECTION_SW] = function(plot) 
			return plot:IsNEOfRiver();
		end,
		
		[DIRECTION_W] = function(plot) 
			local plotW  = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), DIRECTION_W);
			return plotW and plotW:IsWOfRiver();
		end,
		
		[DIRECTION_NW] = function(plot) 
			local plotNW = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), DIRECTION_NW);
			return plotNW and plotNW:IsNWOfRiver();
		end	
	};
	
	local visitedMap = table.fill(0, self.numTiles);
	local valid = true;
	
	for x = 0, self.iW - 1, 1 do
		-- Traverse along the bottom edge of the map
		-- in order to support rivers touching the map edge.
		valid = valid and self:ValidateTraverse(IsRiverFunctions, visitedMap, x, 0);
	end
	
	if (not self.wrapY) then
		-- No y-wrap, so traverse starting at top edge too.
		for x = 0, self.iW - 1, 1 do
			-- Traverse along the bottom edge of the map
			-- in order to support rivers touching the map edge.
			valid = valid and self:ValidateTraverse(IsRiverFunctions, visitedMap, x, self.iH-1);
		end
	end
	
	if (not self.wrapX) then
		-- No x-wrap, so traverse starting at left and right edges too.
		for y = 0, self.iH - 1, 1 do
			-- Traverse along the bottom edge of the map
			-- in order to bypass rivers touching the map edge.
			valid = valid and self:ValidateTraverse(IsRiverFunctions, visitedMap, 0,      y);
			valid = valid and self:ValidateTraverse(IsRiverFunctions, visitedMap, self.iW-1, y);
		end
	end
	
	if (not valid) then
		self:RiverPrint("Rivers are invalid.");
		return;
	end
	
	-- Check for unvisited plots.
	local numUnvisited = 0;
	for y = 0, self.iH - 1, 1 do
		for x = 0, self.iW - 1, 1 do
			local i = GetPlotIndexLua(x, y);
			
			if (visitedMap[i] == 0) then
				self:RiverPrint("River cycle detected! Unable to reach " .. CoordString(x,y));
				numUnvisited = numUnvisited + 1;
			end
		end
	end
	if (numUnvisited == 0) then
		self:RiverPrint("Rivers are OK.");
	else	
		self:RiverPrint("Rivers have at least one cycle. Unable to reach " .. numUnvisited .. " tile(s)");
	end
end

function RiverGenerator:ValidateTraverse(IsRiverFunctions, visitedMap, startX, startY)
	-- Recursive helper method for river validation.
	-- Use a stack to visit the map in DFS order.
	--
	-- Args:
	--   IsRiverFunctions: a mapping of directions to river-existence test functions
	--   visitedMap: a map of visited flags for each plot
	--   startX, startY: where to begin traversal
	--
	-- Returns: true iff traversal was valid (false if something unexpected occurred).
	local stack = Stack:Create();
	stack:Push({x=startX, y=startY});
	
	local iVisited = GetPlotIndexLua(startX, startY);
	visitedMap[iVisited] = 1;
	
	while (not stack:IsEmpty()) do
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		local plot = Map.GetPlot(x,y);
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			local IsRiverFunc = IsRiverFunctions[direction];
						
			if (adjacentPlot and (not IsRiverFunc(plot))) then
				-- We have an adjacent plot that is not across a river.
				-- Let's see if it's unvisited.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = GetPlotIndexLua(aX, aY);
			
				if (visitedMap[iCouldVisit] == 0) then
					-- Add to the stack of plots to traverse.
					stack:Push({x=aX, y=aY});
					visitedMap[iCouldVisit] = 1;
				end
			elseif ((not adjacentPlot) and 
					((direction == DIRECTION_E) or 
					 (direction == DIRECTION_SE) or 
				     (direction == DIRECTION_SW)) and 
					IsRiverFunc(plot)) then
				self:RiverPrint("Detected a river that runs along the map edge at " .. 
					CoordString(x,y));
				return false;
			end
		end
	end
	return true;
end

function RiverGenerator:WouldFlowBetweenDryPlots(riverSegment)
	-- Return true iff the river at riverSegment would flow 
	-- between two non-nil, non-water plots.
	--
	-- Does not check whether the river actually exists on the map.
	return riverSegment and (riverSegment.riverPlot ~= nil) and (riverSegment.otherSidePlot ~= nil) and not
		((riverSegment.riverPlot:IsWater()) or (riverSegment.otherSidePlot:IsWater()));
end

function RiverGenerator:AddCoastalRivers()
	-- Add rivers to salt-water coasts.
	print("Adding coastal rivers (" .. self.pattern.name .. ")");
	
	self:Reset();
	
    -- Don't worry about natural wonders because they don't exist yet.
    -- Don't worry about coastal land because water-tile checks are direction-specific.
	for i = 0, self.numTiles - 1, 1 do
		local plot = Map.GetPlotByIndex(i);
        
        -- Don't start too close to another river's starting spot.
        if (not self:IsCloseToAnotherStart(plot)) then
            -- Consider all meaningful flow directions.
			-- Shuffle the directions for each plot to avoid directional bias.
			local flowDirs = GetShuffledCopyOfTable(FlowDirections);
            for i, flowDirection in ipairs(flowDirs) do
				-- Get the pattern for this potential river.
				local pattern = self:ChoosePattern();
			
				-- Get reverse-river propagation info.
				local riverSegment = self:GetRiverSegment(plot, flowDirection);
				
				local mouthPlot     = riverSegment.mouthPlot;
				local sourcePlot    = riverSegment.sourcePlot;
				
				-- Initial river flow:
					-- Avoid nearby rivers.
					-- Avoid map edges.
					-- Avoid water on either side of river.
					-- Avoid flowing directly from a water source.
					-- Check mouth for water, but mouth must be salty unless we allow lake-starts.
				if ((not self:IsAdjacentRiver(riverSegment)) and 
					(riverSegment.riverExists == false) and 
					(mouthPlot ~= nil) and (sourcePlot ~= nil) and
				    self:WouldFlowBetweenDryPlots(riverSegment) and 
					mouthPlot:IsWater() and 
					((not mouthPlot:IsLake()) or pattern.allowLakeMouths) and
					(not sourcePlot:IsWater())) then
					
					self:StartRiver(riverSegment, pattern, false);
					break;
				end
			end
        end
	end
	
	self:PrintStats();
end

function RiverGenerator:AddInlandRivers()
	-- Add rivers to areas that are far from the sea.
	print("Adding inland Rivers (" .. self.pattern.name .. ")");
	
	self:Reset();
	
	local plotsPerRiverEdge = GlobalParameters.RIVER_PLOTS_PER_EDGE or 12;
		
	local passConditions = {
		function(plot)
			return (plot:IsHills() or plot:IsMountain());
		end,
		
		function(plot)
			return (not plot:IsCoastalLand());
		end,
		
		function(plot)
			local area = plot:GetArea();
			return (plot:IsHills() or plot:IsMountain()) and 
			       (area:GetRiverEdgeCount() < ((area:GetPlotCount() / plotsPerRiverEdge) + 1));
		end,
		
		function(plot)
			local area = plot:GetArea();
			return (area:GetRiverEdgeCount() < (area:GetPlotCount() / plotsPerRiverEdge) + 1);
		end
	}
	
	-- Don't worry about natural wonders--they don't exist yet.
	for i = 0, self.numTiles - 1, 1 do
		local plot = Map.GetPlotByIndex(i);
		
		-- Don't start too close to another river's starting spot.
		if (not self:IsCloseToAnotherStart(plot)) then
		
			-- Scan the map multiple times to find and eliminate dry spots.		
			for iPass, passCondition in ipairs(passConditions) do
			
				-- Consider all meaningful flow directions.
				-- Shuffle the directions for each plot to avoid directional bias.
				local flowDirs = GetShuffledCopyOfTable(FlowDirections);
				for i, flowDirection in ipairs(flowDirs) do
					-- Get the pattern for this potential river.
					local pattern = self:ChoosePattern();
				
					-- Get river propagation info.
					local riverSegment = self:GetRiverSegment(plot, flowDirection);
					
					local mouthPlot     = riverSegment.mouthPlot;
					local sourcePlot    = riverSegment.sourcePlot;
										
					-- Initial river flow:
					-- Avoid nearby rivers.
					-- Avoid map edges.
					-- Avoid water on either side of river.
					-- Avoid flowing directly from a water source.
					-- Check mouth for water, but mouth must be salty unless we allow lake-starts.
					if ((not self:IsAdjacentRiver(riverSegment)) and 
					    (riverSegment.riverExists == false) and 
						(mouthPlot ~= nil) and (sourcePlot ~= nil) and
						self:WouldFlowBetweenDryPlots(riverSegment) and 
						(not sourcePlot:IsWater()) and 
						((not mouthPlot:IsLake()) or pattern.allowLakeMouths) and
						passCondition(sourcePlot)) then
						-- So far, so good.
						-- However, Civ6 in-game graphics require all rivers to flow
						-- into a water tile. So check whether the mouth plot is water.
						if (mouthPlot:IsWater() or CanHavePostLandmassLake(mouthPlot)) then
							-- Mouth plot either is water or can become water.
							local createLake = not mouthPlot:IsWater();
							self:StartRiver(riverSegment, pattern, createLake);
						end
						break;
					end
				end
			end
		end
	end
	
	self:PrintStats();
end

function RiverGenerator:StartRiver(riverSegment, pattern, createLake)
	-- Maybe start a river.
	if ((createLake == true) and 
        (self.noAddLakes or (pattern.allowCreateLakes == false))) then
		-- We wanted to start a river at a new lake, but lake-creation is disabled.
        -- We can't start a river here.
		return;
	end

	-- Roll dice to decide whether to start a river.
	local targetPlotIndex = riverSegment.targetPlot:GetIndex();
	
	local dice = TerrainBuilder.GetRandomNumber(100, "River recursion");
	if (dice >= pattern.startPct) then
		-- Record the canceled start plot 
		-- to avoid trying the plot in another direction.
		-- Allows us to tune the number of river starts.
		table.insert(self.skippedStartPlots, targetPlotIndex);
		return;
	end
	
	if (createLake == true) then
		-- Create a lake as a source for the river.
		local numLakeTilesAdded = AddPostLandmassLake(riverSegment.mouthPlot, self.lakePlotRand);
		if (numLakeTilesAdded == 0) then
			-- Did not create a lake here.
			return;
		end
		self.stats.numLakeTiles = self.stats.numLakeTiles + numLakeTilesAdded;		
	end

	-- Get the ID of the river's start.
	local riverID = self:AssignIDToRiver(riverSegment);
	
    -- Add the first plot's river.
	self:SetRiver(riverSegment, riverID);
	
	-- Update stats.
	self.stats.numRivers = self.stats.numRivers + 1;
	
	-- Look at elevation to decide which way to go.	
	local nextDir, fallbackDir = self:ChooseNextFlowDir(riverSegment, riverSegment.flowDir);
	
    -- Recursively draw the rest of the river.
    local newLength = self:DoRiver(
		riverSegment.nextPlot,
		nextDir, 
		riverSegment.flowDir, 
		1,
		riverID,
		pattern,
		false);
		
	if (newLength == 1) then
		-- The river didn't grow in that direction.
		-- Try the other direction.
		newLength = self:DoRiver(
			riverSegment.nextPlot,
			fallbackDir,
			riverSegment.flowDir, 
			1, 
			riverID,
			pattern,
			false);
	end
	
	if (newLength >= pattern.smallRiverLength) then
		-- Record the start plot to space-out start plots.
		-- Only do this for sufficiently-long rivers to avoid unnecessary gaps.
		table.insert(self.normalStartPlots, targetPlotIndex);
	else
		table.insert(self.smallStartPlots, targetPlotIndex);
	end
end

function RiverGenerator:DoRiver(
    startPlot, 
	thisFlowDirection, 
	originalFlowDirection, 
	curLength, 
	riverID,
	pattern,
	isBranch)
    -- Generate a river recursively from mouth to source.
    -- Args:
    --   startPlot: the plot at whose SE edge the river is ENDING
    --   thisFlowDirection: the direction the river would flow TOWARDS the start plot's SE edge
    --   originalFlowDirection: the direction in which the mouth of the river is facing
    --   curLength: the number of river segments that we have placed so far
    --   riverID: a unique ID to distinguish this river from other rivers
	--   pattern: the river pattern with which to generate this river
	--   isBranch: indicates whether we have recursively branched off of an existing river
	-- Returns:
	--   newLength: the new length of the river
	--   isMerge: true iff the river just merged with another river
	--   riverID: the new river ID
        
    local originalFlowDirStr = FlowDirStr(originalFlowDirection);
    local thisFlowDirStr     = FlowDirStr(thisFlowDirection);

	self:RiverPrint ("Extending " .. originalFlowDirStr .. " " .. pattern.name .. 
		   " river #" .. tostring(riverID) .. 
           " of length " .. tostring(curLength) .. 
		   " to flow " .. thisFlowDirStr ..
           " towards " .. CoordString(startPlot:GetX(), startPlot:GetY()));

	local newLength = curLength;
		   
	-- startPlot = the plot at whose SE edge the river is ENDING 
    -- (because we're going in reverse).
    --
    -- The next variables are relative to the river placed in this iteration:
    -- riverPlot: the plot that places the new river
    -- otherSidePlot: the plot across the new river from riverPlot
    -- sourcePlot: the plot that new the river flows from
    -- nextPlot: the plot at whose SE edge the new river ends
    local riverSegment = self:GetRiverSegment(startPlot, thisFlowDirection);
    if (not riverSegment) then
        self:RiverPrint("Stopping river; unable to get propagation info.");
        return newLength, false, riverID;
    end
	
	if (riverSegment.riverExists or (not self:WouldFlowBetweenDryPlots(riverSegment))) then
		-- River touches the map edge or a body of water.
        -- Stop recursion.
		self:RiverPrint("Stopping river from flowing " .. thisFlowDirStr .. ".");
		return newLength, false, riverID;
	end
    
    local riverPlot  = riverSegment.riverPlot;
    local sourcePlot = riverSegment.sourcePlot;
    if IsSaltWater(sourcePlot) then
        -- Don't let the river start at salt water.
        -- Stop recursion.
        self:RiverPrint("Stopping river from flowing " .. thisFlowDirStr .. " from salt water.");
        return newLength, false, riverID;
		
    elseif (sourcePlot and sourcePlot:IsLake()) then
		-- Don't let the river start and end at the same lake.
		local sourceLakeID = self.lakeIDMap[GetPlotIndexLua(sourcePlot:GetX(), sourcePlot:GetY())];
		if (riverID == sourceLakeID) then
			self:RiverPrint("Stopping river from flowing " .. thisFlowDirStr .. 
							" from an originating lake.");
			return newLength, false, riverID;
		end
	end
	
	local intersectIsValid, intersectIsMerge, intersectStr = 
		self:GetIntersectInfo(riverSegment, pattern);
	if (not intersectIsValid) then
		-- Intersection type not allowed.
		-- Stop recursion.
		self:RiverPrint("Stopping river to prevent a " .. thisFlowDirStr .. " " .. 
						intersectStr .. " intersection.");
        return newLength, false, riverID;
	end
	
	if (isBranch and intersectIsMerge) then
		-- Intersection type not allowed after a branch.
		-- Stop recursion.
		self:RiverPrint("Stopping river to prevent post-branch " .. intersectStr .. 
						" intersection.");
        return newLength, false, riverID;
	end
    
	local mouthID, sourceID = self:GetRiverIDs(riverSegment);
	self:SetRiver(riverSegment, riverID);
	newLength = newLength + 1;
              
   	local nextPlot = riverSegment.nextPlot; 
	
	-- Check whether we need to stop the river.
	-- Check for merges first in case we need to merge river IDs.
	if (intersectIsMerge) then
        -- The river has intersected another river. We are done.
        self:RiverPrint("Found a river source (another river).");

		-- Merge rivers.
		riverID = self:MergeRivers(riverID, sourceID);
        return newLength, true, riverID;
		
    elseif (sourcePlot ~= nil) and sourcePlot:IsLake() then
        -- The river is now flowing from a lake. We are done.
        self:RiverPrint("Found a river source (fresh water).");
		
		local sourceLakeID = self.lakeIDMap[GetPlotIndexLua(sourcePlot:GetX(), sourcePlot:GetY())];
		
		if (sourceLakeID < 0) then
			-- No other river has touched this lake.
			-- Tag the lake with the river ID.
			self:AssignIDToLake(sourcePlot, riverID);
			return newLength, false, riverID;
		else
			-- The lake is part of another river system. Merge rivers.
			riverID = self:MergeRivers(riverID, sourceLakeID);
			return newLength, true, riverID;
		end
	
    elseif ((nextPlot == nil) or (sourcePlot == nil)) then
        -- The river is now flowing from off the map / towards the edge of the map. We are done.
        self:RiverPrint("Found a river source (map edge).");
        return newLength, false, riverID;
		
    elseif (sourcePlot:IsMountain() and (newLength > pattern.softMaxLength)) then
        -- The river is now flowing from a mountain. We are done.
        self:RiverPrint("Found a river source (mountain).");
        return newLength, false, riverID;
    end
		
    -- Storing X,Y positions as locals to prevent redundant function calls.
	local nextPlotX = nextPlot:GetX();
	local nextPlotY = nextPlot:GetY();
    
	-- Choose the next flow direction.
	local bestFlowDir, fallbackFlowDir = 
		self:ChooseNextFlowDir(riverSegment, originalFlowDirection);
			
	-- Recursively generate river.
	return self:DoNextRiver(
		fallbackFlowDir,
		nextPlot, 
		bestFlowDir, 
		originalFlowDirection, 
		newLength, 
		riverID,
		pattern);
end

function RiverGenerator:DoNextRiver(
	fallbackFlowDir,
	nextPlot, 
	bestFlowDir, 
	originalFlowDirection, 
	curLength, 
	riverID,
	pattern)
	-- Extend the river recursively, and maybe also try the secondary direction,
	-- either as a fallback or as a branch.
	--
    -- Args:
	--   prevLength: the previous length of the river, for deciding whether to do fall-back.
	--   fallbackFlowDir: the secondary flow direction for falling-back or branching.
	--   nextPlot: the next plot for river propagation
    --   bestFlowDir: the 1st choioce of flow direction for river propagation
    --   originalFlowDirection: the direction in which the start of the river is facing
    --   curLength: the number of river segments that we have placed so far
    --   riverID: a unique ID to distinguish this river from other rivers
	--   pattern: the pattern with which to generate this river
	-- Returns:
	--   returnedLength: the length of the river after propagation has finished
	--   isMerge: true iff the river just merged with another river
	--   riverID: the new river ID
	
	if (curLength >= pattern.hardMaxLength) then
		-- River is at max length. 
		-- This allows the user to control the number of river segments.
		return curLength, false, riverID;
	end
	
	local isBranch = false;
	
	-- Recursive call in the 1st direction.
	local returnedLength, isMerge, returnedRiverID = self:DoRiver(
		nextPlot, 
		bestFlowDir, 
		originalFlowDirection, 
		curLength, 
		riverID,
		pattern,
		isBranch);
	
	-- By default, don't branch.
	-- Don't branch right before a merge.
	local fallbackDice = TerrainBuilder.GetRandomNumber(100, "River Fallback/Branch Recursion");
	local percentChance = 0;
	
	if (returnedLength == curLength) then
		-- The "best" flow direction didn't help.
		-- So maybe try the fallback direction.
		percentChance = pattern.fallbackPct;
	
	elseif (isMerge == false) then
		-- We didn't just merge with another river, so we can branch.
		isBranch = true;
		
		-- Randomly decide whether to create a branch.
		percentChance = pattern.branchPct;
	end
	
	if (curLength >= pattern.softMaxLength) then
		-- Reduce chances for longer rivers.
		-- Use current length to bias branches towards the start of propagation.
		percentChance = percentChance * pattern.longRiverFactor;
	end

	local branchLength = 0;
	if (fallbackDice < percentChance) then
		if isBranch then
			self:RiverPrint("River #" .. returnedRiverID .. " creating branch.");
		else
			self:RiverPrint("River #" .. returnedRiverID .. " trying the other direction.");
		end
			
		branchLength, isMerge, returnedRiverID = self:DoRiver(
			nextPlot, 
			fallbackFlowDir, 
			originalFlowDirection, 
			curLength, 
			returnedRiverID,
			pattern,
			isBranch);
	end
	return math.max(returnedLength, branchLength), false, returnedRiverID;
end