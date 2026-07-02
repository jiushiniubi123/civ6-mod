-- Naval Circumnavigation Channels for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_CircumnavGenerator = {};

-- Forward directions.
local FDIR_NORTH = 1;
local FDIR_FWD   = 2;
local FDIR_SOUTH = 3;
local EastDirections = { DIRECTION_NE, DIRECTION_E, DIRECTION_SE };
local WestDirections = { DIRECTION_NW, DIRECTION_W, DIRECTION_SW };

function GotLakes_CircumnavGenerator.Create(landInfo, wrapX, forceChannels, meanderPct)
	-- Constructor.
	-- Args:
	--   landInfo: info for the selected landmass
	--   wrapX: true iff the world wraps east-west
	--   forceChannels: whether to add circumnavigation channels to maps that are 
	--     already circumnavigable
	--   meanderPct: how often, as a percent val in [0,100], to allow random paths to
	--     meander from open water when given thance
	local iW, iH, numTiles = GetMapGridSize();
	
	local circumnav = UserInput.circumnav;
	if (circumnav == Circumnavigation.LANDBASE) then 
		-- Landmass-based.
		circumnav = landInfo.circumnav;
		print("Applying landmass-based circumnavigation (" .. landInfo.name .. ")");
	end
	
	-- create instance data
	local instance = 
	{
		-- Methods
		IsAdjacentToNonRemovable = GotLakes_CircumnavGenerator.IsAdjacentToNonRemovable,
		IsIce               	 = GotLakes_CircumnavGenerator.IsIce,
		IsImpassableWater   	 = GotLakes_CircumnavGenerator.IsImpassableWater,
		IsLand              	 = GotLakes_CircumnavGenerator.IsLand,
		ChooseStartCol  		 = GotLakes_CircumnavGenerator.ChooseStartCol,
		ChooseStartRows 		 = GotLakes_CircumnavGenerator.ChooseStartRows,
		RemoveIce 				 = GotLakes_CircumnavGenerator.RemoveIce,
		RemoveLand   			 = GotLakes_CircumnavGenerator.RemoveLand,
		ExtendPath          	 = GotLakes_CircumnavGenerator.ExtendPath,
		AddPath         		 = GotLakes_CircumnavGenerator.AddPath,
		IsCircumnavigable   	 = GotLakes_CircumnavGenerator.IsCircumnavigable,
		AddEdges 	        	 = GotLakes_CircumnavGenerator.AddEdges,
		AddPaths 	        	 = GotLakes_CircumnavGenerator.AddPaths,
		AddPlotTypeChannels 	 = GotLakes_CircumnavGenerator.AddPlotTypeChannels,
		AddIceChannels      	 = GotLakes_CircumnavGenerator.AddIceChannels,
		
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles,
		
		-- Args
		forceChannels = forceChannels,
		meanderPct = meanderPct,
		wrapX = wrapX,
		
		-- User inputs
		circumnav = circumnav,
		
		-- State
		numLandPlotsRemoved = 0,
		numIcePlotsRemoved = 0,
	};
	
	return instance;
end

function GotLakes_CircumnavGenerator:IsAdjacentToNonRemovable(x,y)
	-- Return true iff the position at (x,y) is adjacent to a non-removable obstacle.
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if (adjacentPlot ~= nil) then
			local aX = adjacentPlot:GetX();
			local aY = adjacentPlot:GetY();
			local iAdjacent = GetPlotIndexLua(aX,aY);
			if (self:IsObstacle(aX,aY) and (not self:IsRemovable(aX,aY))) then
				return true;
			end
		end
	end
	return false;
end

function GotLakes_CircumnavGenerator:IsIce(x,y)
	local plot = Map.GetPlot(x,y);
	return plot:GetFeatureType() == g_FEATURE_ICE;
end

function GotLakes_CircumnavGenerator:IsImpassableWater(x,y)
	local plot = Map.GetPlot(x,y);
	return plot and plot:IsWater() and plot:IsImpassable();
