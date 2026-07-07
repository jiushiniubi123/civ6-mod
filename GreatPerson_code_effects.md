# Civilization VI 伟人完整代码效果分析报告（初稿）

⚠️ 此为初稿，效果全部通过 XML/SQL/Lua 代码推导，尚未对照本地化文本。

---

## §1 总览

### 1.1 伟人类型

| # | 伟人类别 | GreatPersonClassType | UnitType | DistrictType | PseudoYieldType | MaxPlayerInstances |
|---|---------|---------------------|----------|-------------|-----------------|-------------------|
| 1 | 海军统帅 | GREAT_PERSON_CLASS_ADMIRAL | UNIT_GREAT_ADMIRAL | DISTRICT_HARBOR | PSEUDOYIELD_GPP_ADMIRAL | -1 |
| 2 | 陆军统帅 | GREAT_PERSON_CLASS_GENERAL | UNIT_GREAT_GENERAL | DISTRICT_ENCAMPMENT | PSEUDOYIELD_GPP_GENERAL | -1 |
| 3 | 大工程师 | GREAT_PERSON_CLASS_ENGINEER | UNIT_GREAT_ENGINEER | DISTRICT_INDUSTRIAL_ZONE | PSEUDOYIELD_GPP_ENGINEER | -1 |
| 4 | 大商人 | GREAT_PERSON_CLASS_MERCHANT | UNIT_GREAT_MERCHANT | DISTRICT_COMMERCIAL_HUB | PSEUDOYIELD_GPP_MERCHANT | -1 |
| 5 | 大科学家 | GREAT_PERSON_CLASS_SCIENTIST | UNIT_GREAT_SCIENTIST | DISTRICT_CAMPUS | PSEUDOYIELD_GPP_SCIENTIST | -1 |
| 6 | 大先知 | GREAT_PERSON_CLASS_PROPHET | UNIT_GREAT_PROPHET | DISTRICT_HOLY_SITE | PSEUDOYIELD_GPP_PROPHET | 1 |
| 7 | 大作家 | GREAT_PERSON_CLASS_WRITER | UNIT_GREAT_WRITER | DISTRICT_THEATER | PSEUDOYIELD_GPP_WRITER | -1 |
| 8 | 大艺术家 | GREAT_PERSON_CLASS_ARTIST | UNIT_GREAT_ARTIST | DISTRICT_THEATER | PSEUDOYIELD_GPP_ARTIST | -1 |
| 9 | 大音乐家 | GREAT_PERSON_CLASS_MUSICIAN | UNIT_GREAT_MUSICIAN | DISTRICT_THEATER | PSEUDOYIELD_GPP_MUSICIAN | -1 |
| 10 | 大统帅 | GREAT_PERSON_CLASS_COMANDANTE_GENERAL | UNIT_COMANDANTE_GENERAL | DISTRICT_ENCAMPMENT | PSEUDOYIELD_GPP_GENERAL | -1 |
| 11 | 大统治者 | GREAT_PERSON_CLASS_GreatSovereigns | UNIT_GREAT_GreatSovereigns | DISTRICT_GOVERNMENT | PSEUDOYIELD_GPP_GreatSovereigns | -1 |

### 1.2 数据来源统计

| 来源 | 伟人数量 | 说明 |
|------|----------|------|
| 原版 (Base) | 177 | 19 Admiral + 21 General + 18 Engineer + 21 Merchant + 21 Scientist + 16 Prophet + 25 Writer + 20 Artist + 16 Musician |
| Expansion1 DLC | +4 | +2 Admiral, +2 General, +0 Engineer, +0 Merchant (含修改已有) |
| Expansion2 DLC | +0 | 仅修改已有伟人效果，不新增 |
| Babylon DLC | +24 | 各类型新增 |
| GranColombia_Maya DLC | +10 | Comandante General 全新类别 |
| 更多伟人 Mod (Sumus Magnus) | +~50 | 18条目被删除（RemoveData） |
| 大统治者伟人 Mod (Great Sovereigns) | +33 | 全新类别 + 重分类2人 |
| 远古伟人 Mod (Ancient Paragons) | +16 | 远古/古典时代新增 |
| 删除部分工程师 Mod (Delete Some Great Engineer) | -5 | 删除5位工程师 |
| 艺术类伟人偷奇观 Mod | 0 | 仅Lua脚本修改，不新增伟人 |
| EWHO Mod | +1 | 新增沙贾汗EWHO版 + 伟人点数数据修改 |
| **总计** | **~319** | |

### 1.3 加载顺序

```
原始游戏数据 (Base < Expansion1 < Expansion2 < Babylon < GranColombia_Maya)
    ↓
Mod加载顺序（按LoadOrder）:
  0:  Delete Some Great Engineer (3334907290)
  13: Ancient Paragons (3085812151)
  240: Sumus Magnus / 更多伟人 (2448605286)
  248-250: Great Sovereigns conditions (2973448849)
  242-999: Sumus Magnus conditions
  999999: Enhanced Wonders for Historical Owners (EWHO, 2921308654)
```

**覆盖规则**：后加载的 Mod 覆盖先加载的 Mod。EWHO (LoadOrder 999999) 最后加载，可能覆盖前面所有伟人修改。

---

## §2 详细数据表

> 格式说明: 内部ID, 类型, 时代, 充能次数, 退役效果, 被动效果, 来源, 状态

### 2.1 海军统帅 (Great Admiral)

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| ARTEMISIA | CLASSICAL | F | 1 | **[需海军单位+可获经验]** 在伟人所在格，选择1个海军单位获得1次免费晋升（经验-1） | 古典/中世纪海军+5战斗力+1移动力光环 | 原版 | 活跃 |
| GAIUS_DUILIUS | CLASSICAL | M | 1 | **[需海军单位+标准编队]** 在伟人所在格，选择1个海军单位编为舰队 | 古典/中世纪海军+5战斗力+1移动力光环 | 原版 | 活跃 |
| THEMISTOCLES | CLASSICAL | M | 1 | **[需港口]** 获得1艘四桨座战船（经验0）；EXP1: 忠诚度+2/回合；EXP2: 海军远程单位+20%产能 | 古典/中世纪海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP1/EXP2修改） |
| HANNO_THE_NAVIGATOR | CLASSICAL | M | 1 | **[需无军事单位]** 获得1个海军近战单位+2移动力 | 古典/中世纪海军+5战斗力+1移动力光环 | Babylon DLC | **已删除（Sumus Magnus）** |
| LEIF_ERIKSON | MEDIEVAL | M | 1 | 所有海军单位可进入海洋格；EXP2: 海军视野+2（ABILITY_ERIKSON_NAVAL_SIGHT） | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| RAJENDRA_CHOLA | MEDIEVAL | M | 1 | 获得50金币（随游戏速度）+ 海军劫掠加成；EXP2: 海军单位+5战斗力（ABILITY_CHOLA_NAVAL_COMBAT） | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| ZHENG_HE | MEDIEVAL | M | 1 | 获得1个使者；EXP2: 该城市外国商路+2金币（给他人）/+2金币（从他人），免费获得1个商队，商路容量+1 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| HIMERIOS | MEDIEVAL | M | 1 | **[需海军+可获经验]** 所在格1个海军单位获得1次免费晋升+经验加成 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | Babylon DLC | 活跃 |
| PLATI_LODBROK | MEDIEVAL | M | 1 | [Sumus Magnus 新增，具体效果见源码] | 中世纪/文艺复兴海军光环 | Sumus Magnus | 活跃 |
| FRANCIS_DRAKE | RENAISSANCE | M | 1 | 获得75金币+海军劫掠加成；EXP2: 获得1艘私掠船（经验-1，唯一） | 文艺复兴/工业海军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| SANTA_CRUZ | RENAISSANCE | M | 1 | **[需海军+标准编队]** 在伟人所在格，选择1个海军单位编为军团 | 文艺复兴/工业海军+5战斗力+1移动力光环 | 原版 | 活跃 |
| YI_SUN_SIN | RENAISSANCE | M | 1 | 获得1艘铁甲舰（经验-1，唯一）；EXP2: 获得1煤/回合 | 文艺复兴/工业海军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| FERDINAND_MAGELLAN | RENAISSANCE | F | 1 | EXP1: 忠诚度+4/回合；EXP2: 获得所在格奢侈品资源+300金币 | 文艺复兴海军光环 | Expansion1 | 活跃 |
| PLATI_BARBAROSSA | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_COOK | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_MAJID | RENAISSANCE | M | 1 | [Sumus Magnus 新增, JNR_EXPLORER] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_MORGAN | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_NIELS_JUEL | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_VITUS | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| PLATI_AGRIPPA | CLASSICAL | M | 1 | [Sumus Magnus 新增] | 古典/中世纪海军光环 | Sumus Magnus | 活跃 |
| PLATI_HENRY | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业海军光环 | Sumus Magnus | 活跃 |
| CHING_SHIH | INDUSTRIAL | F | 1 | 获得100金币+劫掠加成；EXP2: 获得500金币（随游戏速度） | 工业/现代海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| HORATIO_NELSON | INDUSTRIAL | M | 1 | 海军侧翼加成（ABILITY_HORATIO_NELSON_FLANKING_BONUS）；EXP2: 免费灯塔+船坞 | 工业/现代海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| LASKARINA_BOUBOULINA | INDUSTRIAL | F | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 工业/现代海军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| FRANZ_VON_HIPPER | MODERN | M | 1 | 获得1艘战列舰（经验-1，唯一）；EXP2: 获得1煤/回合 | 现代/原子海军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| JOAQUIM_MARQUES_LISBOA | MODERN | M | 1 | 厌战度-25% | 现代/原子海军+5战斗力+1移动力光环 | 原版 | 活跃 |
| TOGO_HEIHACHIRO | MODERN | M | 1 | 所在格1个海军单位获得1次免费晋升+经验+75%；EXP1: 忠诚度+6/回合 | 现代/原子海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP1修改） |
| MATTHEW_PERRY | MODERN | F | 1 | **[需城邦领土]** 成为城邦宗主国 | 现代/原子海军+5战斗力+1移动力光环 | Babylon DLC | 活跃 |
| CHESTER_NIMITZ | ATOMIC | M | 1 | 所有城市海军偷袭者+20%产能；EXP2: 获得1艘潜艇（经验-1，唯一）+1石油/回合 | 原子/信息海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| GRACE_HOPPER | ATOMIC | F | 1 | 获得1个原子-信息时代随机科技突破；EXP2: 获得2个随机科技 | 原子/信息海军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| SERGEY_GORSHKOV | ATOMIC | M | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 原子/信息海军+5战斗力+1移动力光环 | 原版 | 活跃 |
| CLANCY_FERNANDO | INFORMATION | M | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 信息海军+5战斗力+1移动力光环 | 原版 | 活跃 |

