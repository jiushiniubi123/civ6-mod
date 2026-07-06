# Civilization VI 伟人 完整分析报告

> 生成时间：2026-07-06
> 分析范围：/workspace/MOD/伟人/ 及跨目录引用

---

## 1. 总览

### 1.1 数据来源与统计

| 来源 | Mod名称 | 新增数 | 修改数 | 删除数 |
|------|---------|--------|--------|--------|
| 2448605286 | 更多伟人 (Sumus Magnus) | 80+ | 17 (删除原版) | 0 |
| 2973448849 | 大统治者伟人 (Great Sovereigns) | 32 | 0 | 0 |
| 3085812151 | 远古伟人 (Ancient Great People) | 14 | 1 (印何阗移时代) | 0 |
| 3334907290 | 删除部分工程师 | 0 | 0 | 5 |
| 2778428759 | Belief Rework 万神殿与信条重做 | 1 | 0 | 0 |
| 2921308654 | EWHO 奇观历史拥有者加成 | 1 | 0 | 0 |

### 1.2 伟人类型分布

| 伟人类别 | 更多伟人 | 大统治者 | 远古伟人 | 其他 | 总计 |
|----------|---------|---------|---------|------|------|
| 大军事家 (General) | 18 | 0 | 2 | 0 | 20 |
| 海军上将 (Admiral) | 12 | 0 | 2 | 0 | 14 |
| 大商人 (Merchant) | 15 | 0 | 2 | 0 | 17 |
| 大工程师 (Engineer) | 15 | 0 | 2 | 2 | 19 |
| 大科学家 (Scientist) | 10 | 0 | 2 | 0 | 12 |
| 大作家 (Writer) | 8 | 0 | 2 | 0 | 10 |
| 大艺术家/画家 (Artist) | 3 | 0 | 0 | 0 | 3 |
| 大统治者 (GreatSovereign) | 0 | 32 | 0 | 0 | 32 |
| 神圣建筑师 (Divine Architect) | 0 | 0 | 0 | 1 | 1 |
| **总计** | **81+** | **32** | **14** | **3** | **130+** |

### 1.3 时代分布

| 时代 | 更多伟人 | 大统治者 | 远古伟人 | 其他 |
|------|---------|---------|---------|------|
| 远古 (Ancient) | 2 | 0 | 12 | 1 |
| 古典 (Classical) | 4 | 4 | 2 | 0 |
| 中世纪 (Medieval) | 15 | 9 | 0 | 0 |
| 文艺复兴 (Renaissance) | 12 | 8 | 0 | 1 |
| 工业 (Industrial) | 8 | 4 | 0 | 0 |
| 现代 (Modern) | 3 | 2 | 0 | 0 |
| 原子 (Atomic) | 2 | 4 | 0 | 0 |
| 信息 (Information) | 2 | 0 | 0 | 0 |

---

## 2. 详细数据表

### 2.1 更多伟人 (Sumus Magnus) - Mod 2448605286

**Mod信息**：作者 Plati，ID `5a18be19-df93-4322-a3d5-35c5b5087b36`
**配置选项**：SumusMagnusVisionariesOfPeace（和平梦想者）、SumusMagnusUniqueImprovements（文明特色改良）、SumusMagnusRemoveUnimpressives（移除废物伟人）

#### 2.1.1 被删除的原版伟人 (SumusMagnus_RemoveData.xml)

当配置选项 `SumusMagnusRemoveUnimpressives` 启用时删除以下17位原版伟人：

| 内部ID | 英文名 | 伟人类别 |
|--------|--------|----------|
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | John A. Roebling | 大工程师 |
| GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | Charles Correa | 大工程师 |
| GREAT_PERSON_INDIVIDUAL_JANE_DREW | Jane Drew | 大工程师 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | James of St. George | 大工程师 |
| GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER | Franz von Hipper | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE | Francis Drake | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA | Laskarina Bouboulina | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN | Yi Sun-sin | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR | Hanno the Navigator | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_DANDARA | Dandara | 海军上将 |
| GREAT_PERSON_INDIVIDUAL_JOHN_MONASH | John Monash | 大军事家 |
| GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI | Rani Lakshmibai | 大军事家 |
| GREAT_PERSON_INDIVIDUAL_SAMORI_TURE | Samori Ture | 大军事家 |
| GREAT_PERSON_INDIVIDUAL_AETHELFLAED | Aethelflaed | 大军事家 |
| GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI | Piero de' Bardi | 大商人 |
| GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER | Jakob Fugger | 大商人 |
| GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | John Jacob Astor | 大商人 |
| GREAT_PERSON_INDIVIDUAL_ADAM_SMITH | Adam Smith | 大商人 |

#### 2.1.2 新增伟人详细数据

