--========================================================================================================================
													-- DynamicModifiers
--========================================================================================================================
-- Prep
--------------------------------------------------------------------------------------------------------------------------
	-- Types
	--------------------------------------------------------------------
		INSERT OR IGNORE INTO Types
				(Type,																	Kind)
		VALUES	('MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',							'KIND_MODIFIER'),
				('MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',				'KIND_MODIFIER'),
				('MODIFIER_SUK_CITY_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',	'KIND_MODIFIER'),
				('MODIFIER_SUK_SINGLE_CITY_DISTRICT_ADJACENCY',							'KIND_MODIFIER'),
				('MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',							'KIND_MODIFIER'),
				('MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN',			'KIND_MODIFIER'),
				('MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',			'KIND_MODIFIER'),
				('MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',				'KIND_MODIFIER'),
				('MODIFIER_SUK_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION',					'KIND_MODIFIER'),
				('MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',					'KIND_MODIFIER');
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		INSERT OR IGNORE INTO DynamicModifiers
			(
				ModifierType,
				CollectionType,
				EffectType
			)
		VALUES
			(
				'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
				'COLLECTION_CITY_DISTRICTS',
				'EFFECT_ATTACH_MODIFIER'
			),
			(
				'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',
				'COLLECTION_CITY_DISTRICTS',
				'EFFECT_ADJUST_DISTRICT_BASE_YIELD_CHANGE'
			),
			(
				'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',
				'COLLECTION_CITY_DISTRICTS',
				'EFFECT_ADJUST_DISTRICT_YIELD_BASED_ON_ADJACENCY_BONUS'
			),
			(
				'MODIFIER_SUK_SINGLE_CITY_DISTRICT_ADJACENCY',
				'COLLECTION_OWNER',
				'EFFECT_DISTRICT_ADJACENCY'
			),
			(
				'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',
				'COLLECTION_OWNER',
				'EFFECT_TERRAIN_ADJACENCY'
			),
			(
				'MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN',
				'COLLECTION_OWNER',
				'EFFECT_ADJUST_IMPROVEMENT_VALID_TERRAIN'
			),
			(
				'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
				'COLLECTION_CITY_DISTRICTS',
				'EFFECT_ADJUST_DISTRICT_YIELD_CHANGE'
			),
			(
				'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',
				'COLLECTION_CITY_DISTRICTS',
				'EFFECT_ADJUST_TRADE_ROUTE_CAPACITY'
			),
			(
				'MODIFIER_SUK_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION',
				'COLLECTION_OWNER',
				'EFFECT_ADJUST_BUILDING_PRODUCTION'
			),
			(
				'MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',
				'COLLECTION_OWNER',
				'EFFECT_ADJUST_DISTRICT_PRODUCTION'
			);
--==========================================================================================================================
-- Yield per Era
--==========================================================================================================================
	-- PREPARATION
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "Suk_Identities_YieldPerEra"(
			"EraType"			TEXT,
			"YieldType"			TEXT,
			"EraShort"			TEXT,
			"YieldShort"		TEXT
		);

		INSERT INTO Suk_Identities_YieldPerEra
		SELECT
			EraType,
			YieldType,
			REPLACE(EraType, 'ERA_', '') AS EraShort,
			REPLACE(YieldType, 'YIELD_', '') AS YieldShort
		FROM Eras CROSS JOIN Yields
			WHERE YieldType IN (
				'YIELD_PRODUCTION',
				'YIELD_SCIENCE'
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Modifiers
		----------------------
			INSERT OR REPLACE INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId
					)
			SELECT
						'SUK_IDENTITY_'||YieldShort||'_PER_ERA_'||EraShort,
						'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',
						CASE
							WHEN EraType = 'ERA_ANCIENT' THEN NULL
							ELSE 'SUK_GAME_ERA_AFTER_'||EraShort||'_REQUIREMENTS'
						END
			FROM Suk_Identities_YieldPerEra;
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT
					'SUK_IDENTITY_'||YieldShort||'_PER_ERA_'||EraShort,
					'YieldType',
					YieldType
			FROM Suk_Identities_YieldPerEra;

			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT
					'SUK_IDENTITY_'||YieldShort||'_PER_ERA_'||EraShort,
					'Amount',
					1
			FROM Suk_Identities_YieldPerEra;
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
				(
					RequirementSetId,
					RequirementSetType
				)
			SELECT DISTINCT
					'SUK_GAME_ERA_AFTER_'||EraShort||'_REQUIREMENTS',
					'REQUIREMENTSET_TEST_ALL'
			FROM Suk_Identities_YieldPerEra WHERE EraType != "ERA_ANCIENT";
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT DISTINCT
					'SUK_GAME_ERA_AFTER_'||EraShort||'_REQUIREMENTS',
					'REQUIRES_GAME_ERA_AFTER_'||EraShort
			FROM Suk_Identities_YieldPerEra WHERE EraType != "ERA_ANCIENT";
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
				(
					RequirementId,
					RequirementType
				)
			SELECT DISTINCT
					'REQUIRES_GAME_ERA_AFTER_'||EraShort,
					'REQUIREMENT_GAME_ERA_ATLEAST_EXPANSION'
			FROM Suk_Identities_YieldPerEra WHERE EraType != "ERA_ANCIENT";
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			SELECT DISTINCT
					'REQUIRES_GAME_ERA_AFTER_'||EraShort,
					'EraType',
					EraType
			FROM Suk_Identities_YieldPerEra WHERE EraType != "ERA_ANCIENT";
--==========================================================================================================================
-- Generic Modifiers/Requirements
--==========================================================================================================================		----------------------
	-- Modifiers
	----------------------
		INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
		VALUES	(
					'SUK_IDENTITY_GENERIC_DISTRICT_MALUS',
					'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER',
					NULL
				),
				(
					'SUK_IDENTITY_GENERIC_DISTRICT_MALUS_MAJOR',
					'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER',
					NULL
				),

				(
					'SUK_IDENTITY_GENERIC_HOUSING_1',
					'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING',
					'SUK_IDENTITY_GENERIC_DISTRICT_IS_CITY_CENTER_REQUIREMENTS'
				),
				(
					'SUK_IDENTITY_GENERIC_HOUSING_2',
					'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING',
					'SUK_IDENTITY_GENERIC_DISTRICT_IS_CITY_CENTER_REQUIREMENTS'
				),
				(
					'SUK_IDENTITY_GENERIC_HOUSING_3',
					'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING',
					'SUK_IDENTITY_GENERIC_DISTRICT_IS_CITY_CENTER_REQUIREMENTS'
				),
				(
					'SUK_IDENTITY_GENERIC_AMENITIES_1',
					'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',
					NULL
				),
				(
					'SUK_IDENTITY_GENERIC_AMENITIES_2',
					'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',
					NULL
				),
				(
					'SUK_IDENTITY_GENERIC_AMENITIES_3',
					'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',
					NULL
				);
	----------------------
	-- ModifierArguments
	----------------------
		INSERT INTO ModifierArguments
				(ModifierId,									Name,				Value)
		VALUES	('SUK_IDENTITY_GENERIC_DISTRICT_MALUS',			'Amount',			-15),
				('SUK_IDENTITY_GENERIC_DISTRICT_MALUS_MAJOR',	'Amount',			-30),

				('SUK_IDENTITY_GENERIC_HOUSING_1',				'Amount',			1),
				('SUK_IDENTITY_GENERIC_HOUSING_2',				'Amount',			2),
				('SUK_IDENTITY_GENERIC_HOUSING_3',				'Amount',			3),
				('SUK_IDENTITY_GENERIC_AMENITIES_1',			'Amount',			1),
				('SUK_IDENTITY_GENERIC_AMENITIES_2',			'Amount',			2),
				('SUK_IDENTITY_GENERIC_AMENITIES_3',			'Amount',			3);
--------------------------------------------------------------------
	-- Requirements
--------------------------------------------------------------------
	-- RequirementSets
	----------------------
		INSERT OR IGNORE INTO RequirementSets
				(RequirementSetId,												RequirementSetType)
		VALUES	('SUK_IDENTITY_GENERIC_DISTRICT_IS_CITY_CENTER_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY');
	----------------------
	-- RequirementSetRequirements
	----------------------
		INSERT OR IGNORE INTO RequirementSetRequirements
				(RequirementSetId,												RequirementId)
		VALUES	('SUK_IDENTITY_GENERIC_DISTRICT_IS_CITY_CENTER_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_CITY_CENTER');
	----------------------
	-- Requirements
	----------------------
		INSERT OR IGNORE INTO Requirements
				(
					RequirementId,
					RequirementType
				)
		VALUES	(
					'REQUIRES_SUK_IDENITY_REGIONAL_6',
					'REQUIREMENT_PLOT_ADJACENT_TO_OWNER'
				),
				(
					'REQUIRES_CITY_HAS_AQUEDUCT',
					'REQUIREMENT_CITY_HAS_DISTRICT'
				),
				(
					'REQUIRES_SUK_PLOT_HAS_ANY_IMPROVEMENT',
					'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT'
				),
				(
					'REQUIRES_SUK_PLAYER_HAS_EDUCATION',
					'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'
				),
				(
					'REQUIRES_SUK_PLAYER_HAS_DRAMA_AND_POETRY',
					'REQUIREMENT_PLAYER_HAS_CIVIC'
				),
				(
					'REQUIRES_SUK_PLAYER_HAS_MYSTICISM',
					'REQUIREMENT_PLAYER_HAS_CIVIC'
				);

		INSERT OR IGNORE INTO Requirements
				(
					RequirementId,
					RequirementType,
					Inverse
				)
		VALUES	(
					'REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER',
					'REQUIREMENT_DISTRICT_TYPE_MATCHES',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_CAMPUS',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_HARBOR',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_HOLY_SITE',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_SPACEPORT',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				),
				(
					'REQUIRES_SUK_CITY_HAS_NO_DAM',
					'REQUIREMENT_CITY_HAS_DISTRICT',
					1
				);
	-------------------------------------
	-- RequirementArguments
	-------------------------------------
		INSERT OR IGNORE INTO RequirementArguments
			(
				RequirementId,
				Name,
				Value
			)
		VALUES
			(
				'REQUIRES_SUK_IDENITY_REGIONAL_6',
				'MinDistance',
				0
			),
			(
				'REQUIRES_SUK_IDENITY_REGIONAL_6',
				'MaxDistance',
				6
			),

			(
				'REQUIRES_CITY_HAS_AQUEDUCT',
				'DistrictType',
				'DISTRICT_AQUEDUCT'
			),

			(
				'REQUIRES_SUK_PLAYER_HAS_EDUCATION',
				'TechnologyType',
				'TECH_EDUCATION'
			),
			(
				'REQUIRES_SUK_PLAYER_HAS_DRAMA_AND_POETRY',
				'CivicType',
				'CIVIC_DRAMA_POETRY'
			),
			(
				'REQUIRES_SUK_PLAYER_HAS_MYSTICISM',
				'CivicType',
				'CIVIC_MYSTICISM'
			),

			(
				'REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER',
				'DistrictType',
				'DISTRICT_WONDER'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE',
				'DistrictType',
				'DISTRICT_INDUSTRIAL_ZONE'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_CAMPUS',
				'DistrictType',
				'DISTRICT_CAMPUS'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_HARBOR',
				'DistrictType',
				'DISTRICT_HARBOR'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_HOLY_SITE',
				'DistrictType',
				'DISTRICT_HOLY_SITE'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_SPACEPORT',
				'DistrictType',
				'DISTRICT_SPACEPORT'
			),
			(
				'REQUIRES_SUK_CITY_HAS_NO_DAM',
				'DistrictType',
				'DISTRICT_DAM'
			);
--==========================================================================================================================
-- Base District Adjacencies
--==========================================================================================================================
	-- District Adjacencies
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "Suk_DistrictAdjacencies"(
			"DistrictType" 			TEXT,
			"RequirementId" 		TEXT,
			"YieldType" 			TEXT,

			"DistrictShort"			TEXT,
			"YieldShort"			TEXT
		);

		INSERT INTO Suk_DistrictAdjacencies
			(
				DistrictType,
				RequirementId,
				YieldType,
				DistrictShort,
				YieldShort
			)
		SELECT DISTINCT

			Districts.DistrictType,
			Requirements.RequirementId,
			Adjacency_YieldChanges.YieldType,

			REPLACE(Districts.DistrictType, 'DISTRICT_', ''),
			REPLACE(Adjacency_YieldChanges.YieldType, 'YIELD_', '')

		FROM Districts
			JOIN District_Adjacencies ON District_Adjacencies.DistrictType = Districts.DistrictType
			JOIN Adjacency_YieldChanges ON District_Adjacencies.YieldChangeId = Adjacency_YieldChanges.ID
			JOIN Requirements ON
				REPLACE(Districts.DistrictType, 'DISTRICT', 'REQUIRES_DISTRICT_IS') = Requirements.RequirementId
				AND Requirements.RequirementType = 'REQUIREMENT_DISTRICT_TYPE_MATCHES'
			WHERE Districts.RequiresPopulation = 1 AND Districts.DistrictType NOT IN (SELECT CivUniqueDistrictType FROM DistrictReplaces);