**远古伟人Mod (Ancient Paragons) 海军新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| JNR_HENENU | ANCIENT | M | 1 | 获得少量金币（GREATPERSON_GOLD_TINY）+ 海上贸易路线范围+10 | 远古海军+5战斗力+1移动力光环 | Ancient Paragons | 活跃 |
| JNR_NEI_MANGANIBUKA | ANCIENT | F | 1 | **[需无军事单位]** 获得1个海军近战单位（可进入海洋格，战斗力-5） | 远古海军+5战斗力+1移动力光环 | Ancient Paragons | 活跃 |

### 2.2 陆军统帅 (Great General)

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| BOUDICA | CLASSICAL | F | 1 | **[需相邻蛮族]** 转化相邻蛮族单位为己方 | 古典/中世纪陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| HANNIBAL_BARCA | CLASSICAL | M | 1 | **[需陆军+可获经验]** 在伟人所在格，选择1个陆军单位获得1次免费晋升 | 古典/中世纪陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| SUN_TZU | CLASSICAL | M | 0 | 无退役能力 | 古典/中世纪陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| TRUNG_TRAC | CLASSICAL | F | 1 | **[需军营]** 厌战度-25% | 古典/中世纪陆军+5战斗力+1移动力光环 | Babylon DLC | 活跃 |
| PLATI_SARGON | CLASSICAL | M | 1 | [Sumus Magnus 新增] | 古典/中世纪陆军光环 | Sumus Magnus | 活跃 |
| PLATI_REX | CLASSICAL | M | 1 | [Sumus Magnus 新增] | 古典/中世纪陆军光环 | Sumus Magnus | 活跃 |
| AETHELFLAED | MEDIEVAL | F | 1 | 获得1个骑士（经验0，唯一）；EXP1: 需市中心，忠诚度+2/回合 | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| EL_CID | MEDIEVAL | M | 1 | **[需陆军+标准编队]** 在伟人所在格，选择1个陆军单位编为舰队 | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| GENGHIS_KHAN | MEDIEVAL | M | 1 | 所在格1个陆军单位获得1次免费晋升+经验+25% | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| TIMUR | MEDIEVAL | M | 1 | 所在格1个陆军单位免费晋升+能力加成 | 中世纪陆军光环 | Expansion1 | 活跃 |
| PLATI_BAIBARS | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| PLATI_BAYINNAUNG | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| PLATI_JAN_ZIZKA | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| PLATI_RURIK | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| PLATI_SUNDIATA | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| PLATI_GAJAH | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 中世纪/文艺复兴陆军光环 | Sumus Magnus | 活跃 |
| GUSTAVUS_ADOLPHUS | RENAISSANCE | M | 1 | 获得1个射石炮（经验-1，唯一） | 文艺复兴/工业陆军+5战斗力+1移动力光环 | 原版 | **重分类为大统治者（军事政策槽）** |
| JOAN_OF_ARC | RENAISSANCE | F | 1 | **[需有圣物槽]** 获得1个圣物 | 文艺复兴/工业陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| ANA_NZINGA | RENAISSANCE | F | 1 | 获得1个使者 | 文艺复兴/工业陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| PLATI_SFORZA | RENAISSANCE | F | 1 | [Sumus Magnus 新增] | 文艺复兴/工业陆军光环 | Sumus Magnus | 活跃 |
| PLATI_SUAREZ | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业陆军光环 | Sumus Magnus | 活跃 |
| PLATI_LIONHEART | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 文艺复兴/工业陆军光环 | Sumus Magnus | 活跃 |
| NAPOLEON_BONAPARTE | INDUSTRIAL | M | 1 | **[需陆军+标准编队]** 在伟人所在格，选择1个陆军单位编为军团 | 工业/现代陆军+5战斗力+1移动力光环 | 原版 | **重分类为大统治者（通配符政策槽）** |
| RANI_LAKSHMIBAI | INDUSTRIAL | F | 1 | 获得1个骑兵（经验-1，唯一） | 工业/现代陆军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| SIMON_BOLIVAR | INDUSTRIAL | M | 1 | 获得2个使者；EXP1: 需市中心，忠诚度+4/回合 | 工业/现代陆军+5战斗力+1移动力光环 | 原版 | 活跃（EXP1修改） |
| DANDARA | INDUSTRIAL | F | 2 | **[需无军事单位]** 获得1个武僧（经验-1，唯一） | 工业/现代陆军+5战斗力+1移动力光环 | Babylon DLC | **已删除（Sumus Magnus）** |
| PLATI_GARIBALDI | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | 工业/现代陆军光环 | Sumus Magnus | 活跃 |
| JOHN_MONASH | MODERN | M | 1 | 所在格1个陆军单位获得1次免费晋升+额外经验加成 | 现代/原子陆军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| MARINA_RASKOVA | MODERN | F | 1 | **[需拥有地块+机场]** 所在区域获得1个空军槽位 | 现代/原子陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| SAMORI_TURE | MODERN | M | 1 | 获得1个步兵（经验-1，唯一）；EXP1: 获得1个特种部队（经验-1，唯一） | 现代/原子陆军+5战斗力+1移动力光环 | 原版 | **已删除（Sumus Magnus）** |
| TUPAC_AMARU | MODERN | M | 1 | **[需敌方领土]** 在区域获得1个火枪手 | 现代/原子陆军+5战斗力+1移动力光环 | Babylon DLC | 活跃 |
| PLATI_TOKUGAWA | MODERN | M | 1 | [Sumus Magnus 新增] | 现代/原子陆军光环 | Sumus Magnus | 活跃 |
| PLATI_LAWRENCE | MODERN | M | 1 | [Sumus Magnus 新增] | 现代/原子陆军光环 | Sumus Magnus | 活跃 |
| PLATI_UNGERN | MODERN | M | 1 | [Sumus Magnus 新增] | 现代/原子陆军光环 | Sumus Magnus | 活跃 |
| DWIGHT_EISENHOWER | ATOMIC | M | 1 | 所有城市军事单位+5%产能 | 原子/信息陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| GEORGY_ZHUKOV | ATOMIC | M | 1 | 陆军侧翼加成（ABILITY_GEORGY_ZHUKOV_FLANKING_BONUS） | 原子/信息陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| DOUGLAS_MACARTHUR | ATOMIC | M | 1 | 获得1个坦克（经验-1，唯一）；EXP2: 获得1石油/回合 | 原子/信息陆军+5战斗力+1移动力光环 | 原版 | 活跃（EXP2修改） |
| SUDIRMAN | ATOMIC | M | 1 | 所在格1个陆军单位获得1次免费晋升+经验+100%；EXP1: 忠诚度+6/回合 | 原子/信息陆军+5战斗力+1移动力光环 | Expansion1 | 活跃 |
| AHMAD_SHAH_MASSOUD | INFORMATION | M | 1 | 获得1个现代反坦克（经验-1，唯一） | 信息陆军+5战斗力+1移动力光环 | 原版 | 活跃 |
| VIJAYA_WIMALARATNE | INFORMATION | M | 1 | 所在格1个陆军单位获得1次免费晋升+额外经验加成 | 信息陆军+5战斗力+1移动力光环 | 原版 | 活跃 |

**远古伟人Mod (Ancient Paragons) 陆军新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| JNR_FU_HAO | ANCIENT | F | 1 | 获得1个重骑兵单位（带伪装能力） | 远古陆军+5战斗力+1移动力光环 | Ancient Paragons | 活跃 |
| JNR_SIYAJ_K_AK | ANCIENT | M | 1 | 获得1个使者（GREATPERSON_ANA_NZINGA_ACTIVE） | 远古陆军+5战斗力+1移动力光环 | Ancient Paragons | 活跃 |

