# Civilization VI 城邦 (City-State) 完整分析报告

> 生成时间: 2026-07-06
> 数据来源: 原版 / DLC(迭起兴衰/风云变幻/新边疆) / CIVITAS City-States Expanded
> 总条目数: 108 (原版40 + DLC18 + CSE新增50)

---

## 1. 总览

### 1.1 城邦类型一览

| 类型ID | 中文名 | 使者加成 | 来源 |
|--------|--------|----------|------|
| SCIENTIFIC | 科技型 | 1使者: 首都+2科技; 3使者: 每图书馆+2科技; 6使者: 每大学+2科技 | 原版 |
| RELIGIOUS | 宗教型 | 1使者: 首都+2信仰; 3使者: 每神社+2信仰; 6使者: 每寺庙+2信仰 | 原版 |
| TRADE | 贸易型 | 1使者: 首都+4金币; 3使者: 每市场+4金币; 6使者: 每银行+4金币 | 原版 |
| CULTURAL | 文化型 | 1使者: 首都+2文化; 3使者: 每纪念碑+2文化; 6使者: 每艺术博物馆+2文化 | 原版 |
| MILITARISTIC | 军事型 | 1使者: 首都+2生产力(造兵); 3使者: 每兵营+2生产力; 6使者: 每军械库+2生产力 | 原版 |
| INDUSTRIAL | 工业型 | 1使者: 首都+2生产力(造建筑/奇观); 3使者: 每工坊+2生产力; 6使者: 每工厂+2生产力 | 原版 |
| CSE_AGRICULTURAL | 农业型 | 1使者: 首都+2食物; 3使者: 每水磨/粮仓+2食物; 6使者: 每下水道+2食物 | CSE新增 |
| CSE_CONSULAR | 领事型 | 1使者: 城邦自身+2外交支持; 3使者: 每市政广场建筑+2外交支持; 6使者: 每外交区建筑+2外交支持 | CSE新增(需XP2) |
| CSE_ENTERTAINMENT | 娱乐型 | 1使者: 首都+2宜居度; 3使者: 每娱乐中心+2宜居度; 6使者: 每水上乐园+2宜居度 | CSE新增 |
| CSE_MARITIME | 海事型 | 1使者: 首都+2食物+2生产力(仅沿海); 3使者: 每灯塔+2食物+2生产力; 6使者: 每船坞+2食物+2生产力 | CSE新增 |

### 1.2 条目统计

| 来源 | 原版保留 | 新增 | 修改 | 被删除 |
|------|:-------:|:----:|:----:|:------:|
| 原版 | 16 | 0 | 2 | 2 |
| DLC(迭起兴衰/风云变幻) | 16 | 0 | 0 | 2 |
| DLC(新边疆NF1) | 6 | 0 | 0 | 0 |
| DLC(新边疆NF4) | 6 | 0 | 0 | 0 |
| CIVITAS CSE Base | 0 | 42 | 6 | 0 |
| CIVITAS CSE XP1 | 0 | 17 | 2 | 0 |
| CIVITAS CSE XP2 | 0 | 9 | 2 | 0 |
| **合计** | **44** | **68** | **12** | **4** |

---

## 2. 详细数据表

### 2.1 原版城邦（被CSE重新分类）

以下原版城邦在CSE模组中被重新分配到新的城邦类型。宗主权效果保持不变，但使者加成随新类型改变。

