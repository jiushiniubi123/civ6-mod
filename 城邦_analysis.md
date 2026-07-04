# Civilization VI 城邦 完整分析报告

## 1. 总览

### 数据来源统计

| 来源 | 新增数 | 修改数 | 删除数 | 
|------|--------|--------|--------|
| 原版游戏 | 24 | 0 | 0 |
| 兴衰迭起 (Rise & Fall) | 2 | 4 | 0 |
| 风云变幻 (Gathering Storm) | 9 | 0 | 0 |
| 维京地标 DLC | 6 | 2 | 0 |
| CIVITAS City-States 模组 | 73 | 17 | 6 |

### 城邦类型统计

| 类型 | 原版数量 | CIVITAS新增 | 总计 |
|------|----------|-------------|------|
| 军事 (MILITARISTIC) | 6 | 10 | 16 |
| 科技 (SCIENTIFIC) | 6 | 6 | 12 |
| 贸易 (TRADE) | 5 | 7 | 12 |
| 文化 (CULTURAL) | 5 | 6 | 11 |
| 工业 (INDUSTRIAL) | 6 | 5 | 11 |
| 宗教 (RELIGIOUS) | 5 | 5 | 10 |
| 农业 (AGRICULTURAL) | 0 | 11 | 11 |
| 海洋 (MARITIME) | 0 | 11 | 11 |
| 娱乐 (ENTERTAINMENT) | 0 | 7 | 7 |
| 领事 (CONSULAR) | 0 | 10 | 10 |

## 2. 原版+DLC 城邦详细数据

### 2.1 原版城邦 (24个)

#### 军事型 (MILITARISTIC)

**CARTHAGE（迦太基）**
- 内部ID: CIVILIZATION_CARTHAGE
- 宗主效果: 每个军营区提供+1商路容量
- R&F新增: 兵营/马厩/军械库/军事学院中购买陆地单位费用-20%
- 来源: 原版 + R&F修改
- 状态: 原版（被CIVITAS在XP2中移除）

**KABUL（喀布尔）**
- 内部ID: CIVILIZATION_KABUL
- 宗主效果: 单位发起攻击时获得的经验值+100%
- 来源: 原版
- 状态: 原版

**PRESLAV（普雷斯拉夫）**
- 内部ID: CIVILIZATION_PRESLAV
- 宗主效果: 轻骑兵单位获得"巴尔干骑兵"能力（+1移动力）
- R&F新增: 兵营/马厩每回合+2忠诚度，军械库每回合+2忠诚度，军事学院每回合+2忠诚度
- 来源: 原版 + R&F修改
- 状态: 原版

**VALLETTA（瓦莱塔）**
- 内部ID: CIVILIZATION_VALLETTA
- 宗主效果: 市中心和军营区建筑可用信仰购买，城墙/城堡/星堡购买费用-50%
- 来源: 原版
- 状态: 原版

**AKKAD（阿卡德）**
- 内部ID: CIVILIZATION_AKKAD
- 宗主效果: 近战和抗骑兵单位可对城墙造成全额伤害
- 来源: 风云变幻
- 状态: 原版

**NGAZARGAMU（恩加扎加穆）**
- 内部ID: CIVILIZATION_NGAZARGAMU
- 宗主效果: 对应建筑中购买陆地单位费用-15%（兵营/马厩-15%，军械库-15%，军事学院-15%）
- 来源: 风云变幻
- 状态: 原版

#### 科技型 (SCIENTIFIC)

**GENEVA（日内瓦）**
- 内部ID: CIVILIZATION_GENEVA
- 宗主效果: 未与任何主要文明交战时，所有城市+15%科技值
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为领事型）

**HATTUSA（哈图沙）**
- 内部ID: CIVILIZATION_HATTUSA
- 宗主效果: 每回合获得1个你没有但已揭示的每种战略资源（铝、煤、马、铁、硝石、石油、铀）
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为军事型）

**SEOUL（首尔）**
- 内部ID: CIVILIZATION_SEOUL
- 宗主效果: 进入新时代时获得1个随机科技尤里卡
- 来源: 原版
- 状态: 原版（被CIVITAS在XP1中移除）

