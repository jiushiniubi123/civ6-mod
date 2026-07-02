GameEvents = ExposedMembers.GameEvents;
local m_iResources = {
    GameInfo.Resources["RESOURCE_HORSES"].Index,
    GameInfo.Resources["RESOURCE_IRON"].Index,
    GameInfo.Resources["RESOURCE_NITER"].Index,
    GameInfo.Resources["RESOURCE_ALUMINUM"].Index,
    GameInfo.Resources["RESOURCE_COAL"].Index,
    GameInfo.Resources["RESOURCE_OIL"].Index,
    GameInfo.Resources["RESOURCE_URANIUM"].Index
    };
local m_iTechs = {
    GameInfo.Technologies["TECH_ANIMAL_HUSBANDRY"].Index,
    GameInfo.Technologies["TECH_BRONZE_WORKING"].Index,
    GameInfo.Technologies["TECH_MILITARY_ENGINEERING"].Index,
    GameInfo.Technologies["TECH_RADIO"].Index,
    GameInfo.Technologies["TECH_INDUSTRIALIZATION"].Index,
    GameInfo.Technologies["TECH_REFINING"].Index,
    GameInfo.Technologies["TECH_COMBINED_ARMS"].Index
    };
local m_nProductionAdd = {
    10,
    20,
    30,
    40,
    50,
    70,
    100
    };
-- ================================要求===========================================
function CanSellResource(PlayerID, mResource, nResource, bDecrease)
    local pPlayer = Players[PlayerID];
    local pResource:number = pPlayer:GetResources():GetResourceAmount(m_iResources[mResource]);
    if bDecrease then
        pResource = pResource - 50 ;
    end
    if (pResource >= nResource ) then
        return false ;
    else
        return true ;
    end
end

function HasResourceTech(PlayerID, mResource )
    local pPlayer = Players[PlayerID];
    local bTech:boolean = not pPlayer:GetTechs():HasTech(m_iTechs[mResource]);
    return bTech;
end

function OnEnterCityPanel( ownerPlayerID:number, cityID:number, i:number, j:number, k:number, isSelected:boolean, isEditable:boolean)
    print("City Selected.");
    Controls.SRP_SellHorseCheck:SetHide(HasResourceTech(ownerPlayerID,1));
    Controls.SRP_SellHorseCheck:SetDisabled(CanSellResource(ownerPlayerID,1,50, false));
    Controls.SRP_SellHorseCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,1); end );

    Controls.SRP_SellIronCheck:SetHide(HasResourceTech(ownerPlayerID,2));
    Controls.SRP_SellIronCheck:SetDisabled(CanSellResource(ownerPlayerID,2,50, false));
    Controls.SRP_SellIronCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,2); end );

    Controls.SRP_SellNiterCheck:SetHide(HasResourceTech(ownerPlayerID,3));
    Controls.SRP_SellNiterCheck:SetDisabled(CanSellResource(ownerPlayerID,3,50, false));
    Controls.SRP_SellNiterCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,3); end );

    Controls.SRP_SellAluminumCheck:SetHide(HasResourceTech(ownerPlayerID,4));
    Controls.SRP_SellAluminumCheck:SetDisabled(CanSellResource(ownerPlayerID,4,50, false));
    Controls.SRP_SellAluminumCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,4); end );

    Controls.SRP_SellCoalCheck:SetHide(HasResourceTech(ownerPlayerID,5));
    Controls.SRP_SellCoalCheck:SetDisabled(CanSellResource(ownerPlayerID,5,50, false));
    Controls.SRP_SellCoalCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,5); end );

    Controls.SRP_SellOilCheck:SetHide(HasResourceTech(ownerPlayerID,6));
    Controls.SRP_SellOilCheck:SetDisabled(CanSellResource(ownerPlayerID,6,50, false));
    Controls.SRP_SellOilCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,6); end );

    Controls.SRP_SellUraniumCheck:SetHide(HasResourceTech(ownerPlayerID,7));
    Controls.SRP_SellUraniumCheck:SetDisabled(CanSellResource(ownerPlayerID,7,50, false));
    Controls.SRP_SellUraniumCheck:RegisterCallback( Mouse.eLClick, function() OnSellResources(ownerPlayerID,cityID,7); end );
end

function OnEnterGame()

    Controls.SRP_SellHorseCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellIronCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellNiterCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellAluminumCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellCoalCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellOilCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));
    Controls.SRP_SellUraniumCheck:ChangeParent(ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel"));

end

-- ================================卖资源===========================================
function OnSellResources(playerID,cityID,mResource)
    print("Click Sell Resources");
    if playerID == Game.GetLocalPlayer() then
        local pPlayer = Players[playerID];
        local iResource = m_iResources[mResource];
        ExposedMembers.SRP.SellResources(playerID,cityID,iResource,-50,m_nProductionAdd[mResource]);
        RecheckResouces(playerID,mResource);
        UI.PlaySound("Click_Confirm");
    end
end

function RecheckResouces(playerID,iResource)
    if (iResource == 1) then
        Controls.SRP_SellHorseCheck:SetDisabled(CanSellResource(playerID,1,50,true));
    elseif (iResource == 2) then
        Controls.SRP_SellIronCheck:SetDisabled(CanSellResource(playerID,2,50,true));
    elseif (iResource == 3) then
        Controls.SRP_SellNiterCheck:SetDisabled(CanSellResource(playerID,3,50,true));
    elseif (iResource == 4) then
        Controls.SRP_SellAluminumCheck:SetDisabled(CanSellResource(playerID,4,50,true));
    elseif (iResource == 5) then
        Controls.SRP_SellCoalCheck:SetDisabled(CanSellResource(playerID,5,50,true));
    elseif (iResource == 6) then
        Controls.SRP_SellOilCheck:SetDisabled(CanSellResource(playerID,6,50,true));
    elseif (iResource == 7) then
        Controls.SRP_SellUraniumCheck:SetDisabled(CanSellResource(playerID,7,50,true));
    end 
end
-- ===========================================================================

Events.LocalPlayerTurnBegin.Add(OnEnterGame);
Events.CitySelectionChanged.Add(	OnEnterCityPanel );