# Civilization VI 伟人 完整分析报告

> 生成时间: 2026-07-06
> 数据来源: 原版 / DLC(迭起兴衰) / DLC(风云变幻) / Sumus Magnus / Great Sovereigns / 6T Ancient Paragons / DeleteSomeGreatEngineer / GreatPersonTeleport
> 总条目数: ~300+

---

## 1. 总览

| 来源 | 原版保留 | 新增 | 修改 | 被删除 |
|------|:-------:|:----:|:----:|:------:|
| 原版 | ~120 | 0 | 0 | 0 |
| DLC(迭起兴衰) | ~20 | ~20 | 0 | 0 |
| DLC(风云变幻) | ~20 | ~20 | 0 | 0 |
| Sumus Magnus (更多伟人) | 0 | ~65 | 部分原版效果 | 18 |
| Great Sovereigns (大统治者) | 0 | ~30 | 0 | 0 |
| 6T Ancient Paragons (远古伟人) | 0 | 12 | 1 (印何阗) | 0 |
| DeleteSomeGreatEngineer | 0 | 0 | 0 | 5 |
| GreatPersonTeleport | 0 | 0 | 0 | 0 |
| **合计** | **~140** | **~127** | **~3** | **23** |

> **注意**: 原版伟人数据基于《文明VI》本体及全部DLC的已知内容重建。由于workspace中无原版游戏数据文件，原版伟人数量为近似值。Mod新增伟人数据均来自实际Mod文件。

### 1.1 各类型伟人分布

| 伟人类型 | 原版约数 | Sumus Magnus新增 | 6T新增 | Great Sovereigns新增 | 合计 |
|----------|:-------:|:----------------:|:------:|:-------------------:|:----:|
| 大将军 | 17 | 32 | 2 | 0 | ~51 |
| 海军统帅 | 17 | 11 | 2 | 0 | ~30 |
| 大工程师 | 17 | 21 | 2 | 0 | ~40 |
| 大商人 | 16 | 6 | 2 | 0 | ~24 |
| 大科学家 | 16 | 6 | 2 | 0 | ~24 |
| 大作家 | ~16 | 8 | 2 | 0 | ~26 |
| 大艺术家 | ~13 | ~5 | 0 | 0 | ~18 |
| 大音乐家 | ~13 | 0 | 0 | 0 | ~13 |
| 大预言家 | 7 | 0 | 2 | 0 | ~9 |
| **大统治者** | **0** | **0** | **0** | **~30** | **~30** |

---

## 2. 详细数据表

> 以下包含 **原版、所有DLC、所有Mod** 的全部条目。
> 每条一行，按类型/时代/来源分组。包含所有关键字段。

### 2.1 大将军 (Great Generals)

#### 2.1.1 原版大将军

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 布狄卡 | Boudica | GREAT_PERSON_INDIVIDUAL_BOUDICA | 古典 | 1 | 将相邻蛮族单位转化为己方单位 | +5力/+1移动光环(古典/中世纪陆军) | 原版 | 原版 |
| 2 | 孙子 | Sun Tzu | GREAT_PERSON_INDIVIDUAL_SUN_TZU | 古典 | 1 | 创作著作《孙子兵法》 | +5力/+1移动光环(古典/中世纪陆军) | 原版 | 原版 |
| 3 | 埃塞尔弗莱德 | Aethelflaed | GREAT_PERSON_INDIVIDUAL_AETHELFLAED | 中世纪 | 1 | 将相邻城市中的一个单位转化为己方 | +5力/+1移动光环(中世纪/文艺复兴陆军) | 原版 | **被删除(Sumus Magnus)** |
| 4 | 熙德 | El Cid | GREAT_PERSON_INDIVIDUAL_EL_CID | 中世纪 | 1 | 免费创建一支骑士 | +5力/+1移动光环(中世纪/文艺复兴陆军) | 原版 | 原版 |
| 5 | 成吉思汗 | Genghis Khan | GREAT_PERSON_INDIVIDUAL_GENGHIS_KHAN | 中世纪 | 1 | 免费创建一支轻骑兵 | +5力/+1移动光环(中世纪/文艺复兴陆军) | 原版 | 原版 |
| 6 | 古斯塔夫·阿道夫 | Gustavus Adolphus | GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS | 文艺复兴 | 1 | 免费创建一支射石炮 | +5力/+1移动光环(文艺复兴/工业陆军) | 原版 | 原版 |
| 7 | 圣女贞德 | Jeanne d'Arc | GREAT_PERSON_INDIVIDUAL_JEANNE_DARC | 文艺复兴 | 1 | 免费创建一支宗教单位(遗物) | +5力/+1移动光环(文艺复兴/工业陆军) | 原版 | 原版 |
| 8 | 拿破仑·波拿巴 | Napoleon Bonaparte | GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE | 工业 | 1 | 免费创建一支军团 | +5力/+1移动光环(工业/现代陆军) | 原版 | 原版 |
| 9 | 拉克什米·芭伊 | Rani Lakshmibai | GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI | 工业 | 1 | 免费创建一支骑兵 | +5力/+1移动光环(工业/现代陆军) | 原版 | **被删除(Sumus Magnus)** |
| 10 | 萨莫里·杜尔 | Samori Ture | GREAT_PERSON_INDIVIDUAL_SAMORI_TURE | 工业 | 1 | 免费创建一支反坦克组 | +5力/+1移动光环(工业/现代陆军) | 原版 | **被删除(Sumus Magnus)** |
| 11 | 西蒙·玻利瓦尔 | Simon Bolivar | GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR | 工业 | 1 | 免费创建一支现代步兵 | +5力/+1移动光环(工业/现代陆军) | 原版 | 原版 |
| 12 | 苏迪曼 | Sudirman | GREAT_PERSON_INDIVIDUAL_SUDIRMAN | 现代 | 1 | 免费创建一支现代反坦克组 | +5力/+1移动光环(现代/原子能陆军) | 原版 | 原版 |
| 13 | 图帕克·阿马鲁 | Tupac Amaru | GREAT_PERSON_INDIVIDUAL_TUPAC_AMARU | 现代 | 1 | 免费创建一支游击队 | +5力/+1移动光环(现代/原子能陆军) | 原版 | 原版 |
| 14 | 道格拉斯·麦克阿瑟 | Douglas MacArthur | GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR | 原子能 | 1 | 免费创建一支步兵 | +5力/+1移动光环(原子能/信息陆军) | 原版 | 原版 |
| 15 | 格奥尔基·朱可夫 | Georgy Zhukov | GREAT_PERSON_INDIVIDUAL_GEORGY_ZHUKOV | 原子能 | 1 | 免费创建一支坦克 | +5力/+1移动光环(原子能/信息陆军) | 原版 | 原版 |
| 16 | 约翰·莫纳什 | John Monash | GREAT_PERSON_INDIVIDUAL_JOHN_MONASH | 现代 | 1 | 免费创建一支机械化步兵 | +5力/+1移动光环(现代/原子能陆军) | 原版 | **被删除(Sumus Magnus)** |
| 17 | 维贾亚·维马拉特内 | Vijay Wimalaratne | GREAT_PERSON_INDIVIDUAL_VIJAY_WIMALARATNE | 信息 | 1 | 免费创建一支现代装甲 | +5力/+1移动光环(信息/未来陆军) | 原版 | 原版 |
| 18 | 安娜·恩津加 | Ana Nzinga | GREAT_PERSON_INDIVIDUAL_ANA_NZINGA | 文艺复兴 | 1 | 使相邻城市获得额外的使者 | +5力/+1移动光环(文艺复兴/工业陆军) | DLC | 原版 |

