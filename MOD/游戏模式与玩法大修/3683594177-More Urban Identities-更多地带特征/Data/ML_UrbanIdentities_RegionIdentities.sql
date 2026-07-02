-- ML_UrbanIdentities_RegionIdentities
-- Author: Maple_Leaves
-- DateCreated: 2/28/2026 9:53:54 PM
--------------------------------------------------------------


--==========================================================================================================================
-- Wild Tundra
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
				'IDENTITY_SUK_ML_WILD_TUNDRA',
				'IDENTITY_SUK_ML_WILD_TUNDRA',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_WILD_TUNDRA',			'IDENTITY_SUK_ML_WILD_TUNDRA_ENABLE_CAMP'),
		('IDENTITY_SUK_ML_WILD_TUNDRA',			'IDENTITY_SUK_ML_WILD_TUNDRA_CAMP_YIELD'),
		('IDENTITY_SUK_ML_WILD_TUNDRA',			'IDENTITY_SUK_ML_WILD_TUNDRA_RECON_MOVEMENT');

	-------------------------------------		
	-- 1 Enable Camp 
	-------------------------------------
INSERT INTO Modifiers
	(ModifierId,								ModifierType,														SubjectRequirementSetId)
VALUES	
	('IDENTITY_SUK_ML_WILD_TUNDRA_ENABLE_CAMP',	'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN_SUK_ID_ML',	NULL);

INSERT INTO ModifierArguments
	(ModifierId,									Name,					Value)
VALUES	
	('IDENTITY_SUK_ML_WILD_TUNDRA_ENABLE_CAMP',		'ImprovementType',		'IMPROVEMENT_CAMP'),
	('IDENTITY_SUK_ML_WILD_TUNDRA_ENABLE_CAMP',		'TerrainType',			'TERRAIN_TUNDRA');

	-------------------------------------		
	-- 2 Camp Gold 
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_WILD_TUNDRA_CAMP_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_PLOT_HAS_CAMP_WILD_TUNDRA_SUK_ID_ML');
	

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_WILD_TUNDRA_CAMP_YIELD', 'YieldType', 'YIELD_FOOD,YIELD_GOLD'),
	('IDENTITY_SUK_ML_WILD_TUNDRA_CAMP_YIELD', 'Amount', '2,2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,						RequirementSetType)
			VALUES	('REQSET_PLOT_HAS_CAMP_WILD_TUNDRA_SUK_ID_ML',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,							RequirementId)
			VALUES	('REQSET_PLOT_HAS_CAMP_WILD_TUNDRA_SUK_ID_ML',			'REQUIRES_PLOT_IDENTITY_SUK_ML_WILD_TUNDRA'),
					('REQSET_PLOT_HAS_CAMP_WILD_TUNDRA_SUK_ID_ML',			'REQUIRES_PLOT_HAS_CAMP');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_WILD_TUNDRA',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_WILD_TUNDRA',
					'PropertyName',
					'IDENTITY_SUK_ML_WILD_TUNDRA'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_WILD_TUNDRA',
					'PropertyMinimum',
					1
				);

	-------------------------------------		
	-- 2 Recon Movement
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_WILD_TUNDRA_RECON_MOVEMENT', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_WILD_TUNDRA_RECON_MOVEMENT', 'AbilityType', 'ABILITY_IDENTITY_SUK_ML_WILD_TUNDRA');

--==========================================================================================================================
-- Hoi Xil
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
				'IDENTITY_SUK_ML_HOH_XIL',
				'IDENTITY_SUK_ML_HOH_XIL',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_HOH_XIL',			'IDENTITY_SUK_ML_HOH_XIL_PLOT_APPEAL');

	-------------------------------------		
	-- 1 Unit Movement
	-------------------------------------
INSERT INTO GameModifiers
	(ModifierId)
VALUES	
	('IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT',			'MODIFIER_ALL_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'REQSET_PLOT_IDENTITY_SUK_ML_HOH_XIL'),
('IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT_MODIFIER',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT',			'ModifierId',	'IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT_MODIFIER'),
('IDENTITY_SUK_ML_HOH_XIL_UNIT_MOVEMENT_MODIFIER',	'Amount',		'-1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,							RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_HOH_XIL',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,							RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_HOH_XIL',		'REQUIRES_PLOT_IDENTITY_SUK_ML_HOH_XIL');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,									RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_HOH_XIL',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_HOH_XIL',
					'PropertyName',
					'IDENTITY_SUK_ML_HOH_XIL'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_HOH_XIL',
					'PropertyMinimum',
					1
				);

	-------------------------------------		
	-- 2 Plot Appeal
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_HOH_XIL_PLOT_APPEAL', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_HOH_XIL_PLOT_APPEAL', 'Amount', '1');

	-------------------------------------		
	-- 3 Preserve Production
	-------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
	(IdentityType,						ModifierId)
SELECT	
	'IDENTITY_SUK_ML_HOH_XIL',			'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_PRODUCTION'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId)
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 0, 0, 0, NULL, NULL
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_PRODUCTION',	'DistrictType',	'DISTRICT_PRESERVE'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_PRODUCTION', 'Amount',		'30'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');


INSERT INTO Suk_UrbanIdentity_Modifiers
	(IdentityType,						ModifierId)
SELECT	
	'IDENTITY_SUK_ML_HOH_XIL',			'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_BUILDING_PRODUCTION'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId)
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_BUILDING_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_SUK_ID_ML', 0, 0, 0, NULL, NULL
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_BUILDING_PRODUCTION',	'DistrictType',	'DISTRICT_PRESERVE'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_HOH_XIL_PRESERVE_BUILDING_PRODUCTION', 'Amount',		'30'
WHERE EXISTS (SELECT * FROM Districts WHERE DistrictType ='DISTRICT_PRESERVE');

--==========================================================================================================================
-- Scientific Frontier
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
				'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',
				'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',			'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_PRODUCTION'),
		('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',			'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY'),
		('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',			'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2'),
		('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER',			'IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3');

	-------------------------------------		
	-- 1 Production, CAMPUS
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_PRODUCTION', 'Amount', '30'), 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_PRODUCTION', 'DistrictType', 'DISTRICT_CAMPUS');

	-------------------------------------		
	-- 2 Adjacency, CAMPUS
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 0, 0, 0, NULL, NULL),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 0, 0, 0, NULL, NULL),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 

