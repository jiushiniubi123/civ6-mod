-- Coastal Lowlands for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_PassMaker"
include "GotLakes_Utils"

-- Some of this is based on Nere's Inland Flooding mod.
GotLakes_LowlandsGenerator = {};

-- Possible values for an elevation map.
local ELEVATION_WATER      = -1;
-- Elevations 0, 1, and 2 represent tiles marked for coastal flooding.
local ELEVATION_PASSABLE   = 3; -- floodable land and passable natural wonders.
local ELEVATION_IMPASSABLE = 4; -- Impassable land.

function GotLakes_LowlandsGenerator.Create()
	-- Coastal Lowlands constructor.
	local iW, iH, numTiles = GetMapGridSize();
	
    local lowlandsPct = GlobalParameters.CLIMATE_CHANGE_PERCENT_COASTAL_LOWLANDS or 35;
    lowlands = math.clamp(lowlandsPct, 0, 100);
    
	local coastLows  = UserInput.coastLows or CoastalLowlands.STANDARD;
	
	-- create instance data
	local instance = 
	{
		-- Methods
		IsFloodableCoast          = GotLakes_LowlandsGenerator.IsFloodableCoast,
		IsFloodableInland         = GotLakes_LowlandsGenerator.IsFloodableInland,
		IsFloodableFlat           = GotLakes_LowlandsGenerator.IsFloodableFlat,
		IsFloodable               = GotLakes_LowlandsGenerator.IsFloodable,
        InitMap                   = GotLakes_LowlandsGenerator.InitMap,
        InitReachPlot             = GotLakes_LowlandsGenerator.InitReachPlot,
        RemoveObstacle            = GotLakes_LowlandsGenerator.RemoveObstacle,
		CountAdjacentWaterAndLake = GotLakes_LowlandsGenerator.CountAdjacentWaterAndLake,
		Default_ScorePlot         = GotLakes_LowlandsGenerator.Default_ScorePlot,
		Inland_ScorePlot          = GotLakes_LowlandsGenerator.Inland_ScorePlot,
		Flat_ScorePlot            = GotLakes_LowlandsGenerator.Flat_ScorePlot,
		Floodable_ScorePlot       = GotLakes_LowlandsGenerator.Floodable_ScorePlot,
		ScorePlots                = GotLakes_LowlandsGenerator.ScorePlots,
        ScoreFloodableCoast       = GotLakes_LowlandsGenerator.ScoreFloodableCoast,
		ScoreFloodableInland      = GotLakes_LowlandsGenerator.ScoreFloodableInland,
		ScoreFloodableFlat        = GotLakes_LowlandsGenerator.ScoreFloodableFlat,
		ScoreFloodable            = GotLakes_LowlandsGenerator.ScoreFloodable,
		Default_MarkLowlands      = GotLakes_LowlandsGenerator.Default_MarkLowlands,
		Deluge_MarkLowlands       = GotLakes_LowlandsGenerator.Deluge_MarkLowlands,
		HFTH_MarkLowlands         = GotLakes_LowlandsGenerator.HFTH_MarkLowlands,
		Everywhere_MarkLowlands   = GotLakes_LowlandsGenerator.Everywhere_MarkLowlands,
		MarkLowlands              = GotLakes_LowlandsGenerator.MarkLowlands,
		
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles,       
        
        -- Config
        lowlandsPct = lowlandsPct,
        
        -- User inputs
        coastLows             = coastLows,
        gotFreshLakesLandmass = gotLakesFamily and UserInput.freshLakes,
        
        -- State
        tilesMarkedByPassMaker = 0,
	};
	
	return instance;
end

function GotLakes_LowlandsGenerator:IsFloodableCoast(plot)
	return (plot and plot:IsCoastalLand() and
            (not plot:IsHills()) and 
            (not plot:IsMountain()) and
		    (not plot:IsNaturalWonder()));
end

function GotLakes_LowlandsGenerator:IsFloodableInland(plot)
    -- Matches valid lowland for Nere's inland flooding mod.
	return (plot and (plot:IsCoastalLand() or 
                      IsMarshOrSwamp(plot:GetFeatureType()) or 
                      plot:IsRiver()) and
            (not plot:IsHills()) and
			(not plot:IsMountain()) and
		    (not plot:IsNaturalWonder()) and
			(not plot:IsWater()));
end

