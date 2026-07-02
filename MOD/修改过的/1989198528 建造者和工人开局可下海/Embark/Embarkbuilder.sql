INSERT INTO Types
(	Type, 					Kind			)	VALUES
(	'TECH_BUILDERSAIL',		'KIND_TECH'		);

INSERT INTO TechnologyPrereqs
(	Technology, 		PrereqTech			) 	VALUES
(	'TECH_SAILING',		'TECH_BUILDERSAIL'	);

INSERT INTO Technologies
(	TechnologyType, 		Name, 	Cost,	EraType,			UITreeRow,	AdvisorType,		EmbarkUnitType 	) 	VALUES
(	'TECH_BUILDERSAIL', 	'',		'25',	'ERA_ANCIENT',		'4', 		'ADVISOR_GENERIC',	'UNIT_BUILDER' 	);