-- RescueProduction_UI
-- Author: C1sen
-- DateCreated: 2/24/2023 10:05:12 PM
--------------------------------------------------------------

-- ==================================================================================================== --
-- Constant
-- ==================================================================================================== --

GameEvents = ExposedMembers.GameEvents;
local YIELD_GOLD = GameInfo.Yields['YIELD_GOLD'].Index;
local YIELD_FAITH = GameInfo.Yields['YIELD_FAITH'].Index;

-- ==================================================================================================== --
-- Variables
-- ==================================================================================================== --

local tProductionProgressData_Districts = {};
local tProductionProgressData_Buildings = {};
local IsPurchasedWithGold = {};
local IsPurchasedWithFaith = {};
local iGoldHash = {};
local iFaithHash = {};

-- ==================================================================================================== --
-- Core
-- ==================================================================================================== --

function SaveProductionProgressData( PlayerID )
	if PlayerID ~= Game.GetLocalPlayer() then return; end
	local pPlayer = Players[PlayerID];
	local pCity = UI.GetHeadSelectedCity();
	if pPlayer == nil or pCity == nil then return; end
	local CityID = pCity:GetID();
	local pCityBuildQueue = pCity:GetBuildQueue();
	tProductionProgressData_Districts = {};
	tProductionProgressData_Buildings = {};
	for row in GameInfo.Districts() do
		if pCityBuildQueue:GetDistrictProgress( row.Index ) > 0 then
			table.insert(tProductionProgressData_Districts, {
				iPlayer = PlayerID,
				iCity = CityID,
				iDistrict = row.Index,
				iCost = pCityBuildQueue:GetDistrictCost( row.Index ),
				iProgress = pCityBuildQueue:GetDistrictProgress( row.Index ),
				iGoldCost = pCity:GetGold():GetPurchaseCost( YIELD_GOLD, row.Hash ),
				iFaithCost = pCity:GetGold():GetPurchaseCost( YIELD_FAITH, row.Hash )
			});
		end
	end
	for row in GameInfo.Buildings() do
		if pCityBuildQueue:GetBuildingProgress( row.Index ) > 0 then
			table.insert(tProductionProgressData_Buildings, {
				iPlayer = PlayerID,
				iCity = CityID,
				iBuilding = row.Index,
				iCost = pCityBuildQueue:GetBuildingCost( row.Index ),
				iProgress = pCityBuildQueue:GetBuildingProgress( row.Index ),
				iGoldCost = pCity:GetGold():GetPurchaseCost( YIELD_GOLD, row.Hash ),
				iFaithCost = pCity:GetGold():GetPurchaseCost( YIELD_FAITH, row.Hash )
			});
		end
	end
end

function SendProductionProgressData( PlayerID, CityID, purchaseType, objectType )
	if PlayerID ~= Game.GetLocalPlayer() then return; end
	local pPlayer = Players[PlayerID];
	local pCity = CityManager.GetCity(PlayerID, CityID);
	if pPlayer == nil or pCity == nil then return; end
	if purchaseType == EventSubTypes.DISTRICT then
		for i, row in pairs(tProductionProgressData_Districts) do
			if row.iPlayer == PlayerID and row.iCity == CityID and row.iDistrict == objectType and row.iProgress > 0 then
				if IsPurchasedWithGold[PlayerID] then
					GameEvents.RescueProduction.Call( PlayerID, YIELD_GOLD, row.iCost, row.iProgress, row.iGoldCost );
				elseif IsPurchasedWithFaith[PlayerID] then
					GameEvents.RescueProduction.Call( PlayerID, YIELD_FAITH, row.iCost, row.iProgress, row.iFaithCost );
				end
			end
		end
	elseif purchaseType == EventSubTypes.BUILDING then
		for i, row in pairs(tProductionProgressData_Buildings) do
			if row.iPlayer == PlayerID and row.iCity == CityID and row.iBuilding == objectType and row.iProgress > 0 then
				if IsPurchasedWithGold[PlayerID] then
					GameEvents.RescueProduction.Call( PlayerID, YIELD_GOLD, row.iCost, row.iProgress, row.iGoldCost );
				elseif IsPurchasedWithFaith[PlayerID] then
					GameEvents.RescueProduction.Call( PlayerID, YIELD_FAITH, row.iCost, row.iProgress, row.iFaithCost );
				end
			end
		end
	end
end

-- ==================================================================================================== --
-- Triggers
-- ==================================================================================================== --

function OnCityMadePurchase( PlayerID, CityID, plotX, plotY, purchaseType, objectType )
	if PlayerID == Game.GetLocalPlayer() then
		SendProductionProgressData( PlayerID, CityID, purchaseType, objectType );
		SaveProductionProgressData( PlayerID );
	end
end
Events.CityMadePurchase.Add( OnCityMadePurchase );

-- It seems that when purchasing, Event.TreasuryChanged happens before Events.CityMadePurchase --
-- Also, when Event.TreasuryChanged happens, the production progress has not yet been changed --
function OnTreasuryChanged( PlayerID, Yield, Balance )	
	if PlayerID == Game.GetLocalPlayer() then
		if Balance < iGoldHash[PlayerID] then
			SaveProductionProgressData( PlayerID );
			IsPurchasedWithGold[PlayerID] = true;
			IsPurchasedWithFaith[PlayerID] = false;
		end
		iGoldHash[PlayerID] = Players[PlayerID]:GetTreasury():GetGoldBalance() or 0;
	end
end
Events.TreasuryChanged.Add( OnTreasuryChanged );

function OnFaithChanged( PlayerID, Yield, Balance )	
	if PlayerID == Game.GetLocalPlayer() then
		if Balance < iFaithHash[PlayerID] then
			SaveProductionProgressData( PlayerID );
			IsPurchasedWithGold[PlayerID] = false;
			IsPurchasedWithFaith[PlayerID] = true;
		end
		iFaithHash[PlayerID] = Players[PlayerID]:GetReligion():GetFaithBalance() or 0;
	end
end
Events.FaithChanged.Add( OnFaithChanged );

-- Here record player gold or faith to judge whether gold or faith player purchased with --
function Initialize()
	local PlayerID = Game.GetLocalPlayer();
	if PlayerID ~= -1 then
		iGoldHash[PlayerID] = Players[PlayerID]:GetTreasury():GetGoldBalance() or 0;
		iFaithHash[PlayerID] = Players[PlayerID]:GetReligion():GetFaithBalance() or 0;
	end
end
Events.LoadGameViewStateDone.Add( Initialize );