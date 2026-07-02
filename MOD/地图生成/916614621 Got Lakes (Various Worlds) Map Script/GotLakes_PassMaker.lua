-- PassMaker for Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Utils"
------------------------------------------------------------------------------
-- A reusable reachability algorithm
--
-- Ensures that all passable tiles are reachable, regardless of the placement 
-- of impassable tiles. Creates passes if necessary.
--
-- Allows overrides to define what counts as passable or impassable.
------------------------------------------------------------------------------
PassMaker = {}

-- Possible values for each plot on a reachability map.
REACH_NO           = 0; -- Not reachable / not yet reached
REACH_YES          = 1; -- Reachable / target
REACH_SEEN         = 2; -- Dead-end removable obstacle (inside an unreachable area)
REACH_REMOVABLE    = 3; -- Removable obstacle
REACH_NONREMOVABLE = 4; -- Non-removable obstacle

local ENABLE_PASSMAKER_DEBUG = true;

function PassMaker.Create(args)
	-- Constructor.
	local args = args or {};
	local wholeMapW, wholeMapH = GetMapGridSize();

	local plotTypes       = args.plotTypes;      -- or nil
    local regionX         = args.regionX         or 0;
    local regionY         = args.regionY         or 0;
    local iW              = args.width           or wholeMapW;
    local iH              = args.height          or wholeMapH;
    local enableDebug     = args.enableDebug;    -- or nil
    local noHills         = args.noHills;        -- or nil
	local obstaclesName   = args.obstaclesName   or "mountains";
	local hillsPct        = args.hillsPct        or 15;
	local InitReachPlot   = args.InitReachPlot   or PassMaker.Mtn_InitReachPlot;
	local RemoveObstacle  = args.RemoveObstacle  or PassMaker.Mtn_RemoveObstacle;

	-- Default to global map accessors.
	local GetPlotType     = PassMaker.Map_GetPlotType;
	local SetPlotType     = PassMaker.Map_SetPlotType;
	local GetFeatureType  = PassMaker.Map_GetFeatureType;
	local RemoveFeature   = PassMaker.Map_RemoveFeature;
	local HasCliff        = PassMaker.Map_HasCliff;
	local RemoveCliffs    = PassMaker.Map_RemoveCliffs;
	local IsNaturalWonder = PassMaker.Map_IsNaturalWonder;
	local IsSaltWater     = PassMaker.Map_IsSaltWater;
	
	if (plotTypes ~= nil) then
		-- Injected plot-types array.
		-- Override to use field accessors.
		GetPlotType     = PassMaker.Field_GetPlotType;
		SetPlotType     = PassMaker.Field_SetPlotType;
		GetFeatureType  = PassMaker.Field_GetFeatureType;
		RemoveFeature   = PassMaker.Field_RemoveFeature;
		HasCliff        = PassMaker.Field_HasCliff;
		RemoveCliffs    = PassMaker.Field_RemoveCliffs;
		IsNaturalWonder = PassMaker.Field_IsNaturalWonder;
		IsSaltWater     = PassMaker.Field_IsSaltWater;
	end
	
	local data = 
	{
        -- Debugging
        DebugPrint                 = PassMaker.DebugPrint,
    
        -- Plot lookup to support sub-regions
        GetAdjacentPlot            = PassMaker.GetAdjacentPlot,
        GetGlobeXY                 = PassMaker.GetGlobeXY,
        GetPlot                    = PassMaker.GetPlot,
        GetPlotIndex               = PassMaker.GetPlotIndex,
        GetRegionXY                = PassMaker.GetRegionXY,
    
		-- Reachability algorithm.
		Initialize                 = PassMaker.Initialize,
		IsRemovableObstacle        = PassMaker.IsRemovableObstacle,
        FindReachStartsNearTargets = PassMaker.FindReachStartsNearTargets,
		ReachAroundObstacles       = PassMaker.ReachAroundObstacles,
        ReachFromTargets           = PassMaker.ReachFromTargets,
		FindRemovableObstaclesNearUnreached = 
			PassMaker.FindRemovableObstaclesNearUnreached,
		FindPassStart              = PassMaker.FindPassStart,
		SearchObstaclesForPass     = PassMaker.SearchObstaclesForPass,
		FindPass                   = PassMaker.FindPass,
		CreatePass                 = PassMaker.CreatePass,
		EnsureReachability         = PassMaker.EnsureReachability,
		
		-- Hooks for obstacle-specific logic.
		InitReachPlot  = InitReachPlot,
		RemoveObstacle = RemoveObstacle,
		
		-- Wrappers for plot types and feature types.
        IsAdjacentToLakeWithImpNaturalWonder 
                        = PassMaker.IsAdjacentToLakeWithImpNaturalWonder,
        IsLakeWithImpNaturalWonder
                        = PassMaker.IsLakeWithImpNaturalWonder,
		IsMountain      = PassMaker.IsMountain,
		IsIce           = PassMaker.IsIce,
		IsVolcano       = PassMaker.IsVolcano,
		GetPlotType     = GetPlotType,
		SetPlotType     = SetPlotType,
		GetFeatureType  = GetFeatureType,
		RemoveFeature   = RemoveFeature,
		HasCliff        = HasCliff,
		RemoveCliffs    = RemoveCliffs,
		IsNaturalWonder = IsNaturalWonder,
		IsSaltWater     = IsSaltWater,

		-- Grid info
        regionX   = regionX,
        regionY   = regionY,
		iW        = iW,
		iH        = iH,
		numTiles  = iW * iH,
        wholeMapW = wholeMapW,
        wholeMapH = wholeMapH,
		
		-- Misc params.
        enableDebug    = enableDebug,
        noHills        = noHills,
		plotTypes      = plotTypes,
		hillsPct       = hillsPct,
		obstaclesName  = obstaclesName,
	};
	
	data:Initialize();
	
	return data;
