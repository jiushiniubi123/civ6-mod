-- Feature Generator for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
include "GotLakes_Options"
include "GotLakes_Utils"

if g_FEATURE_SUK_KELP then
	-- Suppress the base mod's feature generator.
	Game:SetProperty("Suk_Kelp_Spawned", true);
end

GotLakes_FeatureGenerator = {};

function GotLakes_FeatureGenerator.Create(
	landArgs,
	biodivArgs, 
	climateArgs,
	biomeArgs,
	sunlightArgs,
	donutFillingMap,
    enabledTerrainsMap,
	gotGatheringStorm,
	wrapX,
	createClimateFracFcn, 
	latitudeFcn,
    reduceReefs)
	-- Feature-Gen constructor.
	-- Args:
	--   landArgs: landmass info
	--   biodivArgs: biodiversity info
	--   climateArgs: climate info
	--   biomeArgs: biome info
	--   sunlightArgs: sunlight info
	--   donutFillingMap: a map indicating which plots are part of the donut filling
	--   enabledTerrainsMap: a map of land terrains to enabled status
	--   gotGatheringStorm: whether this is a GS map
	--   wrapX: whether the map wraps east-west
	--   createClimateFracFcn: function that takes a fractal name 
	--     and returns a new climate fractal instance.
	--   latitudeFcn: function that takes plot (x,y) coordinates 
	--     and returns latitude in [0,1]
    --   reduceReefs: whether to reduce reefs as a way to avoid crash-on-reveal bugs. 
    --     (probably obsolete)
	local iW, iH, numTiles = GetMapGridSize();
	
	local freshWater   = UserInput.riverLevel;
	local temperature  = UserInput.temperature;
	local rainfall     = UserInput.rainfall;
	local kelpLevel    = UserInput.kelpLevel;
	local forestJungle = UserInput.forestJungl;
	local climateWrap  = UserInput.climateWrap;
	local biodiv       = UserInput.biodiv;
	local climate      = UserInput.climate;
	local sunlight     = UserInput.sunlight;
	local icyPoles     = UserInput.icyPoles;
    local noFloodplns  = UserInput.noFloodplns;
    local noForests    = UserInput.noForests;
    local noJungles    = UserInput.noJungles;
    local noMarsh      = UserInput.noMarsh;
	
	local polarIceNumRows = landArgs.polarIceNumRows;
	if ((climate == Climates.GREENHOUSE) or 
	    (climate == Climates.SANDSTORM) or
	    (icyPoles == ICYPOLES_CROP)) then
		-- Poles cropped, or climate too hot for ice.
		polarIceNumRows = 0;
		print("Disabling top/bottom rows of polar ice.");
	end
		
	-- Set feature traits.
    -- Floodplains
    if noFloodplns then
        print("Preventing floodplains from spawning (no floodplains).");
    end
    
	-- Jungles
	local junglePct      = biomeArgs.junglePct;
	local junglePctShift = biomeArgs.junglePctShift;
    local addJunglesAtPlotFcn = GotLakes_FeatureGenerator.Default_AddJunglesAtPlot;
    if noJungles then
        print("Preventing jungles from spawning (no jungles).");
        addJunglesAtPlotFcn = GotLakes_FeatureGenerator.AddNothingAtPlot;
    end
	
	-- Reefs
	local reefPct = 9;
    if reduceReefs then
        reefPct = 7;  -- 8% is too much
        if (wrapX == false) then
            print("Reducing reefs (region).");
            reefPct = 1;
        end
    end
	
	-- Kelp Forests
	-- Calibrated to match Suk's Oceans coverage of ~27% of eligible plots on Continents.
	local kelpPct    = sunlightArgs.kelpPct[climate];
	local kelpChange = Round(kelpPct/4);
	
	-- Oases.
	local oasisPct    = biomeArgs.oasisPct;    -- originally 6; r&f 1
	local oasisChange = biomeArgs.oasisChange; -- originally a scale factor of 1.5
	
	-- Forests
	local forestPct    = biomeArgs.forestPct;
	local forestChange = biomeArgs.forestChange;
    local addForestsAtPlotFcn = GotLakes_FeatureGenerator.Default_AddForestsAtPlot;
    if noForests then
        print("Preventing forests from spawning (no forests).");
        addForestsAtPlotFcn = GotLakes_FeatureGenerator.AddNothingAtPlot;
    end

	-- Fungalfields
	-- Treat fungalfield as jungle for jungle vs forest adjustments.
	local fungalPct    = junglePct/3; -- OPH assigned a base percent of 5 which is about a 3rd of base rainfall.
	local fungalChange = junglePctShift/3;
	if g_FEATURE_OPH_FUNGAL_FOREST then
		-- Reduce jungles to make room for fungalfields.
		junglePct      = junglePct/2;
		junglePctShift = junglePctShift/2;
	end

	-- Marsh
	local marshPct    = biomeArgs.marshPct;
	local marshChange = biomeArgs.marshChange;
    
    if g_FEATURE_HD_SWAMP then
        -- Reduce marsh to compensate for swamps which share the same threshold.
        marshPct    = math.max(1,Round(marshPct    * 2/3));
        marshChange = math.max(1,Round(marshChange * 2/3));
    end
    
    local addMarshAtPlotFcn = GotLakes_FeatureGenerator.Default_AddMarshAtPlot;
    if noMarsh then
        print("Preventing marsh from spawning (no marsh).");
        addMarshAtPlotFcn = GotLakes_FeatureGenerator.AddNothingAtPlot;
    end
	
	-- Ice
	local icePct    = sunlightArgs.icePct[climate];
	local iceChange = 10;
	
	-- How much to adjust latitudes based on temperature.
	local jungleLatChange  = 0.1;	
	local reefMaxLatChange = 0.1;
	local forestLatChange  = 0.1;
	local marshLatChange   = 0.1;
	local iceLatChange     = 0.1;
	
	-- How much to adjust latitudes based on forest/jungle mix.
	local forestJungleLatChange = 0.1;

	-- Latitude interpolation ranges: 0 = hottest, 1 = uncropped coldest.
	local jungleMinLat  = sunlightArgs.jungleMinLat[climate];
	local jungleMaxLat  = sunlightArgs.jungleMaxLat[climate];
	local reefMaxLat    = sunlightArgs.reefMaxLat[climate];
	local forestHMinLat = sunlightArgs.forestHMinLat[climate]; 
	local forestHMaxLat = sunlightArgs.forestHMaxLat[climate];
	local marshMinLat   = sunlightArgs.marshMinLat[climate];
	local marshMaxLat   = sunlightArgs.marshMaxLat[climate];
	local forestCMinLat = sunlightArgs.forestCMinLat[climate];
	local forestCMaxLat = sunlightArgs.forestCMaxLat[climate];
	local iceMinLat     = sunlightArgs.iceMinLat[climate];
	local iceMaxLat     = sunlightArgs.iceMaxLat[climate];
	
	local jungleMaxLatDiff = biomeArgs.jungleMaxLatDiff;
	jungleMaxLat = jungleMaxLat + jungleMaxLatDiff;
	
	local forestCMaxLatDiff = biomeArgs.forestCMaxLatDiff;
	forestCMaxLat = forestCMaxLat + forestCMaxLatDiff;
	
	if (icyPoles == ICYPOLES_CROP) then
		-- Reduce all ice fractals for cropped poles.
		local cropMult = 0.5;
		icePct = Round(cropMult * icePct);
		iceChange  = Round(cropMult * iceChange);
	end
		
	-- Compute change multiplier based on temperature.
	local tempMult  = DOWN_TO_UP2[temperature];
	
	-- Warmer climate => wider band of jungles.
	jungleMinLat = jungleMinLat + (tempMult * jungleLatChange);
	jungleMaxLat = jungleMaxLat + (tempMult * jungleLatChange);
	
	-- Warmer climate => wider band of reefs.
	reefMaxLat = reefMaxLat + (tempMult * reefMaxLatChange);
	
	-- Warmer climate => trees stretching closer to the poles
	forestHMinLat = forestHMinLat + (tempMult * forestLatChange);
	forestHMaxLat = forestHMaxLat + (tempMult * forestLatChange);
	forestCMinLat = forestCMinLat + (tempMult * forestLatChange);
	forestCMaxLat = forestCMaxLat + (tempMult * forestLatChange);
	
	-- Warmer climate => marsh extending closer to the poles.
	marshMinLat = marshMinLat + (tempMult * marshLatChange);
	marshMaxLat = marshMaxLat + (tempMult * marshLatChange);
	
	-- Warmer climate => less ice
	icePct     = icePct     - (tempMult * iceChange);
	iceMinLat  = iceMinLat  + (tempMult * iceLatChange);
	iceMaxLat  = iceMaxLat  + (tempMult * iceLatChange);
	
	-- Bias kelp Forest towards cooler latitudes but not extreme cold.
	local kelpPeakLat = forestCMinLat + 0.1;
	
	-- Adjust forest and jungle latitudes based on forest/jungle mix
	-- order of {++forest, +forest, std, +jungle, ++jungle}
	local forestJungleLatMult = DOWN_TO_UP2[forestJungle];
	local forestJungleLatDiff = forestJungleLatMult * forestJungleLatChange;
	jungleMinLat  = jungleMinLat  + forestJungleLatDiff;
	jungleMaxLat  = jungleMaxLat  + forestJungleLatDiff;
	forestHMinLat = forestHMinLat + forestJungleLatDiff;
	forestHMaxLat = forestHMaxLat + forestJungleLatDiff;
	-- Use math.max here to avoid overlap between hot and cold forest bands,
	-- so that interpolation stays continuous across the bands.
	forestCMinLat = math.max((forestCMinLat - forestJungleLatDiff), forestHMaxLat);
	forestCMaxLat = math.max((forestCMaxLat - forestJungleLatDiff), forestCMinLat);
	
	-- Make OPH's fungalfield lats similar to jungle but with a higher lat interpolation range
	-- similar to OPH's placement.
	local fungalMinLat = jungleMinLat + 0.1;
	local fungalMaxLat = jungleMaxLat + 0.1;

	-- Use rainfall to control forests, jungles, and marsh.
	local rainMult = DOWN_TO_UP2[rainfall];
	
	junglePct = junglePct + (rainMult * junglePctShift);
	forestPct = forestPct + (rainMult * forestChange);
	fungalPct = fungalPct + (rainMult * fungalChange);
	marshPct  = marshPct  + (rainMult * marshChange);
	
	fungalPct = math.clamp(fungalPct, 0, 100)

	local kelpMult = DOWN_TO_UP2[kelpLevel];
	kelpPct   = kelpPct   + (kelpMult * kelpChange);
	
	-- More fresh water (rivers) => more oases.
	-- This is a balance tweak--more rivers means less deserts on which to spawn oases.
	local waterMult = DOWN_TO_UP2[freshWater];
	oasisPct = oasisPct + (waterMult * oasisChange);

	local addIceAtPlotFcn;
	if (#sunlightArgs.AddIceAtPlot > 0) then
		-- Non-standard sunlight.
		addIceAtPlotFcn = sunlightArgs.AddIceAtPlot[climateWrap];
	else
		-- Standard sunlight, so let climate decide how to add ice.
		addIceAtPlotFcn = climateArgs.AddIceAtPlot[climateWrap];
	end
	
	icePct = math.clamp(icePct, 0, 100);
	print("Max ice fractal percent: " .. icePct);

	-- create instance data
	local instance = 
	{
		-- methods
		InitFractals		 = GotLakes_FeatureGenerator.InitFractals,
		InitIcePhases		 = GotLakes_FeatureGenerator.InitIcePhases,
		GetIcePhase          = GotLakes_FeatureGenerator.GetIcePhase,
		FractalIceAtPlot     = GotLakes_FeatureGenerator.FractalIceAtPlot,
		PolarRowsIceAtPlot   = GotLakes_FeatureGenerator.PolarRowsIceAtPlot,
		WhiteNoiseIceAtPlot  = GotLakes_FeatureGenerator.WhiteNoiseIceAtPlot,
		AddFeatures			 = GotLakes_FeatureGenerator.AddFeatures,
		AddOasisAtPlot		 = GotLakes_FeatureGenerator.Default_AddOasisAtPlot,
		AddIceAtPlot		 = addIceAtPlotFcn,
		AddMarshAtPlot		 = addMarshAtPlotFcn,
		AddJunglesAtPlot	 = addJunglesAtPlotFcn,
		AddFungalAtPlot      = GotLakes_FeatureGenerator.Default_AddFungalAtPlot,
		AddSwampAtPlot	     = GotLakes_FeatureGenerator.Default_AddSwampAtPlot,
		AddForestsAtPlot	 = addForestsAtPlotFcn,
        AddSavannahAtPlot    = GotLakes_FeatureGenerator.Default_AddSavannahAtPlot,
		AddReefAtPlot        = GotLakes_FeatureGenerator.Default_AddReefAtPlot,
		AddKelpAtPlot        = GotLakes_FeatureGenerator.Default_AddKelpAtPlot,
		AddFeaturesFromContinents 
							 = GotLakes_FeatureGenerator.AddFeaturesFromContinents,
		CreateClimateFractal = createClimateFracFcn,
		GetLatitudeAtPlot    = latitudeFcn,
			
		-- Grid info
		iW       = iW,
		iH       = iH,
		numTiles = numTiles,
		
		-- Land info
		polarIceNumRows   = polarIceNumRows,

		-- Misc script state
		donutFillingMap   = donutFillingMap,
		gotGatheringStorm = gotGatheringStorm,
		wrapX             = wrapX,
        reduceReefs       = reduceReefs,
		
		-- Feature params
		junglePct = junglePct,
		forestPct = forestPct,
		marshPct  = marshPct,
		fungalPct = fungalPct,
		kelpPct   = kelpPct,
		oasisPct  = oasisPct,
		icePct    = icePct,
		reefPct   = reefPct,
        
        bGrass   = enabledTerrainsMap[g_TERRAIN_TYPE_GRASS],
        bPlains  = enabledTerrainsMap[g_TERRAIN_TYPE_PLAINS],
        
        -- Flags for land features that are not completely controlled by "add" functions
        bFloodplains = not noFloodplns,
        bForests     = not noForests,
        bJungles     = not noJungles,
        --bMarsh       = not noMarsh, -- Marsh can only spawn on land via addMarshAtPlotFcn
    
		bForestsOnTundra = biodivArgs.tundraForest and (UserInput.noTForests == false),
		bOasesOnDesert   = biodivArgs.desertOasis  and (UserInput.noDOases   == false),
		
		bJunglesOnGrass  = biodivArgs.grassJungle  and (UserInput.noGJungles == false),
		bMarshOnPlains   = biodivArgs.plainsMarsh  and (UserInput.noPMarsh   == false),
		
		bJunglesOnDesert = biodivArgs.desertJungle and (UserInput.noDJungles == false),
		bForestsOnSnow   = biodivArgs.snowForest   and (UserInput.noSForests == false),
	
		bForestsOnDesert = biodivArgs.desertForest and (UserInput.noDForests == false),
		bOasesOnSnow     = biodivArgs.snowOasis    and (UserInput.noSOases   == false),
			
		jungleMinLat  = jungleMinLat,
		jungleMaxLat  = jungleMaxLat,
		forestHMinLat = forestHMinLat,
		forestHMaxLat = forestHMaxLat,
		forestCMinLat = forestCMinLat,
		forestCMaxLat = forestCMaxLat,
		marshMinLat   = marshMinLat,
		marshMaxLat   = marshMaxLat,
		fungalMinLat  = fungalMinLat,
		fungalMaxLat  = fungalMaxLat,
		reefMaxLat    = reefMaxLat,
		iceMinLat     = iceMinLat,
		iceMaxLat     = iceMaxLat,
		kelpPeakLat   = kelpPeakLat,
		
		fissureCount = 0,
		
		gotIceDonut = (gotDonut and 
			 (climateWrap == WWRAP_AZIMUTH) and 
			 (sunlight    == Sunlights.STANDARD) and
			 (climate     == Climates.ICEAGE)),
			 
		gotKelpDonut = (gotDonut and g_FEATURE_SUK_KELP and
			 (UserInput.kelpForests == KelpForests.CREEP) and 
			 (kelpLevel             == KelpLevels.VHIGH)),
		
		-- Kelp creep with Suk's Oceans disabled => fake kelp donut filling!
		-- Forest/Jungle Much More Forest => Forest in water
		-- Forest/Jungle Much More Jungle => Jungle in water
		gotFakeKelpDonut = (gotDonut and (not g_FEATURE_SUK_KELP) and
			 (UserInput.kelpForests == KelpForests.CREEP)),
		
		-- Dry donut filling
		-- No jungle, forest, or marsh on land.
		gotDryDonut = (gotDonut and (rainfall == RainfallLevels.VLOW)),
		
		-- Wet donut filling
		-- Lots of forest/jungle depending on forest/jungle mix.
		gotWetDonut = (gotDonut and (rainfall == RainfallLevels.VHIGH)),
		
		-- Marsh on applicable land
		gotMarshDonut = (gotDonut and 
			 (rainfall        == RainfallLevels.VHIGH) and 
			 (UserInput.biome == Biomes.WETLAND)),
		
	};
	--PrintContentsOfTable(instance);

	-- initialize instance data
	instance:InitFractals();
	instance:InitIcePhases();
	
	return instance;
end

function GotLakes_FeatureGenerator:InitFractals()
	-- Initialize fractals
	self.jungles = self.CreateClimateFractal("jungles");
	self.forests = self.CreateClimateFractal("forests");
	self.marsh   = self.CreateClimateFractal("marsh");
	self.swamp   = self.CreateClimateFractal("swamp");
	self.kelp    = self.CreateClimateFractal("kelp");
	self.ice     = self.CreateClimateFractal("ice");
    
    if g_FEATURE_JNR_SAVANNAH then
        -- Separate fractal to allow both desert jungles/forests and savannahs on a 
        -- high-biodiversity map.
        self.savannahs = self.CreateClimateFractal("savannahs");
    end

	-- Threshold for max density of fractal ice.
	-- Does not affect white-noise ice.
	self.iceBottomPct = 100 - self.icePct;
	
	-- Threshold for non-interpolated ice.
	self.iceLevel = GetFractalHeight(self.ice, self.iceBottomPct);
	
	-- Reduce frequency of oases on snow.
	self.oasisSnowPct = self.oasisPct / 4;
end

function GotLakes_FeatureGenerator:InitIcePhases()
	if (not self.gotGatheringStorm) then
		-- GS is disabled, so stub-out ice phases.
		self.iceNumPhases = 0;
		return;
	end
	-- Initialize logic for determining meltability of each ice tile.
	print("Initializing ice phases.");
	
	-- Map sea level to ice-loss phase.
	local phases = {};
	local numPhases = 0;
	for row in GameInfo.RandomEvents() do
		if (row.EffectOperatorType == "SEA_LEVEL") then
			local kPhaseDetails = {};
			kPhaseDetails.randomEventEnum = row.Index;
			
			-- Ice loss as percentage lost during phase
			kPhaseDetails.iceLoss = row.IceLoss;
			
			table.insert(phases, kPhaseDetails);
			numPhases = numPhases + 1;
		end
	end
	self.icePhases = phases;
	self.iceNumPhases = numPhases;
end

function GotLakes_FeatureGenerator:GetIcePhase(iceLoss)
	-- Map ice loss from [0,100] to appropriate ice phase # or -1 for permanent ice.
	if (self.iceNumPhases <= 0) then
		return -1;
	end
	
	local minPhase = nil;
	local minIceLoss = 101;
	
	-- Look for the phase with lowest ice loss that is still > param iceLoss
	for i, phase in ipairs(self.icePhases) do
		if ((phase.iceLoss >= iceLoss) and (phase.iceLoss < minIceLoss)) then
			minPhase = phase;
			minIceLoss = phase.iceLoss;
		end
	end
	
	if (not minPhase) then
		-- Permanent ice.
		return -1;
	end
	return minPhase.randomEventEnum;
end

function GotLakes_FeatureGenerator:AddNothingAtPlot(plot, iX, iY, lat)
	-- Add nothing at the specified plot.
	return false, 0;
end

function GotLakes_FeatureGenerator:FractalIceAtPlot(plot, iX, iY, lat)
	-- Fractal ice with linear latitude interpolation.
	local iceLevel = GetFractalHeight(self.ice, Interpolate(lat, 
		self.iceMinLat, self.iceMaxLat, 
		100, self.iceBottomPct));
		
	if (self.ice:GetHeight(iX, iY) <= iceLevel) then
		-- no ice.
		return false, 0;
	end
	
	-- Map latitude to ice loss such that higher lat => higher phase required to melt ice.
	local iceLoss = Interpolate(lat, self.iceMinLat, self.iceMaxLat, 0, 100);
	return true, self:GetIcePhase(iceLoss);
end

function GotLakes_FeatureGenerator:PolarRowsIceAtPlot(plot, iX, iY, lat)
	-- Add ice to the top/bottom rows of the map.
	if ((iY < self.polarIceNumRows) or (iY >= self.iH - self.polarIceNumRows)) then
		-- Got polar ice.
		-- Not enough latitude diff here to bother with interpolation, 
		-- so randomize melting of top/bottom rows of ice.
		local iceLoss = TerrainBuilder.GetRandomNumber(100, "White Noise Ice Loss");
		return true, self:GetIcePhase(iceLoss);
	end
	
	return false, 0;
end

function GotLakes_FeatureGenerator:WhiteNoiseIceAtPlot(plot, iX, iY, lat, maxPct)
	-- Interpolated white noise is good enough for maps that don't have much ice.
	local maxPct = maxPct or 100;
	local rand = TerrainBuilder.GetRandomNumber(100, "White Noise Ice");
	local iceLevel = Interpolate(lat, 
		self.iceMinLat, self.iceMaxLat, 
		100, 100 - maxPct,
		Square);
	if (rand <= iceLevel) then
		return false, 0;
	end
		
	-- Map latitude to ice loss such that higher lat => higher phase required to melt ice.
	local iceLoss = Interpolate(lat, self.iceMinLat, self.iceMaxLat, 0, 100);
	return true, self:GetIcePhase(iceLoss);
end

function GotLakes_FeatureGenerator:AddFeatures()
	-- Default behavior for adding features.
	self.iNumLandPlots = 0;
	
	local kelpForests = UserInput.kelpForests;
	local numKelps = 0;     -- Plots that actually have kelp
	local numKelpables = 0; -- Plots that can have kelp
	
	local latMin = math.huge;
	local latMax = 0.0;
	
	local maxNumReefs = math.huge;
	local numReefs = 0;
	    
	if (self.reduceReefs and (self.wrapX == false)) then
		-- For some reason, region maps crash if there are too many reefs.
		-- Standard size max is 27 on my machine.
		maxNumReefs = Round(self.numTiles / 250); -- Roughly 17 for standard-size maps
		print("Max number of reefs: " .. maxNumReefs);
	end
	
	if self.gotGatheringStorm and self.bFloodplains then
        -- First let's add Floodplains
        print("Adding GS floodplains.");
        -- GotLakes rivers are created mouth-first.
        -- However, this flag might be more concerned about 
        -- whether rivers merge toward the mouth (start inland, multiple sources per mouth) or
        -- whether rivers merge toward the source (start at mouth, multiple mouths per source).
        -- ...but GL rivers can do both!
        local bRiversStartInland = false;
        --	not ((UserInput.rivers == RiverPatterns.SIMPLE) and 
        --	     (UserInput.landmass == Landmasses.INLANDSEA));
        -- Floodplain min/max sizes seem to have no effect 
        -- on number of floodplains tiles added to the map.
        local iMinFloodplainSize = 4;
        local iMaxFloodplainSize = 10;
        TerrainBuilder.GenerateFloodplains(
            bRiversStartInland, iMinFloodplainSize, iMaxFloodplainSize);
	end
	
	-- Main loop, adds features to all plots as appropriate
	for y = 0, self.iH - 1, 1 do
		for x = 0, self.iW - 1, 1 do
			local plot = Map.GetPlot(x,y);
			
			if plot then
				local lat = self.GetLatitudeAtPlot(x, y);
				local plotIndex = GetPlotIndexLua(x,y);
				
				latMin = math.min(latMin, lat);
				latMax = math.max(latMax, lat);
				
				if plot:IsWater() then			
					-- Water feature
					local isShallowWater = (plot:GetTerrainType() == g_TERRAIN_TYPE_COAST);
					
					-- TerrainBuilder.CanHaveFeature() doesn't allow ice in lakes, 
					-- so skip that check because we're OK with frozen lakes.
					--
					-- Avoid if no-ice option is enabled.
					-- Avoid rivers.
					-- Avoid coast if enforcing circumnavigation
					-- Avoid coast if either connected seas or no-coastal-ice is enabled.				
					local allowCoastalIce = 
						not (gotCircumnav or 
							 UserInput.connectSeas or
							 UserInput.noCoastIce);
					local addedIce = false;
					if ((UserInput.noIce == false) and
						(not IsConnectedToRiver(x, y)) and
						(allowCoastalIce or (not IsAdjacentToLandPlot(x, y))) ) then
						-- Maybe add ice.
						local addedIce, icePhase = self:AddIceAtPlot(plot, x, y, lat);
						if addedIce then
							TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
							if self.gotGatheringStorm then
								-- GS: also set ice phase.
								TerrainBuilder.AddIce(plot:GetIndex(), icePhase);
							end
						end
					end
					if not addedIce then
						if (g_FEATURE_REEF and 
							(UserInput.noReefs == false) and 
							(numReefs < maxNumReefs) and
							(not IsAdjacentToKelpForest(x,y)) and
							self:AddReefAtPlot(plot, x, y, lat)) then
							-- Added a reef.
							TerrainBuilder.SetFeatureType(plot, g_FEATURE_REEF);
							numReefs = numReefs + 1;
						
						-- Kelp Forest from Sukritact's Oceans.
						-- Must exist and be enabled by user.
						-- Must not be adjacent to reef.
						-- Must be adjacent to land unless user selected creep
						elseif (g_FEATURE_SUK_KELP and
								(kelpForests ~= KelpForests.NONE) and
								(not IsAdjacentToReef(x,y)) and
								isShallowWater and
								((kelpForests == KelpForests.CREEP) or
								 IsAdjacentToLandPlot(x,y))) then
							numKelpables = numKelpables + 1;
							if self:AddKelpAtPlot(plot, x, y, lat) then
								-- Added a kelp forest
								TerrainBuilder.SetFeatureType(plot, g_FEATURE_SUK_KELP);
								numKelps = numKelps + 1;
							end
						
						elseif (self.gotFakeKelpDonut and isShallowWater and 
								((self.donutFillingMap[plotIndex]) == FILLING_YES)) then
							-- Fake kelp donut filling.
							if (self.bJungles and
                                (UserInput.forestJungl == ForestJungleLevels.VHIGH)) then
								-- Jungle in water
								TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
								
							elseif (self.bForests and 
                                    (UserInput.forestJungl == ForestJungleLevels.VLOW)) then
								-- Forest in water
								TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);							
							end
						end
					end
				else
					--[
					-- Land feature
					self.iNumLandPlots = self.iNumLandPlots + 1;
					if (plot:GetFeatureType() ~= g_FEATURE_NONE) then
						-- Skip land plots that already have features.
					
					elseif ((not self.gotGatheringStorm) and self.bFloodplains and
					    TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FLOODPLAINS)) then
						-- Classic floodplains.
						-- All desert plots along river are set to flood plains.
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_FLOODPLAINS);
						
					elseif (self:AddOasisAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_OASIS);
						-- Added an oasis.
						--
						-- GS base game tries to prevent oases next to geothermal fissures,
						-- but I simply don't care if that happens.
						
					elseif (self:AddMarshAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_MARSH)
						-- Added marsh
						if ((not self.bMarshOnPlains) and 
							IsBaseTerrainType(g_TERRAIN_TYPE_PLAINS, plot:GetTerrainType())) then
							-- Convert plains under marsh into grass 
							SetBaseTerrain(plot, g_TERRAIN_TYPE_GRASS);
						end
					
					elseif (self:AddJunglesAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
						-- Added jungle.
						if ((not self.bJunglesOnGrass) and 
						    IsBaseTerrainType(g_TERRAIN_TYPE_GRASS, plot:GetTerrainType())) then
							-- Convert grass under jungle into plains 
							SetBaseTerrain(plot, g_TERRAIN_TYPE_PLAINS);
						end
                        
					elseif (g_FEATURE_OPH_FUNGAL_FOREST and 
                            self:AddFungalAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_OPH_FUNGAL_FOREST);
						-- Added fungalfield.

                    elseif (g_FEATURE_HD_SWAMP and 
                            self:AddSwampAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_HD_SWAMP);
						-- Added swamp.
						
					elseif self:AddForestsAtPlot(plot, x, y, lat) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);
						-- Added forest.
                        
                    elseif (g_FEATURE_JNR_SAVANNAH and 
                            self:AddSavannahAtPlot(plot, x, y, lat)) then
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_JNR_SAVANNAH);
						-- Added savannah.
					end
					--]]
				end
			else
				print("Nil plot at " .. CoordString(x,y));
			end
		end
	end
	
	print("Number of reefs: " .. numReefs);
	
	-- Analysis that matches the kelp percentage from Suk's Oceans
	print("Kelp coverage of eligible plots: ", PercentString(numKelps, numKelpables));
	
	latMin = Round(latMin*100)/100;
	latMax = Round(latMax*100)/100;
	print("Feature latitude range: " .. CoordString(latMin, latMax));	
