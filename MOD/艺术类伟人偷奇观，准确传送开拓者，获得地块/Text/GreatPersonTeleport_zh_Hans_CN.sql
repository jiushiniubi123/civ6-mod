-- Text_zh_Hans_CN
-- Author: Konomi, SbF6HSO3F (merged)
-- DateCreated: 11/13/2021 14:13:34
--------------------------------------------------------------

--||================= GreatPersonTeleport ==============||--

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,												Text)
VALUES	('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_WONDER_DETAIL',		'：{1_Wonder}'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL',				'移除奇观'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_NOUSE',			'您可以消耗1点使用次数，移除位于该单位所处单元格上自己文明的奇观。'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_DETAIL',			'消耗1点使用次数，移除此单元格上的{1_Wonder}。'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE',				'安置奇观'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_NOUSE',			'你可以将该单位移动至你文明境内的空白单元格上，并在该单元格上重新建造{1_Wonder}。'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_DETAIL',			'在该单元格上重新建造{1_Wonder}。'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NOTUSE',				'[COLOR_RED]因以下原因，该行动不可用：[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_UNIT',				'[ICON_Bullet][COLOR_RED]该单位不为奇观学家[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLOT',				'[ICON_Bullet][COLOR_RED]该单元格不存在[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLAYER',			'[ICON_Bullet][COLOR_RED]该单元格为无主单元格[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_MACTH',		'[ICON_Bullet][COLOR_RED]该单元格不属于其他文明[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_WONDER',			'[ICON_Bullet][COLOR_RED]该单元格上的奇观尚未建造完成[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_NEED',		'[ICON_Bullet][COLOR_RED]该单元格上没有奇观[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_MACTH',		'[ICON_Bullet][COLOR_RED]该单元格不属于您的文明[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_NEED',		'[ICON_Bullet][COLOR_RED]该单元格上没有空间建造奇观[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_BLACKLIST',			'[ICON_Bullet][COLOR_RED]该奇观不可移动[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_GOLD',				'[ICON_Bullet][COLOR_RED][ICON_GOLD] 金币不足（需要 {1_Gold}）[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_COST',				'[ICON_GOLD] 金币消耗：{1_Gold}'),
		('zh_Hans_CN',	'LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_CHARGES',			'[ICON_Bullet][COLOR_RED][ICON_Charges] 使用次数不足（需要1次）[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_REBACK',						'传送开拓者'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_REBACK_EFFECT',					'将一格范围内最近的开拓者随机传送至另一大陆的任意无主陆地块。[COLOR_RED][ICON_Bullet]使用该行动将消耗此伟人。[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_NOTUSE',						'[COLOR_RED]因以下原因，该行动不可用：[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_NO_UNIT',						'[ICON_Bullet][COLOR_RED]该单位不是大作家、大艺术家或大音乐家[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_NO_PLOTS',					'[ICON_Bullet][COLOR_RED]没有其他大陆的无主陆地块可供传送[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_TELEPORT_NO_SETTLER_NEARBY',				'[ICON_Bullet][COLOR_RED]该单位一格范围内没有开拓者[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB',						'文化炸弹'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_EFFECT',				'获取当前单元格（如果无主且接邻己方领土），然后触发文化炸弹，获取周围1格内没有区域、奇观或市中心的所有地块。[COLOR_RED][ICON_Bullet]使用该行动将消耗此伟人。[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_NOUSE',				'你可以消耗此伟人，获取当前地块并触发文化炸弹。'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_NOTUSE',				'[COLOR_RED]因以下原因，该行动不可用：[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_NO_UNIT',				'[ICON_Bullet][COLOR_RED]该单位不是大作家、大艺术家或大音乐家[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_NO_PLOT',				'[ICON_Bullet][COLOR_RED]该单元格不存在[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_FOREIGN',				'[ICON_Bullet][COLOR_RED]该单元格属于其他文明[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_CULTURE_BOMB_NOT_ADJACENT',			'[ICON_Bullet][COLOR_RED]该单元格不与你的领土相邻[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_GREAT_PERSON_GW_WARNING_TITLE',				'警告：包含巨作'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_GW_WARNING_BODY',				'此奇观中有巨作，继续移除将导致巨作消失。[NEWLINE]请手动将巨作移至其他建筑。'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_MOVEGW_CANCEL',				'转移巨作'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_GW_IGNORE',					'继续移除'),

		('zh_Hans_CN',	'LOC_GREAT_PERSON_GW_ALREADY_USED',				'[ICON_Bullet][COLOR_RED]此伟人已生产过巨作[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_UNIT_WONDER_THEFT_NAME',					'奇观学家'),
		('zh_Hans_CN',	'LOC_UNIT_WONDER_THEFT_DESCRIPTION',			'由大作家、大艺术家、大音乐家召唤的特殊单位。可消耗1点使用次数从己方城市移除奇观，并在己方文明境内的空地上重新建造。'),
		('zh_Hans_CN',	'LOC_ABILITY_WONDER_THEFT_NAME',				'奇观学家'),
		('zh_Hans_CN',	'LOC_ABILITY_WONDER_THEFT_DESCRIPTION',			'即使未开放边界，该单位也可进入外国领土。'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_SUMMON',						'召唤奇观学家'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_SUMMON_EFFECT',				'在此处召唤一个奇观学家。奇观学家可以移动和重新安置奇观。[COLOR_RED][ICON_Bullet]使用该行动将消耗此伟人。[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_SUMMON_NOUSE',				'你可以消耗此伟人，在此处召唤一个奇观学家。'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_SUMMON_NOTUSE',				'[COLOR_RED]因以下原因，该行动不可用：[ENDCOLOR]'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_SUMMON_NO_UNIT',				'[ICON_Bullet][COLOR_RED]该单位不是大作家、大艺术家或大音乐家[ENDCOLOR]'),

		('zh_Hans_CN',	'LOC_GREAT_PERSON_NO_MOVEMENT',					'[ICON_Bullet][COLOR_RED][ICON_Movement] 无剩余移动力[ENDCOLOR]');