end

function PassMaker:DebugPrint(str)
	-- Master-switch wrapper to enable/disable printing debug messages to console.
	-- Because this class has a lot of debug messages.
	if self.enableDebug then
		print("PassMaker DEBUG: " .. tostring(str));
	end
end

function PassMaker:GetAdjacentPlot(x, y, direction)
    -- Returns the plot adjacent to (x,y) in the specified direction
    local globeX, globeY = self:GetGlobeXY(x,y);
    local plot = Map.GetAdjacentPlot(globeX, globeY, direction);
    
    if (self.iW == self.wholeMapW) and (self.iH == self.wholeMapH) then
        -- We have a whole-world map, so we can just use the Map API.
        return plot;
    end
    
    if not plot then
        -- Globally out of bounds.
        return nil;
    end
    
    -- Offset global plot's coords back to region coords and then bounds check
    local aX, aY = self:GetRegionXY(plot);
    if ((aX < 0) or (aX >= self.iW) or
        (aY < 0) or (aY >= self.iH)) then
       -- Regionally out of bounds.
       return nil; 
    end
    return plot;
end

function PassMaker:GetGlobeXY(x, y)
    -- Convert regional coordinates to global coordinates.
    return (self.regionX + x) % self.wholeMapW, self.regionY + y;
end

function PassMaker:GetPlot(x, y)
    -- Return a Plot from the global map at (x,y) which are not necessarily global coords.
    local globeX, globeY = self:GetGlobeXY(x,y);
    return Map.GetPlot(globeX, globeY);
end

function PassMaker:GetPlotIndex(x, y)
    -- Returns the Lua-style 1-based index for plot types at the specified regional coords.
    return self.iW*y + x + 1;
end

function PassMaker:GetRegionXY(plot)
    -- Convert global plot's coordinates back to regional coordinates.
    if not plot then
        print("ERROR: cannot get regional coordinates from a nil plot.");
        return 0, 0;
    end
    
    local x = plot:GetX() - self.regionX;
    if (((self.regionX + self.iW) >= self.wholeMapW) and (x < 0)) then
        -- Handle world wrap.
        x = x + self.wholeMapW;
    end
    
    local y = plot:GetY() - self.regionY;
    return x, y;
end

function PassMaker:Initialize()
	-- Initialize the reachability algorithm.
	--
	-- New fields:
	--   reachMap: map data containing reachability info of each tile.
	--   reachStart: start location for the initial reach scan
    --   reachTargets: a queue of targets to reach (in case we only need to reach a 
    --     target instead of all reachable tiles), or nil if not applicable
	--   numReachable: the number of reachable tiles (non-mountain lands)

	self:DebugPrint("Analyzing plots for reachability.");
    self:DebugPrint("SW Corner:       " .. CoordString(self.regionX, self.regionY));
    self:DebugPrint("Grid dimensions: " .. CoordString(self.iW, self.iH));
	
	-- Create a parallel map table to track reachability of each plot.
	local reachMap = table.fill(REACH_NO, self.numTiles);
	
	-- Scan for obstacles and a place to start reaching.
	local reachStart = nil;
    
    -- Scan for targets in case we only need to reach a single target.
    local reachTargets = Queue:Create();
	
	local numReachable = 0;
	
	self.allObsRemovable = true;
	
	-- Add some randomness to the start location of the initial scan.
	local iStart = 1 + TerrainBuilder.GetRandomNumber(self.numTiles, 
		"PassMaker - start location of initial scan.");
	self:DebugPrint("Beginning search for reach start at index " .. iStart);
		
	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do
			local i = self:GetPlotIndex(x,y);
					
			reachMap[i] = self:InitReachPlot(x,y);
			
			if (reachMap[i] == REACH_NO) then
				-- Reachable tile.
				numReachable = numReachable + 1;
		
				if (i >= iStart) and (not reachStart) then
					reachStart = {x=x, y=y};
                    self:DebugPrint("Found reach start at " .. CoordString(x,y));
				end
				
            elseif (reachMap[i] == REACH_YES) then   
                -- Got at least one target
                reachTargets:Enqueue({x=x, y=y});    
                
			elseif (reachMap[i] == REACH_NONREMOVABLE) then
				-- Got at least one non-removable obstacle.
				self.allObsRemovable = false;
			end
		end	
	end
	
	if (not reachStart) then
		-- We missed all of the potential starts in our attempt to randomize the
		-- location of the initial scan!
		print("We missed the potential start tiles; need to do another pass through plot types.");
		for iTile = 1, iStart, 1 do
			local x = ((iTile-1)  % self.iW);
			local y = math.floor((iTile-x-1) / self.iW);
						
			if (reachMap[iTile] == REACH_NO) then
				reachStart = {x=x, y=y};
                self:DebugPrint("Found reach start at " .. CoordString(x,y));
				break;
			end
		end
	end
	
	if (not reachStart) then
		print("No passable plots in the entire map!");
		return;
	end
	
	self.reachMap     = reachMap;
	self.reachStart   = reachStart;
    if not reachTargets:IsEmpty() then
        self.reachTargets = reachTargets;
    end
	self.numReachable = numReachable;
	
	self:DebugPrint("Analysis complete.");
end

function PassMaker:IsRemovableObstacle(iPlot)
	-- Determine whether the plot at iPlot is an obstacle that we can
	-- remove with a pass.
	--
	-- Args:
	--   iPlot: map index of the plot to check
	-- Returns:
	--   true iff the plot contains a removable obstacle
	return self.reachMap[iPlot] == REACH_REMOVABLE;
