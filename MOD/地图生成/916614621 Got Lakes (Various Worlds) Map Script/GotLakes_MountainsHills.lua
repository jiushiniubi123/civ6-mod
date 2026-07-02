-- Mountain & Hill Generators for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

GotLakes_MtnsHillsGenerator = {};

function GotLakes_MtnsHillsGenerator.Create(
    fracXExp, fracYExp,
    wrapX,
    mtnGrainOffset,
    hexMap,
    mtnFractalPercentages,
    hillFractalPercentages,
    mtnClumpEdgeThickness)
	-- Mountains-Hills constructor.
	-- Args:
    --   fracXExp, fracYExp: fractal exponents
    --   wrapX: true iff the world wraps east-west
    --   mtnGrainOffset: fractal grain offset scaled to world size
    --   hexMap: optional struct with hexRadius and a list of hexes for a Hex landmass
    --   mtnFractalPercentages: a map of mountain levels to mountain fractal percentage thresholds
    --   hillFractalPercentages: a map of hill levels to hill fractal percentage thresholds
    --   mtnClumpEdgeThickness: default thickness for mountain clumps
	local iW, iH, numTiles = GetMapGridSize();
	
    local hexMap = hexMap or {};
    
    local mountains   = UserInput.mountains;
    local mtnClumps   = UserInput.mtnClumps;
    local thinMCEdges = UserInput.thinMCEdges;
	local mtnLevel    = UserInput.mtnLevel;
	local hillLevel   = UserInput.hillLevel;
    local noHills     = UserInput.noHills;
    local noMountains = UserInput.noMountains;
    
    local SetHillsFunc = GotLakes_MtnsHillsGenerator.Default_SetHills;
    if noHills then
        print("Preventing mountain generator from spawning of hills (no hills).");
        SetHillsFunc = GotLakes_MtnsHillsGenerator.SetOcean; -- Erase from mts/hills map.
    end
    
    local SetMtnFunc = GotLakes_MtnsHillsGenerator.Default_SetMtn;
    if noMountains then
        print("Preventing mountain generator from spawning mountains (no mountains).");
        SetMtnFunc = GotLakes_MtnsHillsGenerator.SetOcean; -- Erase from mts/hills map.
    end
    
	local mtnAdjust  = mtnFractalPercentages[mtnLevel];	
    local hillAdjust  = hillFractalPercentages[hillLevel];
	
	if (mountains == MtnPatterns.WINDING) then
		-- Increase mountains for winding canyons.
		mtnAdjust  = mtnAdjust  + 10;
	end
	
	-- create instance data
	local instance = 
	{
		-- Helper Methods
		GetAdjustments   = GotLakes_MtnsHillsGenerator.GetAdjustments,
        GetFractalFlags  = GotLakes_MtnsHillsGenerator.GetFractalFlags,
        GetFractalGrain  = GotLakes_MtnsHillsGenerator.GetFractalGrain,
        GetPlotIndex     = GotLakes_MtnsHillsGenerator.GetPlotIndex,
		
        -- Plot Type Setters
        SetOcean = GotLakes_MtnsHillsGenerator.SetOcean,
        SetFlat  = GotLakes_MtnsHillsGenerator.SetFlat,
        SetHills = SetHillsFunc,
        SetMtn   = SetMtnFunc,
        
        -- Mountain Generators
        Tectonic_GenerateMtsHills  = GotLakes_MtnsHillsGenerator.Tectonic_GenerateMtsHills,
        FRanges_GenerateMtsHills   = GotLakes_MtnsHillsGenerator.FRanges_GenerateMtsHills,
        Scattered_GenerateMtsHills = GotLakes_MtnsHillsGenerator.Scattered_GenerateMtsHills,
        Clustered_GenerateMtsHills = GotLakes_MtnsHillsGenerator.Clustered_GenerateMtsHills,
        Uncanny_GenerateMtsHills   = GotLakes_MtnsHillsGenerator.Uncanny_GenerateMtsHills,
        Winding_GenerateMtsHills   = GotLakes_MtnsHillsGenerator.Winding_GenerateMtsHills,
        All_GenerateMtsHills       = GotLakes_MtnsHillsGenerator.All_GenerateMtsHills,
        GenerateMountainsAndHills  = GotLakes_MtnsHillsGenerator.GenerateMountainsAndHills,
        
        -- Hexification
        Scattered_AddHexMtsHills = GotLakes_MtnsHillsGenerator.Scattered_AddHexMtsHills,
        Clustered_AddHexMtsHills = GotLakes_MtnsHillsGenerator.Clustered_AddHexMtsHills,
        HexifyMtsHills           = GotLakes_MtnsHillsGenerator.HexifyMtsHills,
        
        -- Mountain Clumps
        IsInsideMountainClump   = GotLakes_MtnsHillsGenerator.IsInsideMountainClump,
        HollowOutMountainClumps = GotLakes_MtnsHillsGenerator.HollowOutMountainClumps,
        
        -- Extra Mountains/Hills
        CanAddLonelyMountain = GotLakes_MtnsHillsGenerator.CanAddLonelyMountain,
        AddLonelyMountains   = GotLakes_MtnsHillsGenerator.AddLonelyMountains,
        AddExtraHills        = GotLakes_MtnsHillsGenerator.AddExtraHills,
        
		-- Grid info
		iW = iW,
		iH = iH,
		numTiles = numTiles,
        
		-- User inputs
        mountains   = mountains,
        mtnClumps   = mtnClumps,
        thinMCEdges = thinMCEdges,
		mtnLevel    = mtnLevel,
		hillLevel   = hillLevel,
        noHills     = noHills,
        noMountains = noMountains,
        
        -- Args
        fracXExp              = fracXExp,
        fracYExp              = fracYExp,
        wrapX                 = wrapX,
        mtnGrainOffset        = mtnGrainOffset,
        hexRadius             = hexMap.radius,
        numPlotsPerHex        = hexMap.numPlotsPerHex,
        hexes                 = hexMap.hexes,
        mtnClumpEdgeThickness = mtnClumpEdgeThickness,
        
        -- Calibration
        mtnAdjust      = mtnAdjust,
        hillAdjust     = hillAdjust,
	};
	
	return instance;
