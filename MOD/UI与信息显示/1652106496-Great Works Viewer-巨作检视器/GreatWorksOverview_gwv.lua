-- Great Works Viewer mod.

-- Copy from central file
local DATA_FIELD_SLOT_CACHE:string = "SlotCache";
-- Current filter
local gwv_filterMode = "";
-- Setting for vertical expansion.
local gwv_allowVerticalExpansion = false;
-- Set sort order
local gwv_originalSort = false;

-- Concise UI ----------------------------------------------------------------
local cui_ThemeHelper = false;

function CuiOnThemeButtonClick()
    cui_ThemeHelper = not cui_ThemeHelper
    UpdateData()
end
function CuiInit()
    Controls.ThemeHelper:RegisterCallback(Mouse.eLClick, CuiOnThemeButtonClick)
    Controls.ThemeHelper:RegisterCallback(
        Mouse.eMouseEnter,
        function()
            UI.PlaySound("Main_Menu_Mouse_Over")
        end
    )
    Controls.ThemeHelper:SetToolTipString(Locale.Lookup("LOC_CUI_GWV_THEMING_HELPER_TOOLTIP"))
end
function CuiSetThemeMask(instance, srcBldgs, srcBuilding, srcSlot)
    local srcGreatWork = srcBldgs:GetGreatWorkInSlot(srcBuilding, srcSlot)
    local srcGreatWorkType = srcBldgs:GetGreatWorkTypeFromIndex(srcGreatWork)
    local srcGreatWorkObjectType = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType
    local greatWorkInfo = GameInfo.GreatWorks[srcGreatWorkType]

    local artist = 0
    if greatWorkInfo.GreatPersonReference then
        artist = greatWorkInfo.GreatPersonReference.Index
    elseif greatWorkInfo.EraType then
        artist = Game.GetGreatWorkPlayer(srcGreatWork)
    end
    instance.ThemeText:SetText(artist)
    instance.ThemeBacking:SetHide(false)
    instance.ThemeMask:SetHide(not cui_ThemeHelper);

    if srcGreatWorkObjectType == "GREATWORKOBJECT_ARTIFACT" then
        if greatWorkInfo.EraType == "ERA_ANCIENT" then
            instance.ThemeColor:SetColorByName("Civ6Blue")
        elseif greatWorkInfo.EraType == "ERA_CLASSICAL" then
            instance.ThemeColor:SetColorByName("Civ6DarkRed")
        elseif greatWorkInfo.EraType == "ERA_MEDIEVAL" then
            instance.ThemeColor:SetColorByName("Civ6Green")
        elseif greatWorkInfo.EraType == "ERA_RENAISSANCE" then
            instance.ThemeColor:SetColorByName("Civ6LightBlue")
        elseif greatWorkInfo.EraType == "ERA_INDUSTRIAL" then
            instance.ThemeColor:SetColorByName("Civ6Red")
        end
    elseif srcGreatWorkObjectType == "GREATWORKOBJECT_SCULPTURE" then
        instance.ThemeColor:SetColorByName("COLOR_FLOAT_CULTURE")
    elseif srcGreatWorkObjectType == "GREATWORKOBJECT_LANDSCAPE" then
        instance.ThemeColor:SetColorByName("COLOR_FLOAT_FOOD")
    elseif srcGreatWorkObjectType == "GREATWORKOBJECT_PORTRAIT" then
        instance.ThemeColor:SetColorByName("COLOR_FLOAT_GOLD")
    elseif srcGreatWorkObjectType == "GREATWORKOBJECT_RELIGIOUS" then
        instance.ThemeColor:SetColorByName("COLOR_FLOAT_PRODUCTION")
    else
        instance.ThemeColor:SetColorByName("Clear")
        instance.ThemeBacking:SetHide(true)
        instance.ThemeText:SetText(" ")
    end
end

