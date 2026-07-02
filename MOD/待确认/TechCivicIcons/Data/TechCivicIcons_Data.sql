-- ===========================================================================
-- TechCivicIcons - 数据层（完整优化版 v3）
-- 为科技树和市政树上的模组解锁内容添加合适的图标
-- 使用 DIPLOMATIC_ACTION 方式（参考开放边界模式），不修改任何 UI 文件
-- 右击图标时打开正确的科技/市政百科页面，而非错误建筑词条
-- 
-- 覆盖模组：
--   1. 1989198528 建造者和工人开局可下海
--      - TECH_BUILDERSAIL：建造者下海(Lua自动授予) + 收获所有资源
--      - TECH_SCOUTSAIL：开拓者下海(Lua自动授予) + 移除所有地貌
--   2. 3378446140 科技为陆地单位提供移动力
--      - 5个科技：畜牧业/机械/工业化/内燃机/先进动力电池
--   3. 2578023455 移山填海（愚公/精卫/天鲲号）
--      - 10个科技：金属铸造/内燃机/机器人/制图学/蒸汽动力/先进动力电池/化学/核裂变/大规模生产/合成材料
--
-- v3 关键变更：
--   - 保留 TECH_SAILING/SHIPBUILDING/CELESTIAL_NAVIGATION/CARTOGRAPHY 原版 Description（下海/深海）
--   - 每个科技只保留一个图标（移动力/移山填海合并）
--   - 开拓者下海使用开拓者图标（ICON_ATLAS_UNITS Index 0）
--   - 文本格式：每行重复完整主语
--   - TECH_CARTOGRAPHY 新增精卫 DIPLOMATIC_ACTION（移山填海 mod 的 精卫+1移动力）
-- ===========================================================================

-- ===========================================================================
-- Part 0: Description 处理
-- 策略：
--   - 4个科技恢复原版 Description（下海/深海相关，未被提取为 DIPLOMATIC_ACTION）：
--     TECH_SAILING（建造者下海）、TECH_SHIPBUILDING（所有单位下海）、
--     TECH_CELESTIAL_NAVIGATION（商人下海）、TECH_CARTOGRAPHY（进入深海）
--   - 其余26个科技清除 Description（已被 DIPLOMATIC_ACTION 图标替代）
--   - TECH_GUNPOWDER 保留：DLC Expansion2 新增的 Description（火药单位），
-- 
-- 分析依据：原版 Technologies.xml 中这4个科技有 EmbarkUnitType/EmbarkAll 机制，
-- 其 Description 描述了单位下水/进入深海的能力，移山填海 mod 已覆盖，
-- 我们恢复原版文本以保留这些重要信息。
-- ===========================================================================

-- 恢复原版 Description（下海/深海相关，保留原版 ICON_TECHUNLOCK_13）
UPDATE Technologies SET Description = 'LOC_TECH_SAILING_DESCRIPTION'
WHERE TechnologyType = 'TECH_SAILING';
UPDATE Technologies SET Description = 'LOC_TECH_SHIPBUILDING_DESCRIPTION'
WHERE TechnologyType = 'TECH_SHIPBUILDING';
UPDATE Technologies SET Description = 'LOC_TECH_CELESTIAL_NAVIGATION_DESCRIPTION'
WHERE TechnologyType = 'TECH_CELESTIAL_NAVIGATION';
UPDATE Technologies SET Description = 'LOC_TECH_CARTOGRAPHY_DESCRIPTION'
WHERE TechnologyType = 'TECH_CARTOGRAPHY';

-- 清除其余26个科技的 Description
-- 注：TECH_GUNPOWDER 保留（DLC 新增，非收获相关）
UPDATE Technologies SET Description = NULL
WHERE TechnologyType IN (
	-- 水运移动力（原版，使用移动力图标）
	'TECH_MATHEMATICS',
	'TECH_SQUARE_RIGGING',
	'TECH_IRRIGATION',
	'TECH_MINING',
	'TECH_BRONZE_WORKING',
	'TECH_POTTERY',
	'TECH_ANIMAL_HUSBANDRY',
	'TECH_MASONRY',
	'TECH_HORSEBACK_RIDING',
	'TECH_IRON_WORKING',
	'TECH_CONSTRUCTION',
	'TECH_ENGINEERING',
	'TECH_STEAM_POWER',
	'TECH_SCIENTIFIC_THEORY',
	'TECH_REPLACEABLE_PARTS',
	'TECH_COMBINED_ARMS',
	-- [3378446140] 移动力相关（4个）
	'TECH_MACHINERY',
	'TECH_INDUSTRIALIZATION',
	'TECH_COMBUSTION',
	'TECH_ADVANCED_POWER_CELLS',
	-- [2578023455] 移山填海（6个，排除 CARTOGRAPHY）
	'TECH_METAL_CASTING',
	'TECH_ROBOTICS',
	'TECH_CHEMISTRY',
	'TECH_NUCLEAR_FISSION',
	'TECH_MASS_PRODUCTION',
	'TECH_SYNTHETIC_MATERIALS'
);

