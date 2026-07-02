-- Terrain Generator for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_TerrainGenerator = {};

function GotLakes_TerrainGenerator.Create(
	climateArgs,
	biomeArgs,
	sunlightArgs,
	donutFillingMap,
    hexMap,
	enabledTerrainsList,
	enabledTerrainsMap,
	createClimateFracFcn,
	latitudeFcn)
	-- Terrain-Gen constructor.
	-- Args:
	--   climateArgs: info for chosen climate
	--   biomeArgs: info for chosen biome
	--   sunlightArgs: info for chosen sunlight
	--   donutFillingMap: map indicating which plots are donut filling
    --   hexMap: optional struct with hexRadius and a list of hexes for a Hex landmass
	--   enabledTerrainsList: a whitelist of allowed land terrains
	--   enabledTerrainsMap: a map of land terrains to enabled status
	--   createClimateFracFcn: function to create a climate fractal given the fractal's name
	--   latitudeFcn: function to get latitude at (x, y)
	local iW, iH = GetMapGridSize();
    
    local hexMap = hexMap or {};
	
	local temperature = UserInput.temperature;
    local desertLevel = UserInput.desertLevel;
	local tundraLevel = UserInput.tundraLevel;
	local grassPlains = UserInput.grassPlains;
    local climateWrap = UserInput.climateWrap;
	local climate     = UserInput.climate;
	local sunlight    = UserInput.sunlight;
	local biome       = UserInput.biome;
	
	-- Special fractal for the poles of a regional tilted axis.
	-- Because solid tundra/snow/sand is not a fun place to start a game.
	local coldPolePct = sunlightArgs.coldPolePct[climate];
		
	-- Deserts are processed first, so Plains will take this 
	-- percentage of whatever remains. - Bob
	local desertBasePct = sunlightArgs.desertBasePct[climate];
	local desertPctOffset = 0;
	local desertPctShift = 0;
	
	if (sunlightArgs.enableDesertPctShift) then
		-- Enable desert fractal adjustments for certain types of sunlight.
		desertPctOffset = biomeArgs.desertPctOffset;
		desertPctShift  = 7;
	end
	local desertPct = desertBasePct + desertPctOffset;
	
	-- Plains vs Grassland.
	local plainsPct = biomeArgs.plainsPct;
	
	-- How much to increase the world's min/max latitude based on temperature.
	local temperatureLatShift = 0.1;
	
	-- How much to adjust various lat thresholds
    -- in order to increase/decrease tundra based on tundra level.
	local tundraLatShift = sunlightArgs.tundraLatShift[climate];
	
	-- Latitude interpolation ranges in [0,1], where 0 == hottest and 1 == uncropped coldest
	local desertMinLat         = sunlightArgs.desertMinLat[climate];
	local desertMaxLat         = sunlightArgs.desertMaxLat[climate];
	local tundraMinLat         = sunlightArgs.tundraMinLat[climate];
	local tundraNonRiverMaxLat = sunlightArgs.tundraNonRiverMaxLat[climate];
	local tundraMaxLat         = sunlightArgs.tundraMaxLat[climate];
	local snowMinLat           = sunlightArgs.snowMinLat[climate];
	local snowMaxLat           = sunlightArgs.snowMaxLat[climate];
	
	-- Offset the plains percentage by user selection of grass-plains mix.
	local plainsMult = DOWN_TO_UP2[grassPlains];
	plainsPct = plainsPct + (plainsMult * 10);
	
	-- Adjust terrain bands according to user's Temperature selection. 
	-- Compute change multiplier based on temperature.
	local tempMult  = DOWN_TO_UP2[temperature];
	desertPct            = desertPct            + (tempMult * desertPctShift);	
	desertMinLat         = desertMinLat         + (tempMult * temperatureLatShift);
	desertMaxLat         = desertMaxLat         + (tempMult * temperatureLatShift);
	tundraMinLat         = tundraMinLat         + (tempMult * temperatureLatShift);
    tundraNonRiverMaxLat = tundraNonRiverMaxLat + (tempMult * temperatureLatShift);
	tundraMaxLat         = tundraMaxLat         + (tempMult * temperatureLatShift);
	snowMinLat           = snowMinLat           + (tempMult * temperatureLatShift);
	snowMaxLat           = snowMaxLat           + (tempMult * temperatureLatShift);
	
    -- Adjust terrain bands that are relevant to desert level.
    -- Higher desert -> wider desert band and higher desert frequency, narrower fertile band
	local desertMult = DOWN_TO_UP2[desertLevel];
    print("desert mult:    " .. desertMult);
    desertPct            = desertPct            + (desertMult * desertPctShift);	
	desertMinLat         = desertMinLat         + (desertMult * temperatureLatShift);
	desertMaxLat         = desertMaxLat         + (desertMult * temperatureLatShift);
    
	-- Adjust terrain bands that are relevant to tundra level.
	-- Higher tundra => narrower desert and snow bands, wider tundra band
	local tundraMult = UP_TO_DOWN2[tundraLevel];	
	desertMaxLat         = desertMaxLat          + (tundraMult * tundraLatShift);
	tundraMinLat         = tundraMinLat          + (tundraMult * tundraLatShift);
	tundraNonRiverMaxLat = tundraNonRiverMaxLat  + (tundraMult * tundraLatShift);
	tundraMaxLat         = tundraMaxLat          + (tundraMult * tundraLatShift);
	snowMinLat           = snowMinLat            - (tundraMult * tundraLatShift);
        
    local gotFixedLat = (climateWrap == WWRAP_REGION) and (sunlight == Sunlights.STANDARD);
	
	local data = 
	{
		-- methods
		InitFractals		  = GotLakes_TerrainGenerator.InitFractals,
		InitAzimuthal         = sunlightArgs.TInitAzimuthal,
		InitRegion            = sunlightArgs.TInitRegion,
		GenerateTerrain		  = GotLakes_TerrainGenerator.GenerateTerrain,
        HexifyTerrain         = GotLakes_TerrainGenerator.HexifyTerrain,
        AnalyzeHex            = GotLakes_TerrainGenerator.AnalyzeHex,
        GenerateSolidHex      = GotLakes_TerrainGenerator.GenerateSolidHex,
        GenerateHybridHex     = GotLakes_TerrainGenerator.GenerateHybridHex,
        GenerateTerrainAtHex  = GotLakes_TerrainGenerator.GenerateTerrainAtHex,
        GenerateTerrainAtPlot = GotLakes_TerrainGenerator.GenerateTerrainAtPlot,
		ChooseTerrainAtPlot   = GotLakes_TerrainGenerator.ChooseTerrainAtPlot,
		CreateClimateFractal  = createClimateFracFcn,
		GetLatitudeAtPlot     = latitudeFcn,
		
		-- fields
		iW = iW,
		iH = iH,
        
        hexRadius      = hexMap.radius,
        numPlotsPerHex = hexMap.numPlotsPerHex,
        hexes          = hexMap.hexes,
		
		desertBottomPct   = 100-desertPct,
		plainsBottomPct   = 100-plainsPct,
		coldPoleBottomPct = 100-coldPolePct,		
		
		desertInterpFcn       = sunlightArgs.desertInterpFcn,
		tundraInterpFcn       = sunlightArgs.tundraInterpFcn,
		snowInterpFcn         = sunlightArgs.snowInterpFcn,
		
		desertMinLat          = desertMinLat,
		desertMaxLat          = desertMaxLat,
		tundraMinLat          = tundraMinLat,
		tundraNonRiverMaxLat  = tundraNonRiverMaxLat,
		tundraMaxLat          = tundraMaxLat,
		snowMinLat	          = snowMinLat,
		snowMaxLat	          = snowMaxLat,
		
		donutFillingMap     = donutFillingMap,
		enabledTerrainsList = enabledTerrainsList,
		enabledTerrainsMap  = enabledTerrainsMap,
        		
		gotDesertDonut = (gotDonut and
			(climateWrap == WWRAP_AZIMUTH) and 
			(sunlight    == Sunlights.TWOSUNS) and
            (climate     == Climates.SANDSTORM)),
		
        gotGrassDonut = (gotDonut and gotFixedLat and
			((climate     == Climates.STANDARD) or
             (climate     == Climates.GREENHOUSE)) and
            (grassPlains == GrassPlainsLevels.VLOW)),
            
        gotPlainsDonut = (gotDonut and gotFixedLat and
			((climate     == Climates.STANDARD) or
             (climate     == Climates.GREENHOUSE)) and
            (grassPlains == GrassPlainsLevels.VHIGH)),
        
        gotTundraDonut = (gotDonut and gotFixedLat and
			((climate     == Climates.ICEAGE) or
             (climate     == Climates.SNOWBALL)) and
            (tundraLevel == TundraLevels.VHIGH)),
        
		gotSnowDonut = (gotDonut and 
			(climateWrap == WWRAP_AZIMUTH) and 
			(sunlight    == Sunlights.STANDARD) and
            (climate     == Climates.SNOWBALL)),
		
        gotFixedLat = gotFixedLat,
		gotGlobe    = (climateWrap == WWRAP_GLOBE),
        
        -- Plot-order comparators for filling hybrid Hex Pangea hexes.
        hybridHexPlotComparatorNames = 
        {
            "bottom to top",
            "left to right",
            "bottom-left to top-right",
            "bottom-right to top-left"
        },
        hybridHexPlotComparators = 
        {
            -- Index order (bottom to top, left to right)
            function(a,b) return a.index < b.index; end,
            
            -- X order (left to right, bottom to top)
            function(a,b)
                if (a.x == b.x) then 
                    return a.index < b.index; 
                else
                    return a.x < b.x; 
                end
            end,
            
            -- X+Y order (bottom-left diagonally to top-right)
            function(a,b)
                if ((a.x+a.y) == (b.x+b.y)) then 
                    return a.index < b.index; 
                else
                    return (a.x+a.y) < (b.x+b.y); 
                end
            end,
            
            -- Y-X order (bottom-right diagonally to top-left)
            function(a,b)
                if ((a.y-a.x) == (b.y-b.x)) then 
                    return a.index < b.index; 
                else
                    return (a.y-a.x) < (b.y-b.x); 
                end
            end,
        },
	};
	
	data:InitFractals();
	
	return data;
