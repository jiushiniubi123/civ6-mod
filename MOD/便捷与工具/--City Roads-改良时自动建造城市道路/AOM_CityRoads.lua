function OnImprovementAddedToMap(locationX, locationY, improvementType, eImprovementOwner, resource, isPillaged, isWorked)
	local plot = Map.GetPlot(locationX,locationY);
	local owner = plot:GetOwner();
	if owner >= 0 and owner == eImprovementOwner and not plot:IsWater() then 
		local player = Players[owner];
		local era = GameInfo.Eras[player:GetEra()];
		local currentRouteType = plot:GetRouteType(plot);
		local playerRouteType = GetRouteTypeForPlayer(player);
		if currentRouteType == RouteTypes.NONE or CompareRoutes(playerRouteType,currentRouteType) then
			RouteBuilder.SetRouteType(plot, playerRouteType);
		end
	end
end
function CompareRoutes(a,b)
	return GameInfo.Routes[a].MovementCost < GameInfo.Routes[b].MovementCost;
end
function GetRouteTypeForPlayer(player)
	local route = nil;
	local era = GameInfo.Eras[player:GetEra()];
	for routeType in GameInfo.Routes() do 
		if route == nil then
			route = routeType;
		else
			local prereq_era = GameInfo.Eras[routeType.PrereqEra];
			if prereq_era and era.ChronologyIndex >= prereq_era.ChronologyIndex  then
				route =  routeType;
			end
		end
	end
	return route.Index;
end
Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap);