-- MseQuickPanelsGeneral
-- Author: Zur13
-- DateCreated: 4/11/2019 6:11:00 PM
--------------------------------------------------------------

--************************************************************
function MseHideAllSelectorPanels()
	Controls.MSESearchOptions:SetHide( true );
	Controls.ExtendedMapSearchPanelSuggestionsRes:SetHide( true );
	Controls.ExtendedMapSearchPanelSuggestionsCivil:SetHide( true );
	Controls.ExtendedMapSearchPanelSuggestionsUnits:SetHide( true );
	Controls.ExtendedMapSearchPanelSuggestionsImpr:SetHide( true );
	Controls.ExtendedMapSearchPanelSuggestionsWon:SetHide( true );
	
	Controls.MSEBtnSelRes:SetSelected( false );
	Controls.MSEBtnSelCivil:SetSelected( false );
	Controls.MSEBtnSelUnits:SetSelected( false );
	Controls.MSEBtnSelImpr:SetSelected( false );
	Controls.MSEBtnSelWond:SetSelected( false );
end

--************************************************************
local function OnBtnShowSelectorResources()
	local isHidden = Controls.ExtendedMapSearchPanelSuggestionsRes:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.ExtendedMapSearchPanelSuggestionsRes:SetHide( false );
	
		Controls.MSEBtnSelRes:SetSelected( true );
	end
end

--************************************************************
local function OnBtnShowSelectorCivilizations()
	local isHidden = Controls.ExtendedMapSearchPanelSuggestionsCivil:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.ExtendedMapSearchPanelSuggestionsCivil:SetHide( false );
	
		Controls.MSEBtnSelCivil:SetSelected( true );

		PopulateQuickCivilizationsPanel();
	end
end

--************************************************************
local function OnBtnShowSelectorUnits()
	local isHidden = Controls.ExtendedMapSearchPanelSuggestionsUnits:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.ExtendedMapSearchPanelSuggestionsUnits:SetHide( false );
	
		Controls.MSEBtnSelUnits:SetSelected( true );
	end
end

--************************************************************
local function OnBtnShowSelectorImpr()
	local isHidden = Controls.ExtendedMapSearchPanelSuggestionsImpr:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.ExtendedMapSearchPanelSuggestionsImpr:SetHide( false );
	
		Controls.MSEBtnSelImpr:SetSelected( true );
	end
end

--************************************************************
local function OnBtnShowSelectorWond()
	local isHidden = Controls.ExtendedMapSearchPanelSuggestionsWon:IsHidden();
	MseHideAllSelectorPanels();
	if isHidden then
		Controls.ExtendedMapSearchPanelSuggestionsWon:SetHide( false );
	
		Controls.MSEBtnSelWond:SetSelected( true );

		--PopulateQuickWondersPanel();
	end
end

--************************************************************
function MseInitializeQuickPanels()
	termDestinationEditBox = Controls.MapSearchBox;

	MseHideAllSelectorPanels();
	
	Controls.MSEBtnSelRes:RegisterCallback( Mouse.eLClick, OnBtnShowSelectorResources );
	Controls.MSEBtnSelCivil:RegisterCallback( Mouse.eLClick, OnBtnShowSelectorCivilizations );
	Controls.MSEBtnSelUnits:RegisterCallback( Mouse.eLClick, OnBtnShowSelectorUnits );
	Controls.MSEBtnSelImpr:RegisterCallback( Mouse.eLClick, OnBtnShowSelectorImpr );
	Controls.MSEBtnSelWond:RegisterCallback( Mouse.eLClick, OnBtnShowSelectorWond );

	InitQuickResourcePanel();

	InitQuickUnitsPanel();
	InitQuickImprovPanel();
	InitQuickWondersPanel();
end