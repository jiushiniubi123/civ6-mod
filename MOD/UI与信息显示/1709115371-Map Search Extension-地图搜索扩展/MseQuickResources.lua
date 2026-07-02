-- MseQuickResources
-- Author: Zur13
-- DateCreated: 4/9/2019 7:18:25 PM
--------------------------------------------------------------


local m_resStackIM1:table = InstanceManager:new( "ResEntry", "MseStackRes", Controls.MSEResGrid1 ); -- strategic
local m_resStackIM2:table = InstanceManager:new( "ResEntry", "MseStackRes", Controls.MSEResGrid2 ); -- luxury
local m_resStackIM3:table = InstanceManager:new( "ResEntry", "MseStackRes", Controls.MSEResGrid3 ); -- bonus 
local m_resStackIM4:table = InstanceManager:new( "ResEntry", "MseStackRes", Controls.MSEResGrid4 ); -- artifact
local m_resStackIM5:table = InstanceManager:new( "ResEntry", "MseStackRes", Controls.MSEResGrid5 ); -- minor civ lux

local RESOURCE_CNT_THRESHOLD = 60; -- GS has 52 resource entries
local LEFT_OFFSET = 33; 
local RIGHT_OFFSET = 21;

local resGridCols = 8;

local resGridX = 28;
local resGridY = 28;
local resGridDelimX = 7;
local resGridDelimY = 5;

local newResourcesDetected = false;

--************************************************************
function CheckAndRecalculateGridAndPanelSize()
	local resNum = #GameInfo.Resources;
	print( " MSE Detected resource number is ", resNum);
	if resNum > RESOURCE_CNT_THRESHOLD then
		
		resGridDelimX = 3; -- less space
		resGridDelimY = 3;

		-- recalculate is needed
		resGridCols = resGridCols * 2;

		local newPanelSizeX = resGridCols * resGridX + (resGridCols - 1 ) * resGridDelimX + LEFT_OFFSET + RIGHT_OFFSET;
		Controls.ExtendedMapSearchPanelSuggestionsRes:SetSizeX( newPanelSizeX );
		
		Controls.ResButton1:SetAnchor("C,T");
		Controls.ResButton2:SetAnchor("C,T");
		Controls.ResButton3:SetAnchor("C,T");
		Controls.ResButton4:SetAnchor("C,T");

		Controls.ResButton1:SetOffsetX(-5);
		Controls.ResButton2:SetOffsetX(-5);
		Controls.ResButton3:SetOffsetX(-5);
		Controls.ResButton4:SetOffsetX(-5);

		newResourcesDetected = true;
	end
end

--************************************************************
function AddLetterToPanel(letter, pInstanceManager)
	local pInstance = pInstanceManager:GetInstance();
	pInstance.ResButton:SetText("");
	pInstance.ResButton:SetHide(true);
	
	pInstance.MseResLbl:SetText( letter );
	pInstance.MseResLbl:SetHide(false);

	return pInstance;
end

--************************************************************
local resPanelLastResLetter = {}; -- key - panel, value - letter
local resPanelLastResLetterRepeat = {}; -- key - panel, value - letter
local resPanelLastResLetterRow = {}; -- key - panel, value - row
local resPanelLastResLetterAddedInRow = {}; -- key - panel, value - letters already added to row

function RequiredInRowLetter( firstLetter, lastRowColls, row, pResPanel )
	local res = false;

	local REPEAT_THRESHOLD = 1;
	local letterDiffersFromPrev = false;

	local prevLetter	= resPanelLastResLetter[ pResPanel ];
	local prevLetterRep = resPanelLastResLetterRepeat[ pResPanel ];
	local prevRow		= resPanelLastResLetterRow[ pResPanel ];
	local alreadyAdded	= resPanelLastResLetterAddedInRow[ pResPanel ];

	resPanelLastResLetter[ pResPanel ] = firstLetter;
	resPanelLastResLetterRow[ pResPanel ] = row;

	if prevLetterRep ~= nil and prevLetter == firstLetter then
		prevLetterRep = prevLetterRep + 1;
		resPanelLastResLetterRepeat[ pResPanel ] = prevLetterRep;
	else
		letterDiffersFromPrev = true;
		resPanelLastResLetterRepeat[ pResPanel ] = 1;
	end

	if alreadyAdded == nil or prevRow ~= row then
		alreadyAdded = 0;
		resPanelLastResLetterAddedInRow[ pResPanel ] = 0;
	end

	--if lastRowColls > 3 and letterDiffersFromPrev and lastRowColls < resGridCols - 1 and ( (prevLetterRep ~= nil and prevLetterRep > REPEAT_THRESHOLD) or (alreadyAdded < 2 and lastRowColls > 5 ) ) then
	if lastRowColls > 4 and letterDiffersFromPrev and lastRowColls < (resGridCols - 3)  and lastRowColls > (resGridCols / 2) - 4 and alreadyAdded < 1 then
		resPanelLastResLetterAddedInRow[ pResPanel ] = alreadyAdded + 1;
		res = true;
	end

	return res;
end

