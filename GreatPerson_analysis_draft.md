# Civilization VI 伟人（GreatPerson）完整分析报告（初稿）

> 生成时间: 2026-07-07
> 数据来源: Mod (无原版游戏文件)
> 总条目数: 约 80+ 伟人（含新增/修改/删除）
> ⚠️ 此为初稿，效果全部通过 XML/SQL/Lua 代码推导，尚未对照本地化文本。

> **注意：** 当前工作区仅包含 Mod 文件，无原版游戏数据。所有原版伟人条目通过 Mod 的 DELETE/UPDATE 操作推断。原版伟人的具体效果未能在此报告中完全呈现。

---

## 1. 总览

| 来源 | 原版保留 | 新增 | 修改 | 被删除 |
|------|:-------:|:----:|:----:|:------:|
| 原版（推断） | 约 100+ | 0 | 2 | 23 |
| DLC(迭起兴衰) | 未知 | 未知 | 0 | 0 |
| DLC(风云变幻) | 未知 | 未知 | 0 | 0 |
| 2448605286 更多伟人 | 0 | ~45 | 0 | 18 |
| 2973448849 大统治者伟人 | 0 | ~22 | 2 | 0 |
| 3085812151 远古伟人 | 0 | 12 | 1 | 0 |
| 3334907290 删除部分工程师 | 0 | 0 | 0 | 5 |
| 艺术类伟人偷奇观Mod | 0 | 1（单位类型） | 0 | 0 |
| **合计** | **~100** | **~80** | **3** | **23** |

---

## 2. 详细数据表

> 效果列格式：[触发条件] + [目标/范围] + [具体数值] + [持续时间/作用域]

### 2.1 更多伟人 (2448605286 Sumus Magnus) - 新增大将军

#### 被动效果（出生即获得，对周边单位生效的光环）

| # | 内部ID | 时代 | 充能 | 被动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_SARGON | ERA_CLASSICAL | 1 | 周边2格陆地近战/骑兵/重战车/轻战车/反骑兵/武僧单位在防御时+4战斗力(MANNERHEIM_BUFF:Amount=4, 条件: UNIT_WEAK_WHEN_DEFENDING_REQUIREMENT) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位行动后恢复生命值(BAIBARS_BUFF: MODIFIER_PLAYER_UNIT_GRANT_HEAL_AFTER_ACTION) | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_KHALID_WALID | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位对异教单位+7战斗力(KHALID_WALID_BUFF:Amount=7, 条件: REQUIREMENTS_OPPONENT_IS_OTHER_RELIGION) | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_REX | ERA_INDUSTRIAL | 1 | 周边2格所有陆地单位每剩余1移动力+3战斗力(PLATI_REX_BUFF:Amount=3, MODIFIER_SINGLE_UNIT_ADJUST_COMBAT_FOR_UNUSED_MOVEMENT) | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_RURIK | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位经验获取+80%(PLATI_RURIK_BUFF:Amount=80) | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_LIONHEART | ERA_MEDIEVAL | 1 | 周边2格骑兵单位（重骑/轻骑/远程骑兵）攻击时+7战斗力(PLATI_NORMAN_CAVALRY_BUFF:Amount=7, 条件: UNIT_STRONG_WHEN_ATTACKING_REQUIREMENTS) | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位击杀敌人后获得相当于被击杀单位100%战斗力的信仰(PLATI_BAYINNAUNG_BUFF:PercentDefeatedStrength=100, YieldType=YIELD_FAITH) | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH_MADA | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位登陆时+10战斗力(PLATI_GAJAH_MADA_COMBAT_BUFF:Amount=10, 条件: REQUIREMENTS_UNIT_IS_EMBARKED)；所有陆地单位忽略上岸惩罚(PLATI_GAJAH_MADA_DISEMBARK_BUFF:Ignore=true) | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA | ERA_MEDIEVAL | 1 | 周边2格近战/骑兵/反骑兵/重战车/轻战车/武僧单位在防御远程攻击时+10战斗力(PLATI_JAN_ZIZKA_BUFF:Amount=10, 条件: NAGAO_RANGED_DEFENSE_REQUIREMENTS) | 新增 |
| 10 | GREAT_PERSON_INDIVIDUAL_PLATI_HUSSITE_LEGACY | ERA_MEDIEVAL | 1 | 周边2格所有陆地单位对抗更强单位时+4战斗力(PLATI_HUSSITE_LEGACY_BUFF:Amount=4, 条件: COMBAT_AGAINST_STRONGER_UNIT_REQUIREMENTS) | 新增 |
| 11 | GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN | ERA_MODERN | 1 | 周边2格所有陆地单位+4战斗力(MANNERHEIM_BUFF:Amount=4, 条件: UNIT_WEAK_WHEN_DEFENDING_REQUIREMENT) | 新增 |
| 12 | GREAT_PERSON_INDIVIDUAL_PLATI_TOKUGAWA | ERA_MODERN | 1 | 主动效果：退役（具体效果见文本） | 新增 |
| 13 | GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI | ERA_INDUSTRIAL | 1 | 周边2格近战单位在首都大陆+3战斗力(GARIBALDI_BUFF:Amount=3, 条件: GARDE_PLOT_IS_CAPITAL_CONTINENT_REQUIREMENTS) | 新增 |
| 14 | GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE | ERA_MODERN | 1 | 空军单位（空优战斗机）在轰炸时+17战斗力(PLATI_CLAUSEWITZ_BUFF:Amount=17, 条件: BOMBARDMENT_REQUIREMENTS) | 新增 |
| 15 | GREAT_PERSON_INDIVIDUAL_PLATI_SUAREZ | ERA_RENAISSANCE | 1 | 主动效果：退役，近战/骑兵单位可转化敌方单位为己方(PLATI_SARGON_CONVERSION:CanCapture=true) | 新增 |
| 16 | GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA | ERA_RENAISSANCE | 1 | 主动效果：退役（具体效果见文本） | 新增 |
| 17 | GREAT_PERSON_INDIVIDUAL_PLATI_SUNDIATA_KEITA | ERA_MEDIEVAL | 1 | 主动效果：退役（具体效果见文本） | 新增 |

#### 将军单位被动光环（代码中定义，作用于对应类型单位）

