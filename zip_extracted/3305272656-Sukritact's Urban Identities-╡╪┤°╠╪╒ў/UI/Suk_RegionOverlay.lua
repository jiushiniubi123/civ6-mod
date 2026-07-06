--===========================================================================================
--	REGION OVERLAY
--	Toggle the Region Lens with UILens.SetActive("Suk_Region")
--===========================================================================================
	include("InstanceManager");
--===========================================================================================
--	Globals
--===========================================================================================
	local m_WorldViewPath		= "/InGame/WorldViewControls"
	local m_MinimapPath			= "/InGame/HUD/MinimapPanel/MapOptionsStack"
	local m_MinimapPanelPath	= "/InGame/HUD/MinimapPanel/MapOptionsPanel"

	local m_RegionID			= "Suk_UrbIdentities_RegionID"
	local m_RegionType			= "Suk_UrbIdentities_RegionType"
	local m_IdentityType		= "Suk_UrbIdentities_IdentityType"
	local m_MapHexMask			= UILens.CreateLensLayerHash("Map_Hex_Mask");
	local m_MapHexMask_Layer	= UILens.CreateLensLayerHash("Suk_Region_Lens_HexMask")

	local MAP_OPTIONS_PADDING	= 80;
	local m_NonRegionPlots		= {}

	ExposedMembers.MapOption_ShowRegions = true
	ExposedMembers.Suk_ScreenshotMode_HideRegions = true
--===========================================================================================
--	UTILS
--===========================================================================================
	--	rPrint
	--	For Debugging
	--------------------------------------
		function rPrint(s, l, i) -- recursive Print (structure, limit, indent)
			l = (l) or 100; i = i or "";	-- default item limit, indent string
			if (l<1) then print "ERROR: Item limit reached."; return l-1 end;
			local ts = type(s);
			if (ts ~= "table") then print (i,ts,s); return l-1 end
			print (i,ts);           -- print "table"
			for k,v in pairs(s) do  -- print "[KEY] VALUE"
				l = rPrint(v, l, i.."\t["..tostring(k).."]");
				if (l < 0) then break end
			end
			return l
		end
