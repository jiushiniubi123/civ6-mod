-- Text_EN_US
-- Author: Konomi, SbF6HSO3F (merged)
-- DateCreated: 12/19/2021 20:26:33
--------------------------------------------------------------

--||================= GreatPersonTeleport ==============||--

INSERT OR REPLACE INTO BaseGameText
		(Tag,												Text)
VALUES	('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_WONDER_DETAIL', ': {1_Wonder}'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL',		 'Remove Wonder'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_NOUSE',	"You may spend 1 Charge to remove Wonders from your own civilization located on the plot in which the unit is located."),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_DETAIL',	'Remove {1_Wonder} on this plot by spending 1 Charge.'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE',		 'Rebuild Wonder'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_NOUSE',	"You can move the unit to a blank plot within your civilization and rebuild {1_Wonder} on that plot."),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_DETAIL',	'Rebuild the {1_Wonder} on this plot.'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NOTUSE',		 '[COLOR_RED]This action is not available for the following reasons:[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_UNIT',		 '[ICON_Bullet][COLOR_RED]The unit is not a Wonderologist[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLOT',		 '[ICON_Bullet][COLOR_RED]The plot does not exist[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_PLAYER',	 '[ICON_Bullet][COLOR_RED]The plot is a plot with no owner[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_MACTH', '[ICON_Bullet][COLOR_RED]The plot is not part of another civilization[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_WONDER',	 '[ICON_Bullet][COLOR_RED]The Wonder on this plot has not yet been constructed[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_STEAL_PLOT_NEED', '[ICON_Bullet][COLOR_RED]There are no wonders on this plot[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_MACTH', '[ICON_Bullet][COLOR_RED]The plot is not part of your civilization[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_PLOT_NEED', '[ICON_Bullet][COLOR_RED]There is no free space on this plot to build the Wonder[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_BLACKLIST',	 '[ICON_Bullet][COLOR_RED]This Wonder cannot be moved[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_GOLD',		 '[ICON_Bullet][COLOR_RED]Not enough [ICON_GOLD] Gold (need {1_Gold})[ENDCOLOR]'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_PLACE_COST',	 '[ICON_GOLD] Cost: {1_Gold}'),
		('LOC_ARCHAEOLOGIST_OF_GREAT_BRITAIN_NO_CHARGES',	 '[ICON_Bullet][COLOR_RED]Not enough [ICON_Charges] Charges (need 1)[ENDCOLOR]'),

		('LOC_GREAT_PERSON_TELEPORT_REBACK',				'Teleport Settler'),
		('LOC_GREAT_PERSON_TELEPORT_REBACK_EFFECT',			'Teleport the nearest Settler within 1 tile to a random unowned land plot on a different continent. [COLOR_RED][ICON_Bullet]Using this action will consume the Great Person.[ENDCOLOR]'),
		('LOC_GREAT_PERSON_TELEPORT_NOTUSE',				'[COLOR_RED]This action is not available for the following reasons:[ENDCOLOR]'),
		('LOC_GREAT_PERSON_TELEPORT_NO_UNIT',				'[ICON_Bullet][COLOR_RED]The unit is not a Great Writer, Great Artist, or Great Musician[ENDCOLOR]'),
		('LOC_GREAT_PERSON_TELEPORT_NO_PLOTS',				'[ICON_Bullet][COLOR_RED]No unowned land plots on other continents available[ENDCOLOR]'),
		('LOC_GREAT_PERSON_TELEPORT_NO_SETTLER_NEARBY',		'[ICON_Bullet][COLOR_RED]No Settler within 1 tile of this unit[ENDCOLOR]'),

		('LOC_GREAT_PERSON_CULTURE_BOMB',					'Culture Bomb'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_EFFECT',			'Acquire the current tile (if unowned and adjacent to your territory), then trigger a Culture Bomb that claims all surrounding tiles within 1 tile without a District, Wonder, or City Center. [COLOR_RED][ICON_Bullet]Using this action will consume the Great Person.[ENDCOLOR]'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_NOUSE',				'You may spend this Great Person to acquire the current tile and trigger a Culture Bomb.'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_NOTUSE',			'[COLOR_RED]This action is not available for the following reasons:[ENDCOLOR]'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_NO_UNIT',			'[ICON_Bullet][COLOR_RED]The unit is not a Great Writer, Great Artist, or Great Musician[ENDCOLOR]'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_NO_PLOT',			'[ICON_Bullet][COLOR_RED]The plot does not exist[ENDCOLOR]'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_FOREIGN',			'[ICON_Bullet][COLOR_RED]The plot belongs to another civilization[ENDCOLOR]'),
		('LOC_GREAT_PERSON_CULTURE_BOMB_NOT_ADJACENT',		'[ICON_Bullet][COLOR_RED]The plot is not adjacent to your territory[ENDCOLOR]'),

		('LOC_GREAT_PERSON_GW_WARNING_TITLE',				'Warning: Contains Great Works'),
		('LOC_GREAT_PERSON_GW_WARNING_BODY',				'This Wonder contains Great Works. Removing it will result in the loss of these Great Works.[NEWLINE]Please manually transfer the Great Works to another building.'),
		('LOC_GREAT_PERSON_MOVEGW_CANCEL',				'Transfer Great Works'),
		('LOC_GREAT_PERSON_GW_IGNORE',					'Continue Removal'),

		('LOC_GREAT_PERSON_GW_ALREADY_USED',			'[ICON_Bullet][COLOR_RED]This Great Person has already produced a Great Work[ENDCOLOR]'),

		('LOC_UNIT_WONDER_THEFT_NAME',					'Wonderologist'),
		('LOC_UNIT_WONDER_THEFT_DESCRIPTION',			'Special unit summoned by Great Writers, Artists, and Musicians. Can spend 1 Charge to steal Wonders from your own cities and rebuild them on empty plots within your civilization.'),
		('LOC_ABILITY_WONDER_THEFT_NAME',				'Wonderologist'),
		('LOC_ABILITY_WONDER_THEFT_DESCRIPTION',			'Even without Open Borders, this unit can enter foreign territory.'),
		('LOC_GREAT_PERSON_SUMMON',						'Summon Wonderologist'),
		('LOC_GREAT_PERSON_SUMMON_EFFECT',				'Summon a Wonderologist on this tile. Wonderologist can steal and move Wonders. [COLOR_RED][ICON_Bullet]Using this action will consume the Great Person.[ENDCOLOR]'),
		('LOC_GREAT_PERSON_SUMMON_NOUSE',				'You may spend this Great Person to summon a Wonderologist on this tile.'),
		('LOC_GREAT_PERSON_SUMMON_NOTUSE',				'[COLOR_RED]This action is not available for the following reasons:[ENDCOLOR]'),
		('LOC_GREAT_PERSON_SUMMON_NO_UNIT',				'[ICON_Bullet][COLOR_RED]The unit is not a Great Writer, Great Artist, or Great Musician[ENDCOLOR]'),

		('LOC_GREAT_PERSON_NO_MOVEMENT',				'[ICON_Bullet][COLOR_RED][ICON_Movement] No movement points remaining[ENDCOLOR]');