### 2.3 大工程师 (Great Engineer)

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| IMHOTEP | MEDIEVAL | M | 2 | **[需未完成奇观]** 向所在城市远古/古典奇观+350产能，其他奇观+175产能（每次） | Babylon DLC | 活跃（Ancient Paragons更新时代为CLASSICAL，数值改为250/125） |
| BI_SHENG | MEDIEVAL | M | 1 | **[需市中心]** 所在城市+1区域容量 + 获得印刷术科技突破 | 原版 | **已删除（Delete Some Great Engineer）** |
| ISIDORE_OF_MILETUS | MEDIEVAL | M | 2 | **[需未完成奇观]** 向所在城市奇观+215产能（每次，不溢出） | 原版 | **已删除（Delete Some Great Engineer）** |
| JAMES_OF_ST_GEORGE | MEDIEVAL | M | 3 | **[需市中心+缺少城堡]** 免费获得城墙+城堡（3次） | 原版 | **已删除（Sumus Magnus + Delete Some Great Engineer）** |
| PLATI_AL_AHRAMI | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_URBAN | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_ALI_MASHADDI | CLASSICAL/MEDIEVAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_APOLLODRO | CLASSICAL/MEDIEVAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| FILIPPO_BRUNELLESCHI | RENAISSANCE | M | 2 | **[需未完成奇观]** 向所在城市奇观+315产能（每次，不溢出） | 原版 | 活跃 |
| LEONARDO_DA_VINCI | RENAISSANCE | M | 1 | **[需工业区]** 所有工坊+3文化 + 所有工厂+3文化 + 获得1个现代随机科技突破 | 原版 | 活跃 |
| MIMAR_SINAN | RENAISSANCE | M | 2→1 | 所在城市+1住房+1宜居度；EXP1: 充能次数改为1，触发工业区文化炸弹 | 原版 | 活跃（EXP1修改） |
| PLATI_CHATEAU | RENAISSANCE | M | 1 | [Sumus Magnus 新增，改善设施相关] | Sumus Magnus | 活跃 |
| PLATI_MISSION | RENAISSANCE | M | 1 | [Sumus Magnus 新增，改善设施相关] | Sumus Magnus | 活跃 |
| PLATI_POLDER | RENAISSANCE | M | 1 | [Sumus Magnus 新增，改善设施相关] | Sumus Magnus | 活跃 |
| PLATI_WILBRAHAM | RENAISSANCE | F | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_DAHLBERG | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| ADA_LOVELACE | INDUSTRIAL | F | 1 | **[需市中心]** 所在城市+1区域容量 + 获得计算机科技突破 | 原版 | 活跃 |
| GUSTAVE_EIFFEL | INDUSTRIAL | M | 2 | **[需未完成奇观]** 向所在城市奇观+480产能（每次，不溢出） | 原版 | 活跃 |
| JAMES_WATT | INDUSTRIAL | M | 1 | **[需工业区]** 免费获得工坊+工厂 + 所有工厂+2产能 | 原版 | 活跃 |
| PLATI_ISAMBARD | INDUSTRIAL | M | 1 | [Sumus Magnus 新增，海事相关] | Sumus Magnus | 活跃 |
| PLATI_KRUPP | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| ALVAR_AALTO | MODERN | M | 1 | **[需市中心]** 所在城市+1魅力 | 原版 | **已删除（Delete Some Great Engineer）** |
| NIKOLA_TESLA | MODERN | M | 1 | **[需工业区]** 区域建筑范围+3 + 区域建筑+2产能 | 原版 | 活跃 |
| ROBERT_GODDARD | MODERN | M | 1 | **[需工业区]** 航天项目+20%产能 + 获得火箭技术科技突破 | 原版 | 活跃 |
| SHAH_JAHAN | MODERN | M | 1 | **[需未完成奇观]** 购买奇观产能（用金币） | Babylon DLC | 活跃 |
| JOHN_A_ROEBLING | ATOMIC | M | 2 | **[需市中心]** 所在城市+2住房+1宜居度（每次） | 原版 | **已删除（Sumus Magnus + Delete Some Great Engineer）** |
| JANE_DREW | ATOMIC | F | 1 | **[需市中心]** 所在城市+4住房+3宜居度 | 原版 | **已删除（Sumus Magnus）** |
| SERGEI_KOROLEV | ATOMIC | M | 1 | **[需航天中心+未完成航天项目]** 向所在城市航天项目+1500产能（不溢出） | 原版 | 活跃 |
| CHARLES_CORREA | INFORMATION | M | 1 | **[需市中心]** 所在城市+2魅力 | 原版 | **已删除（Sumus Magnus）** |
| JOSEPH_PAXTON | INFORMATION | M | 1 | **[需娱乐中心]** 区域建筑范围+3 + 区域建筑+1宜居度 | 原版 | 活跃 |
| WERNHER_VON_BRAUN | INFORMATION | M | 1 | **[需航天中心]** 航天项目+100%产能 | 原版 | 活跃 |
| KENZO_TANGE | INFORMATION | M | 1 | 5种区域相邻产出转为旅游业绩 | Babylon DLC | 活跃 |

**远古伟人Mod (Ancient Paragons) 工程师新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| JNR_MARIA_HEBRAEA | CLASSICAL | F | 1 | **[需工业区]** 所有项目+20%产能 | Ancient Paragons | 活跃 |

**EWHO Mod 工程师新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| SHAH_JAHAN_EWHO | RENAISSANCE | M | 3 | **[需地块+未完成奇观]** 用金币购买奇观产能 | EWHO | 活跃 |

### 2.4 大商人 (Great Merchant)

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| COLAEUS | CLASSICAL | M | 1 | **[需可见奢侈品]** 获得所在格奢侈品资源 + 100信仰 | 原版 | 活跃 |
| MARCUS_LICINIUS_CRASSUS | CLASSICAL | M | 3 | **[需无主地块+相邻己方地块]** 获得地块（3次）+ 60金币 | 原版 | 活跃 |
| ZHANG_QIAN | CLASSICAL | M | 1 | **[需商业中心]** 该城市外国商路+2金币（给他人）/+2金币（从他人）+ 商路容量+1 | 原版 | 活跃 |
| PLATI_CROESUS | CLASSICAL | M | 1 | **[需商业中心]** 国库金币翻倍（+100%） | Sumus Magnus | 活跃 |
| MARCO_POLO | MEDIEVAL | M | 1 | **[需商业中心]** +1商路容量 + 该城市外国商路+2金币（给他人）/+2金币（从他人）+ 免费商队 | 原版 | 活跃 |
| PIERO_DE_BARDI | MEDIEVAL | M | 1 | **[需商业中心]** 200金币 + 1个使者 | 原版 | **已删除（Sumus Magnus）** |
| IRENE_OF_ATHENS | MEDIEVAL | F | 1 | 获得所在格奢侈品资源 + 商路容量+1；EXP1: 总督点数+1 | 原版 | 活跃 |
| IBN_FADLAN | MEDIEVAL | M | 1 | **[需商业中心]** 商路容量+1 + 城邦商路+2信仰 | Babylon DLC | 活跃 |
| PLATI_IBN_BATTUTA | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| GIOVANNI_DE_MEDICI | RENAISSANCE | M | 1 | **[需商业中心]** 免费获得市场+银行 + 银行+2宫殿巨作槽 | 原版 | 活跃 |
| JAKOB_FUGGER | RENAISSANCE | M | 1 | **[需商业中心]** 200金币 + 2个使者 | 原版 | **已删除（Sumus Magnus）** |
| RAJA_TODAR_MAL | RENAISSANCE | M | 1 | **[需商业中心]** 1个使者 + 国内商路每个专业区域+0.5金币 | 原版 | 活跃 |
| ZHOU_DAGUAN | RENAISSANCE | M | 1 | **[需城邦领土]** 获得3个使者 | Babylon DLC | 活跃 |
| PLATI_AFANASIY | RENAISSANCE | M | 1 | [Sumus Magnus 新增，城邦相关] | Sumus Magnus | 活跃 |
| PLATI_VENETIAN | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_COLBERT | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_JACOBKETTLER | RENAISSANCE | M | 2 | [Sumus Magnus 新增，海事相关] | Sumus Magnus | 活跃 |
| PLATI_CECIL | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| ADAM_SMITH | INDUSTRIAL | M | 1 | 获得1个经济政策槽位；EXP1: 总督点数+1 + 500金币 | 原版 | **已删除（Sumus Magnus）** |
| JOHN_SPILSBURY | INDUSTRIAL | M | 1 | **[需商业中心]** 获得1个玩具资源 | 原版 | 活跃 |
| JOHN_JACOB_ASTOR | INDUSTRIAL | M | 1 | **[需商业中心]** 500金币 + 2个使者 | 原版 | **已删除（Sumus Magnus）** |
| PLATI_HAMILTON | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_NESTLE | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| PLATI_FABERGE | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| MARY_KATHERINE_GODDARD | MODERN | F | 1 | **[需商业中心]** 外交能见度+1（来源：大新闻） | 原版 | 活跃 |
| JOHN_ROCKEFELLER | MODERN | M | 1 | 获得1石油 + 国内商路每个战略资源+2金币 + 国际商路每个战略资源+2金币；EXP2: 获得3石油/回合 | 原版 | 活跃（EXP2修改） |
| SARAH_BREEDLOVE | MODERN | F | 1 | **[需商业中心]** 商路旅游业绩+25% | 原版 | 活跃 |
| STAMFORD_RAFFLES | MODERN | M | 1 | **[需宗主国领土]** 未指定效果 | Babylon DLC | 活跃 |
| PLATI_BANKER | MODERN | M | 1 | [Sumus Magnus 新增] | Sumus Magnus | 活跃 |
| HELENA_RUBINSTEIN | ATOMIC | F | 1 | **[需商业中心]** 获得2个化妆品资源 | 原版 | 活跃 |
| MELITTA_BENTZ | ATOMIC | F | 1 | **[需商业中心]** 商路旅游业绩+25% + 商路容量+1 | 原版 | 活跃 |
| LEVI_STRAUSS | ATOMIC | M | 1 | **[需商业中心]** 获得2个牛仔裤资源 | 原版 | 活跃 |
| ESTEE_LAUDER | INFORMATION | F | 1 | **[需商业中心]** 获得2个香水资源 | 原版 | 活跃 |
| MASARU_IBUKA | INFORMATION | M | 1 | **[需工业区]** 工业区+10旅游业绩 | 原版 | 活跃 |
| JAMSETJI_TATA | INFORMATION | M | 1 | **[需学院]** 学院+10旅游业绩 | 原版 | 活跃 |

**远古伟人Mod (Ancient Paragons) 商人新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| JNR_AMA_E | ANCIENT | F | 1 | **[需商业中心]** 商路容量+1 + 国内商路+1粮食（给他人）/+1产能（给他人） | Ancient Paragons | 活跃 |
| JNR_HIRAM | ANCIENT | M | 1 | **[需商业中心]** 获得1个骨螺紫（MUREX）奢侈品资源 | Ancient Paragons | 活跃 |