end

function GotLakes_FeatureGenerator:Default_AddOasisAtPlot(plot, iX, iY, lat)
	local terrainType = plot:GetTerrainType();		
	if (not ((self.bOasesOnDesert and (terrainType == g_TERRAIN_TYPE_DESERT)) or
			 (self.bOasesOnSnow   and (terrainType == g_TERRAIN_TYPE_SNOW  )) )) then
		return false;
	end
	if IsAdjacentToOasis(iX, iY) then
		return false;
	end
	
	local dice = TerrainBuilder.GetRandomNumber(100, "Add Oasis Lua");
	
	if (terrainType == g_TERRAIN_TYPE_SNOW) then
		return dice <= self.oasisSnowPct;
	end
	return (dice <= self.oasisPct);
end

function GotLakes_FeatureGenerator:Default_AddMarshAtPlot(plot, iX, iY, lat)
	-- Allow marsh on either flat grassland or flat plains.
	local terrainType = plot:GetTerrainType();	
	if (not ((terrainType == g_TERRAIN_TYPE_PLAINS) or 
			 (terrainType == g_TERRAIN_TYPE_GRASS))) then
		return false;
	end
    
    if (IsBaseTerrainType(g_TERRAIN_TYPE_PLAINS, terrainType) and
        (not (self.bMarshOnPlains or self.bGrass))) then
        -- Plains marsh disabled AND grass is disabled => cannot convert this plot to grass.
        return false;
    end
	
	-- Chance of marsh, depending on latitude.
	local marshVal = self.marsh:GetHeight(iX, iY);
	local marshPctWidth = Interpolate(lat, 
		self.marshMinLat, self.marshMaxLat, 
		(self.marshPct)/4, 0,
		math.sqrt);

	-- Split marsh fractal into two semi-snaky bands.
	local marshPassesFilter = 
			(((marshVal >= GetFractalHeight(self.marsh, 25-marshPctWidth))  and 
			  (marshVal <  GetFractalHeight(self.marsh, 25+marshPctWidth))) or
			 ((marshVal >= GetFractalHeight(self.marsh, 75-marshPctWidth))  and 
			  (marshVal <  GetFractalHeight(self.marsh, 75+marshPctWidth))));

	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotMarshDonut then
			-- Marsh donut filling
			-- Standard forest/jungle mix => pure marsh
			if (UserInput.forestJungl == ForestJungleLevels.STANDARD) then
				-- Pure marsh.
				return true;
			else
				-- Mixture of marsh and other features.
				return marshPassesFilter;
			end
			
		elseif self.gotWetDonut then
			-- Mixture of jungle/forest.
			return false;
			
		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end

	return marshPassesFilter;
