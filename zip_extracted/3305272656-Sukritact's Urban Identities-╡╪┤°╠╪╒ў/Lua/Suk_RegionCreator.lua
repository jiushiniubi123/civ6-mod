-- Suk_RegionCreator
-- Author: Sukritact
-- DateCreated: 2/27/2024 8:16:04 PM
--======================================================================================================================
-- Utility Functions
--======================================================================================================================
	include("PlotIterators.lua")

	function Select (n, ...)
		return arg[n]
	end

	function GridToWorld(iX, iY)

		local iSizeX, iSizeY = Map.GetGridSize()
		iSizeX = math.floor(iSizeX/2)
		iSizeY = math.floor(iSizeY/2)

		iX = iX - iSizeX
		iY = iY - iSizeY

		local iWorldX = 36.95 * math.sqrt(3) * ((iX - 0.5 * (iY%2)) + 0.5)
		local iWorldY = 36.95 * 3/2 * iY

		return iWorldX, iWorldY
	end

	function hsvToRgb(h, s, v)
		local r, g, b;

		local i = math.floor(h * 6);
		local f = h * 6 - i;
		local p = v * (1 - s);
		local q = v * (1 - f * s);
		local t = v * (1 - (1 - f) * s);

		local modH = i % 6
		if modH == 0 then
			r = v; g = t; b = p
		elseif modH == 1 then
			r = q; g = v; b = p
		elseif modH == 2 then
			r = p; g = v; b = t
		elseif modH == 3 then
			r = p; g = q; b = v
		elseif modH == 4 then
			r = t; g = p; b = v
		else
			r = v; g = p; b = q
		end

		return r,g,b
	end

	function RandomDebug(iMax, sReason)
		local iRandom = TerrainBuilder.GetRandomNumber(iMax, sReason)
		print("RandomDebug\t"..sReason.."\t\t"..iRandom)
		return iRandom
	end
