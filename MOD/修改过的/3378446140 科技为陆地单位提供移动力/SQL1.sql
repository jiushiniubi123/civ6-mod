-- GameData01
-- Author: hnoyy
-- DateCreated: 10/16/2024 10:36:36 PM
--------------------------------------------------------------
--insert or replace into UnitAbilityModifiers (UnitAbilityType, ModifierId ) 
--VALUES		('ABILITY_SAMURAI', 'COSSACK_MOVE_AND_ATTACK');


UPDATE Technologies
SET Description = 'LOC_TECH_MACHINERY_DESCRIPTION'
WHERE TechnologyType = 'TECH_MACHINERY';

UPDATE Technologies
SET Description = 'LOC_TECH_ADVANCED_POWER_CELLS_DESCRIPTION'
WHERE TechnologyType = 'TECH_ADVANCED_POWER_CELLS';
