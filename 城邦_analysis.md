# Civilization VI 城邦完整分析报告

## 1. 总览

### 1.1 数据来源统计

| 来源 | 路径 | 城邦数 | 新增 | 修改 | 删除 |
|------|------|--------|------|------|------|
| 原版基础游戏 | /workspace/原版+DLC/╘н░ц/Data/Civilizations.xml | 24 | 24 | 0 | 0 |
| Expansion1 (Rise & Fall) | /workspace/原版+DLC/DLC/Expansion1/Data/ | 7 | 7 | 0 | 0 |
| Expansion2 (Gathering Storm) | /workspace/原版+DLC/DLC/Expansion2/Data/ | 11 | 11 | 0 | 0 |
| VikingsLandmarks DLC | /workspace/原版+DLC/DLC/VikingsLandmarks/Data/ | 3 | 3 | 0 | 0 |
| CIVITAS City-States Expanded | /workspace/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/ | 40+ | 40+ | 0 | 0 |

### 1.2 城邦类型

| 类型 | 原版标识 | 说明 |
|------|----------|------|
| 军事型 | CIVILIZATION_TYPE_MILITARISTIC | 为军事单位提供生产力加成 |
| 文化型 | CIVILIZATION_TYPE_CULTURAL | 为文化值产出提供加成 |
| 科技型 | CIVILIZATION_TYPE_SCIENTIFIC | 为科技值产出提供加成 |
| 贸易型 | CIVILIZATION_TYPE_TRADE | 为金币产出提供加成 |
| 宗教型 | CIVILIZATION_TYPE_RELIGIOUS | 为信仰值产出提供加成 |
| 工业型 | CIVILIZATION_TYPE_INDUSTRIAL | 为建造奇观/建筑/单位提供生产力加成 |
| 农业型 (CSE新增) | CIVILIZATION_TYPE_CSE_AGRICULTURAL | CIVITAS mod新增类型 |
| 领事型 (CSE新增) | CIVILIZATION_TYPE_CSE_CONSULAR | CIVITAS mod新增类型 |
| 娱乐型 (CSE新增) | CIVILIZATION_TYPE_CSE_ENTERTAINMENT | CIVITAS mod新增类型 |
| 外交型 (CSE新增) | CIVILIZATION_TYPE_CSE_DIPLOMATIC | CIVITAS mod新增类型 |

---

## 2. 详细数据表

### 2.1 原版基础游戏城邦（24个）

#### 2.1.1 军事型城邦 (Militaristic)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_CARTHAGE | 迦太基 | Carthage | 军事型标准加成 | 每个军营建筑+1贸易路线容量 | 原版 |
| CIVILIZATION_KABUL | 喀布尔 | Kabul | 军事型标准加成 | 您的单位发起攻击时获得双倍经验值 | 原版 |
| CIVILIZATION_PRESLAV | 普雷斯拉夫 | Preslav | 军事型标准加成 | 您在山丘上作战时，单位+5战斗力 | 原版 |
| CIVILIZATION_VALLETTA | 瓦莱塔 | Valletta | 军事型标准加成 | 可用信仰值购买城墙和军营建筑 | 原版 |

**使者加成（军事型）：**
- 1使者：首都+2生产力
- 3使者：每个兵营/马厩+2生产力
- 6使者：每个军械库+2生产力

#### 2.1.2 文化型城邦 (Cultural)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_KUMASI | 库马西 | Kumasi | 文化型标准加成 | 您通往任何城邦的贸易路线为起源城市的每个专业化区域提供+2文化值、+1金币 | 原版 |
| CIVILIZATION_MOHENJO_DARO | 摩亨佐达罗 | Mohenjo Daro | 文化型标准加成 | 无论您的城市是否相邻淡水，水源提供的基础住房均与相邻淡水时相同 | 原版 |
| CIVILIZATION_NAN_MADOL | 南马都尔 | Nan Madol | 文化型标准加成 | 您的城市中，所有相邻海岸或湖泊单元格的区域提供+2文化值 | 原版 |
| CIVILIZATION_VILNIUS | 维尔纽斯 | Vilnius | 文化型标准加成 | 剧院广场区域的主要建筑提供+1巨作槽位 | 原版 |

