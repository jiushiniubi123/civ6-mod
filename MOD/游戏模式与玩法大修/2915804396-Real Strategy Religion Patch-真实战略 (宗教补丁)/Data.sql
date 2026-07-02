UPDATE PseudoYields SET DefaultValue = 0.75
WHERE PseudoYieldType = 'PSEUDOYIELD_GPP_PROPHET';

-- CLASSICAL_ERA

UPDATE AiFavoredItems SET ListType = 'MedievalPseudoYields'
WHERE Item = 'PSEUDOYIELD_GPP_PROPHET' AND ListType = 'ClassicalPseudoYields';

DELETE FROM AiFavoredItems
WHERE Item = 'YIELD_FAITH' AND ListType = 'ClassicalYields';

-- VICTORY_STRATEGY

UPDATE AiFavoredItems SET Value = 10
WHERE Item = 'PSEUDOYIELD_GPP_PROPHET' AND ListType = 'CultureVictoryPseudoYields';

UPDATE AiFavoredItems SET Value = 15
WHERE Item = 'YIELD_FAITH' AND ListType = 'CultureVictoryYields';
