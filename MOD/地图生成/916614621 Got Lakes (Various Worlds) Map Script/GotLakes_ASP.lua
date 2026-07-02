-- Custom Start Positioner for Got Lakes Map Script
-- Author: Scrum Lord
--------------------------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_StartBiasAnalyzer"
include "GotLakes_StartBiasSolver"
include "GotLakes_Utils"
--------------------------------------------------------------------------------------------------
-- Custom start positioner to handle civ starts on a variety of maps.
--
-- Based on AssignStartingPlots from Civ 5.
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- GL Utilities
--------------------------------------------------------------------------------------------------
-- Distance bias value for the plot that has a civ start.
-- Effectively eliminates fertility score at a plot that has a civ start when placing other civs.
local DISTBIAS_IMPACT = 99;

-- Multiplier for stacking distance bias when a plot is close to multiple civs.
local DISTBIAS_STACK_MULTIPLIER = 1.2;

-- Distance bias values for plots that are <index> tiles away from a major civ start.
-- When placing a major civ, any tile within reach of these ripples that doesn't yet have a 
-- distance bias will get an appropriate value, and any tile that does will get 
-- [max(existing, new) * (stack multiplier)] to indicate multiple cities nearby.
--
-- Original ripples from Civ V for both major and minor civs: {97, 95, 92, 89, 69, 57, 24, 15};
local DISTBIAS_MAJOR_RIPPLES =
  {97, 93, 89, 85, 81, 67, 56, 46, 38, 31, 26, 21, 17, 14, 11, 9, 7, 6, 5, 4, 3};

-- Distance bias values for plots that are <index> tiles away from a minor civ start.
-- Use fewer ripples for minor civs because city states don't need room to expand.
local DISTBIAS_MINOR_RIPPLES = {97, 81, 67, 56, 46, 38};

function CompareLandAreas(a,b)
    if (a.fert == b.fert) then
        -- Use Area ID as a tie breaker to avoid MP desyncs.
        return a.index < b.index;
    end
    return a.fert < b.fert;
end

function CreateDistanceMaps()
    local iW, iH, numTiles = GetMapGridSize();
    return {dist=table.fill(numTiles, numTiles), bias=table.fill(0,numTiles)};
end
--------------------------------------------------------------------------------------------------
-- YnAMP Team Start Locations Utilities copied from Teams Together Strong ASP
--------------------------------------------------------------------------------------------------
function GetPlotFertility(plot)
	-- Calculate the fertility of the starting plot
	local iRange = 3;
	local pPlot = plot;
	local plotX = pPlot:GetX();
	local plotY = pPlot:GetY();

	local iW, iH = GetMapGridSize();
	local iHMinus1 = iH - 1;

	local iFertility = 0;
	
	--Rivers are awesome to start next to
	local terrainType = pPlot:GetTerrainType();
	if(pPlot:IsFreshWater() == true and 
        terrainType ~= g_TERRAIN_TYPE_SNOW and 
        terrainType ~= g_TERRAIN_TYPE_SNOW_HILLS and 
        pPlot:IsImpassable() ~= true) then
		iFertility = iFertility + 50;
		if pPlot:IsRiver() == true then
			iFertility = iFertility + 50
		end
	end	
	
	for dx = -iRange, iRange do
		for dy = -iRange,iRange do
			local otherPlot = Map.GetPlotXYWithRangeCheck(plotX, plotY, dx, dy, iRange);

			-- Valid plot?  Also, skip plots along the top and bottom edge
			if(otherPlot) then
				local otherPlotY = otherPlot:GetY();
				if(otherPlotY > 0 and otherPlotY < iHMinus1) then

					terrainType = otherPlot:GetTerrainType();
					featureType = otherPlot:GetFeatureType();

					-- Subtract one if there is snow and no resource.
                    -- Do not count water plots unless there is a resource
					if((terrainType == g_TERRAIN_TYPE_SNOW or 
                        terrainType == g_TERRAIN_TYPE_SNOW_HILLS or 
                        terrainType == g_TERRAIN_TYPE_SNOW_MOUNTAIN) and 
                        otherPlot:GetResourceCount() == 0) then
						iFertility = iFertility - 10;
					elseif(featureType == g_FEATURE_ICE) then
						iFertility = iFertility - 20;
					elseif((otherPlot:IsWater() == false) or otherPlot:GetResourceCount() > 0) then
						iFertility = iFertility + (otherPlot:GetYield(g_YIELD_PRODUCTION)*3)
						iFertility = iFertility + (otherPlot:GetYield(g_YIELD_FOOD)*5)
					end
				
					-- Lower the Fertility if the plot is impassable
					if(iFertility > 5 and otherPlot:IsImpassable() == true) then
						iFertility = iFertility - 5;
					end

					-- Lower the Fertility if the plot has Features
					if(featureType ~= g_FEATURE_NONE) then
						iFertility = iFertility - 2
					end	

				else
					iFertility = iFertility - 20;
				end
			else
				iFertility = iFertility - 20;
			end
		end
	end 

	return iFertility;
end

function CompareCustomStartingPlots(a,b)
    if (a.Fertility == b.Fertility) then
        -- Use plot index as a tie breaker to avoid MP desyncs.
        return a.Index < b.Index;
    end
    return a.Fertility > b.Fertility;
end

function GetCustomStartingPlots()
	local potentialPlots = {}
	local iW, iH = GetMapGridSize();

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = GetPlotIndexLua(iX,iY);
			pPlot = Map.GetPlotByIndex(index)
			if IsCityFriendly(pPlot) then
				local fertility = GetPlotFertility(pPlot)
				table.insert(potentialPlots,
                    { Index = index, Plot = pPlot, Fertility = fertility} );
			end
		end
	end
	print("GetCustomStartingPlots returns "..tostring(#potentialPlots).." plots");
	
	table.sort (potentialPlots, CompareCustomStartingPlots);
	return potentialPlots
end
--------------------------------------------------------------------------------------------------
-- ASP Instance helper methods
--------------------------------------------------------------------------------------------------
GotLakes_ASP = {}

function GotLakes_ASP.Create(args)
	-- Constructor.
	--
	-- Args (fields in an args map):
	--   distanceMaps (optional): maps containing distances to nearby obstacles for each plot;
	--     intended for passing land-start distance-data into a water-start ASP.
	--   divMethod: preferred regional division method (continental or largest-landmass)
	--   enableCustomStartBias: whether to enable GL's custom handling of start biases.
	--   enableFallbacks: whether to allow fallback-quality starts (true) or fail if starts 
	--     are not all OK (false)
	--   enableForcedStarts: whether to force the desired number of starts (true) or allow
	--     results to have fewer starts than expected (false); false prevents this instance
	--     from modifying terrain/features when choosing starts.
	--   enableLakeStarts: whether to allow water-civs to start in fresh lakes
    --   idealDistBetween2MCivs: the minimum plot distance between two major civs to avoid a 
    --     candidate plot score penalty
	--   isMinor: whether to start minor civs (true) or major civs (false)
	--   minDistBetweenCivs: the minimum number of plots to allow between civ starts.
	--   minReachableLandRatio: target minimum fraction of total land that 
	--     to be reachable from each start plot
	--   numCivs: the number of civs that need an assigned start plot.
    --   safeDistBetween2MCivs: the minimum number of plots that is considered a safe (non-fallback)
    --     distance between two major civs
	--   startBiasLogLevel: level at which to log additional messages for solving start bias
	--   startOnWater: whether to look for starting plots on water (true) or passable land (false)
	--   wrapX: whether the map wraps east-west
    local args = args or {};
    local distanceMaps           = args.distanceMaps;
    local divMethod              = args.divMethod              or DIVMETHOD_NONE;
    local enableCustomStartBias  = args.enableCustomStartBias  or false;
    local enableFallbacks        = args.enableFallbacks        or false;
    local enableForcedStarts     = args.enableForcedStarts     or false;
    local enableLakeStarts       = args.enableLakeStarts       or false;
    local idealDistBetween2MCivs = args.idealDistBetween2MCivs or 21;
    local isMinor                = args.isMinor                or false;
    local minDistBetweenCivs     = args.minDistBetweenCivs     or 4;
    local minReachableLandRatio  = args.minReachableLandRatio  or 0.25;
    local numCivs                = args.numCivs                or 1;
    local safeDistBetween2MCivs  = args.safeDistBetween2MCivs  or 10;
    local startBiasLogLevel      = args.startBiasLogLevel      or LogLevels.INFO;
    local startOnWater           = args.startOnWater           or false;
    local wrapX                  = args.wrapX                  or false;
    
    
	local iW, iH, numTiles = GetMapGridSize();
    
    -- Create or import distance maps.
	local distanceMapCopy = table.fill(numTiles, numTiles);
	local distBiasMapCopy = table.fill(0,numTiles);
	if distanceMaps then
		-- Make a copy of the distance map in case we want to redo the starts.
		for i = 1, numTiles do
			distanceMapCopy[i] = distanceMaps.dist[i];
			distBiasMapCopy[i] = distanceMaps.bias[i];
		end
	end
    
    -- Limit min distance between civs based on map size.
    -- so that we don't needlessly iterate beyond the farthest possible distance between civs.
    local maxMinDistBetweenCivs = math.floor(Map.GetPlotDistance(0,0,iW-1,iH-1)/3);
    if wrapX then
        -- Limit to a fraction of map width to avoid ripples wrapping around to where they 
        -- started, and to increase chances of success.
        maxMinDistBetweenCivs = math.floor(iW*0.4)-1;
    end
    if minDistBetweenCivs > maxMinDistBetweenCivs then
        minDistBetweenCivs = maxMinDistBetweenCivs;
        print("Minimum distance between civs reduced to " .. minDistBetweenCivs .. 
              " due to map size.");
    end
    
    local numMajorRipples = #DISTBIAS_MAJOR_RIPPLES;
    
    local safeDistBias = 0;
    safeDistBetween2MCivs = math.max(1, safeDistBetween2MCivs); -- Enforce lower bound.
    if safeDistBetween2MCivs <= numMajorRipples then
        -- Convert safe distance into safe distance bias.
        safeDistBias = DISTBIAS_MAJOR_RIPPLES[safeDistBetween2MCivs];
    end
    print("Safe distance bias: ", safeDistBias);
	
    local idealDistBias = 0;
    idealDistBetween2MCivs = math.max(safeDistBetween2MCivs, idealDistBetween2MCivs);
    if idealDistBetween2MCivs <= numMajorRipples then
        -- Convert ideal distance into ideal distance bias.
        idealDistBias = DISTBIAS_MAJOR_RIPPLES[idealDistBetween2MCivs];
    end
    print("Ideal distance bias: ", idealDistBias);
        
	local regionType = "land";
	local MeasurePlotFertility = GotLakes_ASP.Land_MeasurePlotFertility;
	local MeasureSinglePlot    = GotLakes_ASP.Land_MeasureSinglePlot;
	local FindStart            = GotLakes_ASP.Land_FindStart;
	
	if startOnWater then
		-- Override certain functions to check for water instead of land.
		regionType = "water";
		MeasurePlotFertility = GotLakes_ASP.Water_MeasurePlotFertility;
		MeasureSinglePlot    = GotLakes_ASP.Water_MeasureSinglePlot;
		FindStart            = GotLakes_ASP.Water_FindStart;
	end
	
	-- Civ-to-Area mapping function.
	local AssignCivsToAreas = GotLakes_ASP.Default_AssignCivsToAreas;
	if (divMethod == DIVMETHOD_SEPARATE) then
		-- Method override to assign one area per civ.
		AssignCivsToAreas = GotLakes_ASP.Separate_AssignCivsToAreas;
	end
    
	local startBiasAnalyzer = GotLakes_StartBiasAnalyzer.Create(startBiasLogLevel);
	
	local instance = 
	{
		-- Core Process member methods
		__InitCoastInfo       = GotLakes_ASP.__InitCoastInfo,
        __InitResourceInfo    = GotLakes_ASP.__InitResourceInfo,
		ApplyHexAdjustment    = GotLakes_ASP.ApplyHexAdjustment,
        GetDistanceMaps       = GotLakes_ASP.GetDistanceMaps,
		GetLandmassBoundaries = GotLakes_ASP.GetLandmassBoundaries,
		GenerateRegions       = GotLakes_ASP.GenerateRegions,
		ChooseLocations       = GotLakes_ASP.ChooseLocations,
		
		-- Generate Regions member methods
		MeasurePlotFertility = MeasurePlotFertility,
		MeasureAreaFertility = GotLakes_ASP.MeasureAreaFertility,
		RemoveDeadRows 		 = GotLakes_ASP.RemoveDeadRows,
		DivideIntoRegions 	 = GotLakes_ASP.DivideIntoRegions,
		ChopIntoThreeRegions = GotLakes_ASP.ChopIntoThreeRegions,
		ChopIntoTwoRegions	 = GotLakes_ASP.ChopIntoTwoRegions,
		DivideArea           = GotLakes_ASP.DivideArea,
		AssignCivsToAreas    = AssignCivsToAreas,
		DivideContinental    = GotLakes_ASP.DivideContinental,
		SortRegions          = GotLakes_ASP.SortRegions,

		-- Choose Locations member methods
		GetBiggestPassableLandArea 		= GotLakes_ASP.GetBiggestPassableLandArea,
		GetPassableLandArea 			= GotLakes_ASP.GetPassableLandArea,
		IsFarFromNaturalWonder 			= GotLakes_ASP.IsFarFromNaturalWonder,
		PlaceImpactAndRipples 			= GotLakes_ASP.PlaceImpactAndRipples,
		MeasureSinglePlot				= MeasureSinglePlot,
		EvaluateCandidatePlot 			= GotLakes_ASP.EvaluateCandidatePlot,
		IsBetterPlot                    = GotLakes_ASP.IsBetterPlot,
		IterateThroughCandidatePlotList = GotLakes_ASP.IterateThroughCandidatePlotList,
		FindClosestPlot 				= GotLakes_ASP.FindClosestPlot,
		FindFallbackStart               = GotLakes_ASP.FindFallbackStart,
		FindForcedStart 			    = GotLakes_ASP.FindForcedStart,
		FindStart 						= FindStart,
		
		-- Map grid info
		iW       = iW,
		iH       = iH,
		numTiles = numTiles,
		
		-- Params
		startOnWater          = startOnWater,
		isMinor				  = isMinor,
		enableFallbacks       = enableFallbacks,
		enableForcedStarts    = enableForcedStarts,
		enableLakeStarts      = enableLakeStarts,
		enableCustomStartBias = enableCustomStartBias,
		startBiasLogLevel     = startBiasLogLevel,
		iNumCivs              = numCivs,
		wrapX                 = wrapX,
		divMethod             = divMethod,
		minDistBetweenCivs    = minDistBetweenCivs,
		minReachableLandRatio = minReachableLandRatio,
		
		regionType = regionType,
        
		-- Utils
		startBiasAnalyzer = startBiasAnalyzer,
		
		-- Candidate plot score multiplier for each bias tier.
		-- Scaled to balance with other types of plot scores.
		startBiasTierMults = {5, 4, 3, 2, 1},
		
		-- Stores table of NextToSaltWater plots to reduce redundant calculations
		plotDataIsCoastal = {},		
		-- Stores table of TwoAwayFromSaltWater plots to reduce redundant calculations
		plotDataIsNextToCoast = {},
		
		
		-- Stores data returned from regional division algorithm
		regionData = {},
		
		-- Keep track of whether the map has passable salt water.
		-- If there is no passable salt water, 
		-- then FindWaterStart() will have to consider lakes regardless of area ID
		-- because MapGenerator might not assign water areas to fresh lakes.
		hasPassableSaltWater = true,
		
		-- Civ start position variables
		-- Stores x and y coordinates (and "score") of starting plots for civs, 
		-- indexed by region number
		startingPlots = {},			
	
		-- Stores "impact and ripple" data of start points as each is placed
		distBiasMap = distBiasMapCopy,
		
		-- Stores distance to nearest civ for each plot.
		distanceMap = distanceMapCopy,
		
        -- Upper bound for civ-placement impact radius based on map sie. 
        maxImpactRadius = maxMinDistBetweenCivs,
        
        safeDistBias  = safeDistBias,  -- Any distance bias <= this counts as OK.
        idealDistBias = idealDistBias, -- Any distance bias <= this has no score penalty.
        
		-- Positioner defaults. 
		-- These are the controls for the "Center Bias" placement method for civ starts.
		centerBias = 34, -- % of radius from region center to examine first
		middleBias = 67, -- % of radius from region center to check second

		-- Hex Adjustment tables. These tables direct plot by plot scans in a radius 
		-- around a center hex, starting to Northeast, moving clockwise.
		firstRingYIsEven = {{0, 1}, {1, 0}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}},
		secondRingYIsEven = {
		{1, 2}, {1, 1}, {2, 0}, {1, -1}, {1, -2}, {0, -2},
		{-1, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-1, 2}, {0, 2}
		},
		thirdRingYIsEven = {
		{1, 3}, {2, 2}, {2, 1}, {3, 0}, {2, -1}, {2, -2},
		{1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-2, -2}, {-3, -1},
		{-3, 0}, {-3, 1}, {-2, 2}, {-2, 3}, {-1, 3}, {0, 3}
		},
		firstRingYIsOdd = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {0, 1}},
		secondRingYIsOdd = {		
		{1, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -2}, {0, -2},
		{-1, -2}, {-1, -1}, {-2, 0}, {-1, 1}, {-1, 2}, {0, 2}
		},
		thirdRingYIsOdd = {		
		{2, 3}, {2, 2}, {3, 1}, {3, 0}, {3, -1}, {2, -2},
		{2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -2}, {-2, -1},
		{-3, 0}, {-2, 1}, {-2, 2}, {-1, 3}, {0, 3}, {1, 3}
		},
	}
	
	instance:__InitCoastInfo();
    instance:__InitResourceInfo();
	
	return instance
end

function GotLakes_ASP:__InitCoastInfo()
	-- Set up data tables that record whether a plot is coastal land and whether a plot is 
	-- adjacent to coastal land.
	self.plotDataIsCoastal, self.plotDataIsNextToCoast = GenerateNextToCoastalLandDataTables();
end

