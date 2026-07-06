-- Suk_UrbIdent_RegionDefs
-- Author: Sukritact
-- DateCreated: 3/5/2024 10:18:57 PM
--======================================================================================================================
--[[
	MODDED REGION DEFINITIONS
	Insert a new entry into g_RegionDefinitions with the following format

	g_RegionDefinitions[sRegionType] = {
		CheckerFunction = function(pPlot) return bBool end,
		MinSamples		= iInt, -- Minimum number of neighbors to create cluster
		Epsilon			= iInt, -- Minimum distance to consider neighbors
		MinSize			= iInt, -- Minumum size of cluster for it to be valid. Optional. Default 0.
		Dilate			= iInt,	-- How many tiles to grow the group by before finalising. Optional. Default 0.
		CoastalOnly,	= bBool -- Whether to limit the FINAL cluster to only coastal tiles.  Optional. False 0.
	}

	the "Checker Function" determines which plots are considered valid "Nodes"
	for the algorithm

	Regions are grown from "Core Nodes", which are any Nodes with >= MinSamples number of neighbors
	Nodes are considered neighbors if the distance between them is <= Epsilon.
	Regions will include both regular and Core Nodes. It's just that regions are grown from Core Nodes.

	Regions are < MinSize are culled. MinSize defaults to 0 if not provided.

	See below for examples
]]
--======================================================================================================================
-- DEFINITIONS
--======================================================================================================================
-- Forests
-------------------------------------
	g_RegionDefinitions["REGION_SUK_FOREST"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_FOREST.Index)
			end,
		MinSamples	= 2,
		Epsilon		= 1,
		MinSize		= 4,
		Dilate		= 1,
	}
-------------------------------------
-- Jungle
-------------------------------------
	g_RegionDefinitions["REGION_SUK_JUNGLE"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_JUNGLE.Index)
			end,
		MinSamples	= 3,
		Epsilon		= 1,
		Dilate		= 1,
	}
-------------------------------------
-- Cliffs
-------------------------------------
	g_RegionDefinitions["REGION_SUK_CLIFFS"] = {
		CheckerFunction =
			function(pPlot)
				if pPlot:IsWater() then return end
				if (pPlot:IsNWOfCliff() or pPlot:IsWOfCliff() or pPlot:IsNEOfCliff()) then
					return true
				end

				local iX = pPlot:GetX()
				local iY = pPlot:GetY()

				local pPlotNW = Map.GetAdjacentPlot(iX, iY, DirectionTypes.DIRECTION_NORTHWEST)
				if pPlotNW and pPlotNW:IsNWOfCliff() then return true end

				local pPlotW = Map.GetAdjacentPlot(iX, iY, DirectionTypes.DIRECTION_WEST)
				if pPlotW and pPlotW:IsWOfCliff() then return true end

				local pPlotNE = Map.GetAdjacentPlot(iX, iY, DirectionTypes.DIRECTION_NORTHEAST)
				if pPlotNE and pPlotNE:IsNEOfCliff() then return true end

				return
			end,
		MinSamples	= 2,
		Epsilon		= 1,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
			return not(
				(not pPlot:IsWater()) or pPlot:IsShallowWater()
			)
		end,
	}
-------------------------------------
-- Mountains
-------------------------------------
	g_RegionDefinitions["REGION_SUK_MOUNTAINS"] = {
		CheckerFunction =
			function(pPlot)
				return pPlot:IsMountain()
			end,
		MinSamples	= 2,
		Epsilon		= 1,
		Dilate		= 1,
		MinSize		= 5,
	}
-------------------------------------
-- Kelp Forests
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Features.FEATURE_SUK_KELP then
		g_RegionDefinitions["REGION_SUK_KELP"] = {
			CheckerFunction =
				function(pPlot)
					return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_SUK_KELP.Index)
				end,
			MinSamples	= 2,
			Epsilon		= 1,
			Dilate		= 1,
			MinSize		= 3,
			CullingFunction	= function(pPlot)
				return not(
					pPlot:IsCoastalLand() or pPlot:IsShallowWater()
				)
			end,
		}
	end