('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'DistrictType', 'DISTRICT_CAMPUS'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'TerrainType', 'TERRAIN_SNOW'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'YieldType', 'YIELD_SCIENCE'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'Amount', '1'), 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY', 'Description', 'LOC_ID_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_SCIENCE'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'DistrictType', 'DISTRICT_CAMPUS'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'TerrainType', 'TERRAIN_SNOW_HILLS'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'YieldType', 'YIELD_SCIENCE'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'Amount', '1'), 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_2', 'Description', 'LOC_ID_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_SCIENCE'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'DistrictType', 'DISTRICT_CAMPUS'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'TerrainType', 'TERRAIN_SNOW_MOUNTAIN'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'YieldType', 'YIELD_SCIENCE'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'Amount', '1'), 
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_ADJACENCY_3', 'Description', 'LOC_ID_SUK_ML_SCIENTIFIC_FRONTIER_CAMPUS_SCIENCE');

--==========================================================================================================================
-- Confluence of Currents
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
				'IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',
				'IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_PLOT_FOOD'),
		('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_IMPROVED_WATER_PLOT_GOLD');

	-------------------------------------		
	-- 1 Plot Food
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_PLOT_FOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_PLOT_FOOD', 'YieldType',	'YIELD_FOOD'),
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_PLOT_FOOD', 'Amount',		'1');

	-------------------------------------		
	-- 2 Improved Water Plot Gold
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_IMPROVED_WATER_PLOT_GOLD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_WATER_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_IMPROVED_WATER_PLOT_GOLD', 'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS_IMPROVED_WATER_PLOT_GOLD', 'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,														RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_WATER_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,														RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS'),
					('REQSET_IMPROVED_WATER_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'REQUIRES_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS'),
					('REQSET_IMPROVED_WATER_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_IMPROVED_WATER_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'REQUIRES_PLOT_HAS_WATER_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,												RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',	'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',
					'PropertyName',
					'IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_CONFLUENCE_OF_CURRENTS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Capricious Seas
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
				'IDENTITY_SUK_ML_CAPRICIOUS_SEAS',
				'IDENTITY_SUK_ML_CAPRICIOUS_SEAS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_CAPRICIOUS_SEAS',	'IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY');

	-------------------------------------		
	-- 1 Unit Movement
	-------------------------------------
INSERT INTO GameModifiers
	(ModifierId)
VALUES	
	('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT',			'MODIFIER_ALL_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'REQSET_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT_MODIFIER',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT',			'ModifierId',	'IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT_MODIFIER'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_UNIT_MOVEMENT_MODIFIER',	'Amount',		'-1');

	-------------------------------------		
	-- 2 Holy Site Adjacency
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 

('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'DistrictType', 'DISTRICT_HOLY_SITE'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'TerrainType', 'TERRAIN_COAST'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'YieldType', 'YIELD_FAITH'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'Amount', '1'), 
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_ADJACENCY', 'Description', 'LOC_ID_SUK_ML_CAPRICIOUS_SEAS_HOLY_SITE_FAITH');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS',		'REQUIRES_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,												RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS',	'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS',
					'PropertyName',
					'IDENTITY_SUK_ML_CAPRICIOUS_SEAS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_CAPRICIOUS_SEAS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Hexi Corridor
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
				'IDENTITY_SUK_ML_HEXI_CORRIDOR',
				'IDENTITY_SUK_ML_HEXI_CORRIDOR',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_HEXI_CORRIDOR',	'IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY'),
		('IDENTITY_SUK_ML_HEXI_CORRIDOR',	'IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2'),
		('IDENTITY_SUK_ML_HEXI_CORRIDOR',	'IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3'),
		('IDENTITY_SUK_ML_HEXI_CORRIDOR',	'IDENTITY_SUK_ML_HEXI_CORRIDOR_FARM_FOOD');

	-------------------------------------		
	-- 1 Encampment Adjacency
	-------------------------------------

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY',		'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 1, 1, 0, NULL, NULL),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 1, 1, 0, NULL, NULL),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3',	'MODIFIER_SINGLE_CITY_TERRAIN_ADJACENCY_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 

('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'DistrictType', 'DISTRICT_ENCAMPMENT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'TerrainType', 'TERRAIN_DESERT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'YieldType', 'YIELD_PRODUCTION'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'Amount', '1'), 
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY', 'Description', 'LOC_ID_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_PRODUCTION'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'DistrictType', 'DISTRICT_ENCAMPMENT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'TerrainType', 'TERRAIN_DESERT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'YieldType', 'YIELD_PRODUCTION'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'Amount', '1'), 
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_2', 'Description', 'LOC_ID_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_PRODUCTION'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'DistrictType', 'DISTRICT_ENCAMPMENT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'TerrainType', 'TERRAIN_DESERT'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'YieldType', 'YIELD_PRODUCTION'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'Amount', '1'), 
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'TilesRequired', '1'),
('IDENTITY_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_ADJACENCY_3', 'Description', 'LOC_ID_SUK_ML_HEXI_CORRIDOR_ENCAMPMENT_PRODUCTION');

	-------------------------------------		
	-- 2 Farm Food
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_HEXI_CORRIDOR_FARM_FOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_FARM_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_HEXI_CORRIDOR_FARM_FOOD', 'YieldType',	'YIELD_FOOD'),
	('IDENTITY_SUK_ML_HEXI_CORRIDOR_FARM_FOOD', 'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',		'REQUIREMENTSET_TEST_ALL'),
					('REQSET_FARM_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',		'REQUIRES_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR'),
					('REQSET_FARM_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',	'REQUIRES_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR'),
					('REQSET_FARM_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',	'REQUIRES_PLOT_HAS_FARM');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,										RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',		'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',
					'PropertyName',
					'IDENTITY_SUK_ML_HEXI_CORRIDOR'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_HEXI_CORRIDOR',
					'PropertyMinimum',
					1
				);

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
-- Actai Forbidden
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
				'IDENTITY_SUK_ML_ACTAI_FORBIDDEN',
				'IDENTITY_SUK_ML_ACTAI_FORBIDDEN',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE'),
		('IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE_2');


	-------------------------------------		
	-- 1 Unit Movement
	-------------------------------------
INSERT INTO GameModifiers
	(ModifierId)