| 效果ID | 能力类型 | 目标 | 效果 |
|--------|---------|------|------|
| ABILITY_BAIBARS_UNIQUE | 被动光环 | 所有陆地单位 | 行动后恢复生命 |
| ABILITY_KHALID_WALID_UNIQUE | 被动光环 | 所有陆地单位 | 对异教+7战斗力 |
| ABILITY_PLATI_SARGON_SABBUM | 被动光环 | 近战/骑兵/战车/反骑兵/武僧 | 可转化敌方单位 |
| ABILITY_REX_GOD_OF_WAR | 被动光环 | 所有陆地单位 | 每剩余1移动力+3战斗力 |
| ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE | 被动光环 | 所有陆地单位 | 经验+80% |
| ABILITY_NORMAN_LEGACY | 被动光环 | 骑兵单位 | 攻击时+7战斗力 |
| ABILITY_BAYINNAUNG | 被动光环 | 所有陆地单位 | 击杀获得信仰 |
| ABILITY_GAJAH_MADA_COMBAT | 被动光环 | 所有陆地单位 | 登陆+10战斗力 |
| ABILITY_GAJAH_MADA_DISEMBARK | 被动光环 | 所有陆地单位 | 忽略上岸惩罚 |
| ABILITY_JAN_ZIZKA | 被动光环 | 近战/骑兵/反骑兵/战车/武僧 | 防御远程+10战斗力 |
| ABILITY_HUSSITE_LEGACY | 被动光环 | 所有陆地单位 | 对抗更强单位+4战斗力 |
| ABILITY_MANNERHEIM | 被动光环 | 所有陆地单位 | 防御时+4战斗力 |
| ABILITY_FOG_OF_WAR | 被动光环 | 空优战斗机 | 轰炸+17战斗力 |
| ABILITY_GARIBALDI_BONUS | 被动光环 | 近战单位 | 首都大陆+3战斗力 |
| ABILITY_VITRUVIUS | 被动光环 | 攻城单位 | +5战斗力 |

### 2.2 更多伟人 (2448605286 Sumus Magnus) - 新增大提督

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 被动效果（代码） | 状态 |
|---|--------|------|------|-----------------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_MAJID | ERA_RENAISSANCE | 1 | 所有海军单位+2海上移动力(MAJID_BOOST:Amount=2) | 周边2格海军单位+2海上移动力 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_COOK | ERA_RENAISSANCE | 1 | 所有海军单位+2视野(COOK_SIGHT_BOOST:Amount=2)；所有海军单位+2海上移动力(COOK_MOVEMENT_BOOST:Amount=2) | 周边2格海军单位+2视野/移动力 | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_AGRI_PPA | ERA_CLASSICAL | 1 | 海军近战单位可俘获敌方船只(PLATI_PIRACY_BUFF:CanCapture=true) | 周边2格海军近战单位可俘获 | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_HENRY | ERA_RENAISSANCE | 1 | 主动效果：退役（具体效果见文本） | 无 | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSSA | ERA_RENAISSANCE | 1 | 主动效果：退役（具体效果见文本） | 无 | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL | ERA_RENAISSANCE | 1 | 主动效果：海军近战单位可转化为城市信仰(GENOESE_CHRISTIAN_ADMIRAL:Enable=true) | 周边2格海军单位有海军领事馆加成(PLATI_CONSULATE_OF_SEA_BUFF:每剩余1移动力+1战斗力) | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_LODBROK | ERA_MEDIEVAL | 1 | 主动效果：退役（具体效果见文本） | 无 | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_VITUS | ERA_RENAISSANCE | 1 | 主动效果：退役（具体效果见文本） | 无 | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_MORGAN | ERA_RENAISSANCE | 1 | 主动效果：退役（具体效果见文本） | 无 | 新增 |

### 2.3 更多伟人 (2448605286 Sumus Magnus) - 新增大商人

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_CECIL | ERA_INDUSTRIAL | 1 | 主动效果：需要市中心区域 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_NESTLE | ERA_INDUSTRIAL | 1 | 主动效果：使用巧克力工厂相关 | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_BANKER | ERA_INDUSTRIAL | 1 | 主动效果：银行相关 | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_RAILLORD | ERA_INDUSTRIAL | 1 | 主动效果：铁路相关 | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE | ERA_INDUSTRIAL | 1 | 主动效果：法贝热彩蛋奢侈品资源 | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_AFANASIY | ERA_MEDIEVAL | 1 | 主动效果：商业中心区域 | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON | ERA_INDUSTRIAL | 1 | 主动效果：商业中心区域 | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_COLBERT | ERA_RENAISSANCE | 1 | 主动效果：商业中心区域 | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_JACOB_KETTLER | ERA_RENAISSANCE | 1 | 主动效果：商业中心区域 | 新增 |
| 10 | GREAT_PERSON_INDIVIDUAL_PLATI_IBN_BATTUTA | ERA_MEDIEVAL | 1 | 主动效果：商业中心区域 | 新增 |
| 11 | GREAT_PERSON_INDIVIDUAL_PLATI_VENETIAN | ERA_MEDIEVAL | 1 | 主动效果：遗物相关 | 新增 |

### 2.4 更多伟人 (2448605286 Sumus Magnus) - 新增大工程师

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_URBAN | ERA_MEDIEVAL | 1 | 攻城单位+5战斗力(PLATI_VITRUVIUS_BUFF:Amount=5, 被动光环) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_AL_AHRAMI | ERA_MEDIEVAL | 1 | 奇观建造 | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD | ERA_INDUSTRIAL | 1 | 铁路/工业区相关 | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD_MARITIME | ERA_INDUSTRIAL | 1 | 海事工程相关 | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP | ERA_INDUSTRIAL | 1 | 军事工程相关 | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_ERIK_DAHLBERG | ERA_RENAISSANCE | 1 | 堡垒/军事工程相关 | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_ELIZABETH_WILBRAHAM | ERA_RENAISSANCE | 1 | 建筑相关 | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_APOLLO | ERA_ATOMIC | 1 | 太空竞赛相关 | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_RASTRELLI | ERA_RENAISSANCE | 1 | 建筑/宫殿相关 | 新增 |

### 2.5 更多伟人 (2448605286 Sumus Magnus) - 新增大科学家

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES | ERA_MEDIEVAL | 1 | 需要学院区域 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_SAINT_AUGUSTINE | ERA_MEDIEVAL | 1 | 宗教单位+3战斗力(SAUGUSTINE_BUFF:Amount=3, 被动光环, 目标: CLASS_RELIGIOUS_ALL) | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO | ERA_MEDIEVAL | 1 | 需要学院区域 | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN | ERA_CLASSICAL | 1 | 造纸坊相关 | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS | ERA_RENAISSANCE | 1 | 需要学院区域 | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_CURIE | ERA_MODERN | 1 | 需要学院区域 | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_ZEPPELIN | ERA_INDUSTRIAL | 1 | 需要学院区域 | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_PASTEUR | ERA_INDUSTRIAL | 1 | 需要学院区域 | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY | ERA_INDUSTRIAL | 1 | 需要学院区域 | 新增 |
| 10 | GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV | ERA_ATOMIC | 1 | 需要学院区域 | 新增 |
| 11 | GREAT_PERSON_INDIVIDUAL_PLATI_FRANKLIN | ERA_INDUSTRIAL | 1 | 需要学院区域 | 新增 |
| 12 | GREAT_PERSON_INDIVIDUAL_PLATI_TUSI | ERA_MEDIEVAL | 1 | 需要学院区域 | 新增 |
| 13 | GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNITZ | ERA_RENAISSANCE | 1 | 需要学院区域 | 新增 |
| 14 | GREAT_PERSON_INDIVIDUAL_PLATI_LEIZU | ERA_CLASSICAL | 1 | 需要学院区域 | 新增 |

