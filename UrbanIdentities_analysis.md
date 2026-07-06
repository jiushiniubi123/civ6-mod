# Sukritact's Urban Identities - 地带特征与城市身份 完整分析报告

> 模组版本: v1 | 兼容版本: 1.2, 2.0 | 创建时间: 2024-11-13
> 作者: Sukritact, Leugi, CaptainLime, Pouakai
> 特别感谢: Andrew Dittmann, Matt Lambert, Pinary, Slothoth
> 模组ID: `b21bf49d-565e-42bb-a4e9-379a9facb54f`

---

## 1. 模组概述

- **模组名称**: Sukritact's Urban Identities
- **类型**: 游戏模式 (Game Mode)
- **依赖**: Gathering Storm (风云变幻) — `Expansion: Gathering Storm`
- **可选引用**: Sukritact's Oceans (当激活时，Sturdy Reeds 的描述会自动更新，Kelp Forest Region 也会被启用)
- **核心机制**: 地图上分布着各种地理区域 (Regions)，第一个在该区域建立或占领城市的文明获得该区域的"城市身份"(Identity)，赋予城市独特加成。每个区域从可用的身份池中随机分配一个身份，同一身份不会过度重复出现（频率权重系统）。

**游戏模式机制要点**:
- 身份分为两类：Regional Identities（区域身份，已实现）和 Urban Identities（城市身份，尚未实现）
- 区域身份通过在地图上未被认领的区域中建立或占领城市来获得
- 每个区域只能被认领一次
- 区域地块会获得 Plot Property 标记，用于后续的条件判断
- 游戏模式提供"区域覆盖率"设置，可调整区域覆盖地图的最大百分比（5%-30%，默认5%）

---

## 2. 区域类型 (Regions) — 14种

区域由 `Suk_RegionDefinitions_UrbanIdentities.lua` 中的集群算法动态生成，每种区域有不同的检测函数和参数。

| # | 区域ID | 英文名 | 中文名 | 检测逻辑 | 参数 |
|---|--------|--------|--------|----------|------|
| 1 | `REGION_SUK_FOREST` | Forest Region | 森林区域 | 森林地块 | MinSamples=2, Epsilon=1, MinSize=4, Dilate=1 |
| 2 | `REGION_SUK_JUNGLE` | Jungle Region | 雨林区域 | 雨林地块 | MinSamples=3, Epsilon=1, Dilate=1 |
| 3 | `REGION_SUK_CLIFFS` | Cliffs Region | 悬崖区域 | 悬崖及相邻地块 | MinSamples=2, Epsilon=1, Dilate=1, 剔除内陆远海地块 |
| 4 | `REGION_SUK_OASIS` | Oasis Region | 绿洲区域 | 绿洲地块 | MinSamples=1, Epsilon=3, Dilate=1 |
| 5 | `REGION_SUK_MOUNTAINS` | Mountain Region | 山脉区域 | 山脉地块 | MinSamples=2, Epsilon=1, MinSize=5, Dilate=1 |
| 6 | `REGION_SUK_KELP` | Kelp Forest Region | 海带林区域 | 海带林地块（需 Sukritact's Oceans） | MinSamples=2, Epsilon=1, MinSize=3, Dilate=1, 剔除内陆远海地块 |
| 7 | `REGION_SUK_REEF` | Reef Region | 珊瑚礁区域 | 珊瑚礁地块 | MinSamples=2, Epsilon=2, Dilate=1, 剔除内陆远海地块 |
| 8 | `REGION_SUK_HILLS` | Hills Region | 丘陵区域 | 无特征的丘陵地块（需3个以上相邻） | MinSamples=5, Epsilon=1, Dilate=0 |
| 9 | `REGION_SUK_PLAINS` | Plains Region | 平原区域 | 无特征的平原/草原地块（需3个以上相邻） | MinSamples=5, Epsilon=1, Dilate=0 |
| 10 | `REGION_SUK_GEOTHERMAL` | Geothermal Region | 地热区域 | 地热裂隙地块 | MinSamples=1, Epsilon=3, Dilate=1 |
| 11 | `REGION_SUK_MARSH` | Marsh Region | 沼泽区域 | 沼泽地块 | MinSamples=2, Epsilon=1, MinSize=4, Dilate=1 |
| 12 | `REGION_SUK_LAKE` | Lake Region | 湖泊区域 | 湖泊地块 | MinSamples=2, Epsilon=2, Dilate=1, 剔除内陆远海 |
| 13 | `REGION_SUK_DESERT` | Desert Region | 沙漠区域 | 无水沙漠/沙漠丘陵（需3个以上相邻） | MinSamples=5, Epsilon=1, Dilate=0 |
| 14 | `REGION_SUK_RIVER` | River Region | 河流区域 | 长河流经的非泛滥平原非海岸地块（河流长度≥20边） | MinSize=8, MinSamples=2, Epsilon=1, Dilate=0 |

**区域生成算法说明**:
- `CheckerFunction`: 判定一个地块是否属于该区域类型的节点
- `MinSamples`: 形成核心节点所需的最小邻居数
- `Epsilon`: 判定邻居的最大距离
- `MinSize`: 区域聚类的最小规模（低于此值将被剔除）
- `Dilate`: 最终确定前向外扩展的格数
- `CullingFunction`: 区域最终确定后的剔除函数（如移除远离海岸的海洋地块）
- 河流区域使用特殊逻辑：从 RiverManager 获取所有河流，选择长度≥20边的河流，随机截取一段作为区域节点

---

## 3. 城市身份 (Urban Identities) — 24种

### 身份分配机制

每个区域在游戏初始化时，从其关联的身份类型中随机选取一个。使用频率权重系统 (`m_IndentityFrequency`)：初始权重为10，每次被选中后权重减2，最低为0。这确保了同一身份不会在太多区域中重复出现。

---

### 3.1 原始身份 (20个)