**STOCKHOLM（斯德哥尔摩）**
- 内部ID: CIVILIZATION_STOCKHOLM
- 宗主效果: 每个对应区域建筑+1伟人点数（大将军、海军上将、大工程师、大商人、大预言家、大科学家、大作家、大艺术家、大音乐家各+1）
- 来源: 原版
- 状态: 原版（被CIVITAS在XP2中移除）

**BABYLON（巴比伦）**
- 内部ID: CIVILIZATION_BABYLON
- 宗主效果: 著作+2科技值，文物+1科技值，遗物+1科技值
- 来源: 兴衰迭起
- 状态: 原版

**BOLOGNA（博洛尼亚）**
- 内部ID: CIVILIZATION_BOLOGNA
- 宗主效果: 拥有对应建筑的城市的伟人点数+1（9种伟人各+1）
- 来源: 风云变幻
- 状态: 原版

#### 贸易型 (TRADE)

**AMSTERDAM（阿姆斯特丹）**
- 内部ID: CIVILIZATION_AMSTERDAM
- 宗主效果: 每条国际商路目的地每种奢侈资源+1金币
- 来源: 原版
- 状态: 原版（被CIVITAS在XP1中移除）

**JAKARTA（雅加达）**
- 内部ID: CIVILIZATION_JAKARTA
- 显示名称注意: 文件名JAKARTA，但LOC_NAME为BANDAR_BRUNEI（文莱）
- 宗主效果: 外国城市中每个贸易站+1金币
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为海洋型）

**LISBON（里斯本）**
- 内部ID: CIVILIZATION_LISBON
- 宗主效果: 海上贸易路线免疫掠夺
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为海洋型）

**ZANZIBAR（桑给巴尔）**
- 内部ID: CIVILIZATION_ZANZIBAR
- 宗主效果: 获得肉桂和丁香奢侈资源（各+6宜居度）
- 来源: 原版
- 状态: 原版

**ANTIOCH（安条克）**
- 内部ID: CIVILIZATION_ANTIOCH
- 宗主效果: 每条国际商路目的地每种奢侈资源+1金币（与阿姆斯特丹相同）
- 来源: 兴衰迭起
- 状态: 原版

#### 文化型 (CULTURAL)

**KUMASI（库马西）**
- 内部ID: CIVILIZATION_KUMASI
- 宗主效果: 通往城邦的商路每个专业化区域+2文化+1金币
- 来源: 原版
- 状态: 原版

**MOHENJO_DARO（摩亨佐达罗）**
- 内部ID: CIVILIZATION_MOHENJO_DARO
- 宗主效果: 所有城市获得淡水住房加成（5住房）
- 来源: 原版
- 状态: 原版

**NAN_MADOL（南马都尔）**
- 内部ID: CIVILIZATION_NAN_MADOL
- 宗主效果: 位于或相邻海岸的每个区域+2文化
- 来源: 原版
- 状态: 原版

**VILNIUS（维尔纽斯）**
- 内部ID: CIVILIZATION_VILNIUS
- 宗主效果: 进入新时代时获得1个随机市政鼓舞
- 来源: 原版
- 状态: 原版

**RAPA_NUI（拉帕努伊）**
- 内部ID: CIVILIZATION_RAPA_NUI
- 宗主效果: 允许建造摩艾石像改良设施
- 来源: 风云变幻
- 状态: 原版

#### 工业型 (INDUSTRIAL)

**BRUSSELS（布鲁塞尔）**
- 内部ID: CIVILIZATION_BRUSSELS
- 宗主效果: 城市建造奇观时+15%生产力
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为领事型）

**BUENOS_AIRES（布宜诺斯艾利斯）**
- 内部ID: CIVILIZATION_BUENOS_AIRES
- 宗主效果: 每种奖励资源额外提供+2宜居度
- 来源: 原版
- 状态: 原版（被CIVITAS重分类为农业型）

**HONG_KONG（香港）**
- 内部ID: CIVILIZATION_HONG_KONG
- 宗主效果: 城市项目+20%生产力
- 来源: 原版
- 状态: 原版

**TORONTO（多伦多）**
- 内部ID: CIVILIZATION_TORONTO
- 宗主效果: 工业区和娱乐中心的区域效应范围+3
- 来源: 原版
- 状态: 原版（被CIVITAS在XP2中移除）

