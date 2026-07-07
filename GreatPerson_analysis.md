# Civilization VI 伟人 (GreatPerson) 完整分析报告

> 生成时间: 2026-07-07

> 数据来源: 原版 / DLC(迭起兴衰/风云变幻) / 6个伟人Mod

> 总条目数: 352 (原版186 + DLC 62 + Mod 104)

---

## 1. 总览

| 来源 | 原版保留 | 新增 | 修改 | 被删除 |
|------|:-------:|:----:|:----:|:------:|
| 原版 | 167 | 0 | 0 | 19 |
| DLC(迭起兴衰) | 24 | 0 | 0 | 0 |
| DLC(风云变幻) | 38 | 0 | 0 | 0 |
| 远古伟人 (6T) | 0 | 14 | 0 | 0 |
| 更多伟人 (Sumus Magnus) | 0 | 72 | 0 | 18 |
| 大统治者伟人 (GreatSovereigns) | 0 | 32 | 2 | 0 |
| 删除部分工程师 | 0 | 0 | 0 | 5 |
| 更多伟人汉化 | 0 | 0 | 70 | 0 |
| 大统治者伟人汉化 | 0 | 0 | 29 | 0 |
| **合计** | **229** | **118** | **101** | **42** |

## 2. 加载顺序分析

Load order: 原版 < DLC < 远古伟人(LoadOrder 13-14) < 更多伟人(LoadOrder 240-250) < 大统治者伟人(LoadOrder 240-250, 808阿尔罕布拉) < 删除部分工程师(默认) < 伟人传送(默认) < 汉化文本(1919/11000)

Cross-mod dependencies:

- 大统治者伟人汉化 依赖 大统治者伟人
- 更多伟人汉化 依赖 更多伟人
- 更多伟人 通过 ActionCriteria 检测 远古伟人、More Maritime、Urban Complexity 等
- 大统治者伟人 通过 ActionCriteria 检测 6T 合集、Monopoly++、Burj Khalifa 等

## 3. 详细数据表

### 3.1 大艺术家 (GREAT_PERSON_CLASS_ARTIST) — 23人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 卡迈勒·乌德丁·贝赫扎德 | Kamal Ud Din Behzad | GREAT_PERSON_INDIVIDUAL_KAMAL_UD_DIN_BEHZAD | 文艺复兴 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 2 | 多纳泰罗 | Donatello | GREAT_PERSON_INDIVIDUAL_DONATELLO | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 3 | 安德烈·鲁布廖夫 | Andrey Rublev | GREAT_PERSON_INDIVIDUAL_ANDREY_RUBLEV | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 4 | 希罗尼穆斯·博斯 | Hieronymus Bosch | GREAT_PERSON_INDIVIDUAL_HIERONYMUS_BOSCH | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 5 | 米开朗基罗 | Michelangelo | GREAT_PERSON_INDIVIDUAL_MICHELANGELO | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 6 | 仇英 | Qiu Ying | GREAT_PERSON_INDIVIDUAL_QIU_YING | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 7 | 伦勃朗·凡·莱因 | Rembrandt Van Rijn | GREAT_PERSON_INDIVIDUAL_REMBRANDT_VAN_RIJN | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 8 | 埃尔·格列柯 | El Greco | GREAT_PERSON_INDIVIDUAL_EL_GRECO | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 9 | 提香 | Titian | GREAT_PERSON_INDIVIDUAL_TITIAN | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 10 | 长谷川等伯 | Hasegawa Tohaku | GREAT_PERSON_INDIVIDUAL_HASEGAWA_TOHAKU | 工业 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 11 | 安吉丽卡·考夫曼 | Angelica Kauffman | GREAT_PERSON_INDIVIDUAL_ANGELICA_KAUFFMAN | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 12 | 张承业 | Jang Seung Eop | GREAT_PERSON_INDIVIDUAL_JANG_SEUNG_EOP | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 13 | 索福尼斯巴·安圭索拉 | Sofonisba Anguissola | GREAT_PERSON_INDIVIDUAL_SOFONISBA_ANGUISSOLA | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 14 | 葛饰北斋 | Katsushika Hokusai | GREAT_PERSON_INDIVIDUAL_KATSUSHIKA_HOKUSAI | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 15 | 克劳德·莫奈 | Claude Monet | GREAT_PERSON_INDIVIDUAL_CLAUDE_MONET | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 16 | 埃德蒙尼亚·刘易斯 | Edmonia Lewis | GREAT_PERSON_INDIVIDUAL_EDMONIA_LEWIS | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 17 | 文森特·梵高 | Vincent Van Gogh | GREAT_PERSON_INDIVIDUAL_VINCENT_VAN_GOGH | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 18 | 玛丽-安妮·科洛 | Marie Anne Collot | GREAT_PERSON_INDIVIDUAL_MARIE_ANNE_COLLOT | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 19 | 古斯塔夫·克里姆特 | Gustav Klimt | GREAT_PERSON_INDIVIDUAL_GUSTAV_KLIMT | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |
| 20 | 玛丽·卡萨特 | Mary Cassatt | GREAT_PERSON_INDIVIDUAL_MARY_CASSATT | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |
| 21 | 瓦西里·康定斯基 | Wassily Kandinsky | GREAT_PERSON_INDIVIDUAL_WASSILY_KANDINSKY | 信息 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 22 | 阿姆丽塔·谢尔-吉尔 | Amrita Sher Gil | GREAT_PERSON_INDIVIDUAL_AMRITA_SHER_GIL | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |
| 23 | 鲍里斯·奥尔洛夫斯基 | Boris Orlovsky | GREAT_PERSON_INDIVIDUAL_BORIS_ORLOVSKY | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |

### 3.2 大作家 (GREAT_PERSON_CLASS_WRITER) — 39人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 奥维德 | Ovid | GREAT_PERSON_INDIVIDUAL_OVID | 古典 | 0 | 创作巨作 | — | 原版 | ✓ |
| 2 | 屈原 | Qu Yuan | GREAT_PERSON_INDIVIDUAL_QU_YUAN | 古典 | 2 | 创作巨作 | — | 原版 | ✓ |
| 3 | 荷马 | Homer | GREAT_PERSON_INDIVIDUAL_HOMER | 古典 | 0 | 创作巨作 | — | 原版 | ✓ |
| 4 | 蚁垤 | Valmiki | GREAT_PERSON_INDIVIDUAL_VALMIKI | 古典 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 5 | 跋娑 | Bhasa | GREAT_PERSON_INDIVIDUAL_BHASA | 古典 | 0 | 创作巨作 | — | 原版 | ✓ |
| 6 | 霍布斯 | Plati Hobbes | GREAT_PERSON_INDIVIDUAL_PLATI_HOBBES | 古典 | 0 | 创作巨作《利维坦》 | — | 更多伟人 | ✓ |
| 7 | 乔弗里·乔叟 | Geoffrey Chaucer | GREAT_PERSON_INDIVIDUAL_GEOFFREY_CHAUCER | 中世纪 | 0 | 创作巨作 | — | 原版 | ✓ |
| 8 | 李白 | Li Bai | GREAT_PERSON_INDIVIDUAL_LI_BAI | 中世纪 | 0 | 创作巨作 | — | 原版 | ✓ |
| 9 | 紫式部 | Murasaki Shikibu | GREAT_PERSON_INDIVIDUAL_MURASAKI_SHIKIBU | 中世纪 | 0 | 创作巨作 | — | 原版 | ✓ |
| 10 | 鲁米 | Rumi | GREAT_PERSON_INDIVIDUAL_RUMI | 中世纪 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 11 | 威廉·莎士比亚 | William Shakespeare | GREAT_PERSON_INDIVIDUAL_WILLIAM_SHAKESPEARE | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 12 | 嫘祖 | Plati Leizu | GREAT_PERSON_INDIVIDUAL_PLATI_LEIZU | 文艺复兴 | 1 | +1丝绸资源 | — | 更多伟人 | ✓ |
| 13 | 尼科洛·马基雅维利 | Niccolo Machiavelli | GREAT_PERSON_INDIVIDUAL_NICCOLO_MACHIAVELLI | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 14 | 玛丽-凯瑟琳·德·奥尔努瓦 | Marie Catherine D Aulnoy | GREAT_PERSON_INDIVIDUAL_MARIE_CATHERINE_D_AULNOY | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 15 | 玛格丽特·卡文迪什 | Margaret Cavendish | GREAT_PERSON_INDIVIDUAL_MARGARET_CAVENDISH | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 16 | 米格尔·德·塞万提斯 | Miguel De Cervantes | GREAT_PERSON_INDIVIDUAL_MIGUEL_DE_CERVANTES | 文艺复兴 | 0 | 创作巨作 | — | 原版 | ✓ |
| 17 | 亚历山大·普希金 | Alexander Pushkin | GREAT_PERSON_INDIVIDUAL_ALEXANDER_PUSHKIN | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 18 | 埃德加·爱伦·坡 | Edgar Allen Poe | GREAT_PERSON_INDIVIDUAL_EDGAR_ALLEN_POE | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 19 | 尼采 | Plati Nietzsche | GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE | 工业 | 0 | 创作巨作《查拉图斯特拉如是说》 | — | 更多伟人 | ✓ |
| 20 | 玛丽·雪莱 | Mary Shelley | GREAT_PERSON_INDIVIDUAL_MARY_SHELLEY | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 21 | 简·奥斯汀 | Jane Austen | GREAT_PERSON_INDIVIDUAL_JANE_AUSTEN | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 22 | 约翰·沃尔夫冈·冯·歌德 | Johann Wolfgang Von Goethe | GREAT_PERSON_INDIVIDUAL_JOHANN_WOLFGANG_VON_GOETHE | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 23 | 莱布尼茨 | Plati Leibnitz | GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNITZ | 工业 | 1 | 所有城市+1科技+1文化 | — | 更多伟人 | ✓ |
| 24 | 莱洛尔 | Plati Raillord | GREAT_PERSON_INDIVIDUAL_PLATI_RAILLORD | 工业 | 1 | 铁路+2金币 | — | 更多伟人 | ✓ |
| 25 | F·斯科特·菲茨杰拉德 | F Scott Fitzgerald | GREAT_PERSON_INDIVIDUAL_F_SCOTT_FITZGERALD | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 26 | 列夫·托尔斯泰 | Leo Tolstoy | GREAT_PERSON_INDIVIDUAL_LEO_TOLSTOY | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 27 | 比阿特丽克斯·波特 | Beatrix Potter | GREAT_PERSON_INDIVIDUAL_BEATRIX_POTTER | 现代 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 28 | 洛夫克拉夫特 | Plati Lovecraft | GREAT_PERSON_INDIVIDUAL_PLATI_LOVECRAFT | 现代 | 0 | 创作巨作《克苏鲁的呼唤》 | — | 更多伟人 | ✓ |
| 29 | 海德格尔 | Plati Heidegger | GREAT_PERSON_INDIVIDUAL_PLATI_HEIDEGGER | 现代 | 0 | 创作巨作《存在与时间》 | — | 更多伟人 | ✓ |
| 30 | 罗伯特·霍华德 | Plati Rhoward | GREAT_PERSON_INDIVIDUAL_PLATI_RHOWARD | 现代 | 0 | 创作巨作《蛮王柯南》 | — | 更多伟人 | ✓ |
| 31 | 艾米莉·狄金森 | Emily Dickinson | GREAT_PERSON_INDIVIDUAL_EMILY_DICKINSON | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 32 | 詹姆斯·乔伊斯 | James Joyce | GREAT_PERSON_INDIVIDUAL_JAMES_JOYCE | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 33 | 马克·吐温 | Mark Twain | GREAT_PERSON_INDIVIDUAL_MARK_TWAIN | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 34 | H·G·威尔斯 | Hg Wells | GREAT_PERSON_INDIVIDUAL_HG_WELLS | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 35 | 拉宾德拉纳特·泰戈尔 | Rabindranath Tagore | GREAT_PERSON_INDIVIDUAL_RABINDRANATH_TAGORE | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 36 | 笛卡尔 | Plati Descartes | GREAT_PERSON_INDIVIDUAL_PLATI_DESCARTES | 原子 | 1 | 所有城市+1宜居度 | — | 更多伟人 | ✓ |
| 37 | 西塞罗 | Plati Cicero | GREAT_PERSON_INDIVIDUAL_PLATI_CICERO | 原子 | 1 | 所有城市+1宜居度 | — | 更多伟人 | ✓ |
| 38 | 加夫列拉·米斯特拉尔 | Gabriela Mistral | GREAT_PERSON_INDIVIDUAL_GABRIELA_MISTRAL | 信息 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 39 | 卡雷尔·恰佩克 | Karel Capek | GREAT_PERSON_INDIVIDUAL_KAREL_CAPEK | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |

### 3.3 大音乐家 (GREAT_PERSON_CLASS_MUSICIAN) — 18人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 八桥检校 | Yatsuhashi Kengyo | GREAT_PERSON_INDIVIDUAL_YATSUHASHI_KENGYO | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 2 | 安东尼奥·维瓦尔第 | Antonio Vivaldi | GREAT_PERSON_INDIVIDUAL_ANTONIO_VIVALDI | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 3 | 沃尔夫冈·阿马德乌斯·莫扎特 | Wolfgang Amadeus Mozart | GREAT_PERSON_INDIVIDUAL_WOLFGANG_AMADEUS_MOZART | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 4 | 约翰·塞巴斯蒂安·巴赫 | Johann Sebastian Bach | GREAT_PERSON_INDIVIDUAL_JOHANN_SEBASTIAN_BACH | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 5 | 路德维希·凡·贝多芬 | Ludwig Van Beethoven | GREAT_PERSON_INDIVIDUAL_LUDWIG_VAN_BEETHOVEN | 工业 | 0 | 创作巨作 | — | 原版 | ✓ |
| 6 | 迪米特里耶·坎泰米尔 | Dimitrie Cantemir | GREAT_PERSON_INDIVIDUAL_DIMITRIE_CANTEMIR | 工业 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 7 | 刘天华 | Liu Tianhua | GREAT_PERSON_INDIVIDUAL_LIU_TIANHUA | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 8 | 安东尼奥·卡洛斯·戈麦斯 | Antonio Carlos Gomez | GREAT_PERSON_INDIVIDUAL_ANTONIO_CARLOS_GOMEZ | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 9 | 弗朗茨·李斯特 | Franz Liszt | GREAT_PERSON_INDIVIDUAL_FRANZ_LISZT | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 10 | 弗雷德里克·肖邦 | Frederic Chopin | GREAT_PERSON_INDIVIDUAL_FREDERIC_CHOPIN | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 11 | 彼得·伊里奇·柴可夫斯基 | Peter Ilyich Tchaikovsky | GREAT_PERSON_INDIVIDUAL_PETER_ILYICH_TCHAIKOVSKY | 现代 | 0 | 创作巨作 | — | 原版 | ✓ |
| 12 | 斯科特·乔普林 | Scott Joplin | GREAT_PERSON_INDIVIDUAL_SCOTT_JOPLIN | 现代 | 0 | 创作巨作 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 13 | 克拉拉·舒曼 | Clara Schumann | GREAT_PERSON_INDIVIDUAL_CLARA_SCHUMANN | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 14 | 利留卡拉尼 | Liliuokalani | GREAT_PERSON_INDIVIDUAL_LILIUOKALANI | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 15 | 安东宁·德沃夏克 | Antonin Dvorak | GREAT_PERSON_INDIVIDUAL_ANTONIN_DVORAK | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 16 | 胡文蒂诺·罗萨斯 | Juventino Rosas | GREAT_PERSON_INDIVIDUAL_JUVENTINO_ROSAS | 原子 | 0 | 创作巨作 | — | 原版 | ✓ |
| 17 | 米科拉·莱昂托维奇 | Mykola Leontovych | GREAT_PERSON_INDIVIDUAL_MYKOLA_LEONTOVYCH | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |
| 18 | 高哈尔·贾恩 | Gauhar Jaan | GREAT_PERSON_INDIVIDUAL_GAUHAR_JAAN | 信息 | 0 | 创作巨作 | — | 原版 | ✓ |

