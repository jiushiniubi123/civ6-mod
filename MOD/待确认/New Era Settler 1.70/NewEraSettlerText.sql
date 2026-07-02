-- New Era Settler -- 1.70
-- Author: Das_Capitolin --
----------------------------------------------------------------------------------------------------

UPDATE LocalizedText
SET    Text = REPLACE(Text, '1', '3') -- Updates the Settler tooltip to display cost of 3 population, not 1.
WHERE  Tag = 'LOC_UNIT_SETTLER_DESCRIPTION'; 