VALUES	
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT',			'MODIFIER_ALL_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'REQSET_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN'),
('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT_MODIFIER',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT',			'ModifierId',	'IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT_MODIFIER'),
('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_UNIT_MOVEMENT_MODIFIER',	'Amount',		'-1');
	-------------------------------------		
	-- 2 Plot Culture
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN'),
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE_2', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_UNIMPROVED_ADJACENT_MOUNTAIN_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE',	'Amount',		'1'),
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE_2',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_ACTAI_FORBIDDEN_PLOT_CULTURE_2',	'Amount',		'1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,																RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',									'REQUIREMENTSET_TEST_ALL'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',						'REQUIREMENTSET_TEST_ALL'),
					('REQSET_UNIMPROVED_ADJACENT_MOUNTAIN_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,																RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',									'REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',						'REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN'),
					('REQSET_UNIMPROVED_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',						'REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_UNIMPROVED_ADJACENT_MOUNTAIN_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN'),
					('REQSET_UNIMPROVED_ADJACENT_MOUNTAIN_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_UNIMPROVED_ADJACENT_MOUNTAIN_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',	'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,												RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',
					'PropertyName',
					'IDENTITY_SUK_ML_ACTAI_FORBIDDEN'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ACTAI_FORBIDDEN',
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

--==========================================================================================================================
-- Volcanic Sanctum
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
				'IDENTITY_SUK_ML_VOLCANIC_SANCTUM',
				'IDENTITY_SUK_ML_VOLCANIC_SANCTUM',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM',	'IDENTITY_SUK_ML_VOLCANIC_SANCTUM_PLOT_CULTURE'),
		('IDENTITY_SUK_ML_VOLCANIC_SANCTUM',	'IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY');

	-------------------------------------		
	-- 1 Plot Culture
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_PLOT_CULTURE', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_PLOT_CULTURE',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_PLOT_CULTURE',	'Amount',		'2');

	-------------------------------------		
	-- 2 Adjacency HOLY_SITE
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY', 'MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY',	'DistrictType',	'DISTRICT_HOLY_SITE'),
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY',	'FeatureType',	'FEATURE_VOLCANIC_SOIL'),
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY',	'YieldType',	'YIELD_FAITH'),
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY',	'Amount',		'2'),
	('IDENTITY_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_ADJACENCY',	'Description',	'LOC_ID_SUK_ML_VOLCANIC_SANCTUM_HOLY_SITE_FAITH');

	

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',				'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',	'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',	'REQUIRES_PLOT_HAS_VOLCANIC_SOIL');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',
					'PropertyName',
					'IDENTITY_SUK_ML_VOLCANIC_SANCTUM'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_SANCTUM',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Volcanic Loam
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
				'IDENTITY_SUK_ML_VOLCANIC_LOAM',
				'IDENTITY_SUK_ML_VOLCANIC_LOAM',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_VOLCANIC_LOAM',		'IDENTITY_SUK_ML_VOLCANIC_LOAM_PLOT_YIELD'),
		('IDENTITY_SUK_ML_VOLCANIC_LOAM',		'IDENTITY_SUK_ML_VOLCANIC_LOAM_DISTRICT_PRODUCTION');

	-------------------------------------		
	-- 1 Plot Culture
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_LOAM_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_LOAM_PLOT_YIELD',	'YieldType',	'YIELD_FOOD,YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_VOLCANIC_LOAM_PLOT_YIELD',	'Amount',		'2,2');

	-------------------------------------		
	-- 2 District Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_LOAM_DISTRICT_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_DISTRICTS_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_VOLCANIC_LOAM_DISTRICT_PRODUCTION',	'Amount',		'-15');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',					'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',		'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM'),
					('REQSET_VOLCANIC_SOIL_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',		'REQUIRES_PLOT_HAS_VOLCANIC_SOIL');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',
					'PropertyName',
					'IDENTITY_SUK_ML_VOLCANIC_LOAM'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_VOLCANIC_LOAM',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Copper Veins
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
				'IDENTITY_SUK_ML_RICH_COPPER_VEINS',
				'IDENTITY_SUK_ML_RICH_COPPER_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,									ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_COPPER_VEINS',			'IDENTITY_SUK_ML_RICH_COPPER_VEINS_COPPER_PRODUCTION'),
		('IDENTITY_SUK_ML_RICH_COPPER_VEINS',			'IDENTITY_SUK_ML_RICH_COPPER_VEINS_ENCAMPMENT_PRODUCTION'),
		('IDENTITY_SUK_ML_RICH_COPPER_VEINS',			'IDENTITY_SUK_ML_RICH_COPPER_VEINS_INDUSTRIAL_ZONE_PRODUCTION'),
		('IDENTITY_SUK_ML_RICH_COPPER_VEINS',			'IDENTITY_SUK_ML_RICH_COPPER_VEINS_UNIT_ABILITY');

-------------------------------------		
-- 1 Copper Production
-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_COPPER_PRODUCTION', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_COPPER_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_COPPER_PRODUCTION', 'Amount', '3'),
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_COPPER_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');
	
-------------------------------------		
-- 2 Production INDUSTRIAL_ZONE / ENCAMPMENT
-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_ENCAMPMENT_PRODUCTION',			'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_INDUSTRIAL_ZONE_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_ENCAMPMENT_PRODUCTION',		'Amount', '30'),
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_ENCAMPMENT_PRODUCTION',		'DistrictType', 'DISTRICT_ENCAMPMENT'),
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_INDUSTRIAL_ZONE_PRODUCTION', 'Amount', '30'),
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_INDUSTRIAL_ZONE_PRODUCTION', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');	
				
