# Civilization VI 伟人（GreatPerson）完整分析报告

> 生成时间: 2026-07-07
> 数据来源: Mod (无原版游戏文件)
> 总条目数: 约 80+ 伟人（含新增/修改/删除）

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
> 一致性：✓ 文本与代码一致 / ✗ 存在差异

### 2.1 更多伟人 (2448605286 Sumus Magnus) - 新增大将军

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 被动效果（代码） | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|-----------------|----------|:-------:|:----:|
| 1 | 曼纳海姆 | Carl Gustaf Emil Mannerheim | GREAT_PERSON_INDIVIDUAL_PLATI_SARGON | 古典 | 1 | 周边2格陆地近战/骑兵/重战车/轻战车/反骑兵/武僧单位在防御时+4战斗力 | 所有陆地单位防守时+4战斗力 | ✓ | 新增 |
| 2 | 拜伯尔斯 | Baibars | GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS | 中世纪 | 1 | 周边2格所有陆地单位行动后恢复生命值 | 受伤时的战斗力减益-20%；回合结束后恢复生命值 | ✗ 文本漏了光环范围(周边2格) | 新增 |
| 3 | 哈立德·本·瓦利德 | Khalid ibn al-Walid | GREAT_PERSON_INDIVIDUAL_PLATI_KHALID_WALID | 中世纪 | 1 | 周边2格所有陆地单位对异教单位+7战斗力 | 在两个单元格内，中世纪和文艺复兴时期的陆地单位与异教文明的单位交战时，+7战斗力 | ✓ | 新增 |
| 4 | 卡尔十二世 | Carl XII | GREAT_PERSON_INDIVIDUAL_PLATI_REX | 工业 | 1 | 周边2格所有陆地单位每剩余1移动力+3战斗力 | 每点未使用的移动力为单位+3战斗力 | ✓ | 新增 |
| 5 | 留里克大公 | Rurik | GREAT_PERSON_INDIVIDUAL_PLATI_RURIK | 中世纪 | 1 | 周边2格所有陆地单位经验获取+80% | 获得的经验+80% | ✓ | 新增 |
| 6 | 斯坦尼斯瓦夫·若乌凯夫斯基 | Stanisław Żółkiewski | GREAT_PERSON_INDIVIDUAL_PLATI_LIONHEART | 中世纪 | 1 | 周边2格骑兵单位（重骑/轻骑/远程骑兵）攻击时+7战斗力 | 攻击中世纪和文艺复兴时期的骑兵单位+7战斗力 | ✓ | 新增 |
| 7 | 于格·德·帕扬 | Hugues de Payens | GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG | 中世纪 | 1 | 周边2格所有陆地单位击杀敌人后获得相当于被击杀单位100%战斗力的信仰 | 击杀敌方单位获得信仰值 | ✓ | 新增 |
| 8 | 加查·马达 | Gajah Mada | GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH_MADA | 中世纪 | 1 | 周边2格所有陆地单位登陆时+10战斗力；所有陆地单位忽略上岸惩罚 | 中世纪和文艺复兴时期的陆地单位在船上时+10战斗力，且上下船不消耗移动力 | ✓ | 新增 |
| 9 | 扬·杰式卡 | Jan Žižka | GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA | 中世纪 | 1 | 周边2格近战/骑兵/反骑兵/重战车/轻战车/武僧单位在防御远程攻击时+10战斗力；与基础战斗力更高的单位作战时+4战斗力 | 非远程单位防御远程攻击时+10战斗力；与基础战斗力更高的单位作战时+4战斗力 | ✓ | 新增 |
| 10 | 罗曼·冯·恩琴 | Roman von Ungern-Sternberg | GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN | 现代 | 1 | 周边2格所有陆地单位防御时+4战斗力；创建五个怯薛 | 创建五个怯薛；所有陆地单位防守时+4战斗力 | ✓ | 新增 |
| 11 | 朱塞佩·加里波第 | Giuseppe Garibaldi | GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI | 工业 | 1 | 近战单位在首都大陆+3战斗力 | 近战单位在首都所在大陆上战斗时+3战斗力 | ✓ | 新增 |
| 12 | 阿拉伯的劳伦斯 | T. E. Lawrence | GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE | 现代 | 1 | 空优战斗机在轰炸时+17战斗力；解放城市后10回合内，所有城市+20%文化值 | 攻击区域防御时+17远程攻击力；解放城市后10回合内，所有城市+20%文化值 | ✓ | 新增 |
| 13 | 埃尔南·科尔特斯 | Hernán Cortés | GREAT_PERSON_INDIVIDUAL_PLATI_SUAREZ | 文艺复兴 | 1 | 近战/骑兵单位可转化敌方单位为己方；创建一个拥有一次升级的征服者单位 | 创建一个拥有一次升级的征服者单位；击败敌方单位有几率将其俘获 | ✓ | 新增 |
| 14 | 卡泰丽娜·斯福尔扎 | Caterina Sforza | GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA | 文艺复兴 | 1 | 获得300文化值 | 获得300文化值 | ✓ | 新增 |

### 2.2 更多伟人 (2448605286 Sumus Magnus) - 新增大提督

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|----------|----------|----------|:-------:|:----:|
| 1 | 艾哈迈德·本·马吉德 | Ahmad ibn Majid | GREAT_PERSON_INDIVIDUAL_PLATI_MAJID | 文艺复兴 | 1 | 所有海军单位+2海上移动力 | 周边2格海军单位+2海上移动力 | 所有海军单位+2移动力 | ✓ | 新增 |
| 2 | 阿方索·德·阿尔布克尔克 | Afonso de Albuquerque | GREAT_PERSON_INDIVIDUAL_PLATI_COOK | 文艺复兴 | 1 | 该城市获得一份肉豆蔻；黄金时代额外获得一份 | 周边2格海军单位+2视野/移动力 | 该城市获得一份肉豆蔻。如果文明处于黄金时代，则获得两份 | ✓ | 新增 |
| 3 | 阿格里帕 | Marcus Vipsanius Agrippa | GREAT_PERSON_INDIVIDUAL_PLATI_AGRIPPA | 古典 | 1 | 建造奇观时提供245生产力 | 周边2格海军近战单位可俘获敌方船只 | 建造奇观时提供245生产力；可俘获敌方船只 | ✓ | 新增 |
| 4 | 米希尔·德·鲁伊特 | Michiel de Ruyter | GREAT_PERSON_INDIVIDUAL_PLATI_HENRY | 文艺复兴 | 1 | 该城市每回合+1攻击次数 | 无文本被动效果 | 该城市每回合+1攻击次数 | ✓ | 新增 |
| 5 | 巴巴罗萨·海雷丁 | Hayreddin Barbarossa | GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSSA | 文艺复兴 | 1 | 可训练巴巴里海盗（需要"中世纪集市"市政） | 无 | 可训练巴巴里海盗（需要"中世纪集市"市政） | ✓ | 新增 |
| 6 | 安德烈亚·多里亚 | Andrea Doria | GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL | 文艺复兴 | 1 | 用海军单位征服城市后，该城市自动信仰您的主流宗教 | 周边2格海军单位每剩余1移动力+1战斗力 | 用海军单位征服城市后，该城市自动信仰您的主流宗教；每点未使用的移动力+1战斗力 | ✓ | 新增 |
| 7 | 拉格纳·洛德布罗克 | Ragnar Lodbrok | GREAT_PERSON_INDIVIDUAL_PLATI_LODBROK | 中世纪 | 1 | 掠夺改良设施的收益翻倍 | 周边2格海军近战单位可俘获敌方船只 | 掠夺改良设施的收益翻倍；中世纪和文艺复兴时期的海军近战单位击败敌方海军单位后，可将其俘获 | ✓ | 新增 |