### 3.4 大工程师 (GREAT_PERSON_CLASS_ENGINEER) — 28人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 阿波罗多洛斯 | Plati Apollodro | GREAT_PERSON_INDIVIDUAL_PLATI_APOLLODRO | 古典 | 1 | 政府区+1政策槽 | — | 更多伟人 | ✓ |
| 2 | 阿里·马沙迪 | Plati Ali Mashaddi | GREAT_PERSON_INDIVIDUAL_PLATI_ALI_MASHADDI | 古典 | 1 | 市中心+1文化 | — | 更多伟人 | ✓ |
| 3 | 齐柏林 | Plati Zeppelin | GREAT_PERSON_INDIVIDUAL_PLATI_ZEPPELIN | 古典 | 1 | 机场+2产能 | — | 更多伟人 | ✓ |
| 4 | 印何阗 | Imhotep | GREAT_PERSON_INDIVIDUAL_IMHOTEP | 中世纪 | 2 | 为建造中的奇观提供175锤(2次充能) | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 5 | 阿尔·阿赫马尔 | Plati Al Ahmar | GREAT_PERSON_INDIVIDUAL_PLATI_AL_AHMAR | 中世纪 | 1 | 城市+1宜居度+1住房 | — | 更多伟人 | ✓ |
| 6 | 乌尔班 | Plati Urban | GREAT_PERSON_INDIVIDUAL_PLATI_URBAN | 文艺复兴 | 1 | +2使者 | — | 更多伟人 | ✓ |
| 7 | 列奥纳多·达·芬奇 | Leonardo Da Vinci | GREAT_PERSON_INDIVIDUAL_LEONARDO_DA_VINCI | 文艺复兴 | 1 | 工坊+1文化，该效果触发尤里卡 | — | 原版 | ✓ |
| 8 | 圩田 | Plati Polder | GREAT_PERSON_INDIVIDUAL_PLATI_POLDER | 文艺复兴 | 1 | 提高圩田改良设施+1食物+1产能 | — | 更多伟人 | ✓ |
| 9 | 城堡 | Plati Chateau | GREAT_PERSON_INDIVIDUAL_PLATI_CHATEAU | 文艺复兴 | 1 | 提高城堡改良设施+1文化+1金币 | — | 更多伟人 | ✓ |
| 10 | 米马尔·希南 | Mimar Sinan | GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN | 文艺复兴 | 2 | 城市+1宜居度+1住房(2次充能) | — | 原版 | ✓ |
| 11 | 菲利波·布鲁内莱斯基 | Filippo Brunelleschi | GREAT_PERSON_INDIVIDUAL_FILIPPO_BRUNELLESCHI | 文艺复兴 | 2 | 为建造中的奇观提供315锤(2次充能) | — | 原版 | ✓ |
| 12 | 达尔伯格 | Plati Dahlberg | GREAT_PERSON_INDIVIDUAL_PLATI_DAHLBERG | 文艺复兴 | 1 | 城市+1宜居度+1住房 | — | 更多伟人 | ✓ |
| 13 | 伊桑巴德 | Plati Isambard | GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD | 工业 | 1 | 城市+2住房+2宜居度 | — | 更多伟人 | ✓ |
| 14 | 克虏伯 | Plati Krupp | GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP | 工业 | 1 | 工业区+5产能 | — | 更多伟人 | ✓ |
| 15 | 古斯塔夫·埃菲尔 | Gustave Eiffel | GREAT_PERSON_INDIVIDUAL_GUSTAVE_EIFFEL | 工业 | 2 | 为建造中的奇观提供480锤(2次充能) | — | 原版 | ✓ |
| 16 | 居里夫人 | Plati Curie | GREAT_PERSON_INDIVIDUAL_PLATI_CURIE | 工业 | 2 | 为建造中的奇观提供产能(2次充能) | — | 更多伟人 | ✓ |
| 17 | 艾达·洛芙莱斯 | Ada Lovelace | GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE | 工业 | 1 | 免费获得1个随机科技 | — | 原版 | ✓ |
| 18 | 詹姆斯·瓦特 | James Watt | GREAT_PERSON_INDIVIDUAL_JAMES_WATT | 工业 | 1 | 立即建造工厂和工坊，工厂+2产能 | — | 原版 | ✓ |
| 19 | 伊丽莎白·威尔布拉汉 | Plati Elizabeth Wilbraham | GREAT_PERSON_INDIVIDUAL_PLATI_ELIZABETH_WILBRAHAM | 现代 | 1 | 航空港+3产能 | — | 更多伟人 | ✓ |
| 20 | 尼古拉·特斯拉 | Nikola Tesla | GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA | 现代 | 1 | 区域内建筑影响力延伸至6格内所有城市 | — | 原版 | ✓ |
| 21 | 沙贾汗 | Shah Jahan | GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN | 现代 | 1 | 为建造中的奇观提供产能(1次充能，按当前时代) | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 22 | 罗伯特·戈达德 | Robert Goddard | GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD | 现代 | 1 | 太空竞赛项目+20%产能 | — | 原版 | ✓ |
| 23 | 简·德鲁 | Jane Drew | GREAT_PERSON_INDIVIDUAL_JANE_DREW | 原子 | 1 | 城市+4住房+3宜居度 | — | 原版 | ✓ |
| 24 | 谢尔盖·科罗廖夫 | Sergei Korolev | GREAT_PERSON_INDIVIDUAL_SERGEI_KOROLEV | 原子 | 1 | 为太空竞赛项目提供1500产能 | — | 原版 | ✓ |
| 25 | 丹下健三 | Kenzo Tange | GREAT_PERSON_INDIVIDUAL_KENZO_TANGE | 信息 | 1 | 城市每个区域+1科技+1文化+1金币+1信仰 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 26 | 查尔斯·科雷亚 | Charles Correa | GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | 信息 | 1 | 城市获得2格文化范围 | — | 原版 | ✓ |
| 27 | 沃纳·冯·布劳恩 | Wernher Von Braun | GREAT_PERSON_INDIVIDUAL_WERNHER_VON_BRAUN | 信息 | 1 | 太空竞赛项目+100%产能 | — | 原版 | ✓ |
| 28 | 约瑟夫·帕克斯顿 | Joseph Paxton | GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON | 信息 | 1 | 区域+1宜居度 | — | 原版 | ✓ |

