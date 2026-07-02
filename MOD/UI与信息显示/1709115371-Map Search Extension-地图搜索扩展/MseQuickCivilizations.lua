-- MseQuickCivilizations
-- Author: Zur13
-- DateCreated: 4/10/2019 5:55:31 PM
--------------------------------------------------------------

local m_civStackIM:table = InstanceManager:new( "MseCivilizationEntry", "CivButton", Controls.MseStackCivilizations );


-- ===========================================================================
function GetCityStateIcon(leaderName:string, leaderInfo:table)
	local iconString:string;

	if (leader == "LEADER_MINOR_CIV_SCIENTIFIC" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_SCIENTIFIC") then				
		iconString = "ICON_CITYSTATE_SCIENCE";
	elseif (leader == "LEADER_MINOR_CIV_RELIGIOUS" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_RELIGIOUS") then
		iconString = "ICON_CITYSTATE_FAITH";
	elseif (leader == "LEADER_MINOR_CIV_TRADE" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_TRADE") then
		iconString = "ICON_CITYSTATE_TRADE";
	elseif (leader == "LEADER_MINOR_CIV_CULTURAL" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_CULTURAL") then
		iconString = "ICON_CITYSTATE_CULTURE";
	elseif (leader == "LEADER_MINOR_CIV_MILITARISTIC" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_MILITARISTIC") then
		iconString = "ICON_CITYSTATE_MILITARISTIC";
	elseif (leader == "LEADER_MINOR_CIV_INDUSTRIAL" or leaderInfo.InheritFrom == "LEADER_MINOR_CIV_INDUSTRIAL") then
		iconString = "ICON_CITYSTATE_INDUSTRIAL";
	end

	return iconString;
end

--************************************************************
function PopulateQuickCivilizationsPanel()
	local eObserverID = Game.GetLocalObserver();
	
	-- m_civStackIM:ResetInstances(); -- clear and reuse instances created before (some properties like icon colors and hidden flags remain)
	m_civStackIM:DestroyInstances(); -- destroy old instances and build the new one

	for i, player in ipairs(Game.GetPlayers()) do
		local playerID = player:GetID();
		local playerConfig:table = PlayerConfigurations[playerID];
		local civTypeName = playerConfig:GetCivilizationTypeName();

		local hasMet:boolean = false;
		if player ~= nil and eObserverID ~= nil and playerID ~= eObserverID then
			hasMet = player:GetDiplomacy():HasMet( eObserverID );
		elseif playerID == eObserverID then
			hasMet = true
		end

		if civTypeName == nil then
			UI.DataError("Invalid type name returned by GetCivilizationTypeName");
		end -- if civTypeName == nil

		if player ~= nil and civTypeName ~= nil and hasMet then
			local pInstance = m_civStackIM:GetInstance();

			local icon = pInstance.CivIcon;
			local iconBacking = pInstance.CivIconBG;

			local iconLeader = pInstance.LeaderIcon;
			local civBtn = pInstance.CivButton;
		
			local m_primaryColor;
			local m_secondaryColor;
			local cityStateColorOverride = nil;

			m_primaryColor, m_secondaryColor  = UI.GetPlayerColors( playerID );
			
			-- Set the leader name, civ name, civ icon type, leader icon type
			
			-- CIVILIZATION
			local civIcon:string = "ICON_CIVILIZATION_UNKNOWN";
			local civName:string = Locale.Lookup( GameInfo.Civilizations[civTypeName].Name );

			civIcon = "ICON_" .. civTypeName;

			-- LEADER
			local leaIcon:string = "ICON_LEADER_DEFAULT";
			local leaName:string = "";

			local leaderTypeName:string = playerConfig:GetLeaderTypeName();
				
			
			if leaderTypeName ~= nil then
				-- MAJOR CIV LEADER (DEFAULT BEHAVIOUR)
				leaIcon = "ICON_" .. leaderTypeName;
				leaName = Locale.Lookup(GameInfo.Leaders[leaderTypeName].Name);

				if player:IsBarbarian() or string.find(leaderTypeName, "LEADER_FREE_CITIES") then
					-- BARBARIAN AND FREE CITIES HIDE LEADER ICON
					leaIcon = nil; -- hide icon
				else 
					local leaderInfo:table	= GameInfo.Leaders[leaderTypeName];
					local isMinor			= string.find(leaderTypeName, "LEADER_MINOR_CIV");
						
					if isMinor ~= true and leaderInfo ~= nil and leaderInfo.InheritFrom then
						isMinor				= string.find(leaderInfo.InheritFrom, "LEADER_MINOR_CIV");
					end

					if isMinor then
						-- CITY-STATE CIV LEADER ICON CHANGE TO CITY-STATE ICON TYPE
						leaIcon = GetCityStateIcon( leaderTypeName, leaderInfo );
						leaName = Locale.Lookup(GameInfo.Leaders[leaderTypeName].Name);

						cityStateColorOverride = m_secondaryColor;
						
						if (civBtn ~= nil) then
							civBtn:GetTextControl():SetColor( m_secondaryColor );
						end
					end
					
				end
			else -- if leaderTypeName ~= nil then
				UI.DataError("Invalid type name returned by GetLeaderTypeName");
				leaIcon = nil; -- hide icon
			end -- if leaderTypeName ~= nil then

			-- APPLY CIV ICON TYPE TO GUI COMPONENT
			if icon ~= nil then
				icon:SetIcon(civIcon);
			end
			
			-- APPLY CIV ICON COLORS TO GUI COMPONENT
			if iconBacking ~= nil and icon ~= nil then
				iconBacking:SetColor(m_primaryColor);
				icon:SetColor(m_secondaryColor);
			end

			-- APPLY COLORS AND LEADER ICONS TO GUI COMPONENT
			if iconLeader ~= nil then
				if leaIcon ~= nil then
					iconLeader:SetIcon(leaIcon);
				else 
					iconLeader:SetHide( true );
				end
				if cityStateColorOverride ~= nil then
					iconLeader:SetColor( cityStateColorOverride );
				end
			end

			-- APPLY CIV NAME TO GUI COMPONENT
			if civBtn ~= nil then
				civBtn:SetText(civName);
				civBtn:RegisterCallback(Mouse.eLClick, function()
					--OnSuggestionClicked(pEditBox, pInstance.ResButton:GetToolTipString());
					AppendSuggestionText( civBtn:GetText() );
				end); 
				if cityStateColorOverride ~= nil then
					civBtn:GetTextControl():SetColor( cityStateColorOverride );
				end
			end
			
		end --if player ~= nil and civTypeName ~= nil and hasMet then

	end -- for i, player 

	
end