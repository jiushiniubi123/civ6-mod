-- MauiCreateResource
-- Author: Konomi (modified)
-- DateCreated: 11/13/2021 20:06:54
--------------------------------------------------------------

function IsCreateButtonHide()
	local pUnit = UI.GetHeadSelectedUnit()
	if pUnit == nil then
		return true
	end
    local sUnitType = GameInfo.Units[pUnit:GetType()].UnitType
	if sUnitType ~= "UNIT_HERO_MAUI" then
		return true
	end
	if pUnit:GetMovementMovesRemaining() == 0 then
		return true
	end
	if pUnit:GetActionCharges() == 0 then
		return true
	end
	return false
end

function RefreshCreateButtonDisabled(playerID, unitID, iX, iY)
	local reason = ExposedMembers.SOTS.CanAddResource(iX, iY)
	if reason == '' then
		Controls.MauiCreateButton:SetDisabled(false)
		Controls.MauiCreateButton:SetToolTipString(Locale.Lookup("LOC_KNM_MAUI_CREATE_TIP"))
	else
		Controls.MauiCreateButton:SetDisabled(true)
		Controls.MauiCreateButton:SetToolTipString(Locale.Lookup("LOC_KNM_MAUI_CREATE_TIP") .. Locale.Lookup("LOC_KNM_MAUI_DISABLED_" .. reason .. "_TIP"))
	end
end

function Refresh(playerID, unitID, iX, iY)
	if IsCreateButtonHide() then
		Controls.MauiCreateButtonGrid:SetHide(true)
	else
		Controls.MauiCreateButtonGrid:SetHide(false)
		RefreshCreateButtonDisabled(playerID, unitID, iX, iY)
	end  
end

function OnUnitMoveComplete(playerID, unitID, iX, iY)
	Refresh(playerID, unitID, iX, iY)
end

function OnUnitSelectionChanged(playerID, unitID, plotX, plotY, plotZ, bSelected, bEditable)
    if bSelected then
        Refresh(playerID, unitID, plotX, plotY)
    end
end

function OnCreateButtonClicked()
	local pUnit = UI.GetHeadSelectedUnit()
	local iX = pUnit:GetX()
	local iY = pUnit:GetY()
	local iPlayer = pUnit:GetOwner()

	SimUnitSystem.SetAnimationState(pUnit, "ACTION_1", "IDLE")
	ExposedMembers.SOTS.AddRandomBonusResource(iX, iY)
	ExposedMembers.SOTS.ChangeActionCharges(iPlayer, pUnit:GetID(), -1)
	Controls.MauiCreateButtonGrid:SetHide(true)
end

function Initialize()
    local path = '/InGame/UnitPanel/StandardActionsStack'
	local ctrl = ContextPtr:LookUpControl(path)
	
	if ctrl ~= nil then
		Controls.MauiCreateButtonGrid:ChangeParent(ctrl)
		Controls.MauiCreateButton:RegisterCallback(Mouse.eLClick, OnCreateButtonClicked)
	end
end

Events.LoadGameViewStateDone.Add(Initialize)
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
Events.UnitMoveComplete.Add(OnUnitMoveComplete)