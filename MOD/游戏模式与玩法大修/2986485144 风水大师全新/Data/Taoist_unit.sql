-- Taoist_unit
-- Author: pen
-- DateCreated: 2023/6/8 10:33:21
--------------------------------------------------------------
insert or replace into Types
(Type,												Kind)
values
('UNIT_TAOIST',										'KIND_UNIT');

insert or replace into Units
(UnitType,			Name,					Description,					Cost,	BaseMoves,	BaseSightRange,		Domain,			CanCapture,	CanRetreatWhenCaptured,	CanTrain,	FormationClass,				PromotionClass,					AdvisorType,		PurchaseYield,		PseudoYieldType,CostProgressionModel,				CostProgressionParam1,	CanEarnExperience,	TraitType)
values
('UNIT_TAOIST',		'LOC_UNIT_TAOIST_NAME',	'LOC_UNIT_TAOIST_DESCRIPTION',	150,	3,			3,					'DOMAIN_LAND',	0,			1,						0,			'FORMATION_CLASS_CIVILIAN',	null,							'ADVISOR_GENERIC',	'YIELD_GOLD',		null,			'COST_PROGRESSION_PREVIOUS_COPIES',	50,						0,					null);

insert or replace into Units_MODE
(UnitType,					ActionCharges)
values
('UNIT_TAOIST',				1);

insert or replace into UnitAiInfos
(UnitType,					AiType)
values
('UNIT_TAOIST',				'UNITTYPE_CIVILIAN'),
('UNIT_TAOIST',				'UNITAI_EXPLORE');

insert or replace into GovernorPromotionModifiers
(GovernorPromotionType,					ModifierId)
values
('GOVERNOR_PROMOTION_HERMETIC_ORDER_1',	'HERMETIC_GAIN_TAOIST');

insert or replace into Modifiers
(ModifierId,							ModifierType,									RunOnce,	Permanent)
values
('HERMETIC_GAIN_TAOIST',				'MODIFIER_PLAYER_GRANT_UNIT_IN_CAPITAL',		1,			1);

insert or replace into ModifierArguments
(ModifierId,							Name,					value)
values
('HERMETIC_GAIN_TAOIST',				'UnitType',				'UNIT_TAOIST'),
('HERMETIC_GAIN_TAOIST',				'Amount',				1),
('HERMETIC_GAIN_TAOIST',				'AllowUniqueOverride',	0);

insert or replace into Tags 
(Tag,					Vocabulary)
values
('CLASS_TAOIST',		'ABILITY_CLASS');

insert or replace into TypeTags
(Type,										Tag)
values
('UNIT_TAOIST',								'CLASS_LANDCIVILIAN'),	
('UNIT_TAOIST',								'CLASS_TAOIST');

insert or replace into TypeProperties
(Type,					Name,						Value,		PropertyType)
values
('UNIT_TAOIST',			'CAN_TELEPORT_TO_CITY',		1,			'PROPERTYTYPE_IDENTITY');