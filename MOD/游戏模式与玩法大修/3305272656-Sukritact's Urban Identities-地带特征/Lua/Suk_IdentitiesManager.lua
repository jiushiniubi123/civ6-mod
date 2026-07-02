-- Suk_RegionManager.lua
-- Author: Sukritact
-- DateCreated: 5/3/2024 2:33:52 PM
--===========================================================================
-- Load Values to Cache
--===========================================================================
	ExposedMembers.Suk_UrbanIdentities_Regions		= Game:GetProperty("Suk_UrbanIdentities_Regions")
	ExposedMembers.Suk_UrbanIdentities_PlotCache	= Game:GetProperty("Suk_UrbanIdentities_RegionPlotIndex")
	ExposedMembers.Suk_UrbanIdentities_Cities		= Game:GetProperty("Suk_UrbanIdentities_Cities") or {}

	-- Thankfully Lua Tables are just Pointers, so we can make aliases
	local tRegions			= ExposedMembers.Suk_UrbanIdentities_Regions
	local tPlotCache		= ExposedMembers.Suk_UrbanIdentities_PlotCache
	local tCities			= ExposedMembers.Suk_UrbanIdentities_Cities
--===========================================================================
-- Utility Functions
--===========================================================================
	function CompositeCityID(iPlayer, iCity)
		return string.format("P%dC%d", iPlayer, iCity)
	end

	function DecompositeCityID(sCity)
		local iPlayer, iCity = string.match(sCity, "P(%d+)C(%d+)")
		iPlayer	= tonumber(iPlayer)
		iCity	= tonumber(iCity)
		return iPlayer, iCity
	end
--===========================================================================
-- Identity Management
--===========================================================================
	function AssignIdentity(iPlayer, iCity, sIdentityType)
		------------------------------------------
		-- Insert Identity into the City's Identity list
		------------------------------------------
		local sCity = CompositeCityID(iPlayer, iCity)
		if tCities[sCity].Identities[sIdentityType] then return end

		tCities[sCity].Identities[sIdentityType] = true
		table.insert(tCities[sCity].IdentitiesArray, sIdentityType)
		------------------------------------------
		-- Attach Modifiers
		------------------------------------------
		local pCity = CityManager.GetCity(iPlayer, iCity)
		if pCity then
			local tRows = DB.Query(
				"SELECT ModifierId from Suk_UrbanIdentity_Modifiers WHERE IdentityType = ?",
				sIdentityType
			)
			for _, tRow in ipairs(tRows) do
				pCity:AttachModifierByID(tRow.ModifierId)
			end
		end
		------------------------------------------
		-- Plot Properties
		------------------------------------------
		local tRows = DB.Query(
			[[
				SELECT * FROM Suk_UrbanIdentity_PlotProperties WHERE IdentityType = ? AND CityOnly
			]],
			sIdentityType
		)

		local pPlot = pCity:GetPlot()
		for _, tRow in ipairs(tRows) do
			local sProperty	= tRow.PropertyName
			local sValue	= tonumber(tRow.PropertyValue) or tRow.PropertyValue

			print(sProperty, sValue)
			pPlot:SetProperty(sProperty, sValue)
		end
		------------------------------------------
		-- Trigger Event
		------------------------------------------
		CallLuaEvent(
			"Suk_UrbanIdentityAssigned",
			{
				PlayerID		= iPlayer,
				CityID			= iCity,
				IdentityType	= sIdentityType,
			}
		)
		------------------------------------------
		------------------------------------------
	end

	function TransferIdentities(sCityA, sCityB)

		local iPlayer, iCity = DecompositeCityID(sCityB)
		for _, sIdentityType in ipairs(tCities[sCityA].IdentitiesArray) do
			AssignIdentity(iPlayer, iCity, sIdentityType)
		end

	end
