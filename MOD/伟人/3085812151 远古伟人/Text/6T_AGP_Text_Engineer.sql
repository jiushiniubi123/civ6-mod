-- 6T_AGP_Text_Engineer
-- Author: JNR
--------------------------------------------------------------


-- 工程师文本
--------------------------------------------------------------
INSERT OR IGNORE INTO LocalizedText
		(Language,		Tag,																							Text)
VALUES	('zh_Hans_CN',	'LOC_GREAT_PERSON_INDIVIDUAL_IMHOTEPI_NAME',													'印何阗'),
		('zh_Hans_CN',	'LOC_GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL',										'为奇观建设提供{Amount}点 [ICON_Production] 生产力。'),
		('zh_Hans_CN',	'LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_IMHOTEP_CHAPTER_HISTORY_PARA_1',			'印何阗（"带来和平者"）是公元前27世纪古埃及古王国时期的建筑师与祭司。他主持建造的左塞尔金字塔是埃及最早的大型石质建筑，也是首座作为陵墓使用的金字塔。此前法老葬于泥砖砌成的矩形马斯塔巴墓，而印何阗的金字塔采用石材且规模宏大。不同建材的特性使四面墙相互倾斜支撑，这种创新结构保障了建筑稳固。'),
		('zh_Hans_CN',	'LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_IMHOTEP_CHAPTER_HISTORY_PARA_2',			'金字塔成为埃及建筑千年不朽的象征，这主要归功于印何阗的工程智慧。因其贡献，印何阗在埃及被尊为知识与医药之神，后纳入希腊罗马神系。不过其名亦被环球影业1932年及1999年电影中的邪恶魔物借用。'),
		('zh_Hans_CN',	'LOC_GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA_NAME',											'玛利亚·希伯来亚'),
		('zh_Hans_CN',	'LOC_GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS',													'区域项目获得+20% [ICON_Production] 生产力。'),
		('zh_Hans_CN',	'LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA_CHAPTER_HISTORY_PARA_1',	'玛利亚·希伯来亚是希腊炼金术传统中的早期实践者，也是首位炼金术著作作者。公元1-3世纪活跃于亚历山大港，发明多种化学仪器，被公认为西方世界首位真正意义上的炼金术士。她将生命属性融入金属描述，提出金属具阴阳两性，结合可生成新物质。'),
		('zh_Hans_CN',	'LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA_CHAPTER_HISTORY_PARA_2',	'三臂蒸馏器是玛利亚发明的三重虹吸管蒸馏装置，至今仍用于化学实验室。其著作建议蒸馏管采用煎锅厚度的铜青铜材质，管件接口以面粉糊密封。'),
		('zh_Hans_CN',	'LOC_PEDIA_GREATPEOPLE_PAGE_GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA_CHAPTER_HISTORY_PARA_3',	'玛利亚发明的隔水加热法（玛丽浴）通过分离液体沸点限制容器温度，现仍用于需温和加热的化学过程与食品烹饪。该术语由14世纪阿诺德·维拉诺瓦引入。');

UPDATE LocalizedText SET Text=REPLACE(Text, '175', '125') WHERE Tag='LOC_GREAT_PERSON_INDIVIDUAL_IMHOTEP_PRODUCTION_ANCIENT_CLASSICAL';













