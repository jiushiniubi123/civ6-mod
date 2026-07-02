-- 6T_AGP_Prophet
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,												Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_MOSES',				'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI',	'KIND_GREAT_PERSON_INDIVIDUAL');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,							Name,														GreatPersonClassType,			EraType,		Gender,	ActionCharges)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_MOSES',				'LOC_GREAT_PERSON_INDIVIDUAL_JNR_MOSES_NAME',				'GREAT_PERSON_CLASS_PROPHET',	'ERA_ANCIENT',	'M',	0),
		('GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI_NAME',	'GREAT_PERSON_CLASS_PROPHET',	'ERA_ANCIENT',	'F',	0);
--------------------------------------------------------------