-- Non Stop Project mod for Civilization 6 : Rise & Fall
-- Made by Kenska
-- https://steamcommunity.com/id/memboli/

local projects = {};

function StartProject(pCity, projectID)
    local tParameters = {};
    tParameters[CityOperationTypes.PARAM_PROJECT_TYPE] = projects[projectID];
    tParameters[CityOperationTypes.PARAM_INSERT_MODE] = CityOperationTypes.VALUE_EXCLUSIVE;
    CityManager.RequestOperation(pCity, CityOperationTypes.BUILD, tParameters);
end

function OnCityProjectCompleted(playerID, cityID, objectID, d, e, f, bCanceled)
    if (playerID ~= Game.GetLocalPlayer()) then
        return;
    end

    if (not bCanceled and projects[objectID]) then
        local pCity = CityManager.GetCity(playerID, cityID);
        StartProject(pCity, objectID);
    end
end

function OnLoadGameViewStateDone()
    print("Loading");
    for project in GameInfo.Projects() do
        if (project.Index >= 7) then
            print("Loading project Index " .. tostring(project.Index) .. " " .. tostring(project.ProjectType));
            table.insert(projects, project.Index, project.Hash);
        end
    end
end

function Initialize()
    Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
    Events.CityProjectCompleted.Add(OnCityProjectCompleted);
end
Initialize();