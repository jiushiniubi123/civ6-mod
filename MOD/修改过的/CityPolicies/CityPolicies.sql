-------------------------------------
--   Introduce city-level policy   --
-------------------------------------

-- Modifier
insert or replace into Types
	(Type,										Kind)
values
	('GRANT_BUILDING_TO_ALL_CITIES_IGNORE',		'KIND_MODIFIER');

insert or replace into DynamicModifiers
	(ModifierType,							CollectionType,				EffectType)
values
	('GRANT_BUILDING_TO_ALL_CITIES_IGNORE', 'COLLECTION_PLAYER_CITIES', 'EFFECT_GRANT_BUILDING_IN_CITY_IGNORE');
-------------------------------------

-- grant basic building to enable city policies
insert or replace into TraitModifiers
	(TraitType,					ModifierId)
values
	('TRAIT_LEADER_MAJOR_CIV',	'TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER'),
	('MINOR_CIV_DEFAULT_TRAIT',	'TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER');

insert or replace into Modifiers
	(ModifierId,								ModifierType)
values
	('TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER', 'GRANT_BUILDING_TO_ALL_CITIES_IGNORE');

insert or replace into ModifierArguments
	(ModifierId,								Name,			Value)
values
	('TRAIT_GRANT_EMPTY_CITY_POLICY_MODIFIER', 'BuildingType', 'BUILDING_CITY_POLICY_EMPTY');

-- 
create table 'CityPolicyMaster'(
	'CityPolicy' TEXT NOT NULL,
	'BuildingType' TEXT,
	'EnableProjectType' TEXT,
	'DisableProjectType' TEXT,
	'EnableCivicType' TEXT,
	'EnableTechType' TEXT,
	'EnableCost' INT NOT NULL,
	'DisableCost' INT NOT NULL,
	PRIMARY KEY('CityPolicy')
);

------【此处需要手动修改】------
insert or replace into CityPolicyMaster
	(CityPolicy,			EnableCost,	DisableCost)
values
	('EMPTY',				0,			0),
	('LABOR',				3,			3),
	('REVISION_ALMANAC',	3,			3),
	('AGRICULTURAL_TAX',	3,			3),
	('INDUSTRAIL_TAX',		3,			3),
	('FREIGHT',				3,			3),
	('FORGING_IRON',		3,			3);
insert or replace into CityPolicyMaster
	(CityPolicy,			EnableCost,	DisableCost)
select
	'DIPLOMATIC_MEETING',	10,			10
where exists (select BuildingType from Buildings where BuildingType = 'BUILDING_CONSULATE');

------【结束】------

update CityPolicyMaster set
	BuildingType 			= 'BUILDING_CITY_POLICY_' || CityPolicy,
	EnableProjectType 		= 'PROJECT_CITY_POLICY_ENABLE_' || CityPolicy,
	DisableProjectType 		= 'PROJECT_CITY_POLICY_DISABLE_' || CityPolicy;

insert or replace into Types (Type, Kind) select BuildingType, 'KIND_BUILDING' from CityPolicyMaster;
insert or replace into Types (Type, Kind) select EnableProjectType, 'KIND_PROJECT' from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Types (Type, Kind) select DisableProjectType, 'KIND_PROJECT' from CityPolicyMaster where CityPolicy != 'EMPTY';

-- Use buildings as city policies, use projects to turn on and turn off the city policies.
insert or replace into Buildings (BuildingType,	Name,	Cost,	Description)
select BuildingType, 'LOC_'||BuildingType||'_NAME',		1, 		'LOC_'||BuildingType||'_DESCRIPTION'
from CityPolicyMaster;

insert or replace into Buildings_XP2 (BuildingType, Pillage)
select BuildingType, 0 from CityPolicyMaster;

-- Building effect
insert or replace into BuildingModifiers 
	(BuildingType,								ModifierId)
values 
	('BUILDING_CITY_POLICY_AGRICULTURAL_TAX',	'CITY_POLICY_AGRICULTURAL_TAX_FARM_GOLD_MODIFIER'),
	('BUILDING_CITY_POLICY_AGRICULTURAL_TAX',	'CITY_POLICY_AGRICULTURAL_TAX_FARM_FOOD_MODIFIER'),
	('BUILDING_CITY_POLICY_INDUSTRAIL_TAX',		'CITY_POLICY_INDUSTRAIL_TAX_QUARRY_GOLD_MODIFIER'),
	('BUILDING_CITY_POLICY_INDUSTRAIL_TAX',		'CITY_POLICY_INDUSTRAIL_TAX_MINE_GOLD_MODIFIER'),
	('BUILDING_CITY_POLICY_INDUSTRAIL_TAX',		'CITY_POLICY_INDUSTRAIL_TAX_QUARRY_PRODUCTION_MODIFIER'),
	('BUILDING_CITY_POLICY_INDUSTRAIL_TAX',		'CITY_POLICY_INDUSTRAIL_TAX_MINE_PRODUCTION_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',				'CITY_POLICY_LABOR_POP_FOOD_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',				'CITY_POLICY_LABOR_POP_PROD_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',				'CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER'),
	('BUILDING_CITY_POLICY_LABOR',				'CITY_POLICY_LABOR_CITY_AMENITIES'),
	('BUILDING_CITY_POLICY_REVISION_ALMANAC',	'CITY_POLICY_REVISION_ALMANAC_HOUSING'),
	('BUILDING_CITY_POLICY_REVISION_ALMANAC',	'CITY_POLICY_REVISION_ALMANAC_AMENITY'),
	('BUILDING_CITY_POLICY_REVISION_ALMANAC',	'CITY_POLICY_REVISION_ALMANAC_MOUNTAIN_AMENITY');