| # | 中文名 | 英文名 | 内部ID | 原版类型 | CSE类型 | 宗主权效果 | 来源 | 状态 |
|---|--------|--------|--------|----------|---------|------------|------|------|
| 1 | 布宜诺斯艾利斯 | Buenos Aires | BUENOS_AIRES | INDUSTRIAL | CSE_AGRICULTURAL | 奖励资源提供如同奢侈品资源一样的1点宜居度 | 原版 | 修改(类型) |
| 2 | 布鲁塞尔 | Brussels | BRUSSELS | INDUSTRIAL | CSE_CONSULAR | 城市建造奇观时+15%生产力 | 原版 | 修改(类型) |
| 3 | 迦太基 | Carthage | CARTHAGE | MILITARISTIC | MILITARISTIC | 每个营地提供+1贸易路线容量 | 原版 | 原版(移除XP2) |
| 4 | 日内瓦 | Geneva | GENEVA | SCIENTIFIC | CSE_CONSULAR | 未与任何主要文明交战时+10%科技值 | 原版 | 修改(效果+类型) |
| 5 | 喀布尔 | Kabul | KABUL | MILITARISTIC | MILITARISTIC | 单位攻击时获得双倍经验值 | 原版 | 原版 |
| 6 | 康提 | Kandy | KANDY | RELIGIOUS | RELIGIOUS | 发现自然奇观时获得1件圣遗物 | 原版 | 原版 |
| 7 | 拉文塔 | La Venta | LA_VENTA | RELIGIOUS | RELIGIOUS | 建造者可以建造巨石头像改良设施 | 原版 | 原版 |
| 8 | 里斯本 | Lisbon | LISBON | TRADE | CSE_MARITIME | 商路免受海上掠夺 | 原版 | 修改(类型) |
| 9 | 摩亨朱达罗 | Mohenjo Daro | MOHENJO_DARO | CULTURAL | CULTURAL | 城市无论是否靠近淡水都有完整的住房 | 原版 | 原版 |
| 10 | 耶路撒冷 | Jerusalem | JERUSALEM | RELIGIOUS | RELIGIOUS | 自动皈依其宗教并向所有城市施加宗教压力 | 原版 | 原版 |
| 11 | 哈图沙 | Hattusa | HATTUSA | MILITARISTIC | MILITARISTIC | 每回合获得1个你没有的战略资源 | 原版 | 原版 |
| 12 | 普雷斯拉夫 | Preslav | PRESLAV | MILITARISTIC | MILITARISTIC | 丘陵上的城市获得+2忠诚度 | 原版 | 原版 |
| 13 | 瓦莱塔 | Valletta | VALLETTA | MILITARISTIC | MILITARISTIC | 可用信仰购买市中心建筑和军事建筑 | 原版 | 原版 |
| 14 | 维尔纽斯 | Vilnius | VILNIUS | CULTURAL | CULTURAL | 剧院广场获得最高等级相邻加成时触发文化炸弹 | 原版 | 原版 |
| 15 | 桑给巴尔 | Zanzibar | ZANZIBAR | TRADE | TRADE | 获得丁香和肉桂奢侈品资源 | 原版 | 原版 |
| 16 | 香港 | Hong Kong | HONG_KONG | INDUSTRIAL | INDUSTRIAL | 城市项目+20%生产力 | 原版 | 原版 |
| 17 | 雅加达 | Jakarta | JAKARTA | TRADE | CSE_MARITIME | 国际商路每有一种奢侈品资源+1金币 | 原版 | 修改(类型) |
| 18 | 库马西 | Kumasi | KUMASI | CULTURAL | CULTURAL | 通往城邦的商路每有一种专业区域+2文化+1金币 | 原版 | 原版 |
| 19 | 首尔 | Seoul | SEOUL | SCIENTIFIC | SCIENTIFIC | 进入新时代时获得1次随机科技尤里卡 | 原版 | 原版(移除XP1) |
| 20 | 斯德哥尔摩 | Stockholm | STOCKHOLM | SCIENTIFIC | SCIENTIFIC | 每种伟人+1大科学家点数 | 原版 | 原版(移除XP2) |
| 21 | 多伦多 | Toronto | TORONTO | INDUSTRIAL | INDUSTRIAL | 区域影响范围+3格 | 原版 | 原版(移除XP2) |
| 22 | 埃里温 | Yerevan | YEREVAN | RELIGIOUS | RELIGIOUS | 使徒可以从所有可用升级中选择 | 原版 | 原版 |
| 23 | 阿姆斯特丹 | Amsterdam | AMSTERDAM | TRADE | TRADE | 通往外国城市的商路+1金币 | 原版 | 原版(移除XP1) |
| 24 | 南马都尔 | Nan Madol | NAN_MADOL | CULTURAL | CULTURAL | 沿海区域+2文化 | 原版 | 原版 |

### 2.2 DLC城邦 (迭起兴衰/风云变幻)