end

function PassMaker:FindReachStartsNearTargets()
    -- Find reachability-scan start tiles near target tiles.
    -- 
    -- Returns: a queue of start tiles for reachability scans.
    local reachStarts = Queue:Create();
    
    while not self.reachTargets:IsEmpty() do
        local target = self.reachTargets:Dequeue();
        local x = target.x;
        local y = target.y;
        
        for i, direction in ipairs(HexDirections) do
			local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited.
				local aX, aY = self:GetRegionXY(adjacentPlot);
				local iCouldVisit = self:GetPlotIndex(aX,aY);
				
				if (self.reachMap[iCouldVisit] == REACH_NO) then
					-- Add to the queue of reach starts.
					reachStarts:Enqueue({x=aX, y=aY});
				end
			end
		end
    end
    return reachStarts;
end

function PassMaker:ReachAroundObstacles(start, obsCoords)
	-- Visit all non-obstacle tiles that are reachable from the start tile.
	--
	-- Args:
	--   start: {x,y} coord of starting tile; must not be an obstacle tile.
	--   obsCoords: previous obstacle coords, or nil if this is the first reach.
	--
	-- Returns:
	--   numReached: the number of visited tiles.
	--   obsCoords: a stack containing the {x,y} of every obstacle tile within reach.
	self:DebugPrint("Reaching around obstacles.");
	
	-- Use a stack to search neighboring tiles in DFS order.
	local reachStack = Stack:Create();
	local obsCoords  = obsCoords or Stack:Create();
	
	local iVisited = self:GetPlotIndex(start.x, start.y);
	local count = 0;
    
    if (self.reachMap[iVisited] == REACH_YES) then
        -- Already reached this location.
        self:DebugPrint("Already reached " .. CoordString(start.x,start.y));
        return 0, obsCoords;
    end
	
	reachStack:Push(start);
	self.reachMap[iVisited] = REACH_YES;
	
	while (not reachStack:IsEmpty()) do
	
		local coord = reachStack:Pop();
		local x, y = coord.x, coord.y;
		
		local plot = self:GetPlot(x,y);
		
		-- Increase the reach count.
		count = count + 1;
        self:DebugPrint("Reached " .. CoordString(x,y));

		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited.
				local aX, aY = self:GetRegionXY(adjacentPlot);
				local iCouldVisit = self:GetPlotIndex(aX,aY);
							
				if (self.reachMap[iCouldVisit] == REACH_NO) then
					-- Add to the stack of plots to reach.
					reachStack:Push({x=aX, y=aY});
					self.reachMap[iCouldVisit] = REACH_YES;
					
				elseif (self:IsRemovableObstacle(iCouldVisit)) then
					-- Found a removable obstacle tile.
					-- Add to the stack of tiles to consider for passes
                    self:DebugPrint("Found a removable obstacle at " .. CoordString(aX,aY));
					obsCoords:Push({x=aX, y=aY});
				end
				-- Ignore obstacles that are not removable.
			end
		end
	end
	
	self:DebugPrint("Reached " .. count .. " tile(s).");
	
	return count, obsCoords;
end

function PassMaker:ReachFromTargets()
	-- Visit all non-obstacle tiles that are reachable from at least one target.
    -- 
    -- Intended for connecting coastal lowlands to inland seas
    -- without connecting the inland seas to each other.
	--
	-- Returns:
	--   numReached: the number of visited tiles.
	--   obsCoords: a stack containing the {x,y} of every obstacle tile within reach.
    print("Reaching for target tiles instead of the whole map.");
    
    -- Map targets to reach starts.
    local reachStarts = self:FindReachStartsNearTargets(self.reachTargets);

    local numReached = 0;
    local tgtNumReached = 0;
	local obsCoords  = nil;

    -- Run a reachability scan for each reach start.
    while not reachStarts:IsEmpty() do
        local reachStart = reachStarts:Dequeue();
        tgtNumReached, obsCoords = self:ReachAroundObstacles(reachStart, obsCoords);
        numReached = numReached + tgtNumReached;
    end

    print("Reached " .. numReached .. " tile(s) from targets.");
    return numReached, obsCoords;
end

function PassMaker:FindRemovableObstaclesNearUnreached()
	-- Find relevant obstacles near unreached tiles.
	--
	-- Returns: {x,y} stack of every relevant obstacle tile that is 
	--   adjacent to an unreached tile
	
	-- Add some randomness to the start location of the scan.
	local iOffset = TerrainBuilder.GetRandomNumber(self.numTiles, 
		"Reachability - start location of scan for obstacles near unreached tiles.");
	
	local obsCoords = Stack:Create();
	
	for i = 1, self.numTiles, 1 do
		
		-- Subtract one to make index zero-based,
		-- then use modulus to do zero-based wrap,
		-- then add one to return to one-based indexing.
		local iTile = (i + iOffset - 1) % self.numTiles + 1;
		
		local x = ((iTile-1)  % self.iW);
		local y = math.floor((iTile-x-1) / self.iW);
			
		if (self.reachMap[iTile] == REACH_NO) then
			-- Found an unreached tile.
			-- Check neighbors for obstacles.

			-- Shuffle directions to improve randomness of passes.
			local shuffledDirs = GetShuffledCopyOfTable(HexDirections);

			for j, direction in ipairs(shuffledDirs) do
				local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
									
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's unreached
					local aX, aY = self:GetRegionXY(adjacentPlot);
					local iCouldVisit = self:GetPlotIndex(aX, aY);
				
					if (self:IsRemovableObstacle(iCouldVisit)) then
						-- Found a removable obstacle next to an unreached tile.
						obsCoords:Push({x=aX,y=aY});
					end
				end
			end
		end	
	end
	
	return obsCoords;
