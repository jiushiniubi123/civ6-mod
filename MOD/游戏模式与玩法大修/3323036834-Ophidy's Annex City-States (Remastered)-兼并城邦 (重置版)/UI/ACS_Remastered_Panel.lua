-- ACS_mastered_Panel
-- Author: Ophidy
-- DateCreated: 8/29/2024 10:06:16 PM
--------------------------------------------------------------
include("GameCapabilities");
include("InstanceManager");
include("ModalScreen_PlayerYieldsHelper");

local debug								:boolean	=	false;
local m_IsXP1Active						:boolean 	=	Modding.IsModActive("1B28771A-C749-434B-9053-D1380C553DE9");
local m_IsXP2Active						:boolean 	= 	Modding.IsModActive("4873eb62-8ccc-4574-b784-dda455e74e68");
local m_CivitasCSEActive							=	function() if GameInfo.CSE_ClassTypes then return true else return false end end;

local m_ACSR_Annex_IM					:table 		= 	InstanceManager:new( "ACSR_Inst_Annex",		"ACSR_InstContainer_Annex",		Controls.ACSR_Annex_InstStack);
local m_ACSR_Review_IM					:table 		= 	InstanceManager:new( "ACSR_Inst_Review",	"ACSR_InstContainer_Review",	Controls.ACSR_Review_InstStack);

local NUM_ENVOY_TOKENS_FOR_FIRST_BONUS	:number 	= 	1;
local NUM_ENVOY_TOKENS_FOR_SECOND_BONUS	:number	 	= 	3;
local NUM_ENVOY_TOKENS_FOR_THIRD_BONUS	:number 	= 	6;
local NUM_ENVOY_TOKENS_FOR_FORTH_BONUS	:number 	= 	10;

local FONT_SIZE_SINGLE_DIGIT_ENVOYS		:number 	= 	34;
local FONT_SIZE_TWO_DIGIT_ENVOYS		:number 	= 	22;
local FONT_SIZE_THREE_DIGIT_ENVOYS		:number 	= 	16;

local AnnexThreshold					:number 	=	GameConfiguration.GetValue("ACSR_THRESHOLD") or 7;
local SPEED_FACTOR						:number		=	GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier / 100;
local m_eThreshold						:number
local m_eGrowth							:number		=	GameConfiguration.GetValue("ACSR_GROWTH") or 2;
local m_eMultiplier						:number		=	GameConfiguration.GetValue("ACSR_COSTMULTIPLIER") or 1;
local m_kCityStates 					:table

local DIPLO_PIP_INFO = {};	
		DIPLO_PIP_INFO["DIPLO_STATE_PROTECTOR"]		= { IconName="ICON_RELATIONSHIP_SUZERAIN",	Tooltip="LOC_CITY_STATES_DIPLO_SUZERAIN"};
		DIPLO_PIP_INFO["DIPLO_STATE_PATRON"]		= { IconName="ICON_RELATIONSHIP_GOOD",		Tooltip="LOC_CITY_STATES_DIPLO_GOOD"};
		DIPLO_PIP_INFO["DIPLO_STATE_AWARE"]			= { IconName="ICON_RELATIONSHIP_NEUTRAL",	Tooltip="LOC_CITY_STATES_DIPLO_AWARE"};
		DIPLO_PIP_INFO["DIPLO_STATE_WAR_WITH_MAJOR"]= { IconName="ICON_RELATIONSHIP_WAR",		Tooltip="LOC_CITY_STATES_DIPLO_WAR"};
		DIPLO_PIP_INFO["DIPLO_STATE_WAR_WITH_MINOR"]= { IconName="ICON_RELATIONSHIP_WAR",		Tooltip="LOC_CITY_STATES_DIPLO_WAR"};
		DIPLO_PIP_INFO["DIPLO_STATE_MINOR_MINOR_WAR"]= { IconName="ICON_RELATIONSHIP_WAR",		Tooltip="LOC_CITY_STATES_DIPLO_WAR"};
		
local m_kCSAbsorb = {}
		for row in GameInfo.GreatPersonIndividualActionModifiers() do
			if row.ModifierId == 'MODFEAT_ACSR_FREE_ANNEX' then
				m_kCSAbsorb[row.GreatPersonIndividualType] = true
			end
		end
		