end

function GotLakes_TerrainGenerator:InitFractals()
	-- Initialize terrain fractals and thresholds.	
	self.deserts = self.CreateClimateFractal("deserts");
	self.plains  = self.CreateClimateFractal("plains");
	self.cold    = self.CreateClimateFractal("cold");
	self.polar   = self.CreateClimateFractal("polar");
	
	self.desertTop = GetFractalHeight(self.deserts, 100);
	self.plainsTop = GetFractalHeight(self.plains, 100);
	
	-- Shift some plains away from hills towards flat tiles for playability.
	self.plainsHillBottom = GetFractalHeight(self.plains, self.plainsBottomPct + 25);
	self.plainsFlatBottom = GetFractalHeight(self.plains, self.plainsBottomPct - 8);
end

function GotLakes_TerrainGenerator:Default_InitAzimuthal(enableRandomPoles, centerIsHot)
	-- No-op by default. Custom hook for Terrain Generator.
	return {makeCenterHot = true};
end

function GotLakes_TerrainGenerator:Default_InitRegion(enableRandomPoles, defaultR, defaultTheta)
	-- No-op by default. Custom hook for Terrain Generator.
	return {0,0,0,0,0,1};
end

function GotLakes_TerrainGenerator:GenerateTerrain()		
	-- Generate terrain for all non-water plots.
	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do 
			self:GenerateTerrainAtPlot(x, y, self.GetLatitudeAtPlot(x,y));
		end
	end
    
    if self.hexes then
        -- Got hexes from the Hex pangea.
        -- Overwrite terrains for the pangea.
        if self.gotFixedLat then
            -- Fixed latitude for the whole map.
            print("Hexifying terrain (Hex landmass + fixed latitude).");
            -- Replace fractal layers with a shuffle of mostly single-terrain hexes.
            self:HexifyTerrain();
        else
            -- Got latitude bands.
            print("Forcing a single latitude for each hex (Hex landmass + latitude bands).");
            -- Reapply fractal layers,
            -- but this time use the same latitude for all plots in each hex.
            for i, hex in ipairs(self.hexes) do
                self:GenerateTerrainAtHex(hex);
            end
        end
    end