end

function GotLakes_FeatureGenerator:Default_AddJunglesAtPlot(plot, iX, iY, lat)
	-- Allow jungles on plains, grassland, and maybe even desert.
	local terrainType = plot:GetTerrainType();
	if (not ((self.bJunglesOnDesert and 
			 ((terrainType == g_TERRAIN_TYPE_DESERT) or 
			  (terrainType == g_TERRAIN_TYPE_DESERT_HILLS))) or 
			  TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE))) then
		return false;
	end
    
    if (IsBaseTerrainType(g_TERRAIN_TYPE_GRASS, terrainType) and 
        (not (self.bJunglesOnGrass or self.bPlains))) then
        -- Grass Jungles disabled AND plains is disabled => cannot convert this grass to plains.
        return false;
    end
		
	-- Chance of jungle, depending on latitude.
	local jungleOffset = Interpolate(lat, 
		self.jungleMinLat, self.jungleMaxLat, 
		self.junglePct/2, 0,
		math.sqrt);
	local jungleBottom = GetFractalHeight(self.jungles, 50 - jungleOffset);
	local jungleTop    = GetFractalHeight(self.jungles, 50 + jungleOffset);
	
	local jungleVal = self.jungles:GetHeight(iX, iY);
	local junglePassesFilter = ((jungleVal >= jungleBottom) and (jungleVal < jungleTop));
	
	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotMarshDonut then 
			-- Marsh donut
			-- Possible mixture of marsh and jungle.
			if (UserInput.forestJungl > ForestJungleLevels.STANDARD) then
				-- Mix of marsh and jungle.
				return true;
			else
				-- Mix of marsh and forest.
				return false;
			end
			
		elseif self.gotWetDonut then
			-- Wet donut filling
			if (UserInput.forestJungl == ForestJungleLevels.VLOW) then
				-- Allow for pure forest.
				return false;
			elseif g_FEATURE_OPH_FUNGAL_FOREST and (UserInput.forestJungl == ForestJungleLevels.HIGH) then
				-- Allow for pure fungalfield; only place jungle where fungalfield is not allowed.
				return not TerrainBuilder.CanHaveFeature(plot, g_FEATURE_OPH_FUNGAL_FOREST);
			elseif (UserInput.forestJungl == ForestJungleLevels.VHIGH) then
				-- Pure jungle.
				return true;
			end
		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end
	return junglePassesFilter;