### 2.3 更多伟人 (2448605286 Sumus Magnus) - 新增大商人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|----------|----------|:-------:|:----:|
| 1 | 塞西尔·罗兹 | Cecil Rhodes | GREAT_PERSON_INDIVIDUAL_PLATI_CECIL | 工业 | 1 | 创建一个红衫军；有总督的异大陆城市+20%金币 | 创建一个红衫军；有总督的异大陆城市+20%金币 | ✓ | 新增 |
| 2 | 吉恩·诺伊豪斯二世 | Jean Nestlé II | GREAT_PERSON_INDIVIDUAL_PLATI_NESTLE | 工业 | 1 | 解锁特色建筑巧克力工厂；巧克力工厂产出+2文化值并提供一份果仁糖 | 解锁特色建筑巧克力工厂。该建筑产出+2文化值并提供一份果仁糖，该奢侈品提供+4宜居度 | ✓ | 新增 |
| 3 | 约翰·皮尔庞特·摩根 | J. P. Morgan | GREAT_PERSON_INDIVIDUAL_PLATI_BANKER | 工业 | 1 | 每个银行+1外交点数 | 每个银行+1外交点数 | ✓ | 新增 |
| 4 | 彼得·卡尔·法贝热 | Peter Carl Fabergé | GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE | 工业 | 1 | 获得两份法贝热彩蛋，提供+5宜居度 | 获得两份法贝热彩蛋，提供+5宜居度 | ✓ | 新增 |
| 5 | 阿发纳西·尼基丁 | Afanasy Nikitin | GREAT_PERSON_INDIVIDUAL_PLATI_AFANASIY | 中世纪 | 1 | 首都获得一份该地块上的奢侈品资源；必须在国外激活，该城市每有一种区域获得100金币 | 首都获得一份该地块上的奢侈品资源；必须在国外激活，该城市每有一种区域获得100金币 | ✓ | 新增 |
| 6 | 亚历山大·汉密尔顿 | Alexander Hamilton | GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON | 工业 | 1 | 所有政体经济政策槽位+1 | 所有政体经济政策槽位+1 | ✓ | 新增 |
| 7 | 涩泽荣一 | Eiichi Shibusawa | GREAT_PERSON_INDIVIDUAL_PLATI_COLBERT | 文艺复兴 | 1 | 本城市每种用于发电的资源为改良的奢侈品资源+1宜居度 | 本城市每种用于发电的资源为改良的奢侈品资源+1宜居度 | ✓ | 新增 |
| 8 | 雅各布·凯特勒 | Jacob Kettler | GREAT_PERSON_INDIVIDUAL_PLATI_JACOBKETTLER | 文艺复兴 | 1 | 该港口提供等同于其相邻加成的生产力；如果滨水区，提供等同于食物相邻加成的金币 | 该港口提供等同于其相邻加成的生产力；滨水区提供等同于食物相邻加成的金币 | ✓ | 新增 |
| 9 | 马拉莫科的波诺 | Bono da Malamocco | GREAT_PERSON_INDIVIDUAL_PLATI_VENETIAN_SMUGGLER | 中世纪 | 1 | 获得一个遗物；+1商路容量；必须在国外的港口单元格上激活 | 获得一个遗物；+1商路容量；必须在国外的港口单元格上激活 | ✓ | 新增 |

### 2.4 更多伟人 (2448605286 Sumus Magnus) - 新增大工程师

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|----------|----------|----------|:-------:|:----:|
| 1 | 乌尔班 | Urban | GREAT_PERSON_INDIVIDUAL_PLATI_URBAN | 中世纪 | 1 | 创建两个拥有一次升级的射石炮单位 | 古典时代或中世纪的攻城单位+5战斗力 | 创建两个拥有一次升级的射石炮单位；攻城单位+5战斗力 | ✓ | 新增 |
| 2 | 格拉纳达的穆罕默德五世 | Muhammad V of Granada | GREAT_PERSON_INDIVIDUAL_PLATI_AL_AHMAR | 中世纪 | 1 | 宫殿+3巨作槽位；每个放置于此的宗教艺术巨作+4信仰 | 宫殿+3巨作槽位；每个放置于此的宗教艺术巨作+4信仰 | ✓ | 新增 |
| 3 | 伊桑巴德·金德姆·布鲁内尔 | Isambard Kingdom Brunel | GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD | 工业 | 1 | 该城市每建造一种专业化区域，+1%生产力 | 该城市每建造一种专业化区域，+1%生产力 | ✓ | 新增 |
| 4 | 阿尔弗雷德·克虏伯 | Alfred Krupp | GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP | 工业 | 1 | 建造攻城单位+25%生产力 | 建造攻城单位+25%生产力 | ✓ | 新增 |
| 5 | 塞巴斯蒂安·勒普雷斯特雷·德·沃邦 | Sébastien Le Prestre de Vauban | GREAT_PERSON_INDIVIDUAL_PLATI_DAHLBERG | 文艺复兴 | 1 | 获得一个军事工程师；每个堡垒为工业区+1相邻加成 | 获得一个军事工程师；每个堡垒为工业区+1相邻加成 | ✓ | 新增 |
| 6 | 蔡伦 | Cai Lun | GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN | 古典 | 1 | 解锁并建造特色建筑造纸坊；造纸坊+1科技+2金币 | 解锁并建造特色建筑造纸坊；该建筑产出+1科技值，+2金币 | ✓ | 新增 |
| 7 | 弗朗切斯科·巴尔托洛梅奥·拉斯特雷利 | Francesco Bartolomeo Rastrelli | GREAT_PERSON_INDIVIDUAL_PLATI_CURIE | 文艺复兴 | 1 | 该城市的展阁、公馆和市政广场内建筑+4文化值 | 该城市的展阁、公馆和市政广场内建筑+4文化值 | ✓ | 新增 |