**大军事家 (General)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 阿拉伯的劳伦斯 | Lawrence of Arabia | PLATI_LAWRENCE | 工业 | 1 | 解放城市后10回合内+20%文化产出 | 无 |
| 卡尔·古斯塔夫·埃米尔·曼纳海姆 | Carl Gustaf Emil Mannerheim | PLATI_SARGON | 现代 | 1 | 所有陆地单位防守时+4战斗力 | 所有陆地单位获得ABILITY_MANNERHEIM（防守+4战斗力） |
| 卡尔十二世 | Charles XII | PLATI_REX | 文艺复兴 | 1 | 可训练卡洛琳步兵（Carolean） | 所有陆地单位获得ABILITY_REX_GOD_OF_WAR（每点未使用移动力+3战斗力） |
| 留里克大公 | Rurik | PLATI_RURIK | 中世纪 | 1 | 获得1个开拓者和1个狂暴武士（Berserker），经验+80% | 所有陆地单位获得ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE（经验+80%） |
| 加查·马达 | Gajah Mada | PLATI_GAJAH | 文艺复兴 | 1 | 陆地单位上船+10战斗力，上下船不消耗移动力；获得胡椒和肉豆蔻奢侈资源 | 所有陆地单位获得ABILITY_GAJAH_MADA_COMBAT（上船+10战斗力）和ABILITY_GAJAH_MADA_DISEMBARK（无视上岸惩罚） |
| 罗曼·冯·恩琴 | Roman von Ungern-Sternberg | PLATI_UNGERN | 工业 | 1 | 创建5个怯薛（Keshig） | 无 |
| 扬·杰式卡 | Jan Žižka | PLATI_JAN_ZIZKA | 中世纪 | 1 | 与更高基础战斗力单位作战时+4战斗力 | 所有陆地单位获得ABILITY_JAN_ZIZKA（vs更高力单位+10战斗力）和ABILITY_HUSSITE_LEGACY（vs更强单位+4战斗力） |
| 朱塞佩·加里波第 | Giuseppe Garibaldi | PLATI_GARIBALDI | 工业 | 1 | 所有近战单位在首都大陆+3战斗力 | 所有近战单位获得ABILITY_GARIBALDI_BONUS（首都大陆+3战斗力） |
| 拜伯尔斯 | Baibars | PLATI_BAIBARS | 中世纪 | 1 | 受伤减益-20%，每回合结束恢复生命 | 所有陆地单位获得ABILITY_BAIBARS_UNIQUE（每回合恢复生命） |
| 卡泰丽娜·斯福尔扎 | Caterina Sforza | PLATI_SFORZA | 文艺复兴 | 1 | 立即获得300文化值 | 无 |
| 埃尔南·科尔特斯 | Hernán Cortés | PLATI_SUAREZ | 文艺复兴 | 1 | 创建1个征服者（Conquistador）单位，击败敌人可俘获 | 所有近战骑兵单位获得ABILITY_PLATI_SARGON_SABBUM（击败敌人可俘获） |
| 斯坦尼斯瓦夫·若乌凯夫斯基 | Stanisław Żółkiewski | PLATI_LIONHEART | 文艺复兴 | 1 | 可训练翼骑兵（Winged Hussar） | 所有骑兵单位获得ABILITY_NORMAN_LEGACY（攻击时+7战斗力） |
| 于格·德·帕扬 | Hugues de Payens | PLATI_BAYINNAUNG | 中世纪 | 1 | 解锁圣殿金库建筑（金币=信仰产出10%），击杀敌人获得信仰（击杀力的100%转化为信仰） | 所有陆地单位获得ABILITY_BAYINNAUNG（击杀敌人获得信仰=100%战斗力） |
| 哈立德·本·瓦利德 | Khalid ibn al-Walid | PLATI_SUNDIATA | 中世纪 | 1 | 立即获得200信仰值 | 所有陆地单位获得ABILITY_KHALID_WALID_UNIQUE（与异教单位作战+7战斗力） |
| 威廉·米切尔 | William Mitchell | PLATI_TOKUGAWA | 现代 | 1 | 机场建成时获得1个战斗机单位 | 所有战斗机单位获得ABILITY_FOG_OF_WAR（攻击区域时无远程惩罚，+17战斗力） |
| 三浦按进（威廉·亚当斯） | William Adams | PLATI_TUSI | 文艺复兴 | 1 | 所有政体外交通配符槽位+1 | 无 |

**海军上将 (Admiral)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 阿格里帕 | Agrippa | PLATI_AGRIPPA | 古典 | 1 | 建造奇观提供245生产力 | 无 |
| 米希尔·德·鲁伊特 | Michiel de Ruyter | PLATI_HENRY | 文艺复兴 | 1 | 选定城市每回合获得+1额外远程攻击 | 无 |
| 拉格纳·洛德布罗克 | Ragnar Lodbrok | PLATI_LODBROK | 中世纪 | 1 | 掠夺收益翻倍 | 海军近战单位获得ABILITY_PLATI_CAPTURE_SHIPS（可俘获敌方船只） |
| 巴巴罗萨·海雷丁 | Barbarossa Hayreddin | PLATI_BARBAROSA | 文艺复兴 | 1 | 可训练巴巴里海盗（Barbary Corsair） | 无 |
| 安德烈亚·多里亚 | Andrea Doria | PLATI_NIELS_JUEL | 文艺复兴 | 1 | 海军征服城市自动转化宗教 | 海军近战单位获得ABILITY_GENOESE_NAVAL_CONVERSION（征服城市转化宗教） |
| 艾哈迈德·本·马吉德 | Ahmad ibn Majid | PLATI_MAJID | 文艺复兴 | 1 | 所有海军单位+2移动力 | 所有海军单位获得ABILITY_MAJID_SEA_MOVEMENT（+2移动力） |
| 亨利·摩根 | Henry Morgan | PLATI_MORGAN | 文艺复兴 | 1 | 获得1个总督点 | 无 |
| 维图斯·约纳森·白令 | Vitus Bering | PLATI_VITUS | 文艺复兴 | 1 | 冻土/雪地地块为港口提供+1相邻加成 | 无 |
| 阿方索·德·阿尔布克尔克 | Afonso de Albuquerque | PLATI_COOK | 文艺复兴 | 1 | 获得肉豆蔻奢侈资源 | 所有海军单位获得ABILITY_COOK_SEA_SIGHT（+2视野）和ABILITY_COOK_SEA_MOVEMENT（+2移动力） |
| 劳里亚的罗杰 | Roger of Lauria | PLATI_ARAGONESE | 中世纪 | 1 | 所有海军单位每点未使用移动力+1战斗力 | 所有海军近战单位获得ABILITY_PLATI_CONSULATE_OF_SEA（每点未使用移动力+1战斗力） |

**大商人 (Merchant)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 克罗索斯 | Croesus | PLATI_CROESUS | 古典 | 1 | 国库金币翻倍 | 无 |
| 塞西尔·罗兹 | Cecil Rhodes | PLATI_CECIL | 工业 | 1 | 可训练红衫军（Redcoat），异大陆有总督的城市+20%金币 | 无 |
| 吉恩·诺伊豪斯二世 | Jean Neuhaus II | PLATI_NESTLE | 工业 | 1 | 解锁巧克力工厂（Chocolaterie），提供果仁糖（Praline）奢侈资源（+4宜居度） | 无 |
| 约翰·皮尔庞特·摩根 | J.P. Morgan | PLATI_BANKER | 工业 | 1 | 每个银行建筑+1外交胜利点数 | 无 |
| 阿发纳西·尼基丁 | Afanasy Nikitin | PLATI_AFANASIY | 文艺复兴 | 1 | 首都获得1份奢侈资源 | 无 |
| 雅各布·凯特勒 | Jacob Kettler | PLATI_JACOBKETTLER | 文艺复兴 | 1 | 港口提供等同于相邻加成的生产力 | 无 |
| 伊本·白图泰 | Ibn Battuta | PLATI_IBNBATTUTA | 中世纪 | 1 | 每条贸易路线每4格+1信仰 | 无 |
| 涩泽荣一 | Eiichi Shibusawa | PLATI_COLBERT | 工业 | 1 | 每种发电战略资源为改良奢侈品提供+1宜居度 | 无 |
| 亚历山大·汉密尔顿 | Alexander Hamilton | PLATI_HAMILTON | 工业 | 1 | 所有政体经济政策槽位+1 | 无 |
| 彼得·卡尔·法贝热 | Peter Carl Fabergé | PLATI_FABERGE | 工业 | 1 | 获得2份法贝热彩蛋奢侈资源（Faberge Eggs，+5宜居度） | 无 |
| 让-雅克·罗素 | Jean-Jacques Rousseau | PLATI_RAILLORD | 文艺复兴 | 1 | +1外交胜利点数 | 无 |
| 马拉莫科的波诺 | Bono of Malamocco | PLATI_VENETIAN_SMUGGLER | 中世纪 | 1 | 获得1个遗物，+1商路容量 | 无 |