end

function GotLakes_MtnsHillsGenerator:GetAdjustments()
	-- Get the "adjustment" offsets for mountain & hill fractal height percentages.
	return self.mtnAdjust, self.hillAdjust;
end

function GotLakes_MtnsHillsGenerator:GetFractalFlags()
    -- Return fractal flags for a mountain pattern.
    -- For fractal consistency, call this method no more than once per run.
    local fracFlags = {};
    
    fracFlags.FRAC_POLAR = RandomBool();
    
    if self.wrapX then
        -- Force the fractal to wrap in the x direction for globe maps.
        print("Forcing wrap-x for mountain fractal flags.");
        fracFlags.FRAC_WRAP_X = true;
    else
        fracFlags.FRAC_WRAP_X = RandomBool();
    end
    
    -- This assumes that maps never wrap in the y direction.
    fracFlags.FRAC_WRAP_Y = RandomBool();
    
    print("Mountain fractal flags: polar=" .. tostring(fracFlags.FRAC_POLAR) .. 
        ", wrap_x=" .. tostring(fracFlags.FRAC_WRAP_X) ..
        ", wrap_Y=" .. tostring(fracFlags.FRAC_WRAP_Y));
    
    return fracFlags;
end

function GotLakes_MtnsHillsGenerator:GetFractalGrain(baseGrain)
	-- Get mountain/hills fractal grain scaled to map size.
	return math.min(FRACTAL_MAX_GRAIN, baseGrain + self.mtnGrainOffset);
end

function GotLakes_MtnsHillsGenerator:GetPlotIndex(x, y)
    -- Returns the Lua-style 1-based index for plot types at the specified regional coords.
    return self.iW*y + x + 1;
end

function GotLakes_MtnsHillsGenerator:SetOcean(mtnPlots, i)
    -- Turn the specified hex into ocean.
    mtnPlots[i] = g_PLOT_TYPE_OCEAN;
end

function GotLakes_MtnsHillsGenerator:SetFlat(mtnPlots, i)
    -- Turn the specified hex into flat land.
    mtnPlots[i] = g_PLOT_TYPE_LAND;
end

function GotLakes_MtnsHillsGenerator:Default_SetHills(mtnPlots, i)
    -- Turn the specified hex into hills.
    mtnPlots[i] = g_PLOT_TYPE_HILLS;
end

function GotLakes_MtnsHillsGenerator:Default_SetMtn(mtnPlots, i)
    -- Turn the specified hex into a mountain.
    mtnPlots[i] = g_PLOT_TYPE_MOUNTAIN;
end

function GotLakes_MtnsHillsGenerator:Tectonic_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (tectonic plates).");
	
	-- The "vanilla" mountain pattern.
	local plate_multipliers = {0.67, 0.75, 1.0, 1.33, 1.5};
	local plate_multiplier = plate_multipliers[UserInput.mtnLevel] or 1.0;
		
	-- Tectonic Plate Counts, for use in generating passes through the mountains.
	local numPlates  = 9 * plate_multiplier;	
	local blendRidge = 5;
	local blendFract = 5;
	
	-- Let mountains and hills have different flags,
	-- but use the same flags for fractal-init and ridge-building.
	local mtnFlags = self:GetFractalFlags();
	local hillFlags = self:GetFractalFlags();
	
	-- Generate fractals to govern hills and mountains	
	local mountainsFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(3), 
		mtnFlags, 
		self.fracXExp, self.fracYExp);
		
	local hillsFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(4), 
		hillFlags, 
		self.fracXExp, self.fracYExp);
	
	-- Tectonic mountains
	mountainsFrac:BuildRidges(numPlates, mtnFlags, blendRidge, blendFract);

	-- Add ridges to hills, even for non-tectonic mountain patterns.
	hillsFrac:BuildRidges(numPlates, hillFlags, blendRidge, blendFract);
	
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;
    
	-- Apply adjustment to hills and peaks settings.
	local footLevel = hillAdjust/5;
	local hillLevel = hillAdjust/5;
	
	local mtnLevel     = 100 - footLevel - mtnAdjust;
	local hillsNearMts = mtnLevel - footLevel;
	
	local hillsBottom1 = 28 - hillLevel;
	local hillsTop1    = 28 + hillLevel;
	local hillsBottom2 = 62 - hillLevel;
	local hillsTop2    = 62 + hillLevel;

	local trenches     = 30; -- Water unaffected by world age.
	
	-- Get height values for mountains and hills
	local name = "tectonic plates mtns";
	local iMountainThreshold  = GetFractalHeight(mountainsFrac, mtnLevel,     name);
	local iHillsNearMountains = GetFractalHeight(mountainsFrac, hillsNearMts, name);
	local iTrenchesTop        = GetFractalHeight(mountainsFrac, trenches,     name);
	
	local name = "tectonic plates hills";
	local iPassThreshold      = GetFractalHeight(hillsFrac, hillsNearMts, name);
	local iHillsBottom1       = GetFractalHeight(hillsFrac, hillsBottom1, name);
	local iHillsTop1          = GetFractalHeight(hillsFrac, hillsTop1,    name);
	local iHillsBottom2       = GetFractalHeight(hillsFrac, hillsBottom2, name);
	local iHillsTop2          = GetFractalHeight(hillsFrac, hillsTop2,    name);
		
	-- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local mountainVal = mountainsFrac:GetHeight(x, y);
			local hillVal = hillsFrac:GetHeight(x, y);
						
			-- Check the hill fractal first so that mountains can replace hills.
			if ((hillVal >= iHillsBottom1 and hillVal < iHillsTop1) or 
			    (hillVal >= iHillsBottom2 and hillVal < iHillsTop2)) then
                self:SetHills(mtnPlots, i);
			end
			if (mountainVal >= iMountainThreshold) then
				-- Possible mountain or mountain pass
				if (hillVal >= iPassThreshold) then
					 -- Mountain Pass though the ridgeline
                    self:SetHills(mtnPlots, i);
				else 
					-- Mountain
                    self:SetMtn(mtnPlots, i);
				end
				
			elseif (mountainVal >= iHillsNearMountains) then
                self:SetHills(mtnPlots, i);
				
			elseif (mountainVal <= iTrenchesTop) then
				self:SetOcean(trenchPlots, i);
			end
		end
	end	
