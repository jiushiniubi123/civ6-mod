--=============================================================
-- LocalizedText
--=============================================================
INSERT OR REPLACE INTO LocalizedText
	(Tag,								Language,		Text)
VALUES
--=============================================================
-- Game Mode
--=============================================================
	(
		"LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME",
		"en_US",
		"Sukritact’s Urban Identities"
	),
	(
		"LOC_GAMEMODE_SUK_URBANIDENTITIES_DESCRIPTION",
		"en_US",
		"This game mode aims to make cities more than just a collection of districts and buildings; giving character and quirks to make them unique parts of your empire.[NEWLINE][NEWLINE]Cities can now gain [ICON_SUK_IDENTITY] Identities, granting distinct traits and bonuses. Diverse geographical [ICON_SUK_REGION] Regions dot the map, that award [ICON_SUK_IDENTITY] Identities to the first City founded there by a Civilization. Where will you found your greatest Metropolises? How will they develop, and what legacies will they leave? These are the questions to be answered as you play with Urban Identities!"
	),
	--=============================================================
	--=============================================================
	-- Settings
	(
		"LOC_GAMEMODE_SUK_URBANIDENTITIES_REGIONCOVERAGE_NAME",
		"en_US",
		"Region Coverage"
	),
	(
		"LOC_GAMEMODE_SUK_URBANIDENTITIES_REGIONCOVERAGE_DESCRIPTION",
		"en_US",
		"Set the maximum percentage of the map that can be covered by [ICON_SUK_REGION] Regions."
	),
--=============================================================
-- UI
--=============================================================
	(
		"LOC_SUK_REGIONS_CLAIMED",
		"en_US",
		"Claimed {1} [ICON_SUK_REGION] ({2})"
	),
	(
		"LOC_SUK_REGIONS_UNCLAIMED",
		"en_US",
		"[COLOR_RED]Unclaimed {1} [ICON_SUK_REGION][ENDCOLOR]"
	),
	(
		"LOC_HUD_TOGGLE_SUK_REGIONS",
		"en_US",
		"Show Regions"
	),
	(
		"LOC_HUD_TOGGLE_SUK_REGIONS_TOOLTIP",
		"en_US",
		"Toggle [ICON_SUK_REGION] Region Labels and Borders"
	),
	(
		"LOC_SUK_SCREENSHOT_MODE_REGION_BANNER_NAME",
		"en_US",
		"Hide Regions Banners"
	),
	(
		"LOC_SUK_SCREENSHOT_MODE_REGION_BANNER_DESC",
		"en_US",
		"Hide Regions Banners in Screenshot Mode."
	),
--=============================================================
-- UI - Special
--=============================================================
	(
		"LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_NAME",
		"en_US",
		"{LOC_IDENTITY_SUK_IMPACT_STRUCTURES_NAME}"
	),
	(
		"LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_DESCRIPTION",
		"en_US",
		"+5 Religious Strength from {LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_NAME}."
	),
	(
		"LOC_IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT_MODIFIER_DESCRIPTION",
		"en_US",
		"+{1_Value} Religious Strength from {LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_NAME}"
	),
	(
		"LOC_ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING_DESCRIPTION",
		"en_US",
		"Receives no movement penalty from moving in Hills."
	),
	(
		"LOC_IDENTITY_SUK_PUNA_GRASSLANDS_HILLS",
		"en_US",
		"+{1_num} [ICON_GOLD] Gold from the adjacent Hill {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_FRESHWATER_FISHERY_FOOD",
		"en_US",
		"+{1_num} [ICON_Food] Food from the adjacent Lake {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_FRESHWATER_FISHERY_GOLD",
		"en_US",
		"+{1_num} [ICON_GOLD] Gold from the adjacent Lake {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_DEFENSIBLE_CLIFFS_GOLD",
		"en_US",
		"+{1_num} [ICON_GOLD] Gold from the adjacent Coast {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_GEYSER_FIELD_CLTURE",
		"en_US",
		"+{1_num} [ICON_Culture] Culture from the adjacent Geothermal Fissure {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_BIRD_SANCTUARY_MARSH_SCIENCE",
		"en_US",
		"+{1_num} [ICON_Science] Science from the adjacent Marsh {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_BIRD_SANCTUARY_WOODS_SCIENCE",
		"en_US",
		"+{1_num} [ICON_Science] Science from the adjacent Woods {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_ALTITUDE_TRAINING_FOOD",
		"en_US",
		"+{1_num} [ICON_Food] Food from the adjacent Mountain {1_Num : plural 1?tile; other?tiles;}."
	),
	(
		"LOC_IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY",
		"en_US",
		"+{1_num} [ICON_Food] Food from the adjacent districts."
	);
