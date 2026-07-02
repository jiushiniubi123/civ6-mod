-- MseQuickUnits
-- Author: Zur13
-- DateCreated: 4/10/2019 5:55:55 PM
--------------------------------------------------------------

local m_uniStackIM:table = InstanceManager:new( "MseUnitTypeListEntry", "UnitTypeButton", Controls.MseStackUni );

-- ===========================================================================
--	Returns the icon info and shadow icon info for the passed in unit or returns default icons if those can't be found
--	RETURN 1: iconInfo - table containing textureSheet, textureOffsetX, and textureOffsetY
--	RETURN 2: iconShadowInfo - table containing textureSheetShadow, textureOffsetShadowX, and textureOffsetShadowY
-- ===========================================================================
function GetUnitIcon( unitInfo:table, iconSize:number )	
	
	local iconInfo:table = {};
	if unitInfo then

		local unitIcon:string = nil;
		unitIcon = "ICON_" .. unitInfo.UnitType;
		
		iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas(unitIcon, iconSize);
		if (iconInfo.textureSheet == nil) then			--Check to see if the unit has an icon atlas index defined
			--print("UIWARNING: Could not find icon for " .. unitIcon);
			iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet = IconManager:FindIconAtlas("ICON_UNIT_UNKNOWN", iconSize);		--If not, resolve the index to be a generic unknown index
		end
	end
	return iconInfo;
end

--************************************************************
function AddUnitToUnitList(unitInfo:table)

	-- Create entry
	local unitEntry:table = m_uniStackIM:GetInstance();

	local uBtn = unitEntry.UnitTypeButton;
	local uIcn = unitEntry.UnitTypeIcon;

	local suffix:string = "";
	local uniqueName = Locale.Lookup( unitInfo.Name ) .. suffix;

	uBtn:SetText( uniqueName );

	uBtn:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( uBtn:GetText() );
	end); 
	

	-- Update unit icon
	local iconInfo:table, iconShadowInfo:table = GetUnitIcon(unitInfo, 22, true);
	if iconInfo.textureSheet then
		uIcn:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	end
	
	if unitInfo.MakeTradeRoute == true or unitInfo.UnitType == 'UNIT_BUILDER' or unitInfo.UnitType == 'UNIT_MILITARY_ENGINEER' or unitInfo.UnitType == 'UNIT_ARCHAEOLOGIST' or unitInfo.UnitType == 'UNIT_NATURALIST' or unitInfo.FoundCity then
		uBtn:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		uIcn:SetColorByName("UnitPanelTextDisabledCS");
	elseif string.find(unitInfo.UnitType, "UNIT_GREAT_") then
		uBtn:GetTextControl():SetColorByName("OperationChance_Green");
		uIcn:SetColorByName("OperationChance_Green");
	elseif unitInfo.ReligiousStrength ~= 0 then
		uBtn:GetTextControl():SetColorByName("OperationChance_Yellow");
		uIcn:SetColorByName("OperationChance_Yellow");
	elseif unitInfo.AntiAirCombat ~= 0 then
		uBtn:GetTextControl():SetColorByName("OperationChance_YellowGreen");
		uIcn:SetColorByName("OperationChance_YellowGreen");
	elseif unitInfo.Combat == 0 and unitInfo.RangedCombat == 0 then
		-- if we have no attack strength we must be civilian
		--table.insert(civilianUnits, unitInfo);
		--uBtn:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		--uIcn:SetColorByName("UnitPanelTextDisabledCS");
	elseif unitInfo.Domain == "DOMAIN_LAND" then
		if unitInfo.RangedCombat == 0 then 
			uBtn:GetTextControl():SetColorByName("OperationChance_Red");
			uIcn:SetColorByName("OperationChance_Red");
		else
			uBtn:GetTextControl():SetColorByName("OperationChance_Orange");
			uIcn:SetColorByName("OperationChance_Orange");
		end
	elseif unitInfo.Domain == "DOMAIN_SEA" then
		if unitInfo.RangedCombat == 0 then 
			uBtn:GetTextControl():SetColorByName("BodyTextBlueAlt");
			uIcn:SetColorByName("BodyTextBlueAlt");
		else
			uBtn:GetTextControl():SetColorByName("UnitPanelTextDisabledCS"); -- BodyTextBlue
			uIcn:SetColorByName("UnitPanelTextDisabledCS");
		end
	elseif unitInfo.Domain == "DOMAIN_AIR" then
		uBtn:GetTextControl():SetColorByName("BodyTextBlueAlt");
		uIcn:SetColorByName("BodyTextBlueAlt");
	end
end