**CARDIFF（加的夫）**
- 内部ID: CIVILIZATION_CARDIFF
- 宗主效果: 每个港口建筑提供+2电力（灯塔+2，造船厂+2，海港+2）
- 来源: 风云变幻
- 状态: 原版

**MEXICO_CITY（墨西哥城）**
- 内部ID: CIVILIZATION_MEXICO_CITY
- 宗主效果: 工业区、娱乐中心、水上乐园的区域效应范围+3
- 来源: 风云变幻
- 状态: 原版

#### 宗教型 (RELIGIOUS)

**JERUSALEM（耶路撒冷）**
- 内部ID: CIVILIZATION_JERUSALEM
- 宗主效果: 自动皈依城邦所信仰的宗教（基础游戏）；圣地视为圣城（R&F新增）
- 来源: 原版 + R&F修改
- 状态: 原版

**KANDY（康提）**
- 内部ID: CIVILIZATION_KANDY
- 宗主效果: 首次发现自然奇观获得1件遗物；遗物产出+150%信仰
- 来源: 原版
- 状态: 原版

**LA_VENTA（拉文塔）**
- 内部ID: CIVILIZATION_LA_VENTA
- 宗主效果: 允许建造巨石头像改良设施
- 来源: 原版
- 状态: 原版

**YEREVAN（埃里温）**
- 内部ID: CIVILIZATION_YEREVAN
- 宗主效果: 使徒可从任意晋升中选择
- 来源: 原版
- 状态: 原版

**NAZCA（纳斯卡）**
- 内部ID: CIVILIZATION_NAZCA
- 宗主效果: 允许建造纳斯卡线条改良设施
- 来源: 风云变幻
- 状态: 原版

### 2.2 维京地标DLC/GS城邦 (6个)

**AUCKLAND（奥克兰）**
- 内部ID: CIVILIZATION_AUCKLAND
- 类型: 工业 (INDUSTRIAL)
- 宗主效果: 浅水单元格+1生产力；工业时代起额外+1生产力（总计+2）
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

**ANTANANARIVO（塔那那利佛）**
- 内部ID: CIVILIZATION_ANTANANARIVO
- 类型: 文化 (CULTURAL)
- 宗主效果: 每获得一位伟人，+2%文化值
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

**ARMAGH（阿马）**
- 内部ID: CIVILIZATION_ARMAGH
- 类型: 宗教 (RELIGIOUS)
- 宗主效果: 允许建造修道院改良设施（+2信仰，+4防御，+2驻防；GS中+2住房需2个相邻格，从区域获得+1信仰相邻加成，殖民主义后额外+1住房）
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

**GRANADA（格拉纳达）**
- 内部ID: CIVILIZATION_GRANADA
- 类型: 军事 (MILITARISTIC)
- 宗主效果: 允许建造阿尔卡萨城堡改良设施（+2文化，+4防御，+2驻防；GS中每2点魅力产出+1科技）
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

**MUSCAT（马斯喀特）**
- 内部ID: CIVILIZATION_MUSCAT
- 类型: 贸易 (TRADE)
- 宗主效果: 拥有商业中心的城市+1宜居度
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

**PALENQUE（帕伦克/米特拉）**
- 内部ID: CIVILIZATION_PALENQUE
- 显示名称注意: 内部ID为PALENQUE，但显示名称指向LOC_CIVILIZATION_MITLA_NAME（米特拉）
- 类型: 科技 (SCIENTIFIC)
- 宗主效果: 拥有学院的城市的城市成长速度+15%
- 来源: 维京地标DLC / 风云变幻
- 状态: 原版

### 2.3 风云变幻其他城邦 (3个)

**CAHOKIA（卡霍基亚）**
- 内部ID: CIVILIZATION_CAHOKIA
- 类型: 贸易 (TRADE)
- 宗主效果: 允许建造卡霍基亚土丘改良设施
- 来源: 风云变幻
- 状态: 原版（被CIVITAS重分类为农业型）

**FEZ（非斯）**
- 内部ID: CIVILIZATION_FEZ
- 类型: 科技 (SCIENTIFIC)
- 宗主效果: 使用宗教单位首次将城市皈依你的宗教时，每1人口获得+20科技值
- 来源: 风云变幻
- 状态: 原版