end

function PassMaker:FindPassStart(obsCoords, passStart, passEnd)
	-- Find a candidate starting location for the pass search algorithm.
	--
	-- Args:
	--   obsCoords: a stack containing the {x,y} of obstacle tiles within reach.
	--   passStart: start passes at obstacle tiles next to this reach state
	--   passEnd: declare success when the pass reaches a tile with 
	--     this reach state.
	--
	-- Return a candidate start tile, or nil if no such start tile exists.
		
	-- Need to find removable obstacles that are next to an unreached tile.
    if not obsCoords then
        -- Somehow the obstacle coords were never initialized.
        print("FindPassStart: no obstacles to search for a pass!");
        return nil;
    end

	local start = nil;
	
	while (not obsCoords:IsEmpty()) do
	
		local obsCoord = obsCoords:Pop();
		local x = obsCoord.x;
		local y = obsCoord.y;
		local iTile = self:GetPlotIndex(x,y); 
	
		if (self:IsRemovableObstacle(iTile)) then
			-- Got an obstacle that we haven't yet seen.
		
			-- Check neighboring tiles to see if this is a good 
			-- place to look for a pass.
			local numPassStart = 0;
			local numPassEnd   = 0;
			local numNeighbors = 6;
			
			-- Shuffle directions to improve randomness of passes.
			local shuffledDirs = GetShuffledCopyOfTable(HexDirections);
			
			for i, direction in ipairs(shuffledDirs) do
				local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
									
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's unreached
					local aX, aY = self:GetRegionXY(adjacentPlot);
					local iCouldVisit = self:GetPlotIndex(aX,aY);
				
					if (self.reachMap[iCouldVisit] == passEnd) then
						-- Found a tile that matches end criteria.
						numPassEnd = numPassEnd + 1;
						
						-- We can stop searching neighbors, since
						-- this obstacle touches both start and 
						-- end terratory.
						break;
						
					elseif (self.reachMap[iCouldVisit] == passStart) then
						-- Found a tile that matches start criteria
						-- But we're not interested in obstacle tiles that
						-- are completely inside the starting zone.
						numPassStart = numPassStart + 1;
					end
				else
					-- At an edge of the map.
					numNeighbors = numNeighbors - 1;
				end
			end
	
			if (numPassEnd > 0) then
				-- Got a removable obstacle that is adjacent to an end tile.
				self:DebugPrint("Definite pass: " .. CoordString(x,y));
				return {x=x, y=y};
				
			elseif (numPassStart < numNeighbors) then
				-- Removable obstacle that is not surrounded by start tiles.
				self:DebugPrint("Possible pass: " .. CoordString(x,y));
				return {x=x, y=y};
			end
		end
	end
	
	print("FindPassStart: searched the entire map.");
	return nil;
end

function PassMaker:SearchObstaclesForPass(start, passEnd)
	-- Search through obstacles for a pass between reachable
	-- and unreachable tiles
	--
	-- Args:
	--   start: {x,y} of an obstacle tile from which to start searching obstacles
	--   passEnd: declare success when the pass reaches a tile with 
	--     this reach state.
	--
	-- Returns a stack of {x,y} coords representing a path
	--   or nil if no path found
	
	self:DebugPrint("Searching for a pass, starting at " .. CoordString(start.x,start.y));
	
	-- Use a stack to search neighboring tiles in DFS order.
	local stack = Stack:Create();

	stack:Push(start);
	
	while (not stack:IsEmpty()) do
	
		-- Don't pop the coord unless it's a dead-end.
		local coord = stack:Peek();
		local x, y = coord.x, coord.y;
		local iVisiting = self:GetPlotIndex(x, y);
		
		-- Mark the currently visited obstacle so that we don't
		-- visit the same tile multiple times.
		self.reachMap[iVisiting] = REACH_SEEN;
		
		self:DebugPrint("Scoping out " .. CoordString(x,y));
		
		local numObstacles = 0;
		
		-- First check whether we're at the end of the path.
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited.
				local aX, aY = self:GetRegionXY(adjacentPlot);
				local iCouldVisit = self:GetPlotIndex(aX, aY);
			
				if (self.reachMap[iCouldVisit] == passEnd) then
					-- We found a path across the obstacles!
					self:DebugPrint("Successfully crossed obstacles at " .. CoordString(aX,aY));
					return stack;
				
				elseif (self:IsRemovableObstacle(iCouldVisit)) then
					-- An unexplored removable obstacle tile.
					numObstacles = numObstacles + 1;
					
				elseif (self.reachMap[iCouldVisit] == REACH_SEEN) then
					-- An already-explored removable obstacle tile.
					numObstacles = numObstacles + 1;
				end
			end
		end
		
		-- Not at the end of the path.
		local foundSomething = false;
		
		if ((self.allObsRemovable == true) and (numObstacles < 3)) then
			-- We're walking along obstacles instead of crossing them!
			--
			-- Treat this as a dead-end.
			-- This optimization only works if all obstacles are removable.
			self:DebugPrint("Found " .. numObstacles .. " adjacent obstacle(s)..." .. 
				  "we're probably not on the shortest path."); 
		
		else
			-- Try to extend the path.
			--
			-- Shuffle the directions so that the path isn't
			-- a freakishly straight line or a giant hexagon
			local shuffledDirs = GetShuffledCopyOfTable(HexDirections);
			
			for i, direction in ipairs(shuffledDirs) do
				local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
				
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's unvisited.
					local aX, aY = self:GetRegionXY(adjacentPlot);
					local iCouldVisit = self:GetPlotIndex(aX, aY);
				
					if (self:IsRemovableObstacle(iCouldVisit)) then
						-- Add to the stack of plots to reach.
						stack:Push({x=aX, y=aY});
						foundSomething = true;
						break;
					end
				end
			end
		end
		
		if (foundSomething == false) then
			-- Remove this dead-end obstacle from the path.
			self:DebugPrint("Backtracking from dead-end at " .. CoordString(x,y));
			stack:Pop();
		end
	end
	
	print("No pass at " .. CoordString(start.x,start.y));
	
	-- No path from this obstacle tile to a reached tile.
	return nil;