end

function GotLakes_MtnsHillsGenerator:FRanges_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (fractal ranges).");
	
	-- Create a snaky fractal pattern without using tectonic 
	-- rifts. Instead, use the 50% percentile of a fractal's
	-- height map as the focus for mountain ranges.
			
	-- Generate fractals to govern mountain ranges
	local rangesFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(2),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
		
	local hillsFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(4),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
		
	-- Apply adjustment to hills and peaks settings.
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;
	
	-- Base all ranges at the middle (50th percentile) of the fratal heights
	-- so that mountains are as snaky and non-blob-like as possible
	-- The fractal becomes blob-like at extreme values (0 and 100).
	local middle = 50;
	
	-- Get height values for mountains and hills
	local mtnLevel      = mtnAdjust/2;
	local foothillLevel = mtnLevel + (hillAdjust/6);
	local hillLevel     = hillAdjust/3;
	local trenches      = 15;
	
	local name = "fractal ranges";
	local iFoothillsBottom = GetFractalHeight(rangesFrac, middle - foothillLevel, name); 
	local iMtnsBottom      = GetFractalHeight(rangesFrac, middle - mtnLevel,      name);  
	local iMtnsTop         = GetFractalHeight(rangesFrac, middle + mtnLevel,      name);
	local iFoothillsTop    = GetFractalHeight(rangesFrac, middle + foothillLevel, name);
	local iTrenchesLow     = GetFractalHeight(rangesFrac, trenches,               name);
	local iTrenchesHigh    = GetFractalHeight(rangesFrac, 100 - trenches,         name);

	local name = "fractal ranges hills";
	local iHillsBottom  = GetFractalHeight(hillsFrac, middle - hillLevel, name); 
	local iHillsTop     = GetFractalHeight(hillsFrac, middle + hillLevel, name);  
	
	-- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local rangeVal = rangesFrac:GetHeight(x,y);
			local hillVal  = hillsFrac:GetHeight(x,y);
			
			-- Check the hill fractal first so that mountains can replace hills.
			if (iHillsBottom <= hillVal and hillVal < iHillsTop) then
				-- Hill ranges.
                self:SetHills(mtnPlots, i);
			end
			if (iMtnsBottom <= rangeVal and rangeVal < iMtnsTop) then
				-- Mountains sandwiched between hills, as far as possible
				-- from fractal extrema.
                self:SetMtn(mtnPlots, i);

			elseif (iFoothillsBottom <= rangeVal and rangeVal < iFoothillsTop) then
				-- Hills surrounding and running parallel to the mountains.
				self:SetHills(mtnPlots, i);
				
			elseif (rangeVal <= iTrenchesLow or rangeVal >= iTrenchesHigh) then
				-- Trench representing water at the map's lowest altitudes.
				self:SetOcean(trenchPlots, i);
			end
		end
	end
end

