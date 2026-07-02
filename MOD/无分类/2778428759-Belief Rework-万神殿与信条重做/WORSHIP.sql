--大教堂：+3信仰，+1遗物巨作槽位，本城遗物产出信仰值+50%
UPDATE Building_GreatWorks SET GreatWorkSlotType = 'GREATWORKSLOT_RELIC' WHERE BuildingType = 'BUILDING_CATHEDRAL';
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_CATHEDRAL','CATHEDRAL_RELIC_FAITH');
INSERT INTO Modifiers (ModifierId,ModifierType)
	VALUES	('CATHEDRAL_RELIC_FAITH','MODIFIER_SINGLE_CITY_ADJUST_GREATWORK_YIELD');
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('CATHEDRAL_RELIC_FAITH','GreatWorkObjectType','GREATWORKOBJECT_RELIC'),
			('CATHEDRAL_RELIC_FAITH','YieldType','YIELD_FAITH'),
			('CATHEDRAL_RELIC_FAITH','ScalingFactor',150);

--拜火神庙：+3信仰，+3文化，为圣地周围单元格+1文化
INSERT INTO Building_YieldChanges (BuildingType,YieldType,YieldChange)
	VALUES	('BUILDING_DAR_E_MEHR','YIELD_CULTURE',3);
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_DAR_E_MEHR','DAR_E_MEHR_PLOT_CULTURE');
INSERT INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId)
	VALUES	('DAR_E_MEHR_PLOT_CULTURE','MODIFIER_PLAYER_ADJUST_PLOT_YIELD','REQUIRE_PLOT_ADJACENT_TO_OWNER');
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('DAR_E_MEHR_PLOT_CULTURE','YieldType','YIELD_CULTURE'),
			('DAR_E_MEHR_PLOT_CULTURE','Amount',1);
DELETE FROM Building_YieldsPerEra WHERE BuildingType = 'BUILDING_DAR_E_MEHR';

--宝塔：+3信仰，+1外交支持，建成后+1使者
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_PAGODA','PAGODA_AWARD_ENVOY');
INSERT INTO Modifiers (ModifierId,ModifierType,RunOnce,Permanent)
	VALUES	('PAGODA_AWARD_ENVOY','MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN',1,1);
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('PAGODA_AWARD_ENVOY','Amount',1);

--佛寺：+3信仰，+3瓶，为圣地周围单元格+1科技
UPDATE Building_YieldChanges SET YieldChange = 3 WHERE BuildingType = 'BUILDING_WAT' AND YieldType = 'YIELD_SCIENCE';
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_WAT','WAT_PLOT_SCIENCE');
INSERT INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId)
	VALUES	('WAT_PLOT_SCIENCE','MODIFIER_PLAYER_ADJUST_PLOT_YIELD','REQUIRE_PLOT_ADJACENT_TO_OWNER');
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('WAT_PLOT_SCIENCE','YieldType','YIELD_SCIENCE'),
			('WAT_PLOT_SCIENCE','Amount',1);

--礼拜堂：+3信仰，+3锤，本城所有改良设施+1金币
INSERT INTO Requirements (RequirementId,RequirementType)
	VALUES	('REQUIRES_PLOT_HAS_ANY_IMPROVEMENT','REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT');
INSERT INTO RequirementSets (RequirementSetId,RequirementSetType)
	VALUES	('PLOT_HAS_ANY_IMPROVEMENT','REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId,RequirementId)
	VALUES	('PLOT_HAS_ANY_IMPROVEMENT','REQUIRES_PLOT_HAS_ANY_IMPROVEMENT');

UPDATE Building_YieldChanges SET YieldChange = 3 WHERE BuildingType = 'BUILDING_MEETING_HOUSE' AND YieldType = 'YIELD_PRODUCTION';
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_MEETING_HOUSE','MEETING_HOUSE_PLOT_PRODUCTION');
INSERT INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId)
	VALUES	('MEETING_HOUSE_PLOT_PRODUCTION','MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD','PLOT_HAS_ANY_IMPROVEMENT');
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('MEETING_HOUSE_PLOT_PRODUCTION','YieldType','YIELD_GOLD'),
			('MEETING_HOUSE_PLOT_PRODUCTION','Amount',1);

--清真寺：+3信仰，传教士和使徒传播次数+1

--窣堵波：+3信仰，+2宜居
UPDATE Buildings SET Entertainment = 2 WHERE BuildingType = 'BUILDING_STUPA';

--谒师所：+3信仰，+3粮，+2住房，本城所有改良设施+1粮
UPDATE Building_YieldChanges SET YieldChange = 3 WHERE BuildingType = 'BUILDING_GURDWARA' AND YieldType = 'YIELD_FOOD';
UPDATE Buildings SET Housing = 2 WHERE BuildingType = 'BUILDING_GURDWARA';
INSERT INTO BuildingModifiers (BuildingType,ModifierId)
	VALUES	('BUILDING_GURDWARA','GURDWARA_PLOT_FOOD');
INSERT INTO Modifiers (ModifierId,ModifierType,SubjectRequirementSetId)
	VALUES	('GURDWARA_PLOT_FOOD','MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD','PLOT_HAS_ANY_IMPROVEMENT');
INSERT INTO ModifierArguments (ModifierId,Name,Value)
	VALUES	('GURDWARA_PLOT_FOOD','YieldType','YIELD_FOOD'),
			('GURDWARA_PLOT_FOOD','Amount',1);

--犹太教堂：+10信仰
UPDATE Building_YieldChanges SET YieldChange = 10 WHERE BuildingType = 'BUILDING_SYNAGOGUE' AND YieldType = 'YIELD_FAITH';

UPDATE Beliefs SET Description = 'LOC_BELIEF_CATHEDRAL_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_CATHEDRAL';
UPDATE Beliefs SET Description = 'LOC_BELIEF_GURDWARA_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_GURDWARA';
UPDATE Beliefs SET Description = 'LOC_BELIEF_MEETING_HOUSE_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_MEETING_HOUSE';
UPDATE Beliefs SET Description = 'LOC_BELIEF_PAGODA_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_PAGODA';
UPDATE Beliefs SET Description = 'LOC_BELIEF_SYNAGOGUE_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_SYNAGOGUE';
UPDATE Beliefs SET Description = 'LOC_BELIEF_WAT_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_WAT';
UPDATE Beliefs SET Description = 'LOC_BELIEF_STUPA_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_STUPA';
UPDATE Beliefs SET Description = 'LOC_BELIEF_DAR_E_MEHR_H_DESCRIPTION' WHERE BeliefType = 'BELIEF_DAR_E_MEHR';

UPDATE Buildings SET Description = 'LOC_BUILDING_PAGODA_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_PAGODA';
UPDATE Buildings SET Description = 'LOC_BUILDING_DAR_E_MEHR_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_DAR_E_MEHR';
UPDATE Buildings SET Description = 'LOC_BUILDING_CATHEDRAL_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_CATHEDRAL';
UPDATE Buildings SET Description = 'LOC_BUILDING_GURDWARA_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_GURDWARA';
UPDATE Buildings SET Description = 'LOC_BUILDING_MEETING_HOUSE_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_MEETING_HOUSE';
UPDATE Buildings SET Description = 'LOC_BUILDING_WAT_H_DESCRIPTION' WHERE BuildingType = 'BUILDING_WAT';