## 3. CIVITAS City-States 模组新增城邦

### 3.1 新增城邦类型说明

CIVITAS模组新增了4种城邦类型：
- **农业型 (AGRICULTURAL)**: 提供食物产出加成
- **海洋型 (MARITIME)**: 提供食物+生产力加成
- **娱乐型 (ENTERTAINMENT)**: 提供宜居度加成
- **领事型 (CONSULAR)**: XP1提供忠诚度压力，XP2提供外交支持

### 3.2 农业型城邦 (11个)

**ÇATALHÖYÜK（恰塔霍裕克）**
- 内部ID: CIVILIZATION_CSE_CATALHOYUK
- 宗主效果: 获得皮革和羊毛奢侈资源（各+6宜居度）
- 来源: CIVITAS模组
- 状态: 新增

**ETZANOA（埃扎诺阿）**
- 内部ID: CIVILIZATION_CSE_ETZANOA
- 宗主效果: 社区每相邻同类型区域+1住房
- 来源: CIVITAS模组
- 状态: 新增

**HVALSEY（赫瓦尔塞）**
- 内部ID: CIVILIZATION_CSE_HVALSEY
- 宗主效果: 在冻土/雪地/冰原2格内的渔船+1食物+1生产力
- 来源: CIVITAS模组
- 状态: 新增

**IQALUIT（伊魁特）**
- 内部ID: CIVILIZATION_CSE_IQALUIT
- 宗主效果: 相邻海岸的冻土和雪地+2食物
- 来源: CIVITAS模组
- 状态: 新增

**JOLO（霍洛）**
- 内部ID: CIVILIZATION_CSE_JOLO
- 宗主效果: 获得Abacá和Mangosteen奢侈资源（各+6宜居度）
- 来源: CIVITAS模组
- 状态: 新增

**KUHIKUGU（库希库古）**
- 内部ID: CIVILIZATION_CSE_KUHIKUGU
- 宗主效果: 相邻雨林的农场+1食物+2金币
- 来源: CIVITAS模组
- 状态: 新增

**MAINGMAW（迈恩茂）**
- 内部ID: CIVILIZATION_CSE_MAINGMAW
- 宗主效果: 相邻河流的改良地块+1食物+1金币
- 来源: CIVITAS模组
- 状态: 新增

**MEHRGARH（梅赫尔格尔）**
- 内部ID: CIVILIZATION_CSE_MEHRGARH
- 宗主效果: 收获资源和移除地貌+25%收益
- 来源: CIVITAS模组
- 状态: 新增

**SANA'A（萨那）**
- 内部ID: CIVILIZATION_CSE_SANAA
- 宗主效果: 商路经过每个国内贸易站+1食物
- 来源: CIVITAS模组
- 状态: 新增

**SRI KSETRA（室利差呾罗）**
- 内部ID: CIVILIZATION_CSE_SRI_KSETRA
- 宗主效果: 圣地提供等同于相邻信仰加成的食物
- 来源: CIVITAS模组
- 状态: 新增

**MARRAKECH（马拉喀什）**
- 内部ID: CIVILIZATION_CSE_MARRAKECH
- 宗主效果: 允许建造Riad改良设施（+1食物+1文化+0.5住房）
- 来源: CIVITAS模组
- 状态: 新增

### 3.3 海洋型城邦 (11个)

**AMPI（安比）**
- 内部ID: CIVILIZATION_CSE_AMPI
- 宗主效果: 获得玻璃奢侈资源（+6宜居度），种植园+1生产力
- 来源: CIVITAS模组
- 状态: 新增

**AYNUK（艾努克）**
- 内部ID: CIVILIZATION_CSE_AYNUK
- 宗主效果: 市中心每相邻一个海岸单元格+1食物+1生产力
- 来源: CIVITAS模组
- 状态: 新增

**BUTUAN（蒲端）**
- 内部ID: CIVILIZATION_CSE_BUTUAN
- 宗主效果: 陆上单位登船+2移动力，忽略登船/下船惩罚
- 来源: CIVITAS模组
- 状态: 新增

