--==========================================================================================================================
-- Barbarians--
--==========================================================================================================================
	-- BarbarianTribes
	----------------------
		-- Decrease resource distance for the Cavalry Barbarians
		UPDATE BarbarianTribes
			SET ResourceRange = 3
			WHERE TribeType = 'TRIBE_CAVALRY';

		-- Increase Spawn interval for the Naval Barbarians
		UPDATE BarbarianTribes
			SET TurnsToWarriorSpawn = 15
			WHERE TribeType = 'TRIBE_NAVAL';
	----------------------
	-- Technologies & Units
	----------------------
		UPDATE Technologies
			SET BarbarianFree = 0
			WHERE BarbarianFree = 1 AND TechnologyType NOT IN ('TECH_BRONZE_WORKING', 'TECH_SAILING');

		UPDATE Units
			SET PrereqTech = 'TECH_ARCHERY'
			WHERE UnitType IN ('UNIT_BARBARIAN_HORSE_ARCHER');
--==========================================================================================================================
-- -10 Combat Strength for naval units before researching Celestial Navigation
-- This is on par with the Barbarian Horsemen
--==========================================================================================================================
	-- Abilities
	--------------------------------------------------------------------------
		-- Types
		----------------------
			INSERT INTO Types
					(Type,											Kind)
			VALUES	('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',		'KIND_ABILITY');
		----------------------
		-- UnitAbilities
		----------------------
			INSERT INTO UnitAbilities
				(
					UnitAbilityType,
					Name,
					Description,

					Inactive,
					Permanent
				)
				VALUES
				(
					'ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',
					'LOC_ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS_NAME',
					'LOC_ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS_DESCRIPTION',

					1,
					0
				);
		----------------------
		-- UnitAbilityModifiers
		----------------------
			INSERT INTO UnitAbilityModifiers
					(UnitAbilityType,								ModifierId)
			VALUES	('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',		'SUK_BARBARIAN_NAVAL_MALUS_COMBAT');
		----------------------
		-- TypeTags
		----------------------
			INSERT INTO TypeTags
					(Type,										Tag)
			VALUES	('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',	'CLASS_NAVAL_MELEE'),
					('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',	'CLASS_NAVAL_RANGED'),
					('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',	'CLASS_NAVAL_RAIDER'),
					('ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS',	'CLASS_NAVAL_CARRIER');
	--------------------------------------------------------------------------
	-- Modifiers
	--------------------------------------------------------------------
		-- TraitModifiers
		----------------------
			INSERT INTO TraitModifiers
					(TraitType,				ModifierId)
			VALUES	('TRAIT_BARBARIAN', 	'SUK_BARBARIAN_NAVAL_MALUS');
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
						'SUK_BARBARIAN_NAVAL_MALUS',
						'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',
						'SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION'
					),
					(
						'SUK_BARBARIAN_NAVAL_MALUS_COMBAT',
						'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
						NULL
					);
		----------------------
		-- ModifierArguments
		----------------------
			INSERT INTO ModifierArguments
					(ModifierId,							Name,				Value)
			VALUES	('SUK_BARBARIAN_NAVAL_MALUS',			'AbilityType',		'ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS'),
					('SUK_BARBARIAN_NAVAL_MALUS_COMBAT',	'Amount',			-10);
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
					'SUK_BARBARIAN_NAVAL_MALUS_COMBAT',
					'Preview',
					'LOC_ABILITY_SUK_BARBARIAN_PRIMITIVE_SHIPS_DESCRIPTION'
				);
	----------------------------------------------------------
	-- REQUIREMENTS
	----------------------------------------------------------
		-- RequirementSets
		----------------------
			INSERT INTO RequirementSets
					(RequirementSetId,									RequirementSetType)
			VALUES	('SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION',		'REQUIREMENTSET_TEST_ALL');
		----------------------
		-- RequirementSetRequirements
		----------------------
			INSERT INTO RequirementSetRequirements
					(RequirementSetId,									RequirementId)
			VALUES	('SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION',		'REQUIRES_SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION');
		----------------------
		-- Requirements
		----------------------
			INSERT INTO Requirements
					(RequirementId, 										RequirementType,						Inverse)
			VALUES	('REQUIRES_SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION',	'REQUIREMENT_PLAYER_HAS_TECHNOLOGY',	1);
		----------------------
		-- RequirementArguments
		----------------------
			INSERT INTO RequirementArguments
					(RequirementId, 											Name,				Value)
			VALUES	('REQUIRES_SUK_BARBARIAN_NOT_HAS_CELESTIAL_NAVIGATION', 	'TechnologyType',	'TECH_CELESTIAL_NAVIGATION');
--==========================================================================================================================
--==========================================================================================================================