--=============================================================
-- REGIONS
-- % Automated Text Begins Here %
--=============================================================
	INSERT INTO LocalizedText (Tag, Language, Text) VALUES
	(
		'LOC_REGION_SUK_FOREST_NAME',
		'en_US',
		'Forest Region'
	),
	(
		'LOC_REGION_SUK_JUNGLE_NAME',
		'en_US',
		'Jungle Region'
	),
	(
		'LOC_REGION_SUK_CLIFFS_NAME',
		'en_US',
		'Cliffs Region'
	),
	(
		'LOC_REGION_SUK_OASIS_NAME',
		'en_US',
		'Oasis Region'
	),
	(
		'LOC_REGION_SUK_MOUNTAINS_NAME',
		'en_US',
		'Mountain Region'
	),
	(
		'LOC_REGION_SUK_KELP_NAME',
		'en_US',
		'Kelp Forest Region'
	),
	(
		'LOC_REGION_SUK_REEF_NAME',
		'en_US',
		'Reef Region'
	),
	(
		'LOC_REGION_SUK_HILLS_NAME',
		'en_US',
		'Hills Region'
	),
	(
		'LOC_REGION_SUK_PLAINS_NAME',
		'en_US',
		'Plains Region'
	),
	(
		'LOC_REGION_SUK_GEOTHERMAL_NAME',
		'en_US',
		'Geothermal Region'
	),
	(
		'LOC_REGION_SUK_MARSH_NAME',
		'en_US',
		'Marsh Region'
	),
	(
		'LOC_REGION_SUK_LAKE_NAME',
		'en_US',
		'Lake Region'
	),
	(
		'LOC_REGION_SUK_DESERT_NAME',
		'en_US',
		'Desert Region'
	),
	(
		'LOC_REGION_SUK_RIVER_NAME',
		'en_US',
		'River Region'
	);