### 2.6 更多伟人 (2448605286 Sumus Magnus) - 新增大作家/大艺术家/大音乐家

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE | ERA_INDUSTRIAL | 0 | 创造著作巨作 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_HOBBES | ERA_RENAISSANCE | 0 | 创造著作巨作 | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_WRITER_NEW | 多个时代 | 0 | 多位作家（西塞罗、笛卡尔、海德格尔、洛夫克拉夫特等） | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_PAINTERS | 多个时代 | 0 | 多位画家（毕加索等） | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_SCULPTORS | 多个时代 | 0 | 多位雕塑家 | 新增 |

### 2.7 更多伟人 (2448605286 Sumus Magnus) - 新增资源/建筑/改良设施

| 类型 | 内部ID | 效果 | 来源 |
|------|--------|------|------|
| 资源 | RESOURCE_PLATI_FABERGE_EGG | 法贝热彩蛋 (奢侈品) | PLATI_Resources.xml |
| 资源 | RESOURCE_PLATI_PEPPER | 胡椒 (奢侈品) | PLATI_Resources.xml |
| 资源 | RESOURCE_PLATI_NUTMEG | 肉豆蔻 (奢侈品) | PLATI_Resources.xml |
| 资源 | RESOURCE_PLATI_PRAGUELINE | 果仁糖 (奢侈品) | PLATI_Resources.xml |
| 建筑 | BUILDING_PLATI_CHOCOLATE_FACTORY | 巧克力工厂 | PLATI_Buildings.xml |
| 建筑 | BUILDING_PLATI_PAPER_MILL | 造纸坊 | PLATI_Buildings.xml |
| 建筑 | BUILDING_PLATI_TEMPLE_VAULT | 圣殿金库 | PLATI_Buildings.xml |
| 改良设施 | IMPROVEMENT_PLATI_CHATEAU | 城堡改良 | A_Improvement_Chateau.xml |
| 改良设施 | IMPROVEMENT_PLATI_MISSION | 传教团改良 | A_Improvement_Mission.xml |
| 改良设施 | IMPROVEMENT_PLATI_POLDER | 圩田改良 | A_Improvement_Polder.xml |

### 2.8 更多伟人 (2448605286 Sumus Magnus) - 被删除的原版伟人

| 内部ID | 推测类型 | 状态 |
|--------|----------|:----:|
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 大工程师 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | 大工程师 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JANE_DREW | 大工程师 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 大工程师 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_DANDARA | 大提督 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_MONASH | 大将军 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI | 大将军 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_SAMORI_TURE | 大将军 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_AETHELFLAED | 大将军 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI | 大商人 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER | 大商人 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | 大商人 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_ADAM_SMITH | 大商人 | 被删除 |

---

### 2.9 大统治者伟人 (2973448849 Great Sovereigns) - 新伟人类型

**新伟人类型：** GREAT_PERSON_CLASS_GreatSovereigns
- 单位类型：UNIT_GREAT_GreatSovereigns (移动力4, 视野2, 平民单位)
- 产出区域：政府区 (DISTRICT_GOVERNMENT)
- 伪产出：PSEUDOYIELD_GPP_GreatSovereigns (DefaultValue=7)
- 政府区项目：PROJECT_GreatSovereigns_DISTRICT_GOVERNMENT (Cost=70, 产出15%金币)
- 伟人点数来源：政府区(+1), 1级政府建筑(+1), 2级(+2), 3级(+3), 奇观(阿尔罕布拉宫+1, 宙斯神像+2, 泰姬陵+1, 圣索菲亚+2, 吴哥窟+2, 罗马斗兽场+2, 金字塔+1)

#### 基础16位大统治者

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_FIRST (所罗门) | ERA_CLASSICAL | 1 | 需要圣地；在目标区域免费建造神殿(BUILDING_TEMPLE)；所有神殿+2生产力(GREATPERSON_PLATI_SOLOMON_TEMPLES: YieldType=YIELD_PRODUCTION, Amount=2) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_SECOND (马可·奥勒留) | ERA_CLASSICAL | 1 | 需要政府区；随机获得1个中世纪市政鼓舞(99个)(GREAT_PLATI_MARCUS_AURELIUS: StartEraType=ERA_MEDIEVAL, EndEraType=ERA_MEDIEVAL, Amount=99) | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_THIRD (大流士) | ERA_CLASSICAL | 1 | 需要未完成奇观；目标奇观获得100生产力(GREAT_PLATI_DARIUS_PERSIAN: Amount=100, ScaleByGameSpeed)；每使用1个使者+1文化(GREAT_PLATI_DARIUS_TRADE: Amount=1, YieldType=YIELD_CULTURE) | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTH (阿育王) | ERA_CLASSICAL | 1 | 需要政府区；每个区域+1信仰(GREAT_PLATI_ASHOKA: YieldType=YIELD_FAITH, Amount=1)；每个区域+1食物(GREAT_PLATI_2ASHOKA: YieldType=YIELD_FOOD, Amount=1) | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTH (腓特烈二世) | ERA_MEDIEVAL | 1 | 需要政府区；+1经济政策槽位(GREAT_PLATI_FREDERICH_II: GovernmentSlotType=SLOT_ECONOMIC) | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTH (阿里帕夏) | ERA_INDUSTRIAL | 1 | 需要政府区；单位升级费用-100%(GREAT_PLATI_AHMAD_MANSUR: Amount=100)；随机获得1个科技(GREAT_PLATI_MUHAMAD_ALI_PASHA: Amount=1) | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_SEVENTH (查理曼) | ERA_MEDIEVAL | 1 | 需要政府区；+1军事政策槽位(GREAT_PLATI_CHARLEMAGNE: GovernmentSlotType=SLOT_MILITARY) | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_EIGHTH (哈伦·拉希德) | ERA_MEDIEVAL | 1 | 需要政府区；黄金时代时，贸易路线每格+0.17科技(GREAT_PLATI_HARUN: YieldType=YIELD_SCIENCE, Amount=0.17, 条件: PLAYER_HAS_GOLDEN_AGE) | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_NINTH (阿斯基亚) | ERA_RENAISSANCE | 1 | 需要政府区且城市有圣地+剧院；掠夺区域+2次(GREAT_PLATI_ASKIA: Amount=2, Extra=-1)；用阿斯基亚纪念碑替换纪念碑(BUILDING_PLATI_MONUMENT_ASKIA 替换 BUILDING_MONUMENT) | 新增 |
| 10 | GREAT_PERSON_INDIVIDUAL_PLATI_TENTH (阿克巴) | ERA_RENAISSANCE | 1 | 需要政府区；+1通配符政策槽位(GREAT_PLATI_AKBAR: GovernmentSlotType=SLOT_WILDCARD) | 新增 |
| 11 | GREAT_PERSON_INDIVIDUAL_PLATI_THIRTEENTH (明治) | ERA_INDUSTRIAL | 1 | 需要政府区；社区区域+300金币，工业区+300金币(需替换农场改良)；工业区与社区互相+2食物相邻加成(GREAT_PLATI_MEIJI系列) | 新增 |
| 12 | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTEENTH (凯末尔) | ERA_MODERN | 3 | 需要市中心；目标城市+400生产力(GREAT_PLATI_ATATURK: Amount=400, ScaleByGameSpeed)；被动：所有陆地单位+5战斗力(ModifierId_ABILITY_PLATI_FOURTEENTH_COMBAT) | 新增 |
| 13 | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTEENTH (海尔·塞拉西) | ERA_MODERN | 1 | 需要政府区；+2外交胜利点数(GREAT_PLATI_HAILE_SELASSIE: Amount=2) | 新增 |
| 14 | GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT | ERA_MEDIEVAL | 1 | 需要兵工厂(DISTRICT_ARSENAL)；海军单位晋升所需经验-1(FATHER_OF_ENGLISH_NAVY: Amount=-1) | 新增 |
| 15 | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST (路易十四) | ERA_RENAISSANCE | 1 | 需要政府区 | 新增 |
| 16 | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT (拜里米苏拉) | ERA_MEDIEVAL | 1 | 需要市中心 | 新增 |