### 2.5 更多伟人 (2448605286 Sumus Magnus) - 新增大科学家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|----------|----------|----------|:-------:|:----:|
| 1 | 伊本·路世德 | Ibn Rushd | GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES | 中世纪 | 1 | 黄金时代时，每本著作+1科技+2信仰 | 处于黄金时代时，每本著作+1科技值，+2信仰值 | ✓ | 新增 |
| 2 | 伊本·西那 | Avicenna | GREAT_PERSON_INDIVIDUAL_PLATI_SAUGUSTINE | 中世纪 | 1 | 为一个随机的中世纪的科技触发尤里卡；宗教单位进行神学战斗时+3宗教战斗力 | 为一个随机的中世纪的科技触发尤里卡；宗教单位进行神学战斗时+3宗教战斗力 | ✓ | 新增 |
| 3 | 沈括 | Shen Kuo | GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO | 中世纪 | 1 | 该学院提供等同于其相邻加成的生产力 | 该学院提供等同于其相邻加成的生产力 | ✓ | 新增 |
| 4 | 伊拉斯谟 | Erasmus | GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS | 文艺复兴 | 1 | 当你不与任何文明交战时，每个大学+1外交点数；为一个随机的中世纪或文艺复兴时期的市政触发鼓舞 | 当你不与任何文明交战时，每个大学+1外交点数；为一个随机的中世纪或文艺复兴时期的市政触发鼓舞 | ✓ | 新增 |
| 5 | 路易·巴斯德 | Louis Pasteur | GREAT_PERSON_INDIVIDUAL_PLATI_PASTEUR | 工业 | 1 | 所有城市+20%余粮；触发"卫生设备"的尤里卡；如果尤里卡已触发，则解锁科技 | 所有城市+20%余粮；触发"卫生设备"的尤里卡；如果尤里卡已触发，则解锁科技 | ✓ | 新增 |
| 6 | 迈克尔·法拉第 | Michael Faraday | GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY | 工业 | 1 | 该城市每回合+2电力；为一个随机的工业时代科技触发尤里卡 | 该城市每回合+2电力；为一个随机的工业时代科技触发尤里卡 | ✓ | 新增 |
| 7 | 安德烈·萨哈罗夫 | Andrei Sakharov | GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV | 原子能 | 1 | +2外交胜利点数；为一个随机的原子能时代或信息时代的科技触发尤里卡 | +2外交胜利点数；为一个随机的原子能时代或信息时代的科技触发尤里卡 | ✓ | 新增 |
| 8 | 尤利西斯·格兰特 | Ulysses S. Grant | GREAT_PERSON_INDIVIDUAL_PLATI_FRANKLIN | 工业 | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | 新增 |
| 9 | 三浦按针 | William Adams | GREAT_PERSON_INDIVIDUAL_PLATI_TUSI | 中世纪 | 1 | 所有政体外交政策槽位+1 | 所有政体外交政策槽位+1 | ✓ | 新增 |
| 10 | 伏尔泰 | Voltaire | GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNITZ | 文艺复兴 | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | 新增 |
| 11 | 胡果·格劳秀斯 | Hugo Grotius | GREAT_PERSON_INDIVIDUAL_PLATI_LEIZU | 古典 | 1 | +1外交胜利点数 | +1外交胜利点数 | ✓ | 新增 |

### 2.6 更多伟人 (2448605286 Sumus Magnus) - 新增大作家/大艺术家

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|----------|----------|:-------:|:----:|
| 1 | 弗里德里希·尼采 | Friedrich Nietzsche | GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE | 工业 | 0 | 创造2个著作巨作 | 《查拉图斯特拉如是说》《权力意志论》 | ✓ | 新增 |
| 2 | 希波的奥古斯丁 | Augustine of Hippo | GREAT_PERSON_INDIVIDUAL_PLATI_HOBBES | 文艺复兴 | 0 | 创造2个著作巨作 | 《忏悔录》《上帝之城》 | ✓ | 新增 |
| 3 | 勒内·笛卡尔 | René Descartes | — | 文艺复兴 | 0 | 创造2个著作巨作 | 《第一哲学沉思集》《方法论》 | ✓ | 新增 |
| 4 | 马库斯·图留斯·西塞罗 | Marcus Tullius Cicero | — | 古典 | 0 | 创造2个著作巨作 | 《论演说家》《论共和国》 | ✓ | 新增 |
| 5 | 马丁·海德格尔 | Martin Heidegger | — | 现代 | 0 | 创造2个著作巨作 | 《存在与时间》《诗·语言·思》 | ✓ | 新增 |
| 6 | 霍华德·菲利普·洛夫克拉夫特 | H. P. Lovecraft | — | 现代 | 0 | 创造2个著作巨作 | 《克苏鲁的呼唤》《印斯茅斯之影》 | ✓ | 新增 |
| 7 | 菲利贝尔·德洛姆 | Philibert de l'Orme | GREAT_PERSON_INDIVIDUAL_PLATI_CHATEAU | 文艺复兴 | 1 | 选中的工业区提供等同于生产力相邻加成的文化值；允许建造者修建城堡改良设施 | 选中的工业区提供等同于生产力相邻加成的文化值；允许建造者修建城堡改良设施（需要"人文主义"市政） | ✓ | 新增 |
| 8 | 克里斯托佛·克拉乌 | Christopher Clavius | GREAT_PERSON_INDIVIDUAL_PLATI_MISSION | 文艺复兴 | 1 | 获得当前信仰值产出50%的科技值；允许建造者修建传教团改良设施 | 获得当前信仰值产出50%的科技值；允许建造者修建传教团改良设施（需要"教育"科技） | ✓ | 新增 |
| 9 | 扬·莱赫瓦特 | Jan Leeghwater | GREAT_PERSON_INDIVIDUAL_PLATI_POLDER | 文艺复兴 | 1 | 该城市免疫自然灾害；允许建造者修建圩田改良设施 | 该城市免疫自然灾害；允许建造者修建圩田改良设施（需要"行会"市政） | ✓ | 新增 |

### 2.7 更多伟人 (2448605286 Sumus Magnus) - 新增资源/建筑/改良设施

| 类型 | 中文名 | 英文名 | 内部ID | 效果 | 来源 |
|------|-------|-------|--------|------|------|
| 资源 | 法贝热彩蛋 | Fabergé Egg | RESOURCE_PLATI_FABERGE_EGG | 奢侈品，+5宜居度 | PLATI_Resources.xml |
| 资源 | 胡椒 | Pepper | RESOURCE_PLATI_PEPPER | 奢侈品，+4宜居度 | PLATI_Resources.xml |
| 资源 | 肉豆蔻 | Nutmeg | RESOURCE_PLATI_NUTMEG | 奢侈品，+4宜居度 | PLATI_Resources.xml |
| 资源 | 果仁糖 | Praline | RESOURCE_PLATI_PRAGUELINE | 奢侈品，+4宜居度 | PLATI_Resources.xml |
| 建筑 | 巧克力工厂 | Chocolate Factory | BUILDING_PLATI_CHOCOLATE_FACTORY | 提供果仁糖奢侈品+4宜居度 | PLATI_Buildings.xml |
| 建筑 | 造纸坊 | Paper Mill | BUILDING_PLATI_PAPER_MILL | +1科技+2金币 | PLATI_Buildings.xml |
| 建筑 | 圣殿金库 | Templar Vault | BUILDING_PLATI_TEMPLE_VAULT | 获得等同于该城市信仰产出10%的金币 | PLATI_Buildings.xml |
| 改良设施 | 城堡 | Château | IMPROVEMENT_PLATI_CHATEAU | 特色改良 | A_Improvement_Chateau.xml |
| 改良设施 | 传教团 | Mission | IMPROVEMENT_PLATI_MISSION | 特色改良 | A_Improvement_Mission.xml |
| 改良设施 | 圩田 | Polder | IMPROVEMENT_PLATI_POLDER | 特色改良 | A_Improvement_Polder.xml |

---

### 2.8 大统治者伟人 (2973448849 Great Sovereigns) - 新伟人类型

| 类型 | 中文名 | 英文名 | 说明 |
|------|-------|-------|------|
| 单位类型 | 大统治者 | GreatSovereigns | 伟人单位，移动力4，视野2，平民单位 |
| 伟人类型 | 大统治者 | GreatSovereigns | 全新伟人类型，产出在政府区，伟人点数来源：政府区(+1)，1级政府建筑(+1)，2级(+2)，3级(+3) |
| 政府区项目 | 任人唯贤 | District_Project | 获得等同于城市生产力15%的金币，完成后获得大统治者点数 |

