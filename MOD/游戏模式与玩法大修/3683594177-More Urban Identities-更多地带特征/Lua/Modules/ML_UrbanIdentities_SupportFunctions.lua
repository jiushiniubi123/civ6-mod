-- ML_UrbanIdentities_SupportFunctions
-- Author: Maple_Leaves
-- DateCreated: 2/28/2026 9:53:04 PM
--------------------------------------------------------------

function TableIncludeValue_Suk_Urban_Identities_ML(ttable, vvalue)
	for k, v in pairs(ttable) do
		if v == vvalue then 
		return true;
		end
	end
	return false;
end

function HasCertainResourceWithInXTiles(pPlot, resoureTypeList, range)

	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	for _, kPlot in ipairs(Map.GetNeighborPlots(iX, iY, range)) do
		local pResourceType = kPlot:GetResourceType()

		local pResourceItem = GameInfo.Resources[pResourceType]
		if pResourceItem ~= nil then
			local pResourceTypeStr = pResourceItem.ResourceType
			if TableIncludeValue_Suk_Urban_Identities_ML(resoureTypeList, pResourceTypeStr) then
				return true
			end
		end
	end
	return false

end

function HasCertainResourceThisTile(pPlot, resoureTypeList)

	local pResourceType = pPlot:GetResourceType()

	local pResourceItem = GameInfo.Resources[pResourceType]
	if pResourceItem ~= nil then
		local pResourceTypeStr = pResourceItem.ResourceType
		if TableIncludeValue_Suk_Urban_Identities_ML(resoureTypeList, pResourceTypeStr) then
			return true
		end
	end

	return false

end

function HasAnyResourceWithInXTiles(pPlot, range)

	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	for _, kPlot in ipairs(Map.GetNeighborPlots(iX, iY, range)) do
		local pResourceType = kPlot:GetResourceType()

		local pResourceItem = GameInfo.Resources[pResourceType]
		if pResourceItem ~= nil then
			return true
		end
	end
	return false

end

function HasCoastWithInXTiles(pPlot, range)

	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	for _, kPlot in ipairs(Map.GetNeighborPlots(iX, iY, range)) do
		local pTerrainType = kPlot:GetTerrainType()
		if pTerrainType ~= nil and pTerrainType == GameInfo.Terrains.TERRAIN_COAST.Index then
			return true
		end
	end
	return false

end

function HasWaterWithInXTiles(pPlot, range)

	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	for _, kPlot in ipairs(Map.GetNeighborPlots(iX, iY, range)) do
		if kPlot:IsWater() then
			return true
		end
	end
	return false

end

function IsAdjacentToWater(pPlot)

	for _, kPlot in ipairs(Map.GetAdjacentPlots(pPlot:GetX(), pPlot:GetY())) do
		if kPlot:IsWater() then
			return true
		end
	end
	return false
end

function IsAdjacentToGreatRiver(pPlot)
	if not GameInfo.Terrains.TERRAIN_REAL_RIVER then
		return false
	end

	for _, kPlot in ipairs(Map.GetAdjacentPlots(pPlot:GetX(), pPlot:GetY())) do
		local pTerrainType = kPlot:GetTerrainType()
		if pTerrainType == GameInfo.Terrains.TERRAIN_REAL_RIVER.Index then
			return true
		end
	end
	return false
end

function IsGrassTerrain(pPlot)
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if TableIncludeValue_Suk_Urban_Identities_ML({'TERRAIN_GRASS', 'TERRAIN_GRASS_HILLS', 'TERRAIN_GRASS_MOUNTAIN'}, pTerrainItem.TerrainType) then
		return true
	end
	return false
end

function IsPlainsTerrain(pPlot)
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if TableIncludeValue_Suk_Urban_Identities_ML({'TERRAIN_PLAINS', 'TERRAIN_PLAINS_HILLS', 'TERRAIN_PLAINS_MOUNTAIN'}, pTerrainItem.TerrainType) then
		return true
	end
	return false
end

function IsDesertTerrain(pPlot)
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if TableIncludeValue_Suk_Urban_Identities_ML({'TERRAIN_DESERT', 'TERRAIN_DESERT_HILLS', 'TERRAIN_DESERT_MOUNTAIN'}, pTerrainItem.TerrainType) then
		return true
	end
	return false
end

function IsAdjacentToDesert(pPlot)

	for _, kPlot in ipairs(Map.GetAdjacentPlots(pPlot:GetX(), pPlot:GetY())) do
		if IsDesertTerrain(kPlot) then
			return true
		end
	end
	return false
end

function IsVolcano(pPlot)
	local pFeatureType = pPlot:GetFeatureType()
	local pFeatureItem = GameInfo.Features[pFeatureType]
	if pFeatureItem == nil then
		return false
	end
	if TableIncludeValue_Suk_Urban_Identities_ML({'FEATURE_VOLCANO', 'FEATURE_VOLCANIC_SOIL'}, pFeatureItem.FeatureType) then
		return true
	end
	return false
end


function IsLandTerrain(pPlot)
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if (pTerrainItem.Water == false) then
		return true
	end
	return false
end

function IsFlatLandTerrain(pPlot)
	--I' m not sure whether :IsFlatlands() works or not 
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if (pTerrainItem.Mountain == false) and (pTerrainItem.Hills == false) and (pTerrainItem.Water == false) then
		return true
	end
	return false
end

function IsHillsLandTerrain(pPlot)
	--I' m not sure whether :IsFlatlands() works or not 
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if (pTerrainItem.Mountain == false) and (pTerrainItem.Hills == true) and (pTerrainItem.Water == false) then
		return true
	end
	return false
end

function IsMountainLandTerrain(pPlot)
	local pTerrainType = pPlot:GetTerrainType()
	local pTerrainItem = GameInfo.Terrains[pTerrainType]
	if pTerrainItem == nil then
		return false
	end
	if (pTerrainItem.Mountain == true) and (pTerrainItem.Water == false) then
		return true
	end
	return false
end

function HasCertainFeatureWithInXTiles(pPlot, featureTypeList, range)

	local iX = pPlot:GetX()
	local iY = pPlot:GetY()
	for _, kPlot in ipairs(Map.GetNeighborPlots(iX, iY, range)) do
		local pFeatureType = kPlot:GetFeatureType()
		local pFeatureItem = GameInfo.Features[pFeatureType]
		if pFeatureItem ~= nil then
			local pFeatureTypeStr = pFeatureItem.FeatureType
			if TableIncludeValue_Suk_Urban_Identities_ML(featureTypeList, pFeatureTypeStr) then
				return true
			end
		end
	end
	return false

end