end

function PassMaker:FindPass(obsCoords, passStart, passEnd)
	-- Search for an obstacle path that starts next to an unreachable
	-- tile and ends next to a reachable tile, or vice-versa.
	--
	-- Args:
	--   obsCoords: a stack containing the {x,y} of every 
	--      obstacle tile within reach
	--   passStart: start passes at obstacle tiles next to this reach state
	--   passEnd: declare success when the pass reaches a tile with 
	--     this reach state.
	--
	-- Returns:
	--   the start coord for the next reachability scan, 
	--      or nil if no pass exists
	--   a stack of obstacle tiles representing the pass, 
	--      or nil if no such pass exists.
		
	-- Search the map for removable obstacles that touch unreached terratory.	
	local obsStart = self:FindPassStart(obsCoords, passStart, passEnd);
	if (not obsStart) then
		print("Unexpected: no initial obstacle start in FindPass()");
		return nil, nil;
	end
	
	-- Traverse obstacles tiles until we find a path to a reachable tile.
	local pathCoords = nil;
	
	while ((not pathCoords) and obsStart) do
		-- Search for a path, starting at an obstacle tile next
		-- to the start tile.
		pathCoords = self:SearchObstaclesForPass(obsStart, passEnd);
		
		-- Reset pass backtracking.
		for i = 1, self.numTiles, 1 do
			if (self.reachMap[i] == REACH_SEEN) then
				self.reachMap[i] = REACH_REMOVABLE;
			end
		end
		
		if ((not pathCoords) or (pathCoords:IsEmpty())) then
			-- Unable to find a path out of the start zone.
			-- Need to search for another pass start.
			obsStart = self:FindPassStart(obsCoords, passStart, passEnd);
		end
	end

	if (not obsStart) then
		-- No ice pass detected, after searching the entire map.
		print("Failed to create a pass.");
		return nil, nil;
	end
	
	return obsStart, pathCoords;
end

function PassMaker:CreatePass(obsCoords, passStart, passEnd)
	-- Search for an unreachable tile.
	-- Then search for a path from that tile to a reachable
	-- tile and clear any removable obstacles on that path.
	--
	-- Args:
	--   obsCoords: a stack containing the {x,y} of every removable 
	--     obstacle tile within reach
	--   passStart: start passes at removable obstacles next to this 
	--     reach state
	--   passEnd: declare success when the pass reaches a tile with 
	--     this reach state.
	--
	-- Returns:
	--   the start coord for the next reachability scan. 
	--   the number of removable obstacle tiles altered by the pass.
	
	-- Search for a pass.
	local obsStart, pathCoords = self:FindPass(obsCoords, passStart, passEnd);
	
	if (not pathCoords) then
		print("Failed to find a pass.");
		return nil, 0;
	end
	
	self:DebugPrint("Creating a pass for reachability.");
	local pathSize = 0;
	
	while (not pathCoords:IsEmpty()) do 
		-- Clear obstacles from tiles in the pass.
		
		local coord = pathCoords:Pop();
		local x, y = coord.x, coord.y;
			
		local plotsModded = Stack:Create();
		
		-- Remove the current tile's obstacle.
		self:RemoveObstacle(x, y, plotsModded);
		
		while (not plotsModded:IsEmpty()) do
			-- Add all modded coords to the pass.
			local coordModded = plotsModded:Pop();
			local mX, mY = coordModded.x, coordModded.y;

			local iPass = self:GetPlotIndex(mX, mY);
			
			if (self.reachMap[iPass] ~= REACH_NO) then
				-- leave unreached until the next ReachTiles call()
				self.reachMap[iPass] = REACH_NO; 
				pathSize = pathSize + 1;
			end
			-- else we already added this tile to the pass.
		end		
	end
		
	self:DebugPrint("Pass size: " .. pathSize .. " tile(s).");
	
	-- Use the obstacle start for the next reachability scan, since
	-- we just turned that obstacle into a passable tile.
	return obsStart, pathSize;
end

