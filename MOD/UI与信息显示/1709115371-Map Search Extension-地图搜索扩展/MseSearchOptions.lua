-- MseSearchOptions
-- Author: Zur13
-- DateCreated: 4/15/2019 10:22:35 PM
--------------------------------------------------------------

local mapColors = {}; -- KEY - color int value; VALUE - color descritor: { locColorName, color_console, color }

--************************************************************
local function FindParentPullDown( childComponent )
	local found = false;
	local parent = childComponent;
	while parent ~= nil and parent.GetParent ~= nil do
		--print(" ----", parent);
		if parent == Controls.MSEColorPD1 or parent == Controls.MSEColorPD2 or parent == Controls.MSEColorPD3 then
			found = true;
			break;
		end

		parent = parent:GetParent();
	end
	if not found then
		parent = nil;
	end
	return parent;
end

--************************************************************
local function UpdateActiveMapColor( color, parentPullDown )
	local pOverlay:object = UILens.GetOverlay("MapSearch");
	if pOverlay ~= nil then
		--pOverlay:SetBorderColors(0, borderColor1, borderColor2);
		if parentPullDown == Controls.MSEColorPD1 then
			fillColor = color;
			pOverlay:SetBorderColors( 0, borderColor1, borderColor2 );
			pOverlay:SetHighlightColor( 0, fillColor ); 
		elseif parentPullDown == Controls.MSEColorPD2 then
			borderColor1 = color;
			pOverlay:SetBorderColors( 0, borderColor1, borderColor2 );
			pOverlay:SetHighlightColor( 0, fillColor ); 
		elseif parentPullDown == Controls.MSEColorPD3 then
			borderColor2 = color;
			pOverlay:SetBorderColors( 0, borderColor1, borderColor2 );
			pOverlay:SetHighlightColor( 0, fillColor ); 
		end
	end
end

--************************************************************
local function UpdateColorPullDownSelection( color, pulldown )
	local colorDesc = mapColors[color];
	if colorDesc ~= nil and pulldown ~= nil then
		local suffix = "1";
		if pulldown == Controls.MSEColorPD2 then
			suffix = "2";
		elseif pulldown == Controls.MSEColorPD3 then
			suffix = "3";
		end

		Controls[ "ColorButtonPD" .. suffix ]:SetText( colorDesc.locColorName );
		-- Update color icon
		Controls[ "ColorEntryImagePD" .. suffix ]:SetColor( colorDesc.color );
		Controls[ "ColorEntryImageBgPD" .. suffix ]:SetColor( UI.GetColorValue("COLOR_WHITE") );
		Controls[ "ColorEntryImageTopPD" .. suffix ]:SetColor( colorDesc.color );
	else
		print("UpdateColorPullDownSelection failed colorDesc is nil", colorDesc, color );
	end
end

--************************************************************
local function OnColorSelected( color, color2, pulldownGridBtn )
	--print("OnColorSelected", color, color, pulldownGridBtn );
	local parentPullDown = FindParentPullDown( pulldownGridBtn );
	--print("OnColorSelected", parentPullDown );

	print("Fill color changed OLD_VAL NEW_VAL newColorDesc", fillColor, color, mapColors[color]);
	
	UpdateActiveMapColor( color, parentPullDown );
		
	-- fill color
	UpdateColorPullDownSelection( color, parentPullDown );
end

--************************************************************
local function AddColorEntryToPD( pulldown, colorDesc, selListener )
	--print("Building color entry for ", pulldown, colorDesc, selListener );
	local suffix = "1";
	if pulldown == Controls.MSEColorPD2 then
		suffix = "2";
	elseif pulldown == Controls.MSEColorPD3 then
		suffix = "3";
	end

	-- Create entry
	local colorEntry:table = {};
	pulldown:BuildEntry( "ColorListEntry" .. suffix, colorEntry );

	if colorEntry ~= nil then
		colorEntry.Button:SetText( colorDesc.locColorName );
		colorEntry.Button:SetVoids( colorDesc.color, colorDesc.color );
		if selListener ~= nil then
			colorEntry.Button:RegisterCallback( Mouse.eLClick, selListener );
		end

		-- Update color icon
		colorEntry[ "ColorEntryImage" .. suffix ]:SetColor( colorDesc.color );
		colorEntry[ "ColorEntryImageBg" .. suffix ]:SetColor( UI.GetColorValue("COLOR_WHITE") );
		colorEntry[ "ColorEntryImageTop" .. suffix ]:SetColor( colorDesc.color );
	else
		print("Building color entry failed for ", pulldown, colorDesc, selListener );
	end
end

