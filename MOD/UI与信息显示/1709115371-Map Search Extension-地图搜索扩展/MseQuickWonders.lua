-- MseQuickWonders
-- Author: Zur13
-- DateCreated: 7/29/2019 6:30:38 PM
--------------------------------------------------------------

local m_wonStackIM:table = InstanceManager:new( "MseWonderListEntry", "MSEWonderButton", Controls.MseStackWonders );
local ICON_PREFIX				:string = "ICON_";

--************************************************************
function AddWonToList( wonInfo:table )

	-- Create entry
	local wonderEntry:table = m_wonStackIM:GetInstance();

	local uBtn = wonderEntry.MSEWonderButton;
	local uIcn = wonderEntry.MSEWonderIcon;

	local uniqueName = Locale.Lookup( wonInfo.Name );

	uBtn:SetText( uniqueName );

	uBtn:RegisterCallback(Mouse.eLClick, function()
		AppendSuggestionText( uBtn:GetText() );
	end); 
		
	uIcn:SetIcon( ICON_PREFIX .. wonInfo.BuildingType );

	--if wonInfo.RemoveOnEntry == true then 
		--uBtn:GetTextControl():SetColorByName("OperationChance_Red");
		--uIcn:SetColorByName("OperationChance_Red");
	--elseif wonInfo.TraitType ~= nil then
		--uBtn:GetTextControl():SetColorByName("OperationChance_YellowGreen");
		--uIcn:SetColorByName("OperationChance_YellowGreen");
	--end

end

--************************************************************
function PopulateQuickWondersPanel()
	-- m_wonStackIM:ResetInstances(); -- clear and reuse instances created before (some properties like icon colors and hidden flags remain)
	m_wonStackIM:DestroyInstances(); -- destroy old instances and build the new one
	
	local wonders:table = {};

	for wonInfo in GameInfo.Buildings() do

		if wonInfo.IsWonder == true then 
			table.insert( wonders, wonInfo );
		end
	end
	
	--if GameInfo.Buildings_XP2 ~= nil then
		--for wonInfo in GameInfo.Buildings_XP2() do
			--if wonInfo.CanalWonder == true then 
				--table.insert( wonders, wonInfo );
			--end
		--end
	--end

	-- Alphabetize groups
	local sortFunc = function( a, b ) 
		local aType:string = Locale.Lookup( a.Name );
		local bType:string = Locale.Lookup( b.Name );
		return aType < bType;
	end

	table.sort( wonders, sortFunc );

	for _, wonInfo in ipairs( wonders ) do	AddWonToList( wonInfo );	end
end

--************************************************************
function InitQuickWondersPanel()
	Controls.MseWonButton1:RegisterCallback( Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseWonButton1:GetText() );
	end); 
	Controls.MseWonButton2:RegisterCallback( Mouse.eLClick, function()
		AppendSuggestionText( Controls.MseWonButton2:GetText() );
	end); 

	PopulateQuickWondersPanel();
end