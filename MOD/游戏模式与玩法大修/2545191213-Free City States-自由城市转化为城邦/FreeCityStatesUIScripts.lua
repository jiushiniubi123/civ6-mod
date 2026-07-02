--UI CONTEXT

function GetOriginalCapitals()
	local OriginalCapitalsList = {}	
	for iPlayerID = 0, GameDefines.MAX_PLAYERS-1, 1 do
		local pCities = Players[iPlayerID]:GetCities();	
		if( pCities ) then
			for _, pCity in pCities:Members() do
				if( pCity:IsOriginalCapital() ) then
					table.insert(OriginalCapitalsList, pCity)					
				end
			end
		end
	end	
	return OriginalCapitalsList;
end

function GetPlayerCityUIDatas()
	local CityUIDataList = {}	
	local pCities = Players[62]:GetCities();
	for _, pCity in pCities:Members() do	
		local kCityUIDatas :table = {	
			iPosX = nil,
			iPosY = nil,
			iCityID = nil,
			sCityName = "",
			CityPlotCoordinates = {},
			CityDistricts = {},
			CityBuildings = {},
			CityReligions = {},
		};		
		--General City Datas:
		kCityUIDatas.iPosX = pCity:GetX()
		kCityUIDatas.iPosY = pCity:GetY()		
		kCityUIDatas.iCityID = pCity:GetID()
		kCityUIDatas.sCityName = pCity:GetName()
		--City Tiles Datas:
		local kCityPlots :table = Map.GetCityPlots():GetPurchasedPlots( pCity )				
		for _,plotID in pairs(kCityPlots) do
			local pPlot:table = Map.GetPlotByIndex(plotID);
			local kCoordinates:table = {
				iX = pPlot:GetX(), 
				iY = pPlot:GetY() 
			}
			table.insert(kCityUIDatas.CityPlotCoordinates, kCoordinates)
		end
		--City District Datas:
		local pCityDistricts :table	= pCity:GetDistricts();			
		for _, pDistrict in pCityDistricts:Members() do
			table.insert(kCityUIDatas.CityDistricts, {
				iPosX = pDistrict:GetX(), 
				iPosY = pDistrict:GetY(), 
				iType = pDistrict:GetType(), 
				bPillaged = pCityDistricts:IsPillaged(pDistrict:GetType()),
			});
		end
		--City Buildings Datas: (actually these Datas can also be accessed in gameplay context)
		local pCityBuildings = pCity:GetBuildings()
		for pBuilding in GameInfo.Buildings() do
			if( pCityBuildings:HasBuilding(pBuilding.Index) ) then				
				table.insert(kCityUIDatas.CityBuildings, {				
					iBuildingID = pBuilding.Index,
					bIsPillaged = pCityBuildings:IsPillaged(pBuilding.Index),
				});
			end
		end
		--Religious Pressure Data:
		local pReligions :table = pCity:GetReligion():GetReligionsInCity();
		for _, religionData in pairs(pReligions) do
			table.insert(kCityUIDatas.CityReligions, {
				iReligionType = religionData.Religion,
				iPressure = religionData.Pressure,
			});
		end
		--Save all City Datas:
		table.insert(CityUIDataList, kCityUIDatas)
	end	
	return CityUIDataList;
end

function Initialize() 
	ExposedMembers.GetOriginalCapitals = GetOriginalCapitals
	ExposedMembers.GetPlayerCityUIDatas = GetPlayerCityUIDatas
end
Initialize();