-- Modifiers
-- insert or replace into Modifiers
-- 	(ModifierId,													ModifierType,											Permanent)
-- values
-- 	('CITY_POLICY_DACAOGU_CITY_TRAINED_CAVALRY_PILLAGE_LESS_MOVEMENT','MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',1),
-- 	('CITY_POLICY_DACAOGU_CITY_TRAINED_CAVALRY_EXTRA_PILLAGE_YIELD','MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS',	1);

insert or replace into Modifiers
	(ModifierId,														ModifierType)
values
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',								'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION'),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',								'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION'),
	('CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER',							'MODIFIER_SINGLE_CITY_ADJUST_CITY_GROWTH'),
	('CITY_POLICY_LABOR_CITY_AMENITIES',								'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT');

-- The REQs might needed when standalone.
insert or replace into Modifiers
	(ModifierId,														ModifierType,												SubjectRequirementSetId)
values
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_GOLD_MODIFIER',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'REQUIREMENTS_PLOT_HAS_FARM'),	
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_FOOD_MODIFIER',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'REQUIREMENTS_PLOT_HAS_FARM'),	
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_GOLD_MODIFIER',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'PLOT_HAS_QUARRY_REQUIREMENTS'),	
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_GOLD_MODIFIER',					'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'PLOT_HAS_MINE_REQUIREMENTS'),	
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_PRODUCTION_MODIFIER',			'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'PLOT_HAS_QUARRY_REQUIREMENTS'),
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_PRODUCTION_MODIFIER',				'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',				'PLOT_HAS_MINE_REQUIREMENTS'),
	('CITY_POLICY_REVISION_ALMANAC_HOUSING',							'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING',				NULL),
	('CITY_POLICY_REVISION_ALMANAC_AMENITY',							'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',				NULL),
	('CITY_POLICY_REVISION_ALMANAC_MOUNTAIN_AMENITY',					'MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT',				'CP_REVISION_ALMANAC_MOUNTAIN_REQSET');

insert or replace into RequirementSets (RequirementSetId, RequirementSetType)
values ('CP_REVISION_ALMANAC_MOUNTAIN_REQSET', 'REQUIREMENTSET_TEST_ALL');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId)
values ('CP_REVISION_ALMANAC_MOUNTAIN_REQSET', 'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN');

insert or replace into ModifierArguments
	(ModifierId,															Name,			Value)
values
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_GOLD_MODIFIER',						'YieldType',	'YIELD_GOLD'),
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_GOLD_MODIFIER',						'Amount',		2),
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_FOOD_MODIFIER',						'YieldType',	'YIELD_FOOD'),
	('CITY_POLICY_AGRICULTURAL_TAX_FARM_FOOD_MODIFIER',						'Amount',		-1),
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_GOLD_MODIFIER',						'YieldType',	'YIELD_GOLD'),
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_GOLD_MODIFIER',						'Amount',		2),
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_GOLD_MODIFIER',						'YieldType',	'YIELD_GOLD'),
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_GOLD_MODIFIER',						'Amount',		2),
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_PRODUCTION_MODIFIER',				'YieldType',	'YIELD_PRODUCTION'),
	('CITY_POLICY_INDUSTRAIL_TAX_QUARRY_PRODUCTION_MODIFIER',				'Amount',		-1),
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_PRODUCTION_MODIFIER',					'YieldType',	'YIELD_PRODUCTION'),
	('CITY_POLICY_INDUSTRAIL_TAX_MINE_PRODUCTION_MODIFIER',					'Amount',		-1),
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',									'YieldType',	'YIELD_FOOD'),
	('CITY_POLICY_LABOR_POP_FOOD_MODIFIER',									'Amount',		-1),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',									'YieldType',	'YIELD_PRODUCTION'),
	('CITY_POLICY_LABOR_POP_PROD_MODIFIER',									'Amount',		1.5),
	('CITY_POLICY_LABOR_CITY_GROWTH_MODIFIER',								'Amount',		-75),
	('CITY_POLICY_LABOR_CITY_AMENITIES',									'Amount',		-1),
	('CITY_POLICY_REVISION_ALMANAC_HOUSING',								'Amount',		1),
	('CITY_POLICY_REVISION_ALMANAC_AMENITY',							'Amount',		-1),
	('CITY_POLICY_REVISION_ALMANAC_MOUNTAIN_AMENITY',					'Amount',		1);