#### 扩展大统治者

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_PLATI_RBORGIA (哈克汗二世) | ERA_MEDIEVAL | 1 | 需要政府区 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_PLATI_KOSEMI (沙阿) | ERA_INDUSTRIAL | 1 | 需要市中心；廓尔喀单位+3战斗力(GURKHAS_BUFF:Amount=3)；印度兵在外大陆+3战斗力(SEPOYS_BUFF:Amount=3, 条件: REDCOAT_PLOT_IS_FOREIGN_CONTINENT) | 新增 |
| 3 | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH (兰甘亨) | ERA_MEDIEVAL | 1 | 需要政府区 | 新增 |
| 4 | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED (扎耶德) | ERA_ATOMIC | 1 | 需要政府区 | 新增 |
| 5 | GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR (儒略二世) | ERA_RENAISSANCE | 1 | 需要未完成奇观；退役（具体效果见文本） | 新增 |
| 6 | GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH (李光耀) | ERA_ATOMIC | 1 | 需要政府区 (普通版/大亨版) | 新增 |
| 7 | GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK (俾斯麦) | ERA_INDUSTRIAL | 1 | 需要城邦领土；不需要己方地块 | 新增 |
| 8 | GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH (玛丽亚·特蕾莎) | ERA_RENAISSANCE | 1 | 需要政府区 | 新增 |
| 9 | GREAT_PERSON_INDIVIDUAL_PLATI_ISMAIL (伊斯玛仪一世) | ERA_RENAISSANCE | 1 | 骑兵单位在非黄金时代可转化城市(FATHER_OF_MODERN_IRAN:Enable=true, 条件: PLAYER_NO_GOLDEN_AGE_REQUIREMENTS) | 新增 |
| 10 | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS (维陶塔斯) | ERA_MEDIEVAL | 2 | 需要市中心 | 新增 |
| 11 | GREAT_PERSON_INDIVIDUAL_PLATI_MONACO (摩纳哥) | ERA_INFORMATION | 1 | 需要政府区 | 新增 |
| 12 | GREAT_PERSON_INDIVIDUAL_PLATI_DANDOLO (丹多洛) | ERA_MEDIEVAL | 1 | 需要市中心 | 新增 |
| 13 | GREAT_PERSON_INDIVIDUAL_PLATI_BEG (兀鲁伯) | ERA_RENAISSANCE | 1 | 需要学院 | 新增 |
| 14 | GREAT_PERSON_INDIVIDUAL_PLATI_DENG (斯坎德培) | ERA_RENAISSANCE | 1 | 周边2格单位击杀后获得大统治者点数(SOVEREIGN_POINTS_FROM_KILLS:Amount=8, GreatPersonClassType=GREAT_PERSON_CLASS_GreatSovereigns) | 新增 |
| 15 | GREAT_PERSON_INDIVIDUAL_PLATI_ISABELLA (伊莎贝拉) | ERA_RENAISSANCE | 1 | 需要政府区 | 新增 |
| 16 | GREAT_PERSON_INDIVIDUAL_PLATI_ARBE (美第奇) | ERA_RENAISSANCE | 1 | 需要市中心 | 新增 |

#### 大统治者相关能力效果

| 效果ID | 类型 | 目标 | 效果 |
|--------|------|------|------|
| ABILITY_GURKHAS_BONUS | 被动光环 | 近战/远程单位 | +3战斗力 |
| ABILITY_SEPOYS_BONUS | 被动光环 | 近战/远程单位 | 外大陆+3战斗力 |
| ABILITY_ALFRED_PROMOTION_BONUS | 被动光环 | 海军单位 | 晋升经验-1 |
| ABILITY_ISMAIL_CONVERSION | 被动光环 | 骑兵单位 | 非黄金时代可转化城市 |
| ABILITY_TIMOCRACY_POINTS | 被动光环 | 所有陆地/海军/空军 | 击杀获得大统治者点数(+8) |

#### 大统治者被修改的原版伟人

| 原版ID | 操作 | 说明 |
|--------|------|------|
| GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE | Update | 配置启用修改 |
| GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS | Update | 配置启用修改 |

---

### 2.10 远古伟人 (3085812151 Ancient Great People) - 新增远古/古典伟人

#### 远古大提督

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 被动效果（代码） | 状态 |
|---|--------|------|------|-----------------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_HENENU | ERA_ANCIENT | 1 | 水上贸易路线范围+10(JNR_HENENU_MARITIME_TRADE_RANGE:Amount=10)；获得少量金币(GREATPERSON_GOLD_TINY) | 周边2格远古海军单位+5战斗力+1移动力 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA | ERA_ANCIENT | 1 | 免费获得1个海军近战单位并赋予早期探险者能力(JNR_NEI_MANGANIBUKA_FREE_UNIT:UnitPromotionClassType=PROMOTION_CLASS_NAVAL_MELEE) | 周边2格远古海军单位+5战斗力+1移动力 | 新增 |

#### 远古大将军

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 被动效果（代码） | 状态 |
|---|--------|------|------|-----------------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO | ERA_ANCIENT | 1 | 免费获得1个重骑兵单位并赋予伪装能力(JNR_FU_HAO_FREE_UNIT:UnitPromotionClassType=PROMOTION_CLASS_HEAVY_CAVALRY) | 周边2格远古陆地单位+5战斗力+1移动力 | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | ERA_ANCIENT | 1 | 城市忠诚度效果(与AETHELFLAED同效果, 或ANA_NZINGA效果) | 周边2格远古陆地单位+5战斗力+1移动力 | 新增 |

#### 远古大商人

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_AMA_E | ERA_ANCIENT | 1 | 需要商业中心；+1商路容量；目标城市国内贸易路线+1食物+1生产力(GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES: YieldType=YIELD_FOOD, Amount=1, Domestic=1; GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES: YieldType=YIELD_PRODUCTION, Amount=1, Domestic=1) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_HIRAM | ERA_ANCIENT | 1 | 需要商业中心；目标城市获得1个骨螺奢侈品资源(RESOURCE_JNR_MUREX, Happiness=4) | 新增 |