**大工程师 (Engineer)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 大马士革的阿波罗多洛斯 | Apollodorus of Damascus | PLATI_APOLLODRO | 古典 | 1 | 每个区域+1生产力+1文化 | 无 |
| 乌尔班 | Urban | PLATI_URBAN | 中世纪 | 1 | 创建2个带1次免费晋升的射石炮（Bombard） | 无 |
| 格拉纳达的穆罕默德五世 | Muhammad V of Granada | PLATI_AL_AHMAR | 中世纪 | 1 | 宫殿+3巨作槽位（遗物/文物/雕塑），宗教艺术+4信仰 | 无 |
| 伊桑巴德·金德姆·布鲁内尔 | Isambard Kingdom Brunel | PLATI_ISAMBARD | 工业 | 1 | 每种专业化区域+1%生产力 | 无 |
| 阿尔弗雷德·克虏伯 | Alfred Krupp | PLATI_KRUPP | 工业 | 1 | 建造攻城单位+25%生产力 | 无 |
| 阿尔贝托·桑托斯·杜蒙 | Alberto Santos-Dumont | PLATI_ELIZABETH_WILBRAHAM | 工业 | 1 | 航空港从相邻区域获得+2生产力+2文化 | 无 |
| 塞巴斯蒂安·勒普雷斯特雷·德·沃邦 | Sébastien Le Prestre de Vauban | PLATI_DAHLBERG | 文艺复兴 | 1 | 军事工程师+堡垒为工业区提供+1相邻加成 | 无 |
| 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | PLATI_CURIE | 现代 | 1 | 展阁/公馆/市政广场建筑+4文化 | 无 |
| 维特鲁威 | Vitruvius | PLATI_ZEPPELIN | 古典 | 1 | 触发工程学和军事工程学尤里卡，攻城单位+5战斗力 | 攻城单位获得ABILITY_VITRUVIUS（+5战斗力） |
| 菲迪亚斯 | Phidias | PLATI_ALI_MASHADDI | 古典 | 1 | 所有古典奇观获得巨作槽位（遗物/文物/雕塑各1个） | 无 |
| 兰斯洛特·布朗 | Lancelot "Capability" Brown | PLATI_VIIKTOR_VASNETSOV | 工业 | 1 | 相邻市立公园的市中心+2文化 | 无 |
| 安德烈·勒诺特尔 | André Le Nôtre | PLATI_PICASSO | 文艺复兴 | 1 | （大工程师，具体效果待查） | 无 |

**大科学家 (Scientist)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 伊本·西那 | Ibn Sina | PLATI_SAUGUSTINE | 中世纪 | 1 | 获得1个随机中世纪科技尤里卡 | 所有宗教单位获得ABILITY_SAUGUSTINE_BONUS（+3宗教战斗力） |
| 伊拉斯谟 | Erasmus | PLATI_ERASMUS | 文艺复兴 | 1 | 非战争状态下每个大学+1外交胜利点数，获得1个随机文艺复兴鼓舞 | 无 |
| 路易·巴斯德 | Louis Pasteur | PLATI_PASTEUR | 工业 | 1 | 所有城市+20%余粮，触发卫生设备尤里卡 | 无 |
| 迈克尔·法拉第 | Michael Faraday | PLATI_FARADAY | 工业 | 1 | 每回合+2电力，获得1个随机工业时代尤里卡 | 无 |
| 安德烈·萨哈罗夫 | Andrei Sakharov | PLATI_SAKHAROV | 原子 | 1 | +2外交胜利点数，获得随机原子/信息时代尤里卡 | 无 |
| 蔡伦 | Cai Lun | PLATI_CAI_LUN | 古典 | 1 | 解锁造纸坊建筑（Paper Maker，+1科技+2金币） | 无 |
| 沈括 | Shen Kuo | PLATI_SHEN_KUO | 中世纪 | 1 | 学院区域提供等同于相邻加成的生产力 | 无 |
| 伊本·路世德 | Ibn Rushd (Averroes) | PLATI_AVERROES | 中世纪 | 1 | 黄金时代下每本著作+1科技+2信仰 | 无 |
| 伏尔泰 | Voltaire | PLATI_LEIBNITZ | 文艺复兴 | 1 | +1外交胜利点数 | 无 |
| 胡果·格劳秀斯 | Hugo Grotius | PLATI_LEIZU | 文艺复兴 | 1 | +1外交胜利点数 | 无 |

**大作家 (Writer)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 著作1 | 著作2 |
|--------|--------|--------|------|------|-------|-------|
| 弗里德里希·尼采 | Friedrich Nietzsche | PLATI_NIETZSCHE | 工业 | 0 | 《查拉图斯特拉如是说》 | 《权力意志论》 |
| 希波的奥古斯丁 | Augustine of Hippo | PLATI_HOBBES | 古典 | 0 | 《忏悔录》 | 《上帝之城》 |
| 马丁·海德格尔 | Martin Heidegger | PLATI_HEIDEGGER | 现代 | 0 | 《存在与时间》 | 《诗·语言·思》 |
| 霍华德·菲利普·洛夫克拉夫特 | H.P. Lovecraft | PLATI_LOVECRAFT | 现代 | 0 | 《克苏鲁的呼唤》 | 《印斯茅斯之影》 |
| 罗伯特·欧文·霍华德 | Robert E. Howard | PLATI_RHOWARD | 工业 | 0 | 《野蛮人柯南》 | 《所罗门·凯恩》 |
| 赫布卜·乌·哈格 | Mahbub ul Haq | PLATI_MAHBUB | 原子 | 0 | +1外交胜利点数 | — |
| 罗伯特·舒曼 | Robert Schuman | PLATI_SAINT_AUGUSTINE | 原子 | 0 | +1外交胜利点数 | — |
| 尤利西斯·格兰特 | Ulysses S. Grant | PLATI_FRANKLIN | 工业 | 0 | +1外交胜利点数 | — |