**使者加成（文化型）：**
- 1使者：首都+2文化值
- 3使者：每个古罗马剧场+2文化值
- 6使者：每个艺术博物馆/考古博物馆+2文化值

#### 2.1.3 科技型城邦 (Scientific)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_GENEVA | 日内瓦 | Geneva | 科技型标准加成 | 未处于战争时，您的城市+15%科技值 | 原版 |
| CIVILIZATION_HATTUSA | 哈图萨 | Hattusa | 科技型标准加成 | 为您提供您已解锁但尚未获得的每种战略资源每回合各1份 | 原版 |
| CIVILIZATION_SEOUL | 首尔 | Seoul | 科技型标准加成 | 进入新时代时，获得随机1个已解锁科技的尤里卡 | 原版 |
| CIVILIZATION_STOCKHOLM | 斯德哥尔摩 | Stockholm | 科技型标准加成 | 您的城市每个专业化区域提供+1伟人点数 | 原版 |

**使者加成（科技型）：**
- 1使者：首都+2科技值
- 3使者：每个图书馆+2科技值
- 6使者：每个大学+2科技值

#### 2.1.4 贸易型城邦 (Trade)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_AMSTERDAM | 阿姆斯特丹 | Amsterdam | 贸易型标准加成 | 您的国际贸易路线为目的地提供+1金币，为起源城市提供+1文化值 | 原版 |
| CIVILIZATION_JAKARTA | 雅加达 | Jakarta | 贸易型标准加成 | 您的国际贸易路线为起源城市每有一种专业化区域提供+1金币 | 原版 |
| CIVILIZATION_LISBON | 里斯本 | Lisbon | 贸易型标准加成 | 您的贸易单位免受其他文明的海上劫掠 | 原版 |
| CIVILIZATION_ZANZIBAR | 桑给巴尔 | Zanzibar | 贸易型标准加成 | 获得肉桂和丁香奢侈资源（各提供6宜居度） | 原版 |

**使者加成（贸易型）：**
- 1使者：首都+4金币
- 3使者：每个市场/灯塔+4金币
- 6使者：每个银行/码头+4金币

#### 2.1.5 宗教型城邦 (Religious)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_JERUSALEM | 耶路撒冷 | Jerusalem | 宗教型标准加成 | 自动将您的宗教传播为您创建的宗教城市的宗教 | 原版 |
| CIVILIZATION_KANDY | 康提 | Kandy | 宗教型标准加成 | 发现自然奇观时获得1件圣遗物 | 原版 |
| CIVILIZATION_LA_VENTA | 拉文塔 | La Venta | 宗教型标准加成 | 您的建造者可建造巨石头像改良设施。+2信仰值，+1文化值 | 原版 |
| CIVILIZATION_YEREVAN | 耶列万 | Yerevan | 宗教型标准加成 | 您的使徒可从所有可能的升级中选择任意升级 | 原版 |

**使者加成（宗教型）：**
- 1使者：首都+2信仰值
- 3使者：每个神社+2信仰值
- 6使者：每个寺庙+2信仰值

#### 2.1.6 工业型城邦 (Industrial)

| 内部ID | 中文名 | 英文名 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|----------|------------|------|
| CIVILIZATION_BRUSSELS | 布鲁塞尔 | Brussels | 工业型标准加成 | 您的城市建造奇观时+15%生产力 | 原版 |
| CIVILIZATION_BUENOS_AIRES | 布宜诺斯艾利斯 | Buenos Aires | 工业型标准加成 | 您的奖励资源如同奢侈资源一样提供+1宜居度 | 原版 |
| CIVILIZATION_HONG_KONG | 香港 | Hong Kong | 工业型标准加成 | 您的城市建造城市项目时+20%生产力 | 原版 |
| CIVILIZATION_TORONTO | 多伦多 | Toronto | 工业型标准加成 | 对于您所有来自工业区和娱乐中心的建筑，其加成延伸范围增加3个单元格 | 原版 |

