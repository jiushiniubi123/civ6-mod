-- ============================================================
-- Wonders Tweak MOD — WondersTweak_Data.sql
-- 7个奇观平衡修改，严格按 删除/修改/新增 操作
-- 依赖: Gathering Storm (风云变幻)
-- ============================================================

-- ============================================================
-- ╔══════════════════════════════════════════════════════════╗
-- ║               删  除  操  作  (DELETE)                  ║
-- ╚══════════════════════════════════════════════════════════╝
-- ============================================================

-- 【3.大本钟】删除: 前置建筑要求（银行前置）
DELETE FROM BuildingPrereqs WHERE Building = 'BUILDING_BIG_BEN';
UPDATE Buildings SET AdjacentDistrict = NULL WHERE BuildingType = 'BUILDING_BIG_BEN';

-- 【3.大本钟】删除: 建成时金币翻倍效果
UPDATE ModifierArguments SET Value = '0' WHERE ModifierId = 'BIG_BEN_INCREASE_GOLD' AND Name = 'Amount';

-- 【4.罗马斗兽场】删除: 紧邻娱乐中心区要求
UPDATE Buildings SET AdjacentDistrict = NULL WHERE BuildingType = 'BUILDING_COLOSSEUM';
DELETE FROM BuildingPrereqs WHERE Building = 'BUILDING_COLOSSEUM';

-- 【5.马丘比丘】删除: 原有山脉地形限制
DELETE FROM Building_ValidTerrains WHERE BuildingType = 'BUILDING_MACHU_PICCHU';

-- ============================================================
-- ╔══════════════════════════════════════════════════════════╗
-- ║               修  改  操  作  (MODIFY)                  ║
-- ╚══════════════════════════════════════════════════════════╝
-- ============================================================

-- 【1.空中花园】修改: 住房3 + 宜居度2
UPDATE Buildings SET Housing = 3, Entertainment = 2 WHERE BuildingType = 'BUILDING_HANGING_GARDENS';

-- 【2.巨石阵】修改: +4信仰（原+2 -> 改为+4）
UPDATE Building_YieldChanges SET YieldChange = 4 WHERE BuildingType = 'BUILDING_STONEHENGE' AND YieldType = 'YIELD_FAITH';

-- 【5.马丘比丘】修改: 建筑条件改为临近市中心的丘陵
INSERT OR IGNORE INTO Building_ValidTerrains (BuildingType, TerrainType)
VALUES ('BUILDING_MACHU_PICCHU', 'TERRAIN_GRASS_HILLS'),
       ('BUILDING_MACHU_PICCHU', 'TERRAIN_PLAINS_HILLS'),
       ('BUILDING_MACHU_PICCHU', 'TERRAIN_DESERT_HILLS'),
       ('BUILDING_MACHU_PICCHU', 'TERRAIN_TUNDRA_HILLS'),
       ('BUILDING_MACHU_PICCHU', 'TERRAIN_SNOW_HILLS');
UPDATE Buildings SET AdjacentDistrict = 'DISTRICT_CITY_CENTER' WHERE BuildingType = 'BUILDING_MACHU_PICCHU';

-- 【6.基尔瓦基斯瓦尼】修改: 两个级别的增幅统一为10%
UPDATE ModifierArguments SET Value = '10'
WHERE ModifierId IN (
    'KILWA_SINGLE_ADDSCIENCEYIELD', 'KILWA_SINGLE_ADDFAITHYIELD',
    'KILWA_SINGLE_ADDGOLDYIELD', 'KILWA_SINGLE_ADDCULTUREYIELD',
    'KILWA_SINGLE_ADDPRODUCTIONUNITS', 'KILWA_SINGLE_ADDPRODUCTIONBUILDINGS',
    'KILWA_SINGLE_ADDPRODUCTIONDISTRICTS',
    'KILWA_PLAYERCITIES_ADDSCIENCEYIELD', 'KILWA_PLAYERCITIES_ADDFAITHYIELD',
    'KILWA_PLAYERCITIES_ADDGOLDYIELD', 'KILWA_PLAYERCITIES_ADDCULTUREYIELD',
    'KILWA_PLAYERCITIES_ADDPRODUCTIONUNITS', 'KILWA_PLAYERCITIES_ADDPRODUCTIONBUILDINGS',
    'KILWA_PLAYERCITIES_ADDPRODUCTIONDISTRICTS'
) AND Name = 'Amount';

-- ============================================================
-- ╔══════════════════════════════════════════════════════════╗
-- ║               新  增  操  作  (ADD)                     ║
-- ╚══════════════════════════════════════════════════════════╝
-- ============================================================

-- 【3.大本钟】新增: 该城市金币+20%
INSERT OR IGNORE INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_BIG_BEN', 'WT_BIG_BEN_GOLD_PCT');

INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType)
VALUES ('WT_BIG_BEN_GOLD_PCT', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');

INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
VALUES ('WT_BIG_BEN_GOLD_PCT', 'YieldType', 'YIELD_GOLD'),
       ('WT_BIG_BEN_GOLD_PCT', 'Amount', 20);