------【结束】------

-- Enable Projects
insert or replace into Projects
	(ProjectType, Name, ShortName, Description, Cost, PrereqCivic, PrereqTech, AdvisorType)
select
	EnableProjectType,
	'LOC_'||EnableProjectType||'_NAME',
	'LOC_'||EnableProjectType||'_SHORT_NAME',
	'LOC_'||EnableProjectType||'_DESCRIPTION',
	EnableCost,
	EnableCivicType,
	EnableTechType,
	'ADVISOR_GENERIC'
from CityPolicyMaster where CityPolicy != 'EMPTY';
-- Disable Projects
insert or replace into Projects
	(ProjectType, Name, ShortName, Description, Cost, PrereqCivic, PrereqTech, AdvisorType)
select
	DisableProjectType,
	'LOC_'||DisableProjectType||'_NAME',
	'LOC_'||DisableProjectType||'_SHORT_NAME',
	'LOC_'||DisableProjectType||'_DESCRIPTION',
	DisableCost,
	NULL,
	NULL,
	'ADVISOR_GENERIC'
from CityPolicyMaster where CityPolicy != 'EMPTY';

-- Enable
insert or replace into Project_BuildingCosts
	(ProjectType,			ConsumedBuildingType)
select
	EnableProjectType,		'BUILDING_CITY_POLICY_EMPTY'
from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Projects_XP2
	(ProjectType,			RequiredBuilding,				CreateBuilding)
select
	EnableProjectType,		'BUILDING_CITY_POLICY_EMPTY',	BuildingType
from CityPolicyMaster where CityPolicy != 'EMPTY';

-- Disable
insert or replace into Projects_XP2
	(ProjectType,			RequiredBuilding,				CreateBuilding)
select
	DisableProjectType,		BuildingType,					'BUILDING_CITY_POLICY_EMPTY'
from CityPolicyMaster where CityPolicy != 'EMPTY';
insert or replace into Project_BuildingCosts
	(ProjectType,			ConsumedBuildingType)
select
	DisableProjectType,		BuildingType
from CityPolicyMaster where CityPolicy != 'EMPTY';

insert or replace into MutuallyExclusiveBuildings (Building, MutuallyExclusiveBuilding)
select a.BuildingType, b.BuildingType from CityPolicyMaster a, CityPolicyMaster b where a.BuildingType != b.BuildingType;

-------------------------------------
-- FREIGHT = 官营手工业 / FORGING_IRON = 新兵训练营 / DIPLOMATIC_MEETING = 图腾柱
-------------------------------------
insert or ignore into Types (Type, Kind) values
    ('MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_CHANGE', 'KIND_MODIFIER'),
    ('MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_CHANGE', 'KIND_MODIFIER'),
    ('MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_CHANGE', 'KIND_MODIFIER');

insert or ignore into DynamicModifiers (ModifierType, CollectionType, EffectType) values
    ('MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_CHANGE', 'COLLECTION_OWNER', 'EFFECT_ADJUST_CITY_PRODUCTION_BUILDING'),
    ('MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_CHANGE', 'COLLECTION_OWNER', 'EFFECT_ADJUST_CITY_PRODUCTION_DISTRICT'),
    ('MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_CHANGE', 'COLLECTION_OWNER', 'EFFECT_ADJUST_CITY_PRODUCTION_UNIT');

insert or ignore into RequirementArguments (RequirementId, Name, Value)
    select 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType, 'ResourceType', ResourceType from Resources;
insert or ignore into Requirements (RequirementId, RequirementType)
    select 'HD_REQUIRES_CITY_HAS_IMPROVED_' || ResourceType, 'REQUIREMENT_CITY_HAS_RESOURCE_TYPE_IMPROVED' from Resources;

insert or replace into Requirements (RequirementId, RequirementType)
values ('REQUIRES_PLOT_ADJACENT_FOREST_ROOSEVELT', 'REQUIREMENT_PLOT_ADJACENT_FEATURE_TYPE_MATCHES');
insert or replace into RequirementArguments (RequirementId, Name, Value)
values ('REQUIRES_PLOT_ADJACENT_FOREST_ROOSEVELT', 'FeatureType', 'FEATURE_FOREST');