--************************************************************
local function InitBgColorPD()
	local defaultFillColor;
	local defaultBgColor1;
	local defaultBgColor2;

	local colorDesc;
	--0x<Alpha><Blue><Green><Red>
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_BLACK"),			color_console="COLOR_BLACK",			color=UI.GetColorValueFromHexLiteral(0xAF000000) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_BLACK_TRANS"),		color_console="COLOR_BLACK_TRANS",		color=UI.GetColorValueFromHexLiteral(0x66000000) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_WHITE"),			color_console="COLOR_WHITE",			color=UI.GetColorValueFromHexLiteral(0xAFFFFFFF) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_WHITE_TRANS"),		color_console="COLOR_WHITE_TRANS",		color=UI.GetColorValueFromHexLiteral(0x66FFFFFF) };
	mapColors[ colorDesc.color ] = colorDesc;
	defaultBgColor1 = colorDesc;
	defaultBgColor2 = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_GREY"),				color_console="COLOR_GREY",				color=UI.GetColorValueFromHexLiteral(0xAF898989) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_GREY_TRANS"),		color_console="COLOR_GREY_TRANS",		color=UI.GetColorValueFromHexLiteral(0x66898989) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_GREEN"),			color_console="COLOR_GREEN",			color=UI.GetColorValueFromHexLiteral(0xAF00FF00) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_GREEN_TRANS"),		color_console="COLOR_GREEN_TRANS",		color=UI.GetColorValueFromHexLiteral(0x6600FF00) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_GREEN_DEFAULT"),	color_console="COLOR_GREEN_DEFAULT",	color=UI.GetColorValueFromHexLiteral(0x2800FF00) }; -- 0x2800FF00
	mapColors[ colorDesc.color ] = colorDesc;
	defaultFillColor = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_BLUE"),				color_console="COLOR_BLUE",				color=UI.GetColorValueFromHexLiteral(0xAFFF0000) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_BLUE_TRANS"),		color_console="COLOR_BLUE_TRANS",		color=UI.GetColorValueFromHexLiteral(0x66FF0000) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_RED"),				color_console="COLOR_FONT_RED",			color=UI.GetColorValueFromHexLiteral(0xAF0000FF) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_RED_TRANS"),		color_console="COLOR_FONT_RED_TRANS",	color=UI.GetColorValueFromHexLiteral(0x660000FF) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_YELLOW"),			color_console="COLOR_YELLOW",			color=UI.GetColorValueFromHexLiteral(0xAF00EEFF) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_YELLOW_TRANS"),		color_console="COLOR_YELLOW_TRANS",		color=UI.GetColorValueFromHexLiteral(0x6600EEFF) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_CYAN"),				color_console="COLOR_CYAN",				color=UI.GetColorValueFromHexLiteral(0xAFFFFF00) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_CYAN_TRANS"),		color_console="COLOR_CYAN_TRANS",		color=UI.GetColorValueFromHexLiteral(0x66FFFF00) };
	mapColors[ colorDesc.color ] = colorDesc;

	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_MAGENTA"),			color_console="COLOR_MAGENTA",			color=UI.GetColorValueFromHexLiteral(0xAFFF00FF) };
	mapColors[ colorDesc.color ] = colorDesc;
	colorDesc = { locColorName=Locale.Lookup("LOC_MSE_COLOR_MAGENTA_TRANS"),	color_console="COLOR_MAGENTA_TRANS",	color=UI.GetColorValueFromHexLiteral(0x66FF00FF) };
	mapColors[ colorDesc.color ] = colorDesc;

	-- Alphabetize groups
	local sortFunc = function(a, b) 
		local aType:string = Locale.Lookup(a.locColorName);
		local bType:string = Locale.Lookup(b.locColorName);
		return aType < bType;
	end

	local sortedColors = {};
	local sortedColorsTrans = {};

	for _, colorDesc in pairs(mapColors) do	if		string.match(colorDesc.color_console, "TRANS") then table.insert( sortedColorsTrans, colorDesc);	end;	end;
	for _, colorDesc in pairs(mapColors) do	if not	string.match(colorDesc.color_console, "TRANS") then table.insert( sortedColors, colorDesc);			end;	end;

	table.sort(sortedColorsTrans, sortFunc);
	table.sort(sortedColors, sortFunc);

	--TODO: BG

	Controls.MSEColorPD1:ClearEntries(); 
	Controls.MSEColorPD2:ClearEntries(); 
	Controls.MSEColorPD3:ClearEntries(); 

	for i, colorDesc in ipairs( sortedColorsTrans ) do
		AddColorEntryToPD( Controls.MSEColorPD1, colorDesc, OnColorSelected );
	end
	for i, colorDesc in ipairs( sortedColors ) do
		AddColorEntryToPD( Controls.MSEColorPD1, colorDesc, OnColorSelected );
	end

	for i, colorDesc in ipairs( sortedColorsTrans ) do
		AddColorEntryToPD( Controls.MSEColorPD2, colorDesc, OnColorSelected );
	end
	for i, colorDesc in ipairs( sortedColors ) do
		AddColorEntryToPD( Controls.MSEColorPD2, colorDesc, OnColorSelected );
	end

	for i, colorDesc in ipairs( sortedColorsTrans ) do
		AddColorEntryToPD( Controls.MSEColorPD3, colorDesc, OnColorSelected );
	end
	for i, colorDesc in ipairs( sortedColors ) do
		AddColorEntryToPD( Controls.MSEColorPD3, colorDesc, OnColorSelected );
	end

	Controls.MSEColorPD1:CalculateInternals();
	Controls.MSEColorPD2:CalculateInternals();
	Controls.MSEColorPD3:CalculateInternals();

	OnColorSelected( defaultFillColor.color,	defaultFillColor.color,		Controls.MSEColorPD1 );
	OnColorSelected( defaultBgColor1.color,		defaultBgColor1.color,		Controls.MSEColorPD2 );
	OnColorSelected( defaultBgColor2.color,		defaultBgColor2.color,		Controls.MSEColorPD3 );

end


--************************************************************
local function OnBtnShowMseSearchOptions()
	local isHidden = Controls.MSESearchOptions:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.MSESearchOptions:SetHide( false );
	end
end

--************************************************************
function InitMseSearchOpitonsPanel()
	Controls.MseSearchOptionsBtn:RegisterCallback( Mouse.eLClick, OnBtnShowMseSearchOptions );
	InitBgColorPD();
end