ExposedMembers.SRP = {};
function SellResouces(iPlayer,iCity, iResource, nResource, nProduction)
    local pCity = CityManager.GetCity(iPlayer, iCity );
    pCity:GetBuildQueue():AddProgress(nProduction);
    Players[iPlayer]:GetResources():ChangeResourceAmount(iResource, nResource);
end

ExposedMembers.SRP.SellResources = SellResouces;