function GotLakes_ASP:__InitResourceInfo()
	-- Initialize info for classifying and scoring resources.
    local resourceTypes = {}
    for row in GameInfo.Resources() do
        resourceTypes[row.ResourceType] = row.Index;
	end
        
    -- Build a map of resource type indices to tag-based info
    local resources = {};
    for row in GameInfo.TypeTags() do
        local resourceType = row.Type;
        local tag = row.Tag;
        local id = resourceTypes[resourceType];
        local resource = resources[id] or {};
        local goodness = resource.goodness or 0;
        if tag == "CLASS_CULTURE" then
            resource.isCulture = true;
            goodness = goodness + 1;
        end
        if tag == "CLASS_FOOD" then
            resource.isFood = true;
            goodness = goodness + 1;          
        end
        if tag == "CLASS_GOLD" then
            resource.isGold = true;
            goodness = goodness + 1;
        end
        if tag == "CLASS_PRODUCTION" then
            resource.isProd = true;
            goodness = goodness + 1;
        end
        if tag == "CLASS_SCIENCE" then
            resource.isScience = true;
            goodness = goodness + 1;
        end
        resource.goodness = goodness;
        resource.helps    = goodness > 0;
        
        if id and resource.helps then
            resources[id] = resource;
            --[[
            local labels = "";
            if resource.isCulture then
                labels = labels .. " culture";
            end
            if resource.isFood then
                labels = labels .. " food";
            end
            if resource.isGold then
                labels = labels .. " gold";
            end
            if resource.isProd then
                labels = labels .. " prod";
            end
            if resource.isScience then
                labels = labels .. " science";
            end
            print("Resource #" .. id .. " (" .. resourceType .. 
                  ") has goodness " .. goodness .. " [" .. labels .. " ]");
            --]]
        end
	end
    self.resources = resources;
end

function GotLakes_ASP:ApplyHexAdjustment(x, y, plot_adjustments)
	-- Used this bit of code so many times, I had to make it a function.
	local adjusted_x, adjusted_y;
	if self.wrapX == true then
		adjusted_x = (x + plot_adjustments[1]) % self.iW;
	else
		adjusted_x = x + plot_adjustments[1];
	end
	adjusted_y = y + plot_adjustments[2];
	return adjusted_x, adjusted_y;
end

function GotLakes_ASP:GetDistanceMaps()
    -- Get a copy of the ASP's distance maps.
    local iW, iH, numTiles = GetMapGridSize();
	local distanceMapCopy = table.fill(numTiles, numTiles);
	local distBiasMapCopy = table.fill(0,numTiles);
    -- Make a copy of the distance map to hide internal maps.
    for i = 1, numTiles do
        distanceMapCopy[i] = self.distanceMap[i];
        distBiasMapCopy[i] = self.distBiasMap[i];
    end
    return {dist=distanceMapCopy, bias=distBiasMapCopy};
end

function GotLakes_ASP:GetLandmassBoundaries(iAreaID)
	-- A variant of ObtainlandmassBoundaries()
	-- that supports optional bounding box coordinates.
	--
	-- Set up variables that will be returned by this function.
	local wrapsX = false;
	local wrapsY = false;

	local minX = self.minX or 0;
	local minY = self.minY or 0;
	local maxX = self.maxX or self.iW - 1;
	local maxY = self.maxY or self.iH - 1;
	
	--[[
	print("Obtaining landmass boundaries within " .. CoordString(minX, minY) ..
	      " and " .. CoordString(maxX, maxY));
	--]]
	-- Initialize boundary to the entire bounding box.
	-- If somehow there is not a single plot with matching Area ID,
	-- then the start chooser can force a start anywhere in the box.
	local iWestX = minX;
	local iEastX = maxX;
	local iSouthY = minY;
	local iNorthY = maxY;
	local iWidth  = iEastX  - iWestX  + 1;
	local iHeight = iNorthY - iSouthY + 1;	
	
	if ((self.wrapX == true) and (minX == 0) and (maxX == (self.iW-1))) then
		local foundFirstColumn = false;
		local foundLastColumn = false;
		for y = minY, maxY do
			local plotFirst = Map.GetPlot(minX, y);
			local plotLast = Map.GetPlot(maxX, y);
			local area = plotFirst:GetArea():GetID();
			if area == iAreaID then -- Found a plot belonging to iAreaID in first column.
				foundFirstColumn = true;
			end
			area = plotLast:GetArea():GetID();
			if area == iAreaID then -- Found a plot belonging to iAreaID in last column.
				foundLastColumn = true;
			end
		end
		if foundFirstColumn and foundLastColumn then -- Plot on both sides of map edge.
			wrapsX = true;
		end
	end

	-- Find West and East edges of this landmass.
	if not wrapsX then -- no X wrap
		for x = minX, maxX do 
			-- Check for any area membership one column at a time, left to right.
			local foundAreaInColumn = false;
			for y = minY, maxY do -- Checking column.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, set WestX to this column.
					foundAreaInColumn = true;
					iWestX = x;
					break
				end
			end
			if foundAreaInColumn then -- Found WestX, done looking.
				break
			end
		end
		for x = maxX, minX, -1 do 
			-- Check for any area membership one column at a time, right to left.
			local foundAreaInColumn = false;
			for y = minY, maxY do -- Checking column.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, set EastX to this column.
					foundAreaInColumn = true;
					iEastX = x;
					break
				end
			end
			if foundAreaInColumn then -- Found EastX, done looking.
				break
			end
		end
	else -- Landmass Xwraps.
		local landmassSpansEntireWorldX = true;
		for x = maxX-1, minX+1, -1 do 
			-- Check for end of area membership one column at a time, right to left.
			local foundAreaInColumn = false;
			for y = minY, maxY do -- Checking column.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, will have to check the next column too.
					foundAreaInColumn = true;
				end
			end
			if not foundAreaInColumn then -- Found empty column, which is just west of WestX.
				iWestX = x + 1;
				landmassSpansEntireWorldX = false;
				break
			end
		end
		for x = minX+1, maxX-1 do 
			-- Check for end of area membership one column at a time, left to right.
			local foundAreaInColumn = false;
			for y = minY, maxY do -- Checking column.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, will have to check the next column too.
					foundAreaInColumn = true;
				end
			end
			if not foundAreaInColumn then -- Found empty column, which is just east of EastX.
				iEastX = x - 1;
				landmassSpansEntireWorldX = false;
				break
			end
		end
		-- If landmass spans entire world, we'll treat it as if it does not wrap.
		if landmassSpansEntireWorldX then
			wrapsX = false;
			iWestX = minX;
			iEastX = maxX;
		end
	end
				
	-- Find South and North edges of this landmass.
	if not wrapsY then -- no Y wrap
		for y = minY, maxY do -- Check for any area membership one row at a time, bottom to top.
			local foundAreaInRow = false;
			for x = minX, maxX do -- Checking row.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, set SouthY to this row.
					foundAreaInRow = true;
					iSouthY = y;
					break
				end
			end
			if foundAreaInRow then -- Found SouthY, done looking.
				break
			end
		end
		for y = maxY, minY, -1 do 
			-- Check for any area membership one row at a time, top to bottom.
			local foundAreaInRow = false;
			for x = minX, maxX do -- Checking row.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then
					-- Found a plot belonging to iAreaID, set NorthY to this row.
					foundAreaInRow = true;
					iNorthY = y;
					break
				end
			end
			if foundAreaInRow then -- Found NorthY, done looking.
				break
			end
		end
	else -- Landmass Ywraps.
		local landmassSpansEntireWorldY = true;
		for y = maxY-1, maxY+1, -1 do 
			-- Check for end of area membership one row at a time, top to bottom.
			local foundAreaInRow = false;
			for x = minX, maxX do -- Checking row.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, will have to check the next row too.
					foundAreaInRow = true;
				end
			end
			if not foundAreaInRow then -- Found empty row, which is just south of southY.
				iSouthY = y + 1;
				landmassSpansEntireWorldY = false;
				break
			end
		end
		for y = minY+1, maxY-1 do
			-- Check for end of area membership one row at a time, bottom to top.
			local foundAreaInRow = false;
			for x = minX, maxX do -- Checking row.
				local plot = Map.GetPlot(x, y);
				local area = plot:GetArea():GetID();
				if area == iAreaID then 
					-- Found a plot belonging to iAreaID, will have to check the next row too.
					foundAreaInRow = true;
				end
			end
			if not foundAreaInRow then -- Found empty column, which is just north of NorthY.
				iNorthY = y - 1;
				landmassSpansEntireWorldY = false;
				break
			end
		end
		-- If landmass spans entire world, we'll treat it as if it does not wrap.
		if landmassSpansEntireWorldY then
			wrapsY = false;
			iSouthY = minY;
			iNorthY = maxY;
		end
	end
	
	-- Convert EastX and NorthY into width and height.
	if wrapsX then
		iWidth = (iEastX + self.iW) - iWestX + 1;
	else
		iWidth = iEastX - iWestX + 1;
	end
	if wrapsY then
		iHeight = (iNorthY + self.iH) - iSouthY + 1;
	else
		iHeight = iNorthY - iSouthY + 1;
	end

	--[ Log dump for debug purposes only, disable otherwise.
	local plotTotal = iWidth * iHeight;
	print("Landmass bounding box: " .. CoordString(iWestX, iSouthY) .. 
	      " to " .. CoordString(iEastX, iNorthY) .. 
		  " (contains " .. plotTotal .. " plots)");
	--]]

	-- Insert data into table, then return the table.
	return {iWestX, iSouthY, iEastX, iNorthY, iWidth, iHeight, wrapsX, wrapsY};
end
--------------------------------------------------------------------------------------------------
-- Start of functions tied to GenerateRegions()
--------------------------------------------------------------------------------------------------
function GotLakes_ASP:Land_MeasurePlotFertility(x, y)
	-- Fertility of plots is used to divide continents or areas into Regions.
	-- Regions are used to assign starting plots and place some resources.
	-- Args: 
	--   x, y: plot coords, with 0,0 in SW.
	-- Returns:
	--   fertility: fertility score: > 0 means valid start
	--   hasFreshWater: true iff the plot has access to non-frozen fresh water
	
	--
	-- We want players who start in temperate terrain to have the least room to expand.
	local plot = Map.GetPlot(x, y);
	
	if not IsCityFriendly(plot) then
		-- Not a valid location for a city.
		return 0, false;
	end
	
	local plotIndex = GetPlotIndexLua(x,y);
	local distToNearestCiv = self.distanceMap[plotIndex];	
	if (distToNearestCiv < self.minDistBetweenCivs) then
		-- Too close to a civ-start from a previous run of the start positioner.
		return 0, false;
	end
	
	-- Start at 3 so that the lowest possible measured fertility is 0.
	local plotFertility = 3;
	local hasFreshWater = false;
	
	local terrainType  = plot:GetTerrainType();
	local featureType  = plot:GetFeatureType();
	local resourceType = plot:GetResourceType();
    
    -- Check for resource fertility.
    local resource = self.resources[resourceType] or {};
	local resourceFertility = resource.goodness or 0;
    plotFertility = plotFertility + resourceFertility;
    
	if IsAdjacentToMountain(x, y) then
		-- Mountains add useful adjacency bonuses to land plots.
		plotFertility = plotFertility + 1;
	end
	
	local numAdjacentVolcanoes = CountAdjacentVolcanoes(x,y);
	if (numAdjacentVolcanoes == 1) then
		-- Volcanoes are even more useful than regular mountains...
		plotFertility = plotFertility + 1;
		
	elseif (numAdjacentVolcanoes > 1) then
		-- However, multiple adjacent volcanoes is probably too hazardous.
		plotFertility = plotFertility - 1;
	end
	
	if IsAdjacentToNaturalWonder(x,y) then
		-- Natural wonder plots are not city-friendly,
		-- but treat plots adjacent to natural wonders as highly fertile.
		plotFertility = plotFertility + 5;
	end

	if plot:IsRiver() then
		-- River: fresh water access and watermill-capable.
		plotFertility = plotFertility + 2;
		hasFreshWater = true;
		
	elseif IsAdjacentToNonIceLake(x,y) then
		-- Access to fresh water improves housing for land plots.
		plotFertility = plotFertility + 1;
		hasFreshWater = true;
	end

	-- At this point, the plot is land/hills.
	if plot:IsHills() then
		-- Hills add production, which is a bonus for most terrains.
		plotFertility = plotFertility + 1;
	end
	
	if IsBaseTerrainType(g_TERRAIN_TYPE_GRASS, terrainType) then
		-- Grassland: 2 for flat, 3 for hills.
		plotFertility = plotFertility + 2;
		
	elseif IsBaseTerrainType(g_TERRAIN_TYPE_PLAINS, terrainType) then
		-- Plains: 3 for flat, 2 for hills.
		plotFertility = plotFertility + 3;
		if plot:IsHills() then
			-- Cancel out hills bonus.
			plotFertility = plotFertility - 2;
		end
		
	elseif (IsBaseTerrainType(g_TERRAIN_TYPE_TUNDRA, terrainType)) then
		-- Tundra: bad, but not as bad as snow/desert.
		plotFertility = plotFertility - 1;
		
	elseif (IsBaseTerrainType(g_TERRAIN_TYPE_SNOW, terrainType) or 
	        IsBaseTerrainType(g_TERRAIN_TYPE_DESERT, terrainType)) then
		-- Featureless flat snow/desert is barren, 
		-- but don't rule out the possibility of starting here.
		plotFertility = plotFertility - 2;
	end

	if featureType == g_FEATURE_FOREST then
		plotFertility = plotFertility + 1;
		
	elseif featureType == g_FEATURE_JUNGLE then
		plotFertility = plotFertility + 1;
        
    elseif (g_FEATURE_JNR_SAVANNAH and
            featureType == g_FEATURE_JNR_SAVANNAH) then
		plotFertility = plotFertility + 2;
	
	elseif (g_FEATURE_OPH_FUNGAL_FOREST and
            featureType == g_FEATURE_OPH_FUNGAL_FOREST) then
		plotFertility = plotFertility + 2;

	elseif IsMarshOrSwamp(featureType) then
		plotFertility = plotFertility + 1;

	elseif IsFloodplains(featureType) then 
		plotFertility = plotFertility + 5;
        
    elseif IsGeoFissure(plot) then
        plotFertility = plotFertility + 2;
	end
	
	if IsAdjacentToOasis(x,y) then
		-- Oases are not city friendly,
		-- so compensate by adding fertility to adjacent tiles instead.
		plotFertility = plotFertility + 1;
	end
	
	if plot:IsCoastalLand() then
		plotFertility = plotFertility + 1;
		if self.isMinor then
			-- Coastal land is especially good for minor civs
			-- because coast allows them to receive sea trade routes.
			plotFertility = plotFertility + 1;
		end
	end

	local distance_bias = self.distBiasMap[plotIndex];
	if (distance_bias > 0) then
		-- Close to another civ from previous run of start positioner.
		-- Slight penalty based on distance to the other civ.
		plotFertility = math.max(1, 
            plotFertility - Round(math.abs(plotFertility)*distance_bias/200));
	end

	return plotFertility, hasFreshWater;
end

function GotLakes_ASP:Water_MeasurePlotFertility(x, y)
	-- Fertility of plots is used to divide oceans or areas into Regions.
	-- Regions are used to assign starting plots and place some resources.
	-- Args: 
	--   x, y: plot coords, with 0,0 in SW.
	-- Returns:
	--   fertility: fertility score: > 0 means valid start
	--   hasOcean: true iff the plot has access to an ocean
	--
	-- We want players who start in the middle of vast oceans to have the least room to expand.
	local plot = Map.GetPlot(x, y);
	
	if (not (IsPassable(plot) and plot:IsWater())) then
		-- Not a valid location for a water start.
		return 0, false;
	end
	
	local numAdjacentOceans = CountAdjacentPassableOceans(x,y);
	local isOcean = (terrainType == g_TERRAIN_TYPE_OCEAN);
	local hasOcean = isOcean or (numAdjacentOceans > 0);
	
	if plot:IsLake() then
		-- Just a fresh lake. Set to minimum fertility.
		return 1, false;
		
	elseif (CountAdjacentPassableLand(x,y) > 2) then
		-- Bay or straight.
		return 2, hasOcean;
		
	elseif IsAdjacentToPassableLand(x,y) then
		-- Coastal water.
		return 3, hasOcean;
	end

	local terrainType = plot:GetTerrainType();
	local featureType = plot:GetFeatureType();
	
	if (terrainType == g_TERRAIN_TYPE_COAST) then
		-- Shallow water => land is probably nearby.
		return 4, hasOcean;
	end
	
	-- Got an ocean tile. Increase fertility with each adjacent ocean.
	local fert = 6 + 2*numAdjacentOceans;
	return fert, hasOcean;
end

function GotLakes_ASP:MeasureAreaFertility(
	iAreaID, iWestX, iEastX, iSouthY, iNorthY, wrapsX, wrapsY)
	-- This function is designed to provide initial data for regional division recursion.
	-- Loop through plots in this landmass and measure Fertility Rating.
	-- Results will include a data table of all plots within the rectangle that includes 
	-- the entirety of this landmass.
	--
	-- This function will account for any wrapping around the world this landmass may do.
	--
	-- Args:
	--   iAreaID: area ID of the landmass to measure
	--   iWestX, iEastX, iSouthY, iNorthY: bounding box of the landmass
	--   wrapsX: whether the landmass wraps across the east/west edge of the map
	--   wrapsY: whether the landmass wraps across the north/south edge of the map
	-- Returns:
	--   areaFertilityTable: a list of plot fertilities (one value for each plot in the 
	--     bounding box).
	--   areaFertilityCount: landmass fertility as the sum of all plot fertilities.
	--   plotCount: number of plots in the rectangle
	--   areaPlotCount: number of plots that are part of the landmass
	
	-- These coordinates will be used in case of wrapping landmass, 
	-- extending the landmass "off the map", in to imaginary space 
	-- to process it. Modulo math will correct the coordinates for 
	-- accessing the plot data array.
	local xEnd, yEnd; 
	
	if wrapsX then
		xEnd = iEastX + self.iW;
	else
		xEnd = iEastX;
	end
	if wrapsY then
		yEnd = iNorthY + self.iH;
	else
		yEnd = iNorthY;
	end
	--
	--print("Measuring start placement fertility for regional division.");
	
	local areaFertilityTable = {};
	local areaFertilityCount = 0;
	local plotCount     = 0; -- total plots in rectangle
	local areaPlotCount = 0; -- total plots with matching area ID
	-- whether land area has fresh water or water area has deep ocean access
	local areaHasGoodStuff = false;
	-- When generating a plot data table incrementally, 
	-- process Y first so that plots go row by row.
	for yLoop = iSouthY, yEnd do
		for xLoop = iWestX, xEnd do
			plotCount = plotCount + 1;
			local x = xLoop % self.iW;
			local y = yLoop % self.iH;
			local plot = Map.GetPlot(x, y);
			local thisPlotsArea =plot:GetArea():GetID();
			if thisPlotsArea ~= iAreaID then
				-- This plot is not a member of the landmass, set value to 0
				table.insert(areaFertilityTable, 0);
			else -- This plot is a member, process it.
				local plotFertility, hasGoodStuff = self:MeasurePlotFertility(x, y);
				table.insert(areaFertilityTable, plotFertility);
				areaPlotCount      = areaPlotCount      + 1;
				areaFertilityCount = areaFertilityCount + plotFertility;
				areaHasGoodStuff = areaHasGoodStuff or hasGoodStuff;
			end
		end
	end
	
	if (not areaHasGoodStuff) then
		-- The entire area is sub-par for lack of access to vital stuff.
		-- Slash fertility.
		print("Area #" .. iAreaID .. " is missing important start-plot features.");
        areaFertilityCount = 0;
        for i = 1, #areaFertilityTable do
            local badPlotFertility = math.max(1,Round(areaFertilityTable[i]/3));
            areaFertilityTable[i] = badPlotFertility;
            areaFertilityCount = areaFertilityCount + badPlotFertility; 
        end
	end
	
	-- Note: The table accounts for world wrap, so make sure to translate its index correctly.
	-- Plots in the table run from the southwest corner along the bottom row, 
	-- then upward row by row, per normal plot data indexing.
	return areaFertilityTable, areaFertilityCount, plotCount, areaPlotCount;
