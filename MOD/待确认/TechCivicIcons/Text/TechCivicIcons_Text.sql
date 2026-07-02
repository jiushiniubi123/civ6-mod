-- ===========================================================================
-- TechCivicIcons - 本地化文本（完整优化版 v3）
-- 中文 (zh_Hans_CN) + 英文 (en_US)
-- 注意：此文件通过 UpdateText 加载，确保汉化生效
--
-- v3 关键变更：
--   - 开拓者下海使用"开拓者"正确汉化
--   - 文本格式：每行重复完整主语
--   - 劳动力使用原版格式
--   - 每个科技一个图标，文本合并
-- ===========================================================================

-- ===========================================================================
-- 中文
-- ===========================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
	-- ==========================================
	-- [1989198528] 建造者和工人开局可下海
	-- Lua脚本在 NewGameInitialized 时自动授予
	-- ==========================================

	-- 建造者下海（海里移动力 → 使用移动力图标）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_BUILDER_EMBARK_NAME', '建造者可下海'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_BUILDER_EMBARK_DESC', '建造者解锁在水域中移动的能力。（游戏开始时自动授予此科技）'),

	-- 收获资源（详细文本，每种资源单独一行，冒号+加号格式）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_RESOURCES_NAME', '可收获资源'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_RESOURCES_DESC',
		'解锁所有资源的收获。[NEWLINE]'
		||'[NEWLINE]'
		||'加成资源收获产出：[NEWLINE]'
		||'[ICON_RESOURCE_BANANAS] 香蕉：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[ICON_RESOURCE_CATTLE] 牛：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[ICON_RESOURCE_COPPER] 铜：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_CRABS] 螃蟹：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_DEER] 鹿：+10 [ICON_PRODUCTION] 生产力[NEWLINE]'
		||'[ICON_RESOURCE_FISH] 鱼：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[ICON_RESOURCE_RICE] 大米：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[ICON_RESOURCE_SHEEP] 羊：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[ICON_RESOURCE_STONE] 石头：+10 [ICON_PRODUCTION] 生产力[NEWLINE]'
		||'[ICON_RESOURCE_WHEAT] 小麦：+10 [ICON_FOOD] 食物[NEWLINE]'
		||'[NEWLINE]'
		||'奢侈品资源收获产出：[NEWLINE]'
		||'[ICON_RESOURCE_CITRUS] 柑橘：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_COCOA] 可可：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_COFFEE] 咖啡：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_COTTON] 棉花：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_DIAMONDS] 钻石：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_DYES] 染料：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_FURS] 毛皮：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_GYPSUM] 石膏：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_INCENSE] 熏香：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_IVORY] 象牙：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_JADE] 玉石：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_MARBLE] 大理石：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_MERCURY] 水银：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_PEARLS] 珍珠：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_SALT] 盐：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_SILK] 丝绸：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_SILVER] 白银：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_SPICES] 香料：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_SUGAR] 糖：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_TEA] 茶叶：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_TOBACCO] 烟草：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_TRUFFLES] 松露：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_WHALES] 鲸鱼：+20 [ICON_GOLD] 金币[NEWLINE]'
		||'[ICON_RESOURCE_WINE] 葡萄酒：+20 [ICON_GOLD] 金币'),

	-- ★开拓者下海（代码中 EmbarkUnitType = UNIT_SETTLER，使用开拓者图标）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_SETTLER_EMBARK_NAME', '开拓者可下海'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_SETTLER_EMBARK_DESC', '开拓者解锁在水域中移动的能力。（游戏开始时自动授予此科技）'),

	-- 移除地貌（详细文本，含地貌列表、产出、数量、小图标）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_REMOVE_FEATURES_NAME', '可移除地貌'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_REMOVE_FEATURES_DESC',
		'解锁所有地貌的移除。[NEWLINE]'
		||'[NEWLINE]'
		||'森林 → 20 [ICON_PRODUCTION] 生产力[NEWLINE]'
		||'雨林 → 10 [ICON_PRODUCTION] 生产力 + 10 [ICON_FOOD] 食物[NEWLINE]'
		||'沼泽 → 20 [ICON_FOOD] 食物[NEWLINE]'
		||'火山土 → 20 [ICON_PRODUCTION] 生产力[NEWLINE]'
		||'绿洲 → 20 [ICON_FOOD] 食物[NEWLINE]'
		||'礁石 → 10 [ICON_FOOD] 食物 + 10 [ICON_PRODUCTION] 生产力[NEWLINE]'
		||'地热裂缝 → 20 [ICON_PRODUCTION] 生产力'),

	-- ==========================================
	-- [3378446140] + [2578023455] 合并图标
	-- ★每个科技只保留一个图标，文本内容进行整合
	-- ★文本格式：每行重复完整主语
	-- ==========================================

	-- 畜牧业：仅骑兵移动力
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_NAME', '骑兵+1移动力'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_DESC', '所有骑兵单位（轻骑兵和重骑兵）+1 [ICON_Movement] 移动力。'),

	-- 机械：骑兵+非骑兵合并
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MOVEMENT_COMBINED_NAME', '陆地单位移动力加成'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MACHINERY_COMBINED_DESC',
		'所有骑兵单位（轻骑兵和重骑兵）+1 [ICON_Movement] 移动力。[NEWLINE]'
		||'所有陆地非骑兵战斗单位（近战、远程、抗骑兵、攻城、侦察、支援、伟人）+1 [ICON_Movement] 移动力。'),

	-- 工业化：仅非骑兵移动力
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MOVEMENT_NC_NAME', '陆地战斗单位+1移动力'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_MOVEMENT_NC_DESC', '所有陆地非骑兵战斗单位（近战、远程、抗骑兵、攻城、侦察、支援、伟人）+1 [ICON_Movement] 移动力。'),

	-- 内燃机：骑兵+愚公合并 + 水运移动力
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_COMBUSTION_COMBINED_DESC',
		'水运单位+1 [ICON_Movement] 移动力。[NEWLINE]'
		||'所有骑兵单位（轻骑兵和重骑兵）+1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的愚公单位获得额外 +1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的愚公单位获得额外 +1 视野范围。'),

	-- 先进动力电池：非骑兵+天鲲号合并
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_APC_COMBINED_DESC',
		'所有陆地非骑兵战斗单位（近战、远程、抗骑兵、攻城、侦察、支援、伟人）+1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的天鲲号单位获得额外 +2 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的天鲲号单位获得额外 +2 视野范围。'),

	-- ==========================================
	-- [2578023455] 移山填海 独立科技（每科技一个图标）
	-- ★劳动力使用原版格式
	-- ==========================================

	-- 制图学：精卫 +1移动力（CARTOGRAPHY 保留原版 Description 进入深海）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_CT_NAME', '精卫强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_CT_DESC', '你的精卫单位获得额外 +1 [ICON_Movement] 移动力。'),

	-- 金属铸造：愚公 +1移动力
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_MC_NAME', '愚公强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_MC_DESC', '你的愚公单位获得额外 +1 [ICON_Movement] 移动力。'),

	-- 机器人：愚公+精卫合并
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_COMBINED_RB_NAME', '愚公/精卫强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_ROBOTICS_COMBINED_DESC',
		'你的愚公单位获得额外 +1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的愚公单位获得额外 +1 视野范围。[NEWLINE]'
		||'你的精卫单位获得额外 +1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的精卫单位获得额外 +1 视野范围。'),

	-- 蒸汽动力：精卫 +1移动力 +1视野 + 水运移动力
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_SP_NAME', '精卫强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_SP_DESC',
		'水运单位+2 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的精卫单位获得额外 +1 [ICON_Movement] 移动力。[NEWLINE]'
		||'你的精卫单位获得额外 +1 视野范围。'),

	-- 化学：愚公 +1劳动力（原版格式）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_CM_NAME', '愚公强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_CM_DESC', '你的愚公单位获得额外 +1 [ICON_Production] 劳动力。'),

	-- 核裂变：愚公 +1劳动力（原版格式）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_NF_NAME', '愚公强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_YUGONG_NF_DESC', '你的愚公单位获得额外 +1 [ICON_Production] 劳动力。'),

	-- 大规模生产：精卫 +1劳动力（原版格式）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_MP_NAME', '精卫强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_MP_DESC', '你的精卫单位获得额外 +1 [ICON_Production] 劳动力。'),

	-- 合成材料：精卫 +1劳动力（原版格式）
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_SM_NAME', '精卫强化'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_JINGWEI_SM_DESC', '你的精卫单位获得额外 +1 [ICON_Production] 劳动力。'),

	-- ==========================================
	-- 水运移动力（原版效果，使用移动力图标）
	-- ==========================================
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_WATER_MOVEMENT_NAME', '水运+1移动力'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_WATER_MOVEMENT_DESC', '所有海运单位+1 [ICON_Movement] 移动力。'),

	-- ==========================================
	-- 战略资源收获（自己修改1587956117 添加，使用锤子图标）
	-- ==========================================
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_HORSES_NAME', '马收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_HORSES_DESC', '可收获 [ICON_RESOURCE_HORSES] 马：+30 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_IRON_NAME', '铁收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_IRON_DESC', '可收获 [ICON_RESOURCE_IRON] 铁：+35 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_NITER_NAME', '硝石收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_NITER_DESC', '可收获 [ICON_RESOURCE_NITER] 硝石：+40 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_COAL_NAME', '煤收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_COAL_DESC', '可收获 [ICON_RESOURCE_COAL] 煤：+45 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_OIL_NAME', '石油收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_OIL_DESC', '可收获 [ICON_RESOURCE_OIL] 石油：+50 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_NAME', '铝收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_DESC', '可收获 [ICON_RESOURCE_ALUMINUM] 铝：+60 [ICON_Production] 生产力。'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_URANIUM_NAME', '铀收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_URANIUM_DESC', '可收获 [ICON_RESOURCE_URANIUM] 铀：+70 [ICON_Production] 生产力。'),

	-- ==========================================
	-- 考古收获（自己修改1587956117 添加，使用文化图标）
	-- ==========================================
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_ARCHAEOLOGY_NAME', '考古收获'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_HARVEST_ARCHAEOLOGY_DESC',
		'可收获 [ICON_RESOURCE_ANTIQUITY_SITE] 考古遗址：+40 [ICON_Culture] 文化。[NEWLINE]'
		||'可收获 [ICON_RESOURCE_SHIPWRECK] 沉船：+40 [ICON_Culture] 文化。'),

	-- ==========================================
	-- 市政
	-- ==========================================
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_CODE_OF_LAWS_NAME', '文明的起点'),
	('zh_Hans_CN', 'LOC_DIPLOACTION_TI_CODE_OF_LAWS_DESC', '文明的起点。');