function GotLakes_MtnsHillsGenerator:Scattered_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (scattered crags).");
		
	-- More granular than other mountain patterns.
	local grain = self:GetFractalGrain(4);
		
    local fracFlags = self:GetFractalFlags();
    
	-- Generate fractals to govern clumps of mountains
	local mtsFrac = Fractal.Create(
		self.iW, self.iH, 
		grain,
		fracFlags, 
		self.fracXExp, self.fracYExp);
    
    local hillsFrac = Fractal.Create(
		self.iW, self.iH, 
		grain,
		fracFlags, 
		self.fracXExp, self.fracYExp);
		
	local trenchesFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(2), -- lower granularity for trenches
		fracFlags, 
		self.fracXExp, self.fracYExp);
    
    -- Apply adjustment to hills and peaks settings.
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;

    -- Five thin bands for mountain clumps.
    local mtsAdjust     = mtnAdjust/5;
    local mtsHalfAdjust = mtsAdjust/2;
	local mts1Bottom    = 97 - mtsAdjust;
	local mts2Top       = 75 + mtsHalfAdjust;
	local mts2Bottom    = 75 - mtsHalfAdjust;
	local mts3Top       = 50 + mtsHalfAdjust;
	local mts3Bottom    = 50 - mtsHalfAdjust;
	local mts4Top       = 25 + mtsHalfAdjust;
	local mts4Bottom    = 25 - mtsHalfAdjust;
	local mts5top       = 3  + mtsAdjust;
    
    -- Two bands for hill clumps.
	local hillsHalf   = hillAdjust*0.6; -- Compensate for overlap with mountains.
	local hillsBottom = 97 - hillsHalf;
	local hillsTop    = 3 + hillsHalf;

    -- Snaky trenches.
    -- Water unaffected by world age.
    local trenches1Bottom  = 36;
    local trenches1Top     = 64;
	
	-- Get height values for various thresholds
	local name = "scattered crags mts";
	local iMtn1Bottom = GetFractalHeight(mtsFrac, mts1Bottom, name);
	local iMtn2Top    = GetFractalHeight(mtsFrac, mts2Top,    name);
	local iMtn2Bottom = GetFractalHeight(mtsFrac, mts2Bottom, name);
	local iMtn3Top    = GetFractalHeight(mtsFrac, mts3Top,    name);
	local iMtn3Bottom = GetFractalHeight(mtsFrac, mts3Bottom, name);
	local iMtn4Top    = GetFractalHeight(mtsFrac, mts4Top,    name);
	local iMtn4Bottom = GetFractalHeight(mtsFrac, mts4Bottom, name);
	local iMtn5Top    = GetFractalHeight(mtsFrac, mts5top,    name);
    
	name = "scattered crags hills";
    local iHillsBottom     = GetFractalHeight(hillsFrac, hillsBottom,     name);
	local iHillsTop        = GetFractalHeight(hillsFrac, hillsTop,        name);
	
	name = "scattered crags trenches";
	local iTrenches1Bottom = GetFractalHeight(trenchesFrac, trenches1Bottom, name);
	local iTrenches1Top    = GetFractalHeight(trenchesFrac, trenches1Top,    name);  

    -- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local mtnVal  = mtsFrac:GetHeight(x, y);
            local hillVal = hillsFrac:GetHeight(x, y);
			local trenchVal = trenchesFrac:GetHeight(x, y);
			
			-- Check the hill fractal first so that mountains can replace hills.
			if ((hillVal >= iHillsBottom) or (hillVal <= iHillsTop)) then
                -- 2 bands of hill crags
				self:SetHills(mtnPlots, i);
			end
			if ((mtnVal >= iMtn1Bottom) or (mtnVal <= iMtn5Top)) then
				-- 1st and 2nd mountain bands.
                self:SetMtn(mtnPlots, i);
				
            elseif ((mtnVal >= iMtn3Bottom) and
                    (mtnVal <  iMtn3Top)) then
                -- 3rd band
                self:SetMtn(mtnPlots, i);
                
            elseif ((mtnVal >= iMtn2Bottom) and
                    (mtnVal <  iMtn2Top)) then
                -- 4th band
                self:SetMtn(mtnPlots, i);
            
            elseif ((mtnVal >= iMtn4Bottom) and
                    (mtnVal <  iMtn4Top)) then
                -- 5th band
                self:SetMtn(mtnPlots, i);
            end
			if ((trenchVal >= iTrenches1Bottom) and
                (trenchVal <  iTrenches1Top)) then
                -- Semi-snaky band of trenches
				self:SetOcean(trenchPlots, i);	
			end
		end
	end
    
    if self.hexes then
        -- Got hexes from the Hex pangea.
        -- Coerce the mountains and hills on the pangea into hexagons. 
        self:HexifyMtsHills(mtnPlots, trenchPlots, self.Scattered_AddHexMtsHills);
    end
end

function GotLakes_MtnsHillsGenerator:Clustered_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (clustered highlands).");
	
	-- Concentrate all of the mountains and hills into a small number of
	-- clusters.
		
	-- Generate fractals to govern mountain ranges
	local rangesFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(2),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
		
	local hillFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(4),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
	
	-- Get height values for mountains and hills
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;

	local mtnLevel      = 99 - mtnAdjust;
	local foothillLevel = mtnLevel - (hillAdjust/4);
	local hillLevel     = 98 - hillAdjust;
	local trenchMiddle  = 25;
	local trenches      = 14;
		
	local name = "clustered highlands";
	local iMtnsBottom      = GetFractalHeight(rangesFrac, mtnLevel,                name);
	local iFoothillsBottom = GetFractalHeight(rangesFrac, foothillLevel,           name);
    local iTrenchesBottom  = GetFractalHeight(rangesFrac, trenchMiddle - trenches, name); 
	local iTrenchesTop     = GetFractalHeight(rangesFrac, trenchMiddle + trenches, name); 

	local iHillsBottom    = GetFractalHeight(hillFrac, hillLevel, name); 
	
	-- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local rangeVal = rangesFrac:GetHeight(x,y);
			local hillVal  = hillFrac:GetHeight(x,y);
			
			-- Check the hill fractal first so that mountains can replace hills.
			if (hillVal >= iHillsBottom) then
				-- Hill cluster.
				self:SetHills(mtnPlots, i);
			end
			if (rangeVal >= iMtnsBottom) then
				-- Mountain cluster
                self:SetMtn(mtnPlots, i);
				
			elseif (rangeVal >= iFoothillsBottom) then
				-- Foothills
				self:SetHills(mtnPlots, i);
				
			elseif ((rangeVal >= iTrenchesBottom) and 
                    (rangeVal <  iTrenchesTop)) then	
				-- Trenches surrounding the mountain cluster
				self:SetOcean(trenchPlots, i);
			end
		end
	end
    
    if self.hexes then
        -- Got hexes from the Hex pangea.
        -- Coerce the mountains and hills on the pangea into hexagons. 
        self:HexifyMtsHills(mtnPlots, trenchPlots, self.Clustered_AddHexMtsHills);
    end
end