**DAKAR（达喀尔）**
- 内部ID: CIVILIZATION_CSE_DAKAR
- 宗主效果: 港口建筑+1大商人点数
- 来源: CIVITAS模组
- 状态: 新增

**DJIBOUTI（吉布提）**
- 内部ID: CIVILIZATION_CSE_DJIBOUTI
- 宗主效果: 浅水单元格+1食物，工业时代起额外+1（总计+2）
- 来源: CIVITAS模组
- 状态: 新增

**HAVANA（哈瓦那）**
- 内部ID: CIVILIZATION_CSE_HAVANA
- 宗主效果: 港口产出等同于相邻加成的文化，剧院广场产出等同于相邻加成的金币
- 来源: CIVITAS模组
- 状态: 新增

**HORMUZ（霍尔木兹）**
- 内部ID: CIVILIZATION_CSE_HORMUZ
- 宗主效果: 有港口区域的城市无法被围城
- 来源: CIVITAS模组
- 状态: 新增

**MOMBASA（蒙巴萨）**
- 内部ID: CIVILIZATION_CSE_MOMBASA
- 宗主效果: 专业区域从海岸获得少量相邻加成
- 来源: CIVITAS模组
- 状态: 新增

**NASSAU（拿骚）**
- 内部ID: CIVILIZATION_CSE_NASSAU
- 宗主效果: 掠夺海上商路收益翻倍
- 来源: CIVITAS模组
- 状态: 新增

**PORT ROYAL（皇家港）**
- 内部ID: CIVILIZATION_CSE_PORT_ROYAL
- 宗主效果: 商路目的地每个种植园+1金币+1生产力
- 来源: CIVITAS模组
- 状态: 新增

**UGARIT（乌加里特）**
- 内部ID: CIVILIZATION_CSE_UGARIT
- 宗主效果: 有总督城市+50%海军单位生产力
- 来源: CIVITAS模组
- 状态: 新增

### 3.4 娱乐型城邦 (7个)

**BAIAE（巴亚）**
- 内部ID: CIVILIZATION_CSE_BAIAE
- 宗主效果: 娱乐中心和水上乐园+1外交支持/回合
- 来源: CIVITAS模组
- 状态: 新增

**CHAN CHAN（昌昌）**
- 内部ID: CIVILIZATION_CSE_CHAN_CHAN
- 宗主效果: 宫殿收益翻倍，专业区域相邻政府区/娱乐中心/水上乐园+50%原生收益
- 来源: CIVITAS模组
- 状态: 新增

**DELOS（提洛）**
- 内部ID: CIVILIZATION_CSE_DELOS
- 宗主效果: 惊艳魅力平坦地块双倍地形收益（需娱乐中心/水上乐园）
- 来源: CIVITAS模组
- 状态: 新增

**MACAU（澳门）**
- 内部ID: CIVILIZATION_CSE_MACAU
- 宗主效果: 对有贸易路线的文明+25%旅游业绩
- 来源: CIVITAS模组
- 状态: 新增

**MONACO（摩纳哥）**
- 内部ID: CIVILIZATION_CSE_MONACO
- 宗主效果: 娱乐中心/水上乐园建筑+2旅游业绩，足以支付维护费
- 来源: CIVITAS模组
- 状态: 新增

**SIDON（西顿）**
- 内部ID: CIVILIZATION_CSE_SIDON
- 宗主效果: 所有平民单位+1移动力
- 来源: CIVITAS模组
- 状态: 新增

**MARRAKECH（马拉喀什）**
- 内部ID: CIVILIZATION_CSE_MARRAKECH
- 宗主效果: 允许建造Riad改良设施（+1食物+1文化+0.5住房）
- 来源: CIVITAS模组
- 状态: 新增

### 3.5 领事型城邦 (10个)

**AZCAPOTZALCO（阿斯卡波察尔科）**
- 内部ID: CIVILIZATION_CSE_AZCAPOTZALCO
- 宗主效果: 联盟点数获得速度+25%
- 来源: CIVITAS模组
- 状态: 新增

**CHETRO KETL（切特罗凯特）**
- 内部ID: CIVILIZATION_CSE_CHETRO_KETL
- 宗主效果: 允许建造Kiva改良设施（+2信仰+0.5住房，仅限沙漠/沙漠丘陵）
- 来源: CIVITAS模组
- 状态: 新增

