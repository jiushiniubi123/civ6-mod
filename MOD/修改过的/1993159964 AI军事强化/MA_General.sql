-- MA_General
-- Author: Flactine
-- DateCreated: 2/9/2020 8:41:03 PM
--------------------------------------------------------------
--=====
--TraitModifiers
--=====
INSERT INTO TraitModifiers			
(TraitType,					ModifierId)
VALUES
('TRAIT_LEADER_MAJOR_CIV', 	'MENTAL_AI_NO_MAINTENANCE');
--=====
--Modifiers
--=====
INSERT INTO Modifiers
(ModifierId,					ModifierType,												SubjectRequirementSetId)
VALUES	
('MENTAL_AI_NO_MAINTENANCE',	'MODIFIER_PLAYER_ADJUST_UNIT_MAINTENANCE_DISCOUNT',			'PLAYER_IS_AI');
--=====
--ModifierArguments
--=====
INSERT INTO ModifierArguments
(ModifierId,						Name,				Value)
VALUES						
('MENTAL_AI_NO_MAINTENANCE',		'Amount',			10000);