**大艺术家 (Artist)**

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 效果 |
|--------|--------|--------|------|------|------|
| 菲迪亚斯 | Phidias | (见大工程师) | 古典 | 1 | 古典奇观+巨作槽位 |
| 维克多·瓦斯涅佐夫 | Viktor Vasnetsov | (见Painters_All) | 工业 | 0 | 画家 |
| 巴勃罗·毕加索 | Pablo Picasso | (见Painters_All) | 工业 | 0 | 画家 |

**文明特色改良伟人（配置选项启用）**

| 中文名 | 英文名 | 内部ID | 时代 | 效果 |
|--------|--------|--------|------|------|
| 菲利贝尔·德洛姆 | Philibert de l'Orme | PLATI_CHATEAU | 文艺复兴 | 工业区生产力相邻加成转化为文化值，解锁城堡（Chateau）改良 |
| 克里斯托佛·克拉乌 | Christopher Clavius | PLATI_MISSION | 文艺复兴 | 城市信仰产出50%转化为科技值，解锁传教团（Mission）改良 |
| 扬·莱赫瓦特 | Jan Leeghwater | PLATI_POLDER | 文艺复兴 | 城市免疫自然灾害，解锁圩田（Polder）改良 |

**和平梦想者伟人（配置选项启用）**

| 中文名 | 英文名 | 内部ID | 效果 |
|--------|--------|--------|------|
| 马丁·路德·金 | Martin Luther King Jr. | PLATI_VISIONARY_1 | +1外交胜利点数 |
| 圣雄甘地 | Mahatma Gandhi | PLATI_VISIONARY_2 | +1外交胜利点数 |
| 纳尔逊·曼德拉 | Nelson Mandela | PLATI_VISIONARY_3 | +1外交胜利点数 |
| 马拉拉 | Malala Yousafzai | PLATI_VISIONARY_4 | +1外交胜利点数 |
| 瓦茨拉夫·哈维尔 | Václav Havel | PLATI_VISIONARY_5 | +1外交胜利点数 |

---

### 2.2 大统治者伟人 (Great Sovereigns) - Mod 2973448849

**Mod信息**：作者 Plati，ID `b820e109-c326-7375-b44f-1635a8bedbe5`
**伟人类别**：`GREAT_PERSON_CLASS_GreatSovereigns`（大统治者），使用政府区执行项目，产出金币和伟人点数

#### 2.2.1 核心大统治者（GreatSovereigns_People.xml）

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 所罗门王 | Solomon | PLATI_FIRST | 古典 | 1 | 立即在该城建1座寺庙；所有寺庙+2产能 | 所有寺庙+2生产力 |
| 马可·奥里利乌斯 | Marcus Aurelius | PLATI_SECOND | 古典 | 1 | 获得所有中世纪市政的尤里卡时刻（Amount=99，即全部） | 无 |
| 托勒密一世 | Ptolemy I | PLATI_THIRD | 古典 | 1 | 为奇观建设提供100生产力（不可溢出）；每点城邦使者+1文化 | 每点城邦使者+1文化 |
| 阿育王 | Asoka | PLATI_FOURTH | 古典 | 1 | 每个专业区域+1信仰+1食物 | 每个专业区域+1信仰+1食物 |
| 腓特烈二世 | Frederick II | PLATI_FIFTH | 中世纪 | 1 | 所有政体+1经济政策槽位 | 所有政体+1经济政策槽位 |
| 穆罕默德·阿里帕夏 | Mehmet Ali Pasha | PLATI_SIXTH | 工业 | 1 | 单位升级100%金币折扣 + 随机获得1个免费科技 | 单位升级100%金币折扣 |
| 查理曼 | Charlemagne | PLATI_SEVENTH | 中世纪 | 1 | 所有政体+1军事政策槽位 | 所有政体+1军事政策槽位 |
| 哈伦·拉希德 | Harun al-Rashid | PLATI_EIGHTH | 中世纪 | 1 | 黄金时代下贸易路线每6格+1科技（每格0.17科技） | 黄金时代贸易路线每格+0.17科技 |
| 阿斯基亚大帝 | Askia the Great | PLATI_NINTH | 文艺复兴 | 1 | 区域掠夺收益翻倍（200%）；有纪念碑的征服城市替换为专属纪念碑，提供Cowrie奢侈资源（+4宜居度） | 区域掠夺收益x2 |
| 阿克巴 | Akbar | PLATI_TENTH | 文艺复兴 | 1 | 所有政体+1通配符政策槽位 | 所有政体+1通配符政策槽位 |
| 明治天皇 | Emperor Meiji | PLATI_THIRTEENTH | 工业 | 1 | 工业区/社区替换农场时+300金币；工业区与社区互相+2食物相邻加成 | 工业区↔社区+2食物相邻加成 |
| 凯末尔 | Atatürk | PLATI_FOURTEENTH | 现代 | 3 | 提供400产能（可溢出，3次充能） | 所有陆地单位获得ABILITY_PLATI_FOURTEENTH_COMBAT（战斗加成） |
| 海尔·塞拉西一世 | Haile Selassie I | PLATI_FIFTEENTH | 现代 | 1 | +2外交胜利点数 | 无 |

#### 2.2.2 扩展大统治者（Expansion/ 目录）