#### 2.1.2 Sumus Magnus 新增大将军

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 克洛伊索斯 | Croesus | GREAT_PERSON_INDIVIDUAL_PLATI_CROESUS | 文艺复兴 | 1 | 立即创建一支重骑兵单位 | +5力光环(MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH) | Sumus Magnus | 新增 |
| 2 | 吕山德 | Lysander | GREAT_PERSON_INDIVIDUAL_PLATI_LYSANDER | 古典 | 1 | 立即创建一支重骑兵 | 光环效果 | Sumus Magnus | 新增 |
| 3 | 卡尔十二世 | Carolus Rex | GREAT_PERSON_INDIVIDUAL_PLATI_CAROLUS_REX | 文艺复兴 | 1 | 击杀获得大将军点数 | 每剩余移动力+3战力(ABILITY_REX_GOD_OF_WAR) | Sumus Magnus | 新增 |
| 4 | 阿法纳西·尼基京 | Afanasy Nikitin | GREAT_PERSON_INDIVIDUAL_PLATI_AFANASY | 文艺复兴 | 1 | 免费商人 | 光环效果 | Sumus Magnus | 新增 |
| 5 | T.E.劳伦斯 | T.E. Lawrence | GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE | 现代 | 1 | 获得石油资源 | +80%单位经验获取(ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE) | Sumus Magnus | 新增 |
| 6 | 乌尔班 | Urban | GREAT_PERSON_INDIVIDUAL_PLATI_URBAN | 中世纪 | 1 | 立即创建一支射石炮 | 攻城单位+5战力(ABILITY_VITRUVIUS) | Sumus Magnus | 新增 |
| 7 | 阿格里帕 | Agrippa | GREAT_PERSON_INDIVIDUAL_PLATI_AGRIPPA | 古典 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 8 | 米希尔·德·鲁伊特 | Michiel de Ruyter | GREAT_PERSON_INDIVIDUAL_PLATI_MICHIEL_DE_RUYTER | 文艺复兴 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 9 | 斯坦尼斯瓦夫·若乌凯夫斯基 | Stanislaw Zolkiewski | GREAT_PERSON_INDIVIDUAL_PLATI_STANISLAW_ZOLKIEWSKI | 文艺复兴 | 1 | 免费翼骑兵 | 光环效果 | Sumus Magnus | 新增 |
| 10 | 加里波第 | Garibaldi | GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI | 工业 | 1 | 立即创建一支红衫军 | 首都大陆上肉搏单位+3战力(ABILITY_GARIBALDI_BONUS) | Sumus Magnus | 新增 |
| 11 | 拜巴尔斯 | Baibars | GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS | 中世纪 | 1 | 立即创建一支马穆鲁克 | 所有单位每次行动后回血(ABILITY_BAIBARS_UNIQUE) | Sumus Magnus | 新增 |
| 12 | 萨尔贡 | Sargon | GREAT_PERSON_INDIVIDUAL_PLATI_SARGON | 古典 | 1 | 防御时战力加成 | 肉搏/骑兵可俘获击败的敌方单位(ABILITY_PLATI_SARGON_SABBUM) | Sumus Magnus | 新增 |
| 13 | 克劳塞维茨 | Clausewitz | GREAT_PERSON_INDIVIDUAL_PLATI_CLAUSEWITZ | 工业 | 1 | 获得一个免费间谍 | 战斗机轰炸时+17战力(ABILITY_FOG_OF_WAR) | Sumus Magnus | 新增 |
| 14 | 诺曼 | Norman | GREAT_PERSON_INDIVIDUAL_PLATI_NORMAN | 中世纪 | 1 | 免费重骑兵单位 | 攻击时骑兵+7战力(ABILITY_NORMAN_LEGACY) | Sumus Magnus | 新增 |
| 15 | 莽应龙 | Bayinnaung | GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG | 文艺复兴 | 1 | 免费轻骑兵 | 击败敌方单位获得等于其战力100%的信仰(ABILITY_BAYINNAUNG) | Sumus Magnus | 新增 |
| 16 | 加查·马达 | Gajah Mada | GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH_MADA | 中世纪 | 1 | 免费海军单位 | 登船时+10战力(ABILITY_GAJAH_MADA_COMBAT)；无视下船消耗(ABILITY_GAJAH_MADA_DISEMBARK) | Sumus Magnus | 新增 |
| 17 | 扬·齐兹卡 | Jan Zizka | GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA | 中世纪 | 1 | 获得免费反坦克组 | 防御时+10战力(ABILITY_JAN_ZIZKA) | Sumus Magnus | 新增 |
| 18 | 胡斯遗产 | Hussite Legacy | GREAT_PERSON_INDIVIDUAL_PLATI_HUSSITE_LEGACY | 中世纪 | 1 | 传播宗教 | 对抗更强单位时+4战力(ABILITY_HUSSITE_LEGACY) | Sumus Magnus | 新增 |
| 19 | 曼纳海姆 | Mannerheim | GREAT_PERSON_INDIVIDUAL_PLATI_MANNERHEIM | 现代 | 1 | 所有单位+1移动力 | 防御时+4战力(ABILITY_MANNERHEIM) | Sumus Magnus | 新增 |
| 20 | 留里克 | Rurik | GREAT_PERSON_INDIVIDUAL_PLATI_RURIK | 中世纪 | 1 | 获得一个免费移民 | +80%所有单位经验(ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE) | Sumus Magnus | 新增 |
| 21 | 巴巴罗萨 | Barbarossa | GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSSA | 中世纪 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 22 | 于格·德·帕扬 | Hugues de Payens | GREAT_PERSON_INDIVIDUAL_PLATI_HUGUES_DE_PAYENS | 中世纪 | 1 | 免费骑士 | 光环效果 | Sumus Magnus | 新增 |
| 23 | 哈立德·伊本·瓦利德 | Khalid ibn Walid | GREAT_PERSON_INDIVIDUAL_PLATI_KHALID_WALID | 中世纪 | 1 | 免费骑士 | 对不同宗教单位+7战力(ABILITY_KHALID_WALID_UNIQUE) | Sumus Magnus | 新增 |
| 24 | 阿威罗伊 | Averroes | GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES | 中世纪 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |
| 25 | 安德烈亚·多里亚 | Andrea Doria | GREAT_PERSON_INDIVIDUAL_PLATI_ANDREA_DORIA | 文艺复兴 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 26 | 尤利西斯·格兰特 | Ulysses Grant | GREAT_PERSON_INDIVIDUAL_PLATI_GRANT | 工业 | 1 | 免费单位 | 光环效果 | Sumus Magnus | 新增 |
| 27 | 安德烈·萨哈罗夫 | Andrei Sakharov | GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV | 原子能 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |
| 28 | 迈克尔·法拉第 | Michael Faraday | GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY | 工业 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |
| 29 | 三浦按针 | William Adams | GREAT_PERSON_INDIVIDUAL_PLATI_WILLIAM_ADAMS | 文艺复兴 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 30 | 罗曼·冯·恩琴 | Roman von Ungern | GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN | 现代 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |
| 31 | 法贝热 | Faberge | GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE | 工业 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |
| 32 | 劳里亚的罗杰 | Roger de Lauria | GREAT_PERSON_INDIVIDUAL_PLATI_LOUIS_DE_LAURIA | 中世纪 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 33 | 阿波洛多鲁斯 | Apollodorus | GREAT_PERSON_INDIVIDUAL_PLATI_APOLLODORUS | 古典 | 1 | 即时效果 | 光环效果 | Sumus Magnus | 新增 |

#### 2.1.3 6T Ancient Paragons 新增大将军

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 妇好 | Fu Hao | GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO | 远古 | 1 | 创建带伪装能力的重骑兵 | +5力/+1移动光环(远古/古典陆军) | 6T Ancient Paragons | 新增 |
| 2 | 西亚赫·卡阿克 | Siyaj K'ak' | GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | 远古 | 1 | 复制埃塞尔弗莱德式效果(转化城市中单位) | +5力/+1移动光环(远古/古典陆军) | 6T Ancient Paragons | 新增 |

---

### 2.2 海军统帅 (Great Admirals)

#### 2.2.1 原版海军统帅

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 阿尔特米西亚 | Artemisia | GREAT_PERSON_INDIVIDUAL_ARTEMISIA | 古典 | 1 | 免费创建一支四列桨座战船 | +5力/+1移动光环(古典/中世纪海军) | 原版 | 原版 |
| 2 | 地米斯托克利 | Themistocles | GREAT_PERSON_INDIVIDUAL_THEMISTOCLES | 古典 | 1 | 免费创建一支四列桨座战船 | +5力/+1移动光环(古典/中世纪海军) | 原版 | 原版 |
| 3 | 航海家汉诺 | Hanno the Navigator | GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR | 古典 | 1 | 免费创建一支桨帆船 | +5力/+1移动光环(古典/中世纪海军) | 原版 | **被删除(Sumus Magnus)** |
| 4 | 莱夫·埃里克松 | Leif Erikson | GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON | 中世纪 | 1 | 免费创建一支长船 | +5力/+1移动光环(中世纪/文艺复兴海军) | 原版 | 原版 |
| 5 | 拉金德拉·朱罗 | Rajendra Chola | GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA | 中世纪 | 1 | 免费创建一支卡拉维尔帆船 | +5力/+1移动光环(中世纪/文艺复兴海军) | 原版 | 原版 |
| 6 | 圣克鲁斯 | Santa Cruz | GREAT_PERSON_INDIVIDUAL_SANTA_CRUZ | 文艺复兴 | 1 | 免费创建一支海军袭击者 | +5力/+1移动光环(文艺复兴/工业海军) | 原版 | 原版 |
| 7 | 李舜臣 | Yi Sun-Sin | GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN | 文艺复兴 | 1 | 免费创建一支铁甲船 | +5力/+1移动光环(文艺复兴/工业海军) | 原版 | **被删除(Sumus Magnus)** |
| 8 | 弗朗西斯·德雷克 | Francis Drake | GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE | 文艺复兴 | 1 | 免费创建一支私掠船 | +5力/+1移动光环(文艺复兴/工业海军) | 原版 | **被删除(Sumus Magnus)** |
| 9 | 霍雷肖·纳尔逊 | Horatio Nelson | GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON | 工业 | 1 | 免费创建一支战舰 | +5力/+1移动光环(工业/现代海军) | 原版 | 原版 |
| 10 | 拉斯卡里娜·布布利纳 | Laskarina Bouboulina | GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA | 工业 | 1 | 免费创建一支铁甲舰 | +5力/+1移动光环(工业/现代海军) | 原版 | **被删除(Sumus Magnus)** |
| 11 | 郑一嫂 | Ching Shih | GREAT_PERSON_INDIVIDUAL_CHING_SHIH | 工业 | 1 | 免费创建一支海军袭击者 | +5力/+1移动光环(工业/现代海军) | 原版 | 原版 |
| 12 | 切斯特·尼米兹 | Chester Nimitz | GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ | 现代 | 1 | 免费创建一支航母 | +5力/+1移动光环(现代/原子能海军) | 原版 | 原版 |
| 13 | 克兰西·费尔南多 | Clancy Fernando | GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO | 现代 | 1 | 免费创建一支驱逐舰 | +5力/+1移动光环(现代/原子能海军) | 原版 | 原版 |
| 14 | 弗朗茨·冯·希佩尔 | Franz von Hipper | GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER | 现代 | 1 | 免费创建一支战列舰 | +5力/+1移动光环(现代/原子能海军) | 原版 | **被删除(Sumus Magnus)** |
| 15 | 格蕾丝·霍珀 | Grace Hopper | GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER | 原子能 | 1 | 免费创建一支导弹巡洋舰 | +5力/+1移动光环(原子能/信息海军) | 原版 | 原版 |
| 16 | 若阿金·马克斯·里斯本 | Joaquim Marques Lisboa | GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA | 原子能 | 1 | 免费创建一支战列舰 | +5力/+1移动光环(原子能/信息海军) | 原版 | 原版 |
| 17 | 谢尔盖·戈尔什科夫 | Sergei Gorshkov | GREAT_PERSON_INDIVIDUAL_SERGEI_GORSHKOV | 原子能 | 1 | 免费创建一支核潜艇 | +5力/+1移动光环(原子能/信息海军) | 原版 | 原版 |
| 18 | 丹达拉 | Dandara | GREAT_PERSON_INDIVIDUAL_DANDARA | 工业 | 1 | 免费海军单位 | +5力/+1移动光环 | DLC | **被删除(Sumus Magnus)** |