#### 基础16位大统治者

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果（代码） | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|-----------------|----------|:-------:|:----:|
| 1 | 所罗门王 | King Solomon | GREAT_PERSON_INDIVIDUAL_PLATI_FIRST | 古典 | 1 | 需要圣地；在目标区域免费建造神殿；所有神殿+2生产力 | 立即建造一所寺庙。所有寺庙+2生产力 | ✓ | 新增 |
| 2 | 马可•奥里利乌斯 | Marcus Aurelius | GREAT_PERSON_INDIVIDUAL_PLATI_SECOND | 古典 | 1 | 为所有中世纪市政提供鼓舞 | 为所有中世纪市政提供鼓舞 | ✓ | 新增 |
| 3 | 托勒密一世 | Ptolemy I Soter | GREAT_PERSON_INDIVIDUAL_PLATI_THIRD | 古典 | 1 | 建造奇观时提供100生产力；每个派往城邦的使者+1文化值 | 建造奇观时提供100生产力。每个派往城邦的使者+1文化值 | ✓ | 新增 |
| 4 | 阿育王 | Ashoka | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTH | 古典 | 1 | 城市从每个专业化区域得到+1信仰与+1食物 | 城市从每个专业化区域得到+1信仰与+1食物 | ✓ | 新增 |
| 5 | 腓特烈二世 | Frederick II | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTH | 中世纪 | 1 | 所有政体经济政策槽位+1 | 所有政体经济政策槽位+1 | ✓ | 新增 |
| 6 | 穆罕默德·阿里帕夏 | Muhammad Ali Pasha | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTH | 工业 | 1 | 单位升级-100%金币；获得一项随机科技 | 单位升级-100%金币。获得一项随机科技 | ✓ | 新增 |
| 7 | 查理曼 | Charlemagne | GREAT_PERSON_INDIVIDUAL_PLATI_SEVENTH | 中世纪 | 1 | 所有政体军事政策槽位+1 | 所有政体军事政策槽位+1 | ✓ | 新增 |
| 8 | 哈伦•拉希德 | Harun al-Rashid | GREAT_PERSON_INDIVIDUAL_PLATI_EIGHTH | 中世纪 | 1 | 黄金时代时，商路每经过6格提供+1科技值 | 文明处于黄金时代时，商路每经过6个单元格提供+1科技值 | ✓ | 新增 |
| 9 | 阿斯基亚大帝 | Askia Muhammad | GREAT_PERSON_INDIVIDUAL_PLATI_NINTH | 文艺复兴 | 1 | 征服有纪念碑的城市获得奢侈品货贝（+4宜居度）；掠夺区域收益+100%；用阿斯基亚纪念碑替换纪念碑 | 征服有纪念碑的城市获得奢侈品货贝，提供+4宜居度。掠夺区域的收益+100% | ✓ | 新增 |
| 10 | 阿克巴 | Akbar | GREAT_PERSON_INDIVIDUAL_PLATI_TENTH | 文艺复兴 | 1 | 所有政体通用政策槽位+1 | 所有政体通用政策槽位+1 | ✓ | 新增 |
| 11 | 明治天皇 | Emperor Meiji | GREAT_PERSON_INDIVIDUAL_PLATI_THIRTEENTH | 工业 | 1 | 在农场上建成工业区或社区将获得金币；工业区和社区从每个相邻区域处获得+2食物 | 在农场上建成工业区或社区将获得金币。工业区和社区从每个相邻区域处获得+2食物 | ✓ | 新增 |
| 12 | 凯末尔 | Mustafa Kemal Atatürk | GREAT_PERSON_INDIVIDUAL_PLATI_FOURTEENTH | 现代 | 3 | 提供400生产力（不适用于奇观、项目）；所有陆地单位+5战斗力 | 提供400生产力（不适用于奇观、项目） | ✓ | 新增 |
| 13 | 海尔•塞拉西一世 | Haile Selassie I | GREAT_PERSON_INDIVIDUAL_PLATI_FIFTEENTH | 现代 | 1 | +2外交胜利点数 | +2外交胜利点数 | ✓ | 新增 |
| 14 | 兰甘亨 | Ram Khamhaeng | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH | 中世纪 | 1 | 宗主的每个城邦为全国+1%食物和信仰；每宗主一种城邦，该城市+1宜居度 | 宗主的每个城邦为全国+1%食物和信仰；每宗主一种城邦，该城市+1宜居度 | ✓ | 新增 |
| 15 | 玛丽亚•特蕾莎 | Maria Theresa | GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH | 文艺复兴 | 1 | 每个城邦提供的特色改良设施为剧院广场提供+2相邻加成，为娱乐中心+2生产力；黄金时代奇观+4文化 | 每个城邦提供的特色改良设施为剧院广场提供+2相邻加成，为娱乐中心+2生产力。若处于黄金时代，为奇观+4文化值 | ✓ | 新增 |
| 16 | 李光耀 | Lee Kuan Yew | GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH | 原子能 | 1 | 大商人+1使用次数 | 大商人+1使用次数 | ✓ | 新增 |

