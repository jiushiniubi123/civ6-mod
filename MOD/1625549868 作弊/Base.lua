-- Base
-- Author: Zur13
-- DateCreated: 1/11/2019 9:54:38 PM
--------------------------------------------------------------
local bType = "BUILDING_CMONUMENT";

--******************************************************************************
function OnCityProductionChanged( playerId, cityId, productionId, objectId, bCanceled, typeModifier )
	--print( "OnCityProductionChanged ################################################## ", 1, playerId, cityId, productionId, objectId, bCanceled, typeModifier );

	-- Check and remove Cheat Monument if AI city has it
	if Players[playerId] ~= nil and not Players[playerId]:IsHuman() then
		-- AI
		local playerCities = Players[playerId]:GetCities();
		local capital = nil;
		
		if capital == nil then
			for i,city in playerCities:Members() do
				--print( "OnCityProductionChanged City", 2, city:GetID(), playerId, cityId );
				if city:GetID() == cityId then
					--print( "OnCityProductionChanged City FOUND ", 2, playerId, cityId );
					capital = city;

					--print( "OnCityProductionChanged ", 3, capital:GetBuildQueue():CurrentlyBuilding() );
				end
			end
		end

		if capital ~= nil then
			--capital:GetBuildings():RemoveBuilding(bType);

			for building in GameInfo.Buildings() do
				if building.BuildingType == bType and capital:GetBuildings():HasBuilding(building.Index) then
					print( "OnCityProductionChanged AI owning Cheat Monument Detected. Deleting construction... ##################$$$$$$$$$% ", 1, playerId, cityId );
					capital:GetBuildings():RemoveBuilding(building.Index);
					capital:GetBuildQueue():RemoveBuilding(building.Index);
				end
			end 
		end

		if capital ~= nil and bType == capital:GetBuildQueue():CurrentlyBuilding() then
			print( "OnCityProductionChanged Cheat Monument Construction Request  by AI ##################$$$$$$$$$######################################% ", 1, playerId, cityId );
			
			--capital:GetBuildQueue():FinishProgress();
		end
	end
	
	-- Automatically finish HUMAN player Cheat Monument
	if Players[playerId] ~= nil and Players[playerId]:IsHuman() then
		local playerCities = Players[playerId]:GetCities();
		local capital = nil;
		
		if capital == nil then
			for i,city in playerCities:Members() do
				--print( "OnCityProductionChanged City", 2, city:GetID(), playerId, cityId );
				if city:GetID() == cityId then
					--print( "OnCityProductionChanged City FOUND ", 2, playerId, cityId );
					capital = city;

					--print( "OnCityProductionChanged ", 3, capital:GetBuildQueue():CurrentlyBuilding() );
				end
			end
		end
		
		if capital ~= nil and bType == capital:GetBuildQueue():CurrentlyBuilding() then
			print( "OnCityProductionChanged Cheat Monument Construction Request Detected. Completing construction... ", 4, playerId, cityId );
			
			capital:GetBuildQueue():FinishProgress();
		end
	end
	--for eImprovement in GameInfo.Improvements() do
			----tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE] = eImprovement;
			--print(" AAA ", 1, eImprovement["ImprovementType"], eImprovement["TraitType"]);
			--eImprovement["TraitType"] = nil; 
			--DB.Query("UPDATE Improvements SET TraitType=null; "); --WHERE ImprovementType
		--end
--
		--for eImprovement in GameInfo.Improvements() do
			----tParameters[UnitOperationTypes.PARAM_IMPROVEMENT_TYPE] = eImprovement;
			--print(" BBB ", 2, eImprovement["ImprovementType"], eImprovement["TraitType"] );
		--end
--
		--local results = DB.Query("Select ImprovementType, TraitType from Improvements; ");
		--if(results) then
			--for i, row in ipairs(results) do
				--print(" CCC ", 3, row.ImprovementType, row.TraitType );
			--end
		--end
end

--******************************************************************************
function OnCityProductionComplete( playerId, cityId, orderType, objectId, bCanceled, typeModifier )
	--print( "OnCityProductionChanged ################################################## ", 1, playerId, cityId, orderType, objectId, bCanceled, typeModifier );
	if Players[playerId] ~= nil and Players[playerId]:IsHuman() then
		local playerCities = Players[playerId]:GetCities();
		local capital = nil;
		
		if capital == nil then
			for i,city in playerCities:Members() do
				--print( "OnCityProductionChanged City", 2, city:GetID(), playerId, cityId );
				if city:GetID() == cityId then
					--print( "OnCityProductionChanged City FOUND ", 2, playerId, cityId );
					capital = city;

					--print( "OnCityProductionChanged ", 3, capital:GetBuildQueue():CurrentlyBuilding() );
				end
			end
		end
		
		if capital ~= nil then
			print( "OnCityProductionComplete Cheat Monument Construction Request Detected. Deleting construction... ##################$$$$$$$$$% ", 4, playerId, cityId );
			
			capital:GetBuildings():RemoveBuilding(bType);
		end
	end
end

--******************************************************************************
function FinishProgress( playerId, cityId )
	print( "FinishProgress ", 1, playerId, cityId );

	if Players[playerId] ~= nil and Players[playerId]:IsHuman() then
		local playerCities = Players[playerId]:GetCities();
		local capital = nil;
		
		if capital == nil then
			for i,city in playerCities:Members() do
				print( "FinishProgress City", 2, city:GetID(), playerId, cityId );
				if city:GetID() == cityId then
					print( "FinishProgress City FOUND ", 2, playerId, cityId );
					capital = city;
				end
			end
		end

		print( "FinishProgress ", 3, capital:GetBuildQueue():CurrentlyBuilding() );
		if capital ~= nil then
			print( "FinishProgress ", 4, playerId, cityId );
			
			capital:GetBuildQueue():FinishProgress();
		end
	end
end

--******************************************************************************
function Initialize()
	print( " ## Initializing Mod Cheat Monument Base Autobuild Script... ## " );
	
	--LuaEvents.CMon_FinishProgress.Add(FinishProgress);	
	--Events.CityInitialized.Add(OnCityInitialized);	
	Events.CityProductionChanged.Add(OnCityProductionChanged);	

	--Events.CityProductionCompleted.Add(OnCityProductionComplete);	

	print( " ## Initialization finished Mod Cheat Monument Base Autobuild Script... ## " );
end

Initialize();