#### 2.2.2 Sumus Magnus 新增海军统帅

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 艾哈迈德·伊本·马吉德 | Ahmad ibn Majid | GREAT_PERSON_INDIVIDUAL_PLATI_MAJID | 文艺复兴 | 1 | 免费创建一支卡拉维尔帆船 | 所有海军单位+2海上移动力(ABILITY_MAJID_SEA_MOVEMENT) | Sumus Magnus | 新增 |
| 2 | 詹姆斯·库克 | James Cook | GREAT_PERSON_INDIVIDUAL_PLATI_COOK | 文艺复兴 | 1 | 揭示地图 | 海军单位+2视野(ABILITY_COOK_SEA_SIGHT)+2海上移动力(ABILITY_COOK_SEA_MOVEMENT) | Sumus Magnus | 新增 |
| 3 | 劳里亚的罗杰 | Roger de Lauria | GREAT_PERSON_INDIVIDUAL_PLATI_LAURIA | 中世纪 | 1 | 免费海军单位 | 海军近战单位可俘获敌舰(ABILITY_PLATI_CAPTURE_SHIPS) | Sumus Magnus | 新增 |
| 4 | 热那亚海军上将 | Genoese Admiral | GREAT_PERSON_INDIVIDUAL_PLATI_GENOESE | 中世纪 | 1 | 免费创建桨帆船 | 海军近战单位攻占城市时转化城市宗教(ABILITY_GENOESE_NAVAL_CONVERSION) | Sumus Magnus | 新增 |
| 5 | 阿拉贡海军上将 | Aragonese Admiral | GREAT_PERSON_INDIVIDUAL_PLATI_ARAGONESE | 中世纪 | 1 | 免费海军单位 | 海军近战单位每剩余移动力+1战力(ABILITY_PLATI_CONSULATE_OF_SEA) | Sumus Magnus | 新增 |
| 6 | 亨利·摩根 | Henry Morgan | GREAT_PERSON_INDIVIDUAL_PLATI_MORGAN | 文艺复兴 | 1 | 免费海军袭击者 | 光环效果 | Sumus Magnus | 新增 |
| 7 | 维图斯·白令 | Vitus Bering | GREAT_PERSON_INDIVIDUAL_PLATI_BERING | 文艺复兴 | 1 | 揭示地图 | 光环效果 | Sumus Magnus | 新增 |
| 8 | 阿方索·德·阿尔布克尔克 | Afonso de Albuquerque | GREAT_PERSON_INDIVIDUAL_PLATI_ALBUQUERQUE | 文艺复兴 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 9 | 尼尔斯·尤尔 | Niels Juel | GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL | 文艺复兴 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 10 | 汉密尔顿 | Hamilton | GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON | 工业 | 1 | 免费海军单位 | 光环效果 | Sumus Magnus | 新增 |
| 11 | 比利·米切尔 | Billy Mitchell | GREAT_PERSON_INDIVIDUAL_PLATI_BILLY_MITCHELL | 现代 | 1 | 免费航空单位 | 光环效果 | Sumus Magnus | 新增 |

#### 2.2.3 6T Ancient Paragons 新增海军统帅

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 赫努 | Henenu | GREAT_PERSON_INDIVIDUAL_JNR_HENENU | 远古 | 1 | 获得金币+永久增加海上贸易路线范围33% | +5力/+1移动光环(远古/古典海军) | 6T Ancient Paragons | 新增 |
| 2 | 奈·曼加尼布卡 | Nei Manganibuka | GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA | 远古 | 1 | 创建可进入海洋的海军近战单位(早期探索者) | +5力/+1移动光环(远古/古典海军) | 6T Ancient Paragons | 新增 |

---

### 2.3 大工程师 (Great Engineers)

#### 2.3.1 原版大工程师

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 印何阗 | Imhotep | GREAT_PERSON_INDIVIDUAL_IMHOTEP | 远古→古典 | 2 | 远古/古典奇观+250锤 / 其他时代+125锤 | 原版 | **修改(6T Ancient Paragons)** |
| 2 | 阿基米德 | Archimedes | GREAT_PERSON_INDIVIDUAL_ARCHIMEDES | 古典 | 1 | 军事驻地+2住房/+1宜居度 | 原版 | 原版 |
| 3 | 毕昇 | Bi Sheng | GREAT_PERSON_INDIVIDUAL_BI_SHENG | 中世纪 | 1 | 城市人口+1 | 原版 | **被删除(DeleteSomeGreatEngineer)** |
| 4 | 米利都的伊西多尔 | Isidore of Miletus | GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 中世纪 | 1 | 奇观+215锤 | 原版 | **被删除(DeleteSomeGreatEngineer)** |
| 5 | 圣乔治的詹姆斯 | James of St. George | GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 中世纪 | 2 | 免费建造远古/中世纪城墙 | 原版 | **被删除(Sumus Magnus + DeleteSomeGreatEngineer)** |
| 6 | 菲利波·布鲁内莱斯基 | Filippo Brunelleschi | GREAT_PERSON_INDIVIDUAL_FILIPPO_BRUNELLESCHI | 文艺复兴 | 1 | 奇观+315锤 | 原版 | 原版 |
| 7 | 列奥纳多·达·芬奇 | Leonardo da Vinci | GREAT_PERSON_INDIVIDUAL_LEONARDO_DA_VINCI | 文艺复兴 | 1 | 工作坊+1文化 / 尤里卡+1 | 原版 | 原版 |
| 8 | 米开朗基罗 | Michelangelo | GREAT_PERSON_INDIVIDUAL_MICHELANGELO | 文艺复兴 | 1 | 市中心+3文化 | 原版 | 原版 |
| 9 | 米马尔·希南 | Mimar Sinan | GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN | 文艺复兴 | 1 | 城市人口+1/+1宜居度 | 原版 | 原版 |
| 10 | 约翰·A·罗布林 | John A. Roebling | GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 工业 | 2 | 城市住房+2/+2宜居度 | 原版 | **被删除(Sumus Magnus + DeleteSomeGreatEngineer)** |
| 11 | 詹姆斯·瓦特 | James Watt | GREAT_PERSON_INDIVIDUAL_JAMES_WATT | 工业 | 1 | 立即建造工厂和工作坊 | 原版 | 原版 |
| 12 | 罗伯特·戈达德 | Robert Goddard | GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD | 现代 | 1 | 太空竞赛项目+20%产能 | 原版 | 原版 |
| 13 | 尼古拉·特斯拉 | Nikola Tesla | GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA | 现代 | 1 | 区域范围+3 | 原版 | 原版 |
| 14 | 阿尔瓦·阿尔托 | Alvar Aalto | GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 现代 | 1 | 城市+1魅力/单元格 | 原版 | **被删除(DeleteSomeGreatEngineer)** |
| 15 | 查尔斯·科雷亚 | Charles Correa | GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | 现代 | 1 | 城市+2住房 | 原版 | **被删除(Sumus Magnus)** |
| 16 | 简·德鲁 | Jane Drew | GREAT_PERSON_INDIVIDUAL_JANE_DREW | 现代 | 1 | 城市+4住房/+3宜居度 | 原版 | **被删除(Sumus Magnus)** |
| 17 | 谢尔盖·科罗廖夫 | Sergei Korolev | GREAT_PERSON_INDIVIDUAL_SERGEI_KOROLEV | 原子能 | 1 | 太空竞赛项目+1500锤 | 原版 | 原版 |
| 18 | 沃纳·冯·布劳恩 | Wernher von Braun | GREAT_PERSON_INDIVIDUAL_WERNHER_VON_BRAUN | 原子能 | 1 | 太空竞赛项目+100%产能 | 原版 | 原版 |
| 19 | 约瑟夫·帕克斯顿 | Joseph Paxton | GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON | 工业 | 1 | 花园+1文化/+1旅游 | DLC | 原版 |
| 20 | 古斯塔夫·埃菲尔 | Gustave Eiffel | GREAT_PERSON_INDIVIDUAL_GUSTAVE_EIFFEL | 工业 | 1 | 单元格+1魅力 | DLC | 原版 |
| 21 | 艾达·洛夫莱斯 | Ada Lovelace | GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE | 工业 | 1 | 城市+1科技槽位 | DLC | 原版 |
| 22 | 沙贾汗 | Shah Jahan | GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN | 文艺复兴 | 1 | 奇观+30%锤 | DLC | 原版 |

