-- GameData1
-- Author: Lazire
-- DateCreated: 9/19/2023 2:15:45 AM
--------------------------------------------------------------
UPDATE Maps SET NumNaturalWonders = 5 WHERE MapSizeType = 'MAPSIZE_TINY';
UPDATE Maps SET NumNaturalWonders = 7 WHERE MapSizeType = 'MAPSIZE_SMALL';
UPDATE Maps SET NumNaturalWonders = 10 WHERE MapSizeType = 'MAPSIZE_STANDARD';
UPDATE Maps SET NumNaturalWonders = 12 WHERE MapSizeType = 'MAPSIZE_LARGE';
UPDATE Maps SET NumNaturalWonders = 18 WHERE MapSizeType = 'MAPSIZE_HUGE';