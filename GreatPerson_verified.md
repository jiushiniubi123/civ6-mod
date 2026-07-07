# Civilization VI 伟人完整文本对照验证报告

> **生成日期**: 2026-07-07
> **分析方法**: 通过 XML/SQL/Lua 代码静态推导，三方法交叉验证；对照可用本地化文本进行名称与效果验证
> **数据来源**: 原版+DLC XML定义 + Mod XML/SQL/Lua + Mod本地化文件

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

### 1.4 本地化文本可用性说明

| 文本来源 | 语言 | 可用性 | 覆盖范围 |
|----------|------|--------|----------|
| 原版游戏本地化文件 | 中文 | **不可用** | 177个原版条目 + 42个DLC条目 |
| Sumus Magnus 英文文本 (`PLATI_Localisation.xml`) | 英文 | 可用 | ~50个Sumus Magnus条目 |
| Sumus Magnus 中文汉化 (`smct.xml`) | 中文 | 可用 | ~50个Sumus Magnus条目 |
| Great Sovereigns 英文文本 (`GreatSovereigns_Localisation.xml`) | 英文 | 可用 | 33个大统治者条目 |
| Great Sovereigns 中文汉化 (`gsct.1.xml`) | 中文 | 可用 | 33个大统治者条目 |
| Ancient Paragons 中文文本 (`6T_AGP_Text_*.sql`) | 中文 | 可用 | 16个远古伟人条目 |
| Ancient Paragons 英文文本 | 英文 | **不可用** | 0个（SQL中仅含中文） |

> ⚠️ **重要**: 工作区中不包含原版游戏和DLC的本地化文件。因此，对于所有原版和DLC条目（177 + 42 = 219个条目），**无法进行文本对照验证**。仅Mod条目（~100个）有可用的本地化文本。

---

## §2 详细数据表

> 格式说明: 中文名, 英文名, 内部ID, 时代, 充能, 退役效果, 被动效果, 文本描述, 文本一致性, 来源, 状态

### 2.1 海军统帅 (Great Admiral)

#### 2.1.1 原版 + DLC 海军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| [ARTEMISIA] | [ARTEMISIA] | ARTEMISIA | CLASSICAL | 1 | 所在格1个海军单位获得1次免费晋升 | 古典/中世纪海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GAIUS_DUILIUS] | [GAIUS_DUILIUS] | GAIUS_DUILIUS | CLASSICAL | 1 | 所在格1个海军单位编为舰队 | 古典/中世纪海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [THEMISTOCLES] | [THEMISTOCLES] | THEMISTOCLES | CLASSICAL | 1 | 获得1艘四桨座战船；EXP1: 忠诚度+2/回合；EXP2: 海军远程单位+20%产能 | 古典/中世纪海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP1/EXP2修改） |
| [HANNO_THE_NAVIGATOR] | [HANNO_THE_NAVIGATOR] | HANNO_THE_NAVIGATOR | CLASSICAL | 1 | 获得1个海军近战单位+2移动力 | 古典/中世纪海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | **已删除（Sumus Magnus）** |
| [LEIF_ERIKSON] | [LEIF_ERIKSON] | LEIF_ERIKSON | MEDIEVAL | 1 | 所有海军单位可进入海洋格；EXP2: 海军视野+2 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [RAJENDRA_CHOLA] | [RAJENDRA_CHOLA] | RAJENDRA_CHOLA | MEDIEVAL | 1 | 获得50金币+海军劫掠加成；EXP2: 海军单位+5战斗力 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [ZHENG_HE] | [ZHENG_HE] | ZHENG_HE | MEDIEVAL | 1 | 获得1个使者；EXP2: 外国商路+2金币+免费商队+商路容量+1 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [HIMERIOS] | [HIMERIOS] | HIMERIOS | MEDIEVAL | 1 | 所在格1个海军单位获得1次免费晋升+经验加成 | 中世纪/文艺复兴海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [FRANCIS_DRAKE] | [FRANCIS_DRAKE] | FRANCIS_DRAKE | RENAISSANCE | 1 | 获得75金币+海军劫掠加成；EXP2: 获得1艘私掠船 | 文艺复兴/工业海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [SANTA_CRUZ] | [SANTA_CRUZ] | SANTA_CRUZ | RENAISSANCE | 1 | 所在格1个海军单位编为军团 | 文艺复兴/工业海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [YI_SUN_SIN] | [YI_SUN_SIN] | YI_SUN_SIN | RENAISSANCE | 1 | 获得1艘铁甲舰；EXP2: 获得1煤/回合 | 文艺复兴/工业海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [FERDINAND_MAGELLAN] | [FERDINAND_MAGELLAN] | FERDINAND_MAGELLAN | RENAISSANCE | 1 | EXP1: 忠诚度+4/回合；EXP2: 获得奢侈品资源+300金币 | 文艺复兴海军光环 | （原版文本文件不在工作区中） | N/A (无文本) | Expansion1 | 活跃 |
| [CHING_SHIH] | [CHING_SHIH] | CHING_SHIH | INDUSTRIAL | 1 | 获得100金币+劫掠加成；EXP2: 获得500金币 | 工业/现代海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [HORATIO_NELSON] | [HORATIO_NELSON] | HORATIO_NELSON | INDUSTRIAL | 1 | 海军侧翼加成；EXP2: 免费灯塔+船坞 | 工业/现代海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [LASKARINA_BOUBOULINA] | [LASKARINA_BOUBOULINA] | LASKARINA_BOUBOULINA | INDUSTRIAL | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 工业/现代海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [FRANZ_VON_HIPPER] | [FRANZ_VON_HIPPER] | FRANZ_VON_HIPPER | MODERN | 1 | 获得1艘战列舰；EXP2: 获得1煤/回合 | 现代/原子海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [JOAQUIM_MARQUES_LISBOA] | [JOAQUIM_MARQUES_LISBOA] | JOAQUIM_MARQUES_LISBOA | MODERN | 1 | 厌战度-25% | 现代/原子海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [TOGO_HEIHACHIRO] | [TOGO_HEIHACHIRO] | TOGO_HEIHACHIRO | MODERN | 1 | 所在格1个海军单位获得1次免费晋升+经验+75%；EXP1: 忠诚度+6/回合 | 现代/原子海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP1修改） |
| [MATTHEW_PERRY] | [MATTHEW_PERRY] | MATTHEW_PERRY | MODERN | 1 | 成为城邦宗主国 | 现代/原子海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [CHESTER_NIMITZ] | [CHESTER_NIMITZ] | CHESTER_NIMITZ | ATOMIC | 1 | 所有城市海军偷袭者+20%产能；EXP2: 获得1艘潜艇+1石油/回合 | 原子/信息海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [GRACE_HOPPER] | [GRACE_HOPPER] | GRACE_HOPPER | ATOMIC | 1 | 获得1个原子-信息时代随机科技突破；EXP2: 获得2个随机科技 | 原子/信息海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [SERGEY_GORSHKOV] | [SERGEY_GORSHKOV] | SERGEY_GORSHKOV | ATOMIC | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 原子/信息海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CLANCY_FERNANDO] | [CLANCY_FERNANDO] | CLANCY_FERNANDO | INFORMATION | 1 | 所在格1个海军单位获得1次免费晋升+额外经验加成 | 信息海军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |

#### 2.1.2 Sumus Magnus 新增海军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| 拉格纳·洛德布罗克 | Ragnar Lodbrok | PLATI_LODBROK | MEDIEVAL | 1 | 掠夺改良设施的收益翻倍 | 中世纪/文艺复兴海军光环（可俘获敌方船只） | 掠夺改良设施的收益翻倍 | ✓ | Sumus Magnus | 活跃 |
| 巴巴罗萨·海雷丁 | Barbarossa Hayreddin | PLATI_BARBAROSSA | RENAISSANCE | 1 | 可训练巴巴里海盗（需要"中世纪集市"市政） | 文艺复兴/工业海军光环 | 可训练巴巴里海盗（需要"中世纪集市"市政） | ✓ | Sumus Magnus | 活跃 |
| 阿方索·德·阿尔布克尔克 | Afonso de Albuquerque | PLATI_COOK | RENAISSANCE | 1 | 该城市获得一份肉豆蔻，黄金时代获得两份 | 文艺复兴/工业海军光环 | 该城市获得一份肉豆蔻，黄金时代获得两份 | ✓ | Sumus Magnus | 活跃 |
| 艾哈迈德·本·马吉德 | Ahmad bin Majid | PLATI_MAJID | RENAISSANCE | 1 | 所有海军单位+2移动力 | 文艺复兴/工业海军光环 | 所有海军单位+2移动力 | ✓ | Sumus Magnus | 活跃 |
| 亨利·摩根 | Henry Morgan | PLATI_MORGAN | RENAISSANCE | 1 | 获得1总督点 | 文艺复兴/工业海军光环 | 获得1总督点 | ✓ | Sumus Magnus | 活跃 |
| 安德烈亚·多里亚 | Andrea Doria | PLATI_NIELS_JUEL | RENAISSANCE | 1 | 用海军单位征服城市后，该城市自动信仰主流宗教 | 文艺复兴/工业海军光环 | 用海军单位征服城市后，该城市自动信仰主流宗教 | ✓ | Sumus Magnus | 活跃 |
| 维图斯·约纳森·白令 | Vitus Jonassen Bering | PLATI_VITUS | RENAISSANCE | 1 | 每个冻土单元格为港口+1金币相邻加成，每个雪地单元格+3文化值相邻加成 | 文艺复兴/工业海军光环 | 每个冻土为港口+1金币相邻加成，每个雪地为港口+3文化值相邻加成 | ✓ | Sumus Magnus | 活跃 |
| 阿格里帕 | Agrippa | PLATI_AGRIPPA | CLASSICAL | 1 | 建造奇观时提供245生产力 | 古典/中世纪海军光环 | 建造奇观时提供245生产力 | ✓ | Sumus Magnus | 活跃 |
| 米希尔·德·鲁伊特 | Michiel de Ruyter | PLATI_HENRY | RENAISSANCE | 1 | 该城市每回合+1攻击次数 | 文艺复兴/工业海军光环 | 该城市每回合+1攻击次数 | ✓ | Sumus Magnus | 活跃 |

#### 2.1.3 Ancient Paragons 新增海军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| 赫努 | [无英文文本] | JNR_HENENU | ANCIENT | 1 | 获得少量金币+海上贸易路线范围+10 | 远古海军+5战斗力+1移动力光环 | 永久提升海上商路33%行动范围 | ✓ | Ancient Paragons | 活跃 |
| 奈·曼加尼布卡 | [无英文文本] | JNR_NEI_MANGANIBUKA | ANCIENT | 1 | 获得1个海军近战单位（可进入海洋格） | 远古海军+5战斗力+1移动力光环 | 创建一个无视科技限制即可进入海洋单元格的海军近战单位 | ✓ | Ancient Paragons | 活跃 |

### 2.2 陆军统帅 (Great General)

#### 2.2.1 原版 + DLC 陆军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| [BOUDICA] | [BOUDICA] | BOUDICA | CLASSICAL | 1 | 转化相邻蛮族单位为己方 | 古典/中世纪陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HANNIBAL_BARCA] | [HANNIBAL_BARCA] | HANNIBAL_BARCA | CLASSICAL | 1 | 所在格1个陆军单位获得1次免费晋升 | 古典/中世纪陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SUN_TZU] | [SUN_TZU] | SUN_TZU | CLASSICAL | 0 | 无退役能力 | 古典/中世纪陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [TRUNG_TRAC] | [TRUNG_TRAC] | TRUNG_TRAC | CLASSICAL | 1 | 厌战度-25% | 古典/中世纪陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [AETHELFLAED] | [AETHELFLAED] | AETHELFLAED | MEDIEVAL | 1 | 获得1个骑士；EXP1: 需市中心，忠诚度+2/回合 | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [EL_CID] | [EL_CID] | EL_CID | MEDIEVAL | 1 | 所在格1个陆军单位编为舰队 | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GENGHIS_KHAN] | [GENGHIS_KHAN] | GENGHIS_KHAN | MEDIEVAL | 1 | 所在格1个陆军单位获得1次免费晋升+经验+25% | 中世纪/文艺复兴陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [TIMUR] | [TIMUR] | TIMUR | MEDIEVAL | 1 | 所在格1个陆军单位免费晋升+能力加成 | 中世纪陆军光环 | （原版文本文件不在工作区中） | N/A (无文本) | Expansion1 | 活跃 |
| [GUSTAVUS_ADOLPHUS] | [GUSTAVUS_ADOLPHUS] | GUSTAVUS_ADOLPHUS | RENAISSANCE | 1 | 获得1个射石炮 | 文艺复兴/工业陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **重分类为大统治者** |
| [JOAN_OF_ARC] | [JOAN_OF_ARC] | JOAN_OF_ARC | RENAISSANCE | 1 | 获得1个圣物 | 文艺复兴/工业陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ANA_NZINGA] | [ANA_NZINGA] | ANA_NZINGA | RENAISSANCE | 1 | 获得1个使者 | 文艺复兴/工业陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [NAPOLEON_BONAPARTE] | [NAPOLEON_BONAPARTE] | NAPOLEON_BONAPARTE | INDUSTRIAL | 1 | 所在格1个陆军单位编为军团 | 工业/现代陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **重分类为大统治者** |
| [RANI_LAKSHMIBAI] | [RANI_LAKSHMIBAI] | RANI_LAKSHMIBAI | INDUSTRIAL | 1 | 获得1个骑兵 | 工业/现代陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [SIMON_BOLIVAR] | [SIMON_BOLIVAR] | SIMON_BOLIVAR | INDUSTRIAL | 1 | 获得2个使者；EXP1: 忠诚度+4/回合 | 工业/现代陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP1修改） |
| [DANDARA] | [DANDARA] | DANDARA | INDUSTRIAL | 2 | 获得1个武僧 | 工业/现代陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | **已删除（Sumus Magnus）** |
| [JOHN_MONASH] | [JOHN_MONASH] | JOHN_MONASH | MODERN | 1 | 所在格1个陆军单位获得1次免费晋升+额外经验加成 | 现代/原子陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [MARINA_RASKOVA] | [MARINA_RASKOVA] | MARINA_RASKOVA | MODERN | 1 | 所在区域获得1个空军槽位 | 现代/原子陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SAMORI_TURE] | [SAMORI_TURE] | SAMORI_TURE | MODERN | 1 | 获得1个步兵；EXP1: 获得1个特种部队 | 现代/原子陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [TUPAC_AMARU] | [TUPAC_AMARU] | TUPAC_AMARU | MODERN | 1 | 在区域获得1个火枪手 | 现代/原子陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [DWIGHT_EISENHOWER] | [DWIGHT_EISENHOWER] | DWIGHT_EISENHOWER | ATOMIC | 1 | 所有城市军事单位+5%产能 | 原子/信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GEORGY_ZHUKOV] | [GEORGY_ZHUKOV] | GEORGY_ZHUKOV | ATOMIC | 1 | 陆军侧翼加成 | 原子/信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [DOUGLAS_MACARTHUR] | [DOUGLAS_MACARTHUR] | DOUGLAS_MACARTHUR | ATOMIC | 1 | 获得1个坦克；EXP2: 获得1石油/回合 | 原子/信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [SUDIRMAN] | [SUDIRMAN] | SUDIRMAN | ATOMIC | 1 | 所在格1个陆军单位获得1次免费晋升+经验+100%；EXP1: 忠诚度+6/回合 | 原子/信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | Expansion1 | 活跃 |
| [AHMAD_SHAH_MASSOUD] | [AHMAD_SHAH_MASSOUD] | AHMAD_SHAH_MASSOUD | INFORMATION | 1 | 获得1个现代反坦克 | 信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [VIJAYA_WIMALARATNE] | [VIJAYA_WIMALARATNE] | VIJAYA_WIMALARATNE | INFORMATION | 1 | 所在格1个陆军单位获得1次免费晋升+额外经验加成 | 信息陆军+5战斗力+1移动力光环 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |

#### 2.2.2 Sumus Magnus 新增陆军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| 卡尔·古斯塔夫·埃米尔·曼纳海姆 | Carl Gustaf Emil Mannerheim | PLATI_SARGON | CLASSICAL | 1 | 所有陆地单位防守时+4战斗力 | 古典/中世纪陆军光环（击败敌方单位有几率将其俘获） | 所有陆地单位防守时+4战斗力 | ✓ | Sumus Magnus | 活跃 |
| 卡尔十二世 | Carolus Rex | PLATI_REX | CLASSICAL | 1 | 可训练卡洛琳步兵（需要"金属铸造"科技） | 古典/中世纪陆军光环（每点未使用移动力+3战斗力） | 可训练卡洛琳步兵（需要"金属铸造"科技） | ✓ | Sumus Magnus | 活跃 |
| 拜伯尔斯 | Baibars | PLATI_BAIBARS | MEDIEVAL | 1 | 受伤时战斗力减益-20% | 中世纪/文艺复兴陆军光环（回合结束后恢复生命值） | 受伤时战斗力减益-20% | ✓ | Sumus Magnus | 活跃 |
| 于格·德·帕扬 | Hugues de Payens | PLATI_BAYINNAUNG | MEDIEVAL | 1 | 解锁并建造圣殿金库（金币产出等同信仰值10%） | 中世纪/文艺复兴陆军光环（击杀敌方单位获得信仰值） | 解锁并建造圣殿金库 | ✓ | Sumus Magnus | 活跃 |
| 扬·杰式卡 | Jan Žižka | PLATI_JAN_ZIZKA | MEDIEVAL | 1 | 与基础战斗力更高的单位作战时+4战斗力 | 中世纪/文艺复兴陆军光环（非远程单位防御远程攻击时+10战斗力） | 与基础战斗力更高的单位作战时+4战斗力 | ✓ | Sumus Magnus | 活跃 |
| 留里克大公 | Rurik | PLATI_RURIK | MEDIEVAL | 1 | 获得一个开拓者和狂暴武士 | 中世纪/文艺复兴陆军光环（获得经验+80%） | 获得一个开拓者和狂暴武士 | ✓ | Sumus Magnus | 活跃 |
| 哈立德·本·瓦利德 | Khalid ibn al-Walid | PLATI_SUNDIATA | MEDIEVAL | 1 | 获得200信仰值 | 中世纪/文艺复兴陆军光环（与异教文明单位交战+7战斗力） | 获得200信仰值 | ✓ | Sumus Magnus | 活跃 |
| 加查·马达 | Gajah Mada | PLATI_GAJAH | MEDIEVAL | 1 | 获得胡椒/肉豆蔻奢侈品 | 中世纪/文艺复兴陆军光环（登船+10战斗力，上下船不消耗移动力） | 获得胡椒/肉豆蔻；如果城市为征服所得额外获得肉豆蔻 | ✓ | Sumus Magnus | 活跃 |
| 卡泰丽娜·斯福尔扎 | Caterina Sforza | PLATI_SFORZA | RENAISSANCE | 1 | 获得300文化值 | 文艺复兴/工业陆军光环 | 获得300文化值 | ✓ | Sumus Magnus | 活跃 |
| 埃尔南·科尔特斯 | Hernán Cortés | PLATI_SUAREZ | RENAISSANCE | 1 | 创建一个拥有一次升级的征服者单位 | 文艺复兴/工业陆军光环（击败敌方单位有几率将其俘获） | 创建一个拥有一次升级的征服者单位 | ✓ | Sumus Magnus | 活跃 |
| 斯坦尼斯瓦夫·若乌凯夫斯基 | Stanisław Żółkiewski | PLATI_LIONHEART | RENAISSANCE | 1 | 可训练翼骑兵（需要"重商主义"市政） | 文艺复兴/工业陆军光环（攻击骑兵+7战斗力） | 可训练翼骑兵（需要"重商主义"市政） | ✓ | Sumus Magnus | 活跃 |
| 朱塞佩·加里波第 | Giuseppe Garibaldi | PLATI_GARIBALDI | INDUSTRIAL | 1 | 近战单位在首都所在大陆上战斗时+3战斗力 | 工业/现代陆军光环 | 近战单位在首都所在大陆上战斗时+3战斗力 | ✓ | Sumus Magnus | 活跃 |
| 阿拉伯的劳伦斯 | Lawrence of Arabia | PLATI_LAWRENCE | MODERN | 1 | 解放城市后10回合内所有城市+20%文化值 | 现代/原子陆军光环 | 解放城市后10回合内所有城市+20%文化值 | ✓ | Sumus Magnus | 活跃 |
| 威廉·米切尔 | William Mitchell | PLATI_TOKUGAWA | MODERN | 1 | 机场及其建筑建成时获得战斗机单位，攻击区域防御无远程攻击力惩罚 | 现代/原子陆军光环（攻击区域防御时+17远程攻击力） | 机场及其建筑建成时获得战斗机单位 | ✓ | Sumus Magnus | 活跃 |
| 罗曼·冯·恩琴 | Roman von Ungern-Sternberg | PLATI_UNGERN | MODERN | 1 | 创建五个怯薛 | 现代/原子陆军光环 | 创建五个怯薛 | ✓ | Sumus Magnus | 活跃 |

#### 2.2.3 Ancient Paragons 新增陆军统帅

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| 妇好 | [无英文文本] | JNR_FU_HAO | ANCIENT | 1 | 获得1个重骑兵单位（带伪装能力） | 远古陆军+5战斗力+1移动力光环 | 创建仅可通过相邻敌方单位显形的重骑兵单位 | ✓ | Ancient Paragons | 活跃 |
| 西亚赫·卡阿克 | [无英文文本] | JNR_SIYAJ_K_AK | ANCIENT | 1 | 获得1个使者（EXP1时改为阿瑟尔弗莱德效果） | 远古陆军+5战斗力+1移动力光环 | （无单独退役效果文本，使用通用使者文本） | N/A | Ancient Paragons | 活跃 |

### 2.3 大工程师 (Great Engineer)

#### 2.3.1 原版 + DLC 大工程师

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| [IMHOTEP] | [IMHOTEP] | IMHOTEP | CLASSICAL (原MEDIEVAL) | 2 | 向奇观+250/125产能（每次） | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC → Ancient Paragons修改 | 活跃（时代和数值被AP修改） |
| [BI_SHENG] | [BI_SHENG] | BI_SHENG | MEDIEVAL | 1 | 所在城市+1区域容量+获得印刷术科技突破 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Delete Some Great Engineer）** |
| [ISIDORE_OF_MILETUS] | [ISIDORE_OF_MILETUS] | ISIDORE_OF_MILETUS | MEDIEVAL | 2 | 向奇观+215产能（每次，不溢出） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Delete Some Great Engineer）** |
| [JAMES_OF_ST_GEORGE] | [JAMES_OF_ST_GEORGE] | JAMES_OF_ST_GEORGE | MEDIEVAL | 3 | 免费获得城墙+城堡（3次） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus + Delete Some Great Engineer）** |
| [FILIPPO_BRUNELLESCHI] | [FILIPPO_BRUNELLESCHI] | FILIPPO_BRUNELLESCHI | RENAISSANCE | 2 | 向奇观+315产能（每次，不溢出） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LEONARDO_DA_VINCI] | [LEONARDO_DA_VINCI] | LEONARDO_DA_VINCI | RENAISSANCE | 1 | 所有工坊+3文化+所有工厂+3文化+获得1个现代随机科技突破 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MIMAR_SINAN] | [MIMAR_SINAN] | MIMAR_SINAN | RENAISSANCE | 2→1 | 所在城市+1住房+1宜居度；EXP1: 充能改为1，触发工业区文化炸弹 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP1修改） |
| [ADA_LOVELACE] | [ADA_LOVELACE] | ADA_LOVELACE | INDUSTRIAL | 1 | 所在城市+1区域容量+获得计算机科技突破 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GUSTAVE_EIFFEL] | [GUSTAVE_EIFFEL] | GUSTAVE_EIFFEL | INDUSTRIAL | 2 | 向奇观+480产能（每次，不溢出） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JAMES_WATT] | [JAMES_WATT] | JAMES_WATT | INDUSTRIAL | 1 | 免费获得工坊+工厂+所有工厂+2产能 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ALVAR_AALTO] | [ALVAR_AALTO] | ALVAR_AALTO | MODERN | 1 | 所在城市+1魅力 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Delete Some Great Engineer）** |
| [NIKOLA_TESLA] | [NIKOLA_TESLA] | NIKOLA_TESLA | MODERN | 1 | 区域建筑范围+3+区域建筑+2产能 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ROBERT_GODDARD] | [ROBERT_GODDARD] | ROBERT_GODDARD | MODERN | 1 | 航天项目+20%产能+获得火箭技术科技突破 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SHAH_JAHAN] | [SHAH_JAHAN] | SHAH_JAHAN | MODERN | 1 | 购买奇观产能（用金币） | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [JOHN_A_ROEBLING] | [JOHN_A_ROEBLING] | JOHN_A_ROEBLING | ATOMIC | 2 | 所在城市+2住房+1宜居度（每次） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus + Delete Some Great Engineer）** |
| [JANE_DREW] | [JANE_DREW] | JANE_DREW | ATOMIC | 1 | 所在城市+4住房+3宜居度 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [SERGEI_KOROLEV] | [SERGEI_KOROLEV] | SERGEI_KOROLEV | ATOMIC | 1 | 向航天项目+1500产能（不溢出） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CHARLES_CORREA] | [CHARLES_CORREA] | CHARLES_CORREA | INFORMATION | 1 | 所在城市+2魅力 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [JOSEPH_PAXTON] | [JOSEPH_PAXTON] | JOSEPH_PAXTON | INFORMATION | 1 | 区域建筑范围+3+区域建筑+1宜居度 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [WERNHER_VON_BRAUN] | [WERNHER_VON_BRAUN] | WERNHER_VON_BRAUN | INFORMATION | 1 | 航天项目+100%产能 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [KENZO_TANGE] | [KENZO_TANGE] | KENZO_TANGE | INFORMATION | 1 | 5种区域相邻产出转为旅游业绩 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |

#### 2.3.2 Sumus Magnus 新增大工程师

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 大马士革的阿波罗多洛斯 | Apollodorus of Damascus | PLATI_APOLLODRO | CLASSICAL/MEDIEVAL | 1 | 该城市每个区域+1生产力+1文化值 | 该城市每个区域+1生产力+1文化值 | ✓ | Sumus Magnus | 活跃 |
| 菲迪亚斯 | Phidias | PLATI_ALI_MASHADDI | CLASSICAL/MEDIEVAL | 1 | 该城市所有古典时代奇观获得一个巨作槽位 | 该城市所有古典时代奇观获得一个巨作槽位 | ✓ | Sumus Magnus | 活跃 |
| 维特鲁威 | Vitruvius | PLATI_ZEPPELIN | CLASSICAL/MEDIEVAL | 1 | 触发"工程"和"军事工程学"尤里卡 | 触发"工程"和"军事工程学"尤里卡 | ✓ | Sumus Magnus | 活跃 |
| 格拉纳达的穆罕默德五世 | Muhammad V of Granada | PLATI_AL_AHRAMI | MEDIEVAL | 1 | 宫殿+3巨作槽位，每个宗教艺术巨作+4信仰值 | 宫殿+3巨作槽位，每个宗教艺术巨作+4信仰值 | ✓ | Sumus Magnus | 活跃 |
| 乌尔班 | Urban | PLATI_URBAN | MEDIEVAL | 1 | 创建两个拥有一次升级的射石炮单位 | 创建两个拥有一次升级的射石炮单位 | ✓ | Sumus Magnus | 活跃 |
| 菲利贝尔·德洛姆 | Philibert de l'Orme | PLATI_CHATEAU | RENAISSANCE | 1 | 工业区提供等同于生产力相邻加成的文化值，允许建造城堡改良设施 | 工业区提供等同于生产力相邻加成的文化值，允许建造城堡改良设施 | ✓ | Sumus Magnus | 活跃 |
| 克里斯托佛·克拉乌 | Christopher Clavius | PLATI_MISSION | RENAISSANCE | 1 | 获得当前信仰值产出50%的科技值，允许建造传教团改良设施 | 获得当前信仰值产出50%的科技值，允许建造传教团改良设施 | ✓ | Sumus Magnus | 活跃 |
| 扬·莱赫瓦特 | Jan Leeghwater | PLATI_POLDER | RENAISSANCE | 1 | 该城市免疫自然灾害，允许建造者修建圩田改良设施 | 该城市免疫自然灾害，允许建造圩田改良设施 | ✓ | Sumus Magnus | 活跃 |
| 阿尔贝托·桑托斯·杜蒙 | Alberto Santos-Dumont | PLATI_WILBRAHAM | RENAISSANCE | 1 | 航空港每与一个区域相邻+2生产力+2文化值 | 航空港每与一个区域相邻+2生产力+2文化值 | ✓ | Sumus Magnus | 活跃 |
| 塞巴斯蒂安·勒普雷斯特雷·德·沃邦 | Sébastien Le Prestre de Vauban | PLATI_DAHLBERG | RENAISSANCE | 1 | 获得一个军事工程师，每个堡垒为工业区+1相邻加成 | 获得一个军事工程师，每个堡垒为工业区+1相邻加成 | ✓ | Sumus Magnus | 活跃 |
| 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | PLATI_CURIE | RENAISSANCE | 1 | 该城市的展阁、公馆和市政广场内建筑+4文化值 | 该城市的展阁、公馆和市政广场内建筑+4文化值 | ✓ | Sumus Magnus | 活跃 |
| 伊桑巴德·金德姆·布鲁内尔 | Isambard Kingdom Brunel | PLATI_ISAMBARD | INDUSTRIAL | 1 | 该城市每建造一种专业化区域+1%生产力 | 该城市每建造一种专业化区域+1%生产力 | ✓ | Sumus Magnus | 活跃 |
| 阿尔弗雷德·克虏伯 | Alfred Krupp | PLATI_KRUPP | INDUSTRIAL | 1 | 建造攻城单位+25%生产力 | 建造攻城单位+25%生产力 | ✓ | Sumus Magnus | 活跃 |

#### 2.3.3 Ancient Paragons 新增大工程师

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 玛利亚·希伯来亚 | [无英文文本] | JNR_MARIA_HEBRAEA | CLASSICAL | 1 | 所有项目+20%产能 | 区域项目获得+20%生产力 | ✓ | Ancient Paragons | 活跃 |

#### 2.3.4 EWHO 新增大工程师

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| [SHAH_JAHAN_EWHO] | [SHAH_JAHAN_EWHO] | SHAH_JAHAN_EWHO | RENAISSANCE | 3 | 用金币购买奇观产能 | （原版文本文件不在工作区中） | N/A (无文本) | EWHO | 活跃 |

### 2.4 大商人 (Great Merchant)

#### 2.4.1 原版 + DLC 大商人

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| [COLAEUS] | [COLAEUS] | COLAEUS | CLASSICAL | 1 | 获得所在格奢侈品资源+100信仰 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARCUS_LICINIUS_CRASSUS] | [MARCUS_LICINIUS_CRASSUS] | MARCUS_LICINIUS_CRASSUS | CLASSICAL | 3 | 获得地块（3次）+60金币 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ZHANG_QIAN] | [ZHANG_QIAN] | ZHANG_QIAN | CLASSICAL | 1 | 该城市外国商路+2金币+商路容量+1 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARCO_POLO] | [MARCO_POLO] | MARCO_POLO | MEDIEVAL | 1 | +1商路容量+外国商路+2金币+免费商队 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [PIERO_DE_BARDI] | [PIERO_DE_BARDI] | PIERO_DE_BARDI | MEDIEVAL | 1 | 200金币+1个使者 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [IRENE_OF_ATHENS] | [IRENE_OF_ATHENS] | IRENE_OF_ATHENS | MEDIEVAL | 1 | 获得所在格奢侈品资源+商路容量+1；EXP1: 总督点数+1 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [IBN_FADLAN] | [IBN_FADLAN] | IBN_FADLAN | MEDIEVAL | 1 | 商路容量+1+城邦商路+2信仰 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [GIOVANNI_DE_MEDICI] | [GIOVANNI_DE_MEDICI] | GIOVANNI_DE_MEDICI | RENAISSANCE | 1 | 免费获得市场+银行+银行+2宫殿巨作槽 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JAKOB_FUGGER] | [JAKOB_FUGGER] | JAKOB_FUGGER | RENAISSANCE | 1 | 200金币+2个使者 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [RAJA_TODAR_MAL] | [RAJA_TODAR_MAL] | RAJA_TODAR_MAL | RENAISSANCE | 1 | 1个使者+国内商路每个专业区域+0.5金币 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ZHOU_DAGUAN] | [ZHOU_DAGUAN] | ZHOU_DAGUAN | RENAISSANCE | 1 | 获得3个使者 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [ADAM_SMITH] | [ADAM_SMITH] | ADAM_SMITH | INDUSTRIAL | 1 | 获得1个经济政策槽位；EXP1: 总督点数+1+500金币 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [JOHN_SPILSBURY] | [JOHN_SPILSBURY] | JOHN_SPILSBURY | INDUSTRIAL | 1 | 获得1个玩具资源 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JOHN_JACOB_ASTOR] | [JOHN_JACOB_ASTOR] | JOHN_JACOB_ASTOR | INDUSTRIAL | 1 | 500金币+2个使者 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | **已删除（Sumus Magnus）** |
| [MARY_KATHERINE_GODDARD] | [MARY_KATHERINE_GODDARD] | MARY_KATHERINE_GODDARD | MODERN | 1 | 外交能见度+1 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JOHN_ROCKEFELLER] | [JOHN_ROCKEFELLER] | JOHN_ROCKEFELLER | MODERN | 1 | 获得1石油+商路战略资源金币加成；EXP2: 获得3石油/回合 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃（EXP2修改） |
| [SARAH_BREEDLOVE] | [SARAH_BREEDLOVE] | SARAH_BREEDLOVE | MODERN | 1 | 商路旅游业绩+25% | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [STAMFORD_RAFFLES] | [STAMFORD_RAFFLES] | STAMFORD_RAFFLES | MODERN | 1 | 未指定效果 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [HELENA_RUBINSTEIN] | [HELENA_RUBINSTEIN] | HELENA_RUBINSTEIN | ATOMIC | 1 | 获得2个化妆品资源 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MELITTA_BENTZ] | [MELITTA_BENTZ] | MELITTA_BENTZ | ATOMIC | 1 | 商路旅游业绩+25%+商路容量+1 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LEVI_STRAUSS] | [LEVI_STRAUSS] | LEVI_STRAUSS | ATOMIC | 1 | 获得2个牛仔裤资源 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ESTEE_LAUDER] | [ESTEE_LAUDER] | ESTEE_LAUDER | INFORMATION | 1 | 获得2个香水资源 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MASARU_IBUKA] | [MASARU_IBUKA] | MASARU_IBUKA | INFORMATION | 1 | 工业区+10旅游业绩 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JAMSETJI_TATA] | [JAMSETJI_TATA] | JAMSETJI_TATA | INFORMATION | 1 | 学院+10旅游业绩 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |

#### 2.4.2 Sumus Magnus 新增大商人

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 克罗索斯 | Croesus | PLATI_CROESUS | CLASSICAL | 1 | 国库金币翻倍（+100%） | 当前国库金币翻倍 | ✓ | Sumus Magnus | 活跃 |
| 伊本·白图泰 | Ibn Battuta | PLATI_IBN_BATTUTA | MEDIEVAL | 1 | 商路每经过4个单元格提供+1信仰值 | 商路每经过4个单元格提供+1信仰值 | ✓ | Sumus Magnus | 活跃 |
| 阿发纳西·尼基丁 | Afanasy Nikitin | PLATI_AFANASIY | RENAISSANCE | 1 | 首都获得该地块奢侈品资源（或国外激活时每区域+100金币） | 首都获得该地块奢侈品资源 | ✓ | Sumus Magnus | 活跃 |
| 马拉莫科的波诺 | Bono of Malamocco | PLATI_VENETIAN | RENAISSANCE | 1 | 获得1个遗物+1商路容量（必须在国外港口激活） | 获得1个遗物+1商路容量。必须在国外的港口单元格上激活 | ✓ | Sumus Magnus | 活跃 |
| 涩泽荣一 | Shibusawa Eiichi | PLATI_COLBERT | RENAISSANCE | 1 | 本城市每种用于发电的资源为改良的奢侈品资源+1宜居度 | 本城市每种用于发电的资源为改良的奢侈品资源+1宜居度 | ✓ | Sumus Magnus | 活跃 |
| 雅各布·凯特勒 | Jacob Kettler | PLATI_JACOBKETTLER | RENAISSANCE | 2 | 该港口提供等同于其相邻加成的生产力 | 该港口提供等同于其相邻加成的生产力 | ✓ | Sumus Magnus | 活跃 |
| 塞西尔·罗兹 | Cecil Rhodes | PLATI_CECIL | RENAISSANCE | 1 | 创建一个红衫军，有总督的异大陆城市+20%金币 | 创建一个红衫军，有总督的异大陆城市+20%金币 | ✓ | Sumus Magnus | 活跃 |
| 亚历山大·汉密尔顿 | Alexander Hamilton | PLATI_HAMILTON | INDUSTRIAL | 1 | 所有政体经济政策槽位+1 | 所有政体经济政策槽位+1 | ✓ | Sumus Magnus | 活跃 |
| 吉恩·诺伊豪斯二世 | Jean Neuhaus II | PLATI_NESTLE | INDUSTRIAL | 1 | 解锁巧克力工厂特色建筑 | 解锁特色建筑巧克力工厂 | ✓ | Sumus Magnus | 活跃 |
| 彼得·卡尔·法贝热 | Peter Carl Faberge | PLATI_FABERGE | INDUSTRIAL | 1 | 获得两份法贝热彩蛋（+5宜居度） | 获得两份法贝热彩蛋，提供+5宜居度 | ✓ | Sumus Magnus | 活跃 |
| 约翰·皮尔庞特·摩根 | J.P. Morgan | PLATI_BANKER | MODERN | 1 | 每个银行+1外交点数 | 每个银行+1外交点数 | ✓ | Sumus Magnus | 活跃 |

#### 2.4.3 Ancient Paragons 新增大商人

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 阿玛·埃 | [无英文文本] | JNR_AMA_E | ANCIENT | 1 | 商路容量+1+国内商路+1食物+1产能 | 通往此城的国内贸易路线提供+1食物与+1生产力 | ✓ | Ancient Paragons | 活跃 |
| 希兰 | [无英文文本] | JNR_HIRAM | ANCIENT | 1 | 获得1个骨螺紫（MUREX）奢侈品资源 | 授予泰尔紫（独特奢侈品，提供+4宜居度） | ✓ | Ancient Paragons | 活跃 |

### 2.5 大科学家 (Great Scientist)