function GotLakes_MtnsHillsGenerator:Uncanny_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	-- A variant of Fractal Ranges that usually has more valleys.
	print("Generating mountains and hills (uncanny valleys).");
		
	-- Generate fractals to govern mountain ranges
	local rangesFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(2),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
		
	local hillFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(4),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
	
	-- Apply adjustment to hills and peaks settings.
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;
	
	-- Base all ranges at the middle (50th percentile) of the fratal heights
	-- so that valleys are as snaky and non-blob-like as possible
	-- The fractal becomes blob-like at extreme values (0 and 100).
	local middle        = 50;
	local tValleyLevel  = 2.5;
	local valleyLevel   = 5;	
	local mtnLevel      = valleyLevel + (mtnAdjust/2);
	local foothillLevel = mtnLevel    + (hillAdjust/6);
	local trenches      = 10;
	
	local hillLevel     = valleyLevel + (hillAdjust/3);
	
	-- Get height values for mountains and hills
	local name = "uncanny valleys";
	local iTrenchesBottom = GetFractalHeight(rangesFrac, trenches,               name); 
	local iFHillsBottom   = GetFractalHeight(rangesFrac, middle - foothillLevel, name); 
	local iMtsBottom      = GetFractalHeight(rangesFrac, middle - mtnLevel,      name); 
	local iValleysBottom  = GetFractalHeight(rangesFrac, middle - valleyLevel,   name);
	local iTValleysBottom = GetFractalHeight(rangesFrac, middle - tValleyLevel,  name);  
	local iTValleysTop    = GetFractalHeight(rangesFrac, middle + tValleyLevel,  name);
	local iValleysTop     = GetFractalHeight(rangesFrac, middle + valleyLevel,   name);
	local iMtsTop         = GetFractalHeight(rangesFrac, middle + mtnLevel,      name);	
	local iFHillsTop      = GetFractalHeight(rangesFrac, middle + foothillLevel, name);
	local iTrenchesTop    = GetFractalHeight(rangesFrac, 100 - trenches,         name); 

	local name = "uncanny valleys hills";
	local iHillsBottom    = GetFractalHeight(hillFrac, middle - hillLevel,   name); 
	local iHValleysBottom = GetFractalHeight(hillFrac, middle - valleyLevel, name);  
	local iHValleysTop    = GetFractalHeight(hillFrac, middle + valleyLevel, name);
	local iHillsTop       = GetFractalHeight(hillFrac, middle + hillLevel,   name);
			
	-- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local rangeVal = rangesFrac:GetHeight(x,y);
			local hillVal  = hillFrac:GetHeight(x,y);
			
			-- Check the hill fractal first so that mountains can override hills.
			if ((iHillsBottom <= hillVal and hillVal < iHValleysBottom) or
			    (iHValleysTop <= hillVal and hillVal < iHillsTop)) then
				-- Uncanny hills
				self:SetHills(mtnPlots, i);
			end				
			if (iTValleysBottom <= rangeVal and rangeVal <= iTValleysTop) then
				-- Trench in an uncanny valley between mountains.
				self:SetOcean(trenchPlots, i);

			elseif ((iMtsBottom  <= rangeVal and rangeVal < iValleysBottom) or
			        (iValleysTop <= rangeVal and rangeVal < iMtsTop)) then
				-- Mountains surrounding and running parallel to the hills.
                self:SetMtn(mtnPlots, i);
				
			elseif (iFHillsBottom <= rangeVal and rangeVal < iFHillsTop) then
				-- Foothills.
				self:SetHills(mtnPlots, i);
				
			elseif (rangeVal <= iTrenchesBottom or rangeVal >= iTrenchesTop) then
				-- Trench representing water at the map's lowest altitudes.
				self:SetOcean(trenchPlots, i);
			end
		end
	end
end

function GotLakes_MtnsHillsGenerator:Winding_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (winding canyons).");
	
	-- A mountain pattern that uses a fractal to decide where
	-- *not* to put mountains. Relies on a reachabiliy algorithm
	-- to create mountain passes between canyon clumps.
		
	-- Generate fractals to govern mountain ranges
	local rangesFrac = Fractal.Create(
		self.iW, self.iH, 
		self:GetFractalGrain(3),
		self:GetFractalFlags(), 
		self.fracXExp, self.fracYExp);
		
	local mtnLevel  = 98 - self.mtnAdjust;
	local hillLevel = mtnLevel - self.hillAdjust + 1;
	local trenches  = mtnLevel * 0.375;
	
	-- Get height values for mountains and hills
	local name = "winding canyons";
	local iMtnsBottom  = GetFractalHeight(rangesFrac, mtnLevel,  name);
	local iHillsBottom = GetFractalHeight(rangesFrac, hillLevel, name); 
	local iTrenchesTop = GetFractalHeight(rangesFrac, trenches,  name); 
	
	-- Now the main loop, which will assign the plot types.
	for x = 0, self.iW - 1, 1 do
		for y = 0, self.iH - 1, 1 do
			local i = self:GetPlotIndex(x,y);
			local rangeVal = rangesFrac:GetHeight(x,y);
			
			if (rangeVal > iMtnsBottom) then
				-- Mountains forming canyon walls
                self:SetMtn(mtnPlots, i);
				
			elseif (rangeVal > iHillsBottom) then
				-- Hills near the canyon walls
				self:SetHills(mtnPlots, i);
			
			elseif (rangeVal <= iTrenchesTop) then
				-- Trench in the canyon
                self:SetOcean(trenchPlots, i);
			end
		end
	end	
end