-- ===========================================================================
function GetData()
	m_kCityStates = {}
	--print('init ACSR panel')
	m_ACSR_Annex_IM:ResetInstances()
	m_ACSR_Review_IM:ResetInstances()
	
	local ilocalPlayer = Game.GetLocalPlayer();
	local plocalPlayer = Players[ilocalPlayer];
	
	m_eThreshold = plocalPlayer:GetProperty('AnnexThreshold') or AnnexThreshold
	
	local kAnnexed = plocalPlayer:GetProperty('ANNEXED_STATES') or {}
	
	Controls.Label_Annex_Threshold:SetText(Locale.Lookup('LOC_ACSR_ANNEX_THRESHOLD',m_eThreshold))
	Controls.Label_Annex_Growth:SetText(Locale.Lookup('LOC_ACSR_ANNEX_GROWTH',m_eGrowth))
	if #kAnnexed > 0 then
		Controls.Label_Review_AnnexedAmount:SetText(Locale.Lookup('LOC_ACSR_ANNEXED_AMOUNT',#kAnnexed))
	else 
		Controls.Label_Review_AnnexedAmount:SetText(Locale.Lookup('LOC_ACSR_ANNEXED_AMOUNT_DEFAULT'))
	end
	
	local index = 1
	for i, iPlayer in ipairs(PlayerManager.GetAliveMinorIDs()) do
		local pMinor = Players[iPlayer]
		local pMinorInf = pMinor:GetInfluence()
		
		if pMinorInf:CanReceiveInfluence() and pMinor:GetCities():GetCapitalCity() and plocalPlayer:GetDiplomacy():HasMet( iPlayer ) then
			local primaryColor, secondaryColor = UI.GetPlayerColors( iPlayer )
			local CanAnnex = pMinorInf:GetTokensReceived(ilocalPlayer) >= m_eThreshold and pMinorInf:GetSuzerain() == ilocalPlayer or false
			local eCost_Gold = 999
			local eCost_Faith = 999
			--local eCost_Favor = 999
			local Annex_Discount = plocalPlayer:GetProperty('ACSR_Annex_Discount') or 0;
			-- Transform it to percentage
			Annex_Discount = Annex_Discount/100;

			eCost_Gold = CalcAnnexCost(iPlayer) * math.max((1 - Annex_Discount), 0)
			eCost_Faith = math.ceil(eCost_Gold/2)
			--eCost_Favor = math.ceil(eCost_Gold/(GlobalParameters.PARAMETER_ACS_FAVOR_MULTIPLIER or 10))
			
			local kCityState = {
				iPlayer = iPlayer,
				Envoys = pMinorInf:GetTokensReceived(ilocalPlayer) or 0,
				IsAtWAr = plocalPlayer:GetDiplomacy():IsAtWarWith(iPlayer) or false,
				Name = PlayerConfigurations[iPlayer]:GetCivilizationShortDescription(),
				Color = secondaryColor,
				Icon = "ICON_"..PlayerConfigurations[iPlayer]:GetCivilizationTypeName(),
				Type = ACSR_GetTypeTooltip(ACSR_GetCityStateType(iPlayer)),
				LevyCost = plocalPlayer:GetInfluence():GetLevyMilitaryCost(iPlayer) or 999,
				IsSuzarain = pMinorInf:GetSuzerain() == ilocalPlayer or false,
				BreakThreshold = pMinorInf:GetTokensReceived(ilocalPlayer) >= m_eThreshold or false,
				CanGoldAnnex = CanAnnex and eCost_Gold < plocalPlayer:GetTreasury():GetGoldBalance() or false,
				CanFaithAnnex = CanAnnex and eCost_Faith < plocalPlayer:GetReligion():GetFaithBalance() or false,

				--													 Idiot Programmer
				--CanFavorAnnex = CanAnnex and eCost_Favor < plocalPlayer:GetFavor() or false,
				CostGoldAnnex = eCost_Gold,
				CostFaithAnnex = eCost_Faith,
				--CostFavorAnnex = eCost_Favor
			};
			
			
			m_kCityStates[index] = kCityState
			index = index + 1
		end
	end
	
	table.sort(m_kCityStates, function(a, b) return a.Envoys > b.Envoys; end);
	
	GenerateCityStates();
	if #kAnnexed >= 0 then
		GenerateAnnexedCityStates(kAnnexed);
	end
	
end

function GenerateAnnexedCityStates(kAnnexed)
	for i, kMinor in ipairs(kAnnexed) do
		AddNewReviewInst(kMinor)
	end
end

function AddNewReviewInst(kMinor)
	local iMinor = kMinor.iPlayer
	local iX, iY = kMinor.X, kMinor.Y
	local iPlayer = Game.GetLocalPlayer()
	local plocalPlayer = Players[iPlayer]
	local New = m_ACSR_Review_IM:GetInstance()
	local cityStateName = Locale.ToUpper(PlayerConfigurations[iMinor]:GetCivilizationShortDescription())
	local primaryColor, secondaryColor = UI.GetPlayerColors( iMinor )
	New.ACSR_Inst_Review_Cityname:SetText( cityStateName )
	New.ACSR_Inst_Review_Cityname:SetToolTipString( Locale.Lookup('LOC_ACSR_CITYNAME_LOOKAT') )
	New.ACSR_Inst_Review_Icon:SetIcon( "ICON_"..PlayerConfigurations[iMinor]:GetCivilizationTypeName())
	New.ACSR_Inst_Review_Icon:SetColor( secondaryColor )
	New.ACSR_Inst_Review_Icon:SetToolTipString(Locale.Lookup(ACSR_GetTypeTooltip(ACSR_GetCityStateType(iMinor)))..'[NewLINE]'..ACSR_GetBonusText(iMinor))
	-- All annexed states are assimilated (city destroyed, bonuses permanent)
	New.ACSR_ReviewStacks:SetHide(true)
	New.ACSR_Assimilated_tip:SetHide(false)
	New.ACSR_Inst_Review_SuzerainBonus:SetText(GetSuzerainBonusText(iMinor))
end

-- ReleaseCityState and AssimilateCityState removed — no longer needed since CS is destroyed on annex

function GenerateCityStates()
	for i, kCityState in ipairs(m_kCityStates) do
		AddNewAnnexInst(kCityState)
	end
end

function AddNewAnnexInst(kCityState)
	local ilocalPlayer = Game.GetLocalPlayer()
	local plocalPlayer = Players[ilocalPlayer]
	local New = m_ACSR_Annex_IM:GetInstance()
	local iPlayer = kCityState.iPlayer

	SetRelationPip(iPlayer,New.ACSR_DiplomacyPip)
	
	New.ACSR_Inst_Annex_Cityname:SetText( Locale.ToUpper(kCityState.Name) )
	--New.ACSR_Inst_Annex_Cityname:SetToolTipString( Locale.Lookup('LOC_ACSR_CITYNAME_LOOKAT') )
	New.ACSR_Inst_Annex_Icon:SetIcon(kCityState.Icon)
	New.ACSR_Inst_Annex_Icon:SetColor(kCityState.Color)
	New.ACSR_Inst_Annex_Icon:SetToolTipString(Locale.Lookup(kCityState.Type))
	
	New.ACSR_EnvoyCircle:SetToolTipString(ACSR_GetBonusTextAnnex(iPlayer))
	
	New.ACSR_Inst_Annex_Lookat:RegisterCallback(Mouse.eLClick,function() Close() LookAtCityState(iPlayer) LuaEvents.PartialScreenHooks_OpenCityStates() end)
	
	RealizeEnvoyToken(kCityState.Envoys,New.ACSR_Inst_Annex_Envoys)
	New.ACSR_Inst_Annex_SuzerainBonus:SetText(GetSuzerainBonusText(iPlayer))
	
	
	
	local GoldButtonToolTip = Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_TOOLTIP', kCityState.CostGoldAnnex..' [ICON_GOLD] '..Locale.Lookup('LOC_YIELD_GOLD_NAME'))
	local FaithButtonToolTip = Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_TOOLTIP', kCityState.CostFaithAnnex..' [ICON_FAITH] '..Locale.Lookup('LOC_YIELD_FAITH_NAME'))
	--local FavorButtonToolTip = Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_TOOLTIP', kCityState.CostFavorAnnex..' [ICON_FAVOR] '..Locale.Lookup('LOC_DIPLOMATIC_FAVOR_NAME'))

	if not kCityState.IsSuzarain then
		GoldButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_SUZERAIN')..'[NEWLINE]'..GoldButtonToolTip
		FaithButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_SUZERAIN')..'[NEWLINE]'..FaithButtonToolTip
		--FavorButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_SUZERAIN')..'[NEWLINE]'..FavorButtonToolTip
	elseif not kCityState.BreakThreshold then
		GoldButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_BREAKTHRESHOLD')..'[NEWLINE]'..GoldButtonToolTip
		FaithButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_BREAKTHRESHOLD')..'[NEWLINE]'..FaithButtonToolTip
		--FavorButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_BREAKTHRESHOLD')..'[NEWLINE]'..FavorButtonToolTip
	else
		if not kCityState.CanGoldAnnex then
			GoldButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_ENOUGHGOLD')..'[NEWLINE]'..GoldButtonToolTip
		end
		if not kCityState.CanFaithAnnex then
			FaithButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_ENOUGHFAITH')..'[NEWLINE]'..FaithButtonToolTip
		end
		--[[if not kCityState.CanFavorAnnex then
			FavorButtonToolTip = Locale.Lookup('LOC_ACSR_NOT_ENOUGHFAVOR')..'[NEWLINE]'..FavorButtonToolTip
		end]]--
	end
	--[[
	New.ACSR_Inst_Annex_Button_Favor:SetDisabled(not kCityState.CanFavorAnnex)
	New.ACSR_Inst_Annex_Button_Favor:SetText(Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_STRING',kCityState.CostFavorAnnex..' [ICON_FAVOR_LARGE]'))
	New.ACSR_Inst_Annex_Button_Favor:SetToolTipString(Locale.Lookup(FavorButtonToolTip))
	New.ACSR_Inst_Annex_Button_Favor:RegisterCallback(Mouse.eLClick,
		function()
			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, 
				{iMinor = iPlayer, Currency = 'Favor', Cost = kCityState.CostFavorAnnex, OnStart = "ACSR_AnnexCityState"}
			)
			UI.PlaySound("Purchase_With_Gold");
			Network.BroadcastPlayerInfo()
			Close()
		end
		)
]]--
	New.ACSR_Inst_Annex_Button_Gold:SetDisabled(not kCityState.CanGoldAnnex)
	New.ACSR_Inst_Annex_Button_Gold:SetText(Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_STRING',kCityState.CostGoldAnnex..' [ICON_GOLDLARGE]'))
	New.ACSR_Inst_Annex_Button_Gold:SetToolTipString(Locale.Lookup(GoldButtonToolTip))
	New.ACSR_Inst_Annex_Button_Faith:SetDisabled(not kCityState.CanFaithAnnex)
	New.ACSR_Inst_Annex_Button_Faith:SetText(Locale.Lookup('LOC_ACSR_ANNEX_BUTTON_STRING',kCityState.CostFaithAnnex..' [ICON_FAITHLARGE]'))
	New.ACSR_Inst_Annex_Button_Faith:SetToolTipString(Locale.Lookup(FaithButtonToolTip))

	New.ACSR_Inst_Annex_Button_Gold:RegisterCallback(Mouse.eLClick,
		function()
			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, 
				{iMinor = iPlayer, Currency = 'Gold', Cost = kCityState.CostGoldAnnex, OnStart = "ACSR_AnnexCityState"}
			)
			UI.PlaySound("Purchase_With_Gold");
			Network.BroadcastPlayerInfo()
			Close()
		end
		)
	
	New.ACSR_Inst_Annex_Button_Faith:RegisterCallback(Mouse.eLClick,
		function()
			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, 
				{iMinor = iPlayer, Currency = 'Faith', Cost = kCityState.CostFaithAnnex, OnStart = "ACSR_AnnexCityState"}
			)
			UI.PlaySound("Purchase_With_Faith");
			Network.BroadcastPlayerInfo()
			Close()
		end
		)
		
end


-- ===========================================================================

function SetRelationPip(iPlayer, control)
	local ilocalPlayer = Game.GetLocalPlayer()
	local plocalPlayer = Players[ilocalPlayer]
	local pMinor = Players[iPlayer]
	local diploStateID = pMinor:GetDiplomaticAI():GetDiplomaticStateIndex( ilocalPlayer )
	local DiploState = GameInfo.DiplomaticStates[diploStateID].StateType;
	local iconName = DIPLO_PIP_INFO[DiploState].IconName;
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(iconName, 23);
	local tooltip	:string = Locale.Lookup( DIPLO_PIP_INFO[DiploState].Tooltip );
	
	control:SetHide(DiploState ~= 'DIPLO_STATE_WAR_WITH_MAJOR')
	control:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	control:SetToolTipString(tooltip);
end

function RealizeEnvoyToken( total:number, control:table )	
	if total < 10 then
		control:SetFontSize(FONT_SIZE_SINGLE_DIGIT_ENVOYS);
	elseif total < 100 then
		control:SetFontSize(FONT_SIZE_TWO_DIGIT_ENVOYS);
	else		
		control:SetFontSize(FONT_SIZE_THREE_DIGIT_ENVOYS);	-- So much envoy!
	end
	control:SetText( total );
end

function CalcAnnexCost(iPlayer)
	local ilocalPlayer = Game.GetLocalPlayer()
	local plocalPlayer = Players[ilocalPlayer]
	
	local pMinor = Players[iPlayer]
	local pMinorInf = pMinor:GetInfluence()
	local pCity = pMinor:GetCities():GetCapitalCity()
	
	local eEnvoys = pMinorInf:GetTokensReceived(ilocalPlayer)
	local ePop = pCity:GetPopulation() or 1
	local eDistrict = (pCity:GetDistricts():GetNumDistricts() or 1) - 1
	local eDistance = math.min((Map.GetPlotDistance(pCity:GetX(),pCity:GetY(),plocalPlayer:GetCities():GetCapitalCity():GetX(),plocalPlayer:GetCities():GetCapitalCity():GetY()) or 1),(GlobalParameters.PARAMETER_ACSR_MAX_DISTANCE_FACTOR or 12))
	local eTotalOtherEnvoys = 0
		for i, iMajor in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if iMajor ~= ilocalPlayer then
				eTotalOtherEnvoys = eTotalOtherEnvoys + pMinorInf:GetTokensReceived(iMajor) or 0
			end
		end
	local ePlayerCities = plocalPlayer:GetCities():GetCount() or 1
	
	-- New formula: stronger city-state = cheaper (inverted pop/district)
	-- Base cost halved; added player city count factor (more cities = more expensive)
	local eCost = math.ceil(
		((GlobalParameters.PARAMETER_ACSR_BASE_COST or 50) + (plocalPlayer:GetInfluence():GetLevyMilitaryCost(iPlayer) or 0)) * 
		((GlobalParameters.PARAMETER_ACSR_POP_FACTOR or 10) / (ePop + (GlobalParameters.PARAMETER_ACSR_POP_FACTOR or 10))) * 
		((GlobalParameters.PARAMETER_ACSR_DISTRICT_FACTOR or 4) / (eDistrict + (GlobalParameters.PARAMETER_ACSR_DISTRICT_FACTOR or 4))) *
		((eDistance + (GlobalParameters.PARAMETER_ACSR_DISTANCE_FACTOR or 24)) / (GlobalParameters.PARAMETER_ACSR_DISTANCE_FACTOR or 24)) * 
		((m_eThreshold) / math.max(eEnvoys, m_eThreshold)) *
		(math.min((GlobalParameters.PARAMETER_ACSR_ENVOY_DIFF_FACTOR_MAX or 2), math.max(eTotalOtherEnvoys, eEnvoys) / eEnvoys)) *
		((ePlayerCities + (GlobalParameters.PARAMETER_ACSR_CITY_COUNT_FACTOR or 5)) / (GlobalParameters.PARAMETER_ACSR_CITY_COUNT_FACTOR or 5)) *
		SPEED_FACTOR
		)
		
	if debug then 
		print(tostring((GlobalParameters.PARAMETER_ACSR_BASE_COST or 50) + (plocalPlayer:GetInfluence():GetLevyMilitaryCost(iPlayer) or 0)))
		print(tostring((GlobalParameters.PARAMETER_ACSR_POP_FACTOR or 10) / (ePop + (GlobalParameters.PARAMETER_ACSR_POP_FACTOR or 10))))
		print(tostring((GlobalParameters.PARAMETER_ACSR_DISTRICT_FACTOR or 4) / (eDistrict + (GlobalParameters.PARAMETER_ACSR_DISTRICT_FACTOR or 4))))
		print(tostring((eDistance + (GlobalParameters.PARAMETER_ACSR_DISTANCE_FACTOR or 24)) / (GlobalParameters.PARAMETER_ACSR_DISTANCE_FACTOR or 24)))
		print(tostring(((m_eThreshold) / math.max(eEnvoys, m_eThreshold))))
		print(tostring(math.min((GlobalParameters.PARAMETER_ACSR_ENVOY_DIFF_FACTOR_MAX or 2), math.max(eTotalOtherEnvoys, eEnvoys) / eEnvoys)))
		print(tostring((ePlayerCities + (GlobalParameters.PARAMETER_ACSR_CITY_COUNT_FACTOR or 5)) / (GlobalParameters.PARAMETER_ACSR_CITY_COUNT_FACTOR or 5)))
	end
	eCost = eCost * m_eMultiplier
	return eCost
end

function GetSuzerainBonusText( iPlayer:number )

	local leader	:string = PlayerConfigurations[iPlayer]:GetLeaderTypeName();
	local leaderInfo:table	= GameInfo.Leaders[leader];
	if leaderInfo == nil then
		UI.DataError("GetSuzerainBonusText, cannot determine the type of city state suzerain bonus for player #: "..tostring(iPlayer) );
		return "UNKNOWN";
	end

	local text		:string = "";
	
	-- Unique Bonus
	for leaderTraitPairInfo in GameInfo.LeaderTraits() do
		if (leader ~= nil and leader == leaderTraitPairInfo.LeaderType) then
			local traitInfo : table = GameInfo.Traits[leaderTraitPairInfo.TraitType];
			if (traitInfo ~= nil) then
				local name = PlayerConfigurations[iPlayer]:GetCivilizationShortDescription();
				text = text .. "[COLOR:SuzerainDark]" .. Locale.Lookup("LOC_CITY_STATES_SUZERAIN_UNIQUE_BONUS", name) .. "[ENDCOLOR] ";
				if traitInfo.Description ~= nil then
					text = text .. Locale.Lookup(traitInfo.Description);
				end
			end
		end
	end	

	return text;
end

function LookAtCityState( iPlayer:number, iX, iY)
	if iX and iY then
		UI.LookAtPlotScreenPosition( iX, iY, 0.5, 0.5 );
	else
		local pPlayer		:table = Players[iPlayer];
		local pCapital		:table = pPlayer:GetCities():GetCapitalCity();
	
		UI.LookAtPlotScreenPosition( pCapital:GetX(),  pCapital:GetY(), 0.5, 0.5 );
	end
end

function GetBonusText( iPlayer:number, envoyTokenNum:number )
	local leader	:string = PlayerConfigurations[iPlayer]:GetLeaderTypeName();
	local leaderInfo:table	= GameInfo.Leaders[leader];
	if leaderInfo == nil or leaderInfo.InheritFrom == nil then
		UI.DataError("Cannot determine the type of city state bonus for player #: "..tostring(iPlayer) );
		return "UNKNOWN";
	end

	local bonusTypeText = "";
	if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusTypeText = Locale.Lookup("LOC_MINOR_CIV_SMALL_INFLUENCE_ENVOYS");
	elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusTypeText = Locale.Lookup("LOC_MINOR_CIV_MEDIUM_INFLUENCE_ENVOYS");
	elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusTypeText = Locale.Lookup("LOC_MINOR_CIV_LARGE_INFLUENCE_ENVOYS");
	else UI.DataError("Unknown envoy number for city-state type bonus:" .. tostring(envoyTokenNum));
	end
	
	local bonusDetailsText = "";
	if (leader == "LEADER_MINOR_CIV_SCIENTIFIC" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_SCIENTIFIC") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_SCIENTIFIC_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_SCIENTIFIC_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_SCIENTIFIC_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	elseif (leader == "LEADER_MINOR_CIV_RELIGIOUS" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_RELIGIOUS") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_RELIGIOUS_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_RELIGIOUS_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_RELIGIOUS_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	elseif (leader == "LEADER_MINOR_CIV_TRADE" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_TRADE") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_TRADE_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_TRADE_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_TRADE_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	elseif (leader == "LEADER_MINOR_CIV_CULTURAL" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_CULTURAL") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_CULTURAL_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_CULTURAL_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_CULTURAL_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	elseif (leader == "LEADER_MINOR_CIV_MILITARISTIC" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_MILITARISTIC") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_MILITARISTIC_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_MILITARISTIC_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_MILITARISTIC_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	elseif (leader == "LEADER_MINOR_CIV_INDUSTRIAL" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_INDUSTRIAL") then
		if envoyTokenNum == NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_INDUSTRIAL_TRAIT_SMALL_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_INDUSTRIAL_TRAIT_MEDIUM_INFLUENCE_BONUS");
		elseif envoyTokenNum == NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then bonusDetailsText = Locale.Lookup("LOC_MINOR_CIV_INDUSTRIAL_TRAIT_LARGE_INFLUENCE_BONUS");
		else UI.DataError("Unknown envoy number for city-state type bonus: " .. tostring(envoyTokenNum));
		end
	else
		UI.DataError("Unknown leader type for city-state type bonus");
	end

	return bonusTypeText, bonusDetailsText;
end

function ACSR_GetCityStateType( iPlayer:number )
	local leader = PlayerConfigurations[ iPlayer ]:GetLeaderTypeName();
	local Type = GameInfo.Leaders[leader].InheritFrom:gsub('LEADER_MINOR_CIV_','')

	return Type;
end

function ACSR_GetTypeTooltip( Type:string )
	local toolTip		:string;
	if not m_CivitasCSEActive() then
		if	   Type == "SCIENTIFIC"		then	toolTip	 = "LOC_CITY_STATES_TYPE_SCIENTIFIC";
		elseif Type == "RELIGIOUS"		then	toolTip	 = "LOC_CITY_STATES_TYPE_RELIGIOUS";
		elseif Type == "TRADE"			then	toolTip	 = "LOC_CITY_STATES_TYPE_TRADE";
		elseif Type == "CULTURAL"		then	toolTip	 = "LOC_CITY_STATES_TYPE_CULTURAL";
		elseif Type == "MILITARISTIC"	then	toolTip	 = "LOC_CITY_STATES_TYPE_MILITARISTIC";
		elseif Type == "INDUSTRIAL"		then	toolTip	 = "LOC_CITY_STATES_TYPE_INDUSTRIAL";
		else
			UI.DataError("WARNING: Unknown type '"..Type.."' for getting the City-State tooltip.");
			return 0,0,"","";
		end
	elseif m_CivitasCSEActive() then
		local index = 0
		for row in GameInfo.CSE_ClassTypes() do
			if row.Type == Type then
				break
			end
			index = index + 1
		end
		
		toolTip  = GameInfo.CSE_ClassTypes[index].TypeName
	end
	return toolTip;
end

function ACSR_GetBonusTextAnnex( iPlayer )
	local ilocalPlayer = Game.GetLocalPlayer()
	local plocalPlayer = Players[ilocalPlayer]
	local pMinor = Players[iPlayer]
	local pMinorInf = pMinor:GetInfluence()
	local eEnvoys = pMinorInf:GetTokensReceived(ilocalPlayer)
	local ACS_BonusText
	if eEnvoys > 0 then
		ACS_BonusText = Locale.Lookup('LOC_ACSR_ENVOYS_RECEIVED_HEADER',eEnvoys)
	else
		ACS_BonusText = Locale.Lookup('LOC_ACSR_ENVOYS_RECEIVED_HEADER_DEFAULT')
	end
	if plocalPlayer:GetDiplomacy():IsAtWarWith(iPlayer) then
		return ACS_BonusText
	end
	
	if not m_CivitasCSEActive() then
		
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then
			title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_FIRST_BONUS)
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..detail
		end
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then
			title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_SECOND_BONUS)
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..detail
		end
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then
			title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_THIRD_BONUS)
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..detail
		end
	elseif m_CivitasCSEActive() then
		local index = 0
		local leader = PlayerConfigurations[ iPlayer ]:GetLeaderTypeName();
		local Type = GameInfo.Leaders[leader].InheritFrom:gsub('LEADER_MINOR_CIV_','')
		for row in GameInfo.CSE_ClassTypes() do
			if Type == row.Type then
				break
			end
			index = index + 1
		end
		
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_FIRST_BONUS then
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..Locale.Lookup(GameInfo.CSE_ClassTypes[index].SmallBonus)
		end
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_SECOND_BONUS then
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..Locale.Lookup(GameInfo.CSE_ClassTypes[index].MediumBonus)
		end
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_THIRD_BONUS then
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..Locale.Lookup(GameInfo.CSE_ClassTypes[index].LargeBonus)
		end
		if eEnvoys >= NUM_ENVOY_TOKENS_FOR_FORTH_BONUS then
			ACS_BonusText = ACS_BonusText..'[NewLINE]'..Locale.Lookup(GameInfo.CSE_ClassTypes[index].LargestBonus)
		end
	end
	
	return ACS_BonusText
end

function ACSR_GetBonusText( iPlayer )
	local ACS_BonusText =  ''
	if not m_CivitasCSEActive() then
		
		title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_FIRST_BONUS)
		ACS_BonusText = ACS_BonusText..detail
		title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_SECOND_BONUS)
		ACS_BonusText = ACS_BonusText..'[NewLINE]'..detail
		title, detail = GetBonusText(iPlayer,NUM_ENVOY_TOKENS_FOR_THIRD_BONUS)
		ACS_BonusText = ACS_BonusText..'[NewLINE]'..detail
			
		
	elseif m_CivitasCSEActive() then
		local index = 0
		local leader = PlayerConfigurations[ iPlayer ]:GetLeaderTypeName();
		local Type = GameInfo.Leaders[leader].InheritFrom:gsub('LEADER_MINOR_CIV_','')
		for row in GameInfo.CSE_ClassTypes() do
			if Type == row.Type then
				break
			end
			index = index + 1
		end

		ACS_BonusText = ACS_BonusText..Locale.Lookup(GameInfo.CSE_ClassTypes[index].SmallBonus)..'[NewLINE]'
		ACS_BonusText = ACS_BonusText..Locale.Lookup(GameInfo.CSE_ClassTypes[index].MediumBonus)..'[NewLINE]'
		ACS_BonusText = ACS_BonusText..Locale.Lookup(GameInfo.CSE_ClassTypes[index].LargeBonus)..'[NewLINE]'
		ACS_BonusText = ACS_BonusText..Locale.Lookup(GameInfo.CSE_ClassTypes[index].LargestBonus)
	end
	
	return ACS_BonusText