### 3.5 大科学家 (GREAT_PERSON_CLASS_SCIENTIST) — 34人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 亚里士多德 | Plati Aristotle | GREAT_PERSON_INDIVIDUAL_PLATI_ARISTOTLE | 古典 | 1 | +1万能政策槽 | — | 更多伟人 | ✓ |
| 2 | 希帕蒂娅 | Hypatia | GREAT_PERSON_INDIVIDUAL_HYPATIA | 古典 | 1 | 图书馆+1科技，建造图书馆不消耗金币 | — | 原版 | ✓ |
| 3 | 张衡 | Zhang Heng | GREAT_PERSON_INDIVIDUAL_ZHANG_HENG | 古典 | 1 | 随机触发2项科技尤里卡 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 4 | 欧几里得 | Euclid | GREAT_PERSON_INDIVIDUAL_EUCLID | 古典 | 1 | 随机触发1项科技尤里卡并额外获得1个随机科技尤里卡 | — | 原版 | ✓ |
| 5 | 蔡伦 | Plati Cai Lun | GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN | 古典 | 1 | +1造纸坊建筑(纸张) | — | 更多伟人 | ✓ |
| 6 | 阿耶波多 | Aryabhata | GREAT_PERSON_INDIVIDUAL_ARYABHATA | 古典 | 1 | 随机触发3项科技尤里卡 | — | 原版 | ✓ |
| 7 | 圣奥古斯丁 | Plati Saugustine | GREAT_PERSON_INDIVIDUAL_PLATI_SAUGUSTINE | 中世纪 | 1 | 所有宗教单位+1传播次数 | — | 更多伟人 | ✓ |
| 8 | 宾根的希尔德加德 | Hildegard Of Bingen | GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN | 中世纪 | 1 | 圣地+20信仰 | — | 原版 | ✓ |
| 9 | 欧玛尔·海亚姆 | Omar Khayyam | GREAT_PERSON_INDIVIDUAL_OMAR_KHAYYAM | 中世纪 | 1 | 随机触发2项科技尤里卡和1项市政鼓舞 | — | 原版 | ✓ |
| 10 | 沈括 | Plati Shen Kuo | GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO | 中世纪 | 1 | 获得2个科技尤里卡 | — | 更多伟人 | ✓ |
| 11 | 阿威罗伊 | Plati Averroes | GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES | 中世纪 | 1 | 获得2个科技尤里卡 | — | 更多伟人 | ✓ |
| 12 | 阿布·卡西姆·扎赫拉维 | Abu Al Qasim Al Zahrawi | GREAT_PERSON_INDIVIDUAL_ABU_AL_QASIM_AL_ZAHRAWI | 中世纪 | 1 | 单位+5生命恢复/回合 | — | 原版 | ✓ |
| 13 | 伊拉斯谟 | Plati Erasmus | GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS | 文艺复兴 | 1 | 所有城市+1文化 | — | 更多伟人 | ✓ |
| 14 | 伊本·赫勒敦 | Ibn Khaldun | GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN | 文艺复兴 | 1 | 随机触发2项科技尤里卡 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 15 | 传教团 | Plati Mission | GREAT_PERSON_INDIVIDUAL_PLATI_MISSION | 文艺复兴 | 1 | 提高传教团改良设施+1科学+1信仰 | — | 更多伟人 | ✓ |
| 16 | 伽利略·伽利莱 | Galileo Galilei | GREAT_PERSON_INDIVIDUAL_GALILEO_GALILEI | 文艺复兴 | 1 | 每个相邻山脉格子+250科技 | — | 原版 | ✓ |
| 17 | 埃米莉·杜·沙特莱 | Emilie Du Chatelet | GREAT_PERSON_INDIVIDUAL_EMILIE_DU_CHATELET | 文艺复兴 | 1 | 随机触发3项文化鼓舞 | — | 原版 | ✓ |
| 18 | 艾萨克·牛顿 | Isaac Newton | GREAT_PERSON_INDIVIDUAL_ISAAC_NEWTON | 文艺复兴 | 1 | 立即建造图书馆和大学，大学+2科技 | — | 原版 | ✓ |
| 19 | 巴斯德 | Plati Pasteur | GREAT_PERSON_INDIVIDUAL_PLATI_PASTEUR | 工业 | 1 | 所有城市+1宜居度 | — | 更多伟人 | ✓ |
| 20 | 德米特里·门捷列夫 | Dmitri Mendeleev | GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV | 工业 | 1 | 随机触发3项科技尤里卡 | — | 原版 | ✓ |
| 21 | 查尔斯·达尔文 | Charles Darwin | GREAT_PERSON_INDIVIDUAL_CHARLES_DARWIN | 工业 | 1 | 每个相邻自然奇观格子+500科技 | — | 原版 | ✓ |
| 22 | 法拉第 | Plati Faraday | GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY | 工业 | 2 | 所有城市+3电力(2次充能) | — | 更多伟人 | ✓ |
| 23 | 詹姆斯·杨 | James Young | GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG | 工业 | 1 | 随机发现2个石油资源并触发相关科技尤里卡 | — | 原版 | ✓ |
| 24 | 艾伦·图灵 | Alan Turing | GREAT_PERSON_INDIVIDUAL_ALAN_TURING | 现代 | 1 | 随机触发1项科技尤里卡，并额外获得1项随机科技尤里卡 | — | 原版 | ✓ |
| 25 | 阿尔伯特·爱因斯坦 | Albert Einstein | GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN | 现代 | 1 | 大学+4科技，所有研究实验室+1科技 | — | 原版 | ✓ |
| 26 | 阿尔弗雷德·诺贝尔 | Alfred Nobel | GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL | 现代 | 1 | 随机触发3项科技尤里卡 | — | 原版 | ✓ |
| 27 | 埃尔温·薛定谔 | Erwin Schrodinger | GREAT_PERSON_INDIVIDUAL_ERWIN_SCHRODINGER | 原子 | 1 | 随机触发3项科技尤里卡 | — | 原版 | ✓ |
| 28 | 玛丽·利基 | Mary Leakey | GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY | 原子 | 1 | 每个城市中每件文物+350科技 | — | 原版 | ✓ |
| 29 | 玛格丽特·米德 | Margaret Mead | GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD | 原子 | 1 | 随机触发3项文化鼓舞 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 30 | 贾纳基·阿马尔 | Janaki Ammal | GREAT_PERSON_INDIVIDUAL_JANAKI_AMMAL | 原子 | 1 | 每个相邻雨林格子+400科技 | — | 原版 | ✓ |
| 31 | 卡尔·萨根 | Carl Sagan | GREAT_PERSON_INDIVIDUAL_CARL_SAGAN | 信息 | 1 | 为太空竞赛项目提供3000产能 | — | 原版 | ✓ |
| 32 | 斯蒂芬妮·克沃勒克 | Stephanie Kwolek | GREAT_PERSON_INDIVIDUAL_STEPHANIE_KWOLEK | 信息 | 1 | 太空竞赛项目+100%产能 | — | 原版 | ✓ |
| 33 | 萨哈罗夫 | Plati Sakharov | GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV | 信息 | 1 | +100%太空竞赛项目产能 | — | 更多伟人 | ✓ |
| 34 | 阿卜杜斯·萨拉姆 | Abdus Salam | GREAT_PERSON_INDIVIDUAL_ABDUS_SALAM | 信息 | 1 | 所有大学+1大科学家点数 | — | 原版 | ✓ |

### 3.6 大商人 (GREAT_PERSON_CLASS_MERCHANT) — 35人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 克罗伊斯 | Plati Croesus | GREAT_PERSON_INDIVIDUAL_PLATI_CROESUS | 古典 | 1 | +500金币 | — | 更多伟人 | ✓ |
| 2 | 张骞 | Zhang Qian | GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN | 古典 | 1 | 所有商路+1金币 | — | 原版 | ✓ |
| 3 | 科莱俄斯 | Colaeus | GREAT_PERSON_INDIVIDUAL_COLAEUS | 古典 | 1 | 获得1个奢侈资源并+100金币 | — | 原版 | ✓ |
| 4 | 马库斯·李锡尼·克拉苏 | Marcus Licinius Crassus | GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS | 古典 | 3 | 获得3个相邻的地块(3次充能) | — | 原版 | ✓ |
| 5 | 伊本·法德兰 | Ibn Fadlan | GREAT_PERSON_INDIVIDUAL_IBN_FADLAN | 中世纪 | 1 | 获得200金币和1个使者 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 6 | 伊本·白图泰 | Plati Ibnbattuta | GREAT_PERSON_INDIVIDUAL_PLATI_IBNBATTUTA | 中世纪 | 1 | +1商路上限 | — | 更多伟人 | ✓ |
| 7 | 威尼斯走私者 | Plati Venetian Smuggler | GREAT_PERSON_INDIVIDUAL_PLATI_VENETIAN_SMUGGLER | 中世纪 | 1 | 获得1件文物 | — | 更多伟人 | ✓ |
| 8 | 皮耶罗·德·巴尔迪 | Piero De Bardi | GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI | 中世纪 | 1 | 获得200金币和1个使者 | — | 原版 | ✓ |
| 9 | 雅典的伊琳娜 | Irene Of Athens | GREAT_PERSON_INDIVIDUAL_IRENE_OF_ATHENS | 中世纪 | 1 | 获得1个奢侈资源并+200金币 | — | 原版 | ✓ |
| 10 | 马可·波罗 | Marco Polo | GREAT_PERSON_INDIVIDUAL_MARCO_POLO | 中世纪 | 1 | 免费获得1个商人和1条商路上限 | — | 原版 | ✓ |
| 11 | 乔瓦尼·德·美第奇 | Giovanni De Medici | GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI | 文艺复兴 | 1 | 立即建造银行和市场，银行+1大商人点数 | — | 原版 | ✓ |
| 12 | 周达观 | Zhou Daguan | GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN | 文艺复兴 | 1 | 获得200金币和2个使者 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 13 | 图西 | Plati Tusi | GREAT_PERSON_INDIVIDUAL_PLATI_TUSI | 文艺复兴 | 1 | +1外交政策槽 | — | 更多伟人 | ✓ |
| 14 | 拉贾·托达尔·马尔 | Raja Todar Mal | GREAT_PERSON_INDIVIDUAL_RAJA_TODAR_MAL | 文艺复兴 | 1 | 从宗主国获得的城邦金币+100% | — | 原版 | ✓ |
| 15 | 雅各布·克特勒 | Plati Jacobkettler | GREAT_PERSON_INDIVIDUAL_PLATI_JACOBKETTLER | 文艺复兴 | 1 | 获得2条商路上限(2次充能) | — | 更多伟人 | ✓ |
| 16 | 雅各布·富格尔 | Jakob Fugger | GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER | 文艺复兴 | 1 | 获得200金币和2个使者 | — | 原版 | ✓ |
| 17 | 亚当·斯密 | Adam Smith | GREAT_PERSON_INDIVIDUAL_ADAM_SMITH | 工业 | 1 | 获得500金币，并额外获得1个经济政策槽 | — | 原版 | ✓ |
| 18 | 塞西尔 | Plati Cecil | GREAT_PERSON_INDIVIDUAL_PLATI_CECIL | 工业 | 1 | +1商路上限 | — | 更多伟人 | ✓ |
| 19 | 汉密尔顿 | Plati Hamilton | GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON | 工业 | 1 | +1经济政策槽 | — | 更多伟人 | ✓ |
| 20 | 科尔贝尔 | Plati Colbert | GREAT_PERSON_INDIVIDUAL_PLATI_COLBERT | 工业 | 1 | +1经济政策槽 | — | 更多伟人 | ✓ |
| 21 | 约翰·斯皮尔斯伯里 | John Spilsbury | GREAT_PERSON_INDIVIDUAL_JOHN_SPILSBURY | 工业 | 1 | 获得500金币 | — | 原版 | ✓ |
| 22 | 约翰·雅各布·阿斯特 | John Jacob Astor | GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | 工业 | 1 | 获得750金币 | — | 原版 | ✓ |
| 23 | 雀巢 | Plati Nestle | GREAT_PERSON_INDIVIDUAL_PLATI_NESTLE | 工业 | 1 | +1巧克力资源 | — | 更多伟人 | ✓ |
| 24 | 斯坦福·莱佛士 | Stamford Raffles | GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES | 现代 | 1 | 获得500金币和2个使者 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 25 | 法贝热 | Plati Faberge | GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE | 现代 | 1 | 获得奢侈资源法贝热彩蛋(+5宜居度) | — | 更多伟人 | ✓ |
| 26 | 玛丽·凯瑟琳·戈达德 | Mary Katherine Goddard | GREAT_PERSON_INDIVIDUAL_MARY_KATHERINE_GODDARD | 现代 | 1 | 获得500金币和2个使者 | — | 原版 | ✓ |
| 27 | 约翰·洛克菲勒 | John Rockefeller | GREAT_PERSON_INDIVIDUAL_JOHN_ROCKEFELLER | 现代 | 1 | 获得1个战略资源石油，并额外获得1个石油 | — | 原版 | ✓ |
| 28 | 莎拉·布里德洛夫 | Sarah Breedlove | GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE | 现代 | 1 | 获得1000金币 | — | 原版 | ✓ |
| 29 | 银行家 | Plati Banker | GREAT_PERSON_INDIVIDUAL_PLATI_BANKER | 现代 | 1 | 所有城市+20%金币产出 | — | 更多伟人 | ✓ |
| 30 | 李维·斯特劳斯 | Levi Strauss | GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS | 原子 | 1 | 获得1000金币 | — | 原版 | ✓ |
| 31 | 梅利塔·本茨 | Melitta Bentz | GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ | 原子 | 1 | 获得1000金币 | — | 原版 | ✓ |
| 32 | 海伦娜·鲁宾斯坦 | Helena Rubinstein | GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN | 原子 | 1 | 获得1000金币和2个使者 | — | 原版 | ✓ |
| 33 | 井深大 | Masaru Ibuka | GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA | 信息 | 1 | 区域+1宜居度 | — | 原版 | ✓ |
| 34 | 詹姆谢特吉·塔塔 | Jamsetji Tata | GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA | 信息 | 1 | 获得1000金币 | — | 原版 | ✓ |
| 35 | 雅诗·兰黛 | Estee Lauder | GREAT_PERSON_INDIVIDUAL_ESTEE_LAUDER | 信息 | 1 | 获得1000金币 | — | 原版 | ✓ |

