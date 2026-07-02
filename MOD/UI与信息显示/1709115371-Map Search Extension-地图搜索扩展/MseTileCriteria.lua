-- MseTileCriteria
-- Author: Zur13
-- DateCreated: 4/9/2019 6:57:09 PM
--------------------------------------------------------------


--******************************************************************************
-- Zur13: Scan surrounding area around the plot for cities not further then 3 tiles away and owned by cityOwner
function CheckNearPlayerCityCriteria( plotId:number, cityOwner )
	local plot = Map.GetPlotByIndex( plotId );
	if plot == nil or ( plot:GetOwner() ~= -1 and plot:GetOwner() ~= cityOwner ) then
		return false;
	end
	if Controls.MseCBPurchasedByMe:IsChecked() then
		local selPlotX = plot:GetX();
		local selPlotY = plot:GetY();
		local cityRadius = 4;
		local cRadius = cityRadius + cityRadius - 2; -- radius with cities which may own tile

		for x = selPlotX - cRadius, selPlotX + cRadius, 1 do
		for y = selPlotY - cRadius, selPlotY + cRadius, 1 do
			local iPlot:table = Map.GetPlot(x, y);
		
			if iPlot ~= nil and iPlot:IsCity() and iPlot:GetOwner() == cityOwner then
				local iX:number = iPlot:GetX();
				local iY:number = iPlot:GetY();

				if Map.GetPlotDistance(iX, iY, selPlotX, selPlotY) < cityRadius then
					return true;
				end
			end -- if iPlot ~= nil
		end -- for x
		end -- for y
	end
	return false;
end

--************************************************************
-- Zur13: Check if tile is owned by local player and return true/false according to GUI checkbox
function CheckOwnedByMeCriteria( plotId:number )
	-- local pPlayer = Players[Game.GetLocalPlayer()];
	
	local iPlayerID = Game.GetLocalObserver();
	if (iPlayerID < 0) then
		return true;
	end

	local plot = Map.GetPlotByIndex( plotId );
	if (plot == nil) then
		return false;
	end

	local plotOwner = plot:GetOwner();

	if Controls.MseCBOwnerMe:IsChecked() then
		-- should check plots owned by me
		if plotOwner == iPlayerID then
			-- owned by local player
			return true;
		end
	--else
		---- should ignore plots owned by me
		--if plotOwner ~= iPlayerID then
			---- not owned by local player
			--return true;
		--end
	end
	return false; -- default
end

--************************************************************
-- Zur13: Check if tile is owned by not local player and return true/false according to GUI checkbox
function CheckOwnedByOthersCriteria( plotId:number )
	-- local pPlayer = Players[Game.GetLocalPlayer()];
	
	local iPlayerID = Game.GetLocalObserver();
	if (iPlayerID < 0) then
		return true;
	end

	local plot = Map.GetPlotByIndex( plotId );
	if (plot == nil) then
		return false;
	end

	local plotOwner = plot:GetOwner();

	if Controls.MseCBOwnerOthers:IsChecked() then
		-- should check plots owned by other players
		if plotOwner ~= iPlayerID and plotOwner > -1 then
			-- owned by other player
			return true;
		end
	--else
		---- should ignore plots owned by others
		--if plotOwner == iPlayerID or plotOwner < 0 then
			---- not owned by other player
			--return true;
		--end
	end
	return false; -- default
end

--************************************************************
-- Zur13: Check if tile is not owned and return true/false according to GUI checkbox
function CheckOwnedByNoneCriteria( plotId:number )
	local plot = Map.GetPlotByIndex( plotId );
	if (plot == nil) then
		return false;
	end

	local plotOwner = plot:GetOwner();

	if Controls.MseCBOwnerNone:IsChecked() then
		-- should check not owned plots
		if plotOwner < 0 then
			-- not owned
			return true;
		end
	end
	return false; -- default
end

--************************************************************
-- Zur13: Check if tile could be searched according to GUI checkboxes
function IsTileMatchesCriteria( iPlot )
	local eObserverID = Game.GetLocalObserver();
	return CheckOwnedByMeCriteria( iPlot ) or CheckOwnedByOthersCriteria( iPlot ) or CheckOwnedByNoneCriteria( iPlot ) or CheckNearPlayerCityCriteria( iPlot, eObserverID );
end