-------------------------------------		
-- 3 Unit Ability
-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_UNIT_ABILITY', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_RICH_COPPER_VEINS_UNIT_ABILITY', 'AbilityType', 'ABILITY_IDENTITY_SUK_ML_RICH_COPPER_VEINS');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_COPPER_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS'),
					('REQSET_IMPROVED_COPPER_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',	'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS'), 
					('REQSET_IMPROVED_COPPER_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',	'REQUIRES_PLOT_HAS_COPPER_SUK_ID_ML'), 
					('REQSET_IMPROVED_COPPER_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_COPPER_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COPPER_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rock Capital
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
				'IDENTITY_SUK_ML_ROCK_CAPITAL',
				'IDENTITY_SUK_ML_ROCK_CAPITAL',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_ROCK_CAPITAL',		'IDENTITY_SUK_ML_ROCK_CAPITAL_PLOT_YIELD'),
		('IDENTITY_SUK_ML_ROCK_CAPITAL',		'IDENTITY_SUK_ML_ROCK_CAPITAL_WONDER_PRODUCTION');

	-------------------------------------		
	-- 1 Plot Gold/Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_ROCK_CAPITAL_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_QUARRY_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_ROCK_CAPITAL_PLOT_YIELD',	'YieldType',	'YIELD_GOLD,YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_ROCK_CAPITAL_PLOT_YIELD',	'Amount',		'1,1');

	-------------------------------------		
	-- 2 Wonder Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_ROCK_CAPITAL_WONDER_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_WONDER_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_ROCK_CAPITAL_WONDER_PRODUCTION',	'Amount',		'30');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_QUARRY_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',					'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',					'REQUIRES_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL'),
					('REQSET_QUARRY_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',				'REQUIRES_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL'),
					('REQSET_QUARRY_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',				'REQUIRES_PLOT_HAS_QUARRY');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',
					'PropertyName',
					'IDENTITY_SUK_ML_ROCK_CAPITAL'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ROCK_CAPITAL',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Bountiful Deer
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
				'IDENTITY_SUK_ML_BOUNTIFUL_DEER',
				'IDENTITY_SUK_ML_BOUNTIFUL_DEER',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_BOUNTIFUL_DEER',		'IDENTITY_SUK_ML_BOUNTIFUL_DEER_DEER_YIELD'),
		('IDENTITY_SUK_ML_BOUNTIFUL_DEER',		'IDENTITY_SUK_ML_BOUNTIFUL_DEER_FOREST_YIELD');

	-------------------------------------		
	-- 1 Deer Yield
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_DEER_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_DEER_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_DEER_YIELD',	'YieldType',	'YIELD_FOOD,YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_DEER_YIELD',	'Amount',		'2,1');

	-------------------------------------		
	-- 2 Wonder Production
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_FOREST_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_UNIMROVED_FOREST_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_FOREST_YIELD',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_BOUNTIFUL_DEER_FOREST_YIELD',	'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_DEER_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_UNIMROVED_FOREST_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',					'REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER'),
					('REQSET_DEER_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',				'REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER'),
					('REQSET_DEER_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',				'REQUIRES_PLOT_HAS_DEER_SUK_ID_ML'),
					('REQSET_UNIMROVED_FOREST_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',	'REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER'),
					('REQSET_UNIMROVED_FOREST_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',	'PLOT_IS_FOREST_REQUIREMENT'),
					('REQSET_UNIMROVED_FOREST_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',	'REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',
					'PropertyName',
					'IDENTITY_SUK_ML_BOUNTIFUL_DEER'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_BOUNTIFUL_DEER',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Land of Abundance
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
				'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',
				'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_PLOT_YIELD'),
		('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_GROWTH'),
		('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_HOUSING');

	-------------------------------------		
	-- 1 Wheat Yield
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMROVED_RICE_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_PLOT_YIELD',	'YieldType',	'YIELD_FOOD'),
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_PLOT_YIELD',	'Amount',		'2');

	-------------------------------------		
	-- 2 Growth
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_GROWTH', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_GROWTH',	'Amount',		'10');

	-------------------------------------		
	-- 3 Housing
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_HOUSING', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LAND_OF_ABUNDANCE_CITY_HOUSING',	'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMROVED_RICE_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',					'REQUIRES_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE'),
					('REQSET_IMROVED_RICE_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'REQUIRES_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE'),
					('REQSET_IMROVED_RICE_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'REQUIRES_RICE_IN_PLOT'),
					('REQSET_IMROVED_RICE_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',		'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',
					'PropertyName',
					'IDENTITY_SUK_ML_LAND_OF_ABUNDANCE'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_LAND_OF_ABUNDANCE',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Loess Plateau
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
				'IDENTITY_SUK_ML_LOESS_PLATEAU',
				'IDENTITY_SUK_ML_LOESS_PLATEAU',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_LOESS_PLATEAU',		'IDENTITY_SUK_ML_LOESS_PLATEAU_PLOT_YIELD'),
		('IDENTITY_SUK_ML_LOESS_PLATEAU',		'IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_GROWTH'),
		('IDENTITY_SUK_ML_LOESS_PLATEAU',		'IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_HOUSING');

	-------------------------------------		
	-- 1 Wheat Yield
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMROVED_WHEAT_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_PLOT_YIELD',	'YieldType',	'YIELD_FOOD'),
	('IDENTITY_SUK_ML_LOESS_PLATEAU_PLOT_YIELD',	'Amount',		'2');

	-------------------------------------		
	-- 2 Growth
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_GROWTH', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_GROWTH',	'Amount',		'10');

	-------------------------------------		
	-- 3 Housing
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_HOUSING', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_HOUSING', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_LOESS_PLATEAU_CITY_HOUSING',	'Amount',		'2');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMROVED_WHEAT_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',					'REQUIRES_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU'),
					('REQSET_IMROVED_WHEAT_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',		'REQUIRES_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU'),
					('REQSET_IMROVED_WHEAT_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',		'REQUIRES_WHEAT_IN_PLOT'),
					('REQSET_IMROVED_WHEAT_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',		'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',
					'PropertyName',
					'IDENTITY_SUK_ML_LOESS_PLATEAU'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_LOESS_PLATEAU',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Iron Veins
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
				'IDENTITY_SUK_ML_RICH_IRON_VEINS',
				'IDENTITY_SUK_ML_RICH_IRON_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_IRON_VEINS',		'IDENTITY_SUK_ML_RICH_IRON_VEINS_PLOT_YIELD'),
		('IDENTITY_SUK_ML_RICH_IRON_VEINS',		'IDENTITY_SUK_ML_RICH_IRON_VEINS_UNIT_ABILITY');

	-------------------------------------		
	-- 1 Iron Yield
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_IRON_VEINS_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMROVED_IRON_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_IRON_VEINS_PLOT_YIELD',	'YieldType',	'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_RICH_IRON_VEINS_PLOT_YIELD',	'Amount',		'2');

	-------------------------------------		
	-- 2 Unit Ability
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_IRON_VEINS_UNIT_ABILITY', 'MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS', 0, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_RICH_IRON_VEINS_UNIT_ABILITY', 'AbilityType', 'ABILITY_IDENTITY_SUK_ML_RICH_IRON_VEINS');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',						'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMROVED_IRON_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',						'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS'),
					('REQSET_IMROVED_IRON_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',		'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS'),
					('REQSET_IMROVED_IRON_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',		'REQUIRES_PLOT_HAS_IRON_SUK_ID_ML'),
					('REQSET_IMROVED_IRON_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',		'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_IRON_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_IRON_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Fine Horse Ranch
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
				'IDENTITY_SUK_ML_FINE_HORSE_RANCH',
				'IDENTITY_SUK_ML_FINE_HORSE_RANCH',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_HORSE_EXTRACTION'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_2'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_3'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_4'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_5'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_6'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_7'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_8'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_9'),
		('IDENTITY_SUK_ML_FINE_HORSE_RANCH',		'IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_10');

	-------------------------------------		
	-- 1 Horse Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_HORSE_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_HORSE_EXTRACTION',	'ResourceType',	'RESOURCE_HORSES'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_HORSE_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Unit roduction
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_2',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_3',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_4',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_5',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_6',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_7',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_8',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_9',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_10',	'MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value, Extra) 
VALUES 
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION',	'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION',	'EraType',				'ERA_ANCIENT',						'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_2',	'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_2',	'EraType',				'ERA_CLASSICAL',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_2',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_3',	'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_3',	'EraType',				'ERA_MEDIEVAL',						'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_3',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_4',	'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_4',	'EraType',				'ERA_RENAISSANCE',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_4',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_5',	'UnitPromotionClass',	'PROMOTION_CLASS_HEAVY_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_5',	'EraType',				'ERA_INDUSTRIAL',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_5',	'Amount',				'30',								'-1'),
	
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_6',	'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_6',	'EraType',				'ERA_ANCIENT',						'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_6',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_7',	'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_7',	'EraType',				'ERA_CLASSICAL',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_7',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_8',	'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_8',	'EraType',				'ERA_MEDIEVAL',						'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_8',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_9',	'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_9',	'EraType',				'ERA_RENAISSANCE',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_9',	'Amount',				'30',								'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_10',	'UnitPromotionClass',	'PROMOTION_CLASS_LIGHT_CAVALRY',	'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_10',	'EraType',				'ERA_INDUSTRIAL',					'-1'),
	('IDENTITY_SUK_ML_FINE_HORSE_RANCH_UNIT_PRODUCTION_10',	'Amount',				'30',								'-1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH',					'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH',					'REQUIRES_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH',					'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH',
					'PropertyName',
					'IDENTITY_SUK_ML_FINE_HORSE_RANCH'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_FINE_HORSE_RANCH',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Coal Veins
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
				'IDENTITY_SUK_ML_RICH_COAL_VEINS',
				'IDENTITY_SUK_ML_RICH_COAL_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_COAL_VEINS',		'IDENTITY_SUK_ML_RICH_COAL_VEINS_COAL_EXTRACTION'),
		('IDENTITY_SUK_ML_RICH_COAL_VEINS',		'IDENTITY_SUK_ML_RICH_COAL_VEINS_RESOURCE_VISIBILITY'),
		('IDENTITY_SUK_ML_RICH_COAL_VEINS',		'IDENTITY_SUK_ML_RICH_COAL_VEINS_DISTRICT_PRODUCTION');

	-------------------------------------		
	-- 1 Coal Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_COAL_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_COAL_EXTRACTION',	'ResourceType',	'RESOURCE_COAL'),
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_COAL_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Coal Visibility
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_RESOURCE_VISIBILITY',	'MODIFIER_PLAYER_GRANT_FREE_RESOURCE_VISIBILITY', 1, 1, 0, 'REQSET_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_RESOURCE_VISIBILITY',	'ResourceType',	'RESOURCE_COAL');

	-------------------------------------		
	-- 3 Production INDUSTRIAL_ZONE 
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_DISTRICT_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_DISTRICT_PRODUCTION', 'Amount', '30'),
	('IDENTITY_SUK_ML_RICH_COAL_VEINS_DISTRICT_PRODUCTION', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');	

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS'),
					('REQSET_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML',			'REQUIRES_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_COAL_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_COAL_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Oil Rich Basin
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
				'IDENTITY_SUK_ML_OIL_RICH_BASIN',
				'IDENTITY_SUK_ML_OIL_RICH_BASIN',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_OIL_RICH_BASIN',		'IDENTITY_SUK_ML_OIL_RICH_BASIN_OIL_EXTRACTION'),
		('IDENTITY_SUK_ML_OIL_RICH_BASIN',		'IDENTITY_SUK_ML_OIL_RICH_BASIN_RESOURCE_VISIBILITY'),
		('IDENTITY_SUK_ML_OIL_RICH_BASIN',		'IDENTITY_SUK_ML_OIL_RICH_BASIN_DISTRICT_PRODUCTION');

	-------------------------------------		
	-- 1 Oil Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_OIL_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_OIL_EXTRACTION',	'ResourceType',	'RESOURCE_OIL'),
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_OIL_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Oil Visibility
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_RESOURCE_VISIBILITY',	'MODIFIER_PLAYER_GRANT_FREE_RESOURCE_VISIBILITY', 1, 1, 0, 'REQSET_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_RESOURCE_VISIBILITY',	'ResourceType',	'RESOURCE_OIL');

	-------------------------------------		
	-- 3 Production INDUSTRIAL_ZONE 
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_DISTRICT_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_DISTRICT_PRODUCTION', 'Amount', '30'),
	('IDENTITY_SUK_ML_OIL_RICH_BASIN_DISTRICT_PRODUCTION', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN',					'REQUIRES_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN'),
					('REQSET_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML',			'REQUIRES_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN',
					'PropertyName',
					'IDENTITY_SUK_ML_OIL_RICH_BASIN'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_OIL_RICH_BASIN',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Aluminum Veins
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
				'IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',
				'IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',		'IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_ALUMINUM_EXTRACTION'),
		('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',		'IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_DISTRICT_ADJACENCY');

	-------------------------------------		
	-- 1 Al Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_ALUMINUM_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_ALUMINUM_EXTRACTION',	'ResourceType',	'RESOURCE_ALUMINUM'),
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_ALUMINUM_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Distrcit Adjacency
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_DISTRICT_ADJACENCY',	'MODIFIER_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE_SUK_ID_ML', 0, 0, 0, NULL, 'REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_DISTRICT_ADJACENCY',			'YieldType',			'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS_DISTRICT_ADJACENCY',			'Amount',				2);

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS'),
					('REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',	'REQUIRES_DISTRICT_IS_INDUSTRIAL_ZONE');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_ALUMINUM_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Uranium Veins
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
				'IDENTITY_SUK_ML_RICH_URANIUM_VEINS',
				'IDENTITY_SUK_ML_RICH_URANIUM_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS',		'IDENTITY_SUK_ML_RICH_URANIUM_VEINS_URANIUM_EXTRACTION'),
		('IDENTITY_SUK_ML_RICH_URANIUM_VEINS',		'IDENTITY_SUK_ML_RICH_URANIUM_VEINS_DISTRICT_ADJACENCY');

	-------------------------------------		
	-- 1 U Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_URANIUM_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_URANIUM_EXTRACTION',	'ResourceType',	'RESOURCE_URANIUM'),
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_URANIUM_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Distrcit Adjacency
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_DISTRICT_ADJACENCY',	'MODIFIER_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE_SUK_ID_ML', 0, 0, 0, NULL, 'REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_DISTRICT_ADJACENCY',			'YieldType',			'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_RICH_URANIUM_VEINS_DISTRICT_ADJACENCY',			'Amount',				2);

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS'),
					('REQSET_INDUSTRIAL_ZONE_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',	'REQUIRES_DISTRICT_IS_INDUSTRIAL_ZONE');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_URANIUM_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_URANIUM_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Saltpeter Wasteland
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
				'IDENTITY_SUK_ML_SALTPETER_WASTELAND',
				'IDENTITY_SUK_ML_SALTPETER_WASTELAND',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_SALTPETER_WASTELAND',		'IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_EXTRACTION'),
		('IDENTITY_SUK_ML_SALTPETER_WASTELAND',		'IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_YIELD'),
		('IDENTITY_SUK_ML_SALTPETER_WASTELAND',		'IDENTITY_SUK_ML_SALTPETER_WASTELAND_SALT_YIELD');

	-------------------------------------		
	-- 1 Niter Accumulation
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_EXTRACTION', 'MODIFIER_PLAYER_ADJUST_RESOURCE_ACCUMULATION_MODIFIER', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_EXTRACTION',	'ResourceType',	'RESOURCE_NITER'),
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_EXTRACTION',	'Amount',		'2');

	-------------------------------------		
	-- 2 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_NITER_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND'),
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_SALT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_SALT_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_YIELD',	'YieldType',	'YIELD_GOLD,YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_NITER_YIELD',	'Amount',		'1,1'),
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_SALT_YIELD',	'YieldType',	'YIELD_GOLD,YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_SALTPETER_WASTELAND_SALT_YIELD',	'Amount',		'1,1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,													RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_NITER_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_SALT_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,													RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',					'REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND'),
					('REQSET_IMPROVED_NITER_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND'),
					('REQSET_IMPROVED_NITER_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_IMPROVED_NITER_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_HAS_NITER_SUK_ID_ML'),
					('REQSET_IMPROVED_SALT_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND'),
					('REQSET_IMPROVED_SALT_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_IMPROVED_SALT_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',	'REQUIRES_PLOT_HAS_SALT_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,														RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',
					'PropertyName',
					'IDENTITY_SUK_ML_SALTPETER_WASTELAND'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SALTPETER_WASTELAND',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Elephant Herds
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
				'IDENTITY_SUK_ML_ELEPHANT_HERDS',
				'IDENTITY_SUK_ML_ELEPHANT_HERDS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_ELEPHANT_HERDS',		'IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_PRODUCTION'),
		('IDENTITY_SUK_ML_ELEPHANT_HERDS',		'IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_CULTURE'),
		('IDENTITY_SUK_ML_ELEPHANT_HERDS',		'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION');

	-------------------------------------		
	-- 1 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_PRODUCTION',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS'),
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_CULTURE',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, 'REQSET_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML', 'REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_PRODUCTION',	'YieldType',	'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_PRODUCTION',	'Amount',		'3'),
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_CULTURE',		'YieldType',	'CULTURE'),
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_PLOT_CULTURE',		'Amount',		'3');

	-------------------------------------		
	-- 2 Unit Production
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION', 1, 1, 0, 'REQSET_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION',	'UnitType',	'UNIT_INDIAN_VARU'),
	('IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION',	'Amount',	'30');