function PassMaker:EnsureReachability()
	-- Make sure that all passable tiles are reachable 
	-- (that is, connected by at least one path of passable tiles).
	--
	-- Returns 0 if successful, nonzero otherwise.
	local obstaclesName = self.obstaclesName;
	print("PassMaker: Checking for tiles trapped by " .. obstaclesName);	
		
	if (not self.reachMap) then
		print("Failed to analyze plot types.");
		return 1;
	end
    	
	local reachStart   = self.reachStart;
	local numReachable = self.numReachable;
	local numUnreached = numReachable;
    local numReached   = 0;
	local pathSize;
	local obsYesCoords = nil;
	local obsCoords    = nil;
	
    if self.reachTargets then
        -- Scan for reachability to targets.
        numReached, obsYesCoords = self:ReachFromTargets();
    end
    -- If we reached any tiles from targets then we can skip the first reach in the loop.
    local doReach = (numReached == 0);
    
	-- Decide whether to search obstacles unreached -> reached or 
	-- vice-versa based on number of unreached tiles on the map.
	local passStart, passEnd;
	
	while (numUnreached > 0) do
        if doReach then
            -- Run a reachability scan on the map.
            numReached, obsYesCoords = self:ReachAroundObstacles(reachStart, obsCoords);
		end
        doReach = true;
        
		-- Update tile counts based on the reach.
		numUnreached = numUnreached - numReached;
		numReached   = numReachable - numUnreached;
		
		if (numUnreached > 0) then
			-- Not all tiles are reachable.
			print("Detected " .. numUnreached .. " unreachable tile(s) out of " .. 
								 numReachable .. " total.");
			
			if (numReached > (numReachable / 2)) then
				-- We've reached more than half of the reachable tiles.
				-- So it's more efficient to search for obstacles near unreached tiles,
				-- then to reach from an already-reached obstacles.
				self:DebugPrint("Most of the map is within reach.");
				passStart = REACH_NO;
				passEnd   = REACH_YES;
				
				obsCoords = self:FindRemovableObstaclesNearUnreached();
			else
				-- We haven't reached much of the map yet.
				-- Begin passes near what we've reached so far in order to
				-- expand our reach efficiently.
				self:DebugPrint("Most of the map is out of reach.");
				passStart = REACH_YES;
				passEnd   = REACH_NO;
				obsCoords = obsYesCoords;
			end
			
			-- Create a pass to make tiles reachable.
			-- Use the start of the pass for the next reachability scan.
			reachStart, pathSize = self:CreatePass(obsCoords, passStart, passEnd);
			
			if (not reachStart) then
				print("Failed to reach around " .. obstaclesName);
				return 2;
			end
			
			-- Update tile counts since we removed obstacles.
			numReachable = numReachable + pathSize;
			numUnreached = numUnreached + pathSize;
		end
	end
	
	print("All tiles are reachable around or through " .. obstaclesName);
	return 0;
end

function PassMaker:IsAdjacentToLakeWithImpNaturalWonder(x, y)
	-- Checks a plot (x, y) to see if it is any type of land adjacent to 
	-- at least one lake that contains an impassable natural wonder.    
    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = self:GetAdjacentPlot(x, y, direction);
		if (adjacentPlot ~= nil) then
            local aX, aY = self:GetRegionXY(adjacentPlot);
            if self:IsLakeWithImpNaturalWonder(aX, aY) then
                return true;
            end
		end
	end
	return false;
end

function PassMaker:IsLakeWithImpNaturalWonder(x,y)
	-- Check whether the plot at (x,y) is part of a lake that contains an impassable 
	-- natural wonder.	
	
	-- Check for neighboring lakes.
	-- Use a visit map to avoid double-counting lake plots.
	local visited = table.fill(0, self.numTiles);
	local iVisited = self:GetPlotIndex(x,y);
	visited[iVisited] = 1;
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- accounted for all neighboring lakes
	local stack = Stack:Create();	
	stack:Push({x=x, y=y});
	
	while (not stack:IsEmpty()) do
		local coord = stack:Pop();
		local cX, cY = coord.x, coord.y;
		
		local cPlot = self:GetPlot(cX,cY);
		
		--print("Looking for impassable wonder lakes at " .. CoordString(cX,cY));
		if (cPlot:IsNaturalWonder() and cPlot:IsImpassable()) then
			-- Found an impassable natural wonder.
			return true;
		end
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = self:GetAdjacentPlot(cX, cY, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				local aX, aY = self:GetRegionXY(adjacentPlot);
				local iCouldVisit = self:GetPlotIndex(aX,aY);

				if (adjacentPlot:IsLake() and (visited[iCouldVisit] == 0)) then
					-- Adjacent lake.
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end
	return false;
end

function PassMaker:IsMountain(x,y)
	return self:GetPlotType(x,y) == g_PLOT_TYPE_MOUNTAIN;
end

function PassMaker:IsIce(x,y)
	return self:GetFeatureType(x,y) == g_FEATURE_ICE;
end

function PassMaker:IsVolcano(x,y)
	return g_FEATURE_VOLCANO and (self:GetFeatureType(x,y) == g_FEATURE_VOLCANO);
end

function PassMaker:Field_GetPlotType(x,y)
	-- Get plot type from a private field.
	return self.plotTypes[self:GetPlotIndex(x, y)];
end

function PassMaker:Field_SetPlotType(x,y,plotType)
	-- Set plot type for a plot in a private field.
	self.plotTypes[self:GetPlotIndex(x, y)] = plotType;
end

function PassMaker:Field_GetFeatureType(x,y)
	-- Features don't exist until after terrain generation.
	return nil;
end

function PassMaker:Field_RemoveFeature(x,y)
	-- Features don't exist until after terrain generation.
end

function PassMaker:Field_HasCliff(x,y)
	-- Cliffs don't exist until after terrain.
	return false;
end

function PassMaker:Field_RemoveCliffs(x,y)
	-- Cliffs don't exist until after terrain.
end

function PassMaker:Field_IsNaturalWonder(x,y)
	-- Natural wonders don't exist until after terrain generation.
	return false;
end

function PassMaker:Field_IsSaltWater(x,y)
	-- For a field map, all water is ocean.
	return self:GetPlotType(x,y) == g_PLOT_TYPE_OCEAN;
end

function PassMaker:Map_GetPlotType(x,y)
	-- Get plot type from the global map.
	local plot = self:GetPlot(x,y);
	
	if plot:IsWater() then
		return g_PLOT_TYPE_OCEAN;
		
	elseif plot:IsMountain() then
		return g_PLOT_TYPE_MOUNTAIN;
	
	elseif plot:IsHills() then
		return g_PLOT_TYPE_HILLS;
		
	else
		return g_PLOT_TYPE_LAND;
	end
end

function PassMaker:Map_SetPlotType(x,y,plotType)
	-- Set plot type (terrain) for a plot in the global map.
	local plot = self:GetPlot(x,y);
	
	if (plotType == g_PLOT_TYPE_OCEAN) then
		-- Set shallow water.
		TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_COAST);
		return;
	end
	
	-- Map land plot type to a terrain type.
	local terrainOffset = 0; -- default for flat land.
	if (plotType == g_PLOT_TYPE_HILLS) then
		terrainOffset = 1;
		
	elseif (plotType == g_PLOT_TYPE_MOUNTAIN) then
		terrainOffset = 2;
	end
	
	local origTerrain = plot:GetTerrainType();
	local baseTerrain = g_TERRAIN_TYPE_GRASS;
	
	if ((origTerrain == g_TERRAIN_TYPE_PLAINS_HILLS) or 
		(origTerrain == g_TERRAIN_TYPE_PLAINS_MOUNTAIN)) then
		baseTerrain = g_TERRAIN_TYPE_PLAINS;
	end
	
	if ((origTerrain == g_TERRAIN_TYPE_DESERT_HILLS) or 
		(origTerrain == g_TERRAIN_TYPE_DESERT_MOUNTAIN)) then
		baseTerrain = g_TERRAIN_TYPE_DESERT;
	end
	
	if ((origTerrain == g_TERRAIN_TYPE_TUNDRA_HILLS) or 
		(origTerrain == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN)) then
		baseTerrain = g_TERRAIN_TYPE_TUNDRA;
	end
	
	if ((origTerrain == g_TERRAIN_TYPE_SNOW_HILLS) or 
		(origTerrain == g_TERRAIN_TYPE_SNOW_MOUNTAIN)) then
		baseTerrain = g_TERRAIN_TYPE_SNOW;
	end
	
	TerrainBuilder.SetTerrainType(plot, baseTerrain + terrainOffset);
