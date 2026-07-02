-- Military Engineer Railroad Highlight (UI / InGame)
-- Highlights visible railroad tiles while the local player's Military Engineer is the selected unit.
-- Plain Lua 5.1 (no ":type" annotations).

-- FIX: Mods like "More Lenses" actively suppress the Religion/Search layers if you don't 
-- have the correct unit selected. The "Great People" layer is much safer. 
-- NOTE: This will NOT highlight actual Great People! The game only draws GP tiles when 
-- a GP is actively selected. When an Engineer is selected, it will exclusively show railroads.
local RAIL_LENS_LAYER = UILens.CreateLensLayerHash("Hex_Coloring_Great_People");

local m_railroadRouteIndex = -1;
local m_highlightActive = false;

-- Debug: prints to Lua.log (grep for "MERH"). Turn on while diagnosing.
local MERH_DEBUG = false;
local MERH_DEBUG_VERBOSE = false;

local function dbg(msg)
    if MERH_DEBUG then
        print("MERH " .. tostring(msg));
    end
end

local function dbgVerbose(msg)
    if MERH_DEBUG and MERH_DEBUG_VERBOSE then
        print("MERH " .. tostring(msg));
    end
end

-- ---------------------------------------------------------------------------
local function EnsureRouteIndex()
    if m_railroadRouteIndex >= 0 then
        return true;
    end
    local r = GameInfo.Routes["ROUTE_RAILROAD"];
    if r == nil then
        return false;
    end
    m_railroadRouteIndex = r.Index;
    return true;
end

-- ---------------------------------------------------------------------------
local function ClearHighlight()
    if m_highlightActive then
        dbg("ClearHighlight: clearing lens layer");
        UILens.ToggleLayerOff(RAIL_LENS_LAYER);
        UILens.ClearLayerHexes(RAIL_LENS_LAYER);
        m_highlightActive = false;
    end
end

-- ---------------------------------------------------------------------------
local function HeadUnitIsMilitaryEngineer()
    local head = UI.GetHeadSelectedUnit();
    if head == nil then
        return false;
    end
    local info = GameInfo.Units[head:GetUnitType()];
    return info ~= nil and info.UnitType == "UNIT_MILITARY_ENGINEER";
end

-- ---------------------------------------------------------------------------
local function CollectVisibleRailroadPlotIndices()
    local outPlots = {};
    if not EnsureRouteIndex() then
        return outPlots;
    end
    local observerId = Game.GetLocalObserver();
    local pVis = PlayerVisibilityManager.GetPlayerVisibility(observerId);
    local n = Map.GetPlotCount();
    for i = 0, n - 1 do
        local plot = Map.GetPlotByIndex(i);
        if plot ~= nil and plot:GetRouteType() == m_railroadRouteIndex then
            local include = true;
            if pVis ~= nil then
                local visState = pVis:GetState(i);
                if visState == RevealedState.HIDDEN then
                    include = false;
                end
            end
            if include then
                table.insert(outPlots, i);
            end
        end
    end
    return outPlots;
end

-- ---------------------------------------------------------------------------
local function EnsureDefaultLensForRailOverlay()
    if UILens.IsLensActive("MovementGood")
        or UILens.IsLensActive("MovementBad")
        or UILens.IsLensActive("MovementQueue")
        or UILens.IsLensActive("MovementFOW") then
        return;
    end
    if not UILens.IsLensActive("Default") then
        UILens.SetActive("Default");
    end
end

-- ---------------------------------------------------------------------------
local ApplyHighlight;
local RefreshHighlight;

