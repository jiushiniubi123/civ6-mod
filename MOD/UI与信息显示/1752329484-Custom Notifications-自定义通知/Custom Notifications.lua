
ExposedMembers.GameEvents = GameEvents;
local tLocalPlayers = {};
-- local iLocalPlayer = Game:GetLocalPlayer();
local iCityPopChangedNotificationHash = NotificationTypes.USER_DEFINED_9;
local iCityGrowthNotificationHash = NotificationTypes.USER_DEFINED_8;
local iDealExpiredNotificationHash = NotificationTypes.USER_DEFINED_7;
local pCityPopUp = nil;
-- local iSettler = GameInfo.Units["UNIT_SETTLER"].Index; 
local bCityPopNotification;
local sCityPopTitle = Locale.Lookup('LOC_CN_CITY_POP_TITLE');


local function OnCityPopulationChanged( iPlayerID, iCityID, iChangeAmount )

	if tLocalPlayers[iPlayerID] then
		if iChangeAmount > 0 then 
			local pCity = CityManager.GetCity(iPlayerID, iCityID);
		-- local pCityCenter = districts:GetDistrictAtLocation(pCity:GetX(), pCity:GetY());
			-- local pCityPlot = Map.GetPlot( pCity:GetX(), pCity:GetY() );
			local sCityName = Locale.Lookup(pCity:GetName());
			-- print("OnCityPopulationChanged: "..sCityName, iChangeAmount);
			NotificationManager.SendNotification(iPlayerID, iCityPopChangedNotificationHash, sCityPopTitle, Locale.Lookup("LOC_CN_CITY_POP_MESSAGE", sCityName), pCity:GetX(), pCity:GetY());
		-- elseif iChangeAmount < 0 then
			-- local pCity = CityManager.GetCity(iPlayerID, iCityID); -- GetJustConqueredFrom
			-- local sCityName = Locale.Lookup(pCity:GetName());
			-- print("OnCityPopulationChanged: "..sCityName, iChangeAmount);
			-- NotificationManager.SendNotification(iPlayerID, iCityPopChangedNotificationHash, "Population  of  "..sCityName.."  decreases", '', pCity:GetX(), pCity:GetY());
		end
	end
end


local function OnLocalPlayerTurnEnd()
	-- works for all players in hotseat
	-- print("OnLocalPlayerTurnEnd");
	-- if bCityBorderNotification then
		-- Events.CityTileOwnershipChanged.Add( OnCityTileOwnershipChanged );
	-- end
		GameEvents.OnCityPopulationChanged.Add( OnCityPopulationChanged ); 
end


local function OnPlayerTurnActivated ( iPlayerID, someBoolean)

	if tLocalPlayers[iPlayerID] then
		-- print("OnPlayerTurnActivated", iPlayerID);

		-- CityTileOwnershipChanged fires when player founds city so dont listen when turn is active
		-- Events.CityTileOwnershipChanged.Remove( OnCityTileOwnershipChanged );

		-- CityPopulationChanged fires when player founds or conquers a city so dont listen when turn is active
		GameEvents.OnCityPopulationChanged.Remove( OnCityPopulationChanged ); 
	end
end


local function OnGoodyHutReward(iPlayerID, iUnitID, iGoodyHutHash, iSubTypeHash)
	-- local GoodyHut = GameInfo.GoodyHuts[iGoodyHutHash];
	-- print('OnGoodyHutReward ', GoodyHut.GoodyHutType );
	if tLocalPlayers[iPlayerID] and pCityPopUp and iGoodyHutHash == 1892398955 and iSubTypeHash == 1038837136 then
		-- print('OnGoodyHutReward pop up reward');
		sCityName = Locale.Lookup(pCityPopUp:GetName());
		NotificationManager.SendNotification(iPlayerID, iCityPopChangedNotificationHash, sCityPopTitle, Locale.Lookup('LOC_CN_CITY_POP_MESSAGE_1', sCityName), pCityPopUp:GetX(), pCityPopUp:GetY());
	end
	pCityPopUp = nil; 
end

-- fires before OnImprovementActivated and OnGoodyHutReward !!!
local function GoodyHutCityPopulationChanged( iPlayerID, iCityID, iNewPopulation )

	if tLocalPlayers[iPlayerID] then
		-- print("GoodyHutCityPopulationChanged");
		pCityPopUp = CityManager.GetCity(iPlayerID, iCityID);
	end
end


local function GetHumanPlayers() 
	for iPlayer = 0, PlayerManager.GetWasEverAliveCount() - 1 do
	local pPlayer = Players[iPlayer];
		if pPlayer and pPlayer:IsHuman() then
			tLocalPlayers[iPlayer] = true;
			-- print(Locale.Lookup(PlayerConfigurations[iPlayer]:GetLeaderName()),' is human');
		end
	end
end


local function ToggleCityPopNotification() 
	bCityPopNotification = not bCityPopNotification;
	Events.LocalPlayerTurnEnd.Remove( OnLocalPlayerTurnEnd );
	Events.PlayerTurnActivated.Remove( OnPlayerTurnActivated ); 
	Events.CityPopulationChanged.Remove( GoodyHutCityPopulationChanged );
	Events.GoodyHutReward.Remove(OnGoodyHutReward);
	if bCityPopNotification then
		Events.CityPopulationChanged.Add( GoodyHutCityPopulationChanged );
		Events.GoodyHutReward.Add(OnGoodyHutReward);
		Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
		Events.PlayerTurnActivated.Add( OnPlayerTurnActivated ); 
	end
end


local function Initialize() 
	GetHumanPlayers();
	bCityPopNotification = GameConfiguration.GetValue('CN_bCityPopNotification');
	if bCityPopNotification == nil then 
		bCityPopNotification = true;
	end

	if bCityPopNotification then
		Events.CityPopulationChanged.Add( GoodyHutCityPopulationChanged );
		Events.GoodyHutReward.Add(OnGoodyHutReward);
		Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
		Events.PlayerTurnActivated.Add( OnPlayerTurnActivated ); 
	end

	GameEvents.ToggleCityPopNotificationEvent.Add(ToggleCityPopNotification);
	-- GameEvents.OnCityPopulationChanged.Add( OnCityPopulationChanged ); 
	-- Events.ImprovementAddedToMap.Add( OnImprovementAddedToMap );
	print('CUSTOM NOTIFICATIONS STARTED.');
end
Events.LoadGameViewStateDone.Add(Initialize);

-- Locale.Lookup("LOC_CIVIC_ENVOY_AWARDED_TOOLTIP", numValue)

-- local function OnImprovementAddedToMap(iX, iY, improvementType, iImprovementOwner, resource, isPillaged, isWorked)
	-- if improvementType == iBarbCamp then
		-- local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility(iLocalPlayer);

		-- if pLocalPlayerVis ~= nil and pLocalPlayerVis:IsRevealed(Map.GetPlot(iX,iY)) then
			-- print("Barb camp added to map.");
			-- NotificationManager.SendNotification(iPlayerID, iBarbCampSpottedNotificationHash, 'Barbarian  camp  spotted','', iX, iY);
		-- end
	-- end
-- end