### 3.7 大将军 (GREAT_PERSON_CLASS_GENERAL) — 40人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 孙子 | Sun Tzu | GREAT_PERSON_INDIVIDUAL_SUN_TZU | 古典 | 0 | 创作军事著作《孙子兵法》 | — | 原版 | ✓ |
| 2 | 布狄卡 | Boudica | GREAT_PERSON_INDIVIDUAL_BOUDICA | 古典 | 1 | 将相邻蛮族单位转化为己方 | — | 原版 | ✓ |
| 3 | 征侧 | Trung Trac | GREAT_PERSON_INDIVIDUAL_TRUNG_TRAC | 古典 | 1 | 在军营获得1个免费单位 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 4 | 汉尼拔·巴卡 | Hannibal Barca | GREAT_PERSON_INDIVIDUAL_HANNIBAL_BARCA | 古典 | 1 | 赠予1个晋升给1个陆军单位 | — | 原版 | ✓ |
| 5 | 加查·马达 | Plati Gajah | GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH | 中世纪 | 1 | +5战斗力对所有陆地单位，登陆不消耗移动力 | — | 更多伟人 | ✓ |
| 6 | 埃塞尔弗莱德 | Aethelflaed | GREAT_PERSON_INDIVIDUAL_AETHELFLAED | 中世纪 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 7 | 帖木儿 | Timur | GREAT_PERSON_INDIVIDUAL_TIMUR | 中世纪 | 1 | 赠予1个晋升给1个陆军单位 | — | DLC(迭起兴衰) | ✓ |
| 8 | 成吉思汗 | Genghis Khan | GREAT_PERSON_INDIVIDUAL_GENGHIS_KHAN | 中世纪 | 1 | 赠予1个晋升给1个陆军单位 | — | 原版 | ✓ |
| 9 | 扬·杰式卡 | Plati Jan Zizka | GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA | 中世纪 | 1 | +5战斗力对所有陆地单位，胡斯派遗产 | — | 更多伟人 | ✓ |
| 10 | 拜巴尔斯 | Plati Baibars | GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS | 中世纪 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 11 | 松迪亚塔 | Plati Sundiata | GREAT_PERSON_INDIVIDUAL_PLATI_SUNDIATA | 中世纪 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 12 | 熙德 | El Cid | GREAT_PERSON_INDIVIDUAL_EL_CID | 中世纪 | 1 | 将1个陆军单位转化为军团 | — | 原版 | ✓ |
| 13 | 留里克 | Plati Rurik | GREAT_PERSON_INDIVIDUAL_PLATI_RURIK | 中世纪 | 1 | 将相邻非军事单位升级为军事单位 | — | 更多伟人 | ✓ |
| 14 | 莽应龙 | Plati Bayinnaung | GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG | 中世纪 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 15 | 古斯塔夫·阿道夫 | Gustavus Adolphus | GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS | 文艺复兴 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ⟳重分类 |
| 16 | 圣女贞德 | Joan Of Arc | GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC | 文艺复兴 | 1 | 创建文物(遗物) | — | 原版 | ✓ |
| 17 | 安娜·恩津加 | Ana Nzinga | GREAT_PERSON_INDIVIDUAL_ANA_NZINGA | 文艺复兴 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 18 | 斯福尔扎 | Plati Sforza | GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA | 文艺复兴 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 19 | 狮心王 | Plati Lionheart | GREAT_PERSON_INDIVIDUAL_PLATI_LIONHEART | 文艺复兴 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 20 | 苏亚雷斯 | Plati Suarez | GREAT_PERSON_INDIVIDUAL_PLATI_SUAREZ | 文艺复兴 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 21 | 雷克斯 | Plati Rex | GREAT_PERSON_INDIVIDUAL_PLATI_REX | 文艺复兴 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 22 | 丹达拉 | Dandara | GREAT_PERSON_INDIVIDUAL_DANDARA | 工业 | 2 | 将相邻非军事单位升级为军事单位(2次充能) | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 23 | 加里波第 | Plati Garibaldi | GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI | 工业 | 1 | +3战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 24 | 拉尼·拉克希米巴伊 | Rani Lakshmibai | GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI | 工业 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 25 | 拿破仑·波拿巴 | Napoleon Bonaparte | GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE | 工业 | 1 | 将1个陆军单位转化为军团 | — | 原版 | ⟳重分类 |
| 26 | 西蒙·玻利瓦尔 | Simon Bolivar | GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR | 工业 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 27 | 冯·恩琴 | Plati Ungern | GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN | 现代 | 1 | 将相邻非军事单位升级为军事单位 | — | 更多伟人 | ✓ |
| 28 | 劳伦斯 | Plati Lawrence | GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE | 现代 | 1 | +5战斗力在沙漠/平原 | — | 更多伟人 | ✓ |
| 29 | 图帕克·阿马鲁 | Tupac Amaru | GREAT_PERSON_INDIVIDUAL_TUPAC_AMARU | 现代 | 1 | 在敌方领土获得2个使者 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 30 | 富兰克林 | Plati Franklin | GREAT_PERSON_INDIVIDUAL_PLATI_FRANKLIN | 现代 | 1 | 所有海军单位+1移动力 | — | 更多伟人 | ✓ |
| 31 | 德川家康 | Plati Tokugawa | GREAT_PERSON_INDIVIDUAL_PLATI_TOKUGAWA | 现代 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 32 | 玛丽娜·拉斯科娃 | Marina Raskova | GREAT_PERSON_INDIVIDUAL_MARINA_RASKOVA | 现代 | 1 | 在航空港建造1架飞机 | — | 原版 | ✓ |
| 33 | 约翰·莫纳什 | John Monash | GREAT_PERSON_INDIVIDUAL_JOHN_MONASH | 现代 | 1 | 赠予1个晋升给1个陆军单位 | — | 原版 | ✓ |
| 34 | 萨摩里·杜尔 | Samori Ture | GREAT_PERSON_INDIVIDUAL_SAMORI_TURE | 现代 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 35 | 德怀特·艾森豪威尔 | Dwight Eisenhower | GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER | 原子 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 36 | 格奥尔基·朱可夫 | Georgy Zhukov | GREAT_PERSON_INDIVIDUAL_GEORGY_ZHUKOV | 原子 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 37 | 萨尔贡 | Plati Sargon | GREAT_PERSON_INDIVIDUAL_PLATI_SARGON | 原子 | 1 | +5战斗力对所有陆地单位 | — | 更多伟人 | ✓ |
| 38 | 道格拉斯·麦克阿瑟 | Douglas Macarthur | GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR | 原子 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 39 | 维贾亚·维马拉拉特纳 | Vijaya Wimalaratne | GREAT_PERSON_INDIVIDUAL_VIJAYA_WIMALARATNE | 信息 | 1 | 赠予1个晋升给1个陆军单位 | — | 原版 | ✓ |
| 40 | 艾哈迈德·沙阿·马苏德 | Ahmad Shah Massoud | GREAT_PERSON_INDIVIDUAL_AHMAD_SHAH_MASSOUD | 信息 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |

### 3.8 海军统帅 (GREAT_PERSON_CLASS_ADMIRAL) — 30人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 地米斯托克利 | Themistocles | GREAT_PERSON_INDIVIDUAL_THEMISTOCLES | 古典 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 2 | 盖乌斯·杜伊利乌斯 | Gaius Duilius | GREAT_PERSON_INDIVIDUAL_GAIUS_DUILIUS | 古典 | 1 | 将1个海军单位转化为舰队 | — | 原版 | ✓ |
| 3 | 航海家汉诺 | Hanno The Navigator | GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR | 古典 | 1 | 将相邻非军事单位升级为军事单位 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 4 | 阿尔特米西亚 | Artemisia | GREAT_PERSON_INDIVIDUAL_ARTEMISIA | 古典 | 1 | 赠予1个晋升给1个海军单位 | — | 原版 | ✓ |
| 5 | 阿格里帕 | Plati Agrippa | GREAT_PERSON_INDIVIDUAL_PLATI_AGRIPPA | 古典 | 1 | 为建造中的奇观提供产能 | — | 更多伟人 | ✓ |
| 6 | 希梅里奥斯 | Himerios | GREAT_PERSON_INDIVIDUAL_HIMERIOS | 中世纪 | 1 | 赠予1个晋升给1个海军单位 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 7 | 拉金德拉·朱罗 | Rajendra Chola | GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA | 中世纪 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 8 | 洛德布罗克 | Plati Lodbrok | GREAT_PERSON_INDIVIDUAL_PLATI_LODBROK | 中世纪 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 9 | 莱夫·埃里克松 | Leif Erikson | GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON | 中世纪 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 10 | 郑和 | Zheng He | GREAT_PERSON_INDIVIDUAL_ZHENG_HE | 中世纪 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 11 | 阿拉贡人 | Plati Aragonese | GREAT_PERSON_INDIVIDUAL_PLATI_ARAGONESE | 中世纪 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 12 | 亨利 | Plati Henry | GREAT_PERSON_INDIVIDUAL_PLATI_HENRY | 文艺复兴 | 1 | 所有海军单位+1移动力 | — | 更多伟人 | ✓ |
| 13 | 圣克鲁斯 | Santa Cruz | GREAT_PERSON_INDIVIDUAL_SANTA_CRUZ | 文艺复兴 | 1 | 将1个海军单位转化为舰队 | — | 原版 | ✓ |
| 14 | 尼尔斯·尤尔 | Plati Niels Juel | GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL | 文艺复兴 | 1 | 所有海军单位+1移动力 | — | 更多伟人 | ✓ |
| 15 | 巴巴罗萨 | Plati Barbarosa | GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSA | 文艺复兴 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 16 | 库克 | Plati Cook | GREAT_PERSON_INDIVIDUAL_PLATI_COOK | 文艺复兴 | 1 | 所有海军单位+1视野+1移动力 | — | 更多伟人 | ✓ |
| 17 | 弗朗西斯·德雷克 | Francis Drake | GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE | 文艺复兴 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 18 | 摩根 | Plati Morgan | GREAT_PERSON_INDIVIDUAL_PLATI_MORGAN | 文艺复兴 | 1 | 获得2个使者 | — | 更多伟人 | ✓ |
| 19 | 李舜臣 | Yi Sun Sin | GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN | 文艺复兴 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 20 | 费迪南德·麦哲伦 | Ferdinand Magellan | GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN | 文艺复兴 | 1 | 获得2个使者 | — | DLC(迭起兴衰) | ✓ |
| 21 | 拉斯卡里娜·布布利纳 | Laskarina Bouboulina | GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA | 工业 | 1 | 赠予1个晋升给1个海军单位 | — | 原版 | ✓ |
| 22 | 郑一嫂 | Ching Shih | GREAT_PERSON_INDIVIDUAL_CHING_SHIH | 工业 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 23 | 霍雷肖·纳尔逊 | Horatio Nelson | GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON | 工业 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 24 | 弗朗茨·冯·希佩尔 | Franz Von Hipper | GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER | 现代 | 1 | 将相邻非军事单位升级为军事单位 | — | 原版 | ✓ |
| 25 | 若阿金·马克斯·里斯本 | Joaquim Marques Lisboa | GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA | 现代 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 26 | 马修·佩里 | Matthew Perry | GREAT_PERSON_INDIVIDUAL_MATTHEW_PERRY | 现代 | 1 | 获得2个使者和城邦宗主国 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 27 | 切斯特·尼米兹 | Chester Nimitz | GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ | 原子 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 28 | 格蕾丝·霍珀 | Grace Hopper | GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER | 原子 | 1 | 获得2个使者 | — | 原版 | ✓ |
| 29 | 谢尔盖·戈尔什科夫 | Sergey Gorshkov | GREAT_PERSON_INDIVIDUAL_SERGEY_GORSHKOV | 原子 | 1 | 赠予1个晋升给1个海军单位 | — | 原版 | ✓ |
| 30 | 克兰西·费尔南多 | Clancy Fernando | GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO | 信息 | 1 | 赠予1个晋升给1个海军单位 | — | 原版 | ✓ |

### 3.9 大预言家 (GREAT_PERSON_CLASS_PROPHET) — 16人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 孔子 | Confucius | GREAT_PERSON_INDIVIDUAL_CONFUCIUS | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 2 | 悉达多·乔达摩 | Siddhartha Gautama | GREAT_PERSON_INDIVIDUAL_SIDDHARTHA_GAUTAMA | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 3 | 施洗约翰 | John The Baptist | GREAT_PERSON_INDIVIDUAL_JOHN_THE_BAPTIST | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 4 | 琐罗亚斯德 | Zoroaster | GREAT_PERSON_INDIVIDUAL_ZOROASTER | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 5 | 老子 | Laozi | GREAT_PERSON_INDIVIDUAL_LAOZI | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 6 | 西门·彼得 | Simon Peter | GREAT_PERSON_INDIVIDUAL_SIMON_PETER | 古典 | 0 | 创立宗教 | — | 原版 | ✓ |
| 7 | 太安万侣 | O No Yasumaro | GREAT_PERSON_INDIVIDUAL_O_NO_YASUMARO | 中世纪 | 0 | 创立宗教 | — | 原版 | ✓ |
| 8 | 松赞干布 | Songtsan Gampo | GREAT_PERSON_INDIVIDUAL_SONGTSAN_GAMPO | 中世纪 | 0 | 创立宗教 | — | 原版 | ✓ |
| 9 | 爱任纽 | Irenaeus | GREAT_PERSON_INDIVIDUAL_IRENAEUS | 中世纪 | 0 | 创立宗教 | — | 原版 | ✓ |
| 10 | 菩提达摩 | Bodhidharma | GREAT_PERSON_INDIVIDUAL_BODHIDHARMA | 中世纪 | 0 | 创立宗教 | — | 原版 | ✓ |
| 11 | 阿迪·商羯罗 | Adi Shankara | GREAT_PERSON_INDIVIDUAL_ADI_SHANKARA | 中世纪 | 0 | 创立宗教 | — | 原版 | ✓ |
| 12 | 哈吉·胡德 | Haji Huud | GREAT_PERSON_INDIVIDUAL_HAJI_HUUD | 文艺复兴 | 0 | 创立宗教 | — | 原版 | ✓ |
| 13 | 托马斯·阿奎那 | Thomas Aquinas | GREAT_PERSON_INDIVIDUAL_THOMAS_AQUINAS | 文艺复兴 | 0 | 创立宗教 | — | 原版 | ✓ |
| 14 | 摩陀婆·阿阇梨 | Madhva Acharya | GREAT_PERSON_INDIVIDUAL_MADHVA_ACHARYA | 文艺复兴 | 0 | 创立宗教 | — | 原版 | ✓ |
| 15 | 阿西西的方济各 | Francis Of Assisi | GREAT_PERSON_INDIVIDUAL_FRANCIS_OF_ASSISI | 文艺复兴 | 0 | 创立宗教 | — | 原版 | ✓ |
| 16 | 马丁·路德 | Martin Luther | GREAT_PERSON_INDIVIDUAL_MARTIN_LUTHER | 文艺复兴 | 0 | 创立宗教 | — | 原版 | ✓ |