-- ===========================================================================
-- Part 1: Types 注册（所有 DIPLOMATIC_ACTION 类型）
-- 参考 DIPLOACTION_OPEN_BORDERS 模式
-- KIND_DIPLOMATIC_ACTION 在科技树中显示为 ICON_TECHUNLOCK_8 背景帧
-- 右击时通过 CivilopediaKey 打开正确的百科页面
-- ===========================================================================
INSERT OR REPLACE INTO Types (Type, Kind)
VALUES
	-- === [1989198528] 建造者和工人开局可下海 ===
	('DIPLOACTION_TI_BUILDER_EMBARK',	'KIND_DIPLOMATIC_ACTION'),
	('DIPLOACTION_TI_HARVEST_RESOURCES','KIND_DIPLOMATIC_ACTION'),
	('DIPLOACTION_TI_SETTLER_EMBARK',	'KIND_DIPLOMATIC_ACTION'),	-- ★改为开拓者
	('DIPLOACTION_TI_REMOVE_FEATURES',	'KIND_DIPLOMATIC_ACTION'),

	-- === [3378446140] + [2578023455] 合并（每个科技只保留一个图标） ===
	-- 畜牧业：骑兵移动力
	('DIPLOACTION_TI_MOVEMENT_CAVALRY_1','KIND_DIPLOMATIC_ACTION'),
	-- 机械：骑兵+非骑兵合并
	('DIPLOACTION_TI_MOVEMENT_COMBINED_1','KIND_DIPLOMATIC_ACTION'),
	-- 工业化：非骑兵移动力
	('DIPLOACTION_TI_MOVEMENT_NC_2',	'KIND_DIPLOMATIC_ACTION'),
	-- 内燃机：骑兵 + 愚公 合并
	('DIPLOACTION_TI_MOVEMENT_COMBINED_2','KIND_DIPLOMATIC_ACTION'),
	-- 先进动力电池：非骑兵 + 天鲲号 合并
	('DIPLOACTION_TI_MOVEMENT_COMBINED_3','KIND_DIPLOMATIC_ACTION'),

	-- === [2578023455] 移山填海 独立科技 ===
	('DIPLOACTION_TI_JINGWEI_CT',	'KIND_DIPLOMATIC_ACTION'),	-- 制图学：精卫 +1移动力
	('DIPLOACTION_TI_YUGONG_MC',	'KIND_DIPLOMATIC_ACTION'),	-- 金属铸造：愚公 +1移动
	('DIPLOACTION_TI_COMBINED_RB',	'KIND_DIPLOMATIC_ACTION'),	-- 机器人：愚公+精卫 合并
	('DIPLOACTION_TI_JINGWEI_SP',	'KIND_DIPLOMATIC_ACTION'),	-- 蒸汽动力：精卫 +1移动 +1视野
	('DIPLOACTION_TI_YUGONG_CM',	'KIND_DIPLOMATIC_ACTION'),	-- 化学：愚公 +1劳动力（原版格式）
	('DIPLOACTION_TI_YUGONG_NF',	'KIND_DIPLOMATIC_ACTION'),	-- 核裂变：愚公 +1劳动力（原版格式）
	('DIPLOACTION_TI_JINGWEI_MP',	'KIND_DIPLOMATIC_ACTION'),	-- 大规模生产：精卫 +1劳动力（原版格式）
	('DIPLOACTION_TI_JINGWEI_SM',	'KIND_DIPLOMATIC_ACTION'),	-- 合成材料：精卫 +1劳动力（原版格式）

	-- === 市政 ===
	('DIPLOACTION_TI_CODE_OF_LAWS',		'KIND_DIPLOMATIC_ACTION'),
	
	-- === 水运移动力（原版效果，使用移动力图标） ===
	('DIPLOACTION_TI_WATER_MOVEMENT_1',	'KIND_DIPLOMATIC_ACTION'),	-- 数学：水运+1移动力
	('DIPLOACTION_TI_WATER_MOVEMENT_2',	'KIND_DIPLOMATIC_ACTION'),	-- 方帆：水运+1移动力
	
	-- === 战略资源收获（自己修改1587956117 添加，使用锤子图标） ===
	('DIPLOACTION_TI_HARVEST_HORSES',	'KIND_DIPLOMATIC_ACTION'),	-- 畜牧：马收获
	('DIPLOACTION_TI_HARVEST_IRON',	'KIND_DIPLOMATIC_ACTION'),	-- 青铜：铁收获
	('DIPLOACTION_TI_HARVEST_NITER',	'KIND_DIPLOMATIC_ACTION'),	-- 火药：硝石收获
	('DIPLOACTION_TI_HARVEST_COAL',	'KIND_DIPLOMATIC_ACTION'),	-- 蒸汽：煤收获
	('DIPLOACTION_TI_HARVEST_OIL',		'KIND_DIPLOMATIC_ACTION'),	-- 科学理论：石油收获
	('DIPLOACTION_TI_HARVEST_ALUMINUM',	'KIND_DIPLOMATIC_ACTION'),	-- 可更换部件：铝收获
	('DIPLOACTION_TI_HARVEST_URANIUM',	'KIND_DIPLOMATIC_ACTION'),	-- 联合作战：铀收获
	
	-- === 考古收获（自己修改1587956117 添加，使用文化图标） ===
	('DIPLOACTION_TI_HARVEST_ARCHAEOLOGY',	'KIND_DIPLOMATIC_ACTION');	-- 考古遗址+沉船收获

