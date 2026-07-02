-- BCI_Data
-- Author: janboruta
-- DateCreated: 4/1/2017 12:09:30 PM
--------------------------------------------------------------

--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
INSERT INTO IconTextureAtlases 
            (Name,                         IconSize,   Filename,                             IconsPerRow,	    IconsPerColumn)
VALUES      ('ICON_ATLAS_BCILITE',         256,        'BCILITEAlphaAtlas256',               8,                 16),
			('ICON_ATLAS_BCILITE',         200,        'BCILITEAlphaAtlas200',               8,                 16),
			('ICON_ATLAS_BCILITE',         128,        'BCILITEAlphaAtlas128',               8,                 16),
			('ICON_ATLAS_BCILITE',         80,         'BCILITEAlphaAtlas80',                8,                 16),
            ('ICON_ATLAS_BCILITE',         64,         'BCILITEAlphaAtlas64',                8,                 16),
            ('ICON_ATLAS_BCILITE',         50,         'BCILITEAlphaAtlas50',                8,                 16),
            ('ICON_ATLAS_BCILITE',         48,         'BCILITEAlphaAtlas48',                8,                 16),
            ('ICON_ATLAS_BCILITE',         45,         'BCILITEAlphaAtlas48',                8,                 16),
            ('ICON_ATLAS_BCILITE',         44,         'BCILITEAlphaAtlas44',                8,                 16),            
            ('ICON_ATLAS_BCILITE',         36,         'BCILITEAlphaAtlas36',                8,                 16),  
			('ICON_ATLAS_BCILITE',         32,         'BCILITEAlphaAtlas32',                8,                 16),           
            ('ICON_ATLAS_BCILITE',         30,         'BCILITEAlphaAtlas30',                8,                 16),
            ('ICON_ATLAS_BCILITE',         22,         'BCILITEAlphaAtlas22',                8,                 16);

--==========================================================================================================================


--==========================================================================================================================
-- IconTextureAtlases
--==========================================================================================================================
INSERT OR REPLACE INTO IconDefinitions 
            (Name,								Atlas,                               'Index')
