--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO IconTextureAtlases	
		(Name,									IconSize,	IconsPerRow,	IconsPerColumn,	 Filename)
VALUES	('ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',			256,	 	1,				1,				 'PLATI_GAPolicies256.dds'),
		('ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',			50,	 		1,				1,				 'PLATI_GAPolicies50.dds'),
		('ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',			38,	 		1,				1,				 'PLATI_GAPolicies38.dds');
--------------------------------------------------------------------------------------------------------------------------
-- IconDefinitions
--------------------------------------------------------------------------------------------------------------------------	
INSERT OR REPLACE INTO IconDefinitions			
		(Name,										Atlas, 							 'Index')
VALUES	--Great Sovereigns																	 
		('ICON_POLICY_THEOCRACY_SOV_CARD', 			'ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',	 0),
		('ICON_POLICY_PLUTOCRACY_SOV_CARD', 		'ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',	 0),
		('ICON_POLICY_DIPLO_SOVER_POINTS',  		'ICON_ATLAS_PLATI_SOVEREIGN_POLICIES',	 0);
--==========================================================================================================================
--==========================================================================================================================