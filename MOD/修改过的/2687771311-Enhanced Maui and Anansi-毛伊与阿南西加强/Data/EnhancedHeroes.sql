-- EnhancedHeroes
-- Author: Konomi
-- DateCreated: 12/3/2021 23:41:26
--------------------------------------------------------------

---------------------------------------------------------------
-- Anansi
---------------------------------------------------------------
UPDATE UnitCommands SET VisibleInUI = 0 WHERE CommandType = 'UNITCOMMAND_RESOURCE_INSPIRE';
UPDATE UnitCommands SET VisibleInUI = 0 WHERE CommandType = 'UNITCOMMAND_CREATE_RANDOM_RESOURCE';

UPDATE TypeProperties SET Value = 100 WHERE Type = 'UNITCOMMAND_RESOURCE_INSPIRE' AND Name = 'PROGRESSION_PARAM1';