end

function GotLakes_ASP:RemoveDeadRows(fertility_table, iWestX, iSouthY, iWidth, iHeight)
	-- Any outside rows in the fertility table of a just-divided region that 
	-- contains all zeroes can be safely removed.
	-- This will improve the accuracy of operations involving any applicable region.
	local adjusted_table = {};
	local adjusted_WestX;
	local adjusted_SouthY
	local adjusted_Width
	local adjusted_Height;
	
	-- Check for rows to remove on the bottom.
	local adjustSouth = 0;
	for y = 0, iHeight - 1 do
		local bKeepThisRow = false;
		for x = 0, iWidth - 1 do
			local i = y * iWidth + x + 1;
			if fertility_table[i] ~= 0 then
				bKeepThisRow = true;
				break
			end
		end
		if bKeepThisRow == true then
			break
		else
			adjustSouth = adjustSouth + 1;
		end
	end

	-- Check for rows to remove on the top.
	local adjustNorth = 0;
	for y = iHeight - 1, 0, -1 do
		local bKeepThisRow = false;
		for x = 0, iWidth - 1 do
			local i = y * iWidth + x + 1;
			if fertility_table[i] ~= 0 then
				bKeepThisRow = true;
				break
			end
		end
		if bKeepThisRow == true then
			break
		else
			adjustNorth = adjustNorth + 1;
		end
	end

	-- Check for columns to remove on the left.
	local adjustWest = 0;
	for x = 0, iWidth - 1 do
		local bKeepThisColumn = false;
		for y = 0, iHeight - 1 do
			local i = y * iWidth + x + 1;
			if fertility_table[i] ~= 0 then
				bKeepThisColumn = true;
				break
			end
		end
		if bKeepThisColumn == true then
			break
		else
			adjustWest = adjustWest + 1;
		end
	end

	-- Check for columns to remove on the right.
	local adjustEast = 0;
	for x = iWidth - 1, 0, -1 do
		local bKeepThisColumn = false;
		for y = 0, iHeight - 1 do
			local i = y * iWidth + x + 1;
			if fertility_table[i] ~= 0 then
				bKeepThisColumn = true;
				break
			end
		end
		if bKeepThisColumn == true then
			break
		else
			adjustEast = adjustEast + 1;
		end
	end

	if adjustSouth > 0 or adjustNorth > 0 or adjustWest > 0 or adjustEast > 0 then
		-- Truncate this region to remove dead rows.
		adjusted_WestX = (iWestX + adjustWest) % self.iW;
		adjusted_SouthY = (iSouthY + adjustSouth) % self.iH;
		adjusted_Width = (iWidth - adjustWest) - adjustEast;
		adjusted_Height = (iHeight - adjustSouth) - adjustNorth;
		-- Reconstruct fertility table. This must be done row by row, so process Y coord first.
		for y = 0, adjusted_Height - 1 do
			for x = 0, adjusted_Width - 1 do
				local i = (y + adjustSouth) * iWidth + (x + adjustWest) + 1;
				local plotFert = fertility_table[i];
				table.insert(adjusted_table, plotFert);
			end
		end
		--[[
		print("-");
		print("Removed Dead Rows, West: ", adjustWest, " East: ", adjustEast);
		print("Removed Dead Rows, South: ", adjustSouth, " North: ", adjustNorth);
		print("-");
		print("Incoming values: ", iWestX, iSouthY, iWidth, iHeight);
		print("Outgoing values: ", adjusted_WestX, adjusted_SouthY, adjusted_Width, adjusted_Height);
		print("-");
		local incoming_index = table.maxn(fertility_table);
		local outgoing_index = table.maxn(adjusted_table);
		print("Size of incoming fertility table: ", incoming_index);
		print("Size of outgoing fertility table: ", outgoing_index);
		--]]
		return adjusted_table, adjusted_WestX, adjusted_SouthY, adjusted_Width, adjusted_Height;
	
	else -- Region not adjusted, return original values unaltered.
		return fertility_table, iWestX, iSouthY, iWidth, iHeight;
	end
end

function GotLakes_ASP:DivideIntoRegions(iNumDivisions, fertility_table, rectangle_data_table)
	-- This is a recursive algorithm. (Original concept and implementation by Ed Beach).
	--
	-- Fertility table is a plot data array including data for all plots to be processed here.
	-- The fertility table is obtained as part of the MeasureFertility functions, or via 
	-- division during the recursion.
	--
	-- Rectangle table includes seven data fields:
	-- westX, southY, width, height, AreaID, fertilityCount, plotCount
	--
	-- If AreaID is -1, it means the rectangle contains fertility data from all plots 
	-- regardless of their AreaIDs. The plotCount is an absolute count of plots within the 
	-- rectangle, without regard to AreaID membership. This is going to purposely reduce 
	-- average fertility per plot for Order-of-Assignment priority. Rectangles with a lot 
	-- of non-member plots will tend to be misshapen and need to be on the favorable side 
	-- of minDistance elements.
	
	-- If this rectangle is not to be divided, break recursion and record the data.
	if (iNumDivisions <= 1) then -- This area is to be defined as a Region.
		-- Expand rectangle table to include an eighth field for average fertility per plot.
		-- fertilityCount/plotCount
		local fAverageFertility = 0.00001;
		if (rectangle_data_table[7] >= 1) then -- Avoid division by zero.
			fAverageFertility = rectangle_data_table[6] / rectangle_data_table[7];
		end
		table.insert(rectangle_data_table, fAverageFertility);
		-- Insert this record in to the instance data for start placement regions for this game.
		-- (This is the crux of the entire regional definition process, 
		-- determining an actual region.)
		table.insert(self.regionData, rectangle_data_table);
		--[[
		local iNumberOfThisRegion = table.maxn(self.regionData);
		print("-");
		print("---------------------------------------------");
		print("Defined location of Start Region #", iNumberOfThisRegion);
		print("---------------------------------------------");
		print("-");
		--]]
		return;
	end
	
	-- Divide this rectangle into iNumDivisions worth of subdivisions, then send each
	-- subdivision back through this function in a recursive loop.
	--print("DivideIntoRegions: Need " .. iNumDivisions .. " regions.");
		
	local firstSubdivisions = 0;
	local laterSubdivisions = 0;
	
	-- See if region is taller or wider.
	local iWidth  = Round(rectangle_data_table[3]);
	local iHeight = Round(rectangle_data_table[4]);
	local bTaller = false;
	if iHeight > iWidth then
		bTaller = true;
	end

	if ((iNumDivisions % 2) == 0) then
		-- Even number of divisions, so divide evenly in half.	
		firstSubdivisions = iNumDivisions / 2;
		laterSubdivisions = firstSubdivisions;
		--print("DivideIntoRegions: even split => 2 x " .. firstSubdivisions);
		
		-- Undershoot by design, to compensate for inevitable overshoot. 
		-- Gets the actual result closer to target.
		chopPercent = 49.5;
		
	elseif ((iNumDivisions % 3) == 0) then
		-- Multiple of 3, so divide evenly into thirds.
		local iSubdivisions = iNumDivisions / 3;
		--print("DivideIntoRegions: even split => 3 x " .. iSubdivisions);

		local results = self:ChopIntoThreeRegions(fertility_table, rectangle_data_table, bTaller);
		local first_section_fertility_table = results[1];
		local first_section_data_table = results[2];
		local second_section_fertility_table = results[3];
		local second_section_data_table = results[4];
		local third_section_fertility_table = results[5];
		local third_section_data_table = results[6];
		
		self:DivideIntoRegions(
			iSubdivisions, first_section_fertility_table, first_section_data_table)
		self:DivideIntoRegions(
			iSubdivisions, second_section_fertility_table, second_section_data_table)
		self:DivideIntoRegions(
			iSubdivisions, third_section_fertility_table, third_section_data_table)
		return;
		
	else
		-- Not divisible by 2 or 3, so do an uneven split into two regions.
		firstSubdivisions = math.floor(iNumDivisions/2);
		laterSubdivisions = firstSubdivisions + 1;

		--print("DivideIntoRegions: uneven split => " .. firstSubdivisions .. " + " .. laterSubdivisions);
		
		-- These chopPercents are all set to undershoot slightly, 
		-- averaging out the actual result closer to target.
		chopPercent = 98 * (firstSubdivisions / iNumDivisions);
	end
	
	-- Chop into two pieces, either evenly or unevenly.
	local results = self:ChopIntoTwoRegions(
		fertility_table, rectangle_data_table, bTaller, chopPercent);
	local first_section_fertility_table = results[1];
	local first_section_data_table = results[2];
	local second_section_fertility_table = results[3];
	local second_section_data_table = results[4];
	
	self:DivideIntoRegions(
		firstSubdivisions, first_section_fertility_table, first_section_data_table)
	self:DivideIntoRegions(
		laterSubdivisions, second_section_fertility_table, second_section_data_table)
end

function GotLakes_ASP:ChopIntoThreeRegions(fertility_table, rectangle_data_table, bTaller)
	--print("-"); print("ChopIntoThree called.");
	-- Performs the mechanics of dividing a region into three roughly equal fertility subregions.
	local results = {};

	-- Chop off the first third.
	-- Undershoot by a bit, tends to make the actual result closer to accurate.
	local initial_results = self:ChopIntoTwoRegions(fertility_table, rectangle_data_table, bTaller, 33);
	-- add first subdivision to results
	local temptable = initial_results[1];
	table.insert(results, temptable); 

	--[[ Activate table printouts for debug purposes only, then deactivate when done. ]]--
	--print("Data returned to ChopIntoThree from ChopIntoTwo.");
	--PrintContentsOfTable(temptable)

	local temptable = initial_results[2];
	table.insert(results, temptable);

	--PrintContentsOfTable(temptable)

	-- Prepare the remainder for further processing.
	local second_section_fertility_table = initial_results[3]; 

	--PrintContentsOfTable(second_section_fertility_table)

	local second_section_data_table = initial_results[4];

	--PrintContentsOfTable(second_section_data_table)
	--print("End of this instance, ChopIntoThree tables.");

	-- See if this piece is taller or wider. (Ed's original implementation skipped this step).
	local bTallerForRemainder = false;
	local width = second_section_data_table[3];
	local height = second_section_data_table[4];
	if height > width then
		bTallerForRemainder = true;
	end

	-- Chop the bigger piece in half.
	-- Undershoot just a little.
	local interim_results = self:ChopIntoTwoRegions(
		second_section_fertility_table, second_section_data_table, bTallerForRemainder, 48.5);
	table.insert(results, interim_results[1]); 
	table.insert(results, interim_results[2]); 
	table.insert(results, interim_results[3]); 
	table.insert(results, interim_results[4]); 

	--[[ Returns a table of six entries, each of which is a nested table.
	1: fertility_table of first subdivision
	2: rectangle_data_table of first subdivision.
	3: fertility_table of second subdivision
	4: rectangle_data_table of second subdivision.
	5: fertility_table of third subdivision
	6: rectangle_data_table of third subdivision.  ]]--
	return results
end

function GotLakes_ASP:ChopIntoTwoRegions(
	fertility_table, rectangle_data_table, bTaller, chopPercent)
	-- Performs the mechanics of dividing a region into two subregions.
	--
	-- Fertility table is a plot data array including data for all plots to be processed here.
	-- This data already factors any need for processing AreaID.
	--
	-- Rectangle table includes seven data fields:
	-- westX, southY, width, height, AreaID, fertilityCount, plotCount
	--print("-"); print("ChopIntoTwo called.");

	--[[ Log dump of incoming table data. Activate for debug only.
	print("Data tables passed to ChopIntoTwoRegions.");
	PrintContentsOfTable(fertility_table)
	PrintContentsOfTable(rectangle_data_table)
	print("End of this instance, ChopIntoTwoRegions tables.");
	--]]--

	-- Read the incoming data table.
	local iWestX      = Round(rectangle_data_table[1]);
	local iSouthY     = Round(rectangle_data_table[2]);
	local iRectWidth  = Round(rectangle_data_table[3]);
	local iRectHeight = Round(rectangle_data_table[4]);
	local iAreaID = rectangle_data_table[5];
	local iTargetFertility = rectangle_data_table[6] * chopPercent / 100;
	
	-- Now divide the region.
	--
	-- West and South edges remain the same for first region.
	local firstRegionWestX = iWestX;
	local firstRegionSouthY = iSouthY;
	-- scope variables that get decided conditionally.
	local firstRegionWidth, firstRegionHeight;
	local secondRegionWestX, secondRegionSouthY, secondRegionWidth, secondRegionHeight;
	local iFirstRegionFertility = 0;
	local iSecondRegionFertility = 0;
	local region_one_fertility = {};
	local region_two_fertility = {};

	if (bTaller) then -- We will divide horizontally, resulting in first region on bottom, second on top.
		--
		-- Width for both will remain the same as the parent rectangle.
		firstRegionWidth = iRectWidth;
		secondRegionWestX = iWestX;
		secondRegionWidth = iRectWidth;

		-- Measure one row at a time, moving up from bottom, until we have exceeded the target fertility.
		local reachedTargetRow = false;
		local rectY = 0;
		while reachedTargetRow == false do
			-- Process the next row in line.
			for rectX = 0, iRectWidth - 1 do
				local fertIndex = rectY * iRectWidth + rectX + 1;
				local plotFertility = fertility_table[fertIndex] or 0;
				-- Add this plot's fertility to the region total so far.
				iFirstRegionFertility = iFirstRegionFertility + plotFertility;
				-- Record this plot in a new fertility table. (Needed for further subdivisions).
				-- Note, building this plot data table incrementally, so it must go row by row.
				table.insert(region_one_fertility, plotFertility);
			end
			if iFirstRegionFertility >= iTargetFertility then
				-- This row has completed the region.
				firstRegionHeight = rectY + 1;
				secondRegionSouthY = (iSouthY + rectY + 1) % self.iH;
				secondRegionHeight = iRectHeight - firstRegionHeight;
				reachedTargetRow = true;
				break
			else
				rectY = rectY + 1;
			end
		end
		
		-- Debug printout of division location.
		--print("Dividing along horizontal line between rows: ", secondRegionSouthY - 1, "-", secondRegionSouthY);
		
		-- Create the fertility table for the second region, the one on top.
		-- Data must be added row by row, to keep the table index behavior consistent.
		for rectY = firstRegionHeight, iRectHeight - 1 do
			for rectX = 0, iRectWidth - 1 do
				local fertIndex = rectY * iRectWidth + rectX + 1;
				local plotFertility = fertility_table[fertIndex] or 0;
				-- Add this plot's fertility to the region total so far.
				iSecondRegionFertility = iSecondRegionFertility + plotFertility;
				-- Record this plot in a new fertility table. (Needed for further subdivisions).
				-- Note, building this plot data table incrementally, so it must go row by row.
				table.insert(region_two_fertility, plotFertility);
			end
		end
				
	else -- We will divide vertically, resulting in first region on left, second on right.
		--
		-- Height for both will remain the same as the parent rectangle.
		firstRegionHeight = iRectHeight;
		secondRegionSouthY = iSouthY;
		secondRegionHeight = iRectHeight;
		
		--[[ First region's new fertility table will be a little tricky. We don't know how many 
		     table entries it will need beforehand, and we cannot add the entries sequentially
		     when the data is being generated column by column, yet the table index needs to 
		     proceed row by row. So we will have to make a second pass.  ]]--

		-- Measure one column at a time, moving left to right, until we have exceeded the target fertility.
		local reachedTargetColumn = false;
		local rectX = 0;
		while reachedTargetColumn == false do
			-- Process the next column in line.
			for rectY = 0, iRectHeight - 1 do
				local fertIndex = rectY * iRectWidth + rectX + 1;
				local plotFertility = fertility_table[fertIndex] or 0;
				-- Add this plot's fertility to the region total so far.
				iFirstRegionFertility = iFirstRegionFertility + plotFertility;
				-- No table record here, handle later row by row.
			end
			if iFirstRegionFertility >= iTargetFertility then
				-- This column has completed the region.
				firstRegionWidth = rectX + 1;
				secondRegionWestX = (iWestX + rectX + 1) % self.iW;
				secondRegionWidth = iRectWidth - firstRegionWidth;
				reachedTargetColumn = true;
				break
			else
				rectX = rectX + 1;
			end
		end

		-- Debug printout of division location.
		--print("Dividing along vertical line between columns: ", secondRegionWestX - 1, "-", secondRegionWestX);

		-- Create the fertility table for the second region, the one on the right.
		-- Data must be added row by row, to keep the table index behavior consistent.
		for rectY = 0, iRectHeight - 1 do
			for rectX = firstRegionWidth, iRectWidth - 1 do
				local fertIndex = rectY * iRectWidth + rectX + 1;
				local plotFertility = fertility_table[fertIndex];
				-- Add this plot's fertility to the region total so far.
				iSecondRegionFertility = iSecondRegionFertility + plotFertility;
				-- Record this plot in a new fertility table. (Needed for further subdivisions).
				-- Note, building this plot data table incrementally, so it must go row by row.
				table.insert(region_two_fertility, plotFertility);
			end
		end
		-- Now create the fertility table for the first region.
		for rectY = 0, iRectHeight - 1 do
			for rectX = 0, firstRegionWidth - 1 do
				local fertIndex = rectY * iRectWidth + rectX + 1;
				local plotFertility = fertility_table[fertIndex];
				table.insert(region_one_fertility, plotFertility);
			end
		end
	end
	
	-- Now check the newly divided regions for dead rows (all zero values) along
	-- the edges and remove any found.
	--
	-- First region
	local FRFertT, FRWX, FRSY, FRWid, FRHei;
	FRFertT, FRWX, FRSY, FRWid, FRHei = self:RemoveDeadRows(region_one_fertility,
		firstRegionWestX, firstRegionSouthY, firstRegionWidth, firstRegionHeight);
	--
	-- Second region
	local SRFertT, SRWX, SRSY, SRWid, SRHei;
	SRFertT, SRWX, SRSY, SRWid, SRHei = self:RemoveDeadRows(region_two_fertility,
		secondRegionWestX, secondRegionSouthY, secondRegionWidth, secondRegionHeight);
	--
	
	-- Generate the data tables that record the location of the new subdivisions.
	local firstPlots = FRWid * FRHei;
	local secondPlots = SRWid * SRHei;
	local region_one_data = {FRWX, FRSY, FRWid, FRHei, iAreaID, iFirstRegionFertility, firstPlots};
	local region_two_data = {SRWX, SRSY, SRWid, SRHei, iAreaID, iSecondRegionFertility, secondPlots};
	-- Generate the final data.
	local outcome = {FRFertT, region_one_data, SRFertT, region_two_data};
	return outcome
end

function GotLakes_ASP:DivideArea(iAreaID, numCivs)
	-- We'll need all eight data fields returned in the results table from the boundary finder:
	local landmass_data = self:GetLandmassBoundaries(iAreaID);
	local iWestX = landmass_data[1];
	local iSouthY = landmass_data[2];
	local iEastX = landmass_data[3];
	local iNorthY = landmass_data[4];
	local iWidth = landmass_data[5];
	local iHeight = landmass_data[6];
	local wrapsX = landmass_data[7];
	local wrapsY = landmass_data[8];
	
	-- Obtain "Start Placement Fertility" of the landmass. (This measurement is customized 
	-- for start placement). This call returns a table recording fertility of all plots 
	-- within a rectangle that contains the landmass, with a zero value for any plots not 
	-- part of the landmass -- plus a fertility sum and plot count.
	local fert_table, fertCount, plotCount, areaPlotCount = self:MeasureAreaFertility(
			iAreaID, iWestX, iEastX, iSouthY, iNorthY, wrapsX, wrapsY);
	-- Now divide this landmass in to regions, one per civ.
	-- The regional divider requires three arguments:
	-- 1. Number of divisions. (For "Biggest Landmass" this means number of civs in the game).
	-- 2. Fertility table. (This was obtained from the last call.)
	-- 3. Rectangle table. This table includes seven data fields:
	-- westX, southY, width, height, AreaID, fertilityCount, plotCount
	-- This is why we got the fertCount and plotCount from the fertility function.
	--
	-- Assemble the Rectangle data table:
	local rect_table = {iWestX, iSouthY, iWidth, iHeight, iAreaID, fertCount, plotCount};
	
	--[ Debug printout for regional division inputs.
	local fertPerPlot = Round(fertCount/math.max(1,areaPlotCount));
	local plotsPerCiv = Round(areaPlotCount/numCivs);
	local fertPerCiv  = Round(fertCount/numCivs);
	print("  Relevant Plots: " .. areaPlotCount);
	print("  Relevant Civs:  " .. numCivs);
	print("  Plots/Civ:      " .. plotsPerCiv);
	print("  Fertility:      " .. fertCount);
	print("  Fertility/Plot: " .. fertPerPlot);
	print("  Fertility/Civ:  " .. fertPerCiv);
	--]]
	
	if (areaPlotCount == 0) then
		print("Area #" .. iAreaID .. " has no relevant plots.");
		return;
	end
	
	-- The data from this call is processed in to self.regionData during the process.
	self:DivideIntoRegions(numCivs, fert_table, rect_table)
	-- The regions have been defined.
