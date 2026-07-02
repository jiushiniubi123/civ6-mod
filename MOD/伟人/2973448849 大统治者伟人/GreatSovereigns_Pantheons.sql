--=============================================================================================================
-- PLATI SOVEREIGN PANTHEON
--=============================================================================================================
-- Types
---------------------------------------------------------------------------------------------------------------
INSERT INTO Types
		(Type,						Kind)
VALUES	('PLATI_BELIEF_SOVEREIGN',			'KIND_BELIEF');
---------------------------------------------------------------------------------------------------------------
-- Beliefs
---------------------------------------------------------------------------------------------------------------
INSERT INTO Beliefs
		(BeliefType,				Name,								Description,								BeliefClassType)
VALUES	('PLATI_BELIEF_SOVEREIGN',			'LOC_PLATI_BELIEF_SOVEREIGN_NAME',			'LOC_PLATI_BELIEF_SOVEREIGN_DESCRIPTION',			'BELIEF_CLASS_PANTHEON');
---------------------------------------------------------------------------------------------------------------
-- BeliefModifiers
---------------------------------------------------------------------------------------------------------------
INSERT INTO BeliefModifiers 
		(BeliefType,				ModifierID) 
VALUES	('PLATI_BELIEF_SOVEREIGN',			'BELIEF_SOVEREIGN_POINT'),
		('PLATI_BELIEF_SOVEREIGN',			'BELIEF_SOVEREIGN_POINT_GOLDEN_AGE');
---------------------------------------------------------------------------------------------------------------
-- Modifiers
---------------------------------------------------------------------------------------------------------------
INSERT INTO Modifiers
		(ModifierId,									ModifierType,												SubjectRequirementSetId)
VALUES	('BELIEF_SOVEREIGN_POINT',						'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',						'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
		('BELIEF_SOVEREIGN_POINT_MODIFIER',				'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS',				NULL),
		('BELIEF_SOVEREIGN_POINT_GOLDEN_AGE',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',						'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
		('BELIEF_SOVEREIGN_POINT_GOLDEN_AGE_MODIFIER',	'MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS',				'PLAYER_HAS_GOLDEN_AGE');
---------------------------------------------------------------------------------------------------------------
-- ModifierArguments
---------------------------------------------------------------------------------------------------------------
INSERT INTO ModifierArguments 
		(ModifierId,									Name,						Value)
VALUES	('BELIEF_SOVEREIGN_POINT',						'ModifierId',				'BELIEF_SOVEREIGN_POINT_MODIFIER'),
		('BELIEF_SOVEREIGN_POINT_MODIFIER',				'GreatPersonClassType',		'GREAT_PERSON_CLASS_GreatSovereigns'),
		('BELIEF_SOVEREIGN_POINT_MODIFIER',				'Amount',					1),
		('BELIEF_SOVEREIGN_POINT_GOLDEN_AGE',			'ModifierId',				'BELIEF_SOVEREIGN_POINT_GOLDEN_AGE_MODIFIER'),
		('BELIEF_SOVEREIGN_POINT_GOLDEN_AGE_MODIFIER',	'GreatPersonClassType',		'GREAT_PERSON_CLASS_GreatSovereigns'),
		('BELIEF_SOVEREIGN_POINT_GOLDEN_AGE_MODIFIER',	'Amount',					1);