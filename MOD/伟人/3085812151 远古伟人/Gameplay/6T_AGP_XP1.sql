-- 6T_AGP_XP1
-- Author: JNR
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
UPDATE	GreatPersonIndividuals
SET		ActionRequiresOwnedTile=1,
		ActionRequiresCompletedDistrictType='DISTRICT_CITY_CENTER'
WHERE	GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK'
		AND EXISTS (SELECT * FROM Modifiers WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE');
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,									ModifierType,												RunOnce,	Permanent)
VALUES	('GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',	1,			1),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_CULTURE',	'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',	1,			1),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_FAITH',		'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION',	1,			1);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,									Name,			Value)
VALUES	('GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE',	'YieldType',	'YIELD_SCIENCE'),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE',	'Amount',		0.2),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_CULTURE',	'YieldType',	'YIELD_CULTURE'),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_CULTURE',	'Amount',		0.2),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_FAITH',		'YieldType',	'YIELD_FAITH'),
		('GREATPERSON_JNR_MAITREYI_CITIZEN_FAITH',		'Amount',		0.2);
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,									Context,	Text)
VALUES	('GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE',	'Summary',	'LOC_GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE');
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
UPDATE	GreatPersonIndividualActionModifiers
SET		ModifierId='GREATPERSON_AETHELFLAED_ACTIVE',
		AttachmentTargetType='GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'
WHERE	GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK'
		AND EXISTS (SELECT * FROM Modifiers WHERE ModifierId='GREATPERSON_AETHELFLAED_ACTIVE');

DELETE FROM GreatPersonIndividualActionModifiers WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI';

INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,					ModifierId,	AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI',	'GREATPERSON_JNR_MAITREYI_CITIZEN_SCIENCE',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
		('GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI',	'GREATPERSON_JNR_MAITREYI_CITIZEN_CULTURE',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
		('GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI',	'GREATPERSON_JNR_MAITREYI_CITIZEN_FAITH',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
--------------------------------------------------------------