end

function PassMaker:Map_GetFeatureType(x,y)
	-- Get feature type from global Map.
	local plot = self:GetPlot(x,y);
	return plot:GetFeatureType();
end

function PassMaker:Map_RemoveFeature(x,y)
	local plot = self:GetPlot(x,y);
	local terrainType = plot:GetTerrainType();
	-- Make the plot featureless.
	TerrainBuilder.SetFeatureType(plot, g_FEATURE_NONE);
	
	-- Set terrain to mountains and then hills in order to make the tile passable.
	TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_DESERT_MOUNTAIN); 
	TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_DESERT_HILLS); 
	
	-- Revert to the plot's original terrain type.
	TerrainBuilder.SetTerrainType(plot, terrainType);
end

function PassMaker:Map_HasCliff(x,y)
	local plot = self:GetPlot(x,y);
	-- Ignore cliffs when considering land tiles,
	-- so that we can have tiny islands with cliffs.
	return plot:IsWater() and HasCliff(plot);
end

function PassMaker:Map_RemoveCliffs(x,y)
	local plot = self:GetPlot(x,y);
	
	-- To ensure passability, just remove cliffs in all directions.
	TerrainBuilder.SetNEOfCliff(plot, false);	
	TerrainBuilder.SetNWOfCliff(plot, false);	
	TerrainBuilder.SetWOfCliff(plot,  false);
	
	local plotNW = self:GetAdjacentPlot(x, y, DIRECTION_NW);
	local plotW  = self:GetAdjacentPlot(x, y, DIRECTION_W);
	local plotNE = self:GetAdjacentPlot(x, y, DIRECTION_NE);

	if (plotNW ~= nil) then
		TerrainBuilder.SetNWOfCliff(plotNW, false);	
	end
	if (plotW ~= nil) then
		TerrainBuilder.SetWOfCliff(plotW, false);	
	end
	if (plotNE ~= nil) then
		TerrainBuilder.SetNEOfCliff(plotNE, false);	
	end
end

function PassMaker:Map_IsNaturalWonder(x,y)
	-- True iff the plot at (x,y) is an impassable natural wonder.
	-- Disregard passable wonders such as Cliffs of Dover
	local plot = self:GetPlot(x,y);
	return plot:IsNaturalWonder() and plot:IsImpassable();	
end

function PassMaker:Map_IsSaltWater(x,y)
	-- True iff the plot at (x,y) is salt water.
	local plot = self:GetPlot(x,y);
	return IsSaltWater(plot);	
end

function PassMaker:Ice_InitReachPlot(x,y)
	-- Calculate reachability val for a plot at (x,y).
	if (self:IsNaturalWonder(x,y) or 
	    self:IsMountain(x,y) or 
		self:HasCliff(x,y)) then
		-- Natural Wonder or mountain/cliff (mountains include volcanoes).
		return REACH_NONREMOVABLE;
	end
				
	if self:IsIce(x,y) then
		-- Ice
		return REACH_REMOVABLE;
	end
	
	return REACH_NO; -- Not yet reached.
end

function PassMaker:Ice_RemoveObstacle(x, y, plotsModded)
	-- Remove any obstacle at (x,y), which is expected to have an obstacle.
	-- Push any affected plots to plotsModded.
	
	-- Remove the ice from the plot.
	print("Removing ice at " .. CoordString(x,y));
	self:RemoveFeature(x,y);
	plotsModded:Push({x=x, y=y});
end

function PassMaker:Land_InitReachPlot(x,y)
	-- Calculate reachability val for a plot at (x,y).
	if (self:GetPlotType(x,y) ~= g_PLOT_TYPE_OCEAN) then
		return REACH_REMOVABLE;
	end
	
	return REACH_NO; -- Not yet reached.
end