#### 1. Hardwood Trees (硬木林)

- **身份ID**: `IDENTITY_SUK_HARDWOOD_TREES`
- **关联区域**: 雨林区域, 森林区域
- **效果**:
  - 每时代+1产能 (从远古时代开始，每进入一个新纪元+1产能)
  - 区域地块上的伐木场若相邻市中心或工业区，+2产能+1金币
- **风味文字**: *"The wood from this region is particularly suited for construction work, and is highly coveted."*
- **实现细节**: 使用 `Suk_Identities_YieldPerEra` 临时表动态生成每时代产能加成；使用 `Suk_UrbanIdentity_PlotProperties` 标记区域地块，通过 `Suk_Identities_DistrictAdjacencyRequirements` 注册相邻检查

---

#### 2. Underground Aquifers (地下含水层)

- **身份ID**: `IDENTITY_SUK_UNDERGROUND_AQUIFERS`
- **关联区域**: 绿洲区域, 沙漠区域
- **效果**:
  - +2住房
  - 可在平坦沙漠建造农场
  - 沙漠（非泛滥平原）上的农场和种植园+1食物+1金币
- **风味文字**: *"Water wells to the surface in unexpected places."*
- **实现细节**: 使用 `MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN` 使农场可在沙漠地形建造；使用 `MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD` 结合复杂条件集（沙漠+非泛滥平原+农场或种植园）提供产出加成

---

#### 3. Idyllic Scenery (田园风光)

- **身份ID**: `IDENTITY_SUK_IDYLLIC_SCENERY`
- **关联区域**: 森林区域, 河流区域, 湖泊区域
- **效果**:
  - +3宜居度
  - 区域地块上的城市公园+1食物+1文化
  - 允许建造城市公园（需要游戏与娱乐市政）
- **风味文字**: *"The view brings peace and comfort to weary souls."*
- **实现细节**: 使用 `MODIFIER_CITY_ADJUST_ALLOWED_IMPROVEMENT` 解锁城市公园建造权限；使用 `REQUIREMENT_PLOT_ADJACENT_IMPROVEMENT_TYPE_MATCHES` 检测城市公园（MinRange=0, MaxRange=0 表示精确匹配该地块本身）

---

#### 4. Open Skies (开阔天空)

- **身份ID**: `IDENTITY_SUK_OPEN_SKIES`
- **关联区域**: 平原区域, 沙漠区域
- **效果**:
  - 区域地块相邻学院+1科技
  - 有大学时，区域地块相邻学院+2科技（叠加效果：有大学时总共+2科技）
- **风味文字**: *"With neither trees nor mountains, one gets a breathtaking view of the night skies."*
- **实现细节**: 两个独立的 Modifier，第二个的 `OwnerRequirementSetId` 为 `SUK_IDENTITY_OPEN_SKIES_CITY_HAS_UNIVERSITY`（需要城市有大学）。两个 Modifier 都作用于同一地块，产生叠加效果

---

#### 5. Prophetic Visions (先知幻象)

- **身份ID**: `IDENTITY_SUK_PROPHETIC_VISIONS`
- **关联区域**: 地热区域, 沼泽区域
- **效果**:
  - 区域地块相邻圣地+1信仰+1文化
  - 有寺庙时，区域地块相邻圣地+2信仰+2文化（叠加效果：总共+2信仰+2文化）
  - +1大先知点数
- **风味文字**: *"For some reason, holy men say their divination works better here. Perhaps something in the air?"*
- **实现细节**: 大先知点数使用 `MODIFIER_PLAYER_ADJUST_GREAT_PERSON_POINTS`，作用于玩家级别

---

#### 6. Mountain Pass (山隘)

- **身份ID**: `IDENTITY_SUK_MOUNTAIN_PASS`
- **关联区域**: 山脉区域
- **效果**:
  - 区域地块上的商业中心+4金币+1商路容量
- **风味文字**: *"Traders from beyond the peaks inevitably pass through this humble valley."*
- **实现细节**: 使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE` 和 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY`，条件为商业中心且位于区域地块

---

#### 7. Ocean Swells (海浪汹涌)

- **身份ID**: `IDENTITY_SUK_OCEAN_SWELLS`
- **关联区域**: 海带林区域, 珊瑚礁区域, 悬崖区域
- **效果**:
  - 每个相邻海岸的城区+2金币+1宜居度
- **风味文字**: *"The waves make this location less than ideal for boating, but their impressive strength is a draw for sightseers and thrillseekers."*
- **实现细节**: 使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE` 和 `MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY`，条件为 `PLOT_IS_COASTAL_LAND_XP2` 且非世界奇观

---

#### 8. Natural Harbor (天然良港)

- **身份ID**: `IDENTITY_SUK_NATURAL_HARBOR`
- **关联区域**: 珊瑚礁区域, 悬崖区域, 海带林区域
- **效果**:
  - 港口每相邻区域+2食物
  - 港口和建筑+50%建造速度
- **风味文字**: *"With deep and calm waters, this sheltered inlet offers a welcome respite from the ocean's fury."*
- **实现细节**: 港口区域建造速度使用 `MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION`（Amount=50），港口建筑建造速度使用 `MODIFIER_SUK_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION`（Amount=50）；食物相邻加成使用 `MODIFIER_SUK_SINGLE_CITY_DISTRICT_ADJACENCY`

---

#### 9. Karst Aquifers (喀斯特含水层)

- **身份ID**: `IDENTITY_SUK_KARST_AQUIFERS`
- **关联区域**: 平原区域, 沼泽区域, 湖泊区域, 河流区域
- **效果**:
  - +2住房+1宜居度
  - 水渠+2食物
- **风味文字**: *"Water may be plentiful, but there's a risk of sinkholes opening up beneath your feet."*
- **实现细节**: 住房和宜居度使用独立的 Modifier；水渠食物加成使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE`，条件集为 `DISTRICT_IS_AQUEDUCT`