function GotLakes_LowlandsGenerator:IsFloodableFlat(plot)
    -- Whether the plot is flat land and floodable.
	return (IsPassableLand(plot) and 
            (not plot:IsHills()) and 
            (not plot:IsNaturalWonder()));
end

function GotLakes_LowlandsGenerator:IsFloodable(plot)
    -- Whether the plot is technically floodable.
	return (IsPassableLand(plot) and (not plot:IsNaturalWonder()));
end

function GotLakes_LowlandsGenerator:InitMap()
    -- Inititalize internal map of lowlands for running PassMaker.
    self.elevationMap = table.fill(ELEVATION_IMPASSABLE, self.numTiles);
    
    for i = 1, self.numTiles do
        local plot = Map.GetPlotByIndex(i-1);
        
        if plot:IsWater() then
            self.elevationMap[i] = ELEVATION_WATER;
            
        elseif IsPassable(plot) then
            -- Count all passable tiles as floodable
            -- so that PassMaker can traverse passable NWs to reach 
            -- otherwise-isolaed pockets of land.
            self.elevationMap[i] = ELEVATION_PASSABLE;
        end
	end
end

function GotLakes_LowlandsGenerator:InitReachPlot(x, y, elevation)
    -- Helper function for PassMaker hook.
    -- Wrap this with a function that specifies elevation before injecting into PM.
    local i = GetPlotIndexLua(x,y);
    local elevationAtPlot = self.elevationMap[i];
    
    if (elevationAtPlot == ELEVATION_IMPASSABLE) then
        return REACH_NONREMOVABLE;
    
    elseif (elevationAtPlot == ELEVATION_PASSABLE) then
        return REACH_REMOVABLE;
        
    elseif (elevationAtPlot < elevation) then   
        -- Treat water and lower elevations as already reached
        -- to avoid connecting bodies of water with lowlands.
        return REACH_YES;
    end
    return REACH_NO; -- Not yet reached.
end

function GotLakes_LowlandsGenerator:RemoveObstacle(x, y, plotsModded, elevation)
    -- Helper function for PassMaker hook.
    -- Wrap this with a function that specifies elevation before injecting into PM.
    -- Remove any obstacle at (x,y), which is expected to have an obstacle.
    -- Push any affected plots to plotsModded.
    local i = GetPlotIndexLua(x,y);
    local elevationAtPlot = self.elevationMap[i]; 
    if (elevationAtPlot < elevation) then
        -- No obstacles to remove here.
        print("Elevation is already " .. elevationAtPlot .. " at " .. CoordString(x,y));
        return;
    end
    
    local plot = Map.GetPlotByIndex(i-1);
    if plot:IsNaturalWonder() then
        -- Don't actually mark the natural wonder as lowlands, but add it to the path.
        print("Passing through natural wonder at " .. CoordString(x,y));
        plotsModded:Push({x=x, y=y});
        return;
    end
    
    print("Setting elevation to " .. elevation .. " at " .. CoordString(x,y));
    
    -- Turn highland into lowland.
    self.elevationMap[i] = elevation;
    TerrainBuilder.AddCoastalLowland(i-1, elevation);
    
    self.tilesMarkedByPassMaker = self.tilesMarkedByPassMaker + 1;
    plotsModded:Push({x=x, y=y});
end

function GotLakes_LowlandsGenerator:CountAdjacentWaterAndLake(x, y)
	local iWaterCount = 0;
	local iLakeCount = 0;
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
        if (adjacentPlot ~= nil) then
            if adjacentPlot:IsWater() then
                iWaterCount = iWaterCount + 1;
            end
            if adjacentPlot:IsLake() then
                iLakeCount = iLakeCount + 1;
            end
        end
	end
	return iWaterCount, iLakeCount;
end