--=============================================================
-- IDENTITIES - REGIONAL
--=============================================================
	INSERT INTO LocalizedText (Tag, Language, Text) VALUES
	(
		'LOC_IDENTITY_SUK_HARDWOOD_TREES_NAME',
		'en_US',
		'Hardwood Trees'
	),
	(
		'LOC_IDENTITY_SUK_HARDWOOD_TREES_DESCRIPTION',
		'en_US',
		'This city receives +1 [ICON_PRODUCTION] Production per game era. Lumber Mills in this [ICON_SUK_REGION] Region provide +2 [ICON_PRODUCTION] Production, +1 [ICON_GOLD] Gold when adjacent to the City Center or an Industrial Zone.'
	),
	(
		'LOC_IDENTITY_SUK_HARDWOOD_TREES_FLAVOR',
		'en_US',
		'The wood from this region is particularly suited for construction work, and is highly coveted.'
	),
	(
		'LOC_IDENTITY_SUK_UNDERGROUND_AQUIFERS_NAME',
		'en_US',
		'Underground Aquifers'
	),
	(
		'LOC_IDENTITY_SUK_UNDERGROUND_AQUIFERS_DESCRIPTION',
		'en_US',
		'+2 [ICON_HOUSING] Housing in this City. Farms can be built on Flat Desert tiles in this city. Farms and Plantations on Desert tiles (non-Floodplains) yield +1 [ICON_Food] Food, +1 [ICON_GOLD] Gold in this city.'
	),
	(
		'LOC_IDENTITY_SUK_UNDERGROUND_AQUIFERS_FLAVOR',
		'en_US',
		'Water wells to the surface in unexpected places.'
	),
	(
		'LOC_IDENTITY_SUK_IDYLLIC_SCENERY_NAME',
		'en_US',
		'Idyllic Scenery'
	),
	(
		'LOC_IDENTITY_SUK_IDYLLIC_SCENERY_DESCRIPTION',
		'en_US',
		'+3 [ICON_AMENITIES] Amenities in this city. City Parks on a [ICON_SUK_REGION] Region tile yield +1 [ICON_Food] Food, +1 [ICON_Culture] Culture. Allows City Parks to be built in this city (requires Games and Recreation).'
	),
	(
		'LOC_IDENTITY_SUK_IDYLLIC_SCENERY_FLAVOR',
		'en_US',
		'The view brings peace and comfort to weary souls.'
	),
	(
		'LOC_IDENTITY_SUK_OPEN_SKIES_NAME',
		'en_US',
		'Open Skies'
	),
	(
		'LOC_IDENTITY_SUK_OPEN_SKIES_DESCRIPTION',
		'en_US',
		'[ICON_SUK_Region] Region tiles adjacent to a Campus yield +1 [ICON_SCIENCE] Science. Increasing to +2 [ICON_SCIENCE] Science if this city has a University.'
	),
	(
		'LOC_IDENTITY_SUK_OPEN_SKIES_FLAVOR',
		'en_US',
		'With neither trees nor mountains, one gets a breathtaking view of the night skies.'
	),
	(
		'LOC_IDENTITY_SUK_PROPHETIC_VISIONS_NAME',
		'en_US',
		'Prophetic Visions'
	),
	(
		'LOC_IDENTITY_SUK_PROPHETIC_VISIONS_DESCRIPTION',
		'en_US',
		'[ICON_SUK_Region] Region tiles adjacent to a Holy Site yield +2 [ICON_Faith] Faith. Increasing to +3 [ICON_Faith] Faith. if this city has a Temple. +1 [ICON_GreatProphet] Great Prophet point from this city’s Holy Site.'
	),
	(
		'LOC_IDENTITY_SUK_PROPHETIC_VISIONS_FLAVOR',
		'en_US',
		'For some reason, holy men say their divination works better here. Perhaps something in the air?'
	),
	(
		'LOC_IDENTITY_SUK_MOUNTAIN_PASS_NAME',
		'en_US',
		'Mountain Pass'
	),
	(
		'LOC_IDENTITY_SUK_MOUNTAIN_PASS_DESCRIPTION',
		'en_US',
		'This city’s Commercial Hub provides +4 [ICON_Gold] Gold and +1 [ICON_TradeRoute] Trade Route capacity if built on a [ICON_SUK_REGION] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_MOUNTAIN_PASS_FLAVOR',
		'en_US',
		'Traders from beyond the peaks inevitably pass through this humble valley.'
	),
	(
		'LOC_IDENTITY_SUK_RICH_SOIL_NAME',
		'en_US',
		'Rich Soil'
	),
	(
		'LOC_IDENTITY_SUK_RICH_SOIL_DESCRIPTION',
		'en_US',
		'There is a 33% chance a farmable Bonus Resource spawns when you first build a Farm on each of the [ICON_SUK_REGION] Region’s tiles in this city.'
	),
	(
		'LOC_IDENTITY_SUK_RICH_SOIL_FLAVOR',
		'en_US',
		'Berries, vegetables, grains. These all thrive in the dark loamy soil.'
	),
	(
		'LOC_IDENTITY_SUK_MASSIVE_TREES_NAME',
		'en_US',
		'Massive Trees'
	),
	(
		'LOC_IDENTITY_SUK_MASSIVE_TREES_DESCRIPTION',
		'en_US',
		'-15% [ICON_Production] Production towards districts in this city. This city’s Holy Site and Theatre Square each provide +3 of the appropriate yield if built on a [ICON_Suk_Region] Region Tile, and provide +2 [ICON_GreatPerson] Great People Points of their type if that tile also has Breathtaking appeal.'
	),
	(
		'LOC_IDENTITY_SUK_MASSIVE_TREES_FLAVOR',
		'en_US',
		'You can’t help but feel awe and wonder at the truly incredible heights these trees reach.'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_NAME',
		'en_US',
		'Ocean Swells'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_DESCRIPTION',
		'en_US',
		'-50% [ICON_PRODUCTION] Production towards the Harbor and its buildings. +1 [ICON_AMENITIES] Amenity, +3 [ICON_GOLD] for each district in this city that is adjacent to Coast.'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_FLAVOR',
		'en_US',
		'The waves make this location less than ideal for boating, but their impressive strength is a draw for sightseers and thrillseekers.'
	),
	(
		'LOC_IDENTITY_SUK_FOSSIL_DEPOSITS_NAME',
		'en_US',
		'Fossil Deposits'
	),
	(
		'LOC_IDENTITY_SUK_FOSSIL_DEPOSITS_DESCRIPTION',
		'en_US',
		'This city receives +1 [ICON_Science] Science per game era. [ICON_SUK_REGION] Region Tiles provide +2 [ICON_Science] Science, +2 [ICON_Culture] Culture if this city has both a University and an Archaeological Museum.'
	),
	(
		'LOC_IDENTITY_SUK_FOSSIL_DEPOSITS_FLAVOR',
		'en_US',
		'One can find strange bones that whisper of a distant and alien past.'
	),
	(
		'LOC_IDENTITY_SUK_REJUVENATING_SPRINGS_NAME',
		'en_US',
		'Rejuvenating Springs'
	),
	(
		'LOC_IDENTITY_SUK_REJUVENATING_SPRINGS_DESCRIPTION',
		'en_US',
		'This city receives +1 [ICON_Housing] Housing, +1 [ICON_Amenities] Amenity. If built on a [ICON_Suk_Region] Region tile, this city’s Entertainment Complex provides +1 [ICON_Housing] Housing, +1 [ICON_Amenities] Amenities to all cities within 6 tiles, as well as +2 [ICON_Food] Food on adjacent tiles.'
	),
	(
		'LOC_IDENTITY_SUK_REJUVENATING_SPRINGS_FLAVOR',
		'en_US',
		'Weary travelers soak in these waters, which are said to have restorative properties.'
	),
	(
		'LOC_IDENTITY_SUK_SCENIC_VISTAS_NAME',
		'en_US',
		'Scenic Vistas'
	),
	(
		'LOC_IDENTITY_SUK_SCENIC_VISTAS_DESCRIPTION',
		'en_US',
		'-15% [ICON_Production] Production towards districts in this city. [ICON_Suk_Region] Region Tiles with Breathtaking Appeal yield +2 [ICON_Culture] Culture, +2 [ICON_Gold] Gold. If built on a [ICON_Suk_Region] Region tile, this city’s Theatre Square receives +3 [ICON_Culture] Culture, and provides +1 Appeal to all tiles in the city.'
	),
	(
		'LOC_IDENTITY_SUK_SCENIC_VISTAS_FLAVOR',
		'en_US',
		'From these sheer cliffs, the world unfurls like a map beneath your feet.'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_NAME',
		'en_US',
		'Natural Harbor'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_DESCRIPTION',
		'en_US',
		'This city’s Harbor receives +2 [ICON_FOOD] Food for each adjacent District. +50% [ICON_PRODUCTION] Production towards the Harbor and its buildings.'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_FLAVOR',
		'en_US',
		'With deep and calm waters, this sheltered inlet offers a welcome respite from the ocean’s fury.'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_NAME',
		'en_US',
		'Karst Aquifers'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_DESCRIPTION',
		'en_US',
		'-30% [ICON_Production] Production towards districts in this city. This city and your other cities within 6 tiles receive +2 [ICON_Housing] Housing, +1 [ICON_AMENITIES] Amenity. Those cities also receive +4 [ICON_Food] Food if they have an Aqueduct.'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_FLAVOR',
		'en_US',
		'Water may be plentiful, but there’s a risk of sinkholes opening up beneath your feet.'
	),
	(
		'LOC_IDENTITY_SUK_STEEP_SLOPES_NAME',
		'en_US',
		'Steep Slopes'
	),
	(
		'LOC_IDENTITY_SUK_STEEP_SLOPES_DESCRIPTION',
		'en_US',
		'-30% [ICON_Production] Production towards districts in this city. Districts in this city get +2 of their adjacency bonus if built on a [ICON_Suk_Region] Region Tile.'
	),
	(
		'LOC_IDENTITY_SUK_STEEP_SLOPES_FLAVOR',
		'en_US',
		'The dramatic changes in slope make for some difficult but inspired architecture.'
	),
	(
		'LOC_IDENTITY_SUK_PUNA_GRASSLANDS_NAME',
		'en_US',
		'Puna Grasslands'
	),
	(
		'LOC_IDENTITY_SUK_PUNA_GRASSLANDS_DESCRIPTION',
		'en_US',
		'-1 [ICON_Food] Food from Farms and +2 [ICON_Food] Food from Pastures in this city.[NEWLINE][NEWLINE]This city’s Commercial Hub receives +1 [ICON_Gold] Gold from every adjacent Hill and Mountain, and will also provide [ICON_Food] Food equivalent to its adjacency bonus if built on a [ICON_Suk_Region] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_PUNA_GRASSLANDS_FLAVOR',
		'en_US',
		'These high-altitude grasslands aren’t the best for agriculture, but the wool from from animals that graze here is highly valued.'
	),
	(
		'LOC_IDENTITY_SUK_FOG_DESERTS_NAME',
		'en_US',
		'Fog Deserts'
	),
	(
		'LOC_IDENTITY_SUK_FOG_DESERTS_DESCRIPTION',
		'en_US',
		'+2 [ICON_HOUSING] Housing in this City. +2 [ICON_FOOD] Food from Improved [ICON_SUK_REGION] Region tiles. +1 [ICON_HOUSING] from Districts on  [ICON_SUK_REGION] Region Tiles.'
	),
	(
		'LOC_IDENTITY_SUK_FOG_DESERTS_FLAVOR',
		'en_US',
		'Rolling clouds of fog from moister areas bring in water that can be trapped by both the local flora and humans alike.'
	),
	(
		'LOC_IDENTITY_SUK_CLOUD_FORESTS_NAME',
		'en_US',
		'Cloud Forests'
	),
	(
		'LOC_IDENTITY_SUK_CLOUD_FORESTS_DESCRIPTION',
		'en_US',
		'-1 [ICON_Production] Production from Lumbermills in this city. Unimproved [ICON_Suk_Region] Region tiles in this city provide +1 [ICON_Faith] Faith with Mysticism, +1 [ICON_Culture] Culture with Drama and Poetry, and +1 [ICON_Science] Science with Education. These yields are doubled after discovering Conservation.'
	),
	(
		'LOC_IDENTITY_SUK_CLOUD_FORESTS_FLAVOR',
		'en_US',
		'These woods are notable for the dense clouds and even denser trees, but also the capitvating amount of life one can find here.'
	),
	(
		'LOC_IDENTITY_SUK_ALLUVIAL_PLACER_NAME',
		'en_US',
		'Alluvial Placer'
	),
	(
		'LOC_IDENTITY_SUK_ALLUVIAL_PLACER_DESCRIPTION',
		'en_US',
		'Mines adjacent to a river yield +2 [ICON_GOLD] Gold in this city. Mines on a [ICON_SUK_REGION] Region tile yield +1 [ICON_PRODUCTION] Production.'
	),
	(
		'LOC_IDENTITY_SUK_ALLUVIAL_PLACER_FLAVOR',
		'en_US',
		'Carried by the current and mixed in with the sediment, are precious minerals and metals.'
	),
	(
		'LOC_IDENTITY_SUK_SPAWNING_GROUNDS_NAME',
		'en_US',
		'Spawning Grounds'
	),
	(
		'LOC_IDENTITY_SUK_SPAWNING_GROUNDS_DESCRIPTION',
		'en_US',
		'[ICON_SUK_REGION] Region tiles provide +1 [ICON_FOOD] Food. An additional +1 [ICON_CULTURE] Culture if this city has a Theater Square, and an addtional +1 [ICON_FOOD] Food, +1 [ICON_CULTURE] Culture if the Theater Square is next to a river. All bonuses are lost if this city has a Dam or Industrial Zone.'
	),
	(
		'LOC_IDENTITY_SUK_SPAWNING_GROUNDS_FLAVOR',
		'en_US',
		'Fish migrate up these waters to spawn their eggs, and will do so as long as the streams stay clear and clean.'
	),
	(
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_NAME',
		'en_US',
		'Freshwater Fishery'
	),
	(
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_DESCRIPTION',
		'en_US',
		'If built on a [ICON_SUK_REGION] Region Tile, this city’s Harbor district recieves +1 [ICON_Food] Food, +2 [ICON_Gold] Gold for every adjacent Lake tile.'
	),
	(
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_FLAVOR',
		'en_US',
		'The aquatic life here is rich, both in quantity, and in taste!'
	),
	(
		'LOC_IDENTITY_SUK_TOWER_KARST_NAME',
		'en_US',
		'Tower Karst'
	),
	(
		'LOC_IDENTITY_SUK_TOWER_KARST_DESCRIPTION',
		'en_US',
		'+1 [ICON_Culture] Culture on unimproved [ICON_Suk_Region] Region tiles. An additional +1 [ICON_Culture] Culture if the tile is adjacent to a Farm, and +1 [ICON_Culture] Culture if the tile has Breathtaking appeal. The tiles also provide [ICON_Gold] Gold equivalent to the [ICON_Culture] Culture bonus if this city has a Theater Square.'
	),
	(
		'LOC_IDENTITY_SUK_TOWER_KARST_FLAVOR',
		'en_US',
		'Awesome towers of rock jut out dramatically from these hills—a truly inspiring sight.'
	),
	(
		'LOC_IDENTITY_SUK_SURFACE_DEPOSITS_NAME',
		'en_US',
		'Surface Deposits'
	),
	(
		'LOC_IDENTITY_SUK_SURFACE_DEPOSITS_DESCRIPTION',
		'en_US',
		'+15% [ICON_Production] Production towards Units in this city if it has an Encampment. This city’s Encampment provides +2 [ICON_Production] Production, +2 [ICON_Science] Science if it is built on a [ICON_Suk_Region] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_SURFACE_DEPOSITS_FLAVOR',
		'en_US',
		'While maybe not enough for heavy industry, there is enough metal here for household tools, and perhaps… some horseshoes and weapons?'
	),
	(
		'LOC_IDENTITY_SUK_VANTAGE_POINTS_NAME',
		'en_US',
		'Vantage Points'
	),
	(
		'LOC_IDENTITY_SUK_VANTAGE_POINTS_DESCRIPTION',
		'en_US',
		'Units gain +2 Sight while on a [ICON_Suk_Region] Region tile regardless of ownership. If this city has an Encampment on a [ICON_Suk_Region] Region tile, Ranged and Recon units trained in this city start with a free promotion that do not already start with a free promotion.'
	),
	(
		'LOC_IDENTITY_SUK_VANTAGE_POINTS_FLAVOR',
		'en_US',
		'The terrain makes it impossible for more than a small group to sneak through the region without someone noticing.'
	),
	(
		'LOC_IDENTITY_SUK_GEYSER_FIELD_NAME',
		'en_US',
		'Geyser Field'
	),
	(
		'LOC_IDENTITY_SUK_GEYSER_FIELD_DESCRIPTION',
		'en_US',
		'-1 [ICON_Science] Science, +1 [ICON_Culture] Culture from Geothermal Fissures in the [ICON_Suk_Region] Region. This city’s Theater Square gains a major [ICON_Culture] Culture adjacency from Geothermal Fissures. After researching Conservation, an additional +1 [ICON_Culture] Culture, +2 [ICON_Food] Food from Geothermal Fissures, and Districts adjacent to a Geothermal Fissure provide +4 [ICON_Tourism] Tourism in this city.[NEWLINE][NEWLINE]All bonuses are lost if this city has a Campus.'
	),
	(
		'LOC_IDENTITY_SUK_GEYSER_FIELD_FLAVOR',
		'en_US',
		'With their regular and impressive jets of water, these geysers are both testament to the marvel that are geothermal forces, and a draw to tourists.'
	),
	(
		'LOC_IDENTITY_SUK_OMINOUS_FOREST_NAME',
		'en_US',
		'Ominous Forest'
	),
	(
		'LOC_IDENTITY_SUK_OMINOUS_FOREST_DESCRIPTION',
		'en_US',
		'-1 [ICON_Amenities] Amenities in this city. +1 [ICON_Culture] Culture, +1 [ICON_Faith] Faith from [ICON_Suk_Region] Region tiles.[NEWLINE][NEWLINE]An additional +1 [ICON_Culture] Culture, +1 [ICON_Faith] Faith from [ICON_Suk_Region] Region tiles if this city has a Holy Site.[NEWLINE]An additional +1 [ICON_Culture] Culture, +1 [ICON_Faith] Faith from [ICON_Suk_Region] Region tiles if this city has a Theatre Square.[NEWLINE][NEWLINE]All bonuses and penalties are lost if this city has a Campus.'
	),
	(
		'LOC_IDENTITY_SUK_OMINOUS_FOREST_FLAVOR',
		'en_US',
		'Dark and foreboding, legends abound of mysterious things hiding between these trees. Is there something there? Or merely a trick of the light…'
	),
	(
		'LOC_IDENTITY_SUK_STURDY_REEDS_NAME',
		'en_US',
		'Sturdy Reeds'
	),
	(
		'LOC_IDENTITY_SUK_STURDY_REEDS_DESCRIPTION',
		'en_US',
		'Lake tiles in this [ICON_Suk_Region] Region gain +1 [ICON_Production] Production if within two tiles of a City Center or Commercial Hub. This increases to +2 [ICON_Production]Production if within range of both.'
	),
	(
		'LOC_IDENTITY_SUK_STURDY_REEDS_FLAVOR',
		'en_US',
		'The ponds and coasts in the area nurture a particularly sturdy type of reed that is particularly suited for craftwork and construction.'
	),
	(
		'LOC_IDENTITY_SUK_WINDY_PLAINS_NAME',
		'en_US',
		'Windy Plains'
	),
	(
		'LOC_IDENTITY_SUK_WINDY_PLAINS_DESCRIPTION',
		'en_US',
		'If built on a [ICON_Suk_Region] Region tile, this city’s Industrial Zone provides +2 [ICON_Food] Food to adjacent Farms, and +2 [ICON_Production] Production to adjacent Mines. Wind Farms may be built on flat Plains and Grassland tiles in this city.'
	),
	(
		'LOC_IDENTITY_SUK_WINDY_PLAINS_FLAVOR',
		'en_US',
		'The grass is constantly swaying with the gales. Anything not tied down has a tendency to get blown away. This may be a good spot for a couple of windmills…'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_OUTPOST_NAME',
		'en_US',
		'Natural Outpost'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_OUTPOST_DESCRIPTION',
		'en_US',
		'This city’s Encampment provides +2 [ICON_TradeRoute] Trade Route capacity if built on a [ICON_Suk_Region] Region tile. All [ICON_TradeRoute] Trade Routes from this city yield +2 [ICON_Food] Food, +3 [ICON_Gold] Gold.'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_OUTPOST_FLAVOR',
		'en_US',
		'Lonely, dangerous, and remote; there’s no reason to ever come here, but you do have to pass through the area to get anywhere else.'
	),
	(
		'LOC_IDENTITY_SUK_UNDERSEA_FORMATIONS_NAME',
		'en_US',
		'Undersea Formations'
	),
	(
		'LOC_IDENTITY_SUK_UNDERSEA_FORMATIONS_DESCRIPTION',
		'en_US',
		'Reefs on [ICON_Suk_Region] Region tiles gain +2 [ICON_Faith] Faith if within 3 tiles of a Holy Site, +2 [ICON_Culture] Culture if within 3 tiles of a Theatre Square, and +1 [ICON_Science] Science if within 3 tiles of a Campus. All bonuses are lost if this city has a Harbor.'
	),
	(
		'LOC_IDENTITY_SUK_UNDERSEA_FORMATIONS_FLAVOR',
		'en_US',
		'Coral clings to wondrous rock formations beneath the surface, in a beautiful, yet delicate, display.'
	),
	(
		'LOC_IDENTITY_SUK_BIRD_SANCTUARY_NAME',
		'en_US',
		'Bird Sanctuary'
	),
	(
		'LOC_IDENTITY_SUK_BIRD_SANCTUARY_DESCRIPTION',
		'en_US',
		'+1 [ICON_Amenities] Amenity in this city. The Campus receives a standard adjacency bonus from Marshes and a minor adjacency from Woods in this city. The Entertainment Complex provides +2 [ICON_Amenities]Amenities in this city if built on a [ICON_Suk_Region] Region tile. All bonuses are lost if this city has an Industrial Zone.'
	),
	(
		'LOC_IDENTITY_SUK_BIRD_SANCTUARY_FLAVOR',
		'en_US',
		'A stunning variety of birds live in the area. Their calls are a veritable cacophony in the mornings, but a somewhat pleasant one.'
	),
	(
		'LOC_IDENTITY_SUK_ALTITUDE_TRAINING_NAME',
		'en_US',
		'Altitude Training'
	),
	(
		'LOC_IDENTITY_SUK_ALTITUDE_TRAINING_DESCRIPTION',
		'en_US',
		'The City Centre receives a standard [ICON_Food] Food adjacency bonus from Mountains. If this city has an Aqueduct or an Encampment, all units trained here receive no [ICON_Movement] Movement penalty from moving in Hills.'
	),
	(
		'LOC_IDENTITY_SUK_ALTITUDE_TRAINING_FLAVOR',
		'en_US',
		'The incredible altitudes require people who live here to physically adapt to the low oxygen environment.'
	),
	(
		'LOC_IDENTITY_SUK_DEFENSIBLE_CLIFFS_NAME',
		'en_US',
		'Defensible Cliffs'
	),
	(
		'LOC_IDENTITY_SUK_DEFENSIBLE_CLIFFS_DESCRIPTION',
		'en_US',
		'This city’s Encampment receives a standard [ICON_Gold] Gold adjacency bonus from Coast, and provides +1 [ICON_TradeRoute] Trade Route Capacity if built on a [ICON_Suk_Region] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_DEFENSIBLE_CLIFFS_FLAVOR',
		'en_US',
		'These cliffs overlook a stretch of water that will prove vital to maritime commerce. It would behoove those living here to secure them.'
	),
	(
		'LOC_IDENTITY_SUK_CLAY_DEPOSITS_NAME',
		'en_US',
		'Clay Deposits'
	),
	(
		'LOC_IDENTITY_SUK_CLAY_DEPOSITS_DESCRIPTION',
		'en_US',
		'This city’s Theatre Square receives a +2 [ICON_Culture] Culture adjacency if built on a [ICON_Suk_Region] Region tile. Receive [ICON_Production] Production equal to the Theatre Square’s adjacency bonus if it is adjacent to an Industrial Zone.'
	),
	(
		'LOC_IDENTITY_SUK_CLAY_DEPOSITS_FLAVOR',
		'en_US',
		'High-quality and plentiful clay deposits fuel the creation of kilns to craft gorgeous works of ceramics and porcelain.'
	),
	(
		'LOC_IDENTITY_SUK_IMPACT_STRUCTURES_NAME',
		'en_US',
		'Impact Structures'
	),
	(
		'LOC_IDENTITY_SUK_IMPACT_STRUCTURES_DESCRIPTION',
		'en_US',
		'-15% [ICON_Production] Production towards districts in this city.[NEWLINE][NEWLINE]If this city has a Holy Site but not a Space Port. Religious Units trained here gain +5 [ICON_Religion] Religious Strength in Theological Combat.[NEWLINE][NEWLINE]If this city has a Space Port but not a Holy Site. +30% [ICON_Production] Production towards all space-program projects in the city.'
	),
	(
		'LOC_IDENTITY_SUK_IMPACT_STRUCTURES_FLAVOR',
		'en_US',
		'A sign of divine fury? Or just a really big rock happening to collide with Earth? In either case the ground bears the lasting scars.'
	),
	(
		'LOC_IDENTITY_SUK_IGNEOUS_INTRUSION_NAME',
		'en_US',
		'Igneous Intrusion'
	),
	(
		'LOC_IDENTITY_SUK_IGNEOUS_INTRUSION_DESCRIPTION',
		'en_US',
		'Quarries may be built on Hills in this city, and Quarries on a [ICON_Suk_Region] Region tile receive +1 [ICON_Production] Production. +15% [ICON_Production] Production towards Wonders in this city if it has an Industrial Zone on a [ICON_Suk_Region] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_IGNEOUS_INTRUSION_FLAVOR',
		'en_US',
		'Formed from magma cooled beneath the earth, much of the rock that constitute these hills is excellent for monumental construction.'
	);
--=============================================================
-- % Automated Text Ends Here %
--=============================================================
	INSERT INTO LocalizedText
		(
			Tag,
			Language,
			Text
		)
	SELECT
			'LOC_IDENTITY_SUK_STURDY_REEDS_DESCRIPTION_OCEANS',
			'en_US',
			REPLACE(Text, 'Lake tiles', 'Lake and Kelp Forest tiles')
	FROM LocalizedText WHERE
		Tag = 'LOC_IDENTITY_SUK_STURDY_REEDS_DESCRIPTION'
		AND Language = 'en_US';
--=============================================================
--=============================================================