end

function GotLakes_TerrainGenerator:HexifyTerrain()
    -- Coerce terrain into hexes that are mostly homogenous.
    
    -- Shuffle hexes to avoid directional biases.
    local hexes = GetShuffledCopyOfTable(self.hexes);

    -- Analyze terrain of hexes to get terrain plot counts.
    local countDesert = 0;
    local countGrass  = 0;
    local countPlains = 0;
    local countSnow   = 0;
    local countTundra = 0;
    for i, hex in ipairs(hexes) do
        local hexDesert, hexGrass, hexPlains, hexSnow, hexTundra = self:AnalyzeHex(hex);
        -- Track the number of land plots in each hex.
        hex.numLandPlots = hexDesert + hexGrass + hexPlains + hexSnow + hexTundra;
        
        -- Update pangea totals.
        countDesert = countDesert + hexDesert;
        countGrass  = countGrass  + hexGrass;
        countPlains = countPlains + hexPlains;
        countSnow   = countSnow   + hexSnow;
        countTundra = countTundra + hexTundra;
    end

    -- Overwrite terrain one hex at a time.
    for i, hex in ipairs(hexes) do
        local numLandPlots = hex.numLandPlots;
    
        -- Figure out which flavor of hex to make.
        local solidTerrainType = nil;
        if (countDesert >= numLandPlots) then
            solidTerrainType = g_TERRAIN_TYPE_DESERT;
            countDesert = countDesert - numLandPlots;
            
        elseif (countGrass >= numLandPlots) then
            solidTerrainType = g_TERRAIN_TYPE_GRASS;
            countGrass = countGrass - numLandPlots;
        
        elseif (countPlains >= numLandPlots) then
            solidTerrainType = g_TERRAIN_TYPE_PLAINS;
            countPlains = countPlains - numLandPlots;
            
        elseif (countSnow >= numLandPlots) then
            solidTerrainType = g_TERRAIN_TYPE_SNOW;
            countSnow = countSnow - numLandPlots;
            
        elseif (countTundra >= numLandPlots) then
            solidTerrainType = g_TERRAIN_TYPE_TUNDRA;
            countTundra = countTundra - numLandPlots;
        end
        if solidTerrainType then
            -- Make a homogenous hex.
            self:GenerateSolidHex(hex, solidTerrainType);
        else
            -- Make a hybrid hex.
            countDesert, countGrass, countPlains, countSnow, countTundra = self:GenerateHybridHex(
                hex, countDesert, countGrass, countPlains, countSnow, countTundra);    
        end
    end