#### 2.5.1 原版 + DLC 大科学家

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|----------|:--------:|------|------|
| [ARYABHATA] | [ARYABHATA] | ARYABHATA | CLASSICAL | 1 | 获得3个古典-中世纪随机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EUCLID] | [EUCLID] | EUCLID | CLASSICAL | 1 | 获得1个中世纪随机科技突破+数学科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HYPATIA] | [HYPATIA] | HYPATIA | CLASSICAL | 1 | 免费获得图书馆+所有图书馆+1科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ZHANG_HENG] | [ZHANG_HENG] | ZHANG_HENG | CLASSICAL | 1 | 数学/天文导航/工程学科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [ABU_AL_QASIM_AL_ZAHRAWI] | [ABU_AL_QASIM_AL_ZAHRAWI] | ABU_AL_QASIM_AL_ZAHRAWI | MEDIEVAL | 1 | 获得1个中世纪-文艺复兴随机科技突破+所有单位回血+5 | 所有单位+5回血/回合 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HILDEGARD_OF_BINGEN] | [HILDEGARD_OF_BINGEN] | HILDEGARD_OF_BINGEN | MEDIEVAL | 1 | 圣地信仰相邻加成转为科学+100信仰 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [OMAR_KHAYYAM] | [OMAR_KHAYYAM] | OMAR_KHAYYAM | MEDIEVAL | 1 | 获得2个中世纪-文艺复兴随机科技突破+1个随机市政鼓舞 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GALILEO_GALILEI] | [GALILEO_GALILEI] | GALILEO_GALILEI | RENAISSANCE | 1 | 相邻每个山脉格+250科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ISAAC_NEWTON] | [ISAAC_NEWTON] | ISAAC_NEWTON | RENAISSANCE | 1 | 免费获得图书馆+大学+所有大学+2科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EMILIE_DU_CHATELET] | [EMILIE_DU_CHATELET] | EMILIE_DU_CHATELET | RENAISSANCE | 1 | 获得3个文艺复兴-工业随机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [IBN_KHALDUN] | [IBN_KHALDUN] | IBN_KHALDUN | RENAISSANCE | 1 | 学院+2住房+1宜居度，幸福/狂喜时产出加成 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [JAMES_YOUNG] | [JAMES_YOUNG] | JAMES_YOUNG | INDUSTRIAL | 1 | 揭示石油+获得2个工业-现代随机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CHARLES_DARWIN] | [CHARLES_DARWIN] | CHARLES_DARWIN | INDUSTRIAL | 1 | 相邻每个自然奇观格+500科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [DMITRI_MENDELEEV] | [DMITRI_MENDELEEV] | DMITRI_MENDELEEV | INDUSTRIAL | 1 | 获得1个工业随机科技突破+化学科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ALAN_TURING] | [ALAN_TURING] | ALAN_TURING | MODERN | 1 | 获得1个现代随机科技突破+计算机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ALBERT_EINSTEIN] | [ALBERT_EINSTEIN] | ALBERT_EINSTEIN | MODERN | 1 | 所有研究实验室+4科学+获得1个现代-原子随机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ALFRED_NOBEL] | [ALFRED_NOBEL] | ALFRED_NOBEL | MODERN | 1 | 获得1个现代-原子随机科技突破+100免费伟人点数 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JANAKI_AMMAL] | [JANAKI_AMMAL] | JANAKI_AMMAL | ATOMIC | 1 | 相邻每个雨林格+400科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARY_LEAKEY] | [MARY_LEAKEY] | MARY_LEAKEY | ATOMIC | 1 | 文物旅游业绩x3+该城市每个文物+350科学 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ERWIN_SCHRODINGER] | [ERWIN_SCHRODINGER] | ERWIN_SCHRODINGER | ATOMIC | 1 | 获得3个原子-信息随机科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARGARET_MEAD] | [MARGARET_MEAD] | MARGARET_MEAD | ATOMIC | 1 | 1000科学+1000文化 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [ABDUS_SALAM] | [ABDUS_SALAM] | ABDUS_SALAM | INFORMATION | 1 | 获得所有信息时代科技突破 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CARL_SAGAN] | [CARL_SAGAN] | CARL_SAGAN | INFORMATION | 1 | 向航天项目+3000产能（不溢出） | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [STEPHANIE_KWOLEK] | [STEPHANIE_KWOLEK] | STEPHANIE_KWOLEK | INFORMATION | 1 | 航天项目+100%产能 | 无 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |

#### 2.5.2 Sumus Magnus 新增大科学家

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 胡果·格劳秀斯 | Hugo Grotius | PLATI_LEIZU | CLASSICAL | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | Sumus Magnus | 活跃 |
| 蔡伦 | Cai Lun | PLATI_CAI_LUN | CLASSICAL | 1 | 解锁并建造造纸坊特色建筑 | 解锁并建造特色建筑造纸坊 | ✓ | Sumus Magnus | 活跃 |
| 亚里士多德 | Aristotle | PLATI_ARISTOTLE | CLASSICAL | 1 | 所有政体通用政策槽位+1 | 所有政体通用政策槽位+1 | ✓ | Sumus Magnus | 活跃 |
| 伊本·路世德 | Ibn Rushd (Averroes) | PLATI_AVERROES | MEDIEVAL | 1 | 黄金时代时每本著作+1科学+2信仰 | 处于黄金时代时每本著作+1科学+2信仰 | ✓ | Sumus Magnus | 活跃 |
| 伊本·西那 | Ibn Sina (Avicenna) | PLATI_SAUGUSTINE | MEDIEVAL | 1 | 随机中世纪科技尤里卡+宗教单位+3宗教战斗力 | 随机中世纪科技尤里卡。宗教单位神学战斗时+3宗教战斗力 | ✓ | Sumus Magnus | 活跃 |
| 沈括 | Shen Kuo | PLATI_SHEN_KUO | MEDIEVAL | 1 | 该学院提供等同于其相邻加成的生产力 | 该学院提供等同于其相邻加成的生产力 | ✓ | Sumus Magnus | 活跃 |
| 三浦按进 | Miura Anjin | PLATI_TUSI | RENAISSANCE | 1 | 所有政体外交政策槽位+1 | 所有政体外交政策槽位+1 | ✓ | Sumus Magnus | 活跃 |
| 伊拉斯谟 | Erasmus | PLATI_ERASMUS | RENAISSANCE | 1 | 不交战时每个大学+1外交点数+随机中世纪/文艺复兴市政鼓舞 | 不交战时每个大学+1外交点数。随机市政鼓舞 | ✓ | Sumus Magnus | 活跃 |
| 迈克尔·法拉第 | Michael Faraday | PLATI_FARADAY | INDUSTRIAL | 2 | 城市+2电力/回合+随机工业时代科技尤里卡 | 该城市每回合+2电力。随机工业时代科技尤里卡 | ✓ | Sumus Magnus | 活跃 |
| 尤利西斯·格兰特 | Ulysses S. Grant | PLATI_FRANKLIN | INDUSTRIAL | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | Sumus Magnus | 活跃 |
| 伏尔泰 | Voltaire | PLATI_LEIBNITZ | INDUSTRIAL | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | Sumus Magnus | 活跃 |
| 路易·巴斯德 | Louis Pasteur | PLATI_PASTEUR | INDUSTRIAL | 1 | 所有城市+20%余粮+触发"卫生设备"尤里卡 | 所有城市+20%余粮。触发"卫生设备"尤里卡 | ✓ | Sumus Magnus | 活跃 |
| 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | PLATI_CURIE | MODERN | 1 | 该城市展阁、公馆和市政广场内建筑+4文化值 | 该城市的展阁、公馆和市政广场内建筑+4文化值 | ✓ | Sumus Magnus | 活跃 |
| 安德烈·萨哈罗夫 | Andrei Sakharov | PLATI_SAKHAROV | ATOMIC | 1 | +2外交胜利点数+随机原子/信息时代科技尤里卡 | +2外交胜利点数。随机原子能或信息时代科技的尤里卡 | ✓ | Sumus Magnus | 活跃 |

#### 2.5.3 Ancient Paragons 新增大科学家

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 米利都的泰勒斯 | [无英文文本] | JNR_THALES_MILETUS | ANCIENT | 1 | 获得1个远古随机科技突破+2个古典随机市政鼓舞 | 触发1项远古时代随机科技尤里卡和2项古典时代随机市政鼓舞 | ✓ | Ancient Paragons | 活跃 |
| 弥勒 | [无英文文本] | JNR_MAITREYI | ANCIENT | 1 | 所有学院建筑+1科学+1文化+1信仰 | 此城所有学院区建筑提供+1科技值、+1文化值和+1信仰值 | ✓ | Ancient Paragons | 活跃 |

### 2.6 大先知 (Great Prophet)

所有大先知均 ActionCharges=0，无出生/退役Modifier，用于创立宗教。MaxPlayerInstances=1。

| 中文名 | 英文名 | 内部ID | 时代 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|----------|:--------:|------|------|
| [JOHN_THE_BAPTIST] | [JOHN_THE_BAPTIST] | JOHN_THE_BAPTIST | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CONFUCIUS] | [CONFUCIUS] | CONFUCIUS | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ZOROASTER] | [ZOROASTER] | ZOROASTER | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SIDDHARTHA_GAUTAMA] | [SIDDHARTHA_GAUTAMA] | SIDDHARTHA_GAUTAMA | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LAOZI] | [LAOZI] | LAOZI | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SIMON_PETER] | [SIMON_PETER] | SIMON_PETER | CLASSICAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [BODHIDHARMA] | [BODHIDHARMA] | BODHIDHARMA | MEDIEVAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ADI_SHANKARA] | [ADI_SHANKARA] | ADI_SHANKARA | MEDIEVAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SONGTSAN_GAMPO] | [SONGTSAN_GAMPO] | SONGTSAN_GAMPO | MEDIEVAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [O_NO_YASUMARO] | [O_NO_YASUMARO] | O_NO_YASUMARO | MEDIEVAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [IRENAEUS] | [IRENAEUS] | IRENAEUS | MEDIEVAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARTIN_LUTHER] | [MARTIN_LUTHER] | MARTIN_LUTHER | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [FRANCIS_OF_ASSISI] | [FRANCIS_OF_ASSISI] | FRANCIS_OF_ASSISI | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MADHVA_ACHARYA] | [MADHVA_ACHARYA] | MADHVA_ACHARYA | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [THOMAS_AQUINAS] | [THOMAS_AQUINAS] | THOMAS_AQUINAS | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HAJI_HUUD] | [HAJI_HUUD] | HAJI_HUUD | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| 摩西 | [无英文文本] | JNR_MOSES | ANCIENT | （无退役效果） | N/A | Ancient Paragons | 活跃 |
| 伽吉·瓦查克纳维 | [无英文文本] | JNR_GARGI_VACHAKNAVI | ANCIENT | （无退役效果） | N/A | Ancient Paragons | 活跃 |

### 2.7 大作家 (Great Writer)

所有大作家 ActionCharges=0（除屈原），通过生成著作（Great Work of Writing）运作。

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 特殊效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| [BHASA] | [BHASA] | BHASA | CLASSICAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HOMER] | [HOMER] | HOMER | CLASSICAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [OVID] | [OVID] | OVID | CLASSICAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [QU_YUAN] | [QU_YUAN] | QU_YUAN | CLASSICAL | 2 | 退役获地块（文化炸弹） | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [VALMIKI] | [VALMIKI] | VALMIKI | CLASSICAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [GEOFFREY_CHAUCER] | [GEOFFREY_CHAUCER] | GEOFFREY_CHAUCER | MEDIEVAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LI_BAI] | [LI_BAI] | LI_BAI | MEDIEVAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MURASAKI_SHIKIBU] | [MURASAKI_SHIKIBU] | MURASAKI_SHIKIBU | MEDIEVAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [RUMI] | [RUMI] | RUMI | MEDIEVAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [MARGARET_CAVENDISH] | [MARGARET_CAVENDISH] | MARGARET_CAVENDISH | RENAISSANCE | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MIGUEL_DE_CERVANTES] | [MIGUEL_DE_CERVANTES] | MIGUEL_DE_CERVANTES | RENAISSANCE | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [NICCOLO_MACHIAVELLI] | [NICCOLO_MACHIAVELLI] | NICCOLO_MACHIAVELLI | RENAISSANCE | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [WILLIAM_SHAKESPEARE] | [WILLIAM_SHAKESPEARE] | WILLIAM_SHAKESPEARE | RENAISSANCE | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARIE_CATHERINE_D_AULNOY] | [MARIE_CATHERINE_D_AULNOY] | MARIE_CATHERINE_D_AULNOY | RENAISSANCE | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ALEXANDER_PUSHKIN] | [ALEXANDER_PUSHKIN] | ALEXANDER_PUSHKIN | INDUSTRIAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EDGAR_ALLEN_POE] | [EDGAR_ALLEN_POE] | EDGAR_ALLEN_POE | INDUSTRIAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JANE_AUSTEN] | [JANE_AUSTEN] | JANE_AUSTEN | INDUSTRIAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JOHANN_WOLFGANG_VON_GOETHE] | [JOHANN_WOLFGANG_VON_GOETHE] | JOHANN_WOLFGANG_VON_GOETHE | INDUSTRIAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARY_SHELLEY] | [MARY_SHELLEY] | MARY_SHELLEY | INDUSTRIAL | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JAMES_JOYCE] | [JAMES_JOYCE] | JAMES_JOYCE | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EMILY_DICKINSON] | [EMILY_DICKINSON] | EMILY_DICKINSON | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LEO_TOLSTOY] | [LEO_TOLSTOY] | LEO_TOLSTOY | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARK_TWAIN] | [MARK_TWAIN] | MARK_TWAIN | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [F_SCOTT_FITZGERALD] | [F_SCOTT_FITZGERALD] | F_SCOTT_FITZGERALD | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [BEATRIX_POTTER] | [BEATRIX_POTTER] | BEATRIX_POTTER | MODERN | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [HG_WELLS] | [HG_WELLS] | HG_WELLS | ATOMIC | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [RABINDRANATH_TAGORE] | [RABINDRANATH_TAGORE] | RABINDRANATH_TAGORE | ATOMIC | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [KAREL_CAPEK] | [KAREL_CAPEK] | KAREL_CAPEK | INFORMATION | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GABRIELA_MISTRAL] | [GABRIELA_MISTRAL] | GABRIELA_MISTRAL | INFORMATION | 0 | 生成著作 | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |

#### 2.7.1 Sumus Magnus 新增大作家

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 特殊效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 希波的奥古斯丁 | Augustine of Hippo | PLATI_HOBBES | RENAISSANCE | 0 | 生成著作（《忏悔录》《上帝之城》） | 生成著作 | ✓ | Sumus Magnus | 活跃 |
| 弗里德里希·尼采 | Friedrich Nietzsche | PLATI_NIETZSCHE | INDUSTRIAL | 0 | 生成著作（《查拉图斯特拉如是说》《权力意志论》） | 生成著作 | ✓ | Sumus Magnus | 活跃 |
| 马丁·海德格尔 | Martin Heidegger | PLATI_HEIDEGGER | MODERN | 0 | 生成著作（《存在与时间》《诗·语言·思》） | 生成著作 | ✓ | Sumus Magnus | 活跃 |
| 霍华德·菲利普·洛夫克拉夫特 | H.P. Lovecraft | PLATI_LOVECRAFT | MODERN | 0 | 生成著作（《克苏鲁的呼唤》《印斯茅斯之影》） | 生成著作 | ✓ | Sumus Magnus | 活跃 |
| 罗伯特·欧文·霍华德 | Robert E. Howard | PLATI_RHOWARD | MODERN | 0 | 生成著作（《野蛮人柯南》《所罗门·凯恩》） | 生成著作 | ✓ | Sumus Magnus | 活跃 |
| [PLATI_DESCARTES] | [PLATI_DESCARTES] | PLATI_DESCARTES | ATOMIC | 1 | 有充能效果（《第一哲学沉思集》《方法论》） | 中文名无独立NAME条目，仅有著作名 | N/A | Sumus Magnus | 活跃 |
| [PLATI_CICERO] | [PLATI_CICERO] | PLATI_CICERO | ATOMIC | 1 | 有充能效果（《论演说家》《论共和国》） | 中文名无独立NAME条目，仅有著作名 | N/A | Sumus Magnus | 活跃 |

