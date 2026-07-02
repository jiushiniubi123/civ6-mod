-- Suk_CQUI_StatusMessagePanel
-- CQUI-compatible version of StatusMessagePanel for Sukritact's Simple UI Adjustments
-- ===========================================================================
-- INCLUDE CQUI FILE (which already includes the base StatusMessagePanel)
-- ===========================================================================
include("StatusMessagePanel_CQUI");
-- ===========================================================================
-- OnWorldTextMessage
-- Format for calling this is Game.AddWorldViewText(iType, iSubType, -1, -1, sMessage)
-- ===========================================================================
function OnWorldTextMessage(iType, iSubType, iX, iY, sMessage)
	OnStatusMessage(sMessage, 7, iType, iSubType)
end
-- ===========================================================================
-- LateInitialize
-- ===========================================================================
BASE_CQUI_Suk_LateInitialize = LateInitialize

function LateInitialize()
	if LateInitialize then BASE_CQUI_Suk_LateInitialize() end
	Events.WorldTextMessage.Add(OnWorldTextMessage)
	LuaEvents.Custom_StatusMessage.Add(OnStatusMessage)
end
-- ===========================================================================
-- OnShutdown
-- ===========================================================================
BASE_CQUI_Suk_OnShutdown = OnShutdown
function OnShutdown()
	if BASE_CQUI_Suk_OnShutdown then BASE_CQUI_Suk_OnShutdown() end
	Events.WorldTextMessage.Remove(OnWorldTextMessage)
	LuaEvents.Custom_StatusMessage.Remove(OnStatusMessage)
end
ContextPtr:SetShutdown(OnShutdown)
-- ===========================================================================