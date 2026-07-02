-- FixOverflowScienceAndCulture_Config
-- Author: PhantomJ_M
-- DateCreated: 1/19/2025 6:15:41 PM
--------------------------------------------------------------
UPDATE GameCores SET PackageId = '0dd7effb-7222-4c96-9558-44af1850766a',	DllPrefix = 'GameCore_XP2_Loader'	WHERE GameCore='Expansion2';


INSERT INTO Parameters
		(ConfigurationGroup,	ConfigurationId,			DefaultValue,	Name,								Description,								Domain,		GroupId,			Hash,	ParameterId,				SortIndex) 
VALUES	('Game',				'GAME_RECURSIVE_SCIENCE',	0,				'LOC_GAME_RECURSIVE_SCIENCE_NAME',	'LOC_GAME_RECURSIVE_SCIENCE_DESCRIPTION',	'bool',		'AdvancedOptions',	0,		'GameRecursiveScience',		2000),
		('Game',				'GAME_RECURSIVE_CULTURE',	0,				'LOC_GAME_RECURSIVE_CULTURE_NAME',	'LOC_GAME_RECURSIVE_CULTURE_DESCRIPTION',	'bool',		'AdvancedOptions',	0,		'GameRecursiveCulture',		2000);

INSERT INTO ParameterDependencies
		(ConfigurationGroup,	ConfigurationId,		ConfigurationValue,				Operator,		ParameterId) 
VALUES	('Game',				'WORLD_BUILDER',		'1',							'NotEquals',	'GameRecursiveScience'), 
		('Game',				'WORLD_BUILDER',		'1',							'NotEquals',	'GameRecursiveCulture');