INSERT INTO Suk_UrbanIdentity_Modifiers
	(IdentityType,						ModifierId)
SELECT	
	'IDENTITY_SUK_ML_ELEPHANT_HERDS',	'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_2'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_VIETNAMESE_VOI_CHIEN');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId)
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_2', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION', 0, 0, 0, NULL, NULL
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_VIETNAMESE_VOI_CHIEN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_2',	'UnitType',	'UNIT_VIETNAMESE_VOI_CHIEN'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_VIETNAMESE_VOI_CHIEN');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_2', 'Amount',		'30'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_VIETNAMESE_VOI_CHIEN');


INSERT INTO Suk_UrbanIdentity_Modifiers
	(IdentityType,						ModifierId)
SELECT	
	'IDENTITY_SUK_ML_ELEPHANT_HERDS',	'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_3'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_KHMER_DOMREY');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId)
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_3', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION', 0, 0, 0, NULL, NULL
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_KHMER_DOMREY');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_3',	'UnitType',	'UNIT_KHMER_DOMREY'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_KHMER_DOMREY');

INSERT INTO ModifierArguments (ModifierId, Name, Value) 
SELECT  
'IDENTITY_SUK_ML_ELEPHANT_HERDS_UNIT_PRODUCTION_3', 'Amount',		'30'
WHERE EXISTS (SELECT * FROM Units WHERE UnitType ='UNIT_KHMER_DOMREY');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',					'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML',					'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',					'REQUIRES_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS'),
					('REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',	'REQUIRES_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS'),
					('REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_IMPROVED_IVORY_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',	'REQUIRES_PLOT_HAS_IVORY_SUK_ID_ML'),
					('REQSET_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML',					'REQUIRES_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML');
		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',
					'PropertyName',
					'IDENTITY_SUK_ML_ELEPHANT_HERDS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_ELEPHANT_HERDS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Gemstone Veins
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
				'IDENTITY_SUK_ML_GEMSTONE_VEINS',
				'IDENTITY_SUK_ML_GEMSTONE_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_GEMSTONE_VEINS',		'IDENTITY_SUK_ML_GEMSTONE_VEINS_PLOT_YIELD'),
		('IDENTITY_SUK_ML_GEMSTONE_VEINS',		'IDENTITY_SUK_ML_GEMSTONE_VEINS_DISTRICT_PRODUCTION');

	-------------------------------------		
	-- 1 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_PLOT_YIELD',	'YieldType',	'YIELD_PRODUCTION,YIELD_GOLD'),
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_PLOT_YIELD',	'Amount',		'1,3');

	-------------------------------------		
	-- 2 Production INDUSTRIAL_ZONE 
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_DISTRICT_PRODUCTION',	'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_DISTRICT_PRODUCTION', 'Amount', '30'),
	('IDENTITY_SUK_ML_GEMSTONE_VEINS_DISTRICT_PRODUCTION', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS',		'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML',				'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS',		'REQUIRES_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS'),
					('REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML',				'REQUIRES_PLOT_HAS_JADE_SUK_ID_ML'),
					('REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML',				'REQUIRES_PLOT_HAS_DIAMONDS_SUK_ID_ML'),
					('REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML',				'REQUIRES_PLOT_HAS_AMBER_SUK_ID_ML'),
					('REQSET_PLOT_HAS_GEMSTONE_SUK_ID_ML',				'REQUIRES_PLOT_HAS_MERCURY_SUK_ID_ML');

		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_GEMSTONE_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_GEMSTONE_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Secluded Flower Sea
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
				'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',
				'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,								ModifierId)
VALUES	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_APPEAL'),
		('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_YIELD'),
		('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY'),
		('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY_2');

	-------------------------------------		
	-- 1 Plot Appeal
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_APPEAL', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_APPEAL',	'Amount',		'1');

	-------------------------------------		
	-- 2 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_CHARMING_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_YIELD',	'YieldType',	'YIELD_FAITH'),
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_PLOT_YIELD',	'Amount',		'2');

	-------------------------------------		
	-- 3 District Adjacency
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY',		'MODIFIER_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE_SUK_ID_ML', 0, 0, 0, NULL, 'REQSET_HOLY_SITE_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'),
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY_2',	'MODIFIER_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE_SUK_ID_ML', 0, 0, 0, NULL, 'REQSET_THEATER_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY',		'YieldType',	'YIELD_FAITH'),
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY',		'Amount',		2),
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY_2',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA_DISTRICT_ADJACENCY_2',	'Amount',		2);

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',			'REQUIREMENTSET_TEST_ALL'),
					('REQSET_HOLY_SITE_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_THEATER_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',				'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',			'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',			'REQUIRES_PLOT_CHARMING_APPEAL'),
					('REQSET_HOLY_SITE_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',	'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'),
					('REQSET_HOLY_SITE_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',	'REQUIRES_DISTRICT_IS_HOLY_SITE'),
					('REQSET_THEATER_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'),
					('REQSET_THEATER_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',		'REQUIRES_DISTRICT_IS_THEATER');


		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',
					'PropertyName',
					'IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SECLUDED_FLOWER_SEA',
					'PropertyMinimum',
					1
				);


