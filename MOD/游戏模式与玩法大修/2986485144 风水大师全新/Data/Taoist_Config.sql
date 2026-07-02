-- Taoist_Config
-- Author: pen
-- DateCreated: 2025/10/6 10:33:21
-- References on Ophidy, Nwflower, Synora
--------------------------------------------------------------
insert or replace into Parameters
(ParameterId, 						Name,									Description, 										Domain, 						DefaultValue, 				ConfigurationGroup,	ConfigurationId, 				GroupId,			SortIndex) 
values
('Taoist_Settings',					'LOC_TAOIST_SETTINGS_NAME',				'LOC_TAOIST_SETTINGS_DESCRIPTION',					'TaoistSettings',				'SETTINGS_TAOIST_STANDARD',	'Game',				'Taoist_Settings',				'AdvancedOptions',	1687),

('Taoist_OutBorder',				'LOC_TAOIST_OUTBORDER_NAME',			'LOC_TAOIST_OUTBORDER_DESCRIPTION',					'bool',							1,							'Game',				'Taoist_OutBorder',				'AdvancedOptions',	1690),
('Taoist_Disposable',				'LOC_TAOIST_DISPOSABLE_NAME',			'LOC_TAOIST_DISPOSABLE_DESCRIPTION',				'bool',							1,							'Game',				'Taoist_Disposable',			'AdvancedOptions',	1690),
('Taoist_SeaLeyline',				'LOC_TAOIST_SEA_LEYLINE_NAME',			'LOC_TAOIST_SEA_LEYLINE_DESCRIPTION',				'bool',							0,							'Game',				'Taoist_SeaLeyline',			'AdvancedOptions',	1691),
('Taoist_EnterForeign',				'LOC_TAOIST_ENTER_FOREIGN_NAME',		'LOC_TAOIST_ENTER_FOREIGN_DESCRIPTION',				'bool',							0,							'Game',				'Taoist_EnterForeign',			'AdvancedOptions',	1690),
('Taoist_AllowPromotion',			'LOC_TAOIST_ALLOW_PROMOTION_NAME',		'LOC_TAOIST_ALLOW_PROMOTION_DESCRIPTION',			'bool',							1,							'Game',				'Taoist_AllowPromotion',		'AdvancedOptions',	1690),
('Taoist_RigidTerrain',				'LOC_TAOIST_RIGID_TERRAIN_NAME',		'LOC_TAOIST_RIGID_TERRAIN_DESCRIPTION',				'bool',							1,							'Game',				'Taoist_RigidTerrain',			'AdvancedOptions',	1690),
('Taoist_NoDistrict',				'LOC_TAOIST_NO_DISTRICT_NAME',			'LOC_TAOIST_NO_DISTRICT_DESCRIPTION',				'bool',							1,							'Game',				'Taoist_NoDistrict',			'AdvancedOptions',	1689),
('Taoist_NoImprovement',			'LOC_TAOIST_NO_IMPROVEMENT_NAME',		'LOC_TAOIST_NO_IMPROVEMENT_DESCRIPTION',			'bool',							1,							'Game',				'Taoist_NoImprovement',			'AdvancedOptions',	1689),
('Taoist_OnlyOne',					'LOC_TAOIST_ONLY_ONE_NAME',				'LOC_TAOIST_ONLY_ONE_DESCRIPTION',					'bool',							0,							'Game',				'Taoist_OnlyOne',				'AdvancedOptions',	1690),
('Taoist_PromotionSupplement',		'LOC_TAOIST_PROMOTION_SUPPLEMENT_NAME',	'LOC_TAOIST_PROMOTION_SUPPLEMENT_DESCRIPTION',		'bool',							1,							'Game',				'Taoist_PromotionSupplement',	'AdvancedOptions',	1691),
('Taoist_InitialActions',			'LOC_TAOIST_INITIAL_ACTIONS_NAME',		'LOC_TAOIST_INITIAL_ACTIONS_DESCRIPTION',			'Taoist_InitialActionsTimes',	1,							'Game',				'Taoist_InitialActionsTimes',	'AdvancedOptions',	1688),
('Taoist_MaxRecordActions',			'LOC_TAOIST_MAX_RECORD_ACTIONS_NAME',	'LOC_TAOIST_MAX_RECORD_ACTIONS_DESCRIPTION',		'Taoist_MaxRecordActions',		2,							'Game',				'Taoist_MaxRecordActions',		'AdvancedOptions',	1688),
('Taoist_InitialMovement',			'LOC_TAOIST_INITIAL_MOVEMENT_NAME',		'LOC_TAOIST_INITIAL_MOVEMENT_DESCRIPTION',			'Taoist_InitialMovement',		3,							'Game',				'Taoist_InitialMovement',		'AdvancedOptions',	1688);

insert or replace into DomainRanges
(Domain, 						MinimumValue, 	MaximumValue) 
values
('Taoist_InitialActionsTimes',	0,				3),
('Taoist_MaxRecordActions',		1,				3),
('Taoist_InitialMovement',		3,				5);

insert or replace into DomainValues
(Domain, 						Value, 						Name,									Description,								SortIndex) 
values
('TaoistSettings',				'SETTINGS_TAOIST_STANDARD',	'LOC_SETTINGS_TAOIST_STANDARD_NAME',	'LOC_SETTINGS_TAOIST_STANDARD_DESCRIPTION',	1),
('TaoistSettings',				'SETTINGS_TAOIST_NORMAL',	'LOC_SETTINGS_TAOIST_NORMAL_NAME',		'LOC_SETTINGS_TAOIST_NORMAL_DESCRIPTION',	2),
('TaoistSettings',				'SETTINGS_TAOIST_CUSTOM',	'LOC_SETTINGS_TAOIST_CUSTOM_NAME',		'LOC_SETTINGS_TAOIST_CUSTOM_DESCRIPTION',	3);

insert or replace into ParameterCriteria
(ParameterId,					ConfigurationGroup,		ConfigurationId,			Operator,		ConfigurationValue)
values
('Taoist_PromotionSupplement',	'Game',					'Taoist_AllowPromotion',	'Equals',		'1');

insert or replace into ParameterDependencies
(ParameterId, 					ConfigurationGroup, ConfigurationId, 			Operator, 	ConfigurationValue) 
values
('Taoist_Settings',				'Game',				'GAMEMODE_SECRETSOCIETIES',	'Equals',	1),

--('Taoist_Settings',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_DEAL_CUSTOM'),

('Taoist_OutBorder',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_Disposable',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_SeaLeyline',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_EnterForeign',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_AllowPromotion',		'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_RigidTerrain',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_NoDistrict',			'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_NoImprovement',		'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_OnlyOne',				'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_PromotionSupplement',	'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_InitialActions',		'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_MaxRecordActions',		'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM'),
('Taoist_InitialMovement',		'Game',				'Taoist_Settings',			'Equals',	'SETTINGS_TAOIST_CUSTOM');

--Static: 1为绑定，0为触发
insert or replace into ConfigurationUpdates 
(SourceGroup,		SourceId,						SourceValue,	TargetGroup,	TargetId,						TargetValue,	Hash,	Static)
values
('Game',			'Taoist_AllowPromotion',		0,				'Game',			'Taoist_PromotionSupplement',	0,			0,		0),
('Game',			'Taoist_AllowPromotion',		1,				'Game',			'Taoist_PromotionSupplement',	1,			0,		0);