-- ===========================================================================
-- Part 2: DiplomaticActions 表
-- 参考开放边界模式 (DIPLOACTION_OPEN_BORDERS, InitiatorPrereqCivic=CIVIC_EARLY_EMPIRE)
-- 关键字段：
--   InitiatorPrereqTech  → 科技树解锁条件
--   InitiatorPrereqCivic → 市政树解锁条件
--   CivilopediaKey       → 右击时打开的百科页面（设为对应科技即可正确导航）
--   Name                 → 显示名称（tooltip 标题）
--   Description          → 描述文本（tooltip 内容，支持多行和 [ICON_XXX] 小图标）
-- ===========================================================================

-- ===========================================================================
-- 2.1 [1989198528] TECH_BUILDERSAIL：建造者下海 + 收获资源
-- 注意：Lua脚本 Embarkbuilder.lua 在 NewGameInitialized 时自动授予此科技
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_BUILDER_EMBARK',	'LOC_DIPLOACTION_TI_BUILDER_EMBARK_NAME',	'LOC_DIPLOACTION_TI_BUILDER_EMBARK_DESC',	'TECH_BUILDERSAIL',	'TECH_BUILDERSAIL'),
	('DIPLOACTION_TI_HARVEST_RESOURCES','LOC_DIPLOACTION_TI_HARVEST_RESOURCES_NAME','LOC_DIPLOACTION_TI_HARVEST_RESOURCES_DESC','TECH_BUILDERSAIL',	'TECH_BUILDERSAIL');

-- ===========================================================================
-- 2.2 [1989198528] TECH_SCOUTSAIL：开拓者下海 + 移除地貌
-- 注意：Lua脚本 Embarkscout.lua 在 NewGameInitialized 时自动授予此科技
-- ★代码中 EmbarkUnitType = 'UNIT_SETTLER'，使用开拓者图标
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_SETTLER_EMBARK',	'LOC_DIPLOACTION_TI_SETTLER_EMBARK_NAME',	'LOC_DIPLOACTION_TI_SETTLER_EMBARK_DESC',	'TECH_SCOUTSAIL',	'TECH_SCOUTSAIL'),
	('DIPLOACTION_TI_REMOVE_FEATURES',	'LOC_DIPLOACTION_TI_REMOVE_FEATURES_NAME',	'LOC_DIPLOACTION_TI_REMOVE_FEATURES_DESC',	'TECH_SCOUTSAIL',	'TECH_SCOUTSAIL');

-- ===========================================================================
-- 2.3 [3378446140] + [2578023455] 合并图标（每个科技一个图标）
-- ★核心原则：每个科技只保留一个图标，文本内容进行整合
-- 移动力类使用 ICON_ATLAS_STATS Index 3（移动力图标）
-- 海里移动力也使用移动力图标
-- ===========================================================================