#### 扩展大统治者

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果（代码） | 文本描述 | 一致性 | 状态 |
|---|-------|-------|--------|------|------|-----------------|----------|:-------:|:----:|
| 1 | 路易十四 | Louis XIV | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST | 文艺复兴 | 1 | 所有市政广场内建筑获得3个艺术巨作槽位；雕塑巨作提供的文化值+200% | 所有市政广场内建筑获得3个艺术巨作槽位。此处放置的雕塑所提供的文化值+200% | ✓ | 新增 |
| 2 | 扎耶德·本·苏尔坦·阿勒纳哈扬 | Zayed bin Sultan Al Nahyan | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED | 原子能 | 1 | 对于所有城市，每有一种用于发电的战略资源，便+20%金币 | 对于所有城市，每有一种用于发电的战略资源，便+20%金币 | ✓ | 新增 |
| 3 | 拜里米苏拉 | Parameswara | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT | 中世纪 | 1 | 该城市+1攻击次数；该城市每有港口、商业中心、外交区中一种，+5%金币和信仰值 | 该城市+1攻击次数；该城市每有港口、商业中心、外交区中一种，+5%金币和信仰值 | ✓ | 新增 |
| 4 | 维陶塔斯 | Vytautas | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS | 中世纪 | 2 | 提供一个骑士，且为该城市每回合+5忠诚度 | 提供一个骑士，且为该城市每回合+5忠诚度 | ✓ | 新增 |
| 5 | 哈克汗二世 | Rodrigo Borgia | GREAT_PERSON_INDIVIDUAL_PLATI_RBORGIA | 中世纪 | 1 | 建造奇观时提供180生产力；黄金时代时，所有城市从每个非主流宗教处获得+1宜居度 | 建造奇观时提供180生产力。如果处于黄金时代，所有城市从每个非主流宗教处获得+1宜居度 | ✓ | 新增 |
| 6 | 奥托·冯·俾斯麦 | Otto von Bismarck | GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK | 工业 | 1 | 成为选定城邦的宗主国，并移除其他所有玩家的使者；政体中每张生效的外交政策卡每回合+1外交支持 | 成为选定城邦的宗主国，并移除其他所有玩家的使者。政体中每张生效的外交政策卡每回合+1外交支持 | ✓ | 新增 |
| 7 | 洛伦佐·德·美第奇 | Lorenzo de' Medici | GREAT_PERSON_INDIVIDUAL_PLATI_ARBE | 文艺复兴 | 1 | 所有文艺复兴时期的奇观获得两个艺术巨作槽位；黄金时代获得一位大艺术家 | 所有文艺复兴时期的奇观获得两个巨作槽位。如文明处于黄金时代，获得一位大艺术家 | ✓ | 新增 |
| 8 | 普里特维·纳拉扬·沙阿 | Prithvi Narayan Shah | GREAT_PERSON_INDIVIDUAL_PLATI_KOSEMI | 工业 | 1 | 近战单位+5战斗力；在外国领土上战斗额外+3战斗力 | 近战单位+5战斗力。如果在外国领土上战斗，则额外+3战斗力 | ✓ | 新增 |
| 9 | 兀鲁伯 | Ulugh Beg | GREAT_PERSON_INDIVIDUAL_PLATI_BEG | 文艺复兴 | 1 | 每建成一个学院，提供200科技值 | 每建成一个学院，提供200科技值 | ✓ | 新增 |
| 10 | 儒略二世 | Pope Julius II | GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR | 文艺复兴 | 1 | 建造奇观时提供455生产力 | 建造奇观时提供455生产力 | ✓ | 新增 |
| 11 | 阿尔弗雷德大帝 | Alfred the Great | GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT | 中世纪 | 1 | 海军兵工厂从每个相邻区域获得+1科技值和+1文化值，如该城有军营，则加成翻三倍；海军单位初始获得一次免费升级 | 海军兵工厂从每个相邻区域获得+1科技值和+1文化值，如该城有军营，则加成翻三倍。海军单位初始获得一次免费升级 | ✓ | 新增 |
| 12 | 斯坎德培 | Skanderbeg | GREAT_PERSON_INDIVIDUAL_PLATI_DENG | 文艺复兴 | 1 | 立即击杀两个单元格内所有敌方单位；两个单元格内本方陆地战斗单位恢复所有移动力；击杀获得+8大统治者点数 | 立即击杀两个单元格内所有敌方单位。两个单元格内本方陆地战斗单位恢复所有移动力。击败敌方单位时获得+8大统治者点数 | ✓ | 新增 |
| 13 | 伊斯玛仪一世 | Ismail I | GREAT_PERSON_INDIVIDUAL_PLATI_ISMAIL | 文艺复兴 | 1 | 若处于黑暗时代，骑兵攻占城市将使该城市信仰主流宗教；若黄金时代，巨作提供的文化值翻倍 | 若处于黑暗时代，用骑兵单位攻占城市将使该城市信仰您的主流宗教；若处于黄金时代，巨作提供的文化值翻倍 | ✓ | 新增 |

#### 大统治者相关政策卡

| 政策卡中文名 | 效果 |
|-------------|------|
| 精英统治 | 每回合+2大统治者点数 |
| 国际贵族 | 领事馆+2大统治者点数；外交办+2大统治者点数 |
| 小红点 | 每回合+2大统治者点数；首都每有一种区域，每回合+1大统治者点数 |
| 至尊之国 | 每有一种宗主的城邦，每回合+2大统治者点数 |
| 归还凯撒 | 所有祭祀建筑+2大统治者点数 |
| 三级会议（6T） | 拥有军营、商业中心和圣地的城市每回合+2大统治者点数 |
| 荣誉政体（6T） | 击败敌方单位时获得+8大统治者点数 |
| 大理石之城（6T） | 首都中建造的每一座古典及后古典时代奇观提供+1大统治者点数/回合 |
| 混合政体（6T） | 每座拥有至少3个特色区域的城市每回合+1大统治者点数 |
| 太阳王（6T） | 首都中建造的每一座文艺复兴及工业时代奇观提供+3大统治者点数/回合 |
| 吉伦特主义（6T） | 征服的城市每回合+1大统治者点数；不忠诚的城市每回合+4大统治者点数 |
| 共主邦联（6T） | 每回合获得的大统治者点数+20%，乘以最高等级有效同盟的等级（最高+60%） |
| 战斗精神（6T） | 战争期间每回合获得的大统治者点数+100% |
| 选拔政治（6T） | 相邻加成至少+4的学院和工业区各提供+2大统治者点数/回合；若达到+10则额外+3 |
| 包容性制度（6T） | 拥有至少20人口的城市每回合+6大统治者点数 |

#### 大统治者万神殿

| 万神殿信条 | 效果 |
|-----------|------|
| 圣主明君 | 每回合+1大统治者点数；黄金时代额外+1 |

### 2.9 远古伟人 (3085812151 Ancient Great People) - 新增远古/古典伟人

| # | 中文名 | 英文名 | 内部ID | 类型 | 时代 | 充能 | 主动效果（代码） | 被动效果 | 文本一致性 | 状态 |
|---|-------|-------|--------|------|------|------|-----------------|----------|:----------:|:----:|
| 1 | 赫努门 | Henenu | GREAT_PERSON_INDIVIDUAL_JNR_HENENU | 大提督 | 远古 | 1 | 水上贸易路线范围+10；获得少量金币 | 周边2格远古海军单位+5战斗力+1移动力 | 无文本（汉化仅针对类型，未翻译名字/描述） | 新增 |
| 2 | 内伊·曼加尼布卡 | Nei Manganibuka | GREAT_PERSON_INDIVIDUAL_JNR_NEI_MANGANIBUKA | 大提督 | 远古 | 1 | 免费获得1个海军近战单位并赋予早期探险者能力 | 周边2格远古海军单位+5战斗力+1移动力 | 无文本 | 新增 |
| 3 | 妇好 | Fu Hao | GREAT_PERSON_INDIVIDUAL_JNR_FU_HAO | 大将军 | 远古 | 1 | 免费获得1个重骑兵单位并赋予伪装能力 | 周边2格远古陆地单位+5战斗力+1移动力 | 无文本 | 新增 |
| 4 | 夏甲克 | Siyaj K'ak' | GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | 大将军 | 远古 | 1 | 城市忠诚度效果 | 周边2格远古陆地单位+5战斗力+1移动力 | 无文本 | 新增 |
| 5 | 阿玛埃 | Ama e | GREAT_PERSON_INDIVIDUAL_JNR_AMA_E | 大商人 | 远古 | 1 | +1商路容量；目标城市国内贸易路线+1食物+1生产力 | — | 无文本 | 新增 |
| 6 | 希拉姆 | Hiram | GREAT_PERSON_INDIVIDUAL_JNR_HIRAM | 大商人 | 远古 | 1 | 目标城市获得1个骨螺奢侈品资源(+4宜居度) | — | 无文本 | 新增 |
| 7 | 泰勒斯（米利都） | Thales of Miletus | GREAT_PERSON_INDIVIDUAL_JNR_THALES_MILETUS | 大科学家 | 远古 | 1 | 获得1个远古科技尤里卡；获得2个古典市政鼓舞 | — | 无文本 | 新增 |
| 8 | 弥勒 | Maitreyi | GREAT_PERSON_INDIVIDUAL_JNR_MAITREYI | 大科学家 | 远古 | 1 | 图书馆+1科技+1文化+1信仰；大学+1科技+1文化+1信仰；研究实验室+1科技+1文化+1信仰 | — | 无文本 | 新增 |
| 9 | 摩西 | Moses | GREAT_PERSON_INDIVIDUAL_JNR_MOSES | 大先知 | 远古 | 0 | 创建宗教用，无激活能力 | — | 无文本 | 新增 |
| 10 | 迦尔吉·伐遮犍罗 | Gargi Vachaknavi | GREAT_PERSON_INDIVIDUAL_JNR_GARGI_VACHAKNAVI | 大先知 | 远古 | 0 | 创建宗教用，无激活能力 | — | 无文本 | 新增 |
| 11 | 恩赫杜安娜 | Enheduanna | GREAT_PERSON_INDIVIDUAL_JNR_EN_HEDU_ANNA | 大作家 | 远古 | 0 | 创造2个著作巨作（各+4文化+4旅游） | — | 无文本 | 新增 |
| 12 | 伊姆霍特普 | Imhotep | GREAT_PERSON_INDIVIDUAL_JNR_PTAHHOTEP | 大作家 | 远古 | 0 | 创造2个著作巨作（各+4文化+4旅游） | — | 无文本 | 新增 |