### 2.5 大科学家 (Great Scientist)

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| ARYABHATA | CLASSICAL | M | 1 | **[需学院]** 获得3个古典-中世纪随机科技突破 | 无 | 原版 | 活跃 |
| EUCLID | CLASSICAL | M | 1 | **[需学院]** 获得1个中世纪随机科技突破 + 数学科技突破 | 无 | 原版 | 活跃 |
| HYPATIA | CLASSICAL | F | 1 | **[需学院]** 免费获得图书馆 + 所有图书馆+1科学 | 无 | 原版 | 活跃 |
| ZHANG_HENG | CLASSICAL | M | 1 | **[需学院]** 数学/天文导航/工程学科技突破（或直接获得） | 无 | Babylon DLC | 活跃 |
| PLATI_LEIZU | CLASSICAL | F | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_CAI_LUN | CLASSICAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_ARISTOTLE | CLASSICAL | M | 1 | **[需政府区]** 获得1个通配符政策槽位 | 无 | Sumus Magnus | 活跃 |
| ABU_AL_QASIM_AL_ZAHRAWI | MEDIEVAL | M | 1 | **[任意位置]** 获得1个中世纪-文艺复兴随机科技突破 + 所有单位回血+5 | 所有单位+5回血/回合 | 原版 | 活跃 |
| HILDEGARD_OF_BINGEN | MEDIEVAL | F | 1 | **[需圣地]** 圣地信仰相邻加成转为科学 + 100信仰 | 无 | 原版 | 活跃 |
| OMAR_KHAYYAM | MEDIEVAL | M | 1 | **[需学院]** 获得2个中世纪-文艺复兴随机科技突破 + 1个中世纪-文艺复兴随机市政鼓舞 | 无 | 原版 | 活跃 |
| PLATI_AVERROES | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_SAINT_AUGUSTINE | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_SHEN_KUO | MEDIEVAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| GALILEO_GALILEI | RENAISSANCE | M | 1 | 相邻每个山脉格+250科学（草地/平原/沙漠/冻土/雪地） | 无 | 原版 | 活跃 |
| ISAAC_NEWTON | RENAISSANCE | M | 1 | **[需学院]** 免费获得图书馆+大学 + 所有大学+2科学 | 无 | 原版 | 活跃 |
| EMILIE_DU_CHATELET | RENAISSANCE | F | 1 | **[需学院]** 获得3个文艺复兴-工业随机科技突破 | 无 | 原版 | 活跃 |
| IBN_KHALDUN | RENAISSANCE | M | 1 | **[需学院]** 学院+2住房+1宜居度，幸福/狂喜时产出加成 | 无 | Babylon DLC | 活跃 |
| PLATI_TUSI | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_ERASMUS | RENAISSANCE | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| JAMES_YOUNG | INDUSTRIAL | M | 1 | **[需学院]** 揭示石油 + 获得2个工业-现代随机科技突破 | 无 | 原版 | 活跃 |
| CHARLES_DARWIN | INDUSTRIAL | M | 1 | **[需在或相邻自然奇观]** 相邻每个自然奇观格+500科学 | 无 | 原版 | 活跃 |
| DMITRI_MENDELEEV | INDUSTRIAL | M | 1 | **[需学院]** 获得1个工业随机科技突破 + 化学科技突破 | 无 | 原版 | 活跃 |
| PLATI_FARADAY | INDUSTRIAL | M | 2 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_FRANKLIN | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_LEIBNITZ | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_PASTEUR | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| PLATI_ZEPPELIN | INDUSTRIAL | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| ALAN_TURING | MODERN | M | 1 | **[需学院]** 获得1个现代随机科技突破 + 计算机科技突破 | 无 | 原版 | 活跃 |
| ALBERT_EINSTEIN | MODERN | M | 1 | **[需学院]** 所有研究实验室+4科学 + 获得1个现代-原子随机科技突破 | 无 | 原版 | 活跃 |
| ALFRED_NOBEL | MODERN | M | 1 | **[需学院]** 获得1个现代-原子随机科技突破 + 100免费伟人点数 | 无 | 原版 | 活跃 |
| PLATI_CURIE | MODERN | F | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| JANAKI_AMMAL | ATOMIC | F | 1 | **[需在或相邻雨林]** 相邻每个雨林格+400科学 | 无 | 原版 | 活跃 |
| MARY_LEAKEY | ATOMIC | F | 1 | **[需剧院+文物]** 文物旅游业绩x3 + 该城市每个文物+350科学 | 无 | 原版 | 活跃 |
| ERWIN_SCHRODINGER | ATOMIC | M | 1 | **[需学院]** 获得3个原子-信息随机科技突破 | 无 | 原版 | 活跃 |
| MARGARET_MEAD | ATOMIC | F | 1 | **[需学院+非敌对]** 1000科学+1000文化 | 无 | Babylon DLC | 活跃 |
| PLATI_SAKHAROV | ATOMIC | M | 1 | [Sumus Magnus 新增] | 无 | Sumus Magnus | 活跃 |
| ABDUS_SALAM | INFORMATION | M | 1 | **[需学院]** 获得所有信息时代科技突破 | 无 | 原版 | 活跃 |
| CARL_SAGAN | INFORMATION | M | 1 | **[需航天中心+未完成航天项目]** 向所在城市航天项目+3000产能（不溢出） | 无 | 原版 | 活跃 |
| STEPHANIE_KWOLEK | INFORMATION | F | 1 | **[需航天中心]** 航天项目+100%产能 | 无 | 原版 | 活跃 |

**远古伟人Mod (Ancient Paragons) 科学家新增:**

| 内部ID | 时代 | 性别 | 充能 | 退役效果 | 被动效果 | 来源 | 状态 |
|--------|------|------|------|----------|----------|------|------|
| JNR_THALES_MILETUS | ANCIENT | M | 1 | **[需学院]** 获得1个远古随机科技突破 + 2个古典随机市政鼓舞 | 无 | Ancient Paragons | 活跃 |
| JNR_MAITREYI | ANCIENT | F | 1 | **[需学院]** 所有图书馆+1科学+1文化+1信仰，所有大学+1科学+1文化+1信仰，所有研究实验室+1科学+1文化+1信仰 | 无 | Ancient Paragons | 活跃 |

### 2.6 大先知 (Great Prophet)

所有大先知均 ActionCharges=0，无出生/退役Modifier，用于创立宗教。MaxPlayerInstances=1。

| 内部ID | 时代 | 性别 | 来源 | 状态 |
|--------|------|------|------|------|
| JOHN_THE_BAPTIST | CLASSICAL | M | 原版 | 活跃 |
| CONFUCIUS | CLASSICAL | M | 原版 | 活跃 |
| ZOROASTER | CLASSICAL | M | 原版 | 活跃 |
| SIDDHARTHA_GAUTAMA | CLASSICAL | M | 原版 | 活跃 |
| LAOZI | CLASSICAL | M | 原版 | 活跃 |
| SIMON_PETER | CLASSICAL | M | 原版 | 活跃 |
| BODHIDHARMA | MEDIEVAL | M | 原版 | 活跃 |
| ADI_SHANKARA | MEDIEVAL | M | 原版 | 活跃 |
| SONGTSAN_GAMPO | MEDIEVAL | M | 原版 | 活跃 |
| O_NO_YASUMARO | MEDIEVAL | M | 原版 | 活跃 |
| IRENAEUS | MEDIEVAL | M | 原版 | 活跃 |
| MARTIN_LUTHER | RENAISSANCE | M | 原版 | 活跃 |
| FRANCIS_OF_ASSISI | RENAISSANCE | M | 原版 | 活跃 |
| MADHVA_ACHARYA | RENAISSANCE | M | 原版 | 活跃 |
| THOMAS_AQUINAS | RENAISSANCE | M | 原版 | 活跃 |
| HAJI_HUUD | RENAISSANCE | M | 原版 | 活跃 |

**远古伟人Mod (Ancient Paragons) 先知新增:**

| 内部ID | 时代 | 性别 | 充能 | 来源 | 状态 |
|--------|------|------|------|------|------|
| JNR_MOSES | ANCIENT | M | 0 | Ancient Paragons | 活跃 |
| JNR_GARGI_VACHAKNAVI | ANCIENT | F | 0 | Ancient Paragons | 活跃 |

### 2.7 大作家 (Great Writer)

所有大作家 ActionCharges=0（除屈原），通过生成著作（Great Work of Writing）运作。

| 内部ID | 时代 | 性别 | 充能 | 特殊效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| BHASA | CLASSICAL | M | 0 | 生成著作 | 原版 | 活跃 |
| HOMER | CLASSICAL | M | 0 | 生成著作 | 原版 | 活跃 |
| OVID | CLASSICAL | M | 0 | 生成著作 | 原版 | 活跃 |
| QU_YUAN | CLASSICAL | M | 2 | 退役获地块（文化炸弹） | 原版 | 活跃 |
| VALMIKI | CLASSICAL | M | 0 | 生成著作 | Babylon DLC | 活跃 |
| GEOFFREY_CHAUCER | MEDIEVAL | M | 0 | 生成著作 | 原版 | 活跃 |
| LI_BAI | MEDIEVAL | M | 0 | 生成著作 | 原版 | 活跃 |
| MURASAKI_SHIKIBU | MEDIEVAL | F | 0 | 生成著作 | 原版 | 活跃 |
| RUMI | MEDIEVAL | M | 0 | 生成著作 | Babylon DLC | 活跃 |
| MARGARET_CAVENDISH | RENAISSANCE | F | 0 | 生成著作 | 原版 | 活跃 |
| MIGUEL_DE_CERVANTES | RENAISSANCE | M | 0 | 生成著作 | 原版 | 活跃 |
| NICCOLO_MACHIAVELLI | RENAISSANCE | M | 0 | 生成著作 | 原版 | 活跃 |
| WILLIAM_SHAKESPEARE | RENAISSANCE | M | 0 | 生成著作 | 原版 | 活跃 |
| MARIE_CATHERINE_D_AULNOY | RENAISSANCE | F | 0 | 生成著作 | 原版 | 活跃 |
| PLATI_HOBBES | RENAISSANCE | M | 0 | 生成著作 | Sumus Magnus | 活跃 |
| ALEXANDER_PUSHKIN | INDUSTRIAL | M | 0 | 生成著作 | 原版 | 活跃 |
| EDGAR_ALLEN_POE | INDUSTRIAL | M | 0 | 生成著作 | 原版 | 活跃 |
| JANE_AUSTEN | INDUSTRIAL | F | 0 | 生成著作 | 原版 | 活跃 |
| JOHANN_WOLFGANG_VON_GOETHE | INDUSTRIAL | M | 0 | 生成著作 | 原版 | 活跃 |
| MARY_SHELLEY | INDUSTRIAL | F | 0 | 生成著作 | 原版 | 活跃 |
| PLATI_NIETZSCHE | INDUSTRIAL | M | 0 | 生成著作 | Sumus Magnus | 活跃 |
| JAMES_JOYCE | MODERN | M | 0 | 生成著作 | 原版 | 活跃 |
| EMILY_DICKINSON | MODERN | F | 0 | 生成著作 | 原版 | 活跃 |
| LEO_TOLSTOY | MODERN | M | 0 | 生成著作 | 原版 | 活跃 |
| MARK_TWAIN | MODERN | M | 0 | 生成著作 | 原版 | 活跃 |
| F_SCOTT_FITZGERALD | MODERN | M | 0 | 生成著作 | 原版 | 活跃 |
| BEATRIX_POTTER | MODERN | M | 0 | 生成著作 | Babylon DLC | 活跃 |
| PLATI_HEIDEGGER | MODERN | M | 0 | 生成著作 | Sumus Magnus | 活跃 |
| PLATI_LOVECRAFT | MODERN | M | 0 | 生成著作 | Sumus Magnus | 活跃 |
| PLATI_RHOWARD | MODERN | M | 0 | 生成著作 | Sumus Magnus | 活跃 |
| HG_WELLS | ATOMIC | M | 0 | 生成著作 | 原版 | 活跃 |
| RABINDRANATH_TAGORE | ATOMIC | M | 0 | 生成著作 | 原版 | 活跃 |
| PLATI_DESCARTES | ATOMIC | M | 1 | [Sumus Magnus 新增，有充能] | Sumus Magnus | 活跃 |
| PLATI_CICERO | ATOMIC | M | 1 | [Sumus Magnus 新增，有充能] | Sumus Magnus | 活跃 |
| KAREL_CAPEK | INFORMATION | M | 0 | 生成著作 | 原版 | 活跃 |
| GABRIELA_MISTRAL | INFORMATION | M | 0 | 生成著作 | Babylon DLC | 活跃 |