function GotLakes_MtnsHillsGenerator:All_GenerateMtsHills(mtnPlots, trenchPlots)
	-- Mountains and hills - pattern-specific
	print("Generating mountains and hills (everything).");
	
	-- A mountain pattern that combines all of the other mountain patterns.
	local mtnPatternFuncs = 
	{
		self.Tectonic_GenerateMtsHills,
		self.FRanges_GenerateMtsHills,
		self.Scattered_GenerateMtsHills,
		self.Clustered_GenerateMtsHills,
		self.Uncanny_GenerateMtsHills,
		self.Winding_GenerateMtsHills
	};
	
	local maskPct = 30;
	
	for i, MtnPatternFunc in ipairs(mtnPatternFuncs) do
		-- Generate each mountain pattern on a separate layer of maps.
		local patternMtns     = table.fill(g_PLOT_TYPE_OCEAN, self.numTiles);
		local patternTrenches = table.fill(g_PLOT_TYPE_LAND,  self.numTiles);
        self._GenerateHelperMtnPattern = MtnPatternFunc;
		self:_GenerateHelperMtnPattern(patternMtns, patternTrenches);
		
		-- Choose a fractal grain for filtering out pieces of the mountain pattern.
		local grain = self:GetFractalGrain(1) + 
			TerrainBuilder.GetRandomNumber(3, "Random mask grain");
		print("Mountain pattern mask grain: " .. grain);
		
		-- Use a fractal to mask part of the mountain pattern
		-- so that combining all patterns doesn't cover the map in mountains.
		local maskFrac = Fractal.Create(
			self.iW, self.iH, 
			grain,
			self:GetFractalFlags(), 
			self.fracXExp, self.fracYExp);
		
		-- Include this percent of the mountain pattern.
		local iIncludeTop = GetFractalHeight(maskFrac, maskPct, "everything mountains");
		
		-- Now the main loop, which will assign the plot types.
		for x = 0, self.iW - 1, 1 do
			for y = 0, self.iH - 1, 1 do
				local iPlot = self:GetPlotIndex(x,y);
				local maskVal = maskFrac:GetHeight(x,y);
				
				if (maskVal <= iIncludeTop) then
					-- Add to the "everything" pattern's maps.
					if ((mtnPlots[iPlot]    == g_PLOT_TYPE_OCEAN) or 
						(patternMtns[iPlot] == g_PLOT_TYPE_MOUNTAIN)) then
						-- Let hills override ocean, and let mountains override hills.
						mtnPlots[iPlot]    = patternMtns[iPlot];
					end
					if (trenchPlots[iPlot] == g_PLOT_TYPE_LAND) then
						trenchPlots[iPlot] = patternTrenches[iPlot];
					end
				end
			end
		end
	end	
end

function GotLakes_MtnsHillsGenerator:Scattered_AddHexMtsHills(
    mtnPlots, hexInfo, numMts, tgtNumMts, numHills, tgtNumHills)
    -- Overwrite mountains and hills for a Hex Pangea hex.
    -- Args:
    --   mtnPlots: map of mountains and hills
    --   hexInfo: info about the hex such as center coords x and y
    --   hexInfo.numMtsPerHex: target number of mountains for each hex
    --     (tgtNumMts still applies).
    --   numMts, tgtNumMts: current and target number of mountains
    --   numHills, tgtNumHills: current and target number of hills
    -- Returns:
    --    numMts, numHills: new mountain and hill counts for the map
    local hexNumMts = 0;
    local hexNumHills = 0;
    local numMts = numMts;
    local numHills = numHills;
    local numMtsPerHex = hexInfo.numMtsPerHex or tgtNumMts;
    local numHillsPerHex = hexInfo.numHillsPerHex or tgtNumHills;
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
            
            if ((numMts < tgtNumMts) and (hexNumMts < numMtsPerHex)) then
                self:SetMtn(mtnPlots, iPlot);
                hexNumMts = hexNumMts + 1;
                numMts = numMts + 1;
                
            elseif ((numHills < tgtNumHills) and (hexNumHills < numHillsPerHex)) then
                self:SetHills(mtnPlots, iPlot);
                hexNumHills = hexNumHills + 1;
                numHills = numHills + 1;
            else
                self:SetOcean(mtnPlots, iPlot);
            end
            
            if (r > 1) then
                local directions = GetShuffledCopyOfTable(HexDirections);
                for i, direction in ipairs(directions) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
    return numMts, numHills;
end

function GotLakes_MtnsHillsGenerator:Clustered_AddHexMtsHills(
    mtnPlots, hexInfo, numMts, tgtNumMts, numHills, tgtNumHills)
    -- Overwrite mountains and hills for a Hex Pangea hex.
    -- Args:
    --   mtnPlots: map of mountains and hills
    --   hexInfo: info about the hex such as center coords x and y
    --   hexInfo.mtnDistFromEdge: minimum distance from edge of hex to mountains (for
    --     sufficiently large hexes).
    --   numMts, tgtNumMts: current and target number of mountains
    --   numHills, tgtNumHills: current and target number of hills
    -- Returns:
    --    numMts, numHills: new mountain and hill counts for the map
    local numMts = numMts;
    local numHills = numHills;
    local mtnDistFromEdge = hexInfo.mtnDistFromEdge;
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
            
            if (((hexRadius <= mtnDistFromEdge) or (r >= mtnDistFromEdge)) and
                (numMts < tgtNumMts)) then
                self:SetMtn(mtnPlots, iPlot);
                numMts = numMts + 1;
                
            elseif (numHills < tgtNumHills) then
                self:SetHills(mtnPlots, iPlot);
                numHills = numHills + 1;
            else
                self:SetOcean(mtnPlots, iPlot);
            end
            
            if (r > 1) then
                local directions = GetShuffledCopyOfTable(HexDirections);
                for i, direction in ipairs(directions) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
    return numMts, numHills;
end