### 3.10 大统治者 (GREAT_PERSON_CLASS_GreatSovereigns) — 16人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|----------|------|------|
| 1 | 丹多洛 | Plati Dandolo | GREAT_PERSON_INDIVIDUAL_PLATI_DANDOLO | 中世纪 | 1 | +1经济政策槽 | — | 大统治者伟人 | ✓ |
| 2 | 拉玛坎亨 | Plati Sixteenth | GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH | 中世纪 | 1 | +1军事政策槽 | — | 大统治者伟人 | ✓ |
| 3 | 格迪米纳斯 | Plati Sovereign Gediminas | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS | 中世纪 | 2 | +1外交政策槽(2次充能) | — | 大统治者伟人 | ✓ |
| 4 | 罗德里戈·波吉亚 | Plati Rborgia | GREAT_PERSON_INDIVIDUAL_PLATI_RBORGIA | 中世纪 | 1 | +1军事政策槽 | — | 大统治者伟人 | ✓ |
| 5 | 腓特烈大帝 | Plati Sovereign Fridrik Great | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT | 中世纪 | 1 | +1军事政策槽 | — | 大统治者伟人 | ✓ |
| 6 | 阿尔弗雷德大帝 | Plati Alfred The Great | GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT | 中世纪 | 1 | 所有海军单位+1免费晋升 | — | 大统治者伟人 | ✓ |
| 7 | 兀鲁伯 | Plati Beg | GREAT_PERSON_INDIVIDUAL_PLATI_BEG | 文艺复兴 | 1 | +1外交政策槽 | — | 大统治者伟人 | ✓ |
| 8 | 玛丽亚·特蕾莎 | Plati Twelwth | GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH | 文艺复兴 | 1 | +1外交政策槽 | — | 大统治者伟人 | ✓ |
| 9 | 邓小平 | Plati Deng | GREAT_PERSON_INDIVIDUAL_PLATI_DENG | 文艺复兴 | 1 | +1经济政策槽 | — | 大统治者伟人 | ✓ |
| 10 | 阿克巴 | Plati Akbar | GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR | 文艺复兴 | 1 | 为建造中的奇观提供产能 | — | 大统治者伟人 | ✓ |
| 11 | 首位君主 | Plati Sovereign First | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST | 文艺复兴 | 1 | +1万能政策槽 | — | 大统治者伟人 | ✓ |
| 12 | 俾斯麦 | Plati Bismark | GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK | 工业 | 1 | 获得2个使者(城邦领土) | — | 大统治者伟人 | ✓ |
| 13 | 科塞姆苏丹 | Plati Kosemi | GREAT_PERSON_INDIVIDUAL_PLATI_KOSEMI | 工业 | 1 | +1外交政策槽 | — | 大统治者伟人 | ✓ |
| 14 | 扎耶德 | Plati Sovereign Zayed | GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED | 原子 | 1 | +1万能政策槽 | — | 大统治者伟人 | ✓ |
| 15 | 李光耀 | Plati Eleventh | GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH | 原子 | 1 | +1经济政策槽 | — | 大统治者伟人 | ✓ |
| 16 | 摩纳哥 | Plati Monaco | GREAT_PERSON_INDIVIDUAL_PLATI_MONACO | 信息 | 1 | +1经济政策槽 | — | 大统治者伟人 | ✓ |

### 3.11 其他伟人类型 — 15人

包括 COMANDANTE_GENERAL 11人、JNR_EXPLORER 2人、ENGINEER_EWHO 2人

#### 总指挥官 — 10人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 乌达内塔 | Commandante Urdaneta | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_URDANETA | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 2 | 何塞·德·苏克雷 | Commandante Jose De Sucre | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_JOSE_DE_SUCRE | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 3 | 保拉·桑坦德 | Commandante Paula Santander | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PAULA_SANTANDER | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 4 | 安东尼奥·帕埃斯 | Commandante Antonio Paez | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_ANTONIO_PAEZ | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 5 | 皮亚尔 | Commandante Piar | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PIAR | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 6 | 纳里尼奥 | Commandante Narino | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_NARINO | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 7 | 蒙蒂利亚 | Commandante Montilla | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MONTILLA | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 8 | 里瓦斯 | Commandante Ribas | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_RIBAS | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 9 | 马里尼奥 | Commandante Marino | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MARINO | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |
| 10 | 麦格雷戈 | Commandante Macgregor | GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MACGREGOR | 远古 | 1 | — | DLC(巴比伦/大哥伦比亚) | ✓ |

#### 探险家 — 2人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 维图斯 | Plati Vitus | GREAT_PERSON_INDIVIDUAL_PLATI_VITUS | 文艺复兴 | 1 | 所有海军单位+1移动力 | 更多伟人 | ✓ |
| 2 | 马吉德 | Plati Majid | GREAT_PERSON_INDIVIDUAL_PLATI_MAJID | 文艺复兴 | 1 | 所有海军单位+1移动力 | 更多伟人 | ✓ |

#### 大工程师(EWHO) — 1人

| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |
|---|--------|--------|--------|------|------|----------|------|------|
| 1 | 沙贾汗(EWHO) | Shah Jahan Ewho | GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN_EWHO | 文艺复兴 | 3 | — | EWHO | ✓ |

## 4. 关联数据

### 4.1 新增建筑

| 建筑ID | 中文名 | 效果 | 来源 |
|--------|--------|------|------|
| BUILDING_PLATI_PAPER_MAKER | 造纸坊 | +1科技 +2金币 | 更多伟人 |
| BUILDING_PLATI_TEMPLAR_VAULT | 圣殿骑士金库 | +2信仰 | 更多伟人 |
| BUILDING_PLATI_CHOCOLATERIE | 巧克力工坊 | +2文化 提供果仁糖 | 更多伟人 |
| BUILDING_PLATI_MONUMENT_ASKIA | 阿斯基亚纪念碑 | 替换纪念碑 | 大统治者伟人 |
| BUILDING_HAKAM_CATHEDRAL | 哈卡姆大教堂 | 特殊宗教建筑 | 大统治者伟人 |
| BUILDING_HAKAM_MOSQUE | 哈卡姆清真寺 | 特殊宗教建筑 | 大统治者伟人 |
| BUILDING_HAKAM_SYNAGOGE | 哈卡姆犹太会堂 | 特殊宗教建筑 | 大统治者伟人 |

### 4.2 新增资源

| 资源ID | 中文名 | 宜居度 | 来源 |
|--------|--------|--------|------|
| RESOURCE_EGG | 法贝热彩蛋 | +5 | 更多伟人 |
| RESOURCE_PEPPER | 胡椒 | +4 | 更多伟人 |
| RESOURCE_NUTMEG | 肉豆蔻 | +4 | 更多伟人 |
| RESOURCE_PRALINE | 果仁糖 | +4 | 更多伟人 |
| RESOURCE_JNR_MUREX | 泰尔紫 | +4 | 远古伟人 |
| RESOURCE_COWRIE | 货贝 | +4 | 大统治者伟人 |

### 4.3 新增政策卡