end

-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then
        Open()
    end
end

function OnInputHandler(pInputStruct:table)
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
		if not ContextPtr:IsHidden() then
			CloseACSPanel();
		end
		return true;
	end
	return false;
end

function OnTogglePanel()
	--print('OnTogglePanel')
	if ContextPtr:IsHidden() then
		Open()
	else
		CloseACSPanel()
	end
end

function Open()	
	GetData()
	ContextPtr:SetHide(false);
	
	if not UIManager:IsInPopupQueue(ContextPtr) then
        local kParameters = {};
        kParameters.RenderAtCurrentParent = true;
        kParameters.InputAtCurrentParent = true;
        kParameters.AlwaysVisibleInQueue = true;
        UIManager:QueuePopup(ContextPtr, PopupPriority.Low, kParameters);
        -- Change our parent to be 'Screens' so the navigational hooks draw on top of it.
        ContextPtr:ChangeParent(ContextPtr:LookUpControl("/InGame/Screens"));
        UI.PlaySound("UI_Screen_Open");
        --LuaEvents.QDDealPopup_Opened();
    end
	
	-- From ModalScreen_PlayerYieldsHelper
	if not RefreshYields() then
		local _, height	= UIManager:GetScreenSizeVal();
		Controls.Vignette:SetSizeY(height - TOP_PANEL_OFFSET);
	end
	
	Controls.ScreenAnimIn:SetToBeginning();
	Controls.ScreenAnimIn:Play();
	LuaEvents.ACSR_Panel_Opened();
	
	local launchContainer = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchContainer");
	local _, height	= UIManager:GetScreenSizeVal();
	if height <= 850 then
		launchContainer:SetOffsetY(-35);
	end
