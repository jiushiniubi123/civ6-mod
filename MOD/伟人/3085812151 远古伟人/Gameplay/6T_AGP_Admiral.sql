-- 6T_AGP_Admiral
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,											Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA',	'KIND_GREAT_PERSON_INDIVIDUAL');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,						Name,													GreatPersonClassType,			EraType,		Gender,	ActionCharges,	ActionRequiresOwnedTile,	ActionRequiresNoMilitaryUnit,	ActionNameTextOverride,					ActionEffectTileHighlighting,	AreaHighlightRadius)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'LOC_GREAT_PERSON_INDIVIDUAL_JNR_HENENU_NAME',			'GREAT_PERSON_CLASS_ADMIRAL',	'ERA_ANCIENT',	'M',	1,				0,							0,								'LOC_GREATPERSON_ACTION_NAME_RETIRE',	0,								2),
		('GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA_NAME',	'GREAT_PERSON_CLASS_ADMIRAL',	'ERA_ANCIENT',	'F',	1,				0,							1,								'LOC_GREATPERSON_ACTION_NAME_RETIRE',	0,								2);
--------------------------------------------------------------

-- RequirementSets
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSets
		(RequirementSetId,						RequirementSetType)
VALUES	('AOE_ANCIENT_SEA_REQUIREMENTS_JNR',	'REQUIREMENTSET_TEST_ALL');
--------------------------------------------------------------

-- RequirementSetRequirements
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('AOE_ANCIENT_SEA_REQUIREMENTS_JNR',	'AOE_REQUIRES_SEA_DOMAIN'),
		('AOE_ANCIENT_SEA_REQUIREMENTS_JNR',	'AOE_REQUIRES_OWNER_ADJACENCY'),
		('AOE_ANCIENT_SEA_REQUIREMENTS_JNR',	'AOE_REQUIRES_ANCIENT_REQUIREMENTS_JNR');
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA',		'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					'AOE_ANCIENT_SEA_REQUIREMENTS_JNR'),
		('GREATPERSON_MOVEMENT_AOE_ANCIENT_SEA',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					'AOE_ANCIENT_SEA_REQUIREMENTS_JNR');

INSERT OR IGNORE INTO Modifiers
		(ModifierId,										ModifierType,											RunOnce,	Permanent)
VALUES	('JNR_HENENU_MARITIME_TRADE_RANGE',					'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_WATER_RANGE',		1,			1),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT',					'MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER',	1,			1),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT_ENABLE_ABILITY',	'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',					0,			0);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,										Name,						Value)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA',		'AbilityType',				'ABILITY_GREAT_ADMIRAL_STRENGTH'),
		('GREATPERSON_MOVEMENT_AOE_ANCIENT_SEA',			'AbilityType',				'ABILITY_GREAT_ADMIRAL_MOVEMENT'),
		
		('JNR_HENENU_MARITIME_TRADE_RANGE',					'Amount',					10),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT',					'UnitPromotionClassType',	'PROMOTION_CLASS_NAVAL_MELEE'),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT',					'ModifierId',				'JNR_NEI_MANGANIBUKA_FREE_UNIT_ENABLE_ABILITY'),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT_ENABLE_ABILITY',	'AbilityType',				'ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER');
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,										Context,	Text)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA',		'Summary',	'LOC_GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA'),

		('JNR_HENENU_MARITIME_TRADE_RANGE',					'Summary',	'LOC_JNR_HENENU_MARITIME_TRADE_RANGE'),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT',					'Summary',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA_FREE_UNIT');
--------------------------------------------------------------

-- GreatPersonIndividualBirthModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualBirthModifiers
		(GreatPersonIndividualType,						ModifierId)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA'),
		('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'GREATPERSON_MOVEMENT_AOE_ANCIENT_SEA'),
		('GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA',	'GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_SEA'),
		('GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA',	'GREATPERSON_MOVEMENT_AOE_ANCIENT_SEA');
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,						ModifierId,							AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'GREATPERSON_GOLD_TINY',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
		('GREAT_PERSON_INDIVIDUAL_JNR_HENENU',			'JNR_HENENU_MARITIME_TRADE_RANGE',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER'),
		('GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA',	'JNR_NEI_MANGANIBUKA_FREE_UNIT',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');
--------------------------------------------------------------