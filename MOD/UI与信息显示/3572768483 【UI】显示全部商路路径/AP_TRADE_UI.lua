include( "Colors" );
include("TradeSupport");
local m_LaunchButtonInstance = {};
local m_TradeRouteLens:number = UILens.CreateLensLayerHash("TradeRoutes");
local localPlayerID_AP = Game.GetLocalPlayer();

AP_TRADE_UI_OPTIONS = AP_TRADE_UI_OPTIONS or {
	COLORFUL_ROUTE		= true,
	SHOW_DOMESTIC		= true,
    SHOW_OUTGOING		= true,
	SHOW_INCOMING		= false,
}

function AP_TRADE_UI_ON(playerID:number, unitID:number)

    UILens.SetActive(m_TradeRouteLens);
    UILens.ClearLayerHexes(m_TradeRouteLens);

    local DEFAULT_TINT = UI.GetColorValue(1, 1, 1, 1);
    local AP_YELLOW_TINT = UI.GetColorValue(1, 1, 0, 1);
    local AP_GREEN_TINT = UI.GetColorValue(0, 1, 0, 1);
    local AP_RED_TINT = UI.GetColorValue(1, 0, 0, 1);
    local AP_BLUE_TINT = UI.GetColorValue(0.6, 0.8, 1, 1);
    local AP_OUTGOING_TINT = AP_YELLOW_TINT
    local AP_INCOMING_TINT = AP_BLUE_TINT
    local AP_DOMESTIC_TINT = DEFAULT_TINT

    local originPlayer:table = Players[playerID];
    local originCities:table = originPlayer:GetCities();
    local tradeManager:table = Game.GetTradeManager();

    for _, originCity in originCities:Members() do
        if AP_TRADE_UI_OPTIONS.SHOW_OUTGOING == true then
            local outgoingRoutes:table = originCity:GetTrade():GetOutgoingRoutes();
            for _, routeInfo in ipairs(outgoingRoutes) do
                --if unitID == routeInfo.TraderUnitID then
                    local destinationPlayer:table = Players[routeInfo.DestinationCityPlayer];
                    if destinationPlayer:GetID() ~= localPlayerID_AP then
                    local destinationCity:table = destinationPlayer:GetCities():FindID(routeInfo.DestinationCityID);

                    pathPlots, portalEntrances, portalExits = tradeManager:GetTradeRoutePath(originCity:GetOwner(), originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID());
                    if AP_TRADE_UI_OPTIONS.COLORFUL_ROUTE == true then
                        AP_OUTGOING_TINT = AP_YELLOW_TINT
                    else
                        AP_OUTGOING_TINT = DEFAULT_TINT
                    end
                    SetPathSegment(pathPlots,portalEntrances,portalExits,AP_OUTGOING_TINT)

                    end
                --end
            end
        end
        if AP_TRADE_UI_OPTIONS.SHOW_INCOMING == true then
            local incomingRoutes:table = originCity:GetTrade():GetIncomingRoutes();
            for _, routeInfo in ipairs(incomingRoutes) do
                --if unitID == routeInfo.TraderUnitID then
                    local originPlayer1:table = Players[routeInfo.OriginCityPlayer];
                    if originPlayer1:GetID() ~= localPlayerID_AP then
                    local originCity1:table = originPlayer1:GetCities():FindID(routeInfo.OriginCityID);

                    pathPlots, portalEntrances, portalExits = tradeManager:GetTradeRoutePath(originCity1:GetOwner(), originCity1:GetID(),originCity:GetOwner(), originCity:GetID());
                    if AP_TRADE_UI_OPTIONS.COLORFUL_ROUTE == true then
                        AP_INCOMING_TINT = AP_BLUE_TINT
                    else
                        AP_INCOMING_TINT = DEFAULT_TINT
                    end
                    SetPathSegment(pathPlots,portalEntrances,portalExits,AP_INCOMING_TINT)
                    end
                --end
            end
        end
        if AP_TRADE_UI_OPTIONS.SHOW_DOMESTIC == true then
            local outgoingRoutes:table = originCity:GetTrade():GetOutgoingRoutes();
            for _, routeInfo in ipairs(outgoingRoutes) do
                --if unitID == routeInfo.TraderUnitID then
                    local destinationPlayer:table = Players[routeInfo.DestinationCityPlayer];
                    if destinationPlayer:GetID() == localPlayerID_AP then
                    local destinationCity:table = destinationPlayer:GetCities():FindID(routeInfo.DestinationCityID);

                    pathPlots, portalEntrances, portalExits = tradeManager:GetTradeRoutePath(originCity:GetOwner(), originCity:GetID(), destinationCity:GetOwner(), destinationCity:GetID());
                    SetPathSegment(pathPlots,portalEntrances,portalExits,AP_DOMESTIC_TINT)
                    end
                --end
            end
        end
    end