**使者加成（工业型）：**
- 1使者：首都+2生产力
- 3使者：每个工坊+2生产力
- 6使者：每个工厂+2生产力

---

### 2.2 Rise & Fall (Expansion1) 新增城邦（7个）

| 内部ID | 中文名 | 英文名 | 类型 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|------|----------|------------|------|
| CIVILIZATION_ANTANANARIVO | 塔那那利佛 | Antananarivo | 文化型 | 文化型标准加成 | 您获得的每位伟人使您的文明额外获得+2%文化值，最高+30% | XP1 |
| CIVILIZATION_ARMAGH | 阿马 | Armagh | 宗教型 | 宗教型标准加成 | 您的建造者可建造修道院改良设施。+2信仰值，+2住房 | XP1 |
| CIVILIZATION_AUCKLAND | 奥克兰 | Auckland | 工业型 | 工业型标准加成 | 浅水单元格+1生产力。进入工业时代后额外+1生产力 | XP1 |
| CIVILIZATION_BABYLON | 巴比伦 | Babylon | 科技型 | 科技型标准加成 | 获得每项您已解锁科技的尤里卡 | XP1 |
| CIVILIZATION_GRANADA | 格拉纳达 | Granada | 军事型 | 军事型标准加成 | 您的建造者可建造阿尔卡萨城堡改良设施。+2文化值，提供防御加成 | XP1 |
| CIVILIZATION_MUSCAT | 马斯喀特 | Muscat | 贸易型 | 贸易型标准加成 | 城市每个专业化区域为国际贸易路线提供+1金币 | XP1 |
| CIVILIZATION_PALENQUE | 帕伦克 | Palenque | 科技型 | 科技型标准加成 | 城市每有1人口，为其提供+1信仰值 | XP1 |

---

### 2.3 Gathering Storm (Expansion2) 新增城邦（11个）

| 内部ID | 中文名 | 英文名 | 类型 | 使者加成 | 宗主国加成 | 来源 |
|--------|--------|--------|------|----------|------------|------|
| CIVILIZATION_BOLOGNA | 博洛尼亚 | Bologna | 科技型 | 科技型标准加成 | 您的城市每个专业化区域提供+1伟人点数 | XP2 |
| CIVILIZATION_CAGUANA | 卡瓜纳 | Caguana | 文化型 | 文化型标准加成 | 您的建造者可建造巴蒂球场改良设施。+1文化值，随市政树进展增加 | XP2 |
| CIVILIZATION_CARDIFF | 加的夫 | Cardiff | 工业型 | 工业型标准加成 | 港口区域的每个建筑提供+2电力 | XP2 |
| CIVILIZATION_FEZ | 非斯 | Fez | 科技型 | 科技型标准加成 | 每次使用宗教单位转化城市时，根据该城市的非信仰者人口获得科技值 | XP2 |
| CIVILIZATION_LAHORE | 拉合尔 | Lahore | 军事型 | 军事型标准加成 | 可用信仰值购买尼罕步兵单位，不消耗资源 | XP2 |
| CIVILIZATION_MEXICO_CITY | 墨西哥城 | Mexico City | 工业型 | 工业型标准加成 | 您的区域的范围效果延伸3个单元格 | XP2 |
| CIVILIZATION_NAZCA | 纳斯卡 | Nazca | 宗教型 | 宗教型标准加成 | 您的建造者可建造纳斯卡线条改良设施。+1信仰值，为相邻单元格提供加成 | XP2 |
| CIVILIZATION_NGAZARGAMU | 恩加扎加穆 | Ngazargamu | 军事型 | 军事型标准加成 | 购买军事单位时，每种专业化区域类型减少20%金币花费 | XP2 |
| CIVILIZATION_RAPA_NUI | 拉帕努伊 | Rapa Nui | 文化型 | 文化型标准加成 | 您的建造者可建造摩艾石像改良设施。+1文化值，为相邻单元格提供文化值 | XP2 |
| CIVILIZATION_TARUGA | 塔鲁加 | Taruga | 科技型 | 科技型标准加成 | 每种战略资源提供+5%科技值 | XP2 |
| CIVILIZATION_WOLIN | 沃林 | Wolin | 军事型 | 军事型标准加成 | 击杀陆地单位时获得等同于其战斗力25%的大将军点数 | XP2 |