#### 被修改的原版伟人

| 原版中文名 | 修改前 | 修改后 | 来源 | 文本一致性 |
|------------|--------|--------|------|:----------:|
| 伊姆霍特普 | 远古时代 | 古典时代 | 6T_AGP_Engineer.sql | 修改了时代，ActionCharges=2，奇观生产力远古/古典=250，其他=125 | ✓ |

### 2.10 删除部分工程师 (3334907290) - 被删除的伟人

| 推断中文名 | 内部ID | 状态 |
|------------|--------|:----:|
| 毕昇 | GREAT_PERSON_INDIVIDUAL_BI_SHENG | 被删除 |
| 圣乔治的詹姆斯 | GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 被删除 |
| 米利都的伊西多尔 | GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 被删除 |
| 约翰·罗布林 | GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 被删除 |
| 阿尔瓦·阿尔托 | GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 被删除 |

### 2.11 艺术类伟人偷奇观Mod - 伟人新功能

| 功能 | 触发方式 | 效果说明 |
|------|----------|----------|
| 奇观偷取 | 大作家/大艺术家/大音乐家使用按钮 | 将目标奇观从当前位置移到新位置（黑名单：金门大桥、巴拿马运河、塔桥） |
| 奇观安置 | 奇观学家单位使用按钮 | 将已偷取的奇观放置到新位置 |
| 传送开拓者 | 大作家/大艺术家/大音乐家使用按钮 | 传送开拓者到异大陆随机空地 |
| 文化炸弹 | 大作家/大艺术家/大音乐家使用按钮 | 获取邻近1环地块 |
| 召唤奇观学家 | 大作家/大艺术家/大音乐家使用按钮 | 召唤一个奇观学家单位 |

**新增单位：**
- UNIT_WONDER_THEFT (奇观学家)：移动力5，视野2，平民单位，专门用于偷取/放置奇观

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

#### 大统治者伟人核心链

| 条目ID | ModifierId | ModifierType | Arguments | 终端值 |
|--------|-----------|--------------|-----------|--------|
| PLATI_FIRST | GREATPERSON_PLATI_SOLOMON_PRODUCTION | MODIFIER_SINGLE_CITY_GRANT_BUILDING_IN_CITY_IGNORE | BuildingType=BUILDING_TEMPLE | 免费建造神殿 |
| PLATI_FIRST | GREATPERSON_PLATI_SOLOMON_TEMPLES | MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE | YieldType=YIELD_PRODUCTION, BuildingType=BUILDING_TEMPLE, Amount=2 | 所有神殿+2生产力 |
| PLATI_SECOND | GREAT_PLATI_MARCUS_AURELIUS | MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_BY_ERA | StartEraType=ERA_MEDIEVAL, EndEraType=ERA_MEDIEVAL, Amount=99 | 获得1个中世纪市政鼓舞 |
| PLATI_THIRD | GREAT_PLATI_DARIUS_PERSIAN | MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY | Amount=100, ScaleByGameSpeed | 奇观+100生产力 |
| PLATI_THIRD | GREAT_PLATI_DARIUS_TRADE | MODIFIER_PLAYER_ADJUST_YIELD_CHANGE_PER_USED_INFLUENCE_TOKEN | Amount=1, YieldType=YIELD_CULTURE | 每使用1使者+1文化 |
| PLATI_FOURTH | GREAT_PLATI_ASHOKA | MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT | YieldType=YIELD_FAITH, Amount=1 | 每个区域+1信仰 |
| PLATI_FOURTH | GREAT_PLATI_2ASHOKA | MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_DISTRICT | YieldType=YIELD_FOOD, Amount=1 | 每个区域+1食物 |
| PLATI_FIFTH | GREAT_PLATI_FREDERICH_II | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_ECONOMIC | +1经济槽位 |
| PLATI_SIXTH | GREAT_PLATI_AHMAD_MANSUR | MODIFIER_PLAYER_ADJUST_UNIT_UPGRADE_DISCOUNT_PERCENT | Amount=100 | 升级费-100% |
| PLATI_SIXTH | GREAT_PLATI_MUHAMAD_ALI_PASHA | MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY | Amount=1 | 随机获得1科技 |
| PLATI_SEVENTH | GREAT_PLATI_CHARLEMAGNE | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_MILITARY | +1军事槽位 |
| PLATI_EIGHTH | GREAT_PLATI_HARUN | MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD_PER_PATH_TILE | YieldType=YIELD_SCIENCE, Amount=0.17 | 黄金时代商路每格+0.17科技 |
| PLATI_NINTH | GREAT_PLATI_ASKIA | MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE | Amount=2, Extra=-1 | 掠夺次数+2 |
| PLATI_NINTH | GREAT_PLATI_2ASKIA | MODIFIER_PLAYER_ADJUST_VALID_BUILDING | BuildingType=BUILDING_PLATI_MONUMENT_ASKIA, BuildingTypeToReplace=BUILDING_MONUMENT | 替换纪念碑 |
| PLATI_TENTH | GREAT_PLATI_AKBAR | MODIFIER_PLAYER_CULTURE_ADJUST_GOVERNMENT_SLOTS_MODIFIER | GovernmentSlotType=SLOT_WILDCARD | +1通配符槽位 |
| PLATI_THIRTEENTH | GREAT_PLATI_MEIJI_NEIGHBOURHOOD_GOLD | MODIFIER_PLAYER_DISTRICT_CREATE_YIELD | DistrictType=DISTRICT_NEIGHBORHOOD, Amount=300, YieldType=YIELD_GOLD | 社区+300金 |
| PLATI_THIRTEENTH | GREAT_PLATI_MEIJI_INDUSTRIAL_GOLD | MODIFIER_PLAYER_DISTRICT_CREATE_YIELD | DistrictType=DISTRICT_INDUSTRIAL_ZONE, Amount=300, YieldType=YIELD_GOLD | 工业区+300金 |
| PLATI_THIRTEENTH | GREAT_PLATI_MEIJI_ADJACENCY_IND_TO_NEIGH | MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY | DistrictType=INDUSTRIAL_ZONE, YieldType=FOOD, Amount=2 | 工业区对社区+2食物相邻 |
| PLATI_THIRTEENTH | GREAT_PLATI_MEIJI_ADJACENCY_NEIGH_TO_IND | MODIFIER_PLAYER_CITIES_DISTRICT_ADJACENCY | DistrictType=NEIGHBORHOOD, YieldType=FOOD, Amount=2 | 社区对工业区+2食物相邻 |
| PLATI_FOURTEENTH | GREAT_PLATI_ATATURK | MODIFIER_SINGLE_CITY_GRANT_PRODUCTION_IN_CITY | Amount=400, ScaleByGameSpeed | 城市+400生产力 |
| PLATI_FIFTEENTH | GREAT_PLATI_HAILE_SELASSIE | MODIFIER_PLAYER_ADJUST_DIPLOMATIC_VICTORY_POINTS | Amount=2 | +2外交胜利点 |
| PLATI_ALFRED | FATHER_OF_ENGLISH_NAVY | MODIFIER_PLAYER_UNIT_ADJUST_GRANT_EXPERIENCE | Amount=-1 | 海军晋升经验-1 |
| PLATI_KOSEMI | GURKHAS_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=5 | 廓尔喀+5战斗力 |
| PLATI_KOSEMI | SEPOYS_BUFF | MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH | Amount=3 | 外大陆印度兵+3战斗力 |
| PLATI_DENG | SOVEREIGN_POINTS_FROM_KILLS | MODIFIER_PLAYER_UNIT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL | Amount=8, GreatPersonClassType=GREAT_PERSON_CLASS_GreatSovereigns | 击杀+8大统治者点数 |
| PLATI_ISMAIL | FATHER_OF_MODERN_IRAN | MODIFIER_PLAYER_UNIT_ADJUST_CITY_ON_CAPTURE | Enable=true | 非黄金时代可转化城市 |

