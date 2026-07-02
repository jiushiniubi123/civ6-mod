-- YAJ_PantheonUpdates
-- Author: raiji
-- DateCreated: 9/14/2025 7:37:17 AM
--------------------------------------------------------------

---------------------------------------
-- Types
---------------------------------------	
INSERT OR REPLACE INTO Types	
		(Type,										Kind)
VALUES	--('PROMOTION_CLASS_BUILDER',	'KIND_PROMOTION_CLASS'),
		('BELIEF_YAJ_EARTH_REFORMER',	'KIND_BELIEF'),
		('ABIL_YAJ_EARTH_REFORMER_MOV',	'KIND_ABILITY');

INSERT OR REPLACE INTO TypeTags
			(Type,								Tag)
VALUES	('ABIL_YAJ_EARTH_REFORMER_MOV',	'CLASS_BUILDER');

-------------------------------------
-- Requirements
-------------------------------------
INSERT OR REPLACE INTO Requirements
		(RequirementId, 							RequirementType)
VALUES	('REQUIRES_BUILDER_UNIT',	'REQUIREMENT_UNIT_TAG_MATCHES');

-------------------------------------
-- RequirementArguments
-------------------------------------
INSERT OR REPLACE INTO RequirementArguments
		(RequirementId, 								Name,						Value)
VALUES	('REQUIRES_BUILDER_UNIT',	'Tag',	'CLASS_BUILDER');
-------------------------------------
-- RequirementSets
-------------------------------------
INSERT OR REPLACE INTO RequirementSets
		(RequirementSetId,											RequirementSetType)
VALUES	('YAJ_YAJ_EARTH_REFORMER_GOVERN_BUILDERS_REQ',		'REQUIREMENTSET_TEST_ALL');
-------------------------------------
-- RequirementSetRequirements
-------------------------------------	
INSERT OR REPLACE INTO RequirementSetRequirements
		(RequirementSetId,							RequirementId)
VALUES	('YAJ_YAJ_EARTH_REFORMER_GOVERN_BUILDERS_REQ',	'REQUIRES_CITY_HAS_GOVERNOR'),
		('YAJ_YAJ_EARTH_REFORMER_GOVERN_BUILDERS_REQ',	'REQUIRES_BUILDER_UNIT');


-------------------------------------
-- UnitAbilities
-------------------------------------					
INSERT INTO UnitAbilities			
		(UnitAbilityType,							Name,										Description,	Inactive)
VALUES	('ABIL_YAJ_EARTH_REFORMER_MOV',				'LOC_ABIL_YAJ_EARTH_REFORMER_MOV_NAME',		'LOC_ABIL_YAJ_EARTH_REFORMER_MOV_DESCRIPTION',	1);


-------------------------------------
-- UnitAbilityModifiers
-------------------------------------
INSERT INTO UnitAbilityModifiers	
		(UnitAbilityType,							ModifierId)
VALUES	('ABIL_YAJ_EARTH_REFORMER_MOV',				'YAJ_EARTH_REFORMER_BUILDER_MOV');

---------------------------------------
-- Beliefs
---------------------------------------
INSERT OR REPLACE INTO Beliefs		
		(BeliefType,	Name,	Description,	BeliefClassType) 
VALUES	('BELIEF_YAJ_EARTH_REFORMER',	'LOC_BELIEF_YAJ_EARTH_REFORMER_NAME',	'LOC_BELIEF_YAJ_EARTH_REFORMER_DESCRIPTION',	'BELIEF_CLASS_PANTHEON');

--------------------------------------------------------------
-- Modifiers
--------------------------------------------------------------
INSERT OR REPLACE INTO Modifiers			
		(ModifierId,	ModifierType,	SubjectRequirementSetId)
VALUES	('YAJ_EARTH_REFORMER_BUILDER_PRODUCTION',	'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_TAG_ERA_PRODUCTION',	'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
		('YAJ_EARTH_REFORMER_ATTACH_BUILDER_CHARGE',		'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',	'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
		('YAJ_EARTH_REFORMER_ENABLE_FAITH_PURCHASE_BUILDER',		'MODIFIER_PLAYER_CITIES_ENABLE_UNIT_FAITH_PURCHASE',	'PLAYER_HAS_PANTHEON_REQUIREMENTS'),

		('YAJ_EARTH_REFORMER_GRANTS_BUILDER_MOV',	'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',	'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
		('YAJ_EARTH_REFORMER_BUILDER_MOV',	'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT',	NULL);

INSERT OR REPLACE INTO Modifiers			
		(ModifierId,	ModifierType,	SubjectRequirementSetId, Permanent)
VALUES	('YAJ_EARTH_REFORMER_GOVERNOR_BUILDER_CHARGE',	'MODIFIER_PLAYER_TRAINED_UNITS_ADJUST_BUILDER_CHARGES',	'YAJ_YAJ_EARTH_REFORMER_GOVERN_BUILDERS_REQ',	1);

-------------------------------------
-- ModifierArguments
-------------------------------------
INSERT OR REPLACE INTO ModifierArguments
		(ModifierId, 								Name,						Value)
VALUES	('YAJ_EARTH_REFORMER_BUILDER_PRODUCTION',	'UnitPromotionClass', 'PROMOTION_CLASS_BUILDER'),
		('YAJ_EARTH_REFORMER_BUILDER_PRODUCTION',	'EraType', 'NO_ERA'),
		('YAJ_EARTH_REFORMER_BUILDER_PRODUCTION',	'Amount',	25),

		('YAJ_EARTH_REFORMER_ATTACH_BUILDER_CHARGE',	'ModifierId', 'YAJ_EARTH_REFORMER_GOVERNOR_BUILDER_CHARGE'),
		('YAJ_EARTH_REFORMER_GOVERNOR_BUILDER_CHARGE',	'Amount', 1),

		('YAJ_EARTH_REFORMER_ENABLE_FAITH_PURCHASE_BUILDER',	'Tag',	'CLASS_BUILDER'),

		('YAJ_EARTH_REFORMER_GRANTS_BUILDER_MOV',	'AbilityType',	'ABIL_YAJ_EARTH_REFORMER_MOV'),
		('YAJ_EARTH_REFORMER_BUILDER_MOV',	'Amount', 1);


UPDATE Units SET PromotionClass = 'PROMOTION_CLASS_BUILDER' WHERE UnitType="UNIT_BUILDER";
---------------------------------------
-- BeliefModifiers
---------------------------------------
INSERT OR REPLACE INTO BeliefModifiers			
		(BeliefType,							ModifierId)
VALUES	--('BELIEF_YAJ_EARTH_REFORMER',	'YAJ_EARTH_REFORMER_BUILDER_PRODUCTION'),
		('BELIEF_YAJ_EARTH_REFORMER',	'FERTILITY_RITES_BUILDER'),
		('BELIEF_YAJ_EARTH_REFORMER',	'YAJ_EARTH_REFORMER_GRANTS_BUILDER_MOV'),
		('BELIEF_YAJ_EARTH_REFORMER',	'YAJ_EARTH_REFORMER_ENABLE_FAITH_PURCHASE_BUILDER'),
		('BELIEF_YAJ_EARTH_REFORMER',	'YAJ_EARTH_REFORMER_ATTACH_BUILDER_CHARGE');