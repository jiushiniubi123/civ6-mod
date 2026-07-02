-- Text_EN_US
-- Author: Konomi (modified)
-- DateCreated: 12/19/2021 20:26:33
--------------------------------------------------------------
INSERT INTO LocalizedText 
		(Language,	Tag,										Text)
VALUES	('en_US',	'LOC_KNM_MAUI_CREATE_TIP',					'Maui''s Bounty[NEWLINE][NEWLINE]Use when located on an empty plot. Maui creates a random Bonus Resource on the plot. Costs 1 Charge and ends turn.'),
		('en_US',	'LOC_KNM_MAUI_DISABLED_RESOURCE_TIP',		'[NEWLINE][NEWLINE][COLOR:Red]Must be used on a plot without resources. [ENDCOLOR]'),
		('en_US',	'LOC_KNM_MAUI_DISABLED_BLANK_TIP',			'[NEWLINE][NEWLINE][COLOR:Red]Must be used on an empty plot. (No resource, building, improvement, wonder or national park) [ENDCOLOR]'),

		('en_US',	'LOC_KNM_ANANSI_INSPIRE_TIP',				"Anansi's Tricks[NEWLINE][NEWLINE]Use when located on an unlocked Resource. Anansi consumes the resource and generates {1_ScienceReward} [ICON_SCIENCE] Science and {2_CultureReward} [ICON_CULTURE] Culture. Any improvement present is destroyed. Costs 1 Charge and ends turn. "),
		('en_US',	'LOC_KNM_ANANSI_DISABLED_VISIBLE_TIP',		'[NEWLINE][NEWLINE][COLOR:Red]Must be used on a visible resource. [ENDCOLOR]'),

		('en_US',	'LOC_KNM_DISABLED_CHARGE_TIP',				'[NEWLINE][NEWLINE][COLOR:Red]Not enough Action Charges remaining[ENDCOLOR]');

UPDATE LocalizedText SET Text = 'Use when located on an unlocked Resource. Anansi consumes the resource and generates {1_ScienceReward} [ICON_SCIENCE] Science and {2_CultureReward} [ICON_CULTURE] Culture. Any improvement present is destroyed. Costs 1 Charge and ends turn.' 
WHERE Language = 'en_US' AND Tag = 'LOC_UNITCOMMAND_RESOURCE_INSPIRE_HELP';