| 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|----------|----------|
| 伊莎贝拉一世 | Isabella I | PLATI_ISABELLA | 文艺复兴 | 1 | 免费获得1位大探险家；商人+2视野；海军击败敌人+8大探险家点数 | 商人+2视野；海军击杀获得大探险家点数 |
| 恩里科·丹多洛 | Enrico Dandolo | PLATI_DANDOLO | 中世纪 | 1 | 宫殿+2遗物槽位并获2遗物；商人路过外国城市-20忠诚度 | 商人-20忠诚度压力 |
| 雷尼尔三世 | Rainier III | PLATI_MONACO | 原子 | 1 | 每种多余奢侈资源+200旅游业绩；每个海滨/娱乐码头建筑+60%海滨度假区旅游业绩（最多+300%） | 每种多余奢侈+200旅游业绩；海滨度假区最多+300%旅游业绩 |
| 儒略二世 | Julius II | PLATI_AKBAR | 文艺复兴 | 1 | 为奇观建设提供455生产力 | 无 |
| 奥托·冯·俾斯麦 | Otto von Bismarck | PLATI_BISMARK | 工业 | 1 | 成为选定城邦宗主国，移除所有其他使者；每张外交政策卡+1外交支持/回合 | 每张外交政策卡+1外交支持/回合 |
| 玛丽亚·特蕾莎 | Maria Theresa | PLATI_TWELWTH | 工业 | 1 | 每种城邦特色改良设施+20%大艺术家和大音乐家点数/回合 | 每种城邦改良+20%大艺术家/大音乐家点数 |
| 豪华者洛伦佐 | Lorenzo the Magnificent | PLATI_ARBE | 文艺复兴 | 1 | 该城所有文艺复兴奇观+2艺术巨作槽位；黄金时代免费获得1位大艺术家 | 黄金时代获得大艺术家 |
| 斯坎德培 | Skanderbeg | PLATI_DENG | 中世纪 | 1 | 瞬间消灭2格内所有敌军；2格内陆地单位恢复移动和攻击 | 无 |
| 李光耀 | Lee Kuan Yew | PLATI_ELEVENTH | 原子 | 1 | 所有大商人+1充能次数 | 大商人+1充能 |
| 李光耀（Tycoons版） | Lee Kuan Yew | PLATI_ELEVENTH_TYCOONS | 原子 | 1 | 大商人+1充能 + 立即创建1个投资者单位 | 大商人+1充能 |
| 兰甘亨 | Ramkhamhaeng | PLATI_SIXTEENTH | 中世纪 | 1 | 每种不同类型宗主城邦为所有城市+1人口 | 每种宗主城邦类型+1人口 |
| 乌鲁伯格 | Ulug Beg | PLATI_BEG | 中世纪 | 1 | 每次新放置学院区域+200科技 | 无 |
| 路易十四 | Louis XIV | PLATI_SOVEREIGN_FIRST | 文艺复兴 | 1 | 所有政府区建筑+3艺术巨作槽位；政府区雕塑文化产出3倍（+200%） | 政府区雕塑文化x3 |
| 拜里米苏拉 | Parameswara | PLATI_SOVEREIGN_FRIDRIK_GREAT | 中世纪 | 1 | 选定城市+1额外远程攻击/回合；每个港口/商业中心/外交区+5%金币和+5%信仰 | 港口/商业中心/外交区+5%金币+5%信仰 |
| 维陶塔斯 | Vytautas | PLATI_SOVEREIGN_GEDIMINAS | 中世纪 | 2 | 选定城市+8忠诚/回合；创建1个骑士（带免费晋升） | 无 |
| 伊斯玛仪一世 | Ismail I | PLATI_ISMAIL | 文艺复兴 | 1 | 黑暗时代骑兵攻占城市强制转教；黄金时代巨作文化翻倍 | 骑兵单位获得ABILITY_ISMAIL_CONVERSION；黄金时代巨作文化x2 |
| 扎耶德·本·苏尔坦·阿勒纳哈扬 | Zayed bin Sultan Al Nahyan | PLATI_SOVEREIGN_ZAYED | 原子 | 1 | 每座有改良煤/石油/铀的城市+20%金币 | 改良煤/石油/铀城市+20%金币 |
| 普里特维·纳拉扬·沙阿 | Prithvi Narayan Shah | PLATI_KOSEMI | 文艺复兴 | 1 | 近战/远程单位+3战斗力；外国大陆额外+3 | 近战/远程获得ABILITY_GURKHAS_BONUS（+3战斗力）和ABILITY_SEPOYS_BONUS（外国大陆+3战斗力） |
| 哈卡姆二世 | Al-Hakam II | PLATI_RBORGIA | 中世纪 | 1 | 有崇拜建筑的城市可额外建造大教堂/清真寺/犹太教堂（不受信仰限制） | 无 |
| 阿尔弗雷德大帝 | Alfred the Great | PLATI_ALFRED_THE_GREAT | 中世纪 | 1 | 建造军械库送免费海军单位；军械库+1科技/+1产能相邻加成；政府区+2文化/+2科技相邻加成 | 海军单位获得ABILITY_ALFRED_PROMOTION_BONUS（免费晋升） |

---

### 2.3 远古伟人 (Ancient Great People) - Mod 3085812151

**Mod信息**：作者 JNR，ID `8b1e0073-88e9-43e8-b899-fa9baccc2086`
**概述**：每个远古时代伟人职业新增2位（1男1女），共14位。工程师移入古典时代。

| 中文名 | 英文名 | 内部ID | 类别 | 时代 | 充能 | 主动效果 | 被动效果 |
|--------|--------|--------|------|------|------|----------|----------|
| 赫努 | Henenu | JNR_HENENU | 海军上将 | 远古 | 1 | 退休：小额金币 + 永久海上商路范围+10 | 2格内远古/古典海军+5战斗力+1移动力 |
| 奈·曼加尼布卡 | Nei Manganibuka | JNR_NEI_MANGANIBUKA | 海军上将 | 远古 | 1 | 退休：创建可无视科技进入海洋的海军近战单位 | 2格内远古/古典海军+5战斗力+1移动力 |
| 印何阗 | Imhotep | IMHOTEP | 大工程师 | 古典 | 2 | 为奇观建设提供250生产力（远古/古典）或125生产力（其他时代） | 无 |
| 玛利亚·希伯来亚 | Maria Hebraea | JNR_MARIA_HEBRAEA | 大工程师 | 古典 | 1 | 区域项目+20%生产力（需工业区） | 无 |
| 妇好 | Fu Hao | JNR_FU_HAO | 大军事家 | 远古 | 1 | 退休：创建带"伪装"能力的重骑兵（仅相邻敌方单位可见） | 2格内远古/古典陆地+5战斗力+1移动力 |
| 西亚赫·卡阿克 | Siyaj K'ak' | JNR_SIYAJ_K_AK | 大军事家 | 远古 | 1 | 退休：在城市中心激活，转换为总督区（类似埃塞尔弗莱德） | 2格内远古/古典陆地+5战斗力+1移动力 |
| 阿玛·埃 | Ama-e | JNR_AMA_E | 大商人 | 远古 | 1 | 需商业中心：+1商路容量，通往此城的国内商路+1食物+1生产力 | 无 |
| 希兰 | Hiram | JNR_HIRAM | 大商人 | 远古 | 1 | 需商业中心：授予1单位泰尔紫（Murex）奢侈资源（+4宜居度） | 无 |
| 摩西 | Moses | JNR_MOSES | 大预言家 | 远古 | 0 | 创建宗教 | 无 |
| 伽吉·瓦查克纳维 | Gargi Vachaknavi | JNR_GARGI_VACHAKNAVI | 大预言家 | 远古 | 0 | 创建宗教 | 无 |
| 米利都的泰勒斯 | Thales of Miletus | JNR_THALES_MILETUS | 大科学家 | 远古 | 1 | 需学院：1个远古随机科技尤里卡 + 2个古典随机市政鼓舞 | 无 |
| 弥勒 | Maitreyi | JNR_MAITREYI | 大科学家 | 远古 | 1 | 需学院：此城所有学院建筑各+1科技+1文化+1信仰 | 无 |
| 恩赫杜安娜 | Enheduanna | JNR_EN_HEDU_ANNA | 大作家 | 远古 | 0 | 创建2个著作巨作：《宁美沙拉》《因宁沙古拉》 | 无 |
| 普塔霍特普 | Ptahhotep | JNR_PTAHHOTEP | 大作家 | 远古 | 0 | 创建2个著作巨作：《普塔霍特普箴言·残卷甲》《普塔霍特普箴言·残卷乙》 | 无 |

