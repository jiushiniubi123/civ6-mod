-- Extra Islands and Lakes for Civ VI Got Lakes Map Script
-- Author: Scrum Lord
---------------------------------------------------------------------------------------------------
include "GotLakes_Options"
--include "GotLakes_PassMaker"
include "GotLakes_Utils"
---------------------------------------------------------------------------------------------------
-- Extra Islands / Lakes
--
-- The following algorithms generate islands by default, 
-- but can be inverted to generate lakes instead.
---------------------------------------------------------------------------------------------------
-- Chains
--
-- Originally copied from the Civ V base game's Island Maker,
-- hence the resemblance to the "plus" islands from Civ V's Continents Plus, Pangea Plus, etc.
---------------------------------------------------------------------------------------------------
function CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)	
	-- Create the simplest form of island chain. (fTilt should be in degrees.)
	-- Data returned will be a table of LOCAL plot indices, true for land, false for water.
	local iWH = iWidth * iHeight;
	-- If dimensions are too small to operate, 
	-- or the angle is not between 0 and 180 degrees, abort.
	if iWidth < 4 or iHeight < 4 or iWH < 24 or fTilt < 0 or fTilt > 180 then
		print("*** ERROR! ***"); print("Cell dimensions or Axis angle invalid!"); print("-");
		return nil
	end
	-- This function is going to execute, so set up a data table for the plots.
	local plot_data = table.fill(false, iWH);
	-- Define the center and the radii.
	local iCenterX, iCenterY = (iWidth - 1) / 2, (iHeight - 1) / 2;
	local fRadiusX, fRadiusY = iWidth / 2, iHeight / 2;
	-- Using triangular method of trigonometry. 
	-- If angle > 90 degrees, swap sides and convert the angle.
	local fTilt_in_degrees = fTilt;
	if fTilt > 90 then
		fTilt_in_degrees = 180 - fTilt;
	end
	-- Convert angle to radians. (Lua math table functions operate on radians).
	local fTilt_in_radians = math.rad(fTilt_in_degrees);
	-- Determine traits of the angle.
	local is_horizontal, is_vertical, is_steep, leans_left = false, false, false, false;
	if fTilt == 0 or fTilt == 180 then
		is_horizontal = true;
	elseif fTilt == 90 then
		is_vertical = true;
	else
		if fTilt > 45 and fTilt < 135 then
			is_steep = true;
		end
		if fTilt > 90 then
			leans_left = true;
		end
	end
	-- Obtain start and end plots for the axis.
	local start_x, start_y, end_x, end_y;
	if is_horizontal then
		start_x, start_y, end_x, end_y = 0, iCenterY, iWidth - 1, iCenterY;
	elseif is_vertical then
		start_x, start_y, end_x, end_y = iCenterX, 0, iCenterX, iHeight - 1;
	else
		-- Obtain the tangent of this angle.
		local TAN = math.tan(fTilt_in_radians);
		-- Figure out which axis to use as the measurement basis for the triangle.
		-- (The one that won't let the trangle exceed the defined width and height).
		local width_viable, height_viable = false, false;
		--
		-- Check with width as primary axis.
		local width_check = fRadiusY / TAN;
		if width_check <= fRadiusX then
			width_viable = true;
		end
		-- Check with height as primary axis.
		local height_check = fRadiusX * TAN;
		if height_check <= fRadiusY then
			height_viable = true;
		end
		-- Check for error.
		if width_viable == false and height_viable == false then
			-- Neither width nor height checked out as viable? 
			-- That should not be mathematically possible!
			print("!!!"); print("! ERROR ! - Trigonometric failure !"); print("!!!");
			return nil
		end
		-- Assign the coordinates.
		if width_viable then
			if leans_left == false then
				start_x = iCenterX - width_check;
				end_x   = iCenterX + width_check;
				start_y = 0;
				end_y   = iHeight - 1;
			else
				start_x = iCenterX - width_check;
				end_x   = iCenterX + width_check;
				start_y = iHeight - 1;
				end_y   = 0;
			end
		elseif height_viable then
			if leans_left == false then
				start_x = 0;
				end_x   = iWidth - 1;
				start_y = iCenterY - height_check;
				end_y   = iCenterY + height_check;
			else
				start_x = 0;
				end_x   = iWidth - 1;
				start_y = iCenterY + height_check;
				end_y   = iCenterY - height_check;
			end
		else
			print("*** ERROR *** Width and Height Checks failed! ***");
		end
	end

	local startX, startY, endX, endY, bReverseFlag, slope;
	-- Note: Incoming x/y are starting at 0/0, but we need to convert them to Lua array 
	-- values that start at 1.
	if math.abs(end_y - start_y) < math.abs(end_x - start_x) then
		-- line is closer to horizontal
		if start_x > end_x then
			-- swap start and end
			startX, startY, endX, endY = end_x + 1, end_y + 1, start_x + 1, start_y + 1;
			bReverseFlag = true;
			--print("Path reversed, working from the end plot.");
		else -- don't swap
			startX, startY, endX, endY = start_x + 1, start_y + 1, end_x + 1, end_y + 1;
			bReverseFlag = false;
			--print("Path not reversed.");
		end
		local dx = endX - startX;
		local dy = endY - startY;
		if dx == 0 or dy == 0 then
			slope = 0;
		else
			slope = dy/dx;
		end
		--print("Slope: ", slope);
		local y, y_true = nil, startY;
		-- Process the Axis.
		for x = startX, endX do
			local y_int, y_frac = math.modf(y_true);
			if y_frac >= 0.5 then
				y = math.ceil(y_true);
			else
				y = math.floor(y_true);
			end
			-- Determine if this plot is to become land.
			local diceroll = TerrainBuilder.GetRandomNumber(5, "Island Making - Lua");
			if diceroll > 1 then -- Yes, turn this plot to land.
				local i = (y - 1) * iWidth + x;
				plot_data[i] = true;
			end	
			-- Adjust y for the next iteration of the loop.		
			y_true = y_true + slope;
			--print("y plus slope: ", y_true);
		end

	else -- line is closer to vertical
		if start_y > end_y then
			-- swap start and end
			startX, startY, endX, endY = end_x + 1, end_y + 1, start_x + 1, start_y + 1;
			bReverseFlag = true;
			--print("Path reversed, working from the end plot.");
		else -- don't swap
			startX, startY, endX, endY = start_x + 1, start_y + 1, end_x + 1, end_y + 1;
			bReverseFlag = false;
			--print("Path not reversed.");
		end
		local dx = endX - startX;
		local dy = endY - startY;
		if dx == 0 or dy == 0 then
			slope = 0;
		else
			slope = dx/dy;
		end
		--print("Slope: ", slope);
		local x, x_true = nil, startX;
		-- Process the Axis.
		for y = startY, endY do
			local x_int, x_frac = math.modf(x_true);
			if x_frac >= 0.5 then
				x = math.ceil(x_true);
			else
				x = math.floor(x_true);
			end
			-- Determine if this plot is to become land.
			local diceroll = TerrainBuilder.GetRandomNumber(5, "Island Making - Lua");
			if diceroll > 1 then -- Yes, turn this plot to land.
				local i = (y - 1) * iWidth + x;
				plot_data[i] = true;
			end	
			-- Adjust x for the next iteration of the loop.		
			x_true = x_true + slope;
			--print("x plus slope: ", x_true);
		end
	end
	
	return plot_data;
end

function CreateAxisChainWithDots(iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iNumDots)
	-- This function adds "dots" (randomly placed single plots of land) to an axis island chain.
	local plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt);
	-- Error handling.
	if iInnerWidth > iWidth - 2 then
		iInnerWidth = iWidth - 2;
	end
	if iInnerHeight > iHeight - 2 then
		iInnerHeight = iHeight - 2;
	end
	local westX = 1 + math.floor((iWidth - iInnerWidth) / 2);
	local southY = 1 + math.floor((iHeight - iInnerHeight) / 2);
	-- Add dots. ... Note: No collision checks. Any dots placed on existing plots are lost.
	-- This is intended.
	for loop = 1, iNumDots do
		local randomX = westX + TerrainBuilder.GetRandomNumber(iInnerWidth, 
			"Chains - Random X coord for Dot");
		local randomY = southY + TerrainBuilder.GetRandomNumber(iInnerHeight, 
			"Chains - Random Y coord for Dot - Lua");
		local i = (randomY - 1) * iWidth + randomX;
		plot_data[i] = true;
	end
	return plot_data;
end

function CreateAxisChainWithShiftedDots(
	iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iInnerWest, iInnerSouth, iNumDots)
	-- The dots do not necessarily go in the middle, in this function. 
	-- Use West and South to set the location of the dots.
	local plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
	-- Error handling.
	if iInnerWidth > iWidth - 2 then
		iInnerWidth = iWidth - 2;
	end
	if iInnerHeight > iHeight - 2 then
		iInnerHeight = iHeight - 2;
	end
	-- Add dots. ... Note: No collision checks. Any dots placed on existing plots are lost.
	-- This is intended.
	for loop = 1, iNumDots do
		local randomX = iInnerWest + TerrainBuilder.GetRandomNumber(iInnerWidth, 
			"Random X coord for Dot - Lua");
		local randomY = iInnerSouth + TerrainBuilder.GetRandomNumber(iInnerHeight, 
			"Random Y coord for Dot - Lua");
		local i = (randomY - 1) * iWidth + randomX;
		plot_data[i] = true;
	end

	return plot_data
end

function CreateAxisChainWithDoubleDots(
	iWidth, iHeight, fTilt, iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,
    iNumDots1, iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)
	-- Two sets of dots, with control over size and location.
	local plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
	-- Error handling.
	if iInnerWidth1 > iWidth - 2 then
		iInnerWidth1 = iWidth - 2;
	end
	if iInnerHeight1 > iHeight - 2 then
		iInnerHeight1 = iHeight - 2;
	end
	if iInnerWidth2 > iWidth - 2 then
		iInnerWidth2 = iWidth - 2;
	end
	if iInnerHeight2 > iHeight - 2 then
		iInnerHeight2 = iHeight - 2;
	end
	-- Dots1
	for loop = 1, iNumDots1 do
		local randomX = iInnerWest1 + TerrainBuilder.GetRandomNumber(iInnerWidth1, 
			"Random X coord for Dot - Lua");
		local randomY = iInnerSouth1 + TerrainBuilder.GetRandomNumber(iInnerHeight1, 
			"Random Y coord for Dot - Lua");
		local i = (randomY - 1) * iWidth + randomX;
		plot_data[i] = true;
	end
	-- Dots2
	for loop = 1, iNumDots2 do
		local randomX = iInnerWest2 + TerrainBuilder.GetRandomNumber(iInnerWidth2, 
			"Random X coord for Dot - Lua");
		local randomY = iInnerSouth2 + TerrainBuilder.GetRandomNumber(iInnerHeight2, 
			"Random Y coord for Dot - Lua");
		local i = (randomY - 1) * iWidth + randomX;
		plot_data[i] = true;
	end

	return plot_data
end