function GotLakes_MtnsHillsGenerator:HexifyMtsHills(
    mtnPlots, trenchPlots, AddHexMtsHillsFcn)
    -- Hexify clusters of mountains and hills.
    print("Hexifying mountains and hills.");
    local hexRadius = self.hexRadius;
    
    -- Replace the hex pangea's mountains and hills with mtn/hill hexagons
    
    -- Get height values for mountains and hills
	local mtnAdjust = self.mtnAdjust;
    local hillAdjust = self.hillAdjust;
    
    -- Shuffle the hexes to prevent directional bias.
    local hexes = GetShuffledCopyOfTable(self.hexes);
    
    -- Only count plots in the pangea when determining mtn/hill levels.
    local numPlotsPerHex  = self.numPlotsPerHex;
    local numTiles        = numPlotsPerHex * (#hexes);
    local fTargetNumMts   = numTiles*mtnAdjust/100;
    local fTargetNumHills = numTiles*hillAdjust/100;
    -- Skip trenches because Hex landmass always adds extras as islands.
    
    local iTargetNumMts = Round(fTargetNumMts);
    local iTargetNumHills = Round(fTargetNumHills);
    
    local numMtnHexes  = math.max(1,math.floor(fTargetNumMts/numPlotsPerHex));
    local numHillHexes = math.max(1,math.floor(fTargetNumHills/numPlotsPerHex));
    local numFlatHexes = #hexes - numMtnHexes - numHillHexes;

    -- For scattered crags, distribute mountains and hills to as many hexes as possible.
    local scattered_numMtsPerHex = math.max(1,Round(fTargetNumMts/(#hexes)));
    local scattered_numHillsPerHex = math.max(1,Round(fTargetNumHills/(#hexes)));

    -- For hexRadius > 2, prevent clustered-highlands mountains from touching 
    -- the edge of each hex. Helps to spread-out mountains across more hexes.
    local clustered_mtnDistFromEdge = 2;
    
    local numMts = 0;
    local numHills = 0;
    self._AddHexMtsHills = AddHexMtsHillsFcn;
    
    for i, hex in ipairs(hexes) do
        hex.mtnDistFromEdge = clustered_mtnDistFromEdge;
        hex.numMtsPerHex    = scattered_numMtsPerHex;
        hex.numHillsPerHex  = scattered_numHillsPerHex;
        
        numMts, numHills = self:_AddHexMtsHills(
            mtnPlots, hex, numMts, iTargetNumMts, numHills, iTargetNumHills);
    end
end

function GotLakes_MtnsHillsGenerator:GenerateMountainsAndHills()
	-- Generate a layer of mountains and hills.
	
    -- Create landmass-agnostic maps for mountain pattern output.
	local mtnPlots    = table.fill(g_PLOT_TYPE_OCEAN, self.numTiles);
	local trenchPlots = table.fill(g_PLOT_TYPE_LAND, self.numTiles);
    
	local mtnPatternFuncs = 
	{
		self.Tectonic_GenerateMtsHills,
		self.FRanges_GenerateMtsHills,
		self.Scattered_GenerateMtsHills,
		self.Clustered_GenerateMtsHills,
		self.Uncanny_GenerateMtsHills,
		self.Winding_GenerateMtsHills,
		self.All_GenerateMtsHills
	};
	self._GenerateMtnPattern = mtnPatternFuncs[self.mountains];
	self:_GenerateMtnPattern(mtnPlots, trenchPlots);
    
    return mtnPlots, trenchPlots;
end

function GotLakes_MtnsHillsGenerator:IsInsideMountainClump(plotTypes, x, y, clumpEdgeThickness)
	-- Determine whether a plot is far enough inside a mountain clump
	-- to be a candidate for hollowing.
	-- Args:
	--   plotTypes: current map of pre-terrain plot types
	--   x, y: location to check
	--   clumpEdgeThickness: how far away a mountain must be from a passable plot
	--     to be considered inside the mountain clump
	-- Returns: true iff the plot is inside the mountain clump
	local isNonMountainFcn = function(plot)
		if not plot then 
			return false;
		end
		local i = self:GetPlotIndex(plot:GetX(), plot:GetY());
		return plotTypes[i] ~= g_PLOT_TYPE_MOUNTAIN;
	end;
	
	return not IsNearby(x, y, isNonMountainFcn, clumpEdgeThickness);
end

function GotLakes_MtnsHillsGenerator:HollowOutMountainClumps(plotTypes)
	-- Hollow out mountain clumps if specified by user input.	
	if self.noMountains then
        print("Skipping mountain clumps (no mountains).");
        return;
    end
    
    local mtnClumps = self.mtnClumps;
	if (mtnClumps == MountainClumps.FULL) then
		-- Nothing to do. Mountain ranges are initally full.
		print("Keeping full mountain clumps.");
		return;
	end
	
	local hollowingMap = plotTypes;
	
	if (mtnClumps == MountainClumps.HOLLOW) then
		-- User wants completely-hollow mountain ranges.
		-- Use a separate map for tracking which mountains to remove
		-- so that all mountains inside the mountain range get removed.
		print("Hollowing-out mountain clumps.");
		hollowingMap = table.fill(g_PLOT_TYPE_MOUNTAIN, self.numTiles);
	else
		-- Apply hollowing directly to the plot map.
		-- That way, plots adjacent to newly-hollowed plots count as 
		-- part of the edge of the mountain range. This will result in 
		-- a polka-dot pattern of non-mountain land, which the Terrain
		-- Reachability step will then turn into mazes of reachable land.
		print("Carving mazes into mountain clumps.");
	end
	
	local clumpEdgeThickness = 1;
	if self.thinMCEdges then
		print("Using thin mountain clump edges.");
	else
		clumpEdgeThickness = math.max(1,Round(self.mtnClumpEdgeThickness));
		print("Mountain clump edge thickness: " .. clumpEdgeThickness);
	end
	
    local hillLevel = self.hillAdjust;
    local allowHills = not self.noHills;

	local numMtsRemoved = 0;
	local numHillsAdded = 0;
	
	for y = 0, self.iH - 1 do
		for x = 0, self.iW - 1 do
			local i = self:GetPlotIndex(x,y);
			if ((plotTypes[i] == g_PLOT_TYPE_MOUNTAIN) and
			    (self:IsInsideMountainClump(plotTypes, x, y, clumpEdgeThickness))) then
				-- Found a mountain to remove.
				--print("Removing mountain at " .. CoordString(x,y));
				numMtsRemoved = numMtsRemoved + 1;
				local hillsDice = 
					TerrainBuilder.GetRandomNumber(100, "Mountain Hollow Hill");	
				if (allowHills and (hillsDice < hillLevel)) then
					-- Turn the mountain into a hill so that mountain passes
					-- can have random hills.
                    self:SetHills(hollowingMap, i);
					numHillsAdded = numHillsAdded + 1;
				else
					-- Turn the mountain into flat land.
                    self:SetFlat(hollowingMap, i);
				end
			end
		end
	end
	
	if (mtnClumps == MountainClumps.HOLLOW) then
		-- Apply changes from the separate hollowing map to the plot types.
		for i = 0, self.numTiles do
			if (hollowingMap[i] ~= g_PLOT_TYPE_MOUNTAIN) then
				plotTypes[i] = hollowingMap[i];
			end
		end
	end
	
	print("Removed " .. numMtsRemoved .. " mountain(s) and added " .. 
		  numHillsAdded .. " hill(s).");
end

function GotLakes_MtnsHillsGenerator:CanAddLonelyMountain(plotTypes, x, y)
	-- Check adjacent plots for mountains.
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		adjacentPlot = Map.GetAdjacentPlot(x, y, direction);

		if (adjacentPlot ~= nil) then
			local aX = adjacentPlot:GetX();
			local aY = adjacentPlot:GetY();
			local i = self:GetPlotIndex(aX, aY);

			if (plotTypes[i] == g_PLOT_TYPE_MOUNTAIN) then
				return false;
			end
		end
	end
	return true;
end

function GotLakes_MtnsHillsGenerator:AddLonelyMountains(plotTypes)
	-- Add lonely mountains to a plot array with 1-based indexing.
    if self.noMountains then
        print("Skipping lonely mountains (no mountains).");
        return;
    end
    
	local iTotalLandPlots= 0;
	local iTotalMountains = 0;
	local vCoords = {};

	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do
			local i = self:GetPlotIndex(x, y);
			local plotType = plotTypes[i];

			if plotType ~= g_PLOT_TYPE_OCEAN then
				iTotalLandPlots = iTotalLandPlots + 1;
				
				if (plotType == g_PLOT_TYPE_MOUNTAIN) then
					iTotalMountains = iTotalMountains + 1;
				else
					table.insert(vCoords, {x=x,y=y});
				end
			end
		end
	end

	local targetNumMts = Round(iTotalLandPlots * self.mtnAdjust/100);
	print("Target Num Mountains: " .. tostring(targetNumMts));

	local iNewMountains = targetNumMts - iTotalMountains;
	if (iNewMountains >= 0) then
		print("New Mountains ", iNewMountains);
	else
		iNewMountains = 0;
	end

	local iMountainsSet = 0;
	local shuffledCoords =  GetShuffledCopyOfTable(vCoords);
	for i, coord in ipairs(shuffledCoords) do
		if (iMountainsSet >= iNewMountains) then
			break;
		end
	
		local coordX = coord.x;
		local coordY = coord.y;
		local index = self:GetPlotIndex(coordX, coordY);
		
		if ((plotTypes[index] ~= g_PLOT_TYPE_MOUNTAIN) and 
			(plotTypes[index] ~= g_PLOT_TYPE_OCEAN) and 
			self:CanAddLonelyMountain(plotTypes, coordX, coordY)) then
			-- Add a lonely mountain at this randomly-selected spot.
            self:SetMtn(plotTypes, index);
			iMountainsSet = iMountainsSet + 1;
		end
	end
	print("Mountains Set", iMountainsSet);
end

function GotLakes_MtnsHillsGenerator:AddExtraHills(plotTypes)
	-- Add extra hills to a plot array with 1-based indexing.
    if self.noHills then
        print("Skipping extra hills (no hills).");
        return;
    end
    
	local iTotalLandPlots= 0;
	local iTotalHills = 0;

	for x = 0, self.iW - 1 do
		for y = 0, self.iH - 1 do
			local i = self:GetPlotIndex(x, y);

			if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
				iTotalLandPlots = iTotalLandPlots + 1;
			end

			if (plotTypes[i] == g_PLOT_TYPE_HILLS) then
				iTotalHills = iTotalHills + 1;
			end
		end
	end

	local targetNumHills = Round(iTotalLandPlots * self.hillAdjust/100);
	print("Target Num Hills: " .. tostring(targetNumHills));

	local iNewHills = targetNumHills - iTotalHills;
	if (iNewHills >= 0) then
		print("New Hills ", iNewHills);
	else
		iNewHills = 0;
	end

	local iI = 0;
	local iHillsSet = 0;
	while iHillsSet < iNewHills  and iI < iTotalLandPlots do
		local xRand = TerrainBuilder.GetRandomNumber(self.iW, "Random X");
		local yRand = TerrainBuilder.GetRandomNumber(self.iH, "Random Y");
		local index = self:GetPlotIndex(xRand, yRand);
		
		if (plotTypes[index] == g_PLOT_TYPE_LAND) then
			-- Add a hill at this randomly-selected spot.
            self:SetHills(plotTypes, index);
			iHillsSet = iHillsSet + 1;
		end
		iI = iI + 1;
	end
	print("Hills Set", iHillsSet);
end