--======================================================================================================================
-- DBSCAN Class
--======================================================================================================================
	Suk_DBSCAN_Clustering = {
		------------------------------------------------------------------
		-- Properties
		------------------------------------------------------------------
			m_MapWidth		= Map.GetGridSize(),
			m_MapHeight		= Select(2, Map.GetGridSize()),

			m_MinSamples	= 2, -- Minimum number of neighbors to create cluster
			m_Epsilon		= 1, -- Minimum distance to consider neighbors
			m_MinSize		= 0, -- Minumum size of cluster for it to be valid
			m_Dilate		= 0, -- How many tiles to grow the group by before finalising

			m_Neighbors		= {},
			m_Instances		= {},

			m_CullingFunction = function(pPlot)
				return pPlot:IsWater()
			end,
		------------------------------------------------------------------
		-- Constructor
		------------------------------------------------------------------
			new = function(self, sType, tTable)
				-------------------------------
				-- We actually NEED a checker function
				-- to do anything, so check for that
				-------------------------------
					assert(
						type(tTable.CheckerFunction) == 'function',
						"function expected, recieved " .. type(tTable.CheckerFunction) .. " instead"
					)
				-------------------------------
				-- Init
				-------------------------------
					local pObject = {}
					setmetatable(pObject, self)
					self.__index = self

					pObject.m_RegionType		= sType
					pObject.m_CheckerFunction	= tTable.CheckerFunction
				-------------------------------
				-- Set Min Samples & Epsilon
				-------------------------------
					pObject.m_MinSamples	= tTable.MinSamples or self.m_MinSamples
					pObject.m_Epsilon		= tTable.Epsilon or self.m_Epsilon
					pObject.m_MinSize		= tTable.MinSize or self.m_MinSize
					pObject.m_Dilate		= tTable.Dilate or self.m_Dilate
					if type(tTable.CullingFunction) == "function" then
						pObject.m_CullingFunction	= tTable.CullingFunction
					end
				-------------------------------
				-- Create Tables
				-------------------------------
					pObject.m_Clusters		= {}
					pObject.m_Nodes			= {}
					pObject.m_NodeData		= {}
					pObject.m_CoreNodes		= {}
					pObject.m_CoreNum		= 0
				-------------------------------
				-- Process
				-------------------------------
					pObject:PopulateNodes()
					pObject:DBSCAN()
					if pObject.m_Dilate then
						pObject:DilateClusters()
					end
					pObject:CullPlots()
					pObject:ProcessPassable()
					pObject:CullClustersbySize(4, 18)
					-- Sort Cluster Plots by PlotID
					pObject:SortClusterPlots()
					-- Calculate Cluster Centers
					pObject:CalculateClusterCenters()
					-- Ensure Clusters are sorted by Cluster Center
					pObject:SortClusters()
					-- Ensure Nodes are sorted by PlotID
					table.sort(pObject.m_Nodes)
				-------------------------------
				-------------------------------
				table.insert(self.m_Instances, pObject)
				return pObject
			end,
		------------------------------------------------------------------
		-- Populate Nodes
		------------------------------------------------------------------
			PopulateNodes = function(self)
				for iY = 0, self.m_MapHeight - 1 do
					for iX = 0, self.m_MapWidth - 1 do
					-------------------------------
					-- Check if plot is a node
					-------------------------------
						local iPlot			= iY * self.m_MapWidth + iX
						local pPlot			= Map.GetPlotByIndex(iPlot)

						if self.m_CheckerFunction(pPlot) then

							table.insert(self.m_Nodes, iPlot)
							self.m_NodeData[iPlot] = {
								Object		= pPlot,
								Index		= iPlot,
								X			= iX,
								Y			= iY,
								Neighbors	= {},
								Cluster		= -1,
							}

						end
					-------------------------------
					-------------------------------
					end
				end
				-------------------------------
				-- Check for neighboring nodes
				-------------------------------
					for _,iNodeA in pairs(self.m_Nodes) do

						local tNodeA = self.m_NodeData[iNodeA]

						for _,iNodeB in pairs(self.m_Nodes) do

							local tNodeB = self.m_NodeData[iNodeB]

							-- Generate a key for the pairing
							-- Order the pair to ensure consistency
							local iPairKey = ""
							if iNodeA > iNodeB then
								iPairKey = iNodeA .. "A" .. iNodeB
							else
								iPairKey = iNodeB .. "A" .. iNodeA
							end

							-- Neighbor check
							local tNeighbors = Suk_DBSCAN_Clustering.m_Neighbors

							if tNeighbors[iPairKey] == true then
								table.insert(tNodeA.Neighbors, iNodeB)
							elseif tNeighbors[iPairKey] == false then
								--pass
							else
								local tNodeB = self.m_NodeData[iNodeB]
								local iDistance = Map.GetPlotDistance(tNodeA.X, tNodeA.Y, tNodeB.X, tNodeB.Y)

								if (iDistance > 0) and (iDistance <= self.m_Epsilon) then
									table.insert(tNodeA.Neighbors, iNodeB)
									tNeighbors[iPairKey] = true
								else
									tNeighbors[iPairKey] = false
								end
							end

						end
						-------------------------------
						-- Core Check
						-------------------------------
						--print(#tNodeA.Neighbors, self.m_MinSamples)
						if #tNodeA.Neighbors >= self.m_MinSamples then
							self.m_CoreNodes[iNodeA] = true
							self.m_CoreNum = self.m_CoreNum + 1
						end
						-------------------------------
						-------------------------------
					end
				-------------------------------
				-------------------------------
			end,
		------------------------------------------------------------------
		-- DBSCAN
		-- See below for refs:
		-- https://medium.com/mlearning-ai/dbscan-demystified-understanding-how-this-parameter-free-algorithm-works-89e03d7d7ab
		------------------------------------------------------------------
			DBSCAN = function(self)
				-------------------------------
				-- As long as we still have core points
				-- we grab a point and add to a cluster
				-- and iteratively add its neighbours to the same cluster
				-------------------------------
				while self.m_CoreNum > 0 do

					local iNode, tNode
					-------------------------------
					-- Grab the first node
					-------------------------------
					for iCoreNode, _ in pairs(self.m_CoreNodes) do
						tNode = self.m_NodeData[iCoreNode]
						iNode = iCoreNode
						break
					end
					-------------------------------
					-- Create a new cluster
					-------------------------------
					local iCluster = #self.m_Clusters + 1
					local tCluster = {
						Index = iCluster,
						Nodes = {},
						RegionType = self.m_RegionType,
					}

					table.insert(self.m_Clusters, tCluster)
					self:AddNodeToCluster(iCluster, iNode)
					-------------------------------
					-- Once a cluster has been created, we need to check to see if it meets the minimum size
					-------------------------------
					if #(self.m_Clusters[iCluster].Nodes) < self.m_MinSize then

						for _, iPlot in pairs(self.m_Clusters[iCluster].Nodes) do
							self.m_NodeData[iPlot].Cluster = -1
						end

						self.m_Clusters[iCluster] = nil
					end
				end
			end,
		------------------------------------------------------------------
		-- Add Node To Cluster
		------------------------------------------------------------------
			AddNodeToCluster = function (self, iCluster, iNode)

				if self.m_CoreNodes[iNode] then
					-- We need to remove the node from the core points list if it's in there
					self.m_CoreNodes[iNode] = nil
					self.m_CoreNum = self.m_CoreNum - 1
				end

				local tNode = self.m_NodeData[iNode]
				local tCluster = self.m_Clusters[iCluster]

				if not tNode then return end
				if not tCluster then return end

				-- Check if the node already belongs to a cluster!
				if tNode.Cluster ~= -1 then return end

				-- If not assign a cluster
				tNode.Cluster = iCluster
				table.insert(tCluster.Nodes, iNode)

				if not tCluster.CenterPlot then tCluster.CenterPlot = iNode end

				for _, iNeighbor in ipairs(tNode.Neighbors) do
					self:AddNodeToCluster(iCluster, iNeighbor)
				end
			end,
		------------------------------------------------------------------
		-- Dilate Clusters
		------------------------------------------------------------------
			DilateClusters = function (self)
				-------------------------------
				-- First, we mark any nodes that already have a cluster assigned as "processed"
				-------------------------------
				local tProcessed = {}

				for iPlot, tPlot in pairs(self.m_NodeData) do
					if tPlot.Cluster ~= -1 then
						tProcessed[iPlot] = true
					end
				end
				-------------------------------
				-- Then for each node, add neighbors to a cluster
				-- and mark them as processed, ignoring already processed nodes

				-- Remember that not all plots here will count as nodes!!!
				-------------------------------
				for iPlot, tPlot in pairs(self.m_NodeData) do

					local pPlot = Map.GetPlotByIndex(iPlot)
					local iCluster = tPlot.Cluster

					if iCluster ~= -1 then
						for pIterPlot in PlotAreaSpiralIterator(pPlot, self.m_Dilate) do
							local iIterPlot = pIterPlot:GetIndex()
							if not tProcessed[iIterPlot] then

								local tCluster = self.m_Clusters[iCluster]
								table.insert(tCluster.Nodes, iIterPlot)
								tProcessed[iIterPlot] = true

							end
						end
					end
				end
			end,
		------------------------------------------------------------------
		-- Calculate Cluster Centers
		------------------------------------------------------------------
			CalculateClusterCenters = function (self)
				for iCluster, tCluster in ipairs(self.m_Clusters) do
					local tPlots = {} -- We need a temp table we can sort, hence this guy
					local tPlotLocs = {} -- To store World Position location of plots

					-- Start by getting the locations of each plot (in world space)
					for _, iPlot in ipairs(tCluster.Nodes) do
						tPlotLocs[iPlot] = {GridToWorld(Map.GetPlotLocation(iPlot))}
					end

					-- Then for each plot, find the distance to all other plots
					for _, iPlotA in ipairs(tCluster.Nodes) do
						local iDistanceTotal = 0
						local iX_A, iY_A = unpack(tPlotLocs[iPlotA])

						for _, iPlotB in ipairs(tCluster.Nodes) do
							local iX_B, iY_B = unpack(tPlotLocs[iPlotB])
							local iDistance = (iX_A-iX_B)^2 + (iY_A-iY_B)^2

							iDistanceTotal = iDistanceTotal + iDistance
						end

						table.insert(tPlots, {iPlotA, iDistanceTotal})
					end

					local function SortPlots(tA, tB)
						return tA[2] < tB[2]
					end

					table.sort(tPlots, SortPlots)
					tCluster.CenterPlot = tPlots[1][1]
				end
			end,
		------------------------------------------------------------------
		-- Sort Clusters Plots
		------------------------------------------------------------------
			SortClusterPlots = function (self)
				for _,tCluster in ipairs(self.m_Clusters) do
					table.sort(tCluster.Nodes)
				end
			end,
		------------------------------------------------------------------
		-- Sort Clusters
		------------------------------------------------------------------
			SortClusters = function (self)
				local function Sorting(tA, tB)
					return tA.CenterPlot > tB.CenterPlot
				end

				table.sort(self.m_Clusters, Sorting)
			end,
		------------------------------------------------------------------
		-- Cull Plots
		------------------------------------------------------------------
			CullPlots = function (self)
				for iCluster, tCluster in pairs(self.m_Clusters) do

					local tPlotsToRemove = {}

					for i, iPlot in ipairs(tCluster.Nodes) do
						if self.m_CullingFunction(Map.GetPlotByIndex(iPlot)) then
							table.insert(tPlotsToRemove, i)
						end
					end

					for i = #tPlotsToRemove, 1, -1 do
						table.remove(tCluster.Nodes, tPlotsToRemove[i])
					end
				end
			end,
		------------------------------------------------------------------
		-- Process Passable
		------------------------------------------------------------------
			ProcessPassable = function (self)
				for iCluster, tCluster in pairs(self.m_Clusters) do

					tCluster.Passable = 0

					for i, iPlot in ipairs(tCluster.Nodes) do
						local pPlot = Map.GetPlotByIndex(iPlot)
						if (not pPlot:IsWater()) and (not pPlot:IsImpassable()) then
							tCluster.Passable = tCluster.Passable + 1
						end
					end

				end
			end,
		------------------------------------------------------------------
		-- Cull Small and Oversized Clusters
		------------------------------------------------------------------
			CullClustersbySize = function (self, iMin, iMax)

				local tToCull = {}

				for iCluster, tCluster in pairs(self.m_Clusters) do
					if (tCluster.Passable < iMin) or (tCluster.Passable > iMax) then
						table.insert(tToCull, iCluster)
					end
				end

				for _, iCluster in pairs(tToCull) do
					self.m_Clusters[iCluster] = nil
				end

				local tClusters = {}
				for _, tCluster in pairs(self.m_Clusters) do
					local iCluster = #tClusters + 1
					tCluster.Index = iCluster
					table.insert(tClusters, tCluster)
				end
				self.m_Clusters = tClusters
			end,
		------------------------------------------------------------------
		------------------------------------------------------------------
			GetClusters = function(self)
				return self.m_Clusters
			end,
	}
--======================================================================================================================
-- Create Clusters
--======================================================================================================================
	g_RegionDefinitions = {}; include("Suk_RegionDefinitions_", true);
	local tRegions = DB.Query("SELECT RegionType from Suk_Regions")
	local tRegionTypes = {}

	print("--------------------------------------------------")
	print("Sukritact Urban Identities: Creating Regions")
	print("--------------------------------------------------")
	for _,tRow in ipairs(tRegions) do
		local sRegionType = tRow.RegionType
		local tDefinition = g_RegionDefinitions[sRegionType]
		if g_RegionDefinitions[sRegionType] then
			print("\tProcessing " .. sRegionType)
			tDefinition.Object = Suk_DBSCAN_Clustering:new(sRegionType, tDefinition)
			table.insert(tRegionTypes, sRegionType)
			print("\t-----")
			print((string.format("\tCreated %d Regions(s)", #tDefinition.Object.m_Clusters)))
			print("\tCulling Regions")
		end
	end
--======================================================================================================================
-- Add all clusters to one table
--======================================================================================================================
	g_Clusters			= {}

	function TableConcat(t1,t2)
		for i=1,#t2 do
			t1[#t1+1] = t2[i]
		end
		return t1
	end

	for _, sRegionType in ipairs(tRegionTypes) do
		local tDefinition = g_RegionDefinitions[sRegionType]
		local pObject = tDefinition.Object
		if pObject then
			local tClusters = pObject:GetClusters()
			TableConcat(g_Clusters, tClusters)
		end
	end
--======================================================================================================================
-- Cache plot > cluster relationships
--======================================================================================================================
	local m_PlotCache	= {}

	for iCluster, tCluster in ipairs(g_Clusters) do

		-- init these, we'll want it later
		tCluster.Selected	= false
		tCluster.Valid		= true

		for _, iPlot in ipairs(tCluster.Nodes) do
			m_PlotCache[iPlot] = m_PlotCache[iPlot] or {}
			table.insert(m_PlotCache[iPlot], iCluster)
		end
	end
--======================================================================================================================
-- Randomly select a cluster
-- Check for overlapping clusters and mark them invalid.
-- Repeat until there are no valid clusters
--======================================================================================================================
	local m_GameRegions = {}
	------------------------------------------------------------------
	-- Function for selecting a random cluster
	-- This isn't true randomness: it's weighted
	------------------------------------------------------------------
		function SelectRandomCluster()
			--------------------------------
			-- First, group by Region Type
			--------------------------------
			local sRegionTypeMap	= {}
			local tRegionTypes		= {}

			for iCluster, tCluster in ipairs(g_Clusters) do
				if tCluster.Valid then

					local sRegionType = tCluster.RegionType
					if not tRegionTypes[sRegionType] then
						tRegionTypes[sRegionType] = {}
						table.insert(sRegionTypeMap, tRegionTypes[sRegionType])
					end
					table.insert(
						tRegionTypes[sRegionType],
						#tRegionTypes[sRegionType],
						iCluster
					)
				end
			end

			-- If there are no valid regions, then return
			if #sRegionTypeMap < 1 then return end

			-- Then, select a random Region Type,
			-- Weighted by rarity

			local iMaxRandom = 0
			local iFrequencyMax = 0
			local iFrequencyMin = math.huge

			for iRegionType, tRegionType in ipairs(sRegionTypeMap) do
				tRegionType.Frequency = #tRegionType
				iFrequencyMax = math.max(iFrequencyMax, tRegionType.Frequency)
				iFrequencyMin = math.min(iFrequencyMin, tRegionType.Frequency)
			end
			for iRegionType, tRegionType in ipairs(sRegionTypeMap) do
				local iFrequency = tRegionType.Frequency
				local iRarity = 1 - (iFrequency - iFrequencyMin)/(iFrequencyMax-iFrequencyMin)

				local iRandom = iRarity^4
				iRandom = math.ceil(iRandom * 100)
				iRandom = math.max(iRandom, 1)

				iMaxRandom = iMaxRandom + iRandom
				tRegionType.Max = iMaxRandom
			end

			local tRegionType = sRegionTypeMap[1]
			local iRandom = RandomDebug(iMaxRandom, "Suk: Random Region Type")
			for i,v in ipairs(sRegionTypeMap) do
				if iRandom < v.Max then
					tRegionType = sRegionTypeMap[i]
					break
				end
			end
			--------------------------------
			-- Now, select a random cluster
			-- Weighted by inverse size
			--------------------------------
			local tRandom = {}
			iMaxRandom = 0
			for _, iCluster in ipairs(tRegionType) do
				local tCluster = g_Clusters[iCluster]
				if tCluster.Valid then

					local iSize = tCluster.Passable -- Minimum Size is 4, Maximum is 18
					iSize = (iSize-4)/14 -- 18-4 is 14, hence that number
					iSize = 1-iSize

					local iWeightSize = (2^((10/14)*iSize-10))
					local iRandom = math.ceil(iWeightSize*100)
					iRandom = math.max(iRandom, 1)

					iMaxRandom = iMaxRandom + iRandom
					table.insert(tRandom,
						{
							ID = iCluster,
							Max = iMaxRandom
						}
					)

				end
			end

			if #tRandom < 1 then return end

			local iCluster = tRandom[1].ID
			iRandom = RandomDebug(iMaxRandom, "Suk: Random Region")

			for i,v in ipairs(tRandom) do
				if iRandom < v.Max then
					iCluster = v.ID
					break
				end
			end

			local tCluster = g_Clusters[iCluster]
			tCluster.Selected = true

			return iCluster
		end
	------------------------------------------------------------------
	-- Randomly select clusters until no clusters are valid.
	-- When a cluster is selected, all overlapping clusters are marked invalid
	------------------------------------------------------------------
		while true do
			local iCluster = SelectRandomCluster()
			if not iCluster then break end

			for _, iPlot in ipairs(g_Clusters[iCluster].Nodes) do
				for _, iLoopCluster in ipairs(m_PlotCache[iPlot] ) do
					g_Clusters[iLoopCluster].Valid = false
				end
			end
		end
	------------------------------------------------------------------
	-- Add them to the global list of "Regions"
	------------------------------------------------------------------
		for iCluster, tCluster in ipairs(g_Clusters) do
			if tCluster.Selected then
				table.insert(m_GameRegions, tCluster)
			end
		end
--======================================================================================================================
-- Time to check if regions cover too much of the map and cull them!
--======================================================================================================================
	-- Cull Weights
	local iWeight_RegionTypeFreq	= 4
	local iWeight_RegionDensity		= 6
	local iWeight_RegionSize		= 2
	------------------------------------------------------------------
	-- Count Number of passable Regions
	------------------------------------------------------------------
		local m_PassableCount = 0
		local iWidth, iHeight = Map.GetGridSize()

		for iY = 0, iHeight - 1 do
			for iX = 0, iWidth - 1 do
				local iPlot			= iY * iWidth + iX
				local pPlot			= Map.GetPlotByIndex(iPlot)

				if (not pPlot:IsWater()) and (not pPlot:IsImpassable()) then
					m_PassableCount = m_PassableCount + 1
				end
			end
		end
	------------------------------------------------------------------
	-- Function to calculate region coverage
	------------------------------------------------------------------
		function RegionCoverage(bReturnMore)
			local iPassableRegion = 0

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					iPassableRegion = iPassableRegion + tCluster.Passable
				end
			end

			if bReturnMore then
				return iPassableRegion, m_PassableCount, iPassableRegion/m_PassableCount
			else
				return iPassableRegion/m_PassableCount
			end
		end
	------------------------------------------------------------------
	-- Function to retrieve density per region
	------------------------------------------------------------------
		function RegionDensity()
			local tDensity = {}

			local iMaxDistance = 0
			local iMinDistance = math.huge

			-- First we get the cumulative distance to all other points!
			for iClusterA, tClusterA in pairs(m_GameRegions) do
				if tClusterA.Selected then

					local iDistance = 0

					for iClusterB, tClusterB in pairs(m_GameRegions) do
						if tClusterB.Selected then
							iDistance = iDistance + Map.GetPlotDistance(tClusterA.CenterPlot, tClusterB.CenterPlot)
						end
					end

					iMaxDistance = math.max(iMaxDistance, iDistance)
					iMinDistance = math.min(iMinDistance, iDistance)

					tDensity[iClusterA] = iDistance

				end
			end

			-- We want the regions with a smaller distance to have a higher value
			-- So we subtract the max distance with the cum. distance for each region
			-- This should invert the values

			-- Then we multiply it by 4 and floor it to get an exponent for use later

			local iMaxDifference = iMaxDistance - iMinDistance

			for iCluster, iDistance in pairs(tDensity) do
				tDensity[iCluster] =  math.floor(((iMaxDistance-iDistance)/iMaxDifference))
			end

			return tDensity
		end
	------------------------------------------------------------------
	-- Function to retrieve region type frequency
	------------------------------------------------------------------
		function RegionTypeFrequency()
			local tFrequency = {}
			local tRegionFrequency = {}

			local iMaxFrequency = 0
			local iMinFrequency = math.huge

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					local sRegionType = tCluster.RegionType
					tFrequency[sRegionType] = tFrequency[sRegionType] or 0
					tFrequency[sRegionType] = tFrequency[sRegionType] + 1
				end
			end

			for sRegionType, iCount in pairs(tFrequency) do
				iMaxFrequency = math.max(iMaxFrequency, iCount)
				iMinFrequency = math.min(iMinFrequency, iCount)
			end

			for sRegionType, iCount in pairs(tFrequency) do
				tFrequency[sRegionType] = (iCount-iMinFrequency)/(iMaxFrequency-iMinFrequency)
			end

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					tRegionFrequency[iCluster] = tFrequency[tCluster.RegionType] or 0
				end
			end

			return tRegionFrequency
		end
	------------------------------------------------------------------
	-- Function to retrieve region size stats
	------------------------------------------------------------------
		function RegionSize()
			local tSize = {}

			local iMaxSize = 0
			local iMinSize = math.huge

			local iAvgSize = 0
			local iNumClusters = 0

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					iNumClusters = iNumClusters + 1

					local iSize = #tCluster.Nodes
					iAvgSize = iAvgSize + iSize
				end
			end

			iAvgSize = iAvgSize/iNumClusters

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					local iSize = #tCluster.Nodes
					local iDiff = math.abs(iAvgSize - iSize)

					iMaxSize = math.max(iMaxSize, iDiff)
					iMinSize = math.min(iMinSize, iDiff)

					tSize[iCluster] = iDiff
				end
			end

			local iSizeRange = iMaxSize - iMinSize

			for iCluster, tCluster in pairs(m_GameRegions) do
				if tCluster.Selected then
					tSize[iCluster] = math.floor(((tSize[iCluster]-iMinSize)/iSizeRange))
				end
			end

			return tSize
		end
	------------------------------------------------------------------
	-- While Region Coverage > Threshold, cull regions
	------------------------------------------------------------------
		local Suk_RegionCoverage = tonumber(MapConfiguration.GetValue("Suk_RegionCoverage"))
		local m_RegionCoverageMax = Suk_RegionCoverage/100

		while (RegionCoverage() > m_RegionCoverageMax) do

			local tRandom = {}
			local iMaxRandom = 0

			local tDensity = RegionDensity()
			local tFrequency = RegionTypeFrequency()
			local tSize = RegionSize()

			for iCluster, tCluster in ipairs(m_GameRegions) do
				if tCluster.Selected then

					--local iExponentDensity = tDensity[iCluster] + tFrequency[iCluster] + tSize[iCluster]
					--local iEntries = 2^iExponentDensity

					local iFrequency = tFrequency[iCluster]
					local iWeightFrequency = math.max(math.ceil((2^(10*iFrequency-10))*10*iWeight_RegionTypeFreq), 1)
					local iDensity = tDensity[iCluster]
					local iWeightDensity = math.max(math.ceil((2^(10*iDensity-10))*10*iWeight_RegionDensity), 1)
					local iSize = tSize[iCluster]
					local iWeightSize = math.max(math.ceil((2^(10*iSize-10))*10*iWeight_RegionSize), 1)

					iMaxRandom = iMaxRandom + iWeightFrequency + iWeightDensity + iWeightSize

					table.insert(tRandom,
						{
							ID = iCluster,
							Max = iMaxRandom
						}
					)
				end
			end

			if #tRandom < 1 then break end

			local iCluster = tRandom[1].ID
			local iRandom = RandomDebug(iMaxRandom, "Suk: Random Region")

			for i,v in ipairs(tRandom) do
				if iRandom < v.Max then
					iCluster = v.ID
					break
				end
			end

			m_GameRegions[iCluster].Selected = false
		end
	------------------------------------------------------------------
	-- Remove Culled Regions and reindex
	------------------------------------------------------------------
		local tNewGameRegions = {}

		for iIndex ,tCluster in ipairs(m_GameRegions) do
			if tCluster.Selected then
				table.insert(tNewGameRegions, tCluster)
			end
		end

		m_GameRegions = tNewGameRegions

		for iIndex ,tCluster in ipairs(m_GameRegions) do
			tCluster.Index = iIndex
		end
	------------------------------------------------------------------
	-- Re-cache plot > cluster relationships
	------------------------------------------------------------------
		m_PlotCache	= {}

		for iCluster, tCluster in ipairs(m_GameRegions) do
			for _, iPlot in ipairs(tCluster.Nodes) do
				m_PlotCache[iPlot] = iCluster
			end
		end
	------------------------------------------------------------------
	-- Assign a Random Color to each cluster
	------------------------------------------------------------------
		for iCluster, tCluster in ipairs(m_GameRegions) do

			-- Get Random HSV Value
			-- Not Gameplay critical so we can use math.random here
			local iHue = RandomDebug(361, "SukRegion_RandomHue")/360
			local iSaturation = (RandomDebug(51, "SukRegion_RandomSat")+50)/100
			local iValue = (RandomDebug(21, "SukRegion_RandomVal")+80)/100

			local iR, iG, iB = hsvToRgb(iHue, iSaturation, iValue)

			tCluster.Color = {iR, iG, iB}
		end
--======================================================================================================================
-- Print results and save region info for use elsewhere!
--======================================================================================================================
	print("\t------------------------------------------------")
	print("\t Regions Selected")
	print("\t------------------------------------------------")
	print("\tTotal: ".. #m_GameRegions)
	local tAssignedRegionTypes = {}
	for iRegion, tRegion in pairs(m_GameRegions) do
		local sRegionType = tRegion.RegionType
		tAssignedRegionTypes[sRegionType] = tAssignedRegionTypes[sRegionType] or 0
		tAssignedRegionTypes[sRegionType] = tAssignedRegionTypes[sRegionType] + 1
	end
	for sRegion, iCount in pairs(tAssignedRegionTypes) do
		print((string.format("\t%s: %d", sRegion, iCount)))
	end
	------------------------------------------------------------------

	------------------------------------------------------------------
	print("\t------------------------------------------------")
	print("\t Statistics")
	print("\t------------------------------------------------")

	local iPassableRegion, iPassable, iRegionPercent = RegionCoverage(true)
	local iRegionPercent = iRegionPercent * 100

	print((string.format("\tPassable Tiles, Maximum Setting:\t%d", Suk_RegionCoverage)))
	print((string.format("\tPassable Tiles:\t\t\t%d", iPassable)))
	print((string.format("\tPassable Region Tiles:\t\t%d", iPassableRegion)))
	print((string.format("\tPassable Percent:\t\t\t%.2f", iRegionPercent)))
	------------------------------------------------------------------
	------------------------------------------------------------------
	print("--------------------------------------------------")
	print("--------------------------------------------------")

	Game:SetProperty("Suk_UrbanIdentities_Regions",				m_GameRegions)
	Game:SetProperty("Suk_UrbanIdentities_RegionPlotIndex",		m_PlotCache)
--======================================================================================================================
--======================================================================================================================