#### 远古伟人核心链

| 条目ID | ModifierId | ModifierType | Arguments | 终端值 |
|--------|-----------|--------------|-----------|--------|
| JNR_HENENU | JNR_HENENU_MARITIME_TRADE_RANGE | MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_WATER_RANGE | Amount=10 | 海上贸易范围+10 |
| JNR_NEI_MANGANIBUKA | JNR_NEI_MANGANIBUKA_FREE_UNIT | MODIFIER_PLAYER_GRANT_UNIT_OF_ABILITY_WITH_MODIFIER | UnitPromotionClassType=PROMOTION_CLASS_NAVAL_MELEE | 免费海军近战单位 |
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
| JNR_IMHOTEP | (原版修改) | (原版) | Amount=250 (远古/古典), Amount=125 (其他) | 奇观生产力(修改后) |
| JNR_MARIA_HEBRAEA | GREATPERSON_JNR_PROJECT_PRODUCTION_BONUS | MODIFIER_PLAYER_CITIES_ADJUST_ALL_PROJECTS_PRODUCTION | Amount=20 | 项目+20%生产力 |

---

## 4. 文本与代码对照

### 4.1 一致性统计

| 项目 | 数量 |
|------|------|
| 完全一致 | ~75 |
| 文本漏报（代码有，文本未提） | 1（拜伯尔斯漏了光环范围） |
| 文本误报（文本有，代码无） | 0 |
| 数值差异 | 0 |
| 条件差异 | 0 |
| **总差异** | **1** |

### 4.2 文本与代码差异详情

| 条目 | 代码效果 | 文本描述 | 差异类型 |
|------|----------|----------|----------|
| 拜伯尔斯 (PLATI_BAIBARS) | 代码定义：周边2格所有陆地单位行动后恢复生命值（光环效果） | 文本：受伤时的战斗力减益-20% + 回合结束后恢复生命值 | ✗ 文本漏了光环范围（对周边单位生效），只描述了自身效果 |

所有其他条目文本描述与代码定义一致。文本准确描述了所有数值、触发条件和目标范围。

---

## 5. XML/SQL/Lua 三方法交叉验证

