-- Suk_CustomRegionEffects_Core
-- Author: Sukritact
-- DateCreated: 6/10/2024 10:25:59 AM
--==========================================================================================================================
-- Rich Soil
--==========================================================================================================================
	local tRichSoil_Resources = {}
	for tRow in GameInfo.Improvement_ValidResources() do
		if tRow.ImprovementType == "IMPROVEMENT_FARM" then
			local sResource = tRow.ResourceType
			local iResource = GameInfo.Resources[sResource].Index

			table.insert(tRichSoil_Resources, iResource)
		end
	end

	function OnImprovementAddedToMap(iX, iY, iImprovement, iOwner)

		if not (iImprovement == GameInfo.Improvements["IMPROVEMENT_FARM"].Index) then return end

		local pPlot = Map.GetPlot(iX, iY)
		if (pPlot:GetResourceType() ~= -1) then return end -- No Current Resource
		if not (pPlot:GetProperty("IDENTITY_SUK_RICH_SOIL")) then return end -- Is Rich Soil
		if (pPlot:GetProperty("IDENTITY_SUK_RICH_SOIL_FARM_TESTED")) then return end -- Effect not already triggered

		local pCity = Cities.GetPlotPurchaseCity(pPlot)
		if not pCity then return end

		local pCityPlot = pCity:GetPlot()
		if not (pCityPlot:GetProperty("HAS_IDENTITY_SUK_RICH_SOIL")) then return end

		local bRandom = Game.GetRandNum(3, "Rich Soil - Suk Urban Identities") ==  0
		if not (bRandom) then return end

		local iResource = Game.GetRandNum(#tRichSoil_Resources, "Rich Soil - Suk Urban Identities") + 1
		iResource = tRichSoil_Resources[iResource]

		ResourceBuilder.SetResourceType(pPlot, iResource, 1)
		pPlot:SetProperty("IDENTITY_SUK_RICH_SOIL_FARM_TESTED", 1)
	end

	Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap)
--==========================================================================================================================
--==========================================================================================================================