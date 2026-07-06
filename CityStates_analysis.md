# Civilization VI 城邦数据分析报告

> 生成日期：2026-07-06
> 分析范围：原版游戏 + DLC + 城邦拓展(CIVITAS City-States) + 兼并城邦(Ophidy's Annex) + 自由城市转化城邦(Free City States) + 信仰购买单位/城邦边界政策(Holy Army)

---

## 一、概览 (Overview)

### 1.1 城邦类型统计

| 城邦类型 | 原版数量 | CSE新增 | 最终数量 | 说明 |
|----------|:-------:|:------:|:-------:|------|
| 科学 (Scientific) | 6 | 0 | 6 | 原版6个保留 |
| 文化 (Cultural) | 6 | 0 | 6 | 原版6个保留 |
| 商业 (Trade) | 6 | 0 | 6 | 原版6个保留 |
| 宗教 (Religious) | 6 | 0 | 6 | 原版6个保留 |
| 军事 (Militaristic) | 6 | 0 | 6 | 原版6个保留 |
| 工业 (Industrial) | 6 | 0 | 6 | 原版6个保留 |
| 农业 (Agricultural) | 0 | 6 | 6 | CSE新增类型 |
| 娱乐 (Entertainment) | 0 | 6 | 6 | CSE新增类型 |
| 海事 (Maritime) | 0 | 6 | 6 | CSE新增类型 |
| 领事 (Consular) | 0 | 6 | 6 | CSE新增类型（需XP1/XP2） |
| **总计** | **36** | **24** | **60** | |

### 1.2 数据来源操作统计

| 来源 | 原版保留 | 新增 | 修改 | 被删除 | 总计 |
|------|:------:|:---:|:---:|:-----:|:---:|
| 原版游戏 (Base) | 0 | 0 | 36 | 0 | 36 |
| 城邦拓展 (CSE) | 0 | 24 | 36 | 0 | 60 |
| 兼并城邦 (ACS) | 0 | 1 (项目) | 0 | 0 | 1 |
| 自由城市转化 (FCS) | 0 | 1 (机制) | 0 | 0 | 1 |
| 信仰购买/边界政策 (HA) | 0 | 2 (政策) | 0 | 0 | 2 |

> **说明**：由于工作区不包含原版游戏文件，所有原版城邦数据从CSE mod的DELETE/UPDATE语句反向推导得出。CSE mod完全重写了所有36个原版城邦的类型加成，并新增了24个城邦（4个新类型各6个）。

---

## 二、城邦类型使者加成详解

### 2.1 原版城邦类型加成（被CSE修改前）

**此表记录原版游戏中的城邦类型加成，已被CSE mod完全替换。**

| 类型 | 1使者 | 3使者 | 6使者 | 10使者 |
|------|-------|-------|-------|--------|
| 科学 (Scientific) | 首都+2 科技 | 图书馆+2 科技 | 大学+2 科技 | 研究实验室+3 科技 |
| 文化 (Cultural) | 首都+2 文化 | 剧院广场+2 文化 | 博物馆+2 文化 | 广播中心+3 文化 |
| 商业 (Trade) | 首都+4 金币 | 商业中心+4 金币 | 市场+2 金币 | 银行+4 金币 |
| 宗教 (Religious) | 首都+2 信仰 | 圣地+2 信仰 | 神社+2 信仰 | 寺庙+4 信仰 |
| 军事 (Militaristic) | 首都+2 产能(单位) | 兵营/马厩+2 产能(单位) | 军械库+2 产能(单位) | 军事学院+3 产能(单位) |
| 工业 (Industrial) | 首都+2 产能(区域) | 工业区+2 产能(区域) | 工坊+2 产能(区域) | 工厂+4 产能(区域) |

### 2.2 CSE修改后的城邦类型加成（最终效果）

| 类型 | 1使者 | 3使者 | 6使者 | 10使者 |
|------|-------|-------|-------|--------|
| 科学 (Scientific) | 首都+2 科技 | 图书馆+2 科技 | 大学+2 科技 | 研究实验室+2 科技 |
| 文化 (Cultural) | 首都+2 文化 | 圆形剧场+2 文化 | 艺术/文物博物馆+2 文化 | 广播中心+2 文化 |
| 商业 (Trade) | 首都+4 金币 | 市场/灯塔+4 金币 | 银行/造船厂+4 金币 | 证券交易所/港口+4 金币 |
| 宗教 (Religious) | 首都+2 信仰 | 神社+2 信仰 | 寺庙+2 信仰 | 祭祀建筑+2 信仰 |
| 军事 (Militaristic) | 首都+2 产能(单位) | 兵营/马厩城市+2 产能(单位) | 军械库城市+2 产能(单位) | 军事学院+2 产能(单位) |
| 工业 (Industrial) | 首都+2 产能(区域建筑) | 工坊城市+2 产能(区域建筑) | 工厂城市+2 产能(区域建筑) | 发电厂+2 产能(区域建筑) |
| **农业 (Agricultural)** | 首都+2 食物 | 粮仓+2 食物 | 下水道+2 食物 | 水渠+2 食物 |
| **娱乐 (Entertainment)** | 首都+1 宜居度 | 竞技场+1 宜居度 | 动物园+1 宜居度 | 体育场+1 宜居度 |
| **海事 (Maritime)** | 首都+1 食物+1 产能 | 灯塔+1 食物+1 产能 | 造船厂+1 食物+1 产能 | 港口+1 食物+1 产能 |
| **领事 (Consular)** | 首都+2 外交支持 | 一级政府区建筑+2 外交支持 | 二级政府区建筑+2 外交支持 | 三级政府区建筑+2 外交支持 |

> **XP1(XP1)兼容模式**：当未启用XP2时，领事城邦效果改为：1使者/+2忠诚度压力(首都)，3使者/+2忠诚度(每城)，6使者/+2忠诚度压力(每城)，10使者/+2忠诚度压力(有总督的城市)。

> **XP1兼容模式**：农业城邦10使者效果改为食品市场/购物中心+2食物（非水渠）。

> **XP1兼容模式**：娱乐城邦3使者效果改为竞技场/摩天轮+1宜居度，6使者改为动物园/水族馆+1宜居度，10使者改为体育场/水上运动中心+1宜居度。

### 2.3 CSE的全局设置 (Globals)

| 设置项 | 效果 |
|--------|------|
| 城邦自动获得城墙 | 所有城邦开局自动获得城墙 |
| 宗主国外交支持 | 每宗主一个城邦+1 外交支持/回合 |
| 城邦初始单位 | 城邦开局获得额外单位（侦察兵、投石兵等） |
| 城邦初始人口 | 城邦开局获得额外人口 |
| 城邦初始建筑 | 城邦开局获得粮仓、纪念碑等基础建筑 |
| 城邦初始地块 | 城邦开局获得额外改良地块 |

---

## 三、全部城邦详细数据表

### 3.1 科学城邦 (Scientific)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 哈图沙 | Hattusa | CIVILIZATION_HATTUSA | 原版 | 修改 | 每回合获得1个你已发现的但尚未拥有的战略资源 |
| 2 | 非斯 | Fez | CIVILIZATION_FEZ | 原版 | 修改 | 每当你使用信仰购买建筑或单位时，获得等同于该项花费30%的科技 |
| 3 | 博洛尼亚 | Bologna | CIVILIZATION_BOLOGNA | 原版 | 修改 | 拥有建筑的区域为其所在城市提供+1大科学家点数 |
| 4 | 日内瓦 | Geneva | CIVILIZATION_GENEVA | 原版 | 修改 | 未处于战争状态时，所有城市+15%科技 |
| 5 | 塔鲁加 | Taruga | CIVILIZATION_TARUGA | 原版 | 修改 | 每个不同的战略资源提供+5%科技 |
| 6 | 安善 | Anshan | CIVILIZATION_ANSHAN | 原版 | 修改 | 每当你获得大科学家时，获得额外的科技 |

### 3.2 文化城邦 (Cultural)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 库马西 | Kumasi | CIVILIZATION_KUMASI | 原版 | 修改 | 通往任何城邦的贸易路线为起始城市每个专业化区域提供+2文化 |
| 2 | 摩亨佐达罗 | Mohenjo-Daro | CIVILIZATION_MOHENJO_DARO | 原版 | 修改 | 所有城市（无论是否临水）都能获得+5住房，如同它们建于淡水旁 |
| 3 | 拉帕努伊 | Rapa Nui | CIVILIZATION_RAPA_NUI | 原版 | 修改 | 建造者可建造摩艾石像改良设施 |
| 4 | 卡瓜纳 | Caguana | CIVILIZATION_CAGUANA | 原版 | 修改 | 建造者可建造巴泰伊球场改良设施 |
| 5 | 维尔纽斯 | Vilnius | CIVILIZATION_VILNIUS | 原版 | 修改 | 当你的剧院广场区域获得伟人点数时，额外获得50%文化 |
| 6 | 南马都尔 | Nan Madol | CIVILIZATION_NAN_MADOL | 原版 | 修改 | 所有沿海区域为相邻区域提供+2文化 |

### 3.3 商业城邦 (Trade)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 迦太基 | Carthage | CIVILIZATION_CARTHAGE | 原版 | 修改 | 每有一个兵营区域，额外提供一条贸易路线容量 |
| 2 | 里斯本 | Lisbon | CIVILIZATION_LISBON | 原版 | 修改 | 你的海上贸易路线免疫劫掠 |
| 3 | 威尼斯 | Venice | CIVILIZATION_VENICE | 原版 | 修改 | 你的商路每经过一个外国城市，+1金币 |
| 4 | 桑给巴尔 | Zanzibar | CIVILIZATION_ZANZIBAR | 原版 | 修改 | 获得肉桂和丁香奢侈品资源（不可交易），各提供6宜居度 |
| 5 | 摩加多尔 | Mogadishu | CIVILIZATION_MOGADISHU | 原版 | 修改 | 你的商人不能在水上被劫掠 |
| 6 | 撒马尔罕 | Samarqand | CIVILIZATION_SAMARQAND | 原版 | 修改 | 建造者可建造交易站改良设施 |

**注意**：CSE将原版Samarkand重命名为Bukhara，并新增了CSE_Samarqand作为独立城邦。

### 3.4 宗教城邦 (Religious)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 耶路撒冷 | Jerusalem | CIVILIZATION_JERUSALEM | 原版 | 修改 | 自动转变为你的主流宗教，并对其所有者的城市施加宗教压力 |
| 2 | 梵蒂冈 | Vatican City | CIVILIZATION_VATICAN_CITY | 原版 | 修改 | 当你使用大先知时，获得等同于该先知花费200%的信仰 |
| 3 | 埃里温 | Yerevan | CIVILIZATION_YEREVAN | 原版 | 修改 | 使徒可以从所有可能的晋升中选择 |
| 4 | 康提 | Kandy | CIVILIZATION_KANDY | 原版 | 修改 | 每当你发现自然奇观，获得一件圣遗物 |
| 5 | 拉文塔 | La Venta | CIVILIZATION_LA_VENTA | 原版 | 修改 | 建造者可建造巨石头像改良设施 |
| 6 | 阿尔马 | Armagh | CIVILIZATION_ARMAGH | 原版 | 修改 | 建造者可建造修道院改良设施 |

### 3.5 军事城邦 (Militaristic)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 喀布尔 | Kabul | CIVILIZATION_KABUL | 原版 | 修改 | 你的单位对敌对城市发起的攻击获得双倍经验 |
| 2 | 格兰纳达 | Granada | CIVILIZATION_GRANADA | 原版 | 修改 | 建造者可建造阿尔卡萨要塞改良设施 |
| 3 | 阿卡德 | Akkad | CIVILIZATION_AKKAD | 原版 | 修改 | 近战和反骑兵单位对城墙全额伤害 |
| 4 | 普雷斯佩 | Preslav | CIVILIZATION_PRESLAV | 原版 | 修改 | 战斗胜利为你提供等同于该单位基础战斗力25%的信仰 |
| 5 | 拉合尔 | Lahore | CIVILIZATION_LAHORE | 原版 | 修改 | 可以购买尼罕-辛格战士（特殊单位） |
| 6 | 沃林 | Wolin | CIVILIZATION_WOLIN | 原版 | 修改 | 杀死敌方单位时获得等同于该单位战斗力50%的大将军点数 |

### 3.6 工业城邦 (Industrial)

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 布宜诺斯艾利斯 | Buenos Aires | CIVILIZATION_BUENOS_AIRES | 原版 | 修改 | 每个奖励资源如同奢侈品资源一样提供+1宜居度 |
| 2 | 墨西哥城 | Mexico City | CIVILIZATION_MEXICO_CITY | 原版 | 修改 | 通过城市扩展获得的区域生产力提升适用于所有区域 |
| 3 | 布鲁塞尔 | Brussels | CIVILIZATION_BRUSSELS | 原版 | 修改 | 你的城市建造奇观时+15%生产力 |
| 4 | 香港 | Hong Kong | CIVILIZATION_HONG_KONG | 原版 | 修改 | 城市建造项目时+20%生产力 |
| 5 | 奥克兰 | Auckland | CIVILIZATION_AUCKLAND | 原版 | 修改 | 浅水单元格额外+1生产力，到达工业时代后再+1生产力 |
| 6 | 加的夫 | Cardiff | CIVILIZATION_CARDIFF | 原版 | 修改 | 每个港口区域提供+2电力 |

### 3.7 农业城邦 (Agricultural) — CSE新增

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 安努拉德普勒 | Anuradhapura | CIVILIZATION_CSE_ANURADHAPURA | CSE | 新增 | 建造者可建造佛塔改良设施（+1信仰+1文化），建造后获得1件圣遗物 |
| 2 | 加泰土丘 | Catalhoyuk | CIVILIZATION_CSE_CATALHOYUK | CSE | 新增 | 获得皮革和羊毛奢侈品资源（不可交易），各提供6宜居度 |
| 3 | 库希库古 | Kuhikugu | CIVILIZATION_CSE_KUHIKUGU | CSE | 新增 | 城市获得额外的食物和文化 |
| 4 | 迈恩冒 | Maingmaw | CIVILIZATION_CSE_MAINGMAW | CSE | 新增 | 沿河改良地块+1食物+1金币 |
| 5 | 斯里凯特拉 | Sri Ksetra | CIVILIZATION_CSE_SRIKSETRA | CSE | 新增 | 每2个相邻圣地+1信仰 |
| 6 | 蒂瑟默哈拉默 | Tissamaharama | CIVILIZATION_CSE_TISSAMAHARAMA | CSE | 新增 | 有相邻丛林的城市+1食物，有相邻森林的城市+1金币 |

### 3.8 娱乐城邦 (Entertainment) — CSE新增

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 贝塔诺 | Beikthano | CIVILIZATION_CSE_BEIKTHANO | CSE | 新增 | 城墙+1防御力+1射程，城堡+1防御力+1射程，星堡+1防御力+1射程 |
| 2 | 埃特扎诺阿 | Etzanoa | CIVILIZATION_CSE_ETZANOA | CSE | 新增 | 相邻区域提供+1住房 |
| 3 | 加达梅斯 | Garama | CIVILIZATION_CSE_GARAMA | CSE | 新增 | 获得骆驼和羊毛奢侈品资源（不可交易），各提供6宜居度 |
| 4 | 卡塔拉伽马 | Kataragama | CIVILIZATION_CSE_KATARAGAMA | CSE | 新增 | 相邻寺庙建筑+1信仰 |
| 5 | 迈 | Mai | CIVILIZATION_CSE_MAI | CSE | 新增 | 获得蜂蜡和槟榔奢侈品资源（不可交易），各提供6宜居度 |
| 6 | 焦洛 | Jolo | CIVILIZATION_CSE_JOLO | CSE | 新增 | 单位移动+1，战斗加成 |

### 3.9 海事城邦 (Maritime) — CSE新增

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 布图安 | Butuan | CIVILIZATION_CSE_BUTUAN | CSE | 新增 | 登陆单位移动+1，忽略登陆成本 |
| 2 | 达喀尔 | Dakar | CIVILIZATION_CSE_DAKAR | CSE | 新增 | 港口区域建筑提供大商人点数 |
| 3 | 吉布提 | Djibouti | CIVILIZATION_CSE_DJIBOUTI | CSE | 新增 | 浅水地块+1食物 |
| 4 | 利马 | Lima | CIVILIZATION_CSE_LIMA | CSE | 新增 | 港口和城市中心额外获得产能和食物 |
| 5 | 蒙巴萨 | Mombasa | CIVILIZATION_CSE_MOMBASA | CSE | 新增 | 专业化区域从沿海地块获得次要相邻加成 |
| 6 | 拿骚 | Nassau | CIVILIZATION_CSE_NASSAU | CSE | 新增 | 掠夺海上贸易路线的收益翻倍 |

### 3.10 领事城邦 (Consular) — CSE新增

| 序号 | 中文名 | 英文名 | 内部ID | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|:---:|----------|
| 1 | 安普 | Ampi | CIVILIZATION_CSE_AMPI | CSE | 新增 | 获得玻璃奢侈品资源（不可交易），提供6宜居度；种植园+1产能 |
| 2 | 凯德什 | Kadesh | CIVILIZATION_CSE_KADESH | CSE | 新增 | 相邻城市中心提供+1产能+1食物 |
| 3 | 坎瑙杰 | Kannauj | CIVILIZATION_CSE_KANNAUJ | CSE | 新增 | 获取黄金和信仰资源 |
| 4 | 哈佐尔 | Hazor | CIVILIZATION_CSE_HAZOR | CSE | 新增 | 获取河流资源 |
| 5 | 克拉克夫 | Valabhi | CIVILIZATION_CSE_VALABHI | CSE | 新增 | 有港口的城市+1产能，有圣地的城市+1金币 |
| 6 | 乌尔根奇 | Urgench | CIVILIZATION_CSE_URGENCH | CSE | 新增 | 有市场的城市+1产能，有兵营的城市+1金币 |

### 3.11 XP1扩展城邦（CSE新增于XP1目录）

| 序号 | 中文名 | 英文名 | 内部ID | 类型 | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|------|:---:|----------|
| 1 | 阿兹卡波察尔科 | Azcapotzalco | CIVILIZATION_CSE_AZCAPOTZALCO | 军事 | CSE | 新增 | 联盟点数加成 |
| 2 | 昌昌 | Chan Chan | CIVILIZATION_CSE_CHAN_CHAN | 文化 | CSE | 新增 | 宫殿产出翻倍，专业化区域相邻政府区/娱乐区/水上乐园时+50%原生产出 |
| 3 | 得洛斯 | Delos | CIVILIZATION_CSE_DELOS | 海事 | CSE | 新增 | 特定地形资源产出加成 |
| 4 | 德尔斐 | Delphi | CIVILIZATION_CSE_DELPHI | 宗教 | CSE | 新增 | 奇观建设奖励 |
| 5 | 多多纳 | Dodona | CIVILIZATION_CSE_DODONA | 科学 | CSE | 新增 | 文明时代激励措施加成 |
| 6 | 哈达德 | Hadad | CIVILIZATION_CSE_HADAD | 领事 | CSE | 新增 | 城市官员加成 |
| 7 | 哈林 | Halin | CIVILIZATION_CSE_HALIN | 农业 | CSE | 新增 | 人口增长加成 |
| 8 | 哈瓦那 | Havana | CIVILIZATION_CSE_HAVANA | 娱乐 | CSE | 新增 | 文化、艺术和港口建筑加成 |
| 9 | 霍尔木兹 | Hormuz | CIVILIZATION_CSE_HORMUZ | 海事 | CSE | 新增 | 港口城市防御加成 |
| 10 | 伊萨帕 | Izapa | CIVILIZATION_CSE_IZAPA | 科学 | CSE | 新增 | 科技激励措施加成 |
| 11 | 约翰内斯堡 | Johannesburg | CIVILIZATION_CSE_JOHANNESBURG | 工业 | CSE | 新增 | 工业区建筑加成 |
| 12 | 梅赫尔格尔 | Mehrgarh | CIVILIZATION_CSE_MEHRGARH | 农业 | CSE | 新增 | 资源采集加成 |
| 13 | 摩纳哥 | Monaco | CIVILIZATION_CSE_MONACO | 娱乐 | CSE | 新增 | 娱乐区建筑加成 |
| 14 | 姆齐齐马 | Mzizima | CIVILIZATION_CSE_MZIZIMA | 农业 | CSE | 新增 | 城市增长加成 |
| 15 | 那烂陀 | Nalanda | CIVILIZATION_CSE_NALANDA | 科学 | CSE | 新增 | 快乐度和科学/信仰收益加成 |
| 16 | 皇家港 | Port Royal | CIVILIZATION_CSE_PORT_ROYAL | 商业 | CSE | 新增 | 贸易路线加成 |
| 17 | 乌加里特 | Ugarit | CIVILIZATION_CSE_UGARIT | 军事 | CSE | 新增 | 海军单位生产加成 |

### 3.12 XP2扩展城邦（CSE新增于XP2目录）

| 序号 | 中文名 | 英文名 | 内部ID | 类型 | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|------|:---:|----------|
| 1 | 阿拉穆特 | Alamut | CIVILIZATION_CSE_ALAMUT | 领事 | CSE | 新增 | 间谍可以从所有可能的晋升中选择 |
| 2 | 拜亚 | Baiae | CIVILIZATION_CSE_BAIAE | 娱乐 | CSE | 新增 | 娱乐区和水上乐园加成 |
| 3 | 哥贝克力石阵 | Gobekli Tepe | CIVILIZATION_CSE_GOBEKLI_TEPE | 宗教 | CSE | 新增 | 奇观建设加成 |
| 4 | 贡德沙普尔 | Gundeshapur | CIVILIZATION_CSE_GUNDESHAPUR | 科学 | CSE | 新增 | 时代激励和校区邻近加成 |
| 5 | 赫瓦尔斯 | Hvalsey | CIVILIZATION_CSE_HVALSEY | 海事 | CSE | 新增 | 冰川水域钓鱼船加成 |
| 6 | 丹吉尔 | Tangier | CIVILIZATION_CSE_TANGIER | 文化 | CSE | 新增 | 时代激励和剧场邻近加成 |
| 7 | 泰尤纳 | Teyuna | CIVILIZATION_CSE_TEYUNA | 科学 | CSE | 新增 | 山地邻近加成 |
| 8 | 瓦杜兹 | Vaduz | CIVILIZATION_CSE_VADUZ | 商业 | CSE | 新增 | 建筑购买折扣 |
| 9 | 维也纳 | Vienna | CIVILIZATION_CSE_VIENNA | 领事 | CSE | 新增 | 城市官员、建筑折扣和外交影响力加成 |

### 3.13 CSE Base新增城邦（补充）

| 序号 | 中文名 | 英文名 | 内部ID | 类型 | 来源 | 状态 | 宗主加成 |
|:---:|--------|--------|--------|------|------|:---:|----------|
| 1 | 阿伊努克 | Aynuk | CIVILIZATION_CSE_AYNUK | 海事 | CSE | 新增 | 沿海地块+1食物+1产能 |
| 2 | 切特罗凯特尔 | Chetro Ketl | CIVILIZATION_CSE_CHETRO_KETL | 文化 | CSE | 新增 | 建造者可建造奇瓦改良设施 |
| 3 | 伊魁特 | Iqaluit | CIVILIZATION_CSE_IQALUIT | 农业 | CSE | 新增 | 寒带地区食物和产能加成 |
| 4 | 凯拉尼亚 | Kelaniya | CIVILIZATION_CSE_KELANIYA | 宗教 | CSE | 新增 | 城市中心和港口额外文化和信仰 |
| 5 | 马拉喀什 | Marrakech | CIVILIZATION_CSE_MARRAKECH | 商业 | CSE | 新增 | 建造者可建造里亚德改良设施（+1文化+1食物），国际商路+1金币 |
| 6 | 米吉多 | Megiddo | CIVILIZATION_CSE_MEGIDDO | 军事 | CSE | 新增 | 兵营区域提供+1产能和+2金币（国际商路） |
| 7 | 帕尔米拉 | Palmyra | CIVILIZATION_CSE_PALMYRA | 商业 | CSE | 新增 | 圣地建筑为每条经过的外国商路提供+1金币 |
| 8 | 法希斯 | Phasis | CIVILIZATION_CSE_PHASIS | 工业 | CSE | 新增 | 相邻森林的森林地块+1产能，沿河伐木场+2金币 |
| 9 | 卡特纳 | Qatna | CIVILIZATION_CSE_QATNA | 工业 | CSE | 新增 | 工业区建筑可用信仰购买，+1产能 |
| 10 | 萨莱 | Sale | CIVILIZATION_CSE_SALE | 军事 | CSE | 新增 | 海军劫掠单位获得额外攻击次数 |
| 11 | 萨那 | Sanaa | CIVILIZATION_CSE_SANAA | 文化 | CSE | 新增 | 城市中心对相邻区域提供相邻加成 |
| 12 | 塞乌托波利斯 | Seuthopolis | CIVILIZATION_CSE_SEUTHOPOLIS | 商业 | CSE | 新增 | 城市中每条贸易路线+1产能 |
| 13 | 沙赫尔苏赫特 | Shahr-e Sukhte | CIVILIZATION_CSE_SHAHRESUKHTE | 工业 | CSE | 新增 | 有工坊的城市+1产能，有市场的城市+1金币 |
| 14 | 西顿 | Sidon | CIVILIZATION_CSE_SIDON | 文化 | CSE | 新增 | 有圆形剧场的城市+1文化 |
| 15 | 新加坡 | Singapore | CIVILIZATION_CSE_SINGAPORE | 商业 | CSE | 新增 | 每个相邻港口/商业中心/剧院区+1金币 |
| 16 | 塔奥斯 | Taos | CIVILIZATION_CSE_TAOS | 文化 | CSE | 新增 | 每个相邻圣地和营地+1文化 |
| 17 | 图内里乌特 | Tuneriut | CIVILIZATION_CSE_TUNERIUT | 商业 | CSE | 新增 | 每2个相邻营地+1金币 |
| 18 | 怀亚姆 | Wyam | CIVILIZATION_CSE_WYAM | 宗教 | CSE | 新增 | 圣地或剧院区有巨作槽位的城市+1信仰+1文化 |

---

## 四、关联数据 (Linked Data)

### 4.1 CSE新增改良设施

| 改良设施 | 关联城邦 | 基础产出 | 加成产出 | 解锁条件 |
|----------|----------|----------|----------|----------|
| 佛塔 (Dagoba) | 安努拉德普勒 | +1信仰 +1文化 | 教育+1文化，飞行+1文化，神学+1信仰，宗教改革+1信仰 | 圣地相邻+1信仰，剧院区相邻+1文化 |
| 里亚德 (Riad) | 马拉喀什 | +1文化 +1食物 | 相邻里亚德+1文化，绿洲+1食物，冲积平原+1食物 | 国际商路+1金币 |
| 奇瓦 (Chiva) | 切特罗凯特尔 | 产出（文化相关） | — | — |
| 交易站 (Trading Post) | 撒马尔罕 | 商路相关 | — | — |

### 4.2 CSE新增奢侈品资源

| 资源 | 关联城邦 | 宜居度 | 可交易 |
|------|----------|:-----:|:-----:|
| 玻璃 (Glass) | 安普 | 6 | 否 |
| 蜂蜡 (Beeswax) | 迈 | 6 | 否 |
| 槟榔 (Betel Nut) | 迈 | 6 | 否 |
| 皮革 (Leather) | 加泰土丘 | 6 | 否 |
| 羊毛 (Wool) | 加泰土丘/加达梅斯 | 6 | 否 |
| 骆驼 (Camel) | 加达梅斯 | 6 | 否 |

### 4.3 其他相关Mod数据

#### 兼并城邦 (Ophidy's Annex City-States Remastered)
- 新增项目：城邦兼并项目（允许文明直接兼并城邦）
- 兼并参数：消耗生产力、金币或外交支持

#### 自由城市转化城邦 (Free City States)
- Lua脚本实现自由城市在一定条件下转化为新城邦
- 转化条件：自由城市存在一定回合数且未被重新征服

#### 信仰购买/城邦边界政策 (Holy Army)
- 政策：允许使用信仰购买陆军单位
- 政策：城邦边界扩张相关

---

## 五、修改/删除的原始内容

### 5.1 城邦类型加成修改

CSE mod完全重写了所有6个原版城邦类型的使者加成。具体修改如下：

| 类型 | 修改项 | 修改前 | 修改后 |
|------|--------|--------|--------|
| 科学 | 3使者 | 首都+2科技 | 首都+2科技 (不变) |
| 科学 | 3使者 | 图书馆+1科技 | 图书馆+2科技 |
| 科学 | 6使者 | 大学+2科技 | 大学+2科技 (不变) |
| 科学 | 10使者 | 研究实验室+3科技 | 研究实验室+2科技 |
| 文化 | 3使者 | 剧院广场+2文化 | 圆形剧场+2文化 |
| 文化 | 6使者 | 博物馆+2文化 | 艺术/文物博物馆+2文化 |
| 文化 | 10使者 | 广播中心+3文化 | 广播中心+2文化 |
| 商业 | 3使者 | 商业中心+4金币 | 市场/灯塔+4金币 |
| 商业 | 6使者 | 市场+2金币 | 银行/造船厂+4金币 |
| 商业 | 10使者 | 银行+4金币 | 证券交易所/港口+4金币 |
| 宗教 | 3使者 | 圣地+2信仰 | 神社+2信仰 |
| 宗教 | 6使者 | 神社+2信仰 | 寺庙+2信仰 |
| 宗教 | 10使者 | 寺庙+4信仰 | 祭祀建筑+2信仰 |
| 军事 | 3使者 | 兵营+2产能(单位) | 兵营/马厩城市+2产能(单位) |
| 军事 | 6使者 | 军械库+2产能(单位) | 军械库城市+2产能(单位) |
| 军事 | 10使者 | 军事学院+3产能(单位) | 军事学院+2产能(单位) |
| 工业 | 3使者 | 工业区+2产能(区域) | 工坊城市+2产能(区域建筑) |
| 工业 | 6使者 | 工坊+2产能(区域) | 工厂城市+2产能(区域建筑) |
| 工业 | 10使者 | 工厂+4产能(区域) | 发电厂+2产能(区域建筑) |

### 5.2 城邦重命名

| 原版ID | 原版名称 | CSE修改后 |
|--------|----------|-----------|
| CIVILIZATION_SAMARQAND | Samarkand | 重命名为 Bukhara（布哈拉） |

### 5.3 被删除的原始数据

CSE mod通过 `DELETE FROM TraitModifiers WHERE TraitType IN ('MINOR_CIV_DEFAULT_TRAIT')` 删除了原版默认城邦特质的所有修饰符。此外，每个城邦类型（科学、文化、商业、宗教、军事、工业）的原始 `TraitModifiers` 都被完全删除并重新定义。

---

## 六、兼容性分析 (Compatibility Analysis)

### 6.1 Mod间冲突

| 冲突项 | Mod A | Mod B | 最终结果 |
|--------|-------|-------|----------|
| 城邦类型加成 | CSE City-States | 原版 | CSE完全覆盖，所有类型加成被替换 |
| 撒马尔罕城邦 | CSE City-States (自身) | — | 原版Samarkand被重命名为Bukhara，CSE新增独立Samarqand |
| 城邦边界 | CSE (城墙) | Holy Army (边界政策) | 兼容，各自独立生效 |
| 兼并机制 | CSE | ACS Remastered | 兼容，不同机制 |

### 6.2 加载顺序

根据 `.modinfo` 文件分析：
1. 原版游戏 (Base)
2. XP1 (Rise and Fall) / XP2 (Gathering Storm)
3. CIVITAS City-States (城邦拓展) — 核心数据
4. Holy Army — 独立政策mod
5. Free City States — 独立Lua脚本mod
6. Ophidy's Annex City-States — 独立城邦兼并mod

CSE mod通过 `DELETE` 和 `INSERT OR REPLACE` 确保其数据覆盖所有先前的定义。

### 6.3 条件兼容性

| 条件 | 行为 |
|------|------|
| 无XP1 | 领事城邦类型不可用，农业/娱乐城邦使用替代加成 |
| 无XP2 | 领事城邦使用忠诚度加成（非外交支持），农业/娱乐城邦使用XP1兼容版本 |
| 有XP1+XP2 | 所有城邦类型和加成完全生效 |
| Ethiopia模式 | 开启后使者加成影响外交区建筑 |

---

## 七、附录

### 7.1 文件清单

所有数据来源于以下文件路径：

- `/workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/` — 所有核心数据文件
- `/workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/City-State Types/Base/` — 城邦类型加成定义
- `/workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/City-States/Base/` — 基础城邦个体定义
- `/workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/City-States/XP1/` — XP1城邦个体定义
- `/workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/City-States/XP2/` — XP2城邦个体定义
- `/workspace/MOD/修改过的/2169184492 信仰购买单位政策和城邦边界政策/` — Holy Army mod
- `/workspace/MOD/游戏模式与玩法大修/3323036834-Ophidy's Annex City-States (Remastered)-兼并城邦 (重置版)/` — 兼并城邦mod
- `/workspace/MOD/游戏模式与玩法大修/2545191213-Free City States-自由城市转化为城邦/` — 自由城市转化mod

### 7.2 术语对照

| 英文 | 中文 |
|------|------|
| City-State | 城邦 |
| Envoy | 使者 |
| Suzerain | 宗主 |
| Suzerain Bonus | 宗主加成 |
| Scientific | 科学 |
| Cultural | 文化 |
| Trade | 商业 |
| Religious | 宗教 |
| Militaristic | 军事 |
| Industrial | 工业 |
| Agricultural | 农业 |
| Entertainment | 娱乐 |
| Maritime | 海事 |
| Consular | 领事 |
| Amenity | 宜居度 |
| Loyalty | 忠诚度 |
| Diplomatic Favor | 外交支持 |
| Government Plaza | 政府区 |