-- Suk_UrbanIdentities_ML_Modifiers
-- Custom ModifierTypes migrated from More Urban Identities (Maple_Leaves)
-- Required by the identities that depend on Sukritact's original Regions
--------------------------------------------------------------

INSERT OR IGNORE INTO Types
	(Type,																	Kind)
VALUES	
	('MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML',			'KIND_MODIFIER'),
	('MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML',		'KIND_MODIFIER');

INSERT OR IGNORE INTO DynamicModifiers
	(ModifierType,														CollectionType,					EffectType)
VALUES
	('MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML',		'COLLECTION_OWNER',				'EFFECT_ADJUST_DISTRICT_PRODUCTION'),
	('MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML',	'COLLECTION_OWNER',				'EFFECT_ADJUST_UNIT_TAG_ERA_PRODUCTION');