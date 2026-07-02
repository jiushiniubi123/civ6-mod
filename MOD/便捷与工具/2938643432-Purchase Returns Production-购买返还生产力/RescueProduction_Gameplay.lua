-- RescueProduction_Gameplay
-- Author: C1sen
-- DateCreated: 2/25/2023 10:38:18 AM
--------------------------------------------------------------

-- ==================================================================================================== --
-- Constant
-- ==================================================================================================== --

ExposedMembers.GameEvents = GameEvents;
local iRescueRate = 0.95;
local YIELD_GOLD = GameInfo.Yields['YIELD_GOLD'].Index;
local YIELD_FAITH = GameInfo.Yields['YIELD_FAITH'].Index;

-- ==================================================================================================== --
-- Core
-- ==================================================================================================== --

function RescueProduction( PlayerID, eYield, iCost, iProgress, iPurchaseCost )
	local pPlayer = Players[PlayerID];
	if pPlayer == nil then return; end
	local iRescue = 0;
	if iProgress > 0 and iProgress < iCost and iPurchaseCost > 0 then
		iRescue = iRescueRate * iPurchaseCost * iProgress / iCost;
	end
	if eYield == YIELD_GOLD then
		pPlayer:GetTreasury():ChangeGoldBalance( iRescue );
	elseif eYield == YIELD_FAITH then
		pPlayer:GetReligion():ChangeFaithBalance( iRescue );
	end
end

-- ==================================================================================================== --
-- Initialize
-- ==================================================================================================== --

function Initialize()
	GameEvents.RescueProduction.Add( RescueProduction );
end
Events.LoadGameViewStateDone.Add( Initialize );