end

function GotLakes_TerrainGenerator:AnalyzeHex(hexInfo)
    local countDesert = 0;
    local countGrass  = 0;
    local countPlains = 0;
    local countSnow   = 0;
    local countTundra = 0;

    local hexRadius = self.hexRadius;
    local visitedPlots = {};
    local hexes = Queue:Create();
    hexes:Enqueue({x=hexInfo.x, y=hexInfo.y, r=hexRadius});
    
    while not hexes:IsEmpty() do
        local hex = hexes:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local r = hex.r;
        local iPlot = GetPlotIndexLua(x,y);
        if (not visitedPlots[iPlot]) then
            -- 1st time visiting this plot.
            visitedPlots[iPlot] = true;
            
            local plot = Map.GetPlotByIndex(iPlot-1);
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
            end
            
            if (r > 1) then
                for i, direction in ipairs(HexDirections) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
    local numLandPlots = countDesert + countGrass + countPlains + countSnow + countTundra;
    
    return countDesert, countGrass, countPlains, countSnow, countTundra, numLandPlots;
end

function GotLakes_TerrainGenerator:GenerateSolidHex(hexInfo, terrainType)
    print("Generating " .. TerrainString(terrainType) .. " hex at " .. 
          CoordString(hexInfo.x,hexInfo.y));

    local hexRadius = self.hexRadius;
    local visitedPlots = {};
    local hexes = Queue:Create();
    hexes:Enqueue({x=hexInfo.x, y=hexInfo.y, r=hexRadius});
    
    while not hexes:IsEmpty() do
        local hex = hexes:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local r = hex.r;
        local iPlot = GetPlotIndexLua(x,y);
        if (not visitedPlots[iPlot]) then
            -- 1st time visiting this plot.
            visitedPlots[iPlot] = true;
            
            local plot = Map.GetPlotByIndex(iPlot-1);
            if (not plot:IsWater()) then
                -- Generate terrain for non-water tiles only.
                -- A previous map-gen step already handled water terrain.
                SetBaseTerrain(plot, terrainType);
            end
            
            if (r > 1) then
                for i, direction in ipairs(HexDirections) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
end