end

function GotLakes_FeatureGenerator:Default_AddFungalAtPlot(plot, iX, iY, lat)
	-- Add Fungalfield (from an OPH mod) using the jungle fractal.
    if not TerrainBuilder.CanHaveFeature(plot, g_FEATURE_OPH_FUNGAL_FOREST) then
        return false;
    end
    
	-- Chance of fungal field, depending on latitude.
	-- Reuse the jungle fractal so that jungle and fungalfields don't overlap.
	-- This improves rainfall responsiveness since jungles and fungalfields have similar latitude ranges.
	-- This will cause fungal fields to "surround" jungles.
	local jungleOffset = Interpolate(lat, 
		self.jungleMinLat, self.jungleMaxLat, 
		self.junglePct/2, 0,
		math.sqrt);
	local jungleBottom = GetFractalHeight(self.jungles, 50 - jungleOffset);
	local jungleTop    = GetFractalHeight(self.jungles, 50 + jungleOffset);

	local fungalOffset = Interpolate(lat, 
		self.fungalMinLat, self.fungalMaxLat, 
		self.fungalPct/2, 0,
		Square);
	local fungalBottom = GetFractalHeight(self.jungles, 50 - jungleOffset - fungalOffset);
	local fungalTop    = GetFractalHeight(self.jungles, 50 + jungleOffset + fungalOffset);


	local fungalVal = self.jungles:GetHeight(iX, iY);
	local fungalPassesFilter = ((fungalVal >= fungalBottom) and (fungalVal < jungleBottom)) or 
                               ((fungalVal >= jungleTop)    and (fungalVal < fungalTop));

	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotWetDonut then
			-- Wet donut filling
			if (UserInput.forestJungl == ForestJungleLevels.VLOW) then
				-- Allow for pure forest.
				return false;
			elseif (UserInput.forestJungl == ForestJungleLevels.HIGH) then
				-- Pure fungalfield.
				return true;
			end

		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end
	return fungalPassesFilter;
