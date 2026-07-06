/*
	城邦平衡修改
	对原版、DLC及模组城邦进行数据调整
*/

-----------------------------------------------
-- 日内瓦 GENEVA (原版): 未与任何主要文明交战时+10%科技值 (原15%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 10
WHERE ModifierId = 'MINOR_CIV_GENEVA_SCIENCE_AT_PEACE_BONUS'
AND Name = 'Amount';

-----------------------------------------------
-- 伊萨帕 CSE_IZAPA (XP1): 黄金时代尤里卡额外+5%科技 (原+10%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 5
WHERE ModifierId = 'CSE_IZAPA_TECH_BOOST'
AND Name = 'Amount';

-----------------------------------------------
-- 利马 CSE_LIMA (Base): 学院和建筑建造速度+20%，学院区域+3生产力
-- 移除原有的额外区域和旧生产加成，替换为新的
-----------------------------------------------

-- 删除旧的 TraitModifiers
DELETE FROM TraitModifiers
WHERE TraitType = 'MINOR_CIV_CSE_LIMA_TRAIT';

-- 删除旧的 Modifiers
DELETE FROM Modifiers
WHERE ModifierId LIKE 'CSE_LIMA_%';

-- 删除旧的 ModifierArguments
DELETE FROM ModifierArguments
WHERE ModifierId LIKE 'CSE_LIMA_%';

-- 删除旧的 RequirementSets
DELETE FROM RequirementSets
WHERE RequirementSetId LIKE 'REQSET_CSE_LIMA_%';

-- 删除旧的 RequirementSetRequirements
DELETE FROM RequirementSetRequirements
WHERE RequirementSetId LIKE 'REQSET_CSE_LIMA_%';

-- 插入新的 TraitModifiers
INSERT INTO TraitModifiers
		(TraitType,						ModifierId								)
VALUES	('MINOR_CIV_CSE_LIMA_TRAIT',	'CSE_LIMA_SUZERAIN_CAMPUS_PRODUCTION'	),
		('MINOR_CIV_CSE_LIMA_TRAIT',	'CSE_LIMA_SUZERAIN_BUILDING_PRODUCTION'	),
		('MINOR_CIV_CSE_LIMA_TRAIT',	'CSE_LIMA_SUZERAIN_CAMPUS_YIELD'		);

-- 插入新的 Modifiers
-- 注意: MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE 使用 SubjectRequirementSetId 筛选区域类型
-- MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION 使用 BuildingType 参数
INSERT INTO Modifiers
		(ModifierId,							ModifierType,										SubjectRequirementSetId	)
VALUES	('CSE_LIMA_SUZERAIN_CAMPUS_PRODUCTION',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				'PLAYER_IS_SUZERAIN'	),
		('CSE_LIMA_SUZERAIN_BUILDING_PRODUCTION',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				'PLAYER_IS_SUZERAIN'	),
		('CSE_LIMA_SUZERAIN_CAMPUS_YIELD',		'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',				'PLAYER_IS_SUZERAIN'	),
		('CSE_LIMA_CAMPUS_PRODUCTION',			'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION',	NULL					),
		('CSE_LIMA_BUILDING_PRODUCTION',		'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION',	NULL					),
		('CSE_LIMA_CAMPUS_YIELD',				'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'DISTRICT_IS_CAMPUS'	);

-- 插入新的 ModifierArguments
INSERT INTO ModifierArguments
		(ModifierId,							Name,			Value														)
VALUES	('CSE_LIMA_SUZERAIN_CAMPUS_PRODUCTION',	'ModifierId',	'CSE_LIMA_CAMPUS_PRODUCTION'								),
		('CSE_LIMA_SUZERAIN_BUILDING_PRODUCTION',	'ModifierId',	'CSE_LIMA_BUILDING_PRODUCTION'								),
		('CSE_LIMA_SUZERAIN_CAMPUS_YIELD',		'ModifierId',	'CSE_LIMA_CAMPUS_YIELD'										),
		('CSE_LIMA_CAMPUS_PRODUCTION',			'DistrictType',	'DISTRICT_CAMPUS'											),
		('CSE_LIMA_CAMPUS_PRODUCTION',			'Amount',		20															),
		('CSE_LIMA_BUILDING_PRODUCTION',		'BuildingType',	'BUILDING_LIBRARY,BUILDING_UNIVERSITY,BUILDING_RESEARCH_LAB'	),
		('CSE_LIMA_BUILDING_PRODUCTION',		'Amount',		20															),
		('CSE_LIMA_CAMPUS_YIELD',				'YieldType',	'YIELD_PRODUCTION'											),
		('CSE_LIMA_CAMPUS_YIELD',				'Amount',		3															);

-----------------------------------------------
-- 撒马尔罕 CSE_SAMARQAND (Base): 每个已获得伟人+1%科学，最多+30% (原+2%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 1
WHERE ModifierId = 'CSE_SAMARQAND_GP_SCIENCE'
AND Name = 'Amount';

-----------------------------------------------
-- 伐腊毗 CSE_VALABHI (Base): 学院区域+2信仰；建筑可用信仰购买
-- 移除信仰镜像，改为学院+2信仰
-----------------------------------------------

-- 删除旧的 TraitModifiers
DELETE FROM TraitModifiers
WHERE TraitType = 'MINOR_CIV_CSE_VALABHI_TRAIT';

-- 删除旧的 Modifiers
DELETE FROM Modifiers
WHERE ModifierId LIKE 'CSE_VALABHI_%';

-- 删除旧的 ModifierArguments
DELETE FROM ModifierArguments
WHERE ModifierId LIKE 'CSE_VALABHI_%';

-- 插入新的 TraitModifiers
INSERT INTO TraitModifiers
		(TraitType,						ModifierId								)
VALUES	('MINOR_CIV_CSE_VALABHI_TRAIT',	'CSE_VALABHI_SUZERAIN_FAITH_PURCHASE'	),
		('MINOR_CIV_CSE_VALABHI_TRAIT',	'CSE_VALABHI_SUZERAIN_CAMPUS_FAITH'		);

-- 插入新的 Modifiers
INSERT INTO Modifiers
		(ModifierId,							ModifierType,											SubjectRequirementSetId	)
VALUES	('CSE_VALABHI_SUZERAIN_FAITH_PURCHASE',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'	),
		('CSE_VALABHI_SUZERAIN_CAMPUS_FAITH',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',					'PLAYER_IS_SUZERAIN'	),
		('CSE_VALABHI_FAITH_PURCHASE',			'MODIFIER_PLAYER_CITIES_ENABLE_BUILDING_FAITH_PURCHASE',	NULL					),
		('CSE_VALABHI_CAMPUS_FAITH',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',		'DISTRICT_IS_CAMPUS'	);

-- 插入新的 ModifierArguments
INSERT INTO ModifierArguments
		(ModifierId,							Name,			Value							)
VALUES	('CSE_VALABHI_SUZERAIN_FAITH_PURCHASE',	'ModifierId',	'CSE_VALABHI_FAITH_PURCHASE'	),
		('CSE_VALABHI_SUZERAIN_CAMPUS_FAITH',	'ModifierId',	'CSE_VALABHI_CAMPUS_FAITH'		),
		('CSE_VALABHI_FAITH_PURCHASE',			'DistrictType',	'DISTRICT_CAMPUS'				),
		('CSE_VALABHI_CAMPUS_FAITH',			'YieldType',	'YIELD_FAITH'					),
		('CSE_VALABHI_CAMPUS_FAITH',			'Amount',		2								);

-----------------------------------------------
-- 贡德沙普尔 CSE_GUNDESHAPUR (XP2): 新时代获1免费尤里卡 (原2个)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 1
WHERE ModifierId = 'CSE_GUNDESHAPUR_ERA_EUREKA'
AND Name = 'Amount';

-----------------------------------------------
-- 加赖马 CSE_GARAMA (Base): 绿洲及其两格内+1食物
-- 原有三个范围叠加导致 range1 地块获得+2食物，重构为单范围覆盖
-----------------------------------------------

-- 删除旧的 TraitModifiers
DELETE FROM TraitModifiers
WHERE TraitType = 'MINOR_CIV_CSE_GARAMA_TRAIT';

-- 删除旧的 Modifiers
DELETE FROM Modifiers
WHERE ModifierId LIKE 'CSE_GARAMA_%';

-- 删除旧的 ModifierArguments
DELETE FROM ModifierArguments
WHERE ModifierId LIKE 'CSE_GARAMA_%';

-- 删除旧的 RequirementSets
DELETE FROM RequirementSets
WHERE RequirementSetId LIKE 'REQSET_CSE_GARAMA_%';

-- 删除旧的 RequirementSetRequirements
DELETE FROM RequirementSetRequirements
WHERE RequirementSetId LIKE 'REQSET_CSE_GARAMA_%';

-- 删除旧的 Requirements
DELETE FROM Requirements
WHERE RequirementId LIKE 'REQ_CSE_GARAMA_%';

-- 删除旧的 RequirementArguments
DELETE FROM RequirementArguments
WHERE RequirementId LIKE 'REQ_CSE_GARAMA_%';

-- 插入新的 TraitModifiers (单范围 0-2)
INSERT INTO TraitModifiers
		(TraitType,						ModifierId								)
VALUES	('MINOR_CIV_CSE_GARAMA_TRAIT',	'CSE_GARAMA_SUZERAIN_OASIS_FOOD'		);

-- 插入新的 Modifiers
INSERT INTO Modifiers
		(ModifierId,						ModifierType,							SubjectRequirementSetId				)
VALUES	('CSE_GARAMA_SUZERAIN_OASIS_FOOD',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',	'PLAYER_IS_SUZERAIN'				),
		('CSE_GARAMA_OASIS_FOOD',			'MODIFIER_PLAYER_ADJUST_PLOT_YIELD',	'REQSET_CSE_GARAMA_OASIS_WITHIN_2'	);

-- 插入新的 ModifierArguments
INSERT INTO ModifierArguments
		(ModifierId,						Name,			Value						)
VALUES	('CSE_GARAMA_SUZERAIN_OASIS_FOOD',	'ModifierId',	'CSE_GARAMA_OASIS_FOOD'		),
		('CSE_GARAMA_OASIS_FOOD',			'YieldType',	'YIELD_FOOD'				),
		('CSE_GARAMA_OASIS_FOOD',			'Amount',		1							);

-- 插入新的 RequirementSets
INSERT INTO RequirementSets
		(RequirementSetId,						RequirementSetType			)
VALUES	('REQSET_CSE_GARAMA_OASIS_WITHIN_2',	'REQUIREMENTSET_TEST_ALL'	);

-- 插入新的 RequirementSetRequirements
INSERT INTO RequirementSetRequirements
		(RequirementSetId,						RequirementId					)
VALUES	('REQSET_CSE_GARAMA_OASIS_WITHIN_2',	'REQ_CSE_GARAMA_OASIS_WITHIN_2'	);

-- 插入新的 Requirements
INSERT INTO Requirements
		(RequirementId,						RequirementType,									Inverse	)
VALUES	('REQ_CSE_GARAMA_OASIS_WITHIN_2',	'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES',	0		);

-- 插入新的 RequirementArguments (MinRange=0, MaxRange=2 覆盖绿洲本身及两格范围)
INSERT INTO RequirementArguments
		(RequirementId,						Name,			Value			)
VALUES	('REQ_CSE_GARAMA_OASIS_WITHIN_2',	'FeatureType',	'FEATURE_OASIS'	),
		('REQ_CSE_GARAMA_OASIS_WITHIN_2',	'MinRange',		0				),
		('REQ_CSE_GARAMA_OASIS_WITHIN_2',	'MaxRange',		2				);

-----------------------------------------------
-- 塔那那利佛 ANTANANARIVO (原版DLC): 每获得1位伟人+1%文化值，最多+30% (原+2%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 1
WHERE ModifierId = 'MINOR_CIV_ANTANANARIVO_CULTURE_FROM_EARNED_GREAT_PEOPLE_BONUS'
AND Name = 'Amount';

-----------------------------------------------
-- 丹吉尔 CSE_TANGIER (XP2): 新时代获1免费灵感 (原2个)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 1
WHERE ModifierId = 'CSE_TANGIER_ERA_INSPIRATION'
AND Name = 'Amount';

-----------------------------------------------
-- 多多纳 CSE_DODONA (XP1): 黄金时代灵感额外+5%市政 (原+10%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 5
WHERE ModifierId = 'CSE_DODONA_CIVIC_BOOST'
AND Name = 'Amount';

-----------------------------------------------
-- 沙赫尔苏赫特 CSE_SHAHR_E_SUKHTE (Base): 不处于战争状态时+10%文化 (原+15%)
-----------------------------------------------
UPDATE ModifierArguments
SET Value = 10
WHERE ModifierId = 'CSE_SHAHR_E_SUKHTE_CULTURE_PEACE'
AND Name = 'Amount';

-----------------------------------------------
-- 室利差呾罗 CSE_SRI_KSETRA (Base): 圣地区域+3食物 (原信仰镜像)
-----------------------------------------------

-- 删除旧的 TraitModifiers
DELETE FROM TraitModifiers
WHERE TraitType = 'MINOR_CIV_CSE_SRI_KSETRA_TRAIT';

-- 删除旧的 Modifiers
DELETE FROM Modifiers
WHERE ModifierId LIKE 'CSE_SRI_KSETRA_%';

-- 删除旧的 ModifierArguments
DELETE FROM ModifierArguments
WHERE ModifierId LIKE 'CSE_SRI_KSETRA_%';

-- 插入新的 TraitModifiers
INSERT INTO TraitModifiers
		(TraitType,							ModifierId									)
VALUES	('MINOR_CIV_CSE_SRI_KSETRA_TRAIT',	'CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD'	);

-- 插入新的 Modifiers
INSERT INTO Modifiers
		(ModifierId,								ModifierType,									SubjectRequirementSetId		)
VALUES	('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',			'PLAYER_IS_SUZERAIN'		),
		('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE',	'DISTRICT_IS_HOLY_SITE'		);

-- 插入新的 ModifierArguments
INSERT INTO ModifierArguments
		(ModifierId,								Name,			Value							)
VALUES	('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD',	'ModifierId',	'CSE_SRI_KSETRA_HOLY_SITE_FOOD'	),
		('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'YieldType',	'YIELD_FOOD'					),
		('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'Amount',		3								);