function GotLakes_LowlandsGenerator:Default_ScorePlot(plot)   
    local iScore = 0;
    local x = plot:GetX();
    local y = plot:GetY();
    local featureType = plot:GetFeatureType();

    -- An adjacent volcano or lake is bad news
    if (CountAdjacentVolcanoes(x, y) > 0) then
        return 0;

    elseif (CountAdjacentLakes(x, y) > 0) then
        return 0;

    -- Marsh and swamp are top-priority
    elseif IsMarshOrSwamp(featureType) then
        return 1000;

    -- Floodplains are already dangerous, don't include them here
    elseif IsFloodplains(featureType) then
        return 0;
    end
    
    -- All other tiles are chosen based on the weightings in this section:
    -- Start with a mid-range base Score
    iScore = 500;

    -- Tiles near a River are prioritized heavily (to balance with the up-to-six 
    -- occurrences of the factors below)
    if (plot:IsRiver()) then
        iScore = iScore + 200;
    end

    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
        if (adjacentPlot ~= nil) then
            
            local adjFeatureType = adjacentPlot:GetFeatureType();

            -- Tiles near Marsh, Swamp, or Floodplain are prioritized
            if (IsMarshOrSwamp(adjFeatureType) or IsFloodplains(adjFeatureType)) then
                iScore = iScore + 50;
            end

            -- Tiles near Hills or Mountains are deprioritized
            if (adjacentPlot:IsHills() or adjacentPlot:IsMountain()) then
                iScore = iScore - 50;
            end

            -- Tiles with more adjacent Coast tiles are prioritized
            if (adjacentPlot:IsWater()) then
                -- If a Natural Wonder (Dead Sea?) don't allow it
                if (adjacentPlot:IsNaturalWonder()) then
                    iScore = 0;
                    break;
                else
                    iScore = iScore + 50;
                end
            end
        end
    end
    return iScore;
end