| # | 中文名 | 英文名 | 内部ID | 类型 | 宗主权效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------------|------|------|
| 25 | 安塔那那利佛 | Antananarivo | ANTANANARIVO | CULTURAL | 每获得1位伟人+1%文化值，最多+30% | DLC2 | 修改(效果) |
| 26 | 阿马 | Armagh | ARMAGH | RELIGIOUS | 建造者可以建造修道院改良设施 | DLC2 | 原版 |
| 27 | 奥克兰 | Auckland | AUCKLAND | INDUSTRIAL | 浅水单元格+1生产力，工业时代后+2 | DLC2 | 原版 |
| 28 | 格拉纳达 | Granada | GRANADA | MILITARISTIC | 建造者可以建造阿尔卡萨城堡改良设施 | DLC2 | 原版 |
| 29 | 马斯喀特 | Muscat | MUSCAT | TRADE | 每种奢侈资源+1宜居度 | DLC2 | 原版 |
| 30 | 帕伦克 | Palenque | PALENQUE | SCIENTIFIC | 城市生长率+15% | DLC2 | 原版 |
| 31 | 安条克 | Antioch | ANTIOCH | TRADE | 每条商路+1金币 | XP1 | 原版 |
| 32 | 巴比伦 | Babylon | BABYLON | SCIENTIFIC | 每本著作+2科技 | XP1 | 原版 |
| 33 | 博洛尼亚 | Bologna | BOLOGNA | SCIENTIFIC | 拥有专业区域的城市+1大科学家点数 | XP2 | 原版 |
| 34 | 加的夫 | Cardiff | CARDIFF | INDUSTRIAL | 沿海城市每回合+2电力 | XP2 | 原版 |
| 35 | 非斯 | Fez | FEZ | SCIENTIFIC | 每皈依一座城市获得20倍该城科技产出 | XP2 | 原版 |
| 36 | 墨西哥城 | Mexico City | MEXICO_CITY | INDUSTRIAL | 区域影响范围+3格 | XP2 | 原版 |
| 37 | 纳斯卡 | Nazca | NAZCA | RELIGIOUS | 建造者可以建造纳斯卡线条改良设施 | XP2 | 原版 |
| 38 | 恩加扎加穆 | Ngazargamu | NGAZARGAMU | MILITARISTIC | 每有1个营地建筑，购买单位折扣-20% | XP2 | 原版 |
| 39 | 拉帕努伊 | Rapa Nui | RAPA_NUI | CULTURAL | 建造者可以建造摩艾石像改良设施 | XP2 | 原版 |
| 40 | 卡瓜纳 | Caguana | CAGUANA | CULTURAL | 建造者可以建造巴泰伊球场改良设施 | NF1 | 原版 |
| 41 | 罕萨 | Hunza | HUNZA | TRADE | 每条商路每有3格距离+1金币 | NF1 | 原版 |
| 42 | 拉合尔 | Lahore | LAHORE | MILITARISTIC | 可用信仰购买尼罕武士 | NF1 | 原版 |
| 43 | 新加坡 | Singapore | SINGAPORE | INDUSTRIAL | 每条通往城邦盟友的商路+2生产力 | NF1 | 原版 |
| 44 | 塔鲁加 | Taruga | TARUGA | SCIENTIFIC | 每有1个战略资源+5%科技 | NF1 | 原版 |
| 45 | 梵蒂冈城 | Vatican City | VATICAN_CITY | RELIGIOUS | 伟人激活时传播400点宗教压力 | NF1 | 原版 |
| 46 | 那烂陀 | Nalanda | NALANDA | SCIENTIFIC | 建造者可以建造摩诃毗诃罗改良设施 | NF4 | 原版 |
| 47 | 约翰内斯堡 | Johannesburg | JOHANNESBURG | INDUSTRIAL | 每有一种改良资源+1生产力 | NF4 | 原版 |
| 48 | 撒马尔罕/布哈拉 | Samarkand/Bukhara | SAMARKAND | TRADE | 建造者可以建造商队旅馆改良设施 | NF4 | 原版(CSE改名) |
| 49 | 大城 | Ayutthaya | AYUTTHAYA | CULTURAL | 建造者可以建造大象营改良设施 | NF4 | 原版 |
| 50 | 沃林 | Wolin | WOLIN | MILITARISTIC | 建造者可以建造要塞改良设施 | NF4 | 原版 |
| 51 | 钦圭蒂 | Chinguetti | CHINGUETTI | RELIGIOUS | 国际商路每有1个追随者+1信仰 | NF4 | 原版 |

### 2.3 CSE新增城邦 (Base)