**远古伟人Mod (Ancient Paragons) 作家新增:**

| 内部ID | 时代 | 性别 | 充能 | 特殊效果 | 来源 | 状态 |
|--------|------|------|------|----------|------|------|
| JNR_EN_HEDU_ANNA | ANCIENT | F | 0 | 生成著作 | Ancient Paragons | 活跃 |
| JNR_PTAHHOTEP | ANCIENT | M | 0 | 生成著作 | Ancient Paragons | 活跃 |

### 2.8 大艺术家 (Great Artist)

所有大艺术家 ActionCharges=0，通过生成艺术品（Great Work of Art）运作。

| 内部ID | 时代 | 性别 | 来源 | 状态 |
|--------|------|------|------|------|
| ANDREY_RUBLEV | RENAISSANCE | M | 原版 | 活跃 |
| HIERONYMUS_BOSCH | RENAISSANCE | M | 原版 | 活跃 |
| DONATELLO | RENAISSANCE | M | 原版 | 活跃 |
| MICHELANGELO | RENAISSANCE | M | 原版 | 活跃 |
| KAMAL_UD_DIN_BEHZAD | RENAISSANCE | M | Babylon DLC | 活跃 |
| QIU_YING | INDUSTRIAL | M | 原版 | 活跃 |
| TITIAN | INDUSTRIAL | M | 原版 | 活跃 |
| EL_GRECO | INDUSTRIAL | M | 原版 | 活跃 |
| REMBRANDT_VAN_RIJN | INDUSTRIAL | M | 原版 | 活跃 |
| HASEGAWA_TOHAKU | INDUSTRIAL | M | Babylon DLC | 活跃 |
| PLATI_RASTRELLI | INDUSTRIAL | M | Sumus Magnus | 活跃 |
| SOFONISBA_ANGUISSOLA | MODERN | F | 原版 | 活跃 |
| ANGELICA_KAUFFMAN | MODERN | F | 原版 | 活跃 |
| JANG_SEUNG_EOP | MODERN | M | 原版 | 活跃 |
| KATSUSHIKA_HOKUSAI | MODERN | M | 原版 | 活跃 |
| VINCENT_VAN_GOGH | ATOMIC | M | 原版 | 活跃 |
| EDMONIA_LEWIS | ATOMIC | F | 原版 | 活跃 |
| MARIE_ANNE_COLLOT | ATOMIC | F | 原版 | 活跃 |
| CLAUDE_MONET | ATOMIC | M | 原版 | 活跃 |
| BORIS_ORLOVSKY | INFORMATION | M | 原版 | 活跃 |
| GUSTAV_KLIMT | INFORMATION | M | 原版 | 活跃 |
| AMRITA_SHER_GIL | INFORMATION | F | 原版 | 活跃 |
| MARY_CASSATT | INFORMATION | F | 原版 | 活跃 |
| WASSILY_KANDINSKY | INFORMATION | M | Babylon DLC | 活跃 |

**Sumus Magnus 新增艺术家 (Painter_All):**
- 多位画家，通过生成艺术品运作

### 2.9 大音乐家 (Great Musician)

所有大音乐家 ActionCharges=0，通过生成音乐巨作（Great Work of Music）运作。

| 内部ID | 时代 | 性别 | 来源 | 状态 |
|--------|------|------|------|------|
| ANTONIO_VIVALDI | INDUSTRIAL | M | 原版 | 活跃 |
| JOHANN_SEBASTIAN_BACH | INDUSTRIAL | M | 原版 | 活跃 |
| LUDWIG_VAN_BEETHOVEN | INDUSTRIAL | M | 原版 | 活跃 |
| WOLFGANG_AMADEUS_MOZART | INDUSTRIAL | M | 原版 | 活跃 |
| YATSUHASHI_KENGYO | INDUSTRIAL | M | 原版 | 活跃 |
| DIMITRIE_CANTEMIR | INDUSTRIAL | M | Babylon DLC | 活跃 |
| ANTONIO_CARLOS_GOMEZ | MODERN | M | 原版 | 活跃 |
| FRANZ_LISZT | MODERN | M | 原版 | 活跃 |
| FREDERIC_CHOPIN | MODERN | M | 原版 | 活跃 |
| PETER_ILYICH_TCHAIKOVSKY | MODERN | M | 原版 | 活跃 |
| LIU_TIANHUA | MODERN | M | 原版 | 活跃 |
| SCOTT_JOPLIN | MODERN | M | Babylon DLC | 活跃 |
| ANTONIN_DVORAK | ATOMIC | M | 原版 | 活跃 |
| CLARA_SCHUMANN | ATOMIC | F | 原版 | 活跃 |
| JUVENTINO_ROSAS | ATOMIC | M | 原版 | 活跃 |
| LILIUOKALANI | ATOMIC | F | 原版 | 活跃 |
| GAUHAR_JAAN | INFORMATION | F | 原版 | 活跃 |
| MYKOLA_LEONTOVYCH | INFORMATION | M | 原版 | 活跃 |

### 2.10 大统帅 (Comandante General) — GranColombia DLC

全部 ERA_ANCIENT，性别 M，充能 1，类别 GREAT_PERSON_CLASS_COMANDANTE_GENERAL。

| 内部ID | 退役效果 | 退役条件 | 被动效果 |
|--------|----------|----------|----------|
| JOSE_DE_SUCRE | 获得1个陆军单位 + 陆军单位免费晋升 + 无视资源维护 | 需无军事单位 | +5战斗力光环 +1移动力光环，退役时治疗相邻利亚内罗单位100HP |
| PAULA_SANTANDER | 获得1个随机市政 | 无特殊条件 | 同上 |
| ANTONIO_PAEZ | 骑兵+4战斗力 | 需附近轻骑+重骑 | 同上 |
| URDANETA | 重置所有陆军移动力 | 需2格内有陆军 | 同上 |
| MARINO | 近战+反骑兵+4战斗力 | 需附近近战+反骑兵 | 同上 |
| MACGREGOR | 所在格陆军免费晋升 + 获得单位成本50%金币 | 需陆军+可获经验 | 同上 |
| PIAR | 所在格陆军+7战斗力 | 需陆军单位 | 同上 |
| NARINO | 商路容量+1 + 免费商队 | 无特殊条件 | 同上 |
| MONTILLA | 陆军对区域+4战斗力 | 需2格内有陆军 | 同上 |
| RIBAS | 对2格内敌方单位造成30伤害 | 需2格内有敌方军事单位 | 同上 |

**光环机制**：COMANDANTE_AOE_STRENGTH (Amount=5) + COMANDANTE_AOE_MOVEMENT (Amount=1)，通过 ABILITY_COMANDANTE_GENERAL_STRENGTH / ABILITY_COMANDANTE_GENERAL_MOVEMENT 实现。

### 2.11 大统治者 (Great Sovereigns) — Mod

全新类别，区域为 DISTRICT_GOVERNMENT，PseudoYieldType=PSEUDOYIELD_GPP_GreatSovereigns。

**核心13人:**