end

function GotLakes_ASP:Default_AssignCivsToAreas(land_area_fert, best_areas, numRelevantAreas)
	-- Determine how many civs can fit in each area 
	-- until we have enough areas to assign all of the civs.
	-- Args:
	--   land_area_fert: fertility info for each area
	--   best_areas: area IDs sorted by fertility
	--   numRelevantAreas: the number of areas to consider
	-- Returns:
	--   inhabitedAreaIDs: a list of IDs of areas that have assigned civs
	--   inhabitedAreas: a map of area ID to number of civs in each area.
	
	-- Assign continents to receive start plots. Record number of civs assigned to each 
	-- landmass.
	-- Use a padding multiplier to add slight bias towards civs on separate continents
	-- over civs sharing a continent.
	local civPaddingMult = 1.05;
	local inhabitedAreaIDs = {};
	local inhabitedAreas = {};
	-- Indexed in synch with best_areas. Use same index to match values from each table.
	local numberOfCivsPerArea = table.fill(0, #best_areas);
	-- Loop at least once for each civ, up to the number of relevant areas.
	-- But don't try to fill all relevant areas in case the best areas are much bigger than
	-- the worst areas.
	local bestFertility = nil;
	-- Thresh for comparing area fert to that of the best area.
	local minAreaFertRatio = 0.33; -- 0.25 seemed too small
	
	-- By default, create exactly one area per civ.
	local numAreasToAssign = self.iNumCivs;
	if self.enableCustomStartBias then
		-- Custom start bias algorithm supports extra areas.
		numAreasToAssign = math.max(numRelevantAreas, self.iNumCivs);
		print("Assigning up to " .. numRelevantAreas .. " area(s) for " .. 
			  self.iNumCivs .. " civs.");
	end
	for civToAssign = 1, numAreasToAssign do		
		local bestRemainingArea;
		local bestRemainingFertility = 0;
		local bestAreaTableIndex;
		-- Loop through areas, find the one with the best remaining fertility (civs added 
		-- to a landmass reduces its fertility rating for subsequent civs).
		--
		--print("- - Searching landmasses in order to place Civ #", civToAssign);
		for area_loop, AreaID in ipairs(best_areas) do
			local thisLandmassCurrentFertility = 
				land_area_fert[AreaID] / 
				(1 + (civPaddingMult * numberOfCivsPerArea[area_loop]));
			if thisLandmassCurrentFertility > bestRemainingFertility then
				bestRemainingArea = AreaID;
				bestRemainingFertility = thisLandmassCurrentFertility;
				bestAreaTableIndex = area_loop;
				--
			end
		end
        
        if not bestAreaTableIndex then
            print("No inhabitable areas!");
            break;
        end
		
		if ((numberOfCivsPerArea[bestAreaTableIndex] > 0) and (self.iNumCivs == 1)) then
			-- There is no point in dividing an area if we're placing only one civ 
			-- such as a water civ or a city state.
			print("Leaving the best area undivided for the one civ that needs a region.");
			break;
		end
		
		if (bestFertility and 
		    (civToAssign > self.iNumCivs) and
		    ((bestRemainingFertility / bestFertility) < minAreaFertRatio)) then
			-- This land's fertility is less than a fraction of the original land,
			-- and we've already assigned enough areas to place all civs. Avoid
			-- generating crappy extra regions.
			print("Ignoring relatively barren lands - already found enough for " .. 
				  tostring(civToAssign-1) .. " civs.");
			break;
		
		elseif not bestFertility then
			bestFertility = math.max(1,bestRemainingFertility);
			print("Best fertility is " .. bestFertility);
		else	
			print("Best remaining fertility is " .. bestRemainingFertility);
		end
		
		-- Record results for this pass. (A landmass has been assigned to receive 
		-- one more start point than it previously had).
		numberOfCivsPerArea[bestAreaTableIndex] = numberOfCivsPerArea[bestAreaTableIndex] + 1;
		if TestMembership(inhabitedAreaIDs, bestRemainingArea) == false then
			table.insert(inhabitedAreaIDs, bestRemainingArea);
			inhabitedAreas[bestRemainingArea] = 0;
		end
		inhabitedAreas[bestRemainingArea] = inhabitedAreas[bestRemainingArea] + 1;
	end
	
	--[[
	print("*** Number of Civs per Landmass - Table Readout ***");
	PrintContentsOfTable(inhabitedAreas)
	--]]
	
	return inhabitedAreas;
end

function GotLakes_ASP:Separate_AssignCivsToAreas(land_area_fert, best_areas, numRelevantAreas)
	-- Determine the most fair sequence of areas for assigning one civ per area.
	-- Args:
	--   land_area_fert: fertility info for each area
	--   best_areas: area IDs sorted by fertility
	--   numRelevantAreas: the maximum number of areas to consider
	-- Returns:
	--   inhabitedAreas: a map of area ID to number of civs in each area (always 1 in this case).
	
	-- Loop through areas to compare best with worst 
	-- in a sequence of areas as long as the number of civs.
	local minRatio = 10000;
	local minRatioIndex = 1;
	local worstFertIndexOffest = self.iNumCivs-1;
	if self.isMinor then
		-- Skip fairness search for minor civs.
		print("Using the best " .. self.iNumCivs .. " area(s).");
	else
		for iArea = 1, numRelevantAreas-self.iNumCivs do
			local thisAreaID = best_areas[iArea];
			local thisAreaFert = math.max(1,land_area_fert[thisAreaID]);
			
			local worstAreaID = best_areas[iArea+worstFertIndexOffest];
			local worstAreaFert = math.max(1,land_area_fert[worstAreaID]);

			local areaRatio = thisAreaFert / worstAreaFert;
			
			if (areaRatio < minRatio) then
				minRatio = areaRatio;
				minRatioIndex = iArea;
			end
		end
		
		print("Areas " .. minRatioIndex .. " through " .. 
						  tostring(minRatioIndex + worstFertIndexOffest) ..
						  " have a best/worst fertility ratio of " .. minRatio);
	end
	-- Assign continents to receive start plots.
	-- Use the fairness-optimized sequence of areas to map each civ to its own area.
	local inhabitedAreas = {};
	for civToAssign = 1, self.iNumCivs do
		inhabitedAreas[best_areas[minRatioIndex + civToAssign - 1]] = 1;
	end
	
	--[[
	print("*** Inhabited areas - Table Readout ***");
	PrintContentsOfTable(inhabitedAreas)
	--]]
	
	-- Maybe return a map intead of 2 lists...
	return inhabitedAreas;
end

function GotLakes_ASP:DivideContinental()
	-- Loop through all plots on the map, measuring fertility of each land 
	-- plot, identifying its AreaID, building a list of landmass AreaIDs, and
	-- tallying the Start Placement Fertility for each landmass.

	-- region_data: [WestX, EastX, SouthY, NorthY, 
	-- numLandPlotsinRegion, numCoastalPlotsinRegion,
	-- numOceanPlotsinRegion, iRegionNetYield, 
	-- iNumLandAreas, iNumPlotsinRegion]
	local best_areas = {};
	local globalFertilityOfLands = {};

	-- Obtain info on all landmasses for comparision purposes.
	local iGlobalFertilityOfLands = 0;
	local iNumLandPlots = 0; -- Becomes num water plots if self.startOnWater is true.
	local iNumLandAreas = 0;
	local hasPassableSaltWater = false;
	local land_area_IDs = {};
	local land_area_plots = {};
	local land_area_fert = {};
	local land_area_hasGoodStuff = {};
	-- Cycle through all plots in the bounding box, checking their Start Placement Fertility 
	-- and AreaID.
		
	for x = self.minX, self.maxX do
		for y = self.minY, self.maxY do
			local i = y * self.iW + x + 1;
			local plot = Map.GetPlot(x, y);
			if (IsPassable(plot) and 
				((self.startOnWater and plot:IsWater()) or (not plot:IsWater()))) then
				iNumLandPlots = iNumLandPlots + 1;
				if IsSaltWater(plot) then
					hasPassableSaltWater = true;
				end
				local iArea = plot:GetArea():GetID();
				local plotFertility, hasGoodStuff = self:MeasurePlotFertility(x, y);
				iGlobalFertilityOfLands = iGlobalFertilityOfLands + plotFertility;
				-- This plot is the first detected in its AreaID.
				if TestMembership(land_area_IDs, iArea) == false then 
					iNumLandAreas = iNumLandAreas + 1;
					table.insert(land_area_IDs, iArea);
					land_area_plots[iArea] = 1;
					land_area_fert[iArea] = plotFertility;
					land_area_hasGoodStuff[iArea] = hasGoodStuff;
				else -- This AreaID already known.
					land_area_plots[iArea] = land_area_plots[iArea] + 1;
					land_area_fert[iArea] = land_area_fert[iArea] + plotFertility;
					land_area_hasGoodStuff[iArea] = 
						land_area_hasGoodStuff[iArea] or hasGoodStuff;
				end
			end
		end
	end

	if not hasPassableSaltWater then
		self.hasPassableSaltWater = false;
	end
	
	local numGoodLandAreas = 0;
	for loop_index, data_entry in SortedPairs(land_area_fert) do
		if land_area_hasGoodStuff[loop_index] then
			numGoodLandAreas = numGoodLandAreas + 1;
		else
			-- The entire area is sub-par for lack of access to vital stuff.
			-- Slash fertility.
			--print("Area #" .. loop_index .. " is missing important start-plot features.");
			land_area_fert[loop_index] = math.max(1,Round((land_area_fert[loop_index])/5));
		end
	end

	-- Sort areas, achieving a list of AreaIDs with best areas first.
	--
	-- Fertility data in land_area_fert is stored with areaID index keys.
	-- Need to generate a version of this table with indices of 1 to n, where n is number of 
	-- land areas.
	local interim_table = {};
	for loop_index, data_entry in SortedPairs(land_area_fert) do
		table.insert(interim_table, {index=loop_index, fert=data_entry});
	end
	
	-- Sort the fertility values stored in the interim table. Sort order in Lua is lowest to 
	-- highest.
	table.sort(interim_table, CompareLandAreas);

	--[[
	for loop_index, info in ipairs(interim_table) do
		print("Interim Table ID " .. info.index .. " has fertility of " .. info.fert);
	end
	print("* * * * * * * * * *");
	--]]
	
	print("Found " .. iNumLandAreas .. " potential area(s).");

	-- By default, consider at most one region per civ.
	local iNumRelevantLandAreas = math.min(iNumLandAreas, self.iNumCivs);
	if (self.enableCustomStartBias and (numGoodLandAreas > self.iNumCivs)) then
		-- Custom start bias algorithm supports extra regions.
		iNumRelevantLandAreas = numGoodLandAreas;
	end
	
	if (self.divMethod == DIVMETHOD_SEPARATE) then 
		if (iNumLandAreas < self.iNumCivs) then
			print("Not enough areas to assign each civ its own area.");
			self.AssignCivsToAreas = GotLakes_ASP.Default_AssignCivsToAreas;
		else
			-- Limit the number of relevant areas in case there are lots of tiny islands.
			-- We might ignore some of best areas if using them would be unfair to other civs.
			iNumRelevantLandAreas = math.min(iNumLandAreas, 2*self.iNumCivs);
		end
	end
	
	-- Now re-match the AreaID numbers with their corresponding fertility values
	-- by comparing the original fertility table with the sorted interim table.
	-- During this comparison, best_areas will be constructed from sorted AreaIDs, richest 
	-- stored first.
	local best_areas = {};
	-- We may not need all entries in the table. Process only iNumRelevantLandAreas worth of 
	-- table entries.
	local fertility_value_list = {};
	local fertility_value_tie = false;
	local end_of_interim_table = #interim_table;
	for tableConstructionLoop = end_of_interim_table, 
		(end_of_interim_table - iNumRelevantLandAreas + 1), -1 do
		if TestMembership(
			fertility_value_list, interim_table[tableConstructionLoop].fert) == true then
			fertility_value_tie = true;
			--print("*** WARNING: Fertility Value Tie exists! ***");
		else
			table.insert(fertility_value_list, interim_table[tableConstructionLoop].fert);
		end
	end

	if fertility_value_tie then 
		-- Ties exist! Special handling required to protect against a 
		-- shortfall in the number of defined regions.
		local iNumUniqueFertValues = table.maxn(fertility_value_list);
		for fertLoop = 1, iNumUniqueFertValues do
			for AreaID, fert in SortedPairs(land_area_fert) do
				if fert == fertility_value_list[fertLoop] then
					-- Add ties only if there is room!
					local best_areas_length = table.maxn(best_areas);
					if best_areas_length < iNumRelevantLandAreas then
						table.insert(best_areas, AreaID);
					else
						break
					end
				end
			end
		end
	else
		-- No ties, so no need of special handling for ties.
		for areaTestLoop = end_of_interim_table, 
			(end_of_interim_table - iNumRelevantLandAreas + 1), -1 do
			for loop_index, AreaID in ipairs(land_area_IDs) do
				if interim_table[areaTestLoop].fert == 
					land_area_fert[land_area_IDs[loop_index]] then
					table.insert(best_areas, AreaID);
					break
				end
			end
		end
	end
		
	--[[ Debug printout
	print("-"); print("--- Continental Division, Initial Readout ---"); print("-");
	print("- Global Fertility:", iGlobalFertilityOfLands);
	print("- Total relevant Plots:", iNumLandPlots);
	print("- Total Areas:", iNumLandAreas);
	print("- Relevant Areas:", iNumRelevantLandAreas); print("-");
	--
	print("* * * * * * * * * *");
	for area_loop, AreaID in ipairs(best_areas) do
		print("Area ID " .. AreaID .. " has fertility of " .. land_area_fert[AreaID]);
	end
	print("* * * * * * * * * *");
	--]]

	local inhabitedAreas = self:AssignCivsToAreas(
		land_area_fert, best_areas, iNumRelevantLandAreas);
		
	-- Loop through the list of inhabited landmasses, dividing each landmass into regions.
	-- Note that it is OK to divide a continent with one civ on it: this will assign the 
	-- whole of the landmass to a single region, and is the easiest method of recording 
	-- such a region.
	local regionNum = 1;
	for areaId, numCivsInArea in SortedPairs(inhabitedAreas) do
		-- Divide this landmass in to number of regions equal to civs assigned here.
		if numCivsInArea > 0 then 
			-- Got a valid number of civs, so divide the region.
			print("Region #" .. regionNum .. " => Area #" .. areaId);
			self:DivideArea(areaId, numCivsInArea);
		end
		regionNum = regionNum + 1;
	end
	-- The regions have been defined.
end

function GotLakes_ASP:SortRegions()
	-- Set up list of regions (to be processed in this order).
	--
	-- First, make a list of all average fertility values...
	local regionAssignList = {};
	local averageFertilityListUnsorted = {};
	local averageFertilityListSorted = {}; 
	-- Have to make this a separate table, not merely a pointer to the first table.
	for i, region_data in ipairs(self.regionData) do
		local thisRegionAvgFert = region_data[8];
		table.insert(averageFertilityListUnsorted, {i, thisRegionAvgFert});
		table.insert(averageFertilityListSorted, {index=i, fert=thisRegionAvgFert});
	end
	-- Now sort the copy low to high.
	table.sort(averageFertilityListSorted, CompareLandAreas);
	-- Finally, match each sorted fertilty value to the matching unsorted region number 
	-- and record in sequence.
	for region_order = 1, #averageFertilityListSorted do
		for loop, data_pair in ipairs(averageFertilityListUnsorted) do
			local unsorted_fert = data_pair[2];
			if averageFertilityListSorted[region_order].fert == unsorted_fert then
				table.insert(regionAssignList, {regionId = data_pair[1]});
				-- HAVE TO remove the entry from the table in rare case of ties on fert 
				-- value. Or it will just match this value for a second time, then crash 
				-- when the region it was tied with ends up with nil data.
				table.remove(averageFertilityListUnsorted, loop);
				break
			end
		end
	end
	
	return regionAssignList;
end

function GotLakes_ASP:GenerateRegions(startMinY, startMaxY)
	print("GotLakes ASP: Dividing the map into Regions");
	-- This function stores its data in the instance (self) data table.
	--
	-- The "Three Methods" of regional division:
	-- 1. Biggest Landmass: All civs start on the biggest landmass.
	-- 2. Continental: Civs are assigned to continents. 
	--    Any continents with more than one civ are divided.

	-- Determine number of civilizations present in this game.
	
	print("Generating " .. self.regionType .. 
		  " regions for " .. self.iNumCivs .. " civ(s).");

	-- NOTE: these dimensions need to be whole numbers 
	-- or else indexing failures can occur.
	local minX = 0;
	local maxX = self.iW - 1;
	
	-- Y bounds: initially as percent of height for avoiding starts near the poles.
	local minY = startMinY or 0;
	local maxY = startMaxY or 100;
	
	-- Convert percentages into plot lengths.
	minY = Round(minY * 0.01 * self.iH);
	maxY = Round(maxY * 0.01 * self.iH);
	
	minY = math.clamp(minY, 0,    self.iH-1);
	maxY = math.clamp(maxY, minY, self.iH-1);
	
	self.minX = minX;
	self.minY = minY;
	self.maxX = maxX;
	self.maxY = maxY;
	
	if self.divMethod == DIVMETHOD_BIGGEST then
		print("Division Method: biggest area");
		-- Find the biggest landmass or ocean and divide that into regions.
		
		-- The largest landmass could be anywhere on the map, 
		-- so ignore coordinate constraints.
		print("Ignoring coordinate constraints.");
		self.minX = 0;
		self.maxX = self.iW-1;
		self.minY = 0;
		self.maxY = self.iH-1;
		
		local biggest_area = Areas.FindBiggestArea(self.startOnWater);
		local iAreaID = biggest_area:GetID();
		self:DivideArea(iAreaID, self.iNumCivs);
	
	elseif self.divMethod == DIVMETHOD_NONE then
		print("Division Method: none");
		-- Leave the world undivided.
		
		for i = 1, self.iNumCivs do
			-- Assign the whole world to every civ.
			local width = self.maxX - self.minX + 1;
			local height = self.maxY - self.minY + 1;
			local numPlots = width * height;
			local rectangle_data_table = 
			{ 
				self.minX,
				self.minY,
				width,
				height,
				-1, -- No area ID
				numPlots,
				numPlots,
				1
			}
			table.insert(self.regionData, rectangle_data_table);
		end
	
	else -- Continental (standard or separate areas)
		print("Division Method: continental (standard starts or separate areas)");
		self:DivideContinental();
	end
	
	-- Sanitize the results.
	for i, data in ipairs(self.regionData) do
		-- Turn region boundaries/dimensions into whole numbers 
		-- so that coordinates are also whole numbers.
		data[1] = Round(data[1]);
		data[2] = Round(data[2]);
		data[3] = Round(data[3]);
		data[4] = Round(data[4]);
		--[[ Printout is for debugging only. Deactivate otherwise.
		print("-");
		print("Data for Start Region #", i);
		print("WestX:  ", data[1]);
		print("SouthY: ", data[2]);
		print("Width:  ", data[3]);
		print("Height: ", data[4]);
		print("AreaID: ", data[5]);
		print("Fertility:", data[6]);
		print("Plots:  ", data[7]);
		print("Fert/Plot:", data[8]);
		print("-");
		--]]
	end
	return self:SortRegions();
end
--------------------------------------------------------------------------------------------------
-- Start of functions tied to ChooseLocations()
--------------------------------------------------------------------------------------------------
function GotLakes_ASP:GetBiggestPassableLandArea(minX, minY, maxX, maxY)
	-- Determine the largest number of passable land tiles that are reachable
	-- from a plot within the specified rectangle. Ignore all plots outside 
	-- of the rectangle
	--
	-- Args:
	--  minX, minY, maxX, maxY: ignore plots that are beyond this bounding rectangle.
	--
	-- Returns: the largest number of passable land tiles reachable from a plot
	-- within the bounding box, not including any land tiles outside of the bounding
	-- box.
	
	-- Memoize the visitation table to avoid redundant plot counts.
	local visited = table.fill(0, self.numTiles);
		
	local maxNumPlots = 0;
	
	for x = minX, maxX do
		for y = minY, maxY - 1 do
			maxNumPlots = math.max(maxNumPlots, self:GetPassableLandArea(
				Map.GetPlot(x,y), self.numTiles, minX, minY, maxX, maxY, visited));
		end
	end
	return maxNumPlots;
end

function GotLakes_ASP:GetPassableLandArea(
	plot, searchLimitNumTiles, minX, minY, maxX, maxY, plotsVisited)
	-- Count the number of passable land tiles reachable from the specified plot.
	-- Stop searching if we've reached the "big enough" threshold.
	--
	-- Args:
	--  plot: starting plot
	--  searchLimitNumTiles: stop traversing after reaching this many tiles.
	--  minX, minY, maxX, maxY: ignore plots that are beyond this bounding rectangle.
	--  plotsVisited: (optional) map of visited plots
	--
	-- Returns: the number of passable land tiles reachable from the specified
	--          plot, or zero if the plot itself is already-visited or not passable land.
	local visited = plotsVisited or table.fill(0, self.numTiles);
	
	local iX = plot:GetX();
	local iY = plot:GetY();
	local iVisited = iY * self.iW + iX + 1; -- add one because Lua arrays start at 1

	if ((searchLimitNumTiles == nil) or 
	    (IsPassableLand(plot) == false) or 
		(visited[iVisited] ~= 0)) then
		-- Non-passable or already-visited starting plot.
		return 0;
	end
	
	-- Use a stack to search neighboring tiles in DFS order until we've
	-- covered all of the tiles that share the same passable-land area.
	local stack = Stack:Create();
	local count = 0;
	
	stack:Push({x=iX, y=iY});
	visited[iVisited] = 1;
	
	while ((not stack:IsEmpty()) and (count < searchLimitNumTiles)) do
	
		local coord = stack:Pop();
		local x, y = coord.x, coord.y;
		
		-- Increase the tile count.
		count = count + 1;
		
		for i, direction in ipairs(HexDirections) do
			local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
			
			if (adjacentPlot ~= nil) then
				-- We have an adjacent plot.
				-- Let's see if it's unvisited passable land.
				local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
				local iCouldVisit = aY * self.iW + aX + 1;
			
				if ((IsPassableLand(adjacentPlot) == true) and 
					(visited[iCouldVisit] == 0) and 
					(aX >= minX) and (aX <= maxX) and 
					(aY >= minY) and (aY <= maxY)) then
					-- Add to the stack of plots to visit.
					stack:Push({x=aX, y=aY});
					visited[iCouldVisit] = 1;
				end
			end
		end
	end

	return count;
end

function GotLakes_ASP:IsFarFromNaturalWonder(plot)
	-- Returns false if the player can start because there is a natural wonder too close.

	-- If Start position config equals legendary then you can start near Natural wonders
	if(UserInput.start == START_LEGEND) then
		return true;
	end

	local iMaxNW = GlobalParameters.START_DISTANCE_MAJOR_NATURAL_WONDER or 4;

	local plotX = plot:GetX();
	local plotY = plot:GetY();
	for dx = -iMaxNW, iMaxNW do
		for dy = -iMaxNW,iMaxNW do
			local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, iMaxNW);
			if(otherPlot and otherPlot:IsNaturalWonder()) then
				return false;
			end
		end
	end 

	return true;