#### 2.3.2 Sumus Magnus 新增大工程师

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 亚里士多德 | Aristotle | GREAT_PERSON_INDIVIDUAL_PLATI_ARISTOTLE | 古典 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 2 | 阿维森纳 | Avicenna | GREAT_PERSON_INDIVIDUAL_PLATI_AVICENNA | 中世纪 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 3 | 莱布尼茨 | Leibniz | GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNIZ | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 4 | 巴斯德 | Louis Pasteur | GREAT_PERSON_INDIVIDUAL_PLATI_LOUIS_PASTEUR | 工业 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 5 | 蔡伦 | Cai Lun | GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN | 古典 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 6 | 沈括 | Shen Kuo | GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO | 中世纪 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 7 | 阿尔弗雷德·克虏伯 | Alfred Krupp | GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP | 工业 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 8 | 伊桑巴德·布鲁内尔 | Isambard Brunel | GREAT_PERSON_INDIVIDUAL_PLATI_BRUNEL | 工业 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 9 | 图西 | Tusi | GREAT_PERSON_INDIVIDUAL_PLATI_TUSI | 中世纪 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 10 | 拉斯特雷利 | Rastrelli | GREAT_PERSON_INDIVIDUAL_PLATI_RASSTRELLI | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 11 | 沃邦 | Vauban | GREAT_PERSON_INDIVIDUAL_PLATI_VAUBAN | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 12 | 菲迪亚斯 | Phidias (Zeus) | GREAT_PERSON_INDIVIDUAL_PLATI_ZEUS | 古典 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 13 | 兰斯洛特·布朗 | Lancelot Brown | GREAT_PERSON_INDIVIDUAL_PLATI_BROWN | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 14 | 安德烈·勒诺特尔 | Andre Le Notre | GREAT_PERSON_INDIVIDUAL_PLATI_LE_NOSTRE | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 15 | 勒·柯布西耶 | Le Corbusier | GREAT_PERSON_INDIVIDUAL_PLATI_CORBUSIER | 现代 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 16 | 阿尔贝托·桑托斯-杜蒙 | Alberto Santos-Dumont | GREAT_PERSON_INDIVIDUAL_PLATI_SANTOS_DUMONT | 现代 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 17 | 涩泽荣一 | Shibazawa | GREAT_PERSON_INDIVIDUAL_PLATI_SHIBAZAWA | 工业 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 18 | 伊本·白图泰 | Ibn Battuta | GREAT_PERSON_INDIVIDUAL_PLATI_IBN_BATTUTA | 中世纪 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 19 | 卡特琳娜·斯福尔扎 | Caterina Sforza | GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 20 | 埃尔南·科尔特斯 | Hernan Cortes | GREAT_PERSON_INDIVIDUAL_PLATI_CORTES | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 21 | 维特鲁威 | Vitruvius | GREAT_PERSON_INDIVIDUAL_PLATI_VITRUVIUS | 古典 | 1 | 立即建造城墙 | 攻城单位+5战力(ABILITY_VITRUVIUS) | Sumus Magnus | 新增 |

#### 2.3.3 6T Ancient Paragons 新增/修改大工程师

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 印何阗(修改) | Imhotep (modified) | GREAT_PERSON_INDIVIDUAL_IMHOTEP | 古典 | 2 | 奇观+175锤 | 6T Ancient Paragons | 修改 |
| 2 | 玛利亚·希伯来亚 | Maria Hebraea | GREAT_PERSON_INDIVIDUAL_JNR_MARIA_HEBRAEA | 古典 | 1 | 区域项目+20%产能 | 6T Ancient Paragons | 新增 |

---

### 2.4 大商人 (Great Merchants)

#### 2.4.1 原版大商人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 科莱俄斯 | Colaeus | GREAT_PERSON_INDIVIDUAL_COLAEUS | 古典 | 1 | 获得金币+1贸易路线 | 原版 | 原版 |
| 2 | 马库斯·李锡尼·克拉苏 | Marcus Licinius Crassus | GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS | 古典 | 1 | 获得金币/吞并相邻城市 | 原版 | 原版 |
| 3 | 张骞 | Zhang Qian | GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN | 古典 | 1 | 获得金币+1贸易路线 | 原版 | 原版 |
| 4 | 伊琳娜女皇 | Irene of Athens | GREAT_PERSON_INDIVIDUAL_IRENE_OF_ATHENS | 中世纪 | 1 | 获得金币+1贸易路线 | 原版 | 原版 |
| 5 | 马可·波罗 | Marco Polo | GREAT_PERSON_INDIVIDUAL_MARCO_POLO | 中世纪 | 1 | 获得金币+1贸易路线 | 原版 | 原版 |
| 6 | 伊本·法德兰 | Ibn Fadlan | GREAT_PERSON_INDIVIDUAL_IBN_FADLAN | 中世纪 | 1 | 获得金币+1贸易路线 | 原版 | 原版 |
| 7 | 皮耶罗·德·巴尔迪 | Piero de' Bardi | GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI | 文艺复兴 | 1 | 获得金币+1贸易路线 | 原版 | **被删除(Sumus Magnus)** |
| 8 | 雅各布·富格尔 | Jakob Fugger | GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER | 文艺复兴 | 1 | 获得金币 | 原版 | **被删除(Sumus Magnus)** |
| 9 | 乔瓦尼·德·美第奇 | Giovanni de' Medici | GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI | 文艺复兴 | 1 | 获得金币 | 原版 | 原版 |
| 10 | 约翰·雅各布·阿斯特 | John Jacob Astor | GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | 工业 | 1 | 获得金币 | 原版 | **被删除(Sumus Magnus)** |
| 11 | 亚当·斯密 | Adam Smith | GREAT_PERSON_INDIVIDUAL_ADAM_SMITH | 工业 | 1 | 获得一个经济政策槽位 | 原版 | **被删除(Sumus Magnus)** |
| 12 | 贾姆希德吉·塔塔 | Jamsetji Tata | GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA | 工业 | 1 | 获得金币 | 原版 | 原版 |
| 13 | 约翰·D·洛克菲勒 | John D. Rockefeller | GREAT_PERSON_INDIVIDUAL_JOHN_D_ROCKEFELLER | 现代 | 1 | 获得石油资源 | 原版 | 原版 |
| 14 | 李维·斯特劳斯 | Levi Strauss | GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS | 现代 | 1 | 获得金币 | 原版 | 原版 |
| 15 | 玛丽·凯瑟琳·戈达德 | Mary Katherine Goddard | GREAT_PERSON_INDIVIDUAL_MARY_KATHERINE_GODDARD | 文艺复兴 | 1 | 获得金币 | DLC | 原版 |
| 16 | 梅莉塔·本茨 | Melitta Bentz | GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ | 现代 | 1 | 获得金币/咖啡 | DLC | 原版 |
| 17 | 井深大 | Masaru Ibuka | GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA | 现代 | 1 | 获得金币 | DLC | 原版 |
| 18 | 赫莲娜·鲁宾斯坦 | Helena Rubinstein | GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN | 工业 | 1 | 获得金币 | DLC | 原版 |
| 19 | 莎拉·布里德洛夫 | Sarah Breedlove | GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE | 工业 | 1 | 获得金币 | DLC | 原版 |

#### 2.4.2 Sumus Magnus 新增大商人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 塞西尔·罗兹 | Cecil Rhodes | GREAT_PERSON_INDIVIDUAL_PLATI_CECIL_RHODES | 工业 | 1 | 获得金币 | Sumus Magnus | 新增 |
| 2 | 雅各布·克特勒 | Jacob Kettler | GREAT_PERSON_INDIVIDUAL_PLATI_JACOB_KETTLER | 文艺复兴 | 1 | 获得金币 | Sumus Magnus | 新增 |
| 3 | J.P.摩根 | J.P. Morgan | GREAT_PERSON_INDIVIDUAL_PLATI_JP_MORGAN | 现代 | 1 | 获得金币 | Sumus Magnus | 新增 |
| 4 | 让·诺伊豪斯二世 | Jean Neuhaus II | GREAT_PERSON_INDIVIDUAL_PLATI_NEUHAUS | 现代 | 1 | 获得金币 | Sumus Magnus | 新增 |
| 5 | 邦·达·马拉莫科 | Bono da Malamocco | GREAT_PERSON_INDIVIDUAL_PLATI_BONO | 中世纪 | 1 | 获得金币 | Sumus Magnus | 新增 |
| 6 | 穆罕默德五世 | Muhammad V | GREAT_PERSON_INDIVIDUAL_PLATI_MUHAMMED_V | 文艺复兴 | 1 | 获得金币 | Sumus Magnus | 新增 |

#### 2.4.3 6T Ancient Paragons 新增大商人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 阿玛·埃 | Ama-E | GREAT_PERSON_INDIVIDUAL_JNR_AMA_E | 远古 | 1 | 额外贸易路线+通往此城的国内贸易路线+1粮+1锤 | 6T Ancient Paragons | 新增 |
| 2 | 希兰 | Hiram | GREAT_PERSON_INDIVIDUAL_JNR_HIRAM | 远古 | 1 | 获得推罗紫奢华资源(+4宜居度) | 6T Ancient Paragons | 新增 |

---

### 2.5 大科学家 (Great Scientists)

