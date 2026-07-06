--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
INSERT INTO IconTextureAtlases
		(Name, 										IconSize,	Baseline,	Filename, 									IconsPerRow, 	IconsPerColumn)
VALUES	('ICON_GAMEMODE_SUK_URBANIDENTITIES',		64,			0,			'ICON_GAMEMODE_SUK_URBANIDENTITIES',		3,				1),
		('ICON_CIVILOPEDIA_SUK_URBANIDENTITIES',	32,			0,			'Suk_UrbanIdentities_CivilopediaChapter',	1,				1),
		('ICON_FONTICON_SUK_URBANIDENTITIES',		22,			6,			'Suk_UrbanIdentities_FontIcons',			2,				1);
--===========================================================0,===============================================================
-- IconDefinitions
--==========================================================================================================================
INSERT INTO IconDefinitions
		(Name, 										Atlas, 										'Index')
VALUES	('ICON_GAMEMODE_SUK_URBANIDENTITIES',		'ICON_GAMEMODE_SUK_URBANIDENTITIES',		0),
		('ICON_SUK_URBANIDENTITIES_IDENTITY',		'ICON_GAMEMODE_SUK_URBANIDENTITIES',		1),
		('ICON_SUK_URBANIDENTITIES_REGION',			'ICON_GAMEMODE_SUK_URBANIDENTITIES',		2),

		('ICON_CIVILOPEDIA_SUK_URBANIDENTITIES',	'ICON_CIVILOPEDIA_SUK_URBANIDENTITIES',		0),

		('SUK_IDENTITY',							'ICON_FONTICON_SUK_URBANIDENTITIES',		0),
		('SUK_REGION',								'ICON_FONTICON_SUK_URBANIDENTITIES',		1);
--==========================================================================================================================
--==========================================================================================================================
