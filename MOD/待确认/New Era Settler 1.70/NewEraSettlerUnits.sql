-- New Era Settler -- 1.70
-- Author: Das_Capitolin --
----------------------------------------------------------------------------------------------------

UPDATE Units
SET    Cost = 400, -- Default Cost = 80
       PrereqPopulation = 10, -- Default PrereqPopulation = 2
       PopulationCost = 3 -- Default PopulationCost = 1
WHERE  UnitType = 'UNIT_SETTLER';

UPDATE Units
SET    BaseSightRange = 4 -- Default BaseSightRange = 3
WHERE  UnitType = 'UNIT_SETTLER';

UPDATE UnitCaptures
SET    BecomesUnitType = 'UNIT_BUILDER' -- No stealing of Settlers
WHERE  CapturedUnitType = 'UNIT_SETTLER';

UPDATE MajorStartingUnits
SET    MinDifficulty = 'DIFFICULTY_DEITY'
WHERE  Unit = 'UNIT_SETTLER'
       AND MinDifficulty IS NOT NULL;