-- DummyUI
-- Author: Zur13
-- DateCreated: 1/11/2019 7:58:52 PM
--------------------------------------------------------------
local bType = "BUILDING_CMONUMENT";

--******************************************************************************
-- Request construction of Cheat Monument building in the first player city
local function OnCityInitialized(selectedPlayerId, cityId, x, y )
	--print( "CityAddedToMap ", 1, x, y, selectedPlayerId );

	if Players[selectedPlayerId] ~= nil and Players[selectedPlayerId]:IsHuman()
		and Players[selectedPlayerId]:GetCities():GetCount() <= 1 then
		--print( "CityAddedToMap ", 2, x, y, selectedPlayerId );
		local playerCities = Players[selectedPlayerId]:GetCities();
		local capital = playerCities:GetCapitalCity();
		
		if capital == nil then
			for i,city in playerCities:Members() do
				--if city:IsCapital() then
					capital = city;
				--end
			end
		end

		if capital ~= nil then
			--print( "CityAddedToMap ", 3, x, y, selectedPlayerId );
			local cMonumentInfo = nil;
			--capital:GetBuildQueue():CreateBuilding(bType);
			for row in GameInfo.Buildings() do
				--row.BuildingType
				--row.Name
				--print( "CityAddedToMap ####### ", row.BuildingType, row.Name, row.Hash );
				if row.BuildingType == bType then
					--print( "CityAddedToMap FOUND #################################### ", row.BuildingType, row.Name, row.Hash );
					cMonumentInfo = row;
				end
			end
			if cMonumentInfo ~= nil then 
				--print( "CityAddedToMap ", 4, x, y, selectedPlayerId );
				local tParameters = {}; 
				tParameters[CityOperationTypes.PARAM_BUILDING_TYPE] = cMonumentInfo.Hash;  
				tParameters[CityOperationTypes.PARAM_INSERT_MODE] = CityOperationTypes.VALUE_EXCLUSIVE;
				CityManager.RequestOperation(capital, CityOperationTypes.BUILD, tParameters);

				print( "CityAddedToMap Cheat Monument Construction Request ############# ", 5, selectedPlayerId );
				LuaEvents.CMon_FinishProgress(selectedPlayerId, capital:GetID());
			end
		end

		-- TODO: test ##############################################################################################################################################################################################
		--local tImprovements = tResults[UnitOperationResults.IMPROVEMENTS];
		--for i, eImprovement in ipairs(tImprovements) do
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
end

--******************************************************************************
function Initialize()
	print( " ## Initializing Mod Cheat Monument Autobuild Script... ## " );
	
	Events.CityInitialized.Add(OnCityInitialized);	

	print( " ## Initialization finished Mod Cheat Monument Autobuild Script... ## " );
end

Initialize();