---

#### 10. Fog Deserts (雾漠)

- **身份ID**: `IDENTITY_SUK_FOG_DESERTS`
- **关联区域**: 沙漠区域
- **效果**:
  - +2住房
  - 已改良区域地块+2食物
  - 区域地块上的城区+1住房
- **风味文字**: *"Rolling clouds of fog from moister areas bring in water that can be trapped by both the local flora and humans alike."*
- **实现细节**: 已改良地块食物加成使用 `MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD` 配合 `REQUIRES_SUK_PLOT_HAS_ANY_IMPROVEMENT` 条件；城区住房加成使用 `MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING` 配合 `REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER` 条件

---

#### 11. Alluvial Placer (冲积矿床)

- **身份ID**: `IDENTITY_SUK_ALLUVIAL_PLACER`
- **关联区域**: 河流区域
- **效果**:
  - 相邻河流的矿井+2金币
  - 区域地块上的矿井+1产能
- **风味文字**: *"Carried by the current and mixed in with the sediment, are precious minerals and metals."*
- **实现细节**: 两个独立的 `MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD`，金币加成条件为矿井+相邻河流，产能加成条件为矿井+区域地块标记

---

#### 12. Freshwater Fishery (淡水渔场)

- **身份ID**: `IDENTITY_SUK_FRESHWATER_FISHERY`
- **关联区域**: 湖泊区域
- **效果**:
  - 区域地块上的港口每相邻湖泊+1食物+2金币
- **风味文字**: *"The aquatic life here is rich, both in quantity, and in taste!"*
- **实现细节**: 使用 `MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER` 将子 Modifier 附加到符合条件的港口（区域地块+港口），子 Modifier 使用 `MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY` 提供海岸地形的相邻加成描述

---

#### 13. Surface Deposits (地表矿床)

- **身份ID**: `IDENTITY_SUK_SURFACE_DEPOSITS`
- **关联区域**: 平原区域
- **效果**:
  - 有军营时+15%单位产能
  - 区域地块上的军营+2产能+2科技
- **风味文字**: *"While maybe not enough for heavy industry, there is enough metal here for household tools, and perhaps... some horseshoes and weapons?"*
- **实现细节**: 单位产能加成使用 `MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION`，条件为 `CITY_HAS_ENCAMPMENT`

---

#### 14. Vantage Points (制高点)

- **身份ID**: `IDENTITY_SUK_VANTAGE_POINTS`
- **关联区域**: 山脉区域, 丘陵区域, 悬崖区域
- **效果**:
  - 区域地块上的单位+2视野（无视所有权）
  - 区域地块上的军营训练的远程和侦察单位免费晋升
  - 区域地块上的军营+2食物
- **风味文字**: *"The terrain makes it impossible for more than a small group to sneak through the region without someone noticing."*
- **实现细节**: 视野加成使用 `MODIFIER_ALL_UNITS_ATTACH_MODIFIER`（作为 GameModifier 而非城市 Modifier），条件为地块位于区域；免费晋升使用 `MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE`（Amount=-1 表示免费晋升），条件为远程或侦察单位

---

#### 15. Sturdy Reeds (坚韧芦苇)

- **身份ID**: `IDENTITY_SUK_STURDY_REEDS`
- **关联区域**: 湖泊区域, 海带林区域
- **效果**:
  - 区域内的湖泊地块若在市中心或商业中心2格内+1产能，两者都在范围内+2产能
- **风味文字**: *"The ponds and coasts in the area nurture a particularly sturdy type of reed that is particularly suited for craftwork and construction."*
- **实现细节**: 两个独立的 Modifier 分别检查市中心和商业中心的范围（MaxRange=2）；当 Sukritact's Oceans 激活时，描述从"Lake tiles"更新为"Lake and Kelp Forest tiles"；海带林兼容通过 `REQUIRES_PLOT_HAS_SUK_KELP` 条件动态添加

---

#### 16. Windy Plains (多风平原)

- **身份ID**: `IDENTITY_SUK_WINDY_PLAINS`
- **关联区域**: 平原区域
- **效果**:
  - 区域地块上的工业区相邻农场+2食物，相邻矿井+2产能
  - 可在平坦平原和草原建造风力发电场
- **风味文字**: *"The grass is constantly swaying with the gales. Anything not tied down has a tendency to get blown away. This may be a good spot for a couple of windmills..."*
- **实现细节**: 农场和矿井加成使用 `MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER` 附加到工业区；风力发电场使用 `MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN` 分别解锁平原和草原地形

---

#### 17. Altitude Training (高原训练)

- **身份ID**: `IDENTITY_SUK_ALTITUDE_TRAINING`
- **关联区域**: 山脉区域
- **效果**:
  - 市中心获得山脉食物相邻加成
  - 有水渠或军营时，训练的单位无视丘陵移动惩罚
- **风味文字**: *"The incredible altitudes require people who live here to physically adapt to the low oxygen environment."*
- **实现细节**: 山脉食物相邻加成使用 `MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY`，动态对所有山脉类型生成 Modifier；无视丘陵移动使用单位能力 `ABILITY_IDENTITY_SUK_ALTITUDE_TRAINING`，通过 `MODIFIER_SINGLE_CITY_GRANT_ABILITY_FOR_TRAINED_UNITS` 授予，条件为有水渠或军营

---

#### 18. Defensible Cliffs (可守悬崖)

- **身份ID**: `IDENTITY_SUK_DEFENSIBLE_CLIFFS`
- **关联区域**: 悬崖区域
- **效果**:
  - 军营获得海岸金币相邻加成
  - 区域地块上的军营+1商路容量
