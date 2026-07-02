-- ML_UrbanIdentities_Requirements
-- Author: Maple_Leaves
-- DateCreated: 3/4/2026 11:40:49 PM
--------------------------------------------------------------


-- Requirements

INSERT INTO Requirements 
	(RequirementId,									RequirementType) 
VALUES 
	('REQUIRES_PLOT_HAS_ANY_IMPROVEMENT_SUK_ID_ML', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT');

-- Requirements

INSERT INTO Requirements 
	(RequirementId,									RequirementType,						Inverse) 
VALUES 
	('REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT',	1);

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES
	('REQUIRES_PLOT_HAS_BEACH_RESORT_SUK_ID_ML',			'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_CITY_PARK_SUK_ID_ML',				'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_BEACH_RESORT_SUK_ID_ML',			'ImprovementType', 'IMPROVEMENT_BEACH_RESORT'),
	('REQUIRES_PLOT_HAS_CITY_PARK_SUK_ID_ML',				'ImprovementType', 'IMPROVEMENT_CITY_PARK');

-- Requirements
INSERT INTO Requirements 
	(RequirementId, RequirementType) 
VALUES 
	('REQUIRES_PLOT_HAS_WATER_SUK_ID_ML', 'REQUIREMENT_PLOT_TERRAIN_CLASS_MATCHES');

INSERT INTO RequirementArguments 
	(RequirementId, Name, Value) 
VALUES 
	('REQUIRES_PLOT_HAS_WATER_SUK_ID_ML', 'TerrainClass', 'TERRAIN_CLASS_WATER');


-- Requirements
INSERT INTO Requirements 
	(RequirementId, RequirementType) 
VALUES 
	('REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');

INSERT INTO RequirementArguments 
	(RequirementId, Name, Value) 
VALUES 
	('REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML', 'TechnologyType', 'TECH_SCIENTIFIC_THEORY');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_COPPER_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_COPPER_SUK_ID_ML',			'ResourceType', 'RESOURCE_COPPER');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_DEER_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_DEER_SUK_ID_ML',			'ResourceType', 'RESOURCE_DEER');


-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_IRON_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_IRON_SUK_ID_ML',			'ResourceType', 'RESOURCE_IRON');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_SALT_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_SALT_SUK_ID_ML',			'ResourceType', 'RESOURCE_SALT');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_NITER_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_NITER_SUK_ID_ML',			'ResourceType', 'RESOURCE_NITER');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_IVORY_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_IVORY_SUK_ID_ML',			'ResourceType', 'RESOURCE_IVORY');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_JADE_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_DIAMONDS_SUK_ID_ML',		'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_AMBER_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_MERCURY_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_SILVER_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_JADE_SUK_ID_ML',			'ResourceType', 'RESOURCE_JADE'),
	('REQUIRES_PLOT_HAS_DIAMONDS_SUK_ID_ML',		'ResourceType', 'RESOURCE_DIAMONDS'),
	('REQUIRES_PLOT_HAS_AMBER_SUK_ID_ML',			'ResourceType', 'RESOURCE_AMBER'),
	('REQUIRES_PLOT_HAS_MERCURY_SUK_ID_ML',			'ResourceType', 'RESOURCE_MERCURY'),
	('REQUIRES_PLOT_HAS_SILVER_SUK_ID_ML',			'ResourceType', 'RESOURCE_SILVER');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLOT_HAS_INCENSE_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES'),
	('REQUIRES_PLOT_HAS_SPICES_SUK_ID_ML',			'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLOT_HAS_INCENSE_SUK_ID_ML',			'ResourceType', 'RESOURCE_INCENSE'),
	('REQUIRES_PLOT_HAS_SPICES_SUK_ID_ML',			'ResourceType', 'RESOURCE_SPICES');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML',			'REQUIREMENT_PLAYER_ERA_AT_LEAST');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLAYER_AT_LEAST_ERA_RENAISSANCE_SUK_ID_ML',			'EraType', 'ERA_RENAISSANCE');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML',			'REQUIREMENT_PLAYER_ERA_AT_LEAST');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLAYER_AT_LEAST_ERA_INDUSTRIAL_SUK_ID_ML',			'EraType', 'ERA_INDUSTRIAL');


-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
	('REQUIRES_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML',			'REQUIREMENT_PLAYER_HAS_CIVIC');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
	('REQUIRES_PLAYER_HAS_NATURAL_HISTORY_SUK_ID_ML',			'CivicType', 'CIVIC_NATURAL_HISTORY');

	