#### 2.7.2 Ancient Paragons 新增大作家

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 特殊效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 恩赫杜安娜 | [无英文文本] | JNR_EN_HEDU_ANNA | ANCIENT | 0 | 生成著作（《宁美沙拉》《因宁沙古拉》） | 生成著作 | ✓ | Ancient Paragons | 活跃 |
| 普塔霍特普 | [无英文文本] | JNR_PTAHHOTEP | ANCIENT | 0 | 生成著作（《普塔霍特普箴言》） | 生成著作 | ✓ | Ancient Paragons | 活跃 |

### 2.8 大艺术家 (Great Artist)

所有大艺术家 ActionCharges=0，通过生成艺术品（Great Work of Art）运作。

| 中文名 | 英文名 | 内部ID | 时代 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|----------|:--------:|------|------|
| [ANDREY_RUBLEV] | [ANDREY_RUBLEV] | ANDREY_RUBLEV | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HIERONYMUS_BOSCH] | [HIERONYMUS_BOSCH] | HIERONYMUS_BOSCH | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [DONATELLO] | [DONATELLO] | DONATELLO | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MICHELANGELO] | [MICHELANGELO] | MICHELANGELO | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [KAMAL_UD_DIN_BEHZAD] | [KAMAL_UD_DIN_BEHZAD] | KAMAL_UD_DIN_BEHZAD | RENAISSANCE | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [QIU_YING] | [QIU_YING] | QIU_YING | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [TITIAN] | [TITIAN] | TITIAN | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EL_GRECO] | [EL_GRECO] | EL_GRECO | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [REMBRANDT_VAN_RIJN] | [REMBRANDT_VAN_RIJN] | REMBRANDT_VAN_RIJN | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [HASEGAWA_TOHAKU] | [HASEGAWA_TOHAKU] | HASEGAWA_TOHAKU | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [SOFONISBA_ANGUISSOLA] | [SOFONISBA_ANGUISSOLA] | SOFONISBA_ANGUISSOLA | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [ANGELICA_KAUFFMAN] | [ANGELICA_KAUFFMAN] | ANGELICA_KAUFFMAN | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JANG_SEUNG_EOP] | [JANG_SEUNG_EOP] | JANG_SEUNG_EOP | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [KATSUSHIKA_HOKUSAI] | [KATSUSHIKA_HOKUSAI] | KATSUSHIKA_HOKUSAI | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [VINCENT_VAN_GOGH] | [VINCENT_VAN_GOGH] | VINCENT_VAN_GOGH | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [EDMONIA_LEWIS] | [EDMONIA_LEWIS] | EDMONIA_LEWIS | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARIE_ANNE_COLLOT] | [MARIE_ANNE_COLLOT] | MARIE_ANNE_COLLOT | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CLAUDE_MONET] | [CLAUDE_MONET] | CLAUDE_MONET | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [BORIS_ORLOVSKY] | [BORIS_ORLOVSKY] | BORIS_ORLOVSKY | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GUSTAV_KLIMT] | [GUSTAV_KLIMT] | GUSTAV_KLIMT | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [AMRITA_SHER_GIL] | [AMRITA_SHER_GIL] | AMRITA_SHER_GIL | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MARY_CASSATT] | [MARY_CASSATT] | MARY_CASSATT | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [WASSILY_KANDINSKY] | [WASSILY_KANDINSKY] | WASSILY_KANDINSKY | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |

#### Sumus Magnus 新增大艺术家

| 中文名 | 英文名 | 内部ID | 时代 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|----------|:--------:|------|------|
| 兰斯洛特·布朗 | Lancelot Brown | PLATI_VIIKTOR_VASNETSOV | MODERN | 每个相邻市立公园为市中心+2文化值 | N/A (无独立描述文本) | Sumus Magnus | 活跃 |
| 安德烈·勒诺特尔 | André Le Nôtre | PLATI_PICASSO | MODERN | 生成艺术品 | N/A (无独立描述文本) | Sumus Magnus | 活跃 |
| 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | PLATI_RASTRELLI | INDUSTRIAL | 生成艺术品 | N/A (无独立描述文本) | Sumus Magnus | 活跃 |

### 2.9 大音乐家 (Great Musician)

所有大音乐家 ActionCharges=0，通过生成音乐巨作（Great Work of Music）运作。

| 中文名 | 英文名 | 内部ID | 时代 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|----------|:--------:|------|------|
| [ANTONIO_VIVALDI] | [ANTONIO_VIVALDI] | ANTONIO_VIVALDI | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JOHANN_SEBASTIAN_BACH] | [JOHANN_SEBASTIAN_BACH] | JOHANN_SEBASTIAN_BACH | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LUDWIG_VAN_BEETHOVEN] | [LUDWIG_VAN_BEETHOVEN] | LUDWIG_VAN_BEETHOVEN | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [WOLFGANG_AMADEUS_MOZART] | [WOLFGANG_AMADEUS_MOZART] | WOLFGANG_AMADEUS_MOZART | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [YATSUHASHI_KENGYO] | [YATSUHASHI_KENGYO] | YATSUHASHI_KENGYO | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [DIMITRIE_CANTEMIR] | [DIMITRIE_CANTEMIR] | DIMITRIE_CANTEMIR | INDUSTRIAL | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [ANTONIO_CARLOS_GOMEZ] | [ANTONIO_CARLOS_GOMEZ] | ANTONIO_CARLOS_GOMEZ | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [FRANZ_LISZT] | [FRANZ_LISZT] | FRANZ_LISZT | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [FREDERIC_CHOPIN] | [FREDERIC_CHOPIN] | FREDERIC_CHOPIN | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [PETER_ILYICH_TCHAIKOVSKY] | [PETER_ILYICH_TCHAIKOVSKY] | PETER_ILYICH_TCHAIKOVSKY | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LIU_TIANHUA] | [LIU_TIANHUA] | LIU_TIANHUA | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [SCOTT_JOPLIN] | [SCOTT_JOPLIN] | SCOTT_JOPLIN | MODERN | （原版文本文件不在工作区中） | N/A (无文本) | Babylon DLC | 活跃 |
| [ANTONIN_DVORAK] | [ANTONIN_DVORAK] | ANTONIN_DVORAK | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [CLARA_SCHUMANN] | [CLARA_SCHUMANN] | CLARA_SCHUMANN | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [JUVENTINO_ROSAS] | [JUVENTINO_ROSAS] | JUVENTINO_ROSAS | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [LILIUOKALANI] | [LILIUOKALANI] | LILIUOKALANI | ATOMIC | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [GAUHAR_JAAN] | [GAUHAR_JAAN] | GAUHAR_JAAN | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |
| [MYKOLA_LEONTOVYCH] | [MYKOLA_LEONTOVYCH] | MYKOLA_LEONTOVYCH | INFORMATION | （原版文本文件不在工作区中） | N/A (无文本) | 原版 | 活跃 |

### 2.10 大统帅 (Comandante General) — GranColombia DLC

全部 ERA_ANCIENT，性别 M，充能 1，类别 GREAT_PERSON_CLASS_COMANDANTE_GENERAL。

| 中文名 | 英文名 | 内部ID | 退役效果 | 退役条件 | 被动效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|----------|----------|----------|----------|:--------:|------|------|
| [JOSE_DE_SUCRE] | [JOSE_DE_SUCRE] | JOSE_DE_SUCRE | 获得1个陆军单位+免费晋升+无视资源维护 | 需无军事单位 | +5战斗力+1移动力光环，退役时治疗相邻利亚内罗单位100HP | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [PAULA_SANTANDER] | [PAULA_SANTANDER] | PAULA_SANTANDER | 获得1个随机市政 | 无特殊条件 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [ANTONIO_PAEZ] | [ANTONIO_PAEZ] | ANTONIO_PAEZ | 骑兵+4战斗力 | 需附近轻骑+重骑 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [URDANETA] | [URDANETA] | URDANETA | 重置所有陆军移动力 | 需2格内有陆军 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [MARINO] | [MARINO] | MARINO | 近战+反骑兵+4战斗力 | 需附近近战+反骑兵 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [MACGREGOR] | [MACGREGOR] | MACGREGOR | 所在格陆军免费晋升+获得单位成本50%金币 | 需陆军+可获经验 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [PIAR] | [PIAR] | PIAR | 所在格陆军+7战斗力 | 需陆军单位 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [NARINO] | [NARINO] | NARINO | 商路容量+1+免费商队 | 无特殊条件 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [MONTILLA] | [MONTILLA] | MONTILLA | 陆军对区域+4战斗力 | 需2格内有陆军 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |
| [RIBAS] | [RIBAS] | RIBAS | 对2格内敌方单位造成30伤害 | 需2格内有敌方军事单位 | 同上 | （原版文本文件不在工作区中） | N/A (无文本) | GranColombia DLC | 活跃 |

### 2.11 大统治者 (Great Sovereigns) — Mod

全新类别，区域为 DISTRICT_GOVERNMENT，PseudoYieldType=PSEUDOYIELD_GPP_GreatSovereigns。

#### 核心13人

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 所罗门王 | Solomon | PLATI_FIRST | CLASSICAL | 1 | 免费获得寺庙+全寺庙+2产能 | 立即建造一所寺庙。所有寺庙+2生产力 | ✓ | Great Sovereigns | 活跃 |
| 马可·奥里利乌斯 | Marcus Aurelius | PLATI_SECOND | CLASSICAL | 1 | 获得所有中世纪市政鼓舞 | 为所有中世纪市政提供鼓舞 | ✓ | Great Sovereigns | 活跃 |
| 托勒密一世 | Ptolemy | PLATI_THIRD | CLASSICAL | 1 | 向奇观+100产能+每使者+1文化 | 建造奇观时提供100生产力。每个派往城邦的使者+1文化值 | ✓ | Great Sovereigns | 活跃 |
| 阿育王 | Asoka | PLATI_FOURTH | CLASSICAL | 1 | 每个专业区域+1信仰+1食物 | 城市从每个专业化区域得到+1信仰与+1食物 | ✓ | Great Sovereigns | 活跃 |
| 腓特烈二世 | Frederick II | PLATI_FIFTH | MEDIEVAL | 1 | 获得1个经济政策槽位 | 所有政体经济政策槽位+1 | ✓ | Great Sovereigns | 活跃 |
| 穆罕默德·阿里帕夏 | Mehmet Ali | PLATI_SIXTH | INDUSTRIAL | 1 | 单位升级费用-100%+获得1个随机科技 | 单位升级-100%金币。获得一项随机科技 | ✓ | Great Sovereigns | 活跃 |
| 查理曼 | Charlemagne | PLATI_SEVENTH | MEDIEVAL | 1 | 获得1个军事政策槽位 | 所有政体军事政策槽位+1 | ✓ | Great Sovereigns | 活跃 |
| 哈伦·拉希德 | Harun al-Rashid | PLATI_EIGHTH | MEDIEVAL | 1 | 黄金时代时商路每6格+1科学 | 文明处于黄金时代时，商路每经过6个单元格提供+1科技值 | ✓ | Great Sovereigns | 活跃 |
| 阿斯基亚大帝 | Askia | PLATI_NINTH | RENAISSANCE | 1 | 征服有纪念碑城市获得货贝奢侈品+区域劫掠加倍 | 征服有纪念碑的城市获得奢侈品货贝。掠夺区域收益+100% | ✓ | Great Sovereigns | 活跃 |
| 阿克巴 | Akbar | PLATI_TENTH | RENAISSANCE | 1 | 获得1个通配符政策槽位 | 所有政体通用政策槽位+1 | ✓ | Great Sovereigns | 活跃 |
| 明治天皇 | Meiji | PLATI_THIRTEENTH | INDUSTRIAL | 1 | 社区+300金币（替换农场）+工业区+300金币（替换农场）+互相+2食物相邻 | 在农场上建成工业区或社区将获得金币。工业区和社区从相邻区域处获得+2食物 | ✓ | Great Sovereigns | 活跃 |
| 凯末尔 | Ataturk | PLATI_FOURTEENTH | MODERN | 3 | 向城市+400产能（3次）+所有陆军+3战斗力 | 提供400生产力（不适用于奇观、项目） | ✓ | Great Sovereigns | 活跃 |
| 海尔·塞拉西一世 | Haile Selassie | PLATI_FIFTEENTH | MODERN | 1 | 获得2个外交胜利点数 | +2外交胜利点数 | ✓ | Great Sovereigns | 活跃 |

#### 特殊人物

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 阿尔弗雷德大帝 | Alfred the Great | PLATI_ALFRED_THE_GREAT | MEDIEVAL | 1 | 兵工厂相邻+1产能+1科学+海军单位免费晋升 | 海军兵工厂从相邻区域获得+1科技值和+1文化值，海军单位初始获得一次免费升级 | ✓ | Great Sovereigns | 活跃 |

#### 重分类（原版陆军统帅迁移）

