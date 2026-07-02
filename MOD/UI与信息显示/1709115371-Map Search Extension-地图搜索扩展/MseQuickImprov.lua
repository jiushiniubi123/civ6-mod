-- MseQuickImprov
-- Author: Zur13
-- DateCreated: 4/11/2019 5:53:42 PM
--------------------------------------------------------------

Z_BASE_GetPlotSearchTermsQImpr = GetPlotSearchTerms;

local m_impStackIM:table = InstanceManager:new( "MseUnitTypeListEntry", "UnitTypeButton", Controls.MseStackImprovements );

--************************************************************
-- table example is GameInfo.Improvements()
local function IsDbTableContains(table, col1, col1Val, col2, col2Val)
	for row in table do
		if row[col1] == col1Val and row[col2] == col2Val then
			return true;
		end
	end

	return false;
end

--************************************************************
-- table example is GameInfo.Improvements()
local function IsDbTableContainsAny(table, col1, col1Val)
	for row in table do
		if row[col1] == col1Val then
			return true;
		end
	end

	return false;
end

--************************************************************
-- Zur13: add possibility to search improvements which does not match plot resource
function GetPlotSearchTerms(data)
	local pSearchTerms = Z_BASE_GetPlotSearchTermsQImpr(data);

	local eLocalPlayer = Game.GetLocalPlayer();
	local pLocalPlayer = Players[eLocalPlayer];

	local AddLocalizedSearchTerm = function(kLocKey)
		table.insert( pSearchTerms, Locale.Lookup(kLocKey) );
	end

	-- TODO  Zur13
	if data.ImprovementType ~= nil and data.ResourceType ~= nil then
		-- If there is no local player, it can be visible
		local pResource = GameInfo.Resources[data.ResourceType];
		local bResourceVisible = true;
		if pLocalPlayer ~= nil then
			local pPlayerResources = pLocalPlayer:GetResources();
			bResourceVisible = pPlayerResources:IsResourceVisible(pResource.Hash);
		end
		
		if bResourceVisible then
			--if IsDbTableContainsAny( GameInfo.Improvement_ValidResources(), "ImprovementType", data.ImprovementType ) then
			--end

			if not IsDbTableContains( GameInfo.Improvement_ValidResources(), "ImprovementType", data.ImprovementType, "ResourceType", data.ResourceType ) then
				print("     MSE GetPlotSearchTerms(), found tile where IMPROVEMENT_DOES_NOT_MATCH_RESOURCE");
				AddLocalizedSearchTerm( "LOC_MSE_EXT_SEARCH_TERMS_IMPROVEMENT_DOES_NOT_MATCH_RESOURCE" );
			end
		end
	end
	
	return pSearchTerms;
end

