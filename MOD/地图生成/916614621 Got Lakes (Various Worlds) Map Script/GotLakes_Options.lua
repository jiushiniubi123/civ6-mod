-- Map Options for Got Lakes Map Script
-- Author: Scrum Lord
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Map options
--
-- The order and numbering of these option constants must 
-- match the order in which the options appear in the 
-- CustomOptions list in OptionInfo.
------------------------------------------------------------------------------
MapOptions = 
{
    -- Base game options
	RESOURCES   = 1,  -- resource abundance
	START       = 2,  -- starting plots

	-- Landmass Shuffle
	CONTINENTS  = 3,
	ISLANDS     = 4,
	LAKES       = 5,
	PANGEA      = 6,

	-- Customization options
	MOUNTAINS   = 7,  -- mountain pattern
	MTNCLUMPS   = 8,  -- mountains
	RIVERS      = 9,  -- river pattern
	EXTRAS      = 10, -- Additional islands/lakes
	WORLDWRAP   = 11, -- wrap-x
	CLIMATEWRAP = 12, -- latitudes
	CLIMATE     = 13, -- mostly terrain
	BIOME       = 14, -- mostly features
	SUNLIGHT    = 15, -- latitudes, terrain, start plots
	ICYPOLES    = 16, -- terrain, map sizing, start plots

	-- Adjustment options
	LANDSTARTS  = 17, -- starting plots
	WATERSTARTS = 18, -- starting plots
	MINORSTARTS = 19, -- starting plots
	MTNLEVEL    = 20, -- mountains 
	HILLLEVEL   = 21, -- hills 
	VOLCLEVEL   = 22, -- volcanoes
    GFISSLEVEL  = 23, -- geothermal fissures
	SEALEVEL    = 24, -- land vs water
	LAKELEVEL   = 25, -- fresh lakes
	RIVERLEVEL  = 26, -- rivers
	CIRCUMNAV   = 27, -- land vs water
	COASTEXP    = 28, -- coastal expansion
    COASTLOWS   = 29, -- coastal lowlands
	TEMPERATURE = 30, -- latitude
    DESERTLEVEL = 31, -- latitude
	TUNDRALEVEL = 32, -- latitude
	RAINFALL    = 33, -- wet features
	KELPLEVEL   = 34, -- feature from Sukritact's Oceans
	KELPFORESTS = 35, -- feature from Sukritact's Oceans
	CLIMGRAN    = 36, -- terrain/feature fractals
	GRASSPLAINS = 37, -- grass vs plains
	FORESTJUNGL = 38, -- forest vs jungle
	BIODIV      = 39, -- terrain/feature combos
    
    -- Misc
	CONNECTLAND = 40, -- land vs water
    CONNECTSEAS = 41, -- land vs water
	ISOCOASTS   = 42, -- land vs water
    NOADDLAKES  = 43,  -- post-landmass lakes
	NOCOASTICE  = 44, -- ice
    NOCOASTMTS  = 45, -- mountains
	NODESERT    = 46, -- terrain
	NODFORESTS  = 47, -- features
	NODJUNGLES  = 48, -- features
	NODOASES    = 49, -- features
    NOFLOODPLNS = 50, -- features
    NOFORESTS   = 51, -- features
    NOGFISSURES = 52, -- features
	NOGRASS     = 53, -- terrain
	NOGJUNGLES  = 54, -- features
    NOHILLS     = 55, -- hills
	NOICE       = 56, -- ice
    NOJUNGLES   = 57, -- features
    NOMARSH     = 58, -- features
    NOMOUNTAINS = 59, -- mountains
	NOPLAINS    = 60, -- terrain
	NOPMARSH    = 61, -- features
	NOREEFS     = 62, -- features
    NORIVERS    = 63, -- rivers
	NOSNOW      = 64, -- terrain
	NOSFORESTS  = 65, -- features
	NOSOASES    = 66, -- features
	NOTUNDRA    = 67, -- terrain
	NOTFORESTS  = 68, -- features
    NOVOLCANOES = 69, -- volcanoes
    SCRALUX     = 70, -- resources
	THINMCEDGES = 71, -- mountains
	FRESHLAKES  = 72, -- land vs water
};

FIRST_LAND_OPT    = MapOptions.CONTINENTS;
LAST_LAND_OPT     = MapOptions.PANGEA;