--==========================================================================================================================
-- Hardwood Trees
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_HARDWOOD_TREES',
				'IDENTITY_SUK_HARDWOOD_TREES',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			-- Production Per Era
			INSERT INTO Suk_UrbanIdentity_Modifiers
				(
					IdentityType,
					ModifierId
				)
			SELECT DISTINCT
					'IDENTITY_SUK_HARDWOOD_TREES',
					'SUK_IDENTITY_'||YieldShort||'_PER_ERA_'||EraShort
			FROM Suk_Identities_YieldPerEra WHERE YieldType = 'YIELD_PRODUCTION';

			-- Lumbermill Yields
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_HARDWOOD_TREES',				'IDENTITY_SUK_HARDWOOD_LUMBERMILLS');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_HARDWOOD_LUMBERMILLS',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_HARDWOOD_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,								Name,				Value)
			VALUES	('IDENTITY_SUK_HARDWOOD_LUMBERMILLS',		'YieldType',		'YIELD_PRODUCTION,YIELD_GOLD'),
					('IDENTITY_SUK_HARDWOOD_LUMBERMILLS',		'Amount',			'2,1');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('SUK_IDENTITY_HARDWOOD_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_HARDWOOD_ADJACENCY_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('SUK_IDENTITY_HARDWOOD_REQUIREMENTS',				'REQUIRES_PLOT_HAS_LUMBER_MILL'),
					('SUK_IDENTITY_HARDWOOD_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_HARDWOOD_TREES'),
					('SUK_IDENTITY_HARDWOOD_REQUIREMENTS',				'REQUIRES_SUK_IDENTITY_HARDWOOD_ADJACENCY'),

					('SUK_IDENTITY_HARDWOOD_ADJACENCY_REQUIREMENTS',	'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CITY_CENTER'),
					('SUK_IDENTITY_HARDWOOD_ADJACENCY_REQUIREMENTS',	'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_INDUSTRIAL_ZONE');
		----------------------
		-- Suk_Identities_DistrictAdjacencyRequirements
		----------------------
			INSERT INTO Suk_Identities_DistrictAdjacencyRequirements
					(
						RequirementId,
						DistrictType,
						MinRange,
						MaxRange
					)
			VALUES
					(
						'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CITY_CENTER',
						'DISTRICT_CITY_CENTER',
						NULL,
						NULL
					),
					(
						'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_INDUSTRIAL_ZONE',
						'DISTRICT_INDUSTRIAL_ZONE',
						NULL,
						NULL
					);
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_HARDWOOD_TREES',		'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
					('REQUIRES_SUK_IDENTITY_HARDWOOD_ADJACENCY',		'REQUIREMENT_REQUIREMENTSET_IS_MET');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_HARDWOOD_TREES',
					'PropertyName',
					'IDENTITY_SUK_HARDWOOD_TREES'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_HARDWOOD_TREES',
					'PropertyMinimum',
					1
				),

				(
					'REQUIRES_SUK_IDENTITY_HARDWOOD_ADJACENCY',
					'RequirementSetId',
					'SUK_IDENTITY_HARDWOOD_ADJACENCY_REQUIREMENTS'
				);
--==========================================================================================================================
-- Underground Aquifers
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,										ModifierId)
			VALUES	('IDENTITY_SUK_UNDERGROUND_AQUIFERS',				'SUK_IDENTITY_GENERIC_HOUSING_2'),
					('IDENTITY_SUK_UNDERGROUND_AQUIFERS',				'SUK_IDENTITY_AQUIFERS_DESERT_FARMS'),
					('IDENTITY_SUK_UNDERGROUND_AQUIFERS',				'SUK_IDENTITY_AQUIFERS_DESERT_FARMS_YIELDS');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'SUK_IDENTITY_AQUIFERS_DESERT_FARMS',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN',
						NULL
					),
					(
						'SUK_IDENTITY_AQUIFERS_DESERT_FARMS_YIELDS',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_AQUIFERS_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,				Name,					Value)
			VALUES	('SUK_IDENTITY_AQUIFERS_DESERT_FARMS',				'ImprovementType',		'IMPROVEMENT_FARM'),
					('SUK_IDENTITY_AQUIFERS_DESERT_FARMS',				'TerrainType',			'TERRAIN_DESERT'),

					('SUK_IDENTITY_AQUIFERS_DESERT_FARMS_YIELDS',		'YieldType',			'YIELD_FOOD,YIELD_GOLD'),
					('SUK_IDENTITY_AQUIFERS_DESERT_FARMS_YIELDS',		'Amount',				'1,1');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,								RequirementSetType)
			VALUES	('SUK_IDENTITY_AQUIFERS_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM',	'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,								RequirementId)
			VALUES	('SUK_IDENTITY_AQUIFERS_REQUIREMENTS',			'PETRA_YIELD_MODIFIER_REQUIRES_PLOT_HAS_DESERT'),
					('SUK_IDENTITY_AQUIFERS_REQUIREMENTS',			'REQUIRES_PLOT_HAS_NO_FLOODPLAINS'),
					('SUK_IDENTITY_AQUIFERS_REQUIREMENTS',			'REQUIRES_SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM'),

					('SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM',	'REQUIRES_PLOT_HAS_FARM'),
					('SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM',	'REQUIRES_PLOT_HAS_PLANTATION');
		----------------------
		-- Requirements
		----------------------
			INSERT INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM',	'REQUIREMENT_REQUIREMENTSET_IS_MET');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM',
					'RequirementSetId',
					'SUK_IDENTITY_AQUIFERS_PLANTATION_OR_FARM'
				);