**DELPHI（德尔斐）**
- 内部ID: CIVILIZATION_CSE_DELPHI
- 宗主效果: 奇观+2忠诚度压力，完成时触发文化炸弹
- 来源: CIVITAS模组
- 状态: 新增

**GUNDESHAPUR（贡德沙普尔）**
- 内部ID: CIVILIZATION_CSE_GUNDESHAPUR
- 宗主效果: 进入新时代获2个免费尤里卡，学院区每相邻2个区域+1科学
- 来源: CIVITAS模组
- 状态: 新增

**HADAD（哈达德）**
- 内部ID: CIVILIZATION_CSE_HADAD
- 宗主效果: 有总督城市+2宜居度
- 来源: CIVITAS模组
- 状态: 新增

**MZIZIMA（姆齐齐马）**
- 内部ID: CIVILIZATION_CSE_MZIZIMA
- 宗主效果: 有总督城市+15%人口增长
- 来源: CIVITAS模组
- 状态: 新增

**TANGIER（丹吉尔）**
- 内部ID: CIVILIZATION_CSE_TANGIER
- 宗主效果: 进入新时代获2个免费灵感，剧院区每相邻2个区域+1文化
- 来源: CIVITAS模组
- 状态: 新增

**VADUZ（瓦杜兹）**
- 内部ID: CIVILIZATION_CSE_VADUZ
- 宗主效果: 建筑购买费用-15%金币
- 来源: CIVITAS模组
- 状态: 新增

**VIENNA（维也纳）**
- 内部ID: CIVILIZATION_CSE_VIENNA
- 宗主效果: 有总督城市建筑购买费用-25%
- 来源: CIVITAS模组
- 状态: 新增

**GENEVA（日内瓦）** — 从科技型重分类
- 内部ID: CIVILIZATION_GENEVA
- 原类型: SCIENTIFIC → 新类型: CONSULAR
- 来源: CIVITAS模组重分类
- 状态: 修改

### 3.6 其他新增城邦（军事、科技、贸易、文化、工业、宗教）

**军事型 (10个新增):**
- BEIKTHANO（贝塔诺）- 每级城墙+3远程攻击力+5城防
- HAZOR（夏琐）- 单位受伤时满战力作战
- KADESH（卡迭石）- 重骑兵单位获得击退守军能力
- KANNAUJ（曲女城）- 境内战斗无厌战度
- MEGIDDO（米吉多）- 军营区国际商路+1生产力+2金币
- SALÉ（塞拉）- 海军劫掠单位获得额外攻击
- SEUTHOPOLIS（塞乌托波利斯）- 消灭敌方单位获得等于其战斗力的金币
- TISSAMAHARAMA（蒂瑟默哈拉默）- 陆地单位（侦察、近战、远程、反骑兵）+5战斗力
- ALAMUT（阿拉穆特）- 间谍可从任意晋升中选择
- LIMA（利马）- 有学院区可超过人口限制多建一个区域，学院区+20%生产力

**科技型 (6个新增):**
- IZAPA（伊萨帕）- 黄金时代尤里卡额外+10%科技成本，黑暗时代额外+时代分数
- LIMA（利马）- 见军事型
- NALANDA（那烂陀/塔克西拉）- 满意城市有学院+5%信仰，有圣地+5%科学；狂喜翻倍至+10%
- SAMARQAND（撒马尔罕）- 每个已获得伟人+2%科学，最多+30%
- TAOS（陶斯）- 采石场资源+2科学+1生产力
- VALABHI（伐腊毗）- 学院区产出等同于相邻加成的信仰，建筑可用信仰购买

**贸易型 (7个新增):**
- GARAMA（加赖马）- 绿洲及相邻+2食物，两格远+1食物
- MA'I（马伊）- 获得Beeswax和Betel Nut奢侈资源（各+6宜居度）
- PALMYRA（帕尔米拉）- 圣地建筑为每条经过的外国商路+1金币
- SINGAPORE（新加坡）- 每个派往城邦的使者+1金币
- TUNERIUT（图内留特）- 获得海象奢侈资源（+6宜居度），港口从雪地和冰原获得主要相邻加成
- URGENCH（乌尔根奇）- +1商路容量，沙漠城市国际商路+4金币
- HAVANA（哈瓦那）- 见海洋型

