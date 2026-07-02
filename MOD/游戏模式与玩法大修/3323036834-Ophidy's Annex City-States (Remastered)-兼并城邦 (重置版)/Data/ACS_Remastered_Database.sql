-- ACS_Remastered_Database
-- Author: Ophidy
-- DateCreated: 8/31/2024 7:58:48 PM
-- Modified: Removed Release/Assimilate/Absorb mechanics; 
--           Halved base cost; Added city count factor for pricing
--------------------------------------------------------------

INSERT INTO GlobalParameters
(Name,											Value)
VALUES
('PARAMETER_ACS_FAVOR_MULTIPLIER',				10),
('PARAMETER_ACSR_BASE_COST',					50),
('PARAMETER_ACSR_POP_FACTOR',					10),
('PARAMETER_ACSR_DISTRICT_FACTOR',				4),
('PARAMETER_ACSR_ENVOY_DIFF_FACTOR_MAX',		2),
('PARAMETER_ACSR_DISTANCE_FACTOR',				24),
('PARAMETER_ACSR_CITY_COUNT_FACTOR',			5);

-- ===========================================================================
-- Raffles Great Person adjustment
-- Remove vanilla Raffles ability and replace with free annex
-- ===========================================================================
CREATE TRIGGER ACSR_RafflseAdjustGreatPersonIndividualActionModifiers
AFTER INSERT ON GreatPersonIndividualActionModifiers
WHEN NEW.ModifierId = 'GREATPERSON_CITY_STATE_ABSORB_EXPANSIONS'
BEGIN
	DELETE FROM GreatPersonIndividualActionModifiers WHERE ModifierId = NEW.ModifierId;
END;

CREATE TRIGGER ACSR_RafflseAdjustModifierArguments
AFTER INSERT ON ModifierArguments
WHEN NEW.ModifierId = 'GREATPERSON_CITY_STATE_ABSORB_EXPANSIONS'
BEGIN
	DELETE FROM ModifierArguments WHERE ModifierId = NEW.ModifierId;
END;

CREATE TRIGGER ACSR_RafflseAdjustModifierStrings
AFTER INSERT ON ModifierStrings
WHEN NEW.ModifierId = 'GREATPERSON_CITY_STATE_ABSORB_EXPANSIONS'
BEGIN
	DELETE FROM ModifierStrings WHERE ModifierId = NEW.ModifierId;
END;

CREATE TRIGGER ACSR_RafflseAdjustModifiers
AFTER INSERT ON Modifiers
WHEN NEW.ModifierId = 'GREATPERSON_CITY_STATE_ABSORB_EXPANSIONS'
BEGIN
	DELETE FROM Modifiers WHERE ModifierId = NEW.ModifierId;
END;

INSERT INTO Modifiers
(ModifierId,									ModifierType)
VALUES
('MODFEAT_ACSR_FREE_ANNEX',						'MODIFIER_PLAYER_GRANT_YIELD');

INSERT INTO ModifierArguments
(ModifierId,									Name,						Value)
VALUES
('MODFEAT_ACSR_FREE_ANNEX',						'YieldType',				'YIELD_GOLD'),
('MODFEAT_ACSR_FREE_ANNEX',						'Amount',					'0');

INSERT INTO ModifierStrings
(ModifierId,									Context,					Text)
VALUES
('MODFEAT_ACSR_FREE_ANNEX',						'Summary',					'LOC_ACSR_RAFFLES_ACTION');

CREATE TRIGGER ACSR_RafflseAdjustGreatPersonIndividuals
AFTER INSERT ON GreatPersonIndividuals
WHEN NEW.GreatPersonIndividualType = 'GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES'
BEGIN
	UPDATE GreatPersonIndividuals SET ActionRequiresCityStateTerritory = 1, ActionRequiresSuzerainTerritory = 0 WHERE GreatPersonIndividualType = NEW.GreatPersonIndividualType;
	
	INSERT INTO GreatPersonIndividualActionModifiers
	(GreatPersonIndividualType,						ModifierId,					AttachmentTargetType)
	VALUES
	('GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES',	'MODFEAT_ACSR_FREE_ANNEX',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_UNIT_GREATPERSON');
END;