-- 畜牧业：仅骑兵移动力
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_MOVEMENT_CAVALRY_1','LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_NAME','LOC_DIPLOACTION_TI_MOVEMENT_CAVALRY_DESC','TECH_ANIMAL_HUSBANDRY','TECH_ANIMAL_HUSBANDRY');

-- 机械：骑兵+非骑兵合并
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_MOVEMENT_COMBINED_1','LOC_DIPLOACTION_TI_MOVEMENT_COMBINED_NAME','LOC_DIPLOACTION_TI_MACHINERY_COMBINED_DESC','TECH_MACHINERY','TECH_MACHINERY');

-- 工业化：仅非骑兵移动力
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_MOVEMENT_NC_2',	'LOC_DIPLOACTION_TI_MOVEMENT_NC_NAME','LOC_DIPLOACTION_TI_MOVEMENT_NC_DESC','TECH_INDUSTRIALIZATION','TECH_INDUSTRIALIZATION');

-- 内燃机：骑兵+愚公合并
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_MOVEMENT_COMBINED_2','LOC_DIPLOACTION_TI_MOVEMENT_COMBINED_NAME','LOC_DIPLOACTION_TI_COMBUSTION_COMBINED_DESC','TECH_COMBUSTION','TECH_COMBUSTION');

-- 先进动力电池：非骑兵+天鲲号合并
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_MOVEMENT_COMBINED_3','LOC_DIPLOACTION_TI_MOVEMENT_COMBINED_NAME','LOC_DIPLOACTION_TI_APC_COMBINED_DESC','TECH_ADVANCED_POWER_CELLS','TECH_ADVANCED_POWER_CELLS');

-- ===========================================================================
-- 2.4 [2578023455] 移山填海 独立科技（每科技一个图标）
-- 移动+视野统一使用移动力图标，多效果合并为多行文本
-- 劳动力使用原版格式
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	-- 制图学：精卫 +1移动力（CARTOGRAPHY 保留原版 Description 用于进入深海，精卫加成单独图标）
	('DIPLOACTION_TI_JINGWEI_CT',	'LOC_DIPLOACTION_TI_JINGWEI_CT_NAME',	'LOC_DIPLOACTION_TI_JINGWEI_CT_DESC',	'TECH_CARTOGRAPHY',		'TECH_CARTOGRAPHY'),
	-- 金属铸造：愚公 +1移动力
	('DIPLOACTION_TI_YUGONG_MC',	'LOC_DIPLOACTION_TI_YUGONG_MC_NAME',	'LOC_DIPLOACTION_TI_YUGONG_MC_DESC',	'TECH_METAL_CASTING',	'TECH_METAL_CASTING'),
	-- 机器人：愚公+精卫合并
	('DIPLOACTION_TI_COMBINED_RB',	'LOC_DIPLOACTION_TI_COMBINED_RB_NAME',	'LOC_DIPLOACTION_TI_ROBOTICS_COMBINED_DESC','TECH_ROBOTICS',	'TECH_ROBOTICS'),
	-- 蒸汽动力：精卫 +1移动力 +1视野
	('DIPLOACTION_TI_JINGWEI_SP',	'LOC_DIPLOACTION_TI_JINGWEI_SP_NAME',	'LOC_DIPLOACTION_TI_JINGWEI_SP_DESC',	'TECH_STEAM_POWER',		'TECH_STEAM_POWER'),
	-- 化学：愚公 +1劳动力（原版格式）
	('DIPLOACTION_TI_YUGONG_CM',	'LOC_DIPLOACTION_TI_YUGONG_CM_NAME',	'LOC_DIPLOACTION_TI_YUGONG_CM_DESC',	'TECH_CHEMISTRY',		'TECH_CHEMISTRY'),
	-- 核裂变：愚公 +1劳动力（原版格式）
	('DIPLOACTION_TI_YUGONG_NF',	'LOC_DIPLOACTION_TI_YUGONG_NF_NAME',	'LOC_DIPLOACTION_TI_YUGONG_NF_DESC',	'TECH_NUCLEAR_FISSION',	'TECH_NUCLEAR_FISSION'),
	-- 大规模生产：精卫 +1劳动力（原版格式）
	('DIPLOACTION_TI_JINGWEI_MP',	'LOC_DIPLOACTION_TI_JINGWEI_MP_NAME',	'LOC_DIPLOACTION_TI_JINGWEI_MP_DESC',	'TECH_MASS_PRODUCTION',	'TECH_MASS_PRODUCTION'),
	-- 合成材料：精卫 +1劳动力（原版格式）
	('DIPLOACTION_TI_JINGWEI_SM',	'LOC_DIPLOACTION_TI_JINGWEI_SM_NAME',	'LOC_DIPLOACTION_TI_JINGWEI_SM_DESC',	'TECH_SYNTHETIC_MATERIALS','TECH_SYNTHETIC_MATERIALS');

