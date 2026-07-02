local player_traits_cache = {}
local player_uniqueDistricts_cache = {}
local player_relativeBuildings_cache = {}
local units_earnable_cache = {}
local index_trait_cache = {}
local baseBuildings = nil

function UniqueDistrictFinder (playerID, DistrictType)
	local uniqueDistricts = {}
	if player_uniqueDistricts_cache[playerID] and player_uniqueDistricts_cache[playerID][DistrictType] then
		uniqueDistricts = player_uniqueDistricts_cache[playerID][DistrictType]
	else
		player_uniqueDistricts_cache[playerID] = player_uniqueDistricts_cache[playerID] or {} 
    
		for _, item in ipairs(GameInfo.Districts[DistrictType].ReplacedByCollection) do
			local UniqueDistrictType = item.CivUniqueDistrictType
			if HasTrait (playerID, GameInfo.Districts[UniqueDistrictType].TraitType) then
				table.insert(uniqueDistricts, GameInfo.Districts[UniqueDistrictType].Index)
			end
		end
	end

    if #uniqueDistricts > 0 then
		player_uniqueDistricts_cache[playerID] = uniqueDistricts
        return uniqueDistricts[Game.GetRandNum(#uniqueDistricts)+1]
    else
		table.insert(uniqueDistricts, GameInfo.Districts[DistrictType].Index)
		player_uniqueDistricts_cache[playerID] = uniqueDistricts
        return uniqueDistricts[1]
    end
end

function GetBaseBuildings()
	if baseBuildings then
		return baseBuildings
	end

	local buildings = {}
	for row in GameInfo.Buildings() do
		if row.PrereqDistrict == "DISTRICT_ENCAMPMENT" or row.PrereqDistrict == "DISTRICT_HARBOR" or row.PrereqDistrict == "DISTRICT_AERODROME" then
			if row.TraitType == nil then
				table.insert(buildings, row.Index)
			else 
				index_trait_cache[row.Index] = row.TraitType 
			end
		end
	end

	baseBuildings = buildings
	return buildings
end

function GetRelativeBuildings(playerID)
	if player_relativeBuildings_cache[playerID] then
		return player_relativeBuildings_cache[playerID]
	end

	local relativeBuildings = GetBaseBuildings()
    local config = PlayerConfigurations[playerID]
    if (config == nil) then 
		player_relativeBuildings_cache[playerID] = relativeBuildings
		return relativeBuildings
	end

	for index, trait in pairs(index_trait_cache) do
		if HasTrait(playerID, trait) then
			table.insert(relativeBuildings, index)
		end
	end

	player_relativeBuildings_cache[playerID] = relativeBuildings    
    return relativeBuildings
end

function StoreBuildingCount(table, x, y, buildingCount)
	local key = x .. "|" .. y
	table[key] = buildingCount
end

function GetBuildingCount(table, x, y)
	local key = x .. "|" .. y
	return table[key]
end

function HasTrait(playerID, traitName)
	if playerID == nil then playerID = Game.GetLocalPlayer() end
	if playerID == -1 then return false end

	if player_traits_cache[playerID] then
		for _, trait in ipairs(player_traits_cache[playerID]) do
			if trait == traitName then return true end
		end
	end
		
	local config = PlayerConfigurations[playerID]
	if config then
		local leaderType = config:GetLeaderTypeName()
		local civType = config:GetCivilizationTypeName()
		if civType and leaderType then
			player_traits_cache[playerID] = player_traits_cache[playerID] or {}

			for row in GameInfo.CivilizationTraits() do
				if row.TraitType == traitName and row.CivilizationType == civType then
					table.insert(player_traits_cache[playerID], traitName)
					return true
				end
			end

			for row in GameInfo.LeaderTraits() do
				if row.TraitType == traitName and row.LeaderType == leaderType then
					table.insert(player_traits_cache[playerID], traitName)
					return true
				end
			end
		end
	end
	return false
end

function CanUnitEarnExperience(unitType)
	if units_earnable_cache[unitType] then
		return units_earnable_cache[unitType]
	end

	local unitInfo = GameInfo.Units[unitType]
	if unitInfo then
		units_earnable_cache[unitType] = unitInfo.CanEarnExperience
		return unitInfo.CanEarnExperience
	else return false end
end

function OnUnitAttack(combatInfo)
	if combatInfo then
		local attackerInfo = combatInfo[CombatResultParameters.ATTACKER][CombatResultParameters.ID]
		local unit = UnitManager.GetUnit(attackerInfo.player, attackerInfo.id)
		if unit and CanUnitEarnExperience(unit:GetType()) then
			if not unit:GetProperty("OOActivated") then
				unit:SetProperty("OOActivated", true)
			end
		end
	end
end

function OnUnitDamaged(playerID, unitID, nowDmg, preDmg)
	if (nowDmg > preDmg) then
		local player = Players[playerID]
		if player then
			local unit = player:GetUnits():FindID(unitID)
			if unit and CanUnitEarnExperience(unit:GetType()) then
				if not unit:GetProperty("OOActivated") then
					unit:SetProperty("OOActivated", true)
				end
			end
		end
	end
end

function OnUnitMove(playerID, unitID, a, b)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit and CanUnitEarnExperience(unit:GetType()) then
			if not unit:GetProperty("OOActivated") then
				unit:SetProperty("OOActivated", true)
			end
		end
	end
end

function OnUnitBuild(playerID, unitID, a, b)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit and CanUnitEarnExperience(unit:GetType()) then
			if not unit:GetProperty("OOActivated") then
				unit:SetProperty("OOActivated", true)
			end
		end
	end
end


function OnUnitCreated(playerID, unitID)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit and CanUnitEarnExperience(unit:GetType()) then
			unit:SetProperty("OONewlyCreated", true)
			unit:SetProperty("OftenStack", { PromotedTimes = 0 })
		end
	end
end

function OnUnitPromotionAvailable(playerID, unitID, a)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit and unit:GetProperty("OONewlyCreated") then
			local OftenStack = unit:GetProperty("OftenStack")
			OftenStack.FreePromoted = true
			unit:SetProperty("OftenStack", OftenStack)
		end
	end
end

function OnUnitPromoted(playerID, unitID)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit then
			local OftenStack = unit:GetProperty("OftenStack")
			OftenStack.PromotedTimes = OftenStack.PromotedTimes + 1
			unit:SetProperty("OftenStack", OftenStack)
		end
	end
end

function OnUnitFormationChanged(playerID, unitID)
	local player = Players[playerID]
	if player then
		local unit = player:GetUnits():FindID(unitID)
		if unit then
			local OftenStack = unit:GetProperty("OftenStack")
			OftenStack.FormerPromotedTimes = OftenStack.PromotedTimes
			unit:SetProperty("OftenStack", OftenStack)
		end
	end
end

function OnPlayerTurnBegin(playerID)
	local player = Players[playerID]
	if player then
		for _, unit in player:GetUnits():Members() do
			if unit and CanUnitEarnExperience(unit:GetType()) then
				local shouldUpdate = false
				local OftenStack = unit:GetProperty("OftenStack") or {}
				if (OftenStack.PromotedTimes == nil) then
					shouldUpdate = true
					local experience = unit:GetExperience()
					local currentPoint = experience:GetExperiencePoints()
					local promotedTimes = 0
					if currentPoint >= 150 then promotedTimes = 4
					elseif currentPoint >= 90 then promotedTimes = 3
					elseif currentPoint >= 45 then promotedTimes = 2
					elseif currentPoint >= 15 then promotedTimes = 1
					end
					if experience:CanPromote() then
						promotedTimes = promotedTimes - 1
					end
					OftenStack.PromotedTimes = promotedTimes
				end
				if (OftenStack.FormerPromotedTimes ~= nil) then
					shouldUpdate = true
					--Game.AddWorldViewText(0, string.format("Former:%d, Now:%d", OftenStack.FormerPromotedTimes, OftenStack.PromotedTimes), unit:GetX(), unit:GetY())  --展示合并结果
					local another = OftenStack.PromotedTimes - OftenStack.FormerPromotedTimes
					if (OftenStack.FormerPromotedTimes > another) then
						another = OftenStack.FormerPromotedTimes
					end
					OftenStack.PromotedTimes = another
					OftenStack.FormerPromotedTimes = nil
				end
				if shouldUpdate then unit:SetProperty("OftenStack", OftenStack) end
			end
		end
	end
end

function OnTurnBegin()
	for _, playerID in ipairs(PlayerManager.GetWasEverAliveMajorIDs()) do
		local player = Players[playerID]
		if player then
			for _, unit in player:GetUnits():Members() do
				if unit and CanUnitEarnExperience(unit:GetType()) then
					unit:SetProperty("OONewlyCreated", nil)
					unit:SetProperty("OOActivated", false)
				end
			end
		end
	end
end

local promotedTimes_reductionPoint_table = {
	[0] = 0,
	[1] = 2,
	[2] = 3,
	[3] = 4,
	[4] = 5
}

function OnTurnEnd()
	for _, playerID in ipairs(PlayerManager.GetWasEverAliveMajorIDs()) do
		local player = Players[playerID]
		if player then
			local ENCAMPMENT = UniqueDistrictFinder(playerID, "DISTRICT_ENCAMPMENT")
			local HARBOR = UniqueDistrictFinder(playerID, "DISTRICT_HARBOR")
			local AERODROME = UniqueDistrictFinder(playerID, "DISTRICT_AERODROME")
			local relativeBuildings = GetRelativeBuildings(playerID)
			local location_buildingCount_table = {}

			for _, unit in player:GetUnits():Members() do
				if unit and (not unit:GetProperty("OOActivated")) then
					local unitType = unit:GetType()
					if CanUnitEarnExperience(unitType) then
						local X = unit:GetX()
						local Y = unit:GetY()
						local plot = Map.GetPlot(X, Y)
						local plotIndex = plot:GetIndex()
						if (plot ~= nil) and (playerID == plot:GetOwner()) then
							local districtType = plot:GetDistrictType()
							local baseXP = 0
							local formation = GameInfo.Units[unitType].FormationClass
							if formation == "FORMATION_CLASS_LAND_COMBAT" and districtType == ENCAMPMENT then baseXP = 2
							elseif formation == "FORMATION_CLASS_NAVAL" and districtType == HARBOR then baseXP = 2
							elseif formation == "FORMATION_CLASS_AIR" and districtType == AERODROME then baseXP = 1
							end
							if (baseXP > 0) then
								local city = Cities.GetPlotPurchaseCity(plot)
								local district = CityManager.GetDistrictAt(X, Y)
								if (district ~= nil) and district:IsComplete() and (not district:IsPillaged()) and districtType and (districtType ~= -1) then
									local OftenStack = unit:GetProperty("OftenStack")
									local promotedTimes = OftenStack.PromotedTimes
									if OftenStack.FreePromoted then
										promotedTimes = promotedTimes - 1
									end
									if promotedTimes < 0 then
										promotedTimes = 0
									elseif promotedTimes > 4 then
										promotedTimes = 4
									end

									local buildingCount = GetBuildingCount(location_buildingCount_table, X, Y)
									if (buildingCount == nil) then
										buildingCount = 0
										local buildings = city:GetBuildings()
										--ShowBuildingNameWithIndex(city, city:GetX(), city:GetY(), plotIndex)  --显示相关建筑的索引
										for _, building in ipairs(relativeBuildings) do
											if buildings:HasBuilding(building) then	
												if (buildings:GetBuildingLocation(building) == plotIndex) and (not buildings:IsPillaged(building)) then
													buildingCount = buildingCount + 1
												end
											end
										end
										StoreBuildingCount(location_buildingCount_table, X, Y, buildingCount)
									end

									local totalXP = baseXP + buildingCount - promotedTimes_reductionPoint_table[promotedTimes]
									if totalXP < 0 then totalXP = 0 end
									--Game.AddWorldViewText(0, string.format("Exp +%d", totalXP), X, Y)  --显示所有单位（包括其它文明的单位）本回合获取的经验值
									unit:GetExperience():ChangeExperience(totalXP)
								end
							end
						end
					end
				end
			end
		end
	end
end

function Init()
	GameEvents.PlayerTurnStartComplete.Add(OnPlayerTurnBegin)
	Events.TurnBegin.Add(OnTurnBegin)
	Events.TurnEnd.Add(OnTurnEnd)
	Events.Combat.Add(OnUnitAttack)
	Events.UnitDamageChanged.Add(OnUnitDamaged)
	Events.UnitMoveComplete.Add(OnUnitMove)
	Events.UnitChargesChanged.Add(OnUnitBuild)
	Events.UnitAddedToMap.Add(OnUnitCreated)
	Events.UnitPromotionAvailable.Add(OnUnitPromotionAvailable)
	Events.UnitPromoted.Add(OnUnitPromoted)
	Events.UnitFormCorps.Add(OnUnitFormationChanged)
	Events.UnitFormArmy.Add(OnUnitFormationChanged)
end

Events.LoadGameViewStateDone.Add(Init)