**文化型 (6个新增):**
- DODONA（多多纳）- 黄金时代灵感额外+10%市政成本，黑暗时代额外+时代分数
- GÖBEKLI TEPE（哥贝克力石阵）- 奇观所在城市国内贸易路线+1文化
- KELANIYA（凯拉尼亚）- 艺术巨作+2信仰，著作巨作+1文化
- SHAHR-E SUKHTÉ（沙赫尔苏赫特）- 不处于战争状态时+15%文化
- WYAM（怀亚姆）- 获得野生三文鱼奢侈资源（+6宜居度），渔船+1文化
- ANURADHAPURA（阿努拉德普勒）- 允许建造Dagoba改良设施（+1信仰+1文化，相邻圣地/剧院广场加成，随科技/文化树提升，首个Dagoba赠送遗物）

**工业型 (5个新增):**
- JOHANNESBURG（约翰内斯堡）- 工业区区域建筑6格内+2生产力+4金币
- PHASIS（法锡斯）- 相邻森林单元格+1生产力，相邻河流的伐木场+2金币
- QATNA（卡特纳）- 工业区建筑可用信仰购买，+1生产力
- TEYUNA（泰尤纳）- 相邻山脉的单元格+1生产力
- JOHANNESBURG（约翰内斯堡）- 见工业型

**宗教型 (5个新增):**
- ANURADHAPURA（阿努拉德普勒）- 见文化型
- HALIN（哈林）- 每人口+0.5信仰
- KATARAGAMA（卡塔拉加马）- 有淡水资源的单元格+1信仰
- HATTUSA（哈图沙）- 从科技型重分类为军事型
- MARRAKECH（马拉喀什）- 见农业型

## 4. 被CIVITAS模组修改/删除的原版内容

### 4.1 被重分类的城邦

| 城邦 | 原类型 | 新类型 |
|------|--------|--------|
| BUENOS_AIRES | INDUSTRIAL | CSE_AGRICULTURAL |
| BRUSSELS | INDUSTRIAL | CSE_CONSULAR |
| CAHOKIA | TRADE | CSE_AGRICULTURAL |
| GENEVA | SCIENTIFIC | CSE_CONSULAR |
| JAKARTA | TRADE | CSE_MARITIME |
| LISBON | TRADE | CSE_MARITIME |
| HATTUSA | SCIENTIFIC | MILITARISTIC |

### 4.2 被移除的城邦

| 城邦 | 在哪个扩展中移除 |
|------|------------------|
| AMSTERDAM | XP1 |
| CARTHAGE | XP2 |
| SEOUL | XP1 |
| STOCKHOLM | XP2 |
| TORONTO | XP2 |

### 4.3 被完全替换的城邦类型加成

CIVITAS模组完全替换了以下原版类型的使者奖励：
- CULTURAL（文化型）- 所有TraitModifiers被删除并替换
- INDUSTRIAL（工业型）- 所有TraitModifiers被删除并替换
- MILITARISTIC（军事型）- 所有TraitModifiers被删除并替换
- RELIGIOUS（宗教型）- 所有TraitModifiers被删除并替换
- SCIENTIFIC（科技型）- 所有TraitModifiers被删除并替换
- TRADE（贸易型）- 所有TraitModifiers被删除并替换

## 5. CIVITAS模组使者奖励体系

### 5.1 标准使者奖励（基础模式）