--************************************************************
function PopulateQuickUnitsPanel()
	-- m_uniStackIM:ResetInstances(); -- clear and reuse instances created before (some properties like icon colors and hidden flags remain)
	m_uniStackIM:DestroyInstances(); -- destroy old instances and build the new one
	
	-- Sort units
	local tradeUnits:table = {};
	local supportUnits:table = {};
	local greatUnits:table = {};
	local civilianUnits:table = {};

	local militaryUnits:table = {};
	local militaryUnitsR:table = {};

	local navalUnits:table = {};
	local navalUnitsR:table = {};

	local airUnits:table = {};
	local aAirUnits:table = {};
	
	

	for unitInfo in GameInfo.Units() do
		--print("GameInfo.Units: ", i, unitInfo);
		if unitInfo.MakeTradeRoute == true or unitInfo.UnitType == 'UNIT_BUILDER' or unitInfo.UnitType == 'UNIT_MILITARY_ENGINEER' or unitInfo.UnitType == 'UNIT_ARCHAEOLOGIST' or unitInfo.UnitType == 'UNIT_NATURALIST' or unitInfo.FoundCity then
			table.insert(tradeUnits, unitInfo);
		elseif unitInfo.ReligiousStrength > 0 or unitInfo.ReligiousHealCharges > 0 or unitInfo.SpreadCharges > 0 or unitInfo.LaunchInquisition then
			table.insert(supportUnits, unitInfo);
		elseif string.find(unitInfo.UnitType, "UNIT_GREAT_") then
			table.insert(greatUnits, unitInfo);
		elseif unitInfo.AntiAirCombat > 0 then
			table.insert(aAirUnits, unitInfo);
		elseif unitInfo.Combat == 0 and unitInfo.RangedCombat == 0 then
			-- if we have no attack strength we must be civilian
			table.insert(civilianUnits, unitInfo);
		elseif unitInfo.Domain == "DOMAIN_LAND" then
			if unitInfo.RangedCombat == 0 then 
				table.insert(militaryUnits, unitInfo);
			else
				table.insert(militaryUnitsR, unitInfo);
			end
		elseif unitInfo.Domain == "DOMAIN_SEA" then
			if unitInfo.RangedCombat == 0 then 
				table.insert(navalUnits, unitInfo);
			else
				table.insert(navalUnitsR, unitInfo);
			end
		elseif unitInfo.Domain == "DOMAIN_AIR" then
			table.insert(airUnits, unitInfo);
		end
	end

	-- Alphabetize groups
	local sortFunc = function(a, b) 
		local aType:string = Locale.Lookup(a.Name);
		local bType:string = Locale.Lookup(b.Name);
		return aType < bType;
	end
	table.sort(militaryUnits, sortFunc);
	table.sort(militaryUnitsR, sortFunc);
	table.sort(navalUnits, sortFunc);
	table.sort(navalUnitsR, sortFunc);
	table.sort(aAirUnits, sortFunc);
	table.sort(airUnits, sortFunc);
	table.sort(supportUnits, sortFunc);
	table.sort(civilianUnits, sortFunc);
	table.sort(tradeUnits, sortFunc);

	-- Add units by sorted groups
	for _, unitInfo in ipairs(tradeUnits) do	AddUnitToUnitList( unitInfo );	end
	for _, unitInfo in ipairs(supportUnits) do	AddUnitToUnitList( unitInfo );	end
	for _, unitInfo in ipairs(greatUnits) do	AddUnitToUnitList( unitInfo );	end
	for _, unitInfo in ipairs(civilianUnits) do	AddUnitToUnitList( unitInfo );	end
	
	for _, unitInfo in ipairs(aAirUnits) do		AddUnitToUnitList( unitInfo );	end	
	for _, unitInfo in ipairs(airUnits) do		AddUnitToUnitList( unitInfo );	end
	for _, unitInfo in ipairs(militaryUnitsR) do	AddUnitToUnitList( unitInfo );	end	
	for _, unitInfo in ipairs(militaryUnits) do	AddUnitToUnitList( unitInfo );	end

	for _, unitInfo in ipairs(navalUnitsR) do 	AddUnitToUnitList( unitInfo );	end
	for _, unitInfo in ipairs(navalUnits) do 	AddUnitToUnitList( unitInfo );	end

end

--************************************************************
function InitQuickUnitsPanel()
	Controls.MseUniButton1:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton1:GetText() );
	end); 
	Controls.MseUniButton2:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton2:GetText() );
	end); 
	Controls.MseUniButton3:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton3:GetText() );
	end); 
	Controls.MseUniButton4:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton4:GetText() );
	end); 
	Controls.MseUniButton5:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton5:GetText() );
	end); 
	Controls.MseUniButton6:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton6:GetText() );
	end); 
	Controls.MseUniButton7:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton7:GetText() );
	end); 
	Controls.MseUniButton8:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseUniButton8:GetText() );
	end); 

	PopulateQuickUnitsPanel();
end