ApplyHighlight = function()
    ClearHighlight();
    local localPlayer = Game.GetLocalPlayer();
    if localPlayer == nil or localPlayer < 0 then
        dbg("ApplyHighlight: skip (no local player)");
        return;
    end
    if not HeadUnitIsMilitaryEngineer() then
        dbg("ApplyHighlight: skip (head unit is not Military Engineer)");
        return;
    end
    if not EnsureRouteIndex() then
        dbg("ApplyHighlight: skip (ROUTE_RAILROAD missing from GameInfo)");
        return;
    end

    local plots = CollectVisibleRailroadPlotIndices();
    local head = UI.GetHeadSelectedUnit();
    local railCount = #plots;

    if #plots == 0 and head ~= nil then
        local pIdx = Map.GetPlotIndex(head:GetX(), head:GetY());
        if Map.IsPlot(pIdx) then
            table.insert(plots, pIdx);
            dbg("ApplyHighlight: 0 visible railroad tiles; using engineer plot fallback index=" .. tostring(pIdx));
        end
    end

    if #plots == 0 then
        dbg("ApplyHighlight: skip (no plots to draw after fallback)");
        return;
    end

    EnsureDefaultLensForRailOverlay();
    UILens.ToggleLayerOn(RAIL_LENS_LAYER);
    UILens.SetLayerHexesArea(RAIL_LENS_LAYER, localPlayer, plots);
    m_highlightActive = true;

    dbg("ApplyHighlight: OK SetLayerHexesArea plots=" .. tostring(#plots) .. " visibleRailroads=" .. tostring(railCount) .. " lensLayer=" .. tostring(RAIL_LENS_LAYER));
end

RefreshHighlight = function()
    if Game.GetLocalPlayer() == nil or Game.GetLocalPlayer() < 0 then
        dbg("RefreshHighlight: no local player, clear only");
        ClearHighlight();
        return;
    end
    if HeadUnitIsMilitaryEngineer() then
        dbg("RefreshHighlight: head is Military Engineer -> ApplyHighlight");
        ApplyHighlight();
    else
        dbg("RefreshHighlight: head is not Military Engineer -> ClearHighlight");
        ClearHighlight();
    end
end

-- Firaxis fires UnitSelectionChanged with isSelected=false and UI.GetHeadSelectedUnit()==nil
-- in the same click sequence as isSelected=true; clearing there removes the overlay instantly.
local function ScheduleSelectionRefresh()
    if ContextPtr ~= nil and ContextPtr.ClearUpdateHandler ~= nil and ContextPtr.SetUpdateHandler ~= nil then
        ContextPtr:ClearUpdateHandler();
        ContextPtr:SetUpdateHandler(function()
            ContextPtr:ClearUpdateHandler();
            RefreshHighlight();
        end);
        return;
    end
    
    -- Now, if you click empty space (deselecting everything), it will correctly 
    -- process the refresh and clear the active highlights immediately.
    RefreshHighlight();
end

-- ---------------------------------------------------------------------------
local function OnUnitSelectionChanged(playerID, unitID, hexI, hexJ, hexK, isSelected, isEditable)
    if playerID ~= Game.GetLocalPlayer() or playerID < 0 then
        return;
    end
    local head = UI.GetHeadSelectedUnit();
    local headDesc = "nil";
    if head ~= nil then
        local info = GameInfo.Units[head:GetUnitType()];
        headDesc = (info and info.UnitType) or ("unitTypeIndex=" .. tostring(head:GetUnitType()));
    end
    dbg("OnUnitSelectionChanged: playerID=" .. tostring(playerID) .. " unitID=" .. tostring(unitID) .. " isSelected=" .. tostring(isSelected) .. " head=" .. headDesc);
    ScheduleSelectionRefresh();
end

-- ---------------------------------------------------------------------------
local function OnRouteMapDirty()
    if HeadUnitIsMilitaryEngineer() then
        dbg("OnRouteMapDirty: re-apply");
        ApplyHighlight();
    end
end

-- ---------------------------------------------------------------------------
local function OnLoadGameViewStateDone()
    dbg("OnLoadGameViewStateDone");
    RefreshHighlight();
end

-- ---------------------------------------------------------------------------
local function OnInterfaceModeChanged(eOldMode, eNewMode)
    dbgVerbose("OnInterfaceModeChanged: old=" .. tostring(eOldMode) .. " new=" .. tostring(eNewMode) .. " engineerSel=" .. tostring(HeadUnitIsMilitaryEngineer()));
    if HeadUnitIsMilitaryEngineer() then
        ApplyHighlight();
    end
end

-- ---------------------------------------------------------------------------
local function OnLocalPlayerTurnBegin()
    dbg("OnLocalPlayerTurnBegin");
    if HeadUnitIsMilitaryEngineer() then
        ApplyHighlight();
    end
end

-- ---------------------------------------------------------------------------
local function OnLocalPlayerChanged(localPlayerID, prevLocalPlayerID)
    dbg("OnLocalPlayerChanged: new=" .. tostring(localPlayerID) .. " prev=" .. tostring(prevLocalPlayerID));
    ClearHighlight();
end

-- ---------------------------------------------------------------------------
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged);
dbg("Init: subscribed Events.UnitSelectionChanged");
if GameEvents ~= nil and GameEvents.UnitSelectionChanged ~= nil then
    GameEvents.UnitSelectionChanged.Add(OnUnitSelectionChanged);
    dbg("Init: subscribed GameEvents.UnitSelectionChanged");
else
    dbg("Init: GameEvents.UnitSelectionChanged not available");
end

Events.RouteAddedToMap.Add(OnRouteMapDirty);
Events.RouteChanged.Add(OnRouteMapDirty);
Events.RouteRemovedFromMap.Add(OnRouteMapDirty);
Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
Events.InterfaceModeChanged.Add(OnInterfaceModeChanged);
Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin);
Events.LocalPlayerChanged.Add(OnLocalPlayerChanged);

dbg("Init: EngineerRailHighlight.lua loaded; MERH_DEBUG=" .. tostring(MERH_DEBUG) .. " MERH_DEBUG_VERBOSE=" .. tostring(MERH_DEBUG_VERBOSE));