end

function GotLakes_FeatureGenerator:Default_AddSwampAtPlot(plot, iX, iY, lat)
	if not TerrainBuilder.CanHaveFeature(plot, g_FEATURE_HD_SWAMP) then
        return false;
    end
    
	-- Chance of swamp, depending on latitude.
    -- For the sake of simplicity use the same lat range as marsh.
	local swampVal = self.swamp:GetHeight(iX, iY);
	local swampPctWidth = Interpolate(lat, 
		self.marshMinLat, self.marshMaxLat, 
		(self.marshPct)/4, 0,
		math.sqrt);

	-- Split fractal into two semi-snaky bands.
	local swampPassesFilter = 
			(((swampVal >= GetFractalHeight(self.swamp, 25-swampPctWidth))  and 
			  (swampVal <  GetFractalHeight(self.swamp, 25+swampPctWidth))) or
			 ((swampVal >= GetFractalHeight(self.swamp, 75-swampPctWidth))  and 
			  (swampVal <  GetFractalHeight(self.swamp, 75+swampPctWidth))));

	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotMarshDonut then
			-- Marsh donut filling
			return false;
			
		elseif self.gotWetDonut then
			-- Mixture of jungle/forest.
			return false;
			
		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end

	return swampPassesFilter;
end

function GotLakes_FeatureGenerator:Default_AddForestsAtPlot(plot, iX, iY, lat)
	-- Allow forests adjacent to fresh lakes.
	local terrainType = plot:GetTerrainType();	
	if (not ((terrainType == g_TERRAIN_TYPE_PLAINS) or 
		     (terrainType == g_TERRAIN_TYPE_PLAINS_HILLS) or
			 (terrainType == g_TERRAIN_TYPE_GRASS) or 
		     (terrainType == g_TERRAIN_TYPE_GRASS_HILLS) or
			 (self.bForestsOnTundra and 
			  ((terrainType == g_TERRAIN_TYPE_TUNDRA) or 
		       (terrainType == g_TERRAIN_TYPE_TUNDRA_HILLS))) or
			 (self.bForestsOnDesert and 
			  ((terrainType == g_TERRAIN_TYPE_DESERT) or 
		       (terrainType == g_TERRAIN_TYPE_DESERT_HILLS))) or
			 (self.bForestsOnSnow and 
			  ((terrainType == g_TERRAIN_TYPE_SNOW) or 
			   (terrainType == g_TERRAIN_TYPE_SNOW_HILLS))) )) then
		return false;
	end
	
	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotWetDonut then
			-- Wet donut filling
			-- Whatever empty space remains after marsh, jungle, and fungalfield becomes forest.
			return true;

		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end
	
	-- Chance of forest, depending on latitude.
	local forestVal = self.forests:GetHeight(iX, iY);
	local pctWidth = (self.forestPct)/4;
	
	if (lat <= self.forestHMaxLat) then
		-- Hot forest interpolation: fade towards the equator.
		pctWidth = Interpolate(lat, 
			self.forestHMinLat, self.forestHMaxLat, 
			0, pctWidth,
			math.sqrt);
			
	elseif (lat >= self.forestCMinLat) then
		-- Cold forest interpolation: fade towards the pole.
		pctWidth = Interpolate(lat, 
			self.forestCMinLat, self.forestCMaxLat, 
			pctWidth, 0,
			math.sqrt);
	end
	
	local pctWidthHalf = pctWidth/2;
	
	-- Use multiple ranges to create a mixture of large and small forest clumps.
	return ((forestVal >=  GetFractalHeight(self.forests, 100-(2*pctWidth))) or
		    ((forestVal >= GetFractalHeight(self.forests, 12.5-pctWidthHalf)) and
		     (forestVal <  GetFractalHeight(self.forests, 12.5+pctWidthHalf))) or
		    ((forestVal >= GetFractalHeight(self.forests, 37.5-pctWidthHalf)) and
		     (forestVal <  GetFractalHeight(self.forests, 37.5+pctWidthHalf))));