end

function GotLakes_ASP:PlaceImpactAndRipples(x, y)
	-- To establish a bias of 9, we Impact the overlay and Ripple outward multiple times.
	-- Value of 0 in a plot means no influence from existing Impacts in that plot.
	-- Value of 99 means an Impact occurred in that plot and it IS a start point.
	-- Values > 0 and < 99 are "ripples", meaning that plot is near a start point.
	local wrapX = self.wrapX;
	local impact_value = DISTBIAS_IMPACT;
	-- The base game tries to avoid starting civs within 12 plots of each other.
	-- However, if we tried that here then we'd risk starting civs in low-quality spots
	-- for crowded maps. So extend ripples no farther than 8 plots away.
	local ripple_values = DISTBIAS_MAJOR_RIPPLES;
	if self.isMinor then
		ripple_values = DISTBIAS_MINOR_RIPPLES
	end
    local numRipples = #ripple_values;
	
	local odd = self.firstRingYIsOdd;
	local even = self.firstRingYIsEven;
	local nextX, nextY, plot_adjustments;
	-- Now the main data layer, for start points themselves, and the City State data layer.
	-- Place Impact!
	local impactPlotIndex = y * self.iW + x + 1;
	self.distBiasMap[impactPlotIndex] = impact_value;
	self.distanceMap[impactPlotIndex] = 0;
    
    local maxRadius = math.min(self.maxImpactRadius, math.max(self.minDistBetweenCivs, numRipples));
    
	-- Place Ripples
	for ripple_radius = 1, maxRadius do
        local ripple_value = 0;
        if ripple_radius <= numRipples then
            ripple_value = ripple_values[ripple_radius];
        end
        -- Else we've gone beyond the ripples; just tracking distance to nearest civ.
    
		-- Moving clockwise around the ring, the first direction to travel will be Northeast.
		-- This matches the direction-based data in the odd and even tables. Each
		-- subsequent change in direction will correctly match with these tables, too.
		--
		-- Locate the plot within this ripple ring that is due West of the Impact Plot.
		local currentX = x - ripple_radius;
		local currentY = y;
		-- Now loop through the six directions, moving ripple_radius number of times
		-- per direction. At each plot in the ring, add the ripple_value for that ring 
		-- to the plot's entry in the distance data table.
		for direction_index = 1, 6 do
			for plot_to_handle = 1, ripple_radius do
				-- Must account for hex factor.
			 	if currentY / 2 > math.floor(currentY / 2) then
					-- Current Y is odd. Use odd table.
					plot_adjustments = odd[direction_index];
				else 
					-- Current Y is even. Use plot adjustments from even table.
					plot_adjustments = even[direction_index];
				end
				-- Identify the next plot in the ring.
				nextX = currentX + plot_adjustments[1];
				nextY = currentY + plot_adjustments[2];
				-- Make sure the plot exists
				if wrapX == false and (nextX < 0 or nextX >= self.iW) then
					-- X is out of bounds. Do not add ripple data to this plot.
				elseif (nextY < 0 or nextY >= self.iH) then 
					-- Y is out of bounds. Do not add ripple data to this plot.
				else -- Plot is in bounds, process it.
					-- Handle any world wrap.
					local realX = nextX;
					local realY = nextY;
					if wrapX == true then
						realX = realX % self.iW;
					end
					-- Record ripple data for this plot.
					local ringPlotIndex = realY * self.iW + realX + 1;
					self.distanceMap[ringPlotIndex] = 
						math.min(ripple_radius, self.distanceMap[ringPlotIndex]);
					if ((ripple_value > self.idealDistBias) and 
                        (self.distBiasMap[ringPlotIndex] > 0)) then 
						-- This plot is already in range of at least one other civ!
						-- First choose the greater of the two, existing value or current ripple.
						local stronger_value = 
							math.max(self.distBiasMap[ringPlotIndex], ripple_value);
						-- Now increase it with a multiplier > 1
						-- to reflect that multiple civs are in range of this plot.
                        -- Use math.ceil so that values always increase as a result of overlap.
						local overlap_value = math.min(DISTBIAS_IMPACT,
                            math.ceil(stronger_value * DISTBIAS_STACK_MULTIPLIER));
						self.distBiasMap[ringPlotIndex] = overlap_value;
					elseif (ripple_value > self.idealDistBias) then
						self.distBiasMap[ringPlotIndex] = ripple_value;
					end
				end
				currentX, currentY = nextX, nextY;
			end
		end
	end
end

function GotLakes_ASP:Land_MeasureSinglePlot(x, y, playerId)
	-- Note that "food" and "prod" not strictly about tile yield
	-- Also account for potential for improvement.
	--
	-- Returns:
	--   isFood: if the plot is a source of food
	--   isProd: if the plot is a source of production
	--   goodness: number of nice-to-have points.
	--   isJunk: if the plot is barren/unworkable
	local plot = Map.GetPlot(x, y);
	local plotIsHills  = plot:IsHills();
	local terrainType  = plot:GetTerrainType();
	local featureType  = plot:GetFeatureType();
    local resourceType = plot:GetResourceType();
    local resource = self.resources[resourceType] or {};
	local isFood = resource.isFood;
	local isProd = resource.isProd;
	local goodness = resource.goodness or 0;
	local isJunk = false;
    
	local playerBias = 0;
	if (playerId ~= nil) then
		-- Measure player's start bias.
		playerBias = 
			self.startBiasAnalyzer:GetBiasAtPlot(plot, playerId, self.startBiasTierMults);
		goodness = goodness + playerBias;
	end
	
	if plot:IsMountain() then
		-- Wonder mountains and volcanoes are good. Regular unreachable mountains are junk.
		if (plot:IsNaturalWonder() or IsVolcano(plot)) then
			goodness = goodness + 1;
		end
		
		isJunk = (goodness <= 0) and (not IsAdjacentToPassableLand(plot));
		return isFood, isProd, goodness, isJunk;
		
	elseif plot:IsWater() then
		if featureType == g_FEATURE_ICE then
			-- Ice is barren and impassble, so junk.
			isJunk = true;
		elseif (featureType ~= g_FEATURE_NONE) then
			-- Got a non-ice feature, which could be a natural wonder.
			goodness = goodness + 1;
			if g_FEATURE_REEF and (featureType == g_FEATURE_REEF) then
				isFood = true;
				isProd = true;
			elseif g_FEATURE_SUK_KELP and (featureType == g_FEATURE_SUK_KELP) then
				isFood = true;
			end
		elseif plot:IsLake() then
			-- Lakes themselves are not good, but adjacent land might be good.
			isFood = true;
		elseif terrainType == g_TERRAIN_TYPE_COAST then
			isFood = true;
		else
			-- Ocean tiles are neither good nor junk.
		end
		return isFood, isProd, goodness, isJunk;
	end
	-- At this point, the plot is either land or hills.

	-- Hills add production to all land terrain.
	isProd = plotIsHills;
	
	if (featureType ~= g_FEATURE_NONE) then
		-- Got a feature, which could be a natural wonder.
		-- All land features are good regardless of terrain.
		goodness = goodness + 1;
		if featureType == g_FEATURE_JUNGLE then
			isFood = true;
		elseif featureType == g_FEATURE_FOREST then
			isProd = true;
        elseif (g_FEATURE_JNR_SAVANNAH and
                featureType == g_FEATURE_JNR_SAVANNAH) then
            isFood = true;
            isProd = true;
        elseif (g_FEATURE_OPH_FUNGAL_FOREST and
                featureType == g_FEATURE_OPH_FUNGAL_FOREST) then
            isFood = true;
            isProd = true;
		elseif featureType == g_FEATURE_OASIS then
			isFood = true;
		elseif IsFloodplains(featureType) then
			isFood = true;	
        
		elseif g_FEATURE_GEOTHERMAL_FISSURE and 
			   (featureType == g_FEATURE_GEOTHERMAL_FISSURE) then
			-- Neither food nor prod; +1 goodness is enough
		
        elseif g_FEATURE_HD_SWAMP and 
			   (featureType == g_FEATURE_HD_SWAMP) then
			-- Neither food nor prod; +1 goodness is enough        
        
		elseif featureType == g_FEATURE_MARSH then
			isFood = true;
		end
	end
	
	if IsBaseTerrainType(g_TERRAIN_TYPE_DESERT, terrainType) then
		-- Desert is junk if featureless.
		isJunk = (playerBias <= 0) and 
                 (featureType == g_FEATURE_NONE) and
                 (not resource.helps);
		
	elseif IsBaseTerrainType(g_TERRAIN_TYPE_SNOW, terrainType) then
		-- Snow is junk unless it's a snow-asis or has a resource.
		isJunk = (playerBias <= 0) and 
                 (featureType ~= g_FEATURE_OASIS) and
                 (not resource.helps);

	elseif IsBaseTerrainType(g_TERRAIN_TYPE_TUNDRA, terrainType) then
		-- Tundra by itself is not junk, but not good either.
		-- Not farmable, so not enough food to count as a food source.

	elseif IsBaseTerrainType(g_TERRAIN_TYPE_PLAINS, terrainType) then
		-- Plains are always prod, but also food if flat.
		isFood = isFood or (not plotIsHills);
		isProd = true;
		goodness = goodness + 2;

	elseif IsBaseTerrainType(g_TERRAIN_TYPE_GRASS, terrainType) then
		-- Grass is always food (also prod if hills).
		isFood = true;
		goodness = goodness + 2;
	end
	
	if (not isJunk) then
		-- Additional checks for non-junk land/hill tiles.
		if IsAdjacentToMountain(x, y) then
			goodness = goodness + 1;
			
			local numAdjacentVolcanoes = CountAdjacentVolcanoes(x,y);
			if (numAdjacentVolcanoes == 1) then
				-- Volcanoes are even more useful than regular mountains...
				goodness = goodness + 1;
				
			elseif (numAdjacentVolcanoes > 1) then
				-- However, multiple adjacent volcanoes is probably too hazardous.
				goodness = goodness - 1;
			end
		end
		
		-- Let mountain goodness stack with fresh-water goodness.
		if plot:IsRiver() then
			-- Rivers offer fresh water and allow water mill.
			goodness = goodness + 2;
			
		elseif IsAdjacentToNonIceLake(x,y) then
			-- Lakes offer fresh water, but no water mill
			goodness = goodness + 1;
		end
	end

	return isFood, isProd, goodness, isJunk;
