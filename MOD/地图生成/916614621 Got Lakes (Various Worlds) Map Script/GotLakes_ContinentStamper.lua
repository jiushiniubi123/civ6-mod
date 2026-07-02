-- Continent Stamper for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_ContinentStamper = {};

function GotLakes_ContinentStamper.Create()
	-- Constructor.
	local iW, iH, numTiles = GetMapGridSize();
	
	-- create instance data
	local instance = 
	{
		-- Methods
        GetContinentTypes = GotLakes_ContinentStamper.GetContinentTypes,
        GetPlotIndexLua   = GotLakes_ContinentStamper.GetPlotIndexLua,
        StampRows         = GotLakes_ContinentStamper.StampRows,
		StampArbitrarily  = GotLakes_ContinentStamper.StampArbitrarily,
		StampContinents   = GotLakes_ContinentStamper.StampContinents,
		
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles
	};
	
	return instance;
end

function GotLakes_ContinentStamper:GetContinentTypes()
    -- Get stampable continent types from game info.
    -- returns:
    --  - continents: a list of {id, name} continents to stamp.
    --  - numContinents: how many continents to stamp (matches the size of the list).
    
    -- Collect all continent info into a master list.
    local allContinentTypes = {};
    for row in GameInfo.Continents() do
        table.insert(allContinentTypes, {id = row.Index, name = row.PrimaryKey});
    end
    -- Shuffle the continent info so that we randomly choose continent types.
    allContinentTypes = GetShuffledCopyOfTable(allContinentTypes);
    
    local numContinentTypes = #allContinentTypes;
    if (numContinentTypes < 1) then
        print("Game info doesn't have any continent types! Skipping continent stamping.");
        return;
    end
    print("Got " .. numContinentTypes .. " continent type(s) available for stamping.");

    -- Figure out how many continents we actually need for this map.
    local numContinents = GameInfo.Maps[Map.GetMapSize()].Continents;
    print("Current map size expects " .. numContinents .. " continent(s).");

    -- Prevent number of expected continents from exceeding the number of available continents.
    numContinents = math.min(numContinents, numContinentTypes);
    print("Map will have " .. numContinents .. " continent(s).");
    
    local continentTypes = {};
    for i = 1, numContinents do
        table.insert(continentTypes, allContinentTypes[i]);
    end
    return continentTypes, numContinents;
end

function GotLakes_ContinentStamper:GetPlotIndexLua(x,y)
	-- Map (x,y) to a Lua (1-based) plot array index.
	-- Args: (x,y) where (0,0) is SW corner of the map and (iW-1, iH-1) is NE corner.
	-- Returns: plot array index where 1 is SW corner and iW*iH is NE corner.
	return (self.iW)*y + x + 1;
end

function GotLakes_ContinentStamper:StampRows()
    -- Stamp continents in rows (proof-of-concept).
    local continents, numContinents = self:GetContinentTypes();
    
    local rowsPerContinent = math.ceil(self.iH/numContinents);    
    for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do
            local plot = Map.GetPlot(x,y);
            -- Horizontal stripe continents.
            local iContinent = math.clamp(math.ceil(y/rowsPerContinent), 1, numContinents);
			TerrainBuilder.SetContinentType(plot, continents[iContinent].id)
		end
	end
end