--************************************************************
function AddImprToList(impInfo:table)

	-- Create entry
	local unitEntry:table = m_impStackIM:GetInstance();

	local uBtn = unitEntry.UnitTypeButton;
	local uIcn = unitEntry.UnitTypeIcon;

	local suffix:string = "";
	local uniqueName = Locale.Lookup( impInfo.Name ) .. suffix;

	uBtn:SetText( uniqueName );

	uBtn:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( uBtn:GetText() );
	end); 
	
	
	uIcn:SetIcon( impInfo.Icon );

	if impInfo.RemoveOnEntry == true then 
		uBtn:GetTextControl():SetColorByName("OperationChance_Red");
		uIcn:SetColorByName("OperationChance_Red");
	elseif impInfo.TraitType ~= nil then
		uBtn:GetTextControl():SetColorByName("OperationChance_YellowGreen");
		uIcn:SetColorByName("OperationChance_YellowGreen");
	end
	---- Update unit icon
	--local iconInfo:table, iconShadowInfo:table = GetUnitIcon(unitInfo, 22, true);
	--if iconInfo.textureSheet then
		--uIcn:SetTexture( iconInfo.textureOffsetX, iconInfo.textureOffsetY, iconInfo.textureSheet );
	--end
	--
	--if unitInfo.MakeTradeRoute == true or unitInfo.UnitType == 'UNIT_BUILDER' or unitInfo.UnitType == 'UNIT_MILITARY_ENGINEER' or unitInfo.UnitType == 'UNIT_ARCHAEOLOGIST' or unitInfo.UnitType == 'UNIT_NATURALIST' or unitInfo.FoundCity then
		--uBtn:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		--uIcn:SetColorByName("UnitPanelTextDisabledCS");
	--elseif string.find(unitInfo.UnitType, "UNIT_GREAT_") then
		--uBtn:GetTextControl():SetColorByName("OperationChance_Green");
		--uIcn:SetColorByName("OperationChance_Green");
	--elseif unitInfo.ReligiousStrength ~= 0 then
		--uBtn:GetTextControl():SetColorByName("OperationChance_Yellow");
		--uIcn:SetColorByName("OperationChance_Yellow");
	--elseif unitInfo.AntiAirCombat ~= 0 then
		--uBtn:GetTextControl():SetColorByName("OperationChance_YellowGreen");
		--uIcn:SetColorByName("OperationChance_YellowGreen");
	--elseif unitInfo.Combat == 0 and unitInfo.RangedCombat == 0 then
		---- if we have no attack strength we must be civilian
		----table.insert(civilianUnits, unitInfo);
		----uBtn:GetTextControl():SetColorByName("UnitPanelTextDisabledCS");
		----uIcn:SetColorByName("UnitPanelTextDisabledCS");
	--elseif unitInfo.Domain == "DOMAIN_LAND" then
		--if unitInfo.RangedCombat == 0 then 
			--uBtn:GetTextControl():SetColorByName("OperationChance_Red");
			--uIcn:SetColorByName("OperationChance_Red");
		--else
			--uBtn:GetTextControl():SetColorByName("OperationChance_Orange");
			--uIcn:SetColorByName("OperationChance_Orange");
		--end
	--elseif unitInfo.Domain == "DOMAIN_SEA" then
		--if unitInfo.RangedCombat == 0 then 
			--uBtn:GetTextControl():SetColorByName("BodyTextBlueAlt");
			--uIcn:SetColorByName("BodyTextBlueAlt");
		--else
			--uBtn:GetTextControl():SetColorByName("BodyTextBlue");
			--uIcn:SetColorByName("BodyTextBlueAlt");
		--end
	--elseif unitInfo.Domain == "DOMAIN_AIR" then
		--uBtn:GetTextControl():SetColorByName("BodyTextBlueAlt");
		--uIcn:SetColorByName("BodyTextBlueAlt");
	--end
end

--************************************************************
function PopulateQuickImpPanel()
	-- m_uniStackIM:ResetInstances(); -- clear and reuse instances created before (some properties like icon colors and hidden flags remain)
	m_impStackIM:DestroyInstances(); -- destroy old instances and build the new one
	
	local improvementsCollectatble:table = {};
	local improvements:table = {};
	local improvementsCiv:table = {};

	for impInfo in GameInfo.Improvements() do

		if impInfo.RemoveOnEntry == true then 
			table.insert(improvementsCollectatble, impInfo);
		elseif impInfo.TraitType ~= nil then
			table.insert(improvementsCiv, impInfo);
		else
			table.insert(improvements, impInfo);
		end
	end

	-- Alphabetize groups
	local sortFunc = function(a, b) 
		local aType:string = Locale.Lookup(a.Name);
		local bType:string = Locale.Lookup(b.Name);
		return aType < bType;
	end

	table.sort(improvementsCollectatble, sortFunc);
	table.sort(improvements, sortFunc);
	table.sort(improvementsCiv, sortFunc);

	for _, impInfo in ipairs(improvementsCollectatble) do	AddImprToList( impInfo );	end
	for _, impInfo in ipairs(improvements) do	AddImprToList( impInfo );	end
	for _, impInfo in ipairs(improvementsCiv) do	AddImprToList( impInfo );	end
end

--************************************************************
function InitQuickImprovPanel()
	Controls.MseImpButton1:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseImpButton1:GetText() );
	end); 
	Controls.MseImpButton2:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseImpButton2:GetText() );
	end); 

	PopulateQuickImpPanel();
end