| # | 中文名 | 英文名 | 内部ID | 类型 | 宗主权效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------------|------|------|
| 52 | 安普 | Ampi | CSE_AMPI | CSE_MARITIME | 获得玻璃奢侈品资源(不可交易,提供6宜居度); 种植园+1生产力 | CSE Base | 新增 |
| 53 | 阿努拉德普勒 | Anuradhapura | CSE_ANURADHAPURA | RELIGIOUS | 圣城获得+2信仰; 每个圣遗物+4信仰 | CSE Base | 新增 |
| 54 | 艾努克 | Aynuk | CSE_AYNUK | CSE_MARITIME | 沿海城市+10%生产力; 港口+2生产力 | CSE Base | 新增 |
| 55 | 贝塔诺 | Beikthano | CSE_BEIKTHANO | MILITARISTIC | 单位在城市中心+5战斗力 | CSE Base | 新增 |
| 56 | 武端 | Butuan | CSE_BUTUAN | CSE_MARITIME | 陆地单位登船+2移动力，忽略上下船额外移动力消耗 | CSE Base | 新增 |
| 57 | 加泰土丘 | Catalhoyuk | CSE_CATALHOYUK | CSE_AGRICULTURAL | 城市每有2人口+1食物 | CSE Base | 新增 |
| 58 | 查科凯特尔 | Chetro Ketl | CSE_CHETRO_KETL | CSE_CONSULAR | 未改良地块+2信仰 | CSE Base | 新增 |
| 59 | 达喀尔 | Dakar | CSE_DAKAR | CSE_MARITIME | 浅水单元格+1食物; 工业时代后额外+1食物 | CSE Base | 新增 |
| 60 | 吉布提 | Djibouti | CSE_DJIBOUTI | CSE_MARITIME | 浅水单元格+1食物; 工业时代后额外+1食物 | CSE Base | 新增 |
| 61 | 埃扎诺瓦 | Etzanoa | CSE_ETZANOA | CSE_AGRICULTURAL | 所有城市+15%成长率 | CSE Base | 新增 |
| 62 | 加拉马 | Garama | CSE_GARAMA | TRADE | 绿洲及其相邻地块+1食物; 两格远地块+1食物 | CSE Base | 修改(效果) |
| 63 | 哥贝克力石阵 | Gobekli Tepe | CSE_GOBEKLI_TEPE | CULTURAL | 发现自然奇观时获得1件圣遗物和1个建造者 | CSE Base | 新增 |
| 64 | 夏琐 | Hazor | CSE_HAZOR | MILITARISTIC | 城市每有1个专业区域+2战斗力 | CSE Base | 新增 |
| 65 | 伊卡卢伊特 | Iqaluit | CSE_IQALUIT | CSE_AGRICULTURAL | 冻土和雪地单元格+1食物+1生产力 | CSE Base | 新增 |
| 66 | 霍洛 | Jolo | CSE_JOLO | CSE_AGRICULTURAL | 每个沿海城市+1食物; 每个渔船+1金币 | CSE Base | 新增 |
| 67 | 加低斯 | Kadesh | CSE_KADESH | MILITARISTIC | 单位在友方领土+5战斗力 | CSE Base | 新增 |
| 68 | 曲女城 | Kannauj | CSE_KANNAUJ | MILITARISTIC | 单位升级花费-25% | CSE Base | 新增 |
| 69 | 卡塔拉伽马 | Kataragama | CSE_KATARAGAMA | RELIGIOUS | 圣地区域+2文化 | CSE Base | 新增 |
| 70 | 凯拉尼亚 | Kelaniya | CSE_KELANIYA | CULTURAL | 剧院广场+2信仰 | CSE Base | 新增 |
| 71 | 库希库古 | Kuhikugu | CSE_KUHIKUGU | CSE_AGRICULTURAL | 雨林单元格+1食物+1生产力 | CSE Base | 新增 |
| 72 | 利马 | Lima | CSE_LIMA | SCIENTIFIC | 学院区及其建筑+20%生产力; 学院区+3生产力 | CSE Base | 修改(效果) |
| 73 | 澳门 | Macau | CSE_MACAU | CSE_ENTERTAINMENT | 对拥有商路的文明+25%旅游业绩 | CSE Base | 新增 |
| 74 | 迈 | Mai | CSE_MAI | TRADE | 国际贸易路线+2金币每专业区域 | CSE Base | 新增 |
| 75 | 迈莫 | Maingmaw | CSE_MAINGMAW | CSE_AGRICULTURAL | 每个种植园+1食物; 每个牧场+1生产力 | CSE Base | 新增 |
| 76 | 马拉克什 | Marrakech | CSE_MARRAKECH | MILITARISTIC | 每条商路+2战斗力 | CSE Base | 新增 |
| 77 | 米吉多 | Megiddo | CSE_MEGIDDO | MILITARISTIC | 骑兵单位+5战斗力 | CSE Base | 新增 |
| 78 | 蒙巴萨 | Mombasa | CSE_MOMBASA | CSE_MARITIME | 专业区域从沿海单元格获得小相邻加成 | CSE Base | 新增 |
| 79 | 拿骚 | Nassau | CSE_NASSAU | CSE_MARITIME | 掠夺海上商路产出翻倍 | CSE Base | 新增 |
| 80 | 帕尔米拉 | Palmyra | CSE_PALMYRA | TRADE | 每条商路+1文化+1信仰 | CSE Base | 新增 |
| 81 | 法希斯 | Phasis | CSE_PHASIS | INDUSTRIAL | 战略资源+1生产力 | CSE Base | 新增 |
| 82 | 夸特纳 | Qatna | CSE_QATNA | INDUSTRIAL | 每座城市+1%生产力每时代 | CSE Base | 新增 |
| 83 | 萨莱 | Sale | CSE_SALE | MILITARISTIC | 海军单位+5战斗力 | CSE Base | 新增 |
| 84 | 撒马尔罕 | Samarqand | CSE_SAMARQAND | SCIENTIFIC | 每获得1位伟人+1%科技值，最多+30% | CSE Base | 修改(效果) |
| 85 | 萨那 | Sanaa | CSE_SANAA | CSE_AGRICULTURAL | 绿洲+2食物; 沙漠+1食物 | CSE Base | 新增 |
| 86 | 修托波利斯 | Seuthopolis | CSE_SEUTHOPOLIS | MILITARISTIC | 城市每有1个城墙建筑+3战斗力 | CSE Base | 新增 |
| 87 | 沙赫尔苏赫特 | Shahr-e-Sukhte | CSE_SHAHR_E_SUKHTE | CULTURAL | 不处于战争状态时+10%文化 | CSE Base | 修改(效果) |
| 88 | 西顿 | Sidon | CSE_SIDON | CSE_ENTERTAINMENT | 所有平民单位+1移动力 | CSE Base | 新增 |
| 89 | 新加坡(CS) | Singapore | CSE_SINGAPORE | TRADE | 每派往城邦的1个使者+1金币 | CSE Base | 新增(NF1冲突时移除) |
| 90 | 室利差呾罗 | Sri Ksetra | CSE_SRI_KSETRA | RELIGIOUS | 圣地区域+3食物 | CSE Base | 修改(效果+类型) |
| 91 | 道斯 | Taos | CSE_TAOS | SCIENTIFIC | 每个奇观+3科技 | CSE Base | 新增 |
| 92 | 蒂萨马哈拉马 | Tissamaharama | CSE_TISSAMAHARAMA | MILITARISTIC | 每回合+1大将军点数 | CSE Base | 新增 |
| 93 | 图内留特 | Tuneriut | CSE_TUNERIUT | TRADE | 每条商路+1生产力 | CSE Base | 新增 |
| 94 | 乌尔根奇 | Urgench | CSE_URGENCH | TRADE | 每条国际商路+2金币 | CSE Base | 新增 |
| 95 | 乌加里特 | Ugarit | CSE_UGARIT | CSE_MARITIME | 沿海城市+15%生产力 | CSE Base | 新增 |
| 96 | 伐拉彼 | Valabhi | CSE_VALABHI | SCIENTIFIC | 学院区+2信仰; 学院区建筑可用信仰购买 | CSE Base | 修改(效果) |
| 97 | 瓦杜兹 | Vaduz | CSE_VADUZ | CSE_CONSULAR | 建筑购买花费-15%金币 | CSE Base | 新增 |
| 98 | 维亚姆 | Wyam | CSE_WYAM | CULTURAL | 未改良森林+1文化+1信仰 | CSE Base | 新增 |