| 内部ID | 名称 | 时代 | 性别 | 充能 | 退役效果 | 触发条件 |
|--------|------|------|------|------|----------|----------|
| PLATI_FIRST | 所罗门 | CLASSICAL | M | 1 | 免费获得寺庙 + 全寺庙+2产能 | 需圣地 |
| PLATI_SECOND | 马可·奥勒留 | CLASSICAL | M | 1 | 获得99个中世纪市政鼓舞 | 需政府区 |
| PLATI_THIRD | 大流士 | CLASSICAL | M | 1 | 向奇观+100产能（不溢出，随游戏速度）+ 每影响力点+1文化 | 需未完成奇观 |
| PLATI_FOURTH | 阿育王 | CLASSICAL | M | 1 | 每个专业区域+1信仰 + 每个专业区域+1食物 | 需政府区 |
| PLATI_FIFTH | 腓特烈二世 | MEDIEVAL | M | 1 | 获得1个经济政策槽位 | 需政府区 |
| PLATI_SIXTH | 艾哈迈德·曼苏尔 | INDUSTRIAL | M | 1 | 单位升级费用-100% + 获得1个随机科技 | 需政府区 |
| PLATI_SEVENTH | 查理曼 | MEDIEVAL | M | 1 | 获得1个军事政策槽位 | 需政府区 |
| PLATI_EIGHTH | 哈伦·拉希德 | MEDIEVAL | M | 1 | 黄金时代时商路每格+0.17科学 | 需政府区 |
| PLATI_NINTH | 阿斯基亚 | RENAISSANCE | M | 1 | 区域劫掠奖励+2 + 方尖碑免费替换为阿斯基亚纪念碑 | 需圣地+剧院 |
| PLATI_TENTH | 阿克巴 | RENAISSANCE | M | 1 | 获得1个通配符政策槽位 | 需政府区 |
| PLATI_THIRTEENTH | 明治 | INDUSTRIAL | M | 1 | 社区+300金币（替换农场）+ 工业区+300金币（替换农场）+ 社区↔工业区互相+2食物相邻 | 需政府区 |
| PLATI_FOURTEENTH | 凯末尔 | MODERN | M | 3 | 向城市+400产能（不溢出，随游戏速度，3次）+ 所有陆军+3战斗力 | 需市中心 |
| PLATI_FIFTEENTH | 海尔·塞拉西 | MODERN | M | 1 | 获得2个外交胜利点数 | 需政府区 |

**阿尔弗雷德大帝（特殊）:**

| 内部ID | 名称 | 时代 | 性别 | 充能 | 退役效果 | 触发条件 |
|--------|------|------|------|------|----------|----------|
| PLATI_ALFRED_THE_GREAT | 阿尔弗雷德大帝 | MEDIEVAL | M | 1 | 兵工厂相邻+1产能 + 兵工厂相邻+1科学 + 兵工厂训练海军单位获得免费晋升 | 需兵工厂 |

**重分类（原版陆军统帅迁移）:**

| 原版ID | 名称 | 时代 | 退役效果 | 重分类原因 |
|--------|------|------|----------|------------|
| NAPOLEON_BONAPARTE | 拿破仑·波拿巴 | INDUSTRIAL | 获得1个通配符政策槽位 | 通过 SovereignReclassifyGenerals 参数控制 |
| GUSTAVUS_ADOLPHUS | 古斯塔夫·阿道夫 | RENAISSANCE | 获得1个军事政策槽位 | 通过 SovereignReclassifyGenerals 参数控制 |

**扩展19人（Expansion目录）:**

| 内部ID | 名称 | 时代 | 性别 | 充能 | 退役效果 |
|--------|------|------|------|------|----------|
| PLATI_KOSEMI | 柯塞姆苏丹 | - | F | 1 | [见源码] |
| PLATI_RBORGIA | 罗德里戈·波吉亚 | - | M | 1 | [见源码] |
| PLATI_DANDOLO | 恩里科·丹多洛 | - | M | 1 | [见源码] |
| PLATI_ISABELLA | 伊莎贝拉 | - | F | 1 | [见源码] |
| PLATI_MONACO | 摩纳哥 | - | - | 1 | [见源码] |
| PLATI_AKBAR | 阿克巴（扩展） | - | M | 1 | [见源码] |
| PLATI_BISMARK | 俾斯麦 | - | M | 1 | [见源码] |
| PLATI_TWELWTH | 第十二位 | - | - | 1 | [见源码] |
| PLATI_ARBE | 阿尔贝 | - | - | 1 | [见源码] |
| PLATI_DENG | 邓小平 | - | M | 1 | [见源码] |
| PLATI_ELEVENTH | 第十一位 | - | - | 1 | [见源码] |
| PLATI_SIXTEENTH | 第十六位 | - | - | 1 | [见源码] |
| PLATI_BEG | 贝格 | - | - | 1 | [见源码] |
| PLATI_SOVEREIGN_FIRST | 首位统治者 | - | - | 1 | [见源码] |
| PLATI_SOVEREIGN_FRIDRIK_GREAT | 腓特烈大帝 | - | M | 1 | [见源码] |
| PLATI_SOVEREIGN_GEDIMINAS | 格迪米纳斯 | - | M | 1 | [见源码] |
| PLATI_ISMAIL | 伊斯玛仪 | - | M | 1 | 骑兵单位占领城市时转化（非黄金时代），骑兵+3战斗力 |
| PLATI_SOVEREIGN_ZAYED | 扎耶德 | - | M | 1 | [见源码] |
| PLATI_MARIA_THERESA | 玛丽亚·特蕾莎 | - | F | 1 | [见源码] |
| PLATI_SOVEREIGN_LKY | 李光耀 | - | M | 1 | [见源码] |

**大统治者伟人点数来源：**
- 政府区 +1/回合
- 一级政府建筑 +1/回合
- 二级政府建筑 +2/回合
- 三级政府建筑 +3/回合
- 阿尔罕布拉宫 +1/回合
- 宙斯神像 +2/回合
- 泰姬陵 +1/回合
- 圣索菲亚大教堂 +2/回合
- 吴哥窟 +2/回合
- 罗马斗兽场 +2/回合
- 金字塔 +1/回合
- 神谕 +2/回合（通过SQL添加）

**大统治者专属政策卡：**
- 寡头制（TIMOCRACY）：所有单位击杀获得+8大统治者伟人点数
- 独裁制（AUTOCRACY）：首都拥有特定奇观时+1大统治者伟人点数/回合
- 古典共和制（REPUBLICAN）：拥有3个专业区域的城市+1大统治者伟人点数/回合
- 君主制（MONARCHY）：外交区领事馆+2/外事办+2大统治者伟人点数/回合
- 神权制（THEOCRACY）：拥有三级宗教建筑的城市+2大统治者伟人点数/回合
- 重商共和（PLUTOCRACY）：对6种城邦类型各+2大统治者伟人点数/回合
- 法西斯（FASCIST）：处于战争状态+1大统治者伟人点数/回合
- 共产主义（COMMUNIST）：学院/工业区高相邻+2或+1大统治者伟人点数/回合
- 民主制（DEMOCRAT）：拥有体育场+20人口的城市+6大统治者伟人点数/回合

---

## §3 数据链追溯

### 3.1 通用光环系统

**陆/海军统帅战斗力光环:**

```
数据链: GreatPersonIndividualBirthModifiers
  → MODIFIER_PLAYER_UNITS_GRANT_ABILITY
  → AbilityType: ABILITY_GREAT_GENERAL_STRENGTH / ABILITY_GREAT_ADMIRAL_STRENGTH
  → UnitAbilityModifiers
  → MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH (Amount=5)
  → SubjectRequirementSet: AOE_LAND/SEA_REQUIREMENTS (时代限制)
```

**陆/海军统帅移动力光环:**

```
数据链: GreatPersonIndividualBirthModifiers
  → MODIFIER_PLAYER_UNITS_GRANT_ABILITY
  → AbilityType: ABILITY_GREAT_GENERAL_MOVEMENT / ABILITY_GREAT_ADMIRAL_MOVEMENT
  → UnitAbilityModifiers
  → MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT (Amount=1)
  → SubjectRequirementSet: AOE_LAND/SEA_REQUIREMENTS (时代限制)
```

**时代限制条件链（以古典海军为例）：**
```
AOE_CLASSICAL_SEA_REQUIREMENTS (REQUIREMENTSET_TEST_ALL)
  ├── AOE_REQUIRES_SEA_DOMAIN: REQUIREMENT_UNIT_DOMAIN_MATCHES (DOMAIN_SEA)
  ├── AOE_REQUIRES_OWNER_ADJACENCY: REQUIREMENT_PLOT_ADJACENT_TO_OWNER
  └── AOE_CLASSICAL_SEA_REQUIREMENTS: REQUIREMENT_REQUIREMENTSET_IS_MET
      └── AOE_REQUIRES_CLASSICAL_SEA (REQUIREMENTSET_TEST_ANY)
          ├── AOE_REQUIRES_CLASSICAL_UNIT: REQUIREMENT_UNIT_ERA_TYPE_MATCHES (ERA_CLASSICAL)
          └── AOE_REQUIRES_MEDIEVAL_UNIT: REQUIREMENT_UNIT_ERA_TYPE_MATCHES (ERA_MEDIEVAL)
```

### 3.2 通用退役效果

**GREATPERSON_GOLD (小额金币):**
```
MODIFIER_PLAYER_GRANT_YIELD → YIELD_GOLD, Amount=200
```

**GREATPERSON_1MODERNTECHBOOST:**
```
MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA → ERA_MODERN, Amount=1
```

**GREATPERSON_COMPUTERSTECHBOOST:**
```
MODIFIER_PLAYER_GRANT_SPECIFIC_TECH_BOOST → TECH_COMPUTERS
```

**GREATPERSON_SPACE_RACE_PRODUCTION_RATE_LARGE:**
```
MODIFIER_PLAYER_CITIES_ADJUST_SPACE_RACE_PROJECTS_PRODUCTION → Amount=100
```

**GREATPERSON_GRANT_PRODUCTION_IN_CITY (奇观产能):**
```
MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY → Amount=N (ScaleByGameSpeed), KeepOverflow=false
```

**GREATPERSON_FREE_PROMOTION (免费晋升):**
```
MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE → Amount=-1 (表示免费晋升1次)
```

**GREATPERSON_FORM_CORPS / GREATPERSON_FORM_ARMY (编队/军团):**
```
MODIFIER_UNIT_ADJUST_FORMATION_CLASS → 编为舰队/军团
```

### 3.3 海军统帅独特效果

**LEIF_ERIKSON 海洋通行:**
```
GREATPERSON_LEIF_ERIKSON_ACTIVE
  → MODIFIER_PLAYER_UNITS_ADJUST_OCEAN_VALID → 所有海军单位可进入海洋
EXP2: ERIKSON_NAVAL_SIGHT
  → MODIFIER_PLAYER_UNITS_GRANT_ABILITY → ABILITY_ERIKSON_NAVAL_SIGHT
  → MODIFIER_PLAYER_UNIT_ADJUST_SIGHT → Amount=2
```