-- ===========================================================================
-- 英文
-- ===========================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
	-- ==========================================
	-- [1989198528] Embarkation
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_BUILDER_EMBARK_NAME', 'Builder Can Embark'),
	('en_US', 'LOC_DIPLOACTION_TI_BUILDER_EMBARK_DESC', 'Builders gain the ability to move on water tiles. (Granted automatically at game start)'),

	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_RESOURCES_NAME', 'Harvest Resources'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_RESOURCES_DESC',
		'Unlocks harvesting of all resources.[NEWLINE]'
		||'[NEWLINE]'
		||'Bonus resource harvest yields:[NEWLINE]'
		||'[ICON_RESOURCE_BANANAS] Bananas: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_RESOURCE_CATTLE] Cattle: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_RESOURCE_COPPER] Copper: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_CRABS] Crabs: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_DEER] Deer: +10 [ICON_PRODUCTION] Production[NEWLINE]'
		||'[ICON_RESOURCE_FISH] Fish: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_RESOURCE_RICE] Rice: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_RESOURCE_SHEEP] Sheep: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_RESOURCE_STONE] Stone: +10 [ICON_PRODUCTION] Production[NEWLINE]'
		||'[ICON_RESOURCE_WHEAT] Wheat: +10 [ICON_FOOD] Food[NEWLINE]'
		||'[NEWLINE]'
		||'Luxury resource harvest yields:[NEWLINE]'
		||'[ICON_RESOURCE_CITRUS] Citrus: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_COCOA] Cocoa: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_COFFEE] Coffee: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_COTTON] Cotton: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_DIAMONDS] Diamonds: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_DYES] Dyes: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_FURS] Furs: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_GYPSUM] Gypsum: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_INCENSE] Incense: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_IVORY] Ivory: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_JADE] Jade: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_MARBLE] Marble: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_MERCURY] Mercury: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_PEARLS] Pearls: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_SALT] Salt: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_SILK] Silk: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_SILVER] Silver: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_SPICES] Spices: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_SUGAR] Sugar: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_TEA] Tea: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_TOBACCO] Tobacco: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_TRUFFLES] Truffles: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_WHALES] Whales: +20 [ICON_GOLD] Gold[NEWLINE]'
		||'[ICON_RESOURCE_WINE] Wine: +20 [ICON_GOLD] Gold'),

	-- ★Settler embark (code uses UNIT_SETTLER)
	('en_US', 'LOC_DIPLOACTION_TI_SETTLER_EMBARK_NAME', 'Settler Can Embark'),
	('en_US', 'LOC_DIPLOACTION_TI_SETTLER_EMBARK_DESC', 'Settlers gain the ability to move on water tiles. (Granted automatically at game start)'),

	('en_US', 'LOC_DIPLOACTION_TI_REMOVE_FEATURES_NAME', 'Remove Features'),
	('en_US', 'LOC_DIPLOACTION_TI_REMOVE_FEATURES_DESC',
		'Unlocks removal of all features.[NEWLINE]'
		||'[NEWLINE]'
		||'[ICON_FEATURE_FOREST] Woods → 20 [ICON_PRODUCTION] Production[NEWLINE]'
		||'[ICON_FEATURE_JUNGLE] Rainforest → 10 [ICON_PRODUCTION] Production + 10 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_FEATURE_MARSH] Marsh → 20 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_FEATURE_VOLCANIC_SOIL] Volcanic Soil → 20 [ICON_PRODUCTION] Production[NEWLINE]'
		||'[ICON_FEATURE_OASIS] Oasis → 20 [ICON_FOOD] Food[NEWLINE]'
		||'[ICON_FEATURE_REEF] Reef → 10 [ICON_FOOD] Food + 10 [ICON_PRODUCTION] Production[NEWLINE]'
		||'[ICON_FEATURE_GEOTHERMAL_FISSURE] Geothermal Fissure → 20 [ICON_PRODUCTION] Production'),

	-- ==========================================
	-- [3378446140] + [2578023455] Combined
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_NAME', 'Cavalry +1 Movement'),
	('en_US', 'LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_DESC', 'All cavalry units (Light and Heavy) gain +1 [ICON_Movement] Movement.'),

	('en_US', 'LOC_DIPLOACTION_TI_MOVEMENT_COMBINED_NAME', 'Land Unit Movement Bonus'),
	('en_US', 'LOC_DIPLOACTION_TI_MACHINERY_COMBINED_DESC',
		'All cavalry units (Light and Heavy) gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'All non-cavalry land combat units (Melee, Ranged, Anti-Cavalry, Siege, Recon, Support, Great General) gain +1 [ICON_Movement] Movement.'),

	('en_US', 'LOC_DIPLOACTION_TI_MOVEMENT_NC_NAME', 'Land Combat +1 Movement'),
	('en_US', 'LOC_DIPLOACTION_TI_MOVEMENT_NC_DESC', 'All non-cavalry land combat units (Melee, Ranged, Anti-Cavalry, Siege, Recon, Support, Great General) gain +1 [ICON_Movement] Movement.'),

	('en_US', 'LOC_DIPLOACTION_TI_COMBUSTION_COMBINED_DESC',
		'Embarked units gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'All cavalry units (Light and Heavy) gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Yugong units gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Yugong units gain +1 Sight range.'),

	('en_US', 'LOC_DIPLOACTION_TI_APC_COMBINED_DESC',
		'All non-cavalry land combat units (Melee, Ranged, Anti-Cavalry, Siege, Recon, Support, Great General) gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Tian Kun Hao units gain +2 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Tian Kun Hao units gain +2 Sight range.'),

	-- ==========================================
	-- [2578023455] Yugong and Jingwei
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_CT_NAME', 'Jingwei Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_CT_DESC', 'Your Jingwei units gain +1 [ICON_Movement] Movement.'),
	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_MC_NAME', 'Yugong Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_MC_DESC', 'Your Yugong units gain +1 [ICON_Movement] Movement.'),

	('en_US', 'LOC_DIPLOACTION_TI_COMBINED_RB_NAME', 'Yugong/Jingwei Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_ROBOTICS_COMBINED_DESC',
		'Your Yugong units gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Yugong units gain +1 Sight range.[NEWLINE]'
		||'Your Jingwei units gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Jingwei units gain +1 Sight range.'),

	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_SP_NAME', 'Jingwei Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_SP_DESC',
		'Embarked units gain +2 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Jingwei units gain +1 [ICON_Movement] Movement.[NEWLINE]'
		||'Your Jingwei units gain +1 Sight range.'),

	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_CM_NAME', 'Yugong Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_CM_DESC', 'Your Yugong units gain +1 [ICON_Production] Build charge.'),

	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_NF_NAME', 'Yugong Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_YUGONG_NF_DESC', 'Your Yugong units gain +1 [ICON_Production] Build charge.'),

	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_MP_NAME', 'Jingwei Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_MP_DESC', 'Your Jingwei units gain +1 [ICON_Production] Build charge.'),

	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_SM_NAME', 'Jingwei Enhancement'),
	('en_US', 'LOC_DIPLOACTION_TI_JINGWEI_SM_DESC', 'Your Jingwei units gain +1 [ICON_Production] Build charge.'),

	-- ==========================================
	-- Water Movement
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_WATER_MOVEMENT_NAME', 'Embarked +1 Movement'),
	('en_US', 'LOC_DIPLOACTION_TI_WATER_MOVEMENT_DESC', 'All embarked units gain +1 [ICON_Movement] Movement.'),

	-- ==========================================
	-- Strategic Resource Harvests (added by 自己修改1587956117)
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_HORSES_NAME', 'Horses Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_HORSES_DESC', 'Allows harvest of [ICON_RESOURCE_HORSES] Horses: +30 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_IRON_NAME', 'Iron Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_IRON_DESC', 'Allows harvest of [ICON_RESOURCE_IRON] Iron: +35 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_NITER_NAME', 'Niter Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_NITER_DESC', 'Allows harvest of [ICON_RESOURCE_NITER] Niter: +40 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_COAL_NAME', 'Coal Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_COAL_DESC', 'Allows harvest of [ICON_RESOURCE_COAL] Coal: +45 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_OIL_NAME', 'Oil Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_OIL_DESC', 'Allows harvest of [ICON_RESOURCE_OIL] Oil: +50 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_NAME', 'Aluminum Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_DESC', 'Allows harvest of [ICON_RESOURCE_ALUMINUM] Aluminum: +60 [ICON_Production] Production.'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_URANIUM_NAME', 'Uranium Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_URANIUM_DESC', 'Allows harvest of [ICON_RESOURCE_URANIUM] Uranium: +70 [ICON_Production] Production.'),

	-- ==========================================
	-- Archaeology Harvests (added by 自己修改1587956117)
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_ARCHAEOLOGY_NAME', 'Archaeology Harvest'),
	('en_US', 'LOC_DIPLOACTION_TI_HARVEST_ARCHAEOLOGY_DESC',
		'Allows harvest of [ICON_RESOURCE_ANTIQUITY_SITE] Antiquity Site: +40 [ICON_Culture] Culture.[NEWLINE]'
		||'Allows harvest of [ICON_RESOURCE_SHIPWRECK] Shipwreck: +40 [ICON_Culture] Culture.'),

	-- ==========================================
	-- Civic
	-- ==========================================
	('en_US', 'LOC_DIPLOACTION_TI_CODE_OF_LAWS_NAME', 'Cradle of Civilization'),
	('en_US', 'LOC_DIPLOACTION_TI_CODE_OF_LAWS_DESC', 'The cradle of civilization.');