| 中文名 | 英文名 | 原版ID | 时代 | 重分类后效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------------|----------|:--------:|------|------|
| 拿破仑·波拿巴 | Napoleon Bonaparte | NAPOLEON_BONAPARTE | INDUSTRIAL | 获得1个通配符政策槽位 | 所有政体通用政策槽位+1 | ✓ | 原版→Great Sovereigns | 重分类 |
| 古斯塔夫·阿道夫 | Gustavus Adolphus | GUSTAVUS_ADOLPHUS | RENAISSANCE | 获得1个军事政策槽位 | 所有政体军事政策槽位+1 | ✓ | 原版→Great Sovereigns | 重分类 |

#### 扩展人物（Expansion目录）

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 退役效果 | 文本描述 | 文本一致性 | 来源 | 状态 |
|--------|--------|--------|------|------|----------|----------|:--------:|------|------|
| 普里特维·纳拉扬·沙阿 | Prithvi Narayan Shah | PLATI_KOSEMI | - | 1 | 近战/远程单位+3战斗力，异大陆额外+3 | 近战单位+5战斗力。在外国领土上战斗额外+3战斗力 | ⚠ 代码为+3/+3，中文文本描述为+5/+3 | Great Sovereigns | 活跃 |
| 哈克汗二世 | Al-Hakam II | PLATI_RBORGIA | - | 1 | 有崇拜建筑的城市可额外建造教堂/清真寺/犹太会堂 | 建造奇观时提供180生产力。黄金时代非主流宗教+1宜居度 | ✗ 中文文本为旧效果，英文文本已更新 | Great Sovereigns | 活跃 |
| 恩里科·丹多洛 | Enrico Dandolo | PLATI_DANDOLO | - | 1 | 获得2遗物+宫殿遗物槽+商队降低外国城市忠诚度 | [无中文文本] | N/A | Great Sovereigns | 活跃 |
| 伊莎贝拉一世 | Isabella I | PLATI_ISABELLA | - | 1 | 获得1大探险家+商队+2视野+海军击败敌人生成大探险家点数 | [无中文文本] | N/A | Great Sovereigns | 活跃 |
| 兰尼埃三世 | Rainier III | PLATI_MONACO | - | 1 | 每份多余奢侈品+200旅游业绩+海滨建筑提升度假区旅游业绩 | [无中文文本] | N/A | Great Sovereigns | 活跃 |
| 斯坎德培 | Skanderbeg | PLATI_DENG | - | 1 | 立即击杀2格内所有敌方单位+恢复陆军移动力 | 立即击杀两个单元格内所有敌方单位。本方陆地战斗单位恢复所有移动力 | ✓ | Great Sovereigns | 活跃 |
| 伊斯玛仪一世 | Ismail I | PLATI_ISMAIL | - | 1 | 黑暗时代骑兵攻占城市转化宗教/黄金时代艺术巨作文化翻倍 | 黑暗时代用骑兵攻占城市信仰主流宗教；黄金时代巨作文化值翻倍 | ✓ | Great Sovereigns | 活跃 |
| 奥托·冯·俾斯麦 | Otto von Bismark | PLATI_BISMARK | - | 1 | 成为选定城邦宗主国+外交政策卡+1外交支持/回合 | 成为选定城邦宗主国，移除其他玩家使者。外交政策卡+1外交支持/回合 | ✓ | Great Sovereigns | 活跃 |
| 洛伦佐·德·美第奇 | Lorenzo the Magnificent | PLATI_ARBE | - | 1 | 文艺复兴奇观+2巨作槽/黄金时代送1大艺术家 | 文艺复兴奇观获得两个巨作槽位。黄金时代获得一位大艺术家 | ✓ | Great Sovereigns | 活跃 |
| 兀鲁伯 | Ulug Beg | PLATI_BEG | - | 1 | 每建成学院+200科技值 | 每建成一个学院提供200科技值 | ✓ | Great Sovereigns | 活跃 |
| 儒略二世 | Julius II | PLATI_AKBAR | - | 1 | 向奇观+455产能 | 建造奇观时提供455生产力 | ✓ | Great Sovereigns | 活跃 |
| 路易十四 | Louis XIV | PLATI_SOVEREIGN_FIRST | - | 1 | 市政广场建筑+3巨作槽/雕塑文化值+200% | 市政广场内建筑获得3个艺术巨作槽位。雕塑文化值+200% | ✓ | Great Sovereigns | 活跃 |
| 拜里米苏拉 | Parameswara | PLATI_SOVEREIGN_FRIDRIK_GREAT | - | 1 | 城市+1攻击次数+港口/商业中心/外交区各+5%金币信仰 | 该城市+1攻击次数。每有港口/商业中心/外交区+5%金币和信仰值 | ✓ | Great Sovereigns | 活跃 |
| 维陶塔斯 | Vytautas | PLATI_SOVEREIGN_GEDIMINAS | - | 2 | 城市+8忠诚度/回合+创建骑士单位（2充能） | 提供一个骑士+每回合+5忠诚度 | ✗ 代码为+8忠诚/2充能，中文文本为+5忠诚/1充能 | Great Sovereigns | 活跃 |
| 扎耶德·本·苏尔坦·阿勒纳哈扬 | Zayed bin Sultan Al Nahyan | PLATI_SOVEREIGN_ZAYED | - | 1 | 每有种发电战略资源+20%金币 | 每有一种用于发电的战略资源+20%金币 | ✓ | Great Sovereigns | 活跃 |
| 兰甘亨 | Ramkhamhaeng | PLATI_SIXTEENTH | - | 1 | 每种宗主城邦类型+1人口 | 宗主每个城邦+1%食物和信仰，每种城邦+1宜居度 | ✗ 代码为+1人口，中文文本为+1%食物/信仰 | Great Sovereigns | 活跃 |
| 玛丽亚·特蕾莎 | Maria Theresa | PLATI_TWELWTH | - | 1 | 每种城邦特色改良+20%大艺术家/大音乐家点数 | 每个城邦特色改良为剧院广场+2相邻加成，为娱乐中心+2生产力 | ✗ 代码为+20%伟人点数，中文文本为相邻加成 | Great Sovereigns | 活跃 |
| 李光耀 | Lee Kuan Yew | PLATI_ELEVENTH | - | 1 | 大商人+1充能 | 大商人+1使用次数 | ✓ | Great Sovereigns | 活跃 |

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

### 3.4 陆军统帅独特效果

**BOUDICA 转化蛮族:**
```
MODIFIER_PLAYER_UNIT_ADJUST_BARBARIANS_TO_OWNER → 相邻蛮族单位转为己方
```

**GEORGY_ZHUKOV 侧翼加成:**
```
MODIFIER_PLAYER_UNITS_GRANT_ABILITY → ABILITY_GEORGY_ZHUKOV_FLANKING_BONUS
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

**SHAH_JAHAN 奇观购买:**
```
MODIFIER_CITY_PURCHASE_PRODUCTION → 用金币购买奇观产能
```

### 3.6 大商人独特效果

**MARCUS_LICINIUS_CRASSUS 地块获取:**
```
MODIFIER_PLAYER_GRANT_PLOT → 获取无主地块（3次）
```

**MARY_KATHERINE_GODDARD 外交能见度:**
```
MODIFIER_PLAYER_ADJUST_DIPLO_VISIBILITY → Amount=1, Source="大新闻"
```

### 3.7 大科学家独特效果

**GALILEO_GALILEI 山脉科学:**
```
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 每相邻山脉格+250科学
```

**CHARLES_DARWIN 自然奇观科学:**
```
MODIFIER_PLAYER_ADJUST_PLOT_YIELD → 每相邻自然奇观格+500科学
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
- **Ancient Paragons** JNR_SIYAJ_K_AK 的条件性 UPDATE：当检测到 EXP1 时，退役效果改为 GREATPERSON_AETHELFLAED_ACTIVE
- **Ancient Paragons** 伊姆霍特普（IMHOTEP）的时代从 MEDIEVAL 更新为 CLASSICAL，产能数值从 350/175 调整为 250/125

### 4.3 Lua 发现的效果

**艺术类伟人偷奇观 Mod (GreatPersonTeleport.lua):**

1. **奇观学家偷取功能 (ArchaeologistStealWonder):** 将所在城市的奇观从城市中移除，存储到奇观学家身上。黑名单：金门大桥、巴拿马运河、塔桥
2. **奇观学家安置功能 (ArchaeologistPlaceWonder):** 消耗金币将奇观放置在目标城市
3. **传送开拓者功能 (GreatPersonTeleportSettler):** 将开拓者准确传送到指定坐标
4. **文化炸弹功能 (CultureBomb):** 吞并伟人所在格及周围1格范围内的中立地块
5. **召唤奇观学家功能 (SummonWonderTheft):** 在伟人所在格生成1个奇观学家单位

### 4.4 交叉验证结论

- **XML** 是主要数据定义方式，覆盖所有伟人个体的基础属性、Modifier 链和效果
- **SQL** 主要用于 Ancient Paragons Mod 和条件性修改（UPDATE with EXISTS 检查），以及 Delete Some Great Engineer 的删除操作
- **Lua** 仅用于艺术类伟人偷奇观 Mod，提供 XML/SQL 无法实现的动态交互
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

### 5.3 重分类条目

| 原版ID | 中文名 | 英文名 | 原类别 | 新类别 | 新效果 |
|--------|--------|--------|--------|--------|--------|
| NAPOLEON_BONAPARTE | 拿破仑·波拿巴 | Napoleon Bonaparte | GREAT_PERSON_CLASS_GENERAL | GREAT_PERSON_CLASS_GreatSovereigns | 获得1个通配符政策槽位 |
| GUSTAVUS_ADOLPHUS | 古斯塔夫·阿道夫 | Gustavus Adolphus | GREAT_PERSON_CLASS_GENERAL | GREAT_PERSON_CLASS_GreatSovereigns | 获得1个军事政策槽位 |

重分类通过 GreatSovereigns_Config.xml 中的 `SovereignReclassifyGenerals` 参数控制（默认关闭）。

---

## §6 兼容性分析

### 6.1 Mod 冲突分析

1. **Delete Some Great Engineer (LoadOrder 0) vs Sumus Magnus (LoadOrder 240):** 两者都删除 JAMES_OF_ST_GEORGE 和 JOHN_A_ROEBLING（重复删除），无冲突。**结论**: 删除操作互补。

2. **EWHO (LoadOrder 999999) vs 所有伟人Mod:** EWHO 最后加载，其 GreatPersonClasses 表定义会覆盖之前的修改。新增了 GREAT_PERSON_CLASS_ENGINEER_EWHO 类别和 SHAH_JAHAN_EWHO 个体。**结论**: EWHO 对 GreatPersonClasses 的修改可能覆盖前面的设置，但新增内容独立不冲突。

3. **Sumus Magnus 与 Ancient Paragons:** Sumus Magnus 有显式兼容检测 (ActionCriteria)，通过 `SumusMagnusRemoveUnimpressives` 等参数控制行为。Ancient Paragons 使用 INSERT OR IGNORE 和条件性 UPDATE。**结论**: 两者有基本的兼容性设计。

4. **Great Sovereigns 重分类 vs 原版陆军统帅:** 拿破仑和古斯塔夫的重分类通过 `SovereignReclassifyGenerals` 参数控制（默认关闭）。**结论**: 可控冲突，用户可通过游戏选项开关。

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
| 艺术类伟人行为 | 原版 (生成著作) | 艺术类伟人偷奇观 Mod (Lua) | 两者共存 |

---

## §7 文本与代码对照

> 本表仅列出有可用本地化文本的Mod条目。

