--IMPORTANT PARAMETERS:

--local iConversionProbability = 12; -- probability percentage for converting a free city to a city state city on Standard Speed
local bAdjustConversionProbability = true --allows to adjust this probability depending on xml data
local iPercentageDeletedCityStates = 0; --set too 0 to disable sending city state units offmap (sending city states offmap is done in AssignStartingPlots.lua now, so the function DeleteMostClusteredCityState in this file has become obsolete now
local iMaxRangeUnitConvert = 4; -- in this radius a city state will "recruit" units from free cities
--local bInheritCityPlots = false
--local bInheritCityName = false

local iConversionProbability	= GameConfiguration.GetValue("FreeCS_ConversionProbability")
local bInheritCityName			= GameConfiguration.GetValue("FreeCS_InheritCityName")
local bInheritCityPlots			= GameConfiguration.GetValue("FreeCS_InheritCityPlots")

--[[ TODO-List: 
* Improve start locations algorithm in AssignStartingPlots.lua
* ...
]]

--SUPPORT FUNCTIONS:

function GetMinValueInTable( Table )
	local m={} 	
	for k,v in pairs(Table) do				
		m[2]=v --initialize m[2] with a value from the table	
	end		
	for k,v in pairs(Table) do
		if v <= m[2] then
			m[1]=k
			m[2]=v         
		end
	end	
	return m[1], m[2]
end

function DeleteValueFromList( List, Value )
	for i, ListValue in pairs(List) do
		if ListValue == Value then
			table.remove(List, i)
		end
	end
end

function SelectUnitTypeOnMap ( PlayerUnits, sUnitType )
	for ii, pUnit in PlayerUnits:Members() do
		local sUnitName = GameInfo.Units[pUnit:GetType()].UnitType;
		if ( pUnit:GetX() >= 0 and pUnit:GetY() >= 0 and sUnitName == sUnitType) then
			return pUnit;
		end
	end	
	return nil;
end

function HasSettlerOnMap( iPlayerID )
	local pPlayerUnits = Players[iPlayerID]:GetUnits();
	local bHasSettler = false;
	for ii, pUnit in pPlayerUnits:Members() do
		local sUnitName = GameInfo.Units[pUnit:GetType()].UnitType;
		if ( sUnitName == "UNIT_SETTLER" 
			 and pUnit:GetX() >= 0 and pUnit:GetY() >= 0) then 
			bHasSettler = true;
			break;
		end
	end	
	return bHasSettler;
end

function PlayerIsOffmapMinor( iPlayerID )
	local pPlayer = Players[iPlayerID]
	local pPlayerCapital = pPlayer:GetCities():GetCapitalCity();
	local bHasSettler = HasSettlerOnMap( iPlayerID )
	if( not pPlayer:IsMajor() and iPlayerID ~= 62 and iPlayerID ~= 63 and not pPlayerCapital and not bHasSettler ) then 
		return true;
	else 
		return false;
	end
end

function DeleteUnitsOnMap ( iPlayerID )
-- deletes all units of the player; spawns only one settler offmap to make sure the player does not die if it did not found any city yet
	UnitManager.InitUnit(iPlayerID  , "UNIT_SETTLER", -1, -1);	-- offmap-spawn
	local pUnits = Players[iPlayerID]:GetUnits();
	local pUnit;
	for ii, pUnit in pUnits:Members() do
		if(pUnit:GetX() >= 0 or  pUnit:GetY() >= 0) then
			UnitManager.Kill(pUnit, false)
		end
	end	
end

function DeleteUnitsOffMap ( iPlayerID )
-- deletes all offmap units of the player	
	local pUnits = Players[iPlayerID]:GetUnits();
	local pUnit;
	for ii, pUnit in pUnits:Members() do
		if(pUnit:GetX() < 0 or  pUnit:GetY() < 0) then
			UnitManager.Kill(pUnit, false)
		end
	end	
end

local CityDataList = {}
function GetCityDatas ( pCity )
	local kCityDatas :table = {
		iTurn = Game.GetCurrentGameTurn(),
		iPosX = pCity:GetX(),
		iPosY = pCity:GetY(),
		iPop = pCity:GetPopulation()
	};	
	table.insert(CityDataList, kCityDatas)
end

function SetCityPopulation( pCity, iPopulation )
	if ( pCity ) then
		while pCity:GetPopulation() < iPopulation do
			pCity:ChangePopulation(1); --increase pop by +1
		end
	end
end

function SetCityDatas()	 	
	for _, iCityStateID in ipairs(PlayerManager.GetAliveMinorIDs()) do
		local pCities = Players[iCityStateID]:GetCities();
		local pCity;
		for ii, pCity in pCities:Members() do			
			for i, kCityDatas in pairs(CityDataList) do						
				if ( pCity:GetX() == kCityDatas.iPosX and pCity:GetY() == kCityDatas.iPosY ) then
					SetCityPopulation( pCity, kCityDatas.iPop )
				end	
				--table.remove(CityDataList, i) --dont remove items during loop!
			end
		end
	end	
end

function CityHasWorldWonder( pCity )	
--checks if city has a placable building, i.e. a world wonder (assuming every placable building is a wonder)
	local bCityHasWorldWonder = false;
	if ( pCity ) then
		local pCityBuildings = pCity:GetBuildings(); 
		for pBuilding in GameInfo.Buildings() do	
			if ( pCityBuildings:HasBuilding(pBuilding.Index) ) then
				if ( pBuilding.RequiresPlacement and pBuilding.RequiresPlacement == true ) then
					bCityHasWorldWonder = true;
					break;
				end
			end
		end	
	else	
		return; 
	end	
	if ( bCityHasWorldWonder ) then
		return true;
	else
		return false;
	end	
end

function OriginalCityOwnerWasCityState( pCity )
	local iOrigOwner = pCity:GetOriginalOwner();	
	if( not Players[iOrigOwner]:IsMajor() and iPlayerID ~= 62 and iPlayerID ~= 63) then 
		return true, iOrigOwner;
	else
		return false, iOrigOwner;
	end
end

function HasMetMajorCivilization( iPlayerID )
	for i = 0, GameDefines.MAX_PLAYERS-1, 1 do
		if( Players[i]:IsMajor() and Players[i]:GetDiplomacy():HasMet(iPlayerID)) then
			print("Player " .. iPlayerID .. " has met Player " .. i)
			return true;
		end		
	end	
	return false;
end

function CityIsOrginalCapital( pCity )	
	local OriginalCapitalsList = ExposedMembers.GetOriginalCapitals()
	for _, pOriginalCapital in ipairs(OriginalCapitalsList) do		
		if( pCity:GetX() == pOriginalCapital:GetX() and pCity:GetY() == pOriginalCapital:GetY() ) then
			print("City is Original Capital")
			return true;
		end
	end
	return false;
end

function MeetCityStateOnRevealedPlot( iX, iY )
	if( not iX or not iY ) then return; end	
	local pPlot = Map.GetPlot( iX, iY )
	if( not pPlot ) then return; end
	local pCity = Cities.GetCityInPlot( iX, iY )
	if( not pCity ) then return; end
	local iOwnerPlayerID = pCity:GetOwner()
	local kAlivePlayers = PlayerManager.GetAliveMajors()
	for _, pPlayer in ipairs(kAlivePlayers) do
		if( not pPlayer:GetDiplomacy():HasMet(iOwnerPlayerID) ) then
			local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility( pPlayer:GetID() )
			local visibilityType = pLocalPlayerVis:GetState( pPlot:GetIndex() )
			if( visibilityType == 1 ) then --if plot is revealed, but not visible by pPlayer
				pPlayer:GetDiplomacy():SetHasMet( iOwnerPlayerID ) 
			end
		end
	end	
end

local CityUIDataList = {} 
function SetPlayerCityUIDatas( iPlayerID )	
	for _,kCityUIDatas in pairs(CityUIDataList) do
		local pCities = Players[iPlayerID]:GetCities();
		for _, pCity in pCities:Members() do
			if( pCity:GetX() == kCityUIDatas.iPosX and pCity:GetY() == kCityUIDatas.iPosY ) then 
				--Set City Name:
				if (bInheritCityName == true) then pCity:SetName(kCityUIDatas.sCityName); end		
				--Set City Tiles:
				if (bInheritCityPlots == true) then
					for _,kCoordinates in pairs(kCityUIDatas.CityPlotCoordinates) do
						Map.GetPlot(kCoordinates.iX,kCoordinates.iY):SetOwner(iPlayerID, pCity:GetID(), true)
					end
				end
				--Set City Districts:								
				local pCityBuildQueue = pCity:GetBuildQueue();
				for _,kDistrictDatas in pairs(kCityUIDatas.CityDistricts) do 
					local plot = Map.GetPlot(kDistrictDatas.iPosX, kDistrictDatas.iPosY)
					local iDistrictType = kDistrictDatas.iType
					local iConstructionLevel = 100 --complete district					
					pCityBuildQueue:CreateIncompleteDistrict(iDistrictType, plot:GetIndex(), iConstructionLevel)
					--unfortunately we do not have any Lua function that can set a district to pillaged
				end		
				--Set City Buildings:
				for _,kBuildingData in pairs(kCityUIDatas.CityBuildings) do
					local iConstructionLevel = 100 --complete building
					local iBuildingID = kBuildingData.iBuildingID
					local bIsPillaged = kBuildingData.bIsPillaged
					pCityBuildQueue:CreateIncompleteBuilding(iBuildingID, iConstructionLevel)
					pCity:GetBuildings():SetPillaged(iBuildingID, bIsPillaged)
				end
				--Set Religious Pressures:
				for _,kReligionData in pairs(kCityUIDatas.CityReligions) do
					local iPressure = kReligionData.iPressure
					local iReligionType = kReligionData.iReligionType
					-- print("Setting " .. iPressure .. " pressure for Religion " .. iReligionType)
					local iSomeNumber = 0 --I dont know which value to use and probably it does not matter
					pCity:GetReligion():AddReligiousPressure(iSomeNumber, iReligionType , iPressure)
				end
			else
				print("Warning: City not found")
			end
		end		
	end
end

-- MAIN FUNCTIONS:

function DeleteMostClusteredCityState( bDeleteEnabled )
-- Deletes City State that has the least distance to other city state settlers (requires that city states did not found a city yet)
-- Note that there is a bug using this function: The deleted city states will reveal their original start position on the map if you become their souzerain. So this is why this function should not be used.
	local CityStateDistanceSums = {}
	for _, iCityStateID in ipairs(PlayerManager.GetAliveMinorIDs()) do			
		local CityStateUnits = Players[iCityStateID]:GetUnits();		
		local CityStateSettler = SelectUnitTypeOnMap ( CityStateUnits, "UNIT_SETTLER" )
		if ( CityStateSettler and not HasMetMajorCivilization(iCityStateID) ) then
			local DistanceSum = 0;
			for _, iNeighbouredCityStateID in ipairs(PlayerManager.GetAliveMinorIDs()) do	
				local NeighbouredCityStateUnits = Players[iNeighbouredCityStateID]:GetUnits();			
				local NeighbouredCityStateSettler = SelectUnitTypeOnMap ( NeighbouredCityStateUnits, "UNIT_SETTLER" )
				if ( NeighbouredCityStateSettler ) then				
					local Distance = Map.GetPlotDistance(CityStateSettler:GetX(), CityStateSettler:GetY(), NeighbouredCityStateSettler:GetX(), NeighbouredCityStateSettler:GetY())				
					DistanceSum = DistanceSum + Distance
				end			
			end
			CityStateDistanceSums[iCityStateID] = DistanceSum;
		end
	end
	
	if ( bDeleteEnabled ) then
		local iPlayerDelete, _ = GetMinValueInTable( CityStateDistanceSums )		
		if ( iPlayerDelete ) then
			DeleteUnitsOnMap( iPlayerDelete )	
			print("Deleting units of player "..iPlayerDelete)
		end
	end
	
	return CityStateDistanceSums --return table only for debug purposes
end

local FreeCitiesList = {}
function FreeCitiesRandomDraw()
	local pPlayer = Players[62]; -- Free Cities Player	
	local pCities = pPlayer:GetCities();
	local pCity;	
	for ii, pCity in pCities:Members() do		
		if ( pCity and not OriginalCityOwnerWasCityState( pCity ) and not CityIsOrginalCapital(pCity)
			and CityHasWorldWonder(pCity) ~= nil and CityHasWorldWonder(pCity) == false ) then
			local pDistrict = pCity:GetDistricts():GetDistrictAtLocation( pCity:GetX(), pCity:GetY() );	
			local iCityDamage = pDistrict:GetDamage(DefenseTypes.DISTRICT_GARRISON, value);
			local iCityMaxDamage = pDistrict:GetMaxDamage(DefenseTypes.DISTRICT_GARRISON, value);
			local fDamageFactor = 1 - iCityDamage / iCityMaxDamage
			fDamageFactor = fDamageFactor * fDamageFactor 
			local iRandomNumber = math.random()*100
			local iConvProb = iConversionProbability * fDamageFactor
			print("Random Number: " .. iRandomNumber)
			print("Damage Factor of current free city: " .. fDamageFactor)
			print("ConversionProbability * DamageFactor: " .. iConvProb)
			if( iRandomNumber <= iConversionProbability * fDamageFactor ) then
				print ("New Free CS to ADD!!")
				table.insert(FreeCitiesList, pCity);
			end
		end
	end
end

function FreeCityToCityStateConversion( iCityStateID, pCity )
-- iCityStateID is the ID of the Civ that is currently in its own turn and thus able to immeditatly found a city (which the city state AI will as soon as it is possible)
	local pPlayer = Players[62]; -- Free Cities Player
	local pUnits = pPlayer:GetUnits();		
	if ( pCity ) then
		local iX, iY = pCity:GetX(), pCity:GetY();
 		GetCityDatas(pCity)
		CityUIDataList = ExposedMembers.GetPlayerCityUIDatas();		
		Cities.DestroyCity(pCity); --destroy city before spawning city state units to prevent overlaps
		for ii, pUnit in pUnits:Members() do
			local unitX, unitY = pUnit:GetX(), pUnit:GetY(); 
			local iDistance = Map.GetPlotDistance(unitX, unitY, iX, iY)							
			if ( iDistance <= iMaxRangeUnitConvert ) then 
				local pUnitType = GameInfo.Units[pUnit:GetType()].UnitType
				UnitManager.Kill(pUnit, false);								
				UnitManager.InitUnit(iCityStateID, pUnitType, unitX, unitY);
			end				
		end			
		Players[iCityStateID]:GetCities():Create(iX, iY)
		SetCityDatas();		
		SetPlayerCityUIDatas( iCityStateID );
		DeleteUnitsOffMap( iCityStateID );			
		DeleteValueFromList( FreeCitiesList, pCity )
		--make contact:
		MeetCityStateOnRevealedPlot( iX, iY )
	end
end


function OnPlayerTurnActivated( iPlayerID )	
	if( PlayerIsOffmapMinor( iPlayerID ) ) then 
		for ii, pCity in pairs(FreeCitiesList) do			
			FreeCityToCityStateConversion( iPlayerID, pCity )
			print("Creation of City State with Player ID: "..iPlayerID) -- this message is triggered, when the turn of the first city state of this turn has begun. the following city states of this turn are ignored.
			break;				
		end				
	end	
end
GameEvents.PlayerTurnStartComplete.Add(OnPlayerTurnActivated);

local bNewGamesHasBeenInitialized = false;

function OnTurnBegin( iTurn )
	FreeCitiesRandomDraw();
	--print("This is turn "..iTurn)	
end
Events.TurnBegin.Add( OnTurnBegin );

function OnLoadScreenClose()	
	FreeCitiesRandomDraw(); --this function is not only called for Events.TurnBegin. It should be also called after reloading the game save file to allow free city conversions on the first turn after reload as well.
end
Events.LoadScreenClose.Add( OnLoadScreenClose )


function Initialize() 
	local speedModifier = 1;
	local gameSpeed = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].GameSpeedType;
	if(gameSpeed == 'GAMESPEED_ONLINE') then
		speedModifier = .5;
	elseif(gameSpeed == 'GAMESPEED_QUICK') then
		speedModifier = .67;
	elseif(gameSpeed == 'GAMESPEED_EPIC') then
		speedModifier = 1.5;
	elseif(gameSpeed == 'GAMESPEED_MARATHON') then
		speedModifier = 3;
	end
	-- iConversionProbability = iConversionProbability / speedModifier --deleted line in version 1.3
	local iMaxIdentityLoss = GlobalParameters.LOYALTY_PER_TURN_FROM_NEARBY_CITIZEN_PRESSURE_MAX_LOYALTY
	local iFreeCityStartLoyalty = GlobalParameters.LOYALTY_AFTER_TRANSFERRED_BY_CULTURAL_IDENTITY
	-- by default iMaxIdentityLoss / iFreeCityStartLoyalty is 1 / 5
	if( bAdjustConversionProbability == true ) then
		iConversionProbability = iConversionProbability * ( iMaxIdentityLoss / iFreeCityStartLoyalty ) * 5
	end
	print("Conversion Probability: " .. iConversionProbability .. " %")