--===========================================================================================
--	On Events
--===========================================================================================
	--	OnCityBuilt
	------------------------------------------------------------------------------
		function OnCityBuilt(iPlayer, iCity, iX, iY)
			local sCity					= CompositeCityID(iPlayer, iCity)
			local iPlot					= Map.GetPlotIndex(iX, iY)
			local bRegionsUpdated		= false
			--print("OnCityBuilt", sCity, iPlot)
			------------------------------------------
			-- First, init an entry for the new city
			------------------------------------------
			tCities[sCity] = {
				PlotIndex		= iPlot,
				CityID			= sCity,
				Identities		= {},
				IdentitiesArray	= {},
				Region			= -1
			}
			------------------------------------------
			-- Then, check if there was previously
			-- a city on the same plot (conquest)

			-- Transfer over previous Identities
			-- Then update city info for the city plot
			------------------------------------------
			if tCities[iPlot] then
				--print('There was a city here!!!!', tCities[iPlot].CityID, sCity)
				TransferIdentities(tCities[iPlot].CityID, sCity)
			end

			tCities[iPlot] = tCities[sCity]
			------------------------------------------
			-- Update Region Ownership, if applicable
			-- Enclosed in a repeat loop so we can use break
			------------------------------------------
			repeat
				-- Retrieve RegionID for the plot
				local iRegion = tPlotCache[iPlot]
				if not iRegion then break end
				local tRegion = tRegions[iRegion]
				if not tRegion then break end

				-- Check if the Region is already claimed
				if tRegion.Claimed then
					-- if it is, and it's this plot,
					-- then we transfer ownership to the new city!
					if tRegion.Claimed == iPlot then
						tCities[sCity].Region = iRegion
						CallLuaEvent(
							"Suk_RegionClaimed",
							{
								RegionID		= iRegion,
								PlayerID		= iPlayer,
								CityID			= iCity,
								X				= iX,
								Y				= iY,
								NewlyClaimed	= false

							}
						)
					end
					-- No Identity assignment here
					-- We would have already transferred Identites above!
					break
				end

				-- If we've gotten this far, then the region is unclaimed!
				-- Check if the player is a living major player before assigning ownership
				local pPlayer = Players[iPlayer]
				if not (pPlayer:IsAlive() and pPlayer:IsMajor()) then break end

				tCities[sCity].Region = iRegion
				tRegion.Claimed = iPlot

				AssignIdentity(iPlayer, iCity, tRegion.IdentityType)

				CallLuaEvent(
					"Suk_RegionClaimed",
					{
						RegionID		= iRegion,
						PlayerID		= iPlayer,
						CityID			= iCity,
						X				= iX,
						Y				= iY,
						NewlyClaimed	= true

					}
				)
				bRegionsUpdated = true

			until true
			------------------------------------------
			-- Save Changed Information
			------------------------------------------
			Game:SetProperty("Suk_UrbanIdentities_Cities", tCities)

			if bRegionsUpdated then
				Game:SetProperty("Suk_UrbanIdentities_Regions", tRegions)
			end
			------------------------------------------
			------------------------------------------
		end

		GameEvents.CityBuilt.Add(OnCityBuilt)
	------------------------------------------------------------------------------
	--	OnCityRemovedFromMap
	------------------------------------------------------------------------------
		function OnCityRemovedFromMap (iPlayer, iCity)
			local sCity				= CompositeCityID(iPlayer, iCity)
			local tCityInfo			= tCities[sCity]
			local iPlot				= tCityInfo.PlotIndex
			local bRegionsUpdated	= false
			------------------------------------------
			-- OnCityBuilt should have run with the same PlotIndex first
			-- So if this city was conquered,
			-- a new entry should have overridden this city's entry
			------------------------------------------
			local bCityDestroyed	= tCities[sCity] == tCities[iPlot]

			if bCityDestroyed then
				------------------------------------------
				-- Empty the Region
				------------------------------------------
				local iRegion = tCityInfo.Region
				if iRegion then
					tRegions[iRegion].Claimed = nil
					bRegionsUpdated = true

					CallLuaEvent(
						"Suk_RegionAbandoned",
						{RegionID = iRegion,}
					)
				end
				------------------------------------------
				-- Clear City Plot Properties
				------------------------------------------
				local pPlot = Map.GetPlotByIndex(iPlotIndex)
				for _, sIdentityType in ipairs(tCityInfo.IdentitiesArray) do

					local tRows = DB.Query(
						[[
							SELECT * FROM Suk_UrbanIdentity_PlotProperties WHERE IdentityType = ? AND CityOnly
						]],
						sIdentityType
					)

					for _, tRow in ipairs(tRows) do
						local sProperty	= tRow.PropertyName
						local sValue	= tonumber(tRow.PropertyValue) or tRow.PropertyValue

						pPlot:SetProperty(sProperty, nil)
					end
				end
				------------------------------------------
				------------------------------------------
				tCities[iPlot] = nil
			end
			------------------------------------------
			-- Delete the entry for this city
			------------------------------------------
			tCities[sCity] = nil
			------------------------------------------
			-- Save Changed Information
			------------------------------------------
			Game:SetProperty("Suk_UrbanIdentities_Cities", tCities)

			if bRegionsUpdated then
				Game:SetProperty("Suk_UrbanIdentities_Regions", tRegions)
			end

			-- print("OnCityRemovedFromMap", sCity, iPlot, bCityDestroyed)
			------------------------------------------
			------------------------------------------
		end

		Events.CityRemovedFromMap.Add(OnCityRemovedFromMap)
--===========================================================================
--===========================================================================