**注**：印何阗（Imhotep）原为原版远古大工程师，此mod将其移至古典时代，并修改了生产力数值（远古/古典从175改为250，其他时代从175改为125）。

---

### 2.4 删除部分工程师 - Mod 3334907290

**Mod信息**：作者 sb，ID `7f38a5d2-0a7a-4f8e-af3d-2e7e96e4e2b4`

| 内部ID | 中文名（推测） | 英文名 | 状态 |
|--------|---------------|------|------|
| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 | Bi Sheng | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 圣乔治的詹姆斯 | James of St. George | 被删除 |
| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 | Isidore of Miletus | 被删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 | John A. Roebling | 被删除 |
| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 | Alvar Aalto | 被删除 |

---

### 2.5 其他Mod新增伟人

| 中文名 | 英文名 | 内部ID | 类别 | 时代 | 充能 | 效果 | 来源Mod |
|--------|--------|--------|------|------|------|------|---------|
| 神圣建筑师 | Divine Architect | GREAT_PERSON_INDIVIDUAL_MONUMENT | 神圣建筑师 | 远古 | 1 | 远古奇观提供110生产力，古典及以后奇观仅提供10生产力 | 2778428759 Belief Rework |
| 沙贾汗 (EWHO) | Shah Jahan | GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN_EWHO | 大工程师_EWHO | 文艺复兴 | 3 | 购买生产力（城市购买奇观生产力） | 2921308654 EWHO |

---

## 3. 关联数据

### 3.1 能力定义一览

**更多伟人 (Sumus Magnus) 中定义的单位能力：**

| 能力ID | 名称 | 效果描述 | 适用范围 |
|--------|------|----------|----------|
| ABILITY_SAUGUSTINE_BONUS | 宗教辩论 | +3宗教战斗力 | 所有宗教单位 |
| ABILITY_GARIBALDI_BONUS | 红衫军精神 | +3战斗力（首都大陆） | 近战单位 |
| ABILITY_MAJID_SEA_MOVEMENT | 航海大师 | +2移动力 | 所有海军单位 |
| ABILITY_COOK_SEA_SIGHT | 探险家之眼 | +2视野 | 所有海军单位 |
| ABILITY_COOK_SEA_MOVEMENT | 环球航行 | +2移动力 | 所有海军单位 |
| ABILITY_BAIBARS_UNIQUE | 马穆鲁克韧性 | 每回合结束恢复生命 | 所有陆地单位 |
| ABILITY_KHALID_WALID_UNIQUE | 真主之剑 | +7战斗力（vs异教单位） | 所有陆地单位 |
| ABILITY_PLATI_CAPTURE_SHIPS | 维京战利品 | 可俘获敌方船只 | 海军近战单位 |
| ABILITY_PLATI_SARGON_SABBUM | 征服者 | 击败敌人可俘获 | 近战/骑兵单位 |
| ABILITY_REX_GOD_OF_WAR | 北方雄狮 | 每点未使用移动力+3战斗力 | 所有陆地单位 |
| ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE | 留里克忠告 | 经验+80% | 所有陆地单位 |
| ABILITY_FOG_OF_WAR | 空中优势 | 攻击区域无远程惩罚，+17战斗力 | 战斗机单位 |
| ABILITY_NORMAN_LEGACY | 诺曼遗产 | 攻击时+7战斗力 | 骑兵单位 |
| ABILITY_BAYINNAUNG | 圣殿骑士 | 击杀敌人获得信仰（100%战斗力） | 所有陆地单位 |
| ABILITY_GAJAH_MADA_COMBAT | 海军陆战队 | 上船时+10战斗力 | 所有陆地单位 |
| ABILITY_GAJAH_MADA_DISEMBARK | 两栖作战 | 无视上岸移动力惩罚 | 所有陆地单位 |
| ABILITY_JAN_ZIZKA | 胡斯战车 | 防御时+10战斗力 | 侦察/近战/骑兵单位 |
| ABILITY_HUSSITE_LEGACY | 胡斯遗产 | 对更强单位+4战斗力 | 所有陆地单位 |
| ABILITY_VITRUVIUS | 攻城大师 | +5战斗力 | 攻城单位 |
| ABILITY_MANNERHEIM | 曼纳海姆防线 | 防守时+4战斗力 | 所有陆地单位 |
| ABILITY_GENOESE_NAVAL_CONVERSION | 基督教海军 | 征服城市自动转化宗教 | 海军近战单位 |
| ABILITY_PLATI_CONSULATE_OF_SEA | 海上领事 | 每点未使用移动力+1战斗力 | 海军近战单位 |

**大统治者伟人 (Great Sovereigns) 中定义的单位能力：**

| 能力ID | 名称 | 效果描述 | 适用范围 |
|--------|------|----------|----------|
| ABILITY_ISMAIL_CONVERSION | 波斯之剑 | 非黄金时代攻占城市强制转教 | 骑兵单位 |
| ABILITY_PLATI_FOURTEENTH_COMBAT | 凯末尔改革 | 战斗加成 | 所有陆地单位 |
| ABILITY_ALFRED_PROMOTION_BONUS | 海军传统 | 海军单位免费晋升 | 海军单位 |
| ABILITY_GURKHAS_BONUS | 廓尔喀战士 | +3战斗力 | 近战/远程单位 |
| ABILITY_SEPOYS_BONUS | 印度兵 | 外国大陆+3战斗力 | 近战/远程单位 |
| ABILITY_TIMOCRACY_POINTS | 荣誉制度 | 击杀敌军+8大统治者点数 | 所有单位 |

**远古伟人 (Ancient Great People) 中定义的单位能力：**

