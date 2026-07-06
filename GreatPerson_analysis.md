# 文明VI 伟人数据完整分析报告

> 生成日期：2026-07-06  
> 数据来源：原版游戏 + DLC（迭起兴衰、风云变幻、巴比伦）+ MOD伟人模块

---

## 目录

1. [伟人类型概览](#1-伟人类型概览)
2. [原始游戏伟人数据](#2-原始游戏伟人数据)
3. [DLC新增伟人数据](#3-dlc新增伟人数据)
4. [MOD新增伟人数据](#4-mod新增伟人数据)
5. [伟人能力效果总结](#5-伟人能力效果总结)
6. [加载顺序与覆盖分析](#6-加载顺序与覆盖分析)
7. [MOD删除的伟人](#7-mod删除的伟人)
8. [数据统计](#8-数据统计)

---

## 1. 伟人类型概览

文明VI中共有 **9种** 伟人类型（原始游戏），外加MOD新增的 **1种** 大统治者类型：

| 序号 | 伟人类型 | 英文名 | 关联区域 | 专属单位 | 备注 |
|------|---------|--------|---------|---------|------|
| 1 | 大将军 | GREAT_PERSON_CLASS_GENERAL | 军营 (Encampment) | UNIT_GREAT_GENERAL | 提供光环：战斗力和移动力加成 |
| 2 | 海军统帅 | GREAT_PERSON_CLASS_ADMIRAL | 港口 (Harbor) | UNIT_GREAT_ADMIRAL | 提供光环：战斗力和移动力加成 |
| 3 | 大工程师 | GREAT_PERSON_CLASS_ENGINEER | 工业区 (Industrial Zone) | UNIT_GREAT_ENGINEER | 城市建造/产能相关 |
| 4 | 大商人 | GREAT_PERSON_CLASS_MERCHANT | 商业中心 (Commercial Hub) | UNIT_GREAT_MERCHANT | 贸易/金币/资源相关 |
| 5 | 大预言家 | GREAT_PERSON_CLASS_PROPHET | 圣地 (Holy Site) | UNIT_GREAT_PROPHET | 每位玩家最多1个 (MaxPlayerInstances=1) |
| 6 | 大科学家 | GREAT_PERSON_CLASS_SCIENTIST | 学院 (Campus) | UNIT_GREAT_SCIENTIST | 科技/科研相关 |
| 7 | 大作家 | GREAT_PERSON_CLASS_WRITER | 剧院 (Theater) | UNIT_GREAT_WRITER | 创作巨作 (2个著作槽位) |
| 8 | 大艺术家 | GREAT_PERSON_CLASS_ARTIST | 剧院 (Theater) | UNIT_GREAT_ARTIST | 创作巨作 (3个艺术槽位) |
| 9 | 大音乐家 | GREAT_PERSON_CLASS_MUSICIAN | 剧院 (Theater) | UNIT_GREAT_MUSICIAN | 创作巨作 (2个音乐槽位) |
| 10 | 大统治者 | GREAT_PERSON_CLASS_GreatSovereigns | 政府区 (Government) | UNIT_GREAT_GreatSovereigns | MOD新增 (Platige) |

**大预言家特殊规则：** 每位玩家最多只能获得1位大预言家。宗教转化型领袖（如刚果）不能获得大预言家。

**通用光环效果：** 所有大将军和海军统帅在获得时，会对同时代的对应领域单位提供战斗力和移动力光环加成（范围2格）。大将军提供 +5 战斗力 +1 移动力，海军统帅提供 +5 战斗力 +1 移动力。

---

## 2. 原始游戏伟人数据

### 2.1 大将军 (GREAT_PERSON_CLASS_GENERAL)

**总计：20位**

| 时代 | 名称 | 次数 | 激活条件 | 效果 |
|------|------|------|---------|------|
| 古典 | 布狄卡 (Boudica) | 1 | 需相邻蛮族单位 | 转化相邻蛮族单位为己方 |
| 古典 | 汉尼拔·巴卡 (Hannibal Barca) | 1 | 需陆地军事单位(可升级) | 授予1级晋升 |
| 古典 | 孙子 (Sun Tzu) | 0 | 无 | 创作巨作《孙子兵法》 |
| 中世纪 | 埃塞尔弗莱德 (Aethelflaed) | 1 | 需无军事单位在格 | 免费创建骑士 (Knight) |
| 中世纪 | 熙德 (El Cid) | 1 | 需陆地军事单位(标准编队) | 编组为军团 (Corps) |
| 中世纪 | 成吉思汗 (Genghis Khan) | 1 | 需陆地军事单位(可升级) | 授予1级晋升 + 25%战斗经验 |
| 文艺复兴 | 古斯塔夫·阿道夫 (Gustavus Adolphus) | 1 | 需无军事单位在格 | 免费创建射石炮 (Bombard) |
| 文艺复兴 | 圣女贞德 (Joan of Arc) | 1 | 需遗迹槽位可用 | 创建1件圣物 (Relic) |
| 文艺复兴 | 安娜·恩津加 (Ana Nzinga) | 1 | 无特殊条件 | 授予1位使者 |
| 工业 | 拿破仑·波拿巴 (Napoleon Bonaparte) | 1 | 需陆地军事单位(标准编队) | 编组为军队 (Army) |
| 工业 | 拉尼·拉克希米·芭伊 (Rani Lakshmibai) | 1 | 需无军事单位在格 | 免费创建骑兵 (Cavalry) |
| 工业 | 西蒙·玻利瓦尔 (Simon Bolivar) | 1 | 无特殊条件 | 授予2位使者 |
| 现代 | 约翰·莫纳什 (John Monash) | 1 | 需陆地军事单位(可升级) | 授予1级晋升 + 经验加成能力 |
| 现代 | 玛丽娜·拉斯科娃 (Marina Raskova) | 1 | 需在己方领地+机场 | 为机场+1空中单位槽位 |
| 现代 | 萨莫里·杜尔 (Samori Ture) | 1 | 需无军事单位在格 | 免费创建步兵 (Infantry) |
| 原子 | 德怀特·艾森豪威尔 (Dwight Eisenhower) | 1 | 无特殊条件 | 军事单位+5生产力 |
| 原子 | 格奥尔基·朱可夫 (Georgy Zhukov) | 1 | 无特殊条件 | 所有陆地单位+5侧翼加成 |
| 原子 | 道格拉斯·麦克阿瑟 (Douglas MacArthur) | 1 | 需无军事单位在格 | 免费创建坦克 (Tank) |
| 原子 | 苏迪曼 (Sudirman) | 1 | 需陆地军事单位(可升级) | 授予1级晋升 + 100%战斗经验 |
| 信息 | 艾哈迈德·沙阿·马苏德 (Ahmad Shah Massoud) | 1 | 需无军事单位在格 | 免费创建现代反坦克炮 (Modern AT) |
| 信息 | 维贾亚·维马拉拉特内 (Vijaya Wimalaratne) | 1 | 需陆地军事单位(可升级) | 授予1级晋升 + 经验加成能力 |

---

### 2.2 海军统帅 (GREAT_PERSON_CLASS_ADMIRAL)

**总计：19位**

| 时代 | 名称 | 次数 | 激活条件 | 效果 |
|------|------|------|---------|------|
| 古典 | 阿尔特米西亚 (Artemisia) | 1 | 需海军单位(可升级) | 授予1级晋升 |
| 古典 | 盖乌斯·杜伊利乌斯 (Gaius Duilius) | 1 | 需海军单位(标准编队) | 编组为分舰队 (Corps) |
| 古典 | 地米斯托克利 (Themistocles) | 1 | 需无军事单位在格 | 免费创建四列桨座战船 (Quadrireme) |
| 中世纪 | 莱夫·埃里克森 (Leif Erikson) | 1 | 无特殊条件 | 所有海军单位可进入大洋 |
| 中世纪 | 拉金德拉·朱罗 (Rajendra Chola) | 1 | 无特殊条件 | +50金币 + 掠夺加成能力 |
| 中世纪 | 郑和 (Zheng He) | 1 | 无特殊条件 | 授予1位使者 |
| 文艺复兴 | 弗朗西斯·德雷克 (Francis Drake) | 1 | 无特殊条件 | +75金币 + 掠夺加成能力 |
| 文艺复兴 | 圣克鲁斯 (Santa Cruz) | 1 | 需海军单位(标准编队) | 编组为舰队 (Army) |
| 文艺复兴 | 李舜臣 (Yi Sun-Sin) | 1 | 需无军事单位在格 | 免费创建铁甲舰 (Ironclad) |
| 工业 | 郑氏 (Ching Shih) | 1 | 无特殊条件 | +100金币 + 掠夺加成能力 |
| 工业 | 霍雷肖·纳尔逊 (Horatio Nelson) | 1 | 无特殊条件 | 所有海军单位+5侧翼加成 |
| 工业 | 拉斯卡里娜·布布利纳 (Laskarina Bouboulina) | 1 | 需海军单位(可升级) | 授予1级晋升 + 经验加成 |
| 现代 | 弗朗茨·冯·希佩尔 (Franz von Hipper) | 1 | 需无军事单位在格 | 免费创建战列舰 (Battleship) |
| 现代 | 若阿金·马奎斯·里斯本 (Joaquim Marques Lisboa) | 1 | 无特殊条件 | -25%厌战情绪 |
| 现代 | 东乡平八郎 (Togo Heihachiro) | 1 | 需海军单位(可升级) | 授予1级晋升 + 75%战斗经验 |
| 原子 | 切斯特·尼米兹 (Chester Nimitz) | 1 | 无特殊条件 | 海军掠夺者+20%生产力 |
| 原子 | 格蕾丝·霍珀 (Grace Hopper) | 1 | 无特殊条件 | 1个原子/信息时代随机科技尤里卡 |
| 原子 | 谢尔盖·戈尔什科夫 (Sergey Gorshkov) | 1 | 需海军单位(可升级) | 授予1级晋升 + 经验加成能力 |
| 信息 | 克兰西·费尔南多 (Clancy Fernando) | 1 | 需海军单位(可升级) | 授予1级晋升 + 经验加成能力 |

---

### 2.3 大工程师 (GREAT_PERSON_CLASS_ENGINEER)

**总计：18位**

| 时代 | 名称 | 次数 | 激活条件 | 效果 |
|------|------|------|---------|------|
| 中世纪 | 毕昇 (Bi Sheng) | 1 | 需市中心 | +1区域容量 + 印刷术尤里卡 |
| 中世纪 | 米利都的伊西多尔 (Isidore of Miletus) | 2 | 需未完成奇观 | 215产能投入奇观 |
| 中世纪 | 圣乔治的詹姆斯 (James of St. George) | 3 | 需市中心(缺城堡) | 建造远古城墙和城堡 |
| 文艺复兴 | 菲利波·布鲁内莱斯基 (Filippo Brunelleschi) | 2 | 需未完成奇观 | 315产能投入奇观 |
| 文艺复兴 | 列奥纳多·达·芬奇 (Leonardo da Vinci) | 1 | 需工业区 | 工坊+1文化 + 1个现代科技尤里卡 |
| 文艺复兴 | 米马尔·锡南 (Mimar Sinan) | 2 | 需市中心 | +1住房 +1宜居度 |
| 工业 | 艾达·洛夫莱斯 (Ada Lovelace) | 1 | 需市中心 | +1区域容量 + 计算机尤里卡 |
| 工业 | 古斯塔夫·埃菲尔 (Gustave Eiffel) | 2 | 需未完成奇观 | 480产能投入奇观 |
| 工业 | 詹姆斯·瓦特 (James Watt) | 1 | 需工业区 | 建造工坊+工厂，工厂+2产能 |
| 现代 | 阿尔瓦·阿尔托 (Alvar Aalto) | 1 | 需市中心 | 城市+1吸引力 |
| 现代 | 尼古拉·特斯拉 (Nikola Tesla) | 1 | 需工业区 | 区域建筑范围+3，区域建筑+2产能 |
| 现代 | 罗伯特·戈达德 (Robert Goddard) | 1 | 需工业区 | +20%太空竞赛产能 + 火箭学尤里卡 |
| 原子 | 约翰·A·罗布林 (John A. Roebling) | 2 | 需市中心 | +2住房 +1宜居度 |
| 原子 | 简·德鲁 (Jane Drew) | 1 | 需市中心 | +4住房 +3宜居度 |
| 原子 | 谢尔盖·科罗廖夫 (Sergei Korolev) | 1 | 需航天发射场+未完成太空项目 | 1500产能投入太空竞赛项目 |
| 信息 | 查尔斯·科雷亚 (Charles Correa) | 1 | 需市中心 | 城市+2吸引力 |
| 信息 | 约瑟夫·帕克斯顿 (Joseph Paxton) | 1 | 需娱乐中心 | 区域建筑范围+1，区域建筑+1宜居度 |
| 信息 | 沃纳·冯·布劳恩 (Wernher von Braun) | 1 | 需航天发射场 | +100%太空竞赛产能 |

---

### 2.4 大商人 (GREAT_PERSON_CLASS_MERCHANT)

**总计：21位**

| 时代 | 名称 | 次数 | 激活条件 | 效果 |
|------|------|------|---------|------|
| 古典 | 科莱乌斯 (Colaeus) | 1 | 需可见奢侈品 | 授予免费奢侈品资源 + 60信仰 |
| 古典 | 马库斯·李锡尼·克拉苏 (Marcus Licinius Crassus) | 3 | 需无主相邻己方地块 | 吞并相邻地块 + 60金币 |
| 古典 | 张骞 (Zhang Qian) | 1 | 需商业中心 | 境外入城路线+1金币，来自境外入城路线+1金币，+1贸易路线 |
| 中世纪 | 马可·波罗 (Marco Polo) | 1 | 需商业中心 | 境外入/出城路线+1金币，免费商人，+1贸易路线 |
| 中世纪 | 皮耶罗·德·巴尔迪 (Piero de Bardi) | 1 | 需商业中心 | 200金币 + 1使者 |
| 中世纪 | 雅典的伊琳娜 (Irene of Athens) | 1 | 需可见奢侈品 | 授予免费奢侈品资源 + +1贸易路线 |
| 文艺复兴 | 乔瓦尼·德·美第奇 (Giovanni de Medici) | 1 | 需商业中心 | 建造市场+银行，银行+2巨作槽位 |
| 文艺复兴 | 雅各布·富格尔 (Jakob Fugger) | 1 | 需商业中心 | 200金币 + 2使者 |
| 文艺复兴 | 托达尔·马尔 (Raja Todar Mal) | 1 | 需商业中心 | 1使者 + 国内路线每专业区域+0.5金币 |
| 工业 | 亚当·斯密 (Adam Smith) | 1 | 需商业中心 | +1经济政策槽位 |
| 工业 | 约翰·斯皮尔斯伯里 (John Spilsbury) | 1 | 需商业中心 | 授予玩具奢侈品资源 |
| 工业 | 约翰·雅各布·阿斯特 (John Jacob Astor) | 1 | 需商业中心 | 500金币 + 2使者 |
| 现代 | 约翰·洛克菲勒 (John Rockefeller) | 1 | 需商业中心 | 授予石油 + 战略资源路线金币加成 |
| 现代 | 莎拉·布里德洛夫 (Sarah Breedlove) | 1 | 需商业中心 | 贸易路线+25%旅游业绩 |
| 现代 | 玛丽·凯瑟琳·戈达德 (Mary Katherine Goddard) | 1 | 需商业中心 | +1外交能见度等级 |
| 原子 | 海伦娜·鲁宾斯坦 (Helena Rubinstein) | 1 | 需商业中心 | 授予化妆品奢侈品资源 |
| 原子 | 梅利塔·本茨 (Melitta Bentz) | 1 | 需商业中心 | +25%贸易路线旅游业绩 + +1贸易路线 |
| 原子 | 李维·施特劳斯 (Levi Strauss) | 1 | 需商业中心 | 授予牛仔裤奢侈品资源 |
| 信息 | 雅诗·兰黛 (Estee Lauder) | 1 | 需商业中心 | 授予香水奢侈品资源 |
| 信息 | 井深大 (Masaru Ibuka) | 1 | 需工业区 | 工业区旅游业绩 |
| 信息 | 贾姆希德吉·塔塔 (Jamsetji Tata) | 1 | 需学院 | 学院旅游业绩 |

---

### 2.5 大科学家 (GREAT_PERSON_CLASS_SCIENTIST)

**总计：21位**

| 时代 | 名称 | 次数 | 激活条件 | 效果 |
|------|------|------|---------|------|
| 古典 | 阿耶波多 (Aryabhata) | 1 | 需学院 | 3个古典/中世纪随机科技尤里卡 |
| 古典 | 欧几里得 (Euclid) | 1 | 需学院 | 1个中世纪科技尤里卡 + 数学尤里卡 |
| 古典 | 希帕提娅 (Hypatia) | 1 | 需学院 | 建造图书馆，图书馆+1科技值 |
| 中世纪 | 阿布·卡西姆·扎赫拉维 (Abu Al-Qasim Al-Zahrawi) | 1 | 无特殊条件 | 1个中世纪/文艺复兴科技尤里卡 + 单位+5 HP/回合 |
| 中世纪 | 宾根的希尔德加德 (Hildegard of Bingen) | 1 | 需圣地 | 圣地相邻加成提供科技值 + 100信仰 |
| 中世纪 | 欧玛尔·海亚姆 (Omar Khayyam) | 1 | 需学院 | 2个中世纪/文艺复兴科技尤里卡 + 1个中世纪/文艺复兴市政尤里卡 |
| 文艺复兴 | 伽利略·伽利莱 (Galileo Galilei) | 1 | 需相邻山脉 | 每相邻山脉格子+250科技值 |
| 文艺复兴 | 艾萨克·牛顿 (Isaac Newton) | 1 | 需学院 | 建造图书馆+大学，大学+2科技值 |
| 文艺复兴 | 埃米莉·杜·夏特莱 (Emilie du Chatelet) | 1 | 需学院 | 3个文艺复兴/工业科技尤里卡 |
| 工业 | 詹姆斯·杨 (James Young) | 1 | 需学院 | 揭示石油 + 2个工业/现代科技尤里卡 |
| 工业 | 查尔斯·达尔文 (Charles Darwin) | 1 | 需在或相邻自然奇观 | 每相邻自然奇观格子+500科技值 |
| 工业 | 德米特里·门捷列夫 (Dmitri Mendeleev) | 1 | 需学院 | 1个工业科技尤里卡 + 化学尤里卡 |
| 现代 | 艾伦·图灵 (Alan Turing) | 1 | 需学院 | 1个现代科技尤里卡 + 计算机尤里卡 |
| 现代 | 阿尔伯特·爱因斯坦 (Albert Einstein) | 1 | 需学院 | 研究实验室+4科技值 + 1个现代/原子科技尤里卡 |
| 现代 | 阿尔弗雷德·诺贝尔 (Alfred Nobel) | 1 | 需学院 | 1个现代/原子科技尤里卡 + 100伟人点数 |
| 原子 | 贾纳基·阿马尔 (Janaki Ammal) | 1 | 需在或相邻雨林 | 每相邻雨林格子+400科技值 |
| 原子 | 玛丽·利基 (Mary Leakey) | 1 | 需剧院+文物 | 文物+200%旅游业绩 + 文物+3科技值 |
| 原子 | 埃尔温·薛定谔 (Erwin Schrodinger) | 1 | 需学院 | 3个原子/信息科技尤里卡 |
| 信息 | 阿卜杜斯·萨拉姆 (Abdus Salam) | 1 | 需学院 | 所有信息时代科技尤里卡 |
| 信息 | 卡尔·萨根 (Carl Sagan) | 1 | 需航天发射场+未完成太空项目 | 3000产能投入太空竞赛项目 |
| 信息 | 斯蒂芬妮·克沃勒克 (Stephanie Kwolek) | 1 | 需航天发射场 | +100%太空竞赛产能 |

---

### 2.6 大预言家 (GREAT_PERSON_CLASS_PROPHET)

**总计：16位，均为0次行动次数，无特殊行动效果**

| 时代 | 名称 |
|------|------|
| 古典 | 施洗约翰 (John the Baptist) |
| 古典 | 孔子 (Confucius) |
| 古典 | 琐罗亚斯德 (Zoroaster) |
| 古典 | 悉达多·乔达摩/佛陀 (Siddhartha Gautama) |
| 古典 | 老子 (Laozi) |
| 古典 | 西门·彼得 (Simon Peter) |
| 中世纪 | 菩提达摩 (Bodhidharma) |
| 中世纪 | 阿迪·商羯罗 (Adi Shankara) |
| 中世纪 | 松赞干布 (Songtsan Gampo) |
| 中世纪 | 太安万侶 (O no Yasumaro) |
| 中世纪 | 爱任纽 (Irenaeus) |
| 文艺复兴 | 马丁·路德 (Martin Luther) |
| 文艺复兴 | 阿西西的方济各 (Francis of Assisi) |
| 文艺复兴 | 摩陀婆·阿阇梨 (Madhva Acharya) |
| 文艺复兴 | 托马斯·阿奎那 (Thomas Aquinas) |
| 文艺复兴 | 哈吉·胡德 (Haji Huud) |

---

### 2.7 大作家 (GREAT_PERSON_CLASS_WRITER)

**总计：19位，均为0次行动次数，创建2个巨作**

| 时代 | 名称 |
|------|------|
| 古典 | 跋娑 (Bhasa) |
| 古典 | 荷马 (Homer) |
| 古典 | 奥维德 (Ovid) |
| 古典 | 屈原 (Qu Yuan) — 2次行动次数 |
| 中世纪 | 杰弗里·乔叟 (Geoffrey Chaucer) |
| 中世纪 | 李白 (Li Bai) |
| 中世纪 | 紫式部 (Murasaki Shikibu) |
| 文艺复兴 | 玛格丽特·卡文迪什 (Margaret Cavendish) |
| 文艺复兴 | 米格尔·德·塞万提斯 (Miguel de Cervantes) |
| 文艺复兴 | 尼科洛·马基雅维利 (Niccolo Machiavelli) |
| 文艺复兴 | 威廉·莎士比亚 (William Shakespeare) |
| 文艺复兴 | 玛丽·凯瑟琳·德·奥尔努瓦 (Marie Catherine d'Aulnoy) |
| 工业 | 亚历山大·普希金 (Alexander Pushkin) |
| 工业 | 埃德加·爱伦·坡 (Edgar Allen Poe) |
| 工业 | 简·奥斯汀 (Jane Austen) |
| 工业 | 约翰·沃尔夫冈·冯·歌德 (Johann Wolfgang von Goethe) |
| 工业 | 玛丽·雪莱 (Mary Shelley) |
| 现代 | 詹姆斯·乔伊斯 (James Joyce) |
| 现代 | 艾米莉·狄金森 (Emily Dickinson) |
| 现代 | 列夫·托尔斯泰 (Leo Tolstoy) |
| 现代 | 马克·吐温 (Mark Twain) |
| 现代 | F·斯科特·菲茨杰拉德 (F. Scott Fitzgerald) |
| 原子 | H·G·威尔斯 (H.G. Wells) |
| 原子 | 拉宾德拉纳特·泰戈尔 (Rabindranath Tagore) |
| 信息 | 卡雷尔·恰佩克 (Karel Capek) |

---

### 2.8 大艺术家 (GREAT_PERSON_CLASS_ARTIST)

**总计：16位，均为0次行动次数，创建3个巨作**

| 时代 | 名称 |
|------|------|
| 文艺复兴 | 安德烈·鲁布廖夫 (Andrey Rublev) |
| 文艺复兴 | 希罗尼穆斯·博斯 (Hieronymus Bosch) |
| 文艺复兴 | 多纳泰罗 (Donatello) |
| 文艺复兴 | 米开朗基罗 (Michelangelo) |
| 工业 | 仇英 (Qiu Ying) |
| 工业 | 提香 (Titian) |
| 工业 | 埃尔·格列柯 (El Greco) |
| 工业 | 伦勃朗·凡·莱因 (Rembrandt van Rijn) |
| 现代 | 索福尼斯巴·安圭索拉 (Sofonisba Anguissola) |
| 现代 | 安吉莉卡·考夫曼 (Angelica Kauffman) |
| 现代 | 张承业 (Jang Seung-Eop) |
| 现代 | 葛饰北斋 (Katsushika Hokusai) |
| 原子 | 文森特·梵高 (Vincent van Gogh) |
| 原子 | 埃德莫尼亚·刘易斯 (Edmonia Lewis) |
| 原子 | 玛丽-安·科洛 (Marie-Anne Collot) |
| 原子 | 克劳德·莫奈 (Claude Monet) |
| 信息 | 鲍里斯·奥尔洛夫斯基 (Boris Orlovsky) |
| 信息 | 古斯塔夫·克里姆特 (Gustav Klimt) |
| 信息 | 阿姆里塔·谢尔-吉尔 (Amrita Sher-Gil) |
| 信息 | 玛丽·卡萨特 (Mary Cassatt) |

---

### 2.9 大音乐家 (GREAT_PERSON_CLASS_MUSICIAN)

**总计：16位，均为0次行动次数，创建2个巨作**

| 时代 | 名称 |
|------|------|
| 工业 | 安东尼奥·维瓦尔第 (Antonio Vivaldi) |
| 工业 | 约翰·塞巴斯蒂安·巴赫 (Johann Sebastian Bach) |
| 工业 | 路德维希·凡·贝多芬 (Ludwig van Beethoven) |
| 工业 | 沃尔夫冈·阿马德乌斯·莫扎特 (Wolfgang Amadeus Mozart) |
| 工业 | 八桥检校 (Yatsuhashi Kengyo) |
| 现代 | 安东尼奥·卡洛斯·戈梅斯 (Antonio Carlos Gomez) |
| 现代 | 弗朗茨·李斯特 (Franz Liszt) |
| 现代 | 弗雷德里克·肖邦 (Frederic Chopin) |
| 现代 | 彼得·伊里奇·柴可夫斯基 (Peter Ilyich Tchaikovsky) |
| 现代 | 刘天华 (Liu Tianhua) |
| 原子 | 安东宁·德沃夏克 (Antonin Dvorak) |
| 原子 | 克拉拉·舒曼 (Clara Schumann) |
| 原子 | 胡文蒂诺·罗萨斯 (Juventino Rosas) |
| 原子 | 利留卡拉尼 (Liliuokalani) |
| 信息 | 高哈尔·贾恩 (Gauhar Jaan) |
| 信息 | 米科拉·列昂托维奇 (Mykola Leontovych) |

---

## 3. DLC新增伟人数据

### 3.1 迭起兴衰 (Expansion1) 新增

| 类型 | 名称 | 时代 | 次数 | 效果 |
|------|------|------|------|------|
| 海军统帅 | 希梅里奥斯 (Himerios) | 古典 | 1 | 授予1级晋升 |
| 大工程师 | 伊姆霍特普 (Imhotep) | 古典 | 1 | 建造远古城墙 + 175产能投入奇观 |
| 大将军 | 帖木儿 (Timur) | 中世纪 | 1 | 授予1级晋升 + 25%战斗经验 |
| 大商人 | 马辉 (Mahuio) | 古典 | 1 | 授予200金币 |

### 3.2 风云变幻 (Expansion2) 新增

| 类型 | 名称 | 时代 | 次数 | 效果 |
|------|------|------|------|------|
| 海军统帅 | 汉诺 (Hanno) | 古典 | 1 | 授予1级晋升 |
| 大将军 | 徵侧 (Trung Trac) | 古典 | 1 | 授予1级晋升 |
| 大商人 | 皮西亚斯 (Pytheas) | 古典 | 1 | 授予200金币 |

### 3.3 巴比伦 (Babylon) DLC

巴比伦DLC引入了英雄系统 (Heroes)，不属于传统伟人系统，不在本报告范围内。

---

## 4. MOD新增伟人数据

### 4.1 大统治者伟人 (GreatSovereigns) — MOD: 2973448849

**来源：** Platige 制作  
**新增类型：** GREAT_PERSON_CLASS_GreatSovereigns（大统治者）  
**关联区域：** 政府区 (Government District)  
**专属项目：** 政府区项目 (Project), 每回合提供1点大统治者点数

#### 大统治者个人列表（14位）

| 序号 | 内部ID | 名称 | 时代 | 次数 | 激活条件 | 效果 |
|------|--------|------|------|------|---------|------|
| 1 | PLATI_FIRST | 所罗门 (Solomon) | 古典 | 1 | 需圣地 | 建造神殿，神殿+2产能 |
| 2 | PLATI_SECOND | 马可·奥勒留 (Marcus Aurelius) | 古典 | 1 | 需政府区 | 尤里卡所有中世纪市政 |
| 3 | PLATI_THIRD | 托勒密 (Ptolemy) | 古典 | 1 | 需未完成奇观 | 100产能投入奇观 + 每使者+1文化 |
| 4 | PLATI_FOURTH | 阿育王 (Asoka) | 古典 | 1 | 需政府区 | 城市每专业区域+1信仰和+1粮食 |
| 5 | PLATI_FIFTH | 腓特烈二世 (Frederick II) | 中世纪 | 1 | 需政府区 | +1经济政策槽位 |
| 6 | PLATI_SIXTH | 穆罕默德·阿里帕夏 (Mehmet Ali) | 工业 | 1 | 需政府区 | 单位升级100%金币折扣 + 随机免费科技 |
| 7 | PLATI_SEVENTH | 查理曼 (Charlemagne) | 中世纪 | 1 | 需政府区 | +1军事政策槽位 |
| 8 | PLATI_EIGHTH | 哈伦·拉希德 (Harun al-Rashid) | 中世纪 | 1 | 需政府区 | 黄金时代期间贸易路线每6格+1科技值 |
| 9 | PLATI_NINTH | 阿斯基亚 (Askia) | 文艺复兴 | 1 | 无特殊条件 | 2倍掠夺收益，征服城市若有纪念碑授予Cowrie资源 |
| 10 | PLATI_TENTH | 阿克巴 (Akbar) | 文艺复兴 | 1 | 需政府区 | +1万能政策槽位 |
| 11 | PLATI_THIRTEENTH | 明治天皇 (Meiji) | 工业 | 1 | 无特殊条件 | 农场替代加成，+2食物相邻加成 |
| 12 | PLATI_FOURTEENTH | 凯末尔 (Ataturk) | 现代 | 3 | 需市中心 | 400产能 |
| 13 | PLATI_FIFTEENTH | 海尔·塞拉西 (Haile Selassie) | 现代 | 1 | 需政府区 | +2外交胜利点数 |
| 14 | PLATI_SOVEREIGN_LKY | 李光耀 (Lee Kuan Yew) | 原子 | 1 | 需政府区 | 多种加成效果 |

#### 大统治者重分类（Config_Enabled）

在启用配置下，以下原版大将军被重新分类为大统治者：

| 原名称 | 新分类 | 新效果 |
|--------|--------|--------|
| 拿破仑·波拿巴 (Napoleon Bonaparte) | 大统治者 | +1万能政策槽位 (Wildcard) |
| 古斯塔夫·阿道夫 (Gustavus Adolphus) | 大统治者 | +1军事政策槽位 (Military) |

---

### 4.2 更多伟人 (Sumus Magnus / More Great People) — MOD: 2448605286

**来源：** Platige 制作  
**说明：** 大规模MOD，为所有伟人类型新增大量伟人个体。Peepoles/目录下包含数十个独立的伟人XML文件。

**新增伟人列表（部分摘要）：**

| 类型 | 文件 | 新增伟人 |
|------|------|---------|
| 海军统帅 | Admiral_Medieval_Lodbrok.xml | 洛德布罗克 (中世纪) |
| 海军统帅 | Admiral_Renaissance_Barbarossa.xml | 巴巴罗萨 (文艺复兴) |
| 海军统帅 | Admiral_Renaissance_Cook.xml | 库克船长 (文艺复兴) |
| 海军统帅 | Admiral_Renaissance_Majid.xml | 马吉德 (文艺复兴) |
| 海军统帅 | Admiral_Renaissance_Morgan.xml | 摩根 (文艺复兴) |
| 海军统帅 | Admiral_Renaissance_Niels_Juel.xml | 尼尔斯·尤尔 (文艺复兴) |
| 海军统帅 | Admiral_Renaissance_Vitus.xml | 维图斯 (文艺复兴) |
| 海军统帅 | PLATI_Admiral_Agrippa.xml | 阿格里帕 (古典) |
| 海军统帅 | PLATI_Admiral_Henry.xml | 亨利 (中世纪) |
| 大将军 | General_Classical_Sargon.xml | 萨尔贡 (古典) |
| 大将军 | General_Industrial_Garibaldi.xml | 加里波第 (工业) |
| 大将军 | General_Medieval_Baibars.xml | 拜巴尔斯 (中世纪) |
| 大将军 | General_Medieval_Bayinnaung.xml | 莽应龙 (中世纪) |
| 大将军 | General_Medieval_Jan_Zizka.xml | 扬·杰式卡 (中世纪) |
| 大将军 | General_Medieval_Rurik.xml | 留里克 (中世纪) |
| 大将军 | General_Medieval_Sundiata_Keita.xml | 松迪亚塔·凯塔 (中世纪) |
| 大将军 | General_Medieval_Tokugawa.xml | 德川家康 (中世纪) |
| 大将军 | General_Renaissance_Sforza.xml | 斯福尔扎 (文艺复兴) |
| 大将军 | General_Renaissance_Suarez.xml | 苏亚雷斯 (文艺复兴) |
| 大将军 | PLATI_General_Lawrence.xml | 劳伦斯 (现代) |
| 大将军 | PLATI_General_Lionheart.xml | 狮心王 (中世纪) |
| 大将军 | PLATI_General_Rex.xml | 雷克斯 |
| 大将军 | PLATI_X_General_Gajah.xml | 加查·马达 |
| 大将军 | PLATI_X_General_Ungern.xml | 温琴 |
| 大工程师 | Engineer_Industrial_Isambard.xml | 伊桑巴德 (工业) |
| 大工程师 | Engineer_Industrial_Krupp.xml | 克虏伯 (工业) |
| 大工程师 | Engineer_Medieval_Al_Ahrami.xml | 阿赫拉米 (中世纪) |
| 大工程师 | Engineer_Renaissance_Elizabeth_Wilbraham.xml | 伊丽莎白·威尔布拉汉 (文艺复兴) |
| 大工程师 | Engineer_Renaissance_Erik_Dahlberg.xml | 埃里克·达尔伯格 (文艺复兴) |
| 大工程师 | PLATI_Engineer_Urban.xml | 乌尔班 (文艺复兴) |
| 大工程师 | Z_Engineer_Apollo.xml | 阿波罗 (信息) |
| 大商人 | Merchant_Colbert.xml | 柯尔贝尔 |
| 大商人 | Merchant_Hamilton.xml | 汉密尔顿 |
| 大商人 | Merchant_Ibn_Battuta.xml | 伊本·白图泰 |
| 大商人 | Merchant_Jacob_Kettler.xml | 雅各布·克特勒 |
| 大商人 | PLATI_Merchant_Afanasiy.xml | 阿法纳西 |
| 大商人 | PLATI_Merchant_Banker.xml | 银行家 |
| 大商人 | PLATI_Merchant_Cecil.xml | 塞西尔 |
| 大商人 | PLATI_Merchant_Nestle.xml | 雀巢 |
| 大商人 | PLATI_Merchant_Raillord.xml | 铁路大亨 |
| 大商人 | PLATI_X_Merchant_Faberge.xml | 法贝热 |
| 大商人 | A_Merchant_Venetian.xml | 威尼斯商人 |
| 大科学家 | Scientist_Classic_Cai_Lun.xml | 蔡伦 (古典) |
| 大科学家 | Scientist_Industrial_Zeppelin.xml | 齐柏林 (工业) |
| 大科学家 | Scientist_Medieval_Averroes.xml | 阿威罗伊 (中世纪) |
| 大科学家 | Scientist_Medieval_Saint_Augustine.xml | 圣奥古斯丁 (中世纪) |
| 大科学家 | Scientist_Medieval_Shen_Kuo.xml | 沈括 (中世纪) |
| 大科学家 | Scientist_Modern_Curie.xml | 居里夫人 (现代) |
| 大科学家 | Scientist_Renaissance_Erasmus.xml | 伊拉斯谟 (文艺复兴) |
| 大科学家 | PLATI_X_Scientist_Faraday.xml | 法拉第 |
| 大科学家 | PLATI_X_Scientist_Franklin.xml | 富兰克林 |
| 大科学家 | PLATI_X_Scientist_Leibnitz.xml | 莱布尼茨 |
| 大科学家 | PLATI_X_Scientist_Leizu.xml | 嫘祖 |
| 大科学家 | PLATI_X_Scientist_Pasteur.xml | 巴斯德 |
| 大科学家 | PLATI_X_Scientist_Sakharov.xml | 萨哈罗夫 |
| 大科学家 | PLATI_X_Scientist_Tusi.xml | 图西 |
| 大作家 | Writer_Hobbes.xml | 霍布斯 |
| 大作家 | Writer_NEW.xml | 多位新作家 |
| 大作家 | Writer_Nietzsche.xml | 尼采 |
| 大艺术家 | Painters_All.xml | 多位新画家 |
| 大艺术家 | Z_Artist_Phidias.xml | 菲迪亚斯 |
| 其他 | Z_Visionaries_of_peace.xml | 和平愿景家 |
| 其他 | ClassicalEra_People.xml | 多位古典时代伟人 |
| 其他 | A_CITI_STATE_AFANASIY.xml | 城邦相关伟人 |

此MOD内容极为丰富，具体每位伟人的效果请参考各独立XML文件中的Modifier定义。

---

### 4.3 远古伟人 (Ancient Great People) — MOD: 3085812151

**来源：** 6T 制作  
**说明：** 为所有伟人类型添加远古时代伟人，使用SQL格式定义。

包含以下文件：
- `6T_AGP_Admiral.sql` — 远古海军统帅
- `6T_AGP_Engineer.sql` — 远古大工程师
- `6T_AGP_General.sql` — 远古大将军
- `6T_AGP_Merchant.sql` — 远古大商人
- `6T_AGP_Prophet.sql` — 远古大预言家
- `6T_AGP_Scientist.sql` — 远古大科学家
- `6T_AGP_Writer.sql` — 远古大作家
- `6T_AGP_Unit_Abilities.sql` — 远古伟人单位能力
- `6T_AGP_XP1.sql` — 迭起兴衰兼容

---

## 5. 伟人能力效果总结

### 5.1 即时效果类型

| 效果类型 | 说明 | 典型伟人 |
|---------|------|---------|
| 免费创建单位 | 立即在伟人位置创建指定单位 | 埃塞尔弗莱德(骑士)、萨莫里·杜尔(步兵) |
| 编组升级 | 将单位编组为军团/军队 | 熙德(军团)、拿破仑(军队) |
| 授予晋升 | 为目标单位授予1级晋升 | 汉尼拔、阿尔特米西亚 |
| 经验加成 | 为目标单位增加战斗经验获取率 | 成吉思汗(+25%)、苏迪曼(+100%) |
| 侧翼加成 | 为所有单位增加侧翼加成能力 | 朱可夫(陆地)、纳尔逊(海军) |
| 转化蛮族 | 将相邻蛮族单位转化为己方 | 布狄卡 |
| 吞并地块 | 将无主地块吞并为己方领土 | 克拉苏 |
| 授予使者 | 增加城邦使者 | 安娜·恩津加(1)、西蒙·玻利瓦尔(2) |
| 授予金币 | 一次性获得金币 | 郑氏(100)、洛克菲勒(500) |
| 授予信仰 | 一次性获得信仰 | 科莱乌斯(60)、希尔德加德(100) |
| 科技尤里卡 | 授予随机或指定科技尤里卡 | 多位科学家 |
| 市政灵感 | 授予随机市政灵感 | 海亚姆 |
| 产能投入 | 向奇观或太空项目投入产能 | 伊西多尔(215)、科罗廖夫(1500)、萨根(3000) |
| 建造建筑 | 免费建造指定建筑 | 詹姆斯·瓦特(工坊+工厂) |
| 建筑加成 | 永久提升建筑产出 | 牛顿(大学+2科技)、爱因斯坦(实验室+4科技) |
| 授予资源 | 免费获得奢侈品/战略资源 | 洛克菲勒(石油)、施特劳斯(牛仔裤) |
| 政策槽位 | 增加政府政策槽位 | 亚当·斯密(经济)、阿克巴(万能) |
| 贸易路线 | 增加贸易路线容量 | 张骞(+1)、马可·波罗(+1) |
| 区域容量 | 增加城市区域容量 | 毕昇(+1)、洛夫莱斯(+1) |
| 住房/宜居度 | 增加城市住房和宜居度 | 锡南(+1/+1)、德鲁(+4/+3) |
| 吸引力 | 增加城市吸引力 | 阿尔托(+1)、科雷亚(+2) |
| 区域建筑范围 | 增加区域建筑效果范围 | 特斯拉(+3) |
| 太空竞赛 | 增加太空竞赛项目产能 | 戈达德(+20%)、布劳恩(+100%) |
| 旅游业绩 | 增加贸易/区域旅游业绩 | 布里德洛夫(+25%)、塔塔(学院) |
| 外交能见度 | 增加外交能见度等级 | 戈达德(+1) |
| 厌战减少 | 减少厌战情绪 | 里斯本(-25%) |
| 圣物 | 创建圣物 | 圣女贞德 |
| 跨洋 | 海军单位可进入大洋 | 莱夫·埃里克森 |

### 5.2 光环效果（适用于所有大将军/海军统帅）

所有大将军和海军统帅在获得时自动提供光环效果：
- **大将军光环：** 范围内同代陆地单位获得 +5 战斗力 +1 移动力
- **海军统帅光环：** 范围内同代海军单位获得 +5 战斗力 +1 移动力

---

## 6. 加载顺序与覆盖分析

### 6.1 加载顺序（按modinfo文件中的优先级）

MOD加载顺序通常按modinfo中的 `<LoadOrder>` 或按文件字母顺序。在伟人MOD中：

1. **原版游戏数据** — 最先加载
2. **DLC数据** (Expansion1, Expansion2, Babylon) — 在原版之上加载
3. **伟人MOD:**
   - 2973448849 大统治者伟人 — 创建新类型和伟人
   - 2448605286 更多伟人 (Sumus Magnus) — 为所有类型添加伟人
   - 3085812151 远古伟人 — 添加远古时代伟人
   - 3334907290 删除部分工程师 — 删除特定大工程师
   - 3310259652 大统治者伟人汉化 — 中文翻译
   - 3338128748 更多伟人汉化 — 中文翻译

### 6.2 覆盖关系

| 被覆盖项 | 覆盖者 | 说明 |
|---------|--------|------|
| 拿破仑·波拿巴 (大将军) | 大统治者伟人 Config_Enabled | 重分类为大统治者，效果改为+1万能槽位 |
| 古斯塔夫·阿道夫 (大将军) | 大统治者伟人 Config_Enabled | 重分类为大统治者，效果改为+1军事槽位 |
| 5位大工程师 | 删除部分工程师 MOD | 从游戏中移除 |

### 6.3 潜在冲突

- **大统治者伟人** 与 **更多伟人 (Sumus Magnus)** 均由Platige制作，使用了不同的前缀（GreatSovereigns vs PLATI），不太可能冲突
- **远古伟人** 使用SQL插入，可能与其他MOD的伟人ID冲突需注意
- **删除部分工程师** 使用SQL DELETE语句，会删除对应的大工程师，确保在需要这些工程师的MOD之前加载

---

## 7. MOD删除的伟人

**删除部分工程师 MOD (3334907290) 删除以下5位大工程师：**

| 序号 | 内部ID | 名称 | 时代 |
|------|--------|------|------|
| 1 | GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 (Bi Sheng) | 中世纪 |
| 2 | GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 圣乔治的詹姆斯 (James of St. George) | 中世纪 |
| 3 | GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 (Isidore of Miletus) | 中世纪 |
| 4 | GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 (John A. Roebling) | 原子 |
| 5 | GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 (Alvar Aalto) | 现代 |

---

## 8. 数据统计

### 8.1 原始游戏伟人数量统计

| 伟人类型 | 古典 | 中世纪 | 文艺复兴 | 工业 | 现代 | 原子 | 信息 | 合计 |
|---------|------|--------|---------|------|------|------|------|------|
| 大将军 | 3 | 3 | 3 | 3 | 3 | 4 | 2 | 21 |
| 海军统帅 | 3 | 3 | 3 | 3 | 3 | 3 | 1 | 19 |
| 大工程师 | 0 | 3 | 3 | 3 | 3 | 3 | 3 | 18 |
| 大商人 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 21 |
| 大预言家 | 6 | 5 | 5 | 0 | 0 | 0 | 0 | 16 |
| 大科学家 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 21 |
| 大作家 | 4 | 3 | 5 | 5 | 5 | 2 | 1 | 25 |
| 大艺术家 | 0 | 0 | 4 | 4 | 4 | 4 | 4 | 20 |
| 大音乐家 | 0 | 0 | 0 | 5 | 5 | 4 | 2 | 16 |
| **合计** | **22** | **23** | **29** | **29** | **29** | **27** | **19** | **177** |

### 8.2 DLC新增伟人统计

| DLC | 大将军 | 海军统帅 | 大工程师 | 大商人 | 合计 |
|-----|--------|---------|---------|--------|------|
| 迭起兴衰 (Expansion1) | 1 | 1 | 1 | 1 | 4 |
| 风云变幻 (Expansion2) | 1 | 1 | 0 | 1 | 3 |
| **合计** | **2** | **2** | **1** | **2** | **7** |

### 8.3 MOD新增/修改统计

| MOD | 类型 | 数量 |
|-----|------|------|
| 大统治者伟人 | 新增类型 | 1个新类型 |
| 大统治者伟人 | 新增伟人 | 14位 + 2位重分类 |
| 更多伟人 (Sumus Magnus) | 新增伟人 | 约50+位（所有类型） |
| 远古伟人 | 新增伟人 | 约8+位（远古时代） |
| 删除部分工程师 | 删除伟人 | -5位大工程师 |

### 8.4 总计（含所有MOD）

| 项目 | 数量 |
|------|------|
| 伟人类型总数 | 10种（原版9种 + MOD 1种） |
| 原版伟人总数 | 177位 |
| DLC新增伟人 | 7位 |
| MOD新增伟人 | 约70+位 |
| MOD删除伟人 | 5位 |
| **最终可用伟人** | **约250+位** |

---

> **报告结束**  
> 本报告基于 /workspace 目录下的原始游戏数据、DLC数据和MOD数据生成。  
> 数据源包括：原版XML、DLC XML、MOD XML/SQL文件。