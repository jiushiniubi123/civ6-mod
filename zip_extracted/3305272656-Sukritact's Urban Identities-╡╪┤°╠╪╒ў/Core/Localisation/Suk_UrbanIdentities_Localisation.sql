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
		"Sukritact's Urban Identities"
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
		"LOC_ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING_DESCRIPTION",
		"en_US",
		"Receives no movement penalty from moving in Hills."
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
		'[ICON_SUK_Region] Region tiles adjacent to a Holy Site yield +1 [ICON_Faith] Faith, +1 [ICON_Culture] Culture. Increasing to +2 [ICON_Faith] Faith, +2 [ICON_Culture] Culture if this city has a Temple. +1 [ICON_GreatProphet] Great Prophet point from this city''s Holy Site.'
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
		'This city''s Commercial Hub provides +4 [ICON_Gold] Gold and +1 [ICON_TradeRoute] Trade Route capacity if built on a [ICON_SUK_REGION] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_MOUNTAIN_PASS_FLAVOR',
		'en_US',
		'Traders from beyond the peaks inevitably pass through this humble valley.'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_NAME',
		'en_US',
		'Ocean Swells'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_DESCRIPTION',
		'en_US',
		'+2 [ICON_GOLD] Gold for each district in this city that is adjacent to Coast. +1 [ICON_AMENITIES] Amenity for each district in this city that is adjacent to Coast.'
	),
	(
		'LOC_IDENTITY_SUK_OCEAN_SWELLS_FLAVOR',
		'en_US',
		'The waves make this location less than ideal for boating, but their impressive strength is a draw for sightseers and thrillseekers.'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_NAME',
		'en_US',
		'Natural Harbor'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_DESCRIPTION',
		'en_US',
		'This city''s Harbor receives +2 [ICON_FOOD] Food for each adjacent District. +50% [ICON_PRODUCTION] Production towards the Harbor and its buildings.'
	),
	(
		'LOC_IDENTITY_SUK_NATURAL_HARBOR_FLAVOR',
		'en_US',
		'With deep and calm waters, this sheltered inlet offers a welcome respite from the ocean''s fury.'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_NAME',
		'en_US',
		'Karst Aquifers'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_DESCRIPTION',
		'en_US',
		'This city receives +2 [ICON_HOUSING] Housing, +1 [ICON_AMENITIES] Amenity. This city''s Aqueduct provides +2 [ICON_Food] Food.'
	),
	(
		'LOC_IDENTITY_SUK_KARST_AQUIFERS_FLAVOR',
		'en_US',
		'Water may be plentiful, but there''s a risk of sinkholes opening up beneath your feet.'
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
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_NAME',
		'en_US',
		'Freshwater Fishery'
	),
	(
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_DESCRIPTION',
		'en_US',
		'If built on a [ICON_SUK_REGION] Region Tile, this city''s Harbor district recieves +1 [ICON_Food] Food, +2 [ICON_Gold] Gold for every adjacent Lake tile.'
	),
	(
		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_FLAVOR',
		'en_US',
		'The aquatic life here is rich, both in quantity, and in taste!'
	),
	(
		'LOC_IDENTITY_SUK_SURFACE_DEPOSITS_NAME',
		'en_US',
		'Surface Deposits'
	),
	(
		'LOC_IDENTITY_SUK_SURFACE_DEPOSITS_DESCRIPTION',
		'en_US',
		'+15% [ICON_Production] Production towards Units in this city if it has an Encampment. This city''s Encampment provides +2 [ICON_Production] Production, +2 [ICON_Science] Science if it is built on a [ICON_Suk_Region] Region tile.'
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
		'Units gain +2 Sight while on a [ICON_Suk_Region] Region tile regardless of ownership. If this city has an Encampment on a [ICON_Suk_Region] Region tile, Ranged and Recon units trained in this city start with a free promotion that do not already start with a free promotion. This city''s Encampment provides +2 [ICON_Food] Food if built on a [ICON_Suk_Region] Region tile.'
	),
	(
		'LOC_IDENTITY_SUK_VANTAGE_POINTS_FLAVOR',
		'en_US',
		'The terrain makes it impossible for more than a small group to sneak through the region without someone noticing.'
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
		'If built on a [ICON_Suk_Region] Region tile, this city''s Industrial Zone provides +2 [ICON_Food] Food to adjacent Farms, and +2 [ICON_Production] Production to adjacent Mines. Wind Farms may be built on flat Plains and Grassland tiles in this city.'
	),
	(
		'LOC_IDENTITY_SUK_WINDY_PLAINS_FLAVOR',
		'en_US',
		'The grass is constantly swaying with the gales. Anything not tied down has a tendency to get blown away. This may be a good spot for a couple of windmills…'
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
		'This city''s Encampment receives a standard [ICON_Gold] Gold adjacency bonus from Coast, and provides +1 [ICON_TradeRoute] Trade Route Capacity if built on a [ICON_Suk_Region] Region tile.'
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
		'This city''s Theatre Square receives a +2 [ICON_Culture] Culture adjacency if built on a [ICON_Suk_Region] Region tile. Receive [ICON_Production] Production equal to the Theatre Square''s adjacency bonus if it is adjacent to an Industrial Zone.'
	),
	(
		'LOC_IDENTITY_SUK_CLAY_DEPOSITS_FLAVOR',
		'en_US',
		'High-quality and plentiful clay deposits fuel the creation of kilns to craft gorgeous works of ceramics and porcelain.'
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
-- IDENTITIES - MIGRATED FROM MORE URBAN IDENTITIES (Maple_Leaves)
--=============================================================
	(
		'LOC_IDENTITY_SUK_ML_VERTICAL_CLIMATE_NAME',
		'en_US',
		'Vertical Climate'
	),
	(
		'LOC_IDENTITY_SUK_ML_VERTICAL_CLIMATE_DESCRIPTION',
		'en_US',
		'+1 [ICON_Science] Science to unimproved tiles in this [ICON_SUK_REGION] Region, increasing to +2 after researching the Scientific Theory technology. +30% [ICON_Production] Production towards Campus in this city.'
	),
	(
		'LOC_IDENTITY_SUK_ML_VERTICAL_CLIMATE_FLAVOR',
		'en_US',
		'Spring lies at the mountain''s base, winter at its peak. Every inch of elevation here holds a distinct climate and life.'
	),
	(
		'LOC_IDENTITY_SUK_ML_MONSOON_VALLEY_NAME',
		'en_US',
		'Monsoon Valley'
	),
	(
		'LOC_IDENTITY_SUK_ML_MONSOON_VALLEY_DESCRIPTION',
		'en_US',
		'+2 [ICON_Food] Food to Jungle tiles in this [ICON_SUK_REGION] Region. +2 [ICON_Gold] Gold to Plantations in this [ICON_SUK_REGION] Region.'
	),
	(
		'LOC_IDENTITY_SUK_ML_MONSOON_VALLEY_FLAVOR',
		'en_US',
		'The monsoon breezes through, whispering through the rainforest. Every leaf breathes, every fruit sings.'
	),
	(
		'LOC_IDENTITY_SUK_ML_YEW_GROVE_NAME',
		'en_US',
		'Yew Grove'
	),
	(
		'LOC_IDENTITY_SUK_ML_YEW_GROVE_DESCRIPTION',
		'en_US',
		'+2 [ICON_Production] Production to Lumber Mills in this [ICON_SUK_REGION] Region. +30% [ICON_Production] Production towards Ancient to Medieval ranged units in this city.'
	),
	(
		'LOC_IDENTITY_SUK_ML_YEW_GROVE_FLAVOR',
		'en_US',
		'The yew trees stand tall and straight, their arrows swift as the wind. The timber from these trees once forged countless divine bows and mighty crossbows.'
	),
	(
		'LOC_IDENTITY_SUK_ML_OASIS_TRADING_POST_NAME',
		'en_US',
		'Oasis Trading Post'
	),
	(
		'LOC_IDENTITY_SUK_ML_OASIS_TRADING_POST_DESCRIPTION',
		'en_US',
		'Commercial Hub of this city receives +4 [ICON_Gold] Gold adjacency bonus from Oasis. +1 [ICON_TradeRoute] Trade Route capacity if this city has a Commercial Hub.'
	),
	(
		'LOC_IDENTITY_SUK_ML_OASIS_TRADING_POST_FLAVOR',
		'en_US',
		'In the desert, there lies a clear spring. For merchants and travelers who arrive here, it marks both the end of their journey and the beginning of a new one.'
	),
	(
		'LOC_ID_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_GOLD',
		'en_US',
		'+{1_num} [ICON_Gold] Gold from the adjacent Oasis {1_Num : plural 1?tile; other?tiles;}.'
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