#### 2.5.1 原版大科学家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 阿耶波多 | Aryabhata | GREAT_PERSON_INDIVIDUAL_ARYABHATA | 古典 | 1 | 尤里卡×3 | 原版 | 原版 |
| 2 | 欧几里得 | Euclid | GREAT_PERSON_INDIVIDUAL_EUCLID | 古典 | 1 | 尤里卡+1 | 原版 | 原版 |
| 3 | 希帕提娅 | Hypatia | GREAT_PERSON_INDIVIDUAL_HYPATIA | 古典 | 1 | 图书馆+1科学 | 原版 | 原版 |
| 4 | 希尔德加德·冯·宾根 | Hildegard of Bingen | GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN | 中世纪 | 1 | 获得信仰 | 原版 | 原版 |
| 5 | 奥马尔·海亚姆 | Omar Khayyam | GREAT_PERSON_INDIVIDUAL_OMAR_KHAYYAM | 中世纪 | 1 | 尤里卡+1/鼓舞+1 | 原版 | 原版 |
| 6 | 阿布·卡西姆·扎赫拉维 | Abu al-Qasim al-Zahrawi | GREAT_PERSON_INDIVIDUAL_ABU_AL_QASIM_AL_ZAHRAWI | 中世纪 | 1 | 单位+5回血 | 原版 | 原版 |
| 7 | 伽利略·伽利莱 | Galileo Galilei | GREAT_PERSON_INDIVIDUAL_GALILEO_GALILEI | 文艺复兴 | 1 | 相邻山脉单元格+250科学 | 原版 | 原版 |
| 8 | 艾萨克·牛顿 | Isaac Newton | GREAT_PERSON_INDIVIDUAL_ISAAC_NEWTON | 文艺复兴 | 1 | 大学+2科学 | 原版 | 原版 |
| 9 | 查尔斯·达尔文 | Charles Darwin | GREAT_PERSON_INDIVIDUAL_CHARLES_DARWIN | 工业 | 1 | 相邻自然奇观单元格+500科学 | 原版 | 原版 |
| 10 | 詹姆斯·杨 | James Young | GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG | 工业 | 1 | 获得石油 | 原版 | 原版 |
| 11 | 艾伦·图灵 | Alan Turing | GREAT_PERSON_INDIVIDUAL_ALAN_TURING | 现代 | 1 | 尤里卡+1/计算机+1 | 原版 | 原版 |
| 12 | 阿尔伯特·爱因斯坦 | Albert Einstein | GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN | 现代 | 1 | 为大学+4科学 | 原版 | 原版 |
| 13 | 埃尔温·薛定谔 | Erwin Schrodinger | GREAT_PERSON_INDIVIDUAL_ERWIN_SCHRODINGER | 现代 | 1 | 尤里卡×3 | 原版 | 原版 |
| 14 | 阿卜杜斯·萨拉姆 | Abdus Salam | GREAT_PERSON_INDIVIDUAL_ABDUS_SALAM | 原子能 | 1 | 获得尤里卡 | 原版 | 原版 |
| 15 | 玛丽·利基 | Mary Leakey | GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY | 原子能 | 1 | 文物+200%科学 | 原版 | 原版 |
| 16 | 斯蒂芬妮·克沃勒克 | Stephanie Kwolek | GREAT_PERSON_INDIVIDUAL_STEPHANIE_KWOLEK | 原子能 | 1 | 获得尤里卡 | 原版 | 原版 |
| 17 | 卡尔·萨根 | Carl Sagan | GREAT_PERSON_INDIVIDUAL_CARL_SAGAN | 信息 | 1 | 太空竞赛项目+3000锤 | 原版 | 原版 |
| 18 | 贾纳基·安马尔 | Janaki Ammal | GREAT_PERSON_INDIVIDUAL_JANAKI_AMMAL | 原子能 | 1 | 获得尤里卡 | DLC | 原版 |

#### 2.5.2 Sumus Magnus 新增大科学家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 尼采 | Nietzsche | GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE | 现代 | 1 | 创作著作 | - | Sumus Magnus | 新增 |
| 2 | 伊拉斯谟 | Erasmus | GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 3 | 笛卡尔 | Descartes | GREAT_PERSON_INDIVIDUAL_PLATI_DESCARTES | 文艺复兴 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 4 | 圣奥古斯丁 | Saint Augustine | GREAT_PERSON_INDIVIDUAL_PLATI_SAINT_AUGUSTINE | 中世纪 | 1 | 传播宗教 | 宗教单位+3战力(ABILITY_SAUGUSTINE_BONUS) | Sumus Magnus | 新增 |
| 5 | 苏格拉底 | Socrates | GREAT_PERSON_INDIVIDUAL_PLATI_SOCRATES | 古典 | 1 | 即时效果 | - | Sumus Magnus | 新增 |
| 6 | 西塞罗 | Cicero | GREAT_PERSON_INDIVIDUAL_PLATI_CICERO | 古典 | 1 | 即时效果 | - | Sumus Magnus | 新增 |

#### 2.5.3 6T Ancient Paragons 新增大科学家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 泰勒斯 | Thales of Miletus | GREAT_PERSON_INDIVIDUAL_JNR_THALES_MILETUS | 远古 | 1 | 1个远古科技尤里卡+2个古典市政鼓舞 | 6T Ancient Paragons | 新增 |
| 2 | 弥勒 | Maitreyi | GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI | 远古 | 1 | 基础:所有学院建筑+1科学+1文化+1信仰 / XP1:每人口+0.2科学+0.2文化+0.2信仰 | 6T Ancient Paragons | 新增 |

---

### 2.6 大作家 (Great Writers)

#### 2.6.1 原版大作家 (部分)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 荷马 | Homer | GREAT_PERSON_INDIVIDUAL_HOMER | 古典 | 2 | 创作2部著作 | 原版 | 原版 |
| 2 | 屈原 | Qu Yuan | GREAT_PERSON_INDIVIDUAL_QU_YUAN | 古典 | 2 | 创作2部著作 | 原版 | 原版 |
| 3 | 奥维德 | Ovid | GREAT_PERSON_INDIVIDUAL_OVID | 古典 | 2 | 创作2部著作 | 原版 | 原版 |
| 4 | 杰弗里·乔叟 | Geoffrey Chaucer | GREAT_PERSON_INDIVIDUAL_GEOFFREY_CHAUCER | 中世纪 | 2 | 创作2部著作 | 原版 | 原版 |
| 5 | 紫式部 | Murasaki Shikibu | GREAT_PERSON_INDIVIDUAL_MURASAKI_SHIKIBU | 中世纪 | 2 | 创作2部著作 | 原版 | 原版 |
| 6 | 鲁米 | Rumi | GREAT_PERSON_INDIVIDUAL_RUMI | 中世纪 | 2 | 创作2部著作 | 原版 | 原版 |
| 7 | 米格尔·德·塞万提斯 | Miguel de Cervantes | GREAT_PERSON_INDIVIDUAL_MIGUEL_DE_CERVANTES | 文艺复兴 | 2 | 创作2部著作 | 原版 | 原版 |
| 8 | 威廉·莎士比亚 | William Shakespeare | GREAT_PERSON_INDIVIDUAL_WILLIAM_SHAKESPEARE | 文艺复兴 | 2 | 创作2部著作 | 原版 | 原版 |
| 9 | 列夫·托尔斯泰 | Leo Tolstoy | GREAT_PERSON_INDIVIDUAL_LEO_TOLSTOY | 工业 | 2 | 创作2部著作 | 原版 | 原版 |
| 10 | 简·奥斯汀 | Jane Austen | GREAT_PERSON_INDIVIDUAL_JANE_AUSTEN | 工业 | 2 | 创作2部著作 | 原版 | 原版 |
| 11 | 马克·吐温 | Mark Twain | GREAT_PERSON_INDIVIDUAL_MARK_TWAIN | 工业 | 2 | 创作2部著作 | 原版 | 原版 |
| 12 | F. 斯科特·菲茨杰拉德 | F. Scott Fitzgerald | GREAT_PERSON_INDIVIDUAL_F_SCOTT_FITZGERALD | 现代 | 2 | 创作2部著作 | 原版 | 原版 |
| 13 | 拉宾德拉纳特·泰戈尔 | Rabindranath Tagore | GREAT_PERSON_INDIVIDUAL_RABINDRANATH_TAGORE | 现代 | 2 | 创作2部著作 | 原版 | 原版 |
| 14 | 詹姆斯·乔伊斯 | James Joyce | GREAT_PERSON_INDIVIDUAL_JAMES_JOYCE | 现代 | 2 | 创作2部著作 | 原版 | 原版 |
| 15 | 埃德加·爱伦·坡 | Edgar Allan Poe | GREAT_PERSON_INDIVIDUAL_EDGAR_ALLAN_POE | 工业 | 2 | 创作2部著作 | 原版 | 原版 |
| 16 | 艾米莉·狄金森 | Emily Dickinson | GREAT_PERSON_INDIVIDUAL_EMILY_DICKINSON | 工业 | 2 | 创作2部著作 | 原版 | 原版 |