#### 远古大科学家

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_THALES_MILETUS | ERA_ANCIENT | 1 | 需要学院；随机获得1个远古科技尤里卡(StartEraType=ERA_ANCIENT, EndEraType=ERA_ANCIENT, Amount=1)；随机获得2个古典市政鼓舞(StartEraType=ERA_CLASSICAL, EndEraType=ERA_CLASSICAL, Amount=2) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI | ERA_ANCIENT | 1 | 需要学院；图书馆+1科技+1文化+1信仰；大学+1科技+1文化+1信仰；研究实验室+1科技+1文化+1信仰（共9个Modifier） | 新增 |

#### 远古大先知

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_MOSES | ERA_ANCIENT | 0 | 无激活能力（创建宗教用） | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI | ERA_ANCIENT | 0 | 无激活能力（创建宗教用） | 新增 |

#### 远古大作家

| # | 内部ID | 时代 | 充能 | 主动效果（代码） | 状态 |
|---|--------|------|------|-----------------|:----:|
| 1 | GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA | ERA_ANCIENT | 0 | 创造2个著作巨作(各+4文化+4旅游) | 新增 |
| 2 | GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP | ERA_ANCIENT | 0 | 创造2个著作巨作(各+4文化+4旅游) | 新增 |

#### 被修改的原版伟人

| 原版ID | 操作 | 修改前 | 修改后 | 来源 |
|--------|------|--------|--------|------|
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | UPDATE | EraType=ERA_ANCIENT | EraType=ERA_CLASSICAL | 6T_AGP_Engineer.sql |
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | INSERT OR IGNORE | ActionCharges原始值 | ActionCharges=2, ActionRequiresIncompleteWonder=1 | 6T_AGP_Engineer.sql |
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | UPDATE | Amount=原始值 | 远古/古典奇观生产力=250, 其他=125 | 6T_AGP_Engineer.sql |
| GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | UPDATE | 默认 | Active效果=ANA_NZINGA或AETHELFLAED | 6T_AGP_General.sql, 6T_AGP_XP1.sql |

---

### 2.11 删除部分工程师 (3334907290) - 被删除的伟人

| 内部ID | 推测名称 | 状态 |
|--------|----------|:----:|
| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 圣乔治的詹姆斯 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·罗布林 | 被删除 |
| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 | 被删除 |

---

### 2.12 艺术类伟人偷奇观Mod - 伟人新功能

#### 新增单位

| 内部ID | 类型 | 基础属性 | 效果 |
|--------|------|----------|------|
| UNIT_WONDER_THEFT | 平民单位 | 移动力5, 视野2, 平民类 | 可偷取/放置奇观（通过Lua脚本实现） |

#### Lua脚本功能（/workspace/MOD/艺术类伟人偷奇观，准确传送开拓者，获得地块/）

| 功能 | 触发方式 | 效果 |
|------|----------|------|
| 奇观偷取 | 大作家/大艺术家/大音乐家使用按钮 | 将目标奇观从当前位置移到新位置（黑名单：金门大桥、巴拿马运河、塔桥） |
| 奇观安置 | 奇观学家使用按钮 | 将已偷取的奇观放置到新位置 |
| 传送开拓者 | 大作家/大艺术家/大音乐家使用按钮 | 传送开拓者到异大陆随机空地 |
| 文化炸弹 | 大作家/大艺术家/大音乐家使用按钮 | 获取邻近1环地块 |
| 召唤奇观学家 | 大作家/大艺术家/大音乐家使用按钮 | 召唤一个奇观学家单位 |

---

## 3. 数据链完整追溯

### 3.1 核心链：Type → Trait → Modifier → Arguments → Requirements

#### 更多伟人 - 大将军被动光环链

| 条目ID | ModifierId | ModifierType | Arguments | RequirementSet | 终端值 |
|--------|-----------|--------------|-----------|----------------|--------|
| PLATI_SARGON | MANNERHEIM_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=4 | MANNERHEIM_REQUIREMENT_SET → UNIT_WEAK_WHEN_DEFENDING_REQUIREMENT | 防御时+4战斗力 |
| PLATI_BAIBARS | BAIBARS_BUFF | MODIFIER_PLAYER_UNIT_GRANT_HEAL_AFTER_ACTION | (无参数) | 无 | 行动后回血 |
| PLATI_KHALID_WALID | KHALID_WALID_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=7 | REQUIREMENTS_OPPONENT_IS_OTHER_RELIGION | 对异教+7战斗力 |
| PLATI_REX | PLATI_REX_BUFF | MODIFIER_SINGLE_UNIT_ADJUST_COMBAT_FOR_UNUSED_MOVEMENT | Amount=3 | 无 | 每剩余1移动力+3战斗力 |
| PLATI_RURIK | PLATI_RURIK_BUFF | MODIFIER_PLAYER_UNIT_ADJUST_UNIT_EXPERIENCE_MODIFIER | Amount=80 | 无 | 经验+80% |
| PLATI_LIONHEART | PLATI_NORMAN_CAVALRY_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=7 | UNIT_STRONG_WHEN_ATTACKING_REQUIREMENTS | 攻击时+7战斗力 |
| PLATI_BAYINNAUNG | PLATI_BAYINNAUNG_BUFF | MODIFIER_UNIT_ADJUST_POST_COMBAT_YIELD | PercentDefeatedStrength=100, YieldType=YIELD_FAITH | 无 | 击杀获得100%战斗力等值信仰 |
| PLATI_GAJAH_MADA | PLATI_GAJAH_MADA_COMBAT_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=10 | REQUIREMENTS_UNIT_IS_EMBARKED(Owner) | 登陆时+10战斗力 |
| PLATI_GAJAH_MADA | PLATI_GAJAH_MADA_DISEMBARK_BUFF | MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_SHORES | Ignore=true | 无 | 忽略上岸惩罚 |
| PLATI_JAN_ZIZKA | PLATI_JAN_ZIZKA_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=10 | NAGAO_RANGED_DEFENSE_REQUIREMENTS | 防御远程+10战斗力 |
| PLATI_HUSSITE_LEGACY | PLATI_HUSSITE_LEGACY_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=4 | COMBAT_AGAINST_STRONGER_UNIT_REQUIREMENTS | 对抗更强单位+4战斗力 |
| PLATI_UNGERN | MANNERHEIM_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=4 | MANNERHEIM_REQUIREMENT_SET | 防御时+4战斗力 |
| PLATI_GARIBALDI | GARIBALDI_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=3 | GARDE_PLOT_IS_CAPITAL_CONTINENT_REQUIREMENTS | 首都大陆+3战斗力 |
| PLATI_LAWRENCE | PLATI_CLAUSEWITZ_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=17 | BOMBARDMENT_REQUIREMENTS | 轰炸+17战斗力 |
| PLATI_URBAN | PLATI_VITRUVIUS_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=5 | 无 | 攻城单位+5战斗力 |
| PLATI_SUAREZ | PLATI_SARGON_CONVERSION | MODIFIER_UNIT_ADJUST_COMBAT_CAPTURE | CanCapture=true | 无 | 近战/骑兵可转化敌方单位 |