| 类型 | 1使者 | 3使者 | 6使者 | 10使者 |
|------|-------|-------|-------|--------|
| 科技 | 首都+2科学 | 图书馆+2科学 | 大学+2科学 | 研究实验室+2科学 |
| 文化 | 首都+2文化 | 圆形剧场+2文化 | 艺术/考古博物馆+2文化 | 广播中心+2文化 |
| 贸易 | 首都+4金币 | 市场/灯塔+4金币 | 银行/造船厂+4金币 | 证券交易所/海港+4金币 |
| 宗教 | 首都+2信仰 | 神社+2信仰 | 寺庙+2信仰 | 祭祀建筑+2信仰 |
| 军事 | 首都+2单位生产力 | 兵营/马厩+2单位生产力 | 军械库+2单位生产力 | 军事学院+2单位生产力 |
| 工业 | 首都+2区域/建筑生产力 | 作坊+2区域/建筑生产力 | 工厂+2区域/建筑生产力 | 发电厂+2区域/建筑生产力 |
| 农业 | 首都+2食物 | 粮仓+2食物 | 下水道+2食物 | 引水渠+2食物 |
| 娱乐 | 首都+1宜居度 | 竞技场+1宜居度 | 动物园+1宜居度 | 体育场+1宜居度 |
| 海洋 | 首都+1食物+1生产力 | 灯塔+1食物+1生产力 | 造船厂+1食物+1生产力 | 海港+1食物+1生产力 |
| 领事 | 首都+2忠诚度压力 | 所有城市+2忠诚度 | 所有城市+2忠诚度压力 | 有总督城市+2忠诚度压力 |

### 5.2 Ethiopia模式使者奖励

Ethiopia模式下，所有加成向下移动一个等级，并引入领事馆(CHANCERY)和大使馆(CONSULATE)建筑加成。

## 6. CIVITAS模组全局修改

### 6.1 城邦基础能力增强
- 城邦无厌战度（可选）
- 卫戍战斗力+6
- 城墙强度+6
- 远程攻击+6
- 城墙建造时间减半
- 城邦初始拥有城墙（可选）
- 城邦可建造任意区域（可选）
- 通过使者扩张领土
- 起始单元格数5
- 首次见面获1个使者（可选）
- 使者战斗力倍率2.0
- 额外起始战士+2、建造者+1
- 战时单位生产力+100%
- 单位升级免费
- 解放城邦使者数：远古-中世纪3，文艺复兴+6
- 保护国战争无需谴责且开局即可宣布

### 6.2 城邦忠诚度
- 城邦每回合忠诚度+20（默认）

## 7. 兼容性分析

### 7.1 与原版的冲突
- CIVITAS模组修改了所有原版城邦类型的使者奖励体系
- 重分类了7个城邦的类型
- 在特定扩展中移除了5个城邦
- 修改了城邦的基础能力（城墙、战斗力、起始单位等）

### 7.2 与新边境DLC城邦的兼容
- 模组识别并适配了新边境DLC的城邦（CAGUANA, HUNZA, LAHORE, SINGAPORE, TARUGA, VATICAN_CITY, NALANDA, JOHANNESBURG, SAMARKAND, AYUTTHAYA, WOLIN, CHINGUETTI）
- 如Firaxis的SINGAPORE和JOHANNESBURG存在，则删除CSE版本

### 7.3 已知问题
- PALENQUE的显示名称指向MITLA（米特拉），内部ID与显示名不一致
- JAKARTA的显示名称指向BANDAR_BRUNEI（文莱），内部ID与显示名不一致
- NALANDA在CIVITAS中被重命名为Taxila（塔克西拉）
- SAMARKAND在CIVITAS中被重命名为Bukhara（布哈拉）

## 8. 关联改良设施一览

| 改良设施 | 来源城邦 | 效果 |
|----------|---------|------|
| IMPROVEMENT_COLOSSAL_HEAD | LA_VENTA | 巨石头像 |
| IMPROVEMENT_MONASTERY | ARMAGH | 修道院（+2信仰，+2住房） |
| IMPROVEMENT_ALCAZAR | GRANADA | 阿尔卡萨城堡（+2文化，+4防御，魅力转科技） |
| IMPROVEMENT_MOUND | CAHOKIA | 卡霍基亚土丘 |
| IMPROVEMENT_NAZCA_LINE | NAZCA | 纳斯卡线条 |
| IMPROVEMENT_MOAI | RAPA_NUI | 摩艾石像 |
| IMPROVEMENT_CSE_DAGOBA | ANURADHAPURA | Dagoba（+1信仰+1文化） |
| IMPROVEMENT_CSE_RIAD | MARRAKECH | Riad（+1食物+1文化+0.5住房） |
| IMPROVEMENT_CSE_KIVA | CHETRO KETL | Kiva（+2信仰+0.5住房，仅沙漠） |

---

报告生成时间: 2026-07-04
数据来源: /workspace/原版+DLC/ + /workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/