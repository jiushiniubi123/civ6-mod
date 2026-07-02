
function SetObjectValue(object, valueName, value)
	if (object.SetProperty ~= nil) then
		object:SetProperty(valueName, value)
	end
end

function GetObjectValue(object, valueName, defaultValue)
	local value = object:GetProperty(valueName)
	if (value == nil) then return defaultValue end
	return value
end

local epsLastPlayerHeadCountTurn = 40;
local epsPlayersStillAlive = 0;

---------------------------------------------------------------------------------------------------------

function EpsTweakCatchup_OnPlayerTurnStartComplete(playerIndex)
	
	local player = Players[playerIndex];
	if (not player:IsMajor()) or (not player:IsAlive()) then
		return;
	end
	
	local treshold = 0;
	if (epsPlayersStillAlive >= 3) then treshold = epsPlayersStillAlive - 1; end
	if (epsPlayersStillAlive >= 6) then treshold = epsPlayersStillAlive - 2; end
	if (epsPlayersStillAlive >= 9) then treshold = epsPlayersStillAlive - 3; end
	if (epsPlayersStillAlive >= 12) then treshold = epsPlayersStillAlive - 3; end

	if treshold > 0 then
		local playerTechs = player:GetTechs();
		local techCatchupTable = GetObjectValue(player, "EpsTweakTechCatchupTable", {});
		for techIndex, count in pairs(techCatchupTable) do
			if (count) and (count >= treshold) and (not playerTechs:HasTech(techIndex)) and (not playerTechs:HasBoostBeenTriggered(techIndex)) then
				playerTechs:TriggerBoost(techIndex);
				NotificationManager.SendNotification(
					playerIndex,
					NotificationTypes.USER_DEFINED_5,
					Locale.Lookup("EPSTWEAK_CATCHUP_MESSAGE_NAME"),
					Locale.Lookup("EPSTWEAK_CATCHUP_MESSAGE_TEXT", GameInfo.Technologies[techIndex].Name, tostring(count)));
				techCatchupTable[techIndex] = nil;
			end
		end
		SetObjectValue(player, "EpsTweakTechCatchupTable", techCatchupTable);
		
		local playerCulture = player:GetCulture();
		local civicCatchupTable = GetObjectValue(player, "EpsTweakCivicCatchupTable", {});
		for civicIndex, count in pairs(civicCatchupTable) do
			if (count) and (count >= treshold) and (not playerCulture:HasCivic(civicIndex)) and (not playerCulture:HasBoostBeenTriggered(civicIndex)) then
				playerCulture:TriggerBoost(civicIndex);
				NotificationManager.SendNotification(
					playerIndex,
					NotificationTypes.USER_DEFINED_5,
					Locale.Lookup("EPSTWEAK_CATCHUP_MESSAGE_NAME"),
					Locale.Lookup("EPSTWEAK_CATCHUP_MESSAGE_TEXT", GameInfo.Civics[civicIndex].Name, tostring(count)));
				civicCatchupTable[civicIndex] = nil;
			end
		end
		SetObjectValue(player, "EpsTweakCivicCatchupTable", civicCatchupTable);
	end
end


function EpsTweakCatchup_ResearchComplete(playerIndex, techIndex, unknown)

	local subjectPlayer = Players[playerIndex];
	if (not subjectPlayer:IsMajor()) then
		return;
	end

	local playerTechs = nil;
	local techCatchupTable = GetObjectValue(subjectPlayer, "EpsTweakTechCatchupTable", {});
	if techCatchupTable[techIndex] then
		techCatchupTable[techIndex] = nil;
		SetObjectValue(subjectPlayer, "EpsTweakTechCatchupTable", techCatchupTable);
	end
	
	local headCount = -1;
	local turn = Game.GetCurrentGameTurn();
	if turn > epsLastPlayerHeadCountTurn then
		epsLastPlayerHeadCountTurn = turn;
		headCount = 0;
	end

	for index, player in pairs(Players) do
		if player:IsMajor() and player:IsAlive() then
			if headCount > -1 then
				headCount = headCount + 1;
			end

			playerTechs = player:GetTechs();
			if (index ~= playerIndex) and (not playerTechs:HasTech(techIndex)) and (not playerTechs:HasBoostBeenTriggered(techIndex)) then
				techCatchupTable = GetObjectValue(player, "EpsTweakTechCatchupTable", {});
				if techCatchupTable[techIndex] then
					techCatchupTable[techIndex] = techCatchupTable[techIndex] + 1;
				else
					techCatchupTable[techIndex] = 1;
				end
				SetObjectValue(player, "EpsTweakTechCatchupTable", techCatchupTable);
			end
		end
	end

	if headCount > -1 then
		epsPlayersStillAlive = headCount;
	end
end


function EpsTweakCatchup_CivicCompleted(playerIndex, civicIndex, unknown)

	local subjectPlayer = Players[playerIndex];
	if (not subjectPlayer:IsMajor()) then
		return;
	end

	local playerCulture = nil;
	local civicCatchupTable = GetObjectValue(subjectPlayer, "EpsTweakCivicCatchupTable", {});
	if civicCatchupTable[civicIndex] then
		civicCatchupTable[civicIndex] = nil;
		SetObjectValue(subjectPlayer, "EpsTweakCivicCatchupTable", civicCatchupTable);
	end
	
	for index, player in pairs(Players) do
		if player:IsMajor() and player:IsAlive() then
			playerCulture = player:GetCulture();
			if (index ~= playerIndex) and (not playerCulture:HasCivic(civicIndex)) and (not playerCulture:HasBoostBeenTriggered(civicIndex)) then
				civicCatchupTable = GetObjectValue(player, "EpsTweakCivicCatchupTable", {});
				if civicCatchupTable[civicIndex] then
					civicCatchupTable[civicIndex] = civicCatchupTable[civicIndex] + 1;
				else
					civicCatchupTable[civicIndex] = 1;
				end
				SetObjectValue(player, "EpsTweakCivicCatchupTable", civicCatchupTable);
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------
 
GameEvents.PlayerTurnStartComplete.Add(EpsTweakCatchup_OnPlayerTurnStartComplete)
Events.ResearchCompleted.Add(EpsTweakCatchup_ResearchComplete)
Events.CivicCompleted.Add(EpsTweakCatchup_CivicCompleted)
print("Loaded")