function CuiSetLockMask(instance, srcBldgs, srcBuilding, srcSlot)
    local srcGreatWork = srcBldgs:GetGreatWorkInSlot(srcBuilding, srcSlot)
    local srcGreatWorkType = srcBldgs:GetGreatWorkTypeFromIndex(srcGreatWork)
    local srcGreatWorkObjectType = GameInfo.GreatWorks[srcGreatWorkType].GreatWorkObjectType

    instance.LockIcon:SetHide(true)
    instance.LockMask:SetHide(true)
    instance.LockColor:SetColorByName("Clear")
    instance.LockText:SetText(" ")
    instance.LockMask:SetHide(cui_ThemeHelper);

    -- lock no turns
    if (srcGreatWorkObjectType == "GREATWORKOBJECT_ARTIFACT") then
        -- lock with turns
        local numSlots = srcBldgs:GetNumGreatWorkSlots(srcBuilding)
        for index = 0, numSlots - 1 do
            local greatWorkIndex = srcBldgs:GetGreatWorkInSlot(srcBuilding, index)
            if (greatWorkIndex == -1) then
                instance.LockIcon:SetHide(false)
                instance.LockMask:SetHide(false)
                instance.LockColor:SetColorByName("Black")
                instance.LockText:SetText(" ")
            end
        end
    elseif
        (srcGreatWorkObjectType == "GREATWORKOBJECT_SCULPTURE" or srcGreatWorkObjectType == "GREATWORKOBJECT_LANDSCAPE" or
            srcGreatWorkObjectType == "GREATWORKOBJECT_PORTRAIT" or
            srcGreatWorkObjectType == "GREATWORKOBJECT_RELIGIOUS")
     then
        local iTurnCreated = srcBldgs:GetTurnFromIndex(srcGreatWork)
        local iCurrentTurn = Game.GetCurrentGameTurn()
        local iTurnsBeforeMove = GlobalParameters.GREATWORK_ART_LOCK_TIME or 10
        local iTurnsToWait = iTurnCreated + iTurnsBeforeMove - iCurrentTurn
        if iTurnsToWait > 0 then
            instance.LockIcon:SetHide(false)
            instance.LockMask:SetHide(false)
            instance.LockColor:SetColorByName("Black")
            instance.LockText:SetText(iTurnsToWait .. "[ICON_TURN]")
        end
    end
end
-- Concise UI END ------------------------------------------------------------

-- ===========================================================================
-- Resize

function GwvResize(nBuildings)
	-- Resize window to fit more columns, if possible.
	local columns = math.ceil(nBuildings / 4);
	local needWidth = 1024;
	-- Default UI is for 4 columns, do not shrink it further.
	if columns > 4 then
		-- The column size is 248 + 5 padding. This might be possible to extract from XML.
		local columnSize = 253;
		local screenWidth:number, screenHeight:number = UIManager:GetScreenSizeVal();
		needWidth = 1024 + columnSize * (columns - 4);
		while (needWidth > screenWidth) do
			needWidth = needWidth - columnSize;
			columns = columns - 1;
		end
	end
	Controls.GreatWorksTop:SetSizeX(needWidth);

	-- Was the columns enough or do we need more rows?
	local rows = math.ceil(nBuildings / columns);
	local needHeight = 768;
	if gwv_allowVerticalExpansion and rows > 4 and columns > 4 then
		local rowSize = 155; -- 150 + 5 padding
		needHeight = 768 + rowSize * (rows - 4);
		local screenWidth:number, screenHeight:number = UIManager:GetScreenSizeVal();
                -- Reasonable max height is not full screen. Limit to one less.
                screenHeight = screenHeight - rowSize;
		while (rows > 4 and needHeight > screenHeight) do
			needHeight = needHeight - rowSize;
                        rows = rows - 1;
		end
	end
	Controls.GreatWorksTop:SetSizeY(needHeight);
	Controls.GreatWorksStack:SetWrapWidth(needHeight-148);
	if needHeight == 768 then
		Controls.ModalBG:SetSizeY(768);
	else
		-- Mostly hide the background image since it looks bad otherwise.
		Controls.ModalBG:SetSizeY(135);
	end
	-- Give the option to expand vertically once horizontal is not enough
	Controls.AllowY:SetHide(rows <= 4 or columns <= 4);
        SetFilter("");
end

function OnAllowY()
	gwv_allowVerticalExpansion = not gwv_allowVerticalExpansion;
	if gwv_allowVerticalExpansion then
		Controls.AllowY:SetText(Locale.Lookup("LOC_GREATWORKSVIEW_DISALLOWY"));
		Controls.AllowY:SetToolTipString(Locale.Lookup("LOC_GREATWORKSVIEW_DISALLOWY_TT"));
	else
		Controls.AllowY:SetText(Locale.Lookup("LOC_GREATWORKSVIEW_ALLOWY"));
		Controls.AllowY:SetToolTipString(Locale.Lookup("LOC_GREATWORKSVIEW_ALLOWY_TT"));
        end
	UpdateGreatWorks();
end

-- ===========================================================================
-- Filters

function ClearFilterButtons()
	Controls.FilterArt:SetSelected(false);
	Controls.FilterArtifact:SetSelected(false);
	Controls.FilterMusic:SetSelected(false);
	Controls.FilterRelic:SetSelected(false);
	Controls.FilterWriting:SetSelected(false);
end

function FilterWorkVisible(dstSlotString:string)
	--print("FilterWorkVisible " .. dstSlotString .. " when filtering " .. gwv_filterMode);
	if gwv_filterMode == "" then
		return true;
	end
	-- Ref: GreatWorks.xml <GreatWorkSlotTypes> and <GreatWork_ValidSubTypes>
	-- Could this be extract from the database?

	-- Palace can have anything but Artifact
	if dstSlotString == "GREATWORKSLOT_PALACE" and gwv_filterMode ~= "Artifact" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_WRITING" and gwv_filterMode == "Writing" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_ART" and gwv_filterMode == "Art" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_CATHEDRAL" and gwv_filterMode == "Art" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_ARTIFACT" and gwv_filterMode == "Artifact" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_MUSIC" and gwv_filterMode == "Music" then
		return true;
	end
	if dstSlotString == "GREATWORKSLOT_RELIC" and gwv_filterMode == "Relic" then
		return true;
	end
	return false;