end

function GotLakes_FeatureGenerator:Default_AddSavannahAtPlot(plot, iX, iY, lat)
	-- Add Savannah (from a JNR mod) using a fractal similar to forest.
    if not TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JNR_SAVANNAH) then
        return false;
    end
    
	-- Check donut land-feature filling after checking for applicable terrain.
	if ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES) then
		if self.gotWetDonut then
			-- Wet donut filling
			-- Whatever empty space remains after marsh, jungle, and forest 
            -- becomes savannah, which only spawns on desert.
			return true;

		elseif self.gotDryDonut then
			-- Donut filling that excludes this feature.
			return false;
		end
	end
	
	-- Chance of JNR Savannah, depending on latitude.
	local forestVal = self.savannahs:GetHeight(iX, iY);
	local pctWidth = (self.forestPct)/4;
	
	if (lat <= self.forestHMaxLat) then
		-- Hot forest interpolation: fade towards the equator.
		pctWidth = Interpolate(lat, 
			self.forestHMinLat, self.forestHMaxLat, 
			0, pctWidth,
			math.sqrt);
	end
	
	local pctWidthHalf = pctWidth/2;
	
	-- Use multiple ranges to create a mixture of large and small savannah clumps.
	return ((forestVal >=  GetFractalHeight(self.savannahs, 100-(2*pctWidth))) or
		    ((forestVal >= GetFractalHeight(self.savannahs, 12.5-pctWidthHalf)) and
		     (forestVal <  GetFractalHeight(self.savannahs, 12.5+pctWidthHalf))) or
		    ((forestVal >= GetFractalHeight(self.savannahs, 37.5-pctWidthHalf)) and
		     (forestVal <  GetFractalHeight(self.savannahs, 37.5+pctWidthHalf))));
