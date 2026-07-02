-- 6T_AGP_Unit_Abilities
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,											Kind)
VALUES	('ABILITY_JNR_FU_HAO_CAMOUFLAGE',				'KIND_ABILITY'),
		('ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER',	'KIND_ABILITY');
--------------------------------------------------------------

-- TypeTags
--------------------------------------------------------------
INSERT OR IGNORE INTO TypeTags
		(Type,											Tag)
VALUES	('ABILITY_JNR_FU_HAO_CAMOUFLAGE',				'CLASS_HEAVY_CHARIOT'),
		('ABILITY_JNR_FU_HAO_CAMOUFLAGE',				'CLASS_HEAVY_CAVALRY'),
		('ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER',	'CLASS_NAVAL_MELEE');
--------------------------------------------------------------

-- UnitAbilities
--------------------------------------------------------------
INSERT OR IGNORE INTO UnitAbilities
		(UnitAbilityType,								Name,														Description,												Inactive)
VALUES	('ABILITY_JNR_FU_HAO_CAMOUFLAGE',				'LOC_PROMOTION_CAMOUFLAGE_NAME',						'LOC_PROMOTION_CAMOUFLAGE_DESCRIPTION',							1),
		('ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER',	'LOC_ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER_NAME',	'LOC_ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER_DESCRIPTION',	1);
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,											ModifierType)
VALUES	('JNR_NEI_MANGANIBUKA_FREE_UNIT_REDUCED_STRENGTH',		'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH'),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT_OCEAN_VALID_TERRAIN',	'MODIFIER_PLAYER_UNIT_ADJUST_VALID_TERRAIN');
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,											Name,			Value)
VALUES	('JNR_NEI_MANGANIBUKA_FREE_UNIT_REDUCED_STRENGTH',		'Amount',		-5),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT_OCEAN_VALID_TERRAIN',	'TerrainType',	'TERRAIN_OCEAN'),
		('JNR_NEI_MANGANIBUKA_FREE_UNIT_OCEAN_VALID_TERRAIN',	'Valid',		1);
--------------------------------------------------------------

-- UnitAbilityModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO UnitAbilityModifiers
		(UnitAbilityType,								ModifierId)
VALUES	('ABILITY_JNR_FU_HAO_CAMOUFLAGE',				'CAMOUFLAGE_STEALTH'),
--		('ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER',	'JNR_NEI_MANGANIBUKA_FREE_UNIT_REDUCED_STRENGTH'),
		('ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER',	'JNR_NEI_MANGANIBUKA_FREE_UNIT_OCEAN_VALID_TERRAIN');
--------------------------------------------------------------

-- Requirements
--------------------------------------------------------------
INSERT OR IGNORE INTO Requirements
		(RequirementId,								RequirementType)
VALUES	('AOE_REQUIRES_ANCIENT_REQUIREMENTS_JNR',	'REQUIREMENT_REQUIREMENTSET_IS_MET'),
		('AOE_REQUIRES_ANCIENT_UNIT_JNR',			'REQUIREMENT_UNIT_ERA_TYPE_MATCHES');
--------------------------------------------------------------

-- RequirementArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementArguments
		(RequirementId,								Name,				Value)
VALUES	('AOE_REQUIRES_ANCIENT_REQUIREMENTS_JNR',	'RequirementSetId',	'AOE_ANCIENT_REQUIREMENTS_JNR'),
		('AOE_REQUIRES_ANCIENT_UNIT_JNR',			'EraType',			'ERA_ANCIENT');
--------------------------------------------------------------

-- RequirementSets
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSets
		(RequirementSetId,					RequirementSetType)
VALUES	('AOE_ANCIENT_REQUIREMENTS_JNR',	'REQUIREMENTSET_TEST_ANY');
--------------------------------------------------------------

-- RequirementSetRequirements
--------------------------------------------------------------
INSERT OR IGNORE INTO RequirementSetRequirements
		(RequirementSetId,					RequirementId)
VALUES	('AOE_ANCIENT_REQUIREMENTS_JNR',	'AOE_REQUIRES_ANCIENT_UNIT_JNR'),
		('AOE_ANCIENT_REQUIREMENTS_JNR',	'AOE_REQUIRES_CLASSICAL_UNIT');
--------------------------------------------------------------