end

function SetFilter(newMode, button)
	if newMode == "" then
        	-- Keep mode
	elseif gwv_filterMode == newMode then
        	-- Toggle
		gwv_filterMode = "";
                ClearFilterButtons();
	else
		gwv_filterMode = newMode;
                ClearFilterButtons();
                if button ~= nil then
                	button:SetSelected(true);
                end
	end
	for _:number, destination:table in ipairs(GetGreatWorkBuildings()) do
		local instance:table = destination.Instance;
		local dstBuilding:number = destination.Index;
		local dstBldgs:table = destination.CityBldgs;
		local slotCache:table = instance[DATA_FIELD_SLOT_CACHE];
		local numSlots:number = dstBldgs:GetNumGreatWorkSlots(dstBuilding);
		instance.TopControl:SetHide(true);
		for dstSlot:number = 0, numSlots - 1 do
			-- dstBldgs, dstBuilding, dstSlot
			local dstSlotType:number = dstBldgs:GetGreatWorkSlotType(dstBuilding, dstSlot);
			local dstSlotString:string = GameInfo.GreatWorkSlotTypes[dstSlotType].GreatWorkSlotType;
			--print("Building has slot type " .. dstSlotString .. " X " .. destination.Type);
			if FilterWorkVisible(dstSlotString) then
				instance.TopControl:SetHide(false);
				slotCache[dstSlot+1].FilterMask:SetHide(true);
			else
				slotCache[dstSlot+1].FilterMask:SetHide(false);
			end
		end
	end
	--for row in GameInfo.GreatWork_ValidSubTypes() do
	--	local slotType = row.GreatWorkSlotType;
	--	local slotString = GameInfo.GreatWorkSlotTypes[slotType].GreatWorkSlotType;
	--	local objType = row.GreatWorkObjectType;
	--	print("VALID " .. slotString .. " X " .. objType);
	--end
end

function OnFilterArt()
         SetFilter("Art", Controls.FilterArt);
end
function OnFilterArtifact()
         SetFilter("Artifact", Controls.FilterArtifact);
end
function OnFilterMusic()
         SetFilter("Music", Controls.FilterMusic);
end
function OnFilterRelic()
         SetFilter("Relic", Controls.FilterRelic);
end
function OnFilterWriting()
         SetFilter("Writing", Controls.FilterWriting);
end

-- ===========================================================================
-- Sorting

function GwvSortOrder()
	return not gwv_originalSort;
end

function OnOrderOrig()
	gwv_originalSort = not gwv_originalSort;
	if gwv_originalSort then
		Controls.OrderOrig:SetText(Locale.Lookup("LOC_GREATWORKSVIEW_ORDER_BY_TYPE"));
		Controls.OrderOrig:SetToolTipString(Locale.Lookup("LOC_GREATWORKSVIEW_ORDER_BY_TYPE_TT"));
	else
		Controls.OrderOrig:SetText(Locale.Lookup("LOC_GREATWORKSVIEW_ORIG_ORDER"));
		Controls.OrderOrig:SetToolTipString(Locale.Lookup("LOC_GREATWORKSVIEW_ORIG_ORDER_TT"));
        end
	UpdateGreatWorks();
end

-- ===========================================================================
-- Startup

local BaseInit = Initialize;
function Initialize()
	BaseInit();
	CuiInit() -- Concise UI

	print("Improved View Great Works mod active.");
	Controls.FilterArt:RegisterCallback(Mouse.eLClick,	OnFilterArt);
	Controls.FilterArtifact:RegisterCallback(Mouse.eLClick, OnFilterArtifact);
	Controls.FilterMusic:RegisterCallback(Mouse.eLClick,	OnFilterMusic);
	Controls.FilterRelic:RegisterCallback(Mouse.eLClick,	OnFilterRelic);
	Controls.FilterWriting:RegisterCallback(Mouse.eLClick,	OnFilterWriting);
	Controls.OrderOrig:RegisterCallback(Mouse.eLClick,	OnOrderOrig);
	Controls.AllowY:RegisterCallback(Mouse.eLClick,		OnAllowY);
	Controls.FilterArt:RegisterCallback( Mouse.eMouseEnter,     function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.FilterArtifact:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.FilterMusic:RegisterCallback(Mouse.eMouseEnter,    function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.FilterRelic:RegisterCallback(Mouse.eMouseEnter,    function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.FilterWriting:RegisterCallback(Mouse.eMouseEnter,  function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.OrderOrig:RegisterCallback(Mouse.eMouseEnter,      function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.AllowY:RegisterCallback(Mouse.eMouseEnter,         function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
        ClearFilterButtons();
end