| 能力ID | 名称 | 效果描述 | 适用范围 |
|--------|------|----------|----------|
| ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER | 特拉卡的教导 | 可无视科技要求进入海洋，战斗-5力 | 指定海军单位 |
| ABILITY_JNR_FU_HAO_CAMOUFLAGE | 伪装 | 仅相邻敌方单位可见 | 重战车/重骑兵 |

### 3.2 新增建筑

| 建筑ID | 中文名 | 效果 | 来源Mod | 相关伟人 |
|--------|--------|------|---------|----------|
| BUILDING_PLATI_PAPER_MAKER | 造纸坊 | +1科技+2金币，100锤 | 更多伟人 | 蔡伦 (PLATI_CAI_LUN) |
| BUILDING_PLATI_TEMPLAR_VAULT | 圣殿金库 | 金币=信仰产出10%，300锤，+2信仰 | 更多伟人 | 于格·德·帕扬 (PLATI_BAYINNAUNG) |
| BUILDING_PLATI_CHOCOLATERIE | 巧克力工厂 | 提供果仁糖奢侈资源（+4宜居度），600锤，+2文化 | 更多伟人 | 吉恩·诺伊豪斯二世 (PLATI_NESTLE) |
| BUILDING_PLATI_MONUMENT_ASKIA | 阿斯基亚纪念碑 | 替换纪念碑，提供Cowrie奢侈资源（+4宜居度） | 大统治者 | 阿斯基亚 (PLATI_NINTH) |
| BUILDING_HAKAM_CATHEDRAL | 哈卡姆大教堂 | 额外崇拜建筑 | 大统治者 | 哈卡姆二世 (PLATI_RBORGIA) |
| BUILDING_HAKAM_MOSQUE | 哈卡姆清真寺 | 额外崇拜建筑 | 大统治者 | 哈卡姆二世 (PLATI_RBORGIA) |
| BUILDING_HAKAM_SYNAGOGE | 哈卡姆犹太教堂 | 额外崇拜建筑 | 大统治者 | 哈卡姆二世 (PLATI_RBORGIA) |

### 3.3 新增资源

| 资源ID | 中文名 | 类别 | 宜居度 | 来源Mod | 相关伟人 |
|--------|--------|------|--------|---------|----------|
| RESOURCE_EGG | 法贝热彩蛋 | 奢侈 | 5 | 更多伟人 | 彼得·卡尔·法贝热 (PLATI_FABERGE) |
| RESOURCE_PEPPER | 胡椒 | 奢侈 | 4 | 更多伟人 | 加查·马达 (PLATI_GAJAH) |
| RESOURCE_NUTMEG | 肉豆蔻 | 奢侈 | 4 | 更多伟人 | 加查·马达/阿方索·德·阿尔布克尔克 |
| RESOURCE_PRALINE | 果仁糖 | 奢侈 | 4 | 更多伟人 | 吉恩·诺伊豪斯二世 (PLATI_NESTLE) |
| RESOURCE_JNR_MUREX | 泰尔紫 | 奢侈 | 4 | 远古伟人 | 希兰 (JNR_HIRAM) |
| RESOURCE_PLATI_COWRIE | 贝壳币 (Cowrie) | 奢侈 | 4 | 大统治者 | 阿斯基亚 (PLATI_NINTH) |

### 3.4 新增伟人类别

| 类别ID | 中文名 | 来源Mod |
|--------|--------|---------|
| GREAT_PERSON_CLASS_GreatSovereigns | 大统治者 | 大统治者伟人 |
| GREAT_PERSON_CLASS_ENGINEER_EWHO | 大工程师_EWHO | EWHO |
| GREAT_PERSON_CLASS_MONUMENT | 神圣建筑师 | Belief Rework |

---

## 4. 被修改/删除的原版内容

### 4.1 更多伟人 (Sumus Magnus) 删除的原版伟人

当 `SumusMagnusRemoveUnimpressives` 选项启用时，以下17位原版伟人将被删除：

| 内部ID | 伟人类别 | 删除方式 |
|--------|----------|----------|
| JOHN_A_ROEBLING | 大工程师 | Types表Delete |
| CHARLES_CORREA | 大工程师 | Types表Delete |
| JANE_DREW | 大工程师 | Types表Delete |
| JAMES_OF_ST_GEORGE | 大工程师 | Types表Delete |
| FRANZ_VON_HIPPER | 海军上将 | Types表Delete |
| FRANCIS_DRAKE | 海军上将 | Types表Delete |
| LASKARINA_BOUBOULINA | 海军上将 | Types表Delete |
| YI_SUN_SIN | 海军上将 | Types表Delete |
| HANNO_THE_NAVIGATOR | 海军上将 | Types表Delete |
| DANDARA | 海军上将 | Types表Delete |
| JOHN_MONASH | 大军事家 | Types表Delete |
| RANI_LAKSHMIBAI | 大军事家 | Types表Delete |
| SAMORI_TURE | 大军事家 | Types表Delete |
| AETHELFLAED | 大军事家 | Types表Delete |
| PIERO_DE_BARDI | 大商人 | Types表Delete |
| JAKOB_FUGGER | 大商人 | Types表Delete |
| JOHN_JACOB_ASTOR | 大商人 | Types表Delete |
| ADAM_SMITH | 大商人 | Types表Delete |

### 4.2 删除部分工程师 (3334907290) 删除的原版伟人

| 内部ID | 伟人类别 | 删除方式 |
|--------|----------|----------|
| BI_SHENG | 大工程师 | SQL DELETE |
| JAMES_OF_ST_GEORGE | 大工程师 | SQL DELETE |
| ISIDORE_OF_MILETUS | 大工程师 | SQL DELETE |
| JOHN_A_ROEBLING | 大工程师 | SQL DELETE |
| ALVAR_AALTO | 大工程师 | SQL DELETE |

### 4.3 远古伟人 (3085812151) 修改的原版伟人

| 内部ID | 修改内容 | 修改方式 |
|--------|----------|----------|
| IMHOTEP | 时代从远古移至古典；生产力从175改为250（远古/古典）和125（其他时代） | SQL UPDATE |

### 4.4 大统治者汉化 (3310259652) 对原版的修改

| 修改内容 | 说明 |
|----------|------|
| 拿破仑·波拿巴 | 重分类为大统治者 |
| 古斯塔夫·阿道弗斯 | 重分类为大统治者 |
| 阿尔罕布拉宫 | 建成时获得大统治者（而非原版效果） |

---

## 5. 兼容性分析

### 5.1 重叠删除分析