- **风味文字**: *"These cliffs overlook a stretch of water that will prove vital to maritime commerce. It would behoove those living here to secure them."*
- **实现细节**: 海岸相邻加成使用 `MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY`（DistrictType=ENCAMPMENT, TerrainType=COAST, YieldType=GOLD）；商路容量使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY`

---

#### 19. Clay Deposits (黏土矿床)

- **身份ID**: `IDENTITY_SUK_CLAY_DEPOSITS`
- **关联区域**: 平原区域, 湖泊区域, 河流区域
- **效果**:
  - 区域地块上的剧院广场+2文化相邻
  - 相邻工业区时，剧院广场获得等同于文化相邻加成的产能
- **风味文字**: *"High-quality and plentiful clay deposits fuel the creation of kilns to craft gorgeous works of ceramics and porcelain."*
- **实现细节**: 文化相邻加成使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE`；产能映射使用 `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS`（通过 `MODIFIER_PLAYER_DISTRICT_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS`，YieldTypeToMirror=CULTURE, YieldTypeToGrant=PRODUCTION）

---

#### 20. Igneous Intrusion (火成侵入)

- **身份ID**: `IDENTITY_SUK_IGNEOUS_INTRUSION`
- **关联区域**: 丘陵区域
- **效果**:
  - 可在丘陵上建造采石场
  - 区域地块上的采石场+1产能
  - 区域地块上有工业区时+15%奇观产能
- **风味文字**: *"Formed from magma cooled beneath the earth, much of the rock that constitute these hills is excellent for monumental construction."*
- **实现细节**: 采石场丘陵解锁使用 `MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN`，动态对所有丘陵地形类型生成 Modifier；奇观产能加成使用 `MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER` 附加到工业区，子 Modifier 使用 `MODIFIER_SINGLE_CITY_ADJUST_WONDER_PRODUCTION`

---

### 3.2 ML迁移身份 (4个) — 从 More Urban Identities (Maple_Leaves) 迁移

这些身份最初来自 Maple_Leaves 的 More Urban Identities 模组，已被迁移并整合到 Sukritact's Urban Identities 中，使用 Sukritact 的原始区域系统。

---

#### 21. Vertical Climate (垂直气候)

- **身份ID**: `IDENTITY_SUK_ML_VERTICAL_CLIMATE`
- **关联区域**: 山脉区域
- **效果**:
  - 区域未改良地块+1科技，研究科学理论后+2科技（叠加效果：总共+2科技）
  - +30%学院建造速度
- **风味文字**: *"Spring lies at the mountain's base, winter at its peak. Every inch of elevation here holds a distinct climate and life."*
- **实现细节**: 使用 `MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD`，条件为未改良+区域地块；科学理论后使用第二个 Modifier，OwnerRequirementSetId 为玩家拥有科学理论科技；学院建造速度使用 `MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML`

---

#### 22. Monsoon Valley (季风山谷)

- **身份ID**: `IDENTITY_SUK_ML_MONSOON_VALLEY`
- **关联区域**: 雨林区域
- **效果**:
  - 区域雨林地块+2食物
  - 区域种植园+2金币
- **风味文字**: *"The monsoon breezes through, whispering through the rainforest. Every leaf breathes, every fruit sings."*
- **实现细节**: 食物加成条件为雨林+区域地块；金币加成条件为种植园+区域地块

---

#### 23. Yew Grove (紫杉林)

- **身份ID**: `IDENTITY_SUK_ML_YEW_GROVE`
- **关联区域**: 森林区域
- **效果**:
  - 区域伐木场+2产能
  - 远古至中世纪远程单位+30%建造速度
- **风味文字**: *"The yew trees stand tall and straight, their arrows swift as the wind. The timber from these trees once forged countless divine bows and mighty crossbows."*
- **实现细节**: 远程单位生产加成使用 `MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML`，分别针对远古、古典、中世纪三个时代的远程单位，各+30%

---

#### 24. Oasis Trading Post (绿洲贸易站)

- **身份ID**: `IDENTITY_SUK_ML_OASIS_TRADING_POST`
- **关联区域**: 绿洲区域
- **效果**:
  - 商业中心获得绿洲+4金币相邻加成
  - 有商业中心时+1商路容量
- **风味文字**: *"In the desert, there lies a clear spring. For merchants and travelers who arrive here, it marks both the end of their journey and the beginning of a new one."*
- **实现细节**: 绿洲相邻加成使用 `MODIFIER_SINGLE_CITY_FEATURE_ADJACENCY`（DistrictType=COMMERCIAL_HUB, FeatureType=OASIS, YieldType=GOLD, Amount=4）；商路容量使用 `MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY`，条件为城市有商业中心

---

## 4. 自定义 Modifier/Requirement 系统

### 4.1 DynamicModifiers (10个自定义效果类型)

这些是 Sukritact 为 Urban Identities 模组创建的专用 Modifier 类型，提供了标准游戏引擎未提供的自定义效果能力。

