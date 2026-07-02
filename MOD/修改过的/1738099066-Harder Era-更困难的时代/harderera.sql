UPDATE Moments SET EraScore = 2 WHERE EraScore = 1 AND InterestLevel > 1;
UPDATE Moments SET EraScore = EraScore - 1 WHERE EraScore > 0;