end

function GotLakes_ASP:Water_MeasureSinglePlot(x, y, playerId)
	-- Note that "food" and "prod" not strictly about tile yield
	-- Also account for potential for improvement.
	--
	-- Returns:
	--   isFood: if the plot is a source of food
	--   isProd: if the plot is a source of production
	--   goodness: number of nice-to-have points.
	--   isJunk: if the plot is barren/unworkable
	local plot = Map.GetPlot(x, y);
	local plotIsHills = plot:IsHills();
	local terrainType = plot:GetTerrainType();
	local featureType = plot:GetFeatureType();
	
	local isFood = false;
	local isProd = false;
	local goodness = 0;
	local isJunk = false;
	
	if plot:IsNaturalWonder() then
		-- Wonders are good for early exploring
		goodness = goodness + 1;
	end
	
	if not (plot:IsWater() and IsPassable(plot)) then
		-- Treat land and obstacles as junk.
		isJunk = true;
		return isFood, isProd, goodness, isJunk;
	end
	
	-- Passable water is good.
	-- Food/Prod doesn't matter since water starts are initially explorers,
	-- But set them anyway so that a water start can passes minimum thresholds.
	isFood = true;
	isProd = true;
	goodness = goodness + 1;

	if IsOcean(plot) then
		-- Ocean tiles are even better.
		goodness = goodness + 2;
	end
	return isFood, isProd, goodness, isJunk;
end

function GotLakes_ASP:EvaluateCandidatePlot(plotIndex, playerId, baseScore)
	local goodSoFar = true;
	local reason = "I dunno...";
	local x = (plotIndex - 1) % self.iW;
	local y = math.floor((plotIndex - x - 1) / self.iW);
	local plot = Map.GetPlot(x, y);
	local isEvenY = true;
	if ((y % 2) == 1) then
		isEvenY = false;
	end
	local wrapX = self.wrapX;
	local distance_bias    = self.distBiasMap[plotIndex];
	local distToNearestCiv = self.distanceMap[plotIndex];
	local foodTotal, prodTotal, goodTotal, junkTotal = 0, 0, 0, 0;
	local plotScore = baseScore or 0;
	local search_table = {};
	local junkMult = 4;
	
	-- Evaluate the plot itself.
	local isFood, isProd, goodness, isJunk = self:MeasureSinglePlot(x, y, playerId);
	if isJunk then
		-- The plot itself is junk.
		plotScore = plotScore - 60;
	else
		-- Amplify goodness of the plot itself.
		plotScore = plotScore + (13 * goodness);
	end
		
	-- Evaluate First Ring
	if isEvenY then
		search_table = self.firstRingYIsEven;
	else
		search_table = self.firstRingYIsOdd;
	end

	for loop, plot_adjustments in ipairs(search_table) do
		local searchX, searchY;
		if wrapX then
			searchX = (x + plot_adjustments[1]) % self.iW;
		else
			searchX = x + plot_adjustments[1];
		end
		searchY = y + plot_adjustments[2];
		--
		if searchX < 0 or searchX >= self.iW or searchY < 0 or searchY >= self.iH then
			-- This plot does not exist. It's off the map edge.
			junkTotal = junkTotal + 1;
		else
			local isFood, isProd, goodness, isJunk = 
				self:MeasureSinglePlot(searchX, searchY, playerId);
			if isJunk then
				junkTotal = junkTotal + 1;
			end
			if isFood then
				foodTotal = foodTotal + 1;
			end
			if isProd then
				prodTotal = prodTotal + 1;
			end
			goodTotal = goodTotal + goodness;
		end
	end

	-- Set up the "score" for this candidate. Inner ring results weigh the heaviest.
	local weightedFoodInner = {0, 8, 14, 19, 22, 24, 25};
	local foodResultInner = weightedFoodInner[foodTotal + 1];
	local weightedProdInner = {0, 10, 16, 20, 20, 12, 0};
	local prodResultInner = weightedProdInner[prodTotal + 1];
	local goodResultInner = goodTotal * 2;
	local innerRingScore = 
		foodResultInner + prodResultInner + goodResultInner - (junkTotal * junkMult);
	
	-- Evaluate Second Ring
	if isEvenY then
		search_table = self.secondRingYIsEven;
	else
		search_table = self.secondRingYIsOdd;
	end

	for loop, plot_adjustments in ipairs(search_table) do
		local searchX, searchY;
		if wrapX then
			searchX = (x + plot_adjustments[1]) % self.iW;
		else
			searchX = x + plot_adjustments[1];
		end
		searchY = y + plot_adjustments[2];
		if searchX < 0 or searchX >= self.iW or searchY < 0 or searchY >= self.iH then
			-- This plot does not exist. It's off the map edge.
			junkTotal = junkTotal + 1;
		else
			local isFood, isProd, goodness, isJunk = 
				self:MeasureSinglePlot(searchX, searchY, playerId);
			if isJunk then
				junkTotal = junkTotal + 1;
			end
			if isFood then
				foodTotal = foodTotal + 1;
			end
			if isProd then
				prodTotal = prodTotal + 1;
			end
			goodTotal = goodTotal + goodness;
		end
	end
	
	-- Update up the "score" for this candidate. Middle ring results weigh significantly.
	-- 35 for any further values.
	local weightedFoodMiddle = {0, 2, 5, 10, 20, 25, 28, 30, 32, 34, 35};
	local foodResultMiddle = 35;
	if foodTotal < 10 then
		foodResultMiddle = weightedFoodMiddle[foodTotal + 1];
	end
	local weightedProdMiddle = {0, 10, 20, 25, 30, 35}; -- 35 for any further values.
	local effectiveProdTotal = prodTotal;
	if foodTotal * 2 < prodTotal then
		effectiveProdTotal = math.ceil(foodTotal / 2);
	end
	local prodResultMiddle = 35;
	if effectiveProdTotal < 5 then
		prodResultMiddle = weightedProdMiddle[effectiveProdTotal + 1];
	end
	local goodResultMiddle = goodTotal * 2;
	local middleRingScore = 
		foodResultMiddle + 
		prodResultMiddle + 
		goodResultMiddle - 
		(junkTotal * junkMult);
	
	-- Evaluate Third Ring
	if isEvenY then
		search_table = self.thirdRingYIsEven;
	else
		search_table = self.thirdRingYIsOdd;
	end

	for loop, plot_adjustments in ipairs(search_table) do
		local searchX, searchY;
		if wrapX then
			searchX = (x + plot_adjustments[1]) % self.iW;
		else
			searchX = x + plot_adjustments[1];
		end
		searchY = y + plot_adjustments[2];
		if searchX < 0 or searchX >= self.iW or searchY < 0 or searchY >= self.iH then
			-- This plot does not exist. It's off the map edge.
			junkTotal = junkTotal + 1;
		else
			local isFood, isProd, goodness, isJunk = 
				self:MeasureSinglePlot(searchX, searchY, playerId);
			if isJunk then
				junkTotal = junkTotal + 1;
			end
			if isFood then
				foodTotal = foodTotal + 1;
			end
			if isProd then
				prodTotal = prodTotal + 1;
			end
			goodTotal = goodTotal + goodness;
		end
	end

	-- Tally the final "score" for this candidate.
	local outerRingScore = foodTotal + prodTotal + goodTotal - (junkTotal * (junkMult-1));
	local finalScore = plotScore + innerRingScore + middleRingScore + outerRingScore;

	-- Check Impact and Ripple data to see if candidate is near an already-placed start point.
	if distance_bias > 0 then
        if distance_bias > self.safeDistBias then
            -- This candidate is near an already placed start. This invalidates its 
            -- eligibility for first-pass placement; but it may still qualify as a 
            -- fallback site, and we will reduce its Score according to the bias factor.
            goodSoFar = false;
            reason = "unsafe distance between civs";
        end
        -- Else slightly close to another civ: still OK but reduce the plot score.
        finalScore = finalScore - math.floor(math.abs(finalScore) * distance_bias / 100);
	end
	
	if (not self.startOnWater) then
		-- Checks that are specific to land starts.
	
		-- Get the size in tiles of the land-chunk that owns this plot.
		-- This can be less than plot:GetArea():GetPlotCount() 
		-- due to mountains making other tiles unreachable by land.
		local plotAreaNumTiles = self:GetPassableLandArea(
			plot, self.minLandSize, self.minX, self.minY, self.maxX, self.maxY);
		
		if (plotAreaNumTiles < self.minLandSize) then
			-- This island is less than a small fraction of the biggest land-chunk's size.
			--print("Downgrading tiny-island plot at " .. CoordString(x,y) ..
			--	" which can only reach " .. plotAreaNumTiles .. " tile(s).");
			finalScore = finalScore - 40;
			
		elseif IsAdjacentToSaltWater(x,y) then
			-- Bonus for coastal land on a decently-sized land chunk, 
			-- because coastal start boosts Sailing research and helps naval/coastal civs.
			-- This is a fix for the base game's start bias system only.
			--print("Upgrading coastal land plot at " .. CoordString(x,y));
			local coastBonus = 40;
			if self.enableCustomStartBias then
				-- Custom start bias has its own tier-weighted bonus for coastal civs.
				coastBonus = coastBonus - (5*self.startBiasTierMults[1]);
			end
			if self.isMinor then
				-- Additional bonus for minor civs
				-- because coast allows access to trade routes.
				coastBonus = coastBonus + 30; 
			end
			finalScore = finalScore + coastBonus;
		end
	
		-- Avoid plots that have no access to fresh water.
		if ((not plot:IsWater()) and 
			(not plot:IsMountain()) and
			(not plot:IsRiver()) and
			(not IsAdjacentToNonIceLake(x,y))) then
			--print("Downgrading non-fresh plot at " .. CoordString(x,y));
			goodSoFar = false;
			reason = "no fresh water besides ice";
			finalScore = finalScore - 40;	
		end
	end
	
	if (not self:IsFarFromNaturalWonder(plot)) then
		-- The plot is too close to a natural wonder.
		-- Downgrade to discourage starting too close to the wonder.
		finalScore = finalScore - 80;
	end

	--[[ Debug
	print(".");
	print("Plot:", x, y, " Food:", foodTotal, "Prod: ", prodTotal, "Good:", goodTotal, "Junk:", 
	       junkTotal, "Score:", finalScore);
	print("Plot:", x, y, " Coastal:", self.plotDataIsCoastal[plotIndex], "Distance Bias:", distance_bias);
	--]]
	
	return finalScore, goodSoFar, reason;
end

function GotLakes_ASP:IsBetterPlot(score, bestScore, numTies)
	-- Compare current plot's score to the best score.
	-- If the scores are equal then use a tie-breaker based on the number of previous ties 
	-- at the best score.
	-- Args:
	--   score: score to compare
	--   bestScore: current best (highest) score
	--   numTies: how many previous ties have occurred at the current best score
	-- Returns
	--   isBetter: true iff the current score beats the best score
	--   numTies: an updated count of the number of ties for the best score
	if (score > bestScore) then
		-- Reset tie-breaker count.
		return true, 0;
	end
	
	if (score == bestScore) then 
		-- In the event of a tie, 
		-- randomly pick a winner to avoid bias towards SW corner of the map.
		-- Reduce chances of winning to avoid bias towards the NE corner of the map.
		local numTies = numTies + 1;
		return (TerrainBuilder.GetRandomNumber(numTies + 1, "Tie Breaker") == 0), numTies;
	end
	
	return false, numTies;
end

function GotLakes_ASP:IterateThroughCandidatePlotList(plot_list, playerId, baseScore)
	-- Iterates through a list of candidate plots.
	-- Each plot is identified by its global plot index.
	-- This function assumes all candidate plots can have a city built on them.
	-- Any plots not allowed to have a city should be weeded out when building the candidate list.
	local found_eligible = false;
	local bestPlotScore = -5000;
	local bestPlotIndex;
	local found_fallback = false;
	local bestFallbackScore = -5000;
	local bestFallbackIndex = -1;
	local bestFallbackReason = "";
	local isBetter = false;
	local numTies = 0;
	-- Process list of candidate plots.
    -- Shuffle the list to avoid directional bias in tie breaking.
    local shuffledPlots = GetShuffledCopyOfTable(plot_list);
	for loop, plotIndex in ipairs(shuffledPlots) do
		local score, meets_minimums, fallbackReason =
			self:EvaluateCandidatePlot(plotIndex, playerId, baseScore);
		-- Test current plot against best known plot.
		if meets_minimums then
			found_eligible = true;
			isBetter, numTies = self:IsBetterPlot(score, bestPlotScore, numTies);
			if isBetter then
				bestPlotScore = score;
				bestPlotIndex = plotIndex;
			end
		else
			isBetter, numTies = self:IsBetterPlot(score, bestPlotScore, numTies);
			if ((not found_fallback) or isBetter) then
				found_fallback = true;
				bestFallbackScore = score;
				bestFallbackIndex = plotIndex;
				bestFallbackReason = fallbackReason;
			end
		end
	end
	local election_results = 
	{	
		found_eligible,     -- bool
		bestPlotScore,      -- int
		bestPlotIndex,      -- int
		found_fallback,     -- bool
		bestFallbackScore,  -- int
		bestFallbackIndex,  -- int
		bestFallbackReason  -- string
	};
	return election_results
end

function GotLakes_ASP:FindClosestPlot(outer_eligible_list, iWidth, iHeight, iWestX, iSouthY)
	-- Helper method to encapsulate some confusing logic.
	local closestPlot;
	local closestDistance = math.max(self.iW, self.iH);
	local bullseyeX = iWestX + (iWidth / 2);
	if bullseyeX < iWestX then -- wrapped around: un-wrap it for test purposes.
		bullseyeX = bullseyeX + self.iW;
	end
	local bullseyeY = iSouthY + (iHeight / 2);
	if bullseyeY < iSouthY then -- wrapped around: un-wrap it for test purposes.
		bullseyeY = bullseyeY + self.iH;
	end
	if (math.floor(bullseyeY) % 2 == 1) then -- Y coord is odd, add .5 to X coord for hex-shift.
		bullseyeX = bullseyeX + 0.5;
	end
	
	for loop, plotIndex in ipairs(outer_eligible_list) do
		local fx = (plotIndex - 1) % self.iW;
		local fy = math.floor((plotIndex - fx - 1) / self.iW);
		local adjusted_x = fx;
		local adjusted_y = fy;
		if (math.floor(fy) % 2 == 1) then -- Y coord is odd, add .5 to X coord for hex-shift.
			adjusted_x = fx + 0.5;
		end
		
		if fx < iWestX then -- wrapped around: un-wrap it for test purposes.
			adjusted_x = adjusted_x + self.iW;
		end
		if fy < iSouthY then -- wrapped around: un-wrap it for test purposes.
			adjusted_y = fy + self.iH;
		end
		local fDistance = math.sqrt( (adjusted_x - bullseyeX)^2 + (adjusted_y - bullseyeY)^2 );
		if fDistance < closestDistance then -- Found new "closer" plot.
			closestPlot = plotIndex;
			closestDistance = fDistance;
		end
	end
	-- Assign the closest eligible plot as the start point.
	local x = (closestPlot - 1) % self.iW;
	local y = math.floor((closestPlot - x - 1) / self.iW);

	return x, y, closestPlot;
end

function GotLakes_ASP:FindFallbackStart(fallback_plots)
	-- Compare all the fallback plots and choose the best to be the start plot.
	-- Args:
	--   fallback_plots: a list of plots to consider.
	-- Returns
	--   gotFallback: true iff we found a fallback plot.
	--   x, y: coords of the fallback plot, if found
	--   score: candidate score of the follback plot, if found
	--   description: brief description of the plot's quality, if found
	local gotFallback   = false;
	local x             = -1;
	local y             = -1;
	local bestPlotScore = -50000;
	local description   = "";
	
	local iNumFallbacks = #fallback_plots;
	if (iNumFallbacks == 0) then
		-- No fallback plots to consider.
		return gotFallback, x, y, bestPlotScore, description;
	end
	
	local isBetter = false;
	local numTies  = 0;
    -- Shuffle the plots to avoid directional bias for tie breaking.
    local shuffledPlots = GetShuffledCopyOfTable(fallback_plots);
	for loop, plotData in ipairs(shuffledPlots) do
		local score = plotData[3];
		
		isBetter, numTies = self:IsBetterPlot(score, bestPlotScore, numTies);
		if isBetter then
			gotFallback   = true;
			bestPlotScore = score;
			x             = plotData[1];
			y             = plotData[2];
			description   = plotData[4];
		end
	end
	return gotFallback, x, y, bestPlotScore, description;
end