-- Map names for Civ 6 option lookup.
-- The order of these names must match the order of the 
--corresponding map option indices.
MapOptionNames = 
{
    -- Base game options.
	"resources",  
	"start",

	-- Landmass families
	"continents",
	"islands",
	"lakes",
	"pangea",
    
	-- Customization options
	"mountains",   
	"mtn_clumps",
	"rivers",
	"extras", 
	"world_wrap",
	"climate_wrap",
	"climate",
	"biome",
	"sunlight",
	"icy_poles",    
    
	-- Adjustment options
	"land_starts",
	"water_starts",
	"minor_starts",
	"mtn_level",
	"hill_level",
    "volc_level",
    "geothermal_fissure_level",
	"sea_level",
	"lake_level",  
	"river_level",
	"circumnavigation",
	"coastal_expansion",
    "coastal_lowlands",
	"temperature",
    "desertlevel",
	"tundralevel",
	"rainfall",
	"kelp_level",
	"kelp_forests",
	"clim_gran",  
	"grassplains",
	"forestjungle",
	"biodiversity",    
    
    -- Misc
	"connect_lands",
    "connect_seas",
	"isolated_coasts",
    "no_add_lakes",
	"no_coastal_ice",
    "no_coastal_mountains",
	"no_desert",
	"no_desert_forests",
	"no_desert_jungles",
	"no_desert_oases",
    "no_floodplains",
    "no_forests",
    "no_geo_fissures",
	"no_grass",
	"no_grass_jungles",
    "no_hills",
	"no_ice",
    "no_jungles",
    "no_marsh",
    "no_mountains",
	"no_plains",
	"no_plains_marsh",
	"no_reefs",
    "no_rivers",
	"no_snow",
	"no_snow_forests",
	"no_snow_oases",
	"no_tundra",
	"no_tundra_forests",
    "no_volcanoes",
    "scrambled_luxuries",
	"thin_mtnclump_edges",
	"turn_seas_into_lakes",
};

-- Supported landmasses (possible values of UserInput.landmass)
Landmasses = 
{
	NONE        = 0,  -- MLF none
	ARCHIPELAGO = 1,  -- fractal
	BAGELS      = 2,  -- MLF bagels
	CLUSTERS    = 3,  -- MLF clusters
	CONTINENTS  = 4,  -- fractal continents
	DONUT       = 5,  -- MLF donut
	FRACTAL     = 6,  -- fractal
    HEX         = 7,  -- MLF hex
	INLANDSEA   = 8,  -- MLF inland sea
    INVDONUT    = 9,  -- MLF inverted donut
	INVEXTRAS   = 10, -- MLF inverted extras
	ISLEPLATES  = 11, -- MLF island plates
	LAKES       = 12, -- MLF lakes
	LRGISLES    = 13, -- MLF large isles
	LRGLAKES    = 14, -- MLF lakes
	MAZE        = 15, -- MLF maze
    MEGACLUSTER = 16, -- MLF clusters
	MINIDONUTS  = 17, -- MLF mini Donuts
	NOODLES     = 18, -- MLF noodles
    NUMCONTS    = 19, -- MLF numerous
	OVAL        = 20, -- MLF oval
	PANGEA      = 21, -- fractal pangea
	SEVENSEAS   = 22, -- MLF Lakes
	SMALLCONTS  = 23, -- fractal
	SNAKE       = 24, -- MLF snake
};

-- Common levels for spanning very low to very high.
local VeryLowVeryHighLevels =
{
	VLOW     = 1,
	LOW      = 2,
	STANDARD = 3,
	HIGH     = 4,
	VHIGH    = 5
};

-- Option value names for very low - very high.
VeryLowVeryHighOptionValues = 
{
	"Very Low",
	"Low", 
	"Standard", 
	"High", 
	"Very High",
	"Random Low-High",
	"Random"
};
------------------------------------------------------------------------------
-- Possible non-random values for options
------------------------------------------------------------------------------
-- Base Game options
-- Map Size IDs for mapping worldSize hash to a named map size.
MAPSIZE_DUEL     = "MAPSIZE_DUEL";
MAPSIZE_TINY     = "MAPSIZE_TINY";
MAPSIZE_SMALL    = "MAPSIZE_SMALL";
MAPSIZE_STANDARD = "MAPSIZE_STANDARD";
MAPSIZE_LARGE    = "MAPSIZE_LARGE";
MAPSIZE_HUGE     = "MAPSIZE_HUGE";

-- Start Position.
START_BALANCED = 1;
START_NORMAL   = 2;
START_LEGEND   = 3;

