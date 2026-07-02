-- Great Sovereigns
----------------------------------------------------------------------------------------------------------------------------
-- Oracle
INSERT INTO Modifiers 
		(ModifierId,						ModifierType,													SubjectRequirementSetId	)
VALUES	('ORACLE_GREAT_SOVEREIGN_POINTS',	'MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS',    'PLATI_ALFRED_SPECIAL_REQUIREMENT_SET'	);

INSERT INTO ModifierArguments
		(ModifierId,						Name,					Type,					Value								)
VALUES	('ORACLE_GREAT_SOVEREIGN_POINTS',	'Amount',				'ARGTYPE_IDENTITY',		2									),
		('ORACLE_GREAT_SOVEREIGN_POINTS',	'GreatPersonClassType', 'ARGTYPE_IDENTITY',		'GREAT_PERSON_CLASS_GreatSovereigns');

INSERT INTO BuildingModifiers
			(BuildingType,	ModifierId						)
	SELECT	BuildingType,	'ORACLE_GREAT_SOVEREIGN_POINTS'	
	FROM Buildings WHERE BuildingType = 'BUILDING_ORACLE';