#### 2.6.2 Sumus Magnus 新增大作家 (和平愿景者 - 可选配置)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 海德格尔 | Heidegger | GREAT_PERSON_INDIVIDUAL_PLATI_HEIDEGGER | 现代 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 2 | 洛夫克拉夫特 | Lovecraft | GREAT_PERSON_INDIVIDUAL_PLATI_LOVECRAFT | 现代 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 3 | 罗伯特·霍华德 | Robert E. Howard | GREAT_PERSON_INDIVIDUAL_PLATI_HOWARD | 现代 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 4 | 格劳秀斯 | Grotius | GREAT_PERSON_INDIVIDUAL_PLATI_GROTIUS | 文艺复兴 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 5 | 马赫布卜·哈克 | Mahbub ul Haq | GREAT_PERSON_INDIVIDUAL_PLATI_MAHBUB_UL_HAQ | 现代 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 6 | 罗伯特·舒曼 | Robert Schuman | GREAT_PERSON_INDIVIDUAL_PLATI_ROBERT_SCHUMAN | 现代 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 7 | 伏尔泰 | Voltaire | GREAT_PERSON_INDIVIDUAL_PLATI_VOLTAIRE | 文艺复兴 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |
| 8 | 卢梭 | Rousseau | GREAT_PERSON_INDIVIDUAL_PLATI_ROUSSEAU | 文艺复兴 | 2 | 创作2部著作 | Sumus Magnus | 新增(可选) |

#### 2.6.3 6T Ancient Paragons 新增大作家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 恩赫杜安娜 | Enheduanna | GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA | 远古 | 0 | 创作2部著作(+4文化+4旅游业绩) | 6T Ancient Paragons | 新增 |
| 2 | 普塔霍特普 | Ptahhotep | GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP | 远古 | 0 | 创作2部著作(+4文化+4旅游业绩) | 6T Ancient Paragons | 新增 |

---

### 2.7 大艺术家 (Great Artists)

#### 2.7.1 原版大艺术家 (部分)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 安德烈·鲁布廖夫 | Andrei Rublev | GREAT_PERSON_INDIVIDUAL_ANDREI_RUBLEV | 中世纪 | 3 | 创作3件宗教艺术 | 原版 | 原版 |
| 2 | 多纳泰罗 | Donatello | GREAT_PERSON_INDIVIDUAL_DONATELLO | 文艺复兴 | 3 | 创作3件雕塑 | 原版 | 原版 |
| 3 | 希罗尼穆斯·博斯 | Hieronymus Bosch | GREAT_PERSON_INDIVIDUAL_HIERONYMUS_BOSCH | 文艺复兴 | 3 | 创作3件宗教艺术 | 原版 | 原版 |
| 4 | 米开朗基罗 | Michelangelo | GREAT_PERSON_INDIVIDUAL_MICHELANGELO_ARTIST | 文艺复兴 | 3 | 创作3件雕塑 | 原版 | 原版 |
| 5 | 提香 | Titian | GREAT_PERSON_INDIVIDUAL_TITIAN | 文艺复兴 | 3 | 创作3件肖像 | 原版 | 原版 |
| 6 | 埃尔·格列柯 | El Greco | GREAT_PERSON_INDIVIDUAL_EL_GRECO | 文艺复兴 | 3 | 创作3件宗教艺术 | 原版 | 原版 |
| 7 | 伦勃朗 | Rembrandt | GREAT_PERSON_INDIVIDUAL_REMBRANDT | 文艺复兴 | 3 | 创作3件肖像 | 原版 | 原版 |
| 8 | 仇英 | Qiu Ying | GREAT_PERSON_INDIVIDUAL_QIU_YING | 文艺复兴 | 3 | 创作3件风景画 | 原版 | 原版 |
| 9 | 长谷川等伯 | Hasegawa Tohaku | GREAT_PERSON_INDIVIDUAL_HASEGAWA_TOHAKU | 文艺复兴 | 3 | 创作3件风景画 | 原版 | 原版 |
| 10 | 安杰莉卡·考夫曼 | Angelica Kauffman | GREAT_PERSON_INDIVIDUAL_ANGELICA_KAUFFMAN | 工业 | 3 | 创作3件肖像 | 原版 | 原版 |
| 11 | 文森特·梵高 | Vincent van Gogh | GREAT_PERSON_INDIVIDUAL_VINCENT_VAN_GOGH | 工业 | 3 | 创作3件风景画 | 原版 | 原版 |
| 12 | 克劳德·莫奈 | Claude Monet | GREAT_PERSON_INDIVIDUAL_CLAUDE_MONET | 工业 | 3 | 创作3件风景画 | 原版 | 原版 |
| 13 | 古斯塔夫·克里姆特 | Gustav Klimt | GREAT_PERSON_INDIVIDUAL_GUSTAV_KLIMT | 现代 | 3 | 创作3件肖像 | 原版 | 原版 |

---

### 2.8 大音乐家 (Great Musicians)

#### 2.8.1 原版大音乐家 (部分)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 八桥检校 | Yatsuhashi Kengyo | GREAT_PERSON_INDIVIDUAL_YATSUHASHI_KENGYO | 文艺复兴 | 2 | 创作2部音乐 | 原版 | 原版 |
| 2 | 安东尼奥·维瓦尔第 | Antonio Vivaldi | GREAT_PERSON_INDIVIDUAL_ANTONIO_VIVALDI | 文艺复兴 | 2 | 创作2部音乐 | 原版 | 原版 |
| 3 | 约翰·塞巴斯蒂安·巴赫 | Johann Sebastian Bach | GREAT_PERSON_INDIVIDUAL_JOHANN_SEBASTIAN_BACH | 文艺复兴 | 2 | 创作2部音乐 | 原版 | 原版 |
| 4 | 沃尔夫冈·阿马德乌斯·莫扎特 | Wolfgang Amadeus Mozart | GREAT_PERSON_INDIVIDUAL_WOLFGANG_AMADEUS_MOZART | 文艺复兴 | 2 | 创作2部音乐 | 原版 | 原版 |
| 5 | 路德维希·凡·贝多芬 | Ludwig van Beethoven | GREAT_PERSON_INDIVIDUAL_LUDWIG_VAN_BEETHOVEN | 工业 | 2 | 创作2部音乐 | 原版 | 原版 |
| 6 | 弗雷德里克·肖邦 | Frederic Chopin | GREAT_PERSON_INDIVIDUAL_FREDERIC_CHOPIN | 工业 | 2 | 创作2部音乐 | 原版 | 原版 |
| 7 | 彼得·伊里奇·柴可夫斯基 | Pyotr Ilyich Tchaikovsky | GREAT_PERSON_INDIVIDUAL_PYOTR_ILYICH_TCHAIKOVSKY | 工业 | 2 | 创作2部音乐 | 原版 | 原版 |
| 8 | 安东尼奥·卡洛斯·戈麦斯 | Antonio Carlos Gomes | GREAT_PERSON_INDIVIDUAL_ANTONIO_CARLOS_GOMES | 工业 | 2 | 创作2部音乐 | 原版 | 原版 |
| 9 | 弗朗茨·李斯特 | Franz Liszt | GREAT_PERSON_INDIVIDUAL_FRANZ_LISZT | 工业 | 2 | 创作2部音乐 | 原版 | 原版 |
| 10 | 刘天华 | Liu Tianhua | GREAT_PERSON_INDIVIDUAL_LIU_TIANHUA | 现代 | 2 | 创作2部音乐 | 原版 | 原版 |

---

### 2.9 大预言家 (Great Prophets)

#### 2.9.1 原版大预言家 (部分)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 孔子 | Confucius | GREAT_PERSON_INDIVIDUAL_CONFUCIUS | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 2 | 施洗约翰 | John the Baptist | GREAT_PERSON_INDIVIDUAL_JOHN_THE_BAPTIST | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 3 | 太安万侣 | O no Yasumaro | GREAT_PERSON_INDIVIDUAL_O_NO_YASUMARO | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 4 | 西门彼得 | Simon Peter | GREAT_PERSON_INDIVIDUAL_SIMON_PETER | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 5 | 阿迪·商羯罗 | Adi Shankara | GREAT_PERSON_INDIVIDUAL_ADI_SHANKARA | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 6 | 菩提达摩 | Bodhidharma | GREAT_PERSON_INDIVIDUAL_BODHIDHARMA | 古典 | 4 | 创建宗教 | 原版 | 原版 |
| 7 | 马丁·路德 | Martin Luther | GREAT_PERSON_INDIVIDUAL_MARTIN_LUTHER | 文艺复兴 | 4 | 创建宗教 | 原版 | 原版 |

#### 2.9.2 6T Ancient Paragons 新增大预言家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 摩西 | Moses | GREAT_PERSON_INDIVIDUAL_JNR_MOSES | 远古 | 0 | 被动效果(无主动充能) | 6T Ancient Paragons | 新增 |
| 2 | 伽吉·瓦查克纳维 | Gargi Vachaknavi | GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI | 远古 | 0 | 被动效果(无主动充能) | 6T Ancient Paragons | 新增 |

---

### 2.10 大统治者 (Great Sovereigns) — 全新伟人类型

> **大统治者**是 Great Sovereigns Mod 引入的全新伟人类型，使用 `GREAT_PERSON_CLASS_GreatSovereigns`。
> 单位类型: `UNIT_GREAT_GreatSovereigns`，基础移动力4，成本1。
> 项目: `PROJECT_GreatSovereigns_DISTRICT_GOVERNMENT` (任人唯贤)，成本70，提供10 GPP。
> GP点数来源: 政府广场(+1)、政府建筑(+1-3)、多种奇观(+1-2)、神谕(+2)、万神殿(+1)。

