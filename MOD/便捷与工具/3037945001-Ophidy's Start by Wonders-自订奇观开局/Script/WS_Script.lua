-- Paititi_Start_Script
-- Author: Lazire
-- DateCreated: 9/14/2023 10:32:19 PM
--------------------------------------------------------------
-- 由于更新后直接接入了起始点注册器，这个脚本不再工作
local iTerrain_Mountain		=		GameInfo.TerrainClasses['TERRAIN_CLASS_MOUNTAIN'].Index;
local iTerrain_Water		=		GameInfo.TerrainClasses['TERRAIN_CLASS_WATER'].Index;
local startWondersConfig	=		GameConfiguration.GetValue("START_NATURAL_WONDERS") or {};
local tHumanPlayer			=		{}

function GetValidPlotsInRadiusR(pPlot, iRadius)
	local tTempTable = {}
	if pPlot ~= nil then
		local iPlotX, iPlotY = pPlot:GetX(), pPlot:GetY()
		for dx = (iRadius * -1), iRadius do
			for dy = (iRadius * -1), iRadius do
				local pNearPlot = Map.GetPlotXYWithRangeCheck(iPlotX, iPlotY, dx, dy, iRadius);
				if pNearPlot then
					table.insert(tTempTable, pNearPlot)
				end
			end
		end
	end
	return tTempTable;
end

