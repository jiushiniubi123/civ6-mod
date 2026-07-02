-- AnansiInspire
-- Author: Konomi
-- DateCreated: 11/13/2021 20:06:54
--------------------------------------------------------------

function IsInspireButtonHide()
	local pUnit = UI.GetHeadSelectedUnit()
	if pUnit == nil then
		return true
	end
    local sUnitType = GameInfo.Units[pUnit:GetType()].UnitType
	--不是阿南西就隐藏
	if sUnitType ~= "UNIT_HERO_ANANSI" then
		return true
	end
	--行动力为0就隐藏
	if pUnit:GetMovementMovesRemaining() == 0 then
		return true
	end
	--次数为0就隐藏
	if pUnit:GetActionCharges() == 0 then
		return true
	end
	return false
end

function RefreshInspireButtonDisabled(playerID, unitID, iX, iY)
	local params:table = ExposedMembers.SOTS.GetCurrentParam(playerID)

	local pPlot = Map.GetPlot(iX, iY)
	if pPlot:GetResourceCount() > 0 then
		local pUnit = UnitManager.GetUnit(playerID, unitID)
		local iPlayer = pUnit:GetOwner()
		local pPlayer = Players[iPlayer]
		local playerResources = pPlayer:GetResources()
		--local resourceHash = GameInfo.Resources[resourceType].Hash;
		local resourceHash = pPlot:GetResourceTypeHash()
		if playerResources:IsResourceVisible(resourceHash) then
			Controls.AnansiInspireButton:SetDisabled(false)
			Controls.AnansiInspireButton:SetToolTipString(Locale.Lookup("LOC_KNM_ANANSI_INSPIRE_TIP", params['science'], params['culture']))
			return
		end
	end
	Controls.AnansiInspireButton:SetDisabled(true)
	Controls.AnansiInspireButton:SetToolTipString(Locale.Lookup("LOC_KNM_ANANSI_INSPIRE_TIP", params['science'], params['culture']) .. Locale.Lookup("LOC_KNM_ANANSI_DISABLED_VISIBLE_TIP"))
	
end

function Refresh(playerID, unitID, iX, iY)
	if IsInspireButtonHide() then
		Controls.AnansiInspireButtonGrid:SetHide(true)
	else
		Controls.AnansiInspireButtonGrid:SetHide(false)
		RefreshInspireButtonDisabled(playerID, unitID, iX, iY)
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


function OnInspireButtonClicked()
	--UI.PlaySound('Confirm_Civic')
	local pUnit = UI.GetHeadSelectedUnit()
	local iX = pUnit:GetX()
	local iY = pUnit:GetY()
	local iPlayer = pUnit:GetOwner()

	SimUnitSystem.SetAnimationState(pUnit, "ACTION_1", "IDLE")
	ExposedMembers.SOTS.RemoveResource(iX, iY)
	ExposedMembers.SOTS.AddScienceCulture(iPlayer, iX, iY)
	--UnitManager.RequestCommand(pUnit, UnitCommandTypes.RESOURCE_INSPIRE, {});
	ExposedMembers.SOTS.ChangeActionCharges(iPlayer, pUnit:GetID(), -1)
	Controls.AnansiInspireButtonGrid:SetHide(true)
end

function Initialize()
    local path = '/InGame/UnitPanel/StandardActionsStack'
	local ctrl = ContextPtr:LookUpControl(path)
	
	if ctrl ~= nil then
		Controls.AnansiInspireButtonGrid:ChangeParent(ctrl)
		Controls.AnansiInspireButton:RegisterCallback(Mouse.eLClick, OnInspireButtonClicked)
	end
end

Events.LoadGameViewStateDone.Add(Initialize)
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged)
Events.UnitMoveComplete.Add(OnUnitMoveComplete)
