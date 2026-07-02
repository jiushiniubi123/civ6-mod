-- 6T_AGP_Writer
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,											Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA',	'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP',		'KIND_GREAT_PERSON_INDIVIDUAL'),

		('GREATWORK_JNR_EN_HEDU_ANNA_1',				'KIND_GREATWORK'),
		('GREATWORK_JNR_EN_HEDU_ANNA_2',				'KIND_GREATWORK'),
		('GREATWORK_JNR_PTAHHOTEP_1',					'KIND_GREATWORK'),
		('GREATWORK_JNR_PTAHHOTEP_2',					'KIND_GREATWORK');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,						Name,													GreatPersonClassType,			EraType,		Gender,	ActionCharges)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA_NAME',	'GREAT_PERSON_CLASS_WRITER',	'ERA_ANCIENT',	'F',	0),
		('GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP',		'LOC_GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP_NAME',		'GREAT_PERSON_CLASS_WRITER',	'ERA_ANCIENT',	'M',	0);
--------------------------------------------------------------

-- GreatWorks
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatWorks
		(GreatWorkType,						GreatWorkObjectType,		GreatPersonIndividualType,					Name,										Quote,										Tourism)
VALUES	('GREATWORK_JNR_EN_HEDU_ANNA_1',	'GREATWORKOBJECT_WRITING',	'GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA',	'LOC_GREATWORK_JNR_EN_HEDU_ANNA_1_NAME',	'LOC_GREATWORK_JNR_EN_HEDU_ANNA_1_QUOTE',	4),
		('GREATWORK_JNR_EN_HEDU_ANNA_2',	'GREATWORKOBJECT_WRITING',	'GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA',	'LOC_GREATWORK_JNR_EN_HEDU_ANNA_2_NAME',	'LOC_GREATWORK_JNR_EN_HEDU_ANNA_2_QUOTE',	4),
		('GREATWORK_JNR_PTAHHOTEP_1',		'GREATWORKOBJECT_WRITING',	'GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP',	'LOC_GREATWORK_JNR_PTAHHOTEP_1_NAME',		'LOC_GREATWORK_JNR_PTAHHOTEP_1_QUOTE',				4),
		('GREATWORK_JNR_PTAHHOTEP_2',		'GREATWORKOBJECT_WRITING',	'GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP',	'LOC_GREATWORK_JNR_PTAHHOTEP_2_NAME',		'LOC_GREATWORK_JNR_PTAHHOTEP_2_QUOTE',				4);
--------------------------------------------------------------

-- GreatWork_YieldChanges
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatWork_YieldChanges
		(GreatWorkType,						YieldType,			YieldChange)
VALUES	('GREATWORK_JNR_EN_HEDU_ANNA_1',	'YIELD_CULTURE',	4),
		('GREATWORK_JNR_EN_HEDU_ANNA_2',	'YIELD_CULTURE',	4),
		('GREATWORK_JNR_PTAHHOTEP_1',		'YIELD_CULTURE',	4),
		('GREATWORK_JNR_PTAHHOTEP_2',		'YIELD_CULTURE',	4);
--------------------------------------------------------------