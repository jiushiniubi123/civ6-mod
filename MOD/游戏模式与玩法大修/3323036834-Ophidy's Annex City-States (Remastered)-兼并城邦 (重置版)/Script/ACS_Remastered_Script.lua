-- ACS_Remastered_Script
-- Author: Ophidy
-- DateCreated: 8/31/2024 7:47:03 PM
--------------------------------------------------------------
include("GameCapabilities");

-- ===========================================================================
--	Misc
-- ===========================================================================
local debug						:boolean		=		true

local AnnexThreshold			:number			=		GameConfiguration.GetValue("ACSR_THRESHOLD") or 7
local AnnexDiff					:number			=		GameConfiguration.GetValue("ACSR_GROWTH") or 2
local m_CivitasCSEActive						=		function() if GameInfo.CSE_ClassTypes then return true else return false end end

local m_kCityStateModifiers		:table

function SortCityStates()

	m_kCityStateModifiers = {}
	
	if not m_CivitasCSEActive() then
		for row_Leader in GameInfo.Leaders() do
			local kTraits			=	{}
			local kModifiers		= 	{}
			local kBonuses			=	{}
			if row_Leader.InheritFrom and string.find(row_Leader.InheritFrom,'LEADER_MINOR_') and row_Leader.InheritFrom ~= 'LEADER_MINOR_CIV_DEFAULT' then
				local LeaderType = row_Leader.LeaderType
				
				for row_LeaderTrait in GameInfo.LeaderTraits() do
					if row_LeaderTrait.LeaderType == LeaderType or row_LeaderTrait.LeaderType == GameInfo.Leaders[LeaderType].InheritFrom then
						table.insert(kTraits, row_LeaderTrait.TraitType)
					end
				end

				for row_TraitModifier in GameInfo.TraitModifiers() do 
					for i, Trait in ipairs(kTraits) do
						if row_TraitModifier.TraitType == Trait then
							table.insert(kModifiers, row_TraitModifier.ModifierId)
						end
					end
				end

				for row_Modifier in GameInfo.Modifiers() do
					for i, TraitMod in ipairs(kModifiers) do
						if (row_Modifier.ModifierId == TraitMod and row_Modifier.ModifierType == 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER' and row_Modifier.SubjectRequirementSetId == 'PLAYER_IS_SUZERAIN') then
							for row_ModifierArgument in GameInfo.ModifierArguments() do
								if row_ModifierArgument.ModifierId == row_Modifier.ModifierId and row_ModifierArgument.Name == 'ModifierId' then
									--if debug then print(row_ModifierArgument.ModifierId) end
									table.insert(kBonuses, row_ModifierArgument.Value)
								end
							end
						end
					end
				end
				
				for row_Modifier in GameInfo.Modifiers() do
					for i, TraitMod in ipairs(kModifiers) do
						if (row_Modifier.ModifierId == TraitMod and row_Modifier.SubjectRequirementSetId and row_Modifier.SubjectRequirementSetId ~= 'PLAYER_IS_SUZERAIN') or (row_Modifier.ModifierId == TraitMod and not row_Modifier.SubjectRequirementSetId) then
							if string.find(row_Modifier.ModifierId, 'SMALL_INFLUENCE') or string.find(row_Modifier.ModifierId, 'MEDIUM_INFLUENCE') or string.find(row_Modifier.ModifierId, 'LARGE_INFLUENCE') then
								for row_ModifierArgument in GameInfo.ModifierArguments() do
									if row_ModifierArgument.ModifierId == row_Modifier.ModifierId and row_ModifierArgument.Name == 'ModifierId' then
										--if debug then print(row_ModifierArgument.ModifierId) end
										table.insert(kBonuses, row_ModifierArgument.Value)
									end
								end
							end
						end
					end
				end
				m_kCityStateModifiers[LeaderType] = kBonuses
			end
		end
		
	elseif m_CivitasCSEActive() then
		for row_Leader in GameInfo.Leaders() do
			local kTraits			=	{}
			local kModifiers		= 	{}
			local kBonuses			=	{}
			if row_Leader.InheritFrom and string.find(row_Leader.InheritFrom,'LEADER_MINOR_') and row_Leader.InheritFrom ~= 'LEADER_MINOR_CIV_DEFAULT' then
				local LeaderType = row_Leader.LeaderType
				
				for row_LeaderTrait in GameInfo.LeaderTraits() do
					if row_LeaderTrait.LeaderType == LeaderType or row_LeaderTrait.LeaderType == GameInfo.Leaders[LeaderType].InheritFrom then
						table.insert(kTraits, row_LeaderTrait.TraitType)
					end
				end

				for row_TraitModifier in GameInfo.TraitModifiers() do 
					for i, Trait in ipairs(kTraits) do
						if row_TraitModifier.TraitType == Trait then
							table.insert(kModifiers, row_TraitModifier.ModifierId)
						end
					end
				end

				for row_Modifier in GameInfo.Modifiers() do
					for i, TraitMod in ipairs(kModifiers) do
						if (row_Modifier.ModifierId == TraitMod and row_Modifier.ModifierType == 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER' and row_Modifier.SubjectRequirementSetId == 'PLAYER_IS_SUZERAIN') then
							for row_ModifierArgument in GameInfo.ModifierArguments() do
								if row_ModifierArgument.ModifierId == row_Modifier.ModifierId and row_ModifierArgument.Name == 'ModifierId' then
									--if debug then print(row_ModifierArgument.ModifierId) end
									table.insert(kBonuses, row_ModifierArgument.Value)
								end
							end
						end
					end
				end
				
				for row_Modifier in GameInfo.Modifiers() do
					for i, TraitMod in ipairs(kModifiers) do
						if (row_Modifier.ModifierId == TraitMod and row_Modifier.SubjectRequirementSetId and row_Modifier.SubjectRequirementSetId ~= 'PLAYER_IS_SUZERAIN') or (row_Modifier.ModifierId == TraitMod and not row_Modifier.SubjectRequirementSetId) then
							if not string.find(row_Modifier.ModifierId, 'SEND_TRADE') then
								for row_ModifierArgument in GameInfo.ModifierArguments() do
									if row_ModifierArgument.ModifierId == row_Modifier.ModifierId and row_ModifierArgument.Name == 'ModifierId' then
										--if debug then print(row_Modifier.ModifierId) end
										table.insert(kBonuses, row_ModifierArgument.Value)
									end
								end
							end
						end
					end
				end
				m_kCityStateModifiers[LeaderType] = kBonuses
			end
		end
	end
end

-- ===========================================================================
-- Civilization Trait
-- ===========================================================================
function ACSR_AnnexCityState(iPlayer, kParams)
	local iMinor		=	kParams.iMinor
	local Currency		=	kParams.Currency 
	local Cost			=	kParams.Cost 
	local iMajor		=	iPlayer
	local pMinor		=	Players[iMinor]
	local pPlayer		=	Players[iPlayer]
	local pConfig		=	PlayerConfigurations[iMinor]
	local LeaderType	=	pConfig:GetLeaderTypeName()
	local pMajor		=	Players[iMajor]
	local kAnnexed 		= 	pMajor:GetProperty('ANNEXED_STATES') or {}
	local pCity			=	pMinor:GetCities():GetCapitalCity();
	local iX, iY		=	pCity:GetX(), pCity:GetY()
	local kMinor		=	{}
	kMinor.iPlayer		=	kParams.iMinor
	kMinor.X			=	iX
	kMinor.Y			=	iY

	local PlayerThreshold = pMajor:GetProperty('AnnexThreshold') or AnnexThreshold

	if not kParams.FreeAnnex then
		pMajor:SetProperty('AnnexThreshold', PlayerThreshold+AnnexDiff)
	end

	if debug then print('Annex Launch', LeaderType) end
	
	-- Destroy the City-State (city and all its units are gone)
	Cities.DestroyCity(pCity)
	
	-- Permanently attach the City-State bonuses to the player
	for i, Bonus in ipairs(m_kCityStateModifiers[LeaderType]) do
		if debug then print('Attaching bonus to player:', Bonus) end
		pPlayer:AttachModifierByID(Bonus)
	end

	-- Deduct cost
	if Currency == 'Gold' then
		pPlayer:GetTreasury():ChangeGoldBalance(-Cost)
	elseif Currency == 'Faith' then
		pPlayer:GetReligion():ChangeFaithBalance(-Cost)
	elseif Currency == 'Favor' then
		pPlayer:GetDiplomacy():ChangeFavor(-Cost)
	end
	
	-- Spawn a Settler in the Capital
	local pCapital = pPlayer:GetCities():GetCapitalCity()
	if pCapital then
		UnitManager.InitUnit(pPlayer, "UNIT_SETTLER", pCapital:GetX(), pCapital:GetY())
		if debug then print('Settler spawned in capital') end
	end
	
	-- Record the annexation (no city to manage, so IsAssimilated = true)
	kMinor.iCity			=	-1
	kMinor.IsAssimilated	= 	true
	table.insert(kAnnexed, kMinor)

	pMajor:SetProperty('ANNEXED_STATES', kAnnexed)
end

-- ACSR_ReleaseCityState, CityRemovedFromMap, ACSR_AssimilateCityState removed — 
-- City-States are now destroyed on annex, no city management needed.

-- ===========================================================================
-- Initialize
-- ===========================================================================
function Initialize()
	GameEvents.ACSR_AnnexCityState.Add(ACSR_AnnexCityState)
	
	SortCityStates()
end

Initialize();

include('ACSR_Script_',true)