end

function GotLakes_CircumnavGenerator:IsLand(x,y)
	-- Any plot on the map that is not water counts as land.
	local i = GetPlotIndexLua(x,y);
	local plotType = self.plotTypes[i];
	return plotType and (plotType ~= g_PLOT_TYPE_OCEAN); 
end

function GotLakes_CircumnavGenerator:ChooseStartCol()
	print("Choosing start column for path channels.");
	
	-- Look for the column with the fewest obstacles.
	local colWithMostPathPlots = 0;
	local maxNumPathPlots      = 0;
	
	for x = 0, self.iW-1 do 
		local numPathPlots = 0;
		for y = 0, self.iH-1 do
			if (not self:IsObstacle(x,y)) then
				numPathPlots = numPathPlots + 1;
			end
		end
		if (numPathPlots > maxNumPathPlots) then
			colWithMostPathPlots = x;
			maxNumPathPlots = numPathPlots;
		end
	end
	
	if maxNumPathPlots == 0 then
		-- No water anywhere on the map!
		-- This can happen if landmass is Inverted Extras and Extras is None.
		-- Just choose a random columm.
		print("No water anywhere! Choosing a random column.");
		colWithMostPathPlots = TerrainBuilder.GetRandomNumber(self.iW, "Circumnav start col");
	end
	
	print("Chose column " .. colWithMostPathPlots);
	return colWithMostPathPlots;
end

