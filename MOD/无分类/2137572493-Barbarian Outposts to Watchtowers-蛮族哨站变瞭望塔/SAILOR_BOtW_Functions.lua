local iSailorWatchtower = GameInfo.Improvements["IMPROVEMENT_SAILOR_WATCHTOWER"].Index

function Sailor_BOtW_Spawn(iX, iY, eOwner)
	local iValidImpCheck = Game:GetProperty("SailorBOtWNet_" .. iX .. "_" .. iY)
	if iValidImpCheck == 1 then
		local unitList = Units.GetUnitsInPlot(iX, iY)
		--local sailorBotwPowner = -1
		local pPlot = Map.GetPlot(iX,iY)
		if unitList ~= nil then 
			for i, pUnit in ipairs(unitList) do
			--print("test4", pUnit) 
				local sailorBotwPowner = pUnit:GetOwner()
				if sailorBotwPowner ~= -1 then
					--print("test5", sailorBotwPowner) 
					local pPlayer = Players[sailorBotwPowner]
					local pPlayerCities = pPlayer:GetCities()
					local pCap = pPlayerCities:GetCapitalCity()
					--ImprovementBuilder.SetImprovementType(pPlot, -1)
					--WorldBuilder.CityManager():SetPlotOwner(pPlot, pCap)
					ImprovementBuilder.SetImprovementType(pPlot, iSailorWatchtower, sailorBotwPowner)
					Game:SetProperty("SailorBOtWNet_" .. iX .. "_" .. iY, 0)
				end
			end
		end
	end
end
Events.ImprovementRemovedFromMap.Add(Sailor_BOtW_Spawn)