**RAJENDRA_CHOLA 海军战斗力:**
```
EXP2: CHOLA_NAVAL_COMBAT
  → MODIFIER_PLAYER_UNITS_GRANT_ABILITY → ABILITY_CHOLA_NAVAL_COMBAT
  → MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH → Amount=5
```

**HORATIO_NELSON 侧翼加成:**
```
MODIFIER_PLAYER_UNITS_GRANT_ABILITY → ABILITY_HORATIO_NELSON_FLANKING_BONUS
  → MODIFIER_UNIT_ADJUST_FLANKING → 加成海军侧翼
EXP2: 免费灯塔+船坞（MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE）
```

**JOAQUIM_MARQUES_LISBOA 厌战度:**
```
MODIFIER_PLAYER_ADJUST_WAR_WEARINESS → Amount=-25 (%)
```

**CHESTER_NIMITZ 海军偷袭者产能:**
```
MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PRODUCTION → 海军偷袭者+20%产能
EXP2: 获得潜艇+石油/回合
```

**GRACE_HOPPER 科技突破:**
```
EXP2: MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA → 2个随机科技
```

### 3.4 陆军统帅独特效果

**BOUDICA 转化蛮族:**
```
MODIFIER_PLAYER_UNIT_ADJUST_BARBARIANS_TO_OWNER → 相邻蛮族单位转为己方
条件: 需相邻蛮族单位
```

**GEORGY_ZHUKOV 侧翼加成:**
```
MODIFIER_PLAYER_UNITS_GRANT_ABILITY → ABILITY_GEORGY_ZHUKOV_FLANKING_BONUS
  → MODIFIER_UNIT_ADJUST_FLANKING → 加成陆军侧翼
```

**DWIGHT_EISENHOWER 军事产能:**
```
MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION → Amount=5 (%)
```

### 3.5 大工程师独特效果

**LEONARDO_DA_VINCI 工坊文化:**
```
MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE → BUILDING_WORKSHOP → YIELD_CULTURE → Amount=3
```

**NIKOLA_TESLA 区域范围:**
```
MODIFIER_PLAYER_CITIES_ADJUST_CITY_REGIONAL_EFFECT_RANGE → Amount=3
MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE → 区域建筑+2产能
```

**WERNHER_VON_BRAUN 航天产能:**
```
MODIFIER_PLAYER_CITIES_ADJUST_SPACE_RACE_PROJECTS_PRODUCTION → Amount=100 (%)
```

**SHAH_JAHAN 奇观购买:**
```
MODIFIER_CITY_PURCHASE_PRODUCTION → 用金币购买奇观产能
```

### 3.6 大商人独特效果

**MARCUS_LICINIUS_CRASSUS 地块获取:**
```
MODIFIER_PLAYER_GRANT_PLOT → 获取无主地块（3次）
条件: 地块无主 + 相邻己方地块
```

**MARY_KATHERINE_GODDARD 外交能见度:**
```
MODIFIER_PLAYER_ADJUST_DIPLO_VISIBILITY → Amount=1, Source="大新闻"
```

**SARAH_BREEDLOVE / MELITTA_BENTZ 商路旅游业绩:**
```
MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_TOURISM → Amount=25 (%)
```

### 3.7 大科学家独特效果

**GALILEO_GALILEI 山脉科学:**
```
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 每相邻山脉格+250科学
地形条件: 草地/平原/沙漠/冻土/雪地
```

**CHARLES_DARWIN 自然奇观科学:**
```
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 每相邻自然奇观格+500科学
条件: 在或相邻自然奇观
```

**JANAKI_AMMAL 雨林科学:**
```
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 每相邻雨林格+400科学
条件: 在或相邻雨林
```

**MARY_LEAKEY 文物:**
```
MODIFIER_PLAYER_ADJUST_GREAT_WORK_TOURISM → 文物旅游业绩x3
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 该城市每个文物+350科学
```

**ABDUS_SALAM 信息时代科技:**
```
MODIFIER_PLAYER_GRANT_ALL_TECHNOLOGY_BOOSTS_BY_ERA → ERA_INFORMATION
```

---

## §4 三方法交叉验证

### 4.1 XML 发现的效果

- 所有伟人个体的 GreatPersonIndividuals 表定义（类型、时代、充能次数、ActionRequires）
- 所有 Modifier 链定义（Type → Trait → Modifier → Arguments → Requirements）
- 光环系统（AOE Combat Strength / Movement）通过 GreatPersonIndividualBirthModifiers 绑定
- 退役效果通过 GreatPersonIndividualActionModifiers 绑定
- 所有DLC修改通过 UPDATE 或 INSERT 新 Modifier 实现
- 所有Mod新增通过 INSERT OR IGNORE / INSERT INTO 实现

### 4.2 SQL 发现的效果

- **Ancient Paragons** 所有伟人数据通过 SQL INSERT 语句定义
- **Great Sovereigns** 神谕加成通过 SQL INSERT 动态添加
- **Delete Some Great Engineer** 通过 SQL DELETE 语句删除5位工程师
- **Ancient Paragons** 单位能力（ABILITY_JNR_FU_HAO_CAMOUFLAGE / ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER）通过 SQL 定义
- **Ancient Paragons** 远古时代光环条件（AOE_ANCIENT_REQUIREMENTS_JNR）通过 SQL 定义，包含远古和古典时代
- **Ancient Paragons** JNR_SIYAJ_K_AK 的条件性 UPDATE：当检测到 EXP1 时，退役效果改为 GREATPERSON_AETHELFLAED_ACTIVE（复制阿瑟尔弗莱德的效果）
- **Ancient Paragons** 伊姆霍特普（IMHOTEP）的时代从 MEDIEVAL 更新为 CLASSICAL，产能数值从 350/175 调整为 250/125

### 4.3 Lua 发现的效果

**艺术类伟人偷奇观 Mod (GreatPersonTeleport.lua):**

1. **奇观学家偷取功能 (ArchaeologistStealWonder):**
   - 触发条件：玩家拥有奇观学家单位（UNIT_WONDER_THEFT），充能≥1，站在己方城市领土
   - 效果：将所在城市的奇观从城市中移除，存储到奇观学家身上
   - 黑名单：金门大桥、巴拿马运河、塔桥不可偷取

2. **奇观学家安置功能 (ArchaeologistPlaceWonder):**
   - 触发条件：奇观学家携带有偷取的奇观，站在己方城市领土
   - 效果：消耗对应游戏速度的奇观成本金币，将奇观放置在目标城市

3. **传送开拓者功能 (GreatPersonTeleportSettler):**
   - 触发条件：艺术类伟人消耗后，选择开拓者
   - 效果：将开拓者准确传送到指定坐标，消耗伟人

4. **文化炸弹功能 (CultureBomb):**
   - 触发条件：艺术类伟人消耗后选择文化炸弹
   - 效果：先吞并伟人所在格（如为中立），然后吞并周围1格范围内的中立地块
   - 障碍物检测：跳过区域和奇观所在格

5. **召唤奇观学家功能 (SummonWonderTheft):**
   - 触发条件：艺术类伟人消耗后选择召唤
   - 效果：在伟人所在格生成1个奇观学家单位（UNIT_WONDER_THEFT），消耗伟人

### 4.4 交叉验证结论

- **XML** 是主要数据定义方式，覆盖所有伟人个体的基础属性、Modifier 链和效果
- **SQL** 主要用于 Ancient Paragons Mod 和条件性修改（UPDATE with EXISTS 检查），以及 Delete Some Great Engineer 的删除操作
- **Lua** 仅用于艺术类伟人偷奇观 Mod，提供 XML/SQL 无法实现的动态交互（奇观偷取/安放、精确传送、文化炸弹）
- 三者之间无冲突，各自处理不同层面的功能

---

## §5 被修改/删除内容

### 5.1 原版条目被修改

**Expansion1 修改:**
| 文件 | 目标 | 修改内容 |
|------|------|----------|
| Expansion1_GreatPeople_Admirals.xml | THEMISTOCLES | 新增忠诚度+2/回合 |
| Expansion1_GreatPeople_Admirals.xml | TOGO_HEIHACHIRO | 新增忠诚度+6/回合 |
| Expansion1_GreatPeople_Generals.xml | SIMON_BOLIVAR | 新增忠诚度+4/回合 |
| Expansion1_GreatPeople_Generals.xml | AETHELFLAED | 新增忠诚度+2/回合，ActionRequiresCompletedDistrictType=DISTRICT_CITY_CENTER |
| Expansion1_GreatPeople_Engineers.xml | MIMAR_SINAN | 充能次数从2改为1，触发工业区文化炸弹 |

**Expansion2 修改:**
| 文件 | 目标 | 修改内容 |
|------|------|----------|
| Expansion2_GreatPeople_Admirals.xml | THEMISTOCLES | 海军远程单位+20%产能 |
| Expansion2_GreatPeople_Admirals.xml | ZHENG_HE | 贸易路线效果+免费商队+商路容量 |
| Expansion2_GreatPeople_Admirals.xml | FRANCIS_DRAKE | 获得1艘私掠船 |
| Expansion2_GreatPeople_Admirals.xml | YI_SUN_SIN | 获得1煤/回合 |
| Expansion2_GreatPeople_Admirals.xml | FRANZ_VON_HIPPER | 获得1煤/回合 |
| Expansion2_GreatPeople_Admirals.xml | CHESTER_NIMITZ | 获得潜艇+1石油/回合 |
| Expansion2_GreatPeople_Admirals.xml | HORATIO_NELSON | 免费灯塔+船坞 |
| Expansion2_GreatPeople_Admirals.xml | GRACE_HOPPER | 获得2个随机科技 |
| Expansion2_GreatPeople_Generals.xml | DOUGLAS_MACARTHUR | 获得1石油/回合 |
| Expansion2_GreatPeople_Merchants.xml | JOHN_ROCKEFELLER | 获得3石油/回合 |

