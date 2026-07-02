
GameEvents = ExposedMembers.GameEvents;
local tLocalPlayers = {};
local tCache = {};
-- local iCityPopChangedNotificationHash = NotificationTypes.USER_DEFINED_9;
local iCityGrowthNotificationHash = NotificationTypes.USER_DEFINED_8;
local iDealExpiredNotificationHash = NotificationTypes.USER_DEFINED_7;
local iReligionNotificationHash = NotificationTypes.USER_DEFINED_6;
-- local pCityPopUp = nil;
-- print('CN_RELIGION_SPREAD', GameInfo.CN_Settings['CN_RELIGION_SPREAD'].Setting);
local bCityPopNotification;
local bCityBorderNotification;
local bTradeDealNotification ;
local bReligionNotification ;
local sReligionTitle = Locale.Lookup('LOC_CN_RELIGION_TITLE');
local sCityBorderTitle = Locale.Lookup('LOC_CN_CITY_BORDER_TITLE');
local sTradeDealTitle = Locale.Lookup('LOC_CN_TRADE_DEAL_TITLE');


local function AddButtonToTopPanel()
  local topPanel = ContextPtr:LookUpControl("/InGame/TopPanel/RightContents"); -- Top-right stack with Clock, Civilopedia, and Menu
  Controls.CN_TopPanelButton:ChangeParent(topPanel);
  topPanel:AddChildAtIndex(Controls.CN_TopPanelButton, 3); -- Insert between the Clock and Civilopedia
  topPanel:CalculateSize();
  topPanel:ReprocessAnchoring();
end


local function ToggleDialogVisibility()
  if not Controls.CN_MenuContainer:IsHidden() then
	Controls.CN_MenuContainer:SetHide(true);
  else
	Controls.CN_MenuContainer:SetHide(false);
  end
end


local function OnMenuCloseButtonClick()
	ToggleDialogVisibility();
end


local function OnTopPanelButtonClick()
  ToggleDialogVisibility();
end

-- Callback for keystrokes
local function InputHandler(input:table)
  local key = input:GetKey();
  -- Note that we use KeyUp for the ESC and Enter keys, since this is what the game is listening to.
  -- Handling KeyUp prevents us from getting a double-input, and e.g. opening the game menu or
  -- progressing to the next turn.
  if not Controls.CN_MenuContainer:IsHidden() and input:GetMessageType() == KeyEvents.KeyUp then
    if key == Keys.VK_ESCAPE then
      ToggleDialogVisibility();
      return true;
    elseif key == 102 then  -- enter key
      OnMenuCloseButtonClick();
      return true;
    end
  end
	-- alt + R
  -- if input:GetMessageType() == KeyEvents.KeyDown and key == 18 and input:IsAltDown() and not input:IsShiftDown() and not input:IsControlDown() then
    -- ToggleDialogVisibility();
    -- return true;
  -- end
end