来自大统治者伟人Mod的政策卡:

| 政策卡 | 中文名 | 效果 | 类型 |
|--------|--------|------|------|
| POLICY_SOVEREIGN_ELITE | 精英统治 | +2大统治者伟人点/回合 | 经济 |
| POLICY_SOVEREIGN_TIMOCRACY | 勋阀统治 | 击杀单位+8大统治者伟人点 | 军事 |
| POLICY_SOVEREIGN_ENLIGHTENMENT | 开明专制 | 大统治者伟人点+50% | 经济 |

### 4.4 新增万神殿信条

- PLATI_BELIEF_SOVEREIGN: 圣主明君 — +1大统治者伟人点/回合，黄金时代额外+1

### 4.5 大统治者伟人点来源

| 来源 | 点数/回合 |
|------|----------|
| 政府区 | +1 |
| 觐见厅/祠堂/军阀宝座 | +1 |
| 谒见厅/情报局/大教堂 | +2 |
| 皇家学会/国家博物馆/骑士团团长礼拜堂 | +3 |
| 阿尔罕布拉宫 | +1 |
| 宙斯像 | +2 |
| 泰姬陵 | +1 |
| 圣索菲亚大教堂 | +2 |
| 吴哥窟 | +2 |
| 罗马斗兽场 | +2 |
| 金字塔 | +1 |
| 精英统治政策 | +2 |
| 圣主明君万神殿 | +1(+1黄金时代) |
| 击杀单位 | +8/次 |

## 5. 被修改/删除的原版内容

### 5.1 更多伟人 删除的18位原版伟人

| 原版ID | 中文名 | 类型 | 原因 |
|--------|--------|------|------|
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA | 查尔斯·科雷亚 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON | 约瑟夫·帕克斯顿 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 詹姆斯·圣乔治 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JANE_DREW | 简·德鲁 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD | 罗伯特·戈达德 | 大工程师 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ | 梅利塔·本茨 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JOHN_SPILSBURY | 约翰·斯皮尔斯伯里 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN | 海伦娜·鲁宾斯坦 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS | 李维·斯特劳斯 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_ESTEE_LAUDER | 雅诗·兰黛 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA | 井深大 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA | 詹姆谢特吉·塔塔 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE | 莎拉·布里德洛夫 | 大商人 | 加成平庸 |
| GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR | 约翰·雅各布·阿斯特 | 大商人 | 加成平庸 |

### 5.2 删除部分工程师 删除的5位大工程师

| 原版ID | 中文名 |
|--------|--------|
| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 |
| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 詹姆斯·圣乔治 |
| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 |
| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 |
| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 |

### 5.3 大统治者伟人 重分类的2位原版大将军

- 拿破仑·波拿巴: 重分类为大统治者，+1万能政策槽
- 古斯塔夫·阿道夫: 重分类为大统治者，+1军事政策槽

### 5.4 远古伟人 修改的印何阗

- 印何阗: 时代从远古改为古典，行动次数改为2，古典奇观产能改为250

## 6. 兼容性分析

### 6.1 Mod重叠定义

| 游戏元素 | 删除部分工程师 | 更多伟人 | 最终结果 | 原因 |
|----------|:---:|:---:|:---:|------|
| JOHN_A_ROEBLING | DELETE | DELETE | 被删除 | 两个mod都删除 |
| JAMES_OF_ST_GEORGE | DELETE | DELETE | 被删除 | 两个mod都删除 |

### 6.2 冲突与风险

- **LoadOrder 冲突**: 更多伟人(240-250)与大统治者伟人(240-250)的LoadOrder范围重叠，但两者操作不同表(GreatPersonIndividuals vs GreatSovereigns)，无直接冲突。
- **删除冲突**: 更多伟人的"移除平庸者"选项(LoadOrder 999)和删除部分工程师mod都会删除某些工程师，可能导致重复删除但不会出错。
- **汉化覆盖**: 汉化文本LoadOrder极高(1919/11000)，确保所有文本覆盖正确。

## 7. 远古伟人 新增14人详细效果

远古伟人(6T_AGP)Mod新增14位远古时代伟人，覆盖以下类型:

| 类型 | 人数 | 主要效果 |
|------|:---:|------|
| 大艺术家 | 2 | 创作远古巨作 |
| 大作家 | 2 | 创作远古巨作 |
| 大音乐家 | 2 | 创作远古巨作 |
| 大工程师 | 3 | 奇观产能/城市加成 |
| 大科学家 | 2 | 科技尤里卡/加成 |
| 大商人 | 2 | 金币/商路/资源 |
| 大将军 | 1 | 军事加成 |
| 海军统帅 | 0 | — |


## 8. 更多伟人 新增详细效果

更多伟人(Sumus Magnus) Mod新增72位伟人，覆盖以下类型:

| 类型 | 人数 | 特色 |
|------|:---:|------|
| 大艺术家 | 2 | 新增巨作 |
| 大作家 | 10 | 哲学/文学巨作 |
| 大音乐家 | 1 | 新增巨作 |
| 大工程师 | 12 | 改良设施加成/奇观产能/城市加成 |
| 大科学家 | 13 | 尤里卡/政策槽/特殊加成 |
| 大商人 | 14 | 奢侈资源/金币/商路/政策槽 |
| 大将军 | 15 | 战斗加成/使者/特殊单位 |
| 海军统帅 | 7 | 海军移动/使者/奇观 |

核心特色:

- 新增奢侈资源: 法贝热彩蛋、胡椒、肉豆蔻、果仁糖
- 新增建筑: 造纸坊、圣殿骑士金库、巧克力工坊
- 改良设施加成: 圩田(+1食物+1产能)、城堡(+1文化+1金币)、传教团(+1科学+1信仰)
- 政策槽加成: 万能政策槽、经济政策槽、外交政策槽
- 海军增强: 库克、亨利、维图斯等提供+1海军移动力
- 特殊单位: 加查·马达提供登陆不消耗移动力

## 9. 大统治者伟人 新增详细效果

大统治者伟人(GreatSovereigns) Mod新增18位大统治者，属于全新伟人类别。

核心机制:

| 中文名 | 内部ID | 时代 | 充能 | 主动效果 |
|--------|--------|------|:----:|------|
| 丹多洛 | DANDOLO | 中世纪 | 1 | +1经济政策槽 |
| 拉玛坎亨 | SIXTEENTH | 中世纪 | 1 | +1军事政策槽 |
| 格迪米纳斯 | SOVEREIGN_GEDIMINAS | 中世纪 | 2 | +1外交政策槽(2次充能) |
| 罗德里戈·波吉亚 | RBORGIA | 中世纪 | 1 | +1军事政策槽 |
| 腓特烈大帝 | SOVEREIGN_FRIDRIK_GREAT | 中世纪 | 1 | +1军事政策槽 |
| 阿尔弗雷德大帝 | ALFRED_THE_GREAT | 中世纪 | 1 | 所有海军单位+1免费晋升 |
| 兀鲁伯 | BEG | 文艺复兴 | 1 | +1外交政策槽 |
| 玛丽亚·特蕾莎 | TWELWTH | 文艺复兴 | 1 | +1外交政策槽 |
| 邓小平 | DENG | 文艺复兴 | 1 | +1经济政策槽 |
| 阿克巴 | AKBAR | 文艺复兴 | 1 | 为建造中的奇观提供产能 |
| 首位君主 | SOVEREIGN_FIRST | 文艺复兴 | 1 | +1万能政策槽 |
| 俾斯麦 | BISMARK | 工业 | 1 | 获得2个使者(城邦领土) |
| 科塞姆苏丹 | KOSEMI | 工业 | 1 | +1外交政策槽 |
| 扎耶德 | SOVEREIGN_ZAYED | 原子 | 1 | +1万能政策槽 |
| 李光耀 | ELEVENTH | 原子 | 1 | +1经济政策槽 |
| 摩纳哥 | MONACO | 信息 | 1 | +1经济政策槽 |
| 拿破仑·波拿巴 | (重分类) | 工业 | 1 | +1万能政策槽 |
| 古斯塔夫·阿道夫 | (重分类) | 文艺复兴 | 1 | +1军事政策槽 |

大统治者伟人点获取方式:

- 政府区每回合+1点
- 根据政府区建筑等级额外+1~+3点
- 特定奇观提供点数(阿尔罕布拉宫、宙斯像等)
- 精英统治政策卡+2点/回合
- 圣主明君万神殿+1点/回合(黄金时代+2)
- 击杀单位+8点/次

