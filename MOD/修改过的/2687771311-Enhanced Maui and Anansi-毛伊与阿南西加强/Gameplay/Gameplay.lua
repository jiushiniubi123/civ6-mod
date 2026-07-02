-- Gameplay
-- Author: Konomi (modified)
-- DateCreated: 11/13/2021 15:27:14
--------------------------------------------------------------

---------------------------------------------------------------
-- General
---------------------------------------------------------------

function InitilizeGameProperties()
	for row in GameInfo.TypeProperties() do
		if row.Type == 'UNITCOMMAND_RESOURCE_INSPIRE' then
			if row.Name == 'RESOURCE_INSPIRE_SCIENCE' then
				Game:SetProperty('inspire_science', row.Value)	
			elseif row.Name == 'RESOURCE_INSPIRE_CULTURE' then
				Game:SetProperty('inspire_culture', row.Value)	
			elseif row.Name == 'PROGRESSION_PARAM1' then
				Game:SetProperty('inspire_param1', row.Value)	
			end	
		end
	end

	local bonusResources = {}
	for row in GameInfo.Resources() do
		if row.ResourceClassType == 'RESOURCECLASS_BONUS' then
			if row.Frequency > 0 or row.SeaFrequency > 0 then
				table.insert(bonusResources, row.Index)
			end
		end
	end
	Game:SetProperty('bonus_resources', bonusResources)
end

function GetCurrentParam()
	local era = Game.GetEras():GetCurrentEra()
	local science = Game:GetProperty('inspire_science')
	if science == nil then
		InitilizeGameProperties()
		science = Game:GetProperty('inspire_science')
	end
	local culture = Game:GetProperty('inspire_culture')
	local param1 = Game:GetProperty('inspire_param1')

	local iSpeed = GameConfiguration.GetGameSpeedType()
	local multiplier = GameInfo.GameSpeeds[iSpeed].CostMultiplier

	local ret = {
		['science'] = (science + era * param1) * multiplier / 100,
		['culture'] = (culture + era * param1) * multiplier / 100,
	}
	return ret
end

function ChangeActionCharges(iPlayer, iUnitID, delta)
	local pUnit = UnitManager.GetUnit(iPlayer, iUnitID)
	pUnit:ChangeActionCharges(delta)
	UnitManager.FinishMoves(pUnit)
end

--Create By HaoJun0823
--It can be used in multiplayer online, and the UI is synchronized.
function myRandom(min, max)

	local playerIDS = PlayerManager.GetAliveIDs();
	local turn = Game.GetCurrentGameTurn();
	local result = 0;
	
	for i, playerId in ipairs(playerIDS) do
		local pPlayer = Players[playerId];
		local playerConfig = PlayerConfigurations[playerId];		
		if pPlayer:IsMajor() and pPlayer:IsAlive() then
			for i, pCity in pPlayer:GetCities():Members() do
				if turn % 2 ~= 0 then
					result = result + pCity:GetGrowth():GetTurnsUntilGrowth();
					result = result - pCity:GetGrowth():GetHappiness();
					result = result + pCity:GetGrowth():GetFoodSurplus();
					result = result - pCity:GetGrowth():GetHousing();					
				else
					result = result - pCity:GetGrowth():GetTurnsUntilGrowth();
					result = result + pCity:GetGrowth():GetHappiness();
					result = result - pCity:GetGrowth():GetFoodSurplus();
					result = result + pCity:GetGrowth():GetHousing();					
				end
			end
		end
	end
	--print("Random Result Seed:"..result);	
	return math.floor(math.abs(result)) % max + min
end

---------------------------------------------------------------
-- Maui
---------------------------------------------------------------

function AddRandomBonusResource(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	local bonusResources = Game:GetProperty('bonus_resources')
	if bonusResources == nil then
		InitilizeGameProperties()
		bonusResources = Game:GetProperty('bonus_resources')
	end
	local len = #bonusResources
	local ran = myRandom(1, len)
	local resourceIndex = bonusResources[ran]
	ResourceBuilder.SetResourceType(pPlot, resourceIndex, 1)
end

function CanAddResource(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	if pPlot:GetDistrictID() ~= -1 or pPlot:GetImprovementType() ~= -1 then
		return 'BLANK'
	end
	if pPlot:GetResourceCount() > 0 then
		return 'RESOURCE'
	end
	if pPlot:IsNationalPark() or pPlot:IsNaturalWonder() then
		return 'BLANK'
	end
	return ''
end

---------------------------------------------------------------
-- Anansi
---------------------------------------------------------------

function RemoveResource(iX, iY)
	local pPlot = Map.GetPlot(iX, iY)
	ImprovementBuilder.SetImprovementType(pPlot, -1, 0)
	ResourceBuilder.SetResourceType(pPlot, -1)
end

function AddScienceCulture(playerID, iX, iY)
	local pPlayer = Players[playerID]
	local params = GetCurrentParam()

	local science = params['science']
	pPlayer:GetTechs():ChangeCurrentResearchProgress(science)
	local message = '[COLOR:ResScienceLabelCS]+' .. tostring(science) .. '[ENDCOLOR][ICON_Science]'
	Game.AddWorldViewText(0, message, iX, iY)

	local culture = params['culture']
	pPlayer:GetCulture():ChangeCurrentCulturalProgress(culture)
	message = '[COLOR:ResCultureLabelCS]+' .. tostring(culture) .. '[ENDCOLOR][ICON_Culture]'
	Game.AddWorldViewText(0, message, iX, iY)
end


if ExposedMembers.SOTS == nil then
	ExposedMembers.SOTS = {}
end

-- General
ExposedMembers.SOTS.ChangeActionCharges = ChangeActionCharges
ExposedMembers.SOTS.GetCurrentParam = GetCurrentParam

-- Maui
ExposedMembers.SOTS.AddRandomBonusResource = AddRandomBonusResource
ExposedMembers.SOTS.CanAddResource = CanAddResource

-- Anansi
ExposedMembers.SOTS.RemoveResource = RemoveResource
ExposedMembers.SOTS.AddScienceCulture = AddScienceCulture