function GotLakes_CircumnavGenerator:ChooseStartRows(x, numRows)
	print("Choosing " .. numRows .. " start row(s) for path channels at column " .. x);
	
	local iW = self.iW;
	local iH = self.iH;
	
	-- choose row(s) that have path plots in the start column.
	local pathRows = {};
	local removableRows = {};
	for y = 0, iH-1 do
		if not self:IsAdjacentToNonRemovable(x,y) then
			-- No non-removable obstacle nearby, so there's a decent
			-- chance that this path will *not* become a dead-end.
			if not self:IsObstacle(x,y) then
				table.insert(pathRows, y);
			elseif self:IsRemovable(x,y) then
				table.insert(removableRows, y);		
			end
		end
	end
	
	local selectedRows = pathRows;
	if (#selectedRows < numRows) then
		-- Not enough rows with path plots, so include rows with removable obstacles
		-- in case the map is completely dry.
		local shuffledRows = GetShuffledCopyOfTable(removableRows);
		local i = 1;
		while ((#selectedRows < numRows) and (i <= #shuffledRows)) do
			table.insert(selectedRows, shuffledRows[i]);
			i = i + 1;
		end
		if (#selectedRows < numRows) then
			-- Still not enough rows.
			-- Not sure how this is possible unless numRows is insanely large.
			print("Unable to find " .. numRows .. " starting spots. Found " ..
				  #selectedRows .. " instead.");
		end
			  
	elseif (#selectedRows > numRows) then
		-- Randomly choose a subset of the rows.
		local shuffledRows = GetShuffledCopyOfTable(selectedRows);
		selectedRows = {};
		for i = 0, numRows do
			table.insert(selectedRows, shuffledRows[i]);
		end
	end

	return selectedRows;
end

function GotLakes_CircumnavGenerator:RemoveIce(x,y)
	if self:IsIce(x,y) then
		print("Removing ice at " .. CoordString(x,y));
		self.numIcePlotsRemoved = self.numIcePlotsRemoved + 1;
	end
	
	local plot = Map.GetPlot(x,y);
	local terrainType = plot:GetTerrainType();
	
	-- Make the plot featureless.
	TerrainBuilder.SetFeatureType(plot, g_FEATURE_NONE);
	
	-- Set terrain to mountains and then hills in order to make the tile passable.
	TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_DESERT_MOUNTAIN); 
	TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_DESERT_HILLS); 
	
	-- Revert to the plot's original terrain type.
	TerrainBuilder.SetTerrainType(plot, terrainType);
end

function GotLakes_CircumnavGenerator:RemoveLand(x,y)
	if self:IsLand(x,y) then
		self.numLandPlotsRemoved = self.numLandPlotsRemoved + 1;
		print("Removing land at " .. CoordString(x,y));
	end
	local i = GetPlotIndexLua(x,y);
	self.plotTypes[i] = g_PLOT_TYPE_OCEAN;
end

function GotLakes_CircumnavGenerator:ExtendPath(
	x, y, numColsRemaining, startX, startYs, fwdDirs, visited)
	-- Choose the next tile in the path.
	-- Args:
	--   x, y: current position
	--   numColsRemaining: the number of remaining horizontal steps to take
	--   startX
	--   startYs: all starting rows; potential (x,y') ending locations if the map
	--     wraps east-west
	--   fwdDirs: intended flow directions (either east-facing or west facing,
	--     in order of north, forward, and south.
	--   visited: map of visited plots to support backtracking
	--
	-- Returns:
	--   newX, newY: next position; nil, nil indicates that the path has led to a dead end.
	local xyStr = CoordString(x,y);
	--print("Attempting to extend path from " .. xyStr);

	-- Find the closest starting row to the current position.
	local closestStartY = nil;
	local numRowsRemaining = self.iH+1;
	for i, startY in ipairs(startYs) do
		local yDist = math.abs(y - startY);
		if yDist < numRowsRemaining then
			closestStartY = startY;
			numRowsRemaining = yDist;
		end
	end
	
	--print("Closest start-y is at " .. tostring(closestStartY) .. 
	--      " which is " .. numRowsRemaining .. " row(s) away.");

	-- Determine which direction we need to go in order to reach the closest start row.
	local closestStartYDir = FDIR_FWD;
	if y > closestStartY then
		closestStartYDir = FDIR_SOUTH;
	elseif y < closestStartY then
		closestStartYDir = FDIR_NORTH;
	end
	
	local beelineDir = fwdDirs[closestStartYDir];
	local beelineDirStr = DirectionString(beelineDir);
	--print("Direction to closest start is " .. beelineDirStr);

	-- Determine which directions are available based on how many rows/cols we are from 
	-- the closest starting position.
	local availableDirs = fwdDirs;
	if (numRowsRemaining > numColsRemaining) then
		-- We're too far away from a starting position. Need to backtrack.
		print("Path at " .. xyStr .. " has meandered too far from a starting position.");
		return nil,nil;
	
	elseif (numRowsRemaining == numColsRemaining) then
		-- We have no wiggle room with which to meander.
		-- Need to beeline for the starting position.
		print("Need to beeline " .. beelineDirStr ..
			  " from " .. xyStr .. " towards row " .. closestStartY);
		availableDirs = {beelineDir};
	
	elseif ((closestStartYDir ~= FDIR_FWD) and
	        (numColsRemaining <= (numRowsRemaining * 2))) then
		-- The nearest goal is not straight ahead and we have limited wiggle room.
		local beelineThresh = math.ceil(100*numRowsRemaining/numColsRemaining);
		local wiggleDice = TerrainBuilder.GetRandomNumber(100, "Circumnav Wiggle Room");
		if (wiggleDice < beelineThresh) then
			-- No wiggle room. Just go straight towards the goal.
			print("Got some wiggle room at " .. xyStr ..
			      ", but decided to beeline " .. beelineDirStr ..
			      " towards row " .. closestStartY);
			availableDirs = {beelineDir};
		else 
			-- Allow either forward or towards the nearest start.
			--print("Got some wiggle room, but decided to allow meandering.");
			availableDirs = {beelineDir, fwdDirs[FDIR_FWD]};
		end
	end
	
	-- Analyze plots in available directions.
	local nonObstacles = {}; -- obstacle-free plots
	local obstacles = {};    -- plots with removable obstacles
	local visitables = {};   -- plots with either no obstacle or a removable obstacle
	for i, direction in ipairs(availableDirs) do
		local dirStr = DirectionString(direction);
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
		if (adjacentPlot ~= nil) then
			-- We have an adjacent plot.
			local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();			
			if (aX == startX) then
				-- We found a forward-facing adjacent spot on the starting column.
				for i, startY in ipairs(startYs) do
					if (aY == startY) then
						-- We reached a starting location!
						-- Short-circuit decision-making to complete the path.
						print("Found a starting location at " .. CoordString(aX,aY) .. "!");
						return aX, aY;
					end
				end
			end
			
			local iCouldVisit = GetPlotIndexLua(aX, aY);
			
			if (visited[iCouldVisit] == 0) then
				-- An unvisited adjacent plot.
				local candidate = {x = aX, y = aY};
				if self:IsRemovable(aX,aY) then
					-- Adjacent plot with a removable obstacle.
					--print(dirStr .. " is a removable obstacle at " .. CoordString(aX, aY));
					table.insert(obstacles, candidate);
					table.insert(visitables, candidate);
				elseif not self:IsObstacle(aX,aY) then
					-- Adjacent plot with no obstacle.
					--print(dirStr .. " is a non-obstacle at " .. CoordString(aX, aY));
					table.insert(nonObstacles, candidate);
					table.insert(visitables, candidate);
				end
			end
		end
	end
	
	if (#visitables == 0) then
		print("Reached a dead-end at " .. xyStr .. " with " .. numColsRemaining .. 
		      " column(s) remaining.");
		return nil, nil;
	end
	
	-- Start by randomly choosing from obstacle-free plots.
	local selectedCandidate = RandomElement(nonObstacles);
	
	if ((#nonObstacles > 0) and (#obstacles > 0)) then
		-- Got both obstacles and non-obstacles as candidates.
		-- Roll dice to decide whether to meander into obstacles
		-- or to prefer obstacle-free plots.
		local meanderDice = TerrainBuilder.GetRandomNumber(100, "Circumnav meander roll");
		if (meanderDice < self.meanderPct) then
			selectedCandidate = RandomElement(visitables);
			print("Choosing a plot that might be an obstacle near " .. xyStr);
		else
			print("Avoiding obstacles near " .. xyStr);
		end
	elseif (#nonObstacles > 0) then
		--print("No obstacles to avoid.");
	end
	
	-- First see if we can extend forward to an obstacle-free plot
	-- to avoid removing unnecessary land.
	if not selectedCandidate then
		-- Fall back to a plot that has an obstacle.
		--print("Unable to avoid obstacles.");
		selectedCandidate = RandomElement(obstacles);
	end

	return selectedCandidate.x, selectedCandidate.y;
end

function GotLakes_CircumnavGenerator:AddPath(startX, startY, startYs, startEast)
	-- Draw a path that circumnavigates the globe, starting at the specified coordinates.
	--
	-- If the map wraps east-west, then end at (x,y') where y' is any one of the 
	-- starting y locations. Otherwise, after reaching an east-west map edge, 
	-- return to the starting position and extend the path in the other direction
	--
	-- Args:
	--   startX, startY: starting coordinates
	--   startYs: all starting rows; potential (x,y') ending locations if the map
	--     wraps east-west
	--   startEast: whether to begin drawing the path to the east (true) or to the 
	--     west (false)
	print("Adding a path at " .. CoordString(startX, startY) .. "...");
	
	local fwdDirs = WestDirections;
	local bwdDirs = EastDirections;
	if startEast then
		fwdDirs = EastDirections;
		bwdDirs = WestDirections;
	end
	local curDirs = fwdDirs;
	print("Starting direction: " .. DirectionString(curDirs[FDIR_FWD]));
	
	local x = startX;
	local y = startY;
	if self:IsRemovable(x,y) then
		self:RemoveObstacle(x,y);
	end
	
	local visited = table.fill(0,self.numTiles);
	visited[GetPlotIndexLua(x,y)] = 1;
	
	local stack = Stack:Create();
	stack:Push({x=x,y=y});
	
	local numColsRemaining = self.iW;
	if not self.wrapX then
		-- One less column for non-wrap maps because non-wrap
		-- maps don't need to complete a loop.
		numColsRemaining = numColsRemaining - 1;
	end
	
	-- Extend the path until we reach an east-west map edge.
	while (numColsRemaining > 0) do
		if ( (not self.wrapX) and 
			 (((curDirs[FDIR_FWD] == DIRECTION_E) and (x == self.iW-1)) or
			  ((curDirs[FDIR_FWD] == DIRECTION_W) and (x == 0))) ) then
			-- We reached an east-west edge on a no-wrap map, and we're not done.
			-- Return to the start and go in the other direction.
			print("Reached column " .. x .. " on a non-wrap map. " ..
				  "Returning to start to extend path in the other direction.");
			x = startX;
			y = startY;
			curDirs = bwdDirs;
		end
		local newX, newY = self:ExtendPath(x, y, numColsRemaining, startX, startYs, curDirs, visited);		
		if not newX then
			-- Failed to extend the path.
			if stack:IsEmpty() then
				-- Backtracked the entire path...
				print("Failed to add a path. Somehow there is no way to circumnavigate " ..
					  "the world starting at " .. CoordString(startX, startY));
				return;
			end
			local coords = stack:Pop();
			if coords.x ~= x then
				numColsRemaining = numColsRemaining + 1;
			end
			x = coords.x;
			y = coords.y;
			print("Backtracking to " .. CoordString(x,y));
		else
			if newX ~= x then
				numColsRemaining = numColsRemaining - 1;
			end
			x = newX;
			y = newY;
			stack:Push({x=x,y=y});
			if self:IsRemovable(x,y) then
				self:RemoveObstacle(x,y);
			end
			visited[GetPlotIndexLua(x,y)] = 1;
		end
	end
	print("Path complete."); 
end

function GotLakes_CircumnavGenerator:IsCircumnavigable()
	-- Start at the bottom of the map and traverse obstacles upwards.
	-- If we can reach the top of the map, then the map is not circumnavigable.

	local starts = Queue:Create();
	local prevIsObstacle = nil;
	
	-- Scan the first row of the map for obstacle areas.
	for x = 0, self.iW-1 do
		local isObstacle = self:IsObstacle(x,0);
		if (isObstacle and 
			((prevIsObstacle == nil) or (prevIsObstacle ~= isObstacle)) ) then
			-- Got the first obstacle plot in an area of obstacles.
			starts:Enqueue(x);
		end
		prevIsObstacle = isObstacle;
	end
	
	-- Attempt to reach the top of the map from each obstacle area.
	local visited = table.fill(0, self.numTiles);
	
	while (not starts:IsEmpty()) do
		local startX = starts:Dequeue();
	
		-- Use a stack to search neighboring tiles in DFS order until we've
		-- reached the top of the map or explored the entire obstacle area.
		local stack = Stack:Create();
		
		local iVisited = GetPlotIndexLua(startX, 0);
		
		stack:Push({x=startX, y=0});
		visited[iVisited] = 1;
		
		while (not stack:IsEmpty()) do
			local coord = stack:Pop();
			local x, y = coord.x, coord.y;
			
			if (y == (self.iH-1)) then
				-- We traversed obstacles to the top of the map!
				-- Therefore the map IS NOT circumnavigable.
				return false;
			end
			
			for i, direction in ipairs(HexDirections) do
				local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
				
				if (adjacentPlot ~= nil) then
					-- We have an adjacent plot.
					-- Let's see if it's unvisited.
					local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
					local iCouldVisit = GetPlotIndexLua(aX, aY);
				
					if (self:IsObstacle(aX,aY) and (visited[iCouldVisit] == 0)) then
						-- Add to the stack of plots to visit.
						stack:Push({x=aX, y=aY});
						visited[iCouldVisit] = 1;
					end
				end
			end
		end
	end

	-- No path of obstacles from the bottom of the map to the top.
	-- Therefore the map IS circumnavigable.
	return true;
end

function GotLakes_CircumnavGenerator:AddEdges(plotTypes)
	-- Ensure top and bottom rows are ocean.
	print("Adding circumnavigation channels near edges/poles.");
	local iW = self.iW;
	local iH = self.iH;
	
	for x = 0, iW - 1 do
		self:RemoveObstacle(x,0);
		self:RemoveObstacle(x,iH-1);
	end
	
	if (not self.wrapX) then
		-- Regional Map: ditto for east & west edge columns.
		for y = 0, iH - 1 do
			self:RemoveObstacle(0,y);
			self:RemoveObstacle(iW-1,y);
		end	
	end
	print("Edges complete.");
end

function GotLakes_CircumnavGenerator:AddPaths(numPathChannels)
	print("Adding circumnavigation channels as random paths.");
	
	-- Make sure that we're specifying a positive number of channels.
	local numPathChannels = numPathChannels or 1;
	numPathChannels = math.floor(math.max(1, numPathChannels));
	
	local maxNumPathChannels = Round(self.iH/5);
	if (numPathChannels > maxNumPathChannels) then
		-- Limit the number of paths so that A) we don't remove too much
		-- land/ice, and B) the script completes in a reasonable timeframe.
		print("Reducing number of path channels from " .. numPathChannels .. 
			  " to " .. maxNumPathChannels);
		numPathChannels = maxNumPathChannels;
	end
	
	local startX = self:ChooseStartCol();
	local startYs = self:ChooseStartRows(startX, numPathChannels);
	
	for loop, startY in ipairs(startYs) do
		self:AddPath(startX, startY, startYs, RandomBool());
	end
end

function GotLakes_CircumnavGenerator:AddPlotTypeChannels(plotTypes, numPathChannels)
	-- Run circumnavigation generator on plot types.
	if (self.circumnav == Circumnavigation.NONE) then
		print("Skipping circumnavigation.");
		return;
	end
	
	self.plotTypes      = plotTypes;
	self.IsObstacle     = GotLakes_CircumnavGenerator.IsLand;
	self.IsRemovable    = GotLakes_CircumnavGenerator.IsLand;
	self.RemoveObstacle = GotLakes_CircumnavGenerator.RemoveLand;

	-- Decide whether to add channels.
	if self.forceChannels then
		print("Forcing circumnavigation channels.");
		
	elseif self:IsCircumnavigable() then
		print("Map is already circumnavigable without removing land.");
		return;
	end
	
	if (self.circumnav == Circumnavigation.EDGES) then
		self:AddEdges(plotTypes);
	else
		self:AddPaths(numPathChannels);
		if (self.circumnav == Circumnavigation.BOTH) then
			-- Add edges after adding paths
			-- so that paths don't get stuck at the N/S edges.
			self:AddEdges(plotTypes);
		end
	end
	
	print("Removed " .. self.numLandPlotsRemoved .. " non-water plot(s).");
end

function GotLakes_CircumnavGenerator:AddIceChannels(numPathChannels)
	-- Run circumnavigation generator on ice.
	if (self.circumnav == Circumnavigation.NONE) then
		print("Skipping circumnavigation.");
		return;
	end
	
	self.IsObstacle     = GotLakes_CircumnavGenerator.IsImpassableWater;
	self.IsRemovable    = GotLakes_CircumnavGenerator.IsIce;
	self.RemoveObstacle = GotLakes_CircumnavGenerator.RemoveIce;

	-- Decide whether to add channels.
	if ((not self.forceChannels) and self:IsCircumnavigable()) then
		print("Map is already circumnavigable without removing ice.");
		return;
	end
	
	-- Feature-Gen should have avoided coastal ice.
	-- Add paths to cut through any ice sheets that reach both
	-- north and south edges of the map.
	self:AddPaths(numPathChannels);
	print("Removed " .. self.numIcePlotsRemoved .. " ice plot(s).");
end
