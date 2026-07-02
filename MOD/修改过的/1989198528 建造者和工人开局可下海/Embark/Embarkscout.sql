INSERT INTO Types
(	Type, 					Kind			)	VALUES
(	'TECH_SCOUTSAIL',		'KIND_TECH'		);

INSERT INTO TechnologyPrereqs
(	Technology, 		PrereqTech			) 	VALUES
(	'TECH_SAILING',		'TECH_SCOUTSAIL'	);

INSERT INTO Technologies
(	TechnologyType, 		Name, 	Cost,	EraType,			UITreeRow,	AdvisorType,		EmbarkUnitType 	) 	VALUES
(	'TECH_SCOUTSAIL', 	'',		'25',	'ERA_ANCIENT',		'2', 		'ADVISOR_GENERIC',	'UNIT_SETTLER' 	);

END