end

Initialize();

function InitializeNewGame()--Delete Units of some City States. Only store one of their settler offmap to prevent their vanishing.	
	local iMaxCityStateDelete = math.floor( (iPercentageDeletedCityStates/100) * PlayerManager.GetAliveMinorsCount() );
	for i = 1,iMaxCityStateDelete do	
		DeleteMostClusteredCityState(true);
	end
	bNewGamesHasBeenInitialized = true; 
	print("Deleting " .. iPercentageDeletedCityStates "% of City States from Map")
end

LuaEvents.NewGameInitialized.Add(InitializeNewGame);


-- Bugfixes:

function OnUnitAddedToMap( playerID:number, unitID:number )
--This function fixes a bug where a converted city from the Free Cities starts to spawn units of the Free Cities Player. This bug seems to be caused by using the Cities.DestroyCity function on a city of the Free Cities. Even if you do not place a new city on the plot of the destroyed free city the plot will keep spawning free city units. 
--Note that this bug does not occure if you set a free city yourself. It only happens to cities that became free because of loyalty loss.
	if ( playerID == 62 ) then
		local pUnit = UnitManager.GetUnit(playerID, unitID)	
		local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
		if ( pPlot ) then
			local iOwnerID = pPlot:GetOwner()		
			if ( iOwnerID ~= 62 ) then
				UnitManager.Kill(pUnit, false)
				print("Deleting Free City State Unit with ID " .. unitID)
			end			
		end
	end	
end
Events.UnitAddedToMap.Add(OnUnitAddedToMap)

