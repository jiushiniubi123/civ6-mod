--=================================================================================================================
-- Suk_ScreenshotMode
--=================================================================================================================
local m_RegionOverlay		= UILens.GetOverlay("Suk_RegionBorderOverlay");
local m_MaterialHash		= UILens.CreateLensLayerHash("Suk_RegionBorders")
m_RegionOverlay:InitializeStyles(1, m_MaterialHash);

local COLOR_GREEN_HIGHLIGHT = UI.GetColorValueFromHexLiteral(0x6400FF00);

function ToggleRegionLens()
	local nLayerHash = UILens.CreateLensLayerHash("Suk_RegionBorderOverlay");
	if Controls.SukRegionLensButton:IsChecked() then
		UILens.ToggleLayerOn(nLayerHash)
		UILens.SetActive("Suk_Region");

		m_RegionOverlay:ClearPlotChannel();
	    m_RegionOverlay:SetVisible(true);
		m_RegionOverlay:ShowHighlights(true);
		m_RegionOverlay:ShowBorders(true);

		DoRegionLens()
	else
		m_RegionOverlay:SetVisible(false);
		UILens.ToggleLayerOff(nLayerHash)
		UILens.SetActive("Default");
	end
end

function DoRegionLens()
	local tClusters = Game:GetProperty("Suk_UrbanIdentities_Regions")
	local iClusters = #tClusters

	for iCluster, tCluster in pairs(tClusters) do

		local iChannelIndex = iCluster-1

		local iVal = (iCluster-1)/(iClusters-1)
		local iRed = 1-iVal
		local iBlue = iVal
		local iColorA = UI.GetColorValue(iBlue, 0.0, iRed, 1)
		local iColorB = UI.GetColorValue(iBlue*0.4, 0.0, iRed*0.4, 1)
		local iColorC = UI.GetColorValue(0,0,0,0)
		m_RegionOverlay:SetBorderColors(iChannelIndex, iColorA, iColorB)
		m_RegionOverlay:SetHighlightColor(iChannelIndex, iColorC)
		m_RegionOverlay:SetPlotChannel(tCluster.Nodes, iChannelIndex);
	end
end
--===========================================================================================
--	Initialize/Shutdown
--===========================================================================================
--	OnInit
------------------------------------------------------------------------------
function OnInit( bIsReload)
	Events.LoadScreenClose.Add(OnInit)
	if not ContextPtr:LookUpControl("/InGame/MinimapPanel/LensToggleStack") then return end
	----------------------------
	-- Hookup Buttons
	----------------------------
	Controls.SukRegionLensButton:RegisterCallback(Mouse.eLClick, ToggleRegionLens);
	----------------------------
	-- Re-Parent
	----------------------------
	local pLensToggleStack	= ContextPtr:LookUpControl("/InGame/MinimapPanel/LensToggleStack")

	Controls.SukRegionLensButton:ChangeParent(pLensToggleStack)
	pLensToggleStack:CalculateSize()
	pLensToggleStack:ReprocessAnchoring()
end
------------------------------------------------------------------------------
--	OnShutdown
------------------------------------------------------------------------------
function OnShutdown()
	Controls.SukRegionLensButton:ChangeParent(ContextPtr)
	Events.LoadScreenClose.Remove(OnInit)
end
------------------------------------------------------------------------------
--	Initialize
------------------------------------------------------------------------------
function Initialize()
	ContextPtr:SetInitHandler(OnInit)
	ContextPtr:SetShutdown(OnShutdown)
	ContextPtr:SetInputHandler(OnInputHandler, true)
	ContextPtr:SetHide(false)
end
Initialize()
--=================================================================================================================
--=================================================================================================================