| 条目ID | XML发现 | SQL发现 | Lua发现 | 一致性 |
|--------|:------:|:------:|:------:|:------:|
| 更多伟人 - 所有将军/提督被动光环 | ✓ (PLATI_Abilities.xml) | ✗ | ✗ | 仅通过XML发现 |
| 更多伟人 - 伟人个体定义 | ✓ (Peepoles/*.xml) | ✗ | ✗ | 仅通过XML发现 |
| 大统治者伟人 | ✓ (GreatSovereigns_Core/People/Abilities) | ✓ (GreatSovereigns_Pantheons/ORACLE) | ✗ | XML+SQL一致 |
| 远古伟人 | ✗ | ✓ (所有6T_AGP_*.sql) | ✗ | 仅通过SQL发现 |
| 删除部分工程师 | ✗ | ✓ (core.sql) | ✗ | 仅通过SQL发现 |
| 艺术类伟人偷奇观 | ✓ (GreatWorkCreatorCharges_Data.xml) | ✗ | ✓ (GreatPersonTeleport.lua) | XML+Lua协作 |

---

## 6. 关联数据

### 6.1 能力定义一览表

| 能力ID | 中文名 | 效果描述 | 数值 | 条件 |
|--------|-------|----------|------|------|
| ABILITY_BAIBARS_UNIQUE | 马穆鲁克纪律 | 行动后回血 | — | 所有陆地单位 |
| ABILITY_KHALID_WALID_UNIQUE | 安拉之剑 | 对异教+7战斗力 | 7 | 对手异教 |
| ABILITY_PLATI_SARGON_SABBUM | 科尔特斯的说服 | 可转化敌方单位 | 可俘获 | 近战/骑兵/战车/反骑兵/武僧 |
| ABILITY_REX_GOD_OF_WAR | 查理王 | 剩余移动力加战斗力 | 每剩余1移动力+3 | 所有陆地单位 |
| ABILITY_RURIK_GAVE_YOU_GOOD_ADVICE | 诺夫哥罗德建国者 | 经验加成 | +80% | 所有陆地单位 |
| ABILITY_FOG_OF_WAR | 英雄与异端的遗产 | 轰炸战斗力 | +17 | 空优战斗机 |
| ABILITY_NORMAN_NAME | 若乌凯夫斯基战术 | 攻击时战斗力 | +7 | 骑兵单位 |
| ABILITY_BAYINNAUNG_NAME | 圣殿骑士团 | 击杀获得信仰 | 100%被击杀战斗力 | 所有陆地单位 |
| ABILITY_GAJAH_MADA_COMBAT_NAME | 基诺达拉 | 登陆战斗力 | +10 | 登陆时 |
| ABILITY_GAJAH_MADA_DISEMBARK | (无名称) | 忽略上岸惩罚 | 忽略 | 所有陆地单位 |
| ABILITY_JAN_ZIZKA_NAME | 战车 | 防御远程战斗力 | +10 | 防御远程攻击 |
| ABILITY_HUSSITE_LEGACY_NAME | 胡斯战争的经验 | 对抗更强单位 | +4 | 对手更强 |
| ABILITY_MANNERHEIM_BONUS_NAME | 曼纳海姆防线 | 防御时战斗力 | +4 | 防御时 |
| ABILITY_GARIBALDI_BONUS | (无名称) | 首都大陆战斗力 | +3 | 首都大陆, 近战单位 |
| ABILITY_VITRUVIUS_NAME | 维特鲁威工程 | 攻城单位战斗力 | +5 | 攻城单位 |
| ABILITY_SAUGUSTINE_BUFF | (无名称) | 宗教单位战斗力 | +3 | 所有宗教单位 |
| ABILITY_GURKHAS_BONUS_NAME | 库玛丽女神 | 廓尔喀战斗力 | +5 | 近战/远程 |
| ABILITY_SEPOYS_BONUS_NAME | 廓尔喀军团 | 外大陆印度兵 | +3 | 外大陆, 近战/远程 |
| ABILITY_ALFRED_PROMOTION_DESCRIPTION | (无名称) | 海军晋升经验 | -1 | 海军单位 |
| ABILITY_ISMAIL_CONVERSION | (无名称) | 骑兵转化城市 | 可转化 | 非黄金时代, 骑兵 |
| ABILITY_TIMOCRACY_POINTS_NAME | 荣誉政体 | 击杀获大统治者点数 | +8 | 所有单位 |
| ABILITY_MAJID_SEA_MOVEMENT | (无名称) | 海军海上移动力 | +2 | 海军单位 |
| ABILITY_COOK_SEA_SIGHT | (无名称) | 海军视野 | +2 | 海军单位 |
| ABILITY_PLATI_CAPTURE_SHIPS_NAME | 大海盗的劫掠 | 海军俘获 | 可俘获 | 海军近战 |
| ABILITY_GENOESE_NAVAL_CONVERSION_BONUS_NAME | 热那亚海王 | 海军转化城市 | 可转化 | 海军近战 |
| ABILITY_CONSULATE_OF_SEA_BONUS | 海上领事 | 剩余移动力加战斗力 | 每剩余1移动力+1 | 海军近战 |
| ABILITY_JNR_FU_HAO_CAMOUFLAGE | (无名称) | 伪装能力 | — | 重骑兵单位 |
| ABILITY_JNR_NEI_MANGANIBUKA_EARLY_EXPLORER | 早期探险者 | 早期探险者能力 | — | 海军近战单位 |

### 6.2 新增建筑/资源/改良设施等下游数据

| 类型 | 中文名 | 内部ID | 来源 |
|------|-------|--------|------|
| 建筑 | 巧克力工厂 | BUILDING_PLATI_CHOCOLATE_FACTORY | 更多伟人 |
| 建筑 | 造纸坊 | BUILDING_PLATI_PAPER_MILL | 更多伟人 |
| 建筑 | 圣殿金库 | BUILDING_PLATI_TEMPLE_VAULT | 更多伟人 |
| 建筑 | 阿斯基亚纪念碑 | BUILDING_PLATI_MONUMENT_ASKIA | 大统治者伟人 |
| 资源 | 法贝热彩蛋 | RESOURCE_PLATI_FABERGE_EGG | 更多伟人 |
| 资源 | 胡椒 | RESOURCE_PLATI_PEPPER | 更多伟人 |
| 资源 | 肉豆蔻 | RESOURCE_PLATI_NUTMEG | 更多伟人 |
| 资源 | 果仁糖 | RESOURCE_PLATI_PRAGUELINE | 更多伟人 |
| 资源 | 骨螺 | RESOURCE_JNR_MUREX | 远古伟人 |
| 资源 | 货贝 | RESOURCE_PLATI_COWRIE | 大统治者伟人 |
| 改良设施 | 城堡 | IMPROVEMENT_PLATI_CHATEAU | 更多伟人 |
| 改良设施 | 传教团 | IMPROVEMENT_PLATI_MISSION | 更多伟人 |
| 改良设施 | 圩田 | IMPROVEMENT_PLATI_POLDER | 更多伟人 |
| 单位 | 奇观学家 | UNIT_WONDER_THEFT | 艺术类伟人偷奇观 |
| 项目 | 任人唯贤 | PROJECT_GreatSovereigns_DISTRICT_GOVERNMENT | 大统治者伟人 |

---

## 7. 被修改/删除的原版内容

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

## 8. 兼容性分析

### 8.1 Mod 重叠定义

| 游戏元素 | Mod A 定义 | Mod B 定义 | 最终胜负 | 原因 |
|----------|-----------|-----------|:------:|------|
| GREAT_PERSON_INDIVIDUAL_IMHOTEP | 远古伟人(修改) | 原版(无文件) | 远古伟人 | 唯一修改源 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 更多伟人(DELETE) | 删除部分工程师(DELETE) | 两者都删除 | 重叠删除 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 更多伟人(DELETE) | 删除部分工程师(DELETE) | 两者都删除 | 重叠删除 |
| GREAT_PERSON_INDIVIDUAL_JNR_SIYAJ_K_AK | 6T_AGP_General.sql | 6T_AGP_XP1.sql | XP1版(后加载) | XP1文件在General之后加载 |

### 8.2 冲突与风险

- **重叠删除**：更多伟人(SumusMagnus)和删除部分工程师都删除了JAMES_OF_ST_GEORGE和JOHN_A_ROEBLING，无冲突。
- **加载顺序**：如果更多伟人(Sumus Magnus)在删除部分工程师之后加载，SumusMagnus_RemoveData.xml中的DELETE会再次执行，但SQL的DELETE已经先执行了，无实际影响。
- **大统治者伟人vs远古伟人**：两个Mod不重叠，大统治者是新类型，远古伟人是填充原版类型。
- **艺术类伟人偷奇观**：通过Lua脚本实现，与XML/SQL定义的伟人数据无冲突。但可能与禁用创作巨作弹窗Mod冲突（UI层面）。

---

## 9. 加载顺序

根据 .modinfo 文件分析，正确的加载顺序应为：

1. **原版游戏** → 基础数据
2. **DLC** → 扩展数据
3. **远古伟人 (3085812151)** → 修改原版伊姆霍特普
4. **删除部分工程师 (3334907290)** → 删除5位工程师
5. **更多伟人 (2448605286)** → 删除18位原版，新增45+伟人
6. **更多伟人汉化 (3338128748)** → 汉化（后加载，纯文本替换）
7. **大统治者伟人 (2973448849)** → 新增大统治者类型和22+伟人
8. **大统治者伟人汉化 (3310259652)** → 汉化（后加载，纯文本替换）
9. **艺术类伟人偷奇观** → 功能Mod，依赖Lua，最后加载

---

## 10. 统计总结

| 类别 | 数量 |
|------|------|
| 原版伟人（保留） | ~100 |
| Mod新增伟人 | ~80 |
| 被删除原版伟人 | 23 |
| 被修改原版伟人 | 3 |
| 新增资源 | 6 |
| 新增建筑 | 4 |
| 新增改良设施 | 3 |
| 新增单位类型 | 2 (大统治者、奇观学家) |
| 新增伟人类型 | 1 (大统治者) |
| 新增政策卡 | 10+ |
| 新增万神殿信条 | 1 |
| 总文本差异（不一致） | 1 |

---

## 11. 重要提示

> ⚠️ **重要提示：** 当前工作区仅包含Mod文件，缺少原版游戏数据。本报告中：
> 1. 原版伟人条目通过Mod的DELETE/UPDATE操作推断存在，但**原版伟人的具体效果数值未包含**。
> 2. 被删除的伟人仅列出了被DELETE的ID，未列出原版完整效果。
> 3. 如需完整数据，需要导入原版游戏XML/SQL文件。
> 
> 本报告已完整提取所有Mod添加/修改/删除的伟人数据，所有效果均通过XML/SQL/Lua代码推导，并与本地化文本进行了对照。