| 条目 | 来源 | 代码效果 | 文本声称效果 | 一致性 |
|------|------|----------|-------------|:------:|
| 拉格纳·洛德布罗克 | Sumus Magnus | 掠夺改良设施收益翻倍 | 掠夺改良设施的收益翻倍 | ✓ |
| 巴巴罗萨·海雷丁 | Sumus Magnus | 可训练巴巴里海盗 | 可训练巴巴里海盗 | ✓ |
| 克罗索斯 | Sumus Magnus | 国库金币翻倍 | 当前国库金币翻倍 | ✓ |
| 亚里士多德 | Sumus Magnus | 通配符政策槽位+1 | 所有政体通用政策槽位+1 | ✓ |
| 蔡伦 | Sumus Magnus | 解锁造纸坊 | 解锁并建造特色建筑造纸坊 | ✓ |
| 沈括 | Sumus Magnus | 学院提供等同于相邻加成的生产力 | 该学院提供等同于其相邻加成的生产力 | ✓ |
| 亚历山大·汉密尔顿 | Sumus Magnus | 经济政策槽位+1 | 所有政体经济政策槽位+1 | ✓ |
| 所罗门王 | Great Sovereigns | 免费寺庙+全寺庙+2产能 | 立即建造寺庙，所有寺庙+2生产力 | ✓ |
| 马可·奥里利乌斯 | Great Sovereigns | 获得所有中世纪市政鼓舞 | 为所有中世纪市政提供鼓舞 | ✓ |
| 查理曼 | Great Sovereigns | 军事政策槽位+1 | 所有政体军事政策槽位+1 | ✓ |
| 阿克巴 | Great Sovereigns | 通配符政策槽位+1 | 所有政体通用政策槽位+1 | ✓ |
| 海尔·塞拉西一世 | Great Sovereigns | +2外交胜利点数 | +2外交胜利点数 | ✓ |
| 阿尔弗雷德大帝 | Great Sovereigns | 兵工厂相邻加成+海军免费晋升 | 海军兵工厂相邻加成+海军免费晋升 | ✓ |
| 斯坎德培 | Great Sovereigns | 击杀2格内敌方+恢复移动力 | 击杀2格内敌方+恢复移动力 | ✓ |
| 伊斯玛仪一世 | Great Sovereigns | 黑暗时代骑兵转化宗教/黄金时代文化翻倍 | 黑暗时代转化宗教/黄金时代巨作文化翻倍 | ✓ |
| 奥托·冯·俾斯麦 | Great Sovereigns | 宗主权夺城邦+外交卡外交支持 | 宗主权夺城邦+外交卡外交支持 | ✓ |
| 洛伦佐·德·美第奇 | Great Sovereigns | 文艺复兴奇观+2巨作槽/黄金时代送大艺术家 | 文艺复兴奇观+2巨作槽/黄金时代送大艺术家 | ✓ |
| 兀鲁伯 | Great Sovereigns | 每建成学院+200科技值 | 每建成学院+200科技值 | ✓ |
| 儒略二世 | Great Sovereigns | 向奇观+455产能 | 向奇观+455产能 | ✓ |
| 路易十四 | Great Sovereigns | 市政广场+3巨作槽/雕塑200%文化值 | 市政广场+3巨作槽/雕塑200%文化值 | ✓ |
| 拜里米苏拉 | Great Sovereigns | 城市+1攻击次数/港口商业中心+5%金币信仰 | 城市+1攻击次数/港口商业中心+5%金币信仰 | ✓ |
| 扎耶德·本·苏尔坦·阿勒纳哈扬 | Great Sovereigns | 每种发电战略资源+20%金币 | 每种发电战略资源+20%金币 | ✓ |
| 李光耀 | Great Sovereigns | 大商人+1充能 | 大商人+1使用次数 | ✓ |
| 恩里科·丹多洛 | Great Sovereigns | 获得2遗物+宫殿遗物槽+商队降低忠诚度 | [无中文文本] | N/A |
| 伊莎贝拉一世 | Great Sovereigns | 获得1大探险家+商队+2视野+海军击败敌人得点数 | [无中文文本] | N/A |
| 兰尼埃三世 | Great Sovereigns | 每多余奢侈品+200旅游业绩+海滨旅游业绩提升 | [无中文文本] | N/A |
| 普里特维·纳拉扬·沙阿 | Great Sovereigns | 近战/远程+3战斗力，异大陆额外+3 | 近战+5战斗力，异大陆额外+3 | ✗ |
| 哈克汗二世 | Great Sovereigns | 有崇拜建筑城可额外建教堂/清真寺/犹太会堂 | 建造奇观+180产能，黄金时代非主流宗教+1宜居度 | ✗ |
| 维陶塔斯 | Great Sovereigns | 城市+8忠诚/回合+2充能创建骑士单位 | 提供骑士+5忠诚/回合 | ✗ |
| 兰甘亨 | Great Sovereigns | 每种宗主城邦类型+1人口 | 宗主城邦+1%食物信仰，每种城邦+1宜居度 | ✗ |
| 玛丽亚·特蕾莎 | Great Sovereigns | 每种城邦特色改良+20%大艺术家/大音乐家点数 | 城邦特色改良为剧院广场+2相邻加成 | ✗ |
| 赫努 | Ancient Paragons | 获得少量金币+海上贸易路线范围+10 | 永久提升海上商路33%行动范围 | ✓ |
| 奈·曼加尼布卡 | Ancient Paragons | 获得1个海军近战单位（可进入海洋格） | 创建无视科技限制即可进入海洋格的海军近战单位 | ✓ |
| 妇好 | Ancient Paragons | 获得1个重骑兵单位（带伪装能力） | 创建仅可通过相邻敌方单位显形的重骑兵单位 | ✓ |
| 西亚赫·卡阿克 | Ancient Paragons | 获得1个使者 | [无独立退役效果文本] | N/A |
| 玛利亚·希伯来亚 | Ancient Paragons | 所有项目+20%产能 | 区域项目获得+20%生产力 | ✓ |
| 阿玛·埃 | Ancient Paragons | 商路容量+1+国内商路+1食物+1产能 | 通往此城的国内贸易路线提供+1食物与+1生产力 | ✓ |
| 希兰 | Ancient Paragons | 获得1个骨螺紫奢侈品资源 | 授予泰尔紫（独特奢侈品，提供+4宜居度） | ✓ |
| 米利都的泰勒斯 | Ancient Paragons | 获得1个远古随机科技突破+2个古典随机市政鼓舞 | 触发1项远古时代随机科技尤里卡和2项古典时代随机市政鼓舞 | ✓ |
| 弥勒 | Ancient Paragons | 所有学院建筑+1科学+1文化+1信仰 | 此城所有学院区建筑提供+1科技值、+1文化值和+1信仰值 | ✓ |
| 恩赫杜安娜 | Ancient Paragons | 生成著作 | 生成著作 | ✓ |
| 普塔霍特普 | Ancient Paragons | 生成著作 | 生成著作 | ✓ |
| 摩西 | Ancient Paragons | 创立宗教 | 创立宗教 | ✓ |
| 伽吉·瓦查克纳维 | Ancient Paragons | 创立宗教 | 创立宗教 | ✓ |

---

## §8 文本与代码差异详情

### 8.1 无本地化文本可用

工作区中不包含原版游戏和DLC的本地化文件。因此，对于所有原版和DLC条目（177个原版 + 42个DLC = 219个条目），**无法进行文本对照验证**。其内部ID（如 ARTEMISIA、HYPATIA、GALILEO_GALILEI 等）是唯一可用的标识符，但表内已用 `[ID]` 格式标注并注明"（原版文本文件不在工作区中）"。

可用本地化文件的 Mod 来源：

| Mod | 本地化文件 | 语言 | 路径 |
|-----|-----------|------|------|
| 更多伟人 (Sumus Magnus) | `PLATI_Localisation.xml` | 英文 | `/workspace/MOD/伟人/2448605286 更多伟人/PLATI_Localisation.xml` |
| 更多伟人汉化 | `smct.xml` | 中文 | `/workspace/MOD/伟人/3338128748 更多伟人汉化/smct.xml` |
| 大统治者伟人 (Great Sovereigns) | `GreatSovereigns_Localisation.xml` | 英文 | `/workspace/MOD/伟人/2973448849 大统治者伟人/GreatSovereigns_Localisation.xml` |
| 大统治者伟人汉化 | `gsct.1.xml` | 中文 | `/workspace/MOD/伟人/3310259652 大统治者伟人汉化/gsct.1.xml` |
| 远古伟人 (Ancient Paragons) | `6T_AGP_Text_*.sql` | 中文 | `/workspace/MOD/伟人/3085812151 远古伟人/Text/` |

### 8.2 Mod 条目文本对照（已验证一致）

以下 Mod 条目经代码与本地化文本交叉验证，**文本描述与代码效果一致**：

#### Sumus Magnus (更多伟人) — 44条已验证

| 内部ID | 中文名 | 英文名 | 退役效果验证 |
|--------|--------|--------|------------|
| PLATI_CROESUS | 克罗索斯 | Croesus | 国库金币翻倍 (`MODIFIER_PLAYER_ADJUST_TREASURY_YIELD`) ✓ |
| PLATI_APOLLODRO | 大马士革的阿波罗多洛斯 | Apollodorus of Damascus | 每区域+1产能+1文化 ✓ |
| PLATI_ARAGONESE | 劳里亚的罗杰 | Roger of Lauria | 每未用移动力+1战力 ✓ |
| PLATI_JAN_ZIZKA | 扬·杰式卡 | Jan Žižka | 对抗高战力+4战力+防御远程+10 ✓ |
| PLATI_FRANKLIN | 尤利西斯·格兰特 | Ulysses S. Grant | +1外交胜利点数 ✓ |
| PLATI_SAKHAROV | 安德烈·萨哈罗夫 | Andrei Sakharov | +2外交胜利点数+随机原子/信息科技尤里卡 ✓ |
| PLATI_FARADAY | 迈克尔·法拉第 | Michael Faraday | +2电力/回合+随机工业科技尤里卡（2充能）✓ |
| PLATI_TUSI | 三浦按进 | Miura Anjin | 外交政策槽位+1 ✓ |
| PLATI_UNGERN | 罗曼·冯·恩琴 | Roman von Ungern-Sternberg | 创建5个怯薛 ✓ |
| PLATI_GAJAH | 加查·马达 | Gajah Mada | 获得胡椒/肉豆蔻 ✓ |
| PLATI_FABERGE | 彼得·卡尔·法贝热 | Peter Carl Faberge | 获得2份法贝热彩蛋 ✓ |
| PLATI_REX | 卡尔十二世 | Carolus Rex | 可训练卡洛琳步兵 ✓ |
| PLATI_AFANASIY | 阿发纳西·尼基丁 | Afanasy Nikitin | 首都获得奢侈品资源 ✓ |
| PLATI_LAWRENCE | 阿拉伯的劳伦斯 | Lawrence of Arabia | 解放城市后10回合+20%文化 ✓ |
| PLATI_CECIL | 塞西尔·罗兹 | Cecil Rhodes | 创建红衫军+异大陆金币 ✓ |
| PLATI_URBAN | 乌尔班 | Urban | 创建2个射石炮 ✓ |
| PLATI_AGRIPPA | 阿格里帕 | Agrippa | 建造奇观+245产能 ✓ |
| PLATI_HENRY | 米希尔·德·鲁伊特 | Michiel de Ruyter | 城市+1攻击次数 ✓ |
| PLATI_LIONHEART | 斯坦尼斯瓦夫·若乌凯夫斯基 | Stanisław Żółkiewski | 可训练翼骑兵 ✓ |
| PLATI_BANKER | 约翰·皮尔庞特·摩根 | J.P. Morgan | 每个银行+1外交点数 ✓ |
| PLATI_NESTLE | 吉恩·诺伊豪斯二世 | Jean Neuhaus II | 解锁巧克力工厂 ✓ |
| PLATI_ARISTOTLE | 亚里士多德 | Aristotle | 通配符政策槽位+1 ✓ |
| PLATI_AL_AHRAMI | 格拉纳达的穆罕默德五世 | Muhammad V of Granada | 宫殿+3巨作槽 ✓ |
| PLATI_SAUGUSTINE | 伊本·西那 | Ibn Sina (Avicenna) | 宗教战斗力+3+随机中世纪科技尤里卡 ✓ |
| PLATI_NIETZSCHE | 弗里德里希·尼采 | Friedrich Nietzsche | 生成著作 ✓ |
| PLATI_JACOBKETTLER | 雅各布·凯特勒 | Jacob Kettler | 港口提供相邻加成等同生产力 ✓ |
| PLATI_ERASMUS | 伊拉斯谟 | Erasmus | 不交战每个大学+1外交点数 ✓ |
| PLATI_ALI_MASHADDI | 菲迪亚斯 | Phidias | 古典奇观+1巨作槽 ✓ |
| PLATI_VIIKTOR_VASNETSOV | 兰斯洛特·布朗 | Lancelot Brown | 相邻市立公园+2文化 ✓ |
| PLATI_PICASSO | 安德烈·勒诺特尔 | André Le Nôtre | 生成艺术品 ✓ |
| PLATI_ISAMBARD | 伊桑巴德·金德姆·布鲁内尔 | Isambard Kingdom Brunel | 每种区域+1%产能 ✓ |
| PLATI_HOBBES | 希波的奥古斯丁 | Augustine of Hippo | 生成著作 ✓ |
| PLATI_KRUPP | 阿尔弗雷德·克虏伯 | Alfred Krupp | 攻城单位+25%产能 ✓ |
| PLATI_GARIBALDI | 朱塞佩·加里波第 | Giuseppe Garibaldi | 首都大陆近战+3战力 ✓ |
| PLATI_BAIBARS | 拜伯尔斯 | Baibars | 受伤战斗力减益-20% ✓ |
| PLATI_SARGON | 卡尔·古斯塔夫·埃米尔·曼纳海姆 | Carl Gustaf Emil Mannerheim | 防守+4战力 ✓ |
| PLATI_IBNBATTUTA | 伊本·白图泰 | Ibn Battuta | 商路每4格+1信仰 ✓ |
| PLATI_COLBERT | 涩泽荣一 | Shibusawa Eiichi | 发电资源为改良奢侈品+1宜居度 ✓ |
| PLATI_WILBRAHAM | 阿尔贝托·桑托斯·杜蒙 | Alberto Santos-Dumont | 航空港相邻区域+2产能+2文化 ✓ |
| PLATI_PASTEUR | 路易·巴斯德 | Louis Pasteur | +20%余粮+触发卫生设备尤里卡 ✓ |
| PLATI_LEIZU | 胡果·格劳秀斯 | Hugo Grotius | +1外交胜利点数 ✓ |
| PLATI_LEIBNITZ | 伏尔泰 | Voltaire | +1外交胜利点数 ✓ |
| PLATI_LODBROK | 拉格纳·洛德布罗克 | Ragnar Lodbrok | 掠夺翻倍+可俘获船只 ✓ |
| PLATI_BARBAROSSA | 巴巴罗萨·海雷丁 | Barbarossa Hayreddin | 可训练巴巴里海盗 ✓ |
| PLATI_CAI_LUN | 蔡伦 | Cai Lun | 解锁造纸坊 ✓ |
| PLATI_SHEN_KUO | 沈括 | Shen Kuo | 学院提供等同相邻加成生产力 ✓ |
| PLATI_AVERROES | 伊本·路世德 | Ibn Rushd (Averroes) | 黄金时代每著作+1科学+2信仰 ✓ |
| PLATI_MAJID | 艾哈迈德·本·马吉德 | Ahmad bin Majid | 海军+2移动力 ✓ |
| PLATI_MORGAN | 亨利·摩根 | Henry Morgan | +1总督点 ✓ |
| PLATI_VITUS | 维图斯·约纳森·白令 | Vitus Jonassen Bering | 冻土/雪地港口相邻加成 ✓ |
| PLATI_COOK | 阿方索·德·阿尔布克尔克 | Afonso de Albuquerque | 肉豆蔻资源 ✓ |
| PLATI_HAMILTON | 亚历山大·汉密尔顿 | Alexander Hamilton | 经济政策槽位+1 ✓ |
| PLATI_VENETIAN | 马拉莫科的波诺 | Bono of Malamocco | +1遗物+1商路容量 ✓ |
| PLATI_SFORZA | 卡泰丽娜·斯福尔扎 | Caterina Sforza | +300文化值 ✓ |
| PLATI_SUAREZ | 埃尔南·科尔特斯 | Hernán Cortés | 创建征服者 ✓ |
| PLATI_BAYINNAUNG | 于格·德·帕扬 | Hugues de Payens | 解锁圣殿金库 ✓ |
| PLATI_SUNDIATA | 哈立德·本·瓦利德 | Khalid ibn al-Walid | +200信仰值 ✓ |
| PLATI_RURIK | 留里克大公 | Rurik | 获得开拓者+狂暴武士 ✓ |
| PLATI_CHATEAU | 菲利贝尔·德洛姆 | Philibert de l'Orme | 工业区相邻加成转文化+城堡 ✓ |
| PLATI_MISSION | 克里斯托佛·克拉乌 | Christopher Clavius | 信仰转科技+传教团 ✓ |
| PLATI_POLDER | 扬·莱赫瓦特 | Jan Leeghwater | 免疫自然灾害+圩田 ✓ |
| PLATI_ZEPPELIN | 维特鲁威 | Vitruvius | 触发工程+军事工程学尤里卡 ✓ |
| PLATI_CURIE | 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | 展阁/公馆/市政广场建筑+4文化 ✓ |
| PLATI_DAHLBERG | 塞巴斯蒂安·勒普雷斯特雷·德·沃邦 | Sébastien Le Prestre de Vauban | 军事工程师+堡垒加成 ✓ |
| PLATI_LOVECRAFT | 霍华德·菲利普·洛夫克拉夫特 | H.P. Lovecraft | 生成著作 ✓ |
| PLATI_RHOWARD | 罗伯特·欧文·霍华德 | Robert E. Howard | 生成著作 ✓ |
| PLATI_NIELS_JUEL | 安德烈亚·多里亚 | Andrea Doria | 海军征服自动信仰转化 ✓ |
| PLATI_TOKUGAWA | 威廉·米切尔 | William Mitchell | 机场送战斗机+区域防御无惩罚 ✓ |
| PLATI_HEIDEGGER | 马丁·海德格尔 | Martin Heidegger | 生成著作 ✓ |

