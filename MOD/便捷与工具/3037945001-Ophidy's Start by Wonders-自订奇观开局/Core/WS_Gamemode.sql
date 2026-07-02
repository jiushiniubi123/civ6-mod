-- Gamemode
-- Author: Lazire
-- DateCreated: 9/17/2023 3:16:52 AM
--------------------------------------------------------------
INSERT INTO GameModeItems
(GameModeType,
Name,
Description,
Portrait,
Background,
Icon,
SortIndex)
VALUES
('GAMEMODE_WS',
'LOC_GAMEMODE_WS_NAME',
'LOC_GAMEMODE_WS_DESCRIPTION',
'IMG_GAMEMODE_WS_FORE',
'IMG_GAMEMODE_WS_BACK',
'ICON_GAMEMODE_WS',
10);

INSERT INTO Parameters
(ParameterId,
Name,
Description,
Domain,
DefaultValue,
ConfigurationGroup,
ConfigurationId,
NameArrayConfigurationId,
GroupId,
SortIndex)
VALUES
('GAMEMODE_WS',
'LOC_GAMEMODE_WS_NAME',
'LOC_GAMEMODE_WS_DESCRIPTION',
'bool',
1,
'Game',
'GAMEMODE_WS',
'GAMEMODES_ENABLED_NAMES',
'GameModes',
100);