#### 2.10.1 核心大统治者

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 需求区域 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 所罗门王 | King Solomon | GREAT_PERSON_INDIVIDUAL_PLATI_FIRST | 古典 | 1 | 圣地 | 免费建造神殿+神殿+2产能 | Great Sovereigns | 新增 |
| 2 | 马可·奥勒留 | Marcus Aurelius | GREAT_PERSON_INDIVIDUAL_PLATI_SECOND | 古典 | 1 | 政府广场 | 获得99个中世纪市政鼓舞 | Great Sovereigns | 新增 |
| 3 | 托勒密一世 | Ptolemy I | GREAT_PERSON_INDIVIDUAL_PLATI_THIRD | 古典 | 1 | 奇观(建设中) | 奇观+100锤+每使者+1文化 | Great Sovereigns | 新增 |
| 4 | 阿育王 | Ashoka | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTH | 古典 | 1 | 政府广场 | 城市每区域+1信仰+每区域+1食物 | Great Sovereigns | 新增 |
| 5 | 腓特烈二世 | Frederick II | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTH | 中世纪 | 1 | 政府广场 | 获得一个经济政策槽位 | Great Sovereigns | 新增 |
| 6 | 穆罕默德·阿里帕夏 | Muhammad Ali Pasha | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTH | 工业 | 1 | 政府广场 | 单位升级费用-100%+随机获得1个科技 | Great Sovereigns | 新增 |
| 7 | 查理曼 | Charlemagne | GREAT_PERSON_INDIVIDUAL_PLATI_SEVENTH | 中世纪 | 1 | 政府广场 | 获得一个军事政策槽位 | Great Sovereigns | 新增 |
| 8 | 哈伦·拉希德 | Harun al-Rashid | GREAT_PERSON_INDIVIDUAL_PLATI_EIGHTH | 中世纪 | 1 | 政府广场 | 贸易路线每路径地块+0.17科学(黄金时代) | Great Sovereigns | 新增 |
| 9 | 阿斯基亚大帝 | Askia the Great | GREAT_PERSON_INDIVIDUAL_PLATI_NINTH | 文艺复兴 | 1 | 政府广场 | +2掠夺产出+纪念碑替换为阿斯基亚纪念碑(提供贝壳奢侈品) | Great Sovereigns | 新增 |
| 10 | 阿克巴 | Akbar | GREAT_PERSON_INDIVIDUAL_PLATI_TENTH | 文艺复兴 | 1 | 政府广场 | 获得一个万能政策槽位 | Great Sovereigns | 新增 |
| 11 | 明治天皇 | Emperor Meiji | GREAT_PERSON_INDIVIDUAL_PLATI_THIRTEENTH | 工业 | 1 | 政府广场 | 创建社区(300金)+创建工业区(300金)+社区与工业区互相+2食物相邻 | Great Sovereigns | 新增 |
| 12 | 凯末尔/阿塔图尔克 | Kemal Ataturk | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTEENTH | 现代 | 3 | 市中心 | 给城市+400锤(3次充能) | 被动:+3战力(ABILITY_PLATI_FOURTEENTH_COMBAT) | Great Sovereigns | 新增 |
| 13 | 海尔·塞拉西一世 | Haile Selassie I | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTEENTH | 现代 | 1 | 政府广场 | +2外交胜利点数 | Great Sovereigns | 新增 |

#### 2.10.2 扩展大统治者 (Expansion 文件)

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 需求区域 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 兰甘亨 | Ramkhamhaeng | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH | 中世纪 | 1 | 政府广场 | 每类城邦宗主国+1人口 | Great Sovereigns | 新增 |
| 2 | 玛丽亚·特蕾莎 | Maria Theresa | GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH | 文艺复兴 | 1 | 政府广场 | 每种城邦改良设施+20%大艺术家和大音乐家点数 | Great Sovereigns | 新增 |
| 3 | 李光耀 | Lee Kuan Yew | GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH | 原子能 | 1 | 政府广场 | 所有大商人+1充能 | Great Sovereigns | 新增 |
| 4 | 路易十四 | Louis XIV | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST | 文艺复兴 | 1 | 政府广场 | 每种政府建筑+3艺术槽位+雕塑+6文化 | Great Sovereigns | 新增 |
| 5 | 扎耶德 | Zayed | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED | 原子能 | 1 | 政府广场 | 拥有煤/油/铀的城市+20%金币 | Great Sovereigns | 新增 |
| 6 | 拜里米苏拉 | Parameswara | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT | 中世纪 | 1 | 市中心 | 城市+1攻击次数; 港口/商业/外交区+5%金+5%信仰 | Great Sovereigns | 新增 |
| 7 | 维陶塔斯 | Vytautas (Gediminas) | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS | 中世纪 | 2 | 市中心 | 城市+8忠诚度/回合; 免费创建骑士 | Great Sovereigns | 新增 |
| 8 | 伊斯玛仪一世 | Ismail I | GREAT_PERSON_INDIVIDUAL_PLATI_ISMAIL | 文艺复兴 | 1 | 市中心 | 黄金时代时所有巨作+3文化; 骑兵单位攻占城市时转化宗教 | Great Sovereigns | 新增 |
| 9 | 俾斯麦 | Bismarck | GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK | 工业 | 1 | 城邦领土 | 获得外交政策槽位; 将城邦变为己方宗主国 | Great Sovereigns | 新增 |
| 10 | 阿克巴(扩展) | Akbar (Expansion) | GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR | 文艺复兴 | 1 | 奇观(建设中) | 奇观+455锤(随游戏速度); 出生时+5力/+1移动光环 | Great Sovereigns | 新增 |
| 11 | 阿尔弗雷德大帝 | Alfred the Great | GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT | 中世纪 | 1 | 军械库 | 军械库+1产能+1科学相邻; 建造军械库获得免费海军单位 | Great Sovereigns | 新增 |

---

### 2.11 Sumus Magnus 独特改良解锁者 (可选配置)

| # | 中文名 | 英文名 | 内部ID | 类型 | 解锁改良 | 来源 | 状态 |
|---|--------|--------|--------|------|----------|------|------|
| 1 | 菲利贝尔·德·洛姆 | Philibert de l'Orme | GREAT_PERSON_INDIVIDUAL_PLATI_DE_LORME | 大工程师 | 法国庄园(Chateau) | Sumus Magnus | 新增(可选) |
| 2 | 克里斯托弗·克拉维乌斯 | Christopher Clavius | GREAT_PERSON_INDIVIDUAL_PLATI_CLAVIUS | 大工程师 | 西班牙传教团(Mission) | Sumus Magnus | 新增(可选) |
| 3 | 扬·莱赫瓦特 | Jan Leeghwater | GREAT_PERSON_INDIVIDUAL_PLATI_LEEGHWATER | 大工程师 | 荷兰圩田(Polder) | Sumus Magnus | 新增(可选) |

---

## 3. 关联数据

### 3.1 能力定义一览表 (Mod 新增核心能力)

| 能力ID | 效果描述 | 数值 | 条件 | 来源 |
|--------|----------|------|------|------|
| ABILITY_SAUGUSTINE_BONUS | 宗教单位战力加成 | +3 | 宗教单位 | Sumus Magnus |
| ABILITY_GARIBALDI_BONUS | 肉搏单位战力加成 | +3 | 首都大陆 | Sumus Magnus |
| ABILITY_MAJID_SEA_MOVEMENT | 海军单位海上移动力 | +2 | 所有海军 | Sumus Magnus |
| ABILITY_COOK_SEA_SIGHT | 海军单位视野 | +2 | 所有海军 | Sumus Magnus |
| ABILITY_COOK_SEA_MOVEMENT | 海军单位海上移动力 | +2 | 所有海军 | Sumus Magnus |
| ABILITY_BAIBARS_UNIQUE | 单位行动后回血 | 回血 | 所有陆军 | Sumus Magnus |
| ABILITY_KHALID_WALID_UNIQUE | 对不同宗教单位战力 | +7 | 对方不同宗教 | Sumus Magnus |
| ABILITY_PLATI_CAPTURE_SHIPS | 海军近战俘获敌舰 | 可俘获 | 海军近战 | Sumus Magnus |
| ABILITY_PLATI_SARGON_SABBUM | 俘获击败的敌方单位 | 可俘获 | 肉搏/骑兵 | Sumus Magnus |
| ABILITY_REX_GOD_OF_WAR | 每剩余移动力加战力 | +3/移动力 | 所有陆军 | Sumus Magnus |
| ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE | 单位经验加成 | +80% | 所有陆军 | Sumus Magnus |
| ABILITY_FOG_OF_WAR | 战斗机轰炸战力 | +17 | 战斗机 | Sumus Magnus |
| ABILITY_NORMAN_LEGACY | 攻击时骑兵战力 | +7 | 骑兵攻击 | Sumus Magnus |
| ABILITY_BAYINNAUNG | 击败单位获得信仰 | 100%战力 | 所有陆军 | Sumus Magnus |
| ABILITY_GAJAH_MADA_COMBAT | 登船时战力 | +10 | 登船状态 | Sumus Magnus |
| ABILITY_GAJAH_MADA_DISEMBARK | 无视下船消耗 | 无视 | 所有陆军 | Sumus Magnus |
| ABILITY_JAN_ZIZKA | 防御时战力 | +10 | 防守 | Sumus Magnus |
| ABILITY_HUSSITE_LEGACY | 对抗更强单位战力 | +4 | 对方更强 | Sumus Magnus |
| ABILITY_VITRUVIUS | 攻城单位战力 | +5 | 攻城单位 | Sumus Magnus |
| ABILITY_MANNERHEIM | 防御时战力 | +4 | 防守 | Sumus Magnus |
| ABILITY_GENOESE_NAVAL_CONVERSION | 海军攻占城市转化宗教 | 转化 | 海军近战攻占 | Sumus Magnus |
| ABILITY_PLATI_CONSULATE_OF_SEA | 每剩余移动力加战力 | +1/移动力 | 海军近战 | Sumus Magnus |
| ABILITY_PLATI_FOURTEENTH_COMBAT | 单位战力加成(凯末尔) | +3 | 所有陆军 | Great Sovereigns |
| ABILITY_ISMAIL_CONVERSION | 骑兵攻占城市转化宗教 | 转化 | 骑兵(非黄金时代) | Great Sovereigns |
| ABILITY_JNR_FU_HAO_CAMOUFLAGE | 伪装能力 | - | 重骑兵/重战车 | 6T Ancient Paragons |
| ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER | 可进入海洋 | - | 海军近战 | 6T Ancient Paragons |