---

### 2.4 VikingsLandmarks DLC 城邦（3个）

| 内部ID | 中文名 | 英文名 | 类型 | 说明 | 来源 |
|--------|--------|--------|------|------|------|
| CIVILIZATION_AUCKLAND | 奥克兰 | Auckland | 工业型 | 与XP1重复，效果相同 | VikingsLandmarks |
| CIVILIZATION_ANTANANARIVO | 塔那那利佛 | Antananarivo | 文化型 | 与XP1重复，效果相同 | VikingsLandmarks |
| CIVILIZATION_ARMAGH | 阿马 | Armagh | 宗教型 | 与XP1重复，效果相同 | VikingsLandmarks |

> **注意**：VikingsLandmarks DLC 中的3个城邦与 Expansion1 完全重复。若同时拥有XP1和VikingsLandmarks，游戏会使用XP1的定义。

---

### 2.5 CIVITAS City-States Expanded Mod 新增城邦

CIVITAS mod 新增了多个城邦类型和大量城邦，以下按类型分组：

#### 2.5.1 新增军事型城邦 (Base)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_ALAMUT | 阿拉穆特 | Alamut | 间谍执行攻击性任务时+1级，间谍完成任务时间缩短25% | CSE Base |
| CIVILIZATION_CSE_BEIKTHANO | 贝塔诺 | Beikthano | 您的城市每级城墙+3远程攻击力，+5城市防御力 | CSE Base |
| CIVILIZATION_CSE_BUTUAN | 武端 | Butuan | 陆地单位上船时+2移动力，忽略上下船额外移动力消耗 | CSE Base |
| CIVILIZATION_CSE_DELPHI | 德尔菲 | Delphi | 奇观施加+2忠诚度压力，完成时触发文化炸弹 | CSE Base |
| CIVILIZATION_CSE_ETZANOA | 埃扎诺阿 | Etzanoa | 社区区域每个相邻的同类型区域提供+1住房 | CSE Base |

#### 2.5.2 新增科技型城邦 (Base)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_AZCAPOTZALCO | 阿兹卡波查尔科 | Azcapotzalco | 联盟点数获取速度+25% | CSE Base |
| CIVILIZATION_CSE_CATALHOYUK | 恰塔霍裕克 | Çatalhöyük | 获得皮革和羊毛奢侈资源（不可交易），各提供6宜居度 | CSE Base |
| CIVILIZATION_CSE_GOBEKLI_TEPE | 哥贝克力石阵 | Göbekli Tepe | 奇观为通往其城市的国内贸易路线提供+1文化值 | CSE Base |

#### 2.5.3 新增文化型城邦 (Base)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_ANURADHAPURA | 阿努拉德普勒 | Anuradhapura | 建造者可建造佛塔改良设施。+1文化值，+1信仰值，建造第一个佛塔获得免费圣遗物 | CSE Base |
| CIVILIZATION_CSE_CHAN_CHAN | 昌昌 | Chan Chan | 宫殿提供双倍产出、宜居度和住房。专业化区域相邻政府广场/娱乐中心/水上乐园时+50%原生产出 | CSE Base |
| CIVILIZATION_CSE_CHETRO_KETL | 切特罗凯特尔 | Chetro Ketl | 建造者可建造大基瓦改良设施。+2信仰值，+0.5住房，需建在沙漠/沙漠丘陵上 | CSE Base |
| CIVILIZATION_CSE_DELOS | 提洛 | Delos | 拥有娱乐中心/水上乐园的城市中，魅力值达到令人惊叹的平坦地块地形产出翻倍 | CSE Base |
| CIVILIZATION_CSE_DODONA | 多多纳 | Dodona | 黄金时代中鼓舞提供+10%市政成本，黑暗时代中提供额外时代分数 | CSE Base |

#### 2.5.4 新增贸易型城邦 (Base)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_DAKAR | 达喀尔 | Dakar | 港口区域内的建筑提供+1大商人点数 | CSE Base |
| CIVILIZATION_CSE_DJIBOUTI | 吉布提 | Djibouti | 浅水单元格提供+1食物。进入工业时代后额外+1食物 | CSE Base |