-- Customizations
-- Mountain patterns
MtnPatterns = 
{
	TECTONIC  = 1, -- tectonic a.k.a. normal
	FRACTAL   = 2, -- fractal, snaky ranges
	SCATTERED = 3, -- fractal, lone mountains and hills
	CLUSTERED = 4, -- fractal, groups of mountains / hills
	UNCANNY   = 5, -- fractal, double-ranges (valleys)
	WINDING   = 6, -- fractal, pockets of non-mountains
	ALL       = 7  -- a mixture of all mountain patterns
};

-- What to do with mountain clumps
MountainClumps = 
{
	FULL   = 1,
	MAZE   = 2,
	HOLLOW = 3
};

-- River patterns
RiverPatterns = 
{
	SIMPLE   = 1, -- simple, straightforward
	DETAILED = 2, -- additional branches and winding
	BRANCHY  = 3, -- extra-branchy
	SNAKY    = 4, -- extra-winding
	ALL      = 5  -- a mixture of all river patterns
};

-- Extras
ExtraIslesLakes = 
{
	NONE     = 1, -- No extra islands
	CHAINS   = 2, -- Chains of islands (based on "plus" maps)
	CLUSTERS = 3, -- Dense clusters of islands
	DONUTS   = 4, -- Mini Donuts
	SPRNKLES = 5, -- Sprinkles
	TECTONIC = 6, -- Tectonic islands
	TCHAINS  = 7, -- Chains and Tectonic islands
	ALL      = 8, -- All types of extra islands
};
NUM_EXTRAS_OPTS = ExtraIslesLakes.ALL;

-- World Wrap & Climate Wrap
WWRAP_AZIMUTH = 1; -- azimuthal (for climate wrap)
WWRAP_GLOBE   = 2; -- wrap-x only
WWRAP_REGION  = 3; -- no wrap
WWRAP_SAME    = 4; -- same as world wrap (for climate wrap)
WWRAP_RANDAG  = 5; -- random azimuthal or globe (for climate wrap)
WWRAP_RANDAR  = 6; -- random azimuthal or region (for climate wrap)

Climates = 
{
	SNOWBALL   = 1,
	ICEAGE     = 2,
	STANDARD   = 3,
	GREENHOUSE = 4,
	SANDSTORM  = 5,
};

Biomes = 
{
	ARBOREA  = 1,
	PRAIRIE  = 2,
	STANDARD = 3,
	WETLAND  = 4,
};

Sunlights = 
{
	STANDARD = 1,
	TILTED   = 2,
	TWOSUNS  = 3,
};

ICYPOLES_CROP = 1;
ICYPOLES_FULL = 2;


-- Adjustments
LandStarts = 
{
	LARGEST  = 1,
	STANDARD = 2,
	SEPARATE = 3,
	LANDBASE = 4,
};

WaterStarts = 
{
	LARGEST  = 1,
	STANDARD = 2,
	SEPARATE = 3,
	LANDBASE = 4,
	ONLAND   = 5,
};

MinorStarts = 
{
	LARGEST  = 1,
	STANDARD = 2,
	SEPARATE = 3,
	MAJOR    = 4,
	LAND     = 5,
};

MountainLevels = VeryLowVeryHighLevels;

HillLevels = 
{
	VLOW     = 1,
	LOW      = 2,
	STANDARD = 3,
	HIGH     = 4,
	VHIGH    = 5,
	MTNS     = 6
};

VolcanoLevels = 
{
	VLOW     = 1,
	LOW      = 2,
	STANDARD = 3,
	HIGH     = 4,
	VHIGH    = 5,
	MTNS     = 6,
	HILLS    = 7
};

SeaLevels         = VeryLowVeryHighLevels;
LakeLevels        = VeryLowVeryHighLevels;
RiverLevels       = VeryLowVeryHighLevels;

Circumnavigation = 
{
	NONE     = 1,
	EDGES    = 2,
	PATHS    = 3,
	BOTH     = 4,
	LANDBASE = 5,
};

CoastalExpansion = 
{
	NONE       = 1,
	VLOW       = 2,
	LOW        = 3,
	STANDARD   = 4,
	HIGH       = 5,
	VHIGH      = 6,
	EVERYWHERE = 7
};

CoastalLowlands = 
{
	NONE       = 1,
	STANDARD   = 2,
	INLAND     = 3,
	DELUGE     = 4,
	CATACLYSM  = 5,
	HFTH       = 6,
	EVERYWHERE = 7
};