### 2.4 CSE新增城邦 (XP1/迭起兴衰)

| # | 中文名 | 英文名 | 内部ID | 类型 | 宗主权效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------------|------|------|
| 99 | 阿斯卡波察尔科 | Azcapotzalco | CSE_AZCAPOTZALCO | CSE_CONSULAR | 联盟点数获取速度+25% | CSE XP1 | 新增 |
| 100 | 昌昌 | Chan Chan | CSE_CHAN_CHAN | CSE_ENTERTAINMENT | 宫殿产出翻倍; 专业区域与市政广场/娱乐中心/水上乐园相邻时+50%原生产出 | CSE XP1 | 新增 |
| 101 | 提洛 | Delos | CSE_DELOS | CSE_ENTERTAINMENT | 拥有娱乐中心或水上乐园的城市中，惊艳魅力的平坦地块双倍地形产出 | CSE XP1 | 新增 |
| 102 | 德尔斐 | Delphi | CSE_DELPHI | CSE_CONSULAR | 奇观施加+2忠诚度压力并完成后触发文化炸弹 | CSE XP1 | 新增 |
| 103 | 多多纳 | Dodona | CSE_DODONA | CULTURAL | 黄金时代灵感额外+5%市政; 黑暗时代额外+时代分 | CSE XP1 | 修改(效果) |
| 104 | 哈达德 | Hadad | CSE_HADAD | CSE_CONSULAR | 有已建立总督的城市+2宜居度 | CSE XP1 | 新增 |
| 105 | 哈林 | Halin | CSE_HALIN | RELIGIOUS | 城市每有1人口+0.5信仰 | CSE XP1 | 新增 |
| 106 | 哈瓦那 | Havana | CSE_HAVANA | CSE_MARITIME | 港口产出等同于相邻加成的文化; 剧院广场产出等同于相邻加成的金币 | CSE XP1 | 新增 |
| 107 | 霍尔木兹 | Hormuz | CSE_HORMUZ | CSE_MARITIME | 商路每经过1个沿海城市+2金币 | CSE XP1 | 新增 |
| 108 | 伊萨帕 | Izapa | CSE_IZAPA | SCIENTIFIC | 黄金时代尤里卡额外+5%科技; 黑暗时代额外+时代分 | CSE XP1 | 修改(效果) |
| 109 | 约翰内斯堡(CS) | Johannesburg | CSE_JOHANNESBURG | INDUSTRIAL | 每个改良资源+1生产力 | CSE XP1 | 新增(NF4冲突时移除) |
| 110 | 梅赫尔格尔 | Mehrgarh | CSE_MEHRGARH | CSE_AGRICULTURAL | 收获地块和移除地貌+25%产出 | CSE XP1 | 新增 |
| 111 | 摩纳哥 | Monaco | CSE_MONACO | CSE_ENTERTAINMENT | 娱乐中心和水上乐园建筑+2旅游业绩并产出足够支付维护费的金币 | CSE XP1 | 新增 |
| 112 | 姆齐齐马 | Mzizima | CSE_MZIZIMA | CSE_CONSULAR | 每个已建立总督的城市+1外交支持 | CSE XP1 | 新增 |
| 113 | 那烂陀(CS) | Nalanda (Taxila) | CSE_NALANDA | SCIENTIFIC | 每个专业区域+1科技 | CSE XP1 | 新增(NF4冲突时改名) |
| 114 | 皇家港 | Port Royal | CSE_PORT_ROYAL | CSE_MARITIME | 商路目的地每有1个种植园+1金币+1生产力 | CSE XP1 | 新增 |
| 115 | 乌加里特 | Ugarit | CSE_UGARIT | CSE_MARITIME | 沿海城市+15%生产力 | CSE XP1 | 新增 |

