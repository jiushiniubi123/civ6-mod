




--梁奇观加成，公园全国化特效



INSERT INTO Types
			(Type,	Kind)
VALUES		('MODIFIER_GOVERNOR_PROMOTION_ALL_CITY_ALLOW_CITY_PARK',			'KIND_MODIFIER'),
		('MODIFIER_MINE_PCITIES_WONDER_YIELD_CHANGE',			'KIND_MODIFIER');


INSERT INTO DynamicModifiers
			(ModifierType,												CollectionType,						EffectType)
VALUES			('MODIFIER_GOVERNOR_PROMOTION_ALL_CITY_ALLOW_CITY_PARK',			'COLLECTION_PLAYER_CITIES',			'EFFECT_ADJUST_CITY_ALLOWED_IMPROVEMENT'),
			('MODIFIER_MINE_PCITIES_WONDER_YIELD_CHANGE',			'COLLECTION_OWNER',			'EFFECT_ADJUST_WONDER_YIELD_CHANGE');




--瑞娜建筑打折特效

INSERT INTO Types
			(Type,	Kind)
VALUES		('MODIFIER_BEARGOV_PCITIES_ALL_BUILDINGS_DISCOUNT',			'KIND_MODIFIER');

INSERT INTO DynamicModifiers
			(ModifierType,												CollectionType,						EffectType)
VALUES		('MODIFIER_BEARGOV_PCITIES_ALL_BUILDINGS_DISCOUNT',			'COLLECTION_PLAYER_CITIES',			'EFFECT_ADJUST_ALL_BUILDINGS_PURCHASE_COST');






--Governor Reqs

--Magnus No Building Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_CITY_NOT_HAS_MAGNUS_OFFICE',					'REQUIREMENT_CITY_HAS_BUILDING',								1),
	('REQUIRES_H_CITY_HAS_MAGNUS_OFFICE',						'REQUIREMENT_CITY_HAS_BUILDING',								0),
	('REQUIRES_H_CITY_HAS_MAGNUS_R3_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_CITY_NOT_HAS_MAGNUS_OFFICE',					'BuildingType',								'BUILDING_GOVERNOR_MAGNUS_OFFICE'),
	('REQUIRES_H_CITY_HAS_MAGNUS_OFFICE',						'BuildingType',								'BUILDING_GOVERNOR_MAGNUS_OFFICE'),
	('REQUIRES_H_CITY_HAS_MAGNUS_R3_PROMOTION',					'Established',								1),
	('REQUIRES_H_CITY_HAS_MAGNUS_R3_PROMOTION',					'GovernorPromotionType',					'GOVERNOR_PROMOTION_H_RESOURCE_MANAGER_RIGHT_3');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('CITY_NOT_HAS_MAGNUS_OFFICE_H_REQUIREMENTS',				'REQUIREMENTSET_TEST_ALL'),
	('CITY_HAS_MAGNUS_OFFICE_H_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('MAGNUS_R3_PROMOTION_H_REQUIREMENTS',						'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('CITY_NOT_HAS_MAGNUS_OFFICE_H_REQUIREMENTS',				'REQUIRES_H_CITY_NOT_HAS_MAGNUS_OFFICE'),
	('CITY_HAS_MAGNUS_OFFICE_H_REQUIREMENTS',					'REQUIRES_H_CITY_HAS_MAGNUS_OFFICE'),
	('MAGNUS_R3_PROMOTION_H_REQUIREMENTS',						'REQUIRES_H_CITY_HAS_MAGNUS_OFFICE'),
	('MAGNUS_R3_PROMOTION_H_REQUIREMENTS',						'REQUIRES_H_CITY_HAS_MAGNUS_R3_PROMOTION');

--Moksha 2 Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_GOR_PLOT_IN_SIX',								'REQUIREMENT_PLOT_ADJACENT_TO_OWNER',							0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_GOR_PLOT_IN_SIX',								'MinDistance',								0),
	('REQUIRES_H_GOR_PLOT_IN_SIX',								'MaxDistance',								6);

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_SIX_PLOTS_REQUIREMENTS',							'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_SIX_PLOTS_REQUIREMENTS',							'REQUIRES_H_GOR_PLOT_IN_SIX');

--Specialty Districts

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
SELECT
	'H_GOR_DISTRICT_IS_' || DistrictType,						'REQUIREMENT_DISTRICT_TYPE_MATCHES',							0
FROM Districts;

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
SELECT
	'H_GOR_DISTRICT_IS_' || DistrictType,						'DistrictType',								DistrictType
FROM Districts;

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_IS_SPECIALTY_DISTRICT_REQUIREMENTS',				'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
SELECT
	'H_GOR_IS_SPECIALTY_DISTRICT_REQUIREMENTS',					'H_GOR_DISTRICT_IS_' || DistrictType
FROM Districts WHERE RequiresPopulation = 1;

--Reyna L3 Promotion Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_CITY_HAS_REYNA_L3_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_CITY_HAS_REYNA_L3_PROMOTION',					'Established',								1),
	('REQUIRES_H_CITY_HAS_REYNA_L3_PROMOTION',					'GovernorPromotionType',					'GOVERNOR_PROMOTION_H_MERCHANT_LEFT_3');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_REYNA_L3_REQUIREMENTS',								'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_REYNA_L3_REQUIREMENTS',								'REQUIRES_H_CITY_HAS_REYNA_L3_PROMOTION');