TemperatureLevels = VeryLowVeryHighLevels;
DesertLevels      = VeryLowVeryHighLevels;
TundraLevels      = VeryLowVeryHighLevels;

RainfallLevels    = VeryLowVeryHighLevels;

KelpLevels = 
{
	VLOW     = 1,
	LOW      = 2,
	STANDARD = 3,
	HIGH     = 4,
	VHIGH    = 5,
	RAINFALL = 6
};

KelpForests = 
{
	NONE     = 1,
	STANDARD = 2,
	CREEP    = 3
};

ClimateGrans = 
{
	VCOARSE  = 1,
	COARSE   = 2,
	STANDARD = 3,
	FINE     = 4,
	VFINE    = 5,
	MIXEDCF  = 6,
	MIXED    = 7
};

GrassPlainsLevels  = VeryLowVeryHighLevels;
ForestJungleLevels = VeryLowVeryHighLevels;

Biodivs = 
{
	VERYLOW  = 1, -- no desert oases, no tundra forest
	LOW      = 2, -- base game
	STANDARD = 3, -- grass-jungles, plains-marsh
	HIGH     = 4, -- desert-jungles, snow-forest
	VERYHIGH = 5, -- desert-forest, snow-oases
	CLIMBASE = 6,
};

-- Misc options / compatibility with other mods.
-- Option name for Yet (not) Another Map Pack's "No Ice Near Land" checkbox.
YNAMP_OPTNAME_NO_COASTAL_ICE = "NoIceAdjacentToLand";
------------------------------------------------------------------------------
-- Biodiversity configs
-- Controls which terrain-feature combos are enabled/disabled by biodiversity.
------------------------------------------------------------------------------
BiodivInfo = 
{
	default = 
	{
		-- Standard combos for Got Lakes.
		desertOasis  = true,
		tundraForest = true,
		
		grassJungle  = true,
		plainsMarsh  = true,
	
		desertJungle = false,
		snowForest   = false,

		desertForest = false,
		snowOasis    = false,
	},
	
	veryLow = 
	{
		desertOasis  = false,
		tundraForest = false,
		
		grassJungle  = false,
		plainsMarsh  = false,
	},
	
	low = 
	{		
		grassJungle  = false,
		plainsMarsh  = false,
	},
	
	high = 
	{	
		desertJungle = true,
		snowForest   = true,
	},
	
	veryHigh = 
	{	
		desertJungle = true,
		snowForest   = true,

		desertForest = true,
		snowOasis    = true,
	},
};
------------------------------------------------------------------------------
-- User input globals to indicate chosen map configuration
-- These determine various choices such as function args, 
-- method overrides, and conditional statements.
------------------------------------------------------------------------------
-- User selections for map options
UserInput = 
{
	-- Landmass Shuffle
	landmass    = nil,

	-- Customizations
	mountains   = nil,
	mtnClumps   = nil,
	rivers      = nil,
	extras      = nil,
	worldWrap   = nil,
	climateWrap = nil,
	climate     = nil,
	biome       = nil,
	sunlight    = nil,
	icyPoles    = nil,

	-- Adjustments
	resources   = nil,
	start       = nil,
	landStarts  = nil,
	waterStarts = nil,
	minorStarts = nil,
	mtnLevel    = nil,
	hillLevel   = nil,
	volcLevel   = nil,
    gFissLevel  = nil,
	seaLevel    = nil,
	lakeLevel   = nil,
	riverLevel  = nil,
	circumnav   = nil,
	coastExp    = nil,
    coastLows   = nil,
	temperature = nil,
    desertLevel = nil,
	tundraLevel = nil,
	rainfall    = nil,
	kelpLevel   = nil,
	kelpForests = nil,
	climGran    = nil,
	grassPlains = nil,
	forestJungl = nil,
	biodiv      = nil,
    
    -- Misc options
	connectLand = nil,
    connectSeas = nil,
	isoCoasts   = nil,
    noAddLakes  = nil,
	noCoastIce  = nil,
    noCoastMts  = nil,
	noDesert    = nil,
	noDForests  = nil,
	noDJungles  = nil,
	noDOases    = nil,
    noFloodplns = nil,
    noForests   = nil,
    noGFissures = nil,
	noGrass     = nil,
	noGJungles  = nil,
    noHills     = nil,
	noIce       = nil,
    noJungles   = nil,
    noMarsh     = nil,
    noMountains = nil,
	noPlains    = nil,
	noPMarsh    = nil,
	noReefs     = nil,
    noRivers    = nil,
	noSnow      = nil,
	noSForests  = nil,
	noSOases    = nil,
	noTundra    = nil,
	noTForests  = nil,
    noVolcanoes = nil,
    scraLux     = nil,
	thinMCEdges = nil,
	freshLakes  = nil,
};

