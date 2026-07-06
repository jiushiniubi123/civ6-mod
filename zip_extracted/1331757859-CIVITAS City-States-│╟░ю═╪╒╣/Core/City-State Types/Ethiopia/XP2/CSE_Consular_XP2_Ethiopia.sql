/*
	Type
	Authors: SeelingCat
*/

-----------------------------------------------
-- TraitModifiers
-----------------------------------------------

INSERT INTO TraitModifiers 
		(TraitType, 						ModifierId														)
VALUES	('MINOR_CIV_CSE_CONSULAR_TRAIT',	'MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA'				),
		('MINOR_CIV_CSE_CONSULAR_TRAIT',	'MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA'				),
		
		('MINOR_CIV_CSE_CONSULAR_TRAIT',	'MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA_LARGEST'		),
		('MINOR_CIV_CSE_CONSULAR_TRAIT',	'MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA_LARGEST'		);

-----------------------------------------------
-- Modifiers
-----------------------------------------------

INSERT INTO Modifiers 
		(ModifierId,														ModifierType,													SubjectRequirementSetId					)
VALUES	('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA_LARGEST',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',							'PLAYER_HAS_LARGEST_INFLUENCE'			),
		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA_LARGEST',		'MODTYPE_CSE_CONSULAR_FAVOR',									'REQSET_CSE_PLAYER_HAS_CHANCERY'									),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA_LARGEST',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',							'PLAYER_HAS_LARGEST_INFLUENCE'			),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA_LARGEST',		'MODTYPE_CSE_CONSULAR_FAVOR',									'REQSET_CSE_PLAYER_HAS_CONSULATE'									),

		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA',					'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',							'PLAYER_HAS_LARGE_INFLUENCE'			),
		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA',				'MODTYPE_CSE_CONSULAR_FAVOR',									'REQSET_CSE_PLAYER_HAS_CHANCERY'									),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA',					'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',							'PLAYER_HAS_MEDIUM_INFLUENCE'			),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA',				'MODTYPE_CSE_CONSULAR_FAVOR',									'REQSET_CSE_PLAYER_HAS_CONSULATE'									);

-----------------------------------------------
-- ModifierArguments
-----------------------------------------------

INSERT INTO ModifierArguments
		(ModifierId,														Name,				Value															)
VALUES	('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA',					'ModifierId',		'MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA'			),
		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA',				'Amount',			2																),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA',					'ModifierId',		'MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA'			),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA',				'Amount',			2																),

		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_ETHIOPIA_LARGEST',			'ModifierId',		'MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA_LARGEST'	),
		('MODIFIER_CSE_CONSULAR_CHANCERY_FAVOR_MOD_ETHIOPIA_LARGEST',		'Amount',			2																),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_ETHIOPIA_LARGEST',			'ModifierId',		'MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA_LARGEST'	),
		('MODIFIER_CSE_CONSULAR_CONSULATE_FAVOR_MOD_ETHIOPIA_LARGEST',		'Amount',			2																);

-----------------------------------------------
-- RequirementSets
-----------------------------------------------

INSERT INTO RequirementSets
		(RequirementSetId,						RequirementSetType			)
VALUES	('REQSET_CSE_PLAYER_HAS_CHANCERY',		'REQUIREMENTSET_TEST_ANY'	),
		('REQSET_CSE_PLAYER_HAS_CONSULATE',		'REQUIREMENTSET_TEST_ANY'	);

-----------------------------------------------
-- RequirementSetRequirements
-----------------------------------------------

INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId			)
VALUES	('REQSET_CSE_PLAYER_HAS_CHANCERY',		'REQ_CSE_PLAYER_HAS_CHANCERY'	),
		('REQSET_CSE_PLAYER_HAS_CONSULATE',		'REQ_CSE_PLAYER_HAS_CONSULATE'	);

-----------------------------------------------
-- Requirements
-----------------------------------------------

INSERT INTO Requirements
		(RequirementId,							RequirementType			)
VALUES	('REQ_CSE_PLAYER_HAS_CHANCERY',			'REQUIREMENT_PLAYER_HAS_BUILDING'	),
		('REQ_CSE_PLAYER_HAS_CONSULATE',		'REQUIREMENT_PLAYER_HAS_BUILDING'	);

-----------------------------------------------
-- RequirementArguments
-----------------------------------------------

INSERT INTO RequirementArguments
		(RequirementId,							Name,				Value			)
VALUES	('REQ_CSE_PLAYER_HAS_CHANCERY',			'BuildingType',		'BUILDING_CHANCERY'	),
		('REQ_CSE_PLAYER_HAS_CONSULATE',		'BuildingType',		'BUIDLING_CONSULATE'	);

