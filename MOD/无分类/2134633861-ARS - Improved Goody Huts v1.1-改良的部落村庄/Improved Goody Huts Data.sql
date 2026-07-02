-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Improved Goody Huts Data v1.1
-- Author: Arstahd
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Goody Hut frequency : Default 128 , 3.
--UPDATE Improvements SET TilesPerGoody = 64, GoodyRange = 2 WHERE ImprovementType = 'IMPROVEMENT_GOODY_HUT';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Goody Hut Type weighting. Default = 100. 0 = disable. Other values don't seem to have as much effect as one would expect.
--UPDATE GoodyHuts SET Weight = 70 WHERE GoodyHutType = 'GOODYHUT_MILITARY';
--UPDATE GoodyHuts SET Weight = 100 WHERE GoodyHutType = 'GOODYHUT_SURVIVORS';
--UPDATE GoodyHuts SET Weight = 150 WHERE GoodyHutType = 'GOODYHUT_GOLD';
--UPDATE GoodyHuts SET Weight = 150 WHERE GoodyHutType = 'GOODYHUT_FAITH';
--UPDATE GoodyHuts SET Weight = 100 WHERE GoodyHutType = 'GOODYHUT_CULTURE';
--UPDATE GoodyHuts SET Weight = 100 WHERE GoodyHutType = 'GOODYHUT_SCIENCE';
--UPDATE GoodyHuts SET Weight = 100 WHERE GoodyHutType = 'GOODYHUT_DIPLOMACY';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  New Rewards

--  Goody Hut Subtypes
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, Turn, MinOneCity, RequiresUnit, ModifierID) VALUES 
		('GOODYHUT_MILITARY', 'GOODYHUT_GRANT_SLINGER', 'LOC_GOODYHUT_MILITARY_GRANT_SLINGER_DESCRIPTION', 25, 0, 1, 0, 'GOODY_MILITARY_GRANT_SLINGER'),
		('GOODYHUT_MILITARY', 'GOODYHUT_GRANT_WARRIOR', 'LOC_GOODYHUT_MILITARY_GRANT_WARRIOR_DESCRIPTION', 25, 0, 1, 0, 'GOODY_MILITARY_GRANT_WARRIOR'),
		('GOODYHUT_SURVIVORS', 'GOODYHUT_ADD_POP_2', 'LOC_GOODYHUT_SURVIVORS_ADD_POP_DESCRIPTION', 10, 0, 1, 0, 'GOODY_SURVIVORS_ADD_POPULATION_2'),
		('GOODYHUT_GOLD', 'GOODYHUT_HUGE_GOLD', 'LOC_GOODYHUT_LARGE_GOLD_DESCRIPTION', 10, 0, 0, 0, 'GOODY_GOLD_HUGE_MODIFIER'),
		('GOODYHUT_FAITH', 'GOODYHUT_HUGE_FAITH', 'LOC_GOODYHUT_LARGE_FAITH_DESCRIPTION', 10, 0, 0, 0, 'GOODY_FAITH_HUGE_MODIFIER'),
		('GOODYHUT_CULTURE', 'GOODYHUT_ONE_CIVIC', 'LOC_GOODYHUT_ONE_CIVIC_DESCRIPTION', 20, 0, 1, 0, 'GOODY_CULTURE_GRANT_ONE_CIVIC'),
		('GOODYHUT_SCIENCE', 'GOODYHUT_SCIENCE_RELIC', 'LOC_GOODYHUT_SCIENCE_RELIC_DESCRIPTION', 10, 0, 1, 0, 'GOODY_CULTURE_GRANT_ONE_RELIC');
--  For expansion games
INSERT INTO GoodyHutSubTypes (GoodyHut, SubTypeGoodyHut, Description, Weight, Turn, MinOneCity, RequiresUnit, ModifierID) SELECT 
		'GOODYHUT_DIPLOMACY', 'GOODYHUT_ENVOY_2', 'LOC_GOODYHUT_DIPLOMACY_ENVOY_DESCRIPTION', 30, 0, 0, 0, 'GOODY_DIPLOMACY_GRANT_ENVOY_2' WHERE EXISTS (SELECT 1 FROM Types WHERE Type = 'GOODYHUT_DIPLOMACY');

--  Modifiers
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES 
		('GOODY_MILITARY_GRANT_SLINGER', 'MODIFIER_SINGLE_CITY_GRANT_UNIT_BY_CLASS_IN_NEAREST_CITY', 1, 1),
		('GOODY_MILITARY_GRANT_WARRIOR', 'MODIFIER_SINGLE_CITY_GRANT_UNIT_BY_CLASS_IN_NEAREST_CITY', 1, 1),
		('GOODY_SURVIVORS_ADD_POPULATION_2', 'MODIFIER_PLAYER_NEAREST_CITY_ADD_POPULATION', 1, 1),
		('GOODY_GOLD_HUGE_MODIFIER', 'MODIFIER_PLAYER_GRANT_YIELD', 1, 1),
		('GOODY_FAITH_HUGE_MODIFIER', 'MODIFIER_PLAYER_GRANT_YIELD', 1, 1),
		('GOODY_CULTURE_GRANT_ONE_CIVIC', 'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC', 1, 1),
		('GOODY_DIPLOMACY_GRANT_ENVOY_2', 'MODIFIER_PLAYER_GRANT_INFLUENCE_TOKEN', 1, 1);

