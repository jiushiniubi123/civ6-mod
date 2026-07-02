-- 6T_AGP_Icons
-- Author: JNR
--------------------------------------------------------------

-- IconTextureAtlases
--------------------------------------------------------------	
INSERT INTO IconTextureAtlases	
		(Name,									IconSize,	IconsPerRow,	IconsPerColumn,	Filename)
VALUES	('ICON_ATLAS_JNR_AGP_RESOURCES',		256,	 	1,				1,				'6T_AGP_Resources256.dds'),
		('ICON_ATLAS_JNR_AGP_RESOURCES',		64,	 		1,				1,				'6T_AGP_Resources64.dds'),
		('ICON_ATLAS_JNR_AGP_RESOURCES',		50,	 		1,				1,				'6T_AGP_Resources50.dds'),
		('ICON_ATLAS_JNR_AGP_RESOURCES',		38,	 		1,				1,				'6T_AGP_Resources38.dds'),
		('ICON_ATLAS_JNR_AGP_RESOURCES_FOW',	256,	 	1,				1,				'6T_AGP_Resources256_FOW.dds');

INSERT INTO IconTextureAtlases	
		(Name,									IconSize,	IconsPerRow,	IconsPerColumn,	Filename,					Baseline)
VALUES  ('ICON_ATLAS_JNR_AGP_RESOURCES',		22,	 		1,				1,				'6T_AGP_Resources22.dds',	6);
--------------------------------------------------------------

-- IconDefinitions
--------------------------------------------------------------	
INSERT INTO IconDefinitions	
		(Name,									Atlas, 								'Index')
VALUES	('RESOURCE_JNR_MUREX',					'ICON_ATLAS_JNR_AGP_RESOURCES',		0),
		('ICON_RESOURCE_JNR_MUREX',				'ICON_ATLAS_JNR_AGP_RESOURCES',		0),
		('ICON_RESOURCE_JNR_MUREX_FOW',			'ICON_ATLAS_JNR_AGP_RESOURCES_FOW',	0),
		
		('ICON_GREATWORK_JNR_EN_HEDU_ANNA_1',	'ICON_ATLAS_GREATWORKS',			0),
		('ICON_GREATWORK_JNR_EN_HEDU_ANNA_2',	'ICON_ATLAS_GREATWORKS',			0),
		('ICON_GREATWORK_JNR_PTAHHOTEP_1',		'ICON_ATLAS_GREATWORKS',			0),
		('ICON_GREATWORK_JNR_PTAHHOTEP_2',		'ICON_ATLAS_GREATWORKS',			0);
--------------------------------------------------------------