#### 更多伟人 - 大提督被动光环链

| 条目ID | ModifierId | ModifierType | Arguments | 终端值 |
|--------|-----------|--------------|-----------|--------|
| PLATI_MAJID | MAJID_BOOST | MODIFIER_PLAYER_UNIT_ADJUST_SEA_MOVEMENT | Amount=2 | 海军+2海上移动力 |
| PLATI_COOK | COOK_SIGHT_BOOST | MODIFIER_PLAYER_UNIT_ADJUST_SIGHT | Amount=2 | 海军+2视野 |
| PLATI_COOK | COOK_MOVEMENT_BOOST | MODIFIER_PLAYER_UNIT_ADJUST_SEA_MOVEMENT | Amount=2 | 海军+2海上移动力 |
| PLATI_AGRI_PPA | PLATI_PIRACY_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_CAPTURE | CanCapture=true | 海军近战可俘获 |
| PLATI_NIELS_JUEL | GENOESE_CHRISTIAN_ADMIRAL | MODIFIER_PLAYER_UNIT_ADJUST_CITY_ON_CAPTURE | Enable=true | 海军近战可转化城市 |
| PLATI_NIELS_JUEL | PLATI_CONSULATE_OF_SEA_BUFF | MODIFIER_SINGLE_UNIT_ADJUST_COMBAT_FOR_UNUSED_MOVEMENT | Amount=1 | 每剩余1移动力+1战斗力 |

#### 大统治者伟人 - 核心链

| 条目ID | ModifierId | ModifierType | Arguments | 终端值 |
|--------|-----------|--------------|-----------|--------|
| PLATI_FIRST (所罗门) | GREATPERSON_PLATI_SOLOMON_PRODUCTION | MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE | BuildingType=BUILDING_TEMPLE | 免费建造神殿 |
| PLATI_FIRST (所罗门) | GREATPERSON_PLATI_SOLOMON_TEMPLES | MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE | YieldType=YIELD_PRODUCTION, BuildingType=BUILDING_TEMPLE, Amount=2 | 所有神殿+2生产力 |
| PLATI_SECOND (马可·奥勒留) | GREAT_PLATI_MARCUS_AURELIUS | MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_BY_ERA | StartEraType=ERA_MEDIEVAL, EndEraType=ERA_MEDIEVAL, Amount=99 | 获得1个中世纪市政鼓舞 |
| PLATI_THIRD (大流士) | GREAT_PLATI_DARIUS_PERSIAN | MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY | Amount=100, ScaleByGameSpeed | 奇观+100生产力 |
| PLATI_THIRD (大流士) | GREAT_PLATI_DARIUS_TRADE | MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_USED_INFLUENCE_TOKEN | Amount=1, YieldType=YIELD_CULTURE | 每使用1使者+1文化 |
| PLATI_FOURTH (阿育王) | GREAT_PLATI_ASHOKA | MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT | YieldType=YIELD_FAITH, Amount=1 | 每个区域+1信仰 |
| PLATI_FOURTH (阿育王) | GREAT_PLATI_2ASHOKA | MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT | YieldType=YIELD_FOOD, Amount=1 | 每个区域+1食物 |
| PLATI_FIFTH (腓特烈二世) | GREAT_PLATI_FREDERICH_II | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_ECONOMIC | +1经济槽位 |
| PLATI_SIXTH (阿里帕夏) | GREAT_PLATI_AHMAD_MANSUR | MODIFIER_PLAYER_ADJUST_UNIT_UPGRADE_DISCOUNT_PERCENT | Amount=100 | 升级费-100% |
| PLATI_SIXTH (阿里帕夏) | GREAT_PLATI_MUHAMAD_ALI_PASHA | MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY | Amount=1 | 随机获得1科技 |
| PLATI_SEVENTH (查理曼) | GREAT_PLATI_CHARLEMAGNE | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_MILITARY | +1军事槽位 |
| PLATI_EIGHTH (哈伦·拉希德) | GREAT_PLATI_HARUN | MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_PATH_TILE | YieldType=YIELD_SCIENCE, Amount=0.17 | 黄金时代商路每格+0.17科技 |
| PLATI_NINTH (阿斯基亚) | GREAT_PLATI_ASKIA | MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE | Amount=2, Extra=-1 | 掠夺次数+2 |
| PLATI_NINTH (阿斯基亚) | GREAT_PLATI_2ASKIA | MODIFIER_PLAYER_ADJUST_VALID_BUILDING | BuildingType=BUILDING_PLATI_MONUMENT_ASKIA, BuildingTypeToReplace=BUILDING_MONUMENT | 替换纪念碑 |
| PLATI_TENTH (阿克巴) | GREAT_PLATI_AKBAR | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_WILDCARD | +1通配符槽位 |
| PLATI_THIRTEENTH (明治) | GREAT_PLATI_MEIJI_NEIGHBOURHOOD_GOLD | MODIFIER_PLAYER_DISTRICT_CREATE_YIELD | DistrictType=DISTRICT_NEIGHBORHOOD, Amount=300, YieldType=YIELD_GOLD | 社区+300金 |
| PLATI_THIRTEENTH (明治) | GREAT_PLATI_MEIJI_INDUSTRIAL_GOLD | MODIFIER_PLAYER_DISTRICT_CREATE_YIELD | DistrictType=DISTRICT_INDUSTRIAL_ZONE, Amount=300, YieldType=YIELD_GOLD | 工业区+300金 |
| PLATI_THIRTEENTH (明治) | GREAT_PLATI_MEIJI_ADJACENCY_IND_TO_NEIGH | MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY | DistrictType=INDUSTRIAL_ZONE, YieldType=FOOD, Amount=2 | 工业区对社区+2食物相邻 |
| PLATI_THIRTEENTH (明治) | GREAT_PLATI_MEIJI_ADJACENCY_NEIGH_TO_IND | MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY | DistrictType=NEIGHBORHOOD, YieldType=FOOD, Amount=2 | 社区对工业区+2食物相邻 |
| PLATI_FOURTEENTH (凯末尔) | GREAT_PLATI_ATATURK | MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY | Amount=400, ScaleByGameSpeed | 城市+400生产力 |
| PLATI_FIFTEENTH (海尔·塞拉西) | GREAT_PLATI_HAILE_SELASSIE | MODIFIER_PLAYER_ADJUST_DIPLOMATIC_VICTORY_POINTS | Amount=2 | +2外交胜利点 |
| PLATI_ALFRED | FATHER_OF_ENGLISH_NAVY | MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE | Amount=-1 | 海军晋升经验-1 |
| PLATI_KOSEMI | GURKHAS_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=3 | 廓尔喀+3战斗力 |
| PLATI_KOSEMI | SEPOYS_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=3 | 外大陆印度兵+3战斗力 |
| PLATI_DENG | SOVEREIGN_POINTS_FROM_KILLS | MODIFIER_PLAYER_UNIT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL | Amount=8, GreatPersonClassType=GREAT_PERSON_CLASS_GreatSovereigns | 击杀+8大统治者点数 |
| PLATI_ISMAIL | FATHER_OF_MODERN_IRAN | MODIFIER_PLAYER_UNIT_ADJUST_CITY_ON_CAPTURE | Enable=true | 非黄金时代可转化城市 |