VALUES      ('ICON_CIVILIZATION_AMERICA',		'ICON_ATLAS_BCILITE',				  0),
			('ICON_CIVILIZATION_ARABIA',		'ICON_ATLAS_BCILITE',				  1),
			('ICON_CIVILIZATION_AUSTRALIA',		'ICON_ATLAS_BCILITE',				  2),
			('ICON_CIVILIZATION_AZTEC',			'ICON_ATLAS_BCILITE',				  3),
			('ICON_CIVILIZATION_BRAZIL',		'ICON_ATLAS_BCILITE',				  4),
			('ICON_CIVILIZATION_CHINA',			'ICON_ATLAS_BCILITE',				  5),
			('ICON_CIVILIZATION_EGYPT',			'ICON_ATLAS_BCILITE',				  6),
			('ICON_CIVILIZATION_ENGLAND',		'ICON_ATLAS_BCILITE',				  7),
			('ICON_CIVILIZATION_FRANCE',		'ICON_ATLAS_BCILITE',				  8),
			('ICON_CIVILIZATION_GERMANY',		'ICON_ATLAS_BCILITE',				  9),
			('ICON_CIVILIZATION_GREECE',		'ICON_ATLAS_BCILITE',				  10),
			('ICON_CIVILIZATION_GREECE_GORGO',	'ICON_ATLAS_BCILITE',				  10),
			('ICON_CIVILIZATION_INDIA',			'ICON_ATLAS_BCILITE',				  12),
			('ICON_CIVILIZATION_JAPAN',			'ICON_ATLAS_BCILITE',				  13),
			('ICON_CIVILIZATION_KONGO',			'ICON_ATLAS_BCILITE',				  14),
			('ICON_CIVILIZATION_MACEDON',		'ICON_ATLAS_BCILITE',				  15),
			('ICON_CIVILIZATION_NORWAY',		'ICON_ATLAS_BCILITE',				  16),
			('ICON_CIVILIZATION_NUBIA',			'ICON_ATLAS_BCILITE',				  17),
			('ICON_CIVILIZATION_PERSIA',		'ICON_ATLAS_BCILITE',				  18),
			('ICON_CIVILIZATION_POLAND',		'ICON_ATLAS_BCILITE',				  19),
			('ICON_CIVILIZATION_ROME',			'ICON_ATLAS_BCILITE',				  20),
			('ICON_CIVILIZATION_RUSSIA',		'ICON_ATLAS_BCILITE',				  21),
			('ICON_CIVILIZATION_SCYTHIA',		'ICON_ATLAS_BCILITE',				  22),
			('ICON_CIVILIZATION_SPAIN',			'ICON_ATLAS_BCILITE',				  23),
			('ICON_CIVILIZATION_SUMERIA',		'ICON_ATLAS_BCILITE',				  24),
			('ICON_CIVILIZATION_INDONESIA',		'ICON_ATLAS_BCILITE',				  25),
			('ICON_CIVILIZATION_KHMER',			'ICON_ATLAS_BCILITE',				  26),

			('ICON_CIVILIZATION_INDIA_2',		'ICON_ATLAS_BCILITE',				  12),

			('ICON_CIVILIZATION_CREE',			'ICON_ATLAS_BCILITE',				  64),
			('ICON_CIVILIZATION_GEORGIA',		'ICON_ATLAS_BCILITE',				  65),
			('ICON_CIVILIZATION_KOREA',			'ICON_ATLAS_BCILITE',				  66),
			('ICON_CIVILIZATION_MAPUCHE',		'ICON_ATLAS_BCILITE',				  67),
			('ICON_CIVILIZATION_MONGOLIA',		'ICON_ATLAS_BCILITE',				  68),
			('ICON_CIVILIZATION_NETHERLANDS',	'ICON_ATLAS_BCILITE',				  69),
			('ICON_CIVILIZATION_SCOTLAND',		'ICON_ATLAS_BCILITE',				  70),
			('ICON_CIVILIZATION_ZULU',			'ICON_ATLAS_BCILITE',				  71),

			('ICON_CIVILIZATION_CANADA',		'ICON_ATLAS_BCILITE',				  72),
			('ICON_CIVILIZATION_HUNGARY',		'ICON_ATLAS_BCILITE',				  73),
			('ICON_CIVILIZATION_INCA',			'ICON_ATLAS_BCILITE',				  74),
			('ICON_CIVILIZATION_MALI',			'ICON_ATLAS_BCILITE',				  75),
			('ICON_CIVILIZATION_MAORI',			'ICON_ATLAS_BCILITE',				  76),
			('ICON_CIVILIZATION_OTTOMAN',		'ICON_ATLAS_BCILITE',				  77),
			('ICON_CIVILIZATION_PHOENICIA',		'ICON_ATLAS_BCILITE',				  78),
			('ICON_CIVILIZATION_SWEDEN',		'ICON_ATLAS_BCILITE',				  79),
			
			('ICON_CIVILIZATION_GRAN_COLOMBIA',	'ICON_ATLAS_BCILITE',				  96),
			('ICON_CIVILIZATION_MAYA',			'ICON_ATLAS_BCILITE',				  97),		
			('ICON_CIVILIZATION_ETHIOPIA',		'ICON_ATLAS_BCILITE',				  98),
			('ICON_CIVILIZATION_BYZANTIUM',		'ICON_ATLAS_BCILITE',				  99),	
			('ICON_CIVILIZATION_GAUL',			'ICON_ATLAS_BCILITE',				  100),	
			('ICON_CIVILIZATION_BABYLON_STK',	'ICON_ATLAS_BCILITE',				  31),	
			('ICON_CIVILIZATION_VIETNAM',		'ICON_ATLAS_BCILITE',				  101),			
			('ICON_CIVILIZATION_PORTUGAL',		'ICON_ATLAS_BCILITE',				  102),			

			('ICON_CIVILIZATION_ANTIOCH',		'ICON_ATLAS_BCILITE',				  29),
			('ICON_CIVILIZATION_AMSTERDAM',		'ICON_ATLAS_BCILITE',				  33),
			('ICON_CIVILIZATION_ANTANANARIVO',	'ICON_ATLAS_BCILITE',				  34),
			('ICON_CIVILIZATION_ARMAGH',	    'ICON_ATLAS_BCILITE',				  35),
			('ICON_CIVILIZATION_AUCKLAND',		'ICON_ATLAS_BCILITE',				  36),
			('ICON_CIVILIZATION_BANGDAR',		'ICON_ATLAS_BCILITE',				  37),
			('ICON_CIVILIZATION_BRUSSELS',		'ICON_ATLAS_BCILITE',				  38),
			('ICON_CIVILIZATION_BUENOS_AIRES',	'ICON_ATLAS_BCILITE',				  39),
			('ICON_CIVILIZATION_CARTHAGE',		'ICON_ATLAS_BCILITE',				  40),
			('ICON_CIVILIZATION_GENEVA',	    'ICON_ATLAS_BCILITE',				  41),
			('ICON_CIVILIZATION_HATTUSA',		'ICON_ATLAS_BCILITE',				  42),
			('ICON_CIVILIZATION_HONG_KONG',     'ICON_ATLAS_BCILITE',				  43),
			('ICON_CIVILIZATION_GRANADA',		'ICON_ATLAS_BCILITE',				  44),
			('ICON_CIVILIZATION_JAKARTA',		'ICON_ATLAS_BCILITE',				  37),
			('ICON_CIVILIZATION_JERUSALEM',		'ICON_ATLAS_BCILITE',				  46),
			('ICON_CIVILIZATION_KABUL',		    'ICON_ATLAS_BCILITE',				  47),
			('ICON_CIVILIZATION_KANDY',			'ICON_ATLAS_BCILITE',				  48),
			('ICON_CIVILIZATION_KUMASI',	    'ICON_ATLAS_BCILITE',				  49),
			('ICON_CIVILIZATION_LA_VENTA',		'ICON_ATLAS_BCILITE',				  50),
			('ICON_CIVILIZATION_LISBON',		'ICON_ATLAS_BCILITE',				  111),
			('ICON_CIVILIZATION_MUSCAT',		'ICON_ATLAS_BCILITE',				  52),
			('ICON_CIVILIZATION_MOHENJO_DARO',  'ICON_ATLAS_BCILITE',				  53),
			('ICON_CIVILIZATION_NAN_MADOL',		'ICON_ATLAS_BCILITE',				  54),
			('ICON_CIVILIZATION_PALENQUE',		'ICON_ATLAS_BCILITE',				  92),
			('ICON_CIVILIZATION_PRESLAV',		'ICON_ATLAS_BCILITE',				  56),
			('ICON_CIVILIZATION_SEOUL',			'ICON_ATLAS_BCILITE',				  57),
			('ICON_CIVILIZATION_STOCKHOLM',		'ICON_ATLAS_BCILITE',				  58),
			('ICON_CIVILIZATION_TORONTO',       'ICON_ATLAS_BCILITE',				  59),
			('ICON_CIVILIZATION_VALLETTA',		'ICON_ATLAS_BCILITE',				  60),
			('ICON_CIVILIZATION_VILNIUS',		'ICON_ATLAS_BCILITE',				  61),
			('ICON_CIVILIZATION_YEREVAN',		'ICON_ATLAS_BCILITE',				  62),
			('ICON_CIVILIZATION_ZANZIBAR',		'ICON_ATLAS_BCILITE',				  63),
			('ICON_CIVILIZATION_AKKAD',			'ICON_ATLAS_BCILITE',				  80),
			('ICON_CIVILIZATION_BOLOGNA',		'ICON_ATLAS_BCILITE',				  81),
			('ICON_CIVILIZATION_CAHOKIA',		'ICON_ATLAS_BCILITE',				  82),
			('ICON_CIVILIZATION_CARDIFF',		'ICON_ATLAS_BCILITE',				  83),
			('ICON_CIVILIZATION_FEZ',		    'ICON_ATLAS_BCILITE',				  84),
			('ICON_CIVILIZATION_MEXICO_CITY',	'ICON_ATLAS_BCILITE',				  85),
			('ICON_CIVILIZATION_NAZCA',			'ICON_ATLAS_BCILITE',				  86),
			('ICON_CIVILIZATION_NGAZARGAMU',	'ICON_ATLAS_BCILITE',				  87),
			('ICON_CIVILIZATION_RAPA_NUI',		'ICON_ATLAS_BCILITE',				  88),
			('ICON_CIVILIZATION_CAGUANA',		'ICON_ATLAS_BCILITE',				  89),
			('ICON_CIVILIZATION_HUNZA',			'ICON_ATLAS_BCILITE',				  90),
			('ICON_CIVILIZATION_LAHORE',		'ICON_ATLAS_BCILITE',				  91),
			('ICON_CIVILIZATION_MITLA',			'ICON_ATLAS_BCILITE',				  92),
			('ICON_CIVILIZATION_SINGAPORE',		'ICON_ATLAS_BCILITE',				  93),
			('ICON_CIVILIZATION_TARUGA',		'ICON_ATLAS_BCILITE',				  94),			
			('ICON_CIVILIZATION_VATICAN_CITY',	'ICON_ATLAS_BCILITE',				  95),
			('ICON_CIVILIZATION_BABYLON',		'ICON_ATLAS_BCILITE',				  104),		
			('ICON_CIVILIZATION_AYUTTHAYA',		'ICON_ATLAS_BCILITE',				  105),		
			('ICON_CIVILIZATION_CHINGUETTI',	'ICON_ATLAS_BCILITE',				  106),		
			('ICON_CIVILIZATION_JOHANNESBURG',	'ICON_ATLAS_BCILITE',				  107),		
			('ICON_CIVILIZATION_NALANDA',		'ICON_ATLAS_BCILITE',				  108),		
			('ICON_CIVILIZATION_SAMARKAND',		'ICON_ATLAS_BCILITE',				  109),
			('ICON_CIVILIZATION_WOLIN',			'ICON_ATLAS_BCILITE',				  110);


--==========================================================================================================================

