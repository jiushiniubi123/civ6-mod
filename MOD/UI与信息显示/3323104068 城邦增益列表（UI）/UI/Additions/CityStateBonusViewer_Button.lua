-- CityStateBonusViewer_Button
-- Author: yiboy
-- DateCreated: 8/1/2024 6:27:16 PM
--------------------------------------------------------------

local m_LaunchButtonInstance_NFD = {};
local m_buttonActivated = false

local m_propertyKey					= "PlayerCanGetFanciaHopeTraits"


local currentTurn = -1
-- ===========================================================================
function TogglePopup_NFD()
	print("toggle 1")
	LuaEvents.CityStateViewer_Button_TogglePopup()
	print("toggle 2")
end
-- ===========================================================================
function AttachLaunchButton_CityStateViewer()
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("CityStateViewer_Item", m_LaunchButtonInstance_NFD, buttonStack);
    m_LaunchButtonInstance_NFD.CityStateViewer_Button:RegisterCallback(Mouse.eLClick, TogglePopup_NFD);
    ContextPtr:BuildInstanceForControl("CityStateViewer_PinInstance", {}, buttonStack);

    -- Resize.
    buttonStack:CalculateSize();

    local backing = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBacking");
    backing:SetSizeX(buttonStack:GetSizeX() + 116);

    local backingTile = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBackingTile");
    backingTile:SetSizeX(buttonStack:GetSizeX() - 20);

    LuaEvents.LaunchBar_Resize(buttonStack:GetSizeX());
end
-- ===========================================================================
function Refresh()
	if Players[Game.GetLocalPlayer()]:IsHuman() then
		--总是不显示感叹号
		m_LaunchButtonInstance_NFD.CityStateViewer_AlertIndicator:SetHide(true);
		return;
	end
	m_LaunchButtonInstance_NFD.CityStateViewer_AlertIndicator:SetHide(true);
end
-- ===========================================================================
function OnLoadGameViewStateDone_CityStateViewer()
	AttachLaunchButton_CityStateViewer();
	Refresh()

end
-- ===========================================================================
function Initialize_CityStateViewer()
	if not m_buttonActivated then
		if Players[Game.GetLocalPlayer()]:IsHuman() then
			Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone_CityStateViewer);


			--Events.PlayerTurnActivated.Add(Refresh);
			--Events.ResearchCompleted.Add(Refresh)
			--Events.CivicCompleted.Add(Refresh)
			--Events.InfluenceGiven.Add(Refresh)

			LuaEvents.CityStateViewer_Panel_Closed.Add(Refresh)

			m_buttonActivated = true
		end
	end
    
end

Initialize_CityStateViewer();
-- ===========================================================================


-- ===========================================================================
function initialize()	
	print("City State Viewer Button Initialized!")

end
Events.LoadGameViewStateDone.Add( initialize );