end

function Close()
	UIManager:DequeuePopup(ContextPtr);
	ContextPtr:SetHide(true);
end

function CloseACSPanel()
	if not ContextPtr:IsHidden() then
		Close();
		LuaEvents.ACSR_Panel_Closed();
		-- reset launchbar
		LuaEvents.GovernorPanel_Closed();
	end
end

function CloseOtherPanels()
    LuaEvents.LaunchBar_CloseTechTree()
    LuaEvents.LaunchBar_CloseCivicsTree()
    LuaEvents.LaunchBar_CloseGovernmentPanel()
    LuaEvents.LaunchBar_CloseReligionPanel()
    LuaEvents.LaunchBar_CloseGreatPeoplePopup()
    LuaEvents.LaunchBar_CloseGreatWorksOverview()
	LuaEvents.PartialScreenHooks_CloseCityStates()
    if m_IsXP1Active then
        LuaEvents.GovernorPanel_Close()
        LuaEvents.HistoricMoments_Close()
    end
    if m_IsXP2Active then
        LuaEvents.Launchbar_Expansion2_ClimateScreen_Close()
    end
end

-- ===========================================================================
function ACSR_UnitGreatPersonActivated( unitOwner:number, unitID:number, greatPersonClassID:number, greatPersonIndividualID:number )
	if (unitOwner == Game.GetLocalPlayer()) then
		local GreatPersonIndividualInfo = GameInfo.GreatPersonIndividuals[greatPersonIndividualID]
		local GreatPersonIndividualType = GreatPersonIndividualInfo.GreatPersonIndividualType
		local player = Players[unitOwner];
		local unit = player:GetUnits():FindID(unitID);
		if m_kCSAbsorb[GreatPersonIndividualType] then
		
			local pPlot = Map.GetPlot(unit:GetX(), unit:GetY())
			local pCityState = Cities.GetPlotPurchaseCity(pPlot)
			local iPlayer = pCityState:GetOwner()
			UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.EXECUTE_SCRIPT, 
				{iMinor = iPlayer, Currency = 'Gold', Cost = 0, OnStart = "ACSR_AnnexCityState", FreeAnnex = true}
			)
		
		end
	end
