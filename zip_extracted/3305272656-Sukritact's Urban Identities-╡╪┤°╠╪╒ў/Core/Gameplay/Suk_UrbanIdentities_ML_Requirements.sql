-- Suk_UrbanIdentities_ML_Requirements
-- Custom Requirements migrated from More Urban Identities (Maple_Leaves)
-- Required by the identities that depend on Sukritact's original Regions
--------------------------------------------------------------

-- Requirements
INSERT OR IGNORE INTO Requirements 
	(RequirementId,									RequirementType,						Inverse) 
VALUES 
	('REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML', 'REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT',	1);

-- Requirements
INSERT OR IGNORE INTO Requirements 
	(RequirementId, RequirementType) 
VALUES 
	('REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY');

INSERT OR IGNORE INTO RequirementArguments 
	(RequirementId, Name, Value) 
VALUES 
	('REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML', 'TechnologyType', 'TECH_SCIENTIFIC_THEORY');