#### 2.5.5 新增宗教型城邦 (Base)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_AYNUK | 艾努克 | Aynuk | 市中心每个相邻海岸单元格提供+1食物和+1生产力 | CSE Base |
| CIVILIZATION_CSE_BAIAE | 拜亚 | Baiae | 娱乐区和水上乐园每回合提供+1外交支持 | CSE Base |
| CIVILIZATION_CSE_GARAMA | 加拉马 | Garama | 绿洲及其相邻陆地单元格+2食物，两格远的陆地单元格+1食物 | CSE Base |

#### 2.5.6 新增农业型城邦 (CSE 新类型)

| 内部ID | 中文名 | 英文名 | 宗主国加成 | 来源 |
|--------|--------|--------|------------|------|
| CIVILIZATION_CSE_AMPI | 安皮 | Ampi | 建造者可建造梯田改良设施。+1食物，+1生产力 | CSE Base |
| CIVILIZATION_SAMARKAND | 撒马尔罕/布哈拉 | Samarkand/Bukhara | 建造者可建造贸易圆顶改良设施。+2金币，+1食物 | CSE Base |

> **注意**：在MTE汉化中，CIVILIZATION_SAMARKAND 被改名为"布哈拉"以避免与巴比伦DLC的城市名冲突。

#### 2.5.7 CIVITAS Mod 使者加成体系（替代原版）

CIVITAS mod 修改了所有类型的使者加成，使用新的等级体系：

| 类型 | 1使者 | 3使者 | 6使者 | 10使者 |
|------|-------|-------|-------|--------|
| 科技型 | 首都+2科技值 | 每个图书馆+2科技值 | 每所大学+2科技值 | 每个研究实验室+2科技值 |
| 文化型 | 首都+2文化值 | 每个古罗马剧场+2文化值 | 每个艺术/考古博物馆+2文化值 | 每个广播中心+2文化值 |
| 贸易型 | 首都+4金币 | 每个市场/灯塔+4金币 | 每个银行/码头+4金币 | 每个证券交易所+4金币 |
| 军事型 | 首都+2生产力 | 每个兵营/马厩+2生产力 | 每个军械库+2生产力 | 每个军事学院+2生产力 |
| 宗教型 | 首都+2信仰值 | 每个神社+2信仰值 | 每个寺庙+2信仰值 | 每个祭祀建筑+2信仰值 |
| 工业型 | 首都+2生产力 | 每个工坊+2生产力 | 每个工厂+2生产力 | 每个发电厂+2生产力 |

CIVITAS mod 还新增了以下城邦类型的使者加成：

- **农业型**：1使者在首都+2食物，3使者每个粮仓+2食物，6使者每个下水道+2食物，10使者每个社区+2食物
- **领事型**：1使者在首都+2影响力点数，3使者每个纪念碑+2影响力点数，6使者每个领事馆+2影响力点数
- **娱乐型**：1使者在首都+2宜居度，3使者每个竞技场+2宜居度
- **外交型**：1使者在首都+2外交支持，3使者每个外交区建筑+2外交支持

---

## 3. 关联数据

### 3.1 使者加成 Modifier 定义

原版游戏使用以下 Modifier 体系实现使者加成：

