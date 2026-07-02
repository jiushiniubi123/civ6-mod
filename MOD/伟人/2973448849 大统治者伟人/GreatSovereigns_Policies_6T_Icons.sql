--==========================================================================================================================
-- ICONS
--==========================================================================================================================
-- IconTextureAtlases
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO IconTextureAtlases	
		(Name,												IconSize,	IconsPerRow,	IconsPerColumn,	 Filename)
VALUES	('ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',			256,	 	1,				1,				 'PLATI_GAPolicies256.dds'),
		('ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',			50,	 		1,				1,				 'PLATI_GAPolicies50.dds'),
		('ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',			38,	 		1,				1,				 'PLATI_GAPolicies38.dds');
--------------------------------------------------------------------------------------------------------------------------
-- IconDefinitions
--------------------------------------------------------------------------------------------------------------------------	
INSERT OR REPLACE INTO IconDefinitions			
		(Name,										Atlas, 							 'Index')
VALUES	--Great Sovereigns																	 
		('ICON_POLICY_DIPLO_SOVER_POINTS_6T', 	'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_OLIGARCHY', 			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_AUTOCRACY', 			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_ABSOLUTE', 			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_REVOLUTIONARY', 		'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_COMMONWEALTH', 		'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_COMMUNIST', 			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_FASCIST', 				'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_DEMOCRAT', 			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0),
		('ICON_POLICY_6T_CLASSICAL',  			'ICON_ATLAS_PLATI_SOVEREIGN_6T_POLICIES',	 0);
--==========================================================================================================================
--==========================================================================================================================