-- Convenience vars for user's choice of extra islands/lakes.
ExtrasGot = 
{
	chains       = nil,
	clusters     = nil,
	miniDonuts   = nil,
	sprinkles    = nil,
	tectonic     = nil,
	tecAndChains = nil,
	anything     = nil,
	everything   = nil
};

-- Whether to enforce circumnavigation.
gotCircumnav = nil;

-- Convenience vars for groups of options 
gotLakesFamily  = nil;
gotPangeaFamily = nil;
gotIceAgeFamily = nil;
gotTiltedFamily = nil;
------------------------------------------------------------------------------
-- Helper functions
------------------------------------------------------------------------------
function AdjustWorldHeight(sizeInfo, adjustment)
	-- Adjust settings for world size info.
	--
	-- Args:
	--   sizeInfo: info to adjust
	--   adjustment: multiply height and data by this much
	--
	-- Return adjusted size info
	
	-- Adjust height, rounding to nearest even integer.
	sizeInfo.size[2] = 2*Round(sizeInfo.size[2]*adjustment/2);

	return sizeInfo;
end

function CalculateWorldSizeInfo(width, height)
	-- Calculate world size info based on grid size.
	local mapSize = GetCalculatedMapSize(width, height);
	
	-- Base granularity for fractals that scale with map size.
	-- {0,0,1,1,2,2,3,3,4,4,5,5} original scale
	-- {0,0,0,1,1,1,2,2,2,3,3,3}
	local baseGrain = math.ceil(mapSize/3) - 1;
	
	-- Plate values > 39 might crash the system, so just use piecewise.
	local numRPlatesVals = {4,8,16,20,24,32,36};
	
	-- Target size for island clusters
	local clusterSize = 5 * (mapSize+1);
    
	local numExtraDonutsVals = {3,6};
	local numExtraDonuts     = mapSize*2;
		
	local sizeInfo = 
	{
		-- Map size as {Width (east-to-west), Height (north-to-south)}
		size = {width, height}, -- Civ V: {84, 52},
		
		-- Indicates whether we have a custom map size
		isCustom = false,
		
		-- A simple linear scale starting at 1 for duel, 2 for tiny, etc.
		index = mapSize,
		
		-- The default number of civs for the map size.
		numCivs = mapSize * 2,
		
		-- Base granularity for fractals that scale with map size.
		fracGrain    = baseGrain,
		
		-- Number of plates in Fractal World's ridges
		numRPlates = numRPlatesVals[mapSize] or 36,
		
		-- Island Clusters configuration.
		targetClusterSize = clusterSize,
        
		-- Mini-Donut configuration.
		numExtraDonuts = numExtraDonuts,
	};
	
	print("===========================================");
	print("World Size Info:");
	print("-------------------------------------------");
	print("General:");
	print("  Suggested Num Major Civs: ".. sizeInfo.numCivs);
	print("  Fractal grain:            ".. sizeInfo.fracGrain);
	print("-------------------------------------------");
	print("Landmass:");
	print("  Num fractal ridges: ".. sizeInfo.numRPlates);
	print("-------------------------------------------");
	print("Extras:");
	print("  Target cluster size: ".. sizeInfo.targetClusterSize);
	print("  Num extra donuts:    ".. sizeInfo.numExtraDonuts);
	print("===========================================");

	return sizeInfo;
end

function GetCalculatedMapSize(width, height)
	-- Map grid size to linear index using number of tiles.
	
	-- Size buckets mapped to number of tiles and midpoint thresholds for reference:
	-- duel     = 44 *26  = 1144  < 1712
	-- tiny     = 60 *38  = 2280  < 2842
	-- small    = 74 *46  = 3404  < 3970
	-- standard = 84 *54  = 4536  < 5148
	-- large    = 96 *60  = 5760  < 6378
	-- huge     = 106*66  = 6996  < 7790
	-- massive  = 116*74  = 8584  < 9412
	-- enormous = 128*80  = 10240 < 11280
	-- 18p      = 140*88  = 12320 < 13456
	-- 20p      = 152*96  = 14592 < 15824
	-- 22p      = 164*104 = 17056 < 18384
	-- 24p      = 176*112 = 19712
	
	-- The function of numTiles vs world size is a parabola:
	-- numTiles = y = ax^2 + bx + c
	--
	-- Use quadratic formula to solve for x.
	-- Coefficients are based on a MS Excel quadratic trendline of map sizes.
	local a = 88.068;
	local b = 496.71;
	local c = 886.36;
	
	local numTiles = width * height;
	
	-- Use the positive end of the quadratic inverse.
	local index = Round((-b + math.sqrt(b*b - 4*a*(c-numTiles)))/(2*a));
	
	-- Don't allow tiny maps to become smaller than duel.
	index = math.max(1,index);
	
	print("Grid size " .. CoordString(width, height) .." -> map size #" .. index);
	return index;