--===========================================================================================
--	CLASS: REGION BANNER
--===========================================================================================
	Suk_RegionBanner = {
		m_InstanceManager	= InstanceManager:new("RegionBanner",	"Anchor", Controls.RegionBanners),
		m_Instances			= {},

		m_RegionOverlay		= UILens.GetOverlay("Suk_RegionBorderOverlay"),
		m_RegionHighlight	= UILens.GetOverlay("Suk_RegionBorderHighlight"),
	}

	local eSuk_RegionLens = UILens.CreateLensLayerHash("Suk_Region_Lens")

	Suk_RegionBanner.m_RegionOverlay:InitializeStyles(1, UILens.CreateLensLayerHash("Suk_RegionBorders"))
	Suk_RegionBanner.m_RegionHighlight:InitializeStyles(1, UILens.CreateLensLayerHash("Suk_RegionBorders"))
	------------------------------------------------------------------------------
	--	New
	------------------------------------------------------------------------------
		function Suk_RegionBanner:new(tCluster, iIndex)
			-------------------------------
			-- Create the Banner Object
			-------------------------------
				local pBanner = {}
				pBanner.m_Instance = self.m_InstanceManager:GetInstance()
				setmetatable(pBanner, {__index = Suk_RegionBanner})
			-------------------------------
			-- Assign Cluster
			-------------------------------
				pBanner.m_Cluster	= tCluster
			-------------------------------
			-- Set Instance ID
			-------------------------------
				pBanner.m_Instance.RegionBannerButton:SetVoid1(iIndex)
				Suk_RegionBanner.m_Instances[iIndex] = pBanner
				Suk_RegionBanner.m_Index = iIndex
			-------------------------------
			-- Update Location
			-- Update Color
			-- Refresh Everything Else
			-------------------------------
				pBanner:UpdateLocation()

				local iColorA, iColorB = pBanner:GetColor()
				pBanner.m_Instance.RegionIcon_Base:SetColor(iColorA)
				pBanner:UpdateOverlay()
				pBanner:RefreshBanner()
			-------------------------------
			-- Reset Animation
			-- Init On Hover Actions
			-------------------------------
				pBanner.m_Instance.AlphaAnim:SetToBeginning()
				pBanner.m_Instance.RegionBannerButton:RegisterCallback( Mouse.eMouseEnter,
					function(iIndex)
						local pBanner = Suk_RegionBanner.m_Instances[iIndex]

						-- Toggle Opacity
						pBanner.m_Instance.AlphaAnim:SetToBeginning()
						pBanner.m_Instance.AlphaAnim:Play()

						-- Toggle Region Overlay
						pBanner.m_RegionHighlight:SetPlotChannel(pBanner.m_Cluster.Nodes, iIndex)
					end
				)
				pBanner.m_Instance.RegionBannerButton:RegisterCallback( Mouse.eMouseExit,
					function(iIndex)
						local pBanner = Suk_RegionBanner.m_Instances[iIndex]

						-- Toggle Opacity
						pBanner.m_Instance.AlphaAnim:Stop()
						pBanner.m_Instance.AlphaAnim:Reverse()

						-- Toggle Region Overlay
						pBanner.m_RegionHighlight:ClearPlotChannel(pBanner.m_Cluster.Nodes, iIndex)
					end
				)
			-------------------------------
			-- On Click
			-------------------------------
				pBanner.m_Instance.RegionBannerButton:RegisterCallback( Mouse.eLClick,
					function(iIndex)
						local pBanner = Suk_RegionBanner.m_Instances[iIndex]

						local iPlot = pBanner.m_Cluster.CenterPlot
						local iX, iY = Map.GetPlotLocation(iPlot)

						UI.LookAtPlotScreenPosition( iX, iY, 0.5, 0.5 )
					end
				)
			-------------------------------
			-------------------------------
			return pBanner
		end
	------------------------------------------------------------------------------
	--	Update Overlay
	------------------------------------------------------------------------------
		function Suk_RegionBanner:RefreshBanner()
			self:UpdateVisibility()
			self:UpdateText()
			self:UpdateFrame()
		end
	------------------------------------------------------------------------------
	--	Update Overlay
	------------------------------------------------------------------------------
		function Suk_RegionBanner:UpdateOverlay()
			--self.m_RegionOverlay:ShowHighlights(false)
			self.m_RegionOverlay:ShowBorders(true)
			self.m_RegionOverlay:SetVisible(true)
			self.m_RegionHighlight:ShowHighlights(true)
			self.m_RegionHighlight:ShowBorders(true)
			self.m_RegionHighlight:SetVisible(true)

			local iColorA, iColorB = self:GetColor()
			local iIndex = self.m_Index

			self.m_RegionOverlay:SetBorderColors(iIndex, iColorA, iColorA)
			--self.m_RegionOverlay:SetHighlightColor(iIndex, iColorB)
			self.m_RegionOverlay:SetPlotChannel(self.m_Cluster.Nodes, iIndex)
			self.m_RegionHighlight:SetBorderColors(iIndex, iColorA, iColorA)
			self.m_RegionHighlight:SetHighlightColor(iIndex, iColorB)
		end
	------------------------------------------------------------------------------
	--	Update Frame
	------------------------------------------------------------------------------
		function Suk_RegionBanner:UpdateFrame()
			local tCluster			=	self.m_Cluster
			local bClaimed			=	tCluster.Claimed

			self.m_Instance.RegionIcon_Frame:SetHide(not bClaimed)
		end
	------------------------------------------------------------------------------
	--	Update Text
	------------------------------------------------------------------------------
		function Suk_RegionBanner:UpdateText()
			local tCluster			=	self.m_Cluster
			local sIdentityType		=	tCluster.IdentityType
			local tIdentity			=	GameInfo.Suk_UrbanIdentities[sIdentityType]
			local sRegionType		=	tCluster.RegionType
			local tRegion			=	GameInfo.Suk_Regions[sRegionType]

			local sIdentityName		=	tIdentity.Name			or "LOC_"..sIdentityType.."_NAME"
			local sIdentityDesc		=	tIdentity.Description	or "LOC_"..sIdentityType.."_DESCRIPTION"
			local sIdentityFlavor	=	tIdentity.Flavor		or "LOC_"..sIdentityType.."_FLAVOR"

			local sRegionName		=	tRegion.Name	or "LOC_"..sRegionType.."_NAME"

			local iClaimedPlot		=	tCluster.Claimed
			local sClaimed			=	iClaimedPlot
										and "LOC_SUK_REGIONS_CLAIMED"
										or "LOC_SUK_REGIONS_UNCLAIMED"

			local sCity				=	""
			if iClaimedPlot then
				local iX, iY = Map.GetPlotLocation(iClaimedPlot)
				local pCity = Cities.GetCityInPlot(iX, iY)

				--print(iX, iY, pCity)

				if pCity then
					sCity = pCity:GetName()
				end
			end

			local sTooltip = (
				Locale.ToUpper(Locale.Lookup(sIdentityName))
				.. " [ICON_SUK_IDENTITY][NEWLINE]"
				.. Locale.Lookup(sClaimed, Locale.Lookup(sRegionName), Locale.Lookup(sCity))
				.. "[NEWLINE][NEWLINE]"
				.. Locale.Lookup(sIdentityDesc)
				.. "[NEWLINE]----------[NEWLINE]"
				.. Locale.Lookup(sIdentityFlavor)
			)

			self.m_Instance.Label:LocalizeAndSetText(sIdentityName)
			self.m_Instance.RegionBannerButton:SetToolTipString(sTooltip)
		end
	------------------------------------------------------------------------------
	--	Update Location
	------------------------------------------------------------------------------
		function Suk_RegionBanner:UpdateLocation()
			local pInstance = self.m_Instance
			local tCluster = self.m_Cluster

			-- Set Position
			local iPlot = tCluster.CenterPlot
			local iX, iY = Map.GetPlotLocation(iPlot)
			local iWorldX, iWorldY = UI.GridToWorld(iX, iY);
			pInstance.Anchor:SetWorldPositionVal(iWorldX, iWorldY-32.0, 0);
		end
	------------------------------------------------------------------------------
	--	Update Visibility
	------------------------------------------------------------------------------
		function Suk_RegionBanner:UpdateVisibility(bIsVisible)
			--print("UpdateVisibility", bIsVisible)

			local bIsVisible = bIsVisible
			if (bIsVisible == nil) then

				local eObserverID = Game.GetLocalObserver()
				local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility(eObserverID)
				bIsVisible = false

				for _, iPlot in pairs(self.m_Cluster.Nodes) do
					local iVisible = pLocalPlayerVis:GetState(iPlot)
					if (iVisible ~= RevealedState.HIDDEN) then
						bIsVisible = true
						break
					end
				end
			end

			--print(self.m_Index, bIsVisible)

			self.m_Instance.Anchor:SetHide(not bIsVisible)
		end
	------------------------------------------------------------------------------
	--	Get Color
	------------------------------------------------------------------------------
		function Suk_RegionBanner:GetColor()
			-- Return the Assigned Color if one already exists
			if self.m_ColorA then
				return self.m_ColorA, self.m_ColorB
			end

			local tColor = self.m_Cluster.Color

			self.m_ColorA = UI.GetColorValue(tColor[1], tColor[2], tColor[3], 1.0)
			self.m_ColorB = UI.GetColorValue(tColor[1], tColor[2], tColor[3], 0.05)

			return self.m_ColorA, self.m_ColorB
		end
