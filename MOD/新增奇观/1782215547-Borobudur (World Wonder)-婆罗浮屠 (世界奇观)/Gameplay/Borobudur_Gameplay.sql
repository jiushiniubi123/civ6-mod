
INSERT INTO Types (Type, Kind) VALUES ('BUILDING_BOROBUDUR', 'KIND_BUILDING');

INSERT INTO Buildings (BuildingType, Name, Description, PrereqCivic, Cost, AdvisorType, MaxWorldInstances, IsWonder, RequiresPlacement, RequiresReligion, Quote)
VALUES ('BUILDING_BOROBUDUR', 'LOC_BUILDING_BOROBUDUR_NAME', 'LOC_BUILDING_BOROBUDUR_DESCRIPTION', 'CIVIC_NAVAL_TRADITION', 400, 'ADVISOR_CULTURE', '1', 1, 1, 1, 'LOC_BUILDING_BOROBUDUR_QUOTE');

INSERT INTO Building_RequiredFeatures (BuildingType, FeatureType)
VALUES ('BUILDING_BOROBUDUR', 'FEATURE_JUNGLE');

INSERT INTO BuildingPrereqs (Building, PrereqBuilding) 
VALUES ('BUILDING_BOROBUDUR', 'BUILDING_TEMPLE');

--Plus 1 Faith. Plus 2 Culture.

INSERT INTO Building_YieldChanges (
  BuildingType, YieldType, YieldChange
)
VALUES
  ('BUILDING_BOROBUDUR', 'YIELD_CULTURE',2),
  ('BUILDING_BOROBUDUR', 'YIELD_FAITH',1);


-- 1 Apostle and 1 Guru appear.

INSERT INTO Modifiers
		(ModifierId,									ModifierType, RunOnce, Permanent)
VALUES	('BOROBUDUR_GRANT_APOSTLE',	'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_GRANT_APOSTLE', 'UnitType', 'UNIT_APOSTLE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_GRANT_APOSTLE', 'Amount', '1');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BOROBUDUR', 'BOROBUDUR_GRANT_APOSTLE');

INSERT INTO Modifiers
		(ModifierId,									ModifierType, RunOnce, Permanent)
VALUES	('BOROBUDUR_GRANT_GURU',	'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_GRANT_GURU', 'UnitType', 'UNIT_GURU');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_GRANT_GURU', 'Amount', '1');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BOROBUDUR', 'BOROBUDUR_GRANT_GURU');


-- +1 Faith for luxury goods in target.

INSERT INTO Modifiers
		(ModifierId,									ModifierType)
VALUES	('BOROBUDUR_TRADE_ROUTE_YIELD_PER_DEST_LUXURY',	'MODIFIER_PLAYER_CITIES_ADJUST_TRADE_ROUTE_YIELD_PER_DESTINATION_LUXURY_FOR_INTERNATIONAL');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_TRADE_ROUTE_YIELD_PER_DEST_LUXURY', 'YieldType', 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_TRADE_ROUTE_YIELD_PER_DEST_LUXURY', 'Amount', 1);


INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BOROBUDUR', 'BOROBUDUR_TRADE_ROUTE_YIELD_PER_DEST_LUXURY');


-- +1 Faith from Plantations within 6 tiles.

INSERT INTO Requirements
		(RequirementId,								RequirementType)
VALUES	('REQUIRES_PLOT_HAS_BOROBUDUR_WITHIN_X',	'REQUIREMENT_PLOT_ADJACENT_BUILDING_TYPE_MATCHES');

INSERT INTO RequirementArguments
		(RequirementId,								Name,			Value)
VALUES	('REQUIRES_PLOT_HAS_BOROBUDUR_WITHIN_X',	'BuildingType',	'BUILDING_BOROBUDUR'),
		('REQUIRES_PLOT_HAS_BOROBUDUR_WITHIN_X',	'MaxRange',		6),
		('REQUIRES_PLOT_HAS_BOROBUDUR_WITHIN_X',	'MinRange',		0);

INSERT INTO RequirementSets
		(RequirementSetId,						RequirementSetType)
VALUES	('BOROBUDUR_HAS_PLANTATION_REQUIREMENTS',	'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('BOROBUDUR_HAS_PLANTATION_REQUIREMENTS',	'REQUIRES_PLOT_HAS_BOROBUDUR_WITHIN_X'),
        ('BOROBUDUR_HAS_PLANTATION_REQUIREMENTS',	'REQUIRES_PLOT_HAS_PLANTATION');

INSERT INTO Modifiers
		(ModifierId,									ModifierType,										SubjectRequirementSetId)
VALUES	('BOROBUDUR_INCREASED_PLANTATION_FAITH',	'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	'BOROBUDUR_HAS_PLANTATION_REQUIREMENTS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_INCREASED_PLANTATION_FAITH', 'YieldType', 'YIELD_FAITH');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BOROBUDUR_INCREASED_PLANTATION_FAITH', 'Amount', '1');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BOROBUDUR', 'BOROBUDUR_INCREASED_PLANTATION_FAITH');