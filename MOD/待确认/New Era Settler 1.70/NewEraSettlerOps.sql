-- New Era Settler -- 1.70
-- Author: Das_Capitolin --
----------------------------------------------------------------------------------------------------

UPDATE AiFavoredItems
SET    Value = '1', -- Value = 1 (0 disables Settler founding city)
       Favored = '1'  -- Favored = 1
WHERE  ListType = 'BaseOperationsLimits'
       AND Item = 'OP_SETTLE';
UPDATE AiOperationDefs
SET    Priority = '3', -- Priority = 4    MaxTargetDistInArea = -1
       MaxTargetDistInRegion = '-1', -- MaxTargetDistInRegion = -1
       MaxTargetDistInArea = '-1', -- MaxTargetDistInArea = -1
       MinOddsOfSuccess = '0', -- MinOddsOfSuccess = 0
       MustHaveUnits = '-1' -- MustHaveUnits = -1
WHERE  OperationName = 'Settle New City'
       AND TargetType = 'TARGET_SETTLE_LOCATION';

	--UPDATE OpTeamRequirements SET MinNumber = '1', MaxNumber = '1' WHERE TeamName = 'Settle City Team' AND AiType = 'UNITAI_SETTLE'; -- MinNumber=1  MaxNumber=1 --#
	--UPDATE OpTeamRequirements SET MinNumber = '1', MaxNumber = '3' WHERE TeamName = 'Settle City Team' AND AiType = 'UNITAI_COMBAT'; -- MinNumber=1  MaxNumber= --#
	--UPDATE OpTeamRequirements SET MinNumber = '', MaxNumber = '0' WHERE TeamName = 'Settle City Team' AND AiType = 'UNITTYPE_NAVAL'; -- MinNumber=  MaxNumber=0 --#
	--UPDATE OpTeamRequirements SET MinNumber = '', MaxNumber = '0' WHERE TeamName = 'Settle City Team' AND AiType = 'UNITTYPE_AIR'; -- MinNumber=  MaxNumber=0 --#