function GenerateChains(invertExtras)
	-- Generate Chains of extra islands
	--
	-- Return a map of generated island chain plot types.
	
	-- Now we begin to add the island chains.
	print("Generating chains of islands/lakes.");
	
	local iW, iH, numTiles = GetMapGridSize();

	-- Higher sea level => use less cells.
	local invertableSeaLevel  = UserInput.seaLevel;
	
	if invertExtras then
		-- Invert sea level.
		invertableSeaLevel = 6 - invertableSeaLevel;
	end
	
	local cellTargetFracs = {0.99, 0.88, 0.66, 0.44, 0.33};
	
	local cellTargetFrac  = cellTargetFracs[invertableSeaLevel]; -- originally fixed at 0.66
	
	if (ExtrasGot.everything == true) then
		-- Got "everything" for extras.
		-- Reduce islands to make room for other types of extras.
		cellTargetFrac = cellTargetFrac / 3;
	
	elseif (ExtrasGot.tecAndChains == true) then
		-- Got "tectonic and chains" for extras.
		-- Reduce islands to make room for other extras.
		cellTargetFrac = cellTargetFrac / 2;
	end
	
	-- Use a cell system to combine predefined land chunks with randomly generated island groups.
	-- Define the cell traits. (These need to fit correctly with the map grid width and height.)
	local iCellWidth = 10;
	local iCellHeight = 8;
	local iNumCellColumns = math.floor(iW / iCellWidth);
	local iNumCellRows = math.floor(iH / iCellHeight);
	local iNumTotalCells = iNumCellColumns * iNumCellRows;
	-- Stores data on map cells in use. All cells begin as empty.
	local cell_data = table.fill(false, iNumTotalCells);
	local iNumCellsInUse = 0;
	local iNumCellTarget = math.floor(iNumTotalCells * cellTargetFrac);
	local island_chain_PlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);

	-- Margins for centering the cell grid on the map.
	local xMargin = math.floor((iW - iNumCellColumns * iCellWidth) /2);
	local yMargin = math.floor((iH - iNumCellRows    * iCellHeight)/2);
	
	--print("Target number of cells: " .. iNumCellTarget);
	
	-- Add randomly generated island groups
	local iNumGroups = iNumCellTarget; -- Should virtually never use all the groups.
	for group = 1, iNumGroups do
		if (iNumCellsInUse >= iNumCellTarget) then -- Map has reached desired island population.
			--print("Number of Island Groups produced:", group - 1);
			break
		end
		--[[ Formation Chart
		1. Single Cell, Axis Only
		2. Double Cell, Horizontal, Axis Only
		3. Single Cell With Dots
		4. Double Cell, Horizontal, With Shifted Dots
		5. Double Cell, Vertical, Axis Only
		6. Double Cell, Vertical, With Shifted Dots
		7. Triple Cell, Vertical, With Double Dots
		8. Square of Cells 2x2 With Double Dots
		9. Rectangle 3x2 With Double Dots
		10. Rectangle 2x3 With Double Dots ]]--
		--
		-- Choose a formation
		local rate_threshold = {};
		local total_appearance_rate, iNumFormations = 0, 0;
		-- These numbers are relative to one another. No specific target total is necessary.
		local appearance_rates = { 
			7, -- #1
			3, -- #2
			15, --#3
			8, -- #4
			3, -- #5
			6, -- #6
			4, -- #7
			6, -- #8
			4, -- #9
			3, -- #10
		};
		for i, rate in ipairs(appearance_rates) do
			total_appearance_rate = total_appearance_rate + rate;
			iNumFormations = iNumFormations + 1;
		end
		local accumulated_rate = 0;
		for index = 1, iNumFormations do
			local threshold = 
				(appearance_rates[index] + accumulated_rate) * 10000 / total_appearance_rate;
			table.insert(rate_threshold, threshold);
			accumulated_rate = accumulated_rate + appearance_rates[index];
		end
		local formation_type;
		local diceroll = TerrainBuilder.GetRandomNumber(10000, 
			"Choose formation type - Island Making - Lua");
		for index, threshold in ipairs(rate_threshold) do
			if diceroll <= threshold then -- Choose this formation type.
				formation_type = index;
				break
			end
		end
		-- Choose cell(s) not in use;
		local iNumAttemptsToFindOpenCells = 0;
		local found_unoccupied_cell = false;
		local anchor_cell, cell_x, cell_y, foo;
		while found_unoccupied_cell == false do
			if iNumAttemptsToFindOpenCells > 100 then 
				-- Too many attempts on this pass.
				-- Might not be any valid locations for this formation.
				formation_type = 3; -- Reset formation type.
				iNumAttemptsToFindOpenCells = 0;
			end
			local diceroll = 1 + TerrainBuilder.GetRandomNumber(iNumTotalCells, 
				"Choosing a cell for an island group");
			if cell_data[diceroll] == false then -- Anchor cell is unoccupied.
				-- If formation type is multiple-cell, all secondary cells must also be unoccupied.
				if formation_type == 1 or formation_type == 3 then -- single cell, proceed.
					anchor_cell = diceroll;
					found_unoccupied_cell = true;
				elseif formation_type == 2 or formation_type == 4 then -- double cell, horizontal.
					-- Check to see if anchor cell is in the final column. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns);
					if ((cell_x ~= 0) and (cell_data[diceroll + 1] == false)) then
						-- Anchor cell is valid and adjacent cell is unoccupied.
						anchor_cell = diceroll;
						found_unoccupied_cell = true;
					end
				elseif formation_type == 5 or formation_type == 6 then -- double cell, vertical.
					-- Check to see if anchor cell is in the final row. If so, reject.
					cell_y, foo = math.modf(diceroll / iNumCellColumns);
					cell_y = cell_y + 1;
					if ((cell_y < iNumCellRows) and 
					    (cell_data[diceroll + iNumCellColumns] == false)) then
						-- Anchor cell is valid and adjacent cell is unoccupied.
						anchor_cell = diceroll;
						found_unoccupied_cell = true;
					end
				elseif formation_type == 7 then -- triple cell, vertical.
					-- Check to see if anchor cell is in the northern two rows. If so, reject.
					cell_y, foo = math.modf(diceroll / iNumCellColumns);
					cell_y = cell_y + 1;
					if ((cell_y < iNumCellRows - 1) and 
						(cell_data[diceroll + iNumCellColumns]       == false) and 
						(cell_data[diceroll + (iNumCellColumns * 2)] == false)) then 
						-- Anchor cell is valid and cells above are unoccupied.
						anchor_cell = diceroll;
						found_unoccupied_cell = true;
					end
				elseif formation_type == 8 then -- square, 2x2.
					-- Check to see if anchor cell is in the final row or column. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns);
					if cell_x ~= 0 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns);
						cell_y = cell_y + 1;
						if ((cell_y < iNumCellRows) and 
							(cell_data[diceroll + iNumCellColumns]     == false) and
							(cell_data[diceroll + 1]                   == false) and
							(cell_data[diceroll + iNumCellColumns + 1] == false)) then 
							-- Anchor cell is valid and all cells are open.
							anchor_cell = diceroll;
							found_unoccupied_cell = true;
						end
					end
				elseif formation_type == 9 then -- horizontal, 3x2.
					-- Check to see if anchor cell is too near to an edge. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns);
					if cell_x ~= 0 and cell_x ~= iNumCellColumns - 1 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns);
						cell_y = cell_y + 1;
						if ((cell_y < iNumCellRows) and 
							(cell_data[diceroll + iNumCellColumns]     == false) and
							(cell_data[diceroll + 1]                   == false) and 
							(cell_data[diceroll + 2]                   == false) and
							(cell_data[diceroll + iNumCellColumns + 1] == false) and
							(cell_data[diceroll + iNumCellColumns + 2] == false)) then
							-- Anchor cell is valid and all cells are open.
							anchor_cell = diceroll;
							found_unoccupied_cell = true;
						end
					end
				elseif formation_type == 10 then -- vertical, 2x3.
					-- Check to see if anchor cell is too near to an edge. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns);
					if cell_x ~= 0 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns);
						cell_y = cell_y + 1;
						if ((cell_y < iNumCellRows - 1) and
							(cell_data[diceroll + iNumCellColumns]           == false) and
							(cell_data[diceroll + 1]                         == false) and
							(cell_data[diceroll + iNumCellColumns + 1]       == false) and
							(cell_data[diceroll + (iNumCellColumns * 2)]     == false) and
							(cell_data[diceroll + (iNumCellColumns * 2) + 1] == false)) then
							-- Anchor cell is valid and all cells are open.
							anchor_cell = diceroll;
							found_unoccupied_cell = true;
						end
					end
				end
			end
			iNumAttemptsToFindOpenCells = iNumAttemptsToFindOpenCells + 1;
		end
		-- Find Cell X and Y
		cell_x = math.fmod(anchor_cell, iNumCellColumns);
		if cell_x == 0 then
			cell_x = iNumCellColumns;
		end
		cell_y, foo = math.modf(anchor_cell / iNumCellColumns);
		cell_y = cell_y + 1;
	
		-- Create this island group.
		local iWidth, iHeight, fTilt; -- Scope the variables needed for island group creation.
		local plot_data = {};
		local x_shift, y_shift;
		if formation_type == 1 then -- single cell
			local x_shrinkage = TerrainBuilder.GetRandomNumber(4, "Cell Width adjustment - Lua");
			if x_shrinkage > 2 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 2 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth - x_shrinkage;
			iHeight = iCellHeight - y_shrinkage;
			fTilt = TerrainBuilder.GetRandomNumber(181, "Angle for island chain axis - LUA");
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)

		elseif formation_type == 2 then -- two cells, horizontal
			local x_shrinkage = TerrainBuilder.GetRandomNumber(8, "Cell Width adjustment - Lua");
			if x_shrinkage > 5 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 2 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth * 2 - x_shrinkage;
			iHeight = iCellHeight - y_shrinkage;
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + TerrainBuilder.GetRandomNumber(90, "Angle for island chain axis - LUA");
			if fTilt > 180 then
				fTilt = fTilt - 180;
			end
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
		
		elseif formation_type == 3 then -- single cell, with dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(4, "Cell Width adjustment - Lua");
			if x_shrinkage > 2 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 2 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth - x_shrinkage;
			iHeight = iCellHeight - y_shrinkage;
			fTilt = TerrainBuilder.GetRandomNumber(181, "Angle for island chain axis - LUA");
			-- Determine "dot box"
			local iInnerWidth, iInnerHeight = iWidth - 2, iHeight - 2;
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots = 4;
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots = iNumDots + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithDots(
				iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iNumDots);

		elseif formation_type == 4 then -- two cells, horizontal, with dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(8, "Cell Width adjustment - Lua");
			if x_shrinkage > 5 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 2 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth * 2 - x_shrinkage;
			iHeight = iCellHeight - y_shrinkage;
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + TerrainBuilder.GetRandomNumber(90, "Angle for island chain axis - LUA");
			if fTilt > 180 then
				fTilt = fTilt - 180;
			end
			-- Determine "dot box"
			local iInnerWidth = math.floor(iWidth / 2);
			local iInnerHeight = iHeight - 2;
			local iInnerWest = 2 + TerrainBuilder.GetRandomNumber((iWidth - 1) - iInnerWidth, 
				"Shift for sub island group - Lua");
			local iInnerSouth = 2;
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(10, "Diceroll - Lua");
			local iNumDots = 5;
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots = iNumDots + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithShiftedDots(
				iWidth, 
				iHeight, 
				fTilt, 
				iInnerWidth, 
				iInnerHeight, 
				iInnerWest, 
				iInnerSouth, 
				iNumDots)
		
		elseif formation_type == 5 then -- Double Cell, Vertical, Axis Only
			local x_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Width adjustment - Lua");
			if x_shrinkage > 2 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(7, "Cell Height adjustment - Lua");
			if y_shrinkage > 4 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth - x_shrinkage;
			iHeight = iCellHeight * 2 - y_shrinkage;
			-- Limit angles to mostly vertical ones.
			fTilt = 55 + TerrainBuilder.GetRandomNumber(71, "Angle for island chain axis - LUA");
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
	
		elseif formation_type == 6 then -- Double Cell, Vertical With Dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Width adjustment - Lua");
			if x_shrinkage > 2 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(7, "Cell Height adjustment - Lua");
			if y_shrinkage > 4 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth - x_shrinkage;
			iHeight = iCellHeight * 2 - y_shrinkage;
			-- Limit angles to mostly vertical ones.
			fTilt = 55 + TerrainBuilder.GetRandomNumber(71, "Angle for island chain axis - LUA");
			-- Determine "dot box"
			local iInnerWidth = iWidth - 2;
			local iInnerHeight = math.floor(iHeight / 2);
			local iInnerWest = 2;
			local iInnerSouth = 2 + TerrainBuilder.GetRandomNumber((iHeight - 1) - iInnerHeight, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(10, "Diceroll - Lua");
			local iNumDots = 5;
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots = iNumDots + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithShiftedDots(
				iWidth, 
				iHeight, 
				fTilt, 
				iInnerWidth, 
				iInnerHeight, 
				iInnerWest, 
				iInnerSouth, 
				iNumDots)
	
		elseif formation_type == 7 then -- Triple Cell, Vertical With Double Dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(4, "Cell Width adjustment - Lua");
			if x_shrinkage > 1 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(9, "Cell Height adjustment - Lua");
			if y_shrinkage > 5 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth - x_shrinkage;
			iHeight = iCellHeight * 3 - y_shrinkage;
			-- Limit angles to steep ones.
			fTilt = 70 + TerrainBuilder.GetRandomNumber(41, "Angle for island chain axis - LUA");
			-- Handle Dots Group 1.
			local iInnerWidth1 = iWidth - 3;
			local iInnerHeight1 = iCellHeight - 1;
			local iInnerWest1 = 2 + TerrainBuilder.GetRandomNumber(2, 
				"Shift for sub island group - Lua");
			local iInnerSouth1 = 2 + TerrainBuilder.GetRandomNumber(iCellHeight - 3, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots1 = 4;
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots1 = iNumDots1 + die_1 + die_2;
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iWidth - 3;
			local iInnerHeight2 = iCellHeight - 1;
			local iInnerWest2 = 2 + TerrainBuilder.GetRandomNumber(2, 
				"Shift for sub island group - Lua");
			local iInnerSouth2 = iCellHeight + 2 + TerrainBuilder.GetRandomNumber(iCellHeight - 3, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots2 = 4;
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots2 = iNumDots2 + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithDoubleDots(
				iWidth, 
				iHeight, 
				fTilt, 
				iInnerWidth1, 
				iInnerHeight1, 
				iInnerWest1, 
				iInnerSouth1,
				iNumDots1, 
				iInnerWidth2, 
				iInnerHeight2, 
				iInnerWest2, 
				iInnerSouth2, 
				iNumDots2)
		elseif formation_type == 8 then -- Square Block 2x2 With Double Dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(6, "Cell Width adjustment - Lua");
			if x_shrinkage > 4 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 3 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth * 2 - x_shrinkage;
			iHeight = iCellHeight * 2 - y_shrinkage;
			-- Full range of angles
			fTilt = TerrainBuilder.GetRandomNumber(181, "Angle for island chain axis - LUA");
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth - 2;
			local iInnerHeight1 = iCellHeight - 2;
			local iInnerWest1 = 3 + TerrainBuilder.GetRandomNumber(iCellWidth - 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth1 = 3 + TerrainBuilder.GetRandomNumber(iCellHeight - 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(6, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(10, "Diceroll - Lua");
			local iNumDots1 = 5;
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots1 = iNumDots1 + die_1 + die_2;
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth - 2;
			local iInnerHeight2 = iCellHeight - 2;
			local iInnerWest2 = 3 + TerrainBuilder.GetRandomNumber(iCellWidth - 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth2 = 3 + TerrainBuilder.GetRandomNumber(iCellHeight - 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots2 = 5;
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots2 = iNumDots2 + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithDoubleDots(
				iWidth, iHeight, 
				fTilt, 
				iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,	iNumDots1, 
				iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)

		elseif formation_type == 9 then -- Horizontal Block 3x2 With Double Dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(8, "Cell Width adjustment - Lua");
			if x_shrinkage > 5 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(5, "Cell Height adjustment - Lua");
			if y_shrinkage > 3 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth * 3 - x_shrinkage;
			iHeight = iCellHeight * 2 - y_shrinkage;
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + TerrainBuilder.GetRandomNumber(90, "Angle for island chain axis - LUA");
			if fTilt > 180 then
				fTilt = fTilt - 180;
			end
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth;
			local iInnerHeight1 = iCellHeight - 2;
			local iInnerWest1 = 4 + TerrainBuilder.GetRandomNumber(iCellWidth + 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth1 = 3 + TerrainBuilder.GetRandomNumber(iCellHeight - 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots1 = 9;
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots1 = iNumDots1 + die_1 + die_2;
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth;
			local iInnerHeight2 = iCellHeight - 2;
			local iInnerWest2 = 4 + TerrainBuilder.GetRandomNumber(iCellWidth + 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth2 = 3 + TerrainBuilder.GetRandomNumber(iCellHeight - 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(5, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(7, "Diceroll - Lua");
			local iNumDots2 = 8;
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots2 = iNumDots2 + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithDoubleDots(
				iWidth, iHeight, 
				fTilt, 
				iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1, iNumDots1, 
				iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)

		elseif formation_type == 10 then -- Vertical Block 2x3 With Double Dots
			local x_shrinkage = TerrainBuilder.GetRandomNumber(6, "Cell Width adjustment - Lua");
			if x_shrinkage > 4 then
				x_shrinkage = 0;
			end
			local y_shrinkage = TerrainBuilder.GetRandomNumber(8, "Cell Height adjustment - Lua");
			if y_shrinkage > 5 then
				y_shrinkage = 0;
			end
			x_shift, y_shift = 0, 0;
			if x_shrinkage > 0 then
				x_shift = TerrainBuilder.GetRandomNumber(x_shrinkage, "Cell Width offset - Lua");
			end
			if y_shrinkage > 0 then
				y_shift = TerrainBuilder.GetRandomNumber(y_shrinkage, "Cell Height offset - Lua");
			end
			iWidth = iCellWidth * 2 - x_shrinkage;
			iHeight = iCellHeight * 3 - y_shrinkage;
			-- Mostly vertical
			fTilt = 55 + TerrainBuilder.GetRandomNumber(71, "Angle for island chain axis - LUA");
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth - 2;
			local iInnerHeight1 = iCellHeight;
			local iInnerWest1 = 3 + TerrainBuilder.GetRandomNumber(iCellWidth - 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth1 = 4 + TerrainBuilder.GetRandomNumber(iCellHeight + 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(10, "Diceroll - Lua");
			local iNumDots1 = 8;
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots1 = iNumDots1 + die_1 + die_2;
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth - 2;
			local iInnerHeight2 = iCellHeight;
			local iInnerWest2 = 3 + TerrainBuilder.GetRandomNumber(iCellWidth - 2, 
				"Shift for sub island group - Lua");
			local iInnerSouth2 = 4 + TerrainBuilder.GetRandomNumber(iCellHeight + 2, 
				"Shift for sub island group - Lua");
			-- Determine number of dots
			local die_1 = TerrainBuilder.GetRandomNumber(4, "Diceroll - Lua");
			local die_2 = TerrainBuilder.GetRandomNumber(8, "Diceroll - Lua");
			local iNumDots2 = 7;
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + TerrainBuilder.GetRandomNumber(die_1 + die_2, 
					"Number of dots to add to island chain - Lua");
			else
				iNumDots2 = iNumDots2 + die_1 + die_2;
			end
			plot_data = CreateAxisChainWithDoubleDots(
				iWidth, iHeight, 
				fTilt, 
				iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1, iNumDots1, 
				iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)
		end

		-- Obtain land plots from the plot data
		local x_adjust = xMargin + (cell_x - 1) * iCellWidth  + x_shift;
		local y_adjust = yMargin + (cell_y - 1) * iCellHeight + y_shift;
		for y = 1, iHeight do
			for x = 1, iWidth do
				local data_index = (y - 1) * iWidth + x;
				if plot_data[data_index] == true then -- This plot is land.
					local real_x = x + x_adjust - 1;
					local real_y = y + y_adjust - 1;
					local plot_index = GetPlotIndexLua(real_x, real_y);
					island_chain_PlotTypes[plot_index] = g_PLOT_TYPE_LAND;
				end
			end
		end
	
		-- Record cells in use
		if formation_type == 1 then -- single cell
			cell_data[anchor_cell] = true;
			iNumCellsInUse = iNumCellsInUse + 1;
		elseif formation_type == 2 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
			iNumCellsInUse = iNumCellsInUse + 2;
		elseif formation_type == 3 then
			cell_data[anchor_cell] = true;
			iNumCellsInUse = iNumCellsInUse + 1;
		elseif formation_type == 4 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
			iNumCellsInUse = iNumCellsInUse + 2;
		elseif formation_type == 5 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true;
			iNumCellsInUse = iNumCellsInUse + 2;
		elseif formation_type == 6 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true;
			iNumCellsInUse = iNumCellsInUse + 2;
		elseif formation_type == 7 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true;
			cell_data[anchor_cell + (iNumCellColumns * 2)] = true;
			iNumCellsInUse = iNumCellsInUse + 3;
		elseif formation_type == 8 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
			cell_data[anchor_cell + iNumCellColumns], 
			cell_data[anchor_cell + iNumCellColumns + 1] = true, true;
			iNumCellsInUse = iNumCellsInUse + 4;
		elseif formation_type == 9 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true;
			cell_data[anchor_cell + iNumCellColumns], 
			cell_data[anchor_cell + iNumCellColumns + 1] = true, true;
			cell_data[anchor_cell + 2], 
			cell_data[anchor_cell + iNumCellColumns + 2] = true, true;
			iNumCellsInUse = iNumCellsInUse + 6;
		elseif formation_type == 10 then
			cell_data[anchor_cell], 
			cell_data[anchor_cell + 1] = true, true;
			cell_data[anchor_cell + iNumCellColumns], 
			cell_data[anchor_cell + iNumCellColumns + 1] = true, true;
			cell_data[anchor_cell + (iNumCellColumns * 2)], 
			cell_data[anchor_cell + (iNumCellColumns * 2) + 1] = true, true;
			iNumCellsInUse = iNumCellsInUse + 6;
		end
	end
	
	return island_chain_PlotTypes;
end
---------------------------------------------------------------------------------------------------
-- Clusters
--
-- Densly packed islands - fractal islands subdivided by random paths
---------------------------------------------------------------------------------------------------
function GenerateLakesForClusters(inverted, lakeGrain, fracFlags, lakeLevelOffset)
	-- Use a lake fractal to add water to a land-heavy map.
	-- For generating clusters of lakes (hides lake-levels and lake grains).
	--
	-- Args:
	--   inverted: true iff these lakes are for inverted clusters
	--   lakeGrain: lake fractal granularity
	--   fracFlags: fractal flags
	--   lakeLevelOffset: offset for lake fractal's height threshold
	--
	-- Returns:
	--   plotTypes: a map of generated lakes that are not yet clusters
	local invertableSeaLevel = UserInput.seaLevel;
	if inverted then
		-- The above levels are calibrated for islands.
		-- Reverse order for lakes.
		invertableSeaLevel = 6 - invertableSeaLevel;
	end
	
	-- Map sea levels to water percent thresholds.
	local lake_levels = {66,72,78,84,90};
	local lake_level  = lake_levels[invertableSeaLevel] or 78;
	
	-- Any smaller and lakes might not spread out enough.
	-- Any larger and clusters might be too much like chains.
	local lake_grain = lakeGrain or 3;
	local lakeLevelOffset = lakeLevelOffset or 0;
	lake_level = lake_level + lakeLevelOffset;
	
	if (lake_grain == 1) then
		-- Use polar fractal to keep mega-cluster away from map edges.
		fracFlags = {FRAC_POLAR = true};
	end
	
	print("Clusters sea offset: ", lakeLevelOffset);
	print("Clusters sea level: ", lake_level);
	print("Clusters grain: ", lake_grain);
	
	-- Use the general-purpose lake fractal with special inputs.
	return GenerateLakesFractal(lake_level, lake_grain, fracFlags);
end

function TurnLakesIntoClusters(plotTypes, targetSize)
	print("Turning lakes for clusters into clusters of islands.");
	
	local iW, iH, numTiles = GetMapGridSize();
    
	-- Freshen the lakes.
	FreshenLakes(plotTypes, targetSize, false);
    
	-- We want islands, not lakes.
	-- But we started with lakes, so invert the lakes into islands.
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x, y);
			if (plotTypes[i] == g_PLOT_TYPE_OCEAN) then
				plotTypes[i] = g_PLOT_TYPE_LAND;
			else
				plotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
end

function TurnLakesIntoConnectedClusters(plotTypes, targetSize)
	-- Apply connected-lands to lakes for clusters by connecting lakes.
	print("Turning lakes for clusters into connected clusters of islands.");
	
	local iW, iH, numTiles = GetMapGridSize();
	
    -- Connect landmass "lands" before turning lakes into clusters (to minimize land bridges).
    -- But landmass is inverted right now, so "connect oceans" instead.
    -- Use PassMaker to connect oceans with random channels.
    ConnectOceans(plotTypes);
    
    -- Make a copy of plot types with only non-coastal plots
    -- So that we can freshen the insides of clusters while keeping cluster borders connected.
    local nonCoastPlotTypes = table.fill(g_PLOT_TYPE_LAND, numTiles);
    for y = 0, iH - 1 do
        for x = 0, iW - 1 do
            local i = GetPlotIndexLua(x,y);
            if ((plotTypes[i] == g_PLOT_TYPE_OCEAN) and
                (not IsAdjacentToLand(plotTypes, x, y))) then
                nonCoastPlotTypes[i] = g_PLOT_TYPE_OCEAN;
            end
        end
    end
    
	-- Freshen the lakes.
	FreshenLakes(nonCoastPlotTypes, targetSize, false);
    
    -- Merge the non-coast plots onto the lakes fractal.
    MergeExtrasAvoidLandmass(true, plotTypes, nonCoastPlotTypes);
	
	-- We want islands, not lakes.
	-- But we started with lakes, so invert the lakes into islands.
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x, y);
			if (plotTypes[i] == g_PLOT_TYPE_OCEAN) then
				plotTypes[i] = g_PLOT_TYPE_LAND;
			else
				plotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
end

function GenerateClusters(invertExtras, targetSize, fracFlags)
	-- Generate clusters of islands
	--
	-- Return a map of generated island plot types.
	print("Generating clusters.");
	
	local iW, iH, numTiles = GetMapGridSize();
		
	local lakeGrain = 3;
	local lakeLevelOffset = 0;
	if ExtrasGot.everything then
		-- Got "everything" for extras.
		-- Use a lower grain to distinguish clusters from other extras.
		lakeGrain = 2;
	
	elseif invertExtras then
		-- Inverted Extras
		-- Lower the threshold to make lakes bigger
		lakeLevelOffset = -12; 
		
	elseif (UserInput.landmass == Landmasses.NONE) then
		-- No landmass
		-- Lower the threshold to make islands bigger.
		lakeLevelOffset = -8;
	end
	
	-- Generate a lakes fractal that doesn't have clusters yet.
	local plotTypes = 
		GenerateLakesForClusters(invertExtras, lakeGrain, fracFlags, lakeLevelOffset);
	
	-- Target size for islands/lakes in a cluster.
	print("Target island/lake size: ", targetSize);
    
    TurnLakesIntoClusters(plotTypes, targetSize);
	return plotTypes;
end

function GenerateConnectedClusters(targetSize, fracFlags)
	-- Generate connected clusters of islands
	--
	-- Return a map of generated island plot types.
	print("Generating connected clusters.");
	
	local iW, iH, numTiles = GetMapGridSize();
		
	local lakeGrain = 3;
	local lakeLevelOffset = 0;
	if ExtrasGot.everything then
		-- Got "everything" for extras.
		-- Use a lower grain to distinguish clusters from other extras.
		lakeGrain = 2;
		
	elseif (UserInput.landmass == Landmasses.NONE) then
		-- No landmass
		-- Lower the threshold to make islands bigger.
		lakeLevelOffset = -8;
	end
	
	-- Generate a lakes fractal that doesn't have clusters yet.
	local plotTypes = GenerateLakesForClusters(false, lakeGrain, fracFlags, lakeLevelOffset);
	
	-- Target size for islands/lakes in a cluster.
    -- Use tiny islands to increase chance of islands inside connected lands.
    targetSize = math.ceil(targetSize*0.2);
	print("Target island/lake size: ", targetSize);
    
    TurnLakesIntoConnectedClusters(plotTypes, targetSize);
	return plotTypes;
end
---------------------------------------------------------------------------------------------------
-- Connected Lands
--
-- Not actually an extra but a misc option to connect islands/continents with land bridges.
-- Effectively adds extra land to a landmass, so it's like a checkbox-enabled extra.
---------------------------------------------------------------------------------------------------
function ConnectLands(plotTypes, isolateCoasts, preserveSaltLakes)
    -- Use PassMaker to connect islands/continents with land bridges.
    -- Args:
    --   plotTypes: land/water map of lands to connect.
    --   isolateCoasts: whether to enforce isolated coasts
    --     (in which case, *almost* connect lands).
    --   preserveSaltLakes: whether to prevent saltwater seas from turning into fresh lakes
	local bridgeArgs = 
	{
		obstaclesName 		= "water",
		plotTypes           = plotTypes,
		InitReachPlot 		= PassMaker.Water_InitReachPlot,
		RemoveObstacle      = PassMaker.Water_RemoveObstacle,
	};
    
    if not (isolateCoasts or preserveSaltLakes) then
       -- Apply connected lands directly to the map.
       print("Connecting lands.");
       EnsureReachabilityWithPassMaker(bridgeArgs);
       return;
    end
    
    local mergeFcn = MergeExtrasPreserveSaltLakes;
    if isolateCoasts then
        print("Connecting lands while enforcing isolated coasts.");    
        mergeFcn = MergeExtrasAvoidLandmassCoast;
    else
        -- Preserving salt-water seas.
        print("Connecting lands while preserving salt-water seas.");    
    end
    
    -- Copy the plot types so that we can apply an isolation merge.
    local iW, iH, numTiles = GetMapGridSize();
    local connectingPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
    for i = 1, numTiles do
        connectingPlotTypes[i] = plotTypes[i];
    end
    bridgeArgs.plotTypes = connectingPlotTypes;
    EnsureReachabilityWithPassMaker(bridgeArgs);

	mergeFcn(true, plotTypes, connectingPlotTypes);
end

function ConnectOceans(plotTypes)
	-- Connect all water tiles into a single system of oceans.	
	-- Use PassMaker to connect oceans with random channels.
	local channelArgs = 
	{
		obstaclesName 		= "land",
		plotTypes           = plotTypes,
		InitReachPlot 		= PassMaker.Land_InitReachPlot,
		RemoveObstacle      = PassMaker.Land_RemoveObstacle,
	};
	EnsureReachabilityWithPassMaker(channelArgs);
end
---------------------------------------------------------------------------------------------------
-- Fresh Lakes Landmasses
--
-- Not actually an extra but a misc option to turn all salt water into fresh lakes.
-- Effectively adds extra land to a landmass, so it's like a checkbox-enabled extra.
---------------------------------------------------------------------------------------------------
function FreshenLakesLandmass(plotTypes)
	-- Turn salt water into fresh water for a landmass.
	--
	-- Args:
	--   plotTypes: map to freshen
    local isolateCoasts = UserInput.isoCoasts;
    local connectSeas   = UserInput.connectSeas;

    if not (isolateCoasts or connectSeas) then
        -- Apply freshening directly to the map.
        print("Turning salt water into fresh lakes.");
        FreshenLakes(plotTypes, LAKE_MAXNUMTILES, true);
        return;
    end

    local mergeFcn = MergeExtrasAvoidLandmass;
    if isolateCoasts then
        print("Turning salt water into fresh lakes while isolating coasts.");
        mergeFcn = MergeExtrasAvoidLandmassCoast;
    else
        -- Non-isolated map with connected seas.
        -- Avoid touching the existing land so that the landmass remains roughly intact.
        print("Turning salt water into fresh lakes while avoiding landmass and extras.");
    end

    -- Copy the plot types so that we can apply an isolation merge.
    local iW, iH, numTiles = GetMapGridSize();
    local fresheningPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
    for i = 1, numTiles do
        fresheningPlotTypes[i] = plotTypes[i];
    end
    FreshenLakes(fresheningPlotTypes, LAKE_MAXNUMTILES, true);
    
    -- Merge the freshening back into the landmass.
    mergeFcn(true, plotTypes, fresheningPlotTypes);
end
---------------------------------------------------------------------------------------------------
-- Hex Landmass Helpers
--
-- Not actually an extra but helper methods to add mega-hexes to the map.
-- TODO some of this might be reusable enough to move to utils for hexifying terrain, etc.
---------------------------------------------------------------------------------------------------
function GenerateHex(plotTypes, centerX, centerY, radius, numLands, targetNumLands)
    -- Generate a single multi-plot hex as part of a hex pangea.
    local numLands = numLands;
    local iW, iH, numTiles = GetMapGridSize();
    -- TODO also bounds check x if world wrap is disabled (if necessary).
    if ((centerY < (radius-1)) or (centerY > (iH - radius))) then
        print("Hex at " .. CoordString(centerX, centerY) ..
              " with radius " .. radius ..
              " is too close to the map edge.");
        return numLands;
    end
    if (numLands >= targetNumLands) then
        -- We already added enough land to the map.
        print("Target land level reached.");
        return numLands;
    end
    
    print("Generating hex at " .. CoordString(centerX,centerY) .. 
          " with radius " .. radius);
    local hexes = Queue:Create();
    
    hexes:Enqueue({x=centerX, y=centerY, r=radius});
    
    while not hexes:IsEmpty() do
        local hex = hexes:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local r = hex.r;
        local plot = Map.GetPlot(x,y);
        local iPlot = GetPlotIndexLua(x,y);
        if (plot and (plotTypes[iPlot] == g_PLOT_TYPE_LAND)) then
            -- Already visited this plot.
            --print("Already visited plot at " .. CoordString(x,y));
        elseif plot then
            plotTypes[iPlot] = g_PLOT_TYPE_LAND;
            numLands = numLands + 1;
            
            if (r > 1) then
                for i, direction in ipairs(HexDirections) do
                    local aX, aY = GetAdjacentXY(x, y, direction);
                    hexes:Enqueue({x=aX, y=aY, r=r-1});
                end
            end 
        end
    end
    return numLands;
end

function R1_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 1.
    -- Take flow direction instead of regular hex direction
    -- because pangea sub-hexes are generally aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    -- R1 actually follows hex dirs, unlike higher radii.
    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        -- Actually NE
        return x + oddRowOffset, y + 1;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        -- Actually E
        return x + 1, y;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + oddRowOffset, y - 1;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        -- Actually SW
        return x - evenRowOffset, y - 1;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        -- Actually W
        return x - 1, y;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - evenRowOffset, y + 1;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function R2_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 2.
    -- Use flow direction instead of regular hex direction
    -- because pangea hexes are aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        return x + oddRowOffset, y + 3;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        return x + 2 + oddRowOffset, y + 1;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + 2, y - 2;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        return x - evenRowOffset, y - 3;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        return x - 2 - evenRowOffset, y - 1;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - 2, y + 2;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function R3_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 3.
    -- Use flow direction instead of regular hex direction
    -- because pangea hexes are aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        return x + oddRowOffset, y + 5;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        return x + 4, y + 2;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + 3 + oddRowOffset, y - 3;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        return x - evenRowOffset, y - 5;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        return x - 4, y - 2;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - 3 - evenRowOffset, y + 3;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function R4_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 4.
    -- Use flow direction instead of regular hex direction
    -- because pangea hexes are aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        return x + oddRowOffset, y + 7;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        return x + 5 + oddRowOffset, y + 3;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + 5, y - 4;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        return x - evenRowOffset, y - 7;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        return x - 5 - evenRowOffset, y - 3;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - 5, y + 4;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function R5_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 5.
    -- Use flow direction instead of regular hex direction
    -- because pangea hexes are aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        return x + oddRowOffset, y + 9;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        return x + 7, y + 4;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + 6 + oddRowOffset, y - 5;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        return x - evenRowOffset, y - 9;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        return x - 7, y - 4;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - 6 - evenRowOffset, y + 5;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function R6_GetAdjacentHexXY(x, y, flowDir)
    -- Get the center coords of and ajacent multi-plot hex of radius 6.
    -- Use flow direction instead of regular hex direction
    -- because pangea hexes are aligned with flow directions.
    local oddRowOffset = y % 2;
    local evenRowOffset = 1 - oddRowOffset;

    if (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTH) then
        return x + oddRowOffset, y + 11;
    
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST) then
        return x + 8 + oddRowOffset, y + 5;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST) then
        return x + 8, y - 6;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTH) then
        return x - evenRowOffset, y - 11;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST) then
        return x - 8 - evenRowOffset, y - 5;
        
    elseif (flowDir == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST) then
        return x - 8, y + 6;
    end
    
    print("Invalid flow direction " .. tostring(flowDir));
    return x, y;
end

function GetAdjacentHexFcn(hexRadius)
    local hexRadius = hexRadius or 4;
    local hexRadiusFcns = 
    {
        R1_GetAdjacentHexXY,
        R2_GetAdjacentHexXY,
        R3_GetAdjacentHexXY,
        R4_GetAdjacentHexXY,
        R5_GetAdjacentHexXY,
        R6_GetAdjacentHexXY
    };
    return hexRadiusFcns[hexRadius] or R4_GetAdjacentHexXY;
end

function GenerateHexPangea(plotTypes, initHexes, hexRadius, hexes, numLands, targetNumLands)
    -- Generate a hex pangea by starting with initial hexes
    -- and then expand the shape until either reaching target land level
    -- or filling the map.
    --
    -- Args:
    --   plotTypes: map of land vs water
    --   initHexes: list of {x,y} coords to use for the pangea's central shape;
    --     a singleton results in a hexagon, for example
    --   hexRadius: distance from center plot to edge inclusive for each sub-hex.
    --   hexes: list of hex center coords to populate; ignored if hex radius is 1.
    --   numLands: current number of land plots on the map
    --   targetNumLands: threshold at which to stop expanding the pangea
    -- Returns: an updated total number of land plots
    local numLands = numLands;
    if (numLands >= targetNumLands) then
        -- We already added enough land to the map.
        print("Target land level reached.");
        return numLands;
    end
    
    local initHexes = initHexes or {};
    print("Generating hex pangea with " .. #initHexes .. " initial hex(es).");
    
    local hexQueue = Queue:Create();
    for i, hex in ipairs(initHexes) do
        hexQueue:Enqueue(hex);
    end
    
    local AdjacentHexXYFcn = GetAdjacentHexFcn(hexRadius);
    
    while ((numLands < targetNumLands) and (not hexQueue:IsEmpty())) do
        local hex = hexQueue:Dequeue();
        local x = hex.x;
        local y = hex.y;
        local plot = Map.GetPlot(x,y);
        local iPlot = GetPlotIndexLua(x,y);
        if (plot and (plotTypes[iPlot] == g_PLOT_TYPE_LAND)) then
            -- Already visited this plot.
            --print("Already visited plot at " .. CoordString(x,y));
        elseif plot then
            -- 1st time at this location, so draw the hex.
            local newNumLands = GenerateHex(
                plotTypes, x, y, hexRadius, numLands, targetNumLands);
            if ((hexRadius > 1) and (newNumLands > numLands)) then
                -- Generated a new non-trivial hex.
                table.insert(hexes, {x=x,y=y});
            end
            numLands = newNumLands;
            -- We're in bounds, so continue expanding.
            
            -- Shuffle directions to randomize expansion.
			local shuffledDirs = GetShuffledCopyOfTable(FlowDirections);
            for i, direction in ipairs(shuffledDirs) do
                local aX, aY = AdjacentHexXYFcn(x, y, direction);
                hexQueue:Enqueue({x=aX, y=aY});
            end 
        end
    end
    return numLands;
end

function GeneratePangeaEquilateralHex(
    plotTypes, centerX, centerY, hexRadius, hexes, numLands, targetNumLands)
    -- Generate a pangea of multi-plot hexes
    -- in the form of an equilateral hexagon of sub-hexes.
    -- Args:
    --   plotTypes: map of land vs water to update
    --   centerX, centerY: where to place the central hex
    --   hexRadius: distance from center plot to edge inclusive for each sub-hex.
    --   hexes: list of hex center coords to populate; ignored if hex radius is 1.
    --   numLands: current number of lands plots on the map.
    --   targetNumLands: target number of land plots to have on the map.
    print("Generating pangea hex at " .. CoordString(centerX,centerY) .. 
          " with hexes of radius " .. hexRadius);
    return GenerateHexPangea(
        plotTypes, {{x=centerX,y=centerY}}, hexRadius, hexes, numLands, targetNumLands);
end

function GeneratePangeaQuadHex(
    plotTypes, centerX, centerY, hexRadius, hexes, numLands, targetNumLands)
    -- Generate a pangea of multi-plot hexes
    -- in the form of four overlapping hexagons of sub-hexes.
    -- Args:
    --   plotTypes: map of land vs water to update
    --   centerX, centerY: where to place the central hex
    --   hexRadius: distance from center plot to edge inclusive for each sub-hex.
    --   hexes: list of hex center coords to populate; ignored if hex radius is 1.
    --   numLands: current number of lands plots on the map.
    --   targetNumLands: target number of land plots to have on the map.
    print("Generating pangea quad hex at " .. CoordString(centerX,centerY) .. 
          " with hexes of radius " .. hexRadius);

    local AdjacentHexXYFcn = GetAdjacentHexFcn(hexRadius);
    
    -- Calculate distance between east and west centers of the quad hex
    -- by traversing NE then SE via pangea hex grid.
    local xDiff, yDiff = AdjacentHexXYFcn(0, 0, FlowDirectionTypes.FLOWDIRECTION_NORTHEAST);
    xDiff, yDiff       = AdjacentHexXYFcn(xDiff,yDiff,FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST);
    
    -- Offset western center by half that distance to center the quad onto the map.
    local x = centerX - math.floor(xDiff/2);
    local y = centerY - math.floor(yDiff/2);
    
    local initHexes = {};
    table.insert(initHexes, {x=x,y=y});
    
    -- Hop from west to north.
    x, y = AdjacentHexXYFcn(x, y, FlowDirectionTypes.FLOWDIRECTION_NORTHEAST);
    table.insert(initHexes, {x=x,y=y});
    
    -- Hop from north to east.
    x, y = AdjacentHexXYFcn(x, y, FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST);
    table.insert(initHexes, {x=x,y=y});
    
    -- Hop from east to south.
    x, y = AdjacentHexXYFcn(x, y, FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST);
    table.insert(initHexes, {x=x,y=y});
    
    return GenerateHexPangea(
        plotTypes, initHexes, hexRadius, hexes, numLands, targetNumLands);
end

function GeneratePangeaZigZagHex(
    plotTypes, centerX, centerY, hexRadius, hexes, numLands, targetNumLands)
    -- Generate a pangea of multi-plot hexes
    -- in the form of five barely-overlapping hexagons of sub-hexes.
    -- Args:
    --   plotTypes: map of land vs water to update
    --   centerX, centerY: where to place the central hex
    --   hexRadius: distance from center plot to edge inclusive for each sub-hex.
    --   hexes: list of hex center coords to populate; ignored if hex radius is 1.
    --   numLands: current number of lands plots on the map.
    --   targetNumLands: target number of land plots to have on the map.
    print("Generating pangea zig-zag hex at " .. CoordString(centerX,centerY) .. 
          " with hexes of radius " .. hexRadius);

    -- Start with the central hex.
    local initHexes = {};
    table.insert(initHexes, {x=centerX,y=centerY});
    
    -- Determine width of zig-zag based on map ratio and hex radius.
    -- Zig-zag will expand in all directions, but hopefully we won't reach
    -- the top and bottom edges of the map too soon.
    local iW, iH = GetMapGridSize();
    local ratio   = iW / iH; -- We've got bigger problems if H is 0.
    -- Wider map ratio => more zig-zags.
    local numZigZags = Round(ratio);

    local AdjacentHexXYFcn = GetAdjacentHexFcn(hexRadius);
    
    -- Calculate distance between origin and east/west centers of the zig-zag
    -- by traversing NE then SE / SW then NW via pangea hex grid.
    local xw, yw = AdjacentHexXYFcn(centerX, centerY, FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST);
    local xe, ye = AdjacentHexXYFcn(centerX, centerY, FlowDirectionTypes.FLOWDIRECTION_NORTHEAST);
    table.insert(initHexes, {x=xw,y=yw});
    table.insert(initHexes, {x=xe,y=ye});
    
    if (numZigZags > 1) then
        xw, yw = AdjacentHexXYFcn(xw,yw,FlowDirectionTypes.FLOWDIRECTION_NORTHWEST);
        xe, ye = AdjacentHexXYFcn(xe,ye,FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST);
        table.insert(initHexes, {x=xw,y=yw});
        table.insert(initHexes, {x=xe,y=ye});
    end
    -- Keep hopping NE then SE / SW then NW until we we are far enough to draw three
    -- pangea hexes that overlap only at their outermost layer.
    for i = 3, numZigZags do
        xw, yw = AdjacentHexXYFcn(xw,yw,FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST);
        xe, ye = AdjacentHexXYFcn(xe,ye,FlowDirectionTypes.FLOWDIRECTION_NORTHEAST);
        table.insert(initHexes, {x=xw,y=yw});
        table.insert(initHexes, {x=xe,y=ye});
        
        xw, yw = AdjacentHexXYFcn(xw,yw,FlowDirectionTypes.FLOWDIRECTION_NORTHWEST);
        xe, ye = AdjacentHexXYFcn(xe,ye,FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST);
        table.insert(initHexes, {x=xw,y=yw});
        table.insert(initHexes, {x=xe,y=ye});
    end
    
    return GenerateHexPangea(
        plotTypes, initHexes, hexRadius, hexes, numLands, targetNumLands);
end
---------------------------------------------------------------------------------------------------
-- Mini Donuts
--
-- A randomized grid of donut-shaped islands with random bays and random slicing
---------------------------------------------------------------------------------------------------
function IsInSlice(enableSlicing, theta, sliceLength)
	-- Determine whether a certain donut plot is part of the slice to include.
	--
	-- Args:
	--   enableSlicing: if false, then bypass this check and just return true
	--     so that the entire donut is in the slice.
	--   theta: angle to check
	--   sliceLength: the length of the slice in radians
	--
	-- Returns true if slicing is disabled or theta is in [0,sliceLength).
	return ((enableSlicing == false) or ((0 <= theta) and (theta < sliceLength)));
end

function RandomSlice(rDonut)
	-- Args: 
	--    rDonut: the radius of the donut; determines mimimum slice length
	--
	-- Return [length, offset] 
	--   length: the length of the slice in radians
	--   offset: rotate the slice counter-clockwise by this much in radians.
	--     A slice with an offset of 0 begins at 6:00

	-- Enforce a minimum slice length based on donut size to avoid slices 
	-- that don't look anything like a donut.
	-- Default min length.
	local minLength = math.pi;
	
	if (rDonut >= 8) then
		minLength = TAU/3;
	end
	
	local length = RandomRadians(minLength);
	local offset = RandomRadians();
	
	--print("Slice length " .. RadString(length));
	--print("Slice offset " .. RadString(offset));
	return length, offset;
end

function GenerateMiniDonut(island_plotTypes, centerX, centerY, args)
	-- Generate a single mini-donut.
	--
	-- Args
	--   island_plotTypes: add the mini-donut to this map.
	--   centerX,centerY: target location of the donut's center.
	--   args: donut args from landmass/extras config; ignored if nil
	
	-- Note: some landmasses such as Pangea may shift the mini donut 
	-- as part of landmass generation.
	--print("Generating mini-donut at " .. CoordString(centerX,centerY));
	local iW, iH, numTiles = GetMapGridSize();
	
	local args = args or {};
		
	-- If the center is on an odd row then shift x to account for hex grid.
	-- When calculating Euclidian distance.
	local centerXEucl = centerX;
	if ((centerY % 2) == 1) then
		centerXEucl = centerXEucl + 0.5;
	end
	
	-- Randomize donut radius based min and max.
	local rMin = args.rMin or 2;
	local rMax = args.rMax or 3;
	local rDonut = rMin + TerrainBuilder.GetRandomNumber(rMax-rMin+1, "M-Donut radius");
	--print("Donut radius: " .. rDonut);
	
	-- Donut thicknesss range as a percentage of radius.
	local tMin = args.tMin or 1;
	local tMax = args.tMax or 100;
	tMin = math.clamp(tMin, 1,    100);
	tMax = math.clamp(tMax, tMin, 100);
	local thicknessPct = 
		tMin + TerrainBuilder.GetRandomNumber(tMax-tMin+1, "M-Donut thickness pct");
	local thickness = math.max(1, Round(rDonut*thicknessPct/100));
	--print("Donut thickness: " .. thickness);
	
	-- Use thickness to determine range for hole radius.
	-- The hole is the circle of water at the donut's center.
	-- A negative radius means no hole (filled donut).
	local rHole = rDonut - thickness;
	--print("Donut hole radius: " .. rHole);
	
	-- Donut slice boundaries.
	local sliceLength = TAU;
	local sliceOffset = 0;
	local enableSlicing = args.enableSlicing or false;
	if (enableSlicing == false) then
		--print("No slicing.");
	else
		sliceLength, sliceOffset = RandomSlice(rDonut);
	end
	
	-- Limit which plots to visit; improves performance.
	local rDonutBound = 2*rDonut;	
	local westX = centerX - rDonutBound;
	local eastX = centerX + rDonutBound;
	local southY = math.max(0,    centerY - rDonutBound);
	local northY = math.min(iH-1, centerY + rDonutBound);

	if (not args.wrapX) then
		-- Regional map: don't wrap donuts in the x-direction.
		--print("Avoiding map edges (regional world wrap)");
		westX  = math.max(0,    westX);
		eastX  = math.min(iW-1, eastX);
	end
	
	--print("Donut boundary: " .. CoordString(westX, southY) .. 
	--      " to " .. CoordString(eastX, northY)); 

	-- Use a fractal to add watery imperfections to the donut.
	local baysGrain  = 5;
	if (rDonut >= 10) then
		-- Use larger bays for larger donuts.
		baysGrain = 4;
	end
	--print("Bays grain " .. baysGrain);	
	local baysHeight = args.baysHeight or 74;
	local fracFlags  = {FRAC_WRAP_X = true, FRAC_POLAR = true};
	local baysFrac   = Fractal.Create(iW, iH, baysGrain, fracFlags, -1, -1);
	local iBaysThreshold = GetFractalHeight(baysFrac, baysHeight);
	
	-- Loop through plots in the donut's bounding box and add land
	-- to the plots that are part of the donut.
	for x = westX, eastX do
		local plotX = x % iW;
		local euclX = x;
		--print("Column " .. plotX);
	
		for y = southY, northY do		
			-- Use Euclidian distance so that donuts look circular despite hex tiles.
			-- If y is an odd row then account for hex-grid tile-shift.
			if ((y % 2) == 1) then
				euclX = x + 0.5;
			else
				euclX = x;
			end
			
			local deltaX = euclX - centerXEucl;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			
			-- Use rounded Euclidian distance to improve donut symmetry.
			local d = Round(math.sqrt(deltaXSquared + deltaYSquared));
						
			-- Convert cartesian coords to theta so that we can take a 
			-- slice of the donut.
			--
			-- Offset theta to the range [0,2pi]
			local theta = math.atan2(deltaX, deltaY) + math.pi + sliceOffset;
			if (theta > TAU) then
				theta = theta - TAU;
			end

			-- Check whether to add fractal water to this tile.
			local baysVal = baysFrac:GetHeight(x, y);
			
			if ((rHole < d) and (d <= rDonut) and
			    (IsInSlice(enableSlicing, theta, sliceLength) == true) and
				(baysVal < iBaysThreshold)) then
				-- Donut land.		
				local i = GetPlotIndexLua(plotX, y);
				
				island_plotTypes[i] = g_PLOT_TYPE_LAND;
				--print("Donut at " .. CoordString(deltaX,deltaY) .. " theta " .. theta);
			end
		end
	end
end

function GenerateMiniDonuts(args)
	-- Generate mini-donut islands
	-- Args:
	--   args.doInverted: if true, then adjust water levels for mini-donut lakes
	--   args.baysHeight: threshold for the mini-donut bays fractal
	--   args.numDonutsPerCell: how many donuts to add to each cell in the donut grid
	--   args.numExtraDonuts: how many donuts to add based on world size 
	--   args.numExtraDonutsMult: multiplier for the number of extra donuts to add
	--      anywhere on the map
	--   args.rMult: radius multiplier
	--   args.wrapX: whether east-west wrapping is enabled for the map
	-- Returns a map of generated island plot types.
	print("Generating mini-donuts.");
	
	local iW, iH, numTiles = GetMapGridSize();
	
	-- Args for mini-donuts.
	local args = args or {};
	
	-- Args to pass into the per-donut helper function.
	local donutArgs = {wrapX = args.wrapX};
	
	-- Some water-level settings reverse when we have inverted extras.
	local invertableSeaLevel  = UserInput.seaLevel;
	local lakeLevel           = UserInput.lakeLevel;
	
	if args.doInverted then
		-- Flip the water levels.
		print("Inverting sea level.");
		invertableSeaLevel = 6 - invertableSeaLevel;
	end	
	
	local island_PlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
		
	-- Donut integrity.
	-- higher number => more donut	
	donutArgs.baysHeight = args.baysHeight;
	--print("Bays Height ", donutArgs.baysHeight);

	-- Use a cell system to distribute donuts across the map.
	-- Divide the map into a dozen cells by default.
	local numCellColumns = 4;
	local numCellRows    = 3;
		
	-- Check the aspect ratio of the grid.
	local ratio   = iW / iH; -- We've got bigger problems if H is 0.
	local epsilon = 0.1;
	
	if (ratio > (4 - epsilon)) then
		-- Got a 4:1 grid.
		print("Using 7x2 donut grid (custom 4:1 aspect ratio)");
		numCellColumns = 7;
		numCellRows    = 2;
	
	elseif (ratio > (3 - epsilon)) then
		-- Got a 3:1 grid.
		print("Using 6x2 donut grid (custom 3:1 aspect ratio)");
		numCellColumns = 6;
		numCellRows    = 2;
		
	elseif (ratio > (2 - epsilon)) then
		-- Got a 2:1 grid.
		-- Use 5 columns instead of 4 so that donuts are smaller than bagels.
		print("Using 5x2 donut grid (custom 2:1 aspect ratio)");
		numCellColumns = 5;
		numCellRows    = 2;
		
	elseif (ratio < (1 + epsilon)) then
		-- Got a square
		print("Using 3x3 donut grid (custom 1:1 aspect ratio)");
		numCellColumns = 3;
		numCellRows    = 3;
	end
	
	local numTotalCells = numCellColumns * numCellRows;
	
	-- Donut radius range based on grid size, landmass, extras, and sea level.
	-- Use floating numbers here; will round when calculating radius.
	local cellWidth  = iW / numCellColumns;
	local cellHeight = iH / numCellRows;
	--print("Cell size (w,h): ",  CoordString(cellWidth, cellHeight));
	local cellLength = math.min(cellWidth, cellHeight);
	print("Cell length: " .. cellLength);
	-- Use cell size to determine the base radius range.
	local rMin = cellLength*0.25;
	local rMax = cellLength*0.4;
	print("Radius range based on cell length: ", CoordString(rMin, rMax));
	--
	local rMult = args.rMult or 1;
	rMin = math.max(1, Round(rMin * rMult));
	rMax = math.max(1, Round(rMax * rMult));
	print("Radius range with landmass & extras: ", CoordString(rMin, rMax));
	-- Offset radius range based on sea level.
	local rOffset = Round((rMax-rMin)/2);
	
	local seaMult = UP_TO_DOWN2[invertableSeaLevel] or 0;
	if (rOffset > 0) then
		-- Raise min radius to enlarge/shrink donuts based on sea level.
		rMin = rMin + (seaMult*rOffset);
	else
		rMax = rMax + seaMult;
	end
	rMax = math.max(rMin, rMax);
	print("Radius range with sea level: ", CoordString(rMin, rMax));
	donutArgs.rMin = rMin;
	donutArgs.rMax = rMax;
	
	-- Min/Max donut thickness as a percentage of radius, based on lake level.
	-- Higher lake level => higher thickness => smaller donut hole 
	--   => more land with which to generate fresh lakes.
	local tMins  = {20, 30, 40, 50, 60};
	local tMaxes = {40, 50, 60, 70, 80};
	local tMin = tMins[lakeLevel];
	local tMax = tMaxes[lakeLevel];
	print("Thickness range: ", CoordString(PercentString(tMin), PercentString(tMax)));
	donutArgs.tMin = tMin;
	donutArgs.tMax = tMax;

	-- Choose a random cell to let a donut "escape" to anywhere on the map.
	-- Makes the donut grid less obvious.
	local iEmptyCell = 1 + TerrainBuilder.GetRandomNumber(numTotalCells, "Empty mini-donut cell");
	
	-- Use a shuffled grid of donut types so that we can balance
	-- randomness with consistency between maps.
	local cellNotSliced = 0; -- Not sliced.
	local cellSliced    = 1; -- Randomly sliced.	
	local cellTypes = table.fill(cellNotSliced, numTotalCells);

	-- Percentage of sliced donut instead of unsliced donut.
	local slicedPct = 25;
	local numSlicedCells = math.clamp(0, numTotalCells, Round(numTotalCells*slicedPct/100));
	--print("Number of sliced cells: ", numSlicedCells);
	for i = 1, numSlicedCells do
		cellTypes[i] = cellSliced;
	end
	cellTypes = GetShuffledCopyOfTable(cellTypes);
		
	-- Add padding to cells to reduce overlap between donuts.
	-- Slightly less than rMax to make cell grid less obvious.
	local cellPaddingX = math.floor(math.clamp(donutArgs.rMax-1, 0, cellWidth/3));
	local cellPaddingY = math.floor(math.clamp(donutArgs.rMax-1, 0, cellHeight/3));
	--print("Cell padding: ", CoordString(cellPaddingX, cellPaddingY));

	local numDonutsPerCell = args.numDonutsPerCell or 2;
	print("Numer of donuts per cell: " .. numDonutsPerCell);
	
	-- Boundaries for the current cell.
	local iWestX  = 0;
	local iEastX  = 0;
	local iSouthY = 0;
	local iNorthY = 0;
	local iCell = 1;
	for iRow = 1, numCellRows do
		-- Advance to the next row.
		iEastX  = 0;
		iSouthY = iNorthY;
		iNorthY = math.floor(iRow * cellHeight);
	
		for iCol = 1, numCellColumns do
			-- Advance to the next column.
			iWestX = iEastX;
			iEastX = math.floor(iCol * cellWidth);
			
			for iDonutPerCell = 1, numDonutsPerCell do
			
				local donutX, donutY;
				
				if (iCell == iEmptyCell) then
					-- Empty cell: donut can be anywhere on the map.
					donutX = cellPaddingX + TerrainBuilder.GetRandomNumber(
						iW - 2*cellPaddingX, "Mini-Donut X (empty cell)");
					donutY = cellPaddingY + TerrainBuilder.GetRandomNumber(
						iH - 2*cellPaddingY, "Mini-Donut Y (empty cell)");
				else
					--print("Current cell is " .. 
					--      CoordString(iWestX, iSouthY) .. " to " .. 
					--      CoordString(iEastX, iNorthY));
				
					-- Choose a random location for the donut in the cell.
					donutX = iWestX + cellPaddingX + 
						TerrainBuilder.GetRandomNumber(
							iEastX  - iWestX - 2*cellPaddingX,  "Mini-Donut Cell X");
						
					donutY = iSouthY + cellPaddingY + 
						TerrainBuilder.GetRandomNumber(
							iNorthY - iSouthY - 2*cellPaddingY, "Mini-Donut Cell Y");
				end
				
				-- Check the cell grid to decide whether to slice this donut.
				donutArgs.enableSlicing = (cellTypes[iCell] == cellSliced);
					
				-- Generate the donut.
				GenerateMiniDonut(island_PlotTypes, donutX, donutY, donutArgs);
			end
			
			-- Advance to the next cell.
			iCell = iCell + 1;
		end
	end
		
	-- Place additional, smaller donuts anywhere on the map.
	local numExtraDonuts = args.numExtraDonuts or 10;
	local numExtraDonutsMult = args.numExtraDonutsMult or 1;
	numExtraDonuts = Round(numExtraDonuts * numExtraDonutsMult);
	
	print("Placing " .. numExtraDonuts .. " additional donut(s).");
	donutArgs.rMin = 1;
	donutArgs.rMax = math.max(1,Round(donutArgs.rMax/2));
	
	for iDonut = 1, numExtraDonuts do
		local donutX = cellPaddingX + TerrainBuilder.GetRandomNumber(
			iW - 2*cellPaddingX, "Mini-Donut X");
		local donutY = cellPaddingY + TerrainBuilder.GetRandomNumber(
			iH - 2*cellPaddingY, "Mini-Donut Y");
		
		-- Randomly decide whether to slice the extra donut.
		donutArgs.enableSlicing = 
		  (TerrainBuilder.GetRandomNumber(100, "Extra donut slicing.") < slicedPct);
		
		GenerateMiniDonut(island_PlotTypes, donutX, donutY, donutArgs);
	end
	
	--print("Done generating mini-donuts.");
	return island_PlotTypes;
end
---------------------------------------------------------------------------------------------------
-- Numerous Continents
--
-- Not actually an extra but part of the Numerous Continents landmass.
---------------------------------------------------------------------------------------------------
function GenerateNumerousLand(regionX, regionY, iW, iH, seaLevel, lakeLevel)
    -- Generate a single land for numerous continents/islands.
    local numTiles = iW * iH;
    local plotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
	
    -- Adjust fractal grain with lake level
    -- Higher grain => smaller pieces of land => more likely to form lakes
    local grains = {1, 1, 1, 2, 3};
	local grain = grains[lakeLevel] or 1;
		
	-- Generate the fractal.
	local fracXExp  = -1;
	local fracYExp  = -1;
    local fracFlags = {FRAC_POLAR = RandomBool()};
	local landFrac = Fractal.Create(iW, iH, grain, fracFlags, fracXExp, fracYExp);
	
    -- Adjust filter range to allow variation in fractal snakiness.
    -- Avoid the bottom 33rd percentile so that the pangea isn't just a big rectangle.
    local pctMin   = math.max(0, seaLevel-33);
    local pctRange = (seaLevel - pctMin) / 100;
    
    -- Adjust filter range based on lake level.
    -- Higher lake level => range further from top => noodlier fractal => bigger/more lakes.
    local pctRangeMults = {95, 90, 85, 85, 85};
    local pctRangeMult  = pctRangeMults[lakeLevel] or 85;
    pctMin = pctMin + Round(pctRangeMult * pctRange);
    
    local filterWidth   = 100 - seaLevel;
    local landBottomPct = pctMin;
    local landTopPct    = pctMin + filterWidth;
    
    print("Generating a " .. grain .. "-grain numerous-land fractal " ..
          "with percentile filtering at " .. landBottomPct .. " to " .. landTopPct);
    
	local landBottom = GetFractalHeight(landFrac, landBottomPct);
    local landTop    = GetFractalHeight(landFrac, landTopPct);
	
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = iW*y + x + 1;
			local landVal = landFrac:GetHeight(x, y);
			
			if ((landVal >= landBottom) and (landVal < landTop)) then
				plotTypes[i] = g_PLOT_TYPE_LAND;
			end
		end
	end
    
    -- Use pass maker to ensure that the land is a pangea.
    local bridgeArgs = 
	{
		obstaclesName 		= "water",
		plotTypes           = plotTypes,
        regionX             = regionX,
        regionY             = regionY,
        width               = iW,
        height              = iH,
		InitReachPlot 		= PassMaker.Water_InitReachPlot,
		RemoveObstacle      = PassMaker.Water_RemoveObstacle,
	};
    EnsureReachabilityWithPassMaker(bridgeArgs);
    
	return plotTypes;
end
---------------------------------------------------------------------------------------------------
-- Sprinkles
--
-- Originally the Tiny Islands landmass based off of the Tiny Islands map type from Civ V.
---------------------------------------------------------------------------------------------------
function GenerateSprinkles(inverted, fracFlags)
	-- Generate sprinkles of fractal extras
	-- Return a map of generated island plot types.
	print("Generating sprinkles.");
	
	local iW, iH, numTiles = GetMapGridSize();
	
	local invertableSeaLevel = UserInput.seaLevel;
	local seaLevels = {72,75,78,81,84};
	if (inverted == true) then
		-- The above levels are calibrated for islands.
		-- Reverse order for lakes.
		invertableSeaLevel = 6 - invertableSeaLevel;
		
	elseif (UserInput.landmass == Landmasses.NONE) then
		-- No landmass
		-- Lower the sea levels to make islands bigger.
		-- Increase the range of sea levels 
		-- to make sprinkles more responsive to sea level.
		seaLevels = {60,66,72,78,84};
	end
	
	-- Map sea levels to water percent thresholds.
	local seaLevel  = seaLevels[invertableSeaLevel] or 78;
		
	print("sprinkles sea level: ", seaLevel);
	
	local plotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
		
	-- Use high-grain fractal to produce tiny island sprinkles.
	local grain = 5;
		
	-- Generate the fractal.
	local fracXExp = -1;
	local fracYExp = -1;
	local landFrac = Fractal.Create(iW, iH, grain, fracFlags, fracXExp, fracYExp);
	
	local landBottom = GetFractalHeight(landFrac, seaLevel);
	
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			local landVal = landFrac:GetHeight(x, y);
			
			if (landVal >= landBottom) then
				plotTypes[i] = g_PLOT_TYPE_LAND;
			end
		end
	end
	return plotTypes;
end
---------------------------------------------------------------------------------------------------
-- Tectonic
--
-- Inspired by a barely-used flag that I saw in Civ V, these islands follow the user's selected 
-- mountain pattern. Uses a fractal to determine which mountains rise above the water.
---------------------------------------------------------------------------------------------------
function GenerateTectonicIslands(mainlandPlots, mtnPlots, coastPlots, args)
	-- Generate tectonic islands.
	-- Apply a fractal filter to the mountain pattern.
	--
	-- Args:
	--   mainlandPlots: a map of plots generated by the landmass.
	--   mtnPlots: a map of mountains or trenches generated by a mountain pattern
	--   coastPlots: a map of ocean tiles to turn into shallow water
	--   args.invertExtras: if true, then generate islands to convert into trenches.
	--   args.hillAdjust: hill height adjustment based on hill level
	--   args.mtnAdjust: mountain height adjustment based on mountain level
	--   args.tectonicFlags: flags for the tectonic islands fractal
	--   args.tectonicGrain: granularity of the tectonic islands fractal
	--   args.tectonicLandOffset: offset to adjust sea level (higher value => more land)
	--   args.tectonicSeaMultiplier: multiplier for the tectonic island fractal's sea-level
	-- Returns:
	--   plotTypes: a map of plots such that land represents tectonic islands/lakes
	print("Generating tectonic extras.");

	local iW, iH, numTiles = GetMapGridSize();
    
    local noHills     = UserInput.noHills;
    local noMountains = UserInput.noMountains;

	local plotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
	
	local args = args or {};	
		
	local flags      = args.tectonicFlags  or {};
	local grain      = args.tectonicGrain  or 2;
	
	-- Add a tectonic fractal layer to govern mountains replacing water tiles.
	local fracXExp = -1;
	local fracYExp = -1;
	local tectonicFrac = Fractal.Create(iW, iH, grain, flags, fracXExp, fracYExp);
		
	local invertExtras = args.invertExtras;
	local srcPlotMatch = g_PLOT_TYPE_MOUNTAIN;
	
	if invertExtras then		
		-- Prevents overwriting mountain ranges with water.
		srcPlotMatch = g_PLOT_TYPE_OCEAN;
	end	
		
	-- Determine how much of the world's water to turn into islands.
	local flatLevel = 25;
	
	-- Higher sea level => lower percentage of the world for islands.
	local seaLevel = DOWN_TO_UP2[UserInput.seaLevel];
	
	local tecSeaMultiplier = args.tectonicSeaMultiplier  or 1;
	seaLevel = seaLevel * tecSeaMultiplier;
	
	flatLevel = flatLevel - (seaLevel * 2.5);
	
	-- Adding tectonic islands/trenches as extras
	if (ExtrasGot.everything == true) then
		-- Got "everything" for extras.
		-- Reduce islands to make room for other types of extras.
		flatLevel = 0.6 * flatLevel;
		
	elseif (ExtrasGot.tecAndChains == true) then
		-- Got "tectonic and chains" for extras.
		-- Reduce islands to make room for other extras.
		flatLevel = 0.8 * flatLevel;
	end
	
	-- Offset thresholds for certain extras-oriented landmasses.
	local landmassOffset  = args.tectonicLandOffset or 0;
	flatLevel = flatLevel * (1 + landmassOffset);
	
	-- Determine how much of the land to turn into hills and mountains.
	local mtnAdjust = args.mtnAdjust;
	local hillAdjust = args.hillAdjust;
	local mtnLevel  = flatLevel * mtnAdjust/100;
	local hillLevel = flatLevel * hillAdjust/100;
	
	local iMtnBase  = 100 - mtnLevel;
	local iHillBase = iMtnBase - hillLevel;
	local iFlatBase = 100 - flatLevel;
	
	print("iMtnBase: ", iMtnBase);
	print("iHillBase: ", iHillBase);
	print("iFlatBase: ", iFlatBase);
	
	-- Thresholds at which mountains rise above the surface of the ocean.
	local name  = "tectonic islands";
	local iMtn  = GetFractalHeight(tectonicFrac, iMtnBase,  name);
	local iHill = GetFractalHeight(tectonicFrac, iHillBase, name);
	local iFlat = GetFractalHeight(tectonicFrac, iFlatBase, name);
	
	-- Count # of mts, hills, islands added
	local numMts   = 0;
	local numHills = 0;
	local numFlats = 0;
		
	-- Apply mountain plot types to the main map.
	for x = 0, iW - 1, 1 do
		for y = 0, iH - 1, 1 do
			local i = GetPlotIndexLua(x,y);
			
			local isMatch = (mtnPlots[i] == srcPlotMatch);
			if (not isMatch) then
				-- Check adjacent plots for a match to expand tectonic islands.
				for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
					local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
					if (adjacentPlot ~= nil) then
						local iAdj = GetPlotIndexLua(adjacentPlot:GetX(), adjacentPlot:GetY());
						if (mtnPlots[iAdj] == srcPlotMatch) then
							isMatch = true;
						end
					end
				end
			end

			if (isMatch and (invertExtras or (mainlandPlots[i] == g_PLOT_TYPE_OCEAN))) then
				-- Match from the mountain pattern
				-- Avoid overwriting the mainland with tectonic islands.
				local tectonicVal = tectonicFrac:GetHeight(x,y);
			
				-- Use a fractal to decide which mountains rise above the water.
				if (tectonicVal >= iMtn) then
                    if not noMountains then
                        -- Replace a water tile with a mountain.
                        plotTypes[i] = g_PLOT_TYPE_MOUNTAIN;
                        numMts = numMts + 1;
                    end
					
				elseif (tectonicVal >= iHill) then
                    if not noHills then
                        -- Replace a water tile with a hill.
                        plotTypes[i] = g_PLOT_TYPE_HILLS;
                        numHills = numHills + 1;
                    end
				
				elseif (tectonicVal >= iFlat) then
					-- Replace a water tile with flat land
					plotTypes[i] = g_PLOT_TYPE_LAND;
					numFlats = numFlats + 1;
				end
			end
		end
	end
		
	-- Higher coastal expansion => more shallow water from mountains
	local coastLevels = {0, 15, 30, 45, 60, 75, 100};
	coastLevel = coastLevels[UserInput.coastExp];
	
	local mtnThresh = GetFractalHeight(tectonicFrac, coastLevel);
	local shallowCount = 0;
	
	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local i = GetPlotIndexLua(iX,iY);
			if (coastPlots[i] == g_PLOT_TYPE_OCEAN) then
				-- Check mountain and tectonic island maps, 
				-- decide whether to add shallow water for submerged mountain
				
				if ((plotTypes[i] == g_PLOT_TYPE_OCEAN) and 
				    (mtnPlots[i] == g_PLOT_TYPE_MOUNTAIN)) then
					-- A submerged mountain from the mountain pattern.
					
					local tectonicVal = tectonicFrac:GetHeight(iX,iY);
					if (tectonicVal <= mtnThresh) then
						-- Land in the coast map counts as coast later in map-gen.
						coastPlots[i] = g_PLOT_TYPE_LAND;
						shallowCount = shallowCount + 1;
					end
				end
			end
		end
	end
	
	-- Note: coastal mountains may become hills during feature generation.
	print("Tectonic tiles added: ");
	print("  Mtns:     ", numMts);
	print("  Hills:    ", numHills);
	print("  Flats:    ", numFlats);
	print("  Shallows: ", shallowCount);
	
	return plotTypes;
end
---------------------------------------------------------------------------------------------------
-- Merging onto the landmass
---------------------------------------------------------------------------------------------------
function MergeChains(destPlotTypes, srcPlotTypes)
	-- Merge chains onto a map, allowing land and possibly adjacent water 
	-- from the source to overwrite plots from the destination.
	--
	-- Do this before adding mountains and hills.
	-- 
	-- args:
	--   destPlotTypes: destination for merged extras
	--   srcPlotTypes: extras to merge
	
	--print("Merging chains.");
	local iW, iH = GetMapGridSize();
	
	local sea_thresholds = {35, 30, 20, 10,  5}; --{10, 20, 30};
	local adj_thresholds = {75, 80, 85, 90, 95, 100};
	
	local sea_level = UserInput.seaLevel;
	
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local iPlot = GetPlotIndexLua(x,y);
				
			local srcPlotType = srcPlotTypes[iPlot];
			
			if (srcPlotType ~= g_PLOT_TYPE_OCEAN) then
				-- Something to merge.
				local dice = TerrainBuilder.GetRandomNumber(100,"Chains isle exclusion");
				if (dice < sea_thresholds[sea_level]) then
					-- Occasionally add land from island chains for inversion.
					destPlotTypes[iPlot] = srcPlotType;
				end
			else
				-- Check for adjacent land.
				local numAdjacentLands = 0;
				for i, direction in ipairs(HexDirections) do
					local adjacentPlot = Map.GetAdjacentPlot(x, y, direction);
					
					if (adjacentPlot ~= nil) then
						-- We have an adjacent plot.
						-- Let's see if it's unvisited.
						local aX, aY = adjacentPlot:GetX(), adjacentPlot:GetY();
						local iCouldVisit = GetPlotIndexLua(aX,aY);
					
						if (srcPlotTypes[iCouldVisit] ~= g_PLOT_TYPE_OCEAN) then
							-- Adjacent to land.
							numAdjacentLands = numAdjacentLands + 1;
						end
					end
				end
				
				if (numAdjacentLands > 0) then
					-- This tile is adjacent to an island chain.
					local dice = TerrainBuilder.GetRandomNumber(100,"Chains expansion");		
					if (dice < adj_thresholds[numAdjacentLands]) then
						-- Pretend that coastal water is part of the island chain.
						-- This adds water to inverted chains.
						destPlotTypes[iPlot] = g_PLOT_TYPE_LAND;
					end
				end
			end
		end
	end
	
	--print("Done merging lake chains.");
end

function MergeExtras(mergeLand, destPlotTypes, srcPlotTypes)
	-- Merge extras onto a map, allowing all land from the source to 
	-- overwrite plots from the destination.
	--
	-- Do this before adding mountains and hills.
	-- 
	-- args:
	--   mergeLand: whether to merge as land (true) or as water (false)
	--   destPlotTypes: destination for merged extras
	--   srcPlotTypes: extras to merge
	local iW, iH = GetMapGridSize();
	
	if (mergeLand == false) then
		print("Merging extra lakes to the landmass.");
	end
	
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local iPlot = GetPlotIndexLua(x,y);
			local srcPlotType = srcPlotTypes[iPlot];
			
			if (srcPlotType ~= g_PLOT_TYPE_OCEAN) then
				-- Something to merge.
				if (mergeLand == true) then	
					-- Merge the extra land as-is.
					destPlotTypes[iPlot] = srcPlotType;
				else
					-- Turn the extra land into a body of water.
					destPlotTypes[iPlot] = g_PLOT_TYPE_OCEAN;
				end				
			end
		end
	end
end

function MergeExtrasAvoidLandmass(mergeLand, destPlotTypes, srcPlotTypes)
	-- Add extras without touching landmass land.
	-- Island landmasses use this to avoid combining islands into bigger chunks of land.
	--
	-- args:
	--   mergeLand: whether to merge land (true) or water (false)
	--   destPlotTypes: destination for merged extras
	--   srcPlotTypes: extras to merge		
	if (mergeLand == false) then
		-- We're adding water, so landmass will not get bigger.
		MergeExtras(mergeLand, destPlotTypes, srcPlotTypes);
		return;
	end
	
	print("Merging extras without touching the landmass.");
	
	local iW, iH = GetMapGridSize();

	-- Filter the source map to avoid touching the destination map's land.
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if ( (srcPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) and
				 ((destPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) or 
					IsAdjacentToLand(destPlotTypes, x, y)) ) then
				-- An extra-island plot is overlapping or touching 
				-- the landmass land. So erase the island plot.
				srcPlotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
	
	-- Merge the filtered source map.
	MergeExtras(mergeLand, destPlotTypes, srcPlotTypes);
end

function MergeExtrasAvoidLandmassCoast(mergeLand, destPlotTypes, srcPlotTypes)
	-- Add extras without connecting extras coast with landmass coast.
	--
	-- args:
	--   mergeLand: whether to merge land (true) or water (false)
	--   destPlotTypes: destination for merged extras
	--   srcPlotTypes: extras to merge
	print("Merging extras/freshening without expanding the landmass coast.");
		
	if (mergeLand == false) then
		-- We're adding water, so landmass will not get bigger.
		MergeExtras(mergeLand, destPlotTypes, srcPlotTypes);
		return;
	end
	
	local iW, iH, numTiles = GetMapGridSize();

	-- Create a reference map to make it easier to tell whether
	-- an extras coast touches landmass coast.
	-- Represent both landmass and landmass coastal water as land.
	local expandedDestPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			
			if (destPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
				-- Landmass plot.
				expandedDestPlotTypes[i] = destPlotTypes[i];
			elseif IsAdjacentToLand(destPlotTypes, x, y) then
				-- Landmass coast.
				expandedDestPlotTypes[i] = g_PLOT_TYPE_LAND;
			end
		end
	end
	
	-- Another pass to wrap a 2nd layer of land around the landmass reference.
	local doubleDestPlotTypes = table.fill(g_PLOT_TYPE_OCEAN, numTiles);
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			
			if (expandedDestPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) then
				-- Expanded landmass plot.
				doubleDestPlotTypes[i] = expandedDestPlotTypes[i];
			elseif IsAdjacentToLand(expandedDestPlotTypes, x, y) then
				-- Expanded landmass coast.
				doubleDestPlotTypes[i] = g_PLOT_TYPE_LAND;
			end
		end
	end

	-- Filter the source map to avoid touching the destination map's land.
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if ( (srcPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) and
				 ((doubleDestPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) or 
					IsAdjacentToLand(doubleDestPlotTypes, x, y)) ) then
					
				-- An extra-island plot is within 3 plots of
				-- the landmass land. So erase the island plot.
				srcPlotTypes[i] = g_PLOT_TYPE_OCEAN;
			end
		end
	end
	
	-- Merge the filtered source map.
	MergeExtras(mergeLand, destPlotTypes, srcPlotTypes);
end

function MergeExtrasPreserveSaltLakes(mergeLand, destPlotTypes, srcPlotTypes)
	-- Add extras without freshening lakes.
	--
	-- args:
	--   mergeLand: whether to merge land (true) or water (false)
	--   destPlotTypes: destination for merged extras
	--   srcPlotTypes: extras to merge

	print("Merging extras, but preserving salty lakes.");
	
	if (mergeLand == false) then
		-- We're adding water, so lakes will stay salty.
		MergeExtras(mergeLand, destPlotTypes, srcPlotTypes);
		return;
	end	
	
	local iW, iH = GetMapGridSize();
	
	-- The max size of a lake that could become three fresh water lakes
	-- if we added an island.
	local waterAreaThresh = 3*LAKE_MAXNUMTILES + 1;


	-- Apply island data to the main plot data.
	local numTilesAdded = 0;

	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = GetPlotIndexLua(x,y);
			if ((srcPlotTypes[i] ~= g_PLOT_TYPE_OCEAN) and
				(destPlotTypes[i] == g_PLOT_TYPE_OCEAN)) then
				local waterArea = GetWaterArea(destPlotTypes, x, y);
			
				-- Only add islands to sufficiently-large lakes.
				if (waterArea > waterAreaThresh) then
					destPlotTypes[i] = srcPlotTypes[i];
					numTilesAdded = numTilesAdded+1;
				end
			end
		end
	end	
	
	print("Added " .. numTilesAdded .. " land tile(s) for extras.");
end