function GotLakes_ASP:FindForcedStart(iWidth, iHeight, iWestX, iSouthY)
	-- Search a region for a start plot that can host a city.
	-- Only do this when there are no fallback plots.
	--
	-- Args:
	--   iWidth: width of the region
	--   iHeight: height of the region
	--   iWestX: west edge of the region
	--   iSouthY: bottom edge of the region
	--
	-- Returns: 
	--     x, y start coordinates
    --     start-quality score, 
	--     a brief description of the start's quality,
    --     and distance to the nearest civ (0 if distance is greater than ripple radius)
	
	-- Add some randomness to the start location of the scan.
	local iStartX = TerrainBuilder.GetRandomNumber(iWidth,  "X for passable-start search.");
	local iStartY = TerrainBuilder.GetRandomNumber(iHeight, "Y for passable-start search.");
	for region_y = 0, iHeight - 1 do -- When handling global plot indices, process Y first.
		for region_x = 0, iWidth - 1 do
			local x = ( ((region_x + iStartX) % iWidth)  + iWestX)  % self.iW;
			local y = ( ((region_y + iStartY) % iHeight) + iSouthY) % self.iH;
			local plotIndex = y * self.iW + x + 1;
			local plot = Map.GetPlot(x, y);
			local distToNearestCiv = self.distanceMap[plotIndex];
			-- Check if plot can host a city.
			if (IsCityFriendly(plot) and (distToNearestCiv >= self.minDistBetweenCivs)) then
				print("Found a passable force-start plot at " .. CoordString(x,y));
				return x, y, 0, "Forced", distToNearestCiv;
			end
		end
	end
	
	print("An entire civ start region at " .. 
		CoordString(iWestX, iSouthY) .. " with dimensions " .. 
		CoordString(iWidth, iHeight) .. " is impassable!");
	return nil;
end

function GotLakes_ASP:Land_FindStart(region_number, playerId)
	-- Attempt to choose a start position for a single region.
	-- Args:
	--   region_number: which region in [1,numCivs]
	--   playerId: which player owns this region, 
	--     or nil if players have not been assigned to regions.
	-- Returns:
	--     x, y start coordinates
    --     start-quality score, 
	--     a brief description of the start's quality,
    --     and distance to the nearest civ (0 if distance is greater than ripple radius)
	
	-- Obtain data needed to process this region.
	local region_data_table = self.regionData[region_number];
	local iWestX = region_data_table[1];
	local iSouthY = region_data_table[2];
	local iWidth = region_data_table[3];
	local iHeight = region_data_table[4];
	local iAreaID = region_data_table[5];
	--
	-- Done setting up region data.
	-- Set up contingency.
	local fallback_plots = {};
	
	print("Looking for land start between " .. CoordString(iWestX, iSouthY) .. 
		  " and " .. CoordString(iWestX+iWidth-1, iSouthY+iHeight-1) .. 
		  " with region size " .. CoordString(iWidth, iHeight));
	
	-- Establish scope of center bias.
	local fCenterWidth = (self.centerBias / 100) * iWidth;
	local iNonCenterWidth = math.floor((iWidth - fCenterWidth) / 2)
	local iCenterWidth = iWidth - (iNonCenterWidth * 2);
	-- Modulo math to synch coordinate to actual map in case of world wrap.
	local iCenterWestX = (iWestX + iNonCenterWidth) % self.iW;
	-- "Test" values ignore world wrap for easier membership testing.
	local iCenterTestWestX = (iWestX + iNonCenterWidth);
	local iCenterTestEastX = (iCenterWestX + iCenterWidth - 1);

	local fCenterHeight = (self.centerBias / 100) * iHeight;
	local iNonCenterHeight = math.floor((iHeight - fCenterHeight) / 2)
	local iCenterHeight = iHeight - (iNonCenterHeight * 2);
	local iCenterSouthY = (iSouthY + iNonCenterHeight) % self.iH;
	local iCenterTestSouthY = (iSouthY + iNonCenterHeight);
	local iCenterTestNorthY = (iCenterTestSouthY + iCenterHeight - 1);

	-- Establish scope of "middle donut", outside the center but inside the outer.
	local fMiddleWidth = (self.middleBias / 100) * iWidth;
	local iOuterWidth = math.floor((iWidth - fMiddleWidth) / 2)
	local iMiddleWidth = iWidth - (iOuterWidth * 2);
	local iMiddleWestX = (iWestX + iOuterWidth) % self.iW;
	local iMiddleTestWestX = (iWestX + iOuterWidth);
	local iMiddleTestEastX = (iMiddleTestWestX + iMiddleWidth - 1);

	local fMiddleHeight = (self.middleBias / 100) * iHeight;
	local iOuterHeight = math.floor((iHeight - fMiddleHeight) / 2)
	local iMiddleHeight = iHeight - (iOuterHeight * 2);
	local iMiddleSouthY = (iSouthY + iOuterHeight) % self.iH;
	local iMiddleTestSouthY = (iSouthY + iOuterHeight);
	local iMiddleTestNorthY = (iMiddleTestSouthY + iMiddleHeight - 1); 

	-- Assemble candidates lists.
	local river             = {};
	local coastal           = {};
	local inland_dry        = {};
	local player_river      = {};
	local player_coastal    = {};
	local player_inland_dry = {};
	local center_river      = {};
	local center_coastal    = {};
	local center_inland_dry = {};
	local middle_river      = {};
	local middle_coastal    = {};
	local middle_inland_dry = {};
	local outer_river       = {};
	local outer_coastal     = {};
	local outer_inland_dry  = {};
	
	-- Identify candidate plots.
	for region_y = 0, iHeight - 1 do -- When handling global plot indices, process Y first.
		for region_x = 0, iWidth - 1 do
			-- Actual coords, adjusted for world wrap, if any.
			local x = (region_x + iWestX) % self.iW; 
			local y = (region_y + iSouthY) % self.iH;
			local plotIndex = y * self.iW + x + 1;
			local plot = Map.GetPlot(x, y);
			local distToNearestCiv = self.distanceMap[plotIndex];
			
			if IsCityFriendly(plot) and (distToNearestCiv >= self.minDistBetweenCivs) then 
				-- Could host a city.
				local area_of_plot = plot:GetArea():GetID();
				if area_of_plot == iAreaID or iAreaID == -1 then
					-- This plot is a member, so it goes on at least one candidate list.
					
					-- "Test" coords, ignoring any world wrap and
					-- reaching in to virtual space if necessary.
					local test_x = region_x + iWestX; 
					local test_y = region_y + iSouthY;
					
					local plotIsCoast = 
						plot:IsFreshWater() or self.plotDataIsCoastal[plotIndex] == true;
					
					if ((playerId ~= nil) and 
						self.startBiasAnalyzer:HasBiasAtPlot(
							plot, playerId, self.startBiasTierMults)) then
						-- Plot has player-specific start bias.
						if plot:IsRiver() then
							table.insert(player_river, plotIndex);
						elseif plotIsCoast then
							table.insert(player_coastal, plotIndex);
						else
							table.insert(player_inland_dry, plotIndex);
						end
										
					-- Test whether plot is in center bias, middle donut, or outer donut.
					elseif ((test_x >= iCenterTestWestX  and test_x <= iCenterTestEastX) and 
					        (test_y >= iCenterTestSouthY and test_y <= iCenterTestNorthY)) then
						-- Center Bias.
						if plot:IsRiver() then
							table.insert(river, plotIndex);
							table.insert(center_river, plotIndex);
						elseif plotIsCoast then
							table.insert(coastal, plotIndex);
							table.insert(center_coastal, plotIndex);
						else
							table.insert(inland_dry, plotIndex);
							table.insert(center_inland_dry, plotIndex);
						end
					elseif (test_x >= iMiddleTestWestX and test_x <= iMiddleTestEastX) and 
						   (test_y >= iMiddleTestSouthY and test_y <= iMiddleTestNorthY) then
						if plot:IsRiver() then
							table.insert(river, plotIndex);
							table.insert(middle_river, plotIndex);
						elseif plotIsCoast then
							table.insert(coastal, plotIndex);
							table.insert(middle_coastal, plotIndex);
						else
							table.insert(inland_dry, plotIndex);
							table.insert(middle_inland_dry, plotIndex);
						end
					else
						if plot:IsRiver() then
							table.insert(river, plotIndex);
							table.insert(outer_river, plotIndex);
						elseif plotIsCoast then
							table.insert(coastal, plotIndex);
							table.insert(outer_coastal, plotIndex);
						else
							table.insert(inland_dry, plotIndex);
							table.insert(outer_inland_dry, plotIndex);
						end					
					end
				end
			end
		end
	end
	
	-- Process lists of candidate plots.
	local candidate_lists = {};
	
	if (self.divMethod == DIVMETHOD_NONE) then
		-- No regional division, so disable center bias.
		-- Player on river/coast > river > coast > player on dry > dry
		if #player_river > 0 then
			table.insert(candidate_lists, {plots = player_river, score = 0});
		end
		if #player_coastal > 0 then
			table.insert(candidate_lists, {plots = player_coastal, score = 0});
		end
		if #river > 0 then
			table.insert(candidate_lists, {plots = river, score = 0});
		end
		if #coastal > 0 then
			table.insert(candidate_lists, {plots = coastal, score = 0});
		end
		if #player_inland_dry > 0 then
			table.insert(candidate_lists, {plots = player_inland_dry, score = 0});
		end
		if #inland_dry > 0 then
			table.insert(candidate_lists, {plots = inland_dry, score = 0});
		end
	else
		-- Apply player center bias via candidate list ordering and base score.
        -- Base score allows center bias to influence comparison of fallback plots.
		-- player bias on river/coast trumps center bias
		if #player_river > 0 then
			table.insert(candidate_lists, {plots = player_river, score = 38});
		end
		if #player_coastal > 0 then
			table.insert(candidate_lists, {plots = player_coastal, score = 36});
		end
		if #center_river > 0 then
			table.insert(candidate_lists, {plots = center_river, score = 34});
		end
		if #middle_river > 0 then
			table.insert(candidate_lists, {plots = middle_river, score = 32});
		end
		if #outer_river > 0 then
			table.insert(candidate_lists, {plots = outer_river, score = 30});
		end
		if #center_coastal > 0 then 
			table.insert(candidate_lists, {plots = center_coastal, score = 28});
		end
		if #middle_coastal > 0 then
			table.insert(candidate_lists, {plots = middle_coastal, score = 26});
		end
		if #outer_coastal > 0 then
			table.insert(candidate_lists, {plots = outer_coastal, score = 24});
		end
		if #player_inland_dry > 0 then
			table.insert(candidate_lists, {plots = player_inland_dry, score = 22});
		end
		if #center_inland_dry > 0 then
			table.insert(candidate_lists, {plots = center_inland_dry, score = 20});
		end
		if #middle_inland_dry > 0 then
			table.insert(candidate_lists, {plots = middle_inland_dry, score = 10});
		end
	end
	--
	for loop, listInfo in ipairs(candidate_lists) do 
		-- Up to six plot lists, processed by priority.
        local plot_list = listInfo.plots;
		local election_returns = self:IterateThroughCandidatePlotList(
            plot_list, playerId, listInfo.score);
		-- If any candidates are eligible, choose one.
		local found_eligible = election_returns[1];
		if found_eligible then
			local bestPlotScore = election_returns[2]; 
			local bestPlotIndex = election_returns[3];
			local x = (bestPlotIndex - 1) % self.iW;
			local y = math.floor((bestPlotIndex - x - 1) / self.iW);
			return x, y, bestPlotScore, "OK", self.distanceMap[bestPlotIndex];
		end
		-- If none eligible, check for fallback plot.
		local found_fallback = election_returns[4];
		if found_fallback then
			local bestFallbackScore = election_returns[5];
			local bestFallbackIndex = election_returns[6];
			local bestFallbackReason = election_returns[7];
			local x = (bestFallbackIndex - 1) % self.iW;
			local y = math.floor((bestFallbackIndex - x - 1) / self.iW);
			table.insert(fallback_plots, {x, y, bestFallbackScore, bestFallbackReason});
		end
	end
	-- Reaching this point means no eligible sites 
	-- except center, middle, non-dry outer subregions!
	
	-- Process candidates from Outer Dry subregion, if any.
	if #outer_inland_dry > 0 then	
		local outer_eligible_list = {};
		local found_eligible = false;
		local found_fallback = false;
		local bestFallbackScore = -5000;
		local bestFallbackIndex = -1;
		local bestFallbackReason = "";
		local isBetter = false;
		local numTies = 0;
        local baseScore = -10; -- Center bias score penalty for outer plot.
		-- Process list of candidate plots.
		for loop, plotIndex in ipairs(outer_inland_dry) do
			local score, meets_minimums, fallbackReason =
				self:EvaluateCandidatePlot(plotIndex, playerId, baseScore);
			-- Test current plot against best known plot.
			if meets_minimums then
				found_eligible = true;
				table.insert(outer_eligible_list, plotIndex);
			else	
				isBetter, numTies = self:IsBetterPlot(score, bestFallbackScore, numTies);
				if ((not found_fallback) or isBetter) then
					found_fallback = true;
					bestFallbackScore = score;
					bestFallbackIndex = plotIndex;
					bestFallbackReason = fallbackReason;
				end
			end	
		end
		if found_eligible then 
			-- Iterate through eligible plots and choose the one 
			-- closest to the center of the region.
			local x, y, closestPlot = self:FindClosestPlot(
				outer_eligible_list, iWidth, iHeight, iWestX, iSouthY);
			-- Re-get plot score for inclusion in start plot data.
			local score = self:EvaluateCandidatePlot(closestPlot, playerId, baseScore);
            local plotIndex = y * self.iW + x + 1;
			return x, y, score, "OK", self.distanceMap[plotIndex];
		end
		-- Add the fallback plot (best scored plot) from the Outer region to the fallback list.
		if found_fallback then
			local x = (bestFallbackIndex - 1) % self.iW;
			local y = math.floor((bestFallbackIndex - x - 1) / self.iW);
			table.insert(fallback_plots, {x, y, bestFallbackScore, bestFallbackReason});
		end
	end
	-- Reaching here means no plot in the entire region met the minimum standards for selection.
	
	if (self.enableFallbacks) then
		-- Consider fallback plots.
		local gotFallback, fb_x, fb_y, fb_score, fb_desc = 
			self:FindFallbackStart(fallback_plots);
			
		if gotFallback then
			-- Found a fallback plot.
            local plotIndex = fb_y * self.iW + fb_x + 1;
			return fb_x, fb_y, fb_score, "Fallback - " .. fb_desc, self.distanceMap[plotIndex];
		end
	else
		local iNumFallbacks = table.maxn(fallback_plots);
		if (iNumFallbacks > 0) then
			-- Fallacks are disabled, so pretend that there were no fallbacks.
			print("Ignoring " .. iNumFallbacks .. " fallback plot(s) (fallbacks disabled)");
		end
	end
    
    if (self.enableForcedStarts) then
		-- This region cannot have a start and something has gone way wrong.
		-- Look for a passable (non-mountain, etc) tile to avoid breaking mountain pattern 
		-- reachability.
		return self:FindForcedStart(iWidth, iHeight, iWestX, iSouthY);
	end
	return nil;
end