function GotLakes_LowlandsGenerator:Inland_ScorePlot(plot, allowFloodable)   
 	-- Based on Nere's Inland Flooding mod.
    if not (allowFloodable or self:IsFloodableInland(plot)) then
        return 0;
    end
    
    local iScore = 0;
    local x = plot:GetX();
    local y = plot:GetY();
    local featureType = plot:GetFeatureType();
    local numAdjWater, numAdjLakes = self:CountAdjacentWaterAndLake(x, y);
    local iScore = 0;

    -- seems like 0 is not enough, so changed to -200
    if (CountAdjacentVolcanoes(x, y) > 0) then
        return -200;
    end
    
    -- All tiles are chosen based on the weightings in this section:
    -- Start with a base Score					
    -- Coast is very high priority
    if plot:IsCoastalLand() then
        iScore = 255;
    elseif IsMarshOrSwamp(featureType) then
        iScore = 145;
    else			
        iScore = 5;
    end
    
    -- Lakes gets a boost from coastal + adj water, so this is reduced so that lakes
    -- don't flood at stage 1. Additional check to stop tiles between lakes and coast
    -- from NOT flooding.
    if ((numAdjLakes > 2) and (numAdjLakes == numAdjWater)) then
        iScore = 10;
    -- Small lakes gets a boost from coastal + adj water, so this is pre-substracted
    -- here. Additional check to stop tiles between lakes and coast from NOT flooding.
    elseif ((numAdjLakes <= 2) and 
            (numAdjLakes > 0) and 
            (numAdjLakes == numAdjWater)) then
        -- Tiles next to lakes is considered "coastal" and as thus is valid for 
        -- flooding under the current algorithm. To reduce lake flooding, this could 
        -- be put further into the negative.
        iScore = -210;  
    end
    
    -- Tiles with a River are prioritized heavily (to balance with the up-to-six 
    -- occurrences of the factors below)
    if plot:IsRiver() then
        iScore = iScore + 75;
    end

    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
        if (adjacentPlot ~= nil) then
            
            local adjFeatureType = adjacentPlot:GetFeatureType();

            -- Tiles near Marsh are highly prioritized
            if IsMarshOrSwamp(featureType) then
                iScore = iScore + 100;
            end
            -- Tiles near Floodplains are highly prioritized
            if IsFloodplains(adjFeatureType) then
                iScore = iScore + 30;
            end

            -- Tiles near Hills or Mountains are deprioritized
            if adjacentPlot:IsMountain() then
                iScore = iScore - 75;
            elseif adjacentPlot:IsHills() then
                iScore = iScore - 50;
            end
            
            -- Adjacent plots with rivers give a small boost (only small since river 
            -- are very "snakey" and we don't want inland lakes to flood at level 1).
            if (adjacentPlot:IsRiver()) then
                iScore = iScore + 15;
            end
            
            -- Adjacent coastal plots receive a large boost to make the first parts 
            -- of a coastal river flood at stage 2
            if (adjacentPlot:IsCoastalLand() == true) then
                iScore = iScore + 85; -- Maybe less?
            end
            
            -- Tiles with more adjacent Coast tiles are prioritized
            if (adjacentPlot:IsWater()) then
                iScore = iScore + 30; 
            end
        end
    end
    return iScore;
end

function GotLakes_LowlandsGenerator:Flat_ScorePlot(plot)
    if not self:IsFloodableFlat(plot) then
        return 0;
    end
    
    local score = 0;
    if self:IsFloodableInland(plot) then
        -- Prioritize floodable inland over other flat tiles.
        score = score + 10000;
    end
    
    -- Use the same scoring rules for all valid plots.
    return score + self:Inland_ScorePlot(plot, true);
end

function GotLakes_LowlandsGenerator:Floodable_ScorePlot(plot)   
    if not self:IsFloodable(plot) then
        return 0;
    end
    
    local score = 0;
    if self:IsFloodableFlat(plot) then
        -- Prioritize flats over other floodable tiles.
        score = score + 10000;
    end
    if self:IsFloodableInland(plot) then
        -- Prioritize floodable inland over other flat tiles.
        score = score + 10000;
    end
    
    -- Use the same scoring rules for all valid plots.
    return score + self:Inland_ScorePlot(plot, true);
end

function GotLakes_LowlandsGenerator:ScorePlots(isValidFcn, scoreFcn, keepLosers)
	local aaScoredTiles = {};
    local minScore = math.huge;
    local maxScore = -100000;
    --print("Scoring plots");
	for i = 0, self.numTiles - 1 do
        local plot = Map.GetPlotByIndex(i);
        if isValidFcn(self,plot) then
            local iScore = scoreFcn(self,plot);
            if keepLosers or (iScore > 0) then
                table.insert(aaScoredTiles, {MapIndex=i, Score=iScore});
                minScore = math.min(minScore, iScore);
                maxScore = math.max(maxScore, iScore);
            else
                --print("Plot " .. CoordString(plot:GetX(),plot:GetY()) .. " score is " .. iScore);
            end
        else
            --print("Plot " .. CoordString(plot:GetX(),plot:GetY()) .. " is invalid for flooding");
        end
	end
    if (#aaScoredTiles == 0) then
        -- No scored tiles. Zero-out min/max.
        minScore = 0;
        maxScore = 0;
    end
	return aaScoredTiles, minScore, maxScore;
end

function GotLakes_LowlandsGenerator:ScoreFloodableCoast()
    return self:ScorePlots(self.IsFloodableCoast, self.Default_ScorePlot);
end

function GotLakes_LowlandsGenerator:ScoreFloodableInland()
    return self:ScorePlots(self.IsFloodableInland, self.Inland_ScorePlot);
end

function GotLakes_LowlandsGenerator:ScoreFloodableFlat()
    return self:ScorePlots(self.IsFloodableFlat, self.Flat_ScorePlot);
end

function GotLakes_LowlandsGenerator:ScoreFloodable(keepLosers)
    return self:ScorePlots(self.IsFloodable, self.Floodable_ScorePlot, keepLosers);
end

function GotLakes_LowlandsGenerator:Default_MarkLowlands(scoredTiles, lowlandsPct)
    -- Simple base-game / Nerevatar approach to marking lowlands.
    local tilesToMark = math.floor((#scoredTiles * lowlandsPct) / 100);
    
    if (tilesToMark <= 0) then
        print("No tiles to mark, so no-op.");
        return;
    end
    
    table.sort(scoredTiles, CompareScoredPlots); -- Hardened against desync.
    
    for tileIdx = 1, tilesToMark do
        local iElevation = 2;
        if (tileIdx <= tilesToMark / 4) then
            -- 25% highest scoring tiles get flooded first 
            -- Based on Nerevatar's Inland Flooding.
            iElevation = 0;
        elseif (tileIdx <= (tilesToMark * 5) / 8) then
            -- The next 37.5% highest scoring tiles get flooded second 
            iElevation = 1;
        end -- Else the remaining 37.5% tiles get flooded last 
        
        TerrainBuilder.AddCoastalLowland(scoredTiles[tileIdx].MapIndex, iElevation);
    end
    
    print("Floodable tiles: " ..
          tostring(tilesToMark) .. "/" .. tostring(#scoredTiles) ..
          " (" .. lowlandsPct .. " pct)");
end

function GotLakes_LowlandsGenerator:Deluge_MarkLowlands(scoredTiles, lowlandsPct)
    -- Use PassMaker to connect inland floodables to bodies of water.
    -- Continue to use standard thresholds for increasing elevation.
    local tilesToMark = math.floor((#scoredTiles * lowlandsPct) / 100);
        
    if (tilesToMark <= 0) then
        print("No tiles to mark, so no-op.");
        return;
    end
        
    -- Initialize a map so that we can run passmaker to connect isolated clumps of lowlands.
    self:InitMap();
    
    table.sort(scoredTiles, CompareScoredPlots); -- Hardened against desync.
    
    local passmakerArgs = { obstaclesName = "highlands" };  
    local prevElevation = 0;
    local tilesMarkedFromScoring = 0;
    
    for tileIdx = 1, tilesToMark do
        local iElevation = 2;
        if (tileIdx <= tilesToMark / 4) then
            -- 25% highest scoring tiles get flooded first 
            -- Based on Nerevatar's Inland Flooding.
            iElevation = 0;
        elseif (tileIdx <= (tilesToMark * 5) / 8) then
            -- The next 37.5% highest scoring tiles get flooded second 
            iElevation = 1;
        end -- Else the remaining 37.5% tiles get flooded last 
        
        local updateMap = true;
        local tileMapIndex = scoredTiles[tileIdx].MapIndex;
        if (prevElevation ~= iElevation) then
            -- Elevation has increased.
            -- Run PassMaker to connect isolated pockets of lowlands with random
            -- paths of water/lowlands before lowering elevation.
            passmakerArgs.InitReachPlot = function(pm, x, y)
                    return self:InitReachPlot(x, y, prevElevation);
                end;
            
            passmakerArgs.RemoveObstacle = function(pm, x,y, plotsModded) 
                    self:RemoveObstacle(x, y, plotsModded, prevElevation);
                end;
            EnsureReachabilityWithPassMaker(passmakerArgs);
        
            prevElevation = iElevation;                
        end
        
        if (self.elevationMap[tileMapIndex+1] == ELEVATION_PASSABLE) then      
            TerrainBuilder.AddCoastalLowland(tileMapIndex, iElevation);
            
            -- Update the internal map to match the new value for the global map.
            self.elevationMap[tileMapIndex+1] = iElevation;
            
            tilesMarkedFromScoring = tilesMarkedFromScoring + 1;
        end -- Else the tile was already marked by PassMaker
        
        if (tileIdx == tilesToMark) then
            -- One last PassMaker run after the marking the final tile.
            -- Run PassMaker to connect isolated pockets of lowlands with random
            -- paths of water/lowlands before lowering elevation.
            passmakerArgs.InitReachPlot = function(pm, x, y)
                    return self:InitReachPlot(x, y, iElevation);
                end;
            
            passmakerArgs.RemoveObstacle = function(pm, x,y, plotsModded) 
                    self:RemoveObstacle(x, y, plotsModded, iElevation);
                end;
            EnsureReachabilityWithPassMaker(passmakerArgs);
        end
    end
    
    print("Floodable tiles from scoring: " ..
          tostring(tilesMarkedFromScoring) .. "/" .. tostring(#scoredTiles) ..
          " (" .. lowlandsPct .. " pct)");
    
    print("Floodable tiles from random paths: " .. tostring(self.tilesMarkedByPassMaker));
end

function GotLakes_LowlandsGenerator:HFTH_MarkLowlands()
    -- Mark all tiles before the first hill at stages 0 and 1.
    -- Modify lowlands percentage to control only the number of 
    -- remaining tiles flooded in stage 2.
    
    -- Get a score for every floodable tile, including losers.
    local scoredTiles = self:ScoreFloodable(true);
    
    if #scoredTiles <= 0 then
        -- Somehow there are no floodable tiles.
        print("No floodable tiles, so no-op.");
        return;
    end
    
    table.sort(scoredTiles, CompareScoredPlots); -- Hardened against desync.
    
    -- Use the index of the first hill to derive thresholds for elevation changes
    -- and the number of tiles to mark.
    local elevation2Index = math.floor((#scoredTiles)*2/3);
    for tileIdx = 1, #scoredTiles do
        local tileMapIndex = scoredTiles[tileIdx].MapIndex;
        local plot = Map.GetPlotByIndex(tileMapIndex);
        if plot:IsHills() then
            elevation2Index = tileIdx;
            break;
        end
    end
    
    -- Elevation 1: halfway to the first hill.
    local elevation1Index = math.floor(elevation2Index/2);
    
    -- Tiles to mark: All tiles up to the first hill + 45% of remaining tiles.
    local tilesToMark = elevation2Index + 
        math.floor(((#scoredTiles - elevation2Index) * self.lowlandsPct) / 100);

    -- Initialize a map so that we can run passmaker to connect isolated clumps of lowlands.
    self:InitMap();
    
    
    local passmakerArgs = { obstaclesName = "highlands" };  
    local prevElevation = 0;
    local tilesMarkedFromScoring = 0;
    
    for tileIdx = 1, tilesToMark do
        local iElevation = 2;
        if (tileIdx < elevation1Index) then
            -- Flood the first 50% of tiles before the first hill
            iElevation = 0;
        elseif (tileIdx < elevation2Index) then
            -- The next 50% of tiles before the first hill
            iElevation = 1;
        end -- Else the tiles at and beyond the first hill
        
        local updateMap = true;
        local tileMapIndex = scoredTiles[tileIdx].MapIndex;
        if (prevElevation ~= iElevation) then
            -- Elevation has increased.
            -- Run PassMaker to connect isolated pockets of lowlands with random
            -- paths of water/lowlands before lowering elevation.
            passmakerArgs.InitReachPlot = function(pm, x, y)
                    return self:InitReachPlot(x, y, prevElevation);
                end;
            
            passmakerArgs.RemoveObstacle = function(pm, x,y, plotsModded) 
                    self:RemoveObstacle(x, y, plotsModded, prevElevation);
                end;
            EnsureReachabilityWithPassMaker(passmakerArgs);
            prevElevation = iElevation;                
        end
        
        if (self.elevationMap[tileMapIndex+1] == ELEVATION_PASSABLE) then
            TerrainBuilder.AddCoastalLowland(tileMapIndex, iElevation);
            
            -- Update the internal map to match the new value for the global map.
            self.elevationMap[tileMapIndex+1] = iElevation;
            
            tilesMarkedFromScoring = tilesMarkedFromScoring + 1;
        end
        
        if (tileIdx == tilesToMark) then
            -- One last PassMaker run after the marking the final tile.
            -- Run PassMaker to connect isolated pockets of lowlands with random
            -- paths of water/lowlands before lowering elevation.
            passmakerArgs.InitReachPlot = function(pm, x, y)
                    return self:InitReachPlot(x, y, iElevation);
                end;
            
            passmakerArgs.RemoveObstacle = function(pm, x,y, plotsModded) 
                    self:RemoveObstacle(x, y, plotsModded, iElevation);
                end;
            EnsureReachabilityWithPassMaker(passmakerArgs);
        end
    end
    
    local numPreHillTiles = elevation2Index-1;
    local numPostHillTiles = #scoredTiles - numPreHillTiles;
    
    print("Floodable tiles from scoring: " ..
          tostring(tilesMarkedFromScoring) .. "/" .. tostring(#scoredTiles) ..
          " (scored tiles = " .. numPreHillTiles .. " pre-hill tiles + " .. 
          self.lowlandsPct .. " pct of " .. numPostHillTiles .. " post-hill tiles)");
    
    print("Floodable tiles from random paths: " .. tostring(self.tilesMarkedByPassMaker));
end

function GotLakes_LowlandsGenerator:Everywhere_MarkLowlands()
    -- Mark all tiles before the first hill at stage 0.
    -- Modify lowlands percentage to control only the number of 
    -- remaining tiles flooded in stage 1.
    -- Mark ALL floodable tiles at stage 2.
    
    -- Get a score for every floodable tile, including losers.
    local scoredTiles = self:ScoreFloodable(true);
    
    if #scoredTiles <= 0 then
        -- Somehow there are no floodable tiles.
        print("No floodable tiles, so no-op.");
        return;
    end
    
    table.sort(scoredTiles, CompareScoredPlots); -- Hardened against desync.
    
    -- Use the index of the first hill to derive thresholds for elevation changes
    -- and the number of tiles to mark for stage 1.
    -- 
    -- Elevation 1: Up to but not including the first hill.
    local elevation1Index = math.floor((#scoredTiles)*2/3);
    for tileIdx = 1, #scoredTiles do
        local tileMapIndex = scoredTiles[tileIdx].MapIndex;
        local plot = Map.GetPlotByIndex(tileMapIndex);
        if plot:IsHills() then
            elevation1Index = tileIdx;
            break;
        end
    end
    
    -- Elevation 2: All tiles up to the first hill + 45% of remaining tiles.
    local elevation2Index = elevation1Index + 
        math.floor(((#scoredTiles - elevation1Index) * self.lowlandsPct) / 100);

    -- Tiles to mark: all of them!
    local tilesToMark = #scoredTiles;

    -- Initialize a map so that we can run passmaker to connect isolated clumps of lowlands.
    self:InitMap();
    
    local passmakerArgs = { obstaclesName = "highlands" };  
    local prevElevation = 0;
    local tilesMarkedFromScoring = 0;
    
    for tileIdx = 1, tilesToMark do
        local iElevation = 2;
        if (tileIdx < elevation1Index) then
            -- Up to but not including the first hill
            iElevation = 0;
        elseif (tileIdx < elevation2Index) then
            -- 45 % of remaining tiles
            iElevation = 1;
        end -- Else all remaining tiles.
        
        local updateMap = true;
        local tileMapIndex = scoredTiles[tileIdx].MapIndex;
        if (prevElevation ~= iElevation) then
            -- Elevation has increased.
            -- Run PassMaker to connect isolated pockets of lowlands with random
            -- paths of water/lowlands before lowering elevation.
            passmakerArgs.InitReachPlot = function(pm, x, y)
                    return self:InitReachPlot(x, y, prevElevation);
                end;
            
            passmakerArgs.RemoveObstacle = function(pm, x,y, plotsModded) 
                    self:RemoveObstacle(x, y, plotsModded, prevElevation);
                end;
            EnsureReachabilityWithPassMaker(passmakerArgs);
            prevElevation = iElevation;                
        end
        
        if (self.elevationMap[tileMapIndex+1] == ELEVATION_PASSABLE) then
            TerrainBuilder.AddCoastalLowland(tileMapIndex, iElevation);
            
            -- Update the internal map to match the new value for the global map.
            self.elevationMap[tileMapIndex+1] = iElevation;
            
            tilesMarkedFromScoring = tilesMarkedFromScoring + 1;
        end
        
        -- No need to run passmaker for the last tile, since there will be no more
        -- floodable tiles to mark at that point.
    end
    
    print("Floodable tiles from scoring: " ..
          tostring(tilesMarkedFromScoring) .. "/" .. tostring(#scoredTiles));
    
    print("Floodable tiles from random paths: " .. tostring(self.tilesMarkedByPassMaker));
end

function GotLakes_LowlandsGenerator:MarkLowlands()
    local coastLows = self.coastLows;
    
    if coastLows == CoastalLowlands.NONE then
        print("Skipping Coastal Lowlands.");
        return;
    end

	print("Marking Coastal Lowlands.");
    local scoredTiles = {};
    
    if coastLows == CoastalLowlands.STANDARD then
        -- Standard
        self:Default_MarkLowlands(self:ScoreFloodableCoast(), self.lowlandsPct);
        
    elseif coastLows == CoastalLowlands.INLAND then
        -- Inland
        -- Scale & Offset the range of lowlands percent to [33,100] (2/3 responsiveness)
        -- so that we mark significantly more tiles than Standard.
        self:Default_MarkLowlands(self:ScoreFloodableInland(), 33+(2*self.lowlandsPct/3));
        
    elseif coastLows == CoastalLowlands.DELUGE then
        -- Deluge
        -- Scale & Offset the range of lowlands percent to [50,100] (1/2 responsiveness)
        -- so that we mark significantly more tiles than Inland.
        self:Deluge_MarkLowlands(self:ScoreFloodableFlat(), 50+(self.lowlandsPct/2));
    
    elseif coastLows == CoastalLowlands.CATACLYSM then
        -- Cataclysm
        -- Scale & Offset the range of lowlands percent to [50,100] (1/2 responsiveness)
        -- so that we mark significantly more tiles than Deluge.
        self:Deluge_MarkLowlands(self:ScoreFloodable(), 50+(self.lowlandsPct/2));

    elseif coastLows == CoastalLowlands.HFTH then
        -- Head for the Hills!
        self:HFTH_MarkLowlands();
        
    else    
        -- All floodable tiles.
        self:Everywhere_MarkLowlands();
    end
end