local function OnCityReligionChanged(iPlayerID, iCityID, iNewReligion)
	-- can get religion name only in UI
	local pCity = CityManager.GetCity(iPlayerID, iCityID);
	local iDominantReligion = pCity:GetReligion():GetMajorityReligion();
	local bPlayerReligion = false;

	if iDominantReligion == iNewReligion then
		for _,religion in ipairs(Game.GetReligion():GetReligions()) do
			if religion.Religion == iNewReligion then
				local iX, iY = pCity:GetX(), pCity:GetY();
				local sKey = 'CN_Religion_'..iX..'_'..iY;
				local iPreviousRel = tCache[sKey] or GameConfiguration.GetValue(sKey);

				for iLocalPlayer,_ in pairs(tLocalPlayers) do
					if iPreviousRel ~= iNewReligion then
						local pPlayerReligion = Players[iPlayerID]:GetReligion();
						local iPlayerReligion = pPlayerReligion:GetReligionTypeCreated();

						-- print('CN_Religion', iPreviousRel);
						-- OnCityReligionChanged fires periodically even if religion does not change
						if religion.Founder == iLocalPlayer then
							local sCityName = Locale.Lookup(pCity:GetName());
							local sNewReligionName = Game.GetReligion():GetName(iNewReligion);
							-- print('Religion Changed in', sCityName);
							-- print('Religion Founder', religion.Founder);
							NotificationManager.SendNotification(iLocalPlayer, iReligionNotificationHash, sReligionTitle, Locale.Lookup('LOC_CN_RELIGION_MESSAGE', sNewReligionName, sCityName), iX, iY);
						-- setProperty does not work in UI
							GameConfiguration.SetValue(sKey, iNewReligion);
							tCache[sKey] = iNewReligion;
							break;
						elseif religion.Founder ~= iLocalPlayer and iPreviousRel == iPlayerReligion then
							local sCityName = Locale.Lookup(pCity:GetName());
							local sPlayerReligionName = Game.GetReligion():GetName(iPlayerReligion);
							-- print('Religion Changed in', sCityName);
							-- print('Religion Founder', religion.Founder);
							NotificationManager.SendNotification(iLocalPlayer, iReligionNotificationHash, sReligionTitle, Locale.Lookup('LOC_CN_RELIGION_MESSAGE_1', sPlayerReligionName, sCityName), iX, iY);
							GameConfiguration.SetValue(sKey, iNewReligion);
							tCache[sKey] = iNewReligion;
							break;
						end
					end
				end
				break;
			end
		end
	end
end


local function OnCityTileOwnershipChanged( iPlayerID, iCityID, iX, iY)
-- local function OnCityTileOwnershipChanged(...)
	if tLocalPlayers[iPlayerID] then
		local pCity = CityManager.GetCity(iPlayerID, iCityID);
		local sCityName = Locale.Lookup(pCity:GetName());
		-- print("OnCityTileOwnershipChanged: "..sCityName);
		NotificationManager.SendNotification(iPlayerID, iCityGrowthNotificationHash, sCityBorderTitle, Locale.Lookup('LOC_CN_CITY_BORDER_MESSAGE', sCityName), iX, iY);
	end
end


local function OnLocalPlayerTurnEnd()
	-- works for all players in hotseat
	-- print("OnLocalPlayerTurnEnd");
		Events.CityTileOwnershipChanged.Add( OnCityTileOwnershipChanged );
end


local function OnPlayerTurnActivated ( iPlayerID, someBoolean)

	if tLocalPlayers[iPlayerID] then
		-- print("OnPlayerTurnActivated", iPlayerID);
		-- CityTileOwnershipChanged fires when player founds city so dont listen when turn is active
		Events.CityTileOwnershipChanged.Remove( OnCityTileOwnershipChanged );
	end
end


local function OnDiplomacyDealExpired (iPlayer1, iPlayer2)

	if tLocalPlayers[iPlayer1] then
		-- print("OnDiplomacyDealExpired");
		local sPlayer2name = Locale.Lookup(PlayerConfigurations[iPlayer2]:GetLeaderName());
		NotificationManager.SendNotification(iPlayer1, iDealExpiredNotificationHash, sTradeDealTitle, Locale.Lookup('LOC_CN_TRADE_DEAL_MESSAGE', sPlayer2name), nil, nil);
	elseif tLocalPlayers[iPlayer2] then
		-- print("OnDiplomacyDealExpired");
		local sPlayer2name = Locale.Lookup(PlayerConfigurations[iPlayer1]:GetLeaderName());
		NotificationManager.SendNotification(iPlayer2, iDealExpiredNotificationHash, sTradeDealTitle, Locale.Lookup('LOC_CN_TRADE_DEAL_MESSAGE', sPlayer2name), nil, nil);
	end
end


local function GetHumanPlayers() 
	for iPlayer = 0, PlayerManager.GetWasEverAliveCount() - 1 do
	local pPlayer = Players[iPlayer];
		if pPlayer and pPlayer:IsHuman() then
			tLocalPlayers[iPlayer] = -1;
			-- print(Locale.Lookup(PlayerConfigurations[iPlayer]:GetLeaderName()),' is human');
		end
	end
end