-- ===========================================================================
-- 2.5 法典市政："文明的起点"
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqCivic)
VALUES
	('DIPLOACTION_TI_CODE_OF_LAWS',		'LOC_DIPLOACTION_TI_CODE_OF_LAWS_NAME',		'LOC_DIPLOACTION_TI_CODE_OF_LAWS_DESC',		'CIVIC_CODE_OF_LAWS',	'CIVIC_CODE_OF_LAWS');

-- ===========================================================================
-- 2.6 水运移动力（原版效果，使用移动力图标）
-- 数学/方帆：海运单位+1移动力（原版 Descriptions 被清除，用 DIPLOMATIC_ACTION 替代）
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_WATER_MOVEMENT_1',	'LOC_DIPLOACTION_TI_WATER_MOVEMENT_NAME',	'LOC_DIPLOACTION_TI_WATER_MOVEMENT_DESC',	'TECH_MATHEMATICS',		'TECH_MATHEMATICS'),
	('DIPLOACTION_TI_WATER_MOVEMENT_2',	'LOC_DIPLOACTION_TI_WATER_MOVEMENT_NAME',	'LOC_DIPLOACTION_TI_WATER_MOVEMENT_DESC',	'TECH_SQUARE_RIGGING',	'TECH_SQUARE_RIGGING');

-- ===========================================================================
-- 2.7 战略资源收获（自己修改1587956117 添加，使用锤子图标）
-- 每个战略资源在其原版科技处解锁收获（不在 TECH_BUILDERSAIL）
-- ===========================================================================
INSERT OR REPLACE INTO DiplomaticActions (DiplomaticActionType, Name, Description, CivilopediaKey, InitiatorPrereqTech)
VALUES
	('DIPLOACTION_TI_HARVEST_HORSES',	'LOC_DIPLOACTION_TI_HARVEST_HORSES_NAME',	'LOC_DIPLOACTION_TI_HARVEST_HORSES_DESC',	'TECH_ANIMAL_HUSBANDRY',	'TECH_ANIMAL_HUSBANDRY'),
	('DIPLOACTION_TI_HARVEST_IRON',	'LOC_DIPLOACTION_TI_HARVEST_IRON_NAME',		'LOC_DIPLOACTION_TI_HARVEST_IRON_DESC',		'TECH_BRONZE_WORKING',		'TECH_BRONZE_WORKING'),
	('DIPLOACTION_TI_HARVEST_NITER',	'LOC_DIPLOACTION_TI_HARVEST_NITER_NAME',	'LOC_DIPLOACTION_TI_HARVEST_NITER_DESC',	'TECH_GUNPOWDER',			'TECH_GUNPOWDER'),
	('DIPLOACTION_TI_HARVEST_COAL',	'LOC_DIPLOACTION_TI_HARVEST_COAL_NAME',		'LOC_DIPLOACTION_TI_HARVEST_COAL_DESC',		'TECH_STEAM_POWER',			'TECH_STEAM_POWER'),
	('DIPLOACTION_TI_HARVEST_OIL',		'LOC_DIPLOACTION_TI_HARVEST_OIL_NAME',		'LOC_DIPLOACTION_TI_HARVEST_OIL_DESC',		'TECH_SCIENTIFIC_THEORY',	'TECH_SCIENTIFIC_THEORY'),
	('DIPLOACTION_TI_HARVEST_ALUMINUM',	'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_NAME',	'LOC_DIPLOACTION_TI_HARVEST_ALUMINUM_DESC',	'TECH_REPLACEABLE_PARTS',	'TECH_REPLACEABLE_PARTS'),
	('DIPLOACTION_TI_HARVEST_URANIUM',	'LOC_DIPLOACTION_TI_HARVEST_URANIUM_NAME',	'LOC_DIPLOACTION_TI_HARVEST_URANIUM_DESC',	'TECH_COMBINED_ARMS',		'TECH_COMBINED_ARMS');