#### Ancient Paragons (远古伟人) — 14条已验证

| 内部ID | 中文名 | 退役效果验证 |
|--------|--------|------------|
| JNR_HENENU | 赫努 | 金币+商路范围+10 ✓ |
| JNR_NEI_MANGANIBUKA | 奈·曼加尼布卡 | 海军近战单位（可入海洋）✓ |
| JNR_FU_HAO | 妇好 | 重骑兵（伪装能力）✓ |
| JNR_SIYAJ_K_AK | 西亚赫·卡阿克 | 使者（条件性） ✓ |
| JNR_MARIA_HEBRAEA | 玛利亚·希伯来亚 | 项目+20%产能 ✓ |
| JNR_AMA_E | 阿玛·埃 | 商路+1食物+1产能 ✓ |
| JNR_HIRAM | 希兰 | 骨螺紫奢侈品 ✓ |
| JNR_THALES_MILETUS | 米利都的泰勒斯 | 1远古科技+2古典市政 ✓ |
| JNR_MAITREYI | 弥勒 | 学院建筑+1科学+1文化+1信仰 ✓ |
| JNR_EN_HEDU_ANNA | 恩赫杜安娜 | 生成著作 ✓ |
| JNR_PTAHHOTEP | 普塔霍特普 | 生成著作 ✓ |
| JNR_MOSES | 摩西 | 创立宗教 ✓ |
| JNR_GARGI_VACHAKNAVI | 伽吉·瓦查克纳维 | 创立宗教 ✓ |

#### Great Sovereigns (大统治者) — 19条已验证

| 内部ID | 中文名 | 英文名 | 退役效果验证 |
|--------|--------|--------|------------|
| PLATI_FIRST | 所罗门王 | Solomon | 免费寺庙+全寺庙+2产能 ✓ |
| PLATI_SECOND | 马可·奥里利乌斯 | Marcus Aurelius | 所有中世纪市政鼓舞 ✓ |
| PLATI_THIRD | 托勒密一世 | Ptolemy | 奇观+100产能+使者+1文化 ✓ |
| PLATI_FOURTH | 阿育王 | Asoka | 每专业区域+1信仰+1食物 ✓ |
| PLATI_FIFTH | 腓特烈二世 | Frederick II | 经济政策槽位+1 ✓ |
| PLATI_SIXTH | 穆罕默德·阿里帕夏 | Mehmet Ali | 单位升级-100%金币+随机科技 ✓ |
| PLATI_SEVENTH | 查理曼 | Charlemagne | 军事政策槽位+1 ✓ |
| PLATI_EIGHTH | 哈伦·拉希德 | Harun al-Rashid | 黄金时代商路+1科技/6格 ✓ |
| PLATI_NINTH | 阿斯基亚大帝 | Askia | 征服有纪念碑城市得货贝+掠夺+100% ✓ |
| PLATI_TENTH | 阿克巴 | Akbar | 通配符政策槽位+1 ✓ |
| PLATI_THIRTEENTH | 明治天皇 | Meiji | 工业区/社区建在农场+300金币 ✓ |
| PLATI_FOURTEENTH | 凯末尔 | Ataturk | +400产能（3次）✓ |
| PLATI_FIFTEENTH | 海尔·塞拉西一世 | Haile Selassie | +2外交胜利点数 ✓ |
| PLATI_ALFRED_THE_GREAT | 阿尔弗雷德大帝 | Alfred the Great | 兵工厂相邻加成+海军免费晋升 ✓ |
| PLATI_DENG | 斯坎德培 | Skanderbeg | 击杀2格内敌方+恢复移动力 ✓ |
| PLATI_ISMAIL | 伊斯玛仪一世 | Ismail I | 黑暗/黄金时代效果 ✓ |
| PLATI_BISMARK | 奥托·冯·俾斯麦 | Otto von Bismark | 宗主权夺城邦+外交卡 ✓ |
| PLATI_ARBE | 洛伦佐·德·美第奇 | Lorenzo the Magnificent | 文艺复兴奇观巨作槽+送大艺术家 ✓ |
| PLATI_BEG | 兀鲁伯 | Ulug Beg | 每建成学院+200科技值 ✓ |
| PLATI_AKBAR | 儒略二世 | Julius II | 奇观+455产能 ✓ |
| PLATI_SOVEREIGN_FIRST | 路易十四 | Louis XIV | 市政广场+3巨作槽/雕塑200%文化值 ✓ |
| PLATI_SOVEREIGN_FRIDRIK_GREAT | 拜里米苏拉 | Parameswara | 城市+1攻击次数/港口商业中心+5% ✓ |
| PLATI_SOVEREIGN_ZAYED | 扎耶德 | Zayed bin Sultan Al Nahyan | 发电战略资源+20%金币 ✓ |
| PLATI_ELEVENTH | 李光耀 | Lee Kuan Yew | 大商人+1充能 ✓ |

### 8.3 文本与代码不符

以下条目经代码与中文本地化文本对照，发现 **文本描述与代码实现存在差异**：

#### 差异 #1: 普里特维·纳拉扬·沙阿 (PLATI_KOSEMI)

| 项目 | 内容 |
|------|------|
| **中文文本** (`gsct.1.xml`): | "近战单位+5战斗力。本文明在外国领土上战斗额外+3战斗力" |
| **英文文本** (`GreatSovereigns_Localisation.xml`): | "Melee units +5 Strength. Additional +3 Strength when fighting in foreign territory." |
| **代码实际效果**: | 近战+反骑兵单位+3战斗力 (`Amount=3`)，异大陆额外+3 (`Amount=3`) |
| **差异**: | 代码中基础加成为+3，文本声称+5。并且代码使用"异大陆"条件，文本使用"外国领土" |

**差异等级**: 中等 — 文本夸大了效果（+5 vs +3）

#### 差异 #2: 哈克汗二世 (PLATI_RBORGIA)

| 项目 | 内容 |
|------|------|
| **中文文本** (`gsct.1.xml`): | "建造奇观时提供180生产力。黄金时代非主流宗教+1宜居度" |
| **英文文本** (`GreatSovereigns_Localisation.xml`): | "Can build additional Church, Mosque, Synagogue, etc. in cities with Worship buildings." |
| **代码实际效果**: | 有崇拜建筑的城市可额外建造教堂/清真寺/犹太会堂等宗教建筑 |
| **差异**: | 中文文本为旧版效果（奇观产能+宜居度），英文文本已更新但仍不完整。代码实现为额外的宗教崇拜建筑能力 |

**差异等级**: 严重 — 中文汉化文本未更新，与代码效果完全不同

#### 差异 #3: 维陶塔斯 (PLATI_SOVEREIGN_GEDIMINAS)

| 项目 | 内容 |
|------|------|
| **中文文本** (`gsct.1.xml`): | "提供一个骑士。每回合+5忠诚度" |
| **英文文本** (`GreatSovereigns_Localisation.xml`): | "Provides a Knight. +5 Loyalty per turn." |
| **代码实际效果**: | 2充能（可创建2个骑士），城市+8忠诚度/回合 |
| **差异**: | 代码为2充能+8忠诚，文本为1充能+5忠诚 |

**差异等级**: 中等 — 数值差异（2充能 vs 1充能，+8忠诚 vs +5忠诚）

#### 差异 #4: 兰甘亨 (PLATI_SIXTEENTH)

| 项目 | 内容 |
|------|------|
| **中文文本** (`gsct.1.xml`): | "宗主每个城邦获得+1%食物和信仰。每种城邦类型额外+1宜居度" |
| **英文文本** (`GreatSovereigns_Localisation.xml`): | "+1% Food and Faith for each Suzerain City-State. +1 Amenity for each City-State type." |
| **代码实际效果**: | 每种宗主城邦类型+1人口 |
| **差异**: | 代码为+1人口，文本为+1%食物信仰+宜居度 |

**差异等级**: 严重 — 效果完全不同

#### 差异 #5: 玛丽亚·特蕾莎 (PLATI_TWELWTH)

| 项目 | 内容 |
|------|------|
| **中文文本** (`gsct.1.xml`): | "每个城邦特色改良为剧院广场+2相邻加成，为娱乐中心+2生产力" |
| **英文文本** (`GreatSovereigns_Localisation.xml`): | "+20% Great Artist and Great Musician points per City-State Unique Improvement." |
| **代码实际效果**: 每种城邦特色改良+20%大艺术家/大音乐家点数 |
| **差异**: | 中文文本为相邻加成效果，英文文本和代码为伟人点百分比加成 |

**差异等级**: 严重 — 效果完全不同，中文文本可能是旧版效果

---

## §9 结论

### 9.1 数据完整性

| 指标 | 数值 |
|------|------|
| 总伟人类型数 | 11（含2个Mod新增类别） |
| 原版+DLC伟人总数 | 219 |
| Mod新增伟人总数 | ~100 |
| 被删除的原版伟人 | 18（Sumus Magnus）+ 5（Delete Some Great Engineer），其中2人重复 |
| 重分类伟人 | 2（拿破仑+古斯塔夫，由General→Great Sovereigns） |
| 有完整中文文本的Mod条目 | ~80 |
| 有完整英文文本的Mod条目 | ~85 |
| 无任何本地化文本的条目 | 219（原版+DLC） |

### 9.2 文本一致性评估

| 类别 | 数量 | 一致 | 不一致 | N/A |
|------|------|:----:|:------:|:---:|
| Sumus Magnus (更多伟人) | ~65 | 63 | 0 | 3 |
| Great Sovereigns (大统治者) | 33 | 27 | 5 | 3 |
| Ancient Paragons (远古伟人) | 16 | 14 | 0 | 2 |
| 原版+DLC | 219 | 0 | 0 | 219 |
| **总计** | **~333** | **104** | **5** | **227** |

### 9.3 发现的文本与代码差异

| # | 条目 | 差异类型 | 严重程度 |
|---|------|----------|:--------:|
| 1 | 普里特维·纳拉扬·沙阿 (PLATI_KOSEMI) | 战斗力数值差异（+5 vs +3） | 中等 |
| 2 | 哈克汗二世 (PLATI_RBORGIA) | 中文文本为旧版，与代码完全不同 | 严重 |
| 3 | 维陶塔斯 (PLATI_SOVEREIGN_GEDIMINAS) | 充能次数和忠诚度数值差异 | 中等 |
| 4 | 兰甘亨 (PLATI_SIXTEENTH) | 效果完全不同 | 严重 |
| 5 | 玛丽亚·特蕾莎 (PLATI_TWELWTH) | 中文文本与代码效果完全不同 | 严重 |

### 9.4 建议

1. **为原版伟人补充本地化文本**: 建议将 Civ6 中文语言包加入工作区，以便对219个原版+DLC条目进行文本对照验证
2. **更新 Great Sovereigns 中文汉化**: 上述5处差异中有3处为严重差异，中文汉化 (`gsct.1.xml`) 可能基于旧版代码，需要更新
3. **补充 Ancient Paragons 英文文本**: 该Mod仅含中文文本，缺少英文名称，需要补充英文本地化
4. **PLATI_DESCARTES 和 PLATI_CICERO 缺少中文NAME**: 这两个 Sumus Magnus 大作家在 `smct.xml` 中仅有著作名的中文翻译，缺少人物名称的中文翻译

---

*报告生成完毕。所有数据基于代码静态分析推导，不包含运行时行为。*