--==========================================================================================================================
-- Idyllic Scenery
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_IDYLLIC_SCENERY',
				'IDENTITY_SUK_IDYLLIC_SCENERY',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_IDYLLIC_SCENERY',			'SUK_IDENTITY_GENERIC_AMENITIES_3'),
					('IDENTITY_SUK_IDYLLIC_SCENERY',			'IDENTITY_SUK_IDYLLIC_PARK_YIELDS'),
					('IDENTITY_SUK_IDYLLIC_SCENERY',			'IDENTITY_SUK_IDYLLIC_PARK_UNLOCK');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_IDYLLIC_PARK_YIELDS',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_IDYLLIC_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_IDYLLIC_PARK_UNLOCK',
						'MODIFIER_CITY_ADJUST_ALLOWED_IMPROVEMENT',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,								Name,					Value)
			VALUES	('IDENTITY_SUK_IDYLLIC_PARK_YIELDS',		'YieldType',			'YIELD_FOOD,YIELD_CULTURE'),
					('IDENTITY_SUK_IDYLLIC_PARK_YIELDS',		'Amount',				'1,1'),

					('IDENTITY_SUK_IDYLLIC_PARK_UNLOCK',		'ImprovementType',		'IMPROVEMENT_CITY_PARK');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('SUK_IDENTITY_IDYLLIC_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('SUK_IDENTITY_IDYLLIC_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_IDYLLIC_SCENERY'),
					('SUK_IDENTITY_IDYLLIC_REQUIREMENTS',				'REQUIRES_SUK_IDYLLIC_CITY_PARK');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_IDYLLIC_SCENERY',		'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
					-- Yeah, we have to use this RequirementType because of some weird implementation quirk
					('REQUIRES_SUK_IDYLLIC_CITY_PARK',					'REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_IDYLLIC_SCENERY',
					'PropertyName',
					'IDENTITY_SUK_IDYLLIC_SCENERY'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_IDYLLIC_SCENERY',
					'PropertyMinimum',
					1
				),

				(
					'REQUIRES_SUK_IDYLLIC_CITY_PARK',
					'ImprovementType',
					'IMPROVEMENT_CITY_PARK'
				),
				(
					'REQUIRES_SUK_IDYLLIC_CITY_PARK',
					'MinRange',
					0
				),
				(
					'REQUIRES_SUK_IDYLLIC_CITY_PARK',
					'MaxRange',
					0
				);
--==========================================================================================================================
-- Open Skies
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_OPEN_SKIES',
				'IDENTITY_SUK_OPEN_SKIES',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_OPEN_SKIES',			'IDENTITY_SUK_OPEN_SKIES_SCIENCE'),
					('IDENTITY_SUK_OPEN_SKIES',			'IDENTITY_SUK_OPEN_SKIES_UNIVERSITY_SCIENCE');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId,
						OwnerRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_OPEN_SKIES_SCIENCE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_OPEN_SKIES_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_OPEN_SKIES_UNIVERSITY_SCIENCE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_OPEN_SKIES_REQUIREMENTS',
						'SUK_IDENTITY_OPEN_SKIES_CITY_HAS_UNIVERSITY'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,					Value)
			VALUES	('IDENTITY_SUK_OPEN_SKIES_SCIENCE',					'YieldType',			'YIELD_SCIENCE'),
					('IDENTITY_SUK_OPEN_SKIES_SCIENCE',					'Amount',				1),

					('IDENTITY_SUK_OPEN_SKIES_UNIVERSITY_SCIENCE',		'YieldType',			'YIELD_SCIENCE'),
					('IDENTITY_SUK_OPEN_SKIES_UNIVERSITY_SCIENCE',		'Amount',				1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('SUK_IDENTITY_OPEN_SKIES_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_OPEN_SKIES_CITY_HAS_UNIVERSITY',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('SUK_IDENTITY_OPEN_SKIES_REQUIREMENTS',			'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CAMPUS'),
					('SUK_IDENTITY_OPEN_SKIES_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_OPEN_SKIES'),

					('SUK_IDENTITY_OPEN_SKIES_CITY_HAS_UNIVERSITY',		'REQUIRES_CITY_HAS_UNIVERSITY');
		----------------------
		-- Suk_Identities_DistrictAdjacencyRequirements
		----------------------
			INSERT INTO Suk_Identities_DistrictAdjacencyRequirements
					(
						RequirementId,
						DistrictType,
						MinRange,
						MaxRange
					)
			VALUES
					(
						'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CAMPUS',
						'DISTRICT_CAMPUS',
						NULL,
						NULL
					);
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_OPEN_SKIES',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_OPEN_SKIES',
					'PropertyName',
					'IDENTITY_SUK_OPEN_SKIES'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_OPEN_SKIES',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Prophetic Visions
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_PROPHETIC_VISIONS',
				'IDENTITY_SUK_PROPHETIC_VISIONS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_PROPHETIC_VISIONS',		'IDENTITY_SUK_PROPHETIC_VISIONS_FAITH'),
					('IDENTITY_SUK_PROPHETIC_VISIONS',		'IDENTITY_SUK_PROPHETIC_VISIONS_TEMPLE_FAITH'),
					('IDENTITY_SUK_PROPHETIC_VISIONS',		'IDENTITY_SUK_PROPHETIC_VISIONS_PROPHET');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId,
						OwnerRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_PROPHETIC_VISIONS_FAITH',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_PROPHETIC_VISIONS_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_PROPHETIC_VISIONS_TEMPLE_FAITH',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'SUK_IDENTITY_PROPHETIC_VISIONS_REQUIREMENTS',
						'SUK_IDENTITY_PROPHETIC_VISIONS_CITY_HAS_TEMPLE'
					),
					(
						'IDENTITY_SUK_PROPHETIC_VISIONS_PROPHET',
						'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS',
						NULL,
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,											Name,						Value)
			VALUES	('IDENTITY_SUK_PROPHETIC_VISIONS_FAITH',				'YieldType',				'YIELD_FAITH'),
					('IDENTITY_SUK_PROPHETIC_VISIONS_FAITH',				'Amount',					2),

					('IDENTITY_SUK_PROPHETIC_VISIONS_TEMPLE_FAITH',			'YieldType',				'YIELD_FAITH'),
					('IDENTITY_SUK_PROPHETIC_VISIONS_TEMPLE_FAITH',			'Amount',					1),

					('IDENTITY_SUK_PROPHETIC_VISIONS_PROPHET',				'GreatPersonClassType',		'GREAT_PERSON_CLASS_PROPHET'),
					('IDENTITY_SUK_PROPHETIC_VISIONS_PROPHET',				'Amount',					1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('SUK_IDENTITY_PROPHETIC_VISIONS_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_PROPHETIC_VISIONS_CITY_HAS_TEMPLE',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('SUK_IDENTITY_PROPHETIC_VISIONS_REQUIREMENTS',			'REQUIRES_PLOT_ADJACENT_HOLY_SITE'),
					('SUK_IDENTITY_PROPHETIC_VISIONS_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_PROPHETIC_VISIONS'),

					('SUK_IDENTITY_PROPHETIC_VISIONS_CITY_HAS_TEMPLE',		'REQUIRES_CITY_HAS_TEMPLE');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_PROPHETIC_VISIONS',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_PROPHETIC_VISIONS',
					'PropertyName',
					'IDENTITY_SUK_PROPHETIC_VISIONS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_PROPHETIC_VISIONS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Mountain Pass
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_MOUNTAIN_PASS',
				'IDENTITY_SUK_MOUNTAIN_PASS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_MOUNTAIN_PASS',		'IDENTITY_SUK_MOUNTAIN_PASS_GOLD'),
					('IDENTITY_SUK_MOUNTAIN_PASS',		'IDENTITY_SUK_MOUNTAIN_PASS_TRADE');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_MOUNTAIN_PASS_GOLD',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'SUK_IDENTITY_MOUNTAIN_PASS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MOUNTAIN_PASS_TRADE',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',
						'SUK_IDENTITY_MOUNTAIN_PASS_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_MOUNTAIN_PASS_GOLD',				'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_MOUNTAIN_PASS_GOLD',				'Amount',			4),
					('IDENTITY_SUK_MOUNTAIN_PASS_TRADE',			'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,								RequirementSetType)
			VALUES	('SUK_IDENTITY_MOUNTAIN_PASS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('SUK_IDENTITY_MOUNTAIN_PASS_REQUIREMENTS',				'REQUIRES_DISTRICT_IS_COMMERCIAL_HUB'),
					('SUK_IDENTITY_MOUNTAIN_PASS_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_MOUNTAIN_PASS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_MOUNTAIN_PASS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_MOUNTAIN_PASS',
					'PropertyName',
					'IDENTITY_SUK_MOUNTAIN_PASS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_MOUNTAIN_PASS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Rich Soil
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue,
				CityOnly
			)
		VALUES
			(
				'IDENTITY_SUK_RICH_SOIL',
				'IDENTITY_SUK_RICH_SOIL',
				1,
				0
			),
			(
				'IDENTITY_SUK_RICH_SOIL',
				'HAS_IDENTITY_SUK_RICH_SOIL',
				1,
				1
			);
--==========================================================================================================================
-- Massive Trees
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_MASSIVE_TREES',
				'IDENTITY_SUK_MASSIVE_TREES',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_MASSIVE_TREES',		'SUK_IDENTITY_GENERIC_DISTRICT_MALUS'),
					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_CULTURE'),
					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_FAITH'),

					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_WRITER'),
					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_ARTIST'),
					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_MUSICIAN'),
					('IDENTITY_SUK_MASSIVE_TREES',		'IDENTITY_SUK_MASSIVE_TREES_PROPHET');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_MASSIVE_TREES_CULTURE',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'SUK_IDENTITY_MASS_TREES_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MASSIVE_TREES_FAITH',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'SUK_IDENTITY_MASS_TREES_HOLY_SITE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MASSIVE_TREES_WRITER',
						'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',
						'SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MASSIVE_TREES_ARTIST',
						'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',
						'SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MASSIVE_TREES_MUSICIAN',
						'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',
						'SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_MASSIVE_TREES_PROPHET',
						'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',
						'SUK_IDENTITY_MASS_TREES_APPEAL_HOLY_SITE_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,								Name,						Value)
			VALUES	('IDENTITY_SUK_MASSIVE_TREES_CULTURE',		'YieldType',				'YIELD_CULTURE'),
					('IDENTITY_SUK_MASSIVE_TREES_CULTURE',		'Amount',					3),
					('IDENTITY_SUK_MASSIVE_TREES_FAITH',		'YieldType',				'YIELD_FAITH'),
					('IDENTITY_SUK_MASSIVE_TREES_FAITH',		'Amount',					3),

					('IDENTITY_SUK_MASSIVE_TREES_WRITER',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_WRITER'),
					('IDENTITY_SUK_MASSIVE_TREES_WRITER',		'Amount',					1),
					('IDENTITY_SUK_MASSIVE_TREES_ARTIST',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_ARTIST'),
					('IDENTITY_SUK_MASSIVE_TREES_ARTIST',		'Amount',					1),
					('IDENTITY_SUK_MASSIVE_TREES_MUSICIAN',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_MUSICIAN'),
					('IDENTITY_SUK_MASSIVE_TREES_MUSICIAN',		'Amount',					1),
					('IDENTITY_SUK_MASSIVE_TREES_PROPHET',		'GreatPersonClassType',		'GREAT_PERSON_CLASS_PROPHET'),
					('IDENTITY_SUK_MASSIVE_TREES_PROPHET',		'Amount',					1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('SUK_IDENTITY_MASS_TREES_THEATER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_MASS_TREES_HOLY_SITE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_HOLY_SITE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('SUK_IDENTITY_MASS_TREES_THEATER_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_THEATER'),
					('SUK_IDENTITY_MASS_TREES_THEATER_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES'),

					('SUK_IDENTITY_MASS_TREES_HOLY_SITE_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_HOLY_SITE'),
					('SUK_IDENTITY_MASS_TREES_HOLY_SITE_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES'),

					('SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_THEATER'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS',		'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_THEATER_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES'),

					('SUK_IDENTITY_MASS_TREES_APPEAL_HOLY_SITE_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_HOLY_SITE'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_HOLY_SITE_REQUIREMENTS',	'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
					('SUK_IDENTITY_MASS_TREES_APPEAL_HOLY_SITE_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES',
					'PropertyName',
					'IDENTITY_SUK_MASSIVE_TREES'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_MASSIVE_TREES',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Ocean Swells
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_OCEAN_SWELLS',		'IDENTITY_SUK_OCEAN_SWELLS_DISTRICT_MALUS'),
					('IDENTITY_SUK_OCEAN_SWELLS',		'IDENTITY_SUK_OCEAN_SWELLS_BUILDING_MALUS'),

					('IDENTITY_SUK_OCEAN_SWELLS',		'IDENTITY_SUK_OCEAN_SWELLS_GOLD'),
					('IDENTITY_SUK_OCEAN_SWELLS',		'IDENTITY_SUK_OCEAN_SWELLS_AMENITY');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_OCEAN_SWELLS_DISTRICT_MALUS',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',
						NULL
					),
					(
						'IDENTITY_SUK_OCEAN_SWELLS_BUILDING_MALUS',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_BUILDING_PRODUCTION',
						NULL
					),
					(
						'IDENTITY_SUK_OCEAN_SWELLS_GOLD',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'IDENTITY_SUK_OCEAN_SWELLS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_OCEAN_SWELLS_AMENITY',
						'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY',
						'IDENTITY_SUK_OCEAN_SWELLS_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_OCEAN_SWELLS_DISTRICT_MALUS',	'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_OCEAN_SWELLS_DISTRICT_MALUS',	'Amount',			-50),
					('IDENTITY_SUK_OCEAN_SWELLS_BUILDING_MALUS',	'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_OCEAN_SWELLS_BUILDING_MALUS',	'Amount',			-50),

					('IDENTITY_SUK_OCEAN_SWELLS_GOLD',				'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_OCEAN_SWELLS_GOLD',				'Amount',			3),
					('IDENTITY_SUK_OCEAN_SWELLS_AMENITY',			'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,								RequirementSetType)
			VALUES	('IDENTITY_SUK_OCEAN_SWELLS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,								RequirementId)
			VALUES	('IDENTITY_SUK_OCEAN_SWELLS_REQUIREMENTS',		'PLOT_IS_COASTAL_LAND_XP2'),
					('IDENTITY_SUK_OCEAN_SWELLS_REQUIREMENTS',		'REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER');
--==========================================================================================================================
-- Fossil Deposits
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_FOSSIL_DEPOSITS',
				'IDENTITY_SUK_FOSSIL_DEPOSITS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			-- Production Per Era
			INSERT INTO Suk_UrbanIdentity_Modifiers
				(
					IdentityType,
					ModifierId
				)
			SELECT DISTINCT
					'IDENTITY_SUK_FOSSIL_DEPOSITS',
					'SUK_IDENTITY_'||YieldShort||'_PER_ERA_'||EraShort
			FROM Suk_Identities_YieldPerEra WHERE YieldType = 'YIELD_SCIENCE';

			-- Lumbermill Yields
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_FOSSIL_DEPOSITS',			'IDENTITY_SUK_FOSSIL_PLOT_YIELD');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_FOSSIL_PLOT_YIELD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_FOSSIL_DEPOSITS_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,				Value)
			VALUES	('IDENTITY_SUK_FOSSIL_PLOT_YIELD',		'YieldType',		'YIELD_SCIENCE,YIELD_CULTURE'),
					('IDENTITY_SUK_FOSSIL_PLOT_YIELD',		'Amount',			'2,2');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('IDENTITY_SUK_FOSSIL_DEPOSITS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('IDENTITY_SUK_FOSSIL_DEPOSITS_REQUIREMENTS',		'REQUIRES_CITY_HAS_UNIVERSITY'),
					('IDENTITY_SUK_FOSSIL_DEPOSITS_REQUIREMENTS',		'REQUIRES_CITY_HAS_MUSEUM_ARTIFACT'),
					('IDENTITY_SUK_FOSSIL_DEPOSITS_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_FOSSIL_DEPOSITS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_CITY_HAS_MUSEUM_ARTIFACT',					'REQUIREMENT_CITY_HAS_BUILDING'),
					('REQUIRES_PLOT_IDENTITY_SUK_FOSSIL_DEPOSITS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_CITY_HAS_MUSEUM_ARTIFACT',
					'BuildingType',
					'BUILDING_MUSEUM_ARTIFACT'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FOSSIL_DEPOSITS',
					'PropertyName',
					'IDENTITY_SUK_FOSSIL_DEPOSITS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FOSSIL_DEPOSITS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Rejuvenating Springs
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_REJUVENATING_SPRINGS',
				'IDENTITY_SUK_REJUVENATING_SPRINGS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_REJUVENATING_SPRINGS',		'SUK_IDENTITY_GENERIC_HOUSING_1'),
					('IDENTITY_SUK_REJUVENATING_SPRINGS',		'SUK_IDENTITY_GENERIC_AMENITIES_1'),

					('IDENTITY_SUK_REJUVENATING_SPRINGS',		'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING'),
					('IDENTITY_SUK_REJUVENATING_SPRINGS',		'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY'),
					('IDENTITY_SUK_REJUVENATING_SPRINGS',		'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	--- Regional Housing
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING_MOD',
						'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
						'IDENTITY_SUK_REJ_SPRINGS_REGIONAL_REQUIREMENTS'
					),
					-- Regional Amenity
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY_MOD',
						'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
						'IDENTITY_SUK_REJ_SPRINGS_REGIONAL_REQUIREMENTS'
					),
					-- Food
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD_MOD',
						'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_REJ_SPRINGS_ADJACENT_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			VALUES	(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING',
						'ModifierId',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING_MOD'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY',
						'ModifierId',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY_MOD'
					),
					----------
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_HOUSING_MOD',
						'ModifierId',
						'SUK_IDENTITY_GENERIC_HOUSING_1'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_AMENITY_MOD',
						'ModifierId',
						'SUK_IDENTITY_GENERIC_AMENITIES_1'
					),
					----------
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD',
						'ModifierId',
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD_MOD'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD_MOD',
						'YieldType',
						'YIELD_FOOD'
					),
					(
						'IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_FOOD_MOD',
						'Amount',
						2
					);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_REJ_SPRINGS_REGIONAL_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_REJ_SPRINGS_ADJACENT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_ENTERTAINMENT_COMPLEX'),
					('IDENTITY_SUK_REJ_SPRINGS_ENT_COMP_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_REJ_SPRINGS'),
					('IDENTITY_SUK_REJ_SPRINGS_ADJACENT_REQUIREMENTS',		'ADJACENT_TO_OWNER'),
					('IDENTITY_SUK_REJ_SPRINGS_REGIONAL_REQUIREMENTS',		'REQUIRES_SUK_IDENITY_REGIONAL_6');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_REJ_SPRINGS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_REJ_SPRINGS',
					'PropertyName',
					'IDENTITY_SUK_REJUVENATING_SPRINGS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_REJ_SPRINGS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Scenic Vistas
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_SCENIC_VISTAS',
				'IDENTITY_SUK_SCENIC_VISTAS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_SCENIC_VISTAS',		'SUK_IDENTITY_GENERIC_DISTRICT_MALUS'),
					('IDENTITY_SUK_SCENIC_VISTAS',		'IDENTITY_SUK_SCENIC_VISTAS_PLOT_YIELD'),
					('IDENTITY_SUK_SCENIC_VISTAS',		'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_YIELD'),
					('IDENTITY_SUK_SCENIC_VISTAS',		'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_SCENIC_VISTAS_PLOT_YIELD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_SCENIC_VISTAS_APPEAL_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_YIELD',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL_MOD',
						'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,			Value)
			VALUES	('IDENTITY_SUK_SCENIC_VISTAS_PLOT_YIELD',			'YieldType',	'YIELD_GOLD,YIELD_CULTURE'),
					('IDENTITY_SUK_SCENIC_VISTAS_PLOT_YIELD',			'Amount',		'2,2'),

					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_YIELD',		'YieldType',	'YIELD_CULTURE'),
					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_YIELD',		'Amount',		3),

					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL',		'ModifierId',	'IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL_MOD'),
					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_APPEAL_MOD',	'Amount',		'1');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('IDENTITY_SUK_SCENIC_VISTAS_APPEAL_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('IDENTITY_SUK_SCENIC_VISTAS_APPEAL_REQUIREMENTS',		'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
					('IDENTITY_SUK_SCENIC_VISTAS_APPEAL_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_SCENIC_VISTAS'),

					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_THEATER'),
					('IDENTITY_SUK_SCENIC_VISTAS_THEATRE_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_SCENIC_VISTAS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_SCENIC_VISTAS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SCENIC_VISTAS',
					'PropertyName',
					'IDENTITY_SUK_SCENIC_VISTAS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SCENIC_VISTAS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Natural Harbor
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_NATURAL_HARBOR',		'IDENTITY_SUK_NATURAL_HARBOR_DISTRICT_MALUS'),
					('IDENTITY_SUK_NATURAL_HARBOR',		'IDENTITY_SUK_NATURAL_HARBOR_BUILDING_MALUS'),
					('IDENTITY_SUK_NATURAL_HARBOR',		'IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_NATURAL_HARBOR_DISTRICT_MALUS',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION',
						NULL
					),
					(
						'IDENTITY_SUK_NATURAL_HARBOR_BUILDING_MALUS',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_BUILDING_PRODUCTION',
						NULL
					),
					(
						'IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY',
						'MODIFIER_SUK_SINGLE_CITY_DISTRICT_ADJACENCY',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_NATURAL_HARBOR_DISTRICT_MALUS',		'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_NATURAL_HARBOR_DISTRICT_MALUS',		'Amount',			50),
					('IDENTITY_SUK_NATURAL_HARBOR_BUILDING_MALUS',		'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_NATURAL_HARBOR_BUILDING_MALUS',		'Amount',			50),

					('IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY',			'YieldType',		'YIELD_FOOD'),
					('IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY',			'Amount',			2),
					('IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY',			'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY',			'Description',		'LOC_IDENTITY_SUK_NATURAL_HARBOR_ADJACENCY');
--==========================================================================================================================
-- Karst Aquifers
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_KARST_AQUIFERS',		'SUK_IDENTITY_GENERIC_DISTRICT_MALUS_MAJOR'),
					('IDENTITY_SUK_KARST_AQUIFERS',		'IDENTITY_SUK_KARST_AQUIFERS_HOUSING'),
					('IDENTITY_SUK_KARST_AQUIFERS',		'IDENTITY_SUK_KARST_AQUIFERS_AMENITIES'),
					('IDENTITY_SUK_KARST_AQUIFERS',		'IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_KARST_AQUIFERS_HOUSING',
						'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
						'IDENTITY_SUK_KARST_AQUIFERS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_KARST_AQUIFERS_AMENITIES',
						'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
						'IDENTITY_SUK_KARST_AQUIFERS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT',
						'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
						'IDENTITY_SUK_KARST_AQUIFERS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT_MODFIER',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'DISTRICT_IS_AQUEDUCT'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_KARST_AQUIFERS_HOUSING',				'ModifierId',		'SUK_IDENTITY_GENERIC_HOUSING_2'),
					('IDENTITY_SUK_KARST_AQUIFERS_AMENITIES',			'ModifierId',		'SUK_IDENTITY_GENERIC_AMENITIES_1'),
					('IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT',			'ModifierId',		'IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT_MODFIER'),

					('IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT_MODFIER',	'YieldType',		'YIELD_FOOD'),
					('IDENTITY_SUK_KARST_AQUIFERS_AQUEDUCT_MODFIER',	'Amount',			4);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('IDENTITY_SUK_KARST_AQUIFERS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('IDENTITY_SUK_KARST_AQUIFERS_REQUIREMENTS',		'REQUIRES_SUK_IDENITY_REGIONAL_6');
--==========================================================================================================================
-- Steep Slopes
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_STEEP_SLOPES',
				'IDENTITY_SUK_STEEP_SLOPES',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_STEEP_SLOPES',		'SUK_IDENTITY_GENERIC_DISTRICT_MALUS_MAJOR');

			INSERT INTO Suk_UrbanIdentity_Modifiers
							(IdentityType,						ModifierId)
			SELECT DISTINCT	'IDENTITY_SUK_STEEP_SLOPES',		'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_'||YieldShort
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_'||YieldShort,
					'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_REQUIREMENTS'
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_'||YieldShort,
					'YieldType',
					YieldType
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;

			INSERT INTO ModifierArguments
				(
					ModifierId,
					Name,
					Value
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_'||YieldShort,
					'Amount',
					2
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
				(
					RequirementSetId,
					RequirementSetType
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_REQUIREMENTS',
					'REQUIREMENTSET_TEST_ALL'
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_REQUIREMENTS',
					RequirementId
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;

			INSERT OR IGNORE INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT DISTINCT
					'IDENTITY_SUK_STEEP_SLOPES_'||DistrictShort||'_REQUIREMENTS',
					'REQUIRES_PLOT_IDENTITY_SUK_STEEP_SLOPES'
			FROM Suk_DistrictAdjacencies WHERE RequirementId IS NOT NULL;
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 								RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_STEEP_SLOPES',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_STEEP_SLOPES',
					'PropertyName',
					'IDENTITY_SUK_STEEP_SLOPES'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_STEEP_SLOPES',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Puna Grasslands
--==========================================================================================================================
	-- Prep
	--------------------------------------------------------------------
		CREATE TEMPORARY TABLE "Suk_PunaGrasslands"(
			"TerrainType"		TEXT
		);

		INSERT INTO Suk_PunaGrasslands
				(TerrainType)
		VALUES	('TERRAIN_GRASS_MOUNTAIN'),
				('TERRAIN_PLAINS_MOUNTAIN'),
				('TERRAIN_DESERT_MOUNTAIN'),
				('TERRAIN_TUNDRA_MOUNTAIN'),
				('TERRAIN_SNOW_MOUNTAIN'),

				('TERRAIN_GRASS_HILLS'),
				('TERRAIN_PLAINS_HILLS'),
				('TERRAIN_DESERT_HILLS'),
				('TERRAIN_TUNDRA_HILLS'),
				('TERRAIN_SNOW_HILLS');
	--------------------------------------------------------------------
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_PUNA_GRASSLANDS',
				'IDENTITY_SUK_PUNA_GRASSLANDS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_PUNA_GRASSLANDS',	'IDENTITY_SUK_PUNA_GRASSLANDS_FARM'),
					('IDENTITY_SUK_PUNA_GRASSLANDS',	'IDENTITY_SUK_PUNA_GRASSLANDS_PASTURE'),
					('IDENTITY_SUK_PUNA_GRASSLANDS',	'IDENTITY_SUK_PUNA_GRASSLANDS_COMMERCIAL_FOOD');

			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			SELECT	'IDENTITY_SUK_PUNA_GRASSLANDS',		'IDENTITY_SUK_PUNA_GRASSLANDS_' || TerrainType
			FROM Suk_PunaGrasslands;
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_PUNA_GRASSLANDS_FARM',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'PLOT_HAS_FARM_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_PUNA_GRASSLANDS_PASTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'PLOT_HAS_PASTURE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_PUNA_GRASSLANDS_COMMERCIAL_FOOD',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',
						'IDENTITY_SUK_PUNA_GRASSLANDS_REQUIREMENTS'
					);

			-- District Adjacencies when built on a Region Tile
			INSERT INTO Modifiers
				(
					ModifierId,
					ModifierType,
					SubjectRequirementSetId
				)
			SELECT DISTINCT
				'IDENTITY_SUK_PUNA_GRASSLANDS_' || TerrainType,
				'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',
				NULL
			FROM Suk_PunaGrasslands;
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,					Value)
			VALUES	('IDENTITY_SUK_PUNA_GRASSLANDS_FARM',				'YieldType',			'YIELD_FOOD'),
					('IDENTITY_SUK_PUNA_GRASSLANDS_FARM',				'Amount',				-1),

					('IDENTITY_SUK_PUNA_GRASSLANDS_PASTURE',			'YieldType',			'YIELD_FOOD'),
					('IDENTITY_SUK_PUNA_GRASSLANDS_PASTURE',			'Amount',				2),

					('IDENTITY_SUK_PUNA_GRASSLANDS_COMMERCIAL_FOOD',	'YieldTypeToMirror',	'YIELD_GOLD'),
					('IDENTITY_SUK_PUNA_GRASSLANDS_COMMERCIAL_FOOD',	'YieldTypeToGrant',		'YIELD_FOOD');

			-- Hill and Mountain Adjacencies
			WITH CTE(Name, Value) AS
				(
					SELECT * FROM (VALUES
						('DistrictType',			'DISTRICT_COMMERCIAL_HUB'),
						('YieldType',				'YIELD_GOLD'),
						('Amount',					1)
					)
				)
			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT DISTINCT
						'IDENTITY_SUK_PUNA_GRASSLANDS_' || TerrainType,
						Name,
						Value
			FROM Suk_PunaGrasslands CROSS JOIN CTE;

			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT DISTINCT
						'IDENTITY_SUK_PUNA_GRASSLANDS_' || TerrainType,
						'TerrainType',
						TerrainType
			FROM Suk_PunaGrasslands;

			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT DISTINCT
						'IDENTITY_SUK_PUNA_GRASSLANDS_' || TerrainType,
						'Description',
						CASE WHEN TerrainType LIKE '%_HILLS'
							THEN 'LOC_IDENTITY_SUK_PUNA_GRASSLANDS_HILLS'
							ELSE 'LOC_BUILDING_MACHU_PICCHU_GOLD'
						END
			FROM Suk_PunaGrasslands;
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('IDENTITY_SUK_PUNA_GRASSLANDS_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('IDENTITY_SUK_PUNA_GRASSLANDS_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_COMMERCIAL_HUB'),
					('IDENTITY_SUK_PUNA_GRASSLANDS_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_PUNA_GRASSLANDS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_PUNA_GRASSLANDS',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_PUNA_GRASSLANDS',
					'PropertyName',
					'IDENTITY_SUK_PUNA_GRASSLANDS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_PUNA_GRASSLANDS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Fog Deserts
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_FOG_DESERTS',
				'IDENTITY_SUK_FOG_DESERTS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_FOG_DESERTS',				'SUK_IDENTITY_GENERIC_HOUSING_1'),
					('IDENTITY_SUK_FOG_DESERTS',				'IDENTITY_SUK_FOG_DESERTS_FOOD'),
					('IDENTITY_SUK_FOG_DESERTS',				'IDENTITY_SUK_FOG_DESERTS_HOUSING');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_FOG_DESERTS_FOOD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_FOG_DESERTS_FOOD_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_FOG_DESERTS_HOUSING',
						'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING',
						'IDENTITY_SUK_FOG_DESERTS_HOUSING_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,				Value)
			VALUES	('IDENTITY_SUK_FOG_DESERTS_FOOD',		'YieldType',		'YIELD_FOOD'),
					('IDENTITY_SUK_FOG_DESERTS_FOOD',		'Amount',			2),

					('IDENTITY_SUK_FOG_DESERTS_HOUSING',	'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('IDENTITY_SUK_FOG_DESERTS_FOOD_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_FOG_DESERTS_HOUSING_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('IDENTITY_SUK_FOG_DESERTS_FOOD_REQUIREMENTS',		'REQUIRES_SUK_PLOT_HAS_ANY_IMPROVEMENT'),
					('IDENTITY_SUK_FOG_DESERTS_FOOD_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_FOG_DESERTS'),

					('IDENTITY_SUK_FOG_DESERTS_HOUSING_REQUIREMENTS',	'REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER'),
					('IDENTITY_SUK_FOG_DESERTS_HOUSING_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_FOG_DESERTS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_FOG_DESERTS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FOG_DESERTS',
					'PropertyName',
					'IDENTITY_SUK_FOG_DESERTS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FOG_DESERTS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Cloud Forest
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_CLOUD_FORESTS',
				'IDENTITY_SUK_CLOUD_FORESTS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_SCIENCE'),
					('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_CULTURE'),
					('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_FAITH'),

					('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_SCIENCE_MODERN'),
					('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_CULTURE_MODERN'),
					('IDENTITY_SUK_CLOUD_FORESTS',				'IDENTITY_SUK_CLOUD_FORESTS_FAITH_MODERN');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_CLOUD_FORESTS_SCIENCE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_EDUCATION_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLOUD_FORESTS_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_DRAMA_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLOUD_FORESTS_FAITH',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_MYSTICISM_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLOUD_FORESTS_SCIENCE_MODERN',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_EDUCATION_MODERN_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLOUD_FORESTS_CULTURE_MODERN',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_DRAMA_MODERN_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLOUD_FORESTS_FAITH_MODERN',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_CLOUD_FORESTS_MYSTICISM_MODERN_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_CLOUD_FORESTS_SCIENCE',			'YieldType',		'YIELD_SCIENCE'),
					('IDENTITY_SUK_CLOUD_FORESTS_SCIENCE',			'Amount',			1),
					('IDENTITY_SUK_CLOUD_FORESTS_CULTURE',			'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_CLOUD_FORESTS_CULTURE',			'Amount',			1),
					('IDENTITY_SUK_CLOUD_FORESTS_FAITH',			'YieldType',		'YIELD_FAITH'),
					('IDENTITY_SUK_CLOUD_FORESTS_FAITH',			'Amount',			1),

					('IDENTITY_SUK_CLOUD_FORESTS_SCIENCE_MODERN',	'YieldType',		'YIELD_SCIENCE'),
					('IDENTITY_SUK_CLOUD_FORESTS_SCIENCE_MODERN',	'Amount',			1),
					('IDENTITY_SUK_CLOUD_FORESTS_CULTURE_MODERN',	'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_CLOUD_FORESTS_CULTURE_MODERN',	'Amount',			1),
					('IDENTITY_SUK_CLOUD_FORESTS_FAITH_MODERN',		'YieldType',		'YIELD_FAITH'),
					('IDENTITY_SUK_CLOUD_FORESTS_FAITH_MODERN',		'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_CLOUD_FORESTS_EDUCATION_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_CLOUD_FORESTS_DRAMA_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_CLOUD_FORESTS_MYSTICISM_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_CLOUD_FORESTS_EDUCATION_MODERN_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_CLOUD_FORESTS_DRAMA_MODERN_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_CLOUD_FORESTS_MYSTICISM_MODERN_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			WITH CTE(RequirementSetId, RequirementId) AS
				(
					SELECT * FROM (VALUES
						(NULL,															'REQUIRES_PLOT_IDENTITY_SUK_CLOUD_FORESTS'),
						(NULL,															'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),

						('IDENTITY_CLOUD_FORESTS_EDUCATION_REQUIREMENTS',				'REQUIRES_SUK_PLAYER_HAS_EDUCATION'),
						('IDENTITY_CLOUD_FORESTS_EDUCATION_MODERN_REQUIREMENTS',		'REQUIRES_SUK_PLAYER_HAS_EDUCATION'),

						('IDENTITY_CLOUD_FORESTS_DRAMA_REQUIREMENTS',					'REQUIRES_SUK_PLAYER_HAS_DRAMA_AND_POETRY'),
						('IDENTITY_CLOUD_FORESTS_DRAMA_MODERN_REQUIREMENTS',			'REQUIRES_SUK_PLAYER_HAS_DRAMA_AND_POETRY'),

						('IDENTITY_CLOUD_FORESTS_MYSTICISM_REQUIREMENTS',				'REQUIRES_SUK_PLAYER_HAS_MYSTICISM'),
						('IDENTITY_CLOUD_FORESTS_MYSTICISM_MODERN_REQUIREMENTS',		'REQUIRES_SUK_PLAYER_HAS_MYSTICISM'),

						('IDENTITY_CLOUD_FORESTS_MYSTICISM_MODERN_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_CONSERVATION'),
						('IDENTITY_CLOUD_FORESTS_DRAMA_MODERN_REQUIREMENTS',			'REQUIRES_PLAYER_HAS_CONSERVATION'),
						('IDENTITY_CLOUD_FORESTS_EDUCATION_MODERN_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_CONSERVATION')
					)
				)
			INSERT OR IGNORE INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT
					CTE1.RequirementSetId,
					CTE.RequirementId
			FROM
				(
					(SELECT DISTINCT RequirementSetId FROM CTE WHERE RequirementSetId IS NOT NULL) AS CTE1
				)
			INNER JOIN CTE
			ON (CTE.RequirementSetId IS NULL) OR (CTE1.RequirementSetId == CTE.RequirementSetId);
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_CLOUD_FORESTS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_CLOUD_FORESTS',
					'PropertyName',
					'IDENTITY_SUK_CLOUD_FORESTS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_CLOUD_FORESTS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Alluvial Placer
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_ALLUVIAL_PLACER',
				'IDENTITY_SUK_ALLUVIAL_PLACER',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_ALLUVIAL_PLACER',			'IDENTITY_SUK_ALLUVIAL_PLACER_GOLD'),
					('IDENTITY_SUK_ALLUVIAL_PLACER',			'IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_ALLUVIAL_PLACER_GOLD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_ALLUVIAL_PLACER_GOLD_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_ALLUVIAL_PLACER_GOLD',			'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_ALLUVIAL_PLACER_GOLD',			'Amount',			2),

					('IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
					('IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION',		'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_ALLUVIAL_PLACER_GOLD_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_ALLUVIAL_PLACER_GOLD_REQUIREMENTS',			'REQUIRES_PLOT_HAS_MINE'),
					('IDENTITY_SUK_ALLUVIAL_PLACER_GOLD_REQUIREMENTS',			'REQUIRES_PLOT_ADJACENT_TO_RIVER'),

					('IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION_REQUIREMENTS',	'REQUIRES_PLOT_HAS_MINE'),
					('IDENTITY_SUK_ALLUVIAL_PLACER_PRODUCTION_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_ALLUVIAL_PLACER');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ALLUVIAL_PLACER',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ALLUVIAL_PLACER',
					'PropertyName',
					'IDENTITY_SUK_ALLUVIAL_PLACER'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ALLUVIAL_PLACER',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Spawning Grounds
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_SPAWNING_GROUNDS',
				'IDENTITY_SUK_SPAWNING_GROUNDS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_SPAWNING_GROUNDS',			'IDENTITY_SUK_SPAWNING_GROUNDS_FOOD'),
					('IDENTITY_SUK_SPAWNING_GROUNDS',			'IDENTITY_SUK_SPAWNING_GROUNDS_CULTURE'),
					('IDENTITY_SUK_SPAWNING_GROUNDS',			'IDENTITY_SUK_SPAWNING_GROUNDS_FINAL');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_SPAWNING_GROUNDS_FOOD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_SPAWNING_GROUNDS_CITY_REQUIREMENTS',
						'IDENTITY_SUK_SPAWNING_GROUNDS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SPAWNING_GROUNDS_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_SPAWNING_GROUNDS_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SPAWNING_GROUNDS_FINAL',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_SPAWNING_GROUNDS_IS_RIVER_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SPAWNING_GROUNDS_FINAL_MODIFIER',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						NULL,
						'IDENTITY_SUK_SPAWNING_GROUNDS_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_SPAWNING_GROUNDS_FOOD',				'YieldType',		'YIELD_FOOD'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_FOOD',				'Amount',			1),

					('IDENTITY_SUK_SPAWNING_GROUNDS_CULTURE',			'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_CULTURE',			'Amount',			1),

					('IDENTITY_SUK_SPAWNING_GROUNDS_FINAL',				'ModifierId',		'IDENTITY_SUK_SPAWNING_GROUNDS_FINAL_MODIFIER'),

					('IDENTITY_SUK_SPAWNING_GROUNDS_FINAL_MODIFIER',	'YieldType',		'YIELD_FOOD,YIELD_CULTURE'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_FINAL_MODIFIER',	'Amount',			'1,1');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('IDENTITY_SUK_SPAWNING_GROUNDS_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_CITY_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_IS_RIVER_THEATER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('IDENTITY_SUK_SPAWNING_GROUNDS_REQUIREMENTS',					'REQUIRES_PLOT_IDENTITY_SUK_SPAWNING_GROUNDS'),

					('IDENTITY_SUK_SPAWNING_GROUNDS_CITY_REQUIREMENTS',				'REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_CITY_REQUIREMENTS',				'REQUIRES_SUK_CITY_HAS_NO_DAM'),

					('IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',			'REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',			'REQUIRES_SUK_CITY_HAS_NO_DAM'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_THEATER_REQUIREMENTS',			'REQUIRES_CITY_HAS_THEATER_DISTRICT'),

					('IDENTITY_SUK_SPAWNING_GROUNDS_IS_RIVER_THEATER_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_THEATER'),
					('IDENTITY_SUK_SPAWNING_GROUNDS_IS_RIVER_THEATER_REQUIREMENTS',	'REQUIRES_PLOT_ADJACENT_TO_RIVER');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_SPAWNING_GROUNDS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SPAWNING_GROUNDS',
					'PropertyName',
					'IDENTITY_SUK_SPAWNING_GROUNDS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SPAWNING_GROUNDS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Freshwater Fishery
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_FRESHWATER_FISHERY',
				'IDENTITY_SUK_FRESHWATER_FISHERY',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_FRESHWATER_FISHERY',			'IDENTITY_SUK_FRESHWATER_FISHERY_FOOD'),
					('IDENTITY_SUK_FRESHWATER_FISHERY',			'IDENTITY_SUK_FRESHWATER_FISHERY_GOLD');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_FRESHWATER_FISHERY_FOOD',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_FRESHWATER_FISHERY_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_FRESHWATER_FISHERY_GOLD',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_FRESHWATER_FISHERY_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',
						'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',
						NULL
					),
					(
						'IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',
						'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD',			'ModifierId',		'IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD',			'ModifierId',		'IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD'),

					('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',		'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',		'YieldType',		'YIELD_FOOD'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',		'Amount',			1),
					('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',		'TerrainType',		'TERRAIN_COAST'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_FOOD_MOD',		'Description',		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_FOOD'),

					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',		'DistrictType',		'DISTRICT_HARBOR'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',		'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',		'Amount',			2),
					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',		'TerrainType',		'TERRAIN_COAST'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_GOLD_MOD',		'Description',		'LOC_IDENTITY_SUK_FRESHWATER_FISHERY_GOLD');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,														RequirementSetType)
			VALUES	('IDENTITY_SUK_FRESHWATER_FISHERY_REQUIREMENTS',						'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('IDENTITY_SUK_FRESHWATER_FISHERY_REQUIREMENTS',					'REQUIRES_PLOT_IDENTITY_SUK_FRESHWATER_FISHERY'),
					('IDENTITY_SUK_FRESHWATER_FISHERY_REQUIREMENTS',					'REQUIRES_DISTRICT_IS_HARBOR');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_FRESHWATER_FISHERY',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FRESHWATER_FISHERY',
					'PropertyName',
					'IDENTITY_SUK_FRESHWATER_FISHERY'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_FRESHWATER_FISHERY',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Tower Karst
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_TOWER_KARST',
				'IDENTITY_SUK_TOWER_KARST',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_BASE_CULTURE'),
					('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_FARM_CULTURE'),
					('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_CULTURE'),

					('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_BASE_GOLD'),
					('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_FARM_GOLD'),
					('IDENTITY_SUK_TOWER_KARST',			'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_GOLD');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_TOWER_KARST_BASE_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						NULL,
						'IDENTITY_SUK_TOWER_KARST_BASE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_TOWER_KARST_FARM_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						NULL,
						'IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						NULL,
						'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_TOWER_KARST_BASE_GOLD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_TOWER_KARST_HAS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_TOWER_KARST_BASE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_TOWER_KARST_FARM_GOLD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_TOWER_KARST_HAS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_GOLD',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_TOWER_KARST_HAS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,											Name,				Value)
			VALUES	('IDENTITY_SUK_TOWER_KARST_BASE_CULTURE',				'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_TOWER_KARST_BASE_CULTURE',				'Amount',			1),

					('IDENTITY_SUK_TOWER_KARST_FARM_CULTURE',				'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_TOWER_KARST_FARM_CULTURE',				'Amount',			1),

					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_CULTURE',		'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_CULTURE',		'Amount',			1),

					('IDENTITY_SUK_TOWER_KARST_BASE_GOLD',					'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_TOWER_KARST_BASE_GOLD',					'Amount',			1),

					('IDENTITY_SUK_TOWER_KARST_FARM_GOLD',					'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_TOWER_KARST_FARM_GOLD',					'Amount',			1),

					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_GOLD',			'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_GOLD',			'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_TOWER_KARST_BASE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_TOWER_KARST_HAS_THEATER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_TOWER_KARST_BASE_REQUIREMENTS',				'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
					('IDENTITY_SUK_TOWER_KARST_BASE_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST'),

					('IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS',				'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
					('IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS',				'REQUIRES_PLOT_ADJACENT_TO_FARM'),
					('IDENTITY_SUK_TOWER_KARST_FARM_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST'),

					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS',		'REQUIRES_PLOT_HAS_NO_IMPROVEMENT'),
					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS',		'REQUIRES_PLOT_BREATHTAKING_APPEAL'),
					('IDENTITY_SUK_TOWER_KARST_BREATHTAKING_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST'),

					('IDENTITY_SUK_TOWER_KARST_HAS_THEATER_REQUIREMENTS',		'REQUIRES_CITY_HAS_THEATER_DISTRICT');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST',
					'PropertyName',
					'IDENTITY_SUK_TOWER_KARST'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_TOWER_KARST',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Surface Deposits
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_SURFACE_DEPOSITS',
				'IDENTITY_SUK_SURFACE_DEPOSITS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_SURFACE_DEPOSITS',		'IDENTITY_SUK_SURFACE_DEPOSITS_UNIT_PRODUCTION'),
					('IDENTITY_SUK_SURFACE_DEPOSITS',		'IDENTITY_SUK_SURFACE_DEPOSITS_PRODUCTION'),
					('IDENTITY_SUK_SURFACE_DEPOSITS',		'IDENTITY_SUK_SURFACE_DEPOSITS_SCIENCE');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_SURFACE_DEPOSITS_UNIT_PRODUCTION',
						'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION',
						'CITY_HAS_ENCAMPMENT'
					),
					(
						'IDENTITY_SUK_SURFACE_DEPOSITS_PRODUCTION',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'IDENTITY_SUK_SURFACE_DEPOSITS_ENCAMPMENT_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_SURFACE_DEPOSITS_SCIENCE',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE',
						'IDENTITY_SUK_SURFACE_DEPOSITS_ENCAMPMENT_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_SURFACE_DEPOSITS_UNIT_PRODUCTION',	'Amount',			15),

					('IDENTITY_SUK_SURFACE_DEPOSITS_PRODUCTION',		'YieldType',		'YIELD_PRODUCTION'),
					('IDENTITY_SUK_SURFACE_DEPOSITS_PRODUCTION',		'Amount',			2),

					('IDENTITY_SUK_SURFACE_DEPOSITS_SCIENCE',			'YieldType',		'YIELD_SCIENCE'),
					('IDENTITY_SUK_SURFACE_DEPOSITS_SCIENCE',			'Amount',			2);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('IDENTITY_SUK_SURFACE_DEPOSITS_ENCAMPMENT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('IDENTITY_SUK_SURFACE_DEPOSITS_ENCAMPMENT_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_ENCAMPMENT'),
					('IDENTITY_SUK_SURFACE_DEPOSITS_ENCAMPMENT_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_SURFACE_DEPOSITS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_SURFACE_DEPOSITS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SURFACE_DEPOSITS',
					'PropertyName',
					'IDENTITY_SUK_SURFACE_DEPOSITS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_SURFACE_DEPOSITS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Vantage Points
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_VANTAGE_POINTS',
				'IDENTITY_SUK_VANTAGE_POINTS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_VANTAGE_POINTS',		'IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION');

			INSERT INTO GameModifiers
					(ModifierId)
			VALUES	('IDENTITY_SUK_VANTAGE_POINTS_SIGHT');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_VANTAGE_POINTS_ENCAMPMENT_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION_MODIFIER',
						'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE',
						'IDENTITY_SUK_VANTAGE_POINTS_RANGED_OR_RECON_REQUIREMENTS'
					),
					----------------
					(
						'IDENTITY_SUK_VANTAGE_POINTS_SIGHT',
						'MODIFIER_ALL_UNITS_ATTACH_MODIFIER',
						'IDENTITY_SUK_VANTAGE_POINTS_TILE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_VANTAGE_POINTS_SIGHT_MODIFIER',
						'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,												Name,				Value)
			VALUES	('IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION',				'ModifierId',		'IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION_MODIFIER'),
					('IDENTITY_SUK_VANTAGE_POINTS_FREE_PROMOTION_MODIFIER',		'Amount',			-1),

					('IDENTITY_SUK_VANTAGE_POINTS_SIGHT',						'ModifierId',		'IDENTITY_SUK_VANTAGE_POINTS_SIGHT_MODIFIER'),
					('IDENTITY_SUK_VANTAGE_POINTS_SIGHT_MODIFIER',				'Amount',			2);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('IDENTITY_SUK_VANTAGE_POINTS_ENCAMPMENT_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_VANTAGE_POINTS_RANGED_OR_RECON_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY'),
					('IDENTITY_SUK_VANTAGE_POINTS_TILE_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('IDENTITY_SUK_VANTAGE_POINTS_ENCAMPMENT_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_ENCAMPMENT'),
					('IDENTITY_SUK_VANTAGE_POINTS_ENCAMPMENT_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_VANTAGE_POINTS'),

					('IDENTITY_SUK_VANTAGE_POINTS_RANGED_OR_RECON_REQUIREMENTS',	'RECON_UNITS'),
					('IDENTITY_SUK_VANTAGE_POINTS_RANGED_OR_RECON_REQUIREMENTS',	'REQUIREMENT_UNIT_IS_RANGED'),

					('IDENTITY_SUK_VANTAGE_POINTS_TILE_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_VANTAGE_POINTS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_VANTAGE_POINTS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_VANTAGE_POINTS',
					'PropertyName',
					'IDENTITY_SUK_VANTAGE_POINTS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_VANTAGE_POINTS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Geyser Field
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_GEYSER_FIELD',
				'IDENTITY_SUK_GEYSER_FIELD',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_GEYSER_FIELD',		'IDENTITY_SUK_GEYSER_FIELD_YIELDS'),
					('IDENTITY_SUK_GEYSER_FIELD',		'IDENTITY_SUK_GEYSER_FIELD_YIELDS_CONSERVATION'),

					('IDENTITY_SUK_GEYSER_FIELD',		'IDENTITY_SUK_GEYSER_FIELD_ADJACENCY'),
					('IDENTITY_SUK_GEYSER_FIELD',		'IDENTITY_SUK_GEYSER_FIELD_TOURISM');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES	(
						'IDENTITY_SUK_GEYSER_FIELD_YIELDS',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_REQUIREMENTS',
						'IDENTITY_SUK_GEYSER_FIELD_GEYSER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_GEYSER_FIELD_YIELDS_CONSERVATION',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_CONSERVATION_REQUIREMENTS',
						'IDENTITY_SUK_GEYSER_FIELD_GEYSER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',
						'MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY',
						'IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_GEYSER_FIELD_TOURISM',
						'MODIFIER_CITY_DISTRICTS_ADJUST_TOURISM_CHANGE',
						'IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_CONSERVATION_REQUIREMENTS',
						'IDENTITY_SUK_GEYSER_FIELD_GEYSER_ADJACENCY_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,												Name,				Value)
			VALUES	('IDENTITY_SUK_GEYSER_FIELD_YIELDS',						'YieldType',		'YIELD_SCIENCE,YIELD_CULTURE'),
					('IDENTITY_SUK_GEYSER_FIELD_YIELDS',						'Amount',			'-1,1'),

					('IDENTITY_SUK_GEYSER_FIELD_YIELDS_CONSERVATION',			'YieldType',		'YIELD_CULTURE,YIELD_FOOD'),
					('IDENTITY_SUK_GEYSER_FIELD_YIELDS_CONSERVATION',			'Amount',			'1,2'),

					('IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',						'DistrictType',		'DISTRICT_THEATER'),
					('IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',						'FeatureType',		'FEATURE_GEOTHERMAL_FISSURE'),
					('IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',						'YieldType',		'YIELD_CULTURE'),
					('IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',						'Amount',			2),
					('IDENTITY_SUK_GEYSER_FIELD_ADJACENCY',						'Description',		'LOC_IDENTITY_SUK_GEYSER_FIELD_CLTURE'),

					('IDENTITY_SUK_GEYSER_FIELD_TOURISM',						'Amount',			4);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_CONSERVATION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_ADJACENCY_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,														RequirementId)
			VALUES	('IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_REQUIREMENTS',					'REQUIRES_SUK_CITY_HAS_NO_CAMPUS'),

					('IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_CONSERVATION_REQUIREMENTS',		'REQUIRES_SUK_CITY_HAS_NO_CAMPUS'),
					('IDENTITY_SUK_GEYSER_FIELD_NO_CAMPUS_CONSERVATION_REQUIREMENTS',		'REQUIRES_PLAYER_HAS_CONSERVATION'),

					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_REQUIREMENTS',						'REQUIRES_PLOT_IDENTITY_SUK_GEYSER_FIELD'),
					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_REQUIREMENTS',						'REQUIRES_PLOT_HAS_GEOTHERMAL_FIISSURE'),

					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_ADJACENCY_REQUIREMENTS',				'REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER'),
					('IDENTITY_SUK_GEYSER_FIELD_GEYSER_ADJACENCY_REQUIREMENTS',				'PLOT_ADJACENT_TO_GEOTHERMAL_FISSURE_REQUIREMENT');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_GEYSER_FIELD',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_GEYSER_FIELD',
					'PropertyName',
					'IDENTITY_SUK_GEYSER_FIELD'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_GEYSER_FIELD',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Ominous Forest
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_OMINOUS_FOREST',
				'IDENTITY_SUK_OMINOUS_FOREST',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_OMINOUS_FOREST',		'IDENTITY_SUK_OMINOUS_FOREST_NEG_AMENITIES'),
					('IDENTITY_SUK_OMINOUS_FOREST',		'IDENTITY_SUK_OMINOUS_FOREST_YIELDS'),
					('IDENTITY_SUK_OMINOUS_FOREST',		'IDENTITY_SUK_OMINOUS_FOREST_HOLY_SITE'),
					('IDENTITY_SUK_OMINOUS_FOREST',		'IDENTITY_SUK_OMINOUS_FOREST_THEATER');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_OMINOUS_FOREST_NEG_AMENITIES',
						'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',
						'IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_OMINOUS_FOREST_YIELDS',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_REQUIREMENTS',
						'IDENTITY_SUK_OMINOUS_FOREST_TILE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_OMINOUS_FOREST_HOLY_SITE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_HOLY_SITE_REQUIREMENTS',
						'IDENTITY_SUK_OMINOUS_FOREST_TILE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_OMINOUS_FOREST_THEATER',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_THEATER_REQUIREMENTS',
						'IDENTITY_SUK_OMINOUS_FOREST_TILE_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_OMINOUS_FOREST_NEG_AMENITIES',	'Amount',			-1),

					('IDENTITY_SUK_OMINOUS_FOREST_YIELDS',			'YieldType',		'YIELD_FAITH,YIELD_CULTURE'),
					('IDENTITY_SUK_OMINOUS_FOREST_YIELDS',			'Amount',			'1,1'),

					('IDENTITY_SUK_OMINOUS_FOREST_HOLY_SITE',		'YieldType',		'YIELD_FAITH,YIELD_CULTURE'),
					('IDENTITY_SUK_OMINOUS_FOREST_HOLY_SITE',		'Amount',			'1,1'),

					('IDENTITY_SUK_OMINOUS_FOREST_THEATER',			'YieldType',		'YIELD_FAITH,YIELD_CULTURE'),
					('IDENTITY_SUK_OMINOUS_FOREST_THEATER',			'Amount',			'1,1');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_HOLY_SITE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_THEATER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_OMINOUS_FOREST_TILE_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,														RequirementId)
			VALUES	('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_REQUIREMENTS',					'REQUIRES_SUK_CITY_HAS_NO_CAMPUS'),

					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_HOLY_SITE_REQUIREMENTS',		'REQUIRES_SUK_CITY_HAS_NO_CAMPUS'),
					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_HOLY_SITE_REQUIREMENTS',		'REQUIRES_CITY_HAS_HOLY_SITE'),

					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_THEATER_REQUIREMENTS',			'REQUIRES_SUK_CITY_HAS_NO_CAMPUS'),
					('IDENTITY_SUK_OMINOUS_FOREST_NO_CAMPUS_THEATER_REQUIREMENTS',			'REQUIRES_CITY_HAS_THEATER_DISTRICT'),

					('IDENTITY_SUK_OMINOUS_FOREST_TILE_REQUIREMENTS',						'REQUIRES_PLOT_IDENTITY_SUK_OMINOUS_FOREST');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_OMINOUS_FOREST',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_OMINOUS_FOREST',
					'PropertyName',
					'IDENTITY_SUK_OMINOUS_FOREST'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_OMINOUS_FOREST',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Sturdy Reeds
--==========================================================================================================================
	-- Update Text If Oceans Active
	--------------------------------------------------------------------
		UPDATE Suk_UrbanIdentities
		SET Description = 'LOC_IDENTITY_SUK_STURDY_REEDS_DESCRIPTION_OCEANS'
		WHERE
			IdentityType = 'IDENTITY_SUK_STURDY_REEDS'
			AND EXISTS (SELECT * FROM Requirements WHERE RequirementId = 'REQUIRES_PLOT_HAS_SUK_KELP');
	--------------------------------------------------------------------
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_STURDY_REEDS',
				'IDENTITY_SUK_STURDY_REEDS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_STURDY_REEDS',		'IDENTITY_SUK_STURDY_REEDS_CITY_CENTER'),
					('IDENTITY_SUK_STURDY_REEDS',		'IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_STURDY_REEDS_CITY_CENTER',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_STURDY_REEDS_CITY_CENTER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,				Value)
			VALUES	('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER',		'YieldType',		'YIELD_PRODUCTION'),
					('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER',		'Amount',			1),

					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB',	'YieldType',		'YIELD_PRODUCTION'),
					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB',	'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_STURDY_REEDS_IS_LAKE_OR_KELP_REQUIREMENTS',	'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER_REQUIREMENTS',		'REQUIRES_SUK_STURDY_REEDS_NEAR_CITY_CENTER'),
					('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER_REQUIREMENTS',		'REQUIRES_SUK_STURDY_REEDS_IS_LAKE_OR_KELP'),
					('IDENTITY_SUK_STURDY_REEDS_CITY_CENTER_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_STURDY_REEDS'),

					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIRES_SUK_STURDY_REEDS_NEAR_COMMERCIAL_HUB'),
					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIRES_SUK_STURDY_REEDS_IS_LAKE_OR_KELP'),
					('IDENTITY_SUK_STURDY_REEDS_COMMERCIAL_HUB_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_STURDY_REEDS'),

					('IDENTITY_SUK_STURDY_REEDS_IS_LAKE_OR_KELP_REQUIREMENTS',	'REQUIRES_PLOT_IS_LAKE');

			INSERT INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			SELECT 'IDENTITY_SUK_STURDY_REEDS_IS_LAKE_OR_KELP_REQUIREMENTS',	'REQUIRES_PLOT_HAS_SUK_KELP'
			WHERE EXISTS
				(SELECT * FROM Requirements WHERE RequirementId = 'REQUIRES_PLOT_HAS_SUK_KELP');
		----------------------
		-- Suk_Identities_DistrictAdjacencyRequirements
		----------------------
			INSERT INTO Suk_Identities_DistrictAdjacencyRequirements
					(
						RequirementId,
						DistrictType,
						MinRange,
						MaxRange
					)
			VALUES
					(
						'REQUIRES_SUK_STURDY_REEDS_NEAR_CITY_CENTER',
						'DISTRICT_CITY_CENTER',
						NULL,
						2
					),
					(
						'REQUIRES_SUK_STURDY_REEDS_NEAR_COMMERCIAL_HUB',
						'DISTRICT_COMMERCIAL_HUB',
						NULL,
						2
					);
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_SUK_STURDY_REEDS_IS_LAKE_OR_KELP',		'REQUIREMENT_REQUIREMENTSET_IS_MET'),
					('REQUIRES_PLOT_IDENTITY_SUK_STURDY_REEDS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_SUK_STURDY_REEDS_IS_LAKE_OR_KELP',
					'RequirementSetId',
					'IDENTITY_SUK_STURDY_REEDS_IS_LAKE_OR_KELP_REQUIREMENTS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_STURDY_REEDS',
					'PropertyName',
					'IDENTITY_SUK_STURDY_REEDS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_STURDY_REEDS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Windy Plains
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_WINDY_PLAINS',
				'IDENTITY_SUK_WINDY_PLAINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_WINDY_PLAINS',		'IDENTITY_SUK_WINDY_PLAINS_MINE'),
					('IDENTITY_SUK_WINDY_PLAINS',		'IDENTITY_SUK_WINDY_PLAINS_FARM'),
					('IDENTITY_SUK_WINDY_PLAINS',		'IDENTITY_SUK_WINDY_PLAINS_PLAINS_WIND_FARM'),
					('IDENTITY_SUK_WINDY_PLAINS',		'IDENTITY_SUK_WINDY_PLAINS_GRASSLANDS_WIND_FARM');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_WINDY_PLAINS_MINE',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_WINDY_PLAINS_INDUSTRIAL_ZONE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_WINDY_PLAINS_FARM',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_WINDY_PLAINS_INDUSTRIAL_ZONE_REQUIREMENTS'
					),

					(
						'IDENTITY_SUK_WINDY_PLAINS_MINE_MOD',
						'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_MINE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_WINDY_PLAINS_FARM_MOD',
						'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_FARM_REQUIREMENTS'
					),

					(
						'IDENTITY_SUK_WINDY_PLAINS_PLAINS_WIND_FARM',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN',
						NULL
					),
					(
						'IDENTITY_SUK_WINDY_PLAINS_GRASSLANDS_WIND_FARM',
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,					Value)
			VALUES	('IDENTITY_SUK_WINDY_PLAINS_MINE',					'ModifierId',			'IDENTITY_SUK_WINDY_PLAINS_MINE_MOD'),
					('IDENTITY_SUK_WINDY_PLAINS_MINE_MOD',				'YieldType',			'YIELD_PRODUCTION'),
					('IDENTITY_SUK_WINDY_PLAINS_MINE_MOD',				'Amount',				2),

					('IDENTITY_SUK_WINDY_PLAINS_FARM',					'ModifierId',			'IDENTITY_SUK_WINDY_PLAINS_FARM_MOD'),
					('IDENTITY_SUK_WINDY_PLAINS_FARM_MOD',				'YieldType',			'YIELD_FOOD'),
					('IDENTITY_SUK_WINDY_PLAINS_FARM_MOD',				'Amount',				2),

					('IDENTITY_SUK_WINDY_PLAINS_PLAINS_WIND_FARM',		'ImprovementType',		'IMPROVEMENT_WIND_FARM'),
					('IDENTITY_SUK_WINDY_PLAINS_PLAINS_WIND_FARM',		'TerrainType',			'TERRAIN_PLAINS'),

					('IDENTITY_SUK_WINDY_PLAINS_GRASSLANDS_WIND_FARM',	'ImprovementType',		'IMPROVEMENT_WIND_FARM'),
					('IDENTITY_SUK_WINDY_PLAINS_GRASSLANDS_WIND_FARM',	'TerrainType',			'TERRAIN_GRASS');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('IDENTITY_SUK_WINDY_PLAINS_INDUSTRIAL_ZONE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_MINE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_FARM_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_WINDY_PLAINS_INDUSTRIAL_ZONE_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_INDUSTRIAL_ZONE'),
					('IDENTITY_SUK_WINDY_PLAINS_INDUSTRIAL_ZONE_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_WINDY_PLAINS'),

					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_MINE_REQUIREMENTS',	'ADJACENT_TO_OWNER'),
					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_MINE_REQUIREMENTS',	'REQUIRES_PLOT_HAS_MINE'),

					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_FARM_REQUIREMENTS',	'ADJACENT_TO_OWNER'),
					('IDENTITY_SUK_WINDY_PLAINS_IS_ADJACENT_FARM_REQUIREMENTS',	'REQUIRES_PLOT_HAS_FARM');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_WINDY_PLAINS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_WINDY_PLAINS',
					'PropertyName',
					'IDENTITY_SUK_WINDY_PLAINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_WINDY_PLAINS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Natural Outpost
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_NATURAL_OUTPOST',
				'IDENTITY_SUK_NATURAL_OUTPOST',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_NATURAL_OUTPOST',		'IDENTITY_SUK_NATURAL_OUTPOST_TRADE_ROUTE_CAPACITY'),
					---------
					('IDENTITY_SUK_NATURAL_OUTPOST',		'IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_FOOD'),
					('IDENTITY_SUK_NATURAL_OUTPOST',		'IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_FOOD'),
					---------
					('IDENTITY_SUK_NATURAL_OUTPOST',		'IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_GOLD'),
					('IDENTITY_SUK_NATURAL_OUTPOST',		'IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_GOLD');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_NATURAL_OUTPOST_TRADE_ROUTE_CAPACITY',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',
						'IDENTITY_SUK_NATURAL_OUTPOST_ENCAMPMENT_REQUIREMENTS'
					),
					---------
					(
						'IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_FOOD',
						'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC',
						NULL
					),
					(
						'IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_FOOD',
						'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',
						NULL
					),
					---------
					(
						'IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_GOLD',
						'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_DOMESTIC',
						NULL
					),
					(
						'IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_GOLD',
						'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_FOR_INTERNATIONAL',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,													Name,			Value)
			VALUES	('IDENTITY_SUK_NATURAL_OUTPOST_TRADE_ROUTE_CAPACITY',			'Amount',		2),
					---------
					('IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_FOOD',			'YieldType',	'YIELD_FOOD'),
					('IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_FOOD',			'Amount',		2),
					('IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_FOOD',	'YieldType',	'YIELD_FOOD'),
					('IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_FOOD',	'Amount',		2),
					---------
					('IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_GOLD',			'YieldType',	'YIELD_GOLD'),
					('IDENTITY_SUK_NATURAL_OUTPOST_DOMESTIC_OUTGOING_GOLD',			'Amount',		3),
					('IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_GOLD',	'YieldType',	'YIELD_GOLD'),
					('IDENTITY_SUK_NATURAL_OUTPOST_INTERNATIONAL_OUTGOING_GOLD',	'Amount',		3);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('IDENTITY_SUK_NATURAL_OUTPOST_ENCAMPMENT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_NATURAL_OUTPOST_ENCAMPMENT_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_ENCAMPMENT'),
					('IDENTITY_SUK_NATURAL_OUTPOST_ENCAMPMENT_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_NATURAL_OUTPOST');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId, 									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_NATURAL_OUTPOST',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_NATURAL_OUTPOST',
					'PropertyName',
					'IDENTITY_SUK_NATURAL_OUTPOST'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_NATURAL_OUTPOST',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Undersea Formations
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_UNDERSEA_FORMATIONS',
				'IDENTITY_SUK_UNDERSEA_FORMATIONS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_UNDERSEA_FORMATIONS',		'IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS',		'IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS',		'IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_NO_HARBOR_REQUIREMENTS',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_NO_HARBOR_REQUIREMENTS',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_NO_HARBOR_REQUIREMENTS',
						'IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,			Value)
			VALUES	('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE',	'YieldType',	'YIELD_CULTURE'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE',	'Amount',		2),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE',	'YieldType',	'YIELD_SCIENCE'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE',	'Amount',		1),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH',		'YieldType',	'YIELD_FAITH'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH',		'Amount',		2);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('IDENTITY_SUK_UNDERSEA_FORMATIONS_NO_HARBOR_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('IDENTITY_SUK_UNDERSEA_FORMATIONS_NO_HARBOR_REQUIREMENTS',		'REQUIRES_SUK_CITY_HAS_NO_HARBOR'),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_REEF'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_CULTURE_REQUIREMENTS',		'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_THEATER'),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE_REQUIREMENTS',		'REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE_REQUIREMENTS',		'REQUIRES_PLOT_HAS_REEF'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_SCIENCE_REQUIREMENTS',		'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_CAMPUS'),

					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH_REQUIREMENTS',			'REQUIRES_PLOT_HAS_REEF'),
					('IDENTITY_SUK_UNDERSEA_FORMATIONS_FAITH_REQUIREMENTS',			'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_HOLY_SITE');
		----------------------
		-- Suk_Identities_DistrictAdjacencyRequirements
		----------------------
			INSERT INTO Suk_Identities_DistrictAdjacencyRequirements
					(
						RequirementId,
						DistrictType,
						MinRange,
						MaxRange
					)
			VALUES
					(
						'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_THEATER',
						'DISTRICT_THEATER',
						NULL,
						3
					),
					(
						'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_CAMPUS',
						'DISTRICT_CAMPUS',
						NULL,
						3
					),
					(
						'REQUIRES_PLOT_SUK_UNDERSEA_FORMATIONS_NEAR_HOLY_SITE',
						'DISTRICT_HOLY_SITE',
						NULL,
						3
					);
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS',
					'PropertyName',
					'IDENTITY_SUK_UNDERSEA_FORMATIONS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_UNDERSEA_FORMATIONS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Bird Sanctuary
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_BIRD_SANCTUARY',
				'IDENTITY_SUK_BIRD_SANCTUARY',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,								ModifierId)
			VALUES	('IDENTITY_SUK_BIRD_SANCTUARY',		'IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY'),
					('IDENTITY_SUK_BIRD_SANCTUARY',		'IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY'),
					('IDENTITY_SUK_BIRD_SANCTUARY',		'IDENTITY_SUK_BIRD_SANCTUARY_BASE_AMENITY'),
					('IDENTITY_SUK_BIRD_SANCTUARY',		'IDENTITY_SUK_BIRD_SANCTUARY_EC_AMENITY');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',
						'MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY',
						'IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',
						'MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY',
						'IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_BIRD_SANCTUARY_BASE_AMENITY',
						'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',
						'IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',
						NULL
					),
					(
						'IDENTITY_SUK_BIRD_SANCTUARY_EC_AMENITY',
						'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY',
						'IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',
						'IDENTITY_SUK_BIRD_SANCTUARY_EC_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',		'DistrictType',		'DISTRICT_CAMPUS'),
					('IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',		'FeatureType',		'FEATURE_MARSH'),
					('IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',		'YieldType',		'YIELD_SCIENCE'),
					('IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',		'Amount',			1),
					('IDENTITY_SUK_BIRD_SANCTUARY_MARSH_ADJACENCY',		'Description',		'LOC_IDENTITY_SUK_BIRD_SANCTUARY_MARSH_SCIENCE'),

					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'DistrictType',		'DISTRICT_CAMPUS'),
					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'FeatureType',		'FEATURE_FOREST'),
					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'YieldType',		'YIELD_SCIENCE'),
					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'TilesRequired',	2),
					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'Amount',			1),
					('IDENTITY_SUK_BIRD_SANCTUARY_WOODS_ADJACENCY',		'Description',		'LOC_IDENTITY_SUK_BIRD_SANCTUARY_WOODS_SCIENCE'),

					('IDENTITY_SUK_BIRD_SANCTUARY_BASE_AMENITY',		'Amount',			1),
					('IDENTITY_SUK_BIRD_SANCTUARY_EC_AMENITY',			'Amount',			2);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_BIRD_SANCTUARY_EC_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('IDENTITY_SUK_BIRD_SANCTUARY_NO_IZ_REQUIREMENTS',		'REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE'),

					('IDENTITY_SUK_BIRD_SANCTUARY_EC_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_BIRD_SANCTUARY'),
					('IDENTITY_SUK_BIRD_SANCTUARY_EC_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_ENTERTAINMENT_COMPLEX');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_BIRD_SANCTUARY',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_BIRD_SANCTUARY',
					'PropertyName',
					'IDENTITY_SUK_BIRD_SANCTUARY'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_BIRD_SANCTUARY',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Altitude Training
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_ALTITUDE_TRAINING',		'IDENTITY_SUK_ALTITUDE_TRAINING_GRANT_ABILITY');

			INSERT INTO Suk_UrbanIdentity_Modifiers
					(
						IdentityType,
						ModifierId
					)
			SELECT
						'IDENTITY_SUK_ALTITUDE_TRAINING',
						'IDENTITY_SUK_ALTITUDE_TRAINING_'||TerrainType
			FROM TerrainClass_Terrains WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_ALTITUDE_TRAINING_GRANT_ABILITY',
						'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',
						'IDENTITY_SUK_ALTITUDE_TRAINING_AQUE_OR_ENCMPT_REQUIREMENTS',
						NULL
					);

			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType
					)
			SELECT
						'IDENTITY_SUK_ALTITUDE_TRAINING_'||TerrainType,
						'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY'
			FROM TerrainClass_Terrains WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,											Name,				Value)
			VALUES	('IDENTITY_SUK_ALTITUDE_TRAINING_GRANT_ABILITY',		'AbilityType',		'ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING');

			WITH CTE(Name, Value) AS
				(
					SELECT * FROM (VALUES
						('DistrictType',			'DISTRICT_CITY_CENTER'),
						('YieldType',				'YIELD_FOOD'),
						('Amount',					1),
						('Description',				'LOC_IDENTITY_SUK_ALTITUDE_TRAINING_FOOD'),
						('TerrainType',				NULL)
					)
				)
			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT DISTINCT
						'IDENTITY_SUK_ALTITUDE_TRAINING_'||TerrainClass_Terrains.TerrainType,
						Name,
						CASE WHEN Value IS NOT NULL
							THEN Value
							ELSE TerrainClass_Terrains.TerrainType
						END
			FROM TerrainClass_Terrains CROSS JOIN CTE WHERE TerrainClassType = 'TERRAIN_CLASS_MOUNTAIN';
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('IDENTITY_SUK_ALTITUDE_TRAINING_AQUE_OR_ENCMPT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('IDENTITY_SUK_ALTITUDE_TRAINING_AQUE_OR_ENCMPT_REQUIREMENTS',		'REQUIRES_CITY_HAS_AQUEDUCT'),
					('IDENTITY_SUK_ALTITUDE_TRAINING_AQUE_OR_ENCMPT_REQUIREMENTS',		'REQUIRES_CITY_HAS_ENCAMPMENT');
	--------------------------------------------------------------------
	-- Unit Ability
	--------------------------------------------------------------------
		-- Types
		-------------------------------------
			INSERT INTO Types
					(Type,											Kind)
			VALUES	('ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING',		'KIND_ABILITY');
		-------------------------------------
		-- TypeTags
		-------------------------------------
			INSERT OR REPLACE INTO TypeTags
					(Type,											Tag)
			VALUES	('ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING',		'CLASS_ALL_UNITS');
		-------------------------------------
		-- UnitAbilities
		-------------------------------------
			INSERT INTO UnitAbilities
					(
						UnitAbilityType,
						Name,
						Description,

						Inactive,
						ShowFloatTextWhenEarned,
						Permanent
					)
			VALUES	(
						'ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING',
						'LOC_ABILITY_ALTITUDE_TRAINING_NAME',
						'LOC_ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING_DESCRIPTION',

						1,
						1,
						1
					);
		-------------------------------------
			-- UnitAbilityModifiers
		-------------------------------------
			INSERT INTO UnitAbilityModifiers
					(UnitAbilityType,								ModifierId)
			VALUES	('ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING',		'ALTITUDE_TRAINING_IGNORE_HILLS');
--==========================================================================================================================
-- Defensible Cliffs
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_DEFENSIBLE_CLIFFS',
				'IDENTITY_SUK_DEFENSIBLE_CLIFFS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_DEFENSIBLE_CLIFFS',		'IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY'),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS',		'IDENTITY_SUK_DEFENSIBLE_CLIFFS_TRADE_ROUTE');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',
						'MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY',
						NULL
					),
					(
						'IDENTITY_SUK_DEFENSIBLE_CLIFFS_TRADE_ROUTE',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY',
						'IDENTITY_SUK_DEFENSIBLE_CLIFFS_ENCAMPMENT_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,											Name,				Value)
			VALUES	('IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',		'DistrictType',		'DISTRICT_ENCAMPMENT'),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',		'TerrainType',		'TERRAIN_COAST'),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',		'YieldType',		'YIELD_GOLD'),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',		'Amount',			1),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_COAST_ADJACENCY',		'Description',		'LOC_IDENTITY_SUK_DEFENSIBLE_CLIFFS_GOLD'),

					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_TRADE_ROUTE',			'Amount',			1);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_DEFENSIBLE_CLIFFS_ENCAMPMENT_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_DEFENSIBLE_CLIFFS_ENCAMPMENT_REQUIREMENTS',	'REQUIRES_PLOT_IDENTITY_SUK_DEFENSIBLE_CLIFFS'),
					('IDENTITY_SUK_DEFENSIBLE_CLIFFS_ENCAMPMENT_REQUIREMENTS',	'REQUIRES_DISTRICT_IS_ENCAMPMENT');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_DEFENSIBLE_CLIFFS',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_DEFENSIBLE_CLIFFS',
					'PropertyName',
					'IDENTITY_SUK_DEFENSIBLE_CLIFFS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_DEFENSIBLE_CLIFFS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Clay Deposits
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_CLAY_DEPOSITS',
				'IDENTITY_SUK_CLAY_DEPOSITS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,						ModifierId)
			VALUES	('IDENTITY_SUK_CLAY_DEPOSITS',		'IDENTITY_SUK_CLAY_DEPOSITS_CULTURE'),
					('IDENTITY_SUK_CLAY_DEPOSITS',		'IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_CLAY_DEPOSITS_CULTURE',
						'MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE',
						'IDENTITY_SUK_CLAY_DEPOSITS_THEATER_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_CLAY_DEPOSITS_ADJACENT_IZ_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION_MOD',
						'MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,									Name,					Value)
			VALUES	('IDENTITY_SUK_CLAY_DEPOSITS_CULTURE',			'YieldType',			'YIELD_CULTURE'),
					('IDENTITY_SUK_CLAY_DEPOSITS_CULTURE',			'Amount',				2),

					('IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION',		'ModifierId',			'IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION_MOD'),
					('IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION_MOD',	'YieldTypeToMirror',	'YIELD_CULTURE'),
					('IDENTITY_SUK_CLAY_DEPOSITS_PRODUCTION_MOD',	'YieldTypeToGrant',		'YIELD_PRODUCTION');
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('IDENTITY_SUK_CLAY_DEPOSITS_THEATER_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_CLAY_DEPOSITS_ADJACENT_IZ_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_CLAY_DEPOSITS_THEATER_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_CLAY_DEPOSITS'),
					('IDENTITY_SUK_CLAY_DEPOSITS_THEATER_REQUIREMENTS',			'REQUIRES_DISTRICT_IS_THEATER'),

					('IDENTITY_SUK_CLAY_DEPOSITS_ADJACENT_IZ_REQUIREMENTS',		'REQUIRES_DISTRICT_IS_THEATER'),
					('IDENTITY_SUK_CLAY_DEPOSITS_ADJACENT_IZ_REQUIREMENTS',		'REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_INDUSTRIAL_ZONE');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_CLAY_DEPOSITS',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_CLAY_DEPOSITS',
					'PropertyName',
					'IDENTITY_SUK_CLAY_DEPOSITS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_CLAY_DEPOSITS',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
-- Impact Structures
--==========================================================================================================================
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_IMPACT_STRUCTURES',		'SUK_IDENTITY_GENERIC_DISTRICT_MALUS'),
					('IDENTITY_SUK_IMPACT_STRUCTURES',		'IDENTITY_SUK_IMPACT_STRUCTURES_GRANT_ABILITY'),
					('IDENTITY_SUK_IMPACT_STRUCTURES',		'IDENTITY_SUK_IMPACT_STRUCTURES_SPACE_PROJECTS');
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						OwnerRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_IMPACT_STRUCTURES_GRANT_ABILITY',
						'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',
						'IDENTITY_SUK_IMPACT_STRUCTURES_HOLY_SITE_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT',
						'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
						NULL
					),
					(
						'IDENTITY_SUK_IMPACT_STRUCTURES_SPACE_PROJECTS',
						'MODIFIER_SINGLE_CITY_ADJUST_SPACE_RACE_PROJECTS_PRODUCTION',
						'IDENTITY_SUK_IMPACT_STRUCTURES_SPACEPORT_REQUIREMENTS'
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,				Value)
			VALUES	('IDENTITY_SUK_IMPACT_STRUCTURES_GRANT_ABILITY',	'AbilityType',		'ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES'),
					('IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT',	'Amount',			5),
					('IDENTITY_SUK_IMPACT_STRUCTURES_SPACE_PROJECTS',	'Amount',			30);
		----------------------
		-- ModifierStrings
		----------------------
			INSERT INTO ModifierStrings
				(
					ModifierId,
					Context,
					'Text'
				)
			VALUES
				(
					"IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT",
					"Preview",
					"LOC_IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT_MODIFIER_DESCRIPTION"
				);
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_IMPACT_STRUCTURES_HOLY_SITE_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_IMPACT_STRUCTURES_SPACEPORT_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('IDENTITY_SUK_IMPACT_STRUCTURES_HOLY_SITE_REQUIREMENTS',	'REQUIRES_CITY_HAS_HOLY_SITE'),
					('IDENTITY_SUK_IMPACT_STRUCTURES_HOLY_SITE_REQUIREMENTS',	'REQUIRES_SUK_CITY_HAS_NO_SPACEPORT'),

					('IDENTITY_SUK_IMPACT_STRUCTURES_SPACEPORT_REQUIREMENTS',	'REQUIRES_CITY_HAS_SPACEPORT'),
					('IDENTITY_SUK_IMPACT_STRUCTURES_SPACEPORT_REQUIREMENTS',	'REQUIRES_SUK_CITY_HAS_NO_HOLY_SITE');
	--------------------------------------------------------------------
	-- Unit Ability
	--------------------------------------------------------------------
		-- Types
		-------------------------------------
			INSERT INTO Types
					(Type,											Kind)
			VALUES	('ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES',		'KIND_ABILITY');
		-------------------------------------
		-- TypeTags
		-------------------------------------
			INSERT OR REPLACE INTO TypeTags
					(Type,											Tag)
			VALUES	('ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES',		'CLASS_RELIGIOUS_ALL');
		-------------------------------------
		-- UnitAbilities
		-------------------------------------
			INSERT INTO UnitAbilities
					(
						UnitAbilityType,
						Name,
						Description,

						Inactive,
						ShowFloatTextWhenEarned,
						Permanent
					)
			VALUES	(
						'ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES',
						'LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_NAME',
						'LOC_ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES_DESCRIPTION',

						1,
						1,
						1
					);
		-------------------------------------
			-- UnitAbilityModifiers
		-------------------------------------
			INSERT INTO UnitAbilityModifiers
					(UnitAbilityType,								ModifierId)
			VALUES	('ABILITY_IDENTITY_SUK_IMPACT_STRUCTURES',		'IDENTITY_SUK_IMPACT_STRUCTURES_RELIGOUS_COMBAT');
