-- this should be balanced with iPercentageDeletedCityStates in AssignStartingPlots.lua

UPDATE MapSizes SET DefaultCityStates = ROUND( DefaultCityStates * 1.5 );
UPDATE MapSizes SET MinCityStates = ROUND( MinCityStates * 1.5 );
UPDATE MapSizes SET MaxCityStates = ROUND( MaxCityStates * 1.5 );