-- Got Lakes Map Script - a highly customizable random map generator
-- Author: Scrum Lord
-- Compatibility: Civ VI - Vanilla, R&F, GS, NFP, LP
------------------------------------------------------------------------------
include "NaturalWonderGenerator"
include "CoastalLowlands"
include "ResourceGenerator"
include "FeatureGenerator" -- included to fix NPE in YnAMP's AssignStartingPlots
include "AssignStartingPlots"
include "GotLakes_ASP"
include "GotLakes_Circumnavigation"
include "GotLakes_CoastalLowlands"
include "GotLakes_Coasts"
include "GotLakes_ContinentStamper"
include "GotLakes_Extras"
include "GotLakes_FeatureGen"
include "GotLakes_MountainsHills"
include "GotLakes_Options"
include "GotLakes_PassMaker"
include "GotLakes_RiversLakes"
include "GotLakes_TerrainGen"
include "GotLakes_Utils"
------------------------------------------------------------------------------
-- Got Lakes version info for debugging
------------------------------------------------------------------------------
local glVersion = "37.2";
------------------------------------------------------------------------------
-- Map Option defaults
------------------------------------------------------------------------------
-- On/Off switch for UI options.
-- Set to true to control options with the Advanced Options menu.
-- Set to false to control options with hard-coded defaults.
local ENABLE_UI = true;

local GOT_ALL  = -1;
local GOT_NONE = -2;

-- Hard-Coded Defaults for development/debugging.
--
-- If ENABLE_UI is false then you can use these settings instead of the
-- Advanced Options menu. To re-roll your map, simply edit the settings,
-- save changes, and click Restart in the in-game/WB menu.
local MapDefaults = 
{
    --------------------------------------------------------------------------
    -- Base Game options
    --------------------------------------------------------------------------
    -- Additional values may be possible depending on what other mods you
    -- have installed.
  
    -- Resources
    -- 1 = sparse,   2 = standard, 3 = abundant, 4 = random
    RESOURCES = 2, -- 2
    
    -- Start positions
    -- 1 = balanced, 2 = standard, 3 = legendary
    START = 2, -- 2
    
    --------------------------------------------------------------------------
    -- Landmasses
    -- Use numbers, GOT_NONE, or GOT_ALL
    --------------------------------------------------------------------------
    -- Continents Family
    -- 1 = bagels,      2 = conts,       3 = fractal,
    -- 4 = noodles,     5 = numerous,    6 = small
    CONTINENTS = GOT_NONE,
    --------------------------------------------------------------------------
    -- Islands Family
    -- 1 = archipelago, 2 = clusters,    3 = iplates,
    -- 4 = large,       5 = megacluster, 6 = mini-donuts
    ISLANDS    = GOT_NONE,
    --------------------------------------------------------------------------
    -- Lakes Family
    -- 1 = inland sea,  2 = inv donut,   3 = inv extras
    -- 4 = lakes,       5 = large,       6 = seven seas
    LAKES      = GOT_NONE,
    --------------------------------------------------------------------------
    -- Pangea Family
    -- 1 = donut,       2 = hex,         3 = maze,
    -- 4 = oval,        5 = pangea,      6 = snake  
    PANGEA     = GOT_NONE,
    
    --------------------------------------------------------------------------
    -- Customizations
    --------------------------------------------------------------------------
    -- Mountains:
    -- 1 = tectonic plates,     2 = fractal ranges,  3 = scattered crags,
    -- 4 = clustered highlands, 5 = uncanny valleys, 6 = winding canyons,
    -- 7 = everything,          8 = random moderate, 9 = random
    MOUNTAINS = 1, -- 1

    -- Mountain Clumps:
    -- 1 = full, 2 = maze, 3 = hollow, 4 = random maze/hollow, 5 = random
    MTNCLUMPS = 2, -- 2

    -- Rivers:
    -- 1 = simple, 2 = detailed,   3 = branchy, 
    -- 4 = snaky,  5 = everything, 6 = random
    RIVERS = 1, -- 1
    
    -- Extras:
    -- 1 = none,             2 = chains,     3 = clusters,     4 = mini-donuts,
    -- 5 = sprinkles,        6 = tectonic,   7 = tec & chains, 8 = everything, 
    -- 9 = random moderate, 10 = random
    EXTRAS = 1, -- 1
    
    -- World Wrap: 
    -- 1 = globe, 2 = region, 3 = random
    WORLDWRAP = 1, -- 1
    
    -- Climate Wrap:
    -- 1 = azimuthal,           2 = globe,                  3 = region, 
    -- 4 = same as world wrap,  5 = random azimuthal/globe, 6 = random azimuthal/region
    -- 7 = random globe/region, 8 = random
    CLIMATEWRAP = 4, -- 4
    
    -- Climate:
    -- 1 = snowball,   2 = ice age,   3 = standard, 
    -- 4 = greenhouse, 5 = sandstorm, 6 = random ice age to greenhouse,
    -- 7 = random
    CLIMATE = 3, -- 3
    
    -- Biome:
    -- 1 = arborea, 2 = prairie, 3 = standard, 
    -- 4 = wetland, 5 = random
    BIOME = 3, -- 3
    
    -- Sunlight:
    -- 1 = standard, 2 = tilted Axis, 
    -- 3 = two suns, 4 = random
    SUNLIGHT = 1, -- 1
    
    -- Icy Poles:
    -- 1 = cropped, 2 = standard, 3 = random
    ICYPOLES = 2, -- 2    
    
    --------------------------------------------------------------------------
    -- Adjustments
    --------------------------------------------------------------------------
    -- Land starts
    -- 1 = largest area,   2 = standard,                3 = separate areas, 
    -- 4 = landmass-based, 5 = random largest-separate, 6 = random
    LANDSTARTS = 4, -- 4
    
    -- Water starts
    -- 1 = largest area,   2 = standard, 3 = separate areas, 
    -- 4 = landmass-based, 5 = on land,  6 = random largest-separate, 7 = random
    WATERSTARTS = 4, -- 4
    
    -- Minor starts
    -- 1 = largest area, 2 = standard,     3 = separate areas, 
    -- 4 = major areas,  5 = same as land, 6 = random largest-separate, 7 = random
    MINORSTARTS = 2, -- 2

    -- Mountain level:
    -- 1 = very low,        2 = low,   3 = standard, 4 = high, 5 = very high, 
    -- 6 = random low-high, 7 = random
    MTNLEVEL    = 3, -- 3
    
    -- Hill Level:
    -- 1 = very low,  2 = low,             3 = standard, 4 = high, 5 = very high, 
    -- 6 = mtn level, 7 = random low-high, 8 = random
    HILLLEVEL   = 6, -- 6
    
    -- Volcano Level:
    -- 1 = very low,   2 = low,        3 = standard,        4 = high,  5 = very high,   
    -- 6 = mtn level,  7 = hill level, 8 = random low-high, 9 = random
    VOLCLEVEL   = 6, -- 6
    
    -- Geothermal Fissure level:
    -- 1 = very low,        2 = low,   3 = standard, 4 = high, 5 = very high, 
    -- 6 = random low-high, 7 = random
    GFISSLEVEL  = 3, -- 3
    
    -- Sea Level, etc.
    -- 1 = very low,        2 = low,   3 = standard, 4 = high, 5 = very high, 
    -- 6 = random low-high, 7 = random
    SEALEVEL    = 3, -- 3
    LAKELEVEL   = 3, -- 3
    RIVERLEVEL  = 3, -- 3
    
    -- Circumnavigation:
    -- 1 = none,           2 = edges,                     3 = paths, 4 = edges and paths,
    -- 5 = landmass-based, 6 = random edges and/or paths, 7 = random
    CIRCUMNAV = 5, -- 5
    
    -- Coastal Expansion:
    -- 1 = none,       2 = very low,        3 = low, 
    -- 4 = standard,   5 = high,            6 = very high,
    -- 7 = everywhere, 8 = random low-high, 9 = random
    COASTEXP = 4, -- 4
    
    -- Coastal Lowlands:
    -- 1 = none,       2 = standard         3 = inland, 
    -- 4 = deluge,     5 = cataclysm,       6 = head for the hills,
    -- 7 = everywhere, 8 = random moderate, 9 = random
    COASTLOWS = 3, -- 3
    
    -- Temperature, etc:
    -- 1 = very low,        2 = low,   3 = standard, 4 = high, 5 = very high, 
    -- 6 = random low-high, 7 = random
    TEMPERATURE = 3, -- 3
    DESERTLEVEL = 3, -- 3
    TUNDRALEVEL = 3, -- 3
    RAINFALL    = 3, -- 3
    
    -- Kelp Forest Level
    -- 1 = very low, 2 = low,             3 = standard, 4 = high, 5 = very high
    -- 6 = rainfall, 7 = random low-high, 8 = random
    KELPLEVEL = 6, -- 6    
    
    -- Kelp Forests from Sukritact's Oceans:
    -- 1 = none, 2 = standard, 3 = creep, 4 = random standard/creep, 5 = random
    KELPFORESTS = 2, -- 2
    
    -- Climate Granularity:
    -- 1 = very coarse, 2 = coarse,             3 = standard
    -- 4 = fine,        5 = very fine,          6 = mixed coarse-fine
    -- 7 = mixed,       8 = random coarse-fine, 9 = random
    CLIMGRAN = 3, -- 3
    
    -- Grass/Plains mix:
    -- 1 = ++grass,    2 = +grass, 3 = standard, 4 = +plains, 5 = ++plains, 
    -- 6 = random 2-4, 7 = random
    GRASSPLAINS = 3, -- 3
    
    -- Forest/Jungle mix:
    -- 1 = ++forest,    2 = +forest, 3 = standard, 4 = +jungle, 5 = ++jungle, 
    -- 6 = random 2-4, 7 = random
    FORESTJUNGL = 3, -- 3
    
    -- Biodiversity:
    -- 1 = very Low,        2 = low,       3 = standard,
    -- 4 = high,            5 = very high, 6 = climate based
    -- 7 = random low-high, 8 = random
    BIODIV = 6, -- 6
    
    --------------------------------------------------------------------------
    -- Misc Switches
    --------------------------------------------------------------------------
    CONNECTLAND = false, -- true = connect all lands with random straits
    CONNECTSEAS = false, -- true = connect all saltwater oceans/seas with random channels
    ISOCOASTS   = false, -- true = isolate coasts of lands separated by water
    NOADDLAKES  = false, -- true = prevent post-landmass lakes
    NOCOASTICE  = false, -- true = remove coastal ice
    NOCOASTMTS  = false, -- true = replace coastal mountains with hills
    NODESERT    = false, -- true = prevent desert
    NODFORESTS  = false, -- true = prevent forests on desert
    NODJUNGLES  = false, -- true = prevent jungles on desert
    NODOASES    = false, -- true = prevent oases on desert
    NOFLOODPLNS = false, -- true = prevent non-wonder floodplains
    NOFORESTS   = false, -- true = prevent non-wonder forests
    NOGFISSURES = false, -- true = prevent non-wonder geothermal fissures
    NOGRASS     = false, -- true = prevent grass
    NOGJUNGLES  = false, -- true = prevent grass under jungle
    NOHILLS     = false, -- true = prevent non-wonder hills
    NOICE       = false, -- true = remove ice
    NOJUNGLES   = false, -- true = prevent jungles
    NOMARSH     = false, -- true = prevent marsh
    NOMOUNTAINS = false, -- true = prevent non-wonder, non-volcano mountains
    NOPLAINS    = false, -- true = prevent plains
    NOPMARSH    = false, -- true = prevent plains under marsh
    NOREEFS     = false, -- true = remove non-wonder reefs
    NORIVERS    = false, -- true = prevent rivers
    NOSNOW      = false, -- true = prevent snow
    NOSFORESTS  = false, -- true = prevent forests on snow
    NOSOASES    = false, -- true = prevent oases on snow
    NOTUNDRA    = false, -- true = prevent tundra
    NOTFORESTS  = false, -- true = prevent forests on tundra
    NOVOLCANOES = false, -- true = prevent non-wonder volcanoes
    SCRALUX     = false, -- true = scrambled land luxuries
    THINMCEDGES = false, -- true = thin mountain clump edges
    FRESHLAKES  = false, -- true = turn salt water into fresh lakes
};
------------------------------------------------------------------------------
-- Map Sizing - overrides to standard map sizes.
------------------------------------------------------------------------------
-- GL's linear scale for standard map sizing.    
local PreferredSizes = 
{
    DUEL     = {width = 44,   height = 26},
    TINY     = {width = 60,   height = 38},
    SMALL    = {width = 74,   height = 46},
    STANDARD = {width = 84,   height = 54},
    LARGE    = {width = 96,   height = 60},
    HUGE     = {width = 106,  height = 66},
    MASSIVE  = {width = 116,  height = 74},
}

-- Standard sizes mapped to GL's preferred dimensions.    
local PREFERRED_STD_SIZES = 
{
    [MAPSIZE_DUEL]      = PreferredSizes.DUEL,
    [MAPSIZE_TINY]      = PreferredSizes.TINY,
    [MAPSIZE_SMALL]     = PreferredSizes.SMALL,
    [MAPSIZE_STANDARD]  = PreferredSizes.STANDARD,
    [MAPSIZE_LARGE]     = PreferredSizes.LARGE,
    [MAPSIZE_HUGE]      = PreferredSizes.HUGE
};

-- Sizes mapped to one size larger.
-- Globe climate wrap + Tilted Axis climate enlarges map size
-- to compensate for frozen / cropped-out land.
local PREFERRED_STD_SIZES_ENLARGED = 
{
    [MAPSIZE_DUEL]     = PreferredSizes.TINY,
    [MAPSIZE_TINY]     = PreferredSizes.SMALL,
    [MAPSIZE_SMALL]    = PreferredSizes.STANDARD,
    [MAPSIZE_STANDARD] = PreferredSizes.LARGE,
    [MAPSIZE_LARGE]    = PreferredSizes.HUGE,
    [MAPSIZE_HUGE]     = PreferredSizes.MASSIVE,
};

---------------------------------------------------------------------------------------------------
-- Tunable constants
---------------------------------------------------------------------------------------------------
--[[ Whether to include the "None" landmass in the landmass shuffle.
-- If true then the shuffle will contain "None" plus whatever landmasses the user has selected. 
-- So if the user selects one landmass, then the shuffle will be 50% chance of None + 50% chance 
-- of selected landmass.
--
-- If false then the shuffle will never produce "None" unless the user selects no landmasses 
-- (i.e. None for every landmass family option).
--]]
local INCLUDE_NONE_IN_LANDMASS_SHUFFLE = false; -- default: false

--[[ Mountain fractal height percentage thresholds.
--
-- This list contains a fractal height threshold for each mountain level, 
-- in order of lowest to highest mountain level.
--
-- Each threshold is in the range [0, 100] and represents a base percentage of the map to turn 
-- into mountains. Therefore, a higher threshold results in more mountains.
--
-- These thresholds effect all mountain patterns; however, some mountain patterns may offset
-- the threshold to increase/decrease mountain level.
--
-- This list also determines the number of mountains to place on tectonic islands.
--]]
local MTN_FRACTAL_PERCENTAGES  = {5,10,15,20,25};  -- default: {5,10,15,20,25}

--[[ Hill fractal height percentage thresholds.
--
-- This list contains a fractal height threshold for each hill level, 
-- in order of lowest to highest hill level.
--
-- Each threshold is in the range [0, 100] and represents a base percentage of the map to turn 
-- into hills. Therefore, a higher threshold results in more hills.
--
-- These thresholds effect all mountain patterns.
--
-- This list also determines the number of hills to place on tectonic islands, as well as
-- the percentage chance of turning mountains into hills when removing mountains.
--]]
local HILL_FRACTAL_PERCENTAGES = {12,20,28,36,44}; -- default: {12,20,28,36,44}

--[[ Target thickness of mountain clump edges when Thin Mountain Clump Edges is disabled.
-- Thickness is in number of plots.
--
-- When hollowing-out mountain clumps, this is how far away a passable plot must be in order 
-- for a mountain to become a candidate for removal.
--
-- Ignored if Mountain Clumps is set to Full.
-- Values less than 1 are treated as 1, which is equivalent to Thin Mountain Clump Edges.
-- Higher values will have less of an effect on mountain clumps.
-- Effect might not be noticeable with low mountain level or with already-thin mountain patterns
-- such as Scattered Crags.
--]]
local MTN_CLUMP_EDGE_THICKNESS = 2; -- default: 2

--[[ Miminum fraction of the total number of land tiles for a pangea fractal's biggest landmass.
-- Range [0,1], where 0 effectively disables the threshold,
-- and 1 means that all tiles must be in a single chunk of land.
--]]
local PANGEA_LANDMASS_MAJORITY_MIN = 0.84; -- default: 0.84
local SNAKE_LANDMASS_MAJORITY_MIN  = 0.75; -- default: 0.75

-- Maximum number of attempts to create a pangea 
-- that satisfies the minimum majority of land tiles for the biggest landmass.
local PANGEA_MAX_NUM_ATTEMPTS = 100; -- default: 100

--[[ On/Off switch for Donut Filling easter eggs.
-- If true, then certain settings can alter the center of the donut and inverted donut landmasses.
-- If false, then the center of the donut will always be water with possible extra islands
-- (or in the case of inverted donut, land with possible extra lakes).
--]]
local ENABLE_DONUT_FILLING = true; -- default: true

-- Default height for the mini-donut bays fractal.
local MINIDONUT_BAYS_HEIGHT_DEFAULT = 74; -- default: 74

-- Whether to add circumnavigation channels to maps that are already circumnavigable.
local CIRCUMNAV_FORCE_CHANNELS = false; -- Default: false

--[[ Percent chance of allowing a random circumnavigation path to meander into land/ice
-- whenever the path can choose between open water and land/ice.
--
-- A 0% chance means that paths will avoid land/ice whenever possible, resulting in paths
-- merging but staying narrow after every merge.
--
-- A 100% chance means that paths never try to avoid land/ice, resulting in paths intersecting
-- but never actually merging.
--
-- A middle values means that paths sometimes meander into land/ice, resulting in paths 
-- that sometimes widen after a merge.
--]]
local CIRCUMNAV_MEANDER_PCT = 33; -- Default 33

--[[ How many random horizontal-ish paths to cut through land
-- when enforcing circumnavigation with random paths.
--
-- Note that sometimes paths merge so it might look like you have fewer paths than
-- you specified.
--]]
local CIRCUMNAV_NUM_PATHS_THROUGH_LAND = 2; -- default: 2

--[[ How many random horizontal-ish paths to cut through ice
-- when enforcing circumnavigation with either edges or paths.
--
-- Note that sometimes paths merge so it might look like you have fewer paths than
-- you specified.
--]]
local CIRCUMNAV_NUM_PATHS_THROUGH_ICE = 2; -- default: 2

-- On/Off switch for River Generator debug messages and cycle detection.
-- Useful for troubleshooting.
local ENABLE_RIVER_DEBUG = false; -- default: false

--[[ On/Off switch for river merging, which allows for more complex river systems.
-- WARNING: enabling this may cause the game to crash on start! The chance of this increases
-- with map size. Lower chance of crash with Rivers = Simple, River Level = Low.
--]]
local ENABLE_RIVER_MERGE = false; -- default: false

-- On/Off switch for randomizing which pole is hot on Tilted Axis sunlight 
-- with azimuthal climate wrap.
local ENABLE_TILTEDAZIMUTH_RANDOM_POLES = true; -- default: true

-- If random azimuthal poles for tilted sunlight is disabled, then determine whether the 
-- hot pole is at the center of the map (true) or at the edges (false).
local TILTEDAZIMUTH_HOT_POLE_AT_CENTER = true; -- default: true

-- On/Off switch for randomizing the locations of poles on Tilted Axis or Two Suns sunlights 
-- with regional climate wrap.
local ENABLE_TILTEDREGION_RANDOM_POLES = true; -- default: true

-- If random regional Tilted Axis poles are disabled, then set the south pole's distance 
-- in hexes from the center of the map. Has no effect on Two Suns.
local TILTEDREGION_DEFAULT_POLE_RDIST = 0; -- default: 0

-- If random regional Tilted Axis / Two Suns poles are disabled, then set the south pole's 
-- angle offest in radians [0,TAU] starting east from the center of the map.
local TILTEDREGION_DEFAULT_POLE_THETA = 0; -- default: 0

--[[ Whether to reduce reefs in order to avoid an apparent crash-on-map-reveal bug from 
-- the R&F release. Prior to v33.1 this was enabled by default. Consider re-enabling this if
-- the game starts crashing on maps that have reefs--especially maps that do not wrap east-
-- west.
--]]
local ENABLE_RF_REEF_REDUCTION = false; -- default: false

--[[ Whether to recalculate areas with AreaBuilder after generating Natural Wonders.
-- If enabled, salt-lake Natural Wonders such as Dead Sea and Lake Retba will count as fresh
-- due to the AreaBuilder tagging sufficiently-small water bodies as fresh lakes.
-- If disabled, skip recalculation so that these wonders remain salty, just like base game GS.
-- WARNING: disabling this may result in inaccurate placement of cliffs, resources, and start 
-- positions, due to the start plot system relying on stale info about land/water areas. For 
-- example, civs that were supposed to be on the largest area may wind up on separate land 
-- areas instead.
--]]
local RECALC_AREAS_AFTER_NATURAL_WONDERS = true; -- default: true

--[[ Minimum percentage of total land for a terrain type to count as existing on a map.
-- Each land terrain type that exceeds this threshold will count towards the threshold
-- for relaxing restrictions on resource placement.]]
local LAND_TERRAIN_EXISTENCE_MIN_PCT = 5; -- Default: 5

-- Maximum number of "existing" land terrain types allowed for placing scrambled land
-- luxuries in snow.
local SCRAMBLED_SNOW_LUX_MAX_NUM_LAND_TERRAINS = 1; -- Default: 1

-- Maximum number of "existing" land terrain types allowed for relaxing restrictions
-- on placement of strategic resources.
local STRAT_RESOURCE_RELAXATION_MAX_NUM_LAND_TERRAINS = 2; -- Default: 2

--[[ Whether to allow civs that start in water to fall-back to fresh lakes
-- when there is not enough water to start in an ocean. This guarantees a water start for
-- most maps.
-- 
-- If false, then fall-back to starting on land, just like the base game.
--]]
local ASP_ENABLE_FRESH_LAKE_WATER_STARTS = true; -- default: true

--[[ Whether to allow lower quality starts when attempting Biggest Area or Separate Areas
-- for land/water/minor starts. Enable this if you would rather force mediocre starts 
-- according to your land/Water/minor start options than revert to standard starts.
--
-- Lower quality starts may be closer to other civs and/or lack fresh water.
--
-- If Biggest Area or Separate Areas still fails even when considering lower-quality starts, 
-- then revert to standard starts as a last resort.
--
-- If false, then do not allow lower-quality starts for Biggest Area or Separate Areas; instead, 
-- revert to standard starts if the BA/SA attempt fails *and then* allow lower-quality starts 
-- as a last resort.
--]]
local ASP_ENABLE_NONSTD_STARTS_WITH_FALLBACKS = true; -- default: true

--[[ A hard minimum distance in plots to allow between major civ starting locations.
-- Got Lakes will *completely ignore* any plots that are within this distance from an 
-- already-placed civ.
--
-- A value less than 4 may result in civs starting too close to each other to found their 
-- first city. But that probably won't happen unless you have an unusually crowded map such as 
-- Largest Area starts with on a small island, or twice the default number of civs for the 
-- chosen map size. Useful if you really like insanely crowded maps.
--
-- Higher values will force civs to be farther away, but may result in lower-quality starts 
-- or even a failure to place all civs on the map.
--]]
local ASP_MIN_DISTANCE_BETWEEN_MAJOR_CIVS = 4; -- default: 4

--[[ A hard minimum distance in plots to allow between minor civ starting locations.
-- Got Lakes will *completely ignore* any plots that are within this distance from an 
-- already-placed civ when placing minor civs.
--
-- A value less than 4 may result in civs starting too close to each other to found their 
-- first city. But that probably won't happen unless you have an unusually crowded map such as 
-- Largest Area starts with on a small island, or twice the default number of civs for the 
-- chosen map size. Useful if you really like insanely crowded maps.
--
-- Higher values will force civs to be farther away, but may result in lower-quality starts 
-- or even a failure to place all civs on the map.
--]]
local ASP_MIN_DISTANCE_BETWEEN_MINOR_CIVS = 4; -- default: 4

--[[ A soft minimum distance in plots to allow between two major-civ starting locations.
-- Got Lakes will deprioritize any plots that are within this distance from an already-placed 
-- civ in favor of plots that are farther away.
--
-- In other words, if Got Lakes is unable to find a good plot for a particular civ then GL may
-- use a plot within this distance as a fall-back plot.
--
-- This setting is based on distance between two civs. However, when more than one civ is near
-- a potential starting location then Got Lakes increases this setting using an impact-and-
-- ripples system (based on Civ V ASP) that stacks with each placed civ.
--
-- Minor civs will also honor this distance with respect to major civs, but they have a smaller 
-- impact radius than major civs so that GL can place minor civs closer to each other.
--
-- If the Teams Together Strong mod is enabled then you can override this setting with
-- the Minimum Distance Between Non-Teammates option from that mod.
--
-- Must be <= ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS.
-- Ignored if set to <= ASP_MIN_DISTANCE_BETWEEN_CIVS.
-- Maximum value is 22; higher values make no difference.
--]]
local ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS = 8; -- default: 8, max: 22

--[[ An extra-soft minimum distance in plots to allow between two major-civ starting locations.
-- Got Lakes will use plot scoring to bias the start positioner away from plots that are within
-- this distance from an already-placed civ. This plot score penalty varies depending on
-- distance to other civs.
--
-- This setting is based on distance between two civs. However, when more than one civ is near
-- a potential starting location then Got Lakes increases this setting using an impact-and-
-- ripples system (based on Civ V ASP) that stacks the distance bias penalty with each placed civ.
--
-- Minor civs will also honor this distance with respect to major civs, but they have a smaller 
-- impact radius than major civs so that GL can place minor civs closer to each other.
--
-- Must be >= ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS.
-- Ignored if set to <= ASP_MIN_DISTANCE_BETWEEN_CIVS.
-- Maximum value is 22; higher values make no difference.
--]]
local ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS = 12; -- default: 12, max: 22

--Multiply this by the number of tiles in the biggest landmass to get a target minimum number 
--[[ of reachable tiles for a major civ start.
--
-- By default, avoid starts that can only reach 1/4 the size of the biggest landmass.
--
-- A value of 0 effectively disables this.
-- A value of 1 biases starts towards the largest landmass.
-- Beware that mountain ranges can divide land into smaller chunks.
--
-- Has no effect when starting civs in separate areas.
--]]
local ASP_STARTAREA_MIN_REACHABLE_LAND_RATIO = 0.25; -- default: 0.25

--[[ On/Off switch for custom handling of start biases.
-- ASP is *much* more aware of start biases with this enabled.
-- However, this may have a significant performance impact on map generation for extremely large
-- maps.
--]]
local ASP_ENABLE_GL_START_BIAS = true; -- default: true

--[[ Log Level for Start Bias debug messages.
-- Useful for troubleshooting.
-- ERROR => errors only
-- WARN => add warnings
-- INFO => concise summary
-- FINE => add solver step-by-step
-- FINER => add all biases loaded from DB
-- FINEST => add per-plot analysis (super-spammy on large maps)
--]]
local ASP_START_BIAS_LOG_LEVEL = LogLevels.INFO; -- default: LogLevels.INFO

---------------------------------------------------------------------------------------------------
-- Map Script globals - data that may span multiple steps of map generation
---------------------------------------------------------------------------------------------------
local ScriptData = 
{
    -- True iff the Gathering Storm expansion is enabled.
    -- False indicates either base game or Rise and Fall
    gotGatheringStorm = g_FEATURE_VOLCANO ~= nil,

    -- True iff the Rise and Fall expansion is enabled.
    -- False indicates base-game.
    gotRiseAndFall = g_FEATURE_REEF ~= nil,
    
    -- True iff the Ophidy's Fungalfield Biome mod is enabled.
    gotOphFungalfieldBiome = g_FEATURE_OPH_FUNGAL_FOREST ~= nil,
    
    -- True iff the Select Natural Wonders ++ mod is enabled
    gotSelectNWsPlusPlus = g_CustomPlacements ~= nil,
    
    -- True iff the Sukritact's Oceans mod and corresponding game mode are enabled.
    gotSuksOceans = g_FEATURE_SUK_KELP ~= nil,
    
    -- True iff Yet (not) Another Map Pack is enabled and configured with custom starts.
    gotYnAMPStarts = (bCulturallyLinked or bDistanceRelativeStart),
    
    -- Which function to use for randomizing map configuration.
    configRandFcn = nil,

    -- Biodiversity configuration
    biodivInfo = {},

    -- Make a copy of the plot types before adding mountains, so that
    -- we know what to put back if we remove mountains.
    preMtnPlotTypes = nil,
    
    -- Adjustments to mountain & hill percentages
    -- in case we need to randomly add more hills/mountains
    -- after creating primary mountain ranges.
    mtnAdjust = nil,
    hillAdjust = nil,

    -- Mountains/Hills generator
    mtnsHillsGen = nil,

    -- Map of mountains and hills according to the mountain pattern
    mtnPlots = {},
    
    -- Map of trenches: where to put water for inverted tectonic islands.
    trenchPlots = {},
    
    -- Map of coasts: where to add custom coasts for tectonic shallows and whatnot.
    coastPlots = {},

    -- A map of tectonic islands to avoid when adding mountains and hills.
    -- Nil means no tectonic islands.
    tectonicIslesMap = nil,

    -- A map that tracks which tiles are part of the donut filling.
    donutFillingMap = {},
    
    -- Hex radius and a list of {x,y} hex centers generated by the Hex landmass
    -- if landmass is Hex and hex radius > 1.
    hexMap = nil,
    
    -- Circumnavigation Generator.
    circumNavGen = nil,
    
    -- Common flags for climate fractals.
    -- Explicitly disable the polar flag 
    -- to ensure that fractals touch the N/S edges of the map.
    climateFracFlags = { FRAC_POLAR = false },
    
    -- Which terrains are allowed during terrain generation.
    enabledTerrainsList = nil,
    enabledTerrainsMap = nil,
    
    -- How many terrain types are significantly present on the map.
    numTerrainTypes = 0,
    
    -- Info for regional terrain and feature calculations.
    -- Initialized during terrain generator init.
    terrainInfo = {},

    -- World size passed into GetMapInitData()
    worldSize = nil,
    
    -- World Size configuration
    worldSizeInfo = {},
    
    -- World wrap configuration.
    wrapX = false,

    -- Landmass configuration
    landInfo = {},

    -- Climate configuration    
    climateInfo  = {},
    biomeInfo    = {},
    sunlightInfo = {},
};

-- Commonly used vars, following Civ6 naming convention.
local g_iW       = 0;
local g_iH       = 0;
local g_numTiles = 0;
local g_iFlags   = {};
local g_fracXExp = -1;
local g_fracYExp = -1;

------------------------------------------------------------------------------
-- Utilities
------------------------------------------------------------------------------
function CreateClimateFractal(name)
    -- Create a fractal that controls part of the climate.
    
    -- Get climate granularity.
    local grain = UserInput.climGran;
    if (grain == ClimateGrans.MIXEDCF) then
        -- Mixed Coarse-Fine => random grain for each fractal.
        grain = 2 + TerrainBuilder.GetRandomNumber(3, "Mixed-CF climate grain");
        print("Climate grain for " .. name .. ": ", grain);
        
    elseif (grain == ClimateGrans.MIXED) then
        -- Mixed => random grain for each fractal.
        grain = 1 + TerrainBuilder.GetRandomNumber(5, "Mixed climate grain");
        print("Climate grain for " .. name .. ": ", grain);
    end
    
    return Fractal.Create(
        g_iW, g_iH, 
        grain, 
        ScriptData.climateFracFlags, 
        g_fracXExp, g_fracYExp);
end

function GetSeaLevel()
    -- Map user's selected sea level from option # to 
    -- water percentage for a fractal world.
    local seas = ScriptData.landInfo.sea_levels;
    
    -- Map sea level option to sea level as water percent.
    local sea_level = seas[UserInput.seaLevel] or 72;
    
    print("Sea level is " .. sea_level);
    return sea_level;
end
------------------------------------------------------------------------------
-- TerrainGenerator Overrides (used by CoastalLowlands).
--
-- Override methods to fix bugs and to avoid interference from other mods.
------------------------------------------------------------------------------
function GetNumberAdjacentVolcanoes(iX, iY)
    return CountAdjacentVolcanoes(iX,iY);
end

function GetNumberAdjacentMountains(iX, iY)
    return CountAdjacentMountains(iX,iY);
end

function GetNumberAdjacentLakes(iX, iY)
    return CountAdjacent(iX, iY, IsLakeOrWonderLake);
end
------------------------------------------------------------------------------
-- Mountains and Hills
------------------------------------------------------------------------------
function GenerateMountainsAndHills()
    -- Generate a layer of mountains and hills.
    -- Call this before generating extras.
    local mtnsHillsGen = GotLakes_MtnsHillsGenerator.Create(
        g_fracXExp, g_fracYExp,
        ScriptData.wrapX,
        ScriptData.worldSizeInfo.fracGrain,
        ScriptData.hexMap,
        MTN_FRACTAL_PERCENTAGES,
        HILL_FRACTAL_PERCENTAGES,
        MTN_CLUMP_EDGE_THICKNESS);

    local mtnAdjust, hillAdjust = mtnsHillsGen:GetAdjustments();
    print("Mtn  height adjustment: " .. mtnAdjust);
    print("Hill height adjustment: " .. hillAdjust);
    -- Set global so that we can use these to generate tectonic extras.
    ScriptData.mtnAdjust  = mtnAdjust;
    ScriptData.hillAdjust = hillAdjust;

    -- Make separate maps for mountain pattern output that is
    -- agnostic of actual landmass info.
    local mtnPlots, trenchPlots = mtnsHillsGen:GenerateMountainsAndHills();
    
    -- Allow other parts of the map script to run the mountains/hills generator.
    ScriptData.mtnsHillsGen = mtnsHillsGen;
    
    -- Set global so that we can extend mountain ranges to other parts
    -- of this script.
    ScriptData.mtnPlots    = mtnPlots;
    ScriptData.trenchPlots = trenchPlots;
end

function AddMountainsAndHillsToPlotTypes(plotTypes)
    -- Apply mountain and hill plots to a world's plot types.
    --
    -- Args: 
    --   plotTypes: destination map for adding mountains and hills.
    --    
    -- Mountains and hills - fractal ranges
    print("Adding mountains and hills to the world.");
    
    -- Make a copy of the plot types before adding mountains, so that
    -- we know what to put back if we remove mountains.
    ScriptData.preMtnPlotTypes = table.fill(g_PLOT_TYPE_LAND, g_numTiles);
    for i = 1, g_numTiles do
        ScriptData.preMtnPlotTypes[i] = plotTypes[i];
    end
    
    local got_tectonic = (ScriptData.tectonicIslesMap ~= nil);
    
    -- Count # of mts, hills added
    local numMts   = 0;
    local numHills = 0;
    
    -- Apply mountain plot types to the main map.
    for x = 0, g_iW - 1, 1 do
        for y = 0, g_iH - 1, 1 do
            local i = GetPlotIndexLua(x,y);
            
            -- Check mountain pattern for mountains and hills.
            local srcPlotType = ScriptData.mtnPlots[i];
            
            if ((srcPlotType  ~= g_PLOT_TYPE_OCEAN) and
                (plotTypes[i] ~= g_PLOT_TYPE_OCEAN) and
                ((got_tectonic == false) or 
                 (ScriptData.tectonicIslesMap[i] == g_PLOT_TYPE_OCEAN))) then
                -- Got a plot to add to the world.
                -- Replacing a land tile that is *not* a tectonic island.
                plotTypes[i] = srcPlotType;
                
                if (srcPlotType == g_PLOT_TYPE_MOUNTAIN) then
                    numMts = numMts + 1;
                
                elseif (srcPlotType == g_PLOT_TYPE_HILLS) then
                    numHills = numHills + 1;
                end
            end
        end
    end
    
    -- Note: coastal mountains may become hills during feature generation.
    print("Added " .. numMts .. " mountains and " .. numHills .. " hills.");
    
    -- Hollow-out mountain ranges, if applicable.
    local mtnsHillsGen = ScriptData.mtnsHillsGen;
    mtnsHillsGen:HollowOutMountainClumps(plotTypes);
    
    -- Add some lonely mountains.
    -- Need to do this after populating plot types with mountains
    -- so that lonely-mountain logic can use mountain-ratio.
    print("Adding lonely mountains and hills.");
    mtnsHillsGen:AddLonelyMountains(plotTypes);
    mtnsHillsGen:AddExtraHills(plotTypes);
end
------------------------------------------------------------------------------
-- Extras
------------------------------------------------------------------------------
function GenerateExtras(plotTypes)
    -- Generate extra islands or lakes, depending on landmass.
    --
    -- args:
    --   plotTypes: apply extra-island data to this set of plot types
    --
    -- Return a map of extra islands for customized merging with landmass.
    print("Adding extras to the world.");
    
    -- Check whether we actually wanted extra *lakes* instead of
    -- extra islands.
    local args = ScriptData.landInfo.extraArgs or {};
    local invertExtras = args.invertExtras;
    
    local connectLand = UserInput.connectLand and 
        (gotLakesFamily or gotPangeaFamily or (UserInput.landmass == Landmasses.NONE)) and
        (not invertExtras);
    
    -- Start with a blank map for extras.
    local extras_PlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    
    if ExtrasGot.chains then
        -- Add island chains to the extras map.
        MergeChains(extras_PlotTypes, GenerateChains(invertExtras));
        
        if ((UserInput.extras == ExtraIslesLakes.CHAINS) and 
            (UserInput.landmass == Landmasses.NONE)) then
            -- No landmass and no other extras.
            -- Add more chains to compensate.
            print("Adding a 2nd layer of chains (no landmass, no other extras)");
            MergeChains(extras_PlotTypes, GenerateChains(invertExtras));
        end
    end    
    
    if ExtrasGot.clusters then
        -- Add clusters to the extras map.
        local targetSize = ScriptData.worldSizeInfo.targetClusterSize;
        
        if (connectLand and (not ExtrasGot.everything)) then
            -- Connected Lands enabled and we're adding only clusters.
            -- Add connected clusters and don't connect land later.
            MergeExtras(true, extras_PlotTypes,
                GenerateConnectedClusters(targetSize, g_iFlags));
            connectLand = false;
        else
            -- Add regular clusters.
            MergeExtras(true, extras_PlotTypes, 
                GenerateClusters(invertExtras, targetSize, g_iFlags));
        end
    end
    
    if ExtrasGot.miniDonuts then
        -- Add mini-donuts to the extras map.
        -- Radius multiplier based on landmass and extras.
        local rMult = 1;
        local gotExtrasThemedLandmass = (UserInput.landmass == Landmasses.INVEXTRAS);
        if (gotExtrasThemedLandmass and ExtrasGot.everything) then
            -- An extras-themed landmass with all extras
            -- Make mini-donuts smaller, but not as small as a regular landmass.
            rMult = 8/11; -- approx 0.73; divide by 1.375
            
        elseif (not gotExtrasThemedLandmass) then
            -- A landmass that doesn't need larger mini-donuts.
            -- Shrink mini-donuts to slightly more than half of base size.
            rMult = 4/7; -- approx 0.57; divide by 1.75
        end
        
        local numDonutsPerCell = 2;
        local numExtraDonutsMult = 1;
        if ExtrasGot.everything then
            -- Reduce donuts to make room for other types of extras.
            print("Reducing mini-donuts (everything extras)");
            numDonutsPerCell = 1;
            numExtraDonutsMult = 1/3;
        
        elseif (UserInput.landmass == Landmasses.NONE) then
            print("Increasing mini-donuts (no landmass, no other extras)");
            numExtraDonutsMult = 1.5;
            rMult = 8/11;
        end
        
        local baysHeight = args.miniDonutBaysHeight or MINIDONUT_BAYS_HEIGHT_DEFAULT;
        local miniDonutArgs = 
        {
            doInverted         = invertExtras,
            baysHeight         = baysHeight,
            numDonutsPerCell   = numDonutsPerCell,
            numExtraDonuts     = ScriptData.worldSizeInfo.numExtraDonuts,
            numExtraDonutsMult = numExtraDonutsMult,
            rMult              = rMult,
            wrapX              = ScriptData.wrapX,
        };
        MergeExtras(true, extras_PlotTypes, GenerateMiniDonuts(miniDonutArgs));
    end
    
    if ExtrasGot.sprinkles then
        -- Add island sprinkles to the extras map.
        MergeExtras(true, extras_PlotTypes, GenerateSprinkles(invertExtras, g_iFlags));
    end    
    
    if ExtrasGot.tectonic then
        -- Add tectonic islands to the extras map.
        local mtnPlots = ScriptData.mtnPlots;
        if invertExtras then
            -- Place islands at trenches instead of mountains.
            mtnPlots = ScriptData.trenchPlots;
        end
        
        local coastPlots = ScriptData.coastPlots;
        
        -- Add mountain/hill height adjustments to args.
        args.mtnAdjust = ScriptData.mtnAdjust;
        args.hillAdjust = ScriptData.hillAdjust;
        
        local tectonicPlotTypes = GenerateTectonicIslands(plotTypes, mtnPlots, coastPlots, args);
        MergeExtras(true, extras_PlotTypes, tectonicPlotTypes);
        
        -- The mountain pattern needs this in order to avoid
        -- clobbering the tectonic islands with mountains and hills.
        ScriptData.tectonicIslesMap = tectonicPlotTypes;
    end
    
    if connectLand then
        -- Connect extra islands to each other.
        ConnectLands(extras_PlotTypes, false, false);
    end
        
    -- Finished generating extras (1st pass).

    print("Merging extras to the landmass.");    
    
    -- Merge extras onto the mainland.
    local MergeToMainland = args.MergeToMainland or MergeExtras;
    
    if UserInput.isoCoasts then
        print("Avoiding shallow water connection to landmass (isolated coasts).");
        MergeToMainland = MergeExtrasAvoidLandmassCoast;
    
    elseif ((MergeToMainland == MergeExtras) and ExtrasGot.everything) then
        -- Everything extras adds a ton of land.
        -- Compensate by avoiding contact with the main landmass.
        print("Avoiding main landmass (everything extras).");
        MergeToMainland = MergeExtrasAvoidLandmass;
    end
    
    -- By default, use extras to generate islands (land).
    local mergeLand  = true;
    if invertExtras then
        -- Use extras to generate water instead of land.
        mergeLand  = false;
    end
    
    MergeToMainland(mergeLand, plotTypes, extras_PlotTypes);
    print("Done adding extras.");
end

function GenerateMtnsHillsAndExtras(plotTypes)
    -- Add mountains, hills, and extras to the landmass.
    --
    -- Args:
    --   plotTypes: add to this map of plot types.
   
    local connectLand = UserInput.connectLand;
    local isolateCoasts = UserInput.isoCoasts;
    
    if (connectLand and ((UserInput.landmass ~= Landmasses.NONE))) then
        -- Connect landmass lands before adding extras.
        -- Allow Large Islands landmass to enforce isolation between landmass islands.
        ConnectLands(plotTypes, 
            (isolateCoasts and (UserInput.landmass == Landmasses.LRGISLES)), false);
    end
    
    -- Generate mountain pattern.
    GenerateMountainsAndHills();    
    
    -- Add extras, which depends on mountain pattern.
    GenerateExtras(plotTypes);
    
    -- Check whether we added extra *lakes* instead of extra islands.
    local args = ScriptData.landInfo.extraArgs or {};
    local invertExtras = args.invertExtras;
    
    if (connectLand and invertExtras) then
        -- Connect islands generated by extra lakes.
        ConnectLands(plotTypes, isolateCoasts, true);
    end
    
    if UserInput.freshLakes then
        -- Freshen lakes
        FreshenLakesLandmass(plotTypes);
    end
    
    -- Add mountains and hills after adding all land tiles.
    AddMountainsAndHillsToPlotTypes(plotTypes);
end
-------------------------------------------------------------------------------------------
-- Plot Type overrides and helper methods
-- Need to declare these before declaring land info.
-------------------------------------------------------------------------------------------
FractalWorld = {};

function FractalWorld.Create()
    
    local data = {
        InitFractal         = FractalWorld.InitFractal,
        GenerateCenterRift     = FractalWorld.GenerateCenterRift,
        GeneratePlotTypes     = FractalWorld.GeneratePlotTypes,
        
        plotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    };
    
    return data;
end    

function FractalWorld:InitFractal(args)
    local args = args or {};
    
    local continent_grain = args.continent_grain or 2;
    -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
    local rift_grain = args.rift_grain or -1; 
    local polar = args.polar or true;
    
    local fracFlags = {};
    
    if (polar) then
        fracFlags.FRAC_POLAR = true;
    end
    
    if(rift_grain > 0 and rift_grain < 4) then
        self.riftsFrac = Fractal.Create(
            g_iW, g_iH, rift_grain, {}, g_fracXExp, g_fracYExp);
            
        self.continentsFrac = Fractal.CreateRifts(
            g_iW, g_iH, continent_grain, fracFlags, self.riftsFrac, g_fracXExp, g_fracYExp);
    else
        self.continentsFrac = Fractal.Create(
            g_iW, g_iH, continent_grain, fracFlags, g_fracXExp, g_fracYExp);    
    end

    -- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
    -- Without fractal variation, the tectonics come out too regular.
    --
    --[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
    added some minor randomness and the slope might be a little tricky. It was 
    intended as a 'whole world' modifier to the fractal class. You can modify 
    the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
    --
    local numRPlates = ScriptData.worldSizeInfo.numRPlates; -- Ridge Plates
    -- Blend a bit of ridge into the fractal.
    -- This will do things like roughen the coastlines and build inland seas. - Brian
    self.continentsFrac:BuildRidges(numRPlates, fracFlags, 1, 2);
end

function FractalWorld:GenerateCenterRift()
    -- Causes a rift to break apart and separate any landmasses overlaying the map center.
    -- Rift runs south to north ala the Atlantic Ocean.
    -- Any land plots in the first or last map columns will be lost, overwritten.
    -- This rift function is hex-dependent. It would have to be adapted to work with squares tiles.
    -- Center rift not recommended for non-oceanic worlds or with continent grains higher than 2.
    -- 
    -- First determine the rift "lean". 0 = Starts west, leans east. 1 = Starts east, leans west.
    local riftLean = TerrainBuilder.GetRandomNumber(2, "FractalWorld Center Rift Lean");
    
    -- Set up tables recording the rift line and the edge plots to each side of the rift line.
    local riftLine = {};
    local westOfRift = {};
    local eastOfRift = {};
    -- Determine minimum and maximum length of line segments for each possible direction.
    local primaryMaxLength = math.max(1, math.floor(g_iH / 8));
    local secondaryMaxLength = math.max(1, math.floor(g_iH / 11));
    local tertiaryMaxLength = math.max(1, math.floor(g_iH / 14));
    
    -- Set rift line starting plot and direction.
    local startDistanceFromCenterColumn = math.floor(g_iH / 8);
    if riftLean == 0 then
        startDistanceFromCenterColumn = -(startDistanceFromCenterColumn);
    end
    local startX = math.floor(g_iW / 2) + startDistanceFromCenterColumn;
    local startY = 0;
    local startingDirection = DirectionTypes.DIRECTION_NORTHWEST;
    if riftLean == 0 then
        startingDirection = DirectionTypes.DIRECTION_NORTHEAST;
    end
    -- Set rift X boundary.
    local riftXBoundary = math.floor(g_iW / 2) - startDistanceFromCenterColumn;
    
    -- Rift line is defined by a series of line segments traveling in one of three directions.
    -- East-leaning lines move NE primarily, NW secondarily, and E tertiary.
    -- West-leaning lines move NW primarily, NE secondarily, and W tertiary.
    -- Any E or W segments cause a wider gap on that row, requiring independent storage of 
    -- data regarding west or east of rift.
    --
    -- Key variables need to be defined here so they persist outside of the various loops 
    -- that follow. This requires that the starting plot be processed outside of those loops.
    local currentDirection = startingDirection;
    local currentX = startX;
    local currentY = startY;
    table.insert(riftLine, {currentX, currentY});
    -- Record west and east of the rift for this row.
    local rowIndex = currentY + 1;
    westOfRift[rowIndex] = currentX - 1;
    eastOfRift[rowIndex] = currentX + 1;
    -- Set this rift plot as type Ocean.
    local plotIndex = currentX + 1;
    -- Tiles crossed by the rift all turn in to water.
    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
    
    -- Generate the rift line.
    if riftLean == 0 then -- Leans east
        while currentY < g_iH - 1 do
            -- Generate a line segment
            local nextDirection = 0;

            if currentDirection == DirectionTypes.DIRECTION_EAST then
                local segmentLength = TerrainBuilder.GetRandomNumber(tertiaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX >= riftXBoundary then
                    -- Gone as far east as allowed, must turn back west.
                    nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(3, 
                        "FractalWorld Center Rift Direction");
                    if dice == 1 then
                        nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 do
                    currentX = currentX + 1; -- Moving east, no change to Y.
                    rowIndex = currentY;
                    -- westOfRift[rowIndex] does not change.
                    eastOfRift[rowIndex] = currentX + 1;
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end

            elseif currentDirection == DirectionTypes.DIRECTION_NORTHWEST then
                local segmentLength = TerrainBuilder.GetRandomNumber(secondaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX >= riftXBoundary then 
                    -- Gone as far east as allowed, must turn back west.
                    nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(4, 
                        "FractalWorld Center Rift Direction");
                    if dice == 2 then
                        nextDirection = DirectionTypes.DIRECTION_EAST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 and currentY < g_iH - 1 do
                    -- Identifying hex plots other than to east or west is tricky.
                    -- The X coord could be one of two possibilities.
                    -- Call on Map.GetAdjacentPlot to safely handle this task.
                    local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
                    currentX = nextPlot:GetX();
                    currentY = currentY + 1;
                    rowIndex = currentY;
                    westOfRift[rowIndex] = currentX - 1;
                    eastOfRift[rowIndex] = currentX + 1;
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end
                
            else -- NORTHEAST
                local segmentLength = TerrainBuilder.GetRandomNumber(primaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX >= riftXBoundary then
                    -- Gone as far east as allowed, must turn back west.
                    nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(2, 
                        "FractalWorld Center Rift Direction");
                    if dice == 1 and currentY > g_iH * 0.28 then
                        nextDirection = DirectionTypes.DIRECTION_EAST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 and currentY < g_iH - 1 do
                    -- Identifying hex plots other than to east or west is tricky.
                    -- The X coord could be one of two possibilities.
                    -- Call on Map.GetAdjacentPlot to safely handle this task.
                    local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
                    currentX = nextPlot:GetX();
                    currentY = currentY + 1;
                    rowIndex = currentY;
                    westOfRift[rowIndex] = currentX - 1;
                    eastOfRift[rowIndex] = currentX + 1;
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end
            end
            
            -- Line segment is done, set next direction.
            currentDirection = nextDirection;
        end

    else -- Leans west
        while currentY < g_iH - 1 do
            -- Generate a line segment
            local nextDirection = 0;

            if currentDirection == DirectionTypes.DIRECTION_WEST then
                local segmentLength = TerrainBuilder.GetRandomNumber(tertiaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX <= riftXBoundary then
                    -- Gone as far west as allowed, must turn back east.
                    nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(3, 
                        "FractalWorld Center Rift Direction");
                    if dice == 1 then
                        nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 do
                    currentX = currentX - 1; -- Moving west, no change to Y.
                    rowIndex = currentY;
                    westOfRift[rowIndex] = currentX - 1;
                    -- eastOfRift[rowIndex] does not change.
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end

            elseif currentDirection == DirectionTypes.DIRECTION_NORTHEAST then
                local segmentLength = TerrainBuilder.GetRandomNumber(secondaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX <= riftXBoundary then
                    -- Gone as far west as allowed, must turn back east.
                    nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(4, 
                        "FractalWorld Center Rift Direction - Lua");
                    if dice == 2 then
                        nextDirection = DirectionTypes.DIRECTION_WEST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHWEST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 and currentY < g_iH - 1 do
                    -- Identifying hex plots other than to east or west is tricky.
                    -- The X coord could be one of two possibilities.
                    -- Call on Map.GetAdjacentPlot to safely handle this task.
                    local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
                    currentX = nextPlot:GetX();
                    currentY = currentY + 1;
                    rowIndex = currentY;
                    westOfRift[rowIndex] = currentX - 1;
                    eastOfRift[rowIndex] = currentX + 1;
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end
                
            else -- NORTHWEST
                local segmentLength = TerrainBuilder.GetRandomNumber(primaryMaxLength + 1, 
                    "FractalWorld Center Rift Segment Length");
                -- Choose next direction
                if currentX <= riftXBoundary then
                    -- Gone as far west as allowed, must turn back east.
                    nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                else
                    local dice = TerrainBuilder.GetRandomNumber(2, 
                        "FractalWorld Center Rift Direction - Lua");
                    if dice == 1 and currentY > g_iH * 0.28 then
                        nextDirection = DirectionTypes.DIRECTION_WEST;
                    else
                        nextDirection = DirectionTypes.DIRECTION_NORTHEAST;
                    end
                end
                -- Process the line segment
                local plotsToDo = segmentLength;
                while plotsToDo > 0 and currentY < g_iH - 1 do
                    -- Identifying hex plots other than to east or west is tricky.
                    -- The X coord could be one of two possibilities.
                    -- Call on Map.GetAdjacentPlot to safely handle this task.
                    local nextPlot = Map.GetAdjacentPlot(currentX, currentY, currentDirection);
                    currentX = nextPlot:GetX();
                    currentY = currentY + 1;
                    rowIndex = currentY;
                    westOfRift[rowIndex] = currentX - 1;
                    eastOfRift[rowIndex] = currentX + 1;
                    plotIndex = GetPlotIndexLua(currentX, currentY);
                    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
                    plotsToDo = plotsToDo - 1;
                end
            end
            
            -- Line segment is done, set next direction.
            currentDirection = nextDirection;
        end
    end
    -- Process the final plot in the rift.
    westOfRift[g_iH] = currentX - 1;
    eastOfRift[g_iH] = currentX + 1;
    plotIndex = GetPlotIndexLua(currentX, g_iH - 1);
    self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;

    -- Now force the rift to widen, causing land on either side of the rift to drift apart.
    local horizontalDrift = 3;
    local verticalDrift = 2;
    --
    if riftLean == 0 then
        -- Process Western side from top down.
        for y = g_iH - 1 - verticalDrift, 0, -1 do
            local thisRowX = westOfRift[y+1];
            for x = horizontalDrift, thisRowX do
                local sourcePlotIndex = GetPlotIndexLua(x,y);
                local destPlotIndex = (y + verticalDrift) * g_iW + (x - horizontalDrift) + 1;
                self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex]
            end
        end
        -- Process Eastern side from bottom up.
        for y = verticalDrift, g_iH - 1 do
            local thisRowX = eastOfRift[y+1];
            for x = thisRowX, g_iW - horizontalDrift - 1 do
                local sourcePlotIndex = GetPlotIndexLua(x,y);
                local destPlotIndex = (y - verticalDrift) * g_iW + (x + horizontalDrift) + 1;
                self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex]
            end
        end
        -- Clean up remainder of tiles (by turning them all to Ocean).
        -- Clean up bottom left.
        for y = 0, verticalDrift - 1 do
            local thisRowX = westOfRift[y+1];
            for x = 0, thisRowX do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end
        -- Clean up top right.
        for y = g_iH - verticalDrift, g_iH - 1 do
            local thisRowX = eastOfRift[y+1];
            for x = thisRowX, g_iW - 1 do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end
        -- Clean up the rift.
        for y = verticalDrift, g_iH - 1 - verticalDrift do
            local westX = westOfRift[y-verticalDrift+1] - horizontalDrift + 1;
            local eastX = eastOfRift[y+verticalDrift+1] + horizontalDrift - 1;
            for x = westX, eastX do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end

    else -- riftLean = 1
        -- Process Western side from bottom up.
        for y = verticalDrift, g_iH - 1 do
            local thisRowX = westOfRift[y+1];
            for x = horizontalDrift, thisRowX do
                local sourcePlotIndex = GetPlotIndexLua(x,y);
                local destPlotIndex = (y - verticalDrift) * g_iW + (x - horizontalDrift) + 1;
                self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex]
            end
        end
        -- Process Eastern side from top down.
        for y = g_iH - 1 - verticalDrift, 0, -1 do
            local thisRowX = eastOfRift[y+1];
            for x = thisRowX, g_iW - horizontalDrift - 1 do
                local sourcePlotIndex = GetPlotIndexLua(x,y);
                local destPlotIndex = (y + verticalDrift) * g_iW + (x + horizontalDrift) + 1;
                self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex]
            end
        end
        -- Clean up remainder of tiles (by turning them all to Ocean).
        -- Clean up top left.
        for y = g_iH - verticalDrift, g_iH - 1 do
            local thisRowX = westOfRift[y+1];
            for x = 0, thisRowX do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end
        -- Clean up bottom right.
        for y = 0, verticalDrift - 1 do
            local thisRowX = eastOfRift[y+1];
            for x = thisRowX, g_iW - 1 do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end
        -- Clean up the rift.
        for y = verticalDrift, g_iH - 1 - verticalDrift do
            local westX = westOfRift[y+verticalDrift+1] - horizontalDrift + 1;
            local eastX = eastOfRift[y-verticalDrift+1] + horizontalDrift - 1;
            for x = westX, eastX do
                local plotIndex = GetPlotIndexLua(x,y);
                self.plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN;
            end
        end
    end
end
------------------------------------------------------------------------------
GotLakes_Fractal = {}

function GotLakes_Fractal:AddLandAndWater(water_percent)
    -- Use the continents fractal to decide land vs water for each plot.
    --
    -- Returns the total number of land tiles on the map
    local iWaterThreshold = GetFractalHeight(self.continentsFrac, water_percent);
        
    iNumTotalLandTiles = 0;
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local i = GetPlotIndexLua(x,y);
            local val = self.continentsFrac:GetHeight(x, y);
            if(val <= iWaterThreshold) then
                self.plotTypes[i] = g_PLOT_TYPE_OCEAN;
            else
                self.plotTypes[i] = g_PLOT_TYPE_LAND;
                iNumTotalLandTiles = iNumTotalLandTiles + 1;
            end
        end
    end

    return iNumTotalLandTiles;
end

function GotLakes_Fractal:AddMtsHillsExtras()
    -- Add mountains, hills, and extra islands to the plot-types map.
    GenerateMtnsHillsAndExtras(self.plotTypes);
end

function GotLakes_Fractal:Continents_GeneratePlotTypes(args)
    -- Continents landmass
      local args = args or {};
    
    local water_percent = GetSeaLevel();
        
    local shift_plot_types = args.shift_plot_types;
    if (shift_plot_types == nil) then
        shift_plot_types = true;
    end

    local has_center_rift = args.has_center_rift;
    if (has_center_rift == nil) then
        has_center_rift = true;
    end
    
    -- Reject the continental fractal layer until the largest 
    -- landmass occupies this percent or less of the total land.
    local biggest_area_max_pct = 64;
    local biggest_area_thresh = biggest_area_max_pct * 0.01;
    
    -- Generate continental fractal layer and examine the largest landmass
    -- until we meet our critera.
    local done = false;
    local iAttempts = 0;
    local iWaterThreshold, biggest_area, iNumTotalLandTiles, iNumBiggestAreaTiles, iBiggestID;
    while done == false do
        local grain_dice = TerrainBuilder.GetRandomNumber(7, "Continental Grain roll");
        if grain_dice < 4 then
            grain_dice = 2;
        else
            grain_dice = 1;
        end
        local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll");
        if rift_dice < 1 then
            rift_dice = -1;
        end
        
        self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
        iWaterThreshold = GetFractalHeight(self.continentsFrac, water_percent);
        local iBuffer = math.floor(g_iH/13.0);

        iNumTotalLandTiles = 0;
        for x = 0, g_iW - 1 do
            for y = iBuffer, g_iH - iBuffer - 1 do
                local i = GetPlotIndexLua(x,y);
                local val = self.continentsFrac:GetHeight(x, y);
                local pPlot = Map.GetPlotByIndex(i-1);
                if(val >= iWaterThreshold) then
                    self.plotTypes[i] = g_PLOT_TYPE_LAND;
                    -- temporary setting so can calculate areas
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  
                    iNumTotalLandTiles = iNumTotalLandTiles + 1;
                else
                    self.plotTypes[i] = g_PLOT_TYPE_OCEAN;
                    -- temporary setting so can calculate areas
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  
                end
            end
        end

        ShiftPlotTypes(self.plotTypes);
        self:GenerateCenterRift(self.plotTypes);

        AreaBuilder.Recalculate();
        local biggest_area = Areas.FindBiggestArea(false);
        iNumBiggestAreaTiles = biggest_area:GetPlotCount();
        
        -- Now test the biggest landmass to see if it is large enough.
        if iNumBiggestAreaTiles <= iNumTotalLandTiles * biggest_area_thresh then
            done = true;
            iBiggestID = biggest_area:GetID();
        end
        iAttempts = iAttempts + 1;
    end
    
    -- Add hills, mountains, and extras which are mostly landmass-agnostic.
    self:AddMtsHillsExtras();
    
    return self.plotTypes;
end

function GotLakes_Fractal:Fractal_GeneratePlotTypes(args)
    -- Fractal landmass
    local args = args or {};
    
    local shift_plot_types = args.shift_plot_types;
    if (shift_plot_types == nil) then
        shift_plot_types = true;
    end
    
    local has_center_rift  = args.has_center_rift or false;
    
     self:AddLandAndWater(GetSeaLevel());

    if(shift_plot_types == true) then
        print("Shifting plot types.");
        ShiftPlotTypes(self.plotTypes);
        -- Center Rift warrants plot shifting to guarantee centered landmasses.
        if(has_center_rift == true) then
            print("Generating center rift.");
            self:GenerateCenterRift()
        end
    end

    -- Add hills, mountains, and extras which are mostly landmass-agnostic.
    self:AddMtsHillsExtras();

    return self.plotTypes;
end

function GotLakes_Fractal:Pangea_GeneratePlotTypes(args)
    -- Pangea landmass
    local args = args or {};
    
    -- The following fractal-gen args are fixed for pangea:
    --    shift_plot_types (true)
    --    has_center_rift  (false)
    
    local water_percent = GetSeaLevel();
    if (ExtrasGot.everything == true) then
        -- Pangea with everything extras: higher sea level.
        water_percent = math.min(100, water_percent + 6);

    elseif (ExtrasGot.anything == true) then
        -- Pangea with extras: slightly higher sea level
        water_percent = math.min(100, water_percent + 3);
    end

    -- Generate fractal layer and examine the largest landmass.
    -- Reject the result until the largest landmass occupies enough of the total land.
    local done = false;
    local iAttempts = 0;
    local iWaterThreshold, biggest_area, iNumBiggestAreaTiles, iBiggestID;
    while done == false do
        iAttempts = iAttempts + 1;
        print("Attempt #" .. iAttempts);

        local grain_dice = TerrainBuilder.GetRandomNumber(7, "Continental Grain roll");
        if grain_dice < 4 then
            grain_dice = 1;
        else
            grain_dice = 2;
        end
        local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll");
        if rift_dice < 1 then
            rift_dice = -1;
        end
        
        self.continentsFrac = nil;
        self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
        iWaterThreshold = GetFractalHeight(self.continentsFrac, water_percent);
        
        local iNumTotalLandTiles = 0;
        for x = 0, g_iW - 1 do
            for y = 0, g_iH - 1 do
                local i = GetPlotIndexLua(x,y);
                local val = self.continentsFrac:GetHeight(x, y);
                local pPlot = Map.GetPlotByIndex(i-1);
                if(val <= iWaterThreshold) then
                    self.plotTypes[i] = g_PLOT_TYPE_OCEAN;
                    -- temporary setting so can calculate areas
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  
                else
                    self.plotTypes[i] = g_PLOT_TYPE_LAND;
                    -- temporary setting so can calculate areas
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  
                    iNumTotalLandTiles = iNumTotalLandTiles + 1;
                end
            end
        end
        
        AreaBuilder.Recalculate();
        local biggest_area = Areas.FindBiggestArea(false);
        iNumBiggestAreaTiles = biggest_area:GetPlotCount();
        
        -- Now test the biggest landmass to see if it is large enough.
        if ((iAttempts >= PANGEA_MAX_NUM_ATTEMPTS) or 
            (iNumBiggestAreaTiles >= (iNumTotalLandTiles * PANGEA_LANDMASS_MAJORITY_MIN))) then
            done = true;
            iBiggestID = biggest_area:GetID();
            
            print("Got a sufficiently-large biggest landmass.");
        end
    end

    ShiftPlotTypes(self.plotTypes);

    self:AddMtsHillsExtras();

    return self.plotTypes;
end
-------------------------------------------------------------------------------------------
MultilayeredFractal = {};

function MultilayeredFractal.Create()
    -- MLF constructor.

    -- Sum of all layered regions
    local wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_iW * g_iH);

    -- Create data.
    local data = 
    {
        -- member variables
        iRoundFlags        = {},
        
        -- plot arrays
        plotTypes        = {},
        wholeworldPlotTypes = wholeworldPlotTypes,        
    };
    
    setmetatable(data, {__index = MultilayeredFractal});

    return data;
end

function MultilayeredFractal:ShiftRegionPlots(iRegionWidth, iRegionHeight)
    -- Minimizes land plots along the region's edges by shifting the coordinates.
    local shift_x = self:DetermineXShift(iRegionWidth, iRegionHeight);
    local shift_y = self:DetermineYShift(iRegionWidth, iRegionHeight);
    self:ShiftRegionPlotsBy(shift_x, shift_y, iRegionWidth, iRegionHeight);
end

function MultilayeredFractal:ShiftRegionPlotsBy(xshift, yshift, iRegionWidth, iRegionHeight)
    if (xshift > 0 or yshift > 0) then
        local iWH = iRegionWidth * iRegionHeight;
        local buf = {};
        for i = 1, iWH + 1, 1 do
            buf[i] = self.plotTypes[i];
        end

        for iDestY = 0, iRegionHeight, 1 do
            for iDestX = 0, iRegionWidth, 1 do
                local iDestI = iRegionWidth * iDestY + iDestX;
                local iSourceX = (iDestX + xshift) % iRegionWidth;
                local iSourceY = (iDestY + yshift) % iRegionHeight;
                local iSourceI = iRegionWidth * iSourceY + iSourceX;
                self.plotTypes[iDestI] = buf[iSourceI]
            end
        end
    end
end

function MultilayeredFractal:DetermineXShift(iRegionWidth, iRegionHeight)
    --[[ This function will align the most water-heavy vertical portion of the region with
    its vertical edge. This is a form of centering the landmasses, but it emphasizes the
    edge not the middle. If there are columns completely empty of land, these will tend to
    be chosen as the new edge. The operation looks at a group of columns not just a single
    column, then picks the center of the most water heavy group of columns to be the new
    vertical reguin edge. ]]--

    -- First loop through the map columns and record land plots in each column.
    local land_totals = {};
    for x = 0, iRegionWidth - 1 do
        local current_column = 0;
        for y = 0, iRegionHeight - 1 do
            local i = y * iRegionWidth + x + 1;
            if (self.plotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                current_column = current_column + 1;
            end
        end
        table.insert(land_totals, current_column);
    end
    
    -- Now evaluate column groups, each record applying to the center column of the group.
    local column_groups = {};
    -- Determine the group size in relation to map width.
    local group_radius = math.max(1, math.floor(iRegionWidth / 10));
    -- Measure the groups.
    for column_index = 1, iRegionWidth do
        local current_group_total = 0;
        for current_column = column_index - group_radius, column_index + group_radius do
            local current_index = current_column % iRegionWidth;
            if current_index == 0 then -- Modulo of the last column will be zero; this repairs the issue.
                current_index = iRegionWidth;
            end
            current_group_total = current_group_total + land_totals[current_index];
        end
        table.insert(column_groups, current_group_total);
    end
    
    -- Identify the group with the least amount of land in it.
    local best_value = iRegionHeight * (2 * group_radius + 1); -- Set initial value to max possible.
    local best_group = 1; -- Set initial best group as current map edge.
    for column_index, group_land_plots in ipairs(column_groups) do
        if group_land_plots < best_value then
            best_value = group_land_plots;
            best_group = column_index;
        end
    end
    
    -- Determine X Shift
    local x_shift = best_group - 1;
    return x_shift;
end

function MultilayeredFractal:DetermineYShift(iRegionWidth, iRegionHeight)
    -- Counterpart to DetermineXShift()

    -- First loop through the map rows and record land plots in each row.
    local land_totals = {};
    for y = 0, iRegionHeight - 1 do
        local current_row = 0;
        for x = 0, iRegionWidth - 1 do
            local i = y * iRegionWidth + x + 1;
            if (self.plotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                current_row = current_row + 1;
            end
        end
        table.insert(land_totals, current_row);
    end
    
    -- Now evaluate row groups, each record applying to the center row of the group.
    local row_groups = {};
    -- Determine the group size in relation to map height.
    local group_radius = math.max(1, math.floor(iRegionHeight / 10));
    -- Measure the groups.
    for row_index = 1, iRegionHeight do
        local current_group_total = 0;
        for current_row = row_index - group_radius, row_index + group_radius do
            local current_index = current_row % iRegionHeight;
            if current_index == 0 then -- Modulo of the last row will be zero; this repairs the issue.
                current_index = iRegionHeight;
            end
            current_group_total = current_group_total + land_totals[current_index];
        end
        table.insert(row_groups, current_group_total);
    end
    
    -- Identify the group with the least amount of land in it.
    local best_value = iRegionWidth * (2 * group_radius + 1); -- Set initial value to max possible.
    local best_group = 1; -- Set initial best group as current map edge.
    for row_index, group_land_plots in ipairs(row_groups) do
        if group_land_plots < best_value then
            best_value = group_land_plots;
            best_group = row_index;
        end
    end
    
    -- Determine Y Shift
    local y_shift = best_group - 1;
    return y_shift;
end

function MultilayeredFractal:GenerateFractalLayerWithoutHills(args)
    --[[ This function is intended to be paired with ApplyTectonics. If all the hills and
    mountains plots are going to be overwritten by the tectonics results, then why waste
    calculations generating them? ]]--
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 55;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 1;
    local iRegionPlotFlags = args.iRegionPlotFlags or self.iRoundFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 6;
    local iRegionFracYExp = args.iRegionFracYExp or 5;
    local iRiftGrain = args.iRiftGrain or -1;
    local bShift = args.bShift or true;

    local isolatedCoasts = args.isolatedCoasts;
    --print("Received Region Data");
    --print(iRegionWidth, iRegionHeight, iRegionWestX, iRegionSouthY, iRegionGrain);
    --print("- - -");
    
    -- Init the plot types array for this region's plot data. Redone for each new layer.
    -- Compare to self.wholeworldPlotTypes, which contains the sum of all layers.
    self.plotTypes = {};
    table.fill(self.plotTypes, g_PLOT_TYPE_OCEAN, iRegionWidth * iRegionHeight);
    
    --print("Filled regional table.");

    -- Init the land/water fractal
    local regionContinentsFrac;
    if (iRiftGrain > 0) and (iRiftGrain < 4) then
        local riftsFrac = Fractal.Create(
            iRegionWidth, iRegionHeight, iRiftGrain, {}, iRegionFracXExp, iRegionFracYExp);
        regionContinentsFrac = Fractal.CreateRifts(
            iRegionWidth, 
            iRegionHeight, 
            iRegionGrain, 
            iRegionPlotFlags, 
            riftsFrac, 
            iRegionFracXExp, 
            iRegionFracYExp);
    else
        regionContinentsFrac = Fractal.Create(
            iRegionWidth, 
            iRegionHeight, 
            iRegionGrain, 
            iRegionPlotFlags, 
            iRegionFracXExp, 
            iRegionFracYExp);    
    end
    --print("Initialized main fractal");
    
    -- Using the fractal matrices we just created, determine fractal-height values for sea level.
    local iWaterThreshold = GetFractalHeight(regionContinentsFrac, iWaterPercent);

    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            local val = regionContinentsFrac:GetHeight(x,y);
            if val <= iWaterThreshold then
                --do nothing
            else
                self.plotTypes[i] = g_PLOT_TYPE_LAND
            end
        end
    end
    
    --print("Generated Plot Types");
    
    if bShift then -- Shift plots to obtain a more natural shape.
        self:ShiftRegionPlots(iRegionWidth, iRegionHeight);
    end

    --print("Shifted Plots");

    if isolatedCoasts then
        --print("Isolating fractal layer from base map's coasts.");
        -- Create a reference map to make it easier to tell whether
        -- the layer's coast touches the destination map's coast.
        -- Represent both existing land and existing coastal water as land.
        local expandedDestPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                
                if (self.wholeworldPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                    -- dest plot.
                    expandedDestPlotTypes[i] = self.wholeworldPlotTypes[i];
                elseif IsAdjacentToLand(self.wholeworldPlotTypes, x, y) then
                    -- dest coast.
                    expandedDestPlotTypes[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
        
        -- Another pass to wrap a 2nd layer of land around the landmass reference.
        local doubleDestPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                
                if (expandedDestPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                    -- Expanded landmass plot.
                    doubleDestPlotTypes[i] = expandedDestPlotTypes[i];
                elseif IsAdjacentToLand(expandedDestPlotTypes, x, y) then
                    -- Expanded landmass coast.
                    doubleDestPlotTypes[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
        
        -- Filter the source map to avoid touching the destination map's land.
        for x = 0, iRegionWidth - 1, 1 do
            local wholeworldX = x + iRegionWestX;
            for y = 0, iRegionHeight - 1, 1 do
                local i = y * iRegionWidth + x + 1;
                local wholeworldY = y + iRegionSouthY;
                local iWorld = GetPlotIndexLua(wholeworldX, wholeworldY);
                
                if ( (self.plotTypes[i] ~= g_PLOT_TYPE_OCEAN) and
                     ((doubleDestPlotTypes[iWorld] ~= g_PLOT_TYPE_OCEAN) or 
                        IsAdjacentToLand(doubleDestPlotTypes, wholeworldX, wholeworldY)) ) then
                        
                    -- A layer plot is within 3 plots of
                    -- the dest land. So erase the layer's land plot.
                    self.plotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end

    -- Once the plot types for the region have been generated, they must be
    -- applied to the global plot array.
    --
    -- Default approach is to ignore water and layer the lands over one another.
    -- Land of any type in each new layer overwrites whatever had been there.
    -- If you want to layer the water, too, or some other method, then
    -- you need to replace this function with a custom version, in your script.
    --
    -- Apply the region's plots to the global plot array.
    for x = 0, iRegionWidth - 1, 1 do
        local wholeworldX = x + iRegionWestX;
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1;
            
            -- Check for land to exclude both ocean and nil.
            if self.plotTypes[i] == g_PLOT_TYPE_LAND then
                local wholeworldY = y + iRegionSouthY;
                local iWorld = GetPlotIndexLua(wholeworldX, wholeworldY);
                self.wholeworldPlotTypes[iWorld] = self.plotTypes[i];
            end
        end
    end
    
    --print("Applied region's plots to global plot array.");

    -- This region is done.
    return
end

function MultilayeredFractal:GenerateWaterLayer(args)
    -- This function is intended to allow adding seas to specific areas of large continents.
    --
    -- Usage: Because of how the Shift operation works, we have to treat the "water" we are
    -- trying to place in this layer as "land", until the shift (if any) has occurred. Once
    -- the shift is done, the actual layering of the plots is handled by turning any "land"
    -- plots from this layer in to water plots when applied to the whole world plot table.
    -- This is all under the hood. The only thing is that the WaterPercent in the args table
    -- does NOT apply to the water you are trying to place, but rather the dead space where
    -- no changes will occur. Put another way, you should treat this layer of water as if
    -- it were an island or continent you are trying to add, except that in actual placement
    -- it will come out as water in the end, letting you place a sea inside a larger piece 
    -- of land, or a bay that eats in to a continent from the sea. -- Sirian
    local args = args or {};
    
    -- Handle args or assign defaults.
    local iWaterPercent = args.iWaterPercent or 55;
    local iRegionWidth = args.iRegionWidth; -- Mandatory Parameter, no default
    local iRegionHeight = args.iRegionHeight; -- Mandatory Parameter, no default
    local iRegionWestX = args.iRegionWestX; -- Mandatory Parameter, no default
    local iRegionSouthY = args.iRegionSouthY; -- Mandatory Parameter, no default
    local iRegionGrain = args.iRegionGrain or 1;
    local iRegionPlotFlags = args.iRegionPlotFlags or self.iRoundFlags;
    local iRegionFracXExp = args.iRegionFracXExp or 6;
    local iRegionFracYExp = args.iRegionFracYExp or 5;
    local iRiftGrain = args.iRiftGrain or -1;
    local bShift = args.bShift or true;

    -- Init the plot types array for this region's plot data. Redone for each new layer.
    -- Compare to self.wholeworldPlotTypes, which contains the sum of all layers.
    self.plotTypes = {};
    table.fill(self.plotTypes, g_PLOT_TYPE_OCEAN, iRegionWidth * iRegionHeight);
    
    -- Init the land/water fractal
    local regionContinentsFrac;
    if (iRiftGrain > 0) and (iRiftGrain < 4) then
        local riftsFrac = Fractal.Create(
            iRegionWidth, iRegionHeight, iRiftGrain, {}, iRegionFracXExp, iRegionFracYExp);
        regionContinentsFrac = Fractal.CreateRifts(
            iRegionWidth, 
            iRegionHeight, 
            iRegionGrain, 
            iRegionPlotFlags, 
            riftsFrac, 
            iRegionFracXExp, 
            iRegionFracYExp);
    else
        regionContinentsFrac = Fractal.Create(
            iRegionWidth, 
            iRegionHeight, 
            iRegionGrain, 
            iRegionPlotFlags, 
            iRegionFracXExp, 
            iRegionFracYExp);    
    end
    
    -- Using the fractal matrices we just created, determine fractal-height values for sea level.
    local iWaterThreshold = GetFractalHeight(regionContinentsFrac, iWaterPercent);

    -- Loop through the region's plots
    for x = 0, iRegionWidth - 1, 1 do
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1; -- Lua arrays start at 1.
            local val = regionContinentsFrac:GetHeight(x,y);
            if val <= iWaterThreshold then
                --do nothing
            else
                self.plotTypes[i] = g_PLOT_TYPE_LAND
            end
        end
    end
    
    if bShift then -- Shift plots to obtain a more natural shape.
        self:ShiftRegionPlots(iRegionWidth, iRegionHeight);
    end

    -- Apply the region's plots to the global plot array.
    for x = 0, iRegionWidth - 1, 1 do
        local wholeworldX = x + iRegionWestX;
        for y = 0, iRegionHeight - 1, 1 do
            local i = y * iRegionWidth + x + 1
            
            -- Check for land to exclude both ocean and nil.
            if self.plotTypes[i] == g_PLOT_TYPE_LAND then
                local wholeworldY = y + iRegionSouthY;
                local iWorld = wholeworldY * g_iW + wholeworldX + 1
                self.wholeworldPlotTypes[iWorld] = g_PLOT_TYPE_OCEAN
            end
        end
    end
    
    -- This region is done.
    return
end

function MultilayeredFractal:AddMtsHillsExtras()
    -- Add mountains, hills, and extra islands to the plot-types map.
    --
    -- This method replaces MLF:ApplyTectonics.
    GenerateMtnsHillsAndExtras(self.wholeworldPlotTypes);
end

function MultilayeredFractal:Bagels_GeneratePlotsByRegion()
    -- Bagels    
    
    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);

    -- Args to pass into the per-bagel-slice helper function.
    -- Each bagel slice is basically a large mini-donut.
    local bagelArgs = {wrapX = ScriptData.wrapX};
        
    -- Get user inputs.
    local sea_level = UserInput.seaLevel;
    
    -- Bagel integrity.
    -- Controls the frequency of bays/lakes
    local baysHeights = {88, 84, 80, 76, 72};
    local baysHeight  = baysHeights[sea_level];
    
    -- higher number => more land for bagels
    bagelArgs.baysHeight = baysHeight;
    print("Bays Height ", bagelArgs.baysHeight);
    
    
    -- Use a cell system to distribute donuts across the map.
    -- Divide the map into half a dozen cells in 3x2 grid by default.
    local numCellColumns = 3;
    local numCellRows    = 2;
    local numEmptyCells  = 2;
    
    -- Check the aspect ratio of the grid.
    local ratio   = g_iW / g_iH; -- We've got bigger problems if H is 0.
    local epsilon = 0.1;
    
    if (ratio > (4 - epsilon)) then
        -- Got a 4:1 grid.
        print("Using 4x1 bagel grid (custom 4:1 aspect ratio)");
        numCellColumns = 4;
        numCellRows    = 1;
        numEmptyCells  = 1;
    
    elseif (ratio > (3 - epsilon)) then
        -- Got a 3:1 grid.
        print("Using 3x1 bagel grid (custom 3:1 aspect ratio)");
        numCellRows   = 1;
        numEmptyCells = 1;
        
    elseif (ratio > (2 - epsilon)) then
        -- Got a 2:1 grid.
        print("Using 4x2 bagel grid (custom 2:1 aspect ratio)");
        numCellColumns = 4;
        numEmptyCells  = 3;
        
    elseif (ratio < (1 + epsilon)) then
        -- Got a square
        print("Using 2x2 bagel grid (custom 1:1 aspect ratio)");
        numCellColumns = 2;
        numEmptyCells  = 1;
    end

    local numCells = numCellColumns * numCellRows;
    
    -- Use floating numbers here; will round when calculating cell boundaries.
    local cellWidth  = g_iW / numCellColumns;
    local cellHeight = g_iH / numCellRows;
    local cellLength = math.min(cellWidth, cellHeight);
    print("Cell size (w,h): ",  CoordString(cellWidth, cellHeight));
    
    -- Min/Max bagel radius based on cell size.
    -- A bagel radius of cellLength/2 would force the bagel to be at the
    -- center of the cell, so use something smaller for wiggle-room.
    local bagelSize = math.max(Round(cellLength*0.4), 1);
    bagelSize = bagelSize + UP_TO_DOWN2[sea_level];
    bagelArgs.rMin  = bagelSize;
    bagelArgs.rMax  = bagelSize;
    local     rMax  = bagelArgs.rMax;
    print("Radius: ", bagelSize);
    
    
    -- Min/Max bagel thickness as percentages of radius.
    bagelArgs.tMin = 50;
    bagelArgs.tMax = 75;
    print("Thickness range: ", CoordString(
        Round(bagelArgs.tMin*rMax/100), Round(bagelArgs.tMax*rMax/100)));

    
    -- Choose random cells to be empty so that there is ocean somewhere.
    local cellEmpty = 0;
    local cellBagel = 1;
    local cellTypes = table.fill(cellBagel, numCells);
    for i = 1, numEmptyCells do
        cellTypes[i] = cellEmpty;
    end
    cellTypes = GetShuffledCopyOfTable(cellTypes);
    
    
    -- Add padding to cells to reduce overlap between bagels.
    -- Slightly less than rMax to make cell grid less obvious.
    local cellPaddingX = math.floor(math.clamp(bagelArgs.rMax-1, 0, cellWidth/3));
    local cellPaddingY = math.floor(math.clamp(bagelArgs.rMax-1, 0, cellHeight/3));
    print("Cell padding: ", CoordString(cellPaddingX, cellPaddingY));

        
    -- Boundaries for the current cell.
    local iWestX  = 0;
    local iEastX  = 0;
    local iSouthY = 0;
    local iNorthY = 0;
    local iCell   = 1;
    for iRow = 1, numCellRows do
        -- Advance to the next row.
        iEastX  = 0;
        iSouthY = iNorthY;
        iNorthY = math.floor(iRow * cellHeight);
    
        for iCol = 1, numCellColumns do
            -- Advance to the next column.
            iWestX = iEastX;
            iEastX = math.floor(iCol * cellWidth);
            
            local bagelX, bagelY;
            
            if (cellTypes[iCell] == cellBagel) then
                print("Current cell is " .. CoordString(iWestX, iSouthY) .. 
                      " to " .. CoordString(iEastX, iNorthY));
            
                bagelArgs.enableSlicing = false;
            
                -- Choose a random location for the bagel in the cell.
                bagelX = iWestX + cellPaddingX + 
                    TerrainBuilder.GetRandomNumber(iEastX  - iWestX - 2*cellPaddingX,  "Bagel Cell X");
                    
                bagelY = iSouthY + cellPaddingY + 
                    TerrainBuilder.GetRandomNumber(iNorthY - iSouthY - 2*cellPaddingY, "Bagel Cell Y");

            else
                bagelArgs.enableSlicing = true;
            
                -- Empty cell: a bagel piece could be anywhere on the map.
                bagelX = cellPaddingX + TerrainBuilder.GetRandomNumber(g_iW - 2*cellPaddingX, "Bagel Cell X");
                bagelY = cellPaddingY + TerrainBuilder.GetRandomNumber(g_iH - 2*cellPaddingY, "Bagel Cell Y");
            end
            
            -- Generate the bagel slice using the mini-donut helper function.
            GenerateMiniDonut(self.wholeworldPlotTypes, bagelX, bagelY, bagelArgs);
            
            -- Advance to the next cell.
            iCell = iCell + 1;
        end
    end

    -- Land and water are set. Now apply mountains, hills, and extra islands.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Clusters_GeneratePlotsByRegion()
    -- Clusters / Megacluster
    local clustersGrain = ScriptData.landInfo.clusters_grain;
    
    local lakeLevelOffset = -16;
    if (ExtrasGot.anything == true) then
        -- Got clusters with extras (possibly even more clusters).
        -- Raise the threshold to reduce clusters when there are extras.
        lakeLevelOffset = lakeLevelOffset + 8;
    end
    self.wholeworldPlotTypes = 
            GenerateLakesForClusters(false, clustersGrain, g_iFlags, lakeLevelOffset);    
    
    local connectLand = UserInput.connectLand;
    
    local targetSize = ScriptData.worldSizeInfo.targetClusterSize;
    if connectLand then
        -- Use smaller islands to increase chance of islands inside connected lands.
        targetSize = math.ceil(targetSize*0.6);
    else
        targetSize = targetSize * 2;
    end
    print("Target island size: ", targetSize);
    
    -- Generate mountain pattern.
    GenerateMountainsAndHills();
    
    -- Generate extra islands if applicable.
    local extrasPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    GenerateExtras(extrasPlotTypes);
    
    local isolateCoasts = UserInput.isoCoasts;
    
    if connectLand then
        -- Connected Lands enabled, but we started with a lakes fractal.
        TurnLakesIntoConnectedClusters(self.wholeworldPlotTypes, targetSize);
        
        -- Merge the extra islands.
        local mergeFcn = MergeExtrasAvoidLandmass;
        if isolateCoasts then
            mergeFcn = MergeExtrasAvoidLandmassCoast;
        end
        mergeFcn(true, self.wholeworldPlotTypes, extrasPlotTypes);
        
        -- Override the default major-civ start method of separate areas.
        print("Adjusting landmass-based major starts (Connected Lands).");
        ScriptData.landInfo.aspLandDivMethod = DIVMETHOD_STANDARD;
    else
        -- Merge the extras as water onto the lakes fractal.
        MergeExtras(false, self.wholeworldPlotTypes, extrasPlotTypes);
        
        -- Turn lakes and extras into island clusters.
        TurnLakesIntoClusters(self.wholeworldPlotTypes, targetSize);
    end
    
    if UserInput.freshLakes then
        -- Turn seas into fresh lakes.
        FreshenLakesLandmass(self.wholeworldPlotTypes);
    end
    
    -- Land is set. Now apply hills and mountains.    
    AddMountainsAndHillsToPlotTypes(self.wholeworldPlotTypes);

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Donut_GeneratePlotsByRegion()
    -- Donut
    
    -- Note: fractal wrap flags do not have to match world shape.
    -- Let wrap-x be true here even if the world is flat.
    local fracFlags = {FRAC_WRAP_X = true, FRAC_POLAR = true};

    -- Get user inputs.
    
    -- Special donut filling behavior for sea level:
    -- very low    -> land
    -- low         -> land/water mix a.k.a. "standard"
    -- med         -> ocean with potential extras
    -- high        -> ocean with shallow water instead of extras
    -- very high   -> ocean (overrides all other changes, including extra islands)
    local sea_level = UserInput.seaLevel;
    
    -- Special donut filling for lake level:
    -- very high -> fresh lakes (or salty lakes if coastal expansion is also very high)
    local lake_level = UserInput.lakeLevel;
    
    -- Special donut filling for coastal expansion:
    -- very high -> shallow water
    local coast_exp = UserInput.coastExp;
    
    -- Controls the initial height and width of the donut (before adding bays/lakes)
    --
    -- Don't make this too large (> 95) or else the the landmass will intersect
    -- itself and the poles.
    local axis_multiplier = 0.55;
    
    -- Tiles within this distance to the center are part of the donut's filling.
    local filling_distance = 0.25; -- Original donut seems to be 0.25
    
    -- Tiles between this and the filling distance become mountains
    -- when mountain level is very high.
    local mtn_filling_distance = 0.2;
    
    -- Controls the minimum distance of bays/lakes from the inner/outer edges 
    -- of the donut
    local cohesion_diff = 0.06;
    
    -- Controls the frequency of bays/lakes
    local baysHeights = {94,84,74,64,54}; 
    local baysHeight  = baysHeights[sea_level] or 74;
        
    local inner_cohesion_multiplier = filling_distance + 2*cohesion_diff;
    local outer_cohesion_multiplier = axis_multiplier - cohesion_diff;
                
    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    ScriptData.donutFillingMap = table.fill(FILLING_NO, g_numTiles);

    local donutFillingVal = FILLING_YES;
    if not ENABLE_DONUT_FILLING then
        print("Donut filling disabled.");
        -- Disable donut filling by preventing the donut-filling map 
        -- from having any "Yes" values.
        donutFillingVal = FILLING_NO;
    end

    local centerX = g_iW / 2;
    local centerY = g_iH / 2;   
    local donutWidth = math.max(g_iW, g_iH);
    
    -- Add the donut as land plots.
    local centerS = donutWidth/2;
    local axis = centerS * axis_multiplier;
    local axisSquared = axis * axis;
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local i = GetPlotIndexLua(x,y);
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            
            if ((filling_distance <= d) and (d <= 1)) then
                -- Donut land.
                self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                
            elseif (d < filling_distance) then
                -- Donut filling.
                ScriptData.donutFillingMap[i] = donutFillingVal;
                
                if ((donutFillingVal == FILLING_YES) and 
                    (sea_level == SeaLevels.LOW)) then
                    -- Low sea level: turn donut filling into land, but
                    -- allow some land to become water.
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
    end
    
    -- Now add bays, fjords, inland seas, etc, but not inside the cohesion area.
    local baysGrain = 4;
    local baysFrac = Fractal.Create(g_iW, g_iH, baysGrain, fracFlags, -1, -1);
    local iBaysThreshold = GetFractalHeight(baysFrac, baysHeight);
        
    local axis = centerS * outer_cohesion_multiplier;
    local axisSquared = axis * axis;
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            if d > 1 then
                local i = GetPlotIndexLua(x,y);
                local baysVal = baysFrac:GetHeight(x, y);
                if baysVal >= iBaysThreshold then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end
    
    local axis = centerS * inner_cohesion_multiplier;
    local axisSquared = axis * axis;
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            if d <= 1 then
                local i = GetPlotIndexLua(x,y);
                local baysVal = baysFrac:GetHeight(x, y);
                if baysVal >= iBaysThreshold then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                    -- Count inner cohesion water as part of the donut filling.
                    ScriptData.donutFillingMap[i] = donutFillingVal;
                end
            end
        end
    end
    
    -- Apply mountains, hills, and extra islands.
    self:AddMtsHillsExtras();
        
    -- Override the center of the donut with sweet, sweet filling logic.
    local landFilling  = g_PLOT_TYPE_LAND;
    local waterFilling = g_PLOT_TYPE_OCEAN;
    
    if ((not UserInput.noMountains) and (UserInput.mtnLevel == MountainLevels.VHIGH)) then
        -- very high mountain level: turn water into mountains unless sea level is very high.
        waterFilling = g_PLOT_TYPE_MOUNTAIN;
    end
    
    if ((not UserInput.noHills) and (UserInput.mountains == MtnPatterns.CLUSTERED)) then
        -- Clustered highlands: turn land into hills
        landFilling = g_PLOT_TYPE_HILLS;
    end
    
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local i = GetPlotIndexLua(x,y);
            
            if (ScriptData.donutFillingMap[i] == FILLING_YES) then
                -- Got donut filling.
                if (sea_level == SeaLevels.VHIGH) then
                    -- Very High sea level: all deep water.
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                
                elseif (sea_level == SeaLevels.HIGH) then
                    -- High sea level: mostly water
                    if (self.wholeworldPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                        -- Replace land with water filling;
                        -- use shallow water instead of ocean.
                        self.wholeworldPlotTypes[i] = waterFilling;
                        if (waterFilling == g_PLOT_TYPE_OCEAN) then
                            ScriptData.coastPlots[i] = g_PLOT_TYPE_LAND;
                        end
                    end                    
                elseif (sea_level == SeaLevels.VLOW) then
                    -- Very Low sea level: all land
                    self.wholeworldPlotTypes[i] = landFilling;
                
                elseif (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN) then
                    self.wholeworldPlotTypes[i] = waterFilling;
                    
                elseif (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_LAND) then
                    self.wholeworldPlotTypes[i] = landFilling;
                end
            end
        end
    end
    
    if (lake_level == LakeLevels.VHIGH) then
        -- Turn the donut filling water into lakes.
        local lakeMaxNumTiles = LAKE_MAXNUMTILES; -- Fresh lakes by default.
        if (coast_exp == CoastalExpansion.VHIGH) then
            -- Allow lakes to become salty.
            lakeMaxNumTiles = 4 * lakeMaxNumTiles;
        end
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                if ((ScriptData.donutFillingMap[i] == FILLING_YES) and 
                    (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN)) then
                    -- Got donut filling water.
                    FreshenLake(self.wholeworldPlotTypes, x, y, lakeMaxNumTiles);
                end
            end
        end
        
    elseif (coast_exp == CoastalExpansion.VHIGH) then
        -- Make the donut filling water shallow.
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                
                if ((ScriptData.donutFillingMap[i] == FILLING_YES) and 
                    (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN)) then
                    -- Got donut filling water.
                    ScriptData.coastPlots[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
    end    
    
    if (UserInput.mtnLevel == MountainLevels.VHIGH) then
        print("Hollowing out mountains from the donut filling.");
        -- Hollow-out mountain ranges, if applicable.
        local mtnsHillsGen = ScriptData.mtnsHillsGen;
        mtnsHillsGen:HollowOutMountainClumps(self.wholeworldPlotTypes);
        mtnsHillsGen:AddLonelyMountains(self.wholeworldPlotTypes);
    end
    
    print("Donut complete.");
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Hex_GeneratePlotsByRegion()
    -- Hex (Hexagon Pangea)
    
    -- Fill all rows with background plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);

    -- Check the aspect ratio of the grid.
    local ratio   = g_iW / g_iH; -- We've got bigger problems if H is 0.
    local epsilon = 0.1;
        
    -- Determine the shape of the pagnea using map aspect ratio.
    local HexShapeFcn = GeneratePangeaEquilateralHex;    
    if (ratio > (3 - epsilon)) then
        -- Got a 3:1 or wider grid
        print("Optimizing pangea shape for ultra-wide aspect ratio");
        -- Possibly a cropped snowball globe with std sunlight
        -- TODO test this at each map size.
        HexShapeFcn = GeneratePangeaZigZagHex;
        
    elseif (ratio > (2 - epsilon)) then
        -- Got a 2:1 grid.
        print("Optimizing pangea shape for 2:1 aspect ratio");
        -- Use a quad hex which is wider than a regular hex.
        HexShapeFcn = GeneratePangeaQuadHex;
    end
    
    -- Resolve climate granularity for the hex pangea.
    local climGran = UserInput.climGran;
    if (climGran == ClimateGrans.MIXEDCF) then
        -- Mixed Coarse-Fine => randomize
        climGran = 2 + TerrainBuilder.GetRandomNumber(3, "Mixed-CF hex grain");
        print("Climate grain for hex pangea: " .. climGran);
        
    elseif (climGran == ClimateGrans.MIXED) then
        -- Mixed => randomize
        climGran = 1 + TerrainBuilder.GetRandomNumber(5, "Mixed hex grain");
        print("Climate grain for hex pangea: " .. climGran);
    end
    
    -- Hex diameters based on climate granularity.
    -- Diameter is the distance between opposite corners of a hex (including both corners).    
    -- Higher granularity => smaller hexes
    local hexDiameters = {11,9,7,5,3};
    local minDim = math.min(g_iH,g_iW);
    if (minDim < 35) then
        -- Map is too small/narrow to fit regular-sized hexes.
        -- Lower default to 5 for a more normal-looking pangea.
        -- Diameter of 9 is too big to control sea level, so cap at 7
        print("Reducing hex diameter and limiting to 7 due to extremely small/narrow map size.");
        hexDiameters = {7,7,5,3,1};
        
    elseif (minDim < 45) then
        -- Map is too small/narrow to fit regular-sized hexes.
        -- Diameter of 11 is too big to control sea level, so cap at 9
        print("Reducing hex diameter due to tiny map size.");
        hexDiameters = {9,7,5,3,1};
    end
    local hexDiameter = hexDiameters[climGran];
    print("Hex diameter: " .. hexDiameter);
    
    -- Radius is the distance between center and corner inclusive,
    -- and equals the length of each side.
    local hexRadius = math.ceil(hexDiameter/2);
    print("Hex radius:   " .. hexRadius);
    
    -- number of plots in hex = 1 + 3*R*(R-1)
    -- where R = hex radius.
    local numPlotsPerHex = 1 + 3*hexRadius*(hexRadius-1);
    print("Plots/Hex:    " .. numPlotsPerHex);
   
    -- The (x,y) location of the center of the map.
    local mapCenterX = math.floor(g_iW/2);
    local mapCenterY = math.floor(g_iH/2);
    print("Map Center (x,y): " .. CoordString(mapCenterX, mapCenterY));
    
    -- Determine how many plots to draw based on sea level.
    local waterLevel = GetSeaLevel();
    local landLevel  = 100 - waterLevel;
    local targetNumLands = math.clamp(math.ceil(landLevel*g_numTiles/100), 0, g_numTiles);
    
    -- Draw the pangea.
    -- Start with a "core" shape and keep expanding until we meet/exceed target land level.
    local hexes = {};
    HexShapeFcn(
        self.wholeworldPlotTypes, 
        mapCenterX, mapCenterY, 
        hexRadius, hexes,
        0, targetNumLands);
    
    if (hexRadius > 1) then
        -- Allow later stages of the map script to manipulate the pangea's hexes.
        print("Generated " .. #hexes .. " hex(es).");
        ScriptData.hexMap = 
        {
            radius         = hexRadius,
            numPlotsPerHex = numPlotsPerHex,
            hexes          = hexes
        };
    end
       
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:InlandSea_GeneratePlotsByRegion()
    -- Inland Sea
    -- Use sea level input for lake size.
    -- Lake density is inversely proportional to sea level
    local lakes      = GetSeaLevel();
    local lake_grain = ScriptData.landInfo.lake_grain;
    
    
    if (ScriptData.wrapX) then
        -- Raise water levels to compensate for margins near map edges.
        lakes = lakes - 20;
    end
    
    if (ExtrasGot.anything == true) then
        -- Raise water levels to compensate for extra islands.
        lakes = lakes - 6;
    end
    
    -- Avoid wrapping lakes around the edges, even for globe maps.
    local fracFlags = {FRAC_POLAR = true};
    
    if (ScriptData.wrapX) then
        -- Use a globe-specific lake fractal.
        self.wholeworldPlotTypes = GenerateLakesFractal(lakes, lake_grain, fracFlags);
    else
        -- Fill all rows with land plots.
        self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_LAND, g_numTiles);
            
        -- Add margins so that edges are relatively dry.
        local marginX = math.max(1,math.floor(0.05*g_iW));
        local marginY = math.max(1,math.floor(0.05*g_iH));
        
        local iWestX = marginX;
        local iEastX = g_iW - marginX;
        local iWidth = iEastX - iWestX;
        
        local iSouthY = marginY;
        local iNorthY = g_iH - marginY;
        local iHeight = iNorthY - iSouthY;
        
        local lakesFrac = Fractal.Create(iWidth, iHeight, lake_grain, fracFlags, -1, -1)
        local lakesThreshold = GetFractalHeight(lakesFrac, lakes);
        
        for y = iSouthY, iNorthY do
            for x = iWestX, iEastX do
                local val = lakesFrac:GetHeight(x, y);
                if val >= lakesThreshold then
                    local i = GetPlotIndexLua(x,y);
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    
        -- Second, oval layer to increase the chance of one main body of water.
        local centerX = (g_iW / 2) - 1;
        local centerY = (g_iH / 2) - 1;
        local xAxis = centerX * 0.75;
        local yAxis = centerY * 0.5;
        local xAxisSquared = xAxis * xAxis;
        local yAxisSquared = yAxis * yAxis;
        for x = 0, g_iW - 1 do
            for y = 0, g_iH - 1 do
                local i = GetPlotIndexLua(x,y);
                local deltaX = x - centerX;
                local deltaY = y - centerY;
                local deltaXSquared = deltaX * deltaX;
                local deltaYSquared = deltaY * deltaY;
                local oval_value = deltaXSquared / xAxisSquared + deltaYSquared / yAxisSquared;
                if oval_value <= 1 then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end

    -- Land and water are set.
    -- Now apply hills, mountains, etc.
    self:AddMtsHillsExtras();
    
    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:InvertedDonut_GeneratePlotsByRegion()
    -- Inverted Donut landmass
    
    -- Note: fractal wrap flags do not have to match world shape.
    -- Let wrap-x be true here even if the world is flat.
    local fracFlags = {FRAC_WRAP_X = true, FRAC_POLAR = true};
    
    -- Get user inputs.
        
    -- Special donut filling behavior for sea level:
    -- very low    -> land
    -- low         -> land with potential extra lakes
    -- med         -> land/water mix a.k.a. "standard" with potential extra lakes
    -- high        -> ocean with shallow water where extra lakes were added..ok
    -- very high   -> ocean 
    local sea_level = UserInput.seaLevel;
    
    -- Special donut filling for lake level:
    -- very high -> fresh lakes (or salty lakes if coastal expansion is also very high)
    local lake_level = UserInput.lakeLevel;
    
    -- Special donut filling for coastal expansion:
    -- very high -> shallow water
    local coast_exp = UserInput.coastExp;
    
    -- Controls the initial height and width of the donut (before adding bays/lakes)
    --
    -- Don't make this too large (> 0.65)
    -- or else the the donut sea will divide the land into continents.
    local axis_multiplier = 0.56;
    
    -- Tiles within this distance to the center are part of the donut's filling.
    local filling_distance = 0.25; -- Original donut seems to be 0.25
    
    -- Tiles between this and the filling distance become mountains
    -- when mountain level is very high
    local mtn_filling_distance = 0.2;
    
    -- Controls the minimum distance of bays/lakes from the inner/outer edges 
    -- of the donut
    local cohesion_diff = 0.06;
    
    -- Controls the frequency of bays/lakes
    local baysHeights = {54,64,74,84,94};
    local baysHeight  = baysHeights[sea_level] or 74;
        
    local inner_cohesion_multiplier = filling_distance + 2*cohesion_diff;
    local outer_cohesion_multiplier = axis_multiplier - cohesion_diff;
                
    -- Fill all rows with land plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_LAND, g_numTiles);
    ScriptData.donutFillingMap = table.fill(FILLING_NO, g_numTiles);

    local donutFillingVal = FILLING_YES;
    if not ENABLE_DONUT_FILLING then
        print("Donut filling disabled.");
        -- Disable donut filling by preventing the donut-filling map 
        -- from having any "Yes" values.
        donutFillingVal = FILLING_NO;
    end
    
    local centerX = g_iW / 2;
    local centerY = g_iH / 2;   
    local donutWidth = math.max(g_iW, g_iH);
    
    -- Add the donut as water plots.
    local centerS = donutWidth/2;
    local axis = centerS * axis_multiplier;
    local axisSquared = axis * axis;
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local i = GetPlotIndexLua(x,y);
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            
            if ((filling_distance <= d) and (d <= 1)) then
                -- Donut water.
                self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                
            elseif (d < filling_distance) then
                -- Donut filling, which is initially land.
                ScriptData.donutFillingMap[i] = donutFillingVal;
            end
        end
    end
    
    -- Now add bays, islands, etc, but not inside the cohesion area.
    local baysGrain = 4;
    local baysFrac = Fractal.Create(g_iW, g_iH, baysGrain, fracFlags, -1, -1);
    local iBaysThreshold = GetFractalHeight(baysFrac, baysHeight);
        
    local axis = centerS * outer_cohesion_multiplier;
    local axisSquared = axis * axis;
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            if d > 1 then
                local i = GetPlotIndexLua(x,y);
                local baysVal = baysFrac:GetHeight(x, y);
                if baysVal >= iBaysThreshold then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
    end
    
    local axis = centerS * inner_cohesion_multiplier;
    local axisSquared = axis * axis;
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/axisSquared + deltaYSquared/axisSquared;
            if d <= 1 then
                local i = GetPlotIndexLua(x,y);
                local baysVal = baysFrac:GetHeight(x, y);
                if baysVal >= iBaysThreshold then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                    -- Count inner cohesion land as part of the donut filling.
                    ScriptData.donutFillingMap[i] = donutFillingVal;
                elseif ((donutFillingVal == FILLING_YES) and 
                        (sea_level == SeaLevels.STANDARD)) then
                    -- Turn some land into ocean for land/water mix.
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end
    
    -- Apply mountains, hills, and extra lakes.
    self:AddMtsHillsExtras();
        
    -- Override the center of the donut with sweet, sweet filling logic.
    local landFilling  = g_PLOT_TYPE_LAND;
    local waterFilling = g_PLOT_TYPE_OCEAN;
    
    if ((not UserInput.noMountains) and (UserInput.mtnLevel == MountainLevels.VHIGH)) then
        -- very high mountain level: turn water into mountains unless sea level is very high.
        waterFilling = g_PLOT_TYPE_MOUNTAIN;
    end
    
    if ((not UserInput.noHills) and (UserInput.mountains == MtnPatterns.CLUSTERED)) then
        -- Clustered highlands: turn land into hills
        landFilling = g_PLOT_TYPE_HILLS;
    end
    
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local i = GetPlotIndexLua(x,y);
            
            if (ScriptData.donutFillingMap[i] == FILLING_YES) then
                -- Got donut filling.
                if (sea_level == SeaLevels.VHIGH) then
                    -- Very Low sea level: all deep water.
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                
                elseif (sea_level == SeaLevels.HIGH) then
                    -- High sea level: mountains or mix of shallow and deep water
                    if (self.wholeworldPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
                        -- Replace land with water filling;
                        self.wholeworldPlotTypes[i] = waterFilling;
                        
                    elseif ((self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN) and
                            (waterFilling == g_PLOT_TYPE_OCEAN)) then
                        -- Water added by extras.
                        -- Use shallow water instead of ocean.
                        ScriptData.coastPlots[i] = g_PLOT_TYPE_LAND;
                    end

                elseif (sea_level == SeaLevels.VLOW) then
                    -- Very Low sea level: all land
                    self.wholeworldPlotTypes[i] = landFilling;
                
                elseif (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN) then
                    self.wholeworldPlotTypes[i] = waterFilling;
                    
                elseif (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_LAND) then
                    self.wholeworldPlotTypes[i] = landFilling;
                end
            end
        end
    end
    
    if (lake_level == LakeLevels.VHIGH) then
        -- Turn the donut filling water into lakes.
        local lakeMaxNumTiles = LAKE_MAXNUMTILES; -- Fresh lakes by default.
        if (coast_exp == CoastalExpansion.VHIGH) then
            -- Allow lakes to become salty.
            lakeMaxNumTiles = 4 * lakeMaxNumTiles;
        end
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                if ((ScriptData.donutFillingMap[i] == FILLING_YES) and 
                    (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN)) then
                    -- Got donut filling water.
                    FreshenLake(self.wholeworldPlotTypes, x, y, lakeMaxNumTiles);
                end
            end
        end
        
    elseif (coast_exp == CoastalExpansion.VHIGH) then
        -- Make the donut filling water shallow.
        for y = 0, g_iH - 1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                if ((ScriptData.donutFillingMap[i] == FILLING_YES) and 
                    (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN)) then
                    -- Got donut filling water.
                    ScriptData.coastPlots[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
    end    
    
    if (UserInput.mtnLevel == MountainLevels.VHIGH) then
        print("Hollowing out mountains from the donut filling.");
        -- Hollow-out mountain ranges, if applicable.
        local mtnsHillsGen = ScriptData.mtnsHillsGen;
        mtnsHillsGen:HollowOutMountainClumps(self.wholeworldPlotTypes);
        mtnsHillsGen:AddLonelyMountains(self.wholeworldPlotTypes);
    end
    
    print("Inverted Donut complete.");    
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:InvertedExtras_GeneratePlotsByRegion()
    -- Inverted Extras landmass    
    -- Fill all rows with land plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_LAND, g_numTiles);
    
    -- Apply mountains, hills, and extra lakes.
    self:AddMtsHillsExtras();
    
    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:IslandPlates_GeneratePlotsByRegion()
    -- Island Plates

    -- Get user inputs.
    local fracFlags = {};
    local diffBase  = 4;
    local seaDiff   = DOWN_TO_UP2[UserInput.seaLevel] or 0;
    seaDiff = seaDiff * diffBase;

    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
        
    -- Large islands layer.
    local args = {};
    args.iWaterPercent = seaDiff + 76; -- 65;
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 3;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = fracFlags;
    args.iRegionFracXExp = 7;
    args.iRegionFracYExp = 6;
    self:GenerateFractalLayerWithoutHills(args);
    
    -- Bays layer
    -- Do this before adding small islands so that we don't fracture
    -- small islands or extras into tiny islands.
    local args = {};
    args.iWaterPercent = 84 - seaDiff; -- seaDiff + 90
    args.iRegionWidth = math.ceil(g_iW);
    args.iRegionHeight = math.ceil(g_iH);
    args.iRegionWestX = math.floor(0);
    args.iRegionSouthY = math.floor(0);
    args.iRegionGrain = 4;
    args.iRegionHillsGrain = 4;
    args.iRegionPlotFlags = fracFlags;
    args.iRegionFracXExp = 7;
    args.iRegionFracYExp = 6;
    args.iRiftGrain = -1;
    self:GenerateWaterLayer(args);
    
    if (ExtrasGot.anything == false) then
        -- Small islands layer for when there are no extras.
        local args = {};
        args.iWaterPercent = seaDiff + 84; -- 95;
        args.iRegionWidth = math.ceil(g_iW);
        args.iRegionHeight = math.ceil(g_iH);
        args.iRegionWestX = math.floor(0);
        args.iRegionSouthY = math.floor(0);
        args.iRegionGrain = 4;
        args.iRegionHillsGrain = 4;
        args.iRegionPlotFlags = fracFlags;
        args.iRegionFracXExp = 7;
        args.iRegionFracYExp = 6;
        self:GenerateFractalLayerWithoutHills(args);
    end
    
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Lakes_GeneratePlotsByRegion()
    -- Lakes, Large Lakes, Seven Seas
    
    -- Use sea level input for lake size.
    -- Lake density is inversely proportional to sea level
    local lakes      = GetSeaLevel();
    local lake_grain = ScriptData.landInfo.lake_grain;
    
    local fracFlags = g_iFlags;
        
    if (ExtrasGot.anything == true) then
        -- Lower water levels to compensate for extra islands.
        lakes = lakes - 6;
    end
    
    if (ScriptData.wrapX) then
        -- Use a globe-specific lake fractal.
        self.wholeworldPlotTypes = GenerateLakesFractal(lakes, lake_grain, fracFlags);
    else
        -- Fill all rows with land plots.
        self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_LAND, g_numTiles);
    
        -- Avoid wrapping lakes around the edges.
        fracFlags = {FRAC_POLAR = true};
        
        local marginX = 0;
        local marginY = 0;
        
        local iWestX = marginX;
        local iEastX = g_iW - marginX;
        local iWidth = iEastX - iWestX;
        
        local iSouthY = marginY;
        local iNorthY = g_iH - marginY;
        local iHeight = iNorthY - iSouthY;
        
        local lakesFrac = Fractal.Create(iWidth, iHeight, lake_grain, fracFlags, -1, -1)
        local lakesThreshold = GetFractalHeight(lakesFrac, lakes);
        
        for y = iSouthY, iNorthY do
            for x = iWestX, iEastX do
                local val = lakesFrac:GetHeight(x, y);
                if val >= lakesThreshold then
                    local i = GetPlotIndexLua(x,y);
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end
    
    if (ScriptData.landInfo.gotLakeIslandLayers) then
        -- Island layers for Seven Seas.
        print("Generating island layers.");
        
        local diffBase  = 4;
        local seaDiff   = DOWN_TO_UP2[UserInput.seaLevel] or 0;
        seaDiff = seaDiff * diffBase;
        
        ShiftPlotTypes(self.wholeworldPlotTypes);
        
        -- Generate Medium Islands    
        local args = {};    
        args.iWaterPercent = seaDiff + 80; -- 85
        args.iRegionWidth = math.ceil(g_iW);
        args.iRegionHeight = math.ceil(g_iH);
        args.iRegionWestX = math.floor(0);
        args.iRegionSouthY = math.floor(0);
        args.iRegionGrain = 4;
        args.iRegionHillsGrain = 4;
        args.iRegionPlotFlags = fracFlags;
        args.iRegionFracXExp = 7;
        args.iRegionFracYExp = 6;
        self:GenerateFractalLayerWithoutHills(args);

        if (ExtrasGot.anything == false) then
            -- Tiny islands layer for when there are no extras.
            local args = {};
            args.iWaterPercent = seaDiff + 85; --95 + water_percent;
            args.iRegionWidth = math.ceil(g_iW);
            args.iRegionHeight = math.ceil(g_iH);
            args.iRegionWestX = math.floor(0);
            args.iRegionSouthY = math.floor(0);
            args.iRegionGrain = 4; -- 5
            args.iRegionHillsGrain = 4;
            args.iRegionPlotFlags = fracFlags;
            args.iRegionFracXExp = 7;
            args.iRegionFracYExp = 6;
            self:GenerateFractalLayerWithoutHills(args);
        end
    end

    -- Land and water are set.
    -- Now apply hills, mountains, etc.
    self:AddMtsHillsExtras();
    
    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:LargeIslands_GeneratePlotsByRegion()
    -- Large Islands.
    
    -- Get user inputs.
    local sea_level = UserInput.seaLevel;

    -- Get the number of civs based on map size.
    local iNumCivs = ScriptData.worldSizeInfo.numCivs or 8;
    
    -- Use Sea Level to change the target number of large islands.
    local island_multipliers = {2.3, 2, 1.65, 1.3, 1};
    local island_multiplier  = island_multipliers[sea_level]; -- used to be 1.65 always
    
    -- Use Sea Level to change the target number of occupied cells.
    --
    -- We don't need to lower this for high sea level since we'll be making less
    -- large islands anyway.
    --
    -- Raise the multiplier for low sea level so that we have a higher chance of 
    -- fitting more large islands into the map.
    local cell_multipliers   = {1.0, 0.8, 0.7, 0.7, 0.7};
    local cell_multiplier    = cell_multipliers[sea_level]; -- used to be 0.7 always
    
    -- A cell system will be used to generate the large islands.
    -- Define the cell traits. (These need to fit correctly with the map grid width and height.)
    local iCellWidth = 5;
    local iCellHeight = 4;
    local iNumCellColumns = math.floor(g_iW / iCellWidth);
    local iNumCellRows = math.floor(g_iH / iCellHeight);
    local iNumTotalCells = iNumCellColumns * iNumCellRows;
    local cell_data = table.fill(false, iNumTotalCells) -- Stores data on map cells in use. All cells begin as empty.
    local iNumCellsInUse = 0;
    local iNumCellTarget = math.floor(iNumTotalCells * cell_multiplier);

    -- Add randomly generated island groups
    local iNumGroups = math.floor(iNumCivs * island_multiplier);
    print("-"); print("- Target number of Large Islands: ", iNumGroups); print("-");
    local cannot_find_valid_cell = false;
    for group = 1, iNumGroups do
        if iNumCellsInUse >= iNumCellTarget or cannot_find_valid_cell == true then
            -- Map has reeached desired island population.
            print("-"); print("** Cannot place all Large Islands. Actual number placed: ", group - 1); print("-");
            break
        end
        
        --print("Group ", group);
        --CheckForNilPlotTypes(self.wholeworldPlotTypes);
        
        --[[ Formation Chart
        1. Rectangle 4x2
        2. Rectangle 2x4
        3. Rectangle 3x3 ]]--
        --
        -- Choose a formation
        local rate_threshold = {};
        local total_appearance_rate, iNumFormations = 0, 0;
        local appearance_rates = { -- These numbers are relative to one another. No specific target total is necessary.
            5, -- #1
            5, -- #2
            6, -- #3
        };
        for i, rate in ipairs(appearance_rates) do
            total_appearance_rate = total_appearance_rate + rate;
            iNumFormations = iNumFormations + 1;
        end
        local accumulated_rate = 0;
        for index = 1, iNumFormations do
            local threshold = (appearance_rates[index] + accumulated_rate) * 10000 / total_appearance_rate;
            table.insert(rate_threshold, threshold);
            accumulated_rate = accumulated_rate + appearance_rates[index];
        end
        local formation_type;
        local diceroll = TerrainBuilder.GetRandomNumber(10000, "Choose formation type - Island Making - Lua");
        for index, threshold in ipairs(rate_threshold) do
            if diceroll <= threshold then -- Choose this formation type.
                formation_type = index;
                break
            end
        end
        -- Choose cell(s) not in use;
        local iNumAttemptsToFindOpenCells = 0;
        local found_unoccupied_cell = false;
        local anchor_cell, cell_x, cell_y, foo;
        while found_unoccupied_cell == false and cannot_find_valid_cell == false do
            if iNumAttemptsToFindOpenCells > 100 then -- Too many attempts on this pass. Might not be any valid locations.
                cannot_find_valid_cell = true;
            else
                local diceroll = 1 + TerrainBuilder.GetRandomNumber(iNumTotalCells, "Choosing a cell for an island group");
                if cell_data[diceroll] == false then -- Anchor cell is unoccupied.
                    -- If formation type is multiple-cell, all secondary cells must also be unoccupied.
                    if formation_type == 1 then -- horizontal, 4x2.
                        -- Check to see if anchor cell is too near to an edge. If so, reject.
                        cell_x = math.fmod(diceroll, iNumCellColumns);
                        if cell_x ~= 0 and cell_x < iNumCellColumns - 2 then
                            cell_y, foo = math.modf(diceroll / iNumCellColumns);
                            cell_y = cell_y + 1;
                            if cell_y < iNumCellRows then 
                                -- Anchor cell is valid. Still have to check the other cells.
                                if cell_data[diceroll + iNumCellColumns] == false then
                                    if cell_data[diceroll + 1] == false and cell_data[diceroll + 2] == false then
                                        if cell_data[diceroll + 3] == false then
                                            if cell_data[diceroll + iNumCellColumns + 1] == false then
                                                if cell_data[diceroll + iNumCellColumns + 2] == false then
                                                    if cell_data[diceroll + iNumCellColumns + 3] == false then
                                                        -- All cells are open.
                                                        anchor_cell = diceroll;
                                                        found_unoccupied_cell = true;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elseif formation_type == 2 then -- vertical, 2x4.
                        -- Check to see if anchor cell is too near to an edge. If so, reject.
                        cell_x = math.fmod(diceroll, iNumCellColumns);
                        if cell_x ~= 0 then
                            cell_y, foo = math.modf(diceroll / iNumCellColumns);
                            cell_y = cell_y + 1;
                            if cell_y < iNumCellRows - 2 then
                                -- Anchor cell is valid. Still have to check the other cells.
                                if cell_data[diceroll + iNumCellColumns] == false then
                                    if cell_data[diceroll + 1] == false then
                                        if cell_data[diceroll + iNumCellColumns + 1] == false then
                                            if cell_data[diceroll + (iNumCellColumns * 2)] == false then
                                                if cell_data[diceroll + (iNumCellColumns * 2) + 1] == false then
                                                    if cell_data[diceroll + (iNumCellColumns * 3)] == false then
                                                        if cell_data[diceroll + (iNumCellColumns * 3) + 1] == false then
                                                            -- All cells are open.
                                                            anchor_cell = diceroll;
                                                            found_unoccupied_cell = true;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    elseif formation_type == 3 then -- square, 3x3.
                        -- Check to see if anchor cell is too near to an edge. If so, reject.
                        cell_x = math.fmod(diceroll, iNumCellColumns);
                        if cell_x ~= 0 and cell_x < iNumCellColumns - 1 then
                            cell_y, foo = math.modf(diceroll / iNumCellColumns);
                            cell_y = cell_y + 1;
                            if cell_y < iNumCellRows - 1 then
                                -- Anchor cell is valid. Still have to check the other cells.
                                if cell_data[diceroll + iNumCellColumns] == false then
                                    if cell_data[diceroll + 1] == false and cell_data[diceroll + 2] == false then
                                        if cell_data[diceroll + iNumCellColumns + 1] == false then
                                            if cell_data[diceroll + (iNumCellColumns * 2)] == false then
                                                if cell_data[diceroll + (iNumCellColumns * 2) + 1] == false then
                                                    if cell_data[diceroll + iNumCellColumns + 2] == false then
                                                        if cell_data[diceroll + (iNumCellColumns * 2) + 2] == false then
                                                            -- All cells are open.
                                                            anchor_cell = diceroll;
                                                            found_unoccupied_cell = true;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                iNumAttemptsToFindOpenCells = iNumAttemptsToFindOpenCells + 1;
            end
        end
    
        -- Execute remainder of process on this loop only if a valid cell was found.
        if cannot_find_valid_cell == false then

            -- Find Cell X and Y
            cell_x = math.fmod(anchor_cell, iNumCellColumns);
            if cell_x == 0 then
                cell_x = iNumCellColumns;
            end
            cell_y, foo = math.modf(anchor_cell / iNumCellColumns);
            cell_y = cell_y + 1;

            -- Create this large island.
            local iWidth, iHeight; -- Scope the variables needed for island group creation.
            local iWestX = iCellWidth * (cell_x - 1) + 1;
            local iSouthY = iCellHeight * (cell_y - 1) + 1;
            local iCohesionW, iCohesionH;
            local iCoWestX, iCoSouthY;
            local iWater, iCohesionWater = 55, 60;
            local FracXExp, FracYExp = 5, 5;
            if formation_type == 1 then -- four cells wide, two cells tall.
                iWidth = iCellWidth * 4 - 2;
                iHeight = iCellHeight * 2 - 2;
                FracXExp = 6;
                iCohesionW = math.floor(iWidth/2);
                iCohesionH = math.floor(iHeight/2);
                iCoWestX = iWestX + math.floor(iWidth/4);
                iCoSouthY = iSouthY + math.floor(iHeight/4);
            elseif formation_type == 2 then -- two cells wide, four cells tall.
                iWidth = iCellWidth * 2 - 2;
                iHeight = iCellHeight * 4 - 2;
                FracYExp = 6;
                iCohesionW = math.floor(iWidth/2);
                iCohesionH = math.floor(iHeight/2);
                iCoWestX = iWestX + math.floor(iWidth/4);
                iCoSouthY = iSouthY + math.floor(iHeight/4);
            elseif formation_type == 3 then -- three cells wide, three cells tall.
                iWidth = iCellWidth * 3 - 2;
                iHeight = iCellHeight * 3 - 2;
                iWater = 60;
                iCohesionW = math.floor(iWidth/2);
                iCohesionH = math.floor(iHeight/2);
                iCoWestX = iWestX + math.floor(iWidth/4);
                iCoSouthY = iSouthY + math.floor(iHeight/4);
            end

            -- Execute fractal layers for this Large Island.        
            local args = {};
            args.iWaterPercent = iWater;
            args.iRegionWidth = iWidth;
            args.iRegionHeight = iHeight;
            args.iRegionWestX = iWestX;
            args.iRegionSouthY = iSouthY;
            args.iRegionPlotFlags = self.iRoundFlags;
            args.iRegionFracXExp = FracXExp;
            args.iRegionFracYExp = FracYExp;
            args.iRiftGrain = -1;
            args.isolatedCoasts = UserInput.isoCoasts;

            self:GenerateFractalLayerWithoutHills(args)

            --print("After 1st fractal layer.");
            --CheckForNilPlotTypes(self.wholeworldPlotTypes);
            
            local args = {};
            args.iWaterPercent = iCohesionWater;
            args.iRegionWidth = iCohesionW;
            args.iRegionHeight = iCohesionH;
            args.iRegionWestX = iCoWestX;
            args.iRegionSouthY = iCoSouthY;
            args.iRegionPlotFlags = self.iRoundFlags;
            args.iRegionFracXExp = FracXExp;
            args.iRegionFracYExp = FracYExp;
            args.iRiftGrain = -1;
            args.isolatedCoasts = UserInput.isoCoasts;

            self:GenerateFractalLayerWithoutHills(args)
    
            -- Record cells in use
            if formation_type == 1 then
                cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
                cell_data[anchor_cell + iNumCellColumns], cell_data[anchor_cell + iNumCellColumns + 1] = true, true;
                cell_data[anchor_cell + 2], cell_data[anchor_cell + 3] = true, true;
                cell_data[anchor_cell + iNumCellColumns + 2], cell_data[anchor_cell + iNumCellColumns + 3] = true, true;
                iNumCellsInUse = iNumCellsInUse + 8;
            elseif formation_type == 2 then
                cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
                cell_data[anchor_cell + iNumCellColumns], cell_data[anchor_cell + iNumCellColumns + 1] = true, true;
                cell_data[anchor_cell + (iNumCellColumns * 2)], cell_data[anchor_cell + (iNumCellColumns * 2) + 1] = true, true;
                cell_data[anchor_cell + (iNumCellColumns * 3)], cell_data[anchor_cell + (iNumCellColumns * 3) + 1] = true, true;
                iNumCellsInUse = iNumCellsInUse + 8;
            elseif formation_type == 3 then
                cell_data[anchor_cell], cell_data[anchor_cell + 1], cell_data[anchor_cell + 2] = true, true, true;
                cell_data[anchor_cell + iNumCellColumns], 
                cell_data[anchor_cell + iNumCellColumns + 1], 
                cell_data[anchor_cell + iNumCellColumns + 2] = true, true, true;
                cell_data[anchor_cell + (iNumCellColumns * 2)], 
                cell_data[anchor_cell + (iNumCellColumns * 2) + 1], 
                cell_data[anchor_cell + (iNumCellColumns * 2) + 2] = true, true, true;
                iNumCellsInUse = iNumCellsInUse + 9;
            end
        end
    end

    --print("Before adding mountains, hills, extras.");
    --CheckForNilPlotTypes(self.wholeworldPlotTypes);
    
    -- Land and water are set. Now apply mountains, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Maze_GeneratePlotsByRegion()
    -- Maze
    -- Get user inputs.
    local sea_level = GetSeaLevel();

    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_iW * g_iH);
    
    -- Use a fractal to create isolated clumps of land.
    local landGrain  = 3 + TerrainBuilder.GetRandomNumber(3, "Random grain")
    local landFrac   = Fractal.Create(g_iW, g_iH, landGrain, g_iFlags, -1, -1)
    local landThresh = GetFractalHeight(landFrac, sea_level);
    
    -- Use a pangea-shaped fractal to decide where to allow isolated clumps.
    local panGrain  = 1;
    local panFrac   = Fractal.Create(g_iW, g_iH, panGrain, g_iFlags, -1, -1)
    local panThresh = GetFractalHeight(panFrac, sea_level-10);
    
    for y = 0, g_iH do
        for x = 0, g_iW do
            local panVal = panFrac:GetHeight(x,y);
            if (panVal >= panThresh) then        
                local landVal = landFrac:GetHeight(x,y);
                if landVal >= landThresh then
                    local i = y * g_iW + x + 1; -- add one because Lua arrays start at 1
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                end
            end
        end
    end
    
    -- Use PassMaker to connect the islands with land bridges.
    ConnectLands(self.wholeworldPlotTypes);
    
    -- Use a bay fractal to carve bays into the land.
    local bayGrain  = 3;
    local bayFrac   = Fractal.Create(g_iW, g_iH, bayGrain, g_iFlags, -1, -1)
    local bayThresh = GetFractalHeight(bayFrac, 72);
    
    for y = 0, g_iH do
        for x = 0, g_iW do
            local bayVal = bayFrac:GetHeight(x,y);
            if (bayVal >= bayThresh) then        
                local i = y * g_iW + x + 1; -- add one because Lua arrays start at 1
                self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
            end
        end
    end
    
    -- Reunite the lands with another pass of PassMaker.
    ConnectLands(self.wholeworldPlotTypes);
    
    -- Count the number of water tiles.
    local numWaterTiles = 0;
    for y = 0, g_iH do
        for x = 0, g_iW do
            local i = y * g_iW + x + 1;
            if (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN) then
                numWaterTiles = numWaterTiles + 1;
            end
        end
    end
    local curWaterPct = Round(100.0 * (numWaterTiles / g_numTiles));
    
    local maxNumAttempts = 100;
    local iAttempt = 0;
    while ((sea_level < curWaterPct) and (iAttempt < maxNumAttempts)) do
        -- Sea level is too high.
        -- Add islands and run PassMaker to lower sea level.
        iAttempt = iAttempt + 1;
        print("Need to lower sea level by " .. (curWaterPct - sea_level) .. 
              "% (pass #" .. iAttempt .. ")");
        
        -- Use a fractal to create isolated clumps of land.
        landGrain  = 3 + TerrainBuilder.GetRandomNumber(3, "Random grain")
        landFrac   = Fractal.Create(g_iW, g_iH, landGrain, g_iFlags, -1, -1)
        landThresh = GetFractalHeight(landFrac, sea_level);
        
        -- Use a pangea-shaped fractal to decide where to allow isolated clumps.
        panFrac   = Fractal.Create(g_iW, g_iH, panGrain, g_iFlags, -1, -1)
        panThresh = GetFractalHeight(panFrac, sea_level-10);
        
        for y = 0, g_iH do
            for x = 0, g_iW do
                local panVal = panFrac:GetHeight(x,y);
                if (panVal >= panThresh) then        
                    local landVal = landFrac:GetHeight(x,y);
                    if landVal >= landThresh then
                        local i = y * g_iW + x + 1; -- add one because Lua arrays start at 1
                        self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                    end
                end
            end
        end
        
        ConnectLands(self.wholeworldPlotTypes);
        
        -- Count the number of water tiles.
        numWaterTiles = 0;
        for y = 0, g_iH do
            for x = 0, g_iW do
                local i = y * g_iW + x + 1;
                if (self.wholeworldPlotTypes[i] == g_PLOT_TYPE_OCEAN) then
                    numWaterTiles = numWaterTiles + 1;
                end
            end
        end
        curWaterPct = Round(100 * (numWaterTiles / g_numTiles));
    end
    
    if (sea_level > curWaterPct) then
        -- There is too much land.
        -- Make a shuffled copy of all peninsulas and randomly remove land.
        print("Need to raise sea level by " .. (sea_level - curWaterPct) .. "%");
        
        -- Discover initial peninsulas.
        local peninsulas = {};
        for y = 0, g_iH do
            for x = 0, g_iW do
                local i = y * g_iW + x + 1;
                if IsPeninsula(self.wholeworldPlotTypes, x, y) then
                    table.insert(peninsulas, {x = x, y = y});
                end
            end
        end
        local numPeninsulas = table.maxn(peninsulas);        
        print("Found " .. numPeninsulas .. " peninsula(s).");
        
        -- Shuffle peninsulas for random traversal.
        peninsulas = GetShuffledCopyOfTable(peninsulas);
        
        -- Copy peninsulas into a queue so that we can distribute the land removal across the map
        -- (instead of doing most of the removal in one area).
        local pQueue = Queue:Create();
        for i, p in ipairs(peninsulas) do
            pQueue:Enqueue(p);
        end
        
        local targetNumWaterTiles = Round(g_numTiles * sea_level / 100);
        
        -- Recursively shrink peninsulas until sea level rises to specified level.
        numWaterTiles = ShrinkPeninsulas(
            self.wholeworldPlotTypes, 
            ScriptData.coastPlots, 
            pQueue, 
            numWaterTiles, 
            targetNumWaterTiles);
            
        local curWaterPct = Round(100 * (numWaterTiles / g_numTiles));
        print("Sea Level now at " .. curWaterPct .. "%");
    end
    
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:MiniDonuts_GeneratePlotsByRegion()
    -- Mini Donuts landmass    
    -- Fill all rows with background plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    
    -- Add the landmass version of mini-donuts.    
    local numDonutsPerCell = 2;
    local rMult = 1.0;
    if (ExtrasGot.anything == true) then
        -- Got extras.
        -- Reduce donuts/cell to make room for extras.
        numDonutsPerCell = 1;
        
        if (ExtrasGot.everything == true) then
            -- Also make donuts slightly smaller.
            rMult = 0.9;
        end
    end
    
    local miniDonutArgs = 
    { 
        baysHeight       = MINIDONUT_BAYS_HEIGHT_DEFAULT,
        numDonutsPerCell = numDonutsPerCell,
        numExtraDonuts   = ScriptData.worldSizeInfo.numExtraDonuts,
        rMult            = rMult,
        wrapX            = ScriptData.wrapX,
    };
    MergeExtras(true, self.wholeworldPlotTypes, GenerateMiniDonuts(miniDonutArgs));
    
    -- Apply mountains, hills, and extra islands.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:None_GeneratePlotsByRegion()
    -- No landmass (just extras)

    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    
    -- Apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Noodles_GeneratePlotsByRegion()
    -- Noodles (Noodley Continents)
    -- Convert sea-level into land-level for a mid-range fractal filter.
    local water_percent = GetSeaLevel();
    if (ExtrasGot.everything == true) then
        -- Everything extras: higher sea level.
        water_percent = math.min(100, water_percent + 6);

    elseif (ExtrasGot.anything == true) then
        -- Any extras: slightly higher sea level
        water_percent = math.min(100, water_percent + 3);
    end
    
    -- Allow lake level to adjust the size of loops created by the landmass fractal.
    local lakeLevel  = UserInput.lakeLevel;
    local bottomPcts = {5,6,7,8,9};
    local bottomPct  = bottomPcts[lakeLevel];
    
    -- Fill all rows with background plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);

    local grains = {3,3,2,2,2};
    local grain  = grains[UserInput.seaLevel];
    
    -- Generate the fractal.
    local landFrac = Fractal.Create(g_iW, g_iH, grain, g_iFlags, g_fracXExp, g_fracYExp);
    
    -- Use an offset filter to hollow-out the insides of continents.
    local landLevel  = (100-water_percent);
    local landBottom = GetFractalHeight(landFrac, bottomPct);
    local landTop    = GetFractalHeight(landFrac, bottomPct + landLevel);
    
    for y = 0, g_iH-1 do
        for x = 0, g_iW - 1 do
            local i = GetPlotIndexLua(x,y);
            local landVal = landFrac:GetHeight(x, y);
            
            if ((landVal >= landBottom) and (landVal < landTop)) then
                self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
            end
        end
    end
    
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Numerous_GeneratePlotsByRegion()
    -- Numerous Continents
    
    -- Fill all rows with background plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);

    -- Get user inputs.
    local sea_level  = UserInput.seaLevel;
    local lake_level = UserInput.lakeLevel;
    local water_pct  = GetSeaLevel();
    
    -- Use Sea Level to change the number of continents/islands.
    local num_lands = {7,6,5,4,3};
    local numLands = math.clamp(num_lands[sea_level], 3, 15);
    
    -- Choose a grid based on number of lands (which is based on sea level).
    -- Allow at least one empty cell for randomness.
    local targetNumCells = numLands + 1;
    print("Sea level maps to " .. numLands .. " lands, so we need a grid with " .. 
          targetNumCells .. " cells.");
    
    -- Default 1 - 4 cells (min reachable with normal options is 4)
    local grid = {rows = 2, cols = 2};      
    if (targetNumCells > 6) then
        -- 7 - 8 (max reachable with normal options)
        grid = {rows = 2, cols = 4};
        
    elseif (targetNumCells > 4) then
        -- 5 - 6
        grid = {rows = 2, cols = 3};
    end
    print("Ideal cell grid (rows,cols): ", CoordString(grid.rows, grid.cols));

    -- Determine the number of cells that this map size can handle.
    local minCellWidth  = 7; -- 4 for region + 3 for padding
    local minCellHeight = 9; -- 4 for region + 3 for padding + 2 for even top/bottom rows.
    local maxNumRows    = math.floor(g_iH/minCellHeight);
    local maxNumCols    = math.floor(g_iW/minCellWidth);
    local maxNumCells   = maxNumRows * maxNumCols;

    -- Trim the ideal grid to fit the map size.
    local numCellRows = math.min(maxNumRows, grid.rows);
    local numCellCols = math.min(maxNumCols, grid.cols);
    local numCells    = numCellRows * numCellCols;
    print("Cell grid cropped to fit map size: ", CoordString(numCellRows, numCellCols));
    
    if (maxNumCells < numLands) then
        print("Map is too small to fit " .. numLands .. " lands; must generate only " .. 
              maxNumCells .. " instead.");
        numLands = maxNumCells;
        
    elseif (numCells < numLands) then
        -- We can add room to compensate for map cropping.
        if (numCellCols < maxNumCols) then  
            -- Add columns; aim for enough to have empty cells,
            -- but if that is too many than just use the max.
            numCellCols = math.min(maxNumCols, math.ceil(targetNumCells / numCellRows));
        else
            -- Add rows; aim for enough to have empty cells,
            -- but if that is too many than just use the max.
            numCellRows = math.min(maxNumRows, math.ceil(targetNumCells / numCellCols));        
        end
        print("Cell grid expanded to accomodate sea level: ", 
              CoordString(numCellRows, numCellCols));
        numCells = numCellRows * numCellCols;
    end
    
    local numEmptyCells = numCells - numLands;
    if (numEmptyCells > 0) then
        print("Grid will have " .. numEmptyCells .. " empty cell(s).");
    
        -- Lower sea level to compensate for empty cells.
        water_pct = math.max(10, water_pct - 12*numEmptyCells);
        print("Lowered sea level to " .. water_pct .. " to compensate for empty cell(s).");
        
    elseif (water_pct > 92) then
        water_pct = 92;
        print("Lowered sea level to " .. water_pct .. 
              " to ensure that at least some land exists on the map.");
    end
    
    -- Use floating numbers here; will round when calculating cell boundaries.
    local cellWidth  = math.max(minCellWidth,  g_iW/numCellCols);
    local cellHeight = math.max(minCellHeight, g_iH/numCellRows);
    print("Cell size (w,h): ",  CoordString(cellWidth, cellHeight));
    
    -- Choose random cells to be empty so that there is ocean somewhere.
    local cellEmpty = 0;
    local cellFull  = 1;
    local cellTypes = table.fill(cellFull, numCells);
    for i = 1, numEmptyCells do
        cellTypes[i] = cellEmpty;
    end
    cellTypes = GetShuffledCopyOfTable(cellTypes);
    
    -- Add padding to cells to prevent lands from touching each other.
    -- Need at least three rows/cols of padding to allow isolated coasts.
    local cellPaddingHeadX = 1; -- Padding west of region.
    local cellPaddingHeadY = 3; -- Padding south of region.
    local cellPaddingTail  = 2; -- Padding east or north of region.
    
    -- Cell dimensions with padding.
    local regionWidth  = math.floor(cellWidth  - cellPaddingHeadX - cellPaddingTail);
    local regionHeight = math.floor(cellHeight - cellPaddingHeadY - cellPaddingTail);
    if ((regionHeight % 2) == 1) then
        -- Ensure that each region's height is even,
        -- so that hex rows of the region line up with similar rows of the global map.
        regionHeight = regionHeight + 1;
    end
    print("Region size: ", CoordString(regionWidth, regionHeight));
    local cellNumTiles = regionHeight * regionWidth;
        
    -- Boundaries for the current cell.
    local rowXOffset = 0;
    local iWestX     = 0;
    local iEastX     = 0;
    local iSouthY    = 0;
    local iNorthY    = 0;
    local iCell      = 1;
    for iRow = 1, numCellRows do
        -- Advance to the next row.        
        if ScriptData.wrapX then
            -- Randomly offset this row to make the grid less obvious.
            rowXOffset = TerrainBuilder.GetRandomNumber(
                math.floor(cellWidth-1), "Random grid row x offset");
        end
        iEastX  = rowXOffset;
        iSouthY = iNorthY;
        iNorthY = math.floor(iRow * cellHeight);
    
        for iCol = 1, numCellCols do
            -- Advance to the next column.
            iWestX = iEastX;
            iEastX = (rowXOffset + math.floor(iCol * cellWidth)) % g_iW;

            if (cellTypes[iCell] == cellFull) then
                -- Generate a random pangea for each cell.
                local landWestX  = (iWestX  + cellPaddingHeadX) % g_iW;
                local landSouthY = iSouthY + cellPaddingHeadY;
                if ((landSouthY % 2) == 1) then
                    -- Ensure that each region starts on an even row,
                    -- so that hex rows of the region line up with similar rows of the global map.
                    landSouthY = landSouthY - 1;
                end
                print("Current cell is " .. CoordString(iWestX, iSouthY) .. 
                      " to " .. CoordString(iEastX, iNorthY) .. 
                      " with region at " .. CoordString(landWestX, landSouthY) ..
                      " to " .. CoordString(landWestX+regionWidth, landSouthY+regionHeight));                
                
                local landPlots = GenerateNumerousLand(
                    landWestX, landSouthY, regionWidth, regionHeight, water_pct, lake_level);
                
                -- Add the fractal to the main landmass.
                for y = 0, regionHeight - 1 do
                    local wholeWorldY = landSouthY + y;
                    for x = 0, regionWidth - 1 do
                        local wholeWorldX = (landWestX + x) % g_iW;                        
                        local iWorld = GetPlotIndexLua(wholeWorldX, wholeWorldY);
                        local iPlot = regionWidth*y + x + 1;

                        self.wholeworldPlotTypes[iWorld] = landPlots[iPlot];
                    end
                end
            end
            
            -- Advance to the next cell.
            iCell = iCell + 1;
        end
    end
        
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Oval_GeneratePlotsByRegion()
    -- Oval
    -- Note: fractal wrap flags do not have to match world shape.
    -- Let wrap-x be true here even if the world is flat.
    local fracFlags = {FRAC_WRAP_X = true, FRAC_POLAR = true};

    -- Get user inputs.
    local sea_level = UserInput.seaLevel;

    -- Controls the initial height and width of the oval (before adding bays/lakes)
    --
    -- Don't make this too large (> 95) or else the the landmass will intersect
    -- itself and the poles.
    local axis_list = {0.91, 0.85, 0.79, 0.73, 0.67}; -- Used to be {0.87, 0.81, 0.75}
    local axis_multiplier = axis_list[sea_level];
    
    -- Controls the minimum distance of bays/lakes from the oval's center
    --
    -- At high sea level, only the very center of the oval is guaranteed to be dry.
    local cohesion_list = {0.5, 0.4, 0.3, 0.2, 0.1}; -- Used to be {0.41, 0.38, 0.35}
    local cohesion_multiplier = cohesion_list[sea_level];

    -- Controls the frequency of bays/lakes
    local baysHeight_list = {92, 86, 80, 74, 68};  -- Used to be hard-coded as 82.
    local baysHeight = baysHeight_list[sea_level];
    local baysGrain  = 3;
        
    -- Fill all rows with water plots.
    self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);

    local centerX = g_iW / 2;
    local centerY = g_iH / 2;
    local width     = centerX;
    local height    = centerY;

    if ((not ScriptData.worldSizeInfo.isCustom) and 
        (UserInput.climateWrap == WWRAP_GLOBE) and
        (UserInput.icyPoles == ICYPOLES_CROP)) then
        -- Cropped global map.
        if (UserInput.climate == Climates.ICEAGE) then
            -- Ice age cropped.
            -- Enlarge to compensate for height-crop.
            print("Cropping the oval (globe + ice age cropped)");
            height = height * 1.5;
            
            -- Recalibrate water levels to compensate for larger oval.
            cohesion_multiplier = 0.001;
            baysHeight          = baysHeight - 6;
            
            local baysGrains    = {3,3,2,1,1};
            baysGrain           = baysGrains[sea_level];
            
        elseif (UserInput.climate == Climates.SNOWBALL) then
            -- Snowball cropped.
            -- TODO what about tilted axis sunlight? Use ScriptData.sunlightInfo.latMult instead...
            -- Enlarge to compensate for height-crop.
            print("Cropping the oval (globe + snowball cropped)");
            height = height * 2;
            
            -- Recalibrate water levels to compensate for larger oval.
            cohesion_multiplier = 0.001;
            baysHeight          = baysHeight - 6;
            
            local baysGrains    = {3,3,2,1,1};
            baysGrain           = baysGrains[sea_level];
        end    
    end
    
    -- Add the main oval as land plots.
    local majorAxis = width  * axis_multiplier;
    local minorAxis = height * axis_multiplier;
    local majorAxisSquared = majorAxis * majorAxis;
    local minorAxisSquared = minorAxis * minorAxis;    
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
            if d <= 1 then
                local i = GetPlotIndexLua(x,y);
                self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
            end
        end
    end

    -- Now add bays, fjords, inland seas, etc, but not inside the cohesion area.
    local baysFrac = Fractal.Create(g_iW, g_iH, baysGrain, fracFlags, -1, -1);
    local iBaysThreshold = GetFractalHeight(baysFrac, baysHeight);
    local majorAxis = width * cohesion_multiplier;
    local minorAxis = height * cohesion_multiplier;
    local majorAxisSquared = majorAxis * majorAxis;
    local minorAxisSquared = minorAxis * minorAxis;
    for y = 0, g_iH - 1 do
        for x = 0, g_iW - 1 do
            local deltaX = x - centerX;
            local deltaY = y - centerY;
            local deltaXSquared = deltaX * deltaX;
            local deltaYSquared = deltaY * deltaY;
            local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
            if d > 1 then
                local i = GetPlotIndexLua(x,y);
                local baysVal = baysFrac:GetHeight(x, y);
                if baysVal >= iBaysThreshold then
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_OCEAN;
                end
            end
        end
    end
    
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end

function MultilayeredFractal:Snake_GeneratePlotsByRegion()
    -- Snake Pangea        
    -- Use low-grain to create a pangea fractal.
    local grain = 1;
    
    -- Convert sea-level into land-level for a mid-range fractal filter.
    local water_percent = GetSeaLevel();
    if (ExtrasGot.everything == true) then
        -- Pangea with everything extras: higher sea level.
        water_percent = math.min(100, water_percent + 6);

    elseif (ExtrasGot.anything == true) then
        -- Pangea with extras: slightly higher sea level
        water_percent = math.min(100, water_percent + 3);
    end
    local landLevel  = (100-water_percent)/2;
    
    -- Generate fractal layer and examine the largest landmass.
    -- Reject the result until the largest landmass occupies enough of the total land.
    local done = false;
    local iAttempts = 0;
    
    while (done == false) do
        iAttempts = iAttempts + 1;
        print("Attempt #" .. iAttempts);
    
        -- Fill all rows with background plots.
        self.wholeworldPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
        local iNumTotalLandTiles = 0;

        -- Generate the fractal.
        local landFrac = Fractal.Create(g_iW, g_iH, grain, g_iFlags, g_fracXExp, g_fracYExp);
        
        -- Use a mid-range filter to make the pangea snaky.
        local landBottom = GetFractalHeight(landFrac, 50-landLevel);
        local landTop    = GetFractalHeight(landFrac, 50+landLevel);
        
        for y = 0, g_iH-1 do
            for x = 0, g_iW - 1 do
                local i = GetPlotIndexLua(x,y);
                local pPlot = Map.GetPlotByIndex(i-1);
                local landVal = landFrac:GetHeight(x, y);
                
                if ((landVal >= landBottom) and (landVal < landTop)) then
                    -- Set terrain in global map so that we can calculate largest area.
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT); 
                    self.wholeworldPlotTypes[i] = g_PLOT_TYPE_LAND;
                    iNumTotalLandTiles = iNumTotalLandTiles + 1;
                else
                    TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN); 
                end
            end
        end
        
        -- Check whether the biggest landmass dominates the map.
        AreaBuilder.Recalculate();
        local biggest_area = Areas.FindBiggestArea(false);
        local iNumBiggestAreaTiles = biggest_area:GetPlotCount();
        
        -- Now test the biggest landmass to see if it is large enough.
        if ((iAttempts >= PANGEA_MAX_NUM_ATTEMPTS) or 
            (iNumBiggestAreaTiles >= (iNumTotalLandTiles * SNAKE_LANDMASS_MAJORITY_MIN))) then
            done = true;
            print("Got a sufficiently-large biggest landmass.");
        end
    end
    
    -- Land and water are set. Now apply mountains, hills, etc.
    self:AddMtsHillsExtras();

    -- Plot Type generation completed. Return global plot array.
    return self.wholeworldPlotTypes;
end
----------------------------------------------------------------------------------
-- Landmass post-processing
----------------------------------------------------------------------------------
function AddPlotTypeCircumnav(plotTypes)
    -- If applicable, add channels to allow for naval circumnavigation.
    print("Adding circumnavigation channels...");
    local circumnavGen = GotLakes_CircumnavGenerator.Create(
            ScriptData.landInfo,
            ScriptData.wrapX,
            CIRCUMNAV_FORCE_CHANNELS,
            CIRCUMNAV_MEANDER_PCT);
    circumnavGen:AddPlotTypeChannels(plotTypes, CIRCUMNAV_NUM_PATHS_THROUGH_LAND);
    ScriptData.circumnavGen = circumnavGen;
end

function GeneratePlotTypes()
    print("Generating Plot Types (" .. ScriptData.landInfo.name ..")");
    local plots;
    
    -- Create the appropriate fractal world for the landmass.
    local fractal_world = ScriptData.landInfo.CreateFWorld();
    
    if (ScriptData.landInfo.CreateFWorld == MultilayeredFractal.Create) then
        ------------------------------
        -- MLF landmasses
        ------------------------------
        fractal_world.GeneratePlotsByRegion = ScriptData.landInfo.GenPlotTypes;
        
        plots = fractal_world:GeneratePlotsByRegion();
    else
        ------------------------------
        -- Fractal World landmasses
        ------------------------------
        fractal_world.AddLandAndWater      = GotLakes_Fractal.AddLandAndWater;
        fractal_world.AddMtsHillsExtras    = GotLakes_Fractal.AddMtsHillsExtras;
        fractal_world.GeneratePlotTypes    = ScriptData.landInfo.GenPlotTypes;
    
        if (ScriptData.landInfo.GenPlotTypes == 
                GotLakes_Fractal.Fractal_GeneratePlotTypes) then
            ---------------------------
            -- Archipelago
            -- Fractal
            -- Small Continents
            -- Tiny Islands
            ---------------------------     
            fractal_world:InitFractal(ScriptData.landInfo.fractalInitArgs);
        end
        
        -- Generate plots for a non-MLF fractal world.
        plots = fractal_world:GeneratePlotTypes(ScriptData.landInfo.fractalGenArgs);
    end
    
    -- Add water channels for circumnavigation, if applicable.
    AddPlotTypeCircumnav(plots);
    
    if UserInput.connectSeas then
        print("Connecting oceans.");
        -- Connect all water tiles, if applicable.
        -- Although this doesn't yet guarantee connected saltwater seas,
        -- this will probably do most of the work, unless a volcano or impassable
        -- wonder happens to get in the way. Also, this avoids having to remove
        -- land features or add water features, since features don't exist yet.
        ConnectOceans(plots);
    else
        print("Not connecting oceans.");
    end
        
    CheckForNilPlotTypes(plots);
    return plots;
end
----------------------------------------------------------------------------------
-- Coasts and coastal mountains.
----------------------------------------------------------------------------------
function GenerateCoasts(terrainTypes)
    print("Setting coasts and oceans...");
    local coastGen = GotLakes_CoastGenerator.Create(terrainTypes, ScriptData.coastPlots);
    coastGen:ExpandCoasts();
end

function RemoveCoastalMountains(plotTypes, terrainTypes)
    local mountainsTransformed = 0;
    local noHills = UserInput.noHills;
    
    for iX = 0, g_iW - 1 do
        for iY = 0, g_iH - 1 do
            local index = GetPlotIndexLua(iX, iY);

            if plotTypes[index] == g_PLOT_TYPE_MOUNTAIN then
                if IsAdjacentToShallowWater(terrainTypes, iX, iY) then
                    if noHills then
                        -- Replace mountains with flat land.
                        plotTypes[index] = g_PLOT_TYPE_LAND;
                        terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
                    else
                        -- Replace mountains with hills.
                        plotTypes[index] = g_PLOT_TYPE_HILLS;
                        terrainTypes[index] = g_TERRAIN_TYPE_GRASS_HILLS;
                    end
                    mountainsTransformed = mountainsTransformed + 1;
                end
            end
        end
    end

    AreaBuilder.Recalculate();
    
    print("Coastal mountains removed: ", mountainsTransformed);
    return plotTypes;
end
----------------------------------------------------------------------------------
-- Lakes and Rivers.
----------------------------------------------------------------------------------
function AddLakesAndRivers()    
    -- Add lakes.
    AddLakes();
    
    if UserInput.noRivers then
        print("Skipping rivers (no rivers).");
    else
        print("Generating rivers and possibly a few more lakes.");
        -- Set-up the river generator.
        local riverGen = RiverGenerator.Create(
            ScriptData.gotGatheringStorm,
            ScriptData.worldSizeInfo,
            ScriptData.wrapX,
            false,
            ENABLE_RIVER_DEBUG,
            ENABLE_RIVER_MERGE);
        
        -- Trace rivers mouth-to-source from salt water.
        riverGen:AddCoastalRivers();
        
        -- Fill remaining dry spots in the map with rivers.
        riverGen:AddInlandRivers();
        
        if ENABLE_RIVER_DEBUG then
            -- Validate rivers. Useful for debugging.
            riverGen:Validate();
        end
    end
    
    -- Redo areas after adding (inland river-start) lakes.
    AreaBuilder.Recalculate();
end
------------------------------------------------------------------------------
-- Latitude Lookup
-- Need to declare these before declaring climate info.
------------------------------------------------------------------------------
function GetAzimuthalDistances(iX, iY)
    -- Compute the Euclidian distances needed to compute azimuthal latitude.
    -- Distances are in number of plots.
    -- 
    -- Args: iX, iY: compute distances for these map coordinates.
    --
    -- Returns:
    --   equatorDistFromPoles: distance from the equator to the central pole
    --   distFromNearestPole: distance from coords to the nearest pole
    local centerX = math.ceil(g_iW / 2);
    local centerY = math.ceil(g_iH / 2);
    
    -- Distance between poles = distance between center and the farthest map edge.
    local distBetweenPoles = math.max(g_iW, g_iH)/2;
    
    -- Halfway between poles = equator.
    local equatorDistFromPoles = distBetweenPoles/2;
    
    -- Euclidian Distance from coords to the central pole (makes latitude bands circular).
    local distFromCenter = Distance(iX, iY, centerX, centerY);
    
    -- Distance from the nearest pole.
    local distFromNearestPole = math.min(distFromCenter, distBetweenPoles-distFromCenter);
    return equatorDistFromPoles, distFromNearestPole;
end

function DefaultAzimuthal_GetLatitudeAtPlot(iX, iY)
    -- Default latitude for azimuthal maps.
    -- Returns a latitude value between 0.0 (hot equator) 
    -- and 1.0 (uncropped cold poles at center and corners of map).
    local equatorDistFromPoles, distFromNearestPole = GetAzimuthalDistances(iX, iY);
    
    -- Farther from poles => lower latitude.
    -- Beyond the farthest pole results in negative distance value, which maps to 1.0 (cold).
    local lat = Interpolate(distFromNearestPole, 0, equatorDistFromPoles, 1.0, 0.0);
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function DefaultGlobe_GetLatitudeAtPlot(iX, iY)
    -- Default latitude for globe maps.
    -- Returns a latitude value between 0.0 (hot equator) and 1.0 (uncropped cold poles).
    local lat = math.abs((g_iH / 2) - iY) / (g_iH / 2);
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function DefaultRegion_GetLatitudeAtPlot(iX, iY)
    -- Default latitude for region maps.
    return ScriptData.climateInfo.regionLat[UserInput.icyPoles];
end

function TiltedAxisAzimuthal_GetLatitudeAtPlot(iX, iY)
    -- Tilted Axis latitude for azimuthal maps.
    -- Returns a latitude value between 0.0 (hot central pole) 
    -- and 1.0 (uncropped cold poles at corners of map).
    local centerX = math.ceil(g_iW / 2);
    local centerY = math.ceil(g_iH / 2);
    
    -- Distance between poles == distance between center and the farthest map edge.
    local distBetweenPoles = math.max(g_iW, g_iH)/2;
    
    -- Euclidian Distance from coords to the central pole (makes latitude bands circular).
    local distFromCenter = Distance(iX, iY, centerX, centerY);
    
    -- Use terrain info to determine which pole is hot and which pole is cold.
    local centerLat = 1.0; -- cold
    local edgesLat = 0.0; -- hot
    if (ScriptData.terrainInfo.makeCenterHot) then
        centerLat = 0.0; -- hot
        edgesLat = 1.0; -- cold
    end
    
    -- Farther from central pole => higher latitude (if center is hot).
    local lat = Interpolate(distFromCenter, 0, distBetweenPoles, centerLat, edgesLat);
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function TiltedAxisGlobe_GetLatitudeAtPlot(iX, iY)
    -- Custom lat for Cropped Tilted Axis Globe.
    -- Use a scale of 0 (southern hot side) to 1 (uncropped northern cold side).
    local lat = iY / g_iH;
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function TiltedAxisRegion_GetLatitudeAtPlot(iX, iY)
    -- Custom lat for Tilted Axis Region.
    -- Distance from this point to the pole which faces the sun.
    -- Use Euclidian distance so that the pole is circular-ish (give or take
    -- a column). This was good enough for donut, so why not use it here too!
    local hotPoleDist = Distance(iX, iY, 
        ScriptData.terrainInfo.hotPoleX, ScriptData.terrainInfo.hotPoleY);
    
    return Interpolate(hotPoleDist, 
        ScriptData.terrainInfo.minR,         
        ScriptData.terrainInfo.maxR,
        ScriptData.climateInfo.tiltedLatMin[UserInput.icyPoles], 
        ScriptData.climateInfo.tiltedLatMax[UserInput.icyPoles]);
end

function TwoSunsAzimuthal_GetLatitudeAtPlot(iX, iY)
    -- Two Suns latitude for azimuthal maps.
    -- Returns a latitude value between 0.0 (hot poles at center and corners of map) 
    -- and 1.0 (uncropped cold equatorial band).
    local equatorDistFromPoles, distFromNearestPole = GetAzimuthalDistances(iX, iY);
    
    -- Farther from poles => higher latitude.
    -- Beyond the farthest pole results in negative distance value, which maps to 0.0 (hot).
    local lat = Interpolate(distFromNearestPole, 0, equatorDistFromPoles, 0.0, 1.0);
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function TwoSunsGlobe_GetLatitudeAtPlot(iX, iY)
    -- Custom lat for Two Suns Globe.
    -- Flip the scale so that the equator is cold.
    local lat = 1 - math.abs((g_iH / 2) - iY) / (g_iH / 2);
    return lat * ScriptData.sunlightInfo.latMult[UserInput.climate];
end

function TwoSunsRegion_GetLatitudeAtPlot(iX, iY)
    -- Custom lat for Two Suns Region.    
    -- Distance from this point to the nearest sun-facing pole.
    -- Use Euclidian distance so that the pole is circular-ish (give or take
    -- a column). This was good enough for donut, so why not use it here too!
    local hotPoleDist = math.min(
        Distance(iX, iY, 
            ScriptData.terrainInfo.southPoleX, 
            ScriptData.terrainInfo.southPoleY),
        Distance(iX, iY, 
            ScriptData.terrainInfo.northPoleX, 
            ScriptData.terrainInfo.northPoleY));
            
    local latMult = ScriptData.sunlightInfo.latMult[UserInput.climate];
    
    return Interpolate(hotPoleDist, 
        ScriptData.terrainInfo.minR,
        ScriptData.terrainInfo.maxR,
        0, 
        latMult);
end

function GL_GetLatitudeAtPlot(iX, iY)
    -- Latitude for Got Lakes - no variation fractal required.
    local latitudeFcn = ScriptData.sunlightInfo.GetLatitudeAtPlot[UserInput.climateWrap];
    return latitudeFcn(iX, iY);
end

function GetLatitudeAtPlot(variationFrac, iX, iY)
    -- Override MapUtilities to use Got Lakes latitude.
    return GL_GetLatitudeAtPlot(iX, iY);
end
----------------------------------------------------------------------------------
-- Terrain
----------------------------------------------------------------------------------
function GenerateTerrain()
    print("Generating Terrain (" .. 
           ScriptData.climateInfo.name .. " + " ..
           ScriptData.biomeInfo.name .. " + " .. 
           ScriptData.sunlightInfo.name .. ")");
    
    -- Create the terrain generator using args from climate and biome info.
    local terraingen = GotLakes_TerrainGenerator.Create(
        ScriptData.climateInfo,
        ScriptData.biomeInfo,
        ScriptData.sunlightInfo,
        ScriptData.donutFillingMap,
        ScriptData.hexMap,
        ScriptData.enabledTerrainsList,
        ScriptData.enabledTerrainsMap,
        CreateClimateFractal,
        GL_GetLatitudeAtPlot);
    
    if (UserInput.climateWrap == WWRAP_AZIMUTH) then
        -- Additional step for climates that need azimuthal init.
        ScriptData.terrainInfo = terraingen:InitAzimuthal(
            ENABLE_TILTEDAZIMUTH_RANDOM_POLES,
            TILTEDAZIMUTH_HOT_POLE_AT_CENTER);
            
    elseif (UserInput.climateWrap == WWRAP_REGION) then
        -- Additional step for climates that need region init.
        ScriptData.terrainInfo = terraingen:InitRegion(
            ScriptData.wrapX,
            ENABLE_TILTEDREGION_RANDOM_POLES,
            TILTEDREGION_DEFAULT_POLE_RDIST,
            TILTEDREGION_DEFAULT_POLE_THETA);
    end
    
    -- Generate terrain.
    terraingen:GenerateTerrain();    
end
----------------------------------------------------------------------------------
-- Continent Stamping
----------------------------------------------------------------------------------
function StampContinents()
    local stamper = GotLakes_ContinentStamper.Create();
    stamper:StampContinents();
end
------------------------------------------------------------------------------
-- Continental boundaries and volcanoes (GS only)
-- These methods happen after stamping continents onto the world.
------------------------------------------------------------------------------
function CountContinentBoundaryPlots()
    local iContinentBoundaryPlots = 0;

    for i = 0, g_numTiles - 1, 1 do
        pPlot = Map.GetPlotByIndex(i);
        if (Map.FindSecondContinent(pPlot, 3)) then
            iContinentBoundaryPlots = iContinentBoundaryPlots + 1;
        end
    end
    return iContinentBoundaryPlots;
end

function AddVolcanicTerrain(iContinentBoundaryPlots)
    if UserInput.noVolcanoes then
        print("Not adding volcanoes.");
        return;
    end

    print("Adding volcanoes.");
    -- Don't bother trying to split lonely mountain indices into continents.
    -- That just adds complexity that the user probably won't even notice.
    -- Plus this is a RANDOM map script, so why fight the RNG?
    local aLonelyMountainIndices:table = {};
    local aLonelyNonMtnIndices:table = {};
    local iMountainsPlaced = 0;
    local iVolcanoesPlaced = 0;

    -- Compute target number of volcanoes
    local iTotalLandPlots = 0;
    for iX = 0, g_iW - 1 do
        for iY = 0, g_iH - 1 do
            if (MapGetPlotType(iX, iY) ~= g_PLOT_TYPE_OCEAN) then
                iTotalLandPlots = iTotalLandPlots + 1;
            end
        end
    end
    local volcLevel = UserInput.volcLevel;
    local divisors = {12, 7, 5, 4, 3}; -- Base Game: {6, 5, 3} (effectively 12, 10, 6)
    local iDivisor = divisors[volcLevel] or 5;
    local iDesiredVolcanoes = iTotalLandPlots / (iDivisor * 25); -- Base Game: iDivisor * 50
    
    if (GameCapabilities.HasCapability("CAPABILITY_MEGADISASTERS")) then
        print("Increasing volcanoes (mega-disasters)");
        iDesiredVolcanoes = iDesiredVolcanoes * 2 + 2;
    end
    
    print ("Desired Volcanoes: " .. iDesiredVolcanoes);

    -- Donut + Tectonic Extras = volcanic filling.
    local gotVolcanoFilling = 
        (gotDonut and (UserInput.extras   == ExtraIslesLakes.TECTONIC));

    -- 2/3rds of Earth's volcanoes are near continent boundaries
    print ("Continent Boundary Plots: " .. iContinentBoundaryPlots);
    local iDesiredNearBoundaries = iDesiredVolcanoes * 2 / 3;

    if (iDesiredNearBoundaries > 0) then
        local iBoundaryPlotsPerVolcano = iContinentBoundaryPlots / iDesiredNearBoundaries;

        print ("Boundary Plots Per Volcano: " .. iBoundaryPlotsPerVolcano);

        for iX = 0, g_iW - 1 do
            for iY = 0, g_iH - 1 do
                local index = (iY * g_iW) + iX;
                local plotType = MapGetPlotType(iX, iY);
                -- Don't add volcanoes to water tiles.
                -- If No Coastal Mountains is enabled then avoid coastal volcanoes.
                -- Avoid map edges to prevent walls of volcanoes cutting off corners.
                -- Don't add volcanoes to plots that are surrounded by impassable terrain.
                if (not ((plotType == g_PLOT_TYPE_OCEAN) or 
                         (((UserInput.noCoastMts == true) and IsAdjacentToWater(iX, iY))) or
                         (IsCloseToMapEdge(iX, iY, 1, ScriptData.wrapX, false)) or
                         (CountAdjacentPassable(iX, iY) == 0) )) then
                    -- Maybe add a volcano here...
                    local plot = Map.GetPlot(iX, iY);
                    local bVolcanoHere = false;
                    
                    if (gotVolcanoFilling and 
                        (ScriptData.donutFillingMap[index+1] == FILLING_YES) and
                        (not IsAdjacentToVolcano(iX, iY))) then
                        -- Volcano donut filling!
                        bVolcanoHere = true;
                    
                    elseif (Map.FindSecondContinent(plot, 1)) then
                        if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano *.7, 
                            "Volcano on boundary") == 0) then
                            bVolcanoHere = true;
                        end
                    elseif(Map.FindSecondContinent(plot, 2)) then
                        if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano, 
                            "Volcano 1 from boundary") == 0) then
                            bVolcanoHere = true;
                        end
                    elseif(Map.FindSecondContinent(plot, 3)) then
                        if (TerrainBuilder.GetRandomNumber(iBoundaryPlotsPerVolcano * 1.5, 
                            "Volcano 2 from boundary") == 0) then
                            bVolcanoHere = true;
                        end
                        
                    elseif (not IsAdjacentToMountain(iX, iY)) then
                        -- A land plot that is not adjacent to a mountain.
                        if (plotType == g_PLOT_TYPE_MOUNTAIN) then
                            -- Lonely mountain: guaranteed candidate for lonely volcano.
                            table.insert(aLonelyMountainIndices, index);
                        else
                            local lonelyPct = 25;
                            if (plotType == g_PLOT_TYPE_HILLS) then
                                lonelyPct = 50;
                            end
                            local lonelyDice = 
                                TerrainBuilder.GetRandomNumber(100, "Lonely volcano");
                            if (lonelyDice < lonelyPct) then
                                table.insert(aLonelyNonMtnIndices, index);
                            end
                        end
                    end

                    if bVolcanoHere then
                        MapSetPlotType(iX, iY, g_PLOT_TYPE_MOUNTAIN);
                        TerrainBuilder.SetFeatureType(plot, g_FEATURE_VOLCANO);
                        --print ("Volcano Placed at " .. CoordString(iX, iY));
                        iVolcanoesPlaced = iVolcanoesPlaced + 1;
                    end
                end
            end
        end
        print ("Continent Edge Volcanoes Placed: " .. iVolcanoesPlaced);
    end

    if ((iDesiredVolcanoes > iVolcanoesPlaced) and #aLonelyMountainIndices > 0) then
        -- Use lonely mountains to add more volcanoes.
        local iChance = #aLonelyMountainIndices / iDesiredVolcanoes;
        aShuffledIndices =  GetShuffledCopyOfTable(aLonelyMountainIndices);
        for i, index in ipairs(aShuffledIndices) do
            local plot = Map.GetPlotByIndex(index);
            TerrainBuilder.SetFeatureType(plot, g_FEATURE_VOLCANO);
            --print ("Volcano Placed at " .. CoordStringPlot(plot));
            iVolcanoesPlaced = iVolcanoesPlaced + 1;
            if (iVolcanoesPlaced >= iDesiredVolcanoes) then
                break
            end
        end
    end
    
    if ((iDesiredVolcanoes > iVolcanoesPlaced) and #aLonelyNonMtnIndices > 0) then
        -- We still need more volcanoes.
        -- As a last resort, add new lonely mountains and make them volcanoes.
        local iChance = #aLonelyNonMtnIndices / iDesiredVolcanoes;
        aShuffledIndices =  GetShuffledCopyOfTable(aLonelyNonMtnIndices);
        for i, index in ipairs(aShuffledIndices) do
            local plot = Map.GetPlotByIndex(index);
            MapSetPlotType(plot:GetX(), plot:GetY(), g_PLOT_TYPE_MOUNTAIN);
            TerrainBuilder.SetFeatureType(plot, g_FEATURE_VOLCANO);
            --print ("Volcano Placed at " .. CoordStringPlot(plot));
            iMountainsPlaced = iMountainsPlaced + 1;
            iVolcanoesPlaced = iVolcanoesPlaced + 1;
            if (iVolcanoesPlaced >= iDesiredVolcanoes) then
                break
            end
        end
    end

    -- Recalc areas because volcanoes are impassable.
    AreaBuilder.Recalculate();
    print("Total Mountains Placed: " .. iMountainsPlaced);
    print("Total Volcanoes Placed: " .. iVolcanoesPlaced);
end
------------------------------------------------------------------------------
-- Features
------------------------------------------------------------------------------
function GenerateFeatures()
    print("Generating Features (" .. 
           ScriptData.landInfo.name .. " + " ..
           ScriptData.climateInfo.name .. " + " ..
           ScriptData.biomeInfo.name .. " + " .. 
           ScriptData.sunlightInfo.name .. ")");
    
    -- Create the feature generator.
    local featuregen = GotLakes_FeatureGenerator.Create(
        ScriptData.landInfo, 
        ScriptData.biodivInfo,
        ScriptData.climateInfo,
        ScriptData.biomeInfo,
        ScriptData.sunlightInfo,
        ScriptData.donutFillingMap,
        ScriptData.enabledTerrainsMap,
        ScriptData.gotGatheringStorm,
        ScriptData.wrapX,
        CreateClimateFractal, 
        GL_GetLatitudeAtPlot,
        ENABLE_RF_REEF_REDUCTION);
    
    featuregen:AddFeatures();
    return featuregen;
end
------------------------------------------------------------------------------
-- Natural Wonder Generator overrides
-- Improved edge-case handling
-- Support for Circumnavigation and Connected Seas.
------------------------------------------------------------------------------
function CompareSelectedWonders(a,b)
    if (a.RandomScore == b.RandomScore) then
        -- Use index as a tie breaker to avoid MP desyncs.
        return a.NWIndex < b.NWIndex;
    end
    return a.RandomScore > b.RandomScore;
end

function NaturalWonderGenerator:__FindValidLocs()
    local iW, iH, iPlotCount = GetMapGridSize();
    local iBaseScore = 1;

    for i = 0, iPlotCount - 1 do
        local pPlot = Map.GetPlotByIndex(i);

        -- See which NW can appear here
        for iI = 0, self.iNumWondersInDB - 1 do
            local wonderInfo = GameInfo.Features[self.eFeatureType[iI]];
            local customPlacement = wonderInfo.CustomPlacement;
            if (customPlacement == nil) then
                local wonderNumTiles = wonderInfo.Tiles or 1;
                if (TerrainBuilder.CanHaveFeature(pPlot, self.eFeatureType[iI], false) and 
                    self.aInvalidNaturalWonders[iI] == true) then
                    if ((gotCircumnav or UserInput.connectSeas) and
                        wonderInfo.Impassable and
                        (IsPassableWaterChokepoint(pPlot) or
                         (pPlot:IsWater() and (wonderNumTiles > 1) and 
                          IsAdjacent(pPlot:GetX(),pPlot:GetY(), IsPassableWaterChokepoint)))) then
                        -- Enforcing circumnavigation or connected seas.
                        -- Don't place impassable water wonders at chokepoints.
                        --
                        -- This won't work for 3+ tile impassable water wonders,
                        -- but luckily no such thing exists in either base game, Terra Mirabilis,
                        -- or Sukritact's natrual wonder mods.
                        print("Preventing " .. wonderInfo.FeatureType ..
                              " from blocking naval chokepoint near " .. 
                               CoordString(pPlot:GetX(),pPlot:GetY()));
                    elseif (CountAdjacentPassable(pPlot:GetX(),pPlot:GetY()) == 0) then
                        -- Completely surrounded by impassable terrain.
                        print("Preventing " .. wonderInfo.FeatureType ..
                              " from becoming unreachable at " .. 
                               CoordString(pPlot:GetX(),pPlot:GetY()));
                    else
                        -- Allow the NW at this location like normal.
                        row = {};
                        row.MapIndex = i;
                        row.Score = iBaseScore;
                        table.insert (self.aaPossibleLocs[iI], row);
                    end
                end
            else
                if (CustomCanHaveFeature(pPlot, self.eFeatureType[iI])) then
                    row = {};
                    row.MapIndex = i;
                    row.Score = iBaseScore;
                    table.insert (self.aaPossibleLocs[iI], row);
                end
            end
        end
    end

    local includedWonders = {};
    if ScriptData.gotSelectNWsPlusPlus then
        -- Select Natural Wonders++ enabled. Check for "must-have" natural wonders.
        local includeWondersConfig = GameConfiguration.GetValue("INCLUDE_NATURAL_WONDERS");
        if(includeWondersConfig and #includeWondersConfig > 0) then
            print("The following Natural Wonders have been marked as 'included':");
            for i,v in ipairs(includeWondersConfig) do
                print("* " .. v);
                includedWonders[v] = true;
            end
        end
    end

    local rejectedWonders = {};
    for iI = 0, self.iNumWondersInDB - 1 do
        local iNumEntries = #self.aaPossibleLocs[iI];
        local sFeatureType = GameInfo.Features[self.eFeatureType[iI]].FeatureType;
        local wonderInfo = GameInfo.Features[self.eFeatureType[iI]];
        if (iNumEntries > 0) then
            print ("Found " .. tostring(iNumEntries) .. " possible location(s) for " ..
                   wonderInfo.FeatureType);
            selectionRow = {}
            selectionRow.NWIndex = iI;
            if (ScriptData.gotSelectNWsPlusPlus and (includedWonders[sFeatureType] == true)) then
                -- NW strongly included by the Select Natural Wonders++ mod.
                selectionRow.RandomScore = 1000;
            else
                selectionRow.RandomScore = TerrainBuilder.GetRandomNumber (100, 
                    "Natural Wonder Selection Roll");
            end
            table.insert(self.aSelectedWonders, selectionRow);
        else
            table.insert(rejectedWonders, wonderInfo.FeatureType);
        end
    end
    table.sort(self.aSelectedWonders, CompareSelectedWonders);

    -- Debug output
    if (#rejectedWonders > 0) then
        print ("Unable to place the following " .. #rejectedWonders .. " wonder(s): {");
        print(unpack(rejectedWonders));
        print("}");
    end
    print ("Num wonders with valid location: " .. tostring(#self.aSelectedWonders));
end

function NaturalWonderGenerator:__PlaceWonders()
    -- Override to harden against MP desyncs.
    local j = 1;
    for i, selectionRow in ipairs(self.aSelectedWonders) do
        if (j <= self.iNumWondersToPlace) then
            print (" Selected Wonder = " .. tostring(selectionRow.NWIndex) .. ", Random Score = ", tostring(selectionRow.RandomScore));

            -- Score possible locations
            self:__ScorePlots(selectionRow.NWIndex);

            -- Sort and take best score
            table.sort (self.aaPossibleLocs[selectionRow.NWIndex], CompareScoredPlots);
            local iMapIndex = self.aaPossibleLocs[selectionRow.NWIndex][1].MapIndex;

            -- Place at this location
            local pPlot = Map.GetPlotByIndex(iMapIndex);
            local eFeatureType = self.eFeatureType[selectionRow.NWIndex]
            if(TerrainBuilder.CanHaveFeature(pPlot, eFeatureType)) then
                local customPlacement = GameInfo.Features[eFeatureType].CustomPlacement;
                if (customPlacement == nil) then
                    TerrainBuilder.SetFeatureType(pPlot, eFeatureType);

                    ResetTerrain(pPlot:GetIndex());

                    local plotX = pPlot:GetX();
                    local plotY = pPlot:GetY();

                    for dx = -2, 2 do
                        for dy = -2,2 do
                            local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, 2);
                            if(otherPlot) then
                                if(otherPlot:IsNaturalWonder() == true) then
                                    ResetTerrain(otherPlot:GetIndex());
                                end
                            end
                        end
                    end
                else
                    CustomSetFeatureType(pPlot, eFeatureType);
                end
                print (" Set Wonder with Feature ID of " .. tostring(eFeatureType) .. " at location (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ")");
                table.insert (self.aPlacedWonders, iMapIndex);
                j = j+ 1;
            end
        end
    end
end

function CustomGetMultiTileFeaturePlotList(pPlot, eFeatureType, aPlots)
    -- Override to improve stability.
    
    -- First check this plot itself
    if ((pPlot == nil) or (not TerrainBuilder.CanHaveFeature(pPlot, eFeatureType, true))) then
        return false;
    else
        table.insert(aPlots, pPlot:GetIndex());
    end

    -- Which type of custom placement is it?
    local customPlacement = GameInfo.Features[eFeatureType].CustomPlacement;

    -- Check whether we need to avoid water chokepoints.
    local avoidWaterChokepoints = gotCircumnav or UserInput.connectSeas;

    if (ScriptData.gotSelectNWsPlusPlus and g_CustomPlacements[customPlacement]) then
        -- Run a Select Natural Wonders++ custom placement function.
        return g_CustomPlacements[customPlacement](pPlot, eFeatureType, aPlots);
        
    -- 2 tiles inland, east-west facing camera
    elseif (customPlacement == "PLACEMENT_TORRES_DEL_PAINE" or
        customPlacement == "PLACEMENT_YOSEMITE") then

        -- Assume first tile is the western one, check the one to the east
        local pAdjacentPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_EAST);
        if (pAdjacentPlot ~= nil and TerrainBuilder.CanHaveFeature(pAdjacentPlot, eFeatureType, true) == true) then
            table.insert(aPlots, pAdjacentPlot:GetIndex());
            return true;
        end

    -- 2 tiles on coast, roughly facing camera
    elseif (customPlacement == "PLACEMENT_CLIFFS_DOVER") then
        local pNEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
        local pWPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_WEST);
        local pSWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        local pSEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
        local pEPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_EAST);

        -- W and SW are water, see if SE works
        local pSecondPlot;
        if (pWPlot ~= nil and 
            pSWPlot ~= nil and 
            pWPlot:IsWater() and pWPlot:IsLake() == false and 
            pSWPlot:IsWater() and pWPlot:IsLake() == false) then
            pSecondPlot = pSEPlot;

        -- SW and SE are water, see if E works
        elseif (pSWPlot ~= nil and 
                pSEPlot ~= nil and 
                pSWPlot:IsWater() and pSWPlot:IsLake() == false and 
                pSEPlot:IsWater() and pSEPlot:IsLake() == false) then
            pSecondPlot = pEPlot;

        -- SE and E are water, see if NE works
        -- <<MOD: pSEPlot, not pSWPlot for nil-check>>
        elseif (pSEPlot ~= nil and 
                pEPlot ~= nil  and 
                pSEPlot:IsWater() and pSEPlot:IsLake() == false and 
                pEPlot:IsWater() and pEPlot:IsLake() == false) then
            pSecondPlot = pNEPlot;
        else
            return false;
        end

        if (pSecondPlot ~= nil and TerrainBuilder.CanHaveFeature(pSecondPlot, eFeatureType, true)) then
            table.insert(aPlots, pSecondPlot:GetIndex());
            return true;
        end

    elseif (customPlacement == "PLACEMENT_GIBRALTAR") then
        -- Terra Mirabilis (Rock of Gibraltar)

        -- Assume first tile a land tile without hills, check around it in a preferred order for water
        if (pPlot:IsWater() or pPlot:IsHills()) then
            return false;
        end

        local pSWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        local pSEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
        if (pSWPlot ~= nil and pSWPlot:IsWater() and pSWPlot:IsLake() == false and pSEPlot ~= nil and pSEPlot:IsWater() and pSEPlot:IsLake() == false) then
            return true;
        end

    elseif (customPlacement == "PLACEMENT_MOSI_OA_TUNYA") then
        -- Terra Mirabilis.

        if (pPlot:IsWater() or pPlot:IsHills()) then
            return false;
        end

        if (pPlot:IsWOfRiver() or pPlot:IsNWOfRiver() or pPlot:IsNEOfRiver()) then
            return false;
        end

        local pNWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
        local pNEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
        local pWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_WEST);

        -- Got Lakes: added checks to guard against nil adjacent plots
        if (pNWPlot and pNWPlot:IsNWOfRiver() and 
            pNEPlot and pNEPlot:IsNEOfRiver() and 
            pWPlot and not pWPlot:IsWOfRiver()) then
            return true;
        end

    -- 2 tiles, one on coastal land and one in water, try to face camera if possible
    -- If circumnav enabled then avoid bottlenecks for this NW.
    elseif (customPlacement == "PLACEMENT_GIANTS_CAUSEWAY") then

        -- Assume first tile a land tile without hills, check around it in a preferred order for water
        if (pPlot:IsWater() or pPlot:IsHills()) then
            return false;
        end

        local pSWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        if (pSWPlot ~= nil and pSWPlot:IsWater() and pSWPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pSWPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pSWPlot:GetX(),pSWPlot:GetY()));
            else
                table.insert(aPlots, pSWPlot:GetIndex());
                return true;
            end
        end

        local pSEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
        if (pSEPlot ~= nil and pSEPlot:IsWater() and pSEPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pSEPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pSEPlot:GetX(),pSEPlot:GetY()));
            else
                table.insert(aPlots, pSEPlot:GetIndex());
                return true;
            end
        end

        local pWPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_WEST);
        if (pWPlot ~= nil and pWPlot:IsWater() and pWPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pWPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pWPlot:GetX(),pWPlot:GetY()));
            else
                table.insert(aPlots, pWPlot:GetIndex());
                return true;
            end
        end

        local pEPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_EAST);
        if (pEPlot ~= nil and pEPlot:IsWater() and pEPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pEPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pEPlot:GetX(),pEPlot:GetY()));
            else
                table.insert(aPlots, pEPlot:GetIndex());
                return true;
            end
        end

        local pNWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
        if (pNWPlot ~= nil and pNWPlot:IsWater() and pNWPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pNWPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pNWPlot:GetX(),pNWPlot:GetY()));
            else
                table.insert(aPlots, pNWPlot:GetIndex());
                return true;
            end
        end

        local pNEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
        if (pNEPlot ~= nil and pNEPlot:IsWater() and pNEPlot:IsLake() == false) then
            if (avoidWaterChokepoints and IsPassableWaterChokepoint(pNEPlot)) then
                print("Preventing Giant's Causeway from blocking naval chokepoint at " .. 
                      CoordString(pNEPlot:GetX(),pNEPlot:GetY()));
            else
                table.insert(aPlots, pNEPlot:GetIndex());
                return true;
            end
        end
        
    -- 4 tiles (triangle plus a tail)
    elseif (customPlacement == "PLACEMENT_RORAIMA") then

        -- This one does require three in a row, so let's find that first
        for i = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
            local pFirstPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), i);
            if (pFirstPlot ~= nil and TerrainBuilder.CanHaveFeature(pFirstPlot, eFeatureType, true)) then
                local pSecondPlot = Map.GetAdjacentPlot(pFirstPlot:GetX(), pFirstPlot:GetY(), i);
                if (pSecondPlot ~= nil and TerrainBuilder.CanHaveFeature(pSecondPlot, eFeatureType, true)) then
                    local iNewDir = i - 1;
                    if iNewDir == -1 then
                        iNewDir = 5;
                    end
                    local pThirdPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), iNewDir);
                    if (pThirdPlot ~= nil and TerrainBuilder.CanHaveFeature(pThirdPlot, eFeatureType, true)) then
                        table.insert(aPlots, pFirstPlot:GetIndex());
                        table.insert(aPlots, pSecondPlot:GetIndex());
                        table.insert(aPlots, pThirdPlot:GetIndex());
                        return true;
                    end
                end
            end
        end

    -- 3 tiles in a straight line
    elseif (customPlacement == "PLACEMENT_ZHANGYE_DANXIA") then

        for i = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
            local pFirstPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), i);
            if (pFirstPlot ~= nil and TerrainBuilder.CanHaveFeature(pFirstPlot, eFeatureType, true)) then
                local pSecondPlot = Map.GetAdjacentPlot(pFirstPlot:GetX(), pFirstPlot:GetY(), i);
                if (pSecondPlot ~= nil and TerrainBuilder.CanHaveFeature(pSecondPlot, eFeatureType, true)) then
                    table.insert(aPlots, pFirstPlot:GetIndex());
                    table.insert(aPlots, pSecondPlot:GetIndex());
                    return true;
                end
            end
        end

    -- 3 tiles in triangle coast on front edge, land behind (with any rotation)
    elseif (customPlacement == "PLACEMENT_PIOPIOTAHI") then

        local pWPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_WEST);
        local pNWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
        local pNEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
        local pEPlot  = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_EAST);
        local pSEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
        local pSWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        
        -- all 6 hexes around must be land
        if (pNWPlot == nil or pNEPlot == nil or pWPlot== nil or 
            pSWPlot== nil  or pSEPlot == nil or pEPlot== nil or 
            pNWPlot:IsWater() or pNEPlot:IsWater() or pWPlot:IsWater() or 
            pSWPlot:IsWater() or pSEPlot:IsWater() or pEPlot:IsWater()) then
            return false;
        else
            -- find two adjacent plots that can both serve for this NW
            local bWValid  = TerrainBuilder.CanHaveFeature(pWPlot, eFeatureType, true);
            local bNWValid = TerrainBuilder.CanHaveFeature(pNWPlot, eFeatureType, true);
            local bNEValid = TerrainBuilder.CanHaveFeature(pNEPlot, eFeatureType, true);
            local bEValid  = TerrainBuilder.CanHaveFeature(pEPlot, eFeatureType, true);
            local bSEValid = TerrainBuilder.CanHaveFeature(pSEPlot, eFeatureType, true);
            local bSWValid = TerrainBuilder.CanHaveFeature(pSWPlot, eFeatureType, true);

            if (bSEValid ~= nil and bSWValid ~= nil and bSEValid == true and bSWValid == true ) then
                pWaterCheck1 = Map.GetAdjacentPlot(pSEPlot:GetX(), pSEPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
                pWaterCheck2 = Map.GetAdjacentPlot(pSWPlot:GetX(), pSWPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
                pWaterCheck3 = Map.GetAdjacentPlot(pSWPlot:GetX(), pSWPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
                --- mod <<<
                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                --- mod >>>
                if (pWaterCheck1:IsWater() == false or 
                    pWaterCheck2:IsWater() == false or 
                    pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pSEPlot:GetIndex());
                    table.insert(aPlots, pSWPlot:GetIndex());
                    return true;
                end
            end
            
            if (bEValid  ~= nil and bSEValid ~= nil and bEValid  == true and bSEValid == true ) then
                pWaterCheck1 = Map.GetAdjacentPlot(pEPlot:GetX(), pEPlot:GetY(), DirectionTypes.DIRECTION_EAST);
                pWaterCheck2 = Map.GetAdjacentPlot(pSEPlot:GetX(), pSEPlot:GetY(), DirectionTypes.DIRECTION_EAST);
                pWaterCheck3 = Map.GetAdjacentPlot(pSEPlot:GetX(), pSEPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);

                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                
                if (pWaterCheck1:IsWater() == false or pWaterCheck2:IsWater() == false or pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pEPlot:GetIndex());
                    table.insert(aPlots, pSEPlot:GetIndex());
                    return true;
                end
            end
            
            if (bSWValid  ~= nil and bWValid ~= nil and bSWValid  == true and bWValid == true ) then
                pWaterCheck1 = Map.GetAdjacentPlot(pSWPlot:GetX(), pSWPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
                pWaterCheck2 = Map.GetAdjacentPlot(pWPlot:GetX(), pWPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
                pWaterCheck3 = Map.GetAdjacentPlot(pWPlot:GetX(), pWPlot:GetY(), DirectionTypes.DIRECTION_WEST);
                
                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                
                if (pWaterCheck1:IsWater() == false or pWaterCheck2:IsWater() == false or pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pSWPlot:GetIndex());
                    table.insert(aPlots, pWPlot:GetIndex());
                    return true;
                end
            end

            if (bWValid  ~= nil and bNWValid ~= nil and bWValid  == true and bNWValid == true ) then    
                pWaterCheck1 = Map.GetAdjacentPlot(pWPlot:GetX(), pWPlot:GetY(), DirectionTypes.DIRECTION_WEST);
                pWaterCheck2 = Map.GetAdjacentPlot(pNWPlot:GetX(), pNWPlot:GetY(), DirectionTypes.DIRECTION_WEST);
                pWaterCheck3 = Map.GetAdjacentPlot(pNWPlot:GetX(), pNWPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
                
                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                
                if (pWaterCheck1:IsWater() == false or pWaterCheck2:IsWater() == false or pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pWPlot:GetIndex());
                    table.insert(aPlots, pNWPlot:GetIndex());
                    return true;
                end
            end
            
            if (bNEValid  ~= nil and bEValid ~= nil and bNEValid  == true and bEValid == true ) then    
                pWaterCheck1 = Map.GetAdjacentPlot(pNEPlot:GetX(), pNEPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
                pWaterCheck2 = Map.GetAdjacentPlot(pEPlot:GetX(), pEPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
                pWaterCheck3 = Map.GetAdjacentPlot(pEPlot:GetX(), pEPlot:GetY(), DirectionTypes.DIRECTION_EAST);
                
                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                
                if (pWaterCheck1:IsWater() == false or pWaterCheck2:IsWater() == false or pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pNEPlot:GetIndex());
                    table.insert(aPlots, pEPlot:GetIndex());
                    return true;
                end
            end

            if (bNWValid  ~= nil and bNEValid ~= nil and bNWValid  == true and bNEValid == true ) then
                pWaterCheck1 = Map.GetAdjacentPlot(pNWPlot:GetX(), pNWPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
                pWaterCheck2 = Map.GetAdjacentPlot(pNEPlot:GetX(), pNEPlot:GetY(), DirectionTypes.DIRECTION_NORTHWEST);
                pWaterCheck3 = Map.GetAdjacentPlot(pNEPlot:GetX(), pNEPlot:GetY(), DirectionTypes.DIRECTION_NORTHEAST);
                
                if ((pWaterCheck1 == nil) or (pWaterCheck2 == nil) or (pWaterCheck3 == nil)) then
                    -- Off the edge of the map. This prevents NPE.
                    return false;
                end
                
                if (pWaterCheck1:IsWater() == false or pWaterCheck2:IsWater() == false or pWaterCheck3:IsWater() == false) then
                    return false;
                else
                    table.insert(aPlots, pNWPlot:GetIndex());
                    table.insert(aPlots, pNEPlot:GetIndex());
                    return true;
                end
            end
        end
        
    -- 3 tiles in a triangle that is always "pointing up"
    elseif (customPlacement == "PLACEMENT_PAITITI") then

        local pSEPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST);
        local pSWPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), DirectionTypes.DIRECTION_SOUTHWEST);
        if (pSEPlot ~= nil and pSWPlot ~= nil) then
            local bSEValid:boolean = TerrainBuilder.CanHaveFeature(pSEPlot, eFeatureType, true);
            local bSWValid:boolean = TerrainBuilder.CanHaveFeature(pSWPlot, eFeatureType, true);
            if (bSEValid and bSWValid) then
                table.insert(aPlots, pSEPlot:GetIndex());
                table.insert(aPlots, pSWPlot:GetIndex());
                return true;
            end
        end
    end

    return false;
end

function ResetTerrain(iPlot)
    -- No-op - don't let NW generator mess with terrain.
end

function ResetNaturalWonderTerrain(pPlot)
    -- Call this after running PassMaker on natural wonders.
    local iTerrain = pPlot:GetTerrainType();
    if(iTerrain == g_TERRAIN_TYPE_SNOW_HILLS  or 
       iTerrain == g_TERRAIN_TYPE_SNOW_MOUNTAIN) then
        TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_SNOW);
        
    elseif(iTerrain == g_TERRAIN_TYPE_DESERT_HILLS  or 
           iTerrain == g_TERRAIN_TYPE_DESERT_MOUNTAIN) then
        TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);
        
    elseif(iTerrain == g_TERRAIN_TYPE_PLAINS_HILLS  or 
           iTerrain == g_TERRAIN_TYPE_PLAINS_MOUNTAIN) then
        TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_PLAINS);
        
    elseif(iTerrain == g_TERRAIN_TYPE_GRASS_HILLS  or 
           iTerrain == g_TERRAIN_TYPE_GRASS_MOUNTAIN) then
        TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_GRASS);
        
    elseif(iTerrain == g_TERRAIN_TYPE_TUNDRA_HILLS  or 
           iTerrain == g_TERRAIN_TYPE_TUNDRA_MOUNTAIN) then
        TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_TUNDRA);
    end
end

function GenerateNaturalWonders()
    print("Adding natural wonders");
    
    if ScriptData.gotSelectNWsPlusPlus then
        print("Select Natural Wonders++ mod detected.");
    end
    
    local wonderArgs = 
    {
        numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
    };
    NaturalWonderGenerator.Create(wonderArgs);
    
    if RECALC_AREAS_AFTER_NATURAL_WONDERS then
        -- Recalculate land areas and check for chokepoints before adding cliffs.
        -- This causes NWs such as Dead Sea and Lake Retba to become fresh, but
        -- skipping this may destabilize ASP.
        print("Recalculating areas after generating natural wonders.");
        AreaBuilder.Recalculate();
    else
        print("Skipping recalculation of areas after generating natural wonders.");
    end
end
------------------------------------------------------------------------------
-- Cliffs
------------------------------------------------------------------------------
function SetCliff(iX, iY)
    local pPlot = Map.GetPlot(iX,iY);

    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
        local adjacentPlot = Map.GetAdjacentPlot(iX, iY, direction);
        if (adjacentPlot ~= nil) then
            if (adjacentPlot:IsWater() == true) then
                if(direction == DirectionTypes.DIRECTION_NORTHEAST) then
                    TerrainBuilder.SetNEOfCliff(adjacentPlot, true);
                elseif(direction == DirectionTypes.DIRECTION_EAST) then
                    TerrainBuilder.SetWOfCliff(pPlot, true); 
                elseif(direction == DirectionTypes.DIRECTION_SOUTHEAST) then
                    TerrainBuilder.SetNWOfCliff(pPlot, true); 
                elseif(direction == DirectionTypes.DIRECTION_SOUTHWEST) then
                    TerrainBuilder.SetNEOfCliff(pPlot, true); 
                elseif(direction == DirectionTypes.DIRECTION_WEST) then
                    TerrainBuilder.SetWOfCliff(adjacentPlot, true); 
                elseif(direction == DirectionTypes.DIRECTION_NORTHWEST) then
                    TerrainBuilder.SetNWOfCliff(adjacentPlot, true); 
                end
            end
        end
    end
end

function AddCliffs()
    print("Adding cliffs");
    for iX = 0, g_iW - 1 do
        for iY = 0, g_iH - 1 do    
            if (MapGetPlotType(iX,iY) == g_PLOT_TYPE_HILLS and 
                -- Allow cliffs next to lakes or coasts
                IsAdjacentToWater(iX, iY) == true and 
                IsAdjacentToIce(iX, iY)   == false and
                IsAdjacentToRiver(iX, iY) == false) then
                
                local plot = Map.GetPlot(iX, iY);
                local area = plot:GetArea();
                
                -- Don't worry about areas not having flat coast.
                -- Mountain reachability will break cliffs if necessary.
                -- Also, Lakes maps might not have any coast, but just fresh lakes.
                if (area:GetPlotCount() > 1) then
                    SetCliff(iX, iY);
                end
            end
        end
    end
end
------------------------------------------------------------------------------
-- Terrain Reachability
--
-- Ensures that all passable tiles are reachable, regardless of the placement 
-- of impassable tiles. Creates passes if necessary.
------------------------------------------------------------------------------
function ConnectSeas()
    -- If applicable, connect all bodies of salt water into a single system of oceans.
    -- Args: 
    --   plotTypes (optional): connect all water during plot-type-gen if non-null;
    --     otherwise connect salt water via global map.
    if (not UserInput.connectSeas) then
        print("Not connecting seas.");
        return;
    end
    
    print("Connecting seas.");
    
    -- Use PassMaker to connect seas with random channels.
    local channelArgs = 
    {
        obstaclesName         = "land and fresh lakes",
        InitReachPlot         = PassMaker.NonSaltWater_InitReachPlot,
        RemoveObstacle      = PassMaker.NonSaltWater_RemoveObstacle,
    };
    EnsureReachabilityWithPassMaker(channelArgs);
end

function EnsureTerrainReachability()
    -- DO NOT check for areas that are completely surrounded by natural wonders,
    -- because it might not be possible to completely remove them from the map.
    --
    -- Reset terrain under natural wonders.
    print("Normalizing terrain under natural wonders.");
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local plot = Map.GetPlot(x, y);
            if plot:IsNaturalWonder() then
                ResetNaturalWonderTerrain(plot);
            end
        end
    end
    
    -- DO NOT check for areas that are completely surrounded by volcanoes,
    -- because volcoanoes are impossible to remove from the map.
    --
    -- Check for areas that are completely surrounded by mountains and cliffs.
    -- PassMaker's default behavior is mountain reachability.
    local reachArgs = { noHills = UserInput.noHills, hillsPct = ScriptData.hillAdjust };
    EnsureReachabilityWithPassMaker(reachArgs);
    
    -- Connect salt-water seas and oceans, if applicable.
    -- Do this after checking wonders and volcanoes.
    ConnectSeas();
    
    -- Ensure that all non-mountain tiles are still reachable despite ice.
    reachArgs = 
    {
        obstaclesName   = "ice",
        InitReachPlot   = PassMaker.Ice_InitReachPlot,
        RemoveObstacle  = PassMaker.Ice_RemoveObstacle,
    };
    EnsureReachabilityWithPassMaker(reachArgs);
    
    -- Check whether ice blocks circumnavigation. Carve ice paths if necessary.
    ScriptData.circumnavGen:AddIceChannels(CIRCUMNAV_NUM_PATHS_THROUGH_ICE);
    
    -- Remove features from non-volcano mountains,
    -- and check for any former mountains that require features.
    print("Normalizing features.");
    for x = 0, g_iW - 1 do
        for y = 0, g_iH - 1 do
            local plot = Map.GetPlot(x, y);
            if plot:IsMountain() and (not IsVolcano(plot)) then
                -- Remove features from regular mountains
                TerrainBuilder.SetFeatureType(plot, g_FEATURE_NONE);
                
            elseif ((not ScriptData.gotGatheringStorm) and
                    (not UserInput.noFloodplns) and
                    plot:IsRiver() and 
                    (plot:GetTerrainType() == g_TERRAIN_TYPE_DESERT)) then
                -- Add floodplains to all river-adjacent flat-land desert plots.
                -- Not applicable to GS.
                TerrainBuilder.SetFeatureType(plot, g_FEATURE_FLOODPLAINS);
            end
        end
    end
    
    if RECALC_AREAS_AFTER_NATURAL_WONDERS then
        -- Some areas may have coalesced after removing obstacles.
        -- This causes NWs such as Dead Sea and Lake Retba to become fresh, but
        -- skipping this may destabilize ASP.
        print("Recalculating areas after ensuring terrain reachability.");
        AreaBuilder.Recalculate();
    else
        print("Skipping recalculation of areas after ensuring terrain reachability.");
    end
end
------------------------------------------------------------------------------
-- Coastal Lowlands
------------------------------------------------------------------------------
function MarkCoastalLowlands()
    -- Override to harden against MP desyncs and support new lowland levels
    -- Includes a few tweaks from Nere's Inland Flooding.
    local lowlandsGen = GotLakes_LowlandsGenerator.Create();
    lowlandsGen:MarkLowlands();
end
------------------------------------------------------------------------------
-- Resource Generator overrides
-- Need to declare these before declaring land and climate info.
------------------------------------------------------------------------------
function CanHaveLuxResource(plot, resourceIndex)
    -- A simple test for luxury resource placement on land.
    -- Much easier than overriding terrain-resource mappings.
    --
    -- Args:
    --   plot: plot to check
    --   resourceIndex: which resource to validate
    -- Returns: true iff the plot is allowed to have the resource.
    local featureType = plot:GetFeatureType();
    
    if ((UserInput.scraLux == false) or IsFloodplains(featureType)) then
        -- Scrambled luxuries disabled. Use the default check.
        -- 
        -- Either that or the current plot is a type of floodplains,
        -- in which case use the default check
        -- because floodplains do not allow certain types of improvements such as mines.
        return ResourceBuilder.CanHaveResource(plot, resourceIndex);
    end
    -- Else use a simple set of rules to decide where the resource can go.
    
    if (plot:IsWater() or plot:IsMountain()) then
        -- Avoid certain plots.
        return false;
    end
    
    local terrainType = plot:GetTerrainType();
    
    if ((ScriptData.numTerrainTypes > SCRAMBLED_SNOW_LUX_MAX_NUM_LAND_TERRAINS) and 
        ((terrainType == g_TERRAIN_TYPE_SNOW) or 
         (terrainType == g_TERRAIN_TYPE_SNOW_HILLS))) then
        -- Avoid snow if there are other terrain types available.
        return false;
    end
    
    if ((featureType == g_FEATURE_NONE) or
        (g_FEATURE_VOLCANIC_SOIL and (featureType == g_FEATURE_VOLCANIC_SOIL)) or
        (featureType == g_FEATURE_JUNGLE) or
        (featureType == g_FEATURE_FOREST) or
        (featureType == g_FEATURE_MARSH)) then
        -- Allow only these features.
        -- Avoid oases, geothermal fissures, etc.
        -- Avoid natural wonders, which are special feature types.
        return true;
    end

    return false;
end

function CanHaveStrategicResource(plot, resourceIndex)
    -- A simple test for strategic-resource placement on land.
    -- Much easier than overriding terrain-resource mappings.
    --
    -- Args:
    --   plot: plot to check
    --   resourceIndex: which resource to validate
    -- Returns: true iff the plot is allowed to have the resource.
    local featureType = plot:GetFeatureType();    
    
    if ((ScriptData.numTerrainTypes > STRAT_RESOURCE_RELAXATION_MAX_NUM_LAND_TERRAINS) or
        IsFloodplains(featureType)) then
        -- The map contains a reasonable number of significantly-represented land terrain types.
        -- Use the default check to maintain balance of resource placement.
        --
        -- Either that or the current plot is a type of floodplains,
        -- in which case use the default check
        -- because floodplains do not allow certain types of improvements such as mines.
        return ResourceBuilder.CanHaveResource(plot, resourceIndex);
    end
    -- Else use a simple set of rules to decide where the resource can go.
    if (plot:IsWater() or plot:IsMountain()) then
        -- Avoid certain plots.
        return false;
    end
    
    if ((featureType == g_FEATURE_NONE) or
        (g_FEATURE_VOLCANIC_SOIL and (featureType == g_FEATURE_VOLCANIC_SOIL)) or
        (featureType == g_FEATURE_JUNGLE) or
        (featureType == g_FEATURE_FOREST) or
        (featureType == g_FEATURE_MARSH)) then
        -- Allow only these features.
        -- Avoid ice, oases, geothermal fissures, etc.
        -- Avoid natural wonders, which are special feature types.
        return true;
    end

    return false;
end

function CompareResourceTypes(a,b)
    if (a.NumEntries == b.NumEntries) then
        -- Use index as a tie-breaker to avoid MP desyncs.
        return a.ResourceIndex < b.ResourceIndex;
    end
    return a.NumEntries < b.NumEntries;
end

function ResourceGenerator:__ValidLuxuryPlots(eContinent)
    -- Custom logic to allow more luxuries on non-normal climates.
    -- go through each plot on the continent and put the luxuries    
    local iSize = #self.aLuxuryType;
    local iBaseScore = 1;
    self.iTotalValidPlots = 0;
    
    local avoidIce = ScriptData.climateInfo.resourcesAvoidIce;

    plots = Map.GetContinentPlots(eContinent);
    local iNumPlots = #plots; 
    for i, plot in ipairs(plots) do
    
        local bCanHaveSomeResource = false;
        local pPlot = Map.GetPlotByIndex(plot);

        if(pPlot~=nil and pPlot:IsWater() == false) then
        
            -- See which resources can appear here
            for iI = 1, iSize do
                local bIce = false;

                if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
                    bIce = avoidIce;
                end
                
                -- Relax constraints on resource placement.
                if (CanHaveLuxResource(pPlot, 
                    self.eResourceType[self.aLuxuryType[iI]]) and (bIce == false)) then
                    row = {};
                    row.MapIndex = plot;
                    row.Score = iBaseScore;

                    table.insert (self.aaPossibleLuxLocs[self.aLuxuryType[iI]], row);
                    bCanHaveSomeResource = true;
                end
            end


            if (bCanHaveSomeResource == true) then
                self.iTotalValidPlots = self.iTotalValidPlots + 1;
            end
        end
        -- Compute how many of each resource to place
    end
    
    -- The base game has a "fix" to make land heavy maps have a more equal amount of luxuries 
    -- to other maps. However, this effectively removes lux and strat resources from most of
    -- the water, which leaves mostly bonus resources, so...hack omitted.

    self.iOccurencesPerFrequency = self.iTargetPercentage / 100 * iNumPlots * self.iLuxuryPercentage / 100 / self.iLuxuriesPerRegion;
end

function ResourceGenerator:__GL_HD_PlaceLuxuryResources(chosenLuxID, continentID, extra)
    -- Override for compatibility with Harmony in Diversity v.1.3.4
    local cont = self.continentInfo[continentID]
    local possiblePlots = {};
    local numToPlace = self.iTargetPercentage / 100 * cont.num * 
                       self.iLuxuryPercentage / 100 / cont.numLuxuries + extra;
    for i, plot in ipairs(cont.plots) do
        local pPlot = Map.GetPlotByIndex(plot)
        if (pPlot~=nil and pPlot:IsWater() == false) then
            if CanHaveLuxResource(pPlot, self.eResourceType[chosenLuxID]) then
                local score = 500
                local adjResources = ResourceBuilder.GetAdjacentResourceCount(pPlot)
                score = score / ((adjResources + 1) * 3.75)
                score = score + TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") -- origin: 100
                if adjResources <= 1 then
                    table.insert(possiblePlots, {MapIndex=plot, Score=score})
                end
            end
        end
    end
    table.sort(possiblePlots, CompareScoredPlots) -- GL hardening against MP desyncs
    local numPossiblePlots = #possiblePlots
    local placed = 0;
    for i = 1, numPossiblePlots do
        local pPlot = Map.GetPlotByIndex(possiblePlots[i].MapIndex);
        if ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 0 then
            ResourceBuilder.SetResourceType(pPlot, self.eResourceType[chosenLuxID], 1);
            placed = placed + 1;
        end
        if placed >= numToPlace then
            break;
        end
    end
    return numToPlace - placed;
end

function ResourceGenerator:__PlaceLuxuryResources(eChosenLux, eContinent, hdExtra)
    -- Override to harden against MP desyncs.
    -- Go through continent placing the chosen luxuries 
    
    if self.__PrepareContinentsData then
        -- Got Harmony in Diversity mod
        if not self.reportedHDDetection then
            print("Harmony in Diversity detected. Applying HD override to land luxury placement.");
            self.reportedHDDetection = true;
        end
        self.__GL_HD_PlaceLuxuryResources = ResourceGenerator.__GL_HD_PlaceLuxuryResources;
        -- HD override has a return value unlike the base game.
        return self:__GL_HD_PlaceLuxuryResources(eChosenLux, eContinent, hdExtra);
    end
    
    plots = Map.GetContinentPlots(eContinent);
    --print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));
    --print("Resource: ", eChosenLux);

    local iTotalPlaced = 0;

    -- Compute how many to place
    local iNumToPlace = 1;
    if(self.iOccurencesPerFrequency > 1) then
        iNumToPlace = self.iOccurencesPerFrequency;
    end

    -- Score possible locations
    self:__ScoreLuxuryPlots(eChosenLux, eContinent);

    -- Sort and take best score
    table.sort (self.aaPossibleLuxLocs[eChosenLux], CompareScoredPlots);

    for iI = 1, iNumToPlace do
            if (iI <= #self.aaPossibleLuxLocs[eChosenLux]) then
                local iMapIndex = self.aaPossibleLuxLocs[eChosenLux][iI].MapIndex;
                local iScore = self.aaPossibleLuxLocs[eChosenLux][iI].Score;

                -- Place at this location
                local pPlot = Map.GetPlotByIndex(iMapIndex);
                ResourceBuilder.SetResourceType(pPlot, self.eResourceType[eChosenLux], 1);
            iTotalPlaced = iTotalPlaced + 1;
        end
    end
end

function ResourceGenerator:__ScoreLuxuryPlots(iResourceIndex, eContinent)
    -- Custom logic to allow more luxuries on non-normal climates.
    -- Clear all earlier entries (some might not be valid if resources have been placed
    for k, v in SortedPairs(self.aaPossibleLuxLocs[iResourceIndex]) do
        self.aaPossibleLuxLocs[iResourceIndex][k] = nil;
    end
    
    local avoidIce = ScriptData.climateInfo.resourcesAvoidIce;

    plots = Map.GetContinentPlots(eContinent);
    for i, plot in ipairs(plots) do
        local pPlot = Map.GetPlotByIndex(plot);
        local bIce = false;
        
        if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
            bIce = avoidIce;
        end

        -- Relax constraints on resource placement.
        if (CanHaveLuxResource(pPlot, self.eResourceType[iResourceIndex]) and bIce == false) then
            row = {};
            row.MapIndex = plot;
            row.Score = 500;
            row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 3.75);
            row.Score = row.Score + 
                TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
            
            if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or 
               #self.aaPossibleLuxLocs == 0) then
                    table.insert (self.aaPossibleLuxLocs[iResourceIndex], row);
            end
        end
    end
end

function ResourceGenerator:__ValidStrategicPlots(iWeight, eContinent)
    -- Custom logic to allow all strategics on Snowball climate.
    -- go through each plot on the continent and find the valid strategic plots
    local iSize = #self.aStrategicType;
    local iBaseScore = 1;
    self.iTotalValidPlots = 0;
    self.aResourcePlacementOrderStrategic = {};
    plots = Map.GetContinentPlots(eContinent);

    -- Find valid spots for land resources first
    for i, plot in ipairs(plots) do
        local bCanHaveSomeResource = false;
        local pPlot = Map.GetPlotByIndex(plot);

        -- See which resources can appear here
        for iI = 1, iSize do
            local eResourceType = self.eResourceType[self.aStrategicType[iI]];
            
            -- Relax constraints on resource placement.
            if (CanHaveStrategicResource(pPlot, eResourceType)) then
                row = {};
                row.MapIndex = plot;
                row.Score = iBaseScore;
                table.insert (self.aaPossibleStratLocs[self.aStrategicType[iI]], row);
                bCanHaveSomeResource = true;
            end
        end

        if (bCanHaveSomeResource == true) then
            self.iTotalValidPlots = self.iTotalValidPlots + 1;
        end
    end

    for iI = 1, iSize do
        row = {};
        row.ResourceIndex = self.aStrategicType[iI];
        row.NumEntries = #self.aaPossibleStratLocs[iI];
        row.Weight = iWeight or 0;
        table.insert (self.aResourcePlacementOrderStrategic, row);
    end

    table.sort (self.aResourcePlacementOrderStrategic, CompareResourceTypes);

    self.iOccurencesPerFrequency = (#plots) * (self.iTargetPercentage / 100)  * (self.iStrategicPercentage / 100);
end

function ResourceGenerator:__PlaceStrategicResources(eContinent)
    -- Override to harden against MP desyncs.
    -- Go through continent placing the chosen strategic
    for i, row in ipairs(self.aResourcePlacementOrderStrategic) do
        local eResourceType = self.eResourceType[row.ResourceIndex]

        local iNumToPlace;

        -- Compute how many to place
        iNumToPlace = self.iOccurencesPerFrequency * 
            (self.iFrequency[row.ResourceIndex] / self.iFrequencyStrategicTotal) * row.Weight;

            -- Score possible locations
        self:__ScoreStrategicPlots(row.ResourceIndex, eContinent);

        -- Sort and take best score
        table.sort (self.aaPossibleStratLocs[row.ResourceIndex], CompareScoredPlots);

        if(self.iFrequency[row.ResourceIndex] > 1 and iNumToPlace < 1) then
            iNumToPlace = 1;
        end

        for iI = 1, iNumToPlace do
            if (iI <= #self.aaPossibleStratLocs[row.ResourceIndex]) then
                local iMapIndex = self.aaPossibleStratLocs[row.ResourceIndex][iI].MapIndex;
                local iScore = self.aaPossibleStratLocs[row.ResourceIndex][iI].Score;

                -- Place at this location
                local pPlot = Map.GetPlotByIndex(iMapIndex);
                ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
            end
        end
    end
end

function ResourceGenerator:__ScoreStrategicPlots(iResourceIndex, eContinent)
    -- Custom logic to allow all strategics on Snowball climate.
    -- Clear all earlier entries (some might not be valid if resources have been placed
    for k, v in SortedPairs(self.aaPossibleStratLocs[iResourceIndex]) do
        self.aaPossibleStratLocs[iResourceIndex][k] = nil;
    end

    local scoreMult = 4.5;
    
    if ScriptData.gotGatheringStorm then
        -- Base game logic for GS.
        local iBonusAdjacent = 0;

        if( self.iStandardPercentage < self.iTargetPercentage) then
            iBonusAdjacent = 5;
        elseif ( self.iStandardPercentage > self.iTargetPercentage) then
            iBonusAdjacent = -5;
        end
        scoreMult = (15 + iBonusAdjacent);
    end

    plots = Map.GetContinentPlots(eContinent);
    for i, plot in ipairs(plots) do
        local pPlot = Map.GetPlotByIndex(plot);
        -- Relax constraints on resource placement.
        if (CanHaveStrategicResource(pPlot, self.eResourceType[iResourceIndex])) then
            row = {};
            row.MapIndex = plot;
            row.Score = 500;
            row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * scoreMult);
            row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
            
            if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleStratLocs == 0) then
                table.insert (self.aaPossibleStratLocs[iResourceIndex], row);
            end
        end
    end
end

function ResourceGenerator:__GetOtherResources()
    -- Override to harden against MP desyncs.
    self.aOtherType = {};
    -- Find the other resources
    for row = 0, self.iResourcesInDB do
        local index  = self.aIndex[row];
        if(self.eResourceClassType[index] ~= nil) then
            if (self.eResourceClassType[index] ~= "RESOURCECLASS_STRATEGIC" and 
                self.eResourceClassType[index] ~= "RESOURCECLASS_LUXURY" and 
                self.eResourceClassType[index] ~= "RESOURCECLASS_ARTIFACT") then
                if(self.iFrequency[index] > 0) then
                    table.insert(self.aOtherType, index);
                end
            end
        end
    end

    -- Shuffle the table
    self.aOtherType = GetShuffledCopyOfTable(self.aOtherType);

    local iBaseScore = 1;
    self.iTotalValidPlots = 0;
    local iSize = #self.aOtherType;
    local iPlotCount = Map.GetPlotCount();
    for i = 0, iPlotCount - 1 do
        local pPlot = Map.GetPlotByIndex(i);
        local bCanHaveSomeResource = false;

        -- See which resources can appear here
        for iI = 1, iSize do
            if (ResourceBuilder.CanHaveResource(
                    pPlot, self.eResourceType[self.aOtherType[iI]])) then
                row = {};
                row.MapIndex = i;
                row.Score = iBaseScore;
                table.insert (self.aaPossibleLocs[self.aOtherType[iI]], row);
                bCanHaveSomeResource = true;
            end
        end

        if (bCanHaveSomeResource == true) then
            self.iTotalValidPlots = self.iTotalValidPlots + 1;
        end
    end

    for iI = 1, iSize do
        row = {};
        row.ResourceIndex = self.aOtherType[iI];
        row.NumEntries = #self.aaPossibleLocs[iI];
        table.insert (self.aResourcePlacementOrder, row);
    end

    table.sort (self.aResourcePlacementOrder, CompareResourceTypes);

    for i, row in ipairs(self.aOtherType) do
        self.iFrequencyTotal = self.iFrequencyTotal + self.iFrequency[row];
    end

    --print ("Total frequency: " .. tostring(self.iFrequencyTotal));

    -- Compute how many of each resource to place
    self.iOccurencesPerFrequency = 
        (self.iTargetPercentage / 100 ) * self.iTotalValidPlots * 
        (100 - self.iStrategicPercentage - self.iLuxuryPercentage) / 100 / self.iFrequencyTotal;

    --print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));

    self:__PlaceOtherResources();
end

function ResourceGenerator:__PlaceOtherResources()
    -- Override to harden against MP desyncs.
    for i, row in ipairs(self.aResourcePlacementOrder) do

        local eResourceType = self.eResourceType[row.ResourceIndex]

        local iNumToPlace;

        -- Compute how many to place
        iNumToPlace = self.iOccurencesPerFrequency * self.iFrequency[row.ResourceIndex];
    
        -- Score possible locations
        self:__ScorePlots(row.ResourceIndex);
    
        -- Sort and take best score
        table.sort (self.aaPossibleLocs[row.ResourceIndex], CompareScoredPlots);

        for iI = 1, iNumToPlace do
            if (iI <= #self.aaPossibleLocs[row.ResourceIndex]) then
                local iMapIndex = self.aaPossibleLocs[row.ResourceIndex][iI].MapIndex;
                local iScore = self.aaPossibleLocs[row.ResourceIndex][iI].Score;

                    -- Place at this location
                local pPlot = Map.GetPlotByIndex(iMapIndex);
                ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
            end
        end
    end
end

function ResourceGenerator:__GetWaterOtherResources()
    -- Override to harden against MP desyncs.
    self.aOtherTypeWater = {};
    -- Find the other resources
    for row = 0, self.iResourcesInDB do
        local index  =self.aIndex[row];
        if (self.eResourceClassType[index] ~= nil) then
            if (self.eResourceClassType[index] ~= "RESOURCECLASS_STRATEGIC" and 
                self.eResourceClassType[index] ~= "RESOURCECLASS_LUXURY" and 
                self.eResourceClassType[index] ~= "RESOURCECLASS_ARTIFACT") then
                if(self.iSeaFrequency[index] > 0) then
                    table.insert(self.aOtherTypeWater, index);
                end
            end
        end
    end

    -- Shuffle the table
    self.aOtherTypeWater = GetShuffledCopyOfTable(self.aOtherTypeWater);

    local iBaseScore = 1;
    self.iTotalValidPlots = 0;
    local iSize = #self.aOtherTypeWater;
    local iPlotCount = Map.GetPlotCount();
    for i = 0, iPlotCount - 1 do
        local pPlot = Map.GetPlotByIndex(i);
        local bCanHaveSomeResource = false;

        -- See which resources can appear here
        for iI = 1, iSize do
            if (ResourceBuilder.CanHaveResource(
                    pPlot, self.eResourceType[self.aOtherTypeWater[iI]])) then
                row = {};
                row.MapIndex = i;
                row.Score = iBaseScore;
                table.insert (self.aaPossibleWaterLocs[self.aOtherTypeWater[iI]], row);
                bCanHaveSomeResource = true;
            end
        end

        if (bCanHaveSomeResource == true) then
            self.iTotalValidPlots = self.iTotalValidPlots + 1;
        end
    end

    for iI = 1, iSize do
        row = {};
        row.ResourceIndex = self.aOtherTypeWater[iI];
        row.NumEntries = #self.aaPossibleWaterLocs[iI];
        table.insert (self.aWaterResourcePlacementOrder, row);
    end

    table.sort (self.aWaterResourcePlacementOrder, CompareResourceTypes);
    self.iFrequencyTotalWater = 0;

    for i, row in ipairs(self.aOtherTypeWater) do
        self.iFrequencyTotalWater = self.iFrequencyTotalWater + self.iSeaFrequency[row];
    end

    --print ("Total frequency: " .. tostring(self.iFrequencyTotalWater));

    -- Compute how many of each resource to place
    self.iOccurencesPerFrequency = 
        (self.iTargetPercentage / 100 ) * self.iTotalValidPlots * 
        (100 - self.iStrategicPercentage - self.iLuxuryPercentage) / 100 / 
        self.iFrequencyTotalWater * self.iWaterBonus;

    --print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));

    self:__PlaceWaterOtherResources();
end

function ResourceGenerator:__PlaceWaterOtherResources()
    -- Override to harden against MP desyncs.
    for i, row in ipairs(self.aWaterResourcePlacementOrder) do
        local eResourceType = self.eResourceType[row.ResourceIndex]

        -- Compute how many to place
        local iNumToPlace = self.iOccurencesPerFrequency * self.iSeaFrequency[row.ResourceIndex];
    
        -- Score possible locations
        self:__ScoreWaterPlots(row.ResourceIndex);
    
        -- Sort and take best score
        table.sort (self.aaPossibleWaterLocs[row.ResourceIndex], CompareScoredPlots);

        for iI = 1, iNumToPlace do
            if (iI <= #self.aaPossibleWaterLocs[row.ResourceIndex]) then
                local iMapIndex = self.aaPossibleWaterLocs[row.ResourceIndex][iI].MapIndex;
                local iScore = self.aaPossibleWaterLocs[row.ResourceIndex][iI].Score;

                    -- Place at this location
                local pPlot = Map.GetPlotByIndex(iMapIndex);
                ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
            end
        end
    end
end

function GenerateResources()
    print("Generating resources (" .. 
        ScriptData.landInfo.name .. " + " .. 
        ScriptData.climateInfo.name .. ").");

    local resourceArgs = 
    {
        -- Don't bother trying to override iWaterBonus--the effect is neglible.
        iWaterLux    = ScriptData.landInfo.resourceWaterLux,
        resources    = UserInput.resources,
        START_CONFIG = UserInput.start
    };
    local resGen = ResourceGenerator.Create(resourceArgs);
end
------------------------------------------------------------------------------
-- Overrides for the system that determines civ starting plots.
------------------------------------------------------------------------------
function GetASPCommonArgs()
    -- Return a new args with common settings from constants and script data.
    local args = 
    {
        enableCustomStartBias  = ASP_ENABLE_GL_START_BIAS,
        enableFallbacks        = ASP_ENABLE_NONSTD_STARTS_WITH_FALLBACKS,
        enableForcedStarts     = ASP_NO_FORCED_STARTS,
        enableLakeStarts       = ASP_ENABLE_FRESH_LAKE_WATER_STARTS,
        idealDistBetween2MCivs = ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS,
        isMinor                = ASP_START_MAJOR,
        minDistBetweenCivs     = ASP_MIN_DISTANCE_BETWEEN_MAJOR_CIVS,
        minReachableLandRatio  = ASP_STARTAREA_MIN_REACHABLE_LAND_RATIO,
        safeDistBetween2MCivs  = ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS,
        startBiasLogLevel      = ASP_START_BIAS_LOG_LEVEL,
        startOnWater           = ASP_START_ON_LAND,
        wrapX                  = ScriptData.wrapX
    };
    return args;
end

function DetermineCustomStarts(numCivs, numWaterCivs, numMinorCivs, minY, maxY)
    -- Use custom start positioner to get land and water starts.
    -- Args: 
    --   numCivs: total number of major civs
    --   numWaterCivs: number of water-start civs
    --   numMinorCivs: number of minor civs a.k.a. city states
    --   minY: minimum Y index for starts as percentage of map height
    --   maxY: maximum Y index for starts as percentage of map height
    -- Returns:
    --   landStartPlots: a list of land start positions, one for each civ
    --        (including water civs, which can be used as back-up starts in case
    --      water-starts fail)
    --   waterStartPlots: a list of water start positions, up to one for each
    --     water-start civ
    --   minorStartPlots: a list of minor start positions, one for each 
    --     minor civ
    print("Running custom start positioner.");
    print("Got " .. numCivs .. " civs total, " 
                 .. numWaterCivs .. " of which can start in water.");
    if (minY > 0 or maxY < 100) then
        print("(minY,maxY): " .. CoordString(minY, maxY));
    end
    
    local landStarts  = UserInput.landStarts;
    local waterStarts = UserInput.waterStarts;
    local minorStarts = UserInput.minorStarts;
    
    local numWaterStarts = numWaterCivs;
    if ((numWaterCivs > 0) and (waterStarts == WaterStarts.ONLAND)) then
        -- The user wants all civs to start on land.
        print("Forcing " .. numWaterCivs .. " water civ(s) to start on land.");
        numWaterStarts = 0;
    end
    
    local landDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_STANDARD,
        DIVMETHOD_SEPARATE,
        ScriptData.landInfo.aspLandDivMethod,
    };
    
    local waterDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_STANDARD,
        DIVMETHOD_SEPARATE,
        ScriptData.landInfo.aspWaterDivMethod,
    };
    
    local chosenLandMethod = landDivMethods[landStarts];
    
    local minorDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_NONE,     -- standard for minor civs
        DIVMETHOD_SEPARATE,
        DIVMETHOD_STANDARD, -- major areas
        chosenLandMethod,   -- same as land starts
    };

    local args = GetASPCommonArgs();

    -- Use Custom start positioner to find land starts for all major civs.
    -- Water civs can use a land start as a fallback in case water start fails.
    args.divMethod = chosenLandMethod;
    args.numCivs   = numCivs;
    
    -- Note: a nil error here 
    -- probably means that Lua failed to interpret the GotLakes ASP lua file.
    local startPlots, distanceMaps = RunCustomASP(args, minY, maxY);
        
    if (#startPlots < numCivs) then
        -- Even the fallback attempt failed. Just bail out.
        print("ERROR: not enough starting spots for " .. numCivs .. " major civs!");
        return startPlots, {};
    end
    
    local waterStartPlots = {};
    if (numWaterStarts > 0) then
        -- Generate watery start positions.
        args.distanceMaps = distanceMaps;
        args.divMethod    = waterDivMethods[waterStarts];
        args.numCivs      = numWaterStarts;
        args.startOnWater = ASP_START_ON_WATER;
        waterStartPlots, distanceMaps = RunCustomASP(args, minY, maxY);
    end
    
    local minorStartPlots = {};
    if (numMinorCivs > 0) then
        -- Generate minor-civ start positions.
        args.distanceMaps       = distanceMaps;
        args.divMethod          = minorDivMethods[minorStarts];
        args.isMinor            = ASP_START_MINOR;
        args.minDistBetweenCivs = ASP_MIN_DISTANCE_BETWEEN_MINOR_CIVS;
        args.numCivs            = numMinorCivs;
        args.startOnWater       = ASP_START_ON_LAND;
        minorStartPlots = RunCustomASP(args, minY, maxY);
    end
    return startPlots, waterStartPlots, minorStartPlots;
end

function DetermineNonGLDistanceMaps(starts, distanceMaps)
    -- Convert non-GL starts into distance maps that GL can use to create additional starts.
    -- Args: 
    --   starts: non-GL starting positions
    --   distanceMaps (optional): plot maps indicating proximity to nearby civs
    -- Returns:
    --   distanceMaps: new/updated distance maps with the specified starting positions.
    local numStarts = #starts;
    print("Computing distance maps for " .. numStarts .. " non-GL start(s).");
        
    local args = GetASPCommonArgs();

    -- Initialize ASP for major land starts, 
    -- though we're not generating regions or choosing locations this time.
    --
    -- Note: an "attempt to index nil" error here 
    -- probably means that Lua failed to interpret the GotLakes ASP lua file.  
    args.distanceMaps = distanceMaps;
    args.numCivs      = numStarts;
    local asp = GotLakes_ASP.Create(args);
    
    for i = 1, numStarts do
        local startList = starts[i];
        if (startList and #startList > 0) then
            local start = startList[1];
            asp:PlaceImpactAndRipples(start:GetX(),start:GetY());
        end
    end
    return asp:GetDistanceMaps();
end

function DetermineCustomMinorStarts(numMinorCivs, minY, maxY, distanceMaps)
    -- Use custom start positioner to get minor-civ starts.
    -- Args: 
    --   numMinorCivs: number of minor civs a.k.a. city states
    --   minY: minimum Y index for starts as percentage of map height
    --   maxY: maximum Y index for starts as percentage of map height
    --   distanceMaps (optional): plot maps indicating proximity to nearby civs
    -- Returns:
    --   minorStartPlots: a list of minor start positions, one for each minor civ
    --   distance maps: new plot maps indicating proximity to nearby civs
    print("Running custom start positioner for minor starts.");
    print("Got " .. numMinorCivs .. " minor civ(s).");    
    if (minY > 0 or maxY < 100) then
        print("(minY,maxY): " .. CoordString(minY, maxY));
    end
    
    local distanceMaps = distanceMaps or CreateDistanceMaps(); 
    
    local landStarts  = UserInput.landStarts;
    local minorStarts = UserInput.minorStarts;
    
    local landDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_STANDARD,
        DIVMETHOD_SEPARATE,
        ScriptData.landInfo.aspLandDivMethod,
    };
    
    local chosenLandMethod = landDivMethods[landStarts];
    
    local minorDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_NONE,     -- standard for minor civs
        DIVMETHOD_SEPARATE,
        DIVMETHOD_STANDARD, -- major areas
        chosenLandMethod,   -- same as land starts
    };
    
    local minorStartPlots = {};
    if (numMinorCivs > 0) then
        -- Generate minor-civ start positions.
        local args = GetASPCommonArgs();
        args.distanceMaps       = distanceMaps;
        args.divMethod          = minorDivMethods[minorStarts];
        args.isMinor            = ASP_START_MINOR;
        args.minDistBetweenCivs = ASP_MIN_DISTANCE_BETWEEN_MINOR_CIVS;
        args.numCivs            = numMinorCivs;
        minorStartPlots, distanceMaps = RunCustomASP(args, minY, maxY);
    end
    return minorStartPlots, distanceMaps;
end

function DetermineCustomWaterStarts(numWaterCivs, minY, maxY, distanceMaps)
    -- Use custom start positioner to get water starts only.
    -- Args: 
    --   numWaterCivs: number of water-start civs
    --   minY: minimum Y index for starts as percentage of map height
    --   maxY: maximum Y index for starts as percentage of map height
    --   distanceMaps (optional): plot maps indicating proximity to nearby civs
    -- Returns:
    --   waterStartPlots: a list of water start positions, up to one for each
    --     water-start civ
      --   distanceMaps: new plot maps indicating proximity to nearby civs
    print("Running custom start positioner for water starts.");
    print("Got " .. numWaterCivs .. " civ(s) which can start in water.");
    if (minY > 0 or maxY < 100) then
        print("(minY,maxY): " .. CoordString(minY, maxY));
    end
    
    local distanceMaps = distanceMaps or CreateDistanceMaps();
    
    local waterStarts = UserInput.waterStarts;
    
    local numWaterStarts = numWaterCivs;
    if ((numWaterCivs > 0) and (waterStarts == WaterStarts.ONLAND)) then
        -- The user wants all civs to start on land.
        print("Forcing " .. numWaterCivs .. " water civ(s) to start on land.");
        numWaterStarts = 0;
    end
    
    local waterDivMethods = 
    {
        DIVMETHOD_BIGGEST,
        DIVMETHOD_STANDARD,
        DIVMETHOD_SEPARATE,
        ScriptData.landInfo.aspWaterDivMethod,
    };
    
    local waterStartPlots = {};
    if (numWaterStarts > 0) then
        -- Generate watery start positions.
        local args = GetASPCommonArgs();
        args.distanceMaps = distanceMaps;
        args.divMethod    = waterDivMethods[waterStarts];
        args.numCivs      = numWaterStarts;
        args.startOnWater = ASP_START_ON_WATER;
        waterStartPlots, distanceMaps = RunCustomASP(args, minY, maxY);
    end
    
    return waterStartPlots, distanceMaps;
end

function AssignStartingPlots:__GL_SetDefaultNumCivs()
    MapSizeTypes = {};
    for row in GameInfo.Maps() do
        MapSizeTypes[row.RowId] = row.DefaultPlayers;
    end
    local sizekey = Map.GetMapSize() + 1;
    local iDefaultNumberPlayers = MapSizeTypes[sizekey] or ScriptData.worldSizeInfo.numCivs;
    self.iDefaultNumberMajor = iDefaultNumberPlayers;
    self.iDefaultNumberMinor = math.floor(iDefaultNumberPlayers * 1.5);
end

function AssignStartingPlots:__GL_DetectWaterCivs(numMajorCivsTotal, totalCivsList)
    if (ScriptData.gotGatheringStorm and (not self.startAllOnLand) and GameInfo.Leaders_XP2) then
        -- Gathering Storm has civs that start in water.
        -- NumMajorCivs == number of civs that start on land.
        for i = 1, numMajorCivsTotal do
            local majorCiv = totalCivsList[i];
            local leaderType = PlayerConfigurations[majorCiv]:GetLeaderTypeName();
            if (GameInfo.Leaders_XP2[leaderType] ~= nil and 
                GameInfo.Leaders_XP2[leaderType].OceanStart == true) then
                print ("Found a civ that starts on water.");
                table.insert(self.waterMajorList, majorCiv);
                self.iNumWaterMajorCivs = self.iNumWaterMajorCivs + 1;
            else
                table.insert(self.majorList, majorCiv);
                self.iNumMajorCivs = self.iNumMajorCivs + 1;
            end
        end
    else
        -- Water starts either don't exist or are configured to start on land.
        -- Have all major civs start on land.
        self.iNumMajorCivs = numMajorCivsTotal;
        self.majorList     = totalCivsList;
    end
end

function AssignStartingPlots:__GL_PlaceMajorLandCivs()
    if(UserInput.start == START_BALANCED) then
        print("Tuning resources for balanced starts.");
        self:__AddResourcesBalanced();
        
    elseif (UserInput.start == START_LEGEND) then
        print("Tuning resources for legendary starts.");
        self:__AddResourcesLegendary();
    end
    
    local leyLinesSupported = (self.__AddLeyLine ~= nil);
    if leyLinesSupported then
        print("Adding ley lines to major start locations (Ethiopia pack fully supported).");
    else
        print("Skipping ley lines (Ethiopia pack not fully supported, possibly due to an outdated mod).");
    end
    
    for i, playerId in ipairs(self.majorList) do
        local player = Players[playerId];
        
        if(player == nil) then
            print("Major start #" .. i .. " FAILED");
        else
            local hasPlot = false;
            for k, v in SortedPairs(self.playerStarts[i]) do
                if(v~= nil and hasPlot == false) then
                    hasPlot = true;
                    if leyLinesSupported then
                        self:__AddLeyLine(v);
                    end
                    player:SetStartingPlot(v);
                    print("Major Start #" .. i .. " for Player #" .. playerId .. 
                          ": " .. CoordString(v:GetX(),v:GetY()));
                end
            end
        end
    end
end

function AssignStartingPlots:__GL_PlaceMinorCivs(minorStartPlots)
    --Begin Start Bias for minor        
    if ASP_ENABLE_GL_START_BIAS then
        -- Initialize custom start bias.
        self.playerStarts = {};
        self.playerStartPlayers = {};
        for i, startData in ipairs(minorStartPlots) do
            local plot = Map.GetPlot(startData.x, startData.y);
            local playerStart = {};
            playerStart[1] = plot;
            self.playerStarts[self.iNumMajorCivs + i] = playerStart;
            self.playerStartPlayers[self.iNumMajorCivs + i] = startData.playerId;
        end
    else
        self:__InitStartBias(true);
    end
    
    for i = 1, self.iNumMinorCivs do
        local playerId = self.minorList[i];
        if (self.playerStartPlayers ~= nil) then
            playerId = self.playerStartPlayers[i + self.iNumMajorCivs];
        end            
        local player = Players[playerId];
        
        if(player == nil) then
            print("Minor start #" .. i .. " FAILED");
        else
            local hasPlot = false;
            for k, v in SortedPairs(self.playerStarts[i + self.iNumMajorCivs]) do
                if(v~= nil and hasPlot == false) then
                    hasPlot = true;
                    player:SetStartingPlot(v);
                    print("Minor Start #" .. i .. " for player #" .. playerId ..
                          ": " .. CoordString(v:GetX(),v:GetY()));
                end
            end
        end
    end
end

function AssignStartingPlots:__GL_PlaceWaterCivs(waterStartPlots, startPlots)
    if (ScriptData.gotGatheringStorm and (self.iNumWaterMajorCivs > 0)) then
        -- Place the ocean civs
        local iWaterCivs = #waterStartPlots;

        for i = 1, iWaterCivs do
            -- All water players are unbiased, so we can ignore startData's player ID.
            local waterPlayer = Players[self.waterMajorList[i]];
            local startData = waterStartPlots[i];
            local pStartPlot = Map.GetPlot(startData.x, startData.y);
            waterPlayer:SetStartingPlot(pStartPlot);
            print("Water Start #" .. i .. ": " .. 
                  CoordString(pStartPlot:GetX(),pStartPlot:GetY()));
        end
        if (iWaterCivs < self.iNumWaterMajorCivs) then
            local numFailedCivs = self.iNumWaterMajorCivs - iWaterCivs;
            if startPlots then
                -- We tried and failed to place civs in water.
                print("Starting " .. numFailedCivs .. " water civ(s) on land.");
                
                -- Revert to land plots for failed civs.
                -- Must do this before doing start bias.
                for i = 1, numFailedCivs do
                    if #startPlots > 0 then
                        -- Replace water start with an already-determined land start.
                        local startData = startPlots[i + self.iNumMajorCivs];
                        local plot = Map.GetPlot(startData.x, startData.y);
                        table.insert(self.majorStartPlots, plot);
                        table.insert(self.majorCopy, plot);
                    end
                    
                    -- Move each failed water civ player to the land players list.
                    table.insert(self.majorList, self.waterMajorList[iWaterCivs + 1]);
                    table.remove(self.waterMajorList, iWaterCivs + 1);
                end
                self.iNumMajorCivs      = self.iNumMajorCivs      + numFailedCivs;
                self.iNumWaterMajorCivs = self.iNumWaterMajorCivs - numFailedCivs;
            else
                print("FAILURE PLACING WATER CIVS - Missing civs: " .. tostring(numFailedCivs));
            end
        end
    end
end

function AssignStartingPlots:__GL_DetectMod_FCS()
    -- Check for and support the Free City States mod.
    -- Also detects Free City States Revived.
    if TiramodCreateCityStatePool then
        print("Free City States (Revived) detected. Creating city state pool.");
        TiramodCreateCityStatePool(self);
    end
end

function AssignStartingPlots:__GL_TTS_InitStartingData()
    -- Override for compatibility with Teams Together Strong.
    -- Allows TTS to major civs and GL to place minor and water civs.    
    
    -- Get TTS option for min distance between non-teammates
    -- and use that as the safe distance between two major civs.
    ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS = 
        MapConfiguration.GetValue("StartDistanceNonTeamPlayersMax") or 
        MapConfiguration.GetValue("StartDistanceMajorCivs") or 
        (GlobalParameters.START_DISTANCE_MAJOR_CIVILIZATION + 3) or 15;
    print("Safe Distance Between Two Major Non-Teammates: ", 
          ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS);
    
    
    local numMajorCivsTotal = PlayerManager.GetAliveMajorsCount();
    local totalCivsList     = PlayerManager.GetAliveMajorIDs();
    
    -- Begin TTS starts for major
    -- The TTS mod has its own start bias improvements plus support for colocated teams.
    self.majorStartTeamsPlots = {};
    self.majorStartNonTeamsPlots = {};
    self.possibleMajorPlots = {};
    
    majPlayers = {};
    for i = self.iNumMajorCivs - 1, 0, - 1  do
        table.insert(majPlayers, i);
    end
    
    -- Sort Players placing teams first and prioritising Teams
    -- with higher and more Start Bias Tiers
    sortedMajPlayers = self:__SortPlayersByTeamAndStartBiases(majPlayers);
    
    majorCivPlots = GetCustomStartingPlots();
    
    self:__SetStartMajor(majorCivPlots);
    print("Got " .. tostring(#self.possibleMajorPlots) .. " possible major plot(s) for TTS");
    self:__InitStartBiasMajor(false);
    
    -- Adapt TTS' player starts into a map of players by ID.
    self.playerStarts = {};
    for i = 1, self.iNumMajorCivs do
        self.playerStarts[i] = self.playerStartsMajor[i];
    end
    
    -- Apply TTS player starts to distance maps for minor starts and water starts.
    local distanceMaps = DetermineNonGLDistanceMaps(self.playerStarts);
    
    self:__GL_PlaceMajorLandCivs();
    

    -- Run GL start positioner on minor starts.
    local minorStartPlots = {};
    minorStartPlots, distanceMaps = DetermineCustomMinorStarts(
        self.iNumMinorCivs,
        self.uiStartMinY, 
        100 - self.uiStartMaxY, -- Base Game's "start max y" is actually a delta.
        distanceMaps);
    
    -- Export results from the custom start positioner.
    for i = 1, self.iNumMinorCivs do
        local startData = minorStartPlots[i];
        local plot = Map.GetPlot(startData.x, startData.y);
        table.insert(self.minorStartPlots, plot);
        table.insert(self.minorCopy, plot);
    end

    self:__GL_PlaceMinorCivs(minorStartPlots);
    
    
    -- Run GL start positioner on water starts.
    local waterStartPlots = {};
    waterStartPlots = DetermineCustomWaterStarts(
        self.iNumWaterMajorCivs,
        self.uiStartMinY, 
        100 - self.uiStartMaxY, -- Base Game's "start max y" is actually a delta.
        distanceMaps);
    self:__GL_PlaceWaterCivs(waterStartPlots);
    
    self:__GL_DetectMod_FCS();
end

function AssignStartingPlots:__InitStartingData()
    -- Override for improved stability.
    
    -- Additional ASP helper methods to reduce clutter in __InitStartingData().
    self.__GL_SetDefaultNumCivs  = AssignStartingPlots.__GL_SetDefaultNumCivs;
    self.__GL_DetectWaterCivs    = AssignStartingPlots.__GL_DetectWaterCivs;
    self.__GL_PlaceMajorLandCivs = AssignStartingPlots.__GL_PlaceMajorLandCivs;
    self.__GL_PlaceMinorCivs     = AssignStartingPlots.__GL_PlaceMinorCivs;
    self.__GL_PlaceWaterCivs     = AssignStartingPlots.__GL_PlaceWaterCivs;
    self.__GL_DetectMod_FCS      = AssignStartingPlots.__GL_DetectMod_FCS;

    if(self.uiMinMajorCivFertility <= 0) then
        self.uiMinMajorCivFertility = 5;
    end

    if(self.uiMinMinorCivFertility <= 0) then
        self.uiMinMinorCivFertility = 5;
    end

    -- Find Default Number of players.
    -- Used for luxury spacing and major/minor civ-start buffers.
    self:__GL_SetDefaultNumCivs();
    
    local numMajorCivsTotal = PlayerManager.GetAliveMajorsCount();
    local totalCivsList     = PlayerManager.GetAliveMajorIDs();
    self.iNumMajorCivs      = 0; -- Number of civs that start on land.
    self.iNumMinorCivs      = PlayerManager.GetAliveMinorsCount();
    self.iNumWaterMajorCivs = 0;
    self.majorList          = {}; -- Civs that start on land.
      self.minorList          = PlayerManager.GetAliveMinorIDs();
    self.waterMajorList     = {};

    
    -- See if there are any civs starting out in the water.
    self:__GL_DetectWaterCivs(numMajorCivsTotal, totalCivsList);
    
    self.majorStartPlots = {};
    self.minorStartPlots = {};
    
    if (AssignStartingPlots.__InitStartBiasMajor and
        AssignStartingPlots.__PlayerHasTeam and 
        AssignStartingPlots.__SortPlayersByTeamAndStartBiases) then
        print("Teams Together Strong (TTS) detected. Switching to GL+TTS override.");
        self.__GL_TTS_InitStartingData = AssignStartingPlots.__GL_TTS_InitStartingData;
        self:__GL_TTS_InitStartingData();
        return;
    end
    
    local startPlots = {};
    local waterStartPlots = {};
    local minorStartPlots = {};
    local distanceMaps = {};

    -- Run custom start positioner for all starts.
    startPlots, waterStartPlots, minorStartPlots = DetermineCustomStarts(
        numMajorCivsTotal,
        self.iNumWaterMajorCivs, 
        self.iNumMinorCivs,
        self.uiStartMinY, 
        100 - self.uiStartMaxY); -- Base Game's "start max y" is actually a delta.
    
    if ((#startPlots + #waterStartPlots) < numMajorCivsTotal) then
        print("ERROR: failed to determine major-civ start positions!");
        return; -- Just bail out.

    elseif (#minorStartPlots < self.iNumMinorCivs) then
        print("ERROR: failed to determine minor-civ start positions!");
        return; -- Just bail out.
    end

    -- Export results from our custom start positioner to Civ 6 ASP Land civs.
    for i = 1, self.iNumMajorCivs do
        local startData = startPlots[i];
        local plot = Map.GetPlot(startData.x, startData.y);
        table.insert(self.majorStartPlots, plot);
        table.insert(self.majorCopy, plot);
    end
    
    self:__GL_PlaceWaterCivs(waterStartPlots, startPlots);
    
    --Begin Start Bias for major
    if ASP_ENABLE_GL_START_BIAS then
        -- Initialize with pre-computed custom start bias.
        -- Transform a start list that includes backup spots for water civs (startPlots)
        -- into a map that is 1:1 with the list of land-civ player IDs (self.playerStarts).
        self.playerStarts = {};
        for i, playerIndex in ipairs(self.majorList) do
            for j, startData in ipairs(startPlots) do
                if (startData.playerId == playerIndex) then
                    local plot = Map.GetPlot(startData.x, startData.y);
                    local playerStart = {};
                    playerStart[1] = plot;
                    self.playerStarts[i] = playerStart;
                end
            end
        end
    else
        self:__InitStartBias(false);
    end
    self:__GL_PlaceMajorLandCivs();
    
    
    -- Export results from the custom start positioner.
    for i = 1, self.iNumMinorCivs do
        local startData = minorStartPlots[i];
        local plot = Map.GetPlot(startData.x, startData.y);
        table.insert(self.minorStartPlots, plot);
        table.insert(self.minorCopy, plot);
    end
    self:__GL_PlaceMinorCivs(minorStartPlots);
    
    self:__GL_DetectMod_FCS();
end

function AssignStartingPlots:__GetValidAdjacent(plot, minor)
    -- Override to be more permissive w.r.t. challenging terrain.
    -- Also fixes top/bottom boundary checking.
    local minH = 0;
    local maxH = g_iH-1;
    if (minor == 0) then
        minH = math.min(minH,        math.ceil(g_iH * self.uiStartMinY / 100));
        maxH = math.max(maxH, g_iH - math.ceil(g_iH * self.uiStartMaxY / 100));
    end

    if ((plot:GetY() <= minH) or (plot:GetY() >= maxH)) then
        return false;
    end
    
    if ((not ScriptData.wrapX) and ((plot:GetX() == 0) or (plot:GetX() == g_iW-1))) then
        -- Also avoid east-west edges.
        return false;
    end

    -- Allow some barren tiles next to the start, because a suboptimal start is
    -- better than no start at all, especially on a map with challenging terrain.
    return true;
end
------------------------------------------------------------------------------
function DetermineStartingPlots()
    print("Assigning starting plots (" .. 
        ScriptData.landInfo.name .. " + " .. 
        ScriptData.climateInfo.name .. ").");
    
    if ASP_ENABLE_NONSTD_STARTS_WITH_FALLBACKS then
        print("Allowing fallback plots for non-standard starts.");
    end
    if ASP_ENABLE_FRESH_LAKE_WATER_STARTS then
        print("Allowing water starts in fresh lakes.");
    end
    print("Minimum distance between major civs: ", ASP_MIN_DISTANCE_BETWEEN_MAJOR_CIVS);
    print("Minimum distance between minor civs: ", ASP_MIN_DISTANCE_BETWEEN_MINOR_CIVS);
    print("Safe distance between two major civs: ", ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS);
    if ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS < ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS then
        ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS = ASP_SAFE_DISTANCE_BETWEEN_TWO_MAJOR_CIVS;
    end
    print("Ideal distance between two major civs: ", ASP_IDEAL_DISTANCE_BETWEEN_TWO_MAJOR_CIVS);
    print("Minimum ratio of start area to largest landmass: " ..
        ASP_STARTAREA_MIN_REACHABLE_LAND_RATIO);
    if ASP_ENABLE_GL_START_BIAS then
        print("Using the Got Lakes start bias algorithm.");
    else
        print("Using the base game's limited handling of start bias. ");
    end    
    
    -- Use both land and climate info to calculate fertility thresholds.
    local majorCivFert = math.max(1,Round(
        ScriptData.landInfo.aspMinMajorFert * 
        ScriptData.climateInfo.aspMinFertMult));
        
    local minorCivFert = math.max(1,Round( 
        ScriptData.landInfo.aspMinMinorFert * 
        ScriptData.climateInfo.aspMinFertMult));
    
    -- Ignore the bottom START_MIN_Y % and the top START_MAX_Y % 
    -- of the grid height when placing major civs.
    local startMinY = 0;
    local startMaxY = 100;
     
    if ((UserInput.climateWrap == WWRAP_GLOBE) and 
        (UserInput.icyPoles == ICYPOLES_FULL) and
        (ScriptData.numTerrainTypes > 1) and
        (ScriptData.enabledTerrainsMap[g_TERRAIN_TYPE_SNOW])) then
        -- Avoid starts near the uncropped poles
        -- on maps that have snow and at least one other base terrain type.
        print("Avoiding starts near polar regions (globe climate wrap, standard icy poles, " ..
              "at least two base terrains including snow).");
        local climate = UserInput.climate;
        startMinY = ScriptData.sunlightInfo.aspStartMinY[climate];
        startMaxY = ScriptData.sunlightInfo.aspStartMaxY[climate];
    end
    
    if (UserInput.connectLand and 
        (not UserInput.isoCoasts) and
        (ScriptData.landInfo.aspLandDivMethod == DIVMETHOD_SEPARATE)) then
        -- Connected Lands without Isolated Coasts on a landmass that defaults to separate areas.
        -- Set landmass-based division method to Standard
        -- since lands are now connected by snaky land bridges.
        print("Adjusting landmass-based major starts (Connected Lands without Isolated Coasts).");
        ScriptData.landInfo.aspLandDivMethod = DIVMETHOD_STANDARD;
    end
    
    if UserInput.freshLakes then
        -- Fresh lakes landmass.
        -- Set water-based division method to standard
        -- since all water is in fresh lakes (i.e., don't bother with regions).
        print("Adjusting landmass-based water starts (Turn Seas Into Lakes enabled).");
        ScriptData.landInfo.aspWaterDivMethod = DIVMETHOD_STANDARD;
    end
    
    -- Create the AssignStartingPlots database.
    -- Even though we might override an init method, use the 
    -- inherited constructor in case there are other 
    -- ASP-overriding mods.
    local args = 
    {
        MIN_MAJOR_CIV_FERTILITY = majorCivFert,
        MIN_MINOR_CIV_FERTILITY = minorCivFert,
        MIN_BARBARIAN_FERTILITY = 1,
        START_MIN_Y             = startMinY,
        START_MAX_Y             = 100 - startMaxY, -- Base game treats this as a delta.
        LAND                    = ScriptData.landInfo.aspLandMap,
        WATER                   = ScriptData.landInfo.aspWaterMap,
        START_CONFIG            = UserInput.start,
        STARTALLONLAND          = UserInput.waterStarts == WaterStarts.ONLAND
    };
    local asp = AssignStartingPlots.Create(args);
end
------------------------------------------------------------------------------
-- Map Configuration
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Climate configs
------------------------------------------------------------------------------
ClimateInfo = 
{
    default = 
    {
        name = "standard climate",
        
        biodiv = Biodivs.STANDARD,
        
        -- Fixed latitude for standard-sunlight regions.
        -- Indices are {ICYPOLES_CROP, ICYPOLES_FULL}
        regionLat = {0.2, 0.3},
        
        -- Min regional lat < 0 to add thickness to hot pole.
        -- lower when uncropped to compensate for extended dark side.
        -- Indices are {ICYPOLES_CROP, ICYPOLES_FULL}
        tiltedLatMin = {0, -0.05}, 
        
        -- Max regional lat: increase this to make dark side thicker.
        -- For uncropped, allow plenty of room for dark-side interpolation.
        -- Indices are {ICYPOLES_CROP, ICYPOLES_FULL}
        tiltedLatMax = {0.7, 1.0},
        
        -- Ice generator for standard sunlight
        -- Indices are climate wraps.
        AddIceAtPlot = 
        {
            GotLakes_FeatureGenerator.Azimuthal_AddIceAtPlot,
            GotLakes_FeatureGenerator.Globe_AddIceAtPlot, 
            GotLakes_FeatureGenerator.Region_AddIceAtPlot
        },
        
        -- Resource generation
        -- Cold climates can override this flag to allow resources next to ice.
        resourcesAvoidIce = true,
        
        -- Start plot database
        -- Major/Minor civ fertility multiplier.
        -- Reduce for less-fertile maps.
        aspMinFertMult = 1.0,
    },
    
    snowball = 
    {
        name = "snowball",
        
        biodiv = Biodivs.VERYHIGH,
    
        -- Vary region lat based on icy-poles
        -- to distinguish "ice age cropped" from "ice age full".
        regionLat = {0.23, 0.38},
        
        tiltedLatMin = {0.0, 0.25}, 
        tiltedLatMax = {0.5, 0.75},
        
        AddIceAtPlot = 
        {
            GotLakes_FeatureGenerator.IceAgeAzimuthal_AddIceAtPlot,
            GotLakes_FeatureGenerator.IceAgeGlobe_AddIceAtPlot, 
            GotLakes_FeatureGenerator.IceAgeRegion_AddIceAtPlot
        },
        
        resourcesAvoidIce = false,
        
        aspMinFertMult = 0.01,
    },
    
    iceAge = 
    {
        name = "ice age",
    
        biodiv = Biodivs.HIGH,
    
        -- Vary region lat based on icy-poles
        -- to distinguish "ice age cropped" from "ice age full".
        regionLat = {0.27, 0.4},
        
        tiltedLatMin = {-0.05, -0.1}, 
        tiltedLatMax = {0.55,  1.0},
        
        AddIceAtPlot = 
        {
            GotLakes_FeatureGenerator.IceAgeAzimuthal_AddIceAtPlot,
            GotLakes_FeatureGenerator.IceAgeGlobe_AddIceAtPlot, 
            GotLakes_FeatureGenerator.IceAgeRegion_AddIceAtPlot
        },
        
        resourcesAvoidIce = false,
        
        aspMinFertMult = 0.5,
    },
    
    greenhouse = 
    {
        name = "greenhouse",
    
        biodiv = Biodivs.HIGH,
    
        -- Shift region lat towards poles to allow adjustment of desert/jungle
        regionLat = {0.3, 0.35},
        
        tiltedLatMin = {0,   0}, 
        tiltedLatMax = {0.7, 0.9},
        
        aspMinFertMult = 0.8,
    },
    
    sandstorm = 
    {
        name = "sandstorm",
        
        biodiv = Biodivs.VERYHIGH,
            
        -- Shift region lat towards poles to allow adjustment of desert/jungle
        regionLat = {0.45, 0.55},
        
        tiltedLatMin = {0,   0}, 
        tiltedLatMax = {0.9, 1.0},
        
        aspMinFertMult = 0.6,
    },
};
------------------------------------------------------------------------------
-- Biome configs
------------------------------------------------------------------------------
BiomeInfo = 
{
    default = 
    {
        name = "standard biome",
        
        -- Percentage of fertile terrain that is plains (all else is grassland).
        plainsPct = 50,
        
        -- Offset percentage of land that is desert
        -- to make room for biome-specific terrain.
        desertPctOffset = 0,
        
        -- Max jungle as a percentage of applicable tiles.
        junglePct = 40,
        
        -- How much to offset jungle based on rainfall.
        junglePctShift = 7,
        
        -- How much to decrease min lat and increase max lat for jungles.
        jungleMaxLatDiff = 0.0,
        
        -- Percentage of flat desert land that is oases.
        oasisPct = 20,
        
        -- How much to offset oases based on river level
        -- as a counter-balance to higher river level reducing oases.
        oasisChange = 10,
        
        -- Percentage of land that is forests.
        forestPct = 40,
        
        -- How much to offset forests based on rainfall.
        forestChange = 7,
        
        -- How much to decrease min lats and increase max lat for forests.
        forestCMaxLatDiff = 0.0,
        
        -- Percentage of land that is marsh
        marshPct = 20,
        
        -- How much to offset marsh based on rainfall.
        marshChange = 5,
    },
    
    arborea = 
    {
        name = "arborea",
        
        -- Make room for terrain that supports forests.
        desertPctOffset = -30,
        
        -- Increase all kinds of trees.
        junglePct = 85,
        forestPct = 80,
        
        -- Expand tree latitudes.
        jungleMaxLatDiff  = 0.1,
        forestCMaxLatDiff = 0.2,
    },
    
    prairie = 
    {
        name = "prairie",
        
        plainsPct = 60,
        
        -- Less desert, more grass/plains.
        desertPctOffset = -20,
        
        -- Fewer trees for more open terrain.
        junglePct = 15,
        forestPct = 15,
        
        -- Less marsh, more featureless terrain.
        marshPct = 10,
        marshChange  = 3,
    },
    
    wetland = 
    {
        name = "wetland",
        
        plainsPct = 40,
        
        -- Slightly less desert, since some desert will become oases.
        desertPctOffset = -10,
        
        -- Slightly increase trees in case the map doesn't have marsh.
        junglePct = 60,
        forestPct = 60,
        
        -- Make deserts wetter with more oases.
        oasisPct = 60,
        oasisChange  = 20,
        
        -- Greatly increase marsh.
        marshPct = 60,
        marshChange  = 15,
    }
};
------------------------------------------------------------------------------
-- Sunlight configs
------------------------------------------------------------------------------
SunlightInfo = 
{
    default = 
    {
        name = "standard sunlight",
        
        -- Latitude multiplier for cropped globes.
        -- Indices are Climates {SNOWBALL, ICEAGE, STANDARD, GREENHOUSE, SANDSTORM}
        latMult = {0.5, 2/3, 0.9, 0.9, 0.9},
    
        -- Latitude lookup
        -- Indices are climate wraps.
        GetLatitudeAtPlot = 
        {
            DefaultAzimuthal_GetLatitudeAtPlot,
            DefaultGlobe_GetLatitudeAtPlot, 
            DefaultRegion_GetLatitudeAtPlot
        },
        
        -- Latitude ranges
        -- Indices are Climates {SNOWBALL, ICEAGE, STANDARD, GREENHOUSE, SANDSTORM}
        -- Latitude below which all land is desert.
        desertMinLat = {-0.25, -0.14, 0.1, 0.2, 0.5},
        
        -- Latitude above which no land is desert.
        desertMaxLat = {-0.2, -0.67, 0.45, 0.5, 0.8},
        
        -- Latitude below which no land is tundra.
        tundraMinLat = {-0.15, 0.1, 0.55, 0.8, 1.3},
        
        -- Latitude above which all non-river land is either tundra or snow.
        tundraNonRiverMaxLat = {0.0, 0.42, 0.75, 0.9, 1.4},
        
        -- Latitude above which all land is either tundra or snow.
        -- This used to be (tundraNonRiverMax + snowMax)/2
        tundraMaxLat = {0.0, 0.55, 0.825, 1.0, 1.5},
        
        -- Latitude below which no land is snow.
        snowMinLat = {0.0, 0.22, 0.75, 1.1, 1.6},
        
        -- Latitude above which all land is snow.
        snowMaxLat = {0.5, 0.67, 0.9, 1.5, 2.0},
        
        -- Latitude below which all land is jungle.
        jungleMinLat = {-2.0, -0.14, 0.2, 0.35, 0.5},
        
        -- Latitude above which no land is jungle.
        jungleMaxLat = {-1.0, -0.07, 0.4, 0.6, 0.9},
        
        -- Latitude above which no water is non-wonder reef.
        -- base game is 0.7
        reefMaxLat = {-1.0, -0.07, 0.54, 0.6, 0.8},
        
        -- Latitude below which no land is forest.
        -- By default, start forests at negative lat to increase jungle/forest overlap
        forestHMinLat = {-2.0, -0.07, -0.1, 0.3, 0.4},
        
        -- Max latitude for forests fading towards the equator.
        forestHMaxLat = {-1.0, 0.33, 0.3, 0.45, 0.7},
        
        -- Min latitude for forests fading towards icy poles.
        forestCMinLat = {0.0, 0.53, 0.6, 0.7, 0.8},
        
        -- Max latitude for forests fading towards icy poles.
        forestCMaxLat = {0.9, 0.9, 0.9, 1.0, 1.2},
        
        -- Latitude below which land has a maximum chance of becoming marsh
        marshMinLat = {-1.05, 0.28, 0.25, 0.4, 0.65},
        
        -- Latitude above which no land is marsh
        marshMaxLat = {0.2, 0.73, 0.8, 0.9, 1.0},        
        
        -- Min latitude for ice interpolation
        iceMinLat = {-0.5, 0.18, 0.6, 0.8, 1.5},
        
        -- Max latitude for ice interpolation
        iceMaxLat = {1.0, 1.0, 1.0, 1.5, 2.0},
        
        -- Terrain generation
        -- Base percentage of extreme-hot region that is desert.
        desertBasePct = {0, 50, 50, 50, 75},
        
        -- Hook for initializing sunlight-specific azimuthal latitude ranges.
        TInitAzimuthal = GotLakes_TerrainGenerator.Default_InitAzimuthal,
        
        -- Hook for initializing sunlight-specific regional latitude ranges.
        TInitRegion = GotLakes_TerrainGenerator.Default_InitRegion,
        
        -- Whether to allow climate-biome combos to adjust the base desert percentage.
        enableDesertPctShift = true,
        
        -- Percentage of the cold pole that is snow, if applicable.
        coldPolePct = {100, 100, 100, 100, 100},
        
        -- Iterpolation function for desert / hot-pole fractal.
        -- Default to sqrt so that desert terrain has a subtle creep from from the equator.
        desertInterpFcn = math.sqrt,
        
        -- Interpolation function for transition from fertile to tundra
        -- Default to square so that frozen terrain has a subtle creep from the N/S map edges.
        tundraInterpFcn = Square,
        
        -- Iterpolation function for transition from tundra to snow
        -- Default to square so that frozen terrain has a subtle creep from the N/S map edges.
        snowInterpFcn = Square,
        
        -- How much to adjust various terrain lat thresholds
        -- in order to increase/decrease tundra based on tundra level.
        -- Reduce for standard-sunlight ice age to avoid 0% tundra and 100% tundra
        tundraLatShift = {0.1, 0.05, 0.1, 0.1, 0.1},
        
        -- Feature Generation
        -- Ice generator
        -- Indices are climate wraps.
        -- Use the globe function as a place-holder to use climate function as a fallback.
        AddIceAtPlot = {},
        
        -- Max ice as a fractal percentile.
        -- Indices are Climates {SNOWBALL, ICEAGE, STANDARD, GREENHOUSE, SANDSTORM}
        icePct = {80, 25, 25, 25, 25},
        
        -- Max kelp forest as a fractal percentile.
        -- Calibrated to match Suk's Oceans coverage of ~27% of eligible plots on Continents.
        -- Indices are Climates {SNOWBALL, ICEAGE, STANDARD, GREENHOUSE, SANDSTORM}
        kelpPct = {52, 52, 52, 16, 8},
        
        -- Start plot database
        -- Min/Max start latitude as percent of height
        -- Indices are climates {SNOWBALL, ICEAGE, STANDARD, GREENHOUSE, SANDSTORM}
        aspStartMinY = {33, 25,  5,  5,  5},
        aspStartMaxY = {67, 75, 95, 95, 95},
    },
    
    tilted = 
    {
        name = "tilted axis",
        
        -- Extend the uncropped tilted scale to 2 to freeze the northern hemisphere
        -- and to allow for snow/ice interpolation.
        latMult = {0.33, 0.5, 0.67, 0.75, 0.9},
        
        GetLatitudeAtPlot = 
        {
            TiltedAxisAzimuthal_GetLatitudeAtPlot,
            TiltedAxisGlobe_GetLatitudeAtPlot, 
            TiltedAxisRegion_GetLatitudeAtPlot
        },
        
        TInitAzimuthal = GotLakes_TerrainGenerator.TiltedAxis_InitAzimuthal,
        TInitRegion    = GotLakes_TerrainGenerator.TiltedAxis_InitRegion,
                
        desertMinLat         = {-2.0, 0.0,  0.0,  0.1,  0.2},
        desertMaxLat         = {-1.5, 0.25, 0.33, 0.5,  0.75},
        tundraMinLat         = {0.1,  0.28, 0.45, 0.8,  1.5},
        tundraNonRiverMaxLat = {0.2,  0.4,  0.67, 0.9,  1.6},
        tundraMaxLat         = {0.25, 0.45, 0.78, 1.0,  1.7},
        snowMinLat           = {0.2,  0.4,  0.67, 1.6,  1.6},
        snowMaxLat           = {0.8,  0.9,  0.95, 2.0,  2.0},
        jungleMinLat         = {-2.0, 0.1,  0.15, 0.3,  0.5},
        jungleMaxLat         = {-1.0, 0.25, 0.3,  0.6,  0.9},
        forestHMinLat        = {0,    0,    0.1,  0.25, 0.5},
        forestHMaxLat        = {0.23, 0.23, 0.4,  0.5,  0.65},
        forestCMinLat        = {0.4,  0.4,  0.6,  0.65, 0.75},
        forestCMaxLat        = {0.9,  0.9,  1.0,  1.0,  1.1},
        marshMinLat          = {0.18, 0.18, 0.35, 0.45, 0.6},
        marshMaxLat          = {0.6,  0.6,  0.8,  0.85, 0.95},
        iceMinLat            = {-0.5, 0.28, 0.65, 0.8,  1.5},
        iceMaxLat            = {1.0,  1.0,  1.0,  2.0,  2.0},
        
        
        desertBasePct = {0, 85, 85, 85, 85},
        
        enableDesertPctShift = false,
        
        coldPolePct = {100, 75, 75, 75, 75},
        
        -- Square makes the desert transition suddenly,
        -- making the tilted axis latitude bands more obvious.
        desertInterpFcn = Square,
        
        -- sqrt makes the snow appear suddenly,
        -- with tundra gradually fading into snow.
        snowInterpFcn = math.sqrt,
        
        tundraLatShift = {0.1, 0.1, 0.1, 0.1, 0.1},
        
        AddIceAtPlot = 
        {
            GotLakes_FeatureGenerator.TiltedAxisRegion_AddIceAtPlot,
            GotLakes_FeatureGenerator.TiltedAxisGlobe_AddIceAtPlot, 
            GotLakes_FeatureGenerator.TiltedAxisRegion_AddIceAtPlot
        },
        
        icePct  = {95, 50, 50, 50, 50},
        kelpPct = {52, 52, 52, 16, 8},
        
        -- Avoid the barren wasteland.
        aspStartMinY = { 5,  5, 20, 40, 50},
        aspStartMaxY = {40, 50, 65, 90, 95},
    },
    
    twoSuns = 
    {
        name = "two suns",
        
        latMult = {0.5, 2/3, 0.85, 0.9, 0.9},
        
        GetLatitudeAtPlot = 
        {
            TwoSunsAzimuthal_GetLatitudeAtPlot,
            TwoSunsGlobe_GetLatitudeAtPlot, 
            TwoSunsRegion_GetLatitudeAtPlot
        },
        
        TInitRegion = GotLakes_TerrainGenerator.TwoSuns_InitRegion,
                
        desertMinLat         = {-2.0, 0,    0,    0.1,  0.2},
        desertMaxLat         = {-1.5, 0.2,  0.4,  0.5,  0.8},
        tundraMinLat         = {0.1,  0.38, 0.6,  0.9,  1.5},
        tundraNonRiverMaxLat = {0.25, 0.6,  1.2,  1.5,  1.6},
        tundraMaxLat         = {0.3,  0.8,  1.3,  1.6,  1.7},
        snowMinLat           = {0.25, 0.67, 0.85, 1.6,  1.6},
        snowMaxLat           = {0.95, 1.0,  1.6,  2.0,  2.0},
        jungleMinLat         = {-2.0, 0,    0.2,  0.3,  0.5},
        jungleMaxLat         = {-1.0, 0.2,  0.45, 0.6,  0.9},    
        forestHMinLat        = {0,    0,    0.2,  0.25, 0.5},
        forestHMaxLat        = {0.23, 0.4,  0.45, 0.5,  0.65},
        forestCMinLat        = {0.4,  0.5,  0.8,  0.8,  0.9},
        forestCMaxLat        = {1.0,  1.1,  1.1,  1.1,  1.2},
        marshMinLat          = {0.18, 0.35, 0.4,  0.45, 0.6},
        marshMaxLat          = {0.6,  0.7,  1.0,  1.0,  1.1},
        iceMinLat            = {-0.5, 0.45, 0.65, 0.8,  1.5},
        iceMaxLat            = {0.8,  1.0,  1.2,  2.0,  2.0},
        
        desertBasePct = {0, 90, 90, 90, 90},
        
        enableDesertPctShift = false,
        
        coldPolePct = {100, 90, 90, 90, 90},
        
        -- Square works better for polar bands,
        -- and in this case the poles are hot desert.
        desertInterpFcn = Square,
        
        -- sqrt works better for equatorial bands,
        -- and in this case the equator is tundra and snow.
        tundraInterpFcn = math.sqrt,
        snowInterpFcn   = math.sqrt,
        
        tundraLatShift = {0.1, 0.1, 0.1, 0.1, 0.1},
        
        AddIceAtPlot = 
        {
            GotLakes_FeatureGenerator.TwoSuns_AddIceAtPlot,
            GotLakes_FeatureGenerator.TwoSuns_AddIceAtPlot, 
            GotLakes_FeatureGenerator.TwoSuns_AddIceAtPlot
        },
        
        icePct  = {95, 25, 25, 25, 0},
        kelpPct = {52, 52, 52, 16, 8},
        
        -- Avoid hot desert at the poles.
        aspStartMinY = { 5,  5,  5,  5,  5},
        aspStartMaxY = {95, 95, 95, 95, 95},
    },
}
------------------------------------------------------------------------------
-- Landmass configs
------------------------------------------------------------------------------
LandInfo = 
{
    default = 
    {
        name        = "unknown land",
        id          = 0,
                
        -- Method to create a fractal world for plot generation.
        -- By default, use FractalWorld.Create().
        CreateFWorld = FractalWorld.Create,
        GenPlotTypes = GotLakes_Fractal.Fractal_GeneratePlotTypes,
        
        -- Args for plot type generation
        fractalInitArgs = {},
        fractalGenArgs  = {},
        extraArgs       = {},
        
        -- Clusters grain
        clusters_grain = 1,
        
        -- Lake grain and sea levels {low, normal, high}
        lake_grain = 3,
        sea_levels = {64,68,72,76,80},
        
        -- Whether to add layers of islands to a large lakes map.
        -- Differentiates large Lakes from Seven Seas.
        gotLakeIslandLayers = false,
        
        -- How to add circumnavigation channels for landmass-based circumnavigation.
        -- Default to N/S edges to minimize land impact on ocean-heavy maps.
        circumnav = Circumnavigation.EDGES,
        
        -- Feature Generation
        -- How many rows of ice to add to the top and bottom of a global map.
        polarIceNumRows = 1,
        
        -- Resource Generation
        -- Base game knob: use higher values for island map.
        -- No need to tweak for land-heavy maps, 
        -- since that removes luxuries and strategics from the water.
        resourceWaterLux   = 3,
        
        -- Starting Plot Database
        aspLandMap  = false, -- true for land-heavy maps
        aspWaterMap = false, -- true for water-heavy maps
        
        -- Major/Minor civ fertility thresholds; 
        -- directly proportional to land/water ratio, 
        -- so raise values for land-heavy maps.
        aspMinMajorFert = 150,
        aspMinMinorFert = 50, 
        
        -- Regional division method for civ starts.
        aspLandDivMethod  = DIVMETHOD_STANDARD,
        aspWaterDivMethod = DIVMETHOD_STANDARD,
    },
    
    archipelago = 
    {
        name        = "Archipelago",
        id          = Landmasses.ARCHIPELAGO,
        
        fractalInitArgs = {continent_grain = 4},
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass, 
            tectonicGrain   = 4,
        },
        
        resourceWaterLux = 4,
        aspWaterMap      = true,
        aspMinMajorFert  = 75,
        aspMinMinorFert  = 5, 
    },
    
    bagels = 
    {
        name         = "Bagels",
        id           = Landmasses.BAGELS,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Bagels_GeneratePlotsByRegion,    
    },
    
    clusters = 
    {
        name        = "Clusters",
        id          = Landmasses.CLUSTERS,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Clusters_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass,         
        },
        
        clusters_grain = 2,
        sea_levels     = {62,67,73,78,82},
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 75,
        aspMinMinorFert = 5,
        
        aspLandDivMethod  = DIVMETHOD_SEPARATE,
    },
    
    continents = 
    {
        name         = "Continents",
        id           = Landmasses.CONTINENTS,
        
        GenPlotTypes = GotLakes_Fractal.Continents_GeneratePlotTypes,
    },
    
    donut = 
    {
        name        = "Donut",
        id          = Landmasses.DONUT,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Donut_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            tectonicFlags  = {FRAC_POLAR = true}, -- keep tectonic islands away from map edges.
            tectonicGrain  = 3,
        }, 
                
        aspWaterMap       = true,            
    },
    
    fractal = 
    {
        name        = "Fractal",
        id          = Landmasses.FRACTAL,
        
        fractalInitArgs = 
        {
            rift_grain      = -1, 
            has_center_rift = false, 
            polar           = true,
        },
        
        fractalGenArgs = {has_center_rift = false},
        
        -- keep tectonic islands away from map edges
        extraArgs = {tectonicFlags = {FRAC_POLAR = true}},
        
        aspMinMajorFert = 175,
        aspMinMinorFert = 50,
    },
    
    hex = 
    {
        name        = "Hex",
        id          = Landmasses.HEX,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Hex_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            tectonicFlags  = {FRAC_POLAR = true}, -- keep tectonic islands away from map edges.
            tectonicGrain  = 3,
        }, 
                
        aspWaterMap       = true,            
    },    
    
    inlandSea = 
    {
        name        = "Inland Sea",
        id          = Landmasses.INLANDSEA,
        
        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.InlandSea_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extras freshen lakes
            MergeToMainland   = MergeExtrasPreserveSaltLakes, 
            tectonicFlags        = {FRAC_POLAR = true}, -- keep tectonic islands close to the lake
            tectonicGrain     = 4,
        },
        
        -- For this landmass, sea level affects lake grains and lake threshold.
        -- Higher grain size meams smaller lakes
        -- Higher threshold means less water overall.
        lake_grain = 1,
        sea_levels = {88,80,72,64,56},
        
        -- Use random paths to circumnavigate land-heavy maps.
        circumnav = Circumnavigation.PATHS,
        
        polarIceNumRows = 0,
        
        -- Base games lowers resource waterLux and waterBonus,
        -- but that seems to remove all luxuries and strat resources from the water.
        
        aspLandMap      = true,
        aspMinMajorFert = 200,
        aspMinMinorFert = 50, 
        
        aspWaterDivMethod = DIVMETHOD_BIGGEST,
    },
    
    invertedDonut = 
    {
        name        = "Inverted Donut",
        id          = Landmasses.INVDONUT,
        
        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.InvertedDonut_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Make extras form water instead of land.
            invertExtras          = true, 
            tectonicGrain         = 4,
            tectonicSeaMultiplier = -1,
        },
        
        -- Disable circumnavigation to avoid cutting through the donut.
        circumnav = Circumnavigation.NONE,
                
        polarIceNumRows = 0,
        
        aspLandMap      = true,
        aspMinMajorFert = 200,
        aspMinMinorFert = 50,     
    },    
    
    invertedExtras = 
    {
        name        = "Inverted Extras",
        id          = Landmasses.INVEXTRAS,
        
        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.InvertedExtras_GeneratePlotsByRegion,
        
        -- Make extras form water instead of land.
        extraArgs = 
        {
            invertExtras          = true,
            tectonicGrain           = 4,
            tectonicLandOffset    = 1,
            tectonicSeaMultiplier = -2,
        },
        
        -- Disable circumnavigation since there might not be any seas to navigate.
        circumnav = Circumnavigation.NONE,
                
        polarIceNumRows = 0,
        
        aspLandMap      = true,
        aspMinMajorFert = 200,
        aspMinMinorFert = 50,     
    },
    
    islandPlates = 
    {
        name        = "Island Plates",
        id          = Landmasses.ISLEPLATES,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.IslandPlates_GeneratePlotsByRegion,        
                    
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass, 
            tectonicGrain   = 3,        
        },
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 85,
        aspMinMinorFert = 5, 
    },
    
    lakes = 
    {
        name        = "Lakes",
        id          = Landmasses.LAKES,

        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.Lakes_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extras freshen lakes
            MergeToMainland = MergeExtrasPreserveSaltLakes, 
            tectonicGrain   = 5,
        },
        
        -- For this landmass, sea level affects lake threshold.
        -- Higher threshold means less water overall.
        -- Note: any lower than 82 results in significant salt-water lakes, which
        -- the plot type function will have to freshen by adding land tiles.
        lake_grain  = 4,
        sea_levels  = {90,84,78,72,66},
        
        -- Disable circumnavigation since there might not be any seas to navigate.
        circumnav = Circumnavigation.NONE,
        
        polarIceNumRows = 0,
        
        aspLandMap        = true,
        aspMinMajorFert   = 300,
        aspMinMinorFert   = 50, 
        aspWaterDivMethod = DIVMETHOD_SEPARATE,
    },
    
    largeIslands = 
    {
        name        = "Large Islands",
        id          = Landmasses.LRGISLES,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.LargeIslands_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass, 
            tectonicGrain = 3,        
        },
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 85,
        aspMinMinorFert = 5, 
        
        aspLandDivMethod  = DIVMETHOD_SEPARATE,
    },
    
    largeLakes = 
    {
        name        = "Large Lakes",
        id          = Landmasses.LRGLAKES,
        
        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.Lakes_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extras freshen lakes
            MergeToMainland   = MergeExtrasPreserveSaltLakes, 
            tectonicGrain     = 5,        
        },
        
        -- For this landmass, sea level affects lake grains and lake threshold.
        -- Higher threshold means less water overall.
        lake_grain  = 3, -- grain of 2 at high sea level looks like inland sea
        sea_levels  = {90,84,76,68,62},
        
        -- Disable circumnavigation since there might not be any seas to navigate.
        circumnav = Circumnavigation.NONE,
        
        polarIceNumRows = 0,
        
        aspLandMap      = true,
        aspMinMajorFert = 300,
        aspMinMinorFert = 50, 
    },
    
    maze = 
    {
        name         = "Maze",
        id           = Landmasses.MAZE,
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Maze_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            tectonicFlags  = {FRAC_POLAR = true}, -- keep tectonic islands away from map edges.
            tectonicGrain  = 1,            
        },
        
        -- Disable circumnavigation to preserve the maze.
        circumnav = Circumnavigation.NONE,
        
        aspWaterMap       = true,
        aspMinMajorFert   = 75,
        aspMinMinorFert   = 5, 
        
        -- This pangea can easily splinter into separate areas, 
        -- so use standard regions for starting plots.
    },
    
    megacluster = 
    {
        name        = "Megacluster",
        id          = Landmasses.MEGACLUSTER,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Clusters_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass,         
        },
        
        sea_levels = {62,67,73,78,82},
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 75,
        aspMinMinorFert = 5,
        
        aspLandDivMethod  = DIVMETHOD_SEPARATE,
    },
    
    miniDonuts = 
    {
        name        = "Mini Donuts",
        id          = Landmasses.MINIDONUTS,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.MiniDonuts_GeneratePlotsByRegion,
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass, 
            tectonicGrain   = 3,
        },
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 85,
        aspMinMinorFert = 5,
    },
    
    none = 
    {
        name        = "None",
        id          = Landmasses.NONE,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.None_GeneratePlotsByRegion,        
        
        -- Enlarge extras to compensate for no landmass.
        extraArgs = 
        {
            tectonicGrain           = 3,
            tectonicLandOffset    = 1.5,
            tectonicSeaMultiplier = 2,
        },
        
        resourceWaterLux   = 4, -- 5 doesn't work
        
        aspWaterMap     = true,
        aspMinMajorFert = 1,
        aspMinMinorFert = 1,     
    },
    
    noodles = 
    {
        name = "Noodles",
        id   = Landmasses.NOODLES,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Noodles_GeneratePlotsByRegion,
        
        sea_levels = {64,68,72,76,80},        
    },    
    
    numConts = 
    {
        name        = "Numerous Continents",
        id          = Landmasses.NUMCONTS,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Numerous_GeneratePlotsByRegion,
        
        -- Compensate for cell padding + empty cells
        sea_levels =    {38,53,68,73,88},
        --              {26,39,56,59,76} after empty-cell adjustment
        
        extraArgs = 
        {
            -- Don't let extra islands merge with landmass islands.
            MergeToMainland = MergeExtrasAvoidLandmass, 
            tectonicGrain   = 5,        
        },
        
        resourceWaterLux = 4,
        
        aspWaterMap     = true,
        aspMinMajorFert = 85,
        aspMinMinorFert = 5,
    }, 
    
    oval = 
    {
        name         = "Oval",
        id           = Landmasses.OVAL,
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Oval_GeneratePlotsByRegion,

        extraArgs    = 
        {
            tectonicFlags = {FRAC_POLAR = true}, -- keep tectonic islands away from map edges.
            tectonicGrain = 2, -- landmass is so big that we need 2-grain to notice islands    
        },
        
        -- Use random paths to give ships more access to the oval.
        circumnav = Circumnavigation.PATHS,
        
        aspMinMajorFert = 200,
        aspMinMinorFert = 50,             
    },
    
    pangea = 
    {
        name         = "Pangea",
        id           = Landmasses.PANGEA,
        GenPlotTypes = GotLakes_Fractal.Pangea_GeneratePlotTypes,
        
        extraArgs = 
        {
            tectonicFlags  = {FRAC_POLAR = true}, -- keep tectonic islands away from map edges.
            tectonicGrain  = 1,            
        },
        
        sea_levels = {56,62,68,74,80},
                
        aspMinMajorFert = 300,
        aspMinMinorFert = 50,         
        aspLandDivMethod  = DIVMETHOD_BIGGEST,
    },
    
    sevenSeas = 
    {
        name        = "Seven Seas",
        id          = Landmasses.SEVENSEAS,
        
        CreateFWorld    = MultilayeredFractal.Create,
        GenPlotTypes    = MultilayeredFractal.Lakes_GeneratePlotsByRegion,
        
        -- Enlarge extras.        
        extraArgs = 
        {
            MergeToMainland       = MergeExtrasPreserveSaltLakes, 
            tectonicGrain         = 4,
            tectonicLandOffset    = 1,
            tectonicSeaMultiplier = 2,
        },
        
        -- For this landmass, sea level affects lake grains and lake threshold.
        -- Higher threshold means less water overall.
        lake_grain = 3,
        sea_levels = {62,56,50,44,38},
        
        -- Add islands similar to island plates.
        gotLakeIslandLayers = true,
        
        -- Use both edges and random paths to circumnavigate lots of inland seas.
        circumnav = Circumnavigation.BOTH,
        
        polarIceNumRows = 0,
        
        aspLandMap      = true,
        aspMinMajorFert = 300,
        aspMinMinorFert = 50,
    },    
    
    smallContinents = 
    {
        name        = "Small Continents",
        id          = Landmasses.SMALLCONTS,

        fractalInitArgs = {continent_grain = 3},
        
        extraArgs = {tectonicGrain = 3},
        
        sea_levels  = {65,70,75,80,85},
                
        aspMinMajorFert = 125,
        aspMinMinorFert = 40, 
    },
    
    snake = 
    {
        name        = "Snake",
        id          = Landmasses.SNAKE,
        
        CreateFWorld = MultilayeredFractal.Create,
        GenPlotTypes = MultilayeredFractal.Snake_GeneratePlotsByRegion,
                    
        aspMinMajorFert = 75,
        aspMinMinorFert = 5,
        
        -- This pangea can splinter into separate areas, 
        -- so use standard regions for starting plots.
    },
};
------------------------------------------------------------------------------
-- Map Option configs
------------------------------------------------------------------------------
OptionInfo =
{
    -- Base game options
    {
        Name         = "Resources",
        Values       = {"Sparse", "Standard", "Abundant", "Random"},
        DefaultValue = MapDefaults.RESOURCES,
    },
    {
        Name         = "Start Position",
        Values       = {"Balanced", "Standard", "Legendary"},
        DefaultValue = MapDefaults.START,
    },
    
    -- Landmass families
    GetLandmassFamilyOption("Continents", MapDefaults.CONTINENTS,    
    { 
        LandInfo.bagels,
        LandInfo.continents,
        LandInfo.fractal,
        LandInfo.noodles,
        LandInfo.numConts,
        LandInfo.smallContinents,
    }),
    GetLandmassFamilyOption("Islands", MapDefaults.ISLANDS,    
    { 
        LandInfo.archipelago,
        LandInfo.clusters,
        LandInfo.islandPlates,
        LandInfo.largeIslands,
        LandInfo.megacluster,
        LandInfo.miniDonuts
    }),                    
    GetLandmassFamilyOption("Lakes", MapDefaults.LAKES,    
    { 
        LandInfo.inlandSea,
        LandInfo.invertedDonut,
        LandInfo.invertedExtras,
        LandInfo.lakes,
        LandInfo.largeLakes,
        LandInfo.sevenSeas
    }),
    GetLandmassFamilyOption("Pangea", MapDefaults.PANGEA,    
    { 
        LandInfo.donut,
        LandInfo.hex,
        LandInfo.maze,
        LandInfo.oval,
        LandInfo.pangea,
        LandInfo.snake
    }),

    -- Customizations
    {
        Name         = "Mountains",
        Values       = 
        {
            "Tectonic Plates",
            "Fractal Ranges",
            "Scattered Crags",
            "Clustered Highlands",
            "Uncanny Valleys",
            "Winding Canyons",
            "Everything",
            "Random Moderate",
            "Random"
        },
        DefaultValue = MapDefaults.MOUNTAINS,
        RandLHIndex  = 1,
        RandLHSize   = 5,
        RandSize     = 7,
    },
    {
        Name         = "Mountain Clumps",
        Values       = {"Full",    "Maze", "Hollow", "Random Maze/Hollow", "Random"},
        DefaultValue = MapDefaults.MTNCLUMPS,
        RandLHIndex  = 2,
        RandLHSize   = 2,
        RandSize     = 3,
    },
    {
        Name         = "Rivers",
        Values       = 
        {
            "Simple",
            "Detailed",
            "Branchy",
            "Snaky",
            "Everything",
            "Random"
        },
        DefaultValue = MapDefaults.RIVERS,
        RandSize     = 5,
    },
    {
        Name         = "Extras",
        Values       = 
        {
            "None",
            "Chains",
            "Clusters",
            "Mini Donuts",
            "Sprinkles",
            "Tectonic",
            "Tectonic and Chains",
            "Everything",
            "Random Moderate",
            "Random"
        },
        DefaultValue = MapDefaults.EXTRAS,
        RandLHIndex  = 2,
        RandLHSize   = 6,
        RandSize     = 8,
    },
    {
        Name         = "World Wrap",
        Values       = {"Globe", "Region", "Random"},
        DefaultValue = MapDefaults.WORLDWRAP,
        RandSize     = 2,
    },
    {
        Name         = "Climate Wrap",
        Values       = 
        {
            "Azimuthal",
            "Globe", 
            "Region",
            "Same as World Wrap",
            "Random Azimuthal or Globe",
            "Random Azimuthal or Region",
            "Random Globe or Region",
            "Random"
        },
        DefaultValue = MapDefaults.CLIMATEWRAP,
        RandLHIndex  = 2,
        RandLHSize   = 2,
        RandSize     = 3,
    },
    {
        Name         = "Climate",
        Values       = 
        {
            "Snowball", 
            "Ice Age", 
            "Standard", 
            "Greenhouse", 
            "Sandstorm", 
            "Random Ice Age to Greenhouse",
            "Random"
        },
        DefaultValue = MapDefaults.CLIMATE,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Biome",
        Values       = {"Arborea", "Prairie", "Standard", "Wetland", "Random"},
        DefaultValue = MapDefaults.BIOME,
        RandSize     = 4,
    },
    {
        Name         = "Sunlight",
        Values       = {"Standard", "Tilted Axis", "Two Suns", "Random"},
        DefaultValue = MapDefaults.SUNLIGHT,
        RandSize     = 3,
    },
    {
        Name         = "Icy Poles",
        Values       = {"Cropped", "Standard", "Random"},
        DefaultValue = MapDefaults.ICYPOLES,
        RandSize     = 2,
    },    
    
    -- Adjustments
    {
        Name         = "Land Starts",
        Values       = 
        {
            "Largest Area", 
            "Standard", 
            "Separate Areas",
            "Landmass-Based",
            "Random Largest-Separate",
            "Random"
        },
        DefaultValue = MapDefaults.LANDSTARTS,
        RandLHIndex  = 1,
        RandSize     = 4,
    },
    {
        Name         = "Water Starts",
        Values       = 
        {
            "Largest Area", 
            "Standard", 
            "Separate Areas",
            "Landmass-Based",
            "On Land",
            "Random Largest-Separate",
            "Random"
        },
        DefaultValue = MapDefaults.WATERSTARTS,
        RandLHIndex  = 1,
        RandSize     = 5,
    },    
    {
        Name         = "Minor Starts",
        Values       = 
        {
            "Largest Area", 
            "Standard", 
            "Separate Areas",
            "Major Areas",
            "Same as Land Starts",
            "Random Largest-Separate",
            "Random"
        },
        DefaultValue = MapDefaults.MINORSTARTS,
        RandLHIndex  = 1,
        RandSize     = 4,
    },    
    {
        Name         = "Mountain Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.MTNLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Hill Level",
        Values       = 
        {
            "Very Low",
            "Low", 
            "Standard", 
            "High", 
            "Very High",
            "Same as Mountain Level", 
            "Random Low-High",
            "Random"
        },
        DefaultValue = MapDefaults.HILLLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Volcano Level",
        Values       = 
        {
            "Very Low",
            "Low", 
            "Standard", 
            "High", 
            "Very High",
            "Same as Mountain Level", 
            "Same as Hill Level", 
            "Random Low-High",
            "Random"
        },
        DefaultValue = MapDefaults.VOLCLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Geothermal Fissure Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.GFISSLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Sea Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.SEALEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Lake Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.LAKELEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "River Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.RIVERLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Circumnavigation",
        Values       = 
        {
            "None",
            "Edges",
            "Paths",
            "Edges and Paths",
            "Landmass-Based",
            "Random Edges and/or Paths",
            "Random"
        },
        DefaultValue = MapDefaults.CIRCUMNAV,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Coastal Expansion",
        Values       = 
        {
            "None",
            "Very Low",
            "Low",
            "Standard", 
            "High",
            "Very High",
            "Everywhere",
            "Random Low-High",
            "Random"
        },
        DefaultValue = MapDefaults.COASTEXP,
        RandLHIndex  = 3,
        RandSize     = 7,
    },
    {
        Name         = "Coastal Lowlands",
        Values       = 
        {
            "None",
            "Standard",
            "Inland",
            "Deluge", 
            "Cataclysm",
            "Head for the Hills!",
            "Everywhere",
            "Random Moderate",
            "Random"
        },
        DefaultValue = MapDefaults.COASTLOWS,
        RandLHIndex  = 2,
        RandSize     = 7,
    },
    {
        Name         = "Temperature", -- "Temperature Offset" is too long of a name
        Values       = 
        {
            "Very Cold",
            "Cold", 
            "Standard", 
            "Hot",
            "Very Hot",
            "Random Cold-Hot",
            "Random"
        },
        DefaultValue = MapDefaults.TEMPERATURE,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Desert Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.DESERTLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Tundra Level",
        Values       = VeryLowVeryHighOptionValues,
        DefaultValue = MapDefaults.TUNDRALEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Rainfall",
        Values       = 
        {
            "Very Arid",
            "Arid", 
            "Standard", 
            "Wet",
            "Very Wet",
            "Random Arid-Wet",
            "Random"
        },
        DefaultValue = MapDefaults.RAINFALL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Kelp Forest Level",
        Values       = 
        {
            "Very Low",
            "Low", 
            "Standard", 
            "High", 
            "Very High",
            "Same as Rainfall", 
            "Random Low-High",
            "Random"
        },
        DefaultValue = MapDefaults.KELPLEVEL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Kelp Forests",
        Values       = {"None",    "Standard", "Creep", "Random Standard/Creep", "Random"},
        DefaultValue = MapDefaults.KELPFORESTS,
        RandLHIndex  = 2,
        RandLHSize   = 2,
        RandSize     = 3,
    },
    {
        Name         = "Climate Granularity",
        Values       = 
        {
            "Very Coarse",
            "Coarse", 
            "Standard",
            "Fine",
            "Very Fine",
            "Mixed Coarse-Fine",
            "Mixed", 
            "Random Coarse-Fine",
            "Random"
        },
        DefaultValue = MapDefaults.CLIMGRAN,
        RandLHIndex  = 2,
        RandSize     = 7,
    },
    {
        Name         = "Grass/Plains Mix",
        Values       = 
        {
            "Much More Grass",
            "More Grass",
            "Standard",
            "More Plains",
            "Much More Plains",
            "Random More Grass to More Plains",
            "Random"
        },
        DefaultValue = MapDefaults.GRASSPLAINS,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Forest/Jungle Mix",
        Values       = 
        {
            "Much More Forest",
            "More Forest",
            "Standard",
            "More Jungle",
            "Much More Jungle",
            "Random More Forest to More Jungle",
            "Random"
        },
        DefaultValue = MapDefaults.FORESTJUNGL,
        RandLHIndex  = 2,
        RandSize     = 5,
    },
    {
        Name         = "Biodiversity",
        Values       = 
        {
            "Very Low",
            "Low",
            "Standard",
            "High",
            "Very High",
            "Climate Based",
            "Random Low-High", 
            "Random"
        },
        DefaultValue = MapDefaults.BIODIV,
        RandLHIndex  = 2,
        RandSize     = 6,
    },
    
    -- Misc options
    { Name = "Connected Lands",              DefaultValue = MapDefaults.CONNECTLAND },
    { Name = "Connected Seas",               DefaultValue = MapDefaults.CONNECTSEAS },
    { Name = "Isolated Coasts",              DefaultValue = MapDefaults.ISOCOASTS   },
    { Name = "No Additional Lakes",       DefaultValue = MapDefaults.NOADDLAKES  },
    { Name = "No Coastal Ice",            DefaultValue = MapDefaults.NOCOASTICE  },
    { Name = "No Coastal Mountains",      DefaultValue = MapDefaults.NOCOASTMTS  },
    { Name = "No Desert",                 DefaultValue = MapDefaults.NODESERT    },
    { Name = "No Desert Forests",         DefaultValue = MapDefaults.NODFORESTS  },
    { Name = "No Desert Jungles",         DefaultValue = MapDefaults.NODJUNGLES  },
    { Name = "No Desert Oases",           DefaultValue = MapDefaults.NODOASES    },
    { Name = "No Floodplains",            DefaultValue = MapDefaults.NOFLOODPLNS },
    { Name = "No Forests",                DefaultValue = MapDefaults.NOFORESTS   },
    { Name = "No Geothermal Fissures",    DefaultValue = MapDefaults.NOGFISSURES },
    { Name = "No Grass",                  DefaultValue = MapDefaults.NOGRASS     },
    { Name = "No Grass Jungles",          DefaultValue = MapDefaults.NOGJUNGLES  },
    { Name = "No Hills",                  DefaultValue = MapDefaults.NOHILLS     },
    { Name = "No Ice",                    DefaultValue = MapDefaults.NOICE       },
    { Name = "No Jungles",                DefaultValue = MapDefaults.NOJUNGLES   },
    { Name = "No Marsh",                  DefaultValue = MapDefaults.NOMARSH     },
    { Name = "No Mountains",              DefaultValue = MapDefaults.NOMOUNTAINS },
    { Name = "No Plains",                 DefaultValue = MapDefaults.NOPLAINS    },
    { Name = "No Plains Marsh",           DefaultValue = MapDefaults.NOPMARSH    },
    { Name = "No Reefs",                  DefaultValue = MapDefaults.NOREEFS     },
    { Name = "No Rivers",                 DefaultValue = MapDefaults.NORIVERS    },
    { Name = "No Snow",                   DefaultValue = MapDefaults.NOSNOW,     },
    { Name = "No Snow Forests",           DefaultValue = MapDefaults.NOSFORESTS  },
    { Name = "No Snow Oases",             DefaultValue = MapDefaults.NOSOASES    },
    { Name = "No Tundra",                 DefaultValue = MapDefaults.NOTUNDRA    },
    { Name = "No Tundra Forests",         DefaultValue = MapDefaults.NOTFORESTS  },
    { Name = "No Volcanoes",              DefaultValue = MapDefaults.NOVOLCANOES },
    { Name = "Scrambled Land Luxuries",   DefaultValue = MapDefaults.SCRALUX     },
    { Name = "Thin Mountain Clump Edges", DefaultValue = MapDefaults.THINMCEDGES },
    { Name = "Turn Seas Into Lakes",       DefaultValue = MapDefaults.FRESHLAKES  },
};
------------------------------------------------------------------------------
-- Map Init
------------------------------------------------------------------------------
function GL_RandSeed(seed)
    -- Seed a native RNG with the map's seed
    -- so that we can randomize map options during map-data-init.
    local seed = seed or os.time();
    
    math.randomseed(seed);    
end

function GL_RandInt(upper, description)
    -- Native RNG that can substitute TerrainBuilder.GetRandomNumber()
    -- Args:
    --   upper: exclusive upper-bound integer
    --   description: ignored, but matches signature of TerrainBuilder.GetRandomNumber()
    -- Returns a random integer in the range [0,upper-1]
    
    local upper = upper or 1;
    
    -- Offset [1,N] to [0,N-1]
    return math.random(upper) - 1;
end

function GetOptionValueName(customOption, userInput)
    -- Return the display name of the selected value for an option.
    
    local indexedVal = customOption.Values[userInput];
    
    if (not indexedVal) then
        -- No corresponding display name, so just use the raw value.
        return tostring(userInput);
    end
    
    return indexedVal;
end

function GetUserInput(mapOptionName, defaultValue)
    -- Get user input for a map option.
    local userInput = nil;
    local valName   = "";
    local valSource = nil;
    
    if (ENABLE_UI == true) then
        -- UI options enabled. Determine what the user selected from the start menu.
        userInput = MapConfiguration.GetValue(mapOptionName);
        
        if (userInput == nil) then
            -- User input not available, so use default value instead.
            userInput = defaultValue;
            valSource = "Not Supported";
        end
    else
        -- UI options disabled. Use hard-coded setting instead.
        userInput = defaultValue;
        valSource = "Lua";
    end

    if valSource then
        valName = valSource .. " --> ";
    end
    
    return userInput, valName, valSource;
end

function ChooseOption(optIndex)
    -- Choose a regular map option.
    local customOption = OptionInfo[optIndex];
    local optName      = customOption.Name;
    
    local userInput, valName = 
      GetUserInput(MapOptionNames[optIndex], OptionInfo[optIndex].DefaultValue);
    
    --print("optIndex = " .. optIndex .. ", userInput = " .. NonNilStr(userInput));
    
    valName = valName .. GetOptionValueName(customOption, userInput);
    
    local randSize = customOption.RandSize;
    if randSize then
        -- The option supports random.
        -- Assume that "Random" is the last option in the list.
        local randOpt = #customOption.Values;
        
        local randLHIndex = customOption.RandLHIndex;
        if randLHIndex then
            -- This option supports random low-high, which precedes "random".
            if (userInput == (randOpt - 1)) then
                -- The user selected "Random Low-High", 
                -- so randomize within that range, assuming that LH-index points to "low".
                local randLHSize = customOption.RandLHSize or 3;
                userInput = randLHIndex + ScriptData.configRandFcn(randLHSize, 
                    "Random " .. optName .. " in [low,high] - Lua");
                valName = valName .. " --> Chose " .. GetOptionValueName(customOption, userInput);
            end
        end
        
        if (userInput == randOpt) then
            -- The user selected "Random", so randomize the option.
            userInput = 1 + ScriptData.configRandFcn(randSize, "Random " .. optName .. " - Lua");
            valName = valName .. " --> Chose " .. GetOptionValueName(customOption, userInput);
        end
    end
    
    print(optName .. ": " .. valName);
    
    return userInput;
end

function ChooseBoolOption(optIndex)
    -- Choose a boolean map option.
    local userInput, valName, valSource = 
      GetUserInput(MapOptionNames[optIndex], OptionInfo[optIndex].DefaultValue);
    
    --print("optIndex = " .. optIndex .. ", userInput = " .. NonNilStr(userInput));
            
    valName = valName .. NonNilStr(userInput);
    
    -- Use checkbox ascii art to better distinguish true from false.
    local boxStr = "[ ] ";
    if userInput then
        boxStr = "[x] ";
    end
    
    if valSource then
        valSource = " (" .. valSource .. ")";
    else
        valSource = "";
    end
    
    print(boxStr .. OptionInfo[optIndex].Name .. valSource);
    
    return userInput;
end

function ChooseInitDataOption(optIndex, fallback)
    -- Choose an option that initializes in GetMapInitData().
    -- Can only randomize if we have native RNG.
    --
    -- Args:
    --   optIndex: which option to initialize
    --   fallback: what to set if user selected random but RNG not available.
    --
    -- Returns: the value to set for the map option
    
    local userInput, valName = 
      GetUserInput(MapOptionNames[optIndex], OptionInfo[optIndex].DefaultValue);
        
    local customOption = OptionInfo[optIndex];
    
    local optName = customOption.Name;
    
    valName = valName .. GetOptionValueName(customOption, userInput);
        
    local randSize = customOption.RandSize;
    if randSize then
        -- The option supports random.
        -- Assume that "Random" is the last option in the list.
        local randOpt = #customOption.Values;
        
        local randLHIndex = customOption.RandLHIndex;
        if randLHIndex then
            -- This option supports random low-high, which precedes "random".
            if (userInput == (randOpt - 1)) then
                -- The user selected "Random Low-High", 
                -- so randomize within that range, assuming that LH-index points to "low".
                local randLHSize = customOption.RandLHSize or 3;
                userInput = randLHIndex + ScriptData.configRandFcn(randLHSize, 
                    "Random " .. optName .. " in [low,high] - Lua");
                valName = valName .. " --> Chose " .. GetOptionValueName(customOption, userInput);
            end
        end
        
        if (userInput == randOpt) then
            -- The user selected "Random", so randomize the option if possible.
            if (ScriptData.configRandFcn == GL_RandInt) then
                -- Got a native RNG, so let's randomize this option.
                userInput = 1 + GL_RandInt(randSize, "Random " .. optName .. " - Lua");
                valName = valName .. " --> Chose " .. GetOptionValueName(customOption, userInput);
            else
                -- No RNG available because Civ RNG not yet seeded.
                userInput = fallback;
                valName = valName .. " --> RNG Not Available --> " .. 
                    GetOptionValueName(customOption, userInput);
            end
        end
    end
    
    print(optName .. ": " .. valName);
    
    return userInput;
end

function ChooseNoCoastIceOption()
    -- Choose the No Coastal Ice map option.
    local optIndex = MapOptions.NOCOASTICE;
    local mapOptionName = MapOptionNames[optIndex];
    local defaultValue = OptionInfo[optIndex].DefaultValue;
    
    local userInput = nil;
    local valSource = nil;
    
    if (ENABLE_UI == true) then
        -- UI options enabled. Determine what the user selected from the start menu.
        userInput = MapConfiguration.GetValue(mapOptionName);
        
        if (userInput == nil) then
            -- User input not available, so use default value instead.
            userInput = defaultValue;
            valSource = "Not Supported";
        end
        
        if (userInput ~= true) then
            -- The regular No Coastal Ice checkbox is unchecked.
            -- Try the Ynamp option.
            local ynampInput = MapConfiguration.GetValue(YNAMP_OPTNAME_NO_COASTAL_ICE);
            if (ynampInput ~= nil) then
                -- Ynamp's "No Ice Near Land" checkbox exists.
                userInput = ynampInput;
                valSource = "YnAMP No Ice Near Land";
            end
        end
    else
        -- UI options disabled. Use hard-coded setting instead.
        userInput = defaultValue;
        valSource = "Lua";
    end
        
    -- Use checkbox ascii art to better distinguish true from false.
    local boxStr = "[ ] ";
    if userInput then
        boxStr = "[x] ";
    end
    
    if valSource then
        valSource = " (" .. valSource .. ")";
    else
        valSource = "";
    end
    
    print(boxStr .. OptionInfo[optIndex].Name .. valSource);
    
    return userInput;
end

function ChooseFromShuffle(firstOpt, lastOpt)
    -- Given a first and last option index, create a "deck" out of 
    -- map-filter user inputs and randomly choose an option.
    --
    -- Args:
    --   firstOpt: the first shuffle family option to consider
    --   lastOpt: the last shuffle family option to consider
    -- 
    -- Returns
    --   selectedInfo: config info corresponding to the user input
    
    local deck = {};
    local deckNames = {};
    local numOpts = lastOpt - firstOpt + 1;

    local familyOpt;
    local familyInfos;

    for iOpt=firstOpt,lastOpt do
        -- For each family option, determine what values to include

        -- Get info about the option
        local familyOpt = OptionInfo[iOpt];
                
        -- Get the value that the user selected.
        local familyChoice = GetUserInput(MapOptionNames[iOpt], familyOpt.DefaultValue);
        
        -- Get info about the choices for this option
        local familyInfos = familyOpt.Infos or {};
        
        local familyNumInfos = table.maxn(familyInfos);
        
        if (familyChoice == (familyNumInfos - GOT_ALL)) then
            -- ALL selected for this option family.
            for i, info in ipairs(familyInfos) do
                table.insert(deck, info);
                table.insert(deckNames, info.name);
            end
            
        elseif (familyChoice <= familyNumInfos) then
            -- Single landmass selected.
            table.insert(deck,      familyInfos[familyChoice]);
            table.insert(deckNames, familyInfos[familyChoice].name);
        end
    end
    
    if INCLUDE_NONE_IN_LANDMASS_SHUFFLE then
        -- Add the "no landmass chosen" landmass to the shuffle.
        table.insert(deck, LandInfo.none);
        table.insert(deckNames, LandInfo.none.name);
    end

    local deckSize = table.maxn(deck);
    local selectedInfo;

    if (deckSize == 0) then
        -- Edge case: the deck is empty ("None" for every family!) 
        print("Empty deck! Map will not have a landmass.");
        selectedInfo = LandInfo.none;
    else
        -- Choose a random map from the deck.
        print("Choosing from {");
        print(unpack(deckNames));
        print("}");
        selectedInfo = deck[1 + ScriptData.configRandFcn(deckSize, 
            "Random option weighted by user selection")];
    end
    
    print("Chose " .. selectedInfo.name);

    return selectedInfo;
end

function InitUserInput()
    -- Populate most user-input variables based on map-config specs.
    -- Does not initialize world wrap or map size.
    UserInput.resources   = ChooseOption(MapOptions.RESOURCES);
    UserInput.start       = ChooseOption(MapOptions.START);
    
    ScriptData.landInfo = GetConfigInfo(
        LandInfo.default, ChooseFromShuffle(FIRST_LAND_OPT, LAST_LAND_OPT));
    UserInput.landmass = ScriptData.landInfo.id;
    
    UserInput.mountains   = ChooseOption(MapOptions.MOUNTAINS);
    UserInput.mtnClumps   = ChooseOption(MapOptions.MTNCLUMPS);
    UserInput.rivers      = ChooseOption(MapOptions.RIVERS);
    UserInput.extras      = ChooseOption(MapOptions.EXTRAS);
    UserInput.climate     = ChooseOption(MapOptions.CLIMATE);
    UserInput.biome       = ChooseOption(MapOptions.BIOME);
    UserInput.sunlight    = ChooseOption(MapOptions.SUNLIGHT);
    UserInput.icyPoles    = ChooseOption(MapOptions.ICYPOLES);
    
    UserInput.landStarts  = ChooseOption(MapOptions.LANDSTARTS);
    UserInput.waterStarts = ChooseOption(MapOptions.WATERSTARTS);
    UserInput.minorStarts = ChooseOption(MapOptions.MINORSTARTS);
    UserInput.mtnLevel    = ChooseOption(MapOptions.MTNLEVEL);
    UserInput.hillLevel   = ChooseOption(MapOptions.HILLLEVEL);
    UserInput.volcLevel   = ChooseOption(MapOptions.VOLCLEVEL);
    UserInput.gFissLevel  = ChooseOption(MapOptions.GFISSLEVEL);
    UserInput.seaLevel    = ChooseOption(MapOptions.SEALEVEL);
    UserInput.lakeLevel   = ChooseOption(MapOptions.LAKELEVEL);
    UserInput.riverLevel  = ChooseOption(MapOptions.RIVERLEVEL);
    UserInput.circumnav   = ChooseOption(MapOptions.CIRCUMNAV);
    UserInput.coastExp    = ChooseOption(MapOptions.COASTEXP);
    UserInput.coastLows   = ChooseOption(MapOptions.COASTLOWS);
    UserInput.temperature = ChooseOption(MapOptions.TEMPERATURE);
    UserInput.desertLevel = ChooseOption(MapOptions.DESERTLEVEL);
    UserInput.tundraLevel = ChooseOption(MapOptions.TUNDRALEVEL);
    UserInput.rainfall    = ChooseOption(MapOptions.RAINFALL);
    UserInput.kelpLevel   = ChooseOption(MapOptions.KELPLEVEL);
    UserInput.kelpForests = ChooseOption(MapOptions.KELPFORESTS);
    UserInput.climGran    = ChooseOption(MapOptions.CLIMGRAN);
    UserInput.grassPlains = ChooseOption(MapOptions.GRASSPLAINS);
    UserInput.forestJungl = ChooseOption(MapOptions.FORESTJUNGL);
    UserInput.biodiv      = ChooseOption(MapOptions.BIODIV);
    
    UserInput.connectLand = ChooseBoolOption(MapOptions.CONNECTLAND);
    UserInput.connectSeas = ChooseBoolOption(MapOptions.CONNECTSEAS);
    UserInput.isoCoasts   = ChooseBoolOption(MapOptions.ISOCOASTS);
    UserInput.noAddLakes  = ChooseBoolOption(MapOptions.NOADDLAKES);
    UserInput.noCoastIce  = ChooseNoCoastIceOption();
    UserInput.noCoastMts  = ChooseBoolOption(MapOptions.NOCOASTMTS);
    UserInput.noDesert    = ChooseBoolOption(MapOptions.NODESERT);
    UserInput.noDForests  = ChooseBoolOption(MapOptions.NODFORESTS);
    UserInput.noDJungles  = ChooseBoolOption(MapOptions.NODJUNGLES);
    UserInput.noDOases    = ChooseBoolOption(MapOptions.NODOASES);
    UserInput.noFloodplns = ChooseBoolOption(MapOptions.NOFLOODPLNS);
    UserInput.noForests   = ChooseBoolOption(MapOptions.NOFORESTS);
    UserInput.noGFissures = ChooseBoolOption(MapOptions.NOGFISSURES);
    UserInput.noGrass     = ChooseBoolOption(MapOptions.NOGRASS);
    UserInput.noGJungles  = ChooseBoolOption(MapOptions.NOGJUNGLES);    
    UserInput.noHills     = ChooseBoolOption(MapOptions.NOHILLS);
    UserInput.noIce       = ChooseBoolOption(MapOptions.NOICE);
    UserInput.noJungles   = ChooseBoolOption(MapOptions.NOJUNGLES);
    UserInput.noMarsh     = ChooseBoolOption(MapOptions.NOMARSH);
    UserInput.noMountains = ChooseBoolOption(MapOptions.NOMOUNTAINS);
    UserInput.noPlains    = ChooseBoolOption(MapOptions.NOPLAINS);
    UserInput.noPMarsh    = ChooseBoolOption(MapOptions.NOPMARSH);
    UserInput.noReefs     = ChooseBoolOption(MapOptions.NOREEFS);
    UserInput.noRivers    = ChooseBoolOption(MapOptions.NORIVERS);
    UserInput.noSnow      = ChooseBoolOption(MapOptions.NOSNOW);
    UserInput.noSForests  = ChooseBoolOption(MapOptions.NOSFORESTS);
    UserInput.noSOases    = ChooseBoolOption(MapOptions.NOSOASES);
    UserInput.noTundra    = ChooseBoolOption(MapOptions.NOTUNDRA);
    UserInput.noTForests  = ChooseBoolOption(MapOptions.NOTFORESTS);
    UserInput.noVolcanoes = ChooseBoolOption(MapOptions.NOVOLCANOES);
    UserInput.scraLux     = ChooseBoolOption(MapOptions.SCRALUX);
    UserInput.thinMCEdges = ChooseBoolOption(MapOptions.THINMCEDGES);
    UserInput.freshLakes  = ChooseBoolOption(MapOptions.FRESHLAKES);
    
    -- Tweaks to options
    
    -- Customization options
    -- Extra islands
    if ((UserInput.landmass == Landmasses.NONE) and 
        (UserInput.extras == ExtraIslesLakes.NONE) and
        (not UserInput.freshLakes)) then
        -- No landmass selected.
        -- Make sure that the map has extra islands to avoid an all-water map.
        print("Got no landmass with salt water and no extras! Randomizing extras to avoid an all-salt-water map.");
        UserInput.extras = 2 + ScriptData.configRandFcn(
            NUM_EXTRAS_OPTS-1, "Random extras for map with no landmass Lua");
        
        local extrasOpt = OptionInfo[MapOptions.EXTRAS];
        local valName = GetOptionValueName(extrasOpt, UserInput.extras);
        print(extrasOpt.Name .. ": " .. valName);
    end
    
    -- Climate info
    local climateInfos = 
    {
        ClimateInfo.snowball,
        ClimateInfo.iceAge,
        ClimateInfo.default,
        ClimateInfo.greenhouse,
        ClimateInfo.sandstorm
    };
    ScriptData.climateInfo = GetConfigInfo(ClimateInfo.default, climateInfos[UserInput.climate]);
    
    -- Biome info
    local biomeInfos = 
    {
        BiomeInfo.arborea,
        BiomeInfo.prairie,
        BiomeInfo.default,
        BiomeInfo.wetland
    };
    ScriptData.biomeInfo = GetConfigInfo(BiomeInfo.default, biomeInfos[UserInput.biome]);
    
    -- Sunlight info
    local sunlightInfos = 
    {
        SunlightInfo.default,
        SunlightInfo.tilted,
        SunlightInfo.twoSuns
    };
    ScriptData.sunlightInfo = GetConfigInfo(
        SunlightInfo.default, sunlightInfos[UserInput.sunlight]);
    if (UserInput.icyPoles == ICYPOLES_FULL) then
        -- We're not cropping the map, so cancel-out the latitude multiplier.
        ScriptData.sunlightInfo.latMult = {1, 1, 1, 1, 1};
    end
    
    -- Adjustment options
    -- Mountains, hills, and volcanoes.
    if (UserInput.hillLevel == HillLevels.MTNS) then
        UserInput.hillLevel = UserInput.mtnLevel;
    end
    if (UserInput.volcLevel == VolcanoLevels.MTNS) then
        UserInput.volcLevel = UserInput.mtnLevel;
        
    elseif (UserInput.volcLevel == VolcanoLevels.HILLS) then
        UserInput.volcLevel = UserInput.hillLevel;
    end
    
    -- Circumnavigation
    if (UserInput.circumnav == Circumnavigation.LANDBASE) then 
        -- Resolve landmass-based circumnavigation.
        UserInput.circumnav = ScriptData.landInfo.circumnav;
        print("Using landmass-based circumnavigation (" .. ScriptData.landInfo.name .. 
              " -> " .. OptionInfo[MapOptions.CIRCUMNAV].Values[UserInput.circumnav] .. ")");
    end
    
    -- Kelp forests.
    if (UserInput.kelpLevel == KelpLevels.RAINFALL) then
        UserInput.kelpLevel = UserInput.rainfall;
    end
    
    -- Biodiversity
    if (UserInput.biodiv == Biodivs.CLIMBASE) then
        -- Biodiversity based on climate.
        UserInput.biodiv = ScriptData.climateInfo.biodiv;
    end
    local biodivInfos = 
    {
        BiodivInfo.veryLow, 
        BiodivInfo.low,
        BiodivInfo.default,
        BiodivInfo.high,
        BiodivInfo.veryHigh
    };
    ScriptData.biodivInfo = GetConfigInfo(BiodivInfo.default, biodivInfos[UserInput.biodiv]);
end

function InitWorldWrap()
    -- Determine world wrap
    -- Note: Civ seeds its RNG *after* initializing world wrap.
    -- 
    -- Returns true iff the user selected "Same as World Wrap" for Climate Wrap.
    UserInput.worldWrap = ChooseInitDataOption(MapOptions.WORLDWRAP, WWRAP_GLOBE);
    
    -- Offset world wrap to align with climate wrap.
    UserInput.worldWrap = UserInput.worldWrap + 1;
    
    if (UserInput.worldWrap == WWRAP_GLOBE) then
        -- Globe
        ScriptData.wrapX = true;

        -- Let non-climate fractals touch the edges of the map.
        g_iFlags.FRAC_POLAR = false;            
    else
        -- Region
        ScriptData.wrapX = false;
        
        -- Avoid edges for non-climate fractals.
        g_iFlags.FRAC_POLAR = true;
    end
    
    -- Set world-wrap for all fractals, including climate fractals.
    g_iFlags.FRAC_WRAP_X = ScriptData.wrapX;
    g_iFlags.FRAC_WRAP_Y = false;
    ScriptData.climateFracFlags.FRAC_WRAP_X = ScriptData.wrapX;
    ScriptData.climateFracFlags.FRAC_WRAP_Y = false;
    
    local climateMatchesWorld = false;
    
    UserInput.climateWrap = ChooseInitDataOption(MapOptions.CLIMATEWRAP, WWRAP_SAME);
    if (((UserInput.climateWrap == WWRAP_RANDAG) or (UserInput.climateWrap == WWRAP_RANDAR)) and
        (ScriptData.configRandFcn ~= GL_RandInt)) then
        -- No RNG, so fall back to matching world wrap.
        print("Climate Wrap RNG not available; setting Climate Wrap to match World Wrap.");
        UserInput.climateWrap = WWRAP_SAME; 
    end
    
    if (UserInput.climateWrap == WWRAP_SAME) then
        -- The user wants climate wrap to match world wrap.
        climateMatchesWorld = true;
        UserInput.climateWrap = UserInput.worldWrap;
    elseif (UserInput.climateWrap == WWRAP_RANDAG) then
        -- Random Azimuth or Globe.
        UserInput.climateWrap = 1 + GL_RandInt(2, "Random Climate Wrap Azimuth/Globe - Lua");
        print("Random Azimuthul or Globe Climate Wrap -> Chose " .. 
              OptionInfo[MapOptions.CLIMATEWRAP].Values[UserInput.climateWrap]);
    elseif (UserInput.climateWrap == WWRAP_RANDAR) then
        -- Random Azimuth or Region.
        UserInput.climateWrap = 1 + GL_RandInt(2, "Random Climate Wrap Azimuth/Region - Lua");
        if (UserInput.climateWrap == WWRAP_GLOBE) then
            UserInput.climateWrap = WWRAP_REGION;
        end
        print("Random Azimuthul or Region Climate Wrap -> Chose " .. 
              OptionInfo[MapOptions.CLIMATEWRAP].Values[UserInput.climateWrap]);
    end
    
    return climateMatchesWorld;
end

function InitWorldSizeInfo()
    -- Set the global world size info based on user inputs such as climate.    
    local worldSize = ScriptData.worldSize;
    
    -- Look for the world-size hash in game info.
    local mapSizeType = nil; -- Default val in case hash not found.
    local gridWidth = nil;
    local gridHeight = nil;
    for row in GameInfo.Maps() do    
        if(worldSize == row.Hash) then
            mapSizeType = row.MapSizeType;
            gridWidth = row.GridWidth;
            gridHeight = row.GridHeight;
            break;
        end
    end
    
    if (not mapSizeType) then
        print("Got an unidentified map size.");
        -- Just return and let map-gen calculate world size info based on grid size.
        return;
    end
    print("Map Size is " .. mapSizeType);
    
    if (not (gridWidth and gridHeight)) then
        print("Unable to determine grid dimensions.");
        -- Just return and let map-gen calculate world size info based on grid size.
        return;
    end
    print("Configured grid size (w,h) is " .. CoordString(gridWidth, gridHeight));
        
    local gridSize = PREFERRED_STD_SIZES[mapSizeType] or 
        {width = gridWidth, height = gridHeight};
    
    print("GL base grid size (w,h) is " .. CoordString(gridSize.width, gridSize.height));
    
    local gridSizeEnlarged = PREFERRED_STD_SIZES_ENLARGED[mapSizeType] or 
        {width = gridWidth+8, height = gridHeight+8};
    
    local sizeInfo = nil;
    if (UserInput.climateWrap == WWRAP_GLOBE) then
        -- Global climate wrap: certain climates need cropping / resizing.
        
        if (UserInput.icyPoles == ICYPOLES_CROP) then
            -- Crop out the polar ice taking over more of the world by 
            -- using a "flatter" grid. This allows special plot modes
            -- to assign starting plots without having to worry about 
            -- icy regions.
            print("Adjusting map size (globe + cropped poles)");            
            local reductionMult = ScriptData.sunlightInfo.latMult[UserInput.climate];
            local gridSizeToCrop = gridSize;
            
            if (reductionMult < 0.6) then
                -- Significant height reduction; enlarge map size to compensate.
                print("Enlarging map size to compensate for height reduction.");
                gridSizeToCrop = gridSizeEnlarged;
            end
            
            sizeInfo = AdjustWorldHeight(CalculateWorldSizeInfo(
                gridSizeToCrop.width, gridSizeToCrop.height), reductionMult);
                
        elseif (UserInput.sunlight == Sunlights.TILTED) then
            -- Uncropped tilted axis.
            -- Increase map size to accomodate frozen wasteland
            print("Increasing map size (global tilted axis full)");
            sizeInfo = CalculateWorldSizeInfo(gridSizeEnlarged.width, gridSizeEnlarged.height);
        end
    end
    
    if (not sizeInfo) then
        -- Standard world size info.
        sizeInfo = CalculateWorldSizeInfo(gridSize.width, gridSize.height);
    end
    
    ScriptData.worldSizeInfo = sizeInfo;
end

function GetMapInitData(worldSize)
    -- This function can reset map grid sizes and world wrap settings.
    -- Args: worldSize: a hash that corresponds to a row in GameInfo.Maps
    --
    -- Note: does not take any other args, and for some reason custom map sizes
    -- each have a nil hash in GameInfo.Maps. So...not seeing any way to support
    -- custom map sizes via the MapSize option.
    
    print("Running Got Lakes v" .. glVersion);
    
    if ScriptData.gotGatheringStorm then
        print("Civ6 - Gathering Storm");
        
    elseif ScriptData.gotRiseAndFall then
        print("Civ6 - Rise and Fall");
    else
        print("Civ6 - Vanilla");
    end
    
    if ScriptData.gotOphFungalfieldBiome then
        print("Ophidy's Fungalfield Biome enabled (allows fungalfield feature and psilocap resource)");
    end
    
    if ScriptData.gotSuksOceans then
        print("Custom Game Mode - Sukritact's Oceans (allows kelp forests)");
    end
    
    if ScriptData.gotYnAMPStarts then
        print("Yet (not) Another Maps Pack - Custom Starts (overrides Got Lakes' custom civ starts)");
    end
    
    if (ENABLE_UI == true) then
        print("UI options enabled.");
    else
        print("UI options disabled. Taking options from lua instead.");
    end
    
    ScriptData.worldSize = worldSize;
    
    -- DO NOT generate random numbers with TerrainBuilder in this method.
    -- This method happens before initializing the TerrainBuilder's RNG.

    local mapSeed = MapConfiguration.GetValue("RANDOM_SEED");
    print("Got Lakes map seed: " .. tostring(mapSeed));

    local climateWrapMatchesWorldWrap;

    if MapIsMultiplayer() then
        print("Loading options with no RNG (multiplayer map).");
        -- Since we don't have RNG, 
        -- get only the options necessary for world wrap and map size.
        
        -- Don't get user input because that could be random.
        
        -- Get non-random World Wrap.
        climateWrapMatchesWorldWrap = InitWorldWrap();
        
        -- Don't get shuffle options because those could be random.
        
        -- Determine world size (depends on world wrap).
        -- Since we don't know the climate yet, we can't factor climate 
        -- into the world size (no cropping/enlarging).
        InitWorldSizeInfo();
    else
        print("Loading options with native RNG (single-player map)");
        
        -- Use native RNG so that we can randomize world wrap.
        GL_RandSeed(mapSeed);    
    
        -- Shuffle all map options using native RNG.    
        ScriptData.configRandFcn = GL_RandInt;
        
        -- Get random world wrap.
        climateWrapMatchesWorldWrap = InitWorldWrap();
        
        -- Get user input.
        InitUserInput();
        
        -- Determine world size (depends on world wrap and user input).
        InitWorldSizeInfo();
    end
    
    -- Set grid size based on user input.
    local grid_size = ScriptData.worldSizeInfo.size;
    
    if grid_size then
        -- Successfully mapped worldSize hash to a known map size.
        return {
            Width  = grid_size[1],
            Height = grid_size[2],
            WrapX  = ScriptData.wrapX,
            WrapY  = false
        };
    end
    
    -- Else we have a custom map size.
    print("Got a custom map size; world-wrap is effectively a globe.");
    
    ScriptData.worldSize = nil;
    
    -- Reset directional world wrap specs to match reality.
    UserInput.worldWrap = WWRAP_GLOBE;
    if climateWrapMatchesWorldWrap then
        -- Also reset climate wrap so that it still matches world wrap.
        UserInput.climateWrap = UserInput.worldWrap;
    end
    ScriptData.wrapX = true;
    
    -- Return void - don't reset grid size or world wrap.
end
------------------------------------------------------------------------------
-- Map Generation
------------------------------------------------------------------------------
function InitOptionsWithTerrainBuilder()
    -- Obtain options based on user input.
    -- No-op if GetMapInitData() already generated this info.
    
    if ScriptData.configRandFcn then
        -- Already initialized.
        print("Already loaded options.");
        return;
    end
    
    -- Load all options into global variables.
    print("Loading options with TerrainBuilder RNG...");
    
    ScriptData.configRandFcn = TerrainBuilder.GetRandomNumber;
    
    -- Get user input.
    InitUserInput();
end

function InitTerrainTypes(plotTypes)
    -- Determine which terrain types are enabled.
    local enabledTerrainsList =
    {
        g_TERRAIN_TYPE_DESERT,
        g_TERRAIN_TYPE_GRASS, 
        g_TERRAIN_TYPE_PLAINS,
        g_TERRAIN_TYPE_SNOW,
        g_TERRAIN_TYPE_TUNDRA
    };
    local enabledTerrainsMap =
    {
        [g_TERRAIN_TYPE_DESERT] = true,
        [g_TERRAIN_TYPE_GRASS] = true,
        [g_TERRAIN_TYPE_PLAINS] = true,
        [g_TERRAIN_TYPE_SNOW] = true,
        [g_TERRAIN_TYPE_TUNDRA] = true
    };
    
    if (UserInput.noDesert and UserInput.noGrass and UserInput.noPlains and 
        UserInput.noSnow and UserInput.noTundra) then
        -- User disabled all terrains!
        -- Randomly choose terrains to remove.
        print("All terrain types disabled! Randomly choosing terrains to remove.");
        enabledTerrainsList = GetShuffledCopyOfTable(enabledTerrainsList);
        
        -- Remove 1-3 terrains. Map becomes boring if there is only 1 terrain.
        local numTerrainsToRemove = 1 +    TerrainBuilder.GetRandomNumber(3, 
            "How many terrains to remove");
        
        for i = 1, numTerrainsToRemove do
            local terrainRemoved = table.remove(enabledTerrainsList);
            print("No " .. TerrainString(terrainRemoved));
            enabledTerrainsMap[terrainRemoved] = false;
        end
        
    else
        enabledTerrainsList = {};
    
        if UserInput.noDesert then
            enabledTerrainsMap[g_TERRAIN_TYPE_DESERT] = false;
        else
            table.insert(enabledTerrainsList, g_TERRAIN_TYPE_DESERT);
        end
        if UserInput.noGrass then
            enabledTerrainsMap[g_TERRAIN_TYPE_GRASS] = false;
        else
            table.insert(enabledTerrainsList, g_TERRAIN_TYPE_GRASS);
        end
        if UserInput.noPlains then
            enabledTerrainsMap[g_TERRAIN_TYPE_PLAINS] = false;
        else
            table.insert(enabledTerrainsList, g_TERRAIN_TYPE_PLAINS);
        end
        if UserInput.noSnow then
            enabledTerrainsMap[g_TERRAIN_TYPE_SNOW] = false;
        else
            table.insert(enabledTerrainsList, g_TERRAIN_TYPE_SNOW);
        end
        if UserInput.noTundra then
            enabledTerrainsMap[g_TERRAIN_TYPE_TUNDRA] = false;
        else
            table.insert(enabledTerrainsList, g_TERRAIN_TYPE_TUNDRA);
        end
    end
    ScriptData.enabledTerrainsList = enabledTerrainsList;
    ScriptData.enabledTerrainsMap = enabledTerrainsMap;
    
    local enabledTerrainsStr = "Enabled Terrains: "
    local isFirst = true;
    for i, terrainType in ipairs(enabledTerrainsList) do
        if not isFirst then
            enabledTerrainsStr = enabledTerrainsStr .. ", ";
        else
            isFirst = false;
        end
        enabledTerrainsStr = enabledTerrainsStr .. TerrainString(terrainType);
    end
    print(enabledTerrainsStr);
    
    -- Initialize terrain types based on plot types.
    local terrainTypes = table.fill(g_TERRAIN_TYPE_GRASS, g_numTiles);

    for iX = 0, g_iW - 1 do
        for iY = 0, g_iH - 1 do
            local index = GetPlotIndexLua(iX,iY);
            if (plotTypes[index] == g_PLOT_TYPE_OCEAN) then
                if (IsAdjacentToLand(plotTypes, iX, iY)) then
                    terrainTypes[index] = g_TERRAIN_TYPE_COAST;
                else
                    terrainTypes[index] = g_TERRAIN_TYPE_OCEAN;
                end
            
            -- Initialize all land as grass
            elseif (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
                terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
                
            elseif (plotTypes[index] == g_PLOT_TYPE_HILLS) then
                terrainTypes[index] = g_TERRAIN_TYPE_GRASS_HILLS;
                
            elseif (plotTypes[index] == g_PLOT_TYPE_LAND) then
                terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
            
            else
                print("Unexpected plot type at " .. 
                CoordString(iX, iY) .. ": " .. NonNilStr(plotTypes[index]));
            end
        end
    end
    return terrainTypes;
end

function GeneratePlotsWithFeatures()
    -- Generate plot types, terrain, and features.

    -- Initialize coastal plot map.
    ScriptData.coastPlots = table.fill(g_PLOT_TYPE_OCEAN, g_numTiles);
    
    -- Plot types are the core layer of the map, 
    -- determining land or sea, determining flatland, hills or mountains.
    local plotTypes = GeneratePlotTypes();
    
    -- Initialize terrain types.
    local terrainTypes = InitTerrainTypes(plotTypes);
    
    -- Set shallow and deep water as terrain.
    GenerateCoasts(terrainTypes);

    -- Optional step: replace all coastal mountains with hills.
    -- Must do this after generating coasts and before setting terrain.
    if (UserInput.noCoastMts == true) then
        print("Removing coastal mountains.");
        RemoveCoastalMountains(plotTypes, terrainTypes);
    end
    
    -- Civ 6 doesn't "set" plot types, so instead we "set" terrain types 
    -- in order to unbreak rivers and lakes.
    SetTerrainTypes(terrainTypes); 
    
    -- Add some fresh lakes and rivers.
    -- River generation is affected by plot types, originating from 
    -- highlands and preferring to traverse towards lowlands.
    AddLakesAndRivers();
    
    -- Terrain covers climate: grassland, plains, desert, tundra, snow.
    GenerateTerrain();
    
    print("Analyzing chokepoints.");
    TerrainBuilder.AnalyzeChokepoints();
    
    -- Determines continental plates and possibly artwork as well.
    StampContinents();
    
    if ScriptData.gotGatheringStorm then
        -- Additional steps for Gathering Storm expansion.
        -- These steps depend on stamped continents.
        print("Counting plots along continent boundaries.");
        local iContinentBoundaryPlots = CountContinentBoundaryPlots();
    
        -- Add voclanoes
        -- Must do this before adding natural wonders.
        AddVolcanicTerrain(iContinentBoundaryPlots);        
    end
    
    -- Features depend on plot types, terrain types, rivers and lakes 
    -- to help determine their placement.
    local featuregen = GenerateFeatures();
    
    -- Throw in some random natural wonders.
    -- Natural wonders depend on features for adjacency checks.
    --
    -- Natural wonders originally came after cliffs.
    -- But nat wonder cliffs don't check whether an area still has flat coast.
    GenerateNaturalWonders();
    
    -- Cliffs also depend on both plot types and terrain types.
    AddCliffs();
    
    if ScriptData.gotGatheringStorm then
        -- Additional steps for Gathering Storm expansion.
        -- These steps happen after natural wonders.
        print("Analyzing chokepoints (2nd pass).");
        TerrainBuilder.AnalyzeChokepoints();

        -- Add geothermal fissures.
        featuregen:AddFeaturesFromContinents();
    end
    
    -- Check for areas completely surrounded by 
    -- impassable natural wonders, mountains, volcanoes, cliffs, or ice.
    --
    -- Also normalize terrain and features under the remaining obstacles.
    EnsureTerrainReachability();
    
    -- Note that this does NOT fix wonders that block chokepoints.
    print("Analyzing post-continent chokepoints.");
    TerrainBuilder.AnalyzeChokepoints();
    
    
    if ScriptData.gotGatheringStorm then
        -- Set elevation for coastal land
        -- to control how rising sea-level affects coastal flooding.
        MarkCoastalLowlands();
    end
end

function CountLandTerrainTypes(landTerrainHist)
    -- Determine the number of land terrain types that have a significant presence on the map.
    -- Args: 
    --   landTerrainHist: a histogram of non-mountain land terrains
    -- Returns:
    --   The number of terrain types that exceed a certain percentage of total land terrain.
    local terrains = landTerrainHist.terrains;
    local totalLand = landTerrainHist.total;
    local numTerrains = 0;
    
    for i = 1, #terrains do
        local terrainCount = terrains[i];
        local terrainPct = Round(100 * terrainCount / totalLand);
        if (terrainPct > LAND_TERRAIN_EXISTENCE_MIN_PCT) then
            numTerrains = numTerrains + 1;
        end
    end
    print("Found " .. numTerrains .. " land terrain type(s) that exceed " .. 
          tostring(LAND_TERRAIN_EXISTENCE_MIN_PCT) .. " percent of total land terrain.");
    print("Max number of terrains to allow scrambled land luxuries in snow: " ..
          tostring(SCRAMBLED_SNOW_LUX_MAX_NUM_LAND_TERRAINS));
    print("Max number of terrains to allow strategic resources anywhere on land: " ..
          tostring(STRAT_RESOURCE_RELAXATION_MAX_NUM_LAND_TERRAINS));
    return numTerrains;
end

function GenerateMap()
    print("Generating GotLakes Map");
    -- This is the core map generation function.
        
    -- Shuffle map options if we haven't already.
    -- Use the TerrainBuilder RNG since that is now available.
    InitOptionsWithTerrainBuilder();
    InitHelperFlags();
    
    -- Set globals
    g_iW, g_iH = Map.GetGridSize();
    g_numTiles = g_iW * g_iH;
    
    print("Grid Size (w,h): " .. CoordString(g_iW, g_iH));

    print("Fractal flags:");
    PrintContentsOfTable(g_iFlags);
    
    print("Map.GetMapSize(): ", Map.GetMapSize());
    print("Default # players: ", GameInfo.Maps[Map.GetMapSize()].DefaultPlayers);
    
    if (not ScriptData.worldSize) then
        -- Init non-standard world-size info.
        print("Calculating custom world size info.");
        ScriptData.worldSizeInfo = CalculateWorldSizeInfo(g_iW, g_iH);
        ScriptData.worldSizeInfo.isCustom = true;
    end
    
    -- Generate most of the landmass and climate.
    GeneratePlotsWithFeatures();
    
    -- Analyze land, hills, mountains, oceans, and coast.
    AnalyzeLandmass();
    
    -- Analyze terrain and features.
    ScriptData.numTerrainTypes = CountLandTerrainTypes(AnalyzeClimate());
    
    -- Add luxuries and whatnot.
    GenerateResources();
    
    -- Assign Starting Plots.
    DetermineStartingPlots();

    -- Goodies depend on not colliding with resources or Natural Wonders, 
    -- or being placed too near to start plots.
    AddGoodies(g_iW, g_iH);
end