#### 远古伟人核心链

| 条目ID | ModifierId | ModifierType | Arguments | 终端值 |
|--------|-----------|--------------|-----------|--------|
| JNR_HENENU | JNR_HENENU_MARITIME_TRADE_RANGE | MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_WATER_RANGE | Amount=10 | 海上贸易范围+10 |
| JNR_NEI_MANGANIBUKA | JNR_NEI_MANGANIBUKA_FREE_UNIT | MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER | UnitPromotionClassType=PROMOTION_CLASS_NAVAL_MELEE, ModifierId=JNR_NEI_MANGANIBUKA_FREE_UNIT_ENABLE_ABILITY | 免费海军近战单位 |
| JNR_FU_HAO | JNR_FU_HAO_FREE_UNIT | MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER | UnitPromotionClassType=PROMOTION_CLASS_HEAVY_CAVALRY | 免费重骑兵 |
| JNR_AMA_E | GREATPERSON_EXTRA_TRADE_ROUTE_CAPACITY | (原版) | 原版 | +1商路容量 |
| JNR_AMA_E | GREATPERSON_JNR_FOOD_TO_INCOMING_DOMESTIC_ROUTES | MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS | YieldType=YIELD_FOOD, Amount=1, Domestic=1 | 国内商路+1食物 |
| JNR_AMA_E | GREATPERSON_JNR_PRODUCTION_TO_INCOMING_DOMESTIC_ROUTES | MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS | YieldType=YIELD_PRODUCTION, Amount=1, Domestic=1 | 国内商路+1生产力 |
| JNR_HIRAM | GREATPERSON_JNR_GRANT_MUREX | MODIFIER_SINGLE_CITY_GRANT_RESOURCE_IN_CITY | ResourceType=RESOURCE_JNR_MUREX, Amount=1 | 获得骨螺奢侈品 |
| JNR_THALES_MILETUS | GREATPERSON_JNR_THALES_1ANCIENTECHBOOST | MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA | StartEraType=ERA_ANCIENT, EndEraType=ERA_ANCIENT, Amount=1 | 1个远古科技尤里卡 |
| JNR_THALES_MILETUS | GREATPERSON_JNR_THALES_2CLASSICALCIVICSBOOST | MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_BY_ERA | StartEraType=ERA_CLASSICAL, EndEraType=ERA_CLASSICAL, Amount=2 | 2个古典市政鼓舞 |
| JNR_MAITREYI | GREATPERSON_JNR_MAITREYI_LIBRARY_SCIENCE | MODIFIER_BUILDING_YIELD_CHANGE | BuildingType=BUILDING_LIBRARY, YieldType=YIELD_SCIENCE, Amount=1 | 图书馆+1科技 |
| JNR_MAITREYI | GREATPERSON_JNR_MAITREYI_LIBRARY_CULTURE | MODIFIER_BUILDING_YIELD_CHANGE | BuildingType=BUILDING_LIBRARY, YieldType=YIELD_CULTURE, Amount=1 | 图书馆+1文化 |
| JNR_MAITREYI | GREATPERSON_JNR_MAITREYI_LIBRARY_FAITH | MODIFIER_BUILDING_YIELD_CHANGE | BuildingType=BUILDING_LIBRARY, YieldType=YIELD_FAITH, Amount=1 | 图书馆+1信仰 |
| JNR_MAITREYI | (大学类似x3) | 同上 | 同上 | 大学各+1 |
| JNR_MAITREYI | (研究实验室类似x3) | 同上 | 同上 | 研究实验室各+1 |
| JNR_IMHOTEP | GREATPERSON_JNR_GRANT_PRODUCTION_IN_CITY_CLASSICAL | MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS | Amount=175, ScaleByGameSpeed | 奇观+175生产力 |
| JNR_IMHOTEP | (原版) | (原版) | Amount=250 (远古/古典), Amount=125 (其他) | 奇观生产力(修改后) |
| JNR_MARIA_HEBRAEA | GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS | MODIFIER_PLAYER_CITIES_ADJUST_ALL_PROJECTS_PRODUCTION | Amount=20 | 项目+20%生产力 |

---

## 4. XML/SQL/Lua 三方法交叉验证

