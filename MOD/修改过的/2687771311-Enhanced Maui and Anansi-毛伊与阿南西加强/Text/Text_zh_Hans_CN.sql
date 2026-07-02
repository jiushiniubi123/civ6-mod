-- Text_zh_Hans_CN
-- Author: Konomi (modified)
-- DateCreated: 11/13/2021 14:13:34
--------------------------------------------------------------
INSERT INTO LocalizedText 
		(Language,		Tag,										Text)
VALUES	('zh_Hans_CN',	'LOC_KNM_MAUI_CREATE_TIP',					'毛伊的恩赐[NEWLINE][NEWLINE]在空白的格位上创建随机加成资源。消耗1点次数并结束当前回合。'),
		('zh_Hans_CN',	'LOC_KNM_MAUI_DISABLED_RESOURCE_TIP',		'[NEWLINE][NEWLINE][COLOR:Red]必须在没有资源的格位上使用。[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_KNM_MAUI_DISABLED_BLANK_TIP',			'[NEWLINE][NEWLINE][COLOR:Red]必须在空白的格位上使用。（无资源、建筑、改良、奇观或国家公园）[ENDCOLOR]'),
		
		('zh_Hans_CN',	'LOC_KNM_ANANSI_INSPIRE_TIP',				'阿南西的计谋[NEWLINE][NEWLINE]位于已解锁资源上时使用。阿南西将消耗资源并生成{1_Num}点 [ICON_SCIENCE] 科技值和{2_Num}点 [ICON_CULTURE] 文化值。现有改良设施将被摧毁。消耗1点次数并结束当前回合。'),
		('zh_Hans_CN',	'LOC_KNM_ANANSI_DISABLED_VISIBLE_TIP',		'[NEWLINE][NEWLINE][COLOR:Red]必须在可见的资源上使用。[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_KNM_DISABLED_CHARGE_TIP',				'[NEWLINE][NEWLINE][COLOR:Red]使用次数不足。[ENDCOLOR]');

UPDATE LocalizedText SET Text = '位于已解锁资源上时使用。阿南西将消耗资源并生成{1_ScienceReward}点 [ICON_SCIENCE] 科技值和{2_CultureReward}点 [ICON_CULTURE] 文化值。现有改良设施将被摧毁。消耗1点次数并结束当前回合。' 
WHERE Language = 'zh_Hans_CN' AND Tag = 'LOC_UNITCOMMAND_RESOURCE_INSPIRE_HELP';