-- 由CLear8Sky对Mod Buddy内生成的SQL文件模板进行改动，以便于写入中文
-- GS'Wetlands'CN_Mod_IG
-- Author: 邓半仙人 , Clear8Sky
-- DateCreated: 2021/9/16 16:56:42
--------------------------------------------------------------

-- 该文件对应补译/润色模组 "Wetlands" 中会覆盖原版科技/市政描述文本的部分。
-- 该文件在 InGame 时载入，需 Criteria ： Active_Expansion_2 与 Active_Mod_Wetlands

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,													Text)
SELECT	"zh_Hans_CN",	"LOC_TECH_MACHINERY_DESCRIPTION",						"绿洲花园+1 [ICON_Production] 生产力。允许收获 [ICON_RESOURCE_JNR_PEAT] 泥炭。"
WHERE EXISTS (SELECT Tag FROM EnglishText WHERE Tag = "LOC_RESOURCE_JNR_SWAMP_NAME");

INSERT OR REPLACE INTO LocalizedText
		(Language,		Tag,													Text)
SELECT	"zh_Hans_CN",	"LOC_TECH_REPLACEABLE_PARTS_DESCRIPTION",				"农场与灌溉农场可从相邻每片其他的农场与灌溉农场中获得+1 [ICON_Food] 食物。"
WHERE EXISTS (SELECT Tag FROM EnglishText WHERE Tag = "LOC_RESOURCE_JNR_SWAMP_NAME");