--===========================================================================================
--	MEMBERS
--===========================================================================================
	g_PlotCache = {}

	function InitBanners()
		local tClusters = ExposedMembers.Suk_UrbanIdentities_Regions
		local iClusters = #tClusters

		for iCluster, tCluster in pairs(tClusters) do
			Suk_RegionBanner:new(tCluster, iCluster)
			for _, iPlot in pairs(tCluster.Nodes) do
				g_PlotCache[iPlot] = iCluster
			end
		end
	end
--===========================================================================================
--	SetOverlayVisibility
--===========================================================================================
	function SetOverlayVisibility(bVisible)
		if bVisible then
			for _, pBanner in pairs(Suk_RegionBanner.m_Instances) do
				pBanner:UpdateVisibility()
			end
			Suk_RegionBanner.m_RegionOverlay:SetVisible(true)
			Suk_RegionBanner.m_RegionHighlight:SetVisible(true)
		else
			for _, pBanner in pairs(Suk_RegionBanner.m_Instances) do
				pBanner:UpdateVisibility(false)
			end
			Suk_RegionBanner.m_RegionOverlay:SetVisible(false)
			Suk_RegionBanner.m_RegionHighlight:SetVisible(false)
		end
	end
--===========================================================================================
--	On Events
--===========================================================================================
	--	OnCityChanged
	------------------------------------------------------------------------------
		function OnCityChanged(iPlayer, iCity)

			local pCity = CityManager.GetCity(iPlayer, iCity)
			if not pCity then return end

			local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY())
			if not pPlot then return end

			local iRegion = g_PlotCache[pPlot:GetIndex()]
			if not iRegion then return end

			local pBanner = Suk_RegionBanner.m_Instances[iRegion]
			pBanner:RefreshBanner()
		end
	------------------------------------------------------------------------------
	--	OnPlotVisibilityChanged
	------------------------------------------------------------------------------
		g_RevealStateCache = {}

		function OnPlotVisibilityChanged(iX, iY, iVisible)
			local iPlot = Map.GetPlotIndex(iX, iY)
			local iCluster = g_PlotCache[iPlot]
			if not iCluster then return end

			local pBanner = Suk_RegionBanner.m_Instances[iCluster]

			if (iVisible ~= RevealedState.HIDDEN) then
				if pBanner.m_Instance.Anchor:IsHidden() then
					pBanner:UpdateVisibility()
				end
			end
		end
	------------------------------------------------------------------------------
	--	OnRegionAbandoned
	------------------------------------------------------------------------------
		function OnRegionAbandoned(tData)
			local pBanner = Suk_RegionBanner.m_Instances[tData.RegionID]
			pBanner:RefreshBanner()
		end
	------------------------------------------------------------------------------
	--	OnSuk_ScreenshotMode
	------------------------------------------------------------------------------
		function OnSuk_ScreenshotMode(bScreenshotMode)
			local bShowRegion		= ExposedMembers.MapOption_ShowRegions
			if not bShowRegion then return end

			local bHiddenBorders	= ExposedMembers.Suk_ScreenshotMode_Options.HideBorders
			local bHideBanners		= true

			if tCheckbox then
				bHideBanners = ExposedMembers.Suk_ScreenshotMode_HideRegions
			end

			if bScreenshotMode then
				Suk_RegionBanner.m_RegionOverlay:SetVisible(not bHiddenBorders)
				Suk_RegionBanner.m_RegionHighlight:SetVisible(not bHiddenBorders)
				Controls.RegionBanners:SetHide(bHideBanners)
			else
				Suk_RegionBanner.m_RegionOverlay:SetVisible(true)
				Suk_RegionBanner.m_RegionHighlight:SetVisible(true)
				Controls.RegionBanners:SetHide(false)
			end
		end