--==========================================================================================================================
-- Igneous Intrusion
--==========================================================================================================================
	-- Region Properties
	--------------------------------------------------------------------
		INSERT INTO Suk_UrbanIdentity_PlotProperties
			(
				IdentityType,
				PropertyName,
				PropertyValue
			)
		VALUES
			(
				'IDENTITY_SUK_IGNEOUS_INTRUSION',
				'IDENTITY_SUK_IGNEOUS_INTRUSION',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- Suk_UrbanIdentity_Modifiers
		-------------------------------------
			INSERT INTO Suk_UrbanIdentity_Modifiers
					(IdentityType,							ModifierId)
			VALUES	('IDENTITY_SUK_IGNEOUS_INTRUSION',		'IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION',		'IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER');

			INSERT INTO Suk_UrbanIdentity_Modifiers
					(
						IdentityType,
						ModifierId
					)
			SELECT
						'IDENTITY_SUK_IGNEOUS_INTRUSION',
						'IDENTITY_SUK_IGNEOUS_INTRUSION_'||TerrainType
			FROM Terrains WHERE TerrainType LIKE '%_HILLS';
		----------------------
		-- Modifiers
		----------------------
			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType,
						SubjectRequirementSetId
					)
			VALUES
					(
						'IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY',
						'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
						'IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER',
						'MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER',
						'IDENTITY_SUK_IGNEOUS_INTRUSION_IZ_REQUIREMENTS'
					),
					(
						'IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER_MOD',
						'MODIFIER_SINGLE_CITY_ADJUST_WONDER_PRODUCTION',
						NULL
					);

			INSERT INTO Modifiers
					(
						ModifierId,
						ModifierType
					)
			SELECT
						'IDENTITY_SUK_IGNEOUS_INTRUSION_'||TerrainType,
						'MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN'
			FROM Terrains WHERE TerrainType LIKE '%_HILLS';
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,										Name,					Value)
			VALUES	('IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY',			'YieldType',			'YIELD_PRODUCTION'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY',			'Amount',				1),

					('IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER',			'ModifierId',			'IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER_MOD'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION_WONDER_MOD',		'Amount',				15);

			WITH CTE(Name, Value) AS
				(
					SELECT * FROM (VALUES
						('ImprovementType',			'IMPROVEMENT_QUARRY'),
						('TerrainType',				NULL)
					)
				)
			INSERT INTO ModifierArguments
					(
						ModifierId,
						Name,
						Value
					)
			SELECT DISTINCT
						'IDENTITY_SUK_IGNEOUS_INTRUSION_'||Terrains.TerrainType,
						CTE.Name,
						CASE WHEN CTE.Value IS NOT NULL
							THEN CTE.Value
							ELSE Terrains.TerrainType
						END
			FROM Terrains CROSS JOIN CTE WHERE TerrainType LIKE '%_HILLS';
	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION_IZ_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY_REQUIREMENTS',			'REQUIRES_PLOT_IDENTITY_SUK_IGNEOUS_INTRUSION'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION_QUARRY_REQUIREMENTS',			'REQUIRES_PLOT_HAS_QUARRY'),

					('IDENTITY_SUK_IGNEOUS_INTRUSION_IZ_REQUIREMENTS',				'REQUIRES_PLOT_IDENTITY_SUK_IGNEOUS_INTRUSION'),
					('IDENTITY_SUK_IGNEOUS_INTRUSION_IZ_REQUIREMENTS',				'REQUIRES_DISTRICT_IS_INDUSTRIAL_ZONE');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_IGNEOUS_INTRUSION',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
		-------------------------------------
		-- RequirementArguments
		-------------------------------------
			INSERT OR IGNORE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			VALUES
				(
					'REQUIRES_PLOT_IDENTITY_SUK_IGNEOUS_INTRUSION',
					'PropertyName',
					'IDENTITY_SUK_IGNEOUS_INTRUSION'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_IGNEOUS_INTRUSION',
					'PropertyMinimum',
					1
				);
--==========================================================================================================================
--==========================================================================================================================