| 内部ID | 被删除Mod | 冲突类型 |
|--------|-----------|----------|
| JAMES_OF_ST_GEORGE | 更多伟人 + 删除部分工程师 | 双重删除，无冲突 |
| JOHN_A_ROEBLING | 更多伟人 + 删除部分工程师 | 双重删除，无冲突 |

删除部分工程师 (3334907290) 与 更多伟人 (2448605286) 的 RemoveData 中有2位重叠（JAMES_OF_ST_GEORGE 和 JOHN_A_ROEBLING），但因为是删除操作，不会产生新的冲突。

### 5.2 伟人类别兼容性

- **大统治者** (2973448849) 使用全新的 `GREAT_PERSON_CLASS_GreatSovereigns`，与其他伟人mod无冲突
- **远古伟人** (3085812151) 使用原版伟人类别，与其他mod共享同一伟人池
- **EWHO** (2921308654) 使用全新的 `GREAT_PERSON_CLASS_ENGINEER_EWHO`，不可在时间线中获取，不可重复生成
- **神圣建筑师** (2778428759) 使用全新的 `GREAT_PERSON_CLASS_MONUMENT`

### 5.3 汉化Mod兼容性

- 大统治者伟人汉化 (3310259652) 依赖 大统治者伟人 (2973448849)，使用 `<Replace>` 标签替换文本
- 更多伟人汉化 (3338128748) 依赖 更多伟人 (2448605286)，使用 `<Replace>` 标签替换文本
- 两个汉化mod之间无冲突

### 5.4 加载顺序建议

```
1. 更多伟人 (2448605286)
2. 更多伟人汉化 (3338128748)
3. 大统治者伟人 (2973448849)
4. 大统治者伟人汉化 (3310259652)
5. 远古伟人 (3085812151)
6. 删除部分工程师 (3334907290)
7. EWHO (2921308654)
8. Belief Rework (2778428759)
```

### 5.5 实际游戏落地效果

在启用所有mod的情况下，最终游戏效果：

1. **更多伟人** 新增约80+位伟人，分布在各时代各职业
2. **大统治者** 新增32位大统治者，需要单独的政府区项目获取
3. **远古伟人** 新增14位远古/古典时代伟人
4. **删除**：BI_SHENG、JAMES_OF_ST_GEORGE、ISIDORE_OF_MILETUS、JOHN_A_ROEBLING、ALVAR_AALTO (5位工程师) 被永久删除
5. **更多伟人配置删除**（可选）：启用后额外删除17位原版伟人
6. **印何阗** 被修改为古典时代，生产力数值调整
7. **拿破仑和古斯塔夫·阿道弗斯**（如果启用汉化配置）可能被重分类为大统治者
8. **总计**：新增约130+伟人，删除5-22位原版伟人（取决于配置）

---

## 附录：完整伟人ID索引

### A. 更多伟人 (PLATI_前缀)

PLATI_LAWRENCE, PLATI_CECIL, PLATI_URBAN, PLATI_AGRIPPA, PLATI_NESTLE, PLATI_BANKER, PLATI_HENRY, PLATI_AFANASIY, PLATI_REX, PLATI_LIONHEART, PLATI_RAILLORD, PLATI_AL_AHMAR, PLATI_SAUGUSTINE, PLATI_NIETZSCHE, PLATI_JACOBKETTLER, PLATI_ERASMUS, PLATI_ALI_MASHADDI, PLATI_VIIKTOR_VASNETSOV, PLATI_PICASSO, PLATI_ISAMBARD, PLATI_HOBBES, PLATI_KRUPP, PLATI_GARIBALDI, PLATI_BAIBARS, PLATI_SARGON, PLATI_IBNBATTUTA, PLATI_COLBERT, PLATI_ELIZABETH_WILBRAHAM, PLATI_PASTEUR, PLATI_LEIZU, PLATI_MAHBUB, PLATI_SAINT_AUGUSTINE, PLATI_LEIBNITZ, PLATI_HEIDEGGER, PLATI_LOVECRAFT, PLATI_RHOWARD, PLATI_SFORZA, PLATI_SUAREZ, PLATI_RURIK, PLATI_DAHLBERG, PLATI_CURIE, PLATI_ZEPPELIN, PLATI_CAI_LUN, PLATI_SHEN_KUO, PLATI_LODBROK, PLATI_BARBAROSA, PLATI_BAYINNAUNG, PLATI_SUNDIATA, PLATI_AVERROES, PLATI_NIELS_JUEL, PLATI_HAMILTON, PLATI_TOKUGAWA, PLATI_MAJID, PLATI_MORGAN, PLATI_VITUS, PLATI_COOK, PLATI_CHATEAU, PLATI_MISSION, PLATI_POLDER, PLATI_VENETIAN_SMUGGLER, PLATI_APOLLODRO, PLATI_CROESUS, PLATI_UNGERN, PLATI_GAJAH, PLATI_FABERGE, PLATI_FARADAY, PLATI_SAKHAROV, PLATI_FRANKLIN, PLATI_TUSI, PLATI_JAN_ZIZKA, PLATI_ARAGONESE

### B. 大统治者 (PLATI_前缀)

PLATI_FIRST, PLATI_SECOND, PLATI_THIRD, PLATI_FOURTH, PLATI_FIFTH, PLATI_SIXTH, PLATI_SEVENTH, PLATI_EIGHTH, PLATI_NINTH, PLATI_TENTH, PLATI_ELEVENTH, PLATI_TWELWTH, PLATI_THIRTEENTH, PLATI_FOURTEENTH, PLATI_FIFTEENTH, PLATI_SIXTEENTH, PLATI_ISABELLA, PLATI_DANDOLO, PLATI_MONACO, PLATI_AKBAR, PLATI_BISMARK, PLATI_ARBE, PLATI_KOSEMI, PLATI_BEG, PLATI_SOVEREIGN_FIRST, PLATI_SOVEREIGN_FRIDRIK_GREAT, PLATI_SOVEREIGN_GEDIMINAS, PLATI_ISMAIL, PLATI_SOVEREIGN_ZAYED, PLATI_DENG, PLATI_RBORGIA, PLATI_ALFRED_THE_GREAT, PLATI_ELEVENTH_TYCOONS

### C. 远古伟人 (JNR_前缀)

JNR_HENENU, JNR_NEI_MANGANIBUKA, JNR_MARIA_HEBRAEA, JNR_FU_HAO, JNR_SIYAJ_K_AK, JNR_AMA_E, JNR_HIRAM, JNR_MOSES, JNR_GARGI_VACHAKNAVI, JNR_THALES_MILETUS, JNR_MAITREYI, JNR_EN_HEDU_ANNA, JNR_PTAHHOTEP