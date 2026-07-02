-- 6T_AGP_General
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,										Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO',		'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK',	'KIND_GREAT_PERSON_INDIVIDUAL');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,					Name,												GreatPersonClassType,			EraType,		Gender,	ActionCharges,	ActionRequiresOwnedTile,	ActionNameTextOverride,					ActionEffectTileHighlighting,	AreaHighlightRadius)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO',		'LOC_GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO_NAME',		'GREAT_PERSON_CLASS_GENERAL',	'ERA_ANCIENT',	'F',	1,				0,							'LOC_GREATPERSON_ACTION_NAME_RETIRE',	0,								2),
		('GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK_NAME',	'GREAT_PERSON_CLASS_GENERAL',	'ERA_ANCIENT',	'M',	1,				0,							'LOC_GREATPERSON_ACTION_NAME_RETIRE',	0,								2);

UPDATE GreatPersonIndividuals SET ActionRequiresOwnedTile=1, ActionEffectTileHighlighting=1, ActionRequiresCompletedDistrictType='DISTRICT_CITY_CENTER' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK' AND EXISTS (SELECT * FROM GreatPersonIndividuals WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED' AND ActionRequiresCompletedDistrictType='DISTRICT_CITY_CENTER');
--------------------------------------------------------------

-- RequirementSets
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSets
		(RequirementSetId,						RequirementSetType)
VALUES	('AOE_ANCIENT_LAND_REQUIREMENTS_JNR',	'REQUIREMENTSET_TEST_ALL');
--------------------------------------------------------------

-- RequirementSetRequirements
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId)
VALUES	('AOE_ANCIENT_LAND_REQUIREMENTS_JNR',	'AOE_REQUIRES_LAND_DOMAIN'),
		('AOE_ANCIENT_LAND_REQUIREMENTS_JNR',	'AOE_REQUIRES_OWNER_ADJACENCY'),
		('AOE_ANCIENT_LAND_REQUIREMENTS_JNR',	'AOE_REQUIRES_ANCIENT_REQUIREMENTS_JNR');
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,										ModifierType,											SubjectRequirementSetId)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND',	'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					'AOE_ANCIENT_LAND_REQUIREMENTS_JNR'),
		('GREATPERSON_MOVEMENT_AOE_ANCIENT_LAND',			'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',					'AOE_ANCIENT_LAND_REQUIREMENTS_JNR');

INSERT OR IGNORE INTO Modifiers
		(ModifierId,										ModifierType,											RunOnce,	Permanent)
VALUES	('JNR_FU_HAO_FREE_UNIT',							'MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER',	1,			1),
		('JNR_FU_HAO_FREE_UNIT_ENABLE_ABILITY',				'MODIFIER_PLAYER_UNIT_GRANT_ABILITY',					0,			0);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,										Name,						Value)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND',	'AbilityType',				'ABILITY_GREAT_GENERAL_STRENGTH'),
		('GREATPERSON_MOVEMENT_AOE_ANCIENT_LAND',			'AbilityType',				'ABILITY_GREAT_GENERAL_MOVEMENT'),

		('JNR_FU_HAO_FREE_UNIT',							'UnitPromotionClassType',	'PROMOTION_CLASS_HEAVY_CAVALRY'),
		('JNR_FU_HAO_FREE_UNIT',							'ModifierId',				'JNR_FU_HAO_FREE_UNIT_ENABLE_ABILITY'),
		('JNR_FU_HAO_FREE_UNIT_ENABLE_ABILITY',				'AbilityType',				'ABILITY_JNR_FU_HAO_CAMOUFLAGE');
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,										Context,	Text)
VALUES	('GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND',	'Summary',	'LOC_GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND'),

		('JNR_FU_HAO_FREE_UNIT',							'Summary',	'LOC_JNR_FU_HAO_FREE_UNIT');
--------------------------------------------------------------

-- GreatPersonIndividualBirthModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualBirthModifiers
		(GreatPersonIndividualType,					ModifierId)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO',		'GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND'),
		('GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO',		'GREATPERSON_MOVEMENT_AOE_ANCIENT_LAND'),
		('GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK',	'GREATPERSON_COMBAT_STRENGTH_AOE_ANCIENT_LAND'),
		('GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK',	'GREATPERSON_MOVEMENT_AOE_ANCIENT_LAND');
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,					ModifierId,							AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO',		'JNR_FU_HAO_FREE_UNIT',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON'),
		('GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK',	'GREATPERSON_ANA_NZINGA_ACTIVE',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');

UPDATE GreatPersonIndividualActionModifiers SET ModifierId='GREATPERSON_AETHELFLAED_ACTIVE', AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE' WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK' AND EXISTS (SELECT * FROM GreatPersonIndividuals WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_AETHELFLAED' AND ActionRequiresCompletedDistrictType='DISTRICT_CITY_CENTER');
--------------------------------------------------------------
