function OnImprovementAddedToMap(locationX, locationY, improvementType, eImprovementOwner, resource, isPillaged, isWorked)
	local plot = Map.GetPlot(locationX,locationY);
	local owner = plot:GetOwner();
	if owner >= 0 and owner == eImprovementOwner and not plot:IsWater() then 
		local player = Players[owner];
		local playerTechs = player:GetTechs();
		-- enable the improvements roads after researching TECH_THE_WHEEL
		if playerTechs:HasTech(10) then
			local era = GameInfo.Eras[player:GetEra()];
			local currentRouteType = plot:GetRouteType(plot);
			local playerRouteType = GetRouteTypeForPlayer(player);
			if currentRouteType == RouteTypes.NONE or CompareRoutes(playerRouteType,currentRouteType) then
				RouteBuilder.SetRouteType(plot, playerRouteType);
			end
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

local m_Tech_Wheel = GameInfo.Technologies['TECH_THE_WHEEL'].Index;
function OnResearchCompleted(ePlayer, eTech)
	-- print('CityRoads:OnResearchCompleted:', 'Player', ePlayer, 'Tech', eTech);
	if ePlayer >= 0 and eTech == m_Tech_Wheel then
		-- place roads on the improvements roads after researching TECH_THE_WHEEL
		local player = Players[ePlayer];
		if not player:IsBarbarian() then
			local pCities = player:GetCities();
			local pCity;
			for i, pCity in pCities:Members() do
				local playerRouteType = GetRouteTypeForPlayer(player);
				local pPlots = pCity:GetOwnedPlots();
				for key, plot in ipairs(pPlots) do
					if not plot:IsWater() and plot:GetImprovementType() >= 0 then
						local currentRouteType = plot:GetRouteType(plot);
						if currentRouteType == RouteTypes.NONE or CompareRoutes(playerRouteType,currentRouteType) then
							RouteBuilder.SetRouteType(plot, playerRouteType);
						end
					end
				end
				
			end
		end
	end
end

Events.ImprovementAddedToMap.Add(OnImprovementAddedToMap);
Events.ResearchCompleted.Add(OnResearchCompleted);