| Modifier ID | 效果 | 数值 |
|-------------|------|------|
| MINOR_CIV_SCIENTIFIC_SMALL_INFLUENCE_BONUS | 首都+2科技值 | Amount=2 |
| MINOR_CIV_SCIENTIFIC_MEDIUM_INFLUENCE_BONUS | 每个图书馆+2科技值 | Amount=2 |
| MINOR_CIV_SCIENTIFIC_LARGE_INFLUENCE_BONUS | 每个大学+2科技值 | Amount=2 |
| MINOR_CIV_CULTURAL_SMALL_INFLUENCE_BONUS | 首都+2文化值 | Amount=2 |
| MINOR_CIV_CULTURAL_MEDIUM_INFLUENCE_BONUS | 每个古罗马剧场+2文化值 | Amount=2 |
| MINOR_CIV_CULTURAL_LARGE_INFLUENCE_BONUS | 每个博物馆+2文化值 | Amount=2 |
| MINOR_CIV_TRADE_SMALL_INFLUENCE_BONUS | 首都+4金币 | Amount=4 |
| MINOR_CIV_TRADE_MEDIUM_INFLUENCE_BONUS | 每个市场/灯塔+4金币 | Amount=4 |
| MINOR_CIV_TRADE_LARGE_INFLUENCE_BONUS | 每个银行/码头+4金币 | Amount=4 |
| MINOR_CIV_MILITARISTIC_SMALL_INFLUENCE_BONUS | 首都+2生产力 | Amount=2 |
| MINOR_CIV_MILITARISTIC_MEDIUM_INFLUENCE_BONUS | 每个兵营/马厩+2生产力 | Amount=2 |
| MINOR_CIV_MILITARISTIC_LARGE_INFLUENCE_BONUS | 每个军械库+2生产力 | Amount=2 |
| MINOR_CIV_RELIGIOUS_SMALL_INFLUENCE_BONUS | 首都+2信仰值 | Amount=2 |
| MINOR_CIV_RELIGIOUS_MEDIUM_INFLUENCE_BONUS | 每个神社+2信仰值 | Amount=2 |
| MINOR_CIV_RELIGIOUS_LARGE_INFLUENCE_BONUS | 每个寺庙+2信仰值 | Amount=2 |
| MINOR_CIV_INDUSTRIAL_SMALL_INFLUENCE_BONUS | 首都+2生产力 | Amount=2 |
| MINOR_CIV_INDUSTRIAL_MEDIUM_INFLUENCE_BONUS | 每个工坊+2生产力 | Amount=2 |
| MINOR_CIV_INDUSTRIAL_LARGE_INFLUENCE_BONUS | 每个工厂+2生产力 | Amount=2 |

### 3.2 城邦任务（Quests）

原版城邦任务类型：

| 任务ID | 描述 |
|--------|------|
| MINOR_CIV_QUEST_ROUTE | 建立贸易路线 |
| MINOR_CIV_QUEST_CONSTRUCT_X | 建造特定建筑/单位 |
| MINOR_CIV_QUEST_CREATE_GREAT_PERSON | 招募伟人 |
| MINOR_CIV_QUEST_CONTEST_CULTURE | 文化竞赛 |
| MINOR_CIV_QUEST_CONTEST_SCIENCE | 科技竞赛 |
| MINOR_CIV_QUEST_CONTEST_FAITH | 信仰竞赛 |
| MINOR_CIV_QUEST_CONTEST_DOMINATION | 军事竞赛 |
| MINOR_CIV_QUEST_KILL_CITY_STATE_UNITS | 消灭城邦单位 |
| MINOR_CIV_QUEST_FIND_CITY_STATE | 发现城邦 |
| MINOR_CIV_QUEST_FIND_NATURAL_WONDER | 发现自然奇观 |
| MINOR_CIV_QUEST_CONVERT_CITY | 转化城市 |
| MINOR_CIV_QUEST_TRADE_ROUTE_PLUNDER | 劫掠贸易路线 |
| MINOR_CIV_QUEST_CLEAR_BARBARIANS | 清除蛮族营地 |

### 3.3 新增改良设施（CIVITAS Mod）

| 改良设施ID | 名称 | 来自城邦 | 效果 |
|------------|------|----------|------|
| IMPROVEMENT_CSE_DAGOBA | 佛塔 | Anuradhapura | +1文化值，+1信仰值，每相邻圣地+1信仰值，每相邻剧院广场+1文化值 |
| IMPROVEMENT_CSE_KIVA | 大基瓦 | Chetro Ketl | +2信仰值，+0.5住房，需建在沙漠/沙漠丘陵 |
| IMPROVEMENT_CSE_TERRACE | 梯田 | Ampi | +1食物，+1生产力 |
| IMPROVEMENT_TRADING_DOME | 贸易圆顶 | Samarkand | +2金币，+1食物 |

### 3.4 新增奢侈资源（CIVITAS Mod）