| # | ModifierType | CollectionType | EffectType | 用途 |
|---|-------------|----------------|------------|------|
| 1 | `MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER` | `COLLECTION_CITY_DISTRICTS` | `EFFECT_ATTACH_MODIFIER` | 将子 Modifier 附加到城市中符合条件的城区 |
| 2 | `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_BASE_YIELD_CHANGE` | `COLLECTION_CITY_DISTRICTS` | `EFFECT_ADJUST_DISTRICT_BASE_YIELD_CHANGE` | 调整城区的基础产出变化 |
| 3 | `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS` | `COLLECTION_CITY_DISTRICTS` | `EFFECT_ADJUST_DISTRICT_YIELD_BASED_ON_ADJACENCY_BONUS` | 根据城区的相邻加成提供额外产出（如 Clay Deposits 的产能映射） |
| 4 | `MODIFIER_SUK_SINGLE_CITY_DISTRICT_ADJACENCY` | `COLLECTION_OWNER` | `EFFECT_DISTRICT_ADJACENCY` | 在单城市范围内为特定城区添加相邻加成（如 Natural Harbor 的食物相邻） |
| 5 | `MODIFIER_SUK_SINGLE_CITY_TERRAIN_ADJACENCY` | `COLLECTION_OWNER` | `EFFECT_TERRAIN_ADJACENCY` | 在单城市范围内为特定城区添加地形相邻加成（如 Altitude Training 的山脉食物相邻） |
| 6 | `MODIFIER_SUK_SINGLE_CITY_ADJUST_IMPROVEMENT_VALID_TERRAIN` | `COLLECTION_OWNER` | `EFFECT_ADJUST_IMPROVEMENT_VALID_TERRAIN` | 调整单城市范围内改良设施的有效地形（如 Underground Aquifers 在沙漠上建农场） |
| 7 | `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_DISTRICT_YIELD_CHANGE` | `COLLECTION_CITY_DISTRICTS` | `EFFECT_ADJUST_DISTRICT_YIELD_CHANGE` | 调整城市中特定城区的产出（如 Mountain Pass 商业中心+4金币） |
| 8 | `MODIFIER_SUK_CITY_DISTRICTS_ADJUST_TRADE_ROUTE_CAPACITY` | `COLLECTION_CITY_DISTRICTS` | `EFFECT_ADJUST_TRADE_ROUTE_CAPACITY` | 调整城市中特定城区的商路容量（如 Mountain Pass 商业中心+1商路） |
| 9 | `MODIFIER_SUK_SINGLE_CITY_ADJUST_BUILDING_PRODUCTION` | `COLLECTION_OWNER` | `EFFECT_ADJUST_BUILDING_PRODUCTION` | 调整单城市中特定城区建筑的建造速度（如 Natural Harbor 港口建筑+50%） |
| 10 | `MODIFIER_SUK_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION` | `COLLECTION_OWNER` | `EFFECT_ADJUST_DISTRICT_PRODUCTION` | 调整单城市中特定城区的建造速度（如 Natural Harbor 港口+50%） |

### 4.2 ML迁移 DynamicModifiers (2个额外类型)

这些是从 More Urban Identities (Maple_Leaves) 迁移的自定义 Modifier 类型。

| # | ModifierType | CollectionType | EffectType | 用途 |
|---|-------------|----------------|------------|------|
| 11 | `MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_SUK_ID_ML` | `COLLECTION_OWNER` | `EFFECT_ADJUST_DISTRICT_PRODUCTION` | 调整单城市中特定城区的建造速度（如 Vertical Climate 学院+30%） |
| 12 | `MODIFIER_SINGLE_CITY_ADJUST_UNIT_TAG_ERA_PRODUCTION_SUK_ID_ML` | `COLLECTION_OWNER` | `EFFECT_ADJUST_UNIT_TAG_ERA_PRODUCTION` | 调整单城市中特定时代和兵种标签的单位建造速度（如 Yew Grove 远程单位+30%） |

---

### 4.2 通用 Modifier

这些是可被多个身份复用的通用 Modifier。

#### 区域建造惩罚

| ModifierId | 类型 | 惩罚值 | 说明 |
|-----------|------|--------|------|
| `SUK_IDENTITY_GENERIC_DISTRICT_MALUS` | `MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER` | -15% | 常规区域建造惩罚 |
| `SUK_IDENTITY_GENERIC_DISTRICT_MALUS_MAJOR` | `MODIFIER_SINGLE_CITY_ADJUST_DISTRICT_PRODUCTION_MODIFIER` | -30% | 严重区域建造惩罚 |

#### 住房

| ModifierId | 类型 | 值 | 条件 |
|-----------|------|-----|------|
| `SUK_IDENTITY_GENERIC_HOUSING_1` | `MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING` | +1 | 城区为市中心 |
| `SUK_IDENTITY_GENERIC_HOUSING_2` | `MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING` | +2 | 城区为市中心 |
| `SUK_IDENTITY_GENERIC_HOUSING_3` | `MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_HOUSING` | +3 | 城区为市中心 |

#### 宜居度

| ModifierId | 类型 | 值 |
|-----------|------|-----|
| `SUK_IDENTITY_GENERIC_AMENITIES_1` | `MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT` | +1 |
| `SUK_IDENTITY_GENERIC_AMENITIES_2` | `MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT` | +2 |
| `SUK_IDENTITY_GENERIC_AMENITIES_3` | `MODIFIER_SINGLE_CITY_ADJUST_ENTERTAINMENT` | +3 |

#### 每时代产出

通过 `Suk_Identities_YieldPerEra` 临时表动态生成，涵盖所有时代（ANCIENT 至 INFORMATION 等）与两种产出类型（PRODUCTION 和 SCIENCE）的笛卡尔积：

- 格式: `SUK_IDENTITY_PRODUCTION_PER_ERA_ANCIENT`, `SUK_IDENTITY_PRODUCTION_PER_ERA_CLASSICAL`, ...
- 格式: `SUK_IDENTITY_SCIENCE_PER_ERA_ANCIENT`, `SUK_IDENTITY_SCIENCE_PER_ERA_CLASSICAL`, ...
- 每个 Modifier 值为 +1，远古时代无 OwnerRequirementSetId，其他时代使用 `SUK_GAME_ERA_AFTER_{ERA}_REQUIREMENTS` 条件集

---

### 4.3 自定义 Requirement

#### 区域相邻检查

| RequirementId | RequirementType | 参数 | 说明 |
|---------------|-----------------|------|------|
| `REQUIRES_SUK_IDENITY_REGIONAL_6` | `REQUIREMENT_PLOT_ADJACENT_TO_OWNER` | MinDistance=0, MaxDistance=6 | 地块是否在6格范围内相邻于拥有者 |

#### 城市是否有特定城区

| RequirementId | RequirementType | 参数 | 说明 |
|---------------|-----------------|------|------|
| `REQUIRES_CITY_HAS_AQUEDUCT` | `REQUIREMENT_CITY_HAS_DISTRICT` | DistrictType=`DISTRICT_AQUEDUCT` | 城市是否有水渠 |