**Ancient Paragons 修改:**
| 目标 | 修改内容 |
|------|----------|
| IMHOTEP | EraType 从 MEDIEVAL 改为 CLASSICAL，产能数值从350/175改为250/125 |
| JNR_SIYAJ_K_AK | 当检测到 EXP1 时，退役效果改为 GREATPERSON_AETHELFLAED_ACTIVE + 需市中心 |

### 5.2 条目被删除

**Sumus Magnus RemoveData (18条删除):**

| 类型 | 删除的ID |
|------|----------|
| 工程师 | JOHN_A_ROEBLING, CHARLES_CORREA, JANE_DREW, JAMES_OF_ST_GEORGE |
| 海军 | FRANZ_VON_HIPPER, FRANCIS_DRAKE, LASKARINA_BOUBOULINA, YI_SUN_SIN, HANNO_THE_NAVIGATOR |
| 陆军 | DANDARA, JOHN_MONASH, RANI_LAKSHMIBAI, SAMORI_TURE, AETHELFLAED |
| 商人 | PIERO_DE_BARDI, JAKOB_FUGGER, JOHN_JACOB_ASTOR, ADAM_SMITH |

**Delete Some Great Engineer (5条删除):**
- BI_SHENG (毕昇)
- ISIDORE_OF_MILETUS (米利都的伊西多尔)
- JAMES_OF_ST_GEORGE (圣乔治的詹姆斯) — 与Sumus Magnus重复删除
- ALVAR_AALTO (阿尔瓦·阿尔托)
- JOHN_A_ROEBLING (约翰·罗布林) — 与Sumus Magnus重复删除

**大先知 MaxPlayerInstances=1**（此设置已存在于原版，非Mod删除）

### 5.3 重分类条目

| 原版ID | 原名 | 原类别 | 新类别 | 新效果 |
|--------|------|--------|--------|--------|
| NAPOLEON_BONAPARTE | 拿破仑·波拿巴 | GREAT_PERSON_CLASS_GENERAL | GREAT_PERSON_CLASS_GreatSovereigns | 获得1个通配符政策槽位 |
| GUSTAVUS_ADOLPHUS | 古斯塔夫·阿道夫 | GREAT_PERSON_CLASS_GENERAL | GREAT_PERSON_CLASS_GreatSovereigns | 获得1个军事政策槽位 |

重分类通过 GreatSovereigns_Config.xml 中的 `SovereignReclassifyGenerals` 参数控制（默认关闭）。

---

## §6 兼容性分析

### 6.1 Mod 冲突分析

**关键冲突：**

1. **Delete Some Great Engineer (LoadOrder 0) vs Sumus Magnus (LoadOrder 240):**
   - Delete Some Great Engineer 删除 BI_SHENG, ISIDORE_OF_MILETUS, JAMES_OF_ST_GEORGE, ALVAR_AALTO, JOHN_A_ROEBLING
   - Sumus Magnus 也删除 JAMES_OF_ST_GEORGE 和 JOHN_A_ROEBLING（重复删除）
   - 由于 Sumus Magnus 加载顺序更后（240 > 0），Sumus Magnus 的 RemoveData 在 Delete Some Great Engineer 之后执行
   - 但两者都是 DELETE 操作，重复删除不会导致错误
   - **结论**: 无冲突，删除操作互补

2. **EWHO (LoadOrder 999999) vs 所有伟人Mod:**
   - EWHO 最后加载，其 GreatPersonClasses 表定义会覆盖之前的修改
   - EWHO 新增了 GREAT_PERSON_CLASS_ENGINEER_EWHO 类别和 SHAH_JAHAN_EWHO 个体
   - **结论**: EWHO 对 GreatPersonClasses 的修改可能覆盖前面的设置，但新增内容独立不冲突

3. **Sumus Magnus 与 Ancient Paragons:**
   - Sumus Magnus 有显式兼容检测 (ActionCriteria)，通过 `SumusMagnusRemoveUnimpressives` 等参数控制行为
   - Ancient Paragons 使用 INSERT OR IGNORE 和条件性 UPDATE，避免覆盖已有的修改
   - **结论**: 两者有基本的兼容性设计

4. **Great Sovereigns 重分类 vs 原版陆军统帅:**
   - 拿破仑和古斯塔夫的重分类通过 `SovereignReclassifyGenerals` 参数控制（默认关闭）
   - 当启用时，这两个伟人从陆军统帅类别中移除，加入大统治者类别
   - **结论**: 可控冲突，用户可通过游戏选项开关

### 6.2 重叠定义

| 重叠类型 | GreatPersonIndividual Type | 多个来源 |
|----------|---------------------------|----------|
| 伊姆霍特普 | IMHOTEP | Babylon DLC (MEDIEVAL) → Ancient Paragons (CLASSICAL, 数值修改) |
| 沙贾汗 | SHAH_JAHAN | Babylon DLC → EWHO (SHAH_JAHAN_EWHO, 新类别) |
| 拿破仑 | NAPOLEON_BONAPARTE | 原版 General → Great Sovereigns (重分类) |
| 古斯塔夫 | GUSTAVUS_ADOLPHUS | 原版 General → Great Sovereigns (重分类) |

### 6.3 覆盖关系

| 冲突项 | 先加载 | 后加载 | 胜出 |
|--------|--------|--------|------|
| IMHOTEP 时代 | Babylon DLC (MEDIEVAL) | Ancient Paragons (CLASSICAL) | Ancient Paragons |
| IMHOTEP 产能 | Babylon DLC (350/175) | Ancient Paragons (250/125) | Ancient Paragons |
| 删除工程师 | Delete Some Great Engineer (5人) | Sumus Magnus (2人重叠) | 两者均生效 |
| 重分类拿破仑/古斯塔夫 | 原版 (General) | Great Sovereigns (Sovereign) | 取决于 SovereignReclassifyGenerals 参数 |
| AETHELFLAED 效果 | 原版 (骑士) | EXP1 (需市中心+忠诚度) | EXP1 |
| 艺术类伟人行为 | 原版 (生成著作) | 艺术类伟人偷奇观 Mod (Lua) | 两者共存（Lua添加新功能） |

---

## 附录：源文件索引

| 数据来源 | 源文件路径 |
|----------|-----------|
| 原版海军统帅 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Admirals.xml` |
| 原版陆军统帅 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Generals.xml` |
| 原版大工程师 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Engineers.xml` |
| 原版大商人 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Merchants.xml` |
| 原版大科学家 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Scientists.xml` |
| 原版大先知 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Prophets.xml` |
| 原版大作家 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Writers.xml` |
| 原版大艺术家 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Artists.xml` |
| 原版大音乐家 | `file:///workspace/原版+DLC/原版/Data/GreatPeople_Musicians.xml` |
| Expansion1 海军 | `file:///workspace/原版+DLC/DLC/Expansion1/Data/Expansion1_GreatPeople_Admirals.xml` |
| Expansion1 陆军 | `file:///workspace/原版+DLC/DLC/Expansion1/Data/Expansion1_GreatPeople_Generals.xml` |
| Expansion2 海军 | `file:///workspace/原版+DLC/DLC/Expansion2/Data/Expansion2_GreatPeople_Admirals.xml` |
| Expansion2 陆军 | `file:///workspace/原版+DLC/DLC/Expansion2/Data/Expansion2_GreatPeople_Generals.xml` |
| Babylon 伟人 | `file:///workspace/原版+DLC/DLC/Babylon/Data/Babylon_GreatPeople.xml` |
| GranColombia 伟人 | `file:///workspace/原版+DLC/DLC/GranColombia_Maya/Data/GranColombia_Maya_GreatPeople.xml` |
| Sumus Magnus 删除 | `file:///workspace/MOD/伟人/2448605286 更多伟人/SumusMagnus_RemoveData.xml` |
| Sumus Magnus 配置 | `file:///workspace/MOD/伟人/2448605286 更多伟人/SumusMagnus_Config.xml` |
| Sumus Magnus 能力 | `file:///workspace/MOD/伟人/2448605286 更多伟人/PLATI_Abilities.xml` |
| Sumus Magnus 人物 | `file:///workspace/MOD/伟人/2448605286 更多伟人/Peepoles/` (多个XML文件) |
| Great Sovereigns 核心 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Core.xml` |
| Great Sovereigns 人物 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_People.xml` |
| Great Sovereigns 能力 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Abilities.xml` |
| Great Sovereigns 政策 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Policies_6T_Enabled.xml` |
| Great Sovereigns 阿尔弗雷德 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Alfred_Special.xml` |
| Great Sovereigns 配置 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Config.xml` |
| Great Sovereigns 神谕 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereign_ORACLE.sql` |
| Great Sovereigns 扩展 | `file:///workspace/MOD/伟人/2973448849 大统治者伟人/Expansion/` (多个XML文件) |
| Ancient Paragons 海军 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Admiral.sql` |
| Ancient Paragons 陆军 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_General.sql` |
| Ancient Paragons 工程师 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Engineer.sql` |
| Ancient Paragons 商人 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Merchant.sql` |
| Ancient Paragons 科学家 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Scientist.sql` |
| Ancient Paragons 能力 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Unit_Abilities.sql` |
| Ancient Paragons 作家 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Writer.sql` |
| Ancient Paragons 先知 | `file:///workspace/MOD/伟人/3085812151 远古伟人/Gameplay/6T_AGP_Prophet.sql` |
| Delete Some Great Engineer | `file:///workspace/MOD/伟人/3334907290 删除部分工程师/core.sql` |
| 艺术类伟人偷奇观 Data | `file:///workspace/MOD/艺术类伟人偷奇观，准确传送开拓者，获得地块/Core/GreatWorkCreatorCharges_Data.xml` |
| 艺术类伟人偷奇观 Lua | `file:///workspace/MOD/艺术类伟人偷奇观，准确传送开拓者，获得地块/Lua/GreatPersonTeleport.lua` |
| EWHO 伟人 | `file:///workspace/MOD/游戏模式与玩法大修/2921308654-Enhanced Wonders for Historical Owners-奇观的历史拥有者获得额外加成/Data/EWHO_GreatPeople.xml` |

---

*报告生成日期: 2026-07-07*
*分析方法: 通过 XML/SQL/Lua 代码静态推导，三方法交叉验证*