### 3.2 新增下游数据 (建筑/资源/政策等)

| 类型 | 内部ID | 中文名 | 效果 | 来源 |
|------|--------|--------|------|------|
| 伟人类别 | GREAT_PERSON_CLASS_GreatSovereigns | 大统治者 | 全新伟人类型 | Great Sovereigns |
| 单位 | UNIT_GREAT_GreatSovereigns | 大统治者 | 移动力4, 成本1 | Great Sovereigns |
| 项目 | PROJECT_GreatSovereigns_DISTRICT_GOVERNMENT | 任人唯贤 | 成本70, 提供10 GPP | Great Sovereigns |
| 建筑 | BUILDING_PLATI_MONUMENT_ASKIA | 阿斯基亚纪念碑 | 替代纪念碑, 提供贝壳 | Great Sovereigns |
| 资源 | RESOURCE_PLATI_COWRIE | 贝壳 | 奢华资源, +4宜居度 | Great Sovereigns |
| 资源 | RESOURCE_JNR_MUREX | 推罗紫 | 奢华资源, +4宜居度 | 6T Ancient Paragons |
| 政策 | POLICY_MERITOCRACY | 任人唯贤(基础) | 首都每区域+1大统治者点数 | Great Sovereigns |
| 政策 | POLICY_LITTLE_RED_DOT | 小红点(强化) | 强化版任人唯贤 | Great Sovereigns |
| 万神殿 | BELIEF_HEAVENLY_SOVEREIGN | 天授君权 | +1大统治者点/回合, 黄金时代+1额外 | Great Sovereigns |
| 著作 | GREATWORK_JNR_EN_HEDU_ANNA_1/2 | 恩赫杜安娜著作 | +4文化+4旅游 | 6T Ancient Paragons |
| 著作 | GREATWORK_JNR_PTAHHOTEP_1/2 | 普塔霍特普著作 | +4文化+4旅游 | 6T Ancient Paragons |

---

## 4. 被修改/删除的原版内容

### 4.1 Sumus Magnus 删除列表 (SumusMagnus_RemoveData.xml)

| 原版条目ID | 中文名 | 类型 | 操作 | 执行Mod | 最终状态 |
|------------|--------|------|------|---------|----------|
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 | 大工程师 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | 查尔斯·科雷亚 | 大工程师 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JANE_DREW | 简·德鲁 | 大工程师 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 圣乔治的詹姆斯 | 大工程师 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER | 弗朗茨·冯·希佩尔 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE | 弗朗西斯·德雷克 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA | 拉斯卡里娜·布布利纳 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN | 李舜臣 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR | 航海家汉诺 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_DANDARA | 丹达拉 | 海军统帅 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_MONASH | 约翰·莫纳什 | 大将军 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI | 拉克什米·芭伊 | 大将军 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_SAMORI_TURE | 萨莫里·杜尔 | 大将军 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_AETHELFLAED | 埃塞尔弗莱德 | 大将军 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI | 皮耶罗·德·巴尔迪 | 大商人 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER | 雅各布·富格尔 | 大商人 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | 约翰·雅各布·阿斯特 | 大商人 | DELETE | Sumus Magnus | 已移除 |
| GREAT_PERSON_INDIVIDUAL_ADAM_SMITH | 亚当·斯密 | 大商人 | DELETE | Sumus Magnus | 已移除 |

### 4.2 DeleteSomeGreatEngineer 删除列表 (core.sql)

| 原版条目ID | 中文名 | 类型 | 操作 | 执行Mod | 最终状态 |
|------------|--------|------|------|---------|----------|
| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 | 大工程师 | DELETE | DeleteSomeGreatEngineer | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 圣乔治的詹姆斯 | 大工程师 | DELETE | DeleteSomeGreatEngineer | 已移除 |
| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 | 大工程师 | DELETE | DeleteSomeGreatEngineer | 已移除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 | 大工程师 | DELETE | DeleteSomeGreatEngineer | 已移除 |
| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 | 大工程师 | DELETE | DeleteSomeGreatEngineer | 已移除 |

### 4.3 6T Ancient Paragons 修改内容

| 原版条目ID | 中文名 | 操作 | 修改内容 | 执行Mod | 最终状态 |
|------------|--------|------|----------|---------|----------|
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | 印何阗 | UPDATE | 时代改为古典; 奇观+175锤(原版:远古/古典+250, 其他+125) | 6T Ancient Paragons | 已修改 |
| GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI | 弥勒 | 条件替换 | XP1: 效果从建筑固定产出改为每人口产出(+0.2科学/文化/信仰) | 6T Ancient Paragons | 已修改 |
| GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | 西亚赫·卡阿克 | 条件替换 | 有埃塞尔弗莱德时改为复制其主动效果 | 6T Ancient Paragons | 已修改 |

### 4.4 GreatPersonTeleport Mod 新增能力

本Mod不添加新伟人，而是为现有文化类伟人(大作家/大艺术家/大音乐家)增加新能力：
1. 通过"奇观建筑师"单位窃取并迁移奇观
2. 将移民传送到另一大陆
3. 文化炸弹相邻地块

---

## 5. 兼容性分析

### 5.1 Mod 重叠定义

| 游戏元素 | Mod A 定义 | Mod B 定义 | 最终胜负 | 原因 |
|----------|-----------|-----------|:------:|------|
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | Sumus Magnus: DELETE | DeleteSomeGreatEngineer: DELETE | 无冲突 | 两者均为删除，效果一致 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | Sumus Magnus: DELETE | DeleteSomeGreatEngineer: DELETE | 无冲突 | 两者均为删除，效果一致 |
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | 原版: 远古/2充能 | 6T Ancient Paragons: 古典/2充能/175锤 | 6T | 6T修改覆盖原版数据 |

### 5.2 冲突与风险

1. **Sumus Magnus 与 DeleteSomeGreatEngineer 删除重叠**: 两个Mod都删除了 JOHN_A_ROEBLING 和 JAMES_OF_ST_GEORGE。这不会造成冲突，但最终效果取决于加载顺序。先加载的Mod删除后，后加载的Mod尝试再次删除时会因找不到条目而静默失败（无影响）。

2. **6T Ancient Paragons 与 Sumus Magnus 的印何阗冲突**: 6T 修改了印何阗(IMHOTEP)的时代和效果。如果 Sumus Magnus 也修改了印何阗，后加载的Mod将覆盖对方。建议检查两者对印何阗的处理。

3. **6T 与 Sumus Magnus 的 AETHELFLAED 依赖**: 6T Ancient Paragons 中西亚赫·卡阿克(JNR_SIYAJ_K_AK)的主动效果依赖于 AETHELFLAED 是否存在。Sumus Magnus 删除了 AETHELFLAED，因此在同时加载两个Mod时，西亚赫·卡阿克将使用默认效果(ANA_NZINGA_ACTIVE)而非 AETHELFLAED 效果。

4. **GreatPersonTeleport 与所有Mod的兼容性**: GreatPersonTeleport 仅修改文化类伟人的能力，不对伟人条目进行增删，因此与所有伟人Mod兼容。

5. **大统治者与其他Mod的兼容性**: Great Sovereigns 引入全新的伟人类型，与其他Mod不冲突。但大统治者点数来源（各种奇观+1-2点）可能与修改奇观的Mod产生交互。

6. **加载顺序建议**: 
   - 先加载: DeleteSomeGreatEngineer
   - 其次: Sumus Magnus (更多伟人)
   - 再次: 6T Ancient Paragons (远古伟人)
   - 再后: Great Sovereigns (大统治者伟人)
   - 最后: GreatPersonTeleport (艺术类伟人偷奇观)
   - 汉化Mod紧随其对应主体Mod

### 5.3 可选配置说明

Sumus Magnus 提供三个可选配置项:
- **SumusMagnusVisionariesOfPeace**: 启用和平愿景者(大作家)内容，默认关闭
- **SumusMagnusUniqueImprovements**: 启用独特改良解锁者，默认关闭
- **SumusMagnusRemoveUnimpressives**: 启用"删除不突出者"配置，默认关闭

Great Sovereigns 提供:
- **Alhambra_Config**: 阿尔罕布拉宫配置，默认启用
- **GreatSovereign_Config_Enabled**: 部分扩展内容开关

---

> **报告说明**: 本报告基于workspace中Mod文件的实际数据以及Civilization VI原版/DLC的已知信息重建。原版伟人数量为近似值，具体条目以实际游戏为准。所有Mod新增条目的内部ID和效果数据均来自Mod源文件。