local function ToggleCityPopNotification()
	-- print(" UI  ToggleCityPopNotification");
	bCityPopNotification = not bCityPopNotification;
	GameConfiguration.SetValue('CN_bCityPopNotification', bCityPopNotification); 
	GameEvents.ToggleCityPopNotificationEvent.Call();
end


local function ToggleCityBorderNotification()
	-- print("ToggleCityBorderNotification");
	bCityBorderNotification = not bCityBorderNotification;
	GameConfiguration.SetValue('CN_bCityBorderNotification', bCityBorderNotification); 
	Events.LocalPlayerTurnEnd.Remove( OnLocalPlayerTurnEnd );
	Events.PlayerTurnActivated.Remove( OnPlayerTurnActivated ); 
	if bCityBorderNotification then
		Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
		Events.PlayerTurnActivated.Add( OnPlayerTurnActivated ); 
	end
end


local function ToggleTradeDealNotification() 
	-- print("ToggleTradeDealNotification");
	bTradeDealNotification = not bTradeDealNotification;
	GameConfiguration.SetValue('CN_bTradeDealNotification', bTradeDealNotification); 
	Events.DiplomacyDealExpired.Remove(OnDiplomacyDealExpired);
	if bTradeDealNotification then
		Events.DiplomacyDealExpired.Add(OnDiplomacyDealExpired);
	end
end


local function ToggleReligionNotification() 
	-- print("ToggleReligionNotification");
	bReligionNotification = not bReligionNotification;
	GameConfiguration.SetValue('CN_bReligionNotification', bReligionNotification); 
	Events.CityReligionChanged.Remove(OnCityReligionChanged);
	if bReligionNotification then
		Events.CityReligionChanged.Add( OnCityReligionChanged );
	end
end


local function Initialize() 

	ContextPtr:SetInputHandler(InputHandler, true);
	Controls.CN_TopPanelButton:RegisterCallback(Mouse.eLClick, OnTopPanelButtonClick);
	Controls.CN_OK_Button:RegisterCallback(Mouse.eLClick, OnMenuCloseButtonClick);
	Controls.CN_CityPopCheckBox:RegisterCallback( Mouse.eLClick, ToggleCityPopNotification );
	Controls.CN_CityBorderCheckBox:RegisterCallback( Mouse.eLClick, ToggleCityBorderNotification );
	Controls.CN_TradeDealCheckBox:RegisterCallback( Mouse.eLClick, ToggleTradeDealNotification );
	Controls.CN_ReligionCheckBox:RegisterCallback( Mouse.eLClick, ToggleReligionNotification );

	AddButtonToTopPanel();
	ContextPtr:SetHide(false);
	GetHumanPlayers();

	bCityPopNotification = GameConfiguration.GetValue('CN_bCityPopNotification');
	if bCityPopNotification == nil then 
		bCityPopNotification = true;
	end
	bCityBorderNotification = GameConfiguration.GetValue('CN_bCityBorderNotification');
	if bCityBorderNotification == nil then 
		bCityBorderNotification = true;
	end
	bTradeDealNotification = GameConfiguration.GetValue('CN_bTradeDealNotification');
	if bTradeDealNotification == nil then 
		bTradeDealNotification = true;
	end
	bReligionNotification = GameConfiguration.GetValue('CN_bReligionNotification');
	if bReligionNotification == nil then 
		bReligionNotification = true;
	end

	if bCityBorderNotification then
		Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
		Events.PlayerTurnActivated.Add( OnPlayerTurnActivated ); 
	end
	if bTradeDealNotification then
		Events.DiplomacyDealExpired.Add(OnDiplomacyDealExpired);
	end
	if bReligionNotification then
		Events.CityReligionChanged.Add( OnCityReligionChanged );
	end
	Controls.CN_CityPopCheckBox:SetCheck(bCityPopNotification);
	Controls.CN_CityBorderCheckBox:SetCheck(bCityBorderNotification);
	Controls.CN_TradeDealCheckBox:SetCheck(bTradeDealNotification);
	Controls.CN_ReligionCheckBox:SetCheck(bReligionNotification);
	print('CUSTOM NOTIFICATIONS UI LOADED.');
end


local function OnLoadGameViewStateDone()
	Initialize() ;
end
Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