function GotLakes_TerrainGenerator:GenerateHybridHex(
    hexInfo, countDesert, countGrass, countPlains, countSnow, countTundra)
    
    print("Generating hybrid hex at " .. CoordString(hexInfo.x,hexInfo.y)); 
    local hexRadius = self.hexRadius;

    -- Create a sortable list of plot coordinates.
    local coords = {};
    local visitedPlots = {};
    local hexes = Queue:Create();
    hexes:Enqueue({x=hexInfo.x, y=hexInfo.y, r=hexRadius});
    while not hexes:IsEmpty() do
        local hex = hexes:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local r = hex.r;
        local iPlot = GetPlotIndexLua(x,y);
        if (not visitedPlots[iPlot]) then
            -- 1st time visiting this plot.
            visitedPlots[iPlot] = true;
            
            local plot = Map.GetPlotByIndex(iPlot-1);
            if (not plot:IsWater()) then
                table.insert(coords, {x=x,y=y,index=iPlot});
            end
            
            if (r > 1) then
                for i, direction in ipairs(HexDirections) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
    
    if (#coords == 0) then
        print("Somehow the hex at " .. CoordString(hexInfo.x,hexInfo.y) .. 
              " has no land plots.");
        return;
    end
    
    -- Choose from multiple comparators to decide how we fill the hybrid hex.
    local comparators = self.hybridHexPlotComparators;
    local comparatorDice = 1 + TerrainBuilder.GetRandomNumber(
        #comparators, "Hex Plot Comparator");
    print("Sorting hex plots in order of " .. 
          self.hybridHexPlotComparatorNames[comparatorDice]);
    local comparator = comparators[comparatorDice];
    table.sort(coords, comparator);
    
    for i, coord in ipairs(coords) do
        -- Decide which terrain type to use.
        local terrainType = g_TERRAIN_TYPE_SNOW;
        if (countDesert > 0) then
            terrainType = g_TERRAIN_TYPE_DESERT;
            countDesert = countDesert - 1;
        
        elseif (countGrass > 0) then
            terrainType = g_TERRAIN_TYPE_GRASS;
            countGrass = countGrass - 1;
            
        elseif (countPlains > 0) then
            terrainType = g_TERRAIN_TYPE_PLAINS;
            countPlains = countPlains - 1;
            
        elseif (countTundra > 0) then
            terrainType = g_TERRAIN_TYPE_TUNDRA;
            countTundra = countTundra - 1;
        else
            countSnow = countSnow - 1;
        end
        
        local plot = Map.GetPlot(coord.x, coord.y);
        SetBaseTerrain(plot, terrainType);
    end
    return countDesert, countGrass, countPlains, countSnow, countTundra;
end

function GotLakes_TerrainGenerator:GenerateTerrainAtHex(hexInfo)
    -- Overwrite land terrain for a Hex Pangea hex.
    -- Args:
    --   hexInfo: info about the hex such as center coords x and y
    local iX = hexInfo.x;
    local iY = hexInfo.y;
    local lat = self.GetLatitudeAtPlot(iX,iY);
    
    local hexRadius = self.hexRadius;
    local visitedPlots = {};
    local hexes = Queue:Create();
    hexes:Enqueue({x=iX, y=iY, r=hexRadius});
    
    while not hexes:IsEmpty() do
        local hex = hexes:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local r = hex.r;
        local iPlot = GetPlotIndexLua(x,y);
        if (not visitedPlots[iPlot]) then
            -- 1st time visiting this plot.
            visitedPlots[iPlot] = true;
                        
            -- Generate terrain at plot using common lat for the hex.
            self:GenerateTerrainAtPlot(x, y, lat);
            
            if (r > 1) then
                local directions = GetShuffledCopyOfTable(HexDirections);
                for i, direction in ipairs(directions) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
end

function GotLakes_TerrainGenerator:GenerateTerrainAtPlot(x, y, lat)
    local i = y * self.iW + x;
    local plot = Map.GetPlotByIndex(i);
    if (not plot:IsWater()) then
        -- Generate terrain for non-water tiles only.
        -- A previous map-gen step already handled water terrain.
        SetBaseTerrain(plot, self:ChooseTerrainAtPlot(x, y, lat));
    end
end

function GotLakes_TerrainGenerator:ChooseTerrainAtPlot(iX,iY,lat)
	-- Choose terrain for a non-water tile.
	local terrainsList = self.enabledTerrainsList;
	local terrainsMap = self.enabledTerrainsMap;
	
	if (#terrainsList == 1) then
		-- Only one terrain type enabled.
		return terrainsList[1];
	end
	
	local i = iY * self.iW + iX;
	
    if (self.donutFillingMap[i+1] == FILLING_YES) then
        -- Plot is in the filling region of a donut.
        -- Check for donut fillings.
        if (self.gotDesertDonut and terrainsMap[g_TERRAIN_TYPE_DESERT]) then
            return g_TERRAIN_TYPE_DESERT;
        
        elseif (self.gotGrassDonut and terrainsMap[g_TERRAIN_TYPE_GRASS]) then
            return g_TERRAIN_TYPE_GRASS;
        
        elseif (self.gotPlainsDonut and terrainsMap[g_TERRAIN_TYPE_PLAINS]) then
            return g_TERRAIN_TYPE_PLAINS;
            
        elseif (self.gotTundraDonut and terrainsMap[g_TERRAIN_TYPE_TUNDRA]) then
            --print("Donut tundra.", CoordString(iX,iY));
            return g_TERRAIN_TYPE_TUNDRA;
        
        elseif (self.gotSnowDonut and terrainsMap[g_TERRAIN_TYPE_SNOW]) then
            return g_TERRAIN_TYPE_SNOW;
        end    
    end
		
	local plot = Map.GetPlotByIndex(i);
	
	-- Default to grass (fertile).
	local terrainType = g_TERRAIN_TYPE_GRASS;
	if (not terrainsMap[g_TERRAIN_TYPE_GRASS]) then
		-- Grass is disabled. Need another default terrain.
		if terrainsMap[g_TERRAIN_TYPE_PLAINS] then
			-- Plains is the closest fallback in terms of temperature.
			terrainType = g_TERRAIN_TYPE_PLAINS;
			
		elseif terrainsMap[g_TERRAIN_TYPE_TUNDRA] then
			-- Plains is also disabled. Fall back to tundra.
			terrainType = g_TERRAIN_TYPE_TUNDRA;
		else
			-- Tundra is disabled too. That leaves desert and snow.
			terrainType = g_TERRAIN_TYPE_DESERT;
			
			-- Use the plains fractal to turn the default band 
			-- into a mix of desert and snow.
			local plainsBottom = (self.plainsFlatBottom + self.plainsHillBottom)/2;
			local plainsVal = self.plains:GetHeight(iX, iY);
			if ((plainsVal >= plainsBottom) and (plainsVal < self.plainsTop)) then
				terrainType = g_TERRAIN_TYPE_SNOW;
			end
		end
	end
	--print("Default terrain is " .. TerrainString(terrainType));

	if terrainsMap[g_TERRAIN_TYPE_PLAINS] then
		--print("Checking for plains");
		-- Add plains to the default / fertile band.
		-- Let flat land have a different chance of plains than hills/mtns.
		local plainsBottom = self.plainsFlatBottom;
		if (plot:IsHills() or plot:IsMountain()) then
			plainsBottom = self.plainsHillBottom;
		end	
		local plainsVal = self.plains:GetHeight(iX, iY);
		if ((plainsVal >= plainsBottom) and (plainsVal < self.plainsTop)) then
			terrainType = g_TERRAIN_TYPE_PLAINS;
		end
	end -- Else the fertile band is just the default terrain.
	
	-- Mix of temperate and extremes to improve starts on regional maps.
	local polarVal = self.polar:GetHeight(iX, iY);
	
	if terrainsMap[g_TERRAIN_TYPE_DESERT] then
		-- Chance of desert, depending on latitude.
		--print("Checking for desert");
		local desertBottom = GetFractalHeight(self.deserts, Interpolate(lat, 
			self.desertMinLat, self.desertMaxLat, 
			self.desertBottomPct, 100,
			self.desertInterpFcn));
			
		local desertVal = self.deserts:GetHeight(iX, iY);
		if ((lat <= self.desertMaxLat) and 
			(desertVal >= desertBottom) and 
			(desertVal < self.desertTop)) then
			-- Enforce a hard maximum latitude to avoid fractal anomalies.
			terrainType = g_TERRAIN_TYPE_DESERT;
		end
	end -- Else the fertile band / default terrain extends to the equator.
	
	-- Gradually increase holes in extreme cold as lat increases.
	local coldPoleBottom = GetFractalHeight(self.polar, Interpolate(lat, 
			self.tundraMinLat, self.snowMaxLat, 
			0, self.coldPoleBottomPct,
			self.snowInterpFcn));
	
	if (self.gotGlobe or (polarVal >= coldPoleBottom)) then
		-- Chance of tundra/snow, depending on latitude.
		local snowBottom = GetFractalHeight(self.cold, Interpolate(lat, 
			self.snowMinLat, self.snowMaxLat, 
			100, 0,
			self.snowInterpFcn));
		
		local tundraMaxLat = self.tundraNonRiverMaxLat;
		if (plot:IsRiver()) then
			-- Extend tundra interp for river plots to allow for some temperate
			-- terrain in an otherwise frozen region.
			tundraMaxLat = self.tundraMaxLat;
		end
		
		local tundraBottom = GetFractalHeight(self.cold, Interpolate(lat, 
			self.tundraMinLat, tundraMaxLat, 
			100, 0,
			self.tundraInterpFcn));
		
		local coldVal = self.cold:GetHeight(iX, iY);
		
		if ((lat >= self.snowMinLat) and (coldVal >= snowBottom)) then
			-- Enforce a hard minimum latitude to avoid fractal anomalies.
			--print("Checking for snow");
			if terrainsMap[g_TERRAIN_TYPE_SNOW] then
				terrainType = g_TERRAIN_TYPE_SNOW;
				
			elseif terrainsMap[g_TERRAIN_TYPE_TUNDRA] then
				-- Snow is disabled, so extend tundra to the frozen pole.
				terrainType = g_TERRAIN_TYPE_TUNDRA;
			end -- Else the fertile band / default terrain extends to the frozen pole.
			
		elseif ((lat >= self.tundraMinLat) and (coldVal >= tundraBottom)) then
			-- Enforce a hard minimum latitude to avoid fractal anomalies.
			--print("Checking for tundra");
			if terrainsMap[g_TERRAIN_TYPE_TUNDRA] then
                --print("Normal tundra.", CoordString(iX,iY));
				terrainType = g_TERRAIN_TYPE_TUNDRA;
			end	-- Else the fertile band / default terrain extends to the snow.
		end
	end
	--print("Effective terrain at " .. CoordString(iX,iY) .. " is " .. TerrainString(terrainType));
	return terrainType;
end

function GotLakes_TerrainGenerator:TiltedAxis_InitAzimuthal(enableRandomPoles, centerIsHot)
	-- Tilted Axis azimuthal init.
	-- Args:
	--   enableRandomPoles: whether to randomize poles (true) or use default values (false)
	--   centerIsHot: whether the center is hot by default
	-- Returns:
	--   makeCenterHot: whether to make the center hot (true) or the edges hot (false)
	print("Initializing Tilted Axis azimuthal poles.");
	local makeCenterHot = centerIsHot;
	
	local centerTempSuffix = " (default)";
	if enableRandomPoles then
		centerTempSuffix = " (randomized)";
		makeCenterHot = RandomBool();
	end

	local centerTempStr = "cold";
	if makeCenterHot then
		centerTempStr = "hot";
	end
	print("The central pole will be " .. centerTempStr .. centerTempSuffix .. ".");
	return {makeCenterHot = makeCenterHot};
end

function GotLakes_TerrainGenerator:TiltedAxis_InitRegion(
	wrapX, enableRandomPoles, defaultR, defaultTheta)
	-- Tilted Axis regional init.
	-- Args:
	--   wrapX: whether the world wraps east-west
	--   enableRandomPoles: whether to randomize poles (true) or use default values (false)
	--   defaultR: default south pole R
	--   defaultTheta: default south pole Theta
	-- Returns:
	--   southPoleX, southPoleY: location of the south pole,
	--	 northPoleX, northPoleY: location of the north pole,
	--	 minR, maxR: min/max distances from south pole (for latitude interpolation)
	print("Initializing Tilted Axis region.");
	
	-- The Euclidian (x,y) location of the center of the map.
	local mapCenterX = math.floor(self.iW/2);
	local mapCenterY = math.floor(self.iH/2);
	if ((mapCenterY % 2) == 1) then
		mapCenterX = mapCenterX + 0.5;
	end
	
	print("Map Center (x,y): " .. CoordString(mapCenterX, mapCenterY));
	
	-- The location of the hot pole that faces the sun, 
	-- relative to the center of the map.
	--
	-- Start with polar coords so that we can randomize by distance and angle.
	
	-- Scale the maximum hot pole distance using whichever dimension is longer.
	local distRange = math.max(self.iW, self.iH) * 5;
	print("Hot Pole Max R: ", distRange);
	
	local hotPoleRDist = defaultR;     -- Hexes
	local hotPoleTheta = defaultTheta; -- Radians
	
	if enableRandomPoles then
		-- In hexes
		hotPoleRDist = TerrainBuilder.GetRandomNumber(distRange,
			"Tilted Axis Region - hot pole distance"); 
		
		-- In Radians
		if wrapX then
			print("Choosing north or south pole (wrap-x).");
			-- Allow only N or S pole for east-west continuity (plus or minus pi/2).
			local randNS = TerrainBuilder.GetRandomNumber(2, 
				"Tilted Axis Region - hot pole N/S orientation"); 
			hotPoleTheta = math.pi * (0.5 - randNS);
		else
			-- Allow any orientation.
			hotPoleTheta = RandomRadians(0, TAU, 1000);
		end
	else		
		print("Using default hot pole location (random poles disabled).");
	end
	print("Hot Pole (r, theta): ", CoordString(hotPoleRDist, RadString(hotPoleTheta)));

	-- The Location of the pole in cartesion coords, so that we can calculate
	-- distance to other (x,y) locations
	local hotPoleXDiff = hotPoleRDist * math.cos(hotPoleTheta);
	local hotPoleYDiff = hotPoleRDist * math.sin(hotPoleTheta);
	
	-- This location may be outside of the hex grid--that is OK!
	local hotPoleX = mapCenterX + hotPoleXDiff;
	local hotPoleY = mapCenterY + hotPoleYDiff;
	print("Hot Pole (x,y): " .. CoordString(hotPoleX, hotPoleY));
	
	-- Find the min/max distances to hot-pole on the map 
	-- so that we can interpolate fractals on a scale that fits with the grid.
	local minR = math.huge;
	local maxR = 0;
	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do 	
			local dist = Distance(x, y, hotPoleX, hotPoleY);
			if (dist > maxR) then
				maxR = dist;
			end
			if (dist < minR) then
				minR = dist;
			end
		end
	end
	print("Hot Pole distance range: " .. CoordString(Round(minR),Round(maxR)));
	
	-- Set global terrain info so that both terrain and feature gen can
	-- share the same hot pole for latitude calculations.
	local data =
	{
		hotPoleX = hotPoleX,
		hotPoleY = hotPoleY,
		minR     = minR,
		maxR     = maxR
	};
	return data;
end

function GotLakes_TerrainGenerator:TwoSuns_InitRegion(
	wrapX, enableRandomPoles, defaultR, defaultTheta)
	-- Two Suns regional init.
	-- Args:
	--   wrapX: whether the world wraps east-west.
	--   enableRandomPoles: whether to randomize poles (true) or use default values (false)
	--   defaultR: default south pole R (ignored)
	--   defaultTheta: default south pole Theta
	-- Returns:
	--   southPoleX, southPoleY: location of the south pole,
	--	 northPoleX, northPoleY: location of the north pole,
	--	 minR, maxR: min/max distances from south pole (for latitude interpolation)
	print("Initializing Two Suns region.");
	
	-- The Euclidian (x,y) location of the center of the map.
	local mapCenterX = math.floor(self.iW/2);
	local mapCenterY = math.floor(self.iH/2);
	if ((mapCenterY % 2) == 1) then
		mapCenterX = mapCenterX + 0.5;
	end
	
	print("Map Center (x,y): " .. CoordString(mapCenterX, mapCenterY));
	
	-- The location of the poles relative to the center of the map.
	-- Start with polar coords so that we can randomize by angle.
	--
	-- Scale the maximum pole distance using whichever dimension is longer.
	local poleRDist = math.max(self.iW, self.iH) * 5;  -- Hexes
	local southPoleTheta = defaultTheta;
	
	if enableRandomPoles and wrapX then
		print("Forcing N/S poles (wrap-x).");
		-- Allow only N pole (pi/2) for east-west continuity.
		southPoleTheta = math.pi/2;
		
	elseif enableRandomPoles then
		-- Allow poles in any orientation.
		southPoleTheta = RandomRadians(0, TAU, 1000); -- Radians
	else
		print("Using default south pole theta (random poles disabled).");
	end
	
	local northPoleTheta = southPoleTheta + math.pi;
	if (northPoleTheta >= TAU) then
		northPoleTheta = northPoleTheta - TAU;
	end
	
	-- The Location of the poles in cartesion coords, so that we can calculate
	-- distance to other (x,y) locations
	local southPoleXDiff = poleRDist * math.cos(southPoleTheta);
	local southPoleYDiff = poleRDist * math.sin(southPoleTheta);
	
	local northPoleXDiff = poleRDist * math.cos(northPoleTheta);
	local northPoleYDiff = poleRDist * math.sin(northPoleTheta);
	
	-- Convert cartesian (x,y) back to a corresponding map-grid theta.
	-- Forces a one-to-one mapping of tiles to thetas for each possible
	-- location of the poles.
	local southPoleTileTheta = math.pi/2 - 
		math.atan2(Round(southPoleXDiff), Round(southPoleYDiff));
	print("South Pole Theta: ", RadString(southPoleTileTheta));
	
	-- These locations may be outside of the hex grid--that is OK!
	local southPoleX = mapCenterX + southPoleXDiff;
	local southPoleY = mapCenterY + southPoleYDiff;
	print("South Pole (x,y): " .. CoordString(southPoleX, southPoleY));
	
	local northPoleX = mapCenterX + northPoleXDiff;
	local northPoleY = mapCenterY + northPoleYDiff;
	print("North Pole (x,y): " .. CoordString(northPoleX, northPoleY));
		
	-- Find the min/max distances to nearest pole on the map 
	-- so that we can interpolate fractals on a scale that fits with the grid.
	local minR = math.huge;
	local maxR = 0;
	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do 	
			local dist = math.min(
				Distance(x, y, southPoleX, southPoleY),
				Distance(x, y, northPoleX, northPoleY));
			if (dist > maxR) then
				maxR = dist;
			end
			if (dist < minR) then
				minR = dist;
			end
		end
	end
	print("Hot Pole distance range: " .. CoordString(Round(minR),Round(maxR)));
	
	-- Set global terrain info so that both terrain and feature gen can
	-- share the same hot pole for latitude calculations.
	local data =
	{
		southPoleX = southPoleX,
		southPoleY = southPoleY,
		northPoleX = northPoleX,
		northPoleY = northPoleY,
		minR       = minR,
		maxR       = maxR
	};
	return data;
end