| 资源ID | 名称 | 来自城邦 | 效果 |
|--------|------|----------|------|
| RESOURCE_CSE_LEATHER | 皮革 | Çatalhöyük | 提供6宜居度（不可交易） |
| RESOURCE_CSE_WOOL | 羊毛 | Çatalhöyük | 提供6宜居度（不可交易） |

---

## 4. 被修改/删除的原版内容

### 4.1 CIVITAS Mod 对原版内容的修改

CIVITAS City-States Expanded Mod 修改了以下原版内容：

1. **使者加成体系**：将原版的3级体系（1/3/6使者）扩展为4级体系（1/3/6/10使者），并修改了各级对应建筑
   - 原版第3级（6使者）对应的建筑被改为"大使"级别
   - 新增第4级（10使者）对应更高级建筑

2. **城邦类型名称**：使用新的 LOC_CSE_*_TRAIT 标签替代原版标签

3. **领事城邦追加机制**：MOD 新增了"领事城邦"概念，派遣使者可获得外交支持或忠诚度奖励

4. **城邦初始城墙**：MOD 可配置城邦是否在生成时拥有城墙

5. **埃塞俄比亚模式**：新增使者加成与区域建筑阶级挂钩的机制

### 4.2 MTE 汉化修改

MTE 汉化 mod 对 CIVITAS 城邦进行了以下名称修改：

| 原ID | 原英文名 | MTE中文名 | 说明 |
|------|----------|-----------|------|
| CIVILIZATION_SAMARKAND | Samarkand | 布哈拉 | 因与巴比伦DLC城市名冲突，改名为布哈拉 |

---

## 5. 兼容性分析

### 5.1 各来源之间的重叠

| 城邦ID | 原版 | XP1 | XP2 | VikingsLandmarks | CSE |
|--------|------|-----|-----|------------------|-----|
| CIVILIZATION_AUCKLAND | - | ✓ | - | ✓ | - |
| CIVILIZATION_ANTANANARIVO | - | ✓ | - | ✓ | - |
| CIVILIZATION_ARMAGH | - | ✓ | - | ✓ | - |

### 5.2 潜在冲突

1. **VikingsLandmarks vs. Expansion1**：3个城邦完全重复。若同时启用，Expansion1 的定义优先。
2. **CIVITAS Mod vs. 原版**：CIVITAS 修改了所有城邦的使者加成体系，会覆盖原版加成。
3. **MTE 汉化 vs. CIVITAS**：MTE 汉化会替换 CIVITAS 的英文文本为中文，同时修改了撒马尔罕的名称。
4. **撒马尔罕名称冲突**：CIVILIZATION_SAMARKAND 与巴比伦DLC的城市名重复，MTE汉化将其改为"布哈拉"。

### 5.3 加载顺序建议

1. 原版基础游戏
2. VikingsLandmarks DLC（如适用）
3. Expansion1 (Rise & Fall)
4. Expansion2 (Gathering Storm)
5. CIVITAS City-States Expanded
6. Better Chinese for GS 汉化
7. MTE 汉化（CIVITAS 部分）

---

## 6. 附录：完整城邦列表

### 原版基础游戏（24个）

