local sailorBarbarianNet = GameInfo.Improvements["IMPROVEMENT_BARBARIAN_CAMP"].Index

function Sailor_BOtW_Net(iX, iY, eImprovement, playerID)
	if eImprovement == sailorBarbarianNet then
		Game:SetProperty("SailorBOtWNet_" .. iX .. "_" .. iY, 1)
	end
end
Events.ImprovementAddedToMap.Add(Sailor_BOtW_Net)