function Wonder_Start_Initial()
	Game:SetProperty('Wonder_Start', 1)
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if Players[playerID]:IsHuman() then
			table.insert(tHumanPlayer, playerID)
		end
	end
	--local temp = Game.GetRandNum(#tHumanPlayer) + 1
	--print('randnum = '..temp)
	Wonder_Start(tHumanPlayer)
end

function InPlotsNearestToPlot( pPlot, tPlots, mindistance, maxdistance)
	local mindistance = mindistance
	local maxdistance = maxdistance
	local Nearestplot = pPlot
	if (tPlots and #tPlots > 0) then
		for i, plot in ipairs(tPlots) do 
			if plot:GetTerrainClassType() ~= iTerrain_Mountain and plot:GetTerrainClassType() ~= iTerrain_Water and not plot:IsNaturalWonder() then
				tmp = Map.GetPlotDistance( pPlot:GetX(), pPlot:GetY(), plot:GetX(), plot:GetY() )
				if mindistance <= tmp and tmp <= maxdistance then
					Nearestplot = plot
					maxdistance = tmp
				end
			end
		end
	end
	local b = true
	if pPlot == Nearestplot then
		b = false
	end
	return {plot = Nearestplot, bool = b, distance = maxdistance}
end

function InPlotsFarthestToPlot( pPlot, tPlots, mindistance, maxdistance)
	local mindistance = mindistance
	local maxdistance = maxdistance
	local Farthestplot = pPlot
	if (tPlots and #tPlots > 0) then
		for i, plot in ipairs(tPlots) do 
			if plot:GetTerrainClassType() ~= iTerrain_Mountain and plot:GetTerrainClassType() ~= iTerrain_Water and not plot:IsNaturalWonder() then
				tmp = Map.GetPlotDistance( pPlot:GetX(), pPlot:GetY(), plot:GetX(), plot:GetY() )
				if mindistance <= tmp and tmp <= maxdistance then
					Farthestplot = plot
					mindistance = tmp
				end
			end
		end
	end
	local b = true
	if pPlot == Farthestplot then
		b = false
	end
	return {plot = Farthestplot, bool = b, distance = mindistance}
end

function Wonder_Start( tHumanPlayer )
	if not (startWondersConfig and #startWondersConfig > 0) then 
		print('no start wonders selected')
		return;
	end
	-- 获取奇观地块
	local pWonderPlots	=	{};
	for i, w in ipairs(startWondersConfig) do
		local index = GameInfo.Features[w].Index
		pWonderPlots[index] = {}
		print("Wonder has been marked as 'Start by' "..index)
	end

	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do				
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		for i, w in ipairs(startWondersConfig) do
			local NWindex = GameInfo.Features[w].Index
			if pPlot:GetFeatureType() == NWindex then
				pWonderPlots[NWindex] = pWonderPlots[NWindex] or {}
				table.insert( pWonderPlots[NWindex], pPlot ) 
			end
		end
	end
	-- Test
	--[[for i, w in ipairs(startWondersConfig) do
		local NWindex = GameInfo.Features[w].Index
		print(#pWonderPlots[NWindex])
	end]]--

	for i, w in ipairs(startWondersConfig) do
		local NWindex = GameInfo.Features[w].Index
		if #pWonderPlots[NWindex] ~= 0 then
			print('Wonder successfully generated '..NWindex)
			row = {}
			row.NWindex = NWindex
			row.pPlots = pWonderPlots[NWindex]
			table.insert(pWonderPlots, row)
		end
	end


	-- 获取淡水地块
	local pWaterPlots	=	{};
	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do				
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		if pPlot:IsFreshWater() then
			table.insert( pWaterPlots, pPlot ) 
		end
	end

	-- 获取滨海地块（实际上是任何临水地块）
	local pSWaterPlots	=	{};
	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do				
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		if pPlot:IsCoastalLand() then
			table.insert( pSWaterPlots, pPlot ) 
		end
	end

	-- 获取每个奇观并随机排序
	local tNW			=	{};
	for i, row in ipairs(pWonderPlots) do
		selectionRow = {}
		selectionRow.Index = row.NWindex
		selectionRow.Randscore = Game.GetRandNum(100)
		table.insert(tNW, selectionRow)
	end	

	table.sort(tNW, function(a, b) return a.Randscore > b.Randscore; end);

	-- 奇观不够分给场上玩家则不执行后续操作
	if #tNW < #tHumanPlayer then return; end									
		
	-- 获取远离选定奇观大于等于4格的可安置地块
	local reserveplots =	{};
	for iPlotIndex = 0, Map.GetPlotCount()-1, 1 do	
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		local b = true
		if pPlot:GetTerrainClassType() ~= iTerrain_Mountain and pPlot:GetTerrainClassType() ~= iTerrain_Water and not pPlot:IsNaturalWonder() then		
			for i, row in ipairs(pWonderPlots) do
				for j, NWplot in ipairs(row.pPlots) do
					if Map.GetPlotDistance( NWplot:GetX(), NWplot:GetY(), pPlot:GetX(), pPlot:GetY()) < 4 then
						b = false
						break
					end
				end
			end
			if b then
				table.insert(reserveplots, pPlot)
			end
		end
	end

	-- 为玩家随机分配奇观
	local PlayerWonders = {}
	for i, row in ipairs(tNW) do
		selectionRow = {}
		selectionRow.PlayerID = tHumanPlayer[i]
		selectionRow.NWindex = row.Index
		table.insert(PlayerWonders, selectionRow)
		print('Distribute wonder index '..row.Index..' to player '..tHumanPlayer[i])
		if i == #tHumanPlayer then break; end
	end

	-- 重新初始化位置
	for index, row in ipairs(PlayerWonders) do
		
		local playerID		= row.PlayerID
		local NWindex		= row.NWindex
		local pPlayer		= Players[playerID];
		local pPlayerUnits	= pPlayer:GetUnits();
		local pStartPlot	= pPlayer:GetStartingPlot();
		print('Player '..playerID..' re-initialize start position success')

		local tmp = {}
		for i, pUnit in pPlayerUnits:Members() do 
			table.insert(tmp, pUnit)
		end

		-- 获取相对较好的出生位置
		local bestlocation = nil
		local distWater 	= 3
		local distSWater 	= 3
		local b	 			= false
		for i, pWonderPlot in ipairs(pWonderPlots[NWindex]) do
					
			tFW = InPlotsNearestToPlot(pWonderPlot, pWaterPlots, 0, distWater)
			tSW = InPlotsNearestToPlot(pWonderPlot, pSWaterPlots, 0, distSWater)
			if tFW.distance <= distWater and tFW.bool then
				Fplot 	= tFW.plot	
				distWater 		= tFW.distance
			end
			if tSW.distance <= distSWater and tSW.bool then
				Splot = tSW.plot 
				distSWater 	 = tSW.distance
			end
		
		end
		-- 二环滨海地块 优于 三环淡水地块
		if distWater > 2 and distSWater < 3 then
			bestlocation = Splot
		else 
			bestlocation = Fplot
		end
		
		if not bestlocation then
			print('no plot with water available')
			for i, pWonderPlot in ipairs(pWonderPlots[NWindex]) do
				for _, pPlot in ipairs(Map.GetAdjacentPlots(pWonderPlot:GetX(),pWonderPlot:GetY())) do
					if pPlot:GetTerrainClassType() ~= iTerrain_Mountain and pPlot:GetTerrainClassType() ~= iTerrain_Water and not pPlot:IsNaturalWonder() then
						bestlocation = pPlot
					end
				end
			end
		end
		
		-- 没有可用格位（百慕大特供版）
		if not bestlocation then 
			print('no plot available')
			break; 
		end
		
		-- 向玩家揭示奇观
		for i, pPlot in ipairs(pWonderPlots[NWindex]) do
			PlayersVisibility[playerID]:ChangeVisibilityCount(pPlot:GetIndex(), 1)
		end
		
		-- 排斥过于靠近的AI玩家
		for	j, pPlot in ipairs(GetValidPlotsInRadiusR(bestlocation, 4)) do		
			if pPlot:GetUnitCount() > 0 then
				for k, pUnit in ipairs( Units.GetUnitsInPlot( pPlot ) ) do
					local OwnerID 		=	pUnit:GetOwner()
					if OwnerID ~= playerID and not Players[OwnerID]:IsHuman() then
						local mPlayer	= Players[pUnit:GetOwner()];
						local mPlot		= mPlayer:GetStartingPlot();
						--local randplot	= Game.GetRandNum(#reserveplots) + 1
						local ejectplot = mPlot
						if Players[OwnerID]:IsMajor() then
							ejectplot = InPlotsFarthestToPlot(bestlocation, GetValidPlotsInRadiusR(mPlot, 6), 7, 9).plot
						else 
							ejectplot = InPlotsFarthestToPlot(bestlocation, GetValidPlotsInRadiusR(mPlot, 3), 4, 6).plot
						end
						for n, pAiUnit in mPlayer:GetUnits():Members() do
							UnitManager.PlaceUnit(pAiUnit, ejectplot:GetX(), ejectplot:GetY()); 
						end
						print('AI player '..pUnit:GetOwner().."'s units is successfully ejected")
					end
				end
			end
		end
		
		-- 移动玩家单位
		PlayersVisibility[playerID]:ChangeVisibilityCount(bestlocation:GetIndex(), 1)
		for i, pUnit in ipairs(tmp) do	
			UnitManager.PlaceUnit(pUnit, bestlocation:GetX(), bestlocation:GetY()); 
			print('player unit reset successful')
		end
	end
end



function WondersStartScriptInitialize()
	local GameProperty = Game:GetProperty('Wonder_Start') or 0
	if GameProperty == 0 then
		Events.LoadGameViewStateDone.Add( Wonder_Start_Initial );
	else
		Events.LoadGameViewStateDone.Remove( Wonder_Start_Initial );
	end
end


WondersStartScriptInitialize()