end

-- ===========================================================================
function Initialize()

	ContextPtr:SetHide(true);
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetInputHandler( OnInputHandler, true );

	Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, CloseACSPanel);

	Events.TurnBegin.Add(Close)
	LuaEvents.ACSR_TogglePopup.Add(OnTogglePanel);
	LuaEvents.ACSR_Panel_Opened.Add(CloseOtherPanels);
	

	LuaEvents.DiplomacyActionView_HideIngameUI.Add(Close)
    LuaEvents.EndGameMenu_Shown.Add(Close)
    LuaEvents.FullscreenMap_Shown.Add(Close)
    LuaEvents.NaturalWonderPopup_Shown.Add(Close)
    LuaEvents.ProjectBuiltPopup_Shown.Add(Close)
    LuaEvents.Tutorial_ToggleInGameOptionsMenu.Add(Close)
    LuaEvents.WonderBuiltPopup_Shown.Add(Close)
    LuaEvents.NaturalDisasterPopup_Shown.Add(Close)  
    LuaEvents.RockBandMoviePopup_Shown.Add(Close)
	LuaEvents.CivicsTree_OpenCivicsTree.Add(Close);	
	LuaEvents.Government_OpenGovernment.Add(Close);
	LuaEvents.GovernorPanel_Opened.Add(Close);	
	LuaEvents.GreatPeople_OpenGreatPeople.Add(Close);
	LuaEvents.GreatWorks_OpenGreatWorks.Add(Close);
	LuaEvents.HistoricMoments_Opened.Add(Close);
	LuaEvents.Religion_OpenReligion.Add(Close);	
	LuaEvents.PantheonChooser_OpenReligion.Add(Close);	
	LuaEvents.TechTree_OpenTechTree.Add(Close);
	LuaEvents.ClimateScreen_Opened.Add(Close);
	
	Events.FaithChanged.Add( Close );
	Events.TreasuryChanged.Add( Close );	
	Events.InfluenceChanged.Add( Close );
	Events.InfluenceGiven.Add( Close );
	Events.CityLiberated.Add( Close );
	Events.DiplomacyDeclareWar.Add( Close );
	Events.DiplomacyMakePeace.Add( Close );
	
	
	-- Adjust Raffles
	Events.UnitGreatPersonActivated.Add(ACSR_UnitGreatPersonActivated)
end

Initialize();

include('ACSR_UI_',true)