end

function GotLakes_FeatureGenerator:Default_AddReefAtPlot(plot, iX, iY, lat)
	-- Reef Check. 
	if (self.gotFakeKelpDonut and 
	    ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES)) then
		-- Avoid reefs in fake kelp forest donut filling.
		return false;
	end
	
	-- First see if we can place it here.
	if ((lat < self.reefMaxLat) and 
	    TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF)) then
		-- Roll dice for a chance at a reef.
		local dice = TerrainBuilder.GetRandomNumber(100, "Add Reef Lua");
		if (dice <= self.reefPct) then
			return true;
		end
	end
	return false;
end

function GotLakes_FeatureGenerator:Default_AddKelpAtPlot(plot, iX, iY, lat)
	-- Kelp check.
	if (self.gotKelpDonut and 
	    ((self.donutFillingMap[GetPlotIndexLua(iX, iY)]) == FILLING_YES)) then
		-- Kelp forest donut filling.
		return true;
	end
	
	-- Chance of kelp forest, depending on latitude.
	local kelpVal = self.kelp:GetHeight(iX, iY);
	
	local peakLat = self.kelpPeakLat;
	local pctWidth = (self.kelpPct)/4;
	
	if (lat <= peakLat) then
		pctWidth = Interpolate(lat, 0, peakLat, 5, pctWidth, Square);
	else 
		pctWidth = Interpolate(lat, peakLat, 1, pctWidth, pctWidth/4);
	end
	
	local pctWidthHalf = pctWidth/2;
	
	-- Use multiple ranges to create a mixture of smaller clumps.
	return ((kelpVal  >= GetFractalHeight(self.kelp, 100-2*pctWidthHalf)) or
		    ((kelpVal >= GetFractalHeight(self.kelp, 62.5-pctWidthHalf)) and
		     (kelpVal <  GetFractalHeight(self.kelp, 62.5+pctWidthHalf))) or
			((kelpVal >= GetFractalHeight(self.kelp, 25-2*pctWidthHalf)) and
		     (kelpVal <  GetFractalHeight(self.kelp, 25+2*pctWidthHalf))));
end

function GotLakes_FeatureGenerator:Azimuthal_AddIceAtPlot(plot, iX, iY, lat)
	-- Default azimuthal.
	-- Overlap white noise with a fractal pattern.
	local gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	return self:FractalIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:Globe_AddIceAtPlot(plot, iX, iY, lat)
	-- Default ice for a globe map.
	-- Assuming we only have at most two rows at each vertical edge
	-- of the map, just use white noise for scarce ice tiles.
	local gotIce, icePhase = self:PolarRowsIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	return self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:Region_AddIceAtPlot(plot, iX, iY, lat)
	-- Region maps have no ice by default.
	return false, 0;
end