--************************************************************
function AddResToPanel(pRes, pResPanel, pInstanceManager)

	local resourceType:string = pRes.ResourceType;
	local resourceTextIcon = "[ICON_"..resourceType.."] ";

	local childNum		= pResPanel:GetNumChildren();
	local lastRowColls	= childNum % resGridCols;
	local childRows		= math.floor( childNum / resGridCols );

	local newOffsetX	= lastRowColls * resGridX	+ (lastRowColls) * resGridDelimX;
	local newOffsetY	= childRows * resGridY		+ (childRows) * resGridDelimY;

	local rName = Locale.Lookup(pRes.Name);
	if rName ~= nil and rName ~= "" and string.len( rName ) > 0 then
		local firstLetter = string.sub(rName, 1, 1);
		
		if lastRowColls == 0 then
			-- add Row Header (Letter)
			local pInstance = AddLetterToPanel( firstLetter, pInstanceManager );

			pInstance.MseStackRes:SetOffsetX( newOffsetX + 5 );
			pInstance.MseStackRes:SetOffsetY( newOffsetY + 6 );
		end

		--if RequiredInRowLetter( firstLetter, lastRowColls, childRows, pResPanel ) then
			---- add in-row letter
			--local pInstance = AddLetterToPanel( firstLetter, pInstanceManager );
--
			--pInstance.MseStackRes:SetOffsetX( newOffsetX + 5 );
			--pInstance.MseStackRes:SetOffsetY( newOffsetY + 6 );
		--end

		-- recalculate panel stats
		childNum		= pResPanel:GetNumChildren();
		lastRowColls	= childNum % resGridCols;
		childRows		= math.floor( childNum / resGridCols );

		newOffsetX	= lastRowColls * resGridX	+ (lastRowColls) * resGridDelimX;
		newOffsetY	= childRows * resGridY		+ (childRows) * resGridDelimY;
	end

	--pInstanceManager:ResetInstances();
	local pInstance = pInstanceManager:GetInstance();
	
	pInstance.ResButton:SetText(resourceTextIcon);

	pInstance.ResButton:LocalizeAndSetToolTip(pRes.Name);
	pInstance.ResButton:RegisterCallback(Mouse.eLClick, function()
		--OnSuggestionClicked(pEditBox, pInstance.ResButton:GetToolTipString());
		AppendSuggestionText( pInstance.ResButton:GetToolTipString() );
	end); 

	pInstance.MseStackRes:SetOffsetX( newOffsetX );
	pInstance.MseStackRes:SetOffsetY( newOffsetY );

end

--************************************************************
function PopulateQuickResourcePanel()
	local type;
	local entries = {};
	table.insert(entries, { Text="LOC_CHEAT_MAP_EDITOR_RESOURCES_UNCH", Type=nil });
	table.insert(entries, { Text="LOC_WORLDBUILDER_NO_RESOURCE", Type=-1 });

	-- Group by 
	local luxu:table = {}; -- map lux resource
	local lux2:table = {}; -- minor civ lux resource
	local stra:table = {}; -- strategic resource
	local arti:table = {}; -- artifact resource
	local othe:table = {}; -- other resources (bonus)
	
	for type in GameInfo.Resources() do
		--AddResToPanel(type, Controls.MSEResGrid1, m_resStackIM1, Controls.MapSearchBox);
		local sText = Locale.Lookup(type.Name);
		
		if type.ResourceClassType == "RESOURCECLASS_LUXURY" then
			if type.SeaFrequency > 0 then
				table.insert(luxu, { Text=sText, Type=type });
			elseif type.Frequency == 0 and type.SeaFrequency == 0 then
				-- minor civ luxury resource
				table.insert(lux2, { Text=sText, Type=type });
			else
				-- map luxury resource
				table.insert(luxu, { Text=sText, Type=type });
			end
		elseif type.ResourceClassType == "RESOURCECLASS_STRATEGIC" then
			table.insert(stra, { Text=sText, Type=type });
		elseif type.ResourceClassType == "RESOURCECLASS_ARTIFACT" then
			table.insert(arti, { Text=sText, Type=type });
		else
			if type.SeaFrequency > 0 then
				--sText = "[COLOR_FLOAT_SCIENCE]" .. sText .. "[ENDCOLOR]";
			else
				--sText = "[COLOR_FLOAT_FAITH]" .. sText .. "[ENDCOLOR]";
			end
			table.insert(othe, { Text=sText, Type=type });
		end
	end
	
	-- Sort Alphabetize groups
	local sortFunc = function(a, b) 
		--print( "-- compare resources ", a, b, a.Name, b.Name, a.ResourceType, b.ResourceType );
		local aType:string = Locale.Lookup(a.Text);
		local bType:string = Locale.Lookup(b.Text);
		return aType < bType;
	end

	table.sort(luxu, sortFunc);
	table.sort(lux2, sortFunc);
	table.sort(stra, sortFunc);
	table.sort(arti, sortFunc);
	table.sort(othe, sortFunc);
	
	-- Collect
	for _, entry in ipairs(stra) do AddResToPanel(entry.Type, Controls.MSEResGrid1, m_resStackIM1);	end;
	for _, entry in ipairs(luxu) do AddResToPanel(entry.Type, Controls.MSEResGrid2, m_resStackIM2);	end;
	for _, entry in ipairs(othe) do AddResToPanel(entry.Type, Controls.MSEResGrid3, m_resStackIM3);	end;
	
	
	for _, entry in ipairs(arti) do AddResToPanel(entry.Type, Controls.MSEResGrid4, m_resStackIM4);	end;
	for _, entry in ipairs(lux2) do AddResToPanel(entry.Type, Controls.MSEResGrid5, m_resStackIM5);	end; -- MINOR CIV RES

end

--************************************************************
function InitQuickResourcePanel()
	Controls.ResButton1:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.ResButton1:GetText() );
	end); 

	Controls.ResButton2:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.ResButton2:GetText() );
	end); 

	Controls.ResButton3:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.ResButton3:GetText() );
	end); 

	Controls.ResButton4:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( Controls.ResButton4:GetText() );
	end); 
	
	--CheckAndRecalculateGridAndPanelSize();
	PopulateQuickResourcePanel();
end
