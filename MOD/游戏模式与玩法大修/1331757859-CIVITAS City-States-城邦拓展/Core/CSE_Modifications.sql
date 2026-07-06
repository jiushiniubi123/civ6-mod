/*
	CSE_Modifications
	Modifications to existing city-states' suzerain bonuses.
	Loads after all city-state definition files (LoadOrder > 67).
*/

-- ============================================================================
-- GENEVA (原版) - 未与任何主要文明交战时+10%科技值
-- 原版: +15% Science when not at war → 改为+10%
-- ============================================================================
UPDATE ModifierArguments 
SET Value = '10'
WHERE ModifierId IN (
    SELECT ModifierId FROM TraitModifiers WHERE TraitType = 'MINOR_CIV_GENEVA_TRAIT'
) AND Name = 'Amount';

-- ============================================================================
-- ANTANANARIVO (原版 DLC2) - 每获得1位伟人+1%文化值，最多+30%
-- 原版: +2% Culture per Great Person → 改为+1%
-- ============================================================================
UPDATE ModifierArguments 
SET Value = '1'
WHERE ModifierId IN (
    SELECT ModifierId FROM TraitModifiers WHERE TraitType = 'MINOR_CIV_ANTANANARIVO_TRAIT'
) AND Name = 'Amount';

-- ============================================================================
-- CSE_IZAPA (XP1) - 黄金时代尤里卡额外+5%科技；黑暗时代额外+时代分
-- 原mod: +10% tech boost → 改为+5%
-- ============================================================================
UPDATE ModifierArguments SET Value = '5' WHERE ModifierId = 'CSE_IZAPA_TECH_BOOST' AND Name = 'Amount';

-- ============================================================================
-- CSE_DODONA (XP1) - 黄金时代灵感额外+5%市政；黑暗时代额外+时代分
-- 原mod: +10% civic boost → 改为+5%
-- ============================================================================
UPDATE ModifierArguments SET Value = '5' WHERE ModifierId = 'CSE_DODONA_CIVIC_BOOST' AND Name = 'Amount';

-- ============================================================================
-- CSE_SAMARQAND (Base) - 每个已获得伟人+1%科学，最多+30%
-- 原mod: +2% per Great Person → 改为+1%
-- ============================================================================
UPDATE ModifierArguments SET Value = '1' WHERE ModifierId = 'CSE_SAMARQAND_GP_SCIENCE' AND Name = 'Amount';

-- ============================================================================
-- CSE_SHAHR_E_SUKHTE (Base) - 不处于战争状态时+10%文化
-- 原mod: +15% Culture → 改为+10%
-- ============================================================================
UPDATE ModifierArguments SET Value = '10' WHERE ModifierId = 'CSE_SHAHR_E_SUKHTE_CULTURE_PEACE' AND Name = 'Amount';

-- ============================================================================
-- CSE_GUNDESHAPUR (XP2) - 新时代获1免费尤里卡；学院区每相邻2区域+1科学
-- 原mod: 2 free Eurekas → 改为1
-- 学院区每相邻2区域+1科学保持不变
-- ============================================================================
UPDATE ModifierArguments SET Value = '1' WHERE ModifierId = 'CSE_GUNDESHAPUR_ERA_EUREKA' AND Name = 'Amount';

-- ============================================================================
-- CSE_TANGIER (XP2) - 新时代获1免费灵感；剧院区每相邻2区域+1文化
-- 原mod: 2 free Inspirations → 改为1
-- 剧院区每相邻2区域+1文化保持不变
-- ============================================================================
UPDATE ModifierArguments SET Value = '1' WHERE ModifierId = 'CSE_TANGIER_ERA_INSPIRATION' AND Name = 'Amount';

-- ============================================================================
-- CSE_GARAMA (Base) - 绿洲及相邻+1食物；两格远+1食物
-- 原mod: +2 Food on Oasis（绿洲上）→ 改为+1，使绿洲本身、相邻、两格远均为+1
-- ============================================================================
UPDATE ModifierArguments SET Value = '1' WHERE ModifierId = 'CSE_GARAMA_OASIS_FOOD_ON' AND Name = 'Amount';