function PassMaker:Land_RemoveObstacle(x,y, plotsModded)
	-- Remove any obstacle at (x,y), which is expected to have an obstacle.
	-- Push any affected plots to plotsModded.
	self:DebugPrint("Removing land at " .. CoordString(x,y));
	
	-- Turn land into water.
	self:SetPlotType(x,y,g_PLOT_TYPE_OCEAN);
	plotsModded:Push({x=x, y=y});
end

function PassMaker:Mtn_InitReachPlot(x,y)
	-- Calculate reachability val for a plot at (x,y).
	if (self:IsNaturalWonder(x,y) or self:IsVolcano(x,y)) then
		-- Natural Wonder or volcano.
		return REACH_NONREMOVABLE;
	end
	
	if self:IsMountain(x,y) or self:HasCliff(x,y) then
		-- Mountain or cliff.
		return REACH_REMOVABLE;
	end
	
	return REACH_NO; -- Not yet reached.
end

function PassMaker:Mtn_RemoveObstacle(x,y, plotsModded)
	-- Remove any obstacle at (x,y), which is expected to have an obstacle.
	
	-- The plot at (x,y) could be a mountain, have cliffs, or both;
	-- so always check for both mountain and cliffs.
	if self:IsMountain(x,y) then	
		print("Removing mountain at " .. CoordString(x,y));	
		
		-- Replace the mountain with either hills or flat land.
		-- Don't replace with water because that could cause bodies of 
		-- water to merge, which would affect lakes and rivers.
		local hillsDice = TerrainBuilder.GetRandomNumber(100, "Mountain Pass Hill");		
		if ((not self.noHills) and (hillsDice < self.hillsPct)) then
			-- Turn the mountain into a hill so that mountain passes can have random hills.
			self:SetPlotType(x,y,g_PLOT_TYPE_HILLS);
		else
			-- Keep the original flat land.
			self:SetPlotType(x,y,g_PLOT_TYPE_LAND);
		end
		plotsModded:Push({x=x, y=y});
	end
	
	if self:HasCliff(x,y) then
		print("Removing cliff(s) at " .. CoordString(x,y));	
		self:RemoveCliffs(x,y);
		
		if (self:IsMountain(x,y) == false) then
			-- Avoid double-counting plots that have both mountain and cliffs.
			plotsModded:Push({x=x, y=y});
		end
	end	
end

function PassMaker:NonSaltWater_InitReachPlot(x,y)
	-- Calculate reachability val for a plot at (x,y).
	if (self:IsNaturalWonder(x,y) or 
	    self:IsVolcano(x,y) or 
	    self:IsAdjacentToLakeWithImpNaturalWonder(x,y)) then
		-- Don't remove any impassable natural wonders or volcanoes.
		-- Also don't connect salt water to any lakes that contain impassable wonders.
		return REACH_NONREMOVABLE;
	end
	
	if (not self:IsSaltWater(x,y)) then
		-- Includes lakes, which if removed become salt water.
		return REACH_REMOVABLE;
	end
	
	return REACH_NO; -- Not yet reached.
end

function PassMaker:NonSaltWater_RemoveObstacle(x,y, plotsModded)
	-- Remove any obstacle at (x,y), which is expected to have an obstacle.
	-- Push any affected plots to plotsModded.
	print("Removing land at " .. CoordString(x,y));
	
	-- Check for neighboring lakes.
	-- Use a visit map to avoid double-counting lake plots.
	local visited = table.fill(0, self.numTiles);
	local iVisited = self:GetPlotIndex(x,y);
	visited[iVisited] = 1;
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- accounted for all neighboring lakes that have merged into the ocean.
	local stack = Stack:Create();	
	stack:Push({x=x, y=y});
	
	while (not stack:IsEmpty()) do
	
		local coord = stack:Pop();
		local cX, cY = coord.x, coord.y;
		
		self:DebugPrint("Looking for neighboring lakes at " .. CoordString(cX,cY));
		if (self:IsIce(cX,cY)) then
			-- Remove ice
			print("Removed ice at " .. CoordString(cX,cY));
			self:RemoveFeature(cX,cY);
		end
		plotsModded:Push({x=cX, y=cY});
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = self:GetAdjacentPlot(cX, cY, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				local aX, aY = self:GetRegionXY(adjacentPlot);
				local iCouldVisit = self:GetPlotIndex(aX,aY);

				if (adjacentPlot:IsLake() and (visited[iCouldVisit] == 0)) then
					-- Adjacent non-wonder lake.
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end
	
	-- Turn land and neighboring lakes into salt water.
	self:RemoveCliffs(x,y);
	self:RemoveFeature(x,y);
	self:SetPlotType(x,y,g_PLOT_TYPE_OCEAN);
end

function PassMaker:Water_InitReachPlot(x,y)
	-- Calculate reachability val for a plot at (x,y).
	if (self:GetPlotType(x,y) == g_PLOT_TYPE_OCEAN) then
		return REACH_REMOVABLE;
	end
	
	return REACH_NO; -- Not yet reached.
end

function PassMaker:Water_RemoveObstacle(x,y, plotsModded)
	-- Remove any obstacle at (x,y), which is expected to have an obstacle.
	-- Push any affected plots to plotsModded.
	
	-- Turn water into land.
	self:DebugPrint("Removing water at " .. CoordString(x,y));
	self:SetPlotType(x,y,g_PLOT_TYPE_LAND);
	plotsModded:Push({x=x, y=y});
end

function EnsureReachabilityWithPassMaker(args)
	-- Make sure that all passable tiles are reachable 
	-- (that is, connected by at least one path of passable tiles).
	local passMaker = PassMaker.Create(args);
	passMaker:EnsureReachability();
end