end

function SetPathSegment(pathPlots,portalEntrances,portalExits,Color)
    if #pathPlots == 0 then return end
    local pPathSegment = { };
    for i,plot in pairs(pathPlots) do
        local pExit = portalExits[i];
        if (pExit and pExit >= 0) then
            table.insert(pPathSegment, pExit);
        end
        table.insert(pPathSegment, plot);
        local pEntrance = portalEntrances[i];
        if (pEntrance and pEntrance >= 0) then
            table.insert(pPathSegment, pEntrance);
            UILens.SetLayerHexesPath( m_TradeRouteLens, Game.GetLocalPlayer(), pPathSegment, { }, Color );
            pPathSegment = { };
        end
    end
    local kVariations:table = {};
    local lastElement:number = table.count(pathPlots);
    table.insert(kVariations, {"TradeRoute_Destination", pathPlots[lastElement]} );
    table.insert(kVariations, {"TradeRoute_Destination", pathPlots[1]} );
    UILens.SetLayerHexesPath(m_TradeRouteLens, Game.GetLocalPlayer(), pPathSegment, kVariations, Color);
end



local AP_TRADE_TOP_BOTTON_SWITCH = 0

function ToggleReminderPopup()
    if AP_TRADE_TOP_BOTTON_SWITCH == 0 then
        localPlayerID_AP = Game.GetLocalPlayer()
        AP_TRADE_UI_ON(localPlayerID_AP)
        AP_TRADE_TOP_BOTTON_SWITCH = 1
    elseif AP_TRADE_TOP_BOTTON_SWITCH == 1 then
        UILens.ClearLayerHexes(m_TradeRouteLens);
        AP_TRADE_TOP_BOTTON_SWITCH = 0
    end
end
function ToggleScreenshotOptionsPanel()

	m_LaunchButtonInstance.AP_TRADE_TOP_OptionsPanel:SetHide(
		not m_LaunchButtonInstance.AP_TRADE_TOP_OptionsPanel:IsHidden()
	)
end
function ToggleScreenshotOption(sOption)
	AP_TRADE_UI_OPTIONS[sOption] = not AP_TRADE_UI_OPTIONS[sOption]
	m_LaunchButtonInstance[sOption]:SetCheck(AP_TRADE_UI_OPTIONS[sOption])
end



function Initialize()
    print("AP_TRDE_UI INI")
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("AP_TRADE_TOP", m_LaunchButtonInstance, buttonStack);
    m_LaunchButtonInstance.AP_TRADE_TOP_BOTTON:RegisterCallback(Mouse.eLClick, ToggleReminderPopup);
    m_LaunchButtonInstance.AP_TRADE_TOP_BOTTON:RegisterCallback(Mouse.eRClick, ToggleScreenshotOptionsPanel)

    m_LaunchButtonInstance.AP_TRADE_TOP_ON:RegisterCallback(Mouse.eLClick, ToggleReminderPopup);
    m_LaunchButtonInstance.AP_TRADE_TOP_ON:RegisterCallback(Mouse.eRClick, ToggleScreenshotOptionsPanel)

    for sOption, bBool in pairs(AP_TRADE_UI_OPTIONS) do
		m_LaunchButtonInstance[sOption]:SetCheck(bBool)
		m_LaunchButtonInstance[sOption]:RegisterCallback(Mouse.eLClick,
			function()
				ToggleScreenshotOption(sOption)
			end
		)
	end

    -- Resize.
    buttonStack:CalculateSize();
    local backing = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBacking");
    backing:SetSizeX(buttonStack:GetSizeX() + 116);
    local backingTile = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBackingTile");
    backingTile:SetSizeX(buttonStack:GetSizeX() - 20);
    LuaEvents.LaunchBar_Resize(buttonStack:GetSizeX());

end

Events.LoadGameViewStateDone.Add( Initialize);