--===========================================================================================
--	Lens ON/OFF
--===========================================================================================
	--	OnLensLayerOn
	------------------------------------------------------------------------------
		function OnLensLayerOn( layerHash:number )
			if layerHash == eSuk_RegionLens then
				SetOverlayVisibility(true)
			elseif layerHash == m_MapHexMask_Layer then

				m_NonRegionPlots = {}
				local eObserverID = Game.GetLocalObserver()
				local pLocalPlayerVis = PlayerVisibilityManager.GetPlayerVisibility(eObserverID)

				for iPlot, _ in pairs(g_PlotCache) do
					local iVisible = pLocalPlayerVis:GetState(iPlot)
					if (iVisible ~= RevealedState.HIDDEN) then
						table.insert(m_NonRegionPlots, #m_NonRegionPlots+1, iPlot)
					end
				end

				UILens.ClearLayerHexes( m_MapHexMask );
				UILens.SetLayerHexesArea( m_MapHexMask, Game.GetLocalPlayer(), m_NonRegionPlots);
			end
		end
	------------------------------------------------------------------------------
	--	OnLensLayerOff
	------------------------------------------------------------------------------
		function OnLensLayerOff( layerHash:number )
			if layerHash == eSuk_RegionLens then
				SetOverlayVisibility(false)
			elseif layerHash == m_MapHexMask_Layer then
				UILens.ClearLayerHexes( m_MapHexMask );
			end
		end
--===========================================================================================
--	Initialize/Shutdown
--===========================================================================================
	--	OnInit
	------------------------------------------------------------------------------
		function OnInit(bIsReload)

			local pParent		= ContextPtr:LookUpControl(m_WorldViewPath)
			local pMiniMapStack	= ContextPtr:LookUpControl(m_MinimapPath)
			local pMiniMapPanel	= ContextPtr:LookUpControl(m_MinimapPanelPath)

			if (not pParent) or (not pMiniMapStack) then
				Events.LoadScreenClose.Add(OnInit)
				return
			end

			ContextPtr:ChangeParent(pParent)
			------------------------
			Controls.ToggleButton:SetCheck(ExposedMembers.MapOption_ShowRegions)
			UILens.ToggleLayerOn(eSuk_RegionLens)
			------------------------
			Controls.ToggleButton:ChangeParent(pMiniMapStack)
			pMiniMapStack:SortChildren(
				function(pA, pB)
					local pTextButtonA = pA.GetTextButton and pA:GetTextButton()
					local pTextButtonB = pB.GetTextButton and pB:GetTextButton()

					if pTextButtonA and pTextButtonB then
						return pTextButtonA:GetText() > pTextButtonB:GetText()
					end

					return false
				end
			)
			pMiniMapStack:CalculateSize();
			pMiniMapPanel:SetSizeY(pMiniMapStack:GetSizeY() + MAP_OPTIONS_PADDING);
			------------------------
			Controls.ToggleButton:RegisterCallback(Mouse.eLClick,
				function()
					ExposedMembers.MapOption_ShowRegions = not ExposedMembers.MapOption_ShowRegions
					Controls.ToggleButton:SetCheck(ExposedMembers.MapOption_ShowRegions)
					if ExposedMembers.MapOption_ShowRegions then
						UILens.ToggleLayerOn(eSuk_RegionLens)
					else
						UILens.ToggleLayerOff(eSuk_RegionLens)
					end
				end
			)

			pParent:SortChildren(
				function(pA, pB)
					if pA:GetID() == ContextPtr:GetID() then
						return true
					elseif pB:GetID() == ContextPtr:GetID() then
						return false
					else
						return false
					end
				end
			)

			InitBanners()
			------------------------------------------------------------------------------
			--	Register Entry for Sukritact's Screenshot Mode
			------------------------------------------------------------------------------
			if ExposedMembers.Suk_ScreenshotMode_RegisteredEntries then

				LuaEvents.Suk_ScreenshotMode_RegisterEntry("Suk_RegionOverlay")
				tCheckbox = ExposedMembers.Suk_ScreenshotMode_RegisteredEntries.Suk_RegionOverlay

				if tCheckbox then

					tCheckbox.Checkbox:GetTextButton():SetText(Locale.Lookup("LOC_SUK_SCREENSHOT_MODE_REGION_BANNER_NAME"))
					tCheckbox.Checkbox:SetToolTipString(Locale.Lookup("LOC_SUK_SCREENSHOT_MODE_REGION_BANNER_DESC"))
					tCheckbox.Checkbox:SetCheck(ExposedMembers.Suk_ScreenshotMode_HideRegions)
					tCheckbox.Checkbox:RegisterCallback(Mouse.eLClick,
						function()
							UI.PlaySound("Play_UI_Click");
							ExposedMembers.Suk_ScreenshotMode_HideRegions = not ExposedMembers.Suk_ScreenshotMode_HideRegions
							tCheckbox.Checkbox:SetCheck(ExposedMembers.Suk_ScreenshotMode_HideRegions)
						end
					)

				end
			end
			------------------------------------------------------------------------------
			------------------------------------------------------------------------------
		end
	------------------------------------------------------------------------------
	-- OnShutdown
	------------------------------------------------------------------------------
		function OnShutdown()
			Controls.ToggleButton:ChangeParent(ContextPtr)
			Events.LoadScreenClose.Remove(OnInit)
		end
	------------------------------------------------------------------------------
	-- Initialise
	------------------------------------------------------------------------------
		function Initialise()
			ContextPtr:SetInitHandler(OnInit)
			ContextPtr:SetShutdown(OnShutdown)
			ContextPtr:SetHide(false)

			Events.LensLayerOn.Add(OnLensLayerOn)
			Events.LensLayerOff.Add(OnLensLayerOff)

			Events.CityInitialized.Add(OnCityChanged)
			Events.CityNameChanged.Add(OnCityChanged)
			Events.PlotVisibilityChanged.Add(OnPlotVisibilityChanged)
			LuaEvents.Suk_RegionAbandoned.Add(OnRegionAbandoned)
			LuaEvents.Suk_ScreenshotMode.Add(OnSuk_ScreenshotMode)

			--LuaEvents.SukRegions_MapOptionToggle.Add(SetOverlayVisibility)
		end

		Initialise()
--===========================================================================================
--===========================================================================================