function GotLakes_ASP:Water_FindStart(region_number, playerId)
	-- This function attempts to choose a start position for a single region.
	-- Args:
	--   region_number: which region in [1,numCivs]
	--   playerId: which player owns this region, 
	--     or nil if players have not been assigned to regions.
	-- Returns:
	--     x, y start coordinates
    --     start-quality score, 
	--     a brief description of the start's quality,
    --     and distance to the nearest civ (0 if distance is greater than ripple radius)
	
	-- Obtain data needed to process this region.	
	local region_data_table = self.regionData[region_number];
	local iWestX = region_data_table[1];
	local iSouthY = region_data_table[2];
	local iWidth = region_data_table[3];
	local iHeight = region_data_table[4];
	local iAreaID = region_data_table[5];
	--
	-- Done setting up region data.
	-- Set up contingency.
	local fallback_plots = {};
	
	print("Looking for water start between " .. CoordString(iWestX, iSouthY) .. 
		  " and " .. CoordString(iWestX+iWidth-1, iSouthY+iHeight-1) .. 
		  " with region size " .. CoordString(iWidth, iHeight));
	
	-- Establish scope of center bias.
	local fCenterWidth = (self.centerBias / 100) * iWidth;
	local iNonCenterWidth = math.floor((iWidth - fCenterWidth) / 2)
	local iCenterWidth = iWidth - (iNonCenterWidth * 2);
	-- Modulo math to synch coordinate to actual map in case of world wrap.
	local iCenterWestX = (iWestX + iNonCenterWidth) % self.iW;
	-- "Test" values ignore world wrap for easier membership testing.
	local iCenterTestWestX = (iWestX + iNonCenterWidth);
	local iCenterTestEastX = (iCenterWestX + iCenterWidth - 1);

	local fCenterHeight = (self.centerBias / 100) * iHeight;
	local iNonCenterHeight = math.floor((iHeight - fCenterHeight) / 2)
	local iCenterHeight = iHeight - (iNonCenterHeight * 2);
	local iCenterSouthY = (iSouthY + iNonCenterHeight) % self.iH;
	local iCenterTestSouthY = (iSouthY + iNonCenterHeight);
	local iCenterTestNorthY = (iCenterTestSouthY + iCenterHeight - 1);

	-- Establish scope of "middle donut", outside the center but inside the outer.
	local fMiddleWidth = (self.middleBias / 100) * iWidth;
	local iOuterWidth = math.floor((iWidth - fMiddleWidth) / 2)
	local iMiddleWidth = iWidth - (iOuterWidth * 2);
	local iMiddleWestX = (iWestX + iOuterWidth) % self.iW;
	local iMiddleTestWestX = (iWestX + iOuterWidth);
	local iMiddleTestEastX = (iMiddleTestWestX + iMiddleWidth - 1);

	local fMiddleHeight = (self.middleBias / 100) * iHeight;
	local iOuterHeight = math.floor((iHeight - fMiddleHeight) / 2)
	local iMiddleHeight = iHeight - (iOuterHeight * 2);
	local iMiddleSouthY = (iSouthY + iOuterHeight) % self.iH;
	local iMiddleTestSouthY = (iSouthY + iOuterHeight);
	local iMiddleTestNorthY = (iMiddleTestSouthY + iMiddleHeight - 1); 

	-- Assemble candidates lists.
	local iNumCandidates = 0;
	local center_ocean      = {};
	local center_coastal    = {};
	local center_lake       = {};
	local middle_ocean      = {};
	local middle_coastal    = {};
	local middle_lake       = {};
	local outer_plots       = {};
	
	-- Alternate candidate lists for when we don't need center bias.
	local ocean_plots = {};
	local coast_plots = {};
	local lake_plots  = {};
	
	if (not self.hasPassableSaltWater) then
		print("Ignoring Area ID (no passable salt water)");
		iAreaID = -1;
	end
	
	-- Identify candidate plots.
	for region_y = 0, iHeight - 1 do -- When handling global plot indices, process Y first.
		for region_x = 0, iWidth - 1 do
			-- Actual coords, adjusted for world wrap, if any.
			local x = (region_x + iWestX) % self.iW; 
			local y = (region_y + iSouthY) % self.iH; --
			local plotIndex = y * self.iW + x + 1;
			local plot = Map.GetPlot(x, y);
			local distToNearestCiv = self.distanceMap[plotIndex];
			
			if (plot:IsWater() and IsPassable(plot) and
			    (distToNearestCiv >= self.minDistBetweenCivs) and 
			    (not ((not self.enableLakeStarts) and plot:IsLake())) ) then 
				-- Could host a water start.
				-- Exclude lakes if enableLakeStarts is disabled.
				local area_of_plot = plot:GetArea():GetID();
				if area_of_plot == iAreaID or iAreaID == -1 then
					-- This plot is a member, so it goes on at least one candidate list.
					--
					-- Test whether plot is in center bias, middle donut, or outer donut.
					--
					-- "Test" coords, ignoring any world wrap and
					-- reaching in to virtual space if necessary.
					local test_x = region_x + iWestX; 
					local test_y = region_y + iSouthY;
					if (test_x >= iCenterTestWestX and test_x <= iCenterTestEastX) and 
					   (test_y >= iCenterTestSouthY and test_y <= iCenterTestNorthY) then
						-- Center Bias.
						iNumCandidates = iNumCandidates + 1;
						
						if plot:IsLake() then
							table.insert(center_lake, plotIndex);
							table.insert(lake_plots,  plotIndex);
						elseif IsOcean(plot) then
							table.insert(center_ocean, plotIndex);
							table.insert(ocean_plots,  plotIndex);
						else
							table.insert(center_coastal, plotIndex);
							table.insert(coast_plots,    plotIndex);
						end
					elseif (test_x >= iMiddleTestWestX and test_x <= iMiddleTestEastX) and 
						   (test_y >= iMiddleTestSouthY and test_y <= iMiddleTestNorthY) then
						iNumCandidates = iNumCandidates + 1;
						
						if plot:IsLake() then
							table.insert(middle_lake, plotIndex);
							table.insert(lake_plots,  plotIndex);
						elseif IsOcean(plot) then
							table.insert(middle_ocean, plotIndex);
							table.insert(ocean_plots,  plotIndex);
						else
							table.insert(middle_coastal, plotIndex);
							table.insert(coast_plots,    plotIndex);
						end
					else
						
						table.insert(outer_plots, plotIndex);
						
						if plot:IsLake() then
							iNumCandidates = iNumCandidates + 1;
							table.insert(lake_plots,  plotIndex);
						elseif IsOcean(plot) then
							iNumCandidates = iNumCandidates + 1;
							table.insert(ocean_plots, plotIndex);
						else
							iNumCandidates = iNumCandidates + 1;
							table.insert(coast_plots, plotIndex);
						end
					end
				end
			end
		end
	end

	-- Check how many plots landed on each list.
	local iNumCenterOcean = table.maxn(center_ocean);
	local iNumCenterCoast = table.maxn(center_coastal);
	local iNumCenterLake  = table.maxn(center_lake);
	local iNumMiddleOcean = table.maxn(middle_ocean);
	local iNumMiddleCoast = table.maxn(middle_coastal);
	local iNumMiddleLake  = table.maxn(middle_lake);
	local iNumOuter       = table.maxn(outer_plots);
	
	local iNumOcean       = table.maxn(ocean_plots);
	local iNumCoast       = table.maxn(coast_plots);
	local iNumLake        = table.maxn(lake_plots);
		
	-- Process lists of candidate plots.
	if iNumCandidates > 0 then
		local candidate_lists = {};
		
		if (self.iNumCivs > 1) then
			-- Got multiple water civs. Use center bias to space-out the civs.
			if iNumCenterOcean > 0 then -- Process center bias ocean plots.
				table.insert(candidate_lists, center_ocean);
			end
			if iNumMiddleOcean > 0 then -- Process middle donut ocean plots.
				table.insert(candidate_lists, middle_ocean);
			end
			if iNumCenterCoast > 0 then -- Process center bias coastal plots.
				table.insert(candidate_lists, center_coastal);
			end
			if iNumMiddleCoast > 0 then -- Process middle donut coastal plots.
				table.insert(candidate_lists, middle_coastal);
			end
			if iNumCenterLake > 0 then -- Process center bias lake plots.
				table.insert(candidate_lists, center_lake);
			end
			if iNumMiddleLake > 0 then -- Process middle donut lake plots.
				table.insert(candidate_lists, middle_lake);
			end
		else
			-- Got only one water civ, so we don't need center bias.
			print("Ignoring center-bias (only 1 water civ)");
			if iNumOcean > 0 then -- Process ocean plots.
				table.insert(candidate_lists, ocean_plots);
			end
			if iNumCoast > 0 then -- Process coastal plots.
				table.insert(candidate_lists, coast_plots);
			end
			if iNumLake > 0 then -- Process fresh lake plots.
				table.insert(candidate_lists, lake_plots);
			end
		end
		--
		for loop, plot_list in ipairs(candidate_lists) do 
			-- Up to four plot lists, processed by priority.
			local election_returns = self:IterateThroughCandidatePlotList(plot_list, playerId);
			-- If any candidates are eligible, choose one.
			local found_eligible = election_returns[1];
			if found_eligible then
				local bestPlotScore = election_returns[2]; 
				local bestPlotIndex = election_returns[3];
				local x = (bestPlotIndex - 1) % self.iW;
				local y = math.floor((bestPlotIndex - x - 1) / self.iW);
				return x, y, bestPlotScore, "OK", self.distanceMap[bestPlotIndex];
			end
			-- If none eligible, check for fallback plot.
			local found_fallback = election_returns[4];
			if found_fallback then
				local bestFallbackScore = election_returns[5];
				local bestFallbackIndex = election_returns[6];
				local bestFallbackReason = election_returns[7];
				local x = (bestFallbackIndex - 1) % self.iW;
				local y = math.floor((bestFallbackIndex - x - 1) / self.iW);
				table.insert(fallback_plots, {x, y, bestFallbackScore, bestFallbackReason});
			end
		end
	end
	-- Reaching this point means no eligible sites in center bias or middle donut subregions!
	
	-- Process candidates from Outer subregion, if any.
	if iNumOuter > 0 then	
		local outer_eligible_list = {};
		local found_eligible = false;
		local found_fallback = false;
		local bestFallbackScore = -5000;
		local bestFallbackIndex = -1;
		local bestFallbackReason = "";
		local isBetter = false;
		local numTies = 0;
		-- Process list of candidate plots.
		for loop, plotIndex in ipairs(outer_plots) do
			local score, meets_minimums, fallbackReason =
				self:EvaluateCandidatePlot(plotIndex, playerId);
			-- Test current plot against best known plot.
			if meets_minimums then
				found_eligible = true;
				table.insert(outer_eligible_list, plotIndex);
			else	
				isBetter, numTies = self:IsBetterPlot(score, bestFallbackScore, numTies);
				if ((not found_fallback) or isBetter) then
					found_fallback = true;
					bestFallbackScore = score;
					bestFallbackIndex = plotIndex;
					bestFallbackReason = fallbackReason;
				end
			end		
		end
		if found_eligible then 
			-- Iterate through eligible plots and choose the one 
			-- closest to the center of the region.
			local x, y, closestPlot = self:FindClosestPlot(
				outer_eligible_list, iWidth, iHeight, iWestX, iSouthY);
			-- Re-get plot score for inclusion in start plot data.
			local score = self:EvaluateCandidatePlot(closestPlot, playerId);
            local plotIndex = y * self.iW + x + 1;
			-- Assign this plot as the start for this region.
			return x, y, score, "OK", self.distanceMap[plotIndex];
		end
		-- Add the fallback plot (best scored plot) from the Outer region to the fallback list.
		if found_fallback then
			local x = (bestFallbackIndex - 1) % self.iW;
			local y = math.floor((bestFallbackIndex - x - 1) / self.iW);
			table.insert(fallback_plots, {x, y, bestFallbackScore, bestFallbackReason});
		end
	end
	-- Reaching here means no plot in the entire region met the minimum standards for selection.
	
	if (self.enableFallbacks) then
		-- Consider fallback plots.
		local gotFallback, fb_x, fb_y, fb_score, fb_desc = 
			self:FindFallbackStart(fallback_plots);
			
		if gotFallback then
			-- Found a fallback plot.
            local plotIndex = fb_y * self.iW + fb_x + 1;
			return fb_x, fb_y, fb_score, "Fallback - " .. fb_desc, self.distanceMap[plotIndex];
		end
	else
		local iNumFallbacks = table.maxn(fallback_plots);
		if (iNumFallbacks > 0) then
			-- Fallacks are disabled, so pretend that there were no fallbacks.
			print("Ignoring " .. iNumFallbacks .. " fallback plot(s) (fallbacks disabled)");
		end
	end

	if (self.enableForcedStarts) then
		-- This region cannot have a start and something has gone way wrong.
		-- Look for a passable (non-ice, etc) tile to avoid breaking mountain pattern 
		-- reachability.
		local plotX, plotY = self:FindForcedStart(iWidth, iHeight, iWestX, iSouthY);
		return self:FindForcedStart(iWidth, iHeight, iWestX, iSouthY);
	end
	return nil;
end

function GotLakes_ASP:ChooseLocations(startMinY, startMaxY)
	-- Determine a starting position for each civ.
	-- Args:
	--   startMinY: minimum Y for start plots as a percentage of map height
	--   startMaxY: maximum Y for start plots as a percentage of map height
	-- Returns:
	--   startingPlots: {x,y,fert:int,quality:string} starting info for at most the
	--     the number of civs; guaranteed to be the number of civs if forced-starts
	--     is enabled.
	--   distanceMaps: maps of plots indicating distances to obstacles such as
	--     nearby civs
	local regionAssignList = self:GenerateRegions(startMinY, startMaxY);
	local iNumRegions = #regionAssignList;
	
	if (iNumRegions < self.iNumCivs) then
		print("Not enough start regions!");
		return self.startingPlots, self.distanceMap;
	end
	
	local civStr = "civilizations";
	if self.isMinor then
		civStr = "city states";
	end
	if self.startOnWater then
		civStr = "water " .. civStr;
	end
	print("Got Lakes ASP: Choosing start locations for " .. civStr);
	
	if self.enableCustomStartBias then
		-- For custom start bias, assign players to regions before choosing locations.
		local startBiasSolver = GotLakes_StartBiasSolver.Create(
			self.startBiasAnalyzer,
			self.regionData,
			regionAssignList,
			self.divMethod,
			self.isMinor,
			self.startOnWater,
			self.startBiasLogLevel);
		regionAssignList = startBiasSolver:AssignPlayersToRegions();
	end
		
	if (not self.startOnWater) then		
		-- Get the size in tiles of the biggest chunk of land.
		-- Remember this size when checking for tiny islands.
		local biggestAreaNumTiles = 
			self:GetBiggestPassableLandArea(self.minX, self.minY, self.maxX, self.maxY);
		print("Biggest land chunk has " .. biggestAreaNumTiles .. " tile(s).");
		
		local minLandSizeMultiplier = self.minReachableLandRatio;
		
		if (UserInput.Mountains == MtnPatterns.WINDING) then
			print("Reverting to default starting land-size threshold (winding canyons)");
			minLandSizeMultiplier = 0.25;
		end
		
		-- Minimum number of land tiles immediately reachable from the candidate plot.
		-- Any less than this and the candidate becomes a fallback
		-- to avoid starting on tiny islands, mountain-blocked peninsulas, etc.
		self.minLandSize = math.clamp(Round(biggestAreaNumTiles * minLandSizeMultiplier), 1, 100);
		
		if self.isMinor then
			-- Relax land-size checking for minor civs.
			self.minLandSize = math.clamp(Round(self.minLandSize/self.iNumCivs), 1, 7);
			
		elseif (self.divMethod == DIVMETHOD_SEPARATE) then
			-- Relax land-size checking for separate starts.
			self.minLandSize = math.max(1,Round(self.minLandSize/self.iNumCivs));
		end
		
		print("Looking for land chunks that have at least " .. self.minLandSize .. " tile(s).");
	end

	-- main loop
	for assignIndex = 1, math.min(self.iNumCivs,iNumRegions) do
		local currentRegionNumber = regionAssignList[assignIndex].regionId;
		
		-- Player ID only exists if custom start bias is enabled.
		local playerId = regionAssignList[assignIndex].playerId;
		
		-- Filter by area ID since we assigned each civ a continent or part of a continent.
        local regionNum = currentRegionNumber;
		local x, y, fert, desc, distToNCiv = self:FindStart(currentRegionNumber, playerId);
		
		if ((not x) and (self.enableForcedStarts)) then
			-- This region cannot have a start and something has gone way wrong.
			-- Scan the whole search space as a last resort.
			print("Unable to find a start plot in region #" .. currentRegionNumber);
			local iWidth  = self.maxX - self.minX + 1;
			local iHeight = self.maxY - self.minY + 1;
            regionNum     = 0;
			x, y, fert, desc, distToNCiv = 
                self:FindForcedStart(iWidth, iHeight, self.minX, self.minY);
		end
			
        local startInfo = {};
		if x then
			-- Got a start position.
            startInfo.x = x;
            startInfo.y = y;
            startInfo.fert = fert;
            startInfo.desc = desc;
            startInfo.regionNum = regionNum;
            startInfo.distToNCiv = distToNCiv;
            startInfo.playerId = playerId;
            
            -- Distance bias for debugging.
            local plotIndex = y * self.iW + x + 1;
            startInfo.distBias = self.distBiasMap[plotIndex];
            
			self:PlaceImpactAndRipples(x,y);
			table.insert(self.startingPlots, startInfo);
		else
			print("Start #" .. assignIndex .. " failed.");
		end
	end
	
	for loop, startInfo in ipairs(self.startingPlots) do
		local x           = startInfo.x;
		local y           = startInfo.y;
		local fertility   = startInfo.fert;
		local description = startInfo.desc;	
		local regionNum   = startInfo.regionNum;
        local distToNCiv  = startInfo.distToNCiv;
		local playerId    = startInfo.playerId;
        local distBias    = startInfo.distBias;
		
		local playerStr = "";
		if playerId then
			playerStr = " for player #" .. playerId;
		end
        
        -- Add manual coord padding for better alignment.
        local xyStr = CoordString(x, y);
        if x < 100 then
            xyStr = xyStr .. " ";
        end
        if y < 100 then
            xyStr = xyStr .. " ";
        end
        if x < 10 then
            xyStr = xyStr .. " ";
        end
        if y < 10 then
            xyStr = xyStr .. " ";
        end
        
        local distToNCivStr = "";
        if (distToNCiv < self.numTiles) and (distBias > 0) then
            distToNCivStr = " (" .. distToNCiv .. " plot(s) to nearest civ," .. 
            " distance bias " .. tostring(distBias) .. ")";
        elseif (distToNCiv < self.numTiles) then
            distToNCivStr = " (" .. distToNCiv .. " plot(s) to nearest civ)";
        end
	
		print("Start #" .. loop .. playerStr ..
		      " is in region #" .. regionNum .. " at ", xyStr ..
			  " with Fertility", fertility, description, distToNCivStr);
	end
		
	return self.startingPlots, self:GetDistanceMaps();
end
--------------------------------------------------------------------------------------------------
-- Utilities that run ASP
--------------------------------------------------------------------------------------------------
function AttemptCustomASP(args,	minY, maxY)
	-- Run a single instance of the custom start positioner.
	-- Args:
	--   args: args for the start positioner (see GotLakes_ASP constructor).
	--   minY (optional): min Y index for starts as a percentage of map height; default 0
	--   maxY (optional): max Y index for starts as a percentage of map height; default 100
	-- Returns:
	--   startPlots: a list of up to args.numCivs number of start locations {x,y}
	--   distanceMaps: a plot map indicating proximity to nearby civs
    local minY = minY or 0;
    local maxY = maxY or 100;
	local asp = GotLakes_ASP.Create(args);
	return asp:ChooseLocations(minY, maxY);
end

function RunCustomASP(args, minY, maxY)
	-- Run instances of the custom start positioner until we either succeed 
    -- or we fail with the most relaxed constraints.
    --
	-- Args:
	--   args: args for the start positioner (see GotLakes_ASP constructor).
	--   minY: min Y index for starts as a percentage of map height
	--   maxY: max Y index for starts as a percentage of map height
	-- Returns:
	--   startPlots: a list of up to numCivs number of start locations {x,y}
	--   distanceMaps: a plot map indicating proximity to nearby civs
    local args = args or {};
    
	local startPlots, distanceMaps = AttemptCustomASP(args, minY, maxY);
	
	if (#startPlots == args.numCivs) then
		-- Success on the first try.
		print("1st attempt successful!");
		return startPlots, distanceMaps;
	end
	-- Initial attempt failed.
	
	print("Reverting to default start placement.");
	local divMethodFallback = DIVMETHOD_STANDARD;
	if args.isMinor then
		divMethodFallback = DIVMETHOD_NONE;
	end
    args.divMethod = divMethodFallback; -- Now with less restrictive starts.
    
    args.enableFallbacks = ASP_ENABLE_FALLBACKS; -- Now with fallbacks enabled.
    
    -- Now with forced starts as a last resort (minor starts only).
    args.enableForcedStarts = args.isMinor;
	
	startPlots, distanceMaps = AttemptCustomASP(args); -- Ignore y-coord restrictions
    
    if (args.isMinor or args.startOnWater or (#startPlots == args.numCivs)) then
        if (#startPlots == args.numCivs) then
            -- Success on the second try.
            if (args.isMinor or args.startOnWater) then
                print("2nd and final attempt successful, thank goodness!");
            else
                print("2nd attempt successful!");
            end
        end
        -- Else this was the final attempt for minor civs or water civs.
		return startPlots, distanceMaps;
	end
    -- 2nd attempt failed.
    
    print("Relaxing constraints completely.");
    -- Disable/minimize all constraints on start placement.
    args.divMethod          = DIVMETHOD_NONE;
    args.enableForcedStarts = ASP_ENABLE_FORCED_STARTS;
    
    startPlots, distanceMaps = AttemptCustomASP(args);
    
    if (#startPlots == args.numCivs) then
        -- Yay, we avoided a crash by finding a start for each civ.
        print("3rd and final attempt successful, thank goodness!");
    end
    
    return startPlots, distanceMaps;
end