function GotLakes_FeatureGenerator:IceAgeAzimuthal_AddIceAtPlot(plot, iX, iY, lat)
	-- Ice Age azimuthal.
	if self.gotIceDonut then
		-- Donut landmass.
		local i = GetPlotIndexLua(iX, iY);
		if (self.donutFillingMap[i] == FILLING_YES) then
			-- Turn all donut filling water into ice.			
			local iceLoss = TerrainBuilder.GetRandomNumber(100, "White Noise Ice Loss");
			return true, self:GetIcePhase(iceLoss);
		end
	end
	
	-- Overlap white noise with a fractal pattern.
	local gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	return self:FractalIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:IceAgeGlobe_AddIceAtPlot(plot, iX, iY, lat)
	-- Ice Age globe.
	-- Top or bottom N rows of the map ==> frozen
	-- Overlap white noise with a fractal pattern.
	local gotIce, icePhase = self:PolarRowsIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	return self:FractalIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:IceAgeRegion_AddIceAtPlot(plot, iX, iY, lat)
	-- Ice Age region.	
	-- Use a non-interpolated fractal to cover the whole map with blobs of ice.
	if (self.ice:GetHeight(iX, iY) < self.iceLevel) then
		return false, 0;
	end
	
	local iceLoss = TerrainBuilder.GetRandomNumber(100, "White Noise Ice Loss");
	return true, self:GetIcePhase(iceLoss);
end

function GotLakes_FeatureGenerator:TiltedAxisGlobe_AddIceAtPlot(plot, iX, iY, lat)
	-- Tilted Axis Globe
	local iceNumRows = self.polarIceNumRows;
	if (iY >= self.iH - iceNumRows) then
		-- Top rows for cropped climate => frozen
		local iceLoss = 100; -- Permanent ice for tilted axis full
		if (UserInput.icyPoles == ICYPOLES_CROP) then
			-- Random ice melt for tilted axis cropped.
			iceLoss = TerrainBuilder.GetRandomNumber(100, "White Noise Ice Loss");
		end
		return true, self:GetIcePhase(iceLoss);
	end
	-- Don't bother with ice on the bottom rows,
	-- since the south pole is hot.
	
	-- Overlap white noise with a fractal pattern.
	local gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end	
	return self:FractalIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:TiltedAxisRegion_AddIceAtPlot(plot, iX, iY, lat)
	-- Tilted Axis region: overlap white noise with a fractal pattern.
	-- Reduce white noise so that the dark side is not completely covered in ice.
	local gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat, 50);
	if gotIce then
		return true, icePhase;
	end
	return self:FractalIceAtPlot(plot, iX, iY, lat);
end

function GotLakes_FeatureGenerator:TwoSuns_AddIceAtPlot(plot, iX, iY, lat)
	-- Two Suns: overlap white noise with a fractal pattern.
	local gotIce, icePhase = self:WhiteNoiseIceAtPlot(plot, iX, iY, lat);
	if gotIce then
		return true, icePhase;
	end
	return self:FractalIceAtPlot(plot, iX, iY, lat);	
end

function GotLakes_FeatureGenerator:AddFeaturesFromContinents()
    -- Add geothermal fissures and/or volcanic soil.
    local gotSoilFilling = 
		(gotDonut and 
		 (ExtrasGot.tectonic == true) and
		 (UserInput.biodiv   == Biodivs.VERYHIGH));
         
    local noGFissures = UserInput.noGFissures;
    
    if (noGFissures and (not gotSoilFilling)) then
        print("Skipping features from continents (no geothermal fissures).");
        return;
    end
    
    print("Adding features from continents.");

	local aPossibleFissureIndices:table = {};

	for y = 0, self.iH - 1, 1 do
		for x = 0, self.iW - 1, 1 do
			local i = y * self.iW + x;
			local plot = Map.GetPlot(x,y);
			if plot then
				local featureType = plot:GetFeatureType();

				if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
					--No Feature
				elseif (gotSoilFilling and 
					    (self.donutFillingMap[i+1] == FILLING_YES) and
						TerrainBuilder.CanHaveFeature(plot, g_FEATURE_VOLCANIC_SOIL)) then
					-- Volcanic soil donut filling!
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_VOLCANIC_SOIL);		
						
				elseif (TerrainBuilder.CanHaveFeature(plot, g_FEATURE_GEOTHERMAL_FISSURE) and
					Map.FindSecondContinent(plot, 3)) then
					table.insert(aPossibleFissureIndices, i);
				end
			end
		end
	end
    
    if noGFissures then
        print("Skipping geothermal fissures (no geothermal fissures).");
        return;
    end

    -- Lower denominator => more fissures.
    local fissureLevel = UserInput.gFissLevel or 3;
    local fissureDenoms = {400, 200, 100, 50, 25};
    local fissureDenom = fissureDenoms[fissureLevel] or 100;
	local iDesiredFissures = math.max(1, Round(self.iNumLandPlots / fissureDenom)); -- base game /200
    print("Desired number of fissures: ", iDesiredFissures);
    
	-- Place fissures near continent divides
	if (iDesiredFissures > 0 and #aPossibleFissureIndices > 0) then
		aShuffledIndices =  GetShuffledCopyOfTable(aPossibleFissureIndices);
		for i, index in ipairs(aShuffledIndices) do
			local pPlot = Map.GetPlotByIndex(index);
			TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_GEOTHERMAL_FISSURE);
			self.fissureCount = self.fissureCount + 1;
			--print ("Fissure Placed at " .. CoordString(pPlot:GetX(), pPlot:GetY()));
			if (self.fissureCount >= iDesiredFissures) then
				break
			end
		end
	end

	-- Still have fissures to place?  Add them anywhere
	if (iDesiredFissures > self.fissureCount) then
		local aFullMapFissureIndices:table = {};
		for y = 0, self.iH - 1, 1 do
			for x = 0, self.iW - 1, 1 do
				local i = y * self.iW + x;
				local plot = Map.GetPlotByIndex(i);
				if(plot ~= nil) then
					local featureType = plot:GetFeatureType();

					if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
						--No Feature
					else
						if (TerrainBuilder.CanHaveFeature(plot, 
								g_FEATURE_GEOTHERMAL_FISSURE)) then
							if (not Map.FindSecondContinent(plot, 3)) then
								table.insert(aFullMapFissureIndices, i);
							end
						end
					end
				end
			end
		end
		if (#aFullMapFissureIndices > 0) then
			aShuffledIndices =  GetShuffledCopyOfTable(aFullMapFissureIndices);
			for i, index in ipairs(aShuffledIndices) do
				local pPlot = Map.GetPlotByIndex(index);
				TerrainBuilder.SetFeatureType(pPlot, g_FEATURE_GEOTHERMAL_FISSURE);
				self.fissureCount = self.fissureCount + 1;
				--print ("Full-Map Fissure Placed at " .. CoordString(pPlot:GetX(), pPlot:GetY()));
				if (self.fissureCount >= iDesiredFissures) then
					break
				end
			end
		end
	end
	print("Number of Fissures: ", self.fissureCount)
end