--Liang L1 Improved Resources Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('H_GOR_PLOT_HAS_ANY_IMPROVEMENT_REQUIREMENTS',				'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT',							0);

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_LIANG_L1_IMPROVED_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('H_GOR_PLAYER_HAS_APPRENTICESHIP_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_LIANG_L1_IMPROVED_REQUIREMENTS',					'H_GOR_PLOT_HAS_ANY_IMPROVEMENT_REQUIREMENTS'),
	('H_GOR_PLAYER_HAS_APPRENTICESHIP_REQUIREMENTS',			'REQUIRES_PLAYER_HAS_APPRENTICESHIP');




--Liang 2 Promotion Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_GOR_LIANG_2_PROMOTION',						'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_GOR_LIANG_2_PROMOTION',						'Established',								1),
	('REQUIRES_H_GOR_LIANG_2_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_H_BUILDER_RIGHT_3');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_LIANG_2_PROMOTION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('H_GOR_LIANG_2_PROMOTION_DISTRICT_REQUIREMENTS',			'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_LIANG_2_PROMOTION_REQUIREMENTS',					'REQUIRES_H_GOR_LIANG_2_PROMOTION'),
	('H_GOR_LIANG_2_PROMOTION_DISTRICT_REQUIREMENTS',			'REQUIRES_H_GOR_LIANG_2_PROMOTION'),
	('H_GOR_LIANG_2_PROMOTION_DISTRICT_REQUIREMENTS',			'ADJACENT_TO_OWNER');

--Amani Domestic Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_GOR_AMANI_DOMESTIC_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_GOR_AMANI_DOMESTIC_PROMOTION',						'Established',								1),
	('REQUIRES_H_GOR_AMANI_DOMESTIC_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_AMANI_DOMESTIC_PROMOTION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('H_GOR_AMANI_DOMESTIC_PROMOTION_DISTRICT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_AMANI_DOMESTIC_PROMOTION_REQUIREMENTS',					'REQUIRES_H_GOR_AMANI_DOMESTIC_PROMOTION');

--Amani Domestic 3 Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_GOR_AMANI_3_DOMESTIC_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_GOR_AMANI_3_DOMESTIC_PROMOTION',						'Established',								1),
	('REQUIRES_H_GOR_AMANI_3_DOMESTIC_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_AMANI_3_DOMESTIC_PROMOTION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL'),
	('H_GOR_AMANI_3_DOMESTIC_PROMOTION_DISTRICT_REQUIREMENTS',		'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_AMANI_3_DOMESTIC_PROMOTION_REQUIREMENTS',					'REQUIRES_H_GOR_AMANI_3_DOMESTIC_PROMOTION');

--Victor Unit 9 tiles Reqs

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_H_GOR_UNIT_WITHIN_9_TILES',						'REQUIREMENT_PLOT_ADJACENT_TO_OWNER',							0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_H_GOR_UNIT_WITHIN_9_TILES',						'MinDistance',								0),
	('REQUIRES_H_GOR_UNIT_WITHIN_9_TILES',						'MaxDistance',								9);

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('H_GOR_VICTOR_UNIT_9_TILES_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('H_GOR_VICTOR_UNIT_9_TILES_REQUIREMENTS',					'REQUIRES_H_GOR_UNIT_WITHIN_9_TILES');


--瑞娜

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA_PROMOTION',						'Established',								1),
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_H_MERCHANT_LEFT_1');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('MINE_REYNA_COAST_CITY_1_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('MINE_REYNA_COAST_CITY_1_REQUIREMENTS',					'REQUIRES_CITY_HAS_SPECIFIC_REYNA_PROMOTION'),
	('MINE_REYNA_COAST_CITY_1_REQUIREMENTS',					'REQUIRES_DISTRICT_IS_CITY_CENTER'),
	('MINE_REYNA_COAST_CITY_1_REQUIREMENTS',					'REQUIRES_PLOT_IS_ADJACENT_TO_COAST');


INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA2_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA2_PROMOTION',						'Established',								1),
	('REQUIRES_CITY_HAS_SPECIFIC_REYNA2_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_H_MERCHANT_2');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('MINE_REYNA_BUILDING_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('MINE_REYNA_BUILDING_REQUIREMENTS',					'REQUIRES_CITY_HAS_SPECIFIC_REYNA2_PROMOTION');




--老马6格城市化



INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('GOR_MAGNUS_6_TILES_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('GOR_MAGNUS_6_TILES_REQUIREMENTS',					'REQUIRES_H_GOR_PLOT_IN_SIX'),
	('GOR_MAGNUS_6_TILES_REQUIREMENTS',					'REQUIRES_PLAYER_HAS_URBANIZATION');


--梁就职前置

INSERT INTO Requirements
	(RequirementId,												RequirementType,												Inverse)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_LIANG_PROMOTION',					'REQUIREMENT_CITY_HAS_SPECIFIC_GOVERNOR_PROMOTION_TYPE',		0);

INSERT INTO RequirementArguments
	(RequirementId,												Name,										Value)
VALUES
	('REQUIRES_CITY_HAS_SPECIFIC_LIANG_PROMOTION',						'Established',								1),
	('REQUIRES_CITY_HAS_SPECIFIC_LIANG_PROMOTION',						'GovernorPromotionType',					'GOVERNOR_PROMOTION_BUILDER_GUILDMASTER');

INSERT INTO RequirementSets
	(RequirementSetId,											RequirementSetType)
VALUES
	('MINE_FISHERY_GOVERNOR_PRODUCTION_REQUIREMENTS',					'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
	(RequirementSetId,											RequirementId)
VALUES
	('MINE_FISHERY_GOVERNOR_PRODUCTION_REQUIREMENTS',					'REQUIRES_CITY_HAS_SPECIFIC_LIANG_PROMOTION');






