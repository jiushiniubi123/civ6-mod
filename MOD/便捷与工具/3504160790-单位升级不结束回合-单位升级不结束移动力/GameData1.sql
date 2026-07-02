-- GameData1
-- Author: Memory
-- DateCreated: 5/14/2025 18:12:18 PM
--------------------------------------------------------------
INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES
('TRAIT_LEADER_MAJOR_CIV', 'MODIFIER_UNITS_PROMOTE_NO_FINISH_MOVES');

INSERT INTO Modifiers(ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId)
VALUES
('MODIFIER_UNITS_PROMOTE_NO_FINISH_MOVES', 'MODIFIER_PLAYER_UNITS_PROMOTE_NO_FINISH_MOVES', 0, 0, 0, 'NO_FINISH_MOVES_HUMAN_REQS', NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
('MODIFIER_UNITS_PROMOTE_NO_FINISH_MOVES', 'NoFinishMoves', 'true');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('NO_FINISH_MOVES_HUMAN_REQS', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('NO_FINISH_MOVES_HUMAN_REQS', 'NO_FINISH_MOVES_HUMAN');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('NO_FINISH_MOVES_HUMAN', 'REQUIREMENT_PLAYER_IS_HUMAN');