--==========================================================================================================================
-- Azure Coast
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
				'IDENTITY_SUK_ML_AZURE_COAST',
				'IDENTITY_SUK_ML_AZURE_COAST',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,						ModifierId)
VALUES	('IDENTITY_SUK_ML_AZURE_COAST',		'IDENTITY_SUK_ML_AZURE_COAST_PLOT_APPEAL'),
		('IDENTITY_SUK_ML_AZURE_COAST',		'IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD'),
		('IDENTITY_SUK_ML_AZURE_COAST',		'IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_2'),
		('IDENTITY_SUK_ML_AZURE_COAST',		'IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_3');

	-------------------------------------		
	-- 1 Plot Appeal
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_APPEAL', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_APPEAL', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_APPEAL',	'Amount',		'1');

	-------------------------------------		
	-- 2 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_CHARMING_IDENTITY_SUK_ML_AZURE_COAST');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD',	'YieldType',	'YIELD_CULTURE'),
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD',	'Amount',		'1');

	-------------------------------------		
	-- 3 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_2', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_BEACH_RESORT_IDENTITY_SUK_ML_AZURE_COAST'),
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_3', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_CITY_PARK_IDENTITY_SUK_ML_AZURE_COAST');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_2',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_2',	'Amount',		'5'),
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_3',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_AZURE_COAST_PLOT_YIELD_3',	'Amount',		'5');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,										RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_AZURE_COAST',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_AZURE_COAST',			'REQUIREMENTSET_TEST_ALL'),
					('REQSET_BEACH_RESORT_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CITY_PARK_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,										RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_AZURE_COAST',				'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_AZURE_COAST',			'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST'),
					('REQSET_CHARMING_IDENTITY_SUK_ML_AZURE_COAST',			'REQUIRES_PLOT_CHARMING_APPEAL'),
					('REQSET_BEACH_RESORT_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST'),
					('REQSET_BEACH_RESORT_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIRES_PLOT_HAS_BEACH_RESORT_SUK_ID_ML'),
					('REQSET_CITY_PARK_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST'),
					('REQSET_CITY_PARK_IDENTITY_SUK_ML_AZURE_COAST',		'REQUIRES_PLOT_HAS_CITY_PARK_SUK_ID_ML');

		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST',
					'PropertyName',
					'IDENTITY_SUK_ML_AZURE_COAST'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_AZURE_COAST',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Premium Pasture
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
				'IDENTITY_SUK_ML_PREMIUM_PASTURE',
				'IDENTITY_SUK_ML_PREMIUM_PASTURE',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_PREMIUM_PASTURE',		'IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD'),
		('IDENTITY_SUK_ML_PREMIUM_PASTURE',		'IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD_2'),
		('IDENTITY_SUK_ML_PREMIUM_PASTURE',		'IDENTITY_SUK_ML_PREMIUM_PASTURE_PLOT_YIELD');

	-------------------------------------		
	-- 1 Valid Pasture
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN_SUK_ID_ML', 1, 1, 0, NULL, NULL),
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD_2', 'MODIFIER_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN_SUK_ID_ML', 1, 1, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD',		'ImprovementType',	'IMPROVEMENT_PASTURE'),
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD',		'TerrainType',		'TERRAIN_GRASS'),
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD_2',	'ImprovementType',	'IMPROVEMENT_PASTURE'),
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_VALID_BUILD_2',	'TerrainType',		'TERRAIN_PLAINS');

	-------------------------------------		
	-- 2 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_PASTURE_IDENTITY_SUK_ML_PREMIUM_PASTURE');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_PLOT_YIELD',	'YieldType',	'YIELD_PRODUCTION,YIELD_FOOD'),
	('IDENTITY_SUK_ML_PREMIUM_PASTURE_PLOT_YIELD',	'Amount',		'1,1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_PASTURE_IDENTITY_SUK_ML_PREMIUM_PASTURE',			'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE',				'REQUIRES_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE'),
					('REQSET_PASTURE_IDENTITY_SUK_ML_PREMIUM_PASTURE',			'REQUIRES_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE'),
					('REQSET_PASTURE_IDENTITY_SUK_ML_PREMIUM_PASTURE',			'REQUIRES_PLOT_HAS_PASTURE');

		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,											RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE',			'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE',
					'PropertyName',
					'IDENTITY_SUK_ML_PREMIUM_PASTURE'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_PREMIUM_PASTURE',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Rich Silver Veins
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
				'IDENTITY_SUK_ML_RICH_SILVER_VEINS',
				'IDENTITY_SUK_ML_RICH_SILVER_VEINS',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'IDENTITY_SUK_ML_RICH_SILVER_VEINS_PLOT_YIELD'),
		('IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_DOMESTIC'),
		('IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_INTERNATIONAL'),
		('IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_CAPACITY');

	-------------------------------------		
	-- 1 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_PLOT_YIELD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_SILVER_IDENTITY_SUK_ML_RICH_SILVER_VEINS');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_PLOT_YIELD',	'YieldType',	'YIELD_PRODUCTION'),
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_PLOT_YIELD',	'Amount',		'2');

	-------------------------------------		
	-- 2 Trade Route Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_DOMESTIC',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, NULL),
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_INTERNATIONAL',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_DOMESTIC',		'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_DOMESTIC',		'Amount',		'4'),
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_INTERNATIONAL',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_YIELD_INTERNATIONAL',	'Amount',		'4');

	-------------------------------------		
	-- 3 Trade Route Capacity
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_CAPACITY',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 1, 1, 0, 'REQSET_CITY_HAS_COMMERCIAL_HUB_OR_INDUSTRIAL_ZONE_SUK_ID_ML', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_RICH_SILVER_VEINS_TRADE_ROUTE_CAPACITY',	'Amount',	'1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,												RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_SILVER_IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_INDUSTRIAL_ZONE_SUK_ID_ML',	'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,												RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS',				'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS'),
					('REQSET_IMPROVED_SILVER_IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS'),
					('REQSET_IMPROVED_SILVER_IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'REQUIRES_PLOT_HAS_SILVER_SUK_ID_ML'),
					('REQSET_IMPROVED_SILVER_IDENTITY_SUK_ML_RICH_SILVER_VEINS',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_INDUSTRIAL_ZONE_SUK_ID_ML',	'REQUIRES_CITY_HAS_COMMERCIAL_HUB'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_INDUSTRIAL_ZONE_SUK_ID_ML',	'REQUIRES_CITY_HAS_INDUSTRIAL_ZONE');

		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS',
					'PropertyName',
					'IDENTITY_SUK_ML_RICH_SILVER_VEINS'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_RICH_SILVER_VEINS',
					'PropertyMinimum',
					1
				);