-- ============================================================================
-- CSE_LIMA (Base) - 学院和学院里的建筑建造速度+20%，学院区域+3生产力
-- 移除额外区域效果，保留学院区域建造加成，添加建筑建造加成和学院区生产力
-- ============================================================================
-- 移除旧的额外区域 modifier 及其依赖
DELETE FROM RequirementSetRequirements WHERE RequirementSetId = 'REQSET_CSE_LIMA_HAS_CAMPUS';
DELETE FROM RequirementSets WHERE RequirementSetId = 'REQSET_CSE_LIMA_HAS_CAMPUS';
DELETE FROM ModifierArguments WHERE ModifierId IN ('CSE_LIMA_SUZERAIN_EXTRA_DISTRICT', 'CSE_LIMA_EXTRA_DISTRICT');
DELETE FROM Modifiers WHERE ModifierId IN ('CSE_LIMA_SUZERAIN_EXTRA_DISTRICT', 'CSE_LIMA_EXTRA_DISTRICT');
DELETE FROM TraitModifiers WHERE ModifierId = 'CSE_LIMA_SUZERAIN_EXTRA_DISTRICT';

-- 添加学院建筑建造加成（图书馆、大学、实验室各+20%生产力）
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
('MINOR_CIV_CSE_LIMA_TRAIT', 'CSE_LIMA_SUZERAIN_LIBRARY_PRODUCTION'),
('MINOR_CIV_CSE_LIMA_TRAIT', 'CSE_LIMA_SUZERAIN_UNIVERSITY_PRODUCTION'),
('MINOR_CIV_CSE_LIMA_TRAIT', 'CSE_LIMA_SUZERAIN_LAB_PRODUCTION'),
('MINOR_CIV_CSE_LIMA_TRAIT', 'CSE_LIMA_SUZERAIN_CAMPUS_YIELD');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
('CSE_LIMA_SUZERAIN_LIBRARY_PRODUCTION',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_LIMA_SUZERAIN_UNIVERSITY_PRODUCTION',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_LIMA_SUZERAIN_LAB_PRODUCTION',		'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_LIMA_SUZERAIN_CAMPUS_YIELD',			'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_LIMA_LIBRARY_PRODUCTION',				'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION',	NULL),
('CSE_LIMA_UNIVERSITY_PRODUCTION',			'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION',	NULL),
('CSE_LIMA_LAB_PRODUCTION',					'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION',	NULL),
('CSE_LIMA_CAMPUS_YIELD',					'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_YIELD',			NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
('CSE_LIMA_SUZERAIN_LIBRARY_PRODUCTION',	'ModifierId',	'CSE_LIMA_LIBRARY_PRODUCTION'),
('CSE_LIMA_SUZERAIN_UNIVERSITY_PRODUCTION',	'ModifierId',	'CSE_LIMA_UNIVERSITY_PRODUCTION'),
('CSE_LIMA_SUZERAIN_LAB_PRODUCTION',		'ModifierId',	'CSE_LIMA_LAB_PRODUCTION'),
('CSE_LIMA_SUZERAIN_CAMPUS_YIELD',			'ModifierId',	'CSE_LIMA_CAMPUS_YIELD'),
('CSE_LIMA_LIBRARY_PRODUCTION',				'BuildingType',	'BUILDING_LIBRARY'),
('CSE_LIMA_LIBRARY_PRODUCTION',				'Amount',		20),
('CSE_LIMA_UNIVERSITY_PRODUCTION',			'BuildingType',	'BUILDING_UNIVERSITY'),
('CSE_LIMA_UNIVERSITY_PRODUCTION',			'Amount',		20),
('CSE_LIMA_LAB_PRODUCTION',					'BuildingType',	'BUILDING_RESEARCH_LAB'),
('CSE_LIMA_LAB_PRODUCTION',					'Amount',		20),
('CSE_LIMA_CAMPUS_YIELD',					'DistrictType',	'DISTRICT_CAMPUS'),
('CSE_LIMA_CAMPUS_YIELD',					'YieldType',	'YIELD_PRODUCTION'),
('CSE_LIMA_CAMPUS_YIELD',					'Amount',		3);

-- ============================================================================
-- CSE_VALABHI (Base) - 学院区域+2信仰；建筑可用信仰购买
-- 原mod: Faith = Campus adjacency → 改为 Campus +2 Faith flat
-- 保留信仰购买建筑的 modifier
-- ============================================================================
-- 移除旧的 faith mirror modifier
DELETE FROM ModifierArguments WHERE ModifierId IN ('CSE_VALABHI_SUZERAIN_FAITH_MIRROR', 'CSE_VALABHI_FAITH_MIRROR');
DELETE FROM Modifiers WHERE ModifierId IN ('CSE_VALABHI_SUZERAIN_FAITH_MIRROR', 'CSE_VALABHI_FAITH_MIRROR');
DELETE FROM TraitModifiers WHERE ModifierId = 'CSE_VALABHI_SUZERAIN_FAITH_MIRROR';

-- 添加新的学院+2信仰 modifier
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
('MINOR_CIV_CSE_VALABHI_TRAIT', 'CSE_VALABHI_SUZERAIN_CAMPUS_FAITH');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
('CSE_VALABHI_SUZERAIN_CAMPUS_FAITH',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_VALABHI_CAMPUS_FAITH',			'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_YIELD',	NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
('CSE_VALABHI_SUZERAIN_CAMPUS_FAITH',	'ModifierId',	'CSE_VALABHI_CAMPUS_FAITH'),
('CSE_VALABHI_CAMPUS_FAITH',			'DistrictType',	'DISTRICT_CAMPUS'),
('CSE_VALABHI_CAMPUS_FAITH',			'YieldType',	'YIELD_FAITH'),
('CSE_VALABHI_CAMPUS_FAITH',			'Amount',		2);

-- ============================================================================
-- CSE_SRI_KSETRA (Base) - AGRICULTURAL→RELIGIOUS 圣地区域+3食物
-- 类型从 CSE_AGRICULTURAL 改为 RELIGIOUS
-- 原mod: Holy Site Food = Faith adjacency → 改为 Holy Site +3 Food flat
-- ============================================================================
-- 更新 CSE_Master 中的类型
UPDATE CSE_Master 
SET ProposedType = 'RELIGIOUS' 
WHERE CityState = 'CSE_SRI_KSETRA';

-- 更新 CityStates 中的类型（FrontEnd 已运行，需在 InGame 更新）
UPDATE CityStates 
SET CityStateCategory = 'RELIGIOUS' 
WHERE CivilizationType = 'CIVILIZATION_CSE_SRI_KSETRA';

-- 移除旧的 food adjacency modifier
DELETE FROM ModifierArguments WHERE ModifierId IN ('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD', 'CSE_SRI_KSETRA_HOLY_SITE_FOOD');
DELETE FROM Modifiers WHERE ModifierId IN ('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD', 'CSE_SRI_KSETRA_HOLY_SITE_FOOD');
DELETE FROM TraitModifiers WHERE ModifierId = 'CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD';

-- 添加新的 Holy Site +3 Food modifier
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
('MINOR_CIV_CSE_SRI_KSETRA_TRAIT', 'CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD',	'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER',		'PLAYER_IS_SUZERAIN'),
('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_YIELD',	NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
('CSE_SRI_KSETRA_SUZERAIN_HOLY_SITE_FOOD',	'ModifierId',	'CSE_SRI_KSETRA_HOLY_SITE_FOOD'),
('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'DistrictType',	'DISTRICT_HOLY_SITE'),
('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'YieldType',	'YIELD_FOOD'),
('CSE_SRI_KSETRA_HOLY_SITE_FOOD',			'Amount',		3);