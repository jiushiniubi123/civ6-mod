-- Super Spy Promotions --
-- Author: Das_Capitolin --
----------------------------------------------------------------------------------------------------

-- Global Parameters (Value=TEXT NOT NULL)--
UPDATE GlobalParameters
SET    Value = '4' -- Default Value = 4 (All values beyond this yield -1, so 7 yields 6.)
WHERE  Name = 'ESPIONAGE_MAX_LEVEL';
INSERT INTO Modifiers
            (ModifierId,ModifierType,RunOnce,Permanent,OwnerRequirementSetId,
             SubjectRequirementSetId)
VALUES      ('ESPIONAGE_ANY_PROMOTION',
             'MODIFIER_PLAYER_UNIT_GRANT_UNLIMITED_PROMOTION_CHOICES'
             ,0,1,NULL,NULL);

INSERT INTO ModifierArguments
            (ModifierId,Name,Value)
VALUES      ('ESPIONAGE_ANY_PROMOTION','UnitType','UNIT_SPY');

INSERT INTO TraitModifiers
            (TraitType,ModifierId)
VALUES      ('TRAIT_LEADER_MAJOR_CIV','ESPIONAGE_ANY_PROMOTION'); 

UPDATE GlobalParameters
SET    Value = '2'
WHERE  Name = 'ESPIONAGE_BONUS_GAIN_SOURCES'; -- Default Value = 2

UPDATE GlobalParameters
SET    Value = '10'
WHERE  Name = 'ESPIONAGE_ESCAPE_BASE_CHANCE'; -- Default Value = 10

UPDATE GlobalParameters
SET    Value = '-1'
WHERE  Name = 'ESPIONAGE_ESCAPE_COUNTERSPY_LEVEL_MODIFIER'; -- Default Value = -1

UPDATE GlobalParameters
SET    Value = '1'
WHERE  Name = 'ESPIONAGE_ESCAPE_LEVEL_BOOST'; -- Default Value = 1

UPDATE GlobalParameters
SET    Value = '-4'
WHERE  Name = 'ESPIONAGE_ESCAPE_POLICE_CORRECT_MODIFIER'; -- Default Value = -4

UPDATE GlobalParameters
SET    Value = '3'
WHERE  Name = 'ESPIONAGE_GAIN_SOURCES_DURATION_MULTIPLIER'; -- Default Value = 3