--  Modifier Arguments
INSERT INTO ModifierArguments (ModifierId, Name, Value, Extra) VALUES 
		('GOODY_MILITARY_GRANT_SLINGER', 'UnitPromotionClassType', 'PROMOTION_CLASS_RANGED', NULL),
		('GOODY_MILITARY_GRANT_WARRIOR', 'UnitPromotionClassType', 'PROMOTION_CLASS_MELEE', NULL),
		('GOODY_SURVIVORS_ADD_POPULATION_2', 'Amount', 2, NULL),
		('GOODY_GOLD_HUGE_MODIFIER', 'Amount', 250, NULL),
		('GOODY_GOLD_HUGE_MODIFIER', 'YieldType', 'YIELD_GOLD', NULL),
		('GOODY_GOLD_HUGE_MODIFIER', 'Scale', 1, NULL),
		('GOODY_FAITH_HUGE_MODIFIER', 'Amount', 250, NULL),
		('GOODY_FAITH_HUGE_MODIFIER', 'YieldType', 'YIELD_FAITH', NULL),
		('GOODY_FAITH_HUGE_MODIFIER', 'Scale', 1, NULL),
		('GOODY_CULTURE_GRANT_ONE_CIVIC', 'Amount', 1, -1),
		('GOODY_DIPLOMACY_GRANT_ENVOY_2', 'Amount', 2, NULL);

--  Expansion Table
CREATE TABLE IF NOT EXISTS GoodyHutSubTypes_XP2 (SubTypeGoodyHut VARCHAR, CityState BOOLEAN, StrategicResources BOOLEAN);

--  Expansion Parameters
INSERT INTO GoodyHutSubTypes_XP2 (SubTypeGoodyHut, CityState, StrategicResources) VALUES ('GOODYHUT_ENVOY_2', 1, 0);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  MILITARY REWARDS
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_EXPERIENCE';
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_WARRIOR';
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_SLINGER';
UPDATE GoodyHutSubTypes SET Weight = 80, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_SCOUT';

UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_HEAL';					-- REMOVED
UPDATE GoodyHutSubTypes SET Weight = 40, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_RESOURCES';				-- REMOVED

--  MILITARY QUANTITY
UPDATE ModifierArguments SET 'Value' = 100 WHERE ModifierID = 'GOODY_MILITARY_GRANT_EXPERIENCE';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  SURVIVORS REWARDS
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_SETTLER'; 
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ADD_POP_2';
UPDATE GoodyHutSubTypes SET Weight = 60, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_BUILDER';
UPDATE GoodyHutSubTypes SET Weight = 30, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ADD_POP';

UPDATE GoodyHutSubTypes SET Weight = 30, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_GRANT_TRADER';			-- REMOVED
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  GOLD REWARDS
UPDATE GoodyHutSubTypes SET Weight = 30, Turn = 40, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_HUGE_GOLD';
UPDATE GoodyHutSubTypes SET Weight = 30, Turn = 20, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_LARGE_GOLD';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_MEDIUM_GOLD';
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 0, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_SMALL_GOLD';

--  GOLD QUANTITY
UPDATE ModifierArguments SET Value = 300 WHERE ModifierID = 'GOODY_GOLD_HUGE_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 160 WHERE ModifierID = 'GOODY_GOLD_LARGE_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 150 WHERE ModifierID = 'GOODY_GOLD_MEDIUM_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 80 WHERE ModifierID = 'GOODY_GOLD_SMALL_MODIFIER' AND Name = 'Amount';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  FAITH REWARDS
UPDATE GoodyHutSubTypes SET Weight = 40, Turn = 40, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_HUGE_FAITH';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_LARGE_FAITH';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_MEDIUM_FAITH';
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 20, MinOneCity = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_SMALL_FAITH';

--  FAITH QUANTITY
UPDATE ModifierArguments SET Value = 150 WHERE ModifierID = 'GOODY_FAITH_HUGE_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 150 WHERE ModifierID = 'GOODY_FAITH_LARGE_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 100 WHERE ModifierID = 'GOODY_FAITH_MEDIUM_MODIFIER' AND Name = 'Amount';
UPDATE ModifierArguments SET Value = 80 WHERE ModifierID = 'GOODY_FAITH_SMALL_MODIFIER' AND Name = 'Amount';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  CULTURE REWARDS
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ONE_RELIC';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ONE_CIVIC';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_TWO_CIVIC_BOOSTS';
UPDATE GoodyHutSubTypes SET Weight = 90, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ONE_CIVIC_BOOST';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  SCIENCE REWARDS
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_SCIENCE_RELIC';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ONE_TECH';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_TWO_TECH_BOOSTS';
UPDATE GoodyHutSubTypes SET Weight = 90, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ONE_TECH_BOOST';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  DIPLOMACY REWARDS
UPDATE GoodyHutSubTypes SET Weight = 10, Turn = 50 WHERE SubTypeGoodyHut = 'GOODYHUT_GOVERNOR_TITLE';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ENVOY_2';
UPDATE GoodyHutSubTypes SET Weight = 0, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_FAVOR';
UPDATE GoodyHutSubTypes SET Weight = 90, Turn = 0 WHERE SubTypeGoodyHut = 'GOODYHUT_ENVOY';

--  DIPLOMACY QUANTITY
UPDATE ModifierArguments SET 'Value' = 10 WHERE ModifierID = 'GOODY_DIPLOMACY_GRANT_FAVOR';
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




