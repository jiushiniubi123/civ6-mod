-- Suk_RegionIdentities
-- Author: Sukritact
-- DateCreated: 5/3/2024 2:33:52 PM
--===========================================================================
--===========================================================================
	local m_GameRegions	= Game:GetProperty("Suk_UrbanIdentities_Regions")
	local m_PlotCache	= Game:GetProperty("Suk_UrbanIdentities_RegionPlotIndex")
--===========================================================================
-- Cache Region Types
--===========================================================================
	local m_RegionTypes_Identities = {}
	local m_IndentityFrequency = {}

	for _, tRegion in ipairs(m_GameRegions) do
		local sRegionType = tRegion.RegionType
		if not(m_RegionTypes_Identities[sRegionType]) then

			m_RegionTypes_Identities[sRegionType] = {}
			local tRows = DB.Query(
				[[
					SELECT IdentityType from Suk_UrbanIdentities WHERE RegionOnly == 1 AND IdentityType IN
						(SELECT IdentityType FROM Suk_UrbanIdentity_Regions WHERE RegionType = ?)
				]],
				sRegionType
			)

			for _, tRow in ipairs(tRows) do
				table.insert(m_RegionTypes_Identities[sRegionType], tRow.IdentityType)
				m_IndentityFrequency[tRow.IdentityType] = 10
			end
		end
	end
--===========================================================================
-- Assign an Identity to Each Region
--===========================================================================
	--	SelectRandomRegion
	--------------------------------------
		function SelectRandomRegion(tTable)
			local tRandom = {}
			local iMaxRandom = 0

			for _, sIdentityType in ipairs(tTable) do

				local iExponent = m_IndentityFrequency[sIdentityType]
				local iChance = math.max(1, math.floor(
					((3^(iExponent-10)) * 3500) + 0.5
				))

				iMaxRandom = iMaxRandom + iChance

				table.insert(tRandom,
					{
						ID = sIdentityType,
						Max = iMaxRandom
					}
				)

			end

			local sIdentityType = tRandom[1].ID
			local iRandom = RandomDebug(iMaxRandom, "Suk: Random Identity")

			for i,v in ipairs(tRandom) do
				if iRandom < v.Max then
					sIdentityType = v.ID
					break
				end
			end

			return sIdentityType
		end
	--------------------------------------
	--------------------------------------
		for _, tRegion in ipairs(m_GameRegions) do
			--------------------------------------
			-- Select a random valid Identity Type
			--------------------------------------
			local sRegionType = tRegion.RegionType
			local sIdentityType = SelectRandomRegion(m_RegionTypes_Identities[sRegionType])
			--------------------------------------
			-- Decrement frequency for the selected Identity Type
			--------------------------------------
			m_IndentityFrequency[sIdentityType] = math.max(m_IndentityFrequency[sIdentityType] - 2, 0)
			--------------------------------------
			-- Assign selected Identity Type
			--------------------------------------
			tRegion.IdentityType = sIdentityType
			--------------------------------------
			-- Assign Plot Properties
			-- if applicable
			--------------------------------------
			local tRows = DB.Query(
				[[
					SELECT * FROM Suk_UrbanIdentity_PlotProperties WHERE IdentityType = ? AND NOT CityOnly
				]],
				sIdentityType
			)

			for _, tRow in ipairs(tRows) do
				local sProperty	= tRow.PropertyName
				local sValue	= tonumber(tRow.PropertyValue) or tRow.PropertyValue

				for _, iPlot in ipairs(tRegion.Nodes) do
					local pPlot = Map.GetPlotByIndex(iPlot)
					pPlot:SetProperty(sProperty, sValue)
				end
			end
			--------------------------------------
			--------------------------------------
		end
--===========================================================================
-- For each region, save Region ID, Region Type, and IdentityType to Plot Properties
--===========================================================================
		for iPlot, iRegion in ipairs(m_PlotCache) do

			local tRegion		= m_GameRegions[iRegion]
			local sRegion		= tRegion.RegionType
			local sIdentity		= tRegion.IdentityType

			local pPlot = Map.GetPlotByIndex(iPlot)

			pPlot:SetProperty("Suk_UrbIdentities_RegionID",			iRegion)
			pPlot:SetProperty("Suk_UrbIdentities_RegionType",		sRegion)
			pPlot:SetProperty("Suk_UrbIdentities_IdentityType",		sIdentity)
		end
--===========================================================================
-- Save
--===========================================================================
	Game:SetProperty("Suk_UrbanIdentities_Regions", m_GameRegions)
--===========================================================================
--===========================================================================