| # | 内部ID | 中文名 | 英文名 | 类型 |
|---|--------|--------|--------|------|
| 1 | CIVILIZATION_AMSTERDAM | 阿姆斯特丹 | Amsterdam | 贸易 |
| 2 | CIVILIZATION_BRUSSELS | 布鲁塞尔 | Brussels | 工业 |
| 3 | CIVILIZATION_BUENOS_AIRES | 布宜诺斯艾利斯 | Buenos Aires | 工业 |
| 4 | CIVILIZATION_CARTHAGE | 迦太基 | Carthage | 军事 |
| 5 | CIVILIZATION_GENEVA | 日内瓦 | Geneva | 科技 |
| 6 | CIVILIZATION_HATTUSA | 哈图萨 | Hattusa | 科技 |
| 7 | CIVILIZATION_HONG_KONG | 香港 | Hong Kong | 工业 |
| 8 | CIVILIZATION_JAKARTA | 雅加达 | Jakarta | 贸易 |
| 9 | CIVILIZATION_JERUSALEM | 耶路撒冷 | Jerusalem | 宗教 |
| 10 | CIVILIZATION_KABUL | 喀布尔 | Kabul | 军事 |
| 11 | CIVILIZATION_KANDY | 康提 | Kandy | 宗教 |
| 12 | CIVILIZATION_KUMASI | 库马西 | Kumasi | 文化 |
| 13 | CIVILIZATION_LA_VENTA | 拉文塔 | La Venta | 宗教 |
| 14 | CIVILIZATION_LISBON | 里斯本 | Lisbon | 贸易 |
| 15 | CIVILIZATION_MOHENJO_DARO | 摩亨佐达罗 | Mohenjo Daro | 文化 |
| 16 | CIVILIZATION_NAN_MADOL | 南马都尔 | Nan Madol | 文化 |
| 17 | CIVILIZATION_PRESLAV | 普雷斯拉夫 | Preslav | 军事 |
| 18 | CIVILIZATION_SEOUL | 首尔 | Seoul | 科技 |
| 19 | CIVILIZATION_STOCKHOLM | 斯德哥尔摩 | Stockholm | 科技 |
| 20 | CIVILIZATION_TORONTO | 多伦多 | Toronto | 工业 |
| 21 | CIVILIZATION_VALLETTA | 瓦莱塔 | Valletta | 军事 |
| 22 | CIVILIZATION_VILNIUS | 维尔纽斯 | Vilnius | 文化 |
| 23 | CIVILIZATION_YEREVAN | 耶列万 | Yerevan | 宗教 |
| 24 | CIVILIZATION_ZANZIBAR | 桑给巴尔 | Zanzibar | 贸易 |

### Expansion1 (Rise & Fall) 新增（7个）

| # | 内部ID | 中文名 | 英文名 | 类型 |
|---|--------|--------|--------|------|
| 25 | CIVILIZATION_ANTANANARIVO | 塔那那利佛 | Antananarivo | 文化 |
| 26 | CIVILIZATION_ARMAGH | 阿马 | Armagh | 宗教 |
| 27 | CIVILIZATION_AUCKLAND | 奥克兰 | Auckland | 工业 |
| 28 | CIVILIZATION_BABYLON | 巴比伦 | Babylon | 科技 |
| 29 | CIVILIZATION_GRANADA | 格拉纳达 | Granada | 军事 |
| 30 | CIVILIZATION_MUSCAT | 马斯喀特 | Muscat | 贸易 |
| 31 | CIVILIZATION_PALENQUE | 帕伦克 | Palenque | 科技 |

### Expansion2 (Gathering Storm) 新增（11个）

| # | 内部ID | 中文名 | 英文名 | 类型 |
|---|--------|--------|--------|------|
| 32 | CIVILIZATION_BOLOGNA | 博洛尼亚 | Bologna | 科技 |
| 33 | CIVILIZATION_CAGUANA | 卡瓜纳 | Caguana | 文化 |
| 34 | CIVILIZATION_CARDIFF | 加的夫 | Cardiff | 工业 |
| 35 | CIVILIZATION_FEZ | 非斯 | Fez | 科技 |
| 36 | CIVILIZATION_LAHORE | 拉合尔 | Lahore | 军事 |
| 37 | CIVILIZATION_MEXICO_CITY | 墨西哥城 | Mexico City | 工业 |
| 38 | CIVILIZATION_NAZCA | 纳斯卡 | Nazca | 宗教 |
| 39 | CIVILIZATION_NGAZARGAMU | 恩加扎加穆 | Ngazargamu | 军事 |
| 40 | CIVILIZATION_RAPA_NUI | 拉帕努伊 | Rapa Nui | 文化 |
| 41 | CIVILIZATION_TARUGA | 塔鲁加 | Taruga | 科技 |
| 42 | CIVILIZATION_WOLIN | 沃林 | Wolin | 军事 |

---

*报告生成时间：2026-07-04*
*数据来源：/workspace/原版+DLC/ 及 /workspace/MOD/ 目录下所有相关 XML/SQL 文件*