### 2.5 CSE新增城邦 (XP2/风云变幻)

| # | 中文名 | 英文名 | 内部ID | 类型 | 宗主权效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------------|------|------|
| 116 | 阿拉穆特 | Alamut | CSE_ALAMUT | MILITARISTIC | 间谍可从所有升级中选择 | CSE XP2 | 新增 |
| 117 | 拜亚 | Baiae | CSE_BAIAE | CSE_ENTERTAINMENT | 娱乐中心和水上乐园每回合+1外交支持 | CSE XP2 | 新增 |
| 118 | 贡迪沙普尔 | Gundeshapur | CSE_GUNDESHAPUR | CSE_CONSULAR | 新时代获1免费尤里卡; 学院区每相邻2区域+1科学 | CSE XP2 | 修改(效果) |
| 119 | 赫瓦尔塞 | Hvalsey | CSE_HVALSEY | CSE_AGRICULTURAL | 冻土/雪地/冰面2格内的渔船+1食物+1生产力 | CSE XP2 | 新增 |
| 120 | 丹吉尔 | Tangier | CSE_TANGIER | CSE_CONSULAR | 新时代获1免费灵感; 剧院区每相邻2区域+1文化 | CSE XP2 | 修改(效果) |
| 121 | 特尤纳 | Teyuna | CSE_TEYUNA | INDUSTRIAL | 领土内与山脉相邻的单元格+1生产力 | CSE XP2 | 新增 |
| 122 | 瓦杜兹 | Vaduz | CSE_VADUZ | CSE_CONSULAR | 建筑购买花费-15%金币 | CSE XP2 | 新增(与Base中CSE_VADUZ重复) |
| 123 | 维也纳 | Vienna | CSE_VIENNA | CSE_CONSULAR | 已建立总督的城市建筑购买-25%费用 | CSE XP2 | 新增 |

