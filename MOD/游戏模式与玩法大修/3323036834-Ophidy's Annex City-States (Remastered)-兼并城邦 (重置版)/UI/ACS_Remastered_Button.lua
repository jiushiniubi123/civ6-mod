-- ACS_Remastered_Button
-- Author: Ophidy
-- DateCreated: 8/29/2024 9:48:40 PM
--------------------------------------------------------------
local m_LaunchButtonInstance = {};
local m_LaunchButtonLocked = false;
local debug = false;

function ToggleACSRPopup()
	--print('toggle ACSR Panel')
	LuaEvents.ACSR_TogglePopup()
end

function AttachLaunchButton()
    local buttonStack = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack");

    ContextPtr:BuildInstanceForControl("LaunchBarItem", m_LaunchButtonInstance, buttonStack);
	m_LaunchButtonInstance.LaunchItemIcon:SetIcon('ICON_ACSR_BUTTON');
    m_LaunchButtonInstance.LaunchItemButton:RegisterCallback(Mouse.eLClick, ToggleACSRPopup);
    ContextPtr:BuildInstanceForControl("LaunchBarPinInstance", {}, buttonStack);

    -- Resize.
    buttonStack:CalculateSize();

    local backing = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBacking");
    backing:SetSizeX(buttonStack:GetSizeX() + 116);

    local backingTile = ContextPtr:LookUpControl("/InGame/LaunchBar/LaunchBackingTile");
    backingTile:SetSizeX(buttonStack:GetSizeX() - 20);

    LuaEvents.LaunchBar_Resize(buttonStack:GetSizeX());
end

function OnACSRLauchButtonSetup()
	if not m_LaunchButtonLocked  then
		AttachLaunchButton();
		m_LaunchButtonLocked = true
	end
end

function Initialize()
    Events.LoadGameViewStateDone.Add(OnACSRLauchButtonSetup);
end

Initialize();