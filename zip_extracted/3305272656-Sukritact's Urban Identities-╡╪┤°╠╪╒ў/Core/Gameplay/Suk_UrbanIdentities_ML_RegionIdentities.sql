-- Suk_UrbanIdentities_ML_RegionIdentities
-- Migrated from More Urban Identities (Maple_Leaves)
-- These identities depend on Sukritact's original Regions (REGION_SUK_*)
--==========================================================================================================================
-- Vertical Climate
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
				'IDENTITY_SUK_ML_VERTICAL_CLIMATE',
				'IDENTITY_SUK_ML_VERTICAL_CLIMATE',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE'),
		('IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE_2'),
		('IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'IDENTITY_SUK_ML_VERTICAL_CLIMATE_CAMPUS_PRODUCTION');

	-------------------------------------		
	-- 1 Plot Science
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE'),
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE_2', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, 'REQSET_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML', 'REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE',	'YieldType',	'YIELD_SCIENCE'),
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE',	'Amount',		'1'),
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE_2', 'YieldType',	'YIELD_SCIENCE'),
	('IDENTITY_SUK_ML_VERTICAL_CLIMATE_PLOT_SCIENCE_2', 'Amount',		'1');

	-------------------------------------		
	-- 2 Production, CAMPUS
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_VERTICAL_CLIMATE_CAMPUS_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_VERTICAL_CLIMATE_CAMPUS_PRODUCTION', 'Amount', '30'), 
('IDENTITY_SUK_ML_VERTICAL_CLIMATE_CAMPUS_PRODUCTION', 'DistrictType', 'DISTRICT_CAMPUS');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',			'REQUIREMENTSET_TEST_ALL'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',			'REQUIRES_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'REQUIRES_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',	'REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML',		'REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,												RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',
					'PropertyName',
					'IDENTITY_SUK_ML_VERTICAL_CLIMATE'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VERTICAL_CLIMATE',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Monsoon Valley
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
				'IDENTITY_SUK_ML_MONSOON_VALLEY',
				'IDENTITY_SUK_ML_MONSOON_VALLEY',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_MONSOON_VALLEY',	'IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_FOOD'),
		('IDENTITY_SUK_ML_MONSOON_VALLEY',	'IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_GOLD');

	-------------------------------------		
	-- 1 Plot Food
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_FOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_JUNGLE_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_FOOD', 'YieldType',	'YIELD_FOOD'),
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_FOOD', 'Amount',		'2');

	-------------------------------------		
	-- 2 Plot Gold
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_GOLD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_PLANTATION_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_GOLD', 'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_MONSOON_VALLEY_PLOT_GOLD', 'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_JUNGLE_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',		'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLANTATION_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',				'REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY'),
					('REQSET_JUNGLE_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',		'REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY'),
					('REQSET_JUNGLE_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',		'REQUIRES_PLOT_HAS_JUNGLE'),
					('REQSET_PLANTATION_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',	'REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY'),
					('REQSET_PLANTATION_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',	'REQUIRES_PLOT_HAS_PLANTATION');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,												RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',
					'PropertyName',
					'IDENTITY_SUK_ML_MONSOON_VALLEY'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_MONSOON_VALLEY',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Yew Grove
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
				'IDENTITY_SUK_ML_YEW_GROVE',
				'IDENTITY_SUK_ML_YEW_GROVE',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,					ModifierId)
VALUES	('IDENTITY_SUK_ML_YEW_GROVE',	'IDENTITY_SUK_ML_YEW_GROVE_PLOT_PRODUCTION'),
		('IDENTITY_SUK_ML_YEW_GROVE',	'IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION'),
		('IDENTITY_SUK_ML_YEW_GROVE',	'IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_2'),
		('IDENTITY_SUK_ML_YEW_GROVE',	'IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_3');

	-------------------------------------		
	-- 1 Plot Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_YEW_GROVE_PLOT_PRODUCTION', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_LUMBER_MILL_PLOT_IDENTITY_SUK_ML_YEW_GROVE');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_YEW_GROVE_PLOT_PRODUCTION',	'YieldType',	'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_YEW_GROVE_PLOT_PRODUCTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Unit Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, 'REQSET_PLOT_IDENTITY_SUK_ML_YEW_GROVE', NULL),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_2', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, 'REQSET_PLOT_IDENTITY_SUK_ML_YEW_GROVE', NULL),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_3', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, 'REQSET_PLOT_IDENTITY_SUK_ML_YEW_GROVE', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value, Extra) 
VALUES 
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION',	'UnitPromotionClass',	'PROMOTION_CLASS_RANGED',	'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION',	'EraType',				'ERA_ANCIENT',				'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION',	'Amount',				'30',						'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_2',	'UnitPromotionClass',	'PROMOTION_CLASS_RANGED',	'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_2',	'EraType',				'ERA_CLASSICAL',			'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_2',	'Amount',				'30',						'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_3',	'UnitPromotionClass',	'PROMOTION_CLASS_RANGED',	'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_3',	'EraType',				'ERA_MEDIEVAL',				'-1'),
	('IDENTITY_SUK_ML_YEW_GROVE_UNIT_PRODUCTION_3',	'Amount',				'30',						'-1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_YEW_GROVE',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_LUMBER_MILL_PLOT_IDENTITY_SUK_ML_YEW_GROVE',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_YEW_GROVE',				'REQUIRES_PLOT_IDENTITY_SUK_ML_YEW_GROVE'),
					('REQSET_LUMBER_MILL_PLOT_IDENTITY_SUK_ML_YEW_GROVE',	'REQUIRES_PLOT_IDENTITY_SUK_ML_YEW_GROVE'),
					('REQSET_LUMBER_MILL_PLOT_IDENTITY_SUK_ML_YEW_GROVE',	'REQUIRES_PLOT_HAS_LUMBER_MILL');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_YEW_GROVE',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_YEW_GROVE',
					'PropertyName',
					'IDENTITY_SUK_ML_YEW_GROVE'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_YEW_GROVE',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Oasis Trading Post
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
				'IDENTITY_SUK_ML_OASIS_TRADING_POST',
				'IDENTITY_SUK_ML_OASIS_TRADING_POST',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_OASIS_TRADING_POST',	'IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY'),
		('IDENTITY_SUK_ML_OASIS_TRADING_POST',	'IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_TRADE_ROUTE_CAPACITY');

	-------------------------------------		
	-- 1 Adjacency COMMERCIAL_HUB
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY', 'MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY',	'DistrictType',	'DISTRICT_COMMERCIAL_HUB'),
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY',	'FeatureType',	'FEATURE_OASIS'),
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY',	'Amount',		'4'),
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_ADJACENCY',	'Description',	'LOC_ID_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_GOLD');

	-------------------------------------		
	-- 2 Trade Route
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_TRADE_ROUTE_CAPACITY',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 1, 1, 0, 'REQSET_CITY_HAS_COMMERCIAL_HUB_SUK_ID_ML', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_OASIS_TRADING_POST_COMMERCIAL_HUB_TRADE_ROUTE_CAPACITY',	'Amount',	'1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST',		'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_SUK_ID_ML',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST',		'REQUIRES_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_SUK_ID_ML',			'REQUIRES_CITY_HAS_COMMERCIAL_HUB');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST',	'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST',
					'PropertyName',
					'IDENTITY_SUK_ML_OASIS_TRADING_POST'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_OASIS_TRADING_POST',
					'PropertyMinimum',
					1
				);