-------------------------------------
-- Oases
-------------------------------------
	g_RegionDefinitions["REGION_SUK_OASIS"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_OASIS.Index)
			end,
		MinSamples	= 1,
		Epsilon		= 3,
		Dilate		= 1,
	}
-------------------------------------
-- Geothermal Vents
-------------------------------------
	g_RegionDefinitions["REGION_SUK_GEOTHERMAL"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_GEOTHERMAL_FISSURE.Index)
			end,
		MinSamples	= 1,
		Epsilon		= 3,
		Dilate		= 1,
	}
-------------------------------------
-- Reefs
-------------------------------------
	g_RegionDefinitions["REGION_SUK_REEF"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_REEF.Index)
			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
			return not(
				pPlot:IsCoastalLand() or pPlot:IsShallowWater()
			)
		end,
	}
-------------------------------------
-- Plains
-------------------------------------
	local SukRegionPlains = {}
	SukRegionPlains[GameInfo.Terrains.TERRAIN_GRASS.Index]		= true
	SukRegionPlains[GameInfo.Terrains.TERRAIN_PLAINS.Index]		= true
	--SukRegionPlains[GameInfo.Terrains.TERRAIN_TUNDRA.Index]		= true

	g_RegionDefinitions["REGION_SUK_PLAINS"] = {
		CheckerFunction =
			function(pPlot)
				if SukRegionPlains[pPlot:GetTerrainType()] and (pPlot:GetFeatureType() == -1) then
					local iNeighbors = 0
					for pRingPlot in PlotRingIterator(pPlot, 1) do
						if SukRegionPlains[pRingPlot:GetTerrainType()] and (pRingPlot:GetFeatureType() == -1) then
							iNeighbors = iNeighbors + 1
						end
					end

					if iNeighbors >= 3 then return true end
				end
			end,
		MinSamples	= 5,
		Epsilon		= 1,
		Dilate		= 0,
	}
-------------------------------------
-- Marsh
-------------------------------------
	g_RegionDefinitions["REGION_SUK_MARSH"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_MARSH.Index)
			end,
		MinSamples	= 2,
		Epsilon		= 1,
		Dilate		= 1,
		MinSize		= 4,
	}
-------------------------------------
-- Hills
-------------------------------------
	local SukRegionHills = {}
	SukRegionHills[GameInfo.Terrains.TERRAIN_GRASS_HILLS.Index]		= true
	SukRegionHills[GameInfo.Terrains.TERRAIN_PLAINS_HILLS.Index]		= true
	SukRegionHills[GameInfo.Terrains.TERRAIN_DESERT_HILLS.Index]		= true
	SukRegionHills[GameInfo.Terrains.TERRAIN_TUNDRA_HILLS.Index]		= true

	g_RegionDefinitions["REGION_SUK_HILLS"] = {
		CheckerFunction =
			function(pPlot)
				if SukRegionHills[pPlot:GetTerrainType()] and (pPlot:GetFeatureType() == -1) then
					local iNeighbors = 0
					for pRingPlot in PlotRingIterator(pPlot, 1) do
						if SukRegionHills[pRingPlot:GetTerrainType()] and (pRingPlot:GetFeatureType() == -1) then
							iNeighbors = iNeighbors + 1
						end
					end

					if iNeighbors >= 3 then return true end
				end
			end,
		MinSamples	= 5,
		Epsilon		= 1,
		Dilate		= 0,
	}
