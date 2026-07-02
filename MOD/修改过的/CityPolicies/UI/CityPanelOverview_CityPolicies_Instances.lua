include("Civ6Common")
include("InstanceManager")
include("ToolTipHelper")

local m_kCityPolicyIM = nil
local bLoadScreenHookup = false

-- 当 CityPanelOverview 需要刷新城市政策显示时，其他 Mod 可触发此事件
function On_CityPanelOverview_CityPolicies(data)
    local playerID = Game.GetLocalPlayer()
    local hasCityPolicies = false
    m_kCityPolicyIM:ResetInstances()

    for _, district in ipairs(data.BuildingsAndDistricts) do
        if district.isBuilt and district.Type == "DISTRICT_CITY_CENTER" then
            for _, building in ipairs(district.Buildings) do
                if building.isBuilt then
                    local buildingType = building.Type
                    if buildingType == "BUILDING_CITY_POLICY_EMPTY" then
                        -- 空政策表示没有激活的政策，不显示任何条目
                        hasCityPolicies = false
                    elseif buildingType:match("^BUILDING_CITY_POLICY_") then
                        hasCityPolicies = true
                        local cityPolicyInstance = m_kCityPolicyIM:GetInstance()
                        cityPolicyInstance.CityPolicyName:SetText(building.Name)
                        cityPolicyInstance.Icon:SetIcon(building.Icon)
                        local pRow = GameInfo.Buildings[buildingType]
                        local sToolTip = ToolTipHelper.GetBuildingToolTip(pRow.Hash, playerID, m_pCity)
                        cityPolicyInstance.Top:SetToolTipString(sToolTip)
                    end
                end
            end
            -- 只处理第一个匹配的市中心区域
            break
        end
    end

    Controls.NoCityPolicyArea:SetHide(hasCityPolicies)
    Controls.CityPolicyArea:SetHide(not hasCityPolicies)
    Controls.CityPolicyStack:CalculateSize()
end

function OnInit(isReload)
    if not ContextPtr:LookUpControl("/InGame/CityPanelOverview/BreakdownStack") then
        Events.LoadScreenClose.Add(OnInit)
        bLoadScreenHookup = true
        return
    end

    -- 将我们的容器挂载到 CityPanelOverview 的 BreakdownStack 中
    local pBreakdownStack = ContextPtr:LookUpControl("/InGame/CityPanelOverview/BreakdownStack")
    Controls.CityPolicyContainer:ChangeParent(pBreakdownStack)

    m_kCityPolicyIM = InstanceManager:new("CityPolicyInstance", "Top", Controls.CityPolicyStack)

    LuaEvents.CityPanelOverview_CityPolicies.Add(On_CityPanelOverview_CityPolicies)
end

function OnShutdown()
    if bLoadScreenHookup then
        Events.LoadScreenClose.Remove(OnInit)
    end
    LuaEvents.CityPanelOverview_CityPolicies.Remove(On_CityPanelOverview_CityPolicies)
    if m_kCityPolicyIM then
        m_kCityPolicyIM:DestroyInstances()
    end
    local pBreakdownStack = ContextPtr:LookUpControl("/InGame/CityPanelOverview/BreakdownStack")
    if pBreakdownStack then
        pBreakdownStack:DestroyChild(Controls.CityPolicyContainer)
    end
end

function Initialize()
    ContextPtr:SetInitHandler(OnInit)
    ContextPtr:SetHide(false)
    ContextPtr:SetShutdown(OnShutdown)
end
Initialize()