| 条目ID | XML发现 | SQL发现 | Lua发现 | 一致性 |
|--------|:------:|:------:|:------:|:------:|
| 更多伟人 - 所有将军/提督被动光环 | ✓ (PLATI_Abilities.xml) | ✗ | ✗ | 仅通过XML发现 |
| 更多伟人 - 伟人个体定义 | ✓ (Peepoles/*.xml) | ✗ | ✗ | 仅通过XML发现 |
| 大统治者伟人 | ✓ (GreatSovereigns_Core/People/Abilities) | ✓ (GreatSovereigns_Pantheons/ORACLE) | ✗ | XML+SQL一致 |
| 远古伟人 | ✗ | ✓ (所有6T_AGP_*.sql) | ✗ | 仅通过SQL发现 |
| 删除部分工程师 | ✗ | ✓ (core.sql) | ✗ | 仅通过SQL发现 |
| 艺术类伟人偷奇观 | ✓ (GreatWorkCreatorCharges_Data.xml) | ✗ | ✓ (GreatPersonTeleport.lua) | XML+Lua协作 |

---

## 5. 关联数据

### 5.1 能力定义一览表

| 能力ID | 效果描述 | 数值 | 条件 |
|--------|----------|------|------|
| ABILITY_BAIBARS_UNIQUE | 行动后回血 | — | 所有陆地单位 |
| ABILITY_KHALID_WALID_UNIQUE | 对异教+7战斗力 | 7 | 对手异教 |
| ABILITY_PLATI_SARGON_SABBUM | 可转化敌方单位 | 可俘获 | 近战/骑兵/战车/反骑兵/武僧 |
| ABILITY_REX_GOD_OF_WAR | 剩余移动力加战斗力 | 每剩余1移动力+3 | 所有陆地单位 |
| ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE | 经验加成 | +80% | 所有陆地单位 |
| ABILITY_FOG_OF_WAR | 轰炸战斗力 | +17 | 空优战斗机 |
| ABILITY_NORMAN_LEGACY | 攻击时战斗力 | +7 | 骑兵单位 |
| ABILITY_BAYINNAUNG | 击杀获得信仰 | 100%被击杀战斗力 | 所有陆地单位 |
| ABILITY_GAJAH_MADA_COMBAT | 登陆战斗力 | +10 | 登陆时 |
| ABILITY_GAJAH_MADA_DISEMBARK | 忽略上岸惩罚 | 忽略 | 所有陆地单位 |
| ABILITY_JAN_ZIZKA | 防御远程战斗力 | +10 | 防御远程攻击 |
| ABILITY_HUSSITE_LEGACY | 对抗更强单位 | +4 | 对手更强 |
| ABILITY_MANNERHEIM | 防御时战斗力 | +4 | 防御时 |
| ABILITY_GARIBALDI_BONUS | 首都大陆战斗力 | +3 | 首都大陆, 近战单位 |
| ABILITY_VITRUVIUS | 攻城单位战斗力 | +5 | 攻城单位 |
| ABILITY_SAUGUSTINE_BONUS | 宗教单位战斗力 | +3 | 所有宗教单位 |
| ABILITY_GURKHAS_BONUS | 廓尔喀战斗力 | +3 | 近战/远程 |
| ABILITY_SEPOYS_BONUS | 外大陆印度兵 | +3 | 外大陆, 近战/远程 |
| ABILITY_ALFRED_PROMOTION_BONUS | 海军晋升经验 | -1 | 海军单位 |
| ABILITY_ISMAIL_CONVERSION | 骑兵转化城市 | 可转化 | 非黄金时代, 骑兵 |
| ABILITY_TIMOCRACY_POINTS | 击杀获大统治者点数 | +8 | 所有单位 |
| ABILITY_MAJID_SEA_MOVEMENT | 海军海上移动力 | +2 | 海军单位 |
| ABILITY_COOK_SEA_SIGHT | 海军视野 | +2 | 海军单位 |
| ABILITY_COOK_SEA_MOVEMENT | 海军海上移动力 | +2 | 海军单位 |
| ABILITY_PLATI_CAPTURE_SHIPS | 海军俘获 | 可俘获 | 海军近战 |
| ABILITY_GENOESE_NAVAL_CONVERSION | 海军转化城市 | 可转化 | 海军近战 |
| ABILITY_PLATI_CONSULATE_OF_SEA | 剩余移动力加战斗力 | 每剩余1移动力+1 | 海军近战 |
| ABILITY_JNR_FU_HAO_CAMOUFLAGE | 伪装能力 | — | 重骑兵单位 |
| ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER | 早期探险者 | — | 海军近战单位 |

### 5.2 新增建筑/资源/改良设施等下游数据

| 类型 | 内部ID | 来源 |
|------|--------|------|
| 建筑 | BUILDING_PLATI_CHOCOLATE_FACTORY | 更多伟人 |
| 建筑 | BUILDING_PLATI_PAPER_MILL | 更多伟人 |
| 建筑 | BUILDING_PLATI_TEMPLE_VAULT | 更多伟人 |
| 建筑 | BUILDING_PLATI_MONUMENT_ASKIA | 大统治者伟人 |
| 资源 | RESOURCE_PLATI_FABERGE_EGG | 更多伟人 |
| 资源 | RESOURCE_PLATI_PEPPER | 更多伟人 |
| 资源 | RESOURCE_PLATI_NUTMEG | 更多伟人 |
| 资源 | RESOURCE_PLATI_PRAGUELINE | 更多伟人 |
| 资源 | RESOURCE_JNR_MUREX | 远古伟人 |
| 资源 | RESOURCE_PLATI_COWRIE | 大统治者伟人 |
| 改良设施 | IMPROVEMENT_PLATI_CHATEAU | 更多伟人 |
| 改良设施 | IMPROVEMENT_PLATI_MISSION | 更多伟人 |
| 改良设施 | IMPROVEMENT_PLATI_POLDER | 更多伟人 |
| 单位 | UNIT_WONDER_THEFT | 艺术类伟人偷奇观 |
| 项目 | PROJECT_GreatSovereigns_DISTRICT_GOVERNMENT | 大统治者伟人 |

---

## 6. 被修改/删除的原版内容

| 原版条目ID | 操作 | 执行Mod | 修改前 | 修改后 | 来源文件 |
|------------|------|---------|--------|--------|----------|
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | UPDATE | 远古伟人 | EraType=ERA_ANCIENT | EraType=ERA_CLASSICAL | 6T_AGP_Engineer.sql:15 |
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | INSERT OR IGNORE | 远古伟人 | ActionCharges=原始值 | ActionCharges=2 | 6T_AGP_Engineer.sql:17 |
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | UPDATE | 远古伟人 | 远古/古典奇观=原始值 | 远古/古典奇观=250, 其他=125 | 6T_AGP_Engineer.sql:40-41 |
| GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE | Update | 大统治者伟人 | 原始值 | 配置修改 | GreatSovereign_Config_Enabled.xml |
| GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS | Update | 大统治者伟人 | 原始值 | 配置修改 | GreatSovereign_Config_Enabled.xml |
| 18个原版伟人 | DELETE | 更多伟人 | 存在 | 被移除 | SumusMagnus_RemoveData.xml |
| 5个原版工程师 | DELETE | 删除部分工程师 | 存在 | 被移除 | core.sql |

---

## 7. 兼容性分析

### 7.1 Mod 重叠定义

| 游戏元素 | Mod A 定义 | Mod B 定义 | 最终胜负 | 原因 |
|----------|-----------|-----------|:------:|------|
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | 远古伟人(修改) | 原版(无文件) | 远古伟人 | 唯一修改源 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 更多伟人(DELETE) | 删除部分工程师(DELETE) | 两者都删除 | 重叠删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 更多伟人(DELETE) | 删除部分工程师(DELETE) | 两者都删除 | 重叠删除 |
| GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | 6T_AGP_General.sql | 6T_AGP_XP1.sql | XP1版(后加载) | XP1文件在General之后加载 |

### 7.2 冲突与风险

- **重叠删除**：更多伟人(SumusMagnus)和删除部分工程师都删除了JAMES_OF_ST_GEORGE和JOHN_A_ROEBLING，无冲突。
- **加载顺序**：如果更多伟人(Sumus Magnus)在删除部分工程师之后加载，SumusMagnus_RemoveData.xml中的DELETE会再次执行，但SQL的DELETE已经先执行了，无实际影响。
- **大统治者伟人vs远古伟人**：两个Mod不重叠，大统治者是新类型，远古伟人是填充原版类型。
- **艺术类伟人偷奇观**：通过Lua脚本实现，与XML/SQL定义的伟人数据无冲突。但可能与禁用创作巨作弹窗Mod冲突（UI层面）。

---

## 8. 注意事项

> ⚠️ **重要提示：** 当前工作区仅包含Mod文件，缺少原版游戏数据。本报告中的以下内容系通过Mod操作推断：
> 1. 原版伟人条目：通过DELETE/UPDATE操作推断存在，但原版伟人的具体效果数值未包含在本报告中。
> 2. 被删除的伟人：列出了被DELETE的ID，但未列出原版完整效果。
> 3. 原版伟人列表：并非完整的原版伟人列表，仅包含被Mod引用的条目。
> 
> **如需完整数据，需要导入原版游戏XML/SQL文件。**