end

function GetLandmassFamilyOption(familyName, default, infos)
	-- Generate a landmass family shuffle option, given the following params:
	--   familyName: family name
	--   default: default value for the family option
	--   infos: references to landmasses or climates in a global info struct
	--
	-- A map shuffle can have multiple families of options, such as continents,
	-- islands, lakes, and pangeas.
	local values = {};
	
	-- Generate choices based on info structs.
	for i, info in ipairs(infos) do								 
		table.insert(values, info.name);
	end
	
	-- Add all/none choices.
	table.insert(values, "All");
	table.insert(values, "None");
	
	local defaultVal = default;
	if (defaultVal < 0) then
		-- Negative default means all or none.
		defaultVal = table.maxn(infos) - default;
	end
	
	local option = 
	{
		Infos        = infos,
		Name         = familyName,
		Values       = values,
		DefaultValue = defaultVal,
	};
	
	return option;
end

function InitHelperFlags()
	-- Init global convenience flags based on user input.
	ExtrasGot.chains = 
		(UserInput.extras == ExtraIslesLakes.CHAINS) or
		(UserInput.extras == ExtraIslesLakes.TCHAINS) or
		(UserInput.extras == ExtraIslesLakes.ALL);
		
	ExtrasGot.clusters = 
		(UserInput.extras == ExtraIslesLakes.CLUSTERS) or
		(UserInput.extras == ExtraIslesLakes.ALL);
		
	ExtrasGot.miniDonuts = 
		(UserInput.extras == ExtraIslesLakes.DONUTS) or
		(UserInput.extras == ExtraIslesLakes.ALL);	

	ExtrasGot.sprinkles = 
		(UserInput.extras == ExtraIslesLakes.SPRNKLES) or
		(UserInput.extras == ExtraIslesLakes.ALL);
		
	ExtrasGot.tectonic = 
		(UserInput.extras == ExtraIslesLakes.TECTONIC) or
		(UserInput.extras == ExtraIslesLakes.TCHAINS) or
		(UserInput.extras == ExtraIslesLakes.ALL);
	
	ExtrasGot.tecAndChains	= 
		(UserInput.extras == ExtraIslesLakes.TCHAINS);
		
	ExtrasGot.everything = 
		(UserInput.extras == ExtraIslesLakes.ALL);	
		
	ExtrasGot.anything = 
		(ExtrasGot.chains     or 
		 ExtrasGot.clusters   or 
		 ExtrasGot.miniDonuts or 
		 ExtrasGot.sprinkles  or
		 ExtrasGot.tectonic);
	
	gotCircumnav =
		(UserInput.circumnav ~= Circumnavigation.NONE);
    
    gotDonut = 
        (UserInput.landmass == Landmasses.DONUT) or
        (UserInput.landmass == Landmasses.INVDONUT);
    
	gotLakesFamily = 
		(UserInput.landmass == Landmasses.INLANDSEA) or
		(UserInput.landmass == Landmasses.INVEXTRAS) or
		(UserInput.landmass == Landmasses.LAKES) or
		(UserInput.landmass == Landmasses.LRGLAKES) or
		(UserInput.landmass == Landmasses.SEVENSEAS);
        
    gotPangeaFamily = 
		(UserInput.landmass == Landmasses.DONUT) or
		(UserInput.landmass == Landmasses.MAZE) or
		(UserInput.landmass == Landmasses.OVAL) or
		(UserInput.landmass == Landmasses.PANGEA) or
		(UserInput.landmass == Landmasses.SNAKE);
	
	gotIceAgeFamily = 
		(UserInput.climate == Climates.ICEAGE) or 
		(UserInput.climate == Climates.SNOWBALL);
		
	gotTiltedFamily = (UserInput.sunlight ~= Sunlights.STANDARD);
end