insert or replace into Building_YieldChanges (BuildingType, YieldType, YieldChange) values
    ('BUILDING_CITY_POLICY_FREIGHT', 'YIELD_PRODUCTION', 1),
    ('BUILDING_CITY_POLICY_DIPLOMATIC_MEETING', 'YIELD_FAITH', 1),
    ('BUILDING_CITY_POLICY_FORGING_IRON', 'YIELD_PRODUCTION', 1);

insert or replace into RequirementSets (RequirementSetId, RequirementSetType) values
    ('CP_FREIGHT_HANDCRAFT_REQUIREMENT', 'REQUIREMENTSET_TEST_ANY'),
    ('CP_FORGING_IRON_BOOTCAMP_REQUIREMENT', 'REQUIREMENTSET_TEST_ANY'),
    ('CP_DIPLOMATIC_MEETING_TOTEMS_REQUIREMENT', 'REQUIREMENTSET_TEST_ANY');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'CP_FREIGHT_HANDCRAFT_REQUIREMENT', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || r.ResourceType
from Resources r, Improvement_ValidResources i
where r.ResourceType == i.ResourceType and (i.ImprovementType == 'IMPROVEMENT_MINE' or i.ImprovementType == 'IMPROVEMENT_QUARRY')
    and (r.ResourceClassType == 'RESOURCECLASS_LUXURY' or r.ResourceClassType == 'RESOURCECLASS_BONUS');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId)
select 'CP_FORGING_IRON_BOOTCAMP_REQUIREMENT', 'HD_REQUIRES_CITY_HAS_IMPROVED_' || r.ResourceType
from Resources r, Improvement_ValidResources i
where r.ResourceType == i.ResourceType and (i.ImprovementType == 'IMPROVEMENT_PASTURE' or i.ImprovementType == 'IMPROVEMENT_CAMP'
    or r.ResourceClassType == 'RESOURCECLASS_STRATEGIC');

insert or replace into RequirementSetRequirements (RequirementSetId, RequirementId) values
    ('CP_DIPLOMATIC_MEETING_TOTEMS_REQUIREMENT', 'REQUIRES_PLOT_ADJACENT_FOREST_ROOSEVELT'),
    ('CP_DIPLOMATIC_MEETING_TOTEMS_REQUIREMENT', 'REQUIRES_PLOT_ADJACENT_TO_MOUNTAIN');

insert or replace into BuildingModifiers (BuildingType, ModifierId) values
    ('BUILDING_CITY_POLICY_FREIGHT', 'CITY_POLICY_FREIGHT_BUILDING_PROD'),
    ('BUILDING_CITY_POLICY_FREIGHT', 'CITY_POLICY_FREIGHT_DISTRICT_PROD'),
    ('BUILDING_CITY_POLICY_FORGING_IRON', 'CITY_POLICY_FORGING_IRON_UNIT_PROD'),
    ('BUILDING_CITY_POLICY_DIPLOMATIC_MEETING', 'CITY_POLICY_DIPLOMATIC_MEETING_PROPHET_POINT');

insert or replace into Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) values
    ('CITY_POLICY_FREIGHT_BUILDING_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION_CHANGE', 'CP_FREIGHT_HANDCRAFT_REQUIREMENT'),
    ('CITY_POLICY_FREIGHT_DISTRICT_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_CHANGE', 'CP_FREIGHT_HANDCRAFT_REQUIREMENT'),
    ('CITY_POLICY_FORGING_IRON_UNIT_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_CHANGE', 'CP_FORGING_IRON_BOOTCAMP_REQUIREMENT'),
    ('CITY_POLICY_DIPLOMATIC_MEETING_PROPHET_POINT', 'MODIFIER_SINGLE_CITY_ADJUST_GREAT_PERSON_POINT', 'CP_DIPLOMATIC_MEETING_TOTEMS_REQUIREMENT');

insert or replace into ModifierArguments (ModifierId, Name, Value) values
    ('CITY_POLICY_FREIGHT_BUILDING_PROD', 'Amount', 1),
    ('CITY_POLICY_FREIGHT_DISTRICT_PROD', 'Amount', 1),
    ('CITY_POLICY_FORGING_IRON_UNIT_PROD', 'Amount', 2),
    ('CITY_POLICY_DIPLOMATIC_MEETING_PROPHET_POINT', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_PROPHET'),
    ('CITY_POLICY_DIPLOMATIC_MEETING_PROPHET_POINT', 'Amount', 1);

insert or ignore into Types (Type, Kind)
values ('MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING', 'KIND_MODIFIER');

insert or ignore into DynamicModifiers (ModifierType, CollectionType, EffectType)
values ('MODIFIER_SINGLE_CITY_ADJUST_BUILDING_HOUSING', 'COLLECTION_OWNER', 'EFFECT_ADJUST_BUILDING_HOUSING');