---

## 3. 关联数据

### 3.1 城邦类型使者加成定义

| 类型 | 1使者加成 | 3使者加成 | 6使者加成 |
|------|-----------|-----------|-----------|
| SCIENTIFIC | 首都+2科技 | 每图书馆+2科技 | 每大学+2科技 |
| RELIGIOUS | 首都+2信仰 | 每神社+2信仰 | 每寺庙+2信仰 |
| TRADE | 首都+4金币 | 每市场+4金币 | 每银行+4金币 |
| CULTURAL | 首都+2文化 | 每纪念碑+2文化 | 每艺术博物馆+2文化 |
| MILITARISTIC | 首都+2生产力(造兵) | 每兵营+2生产力 | 每军械库+2生产力 |
| INDUSTRIAL | 首都+2生产力(造建筑/奇观) | 每工坊+2生产力 | 每工厂+2生产力 |
| CSE_AGRICULTURAL | 首都+2食物 | 每水磨+2食物; 每粮仓+2食物 | 每下水道+2食物 |
| CSE_CONSULAR | 城邦自身+2外交支持 | 每市政广场1级建筑+2外交支持 | 每外交区建筑+2外交支持 |
| CSE_ENTERTAINMENT | 首都+2宜居度 | 每娱乐中心+2宜居度 | 每水上乐园+2宜居度 |
| CSE_MARITIME | 首都+2食物+2生产力(仅沿海) | 每灯塔+2食物+2生产力 | 每船坞+2食物+2生产力 |

### 3.2 CSE新增奢侈资源

| 资源ID | 中文名 | 英文名 | 提供 | 来源 |
|--------|--------|--------|------|------|
| RESOURCE_CSE_GLASS | 玻璃 | Glass | +6宜居度(不可交易) | CSE Ampi |

---

## 4. 被修改/删除的原版内容

### 4.1 CSE_Modifications.sql 修改详情

| 原版/Mod条目 | 中文名 | 修改内容 | 修改前 | 修改后 |
|-------------|--------|----------|--------|--------|
| GENEVA | 日内瓦 | Amount值 | +15%科技值 | +10%科技值 |
| ANTANANARIVO | 安塔那那利佛 | Amount值 | +2%文化/伟人 | +1%文化/伟人 |
| CSE_IZAPA | 伊萨帕 | Amount值 | +10%尤里卡 | +5%尤里卡 |
| CSE_DODONA | 多多纳 | Amount值 | +10%灵感 | +5%灵感 |
| CSE_SAMARQAND | 撒马尔罕 | Amount值 | +2%科技/伟人 | +1%科技/伟人 |
| CSE_SHAHR_E_SUKHTE | 沙赫尔苏赫特 | Amount值 | +15%文化 | +10%文化 |
| CSE_GUNDESHAPUR | 贡迪沙普尔 | Amount值 | 2免费尤里卡 | 1免费尤里卡 |
| CSE_TANGIER | 丹吉尔 | Amount值 | 2免费灵感 | 1免费灵感 |
| CSE_GARAMA | 加拉马 | Amount值 | 绿洲上+2食物 | 绿洲上+1食物 |
| CSE_LIMA | 利马 | 完全重新设计 | 有学院的城市可额外建1区域; 学院+20%生产力 | 学院及建筑+20%生产力; 学院+3生产力 |
| CSE_VALABHI | 伐拉彼 | 效果重做 | 学院产出等同于相邻加成的信仰; 建筑可用信仰购买 | 学院+2信仰; 建筑可用信仰购买 |
| CSE_SRI_KSETRA | 室利差呾罗 | 类型+效果重做 | AGRICULTURAL; 圣地食物=信仰相邻加成 | RELIGIOUS; 圣地+3食物 |