#### 城市是否没有特定城区（Inverse）

| RequirementId | RequirementType | 参数 | 说明 |
|---------------|-----------------|------|------|
| `REQUIRES_SUK_CITY_HAS_NO_INDUSTRIAL_ZONE` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_INDUSTRIAL_ZONE` | 城市无工业区 |
| `REQUIRES_SUK_CITY_HAS_NO_CAMPUS` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_CAMPUS` | 城市无学院 |
| `REQUIRES_SUK_CITY_HAS_NO_HARBOR` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_HARBOR` | 城市无港口 |
| `REQUIRES_SUK_CITY_HAS_NO_HOLY_SITE` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_HOLY_SITE` | 城市无圣地 |
| `REQUIRES_SUK_CITY_HAS_NO_SPACEPORT` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_SPACEPORT` | 城市无航天中心 |
| `REQUIRES_SUK_CITY_HAS_NO_DAM` | `REQUIREMENT_CITY_HAS_DISTRICT` (Inverse) | DistrictType=`DISTRICT_DAM` | 城市无水坝 |

#### 玩家是否拥有特定科技/市政

| RequirementId | RequirementType | 参数 |
|---------------|-----------------|------|
| `REQUIRES_SUK_PLAYER_HAS_EDUCATION` | `REQUIREMENT_PLAYER_HAS_TECHNOLOGY` | TechnologyType=`TECH_EDUCATION` |
| `REQUIRES_SUK_PLAYER_HAS_DRAMA_AND_POETRY` | `REQUIREMENT_PLAYER_HAS_CIVIC` | CivicType=`CIVIC_DRAMA_POETRY` |
| `REQUIRES_SUK_PLAYER_HAS_MYSTICISM` | `REQUIREMENT_PLAYER_HAS_CIVIC` | CivicType=`CIVIC_MYSTICISM` |

#### 地块属性

| RequirementId | RequirementType | 参数 | 说明 |
|---------------|-----------------|------|------|
| `REQUIRES_SUK_DISTRICT_IS_NOT_WORLD_WONDER` | `REQUIREMENT_DISTRICT_TYPE_MATCHES` (Inverse) | DistrictType=`DISTRICT_WONDER` | 地块非世界奇观 |
| `REQUIRES_SUK_PLOT_HAS_ANY_IMPROVEMENT` | `REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT` | — | 地块是否有任何改良设施 |

#### ML迁移 Requirement

| RequirementId | RequirementType | 参数 | 说明 |
|---------------|-----------------|------|------|
| `REQUIRES_PLOT_HAS_NO_IMPROVEMENT_SUK_ID_ML` | `REQUIREMENT_PLOT_HAS_ANY_IMPROVEMENT` (Inverse) | — | 地块无改良设施 |
| `REQUIRES_PLAYER_HAS_TECH_SCIENTIFIC_THEORY_SUK_ID_ML` | `REQUIREMENT_PLAYER_HAS_TECHNOLOGY` | TechnologyType=`TECH_SCIENTIFIC_THEORY` | 玩家拥有科学理论科技 |

---

## 5. 区域邻接系统

### 5.1 Suk_Identities_DistrictAdjacencyRequirements 表

这是一个临时设置表，用于定义身份所需的城区相邻检查。在 `Suk_UrbanIdentities__AdjacencySetup.sql` 中，该表的数据被处理后自动生成完整的 Requirement/RequirementSet/RequirementArgument 条目，然后该表被删除。

**已注册的相邻检查条目**:

| RequirementId | DistrictType | MinRange | MaxRange | 使用者 |
|---------------|-------------|----------|----------|--------|
| `REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CITY_CENTER` | `DISTRICT_CITY_CENTER` | NULL | NULL | Hardwood Trees, Sturdy Reeds |
| `REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_INDUSTRIAL_ZONE` | `DISTRICT_INDUSTRIAL_ZONE` | NULL | NULL | Hardwood Trees, Clay Deposits |
| `REQUIRES_SUK_URBIDENT_PLOT_ADJACENT_TO_CAMPUS` | `DISTRICT_CAMPUS` | NULL | NULL | Open Skies |
| `REQUIRES_SUK_STURDY_REEDS_NEAR_CITY_CENTER` | `DISTRICT_CITY_CENTER` | NULL | 2 | Sturdy Reeds |
| `REQUIRES_SUK_STURDY_REEDS_NEAR_COMMERCIAL_HUB` | `DISTRICT_COMMERCIAL_HUB` | NULL | 2 | Sturdy Reeds |

### 5.2 自动化邻接处理流程

`Suk_UrbanIdentities__AdjacencySetup.sql` 执行以下步骤：

1. **生成 RequirementSetRequirements**: 为每个 `Suk_Identities_DistrictAdjacencyRequirements` 条目创建对应的 `__REQUIREMENTS` 条件集，使用 `REQUIREMENTSET_TEST_ANY`
2. **生成 Requirements**: 为每个条目和所有基础/独特城区组合创建 `REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES` 类型的 Requirement
3. **生成 RequirementArguments**: 为每个 Requirement 填充 DistrictType、MinRange、MaxRange 参数
4. **6个数据库触发器**: 确保当新模组添加独特城区时，邻接系统能自动适配

### 5.3 触发器列表

| 触发器名称 | 触发时机 | 作用 |
|-----------|---------|------|
| `Suk_Identities_UniqueDistrict_RequirementSets` | AFTER INSERT ON DistrictReplaces | 为新独特城区创建 RequirementSetRequirements |
| `Suk_Identities_UniqueDistrict_Requirements` | AFTER INSERT ON DistrictReplaces | 为新独特城区创建 Requirements |
| `Suk_Identities_UniqueDistrict_Requirements_DistrictArg` | AFTER INSERT ON DistrictReplaces | 为新独特城区填充 DistrictType 参数 |
| `Suk_Identities_UniqueDistrict_Requirements_MinArg` | AFTER INSERT ON DistrictReplaces | 为新独特城区填充 MinRange 参数 |
| `Suk_Identities_UniqueDistrict_Requirements_MaxArg` | AFTER INSERT ON DistrictReplaces | 为新独特城区填充 MaxRange 参数 |
| `Suk_Identities_UniqueDistrict_Requirements` (第二个) | AFTER INSERT ON DistrictReplaces | 多一个独立的 Requirements 触发器 |

### 5.4 标准城区相邻加成

`Suk_UrbanIdentities_RegionIdentities.sql` 中的 `Suk_DistrictAdjacencies` 临时表从所有标准城区的相邻加成数据中提取信息，用于生成 Altitude Training 等身份的山脉食物相邻加成描述。它从 `Districts`、`District_Adjacencies`、`Adjacency_YieldChanges`、`Requirements` 表中联合查询，仅包含需要人口(`RequiresPopulation=1`)且非独特城区替换的城区。

---

## 6. 兼容性

### 6.1 依赖

- **Gathering Storm (风云变幻)**: 强制依赖 (`Mod id="4873eb62-8ccc-4574-b784-dda455e74e68"`)
- 游戏模式仅在 Gathering Storm 规则集下可用（`RULESET_EXPANSION_1` 或 `RULESET_EXPANSION_2`）

### 6.2 引用

- **Sukritact's Oceans**: 可选引用 (`Mod id="4922ba47-61e1-4b15-9281-db996b14522d"`)
- 当 Sukritact's Oceans 激活时的影响：
  - **Kelp Forest Region** (`REGION_SUK_KELP`): 仅在检测到 `FEATURE_SUK_KELP` 存在时才会注册
  - **Sturdy Reeds 描述更新**: 描述从 "Lake tiles" 自动更新为 "Lake and Kelp Forest tiles"
  - **Sturdy Reeds 海带林兼容**: `IDENTITY_SUK_STURDY_REEDS_IS_LAKE_OR_KELP_REQUIREMENTS` 条件集会动态添加 `REQUIRES_PLOT_HAS_SUK_KELP` 条件

### 6.3 独特城区兼容

- 通过6个数据库触发器，当任何模组添加独特城区（替换标准城区）时，Urban Identities 的邻接系统会自动为新独特城区生成对应的 Requirement 和 RequirementSet
- `Suk_Identities_DistrictAdjacencyRequirements` 表中注册的城区类型会自动匹配所有替换该城区的独特城区

### 6.4 其他模组兼容

- **JNR 沼泽**: 河流区域检测中包含 `FEATURE_JNR_SWAMP`（如果存在）
- **JNR 冻土泛滥平原**: 河流区域检测中包含 `FEATURE_FLOODPLAINS_TUNDRA`（如果存在）

---

## 7. 数据库架构

### 7.1 自定义表

| 表名 | 用途 | 生命周期 |
|------|------|----------|
| `Suk_Regions` | 存储区域类型定义 | 持久 |
| `Suk_UrbanIdentities` | 存储身份类型定义（名称、描述、风味、是否仅区域获取） | 持久 |
| `Suk_UrbanIdentity_Regions` | 身份与区域的关联表 | 持久 |
| `Suk_UrbanIdentity_Modifiers` | 身份与 Modifier 的关联表 | 持久 |
| `Suk_UrbanIdentity_PlotProperties` | 身份的地块属性定义（标记区域地块） | 持久 |
| `Suk_Identities_DistrictAdjacencyRequirements` | 城区相邻检查的临时设置表 | 临时（设置完成后删除） |

### 7.2 自定义 Kind

| Kind | 用途 |
|------|------|
| `KIND_SUK_REGION` | 区域类型分类 |
| `KIND_SUK_URBANIDENTITY` | 身份类型分类 |

---

## 8. 用户界面 (UI)

### 8.1 区域覆盖层

- **Region Labels**: 在地图上显示区域名称和边界
- **Region Lens**: 切换区域显示 (`LOC_HUD_TOGGLE_SUK_REGIONS`)
- **Screenshot Mode**: 可在截图模式下隐藏区域横幅
- **Claimed/Unclaimed**: 已认领区域显示绿色，未认领区域显示红色

### 8.2 文明百科

- **百科分区**: `SUK_IDENTITIES`（排序索引 61）
- **页面组**: `SUK_IDENTITIES_REGIONAL`（区域身份）、`SUK_IDENTITIES_URBAN`（城市身份，尚未实现）
- **自定义页面布局**: `Suk_Identities` 布局，使用 `CivilopediaPage_Suk_UrbanIdentities.lua` 脚本模板
- **百科查询**: 从 `Suk_UrbanIdentities` 表动态生成区域身份页面（`RegionOnly=1`）

### 8.3 游戏模式设置

- **区域覆盖率 (Region Coverage)**: 5%-30% 范围，默认 5%，控制地图上区域覆盖的最大百分比
- 设置项位于 `MapOptions` 组中

---

## 9. Lua 脚本架构

### 9.1 核心脚本

| 文件 | 功能 |
|------|------|
| `Suk_UrbanIdentities_Master.lua` | 主入口，协调所有子模块 |
| `Suk_RegionCreator.lua` | 区域创建引擎，使用 DBSCAN 聚类算法 |
| `Suk_RegionDefinitions_UrbanIdentities.lua` | 14种区域类型的定义（检测函数和参数） |
| `Suk_RegionIdentities.lua` | 身份分配引擎（为每个区域随机选择身份并标记地块） |
| `Suk_IdentitiesManager.lua` | 城市身份管理（认领区域、附加/移除 Modifier） |

### 9.2 模块

| 文件 | 功能 |
|------|------|
| `Modules/PlotIterators.lua` | 地块遍历工具函数 |
| `Modules/Suk_MapConvolution.lua` | 地图卷积/聚类算法（DBSCAN 实现） |

### 9.3 UI 脚本

| 文件 | 功能 |
|------|------|
| `UI/Suk_RegionOverlay.xml` + `.lua` | 区域覆盖层 UI |
| `UI/Suk_RegionLens.xml` + `.lua` | 区域透镜 UI |
| `UI/CivilopediaPage_Suk_UrbanIdentities.lua` | 文明百科页面模板 |

---

## 10. 身份与区域完整映射表

| # | 身份名称 | 身份ID | 森林 | 雨林 | 悬崖 | 绿洲 | 山脉 | 海带林 | 珊瑚礁 | 丘陵 | 平原 | 地热 | 沼泽 | 湖泊 | 沙漠 | 河流 |
|---|---------|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | Hardwood Trees | `IDENTITY_SUK_HARDWOOD_TREES` | ✓ | ✓ | | | | | | | | | | | | |
| 2 | Underground Aquifers | `IDENTITY_SUK_UNDERGROUND_AQUIFERS` | | | | ✓ | | | | | | | | | ✓ | |
| 3 | Idyllic Scenery | `IDENTITY_SUK_IDYLLIC_SCENERY` | ✓ | | | | | | | | | | | ✓ | | ✓ |
| 4 | Open Skies | `IDENTITY_SUK_OPEN_SKIES` | | | | | | | | | ✓ | | | | ✓ | |
| 5 | Prophetic Visions | `IDENTITY_SUK_PROPHETIC_VISIONS` | | | | | | | | | | ✓ | ✓ | | | |
| 6 | Mountain Pass | `IDENTITY_SUK_MOUNTAIN_PASS` | | | | | ✓ | | | | | | | | | |
| 7 | Ocean Swells | `IDENTITY_SUK_OCEAN_SWELLS` | | | ✓ | | | ✓ | ✓ | | | | | | | |
| 8 | Natural Harbor | `IDENTITY_SUK_NATURAL_HARBOR` | | | ✓ | | | ✓ | ✓ | | | | | | | |
| 9 | Karst Aquifers | `IDENTITY_SUK_KARST_AQUIFERS` | | | | | | | | | ✓ | | ✓ | ✓ | | ✓ |
| 10 | Fog Deserts | `IDENTITY_SUK_FOG_DESERTS` | | | | | | | | | | | | | ✓ | |
| 11 | Alluvial Placer | `IDENTITY_SUK_ALLUVIAL_PLACER` | | | | | | | | | | | | | | ✓ |
| 12 | Freshwater Fishery | `IDENTITY_SUK_FRESHWATER_FISHERY` | | | | | | | | | | | | ✓ | | |
| 13 | Surface Deposits | `IDENTITY_SUK_SURFACE_DEPOSITS` | | | | | | | | | ✓ | | | | | |
| 14 | Vantage Points | `IDENTITY_SUK_VANTAGE_POINTS` | | | ✓ | | ✓ | | | ✓ | | | | | | |
| 15 | Sturdy Reeds | `IDENTITY_SUK_STURDY_REEDS` | | | | | | ✓ | | | | | | ✓ | | |
| 16 | Windy Plains | `IDENTITY_SUK_WINDY_PLAINS` | | | | | | | | | ✓ | | | | | |
| 17 | Altitude Training | `IDENTITY_SUK_ALTITUDE_TRAINING` | | | | | ✓ | | | | | | | | | |
| 18 | Defensible Cliffs | `IDENTITY_SUK_DEFENSIBLE_CLIFFS` | | | ✓ | | | | | | | | | | | |
| 19 | Clay Deposits | `IDENTITY_SUK_CLAY_DEPOSITS` | | | | | | | | | ✓ | | | ✓ | | ✓ |
| 20 | Igneous Intrusion | `IDENTITY_SUK_IGNEOUS_INTRUSION` | | | | | | | | ✓ | | | | | | |
| 21 | Vertical Climate | `IDENTITY_SUK_ML_VERTICAL_CLIMATE` | | | | | ✓ | | | | | | | | | |
| 22 | Monsoon Valley | `IDENTITY_SUK_ML_MONSOON_VALLEY` | | ✓ | | | | | | | | | | | | |
| 23 | Yew Grove | `IDENTITY_SUK_ML_YEW_GROVE` | ✓ | | | | | | | | | | | | | |
| 24 | Oasis Trading Post | `IDENTITY_SUK_ML_OASIS_TRADING_POST` | | | | ✓ | | | | | | | | | | |

---

## 11. 技术亮点总结

1. **DBSCAN 聚类算法**: 区域使用基于密度的空间聚类算法 (DBSCAN) 在地图上生成，确保了区域的自然地理分布
2. **频率权重系统**: 身份分配使用指数衰减权重 (`3^(frequency-10)`)，确保身份多样性，避免同一身份过度出现
3. **Plot Property 标记系统**: 通过 `Suk_UrbanIdentity_PlotProperties` 表将身份标记应用到区域地块，后续的 Modifier 条件通过 `REQUIREMENT_PLOT_PROPERTY_MATCHES` 检查这些标记
4. **Modifier 链式附加**: 多个身份使用 `MODIFIER_SUK_CITY_DISTRICTS_ATTACH_MODIFIER` 将子 Modifier 附加到特定城区，实现复杂的条件级联
5. **独特城区自动适配**: 6个数据库触发器确保任何添加独特城区的模组都能自动获得兼容
6. **动态时代产出生成**: 通过 `Suk_Identities_YieldPerEra` 临时表与游戏时代的笛卡尔积自动生成所有时代的产出 Modifier
7. **可选模组动态适配**: Kelp Forest Region 和 Sturdy Reeds 的描述根据 Sukritact's Oceans 是否激活动态调整
8. **文明百科集成**: 完整的自定义百科页面布局，包括区域身份页面组的动态查询生成