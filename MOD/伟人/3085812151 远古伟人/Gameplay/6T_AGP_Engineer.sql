-- 6T_AGP_Engineer
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,											Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_IMHOTEP',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA',	'KIND_GREAT_PERSON_INDIVIDUAL');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
UPDATE GreatPersonIndividuals SET EraType='ERA_CLASSICAL' WHERE	GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP';

INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,						Name,													GreatPersonClassType,			EraType,			Gender,	ActionCharges,	ActionRequiresCompletedDistrictType,	ActionRequiresIncompleteWonder)
VALUES	('GREAT_PERSON_INDIVIDUAL_IMHOTEP',				'LOC_GREAT_PERSON_INDIVIDUAL_IMHOTEPI_NAME',			'GREAT_PERSON_CLASS_ENGINEER',	'ERA_CLASSICAL',	'M',	2,				NULL,									1),
		('GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA_NAME',	'GREAT_PERSON_CLASS_ENGINEER',	'ERA_CLASSICAL',	'F',	1,				'DISTRICT_INDUSTRIAL_ZONE',				0);
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,											ModifierType,												RunOnce,	Permanent)
VALUES	('GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',	1,			1),
		('GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS',			'MODIFIER_PLAYER_CITIES_ADJUST_ALL_PROJECTS_PRODUCTION',	1,			1);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,											Name,			Value,	Type)
VALUES	('GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',	'Amount',		175,	'ScaleByGameSpeed'),
		('GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',	'KeepOverflow',	0,		'ARGTYPE_IDENTITY'),

		('GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS',			'Amount',		20,		'ARGTYPE_IDENTITY');

UPDATE ModifierArguments SET Value=250 WHERE Name='Amount' AND ModifierId='GREAT_PERSON_INDIVIDUAL_IMHOTEP_PRODUCTION_ANCIENT_CLASSICAL';
UPDATE ModifierArguments SET Value=125 WHERE Name='Amount' AND ModifierId='GREAT_PERSON_INDIVIDUAL_IMHOTEP_PRODUCTION_OTHER';
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,											Context,	Text)
VALUES	('GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',	'Summary',	'LOC_GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL'),
		('GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS',			'Summary',	'LOC_GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS');
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,						ModifierId,												AttachmentTargetType)
SELECT	'GREAT_PERSON_INDIVIDUAL_IMHOTEP',				'GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_WONDER_IN_TILE'
FROM	GreatPersonIndividuals
WHERE	GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP'
		AND NOT EXISTS (SELECT * FROM GreatPersonIndividualActionModifiers WHERE GreatPersonIndividualType='GREAT_PERSON_INDIVIDUAL_IMHOTEP');

INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,						ModifierId,												AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA',	'GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS',				'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_PLAYER');
--------------------------------------------------------------