### 4.2 被移除的原版城邦

| 原版条目ID | 中文名 | 操作 | 原因 |
|------------|--------|------|------|
| AMSTERDAM | 阿姆斯特丹 | 被XP1移除 | 原版CSE_Master标记Removed='XP1' |
| SEOUL | 首尔 | 被XP1移除 | 原版CSE_Master标记Removed='XP1' |
| CARTHAGE | 迦太基 | 被XP2移除 | 原版CSE_Master标记Removed='XP2' |
| STOCKHOLM | 斯德哥尔摩 | 被XP2移除 | 原版CSE_Master标记Removed='XP2' |
| TORONTO | 多伦多 | 被XP2移除 | 原版CSE_Master标记Removed='XP2' |

---

## 5. 兼容性分析

### 5.1 冲突处理

| 冲突 | 处理方式 | 结果 |
|------|----------|------|
| CSE_SINGAPORE vs NF1 SINGAPORE | CSE Config检测到原版新加坡存在时自动删除CSE版本 | 使用原版 |
| CSE_JOHANNESBURG vs NF4 JOHANNESBURG | CSE Config检测到原版约翰内斯堡存在时自动删除CSE版本 | 使用原版 |
| CSE_NALANDA vs NF4 NALANDA | CSE_NALANDA改为Taxila(塔克西拉) | 两者共存 |
| CSE_SAMARKAND vs NF4 SAMARKAND | CSE将原版撒马尔罕城市名改为布哈拉(Bukhara) | 两者共存 |

### 5.2 加载顺序

CSE模组加载顺序（InGameActions）:
1. LoadOrder 1: CSE_Master (框架/类型定义)
2. LoadOrder 40: CSE_Types (城邦类型定义)
3. LoadOrder 60: CSE_CityStates (主城邦定义)
4. LoadOrder 62: CSE_CityStates_XP2 (XP2额外城邦)
5. LoadOrder 65-67: 各城邦个体SQL文件
6. LoadOrder 68: **CSE_Modifications.sql** (对已有城邦的修改)
7. LoadOrder 1000: CSE_Globals (全局设置)

CSE_Modifications.sql 在 LoadOrder 68 加载，晚于所有城邦定义文件(60-67)，因此其UPDATE/DELETE/INSERT操作会覆盖所有之前的定义。

### 5.3 风险提示

- **类型重分类**: 多个原版城邦被重新分类(Buenos Aires→AGRICULTURAL, Brussels→CONSULAR等)，这可能影响依赖原版使者加成机制的策略
- **日内瓦/安塔那那利佛削弱**: 这两个原版城邦的宗主权效果被削弱，可能影响游戏平衡
- **CSE新加坡/约翰内斯堡**: 如果启用了NF1/NF4，这两个城邦的CSE版本会被自动移除

---

## 附录: 文件索引

### 关键源文件

| 文件 | 用途 |
|------|------|
| Core/Framework/CSE_Master.sql | 城邦主表(类型定义/分类) |
| Core/Config/CSE_Config.sql | 前端配置(城邦选择器/类型重分类) |
| Core/CSE_CityStates.sql | 城邦核心定义(Civilizations/Leaders/Traits) |
| Core/CSE_CityStates_XP2.sql | XP2额外城邦定义 |
| Core/CSE_Modifications.sql | 对已有城邦的效果修改 |
| Core/CSE_Localisation.sql | 英文/德文本地化 |
| Core/CSE_Localisation_Modifications.sql | 修改后的本地化文本 |
| Core/CSE_Globals.sql | 全局设置(战争厌战/城墙/起始单位等) |
| Core/City-State Types/Base/*.sql | 各城邦类型使者加成定义 |
| Core/City-States/Base/*.sql | 各新增城邦个体定义 |
| Core/City-States/XP1/*.sql | 迭起兴衰新增城邦定义 |
| Core/City-States/XP2/*.sql | 风云变幻新增城邦定义 |