function GotLakes_ContinentStamper:StampArbitrarily()
    -- Stamp continents arbitrarily i.e. without caring about mountains or water.
    local continents = self:GetContinentTypes();

    -- Temporary map of continent IDs so that we don't thrash the global map
    -- as we're traversing arbitrarily.
    local stamps = table.fill(-1, self.numTiles);

    -- Use a queue for expanding continents with BFS traversal.
    local stampQueue = Queue:Create();
    
    -- Initialize the queue with random start plots for continents
    for i, continent in ipairs(continents) do
        local plot = Map.GetPlotByIndex(TerrainBuilder.GetRandomNumber(
            self.numTiles, "continent stamp start plot"));
        local stampCoords = 
        {
            x         = plot:GetX(),
            y         = plot:GetY(),
            index     = self:GetPlotIndexLua(plot:GetX(),plot:GetY()),
            continent = continent,
            isStart   = true -- differentiate start coords from expansions when collision-checking
        };        
        print("Starting continent " .. continent.name .. 
              " at " .. CoordString(stampCoords.x, stampCoords.y));
        stampQueue:Enqueue(stampCoords);
    end
    
    local numTilesStamped = 0;
    
    while not stampQueue:IsEmpty() do
        -- Visit the next coords.
        local stampCoords = stampQueue:Dequeue();
        local x         = stampCoords.x;
        local y         = stampCoords.y;
        local index     = stampCoords.index;
        local continent = stampCoords.continent;
        local isStart   = stampCoords.isStart;
        local name      = continent.name;
        
        --print("Visiting " .. CoordString(x,y));
    
        local stamp = stamps[index];
        local doStamp = true;
        
        if ((stamp >= 0) and isStart) then
            -- We already have a stamp at these coords, and this is a starting plot.
            -- So we have a random start plot collision.
            -- Scan the map for another start plot.
            print("Got a start plot collision at " .. CoordString(x,y));
            
            -- Hopefully collisions are rare, so just scan the plots in index order
            -- until we find an available spot.
            local numTries = 0;
            local newIndex = index;
            while (stamps[newIndex] >= 0) and (numTries < self.numTiles) do
                numTries = numTries + 1;
                newIndex = newIndex + 1;
                if newIndex > self.numTiles then
                    newIndex = 1;
                end
            end
            if (numTries == self.numTiles) then
                -- Unable to start the continent, so just give up on this one.
                print("Somehow we scanned the whole map and could not find an unstamped " ..
                      "plot for starting " .. name);
                doStamp = false;
            else
                -- Found a new start plot.
                local newX =            (newIndex-1) % self.iW;
                local newY = math.floor((newIndex-1) / self.iW);
                print("Relocated " .. name .. " to " .. CoordString(newX,newY));
                x = newX;
                y = newY;
                index = newIndex;
            end
        elseif (stamp >= 0) then    
            -- We already have a stamp at these coords, and this is not a starting plot.
            -- Do not stamp.
            --print("Plot is already stamped at " .. CoordString(x,y));
            doStamp = false;
        end
    
        if doStamp then
            -- Decide whether to randomly defer stamping this plot.
            local deferDice = TerrainBuilder.GetRandomNumber(
                10, "Continent Stamping Deferral Dice");
            
            if ((not isStart) and 
                (numTilesStamped < (self.numTiles*0.9)) and 
                (deferDice < 4)) then
                -- Expansion plot with plenty of expansion remaining chosen for deferral.
                -- Punt this to the end of the queue, so that expansion is random.
                --print("Skipping " .. CoordString(x,y) .. " for now.");
                stampQueue:Enqueue(stampCoords);
            else
                --print("Stamping " .. name .. " onto " .. CoordString(x,y));
                stamps[index] = continent.id;
                numTilesStamped = numTilesStamped + 1;
                            
                -- Randomly enqueue neighboring tiles for expansion.
                -- Shuffle the directions so that the continents expand randomly.
                local shuffledDirs = GetShuffledCopyOfTable(HexDirections);
                for i, direction in ipairs(shuffledDirs) do
                    local adjPlot = Map.GetAdjacentPlot(x, y, direction);
                    if (adjPlot ~= nil) then
                        -- We have an adjacent plot.
                        local adjCoords = 
                        {
                            x         = adjPlot:GetX(),
                            y         = adjPlot:GetY(),
                            index     = self:GetPlotIndexLua(adjPlot:GetX(),adjPlot:GetY()),
                            continent = continent
                        }
                        -- Let's see if it's unvisited.
                        if (stamps[adjCoords.index] < 0) then
                            -- Add to the queue of plots to visit.
                            stampQueue:Enqueue(adjCoords);
                        end
                    end
                end
            end
        end        
    end
    
    -- Apply stamps to the global map.
    for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do
            local stamp = stamps[self:GetPlotIndexLua(x,y)];
            if stamp >= 0 then
                TerrainBuilder.SetContinentType(Map.GetPlot(x,y), stamp);
            end
		end
	end
end

function GotLakes_ContinentStamper:StampContinents()
	-- Run continent stamper.
	
    -- TODO make sure that these counts can detect a dry, flat map.
    if ((CountMountains() == 0) and (CountWater() == 0)) then
        -- Override continent stamping to avoid crashing the game during map gen.
        print("Stamping continents arbitrarily (no mountains, no water).");
        self:StampArbitrarily();
        return;
    end

	print("Stamping continents using the base game's stamper.");
	TerrainBuilder.StampContinents();
end