-------------------------------------
-- Desert
-------------------------------------
	local SukRegionDesert = {}
	SukRegionDesert[GameInfo.Terrains.TERRAIN_DESERT.Index]				= true
	SukRegionDesert[GameInfo.Terrains.TERRAIN_DESERT_HILLS.Index]		= true

	local REGION_SUK_DESERT = function(pPlot)
		if pPlot:IsFreshWater() then return false end
		if not SukRegionDesert[pPlot:GetTerrainType()] then return false end
		return true
	end

	g_RegionDefinitions["REGION_SUK_DESERT"] = {
		CheckerFunction =
			function(pPlot)
				if REGION_SUK_DESERT(pPlot) then
					local iNeighbors = 0
					for pRingPlot in PlotRingIterator(pPlot, 1) do
						if REGION_SUK_DESERT(pPlot) then
							iNeighbors = iNeighbors + 1
						end
					end

					if iNeighbors >= 3 then return true end
				end
			end,
		MinSamples	= 5,
		Epsilon		= 1,
		Dilate		= 0,
	}
-------------------------------------
-- Rivers
-- This one is a weird one, we're going to do our checking OUTSIDE
-- the checking function, then just pass the valid plots on...
-------------------------------------
	-- Cache Floodplains
	-------------------------------------
	local SukRegionRiverFeatures = {}
	SukRegionRiverFeatures[GameInfo.Features.FEATURE_FLOODPLAINS.Index]				= true
	SukRegionRiverFeatures[GameInfo.Features.FEATURE_FLOODPLAINS_GRASSLAND.Index]	= true
	SukRegionRiverFeatures[GameInfo.Features.FEATURE_FLOODPLAINS_PLAINS.Index]		= true
	-- Add Support for JNR
	if GameInfo.Features.FEATURE_FLOODPLAINS_TUNDRA then
		SukRegionRiverFeatures[GameInfo.Features.FEATURE_FLOODPLAINS_TUNDRA.Index]    = true
	end
	if GameInfo.Features.FEATURE_JNR_SWAMP then
		SukRegionRiverFeatures[GameInfo.Features.FEATURE_JNR_SWAMP.Index]        = true
	end
	-------------------------------------
	-- Find the River Tiles
	-------------------------------------
	local SukRegionRiver = {}
	if RiverManager ~= nil then
		for i = 0, RiverManager.GetNumRivers() - 1, 1 do
			local tRiver = RiverManager.GetRiverByIndex(i, "edges")
			local tEdges = tRiver.Edges
			local iEdges = #tRiver.Edges
			if iEdges >= 20 then
				local iLength = RandomDebug(3, "Suk: River Length")
				iLength = (4 + iLength) * 2

				local iMaxBuffer = iEdges - iLength
				local iBuffer = RandomDebug(iMaxBuffer, "Suk: River Buffer")

				for iEdge, tEdge in ipairs(tEdges) do
					if iBuffer > 0 then
						iBuffer = iBuffer - 1
					else
						SukRegionRiver[tEdge[1]] = true
						SukRegionRiver[tEdge[2]] = true
						iLength = iLength - 1

						if iLength < 1 then break end
					end
				end
			end
		end
	end
	-------------------------------------
	-- The actual entry
	-------------------------------------
	g_RegionDefinitions["REGION_SUK_RIVER"] = {
		CheckerFunction =
			function(pPlot)
				if not SukRegionRiver[pPlot:GetIndex()] then return end
				if pPlot:IsImpassable() then return end
				if pPlot:IsCoastalLand() then return end
				if SukRegionRiverFeatures[pPlot:GetFeatureType()] then return end

				return true
			end,
		MinSize		= 8,
		MinSamples	= 2,
		Epsilon		= 1,
		Dilate		= 0,
	}
-------------------------------------
-- Lakes
-------------------------------------
	g_RegionDefinitions["REGION_SUK_LAKE"] = {
		CheckerFunction =
			function(pPlot)
				return pPlot:IsLake()
			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
			return not(
				pPlot:IsLake() or (not pPlot:IsWater())
			)
		end,
	}
-------------------------------------
-- Reefs
-------------------------------------
	g_RegionDefinitions["REGION_SUK_REEF"] = {
		CheckerFunction =
			function(pPlot)
				return (pPlot:GetFeatureType() == GameInfo.Features.FEATURE_REEF.Index)
			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
			return not(
				pPlot:IsCoastalLand() or pPlot:IsShallowWater()
			)
		end,
	}
--======================================================================================================================
--======================================================================================================================