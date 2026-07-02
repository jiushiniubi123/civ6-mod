-- 6T_AGP_Merchant
-- Author: JNR
--------------------------------------------------------------

-- Types
--------------------------------------------------------------
INSERT OR IGNORE INTO Types
		(Type,									Kind)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_AMA_E',	'KIND_GREAT_PERSON_INDIVIDUAL'),
		('GREAT_PERSON_INDIVIDUAL_JNR_HIRAM',	'KIND_GREAT_PERSON_INDIVIDUAL'),

		('RESOURCE_JNR_MUREX',					'KIND_RESOURCE');
--------------------------------------------------------------

-- GreatPersonIndividuals
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividuals
		(GreatPersonIndividualType,				Name,										GreatPersonClassType,			EraType,		Gender,	ActionCharges,	ActionRequiresCompletedDistrictType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_AMA_E',	'LOC_GREAT_PERSON_INDIVIDUAL_AMA_E_NAME',	'GREAT_PERSON_CLASS_MERCHANT',	'ERA_ANCIENT',	'F',	1,				'DISTRICT_COMMERCIAL_HUB'),
		('GREAT_PERSON_INDIVIDUAL_JNR_HIRAM',	'LOC_GREAT_PERSON_INDIVIDUAL_HIRAM_NAME',	'GREAT_PERSON_CLASS_MERCHANT',	'ERA_ANCIENT',	'M',	1,				'DISTRICT_COMMERCIAL_HUB');
--------------------------------------------------------------

-- Resources
--------------------------------------------------------------
INSERT OR IGNORE INTO Resources
		(ResourceType,			Name,							ResourceClassType,		Happiness,	Frequency)
VALUES	('RESOURCE_JNR_MUREX',	'LOC_RESOURCE_JNR_MUREX_NAME',	'RESOURCECLASS_LUXURY',	4,			0);
--------------------------------------------------------------

-- Modifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO Modifiers
		(ModifierId,												ModifierType,												RunOnce,	Permanent)
VALUES	('GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',		'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',	1,			1),
		('GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES',	'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS',	1,			1),
		('GREATPERSON_JNR_GRANT_MUREX',								'MODIFIER_SINGLE_CITY_GRANT_RESOURCE_IN_CITY',				1,			1);
--------------------------------------------------------------

-- ModifierArguments
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierArguments
		(ModifierId,												Name,			Value)
VALUES	('GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',		'YieldType',	'YIELD_FOOD'),
		('GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',		'Amount',		1),
		('GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',		'Domestic',		1),
		('GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES',	'YieldType',	'YIELD_PRODUCTION'),
		('GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES',	'Amount',		1),
		('GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES',	'Domestic',		1),
		('GREATPERSON_JNR_GRANT_MUREX',								'ResourceType',	'RESOURCE_JNR_MUREX'),
		('GREATPERSON_JNR_GRANT_MUREX',								'Amount',		1);
--------------------------------------------------------------

-- ModifierStrings
--------------------------------------------------------------
INSERT OR IGNORE INTO ModifierStrings
		(ModifierId,												Context,	Text)
VALUES	('GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',		'Summary',	'LOC_GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES'),
		('GREATPERSON_JNR_GRANT_MUREX',								'Summary',	'LOC_GREATPERSON_JNR_GRANT_MUREX');
--------------------------------------------------------------

-- GreatPersonIndividualActionModifiers
--------------------------------------------------------------
INSERT OR IGNORE INTO GreatPersonIndividualActionModifiers
		(GreatPersonIndividualType,				ModifierId,													AttachmentTargetType)
VALUES	('GREAT_PERSON_INDIVIDUAL_JNR_AMA_E',	'GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY',					'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
		('GREAT_PERSON_INDIVIDUAL_JNR_AMA_E',	'GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES',			'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
		('GREAT_PERSON_INDIVIDUAL_JNR_AMA_E',	'GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'),
		('GREAT_PERSON_INDIVIDUAL_JNR_HIRAM',	'GREATPERSON_JNR_GRANT_MUREX',								'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE');
--------------------------------------------------------------
