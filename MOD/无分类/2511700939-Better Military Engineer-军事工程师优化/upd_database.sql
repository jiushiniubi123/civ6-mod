-- by DeepLogic

update Units set BuildCharges = 3, BaseMoves = 3 where UnitType = 'UNIT_MILITARY_ENGINEER';

-- UNIT_MILITARY_ENGINEER
update Routes_XP2 set BuildWithUnitChargeCost = 0;
insert or replace into Route_ResourceCosts
    (RouteType,                 ResourceType,       BuildWithUnitCost)
values
    ('ROUTE_ANCIENT_ROAD',      'RESOURCE_HORSES',  1),
    ('ROUTE_MEDIEVAL_ROAD',     'RESOURCE_HORSES',  1),
    ('ROUTE_INDUSTRIAL_ROAD',   'RESOURCE_IRON',    1),
    ('ROUTE_MODERN_ROAD',       'RESOURCE_IRON',    1);

-- Enable Roman Legion to build routes.
-- insert or replace into Route_ValidBuildUnits
--     (RouteType,                 UnitType)
-- values
--     ('ROUTE_ANCIENT_ROAD',      'UNIT_ROMAN_LEGION'),
--     ('ROUTE_MEDIEVAL_ROAD',     'UNIT_ROMAN_LEGION');

-- 
insert or replace into Tags
    (Tag,                       Vocabulary)
values
    ('CLASS_MILITARY_ENGINEER', 'ABILITY_CLASS');

insert or replace into Types
    (Type,                                                          Kind)
values
    ('ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER',         'KIND_ABILITY');

insert or replace into TypeTags
    (Type,                                                          Tag)
values
    ('UNIT_MILITARY_ENGINEER',                                      'CLASS_MILITARY_ENGINEER'),
    ('ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER',         'CLASS_MILITARY_ENGINEER');

insert or replace into UnitAbilities (UnitAbilityType, Name, Description, Inactive) values
    ('ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER',
    'LOC_ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER_NAME',
    'LOC_ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER_DESCRIPTION',
    0);

insert or replace into UnitAbilityModifiers
    (UnitAbilityType,                                               ModifierId)
values
    ('ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER',         'MOD_IGNORE_TERRAIN_COST'),
    ('ABILITY_MILLITARY_ENGINEER_IGNORE_TERRAIN_AND_RIVER',         'MOD_IGNORE_CROSSING_RIVERS_COST');

-- 插入区域建造进度加成数据
INSERT OR REPLACE INTO District_BuildChargeProductions
    (DistrictType, UnitType, PercentProductionPerCharge)
VALUES
    ('DISTRICT_HOLY_SITE', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_CAMPUS', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_ENCAMPMENT', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_COMMERCIAL_HUB', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_ENTERTAINMENT_COMPLEX', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_THEATER', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_INDUSTRIAL_ZONE', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_HARBOR', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_WATER_ENTERTAINMENT_COMPLEX', 'UNIT_MILITARY_ENGINEER', 20),
    ('DISTRICT_LAVRA', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_ROYAL_NAVY_DOCKYARD', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_ACROPOLIS', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_HANSA', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_SEOWON', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_SUGUBA', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_OPPIDUM', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_COTHON', 'UNIT_MILITARY_ENGINEER', 25), 
    ('DISTRICT_OBSERVATORY', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_IKANDA', 'UNIT_MILITARY_ENGINEER', 25),
    ('DISTRICT_HIPPODROME', 'UNIT_MILITARY_ENGINEER', 25), 
    ('DISTRICT_THANH', 'UNIT_MILITARY_ENGINEER', 25);


-- 更新特定区域的建造进度加成
UPDATE District_BuildChargeProductions
SET PercentProductionPerCharge = 25
WHERE DistrictType = 'DISTRICT_CANAL' AND UnitType = 'UNIT_MILITARY_ENGINEER';

UPDATE District_BuildChargeProductions
SET PercentProductionPerCharge = 25
WHERE DistrictType = 'DISTRICT_AQUEDUCT' AND UnitType = 'UNIT_MILITARY_ENGINEER';

UPDATE District_BuildChargeProductions
SET PercentProductionPerCharge = 35
WHERE DistrictType = 'DISTRICT_BATH' AND UnitType = 'UNIT_MILITARY_ENGINEER';

UPDATE District_BuildChargeProductions
SET PercentProductionPerCharge = 25
WHERE DistrictType = 'DISTRICT_DAM' AND UnitType = 'UNIT_MILITARY_ENGINEER';

-- 更新建筑的建造进度加成
UPDATE Building_BuildChargeProductions
SET PercentProductionPerCharge = 25
WHERE BuildingType = 'BUILDING_FLOOD_BARRIER' AND UnitType = 'UNIT_MILITARY_ENGINEER';