--==========================================================================================================================
-- Spice Homeland
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
				'IDENTITY_SUK_ML_SPICE_HOMELAND',
				'IDENTITY_SUK_ML_SPICE_HOMELAND',
				1
			);
	--------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------

INSERT INTO Suk_UrbanIdentity_Modifiers
		(IdentityType,							ModifierId)
VALUES	('IDENTITY_SUK_ML_SPICE_HOMELAND',	'IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD'),
		('IDENTITY_SUK_ML_SPICE_HOMELAND',	'IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD_2'),
		('IDENTITY_SUK_ML_SPICE_HOMELAND',	'IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_DOMESTIC'),
		('IDENTITY_SUK_ML_SPICE_HOMELAND',	'IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_INTERNATIONAL'),
		('IDENTITY_SUK_ML_SPICE_HOMELAND',	'IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_CAPACITY');

	-------------------------------------		
	-- 1 Plot Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_INCENSE_IDENTITY_SUK_ML_SPICE_HOMELAND'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD_2', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQSET_IMPROVED_SPICES_IDENTITY_SUK_ML_SPICE_HOMELAND');

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD',	'Amount',		'4'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD_2',	'YieldType',	'YIELD_GOLD'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_PLOT_YIELD_2',	'Amount',		'4');

	-------------------------------------		
	-- 2 Trade Route Yield
	-------------------------------------
INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_DOMESTIC',		'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, NULL),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_INTERNATIONAL',	'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_DOMESTIC',		'YieldType',	'YIELD_FAITH'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_DOMESTIC',		'Amount',		'4'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_INTERNATIONAL',	'YieldType',	'YIELD_FAITH'),
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_YIELD_INTERNATIONAL',	'Amount',		'4');

	-------------------------------------		
	-- 3 Trade Route Capacity
	-------------------------------------

INSERT INTO Modifiers 
	(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_CAPACITY',	'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', 1, 1, 0, 'REQSET_CITY_HAS_COMMERCIAL_HUB_OR_HOLY_SITE_SUK_ID_ML', NULL);

INSERT INTO ModifierArguments 
	(ModifierId, Name, Value) 
VALUES 
	('IDENTITY_SUK_ML_SPICE_HOMELAND_TRADE_ROUTE_CAPACITY',	'Amount',	'1');

	--------------------------------------------------------------------
	-- Requirements
	--------------------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT OR IGNORE INTO RequirementSets
					(RequirementSetId,											RequirementSetType)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND',				'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_INCENSE_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_IMPROVED_SPICES_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIREMENTSET_TEST_ALL'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_HOLY_SITE_SUK_ID_ML',	'REQUIREMENTSET_TEST_ANY');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT OR IGNORE INTO RequirementSetRequirements
					(RequirementSetId,											RequirementId)
			VALUES	('REQSET_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND',				'REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND'),
					('REQSET_IMPROVED_INCENSE_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND'),
					('REQSET_IMPROVED_INCENSE_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_HAS_INCENSE_SUK_ID_ML'),
					('REQSET_IMPROVED_INCENSE_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_IMPROVED_SPICES_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND'),
					('REQSET_IMPROVED_SPICES_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_HAS_SPICES_SUK_ID_ML'),
					('REQSET_IMPROVED_SPICES_IDENTITY_SUK_ML_SPICE_HOMELAND',	'REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_HOLY_SITE_SUK_ID_ML',	'REQUIRES_CITY_HAS_COMMERCIAL_HUB'),
					('REQSET_CITY_HAS_COMMERCIAL_HUB_OR_HOLY_SITE_SUK_ID_ML',	'REQUIRES_CITY_HAS_HOLY_SITE');

		----------------------
		-- Requirements
		----------------------
			INSERT OR IGNORE INTO Requirements
					(RequirementId,													RequirementType)
			VALUES	('REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND',				'REQUIREMENT_PLOT_PROPERTY_MATCHES');
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
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND',
					'PropertyName',
					'IDENTITY_SUK_ML_SPICE_HOMELAND'
				),
				(
					'REQUIRES_PLOT_IDENTITY_SUK_ML_SPICE_HOMELAND',
					'PropertyMinimum',
					1
				);