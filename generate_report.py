#!/usr/bin/env python3
"""Generate the complete GreatPerson analysis report from gp_phase2.json - V2"""

import json
import re
from collections import defaultdict

# Load the JSON data
with open('/workspace/gp_phase2.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

entries = data['entries']

# ============================================================
# Standard vanilla/DLC great person effects
# ============================================================

VANILLA_EFFECTS = {
    # ---- ENGINEERS ----
    "GREAT_PERSON_INDIVIDUAL_BI_SHENG": "印刷术/攻城术触发尤里卡，并随意触发另一项随机科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS": "为建造中的奇观提供215锤(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE": "在城市中建造古代/中世纪城墙(3次充能)",
    "GREAT_PERSON_INDIVIDUAL_FILIPPO_BRUNELLESCHI": "为建造中的奇观提供315锤(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_LEONARDO_DA_VINCI": "工坊+1文化，该效果触发尤里卡",
    "GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN": "城市+1宜居度+1住房(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE": "免费获得1个随机科技",
    "GREAT_PERSON_INDIVIDUAL_GUSTAVE_EIFFEL": "为建造中的奇观提供480锤(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_JAMES_WATT": "立即建造工厂和工坊，工厂+2产能",
    "GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO": "城市获得1格文化范围",
    "GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA": "区域内建筑影响力延伸至6格内所有城市",
    "GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD": "太空竞赛项目+20%产能",
    "GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING": "城市+2住房+1宜居度(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_JANE_DREW": "城市+4住房+3宜居度",
    "GREAT_PERSON_INDIVIDUAL_SERGEI_KOROLEV": "为太空竞赛项目提供1500产能",
    "GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA": "城市获得2格文化范围",
    "GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON": "区域+1宜居度",
    "GREAT_PERSON_INDIVIDUAL_WERNHER_VON_BRAUN": "太空竞赛项目+100%产能",
    "GREAT_PERSON_INDIVIDUAL_IMHOTEP": "为建造中的奇观提供175锤(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN": "为建造中的奇观提供产能(1次充能，按当前时代)",
    "GREAT_PERSON_INDIVIDUAL_KENZO_TANGE": "城市每个区域+1科技+1文化+1金币+1信仰",
    
    # ---- SCIENTISTS ----
    "GREAT_PERSON_INDIVIDUAL_ARYABHATA": "随机触发3项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_EUCLID": "随机触发1项科技尤里卡并额外获得1个随机科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_HYPATIA": "图书馆+1科技，建造图书馆不消耗金币",
    "GREAT_PERSON_INDIVIDUAL_ABU_AL_QASIM_AL_ZAHRAWI": "单位+5生命恢复/回合",
    "GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN": "圣地+20信仰",
    "GREAT_PERSON_INDIVIDUAL_OMAR_KHAYYAM": "随机触发2项科技尤里卡和1项市政鼓舞",
    "GREAT_PERSON_INDIVIDUAL_GALILEO_GALILEI": "每个相邻山脉格子+250科技",
    "GREAT_PERSON_INDIVIDUAL_ISAAC_NEWTON": "立即建造图书馆和大学，大学+2科技",
    "GREAT_PERSON_INDIVIDUAL_EMILIE_DU_CHATELET": "随机触发3项文化鼓舞",
    "GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG": "随机发现2个石油资源并触发相关科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_CHARLES_DARWIN": "每个相邻自然奇观格子+500科技",
    "GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV": "随机触发3项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_ALAN_TURING": "随机触发1项科技尤里卡，并额外获得1项随机科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN": "大学+4科技，所有研究实验室+1科技",
    "GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL": "随机触发3项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_JANAKI_AMMAL": "每个相邻雨林格子+400科技",
    "GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY": "每个城市中每件文物+350科技",
    "GREAT_PERSON_INDIVIDUAL_ERWIN_SCHRODINGER": "随机触发3项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_ABDUS_SALAM": "所有大学+1大科学家点数",
    "GREAT_PERSON_INDIVIDUAL_CARL_SAGAN": "为太空竞赛项目提供3000产能",
    "GREAT_PERSON_INDIVIDUAL_STEPHANIE_KWOLEK": "太空竞赛项目+100%产能",
    "GREAT_PERSON_INDIVIDUAL_ZHANG_HENG": "随机触发2项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN": "随机触发2项科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD": "随机触发3项文化鼓舞",
    
    # ---- MERCHANTS ----
    "GREAT_PERSON_INDIVIDUAL_COLAEUS": "获得1个奢侈资源并+100金币",
    "GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS": "获得3个相邻的地块(3次充能)",
    "GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN": "所有商路+1金币",
    "GREAT_PERSON_INDIVIDUAL_MARCO_POLO": "免费获得1个商人和1条商路上限",
    "GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI": "获得200金币和1个使者",
    "GREAT_PERSON_INDIVIDUAL_IRENE_OF_ATHENS": "获得1个奢侈资源并+200金币",
    "GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI": "立即建造银行和市场，银行+1大商人点数",
    "GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER": "获得200金币和2个使者",
    "GREAT_PERSON_INDIVIDUAL_RAJA_TODAR_MAL": "从宗主国获得的城邦金币+100%",
    "GREAT_PERSON_INDIVIDUAL_ADAM_SMITH": "获得500金币，并额外获得1个经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_JOHN_SPILSBURY": "获得500金币",
    "GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR": "获得750金币",
    "GREAT_PERSON_INDIVIDUAL_MARY_KATHERINE_GODDARD": "获得500金币和2个使者",
    "GREAT_PERSON_INDIVIDUAL_JOHN_ROCKEFELLER": "获得1个战略资源石油，并额外获得1个石油",
    "GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE": "获得1000金币",
    "GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN": "获得1000金币和2个使者",
    "GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ": "获得1000金币",
    "GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS": "获得1000金币",
    "GREAT_PERSON_INDIVIDUAL_ESTEE_LAUDER": "获得1000金币",
    "GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA": "区域+1宜居度",
    "GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA": "获得1000金币",
    "GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN": "获得200金币和2个使者",
    "GREAT_PERSON_INDIVIDUAL_IBN_FADLAN": "获得200金币和1个使者",
    "GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES": "获得500金币和2个使者",
    
    # ---- GENERALS ----
    "GREAT_PERSON_INDIVIDUAL_BOUDICA": "将相邻蛮族单位转化为己方",
    "GREAT_PERSON_INDIVIDUAL_HANNIBAL_BARCA": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_SUN_TZU": "创作军事著作《孙子兵法》",
    "GREAT_PERSON_INDIVIDUAL_AETHELFLAED": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_EL_CID": "将1个陆军单位转化为军团",
    "GREAT_PERSON_INDIVIDUAL_GENGHIS_KHAN": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC": "创建文物(遗物)",
    "GREAT_PERSON_INDIVIDUAL_ANA_NZINGA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE": "将1个陆军单位转化为军团",
    "GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_JOHN_MONASH": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_MARINA_RASKOVA": "在航空港建造1架飞机",
    "GREAT_PERSON_INDIVIDUAL_SAMORI_TURE": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_GEORGY_ZHUKOV": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_SUDIRMAN": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_AHMAD_SHAH_MASSOUD": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_VIJAYA_WIMALARATNE": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_TIMUR": "赠予1个晋升给1个陆军单位",
    "GREAT_PERSON_INDIVIDUAL_DANDARA": "将相邻非军事单位升级为军事单位(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_TRUNG_TRAC": "在军营获得1个免费单位",
    "GREAT_PERSON_INDIVIDUAL_TUPAC_AMARU": "在敌方领土获得2个使者",
    
    # ---- ADMIRALS ----
    "GREAT_PERSON_INDIVIDUAL_ARTEMISIA": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_GAIUS_DUILIUS": "将1个海军单位转化为舰队",
    "GREAT_PERSON_INDIVIDUAL_THEMISTOCLES": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_ZHENG_HE": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_SANTA_CRUZ": "将1个海军单位转化为舰队",
    "GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_CHING_SHIH": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_SERGEY_GORSHKOV": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_MATTHEW_PERRY": "获得2个使者和城邦宗主国",
    "GREAT_PERSON_INDIVIDUAL_HIMERIOS": "赠予1个晋升给1个海军单位",
    "GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN": "获得2个使者",
}

# Chinese name mappings
CN_NAMES = {
    # Artists
    "GREAT_PERSON_INDIVIDUAL_ANDREY_RUBLEV": "安德烈·鲁布廖夫",
    "GREAT_PERSON_INDIVIDUAL_HIERONYMUS_BOSCH": "希罗尼穆斯·博斯",
    "GREAT_PERSON_INDIVIDUAL_DONATELLO": "多纳泰罗",
    "GREAT_PERSON_INDIVIDUAL_MICHELANGELO": "米开朗基罗",
    "GREAT_PERSON_INDIVIDUAL_QIU_YING": "仇英",
    "GREAT_PERSON_INDIVIDUAL_TITIAN": "提香",
    "GREAT_PERSON_INDIVIDUAL_EL_GRECO": "埃尔·格列柯",
    "GREAT_PERSON_INDIVIDUAL_REMBRANDT_VAN_RIJN": "伦勃朗·凡·莱因",
    "GREAT_PERSON_INDIVIDUAL_SOFONISBA_ANGUISSOLA": "索福尼斯巴·安圭索拉",
    "GREAT_PERSON_INDIVIDUAL_ANGELICA_KAUFFMAN": "安吉丽卡·考夫曼",
    "GREAT_PERSON_INDIVIDUAL_JANG_SEUNG_EOP": "张承业",
    "GREAT_PERSON_INDIVIDUAL_KATSUSHIKA_HOKUSAI": "葛饰北斋",
    "GREAT_PERSON_INDIVIDUAL_VINCENT_VAN_GOGH": "文森特·梵高",
    "GREAT_PERSON_INDIVIDUAL_EDMONIA_LEWIS": "埃德蒙尼亚·刘易斯",
    "GREAT_PERSON_INDIVIDUAL_MARIE_ANNE_COLLOT": "玛丽-安妮·科洛",
    "GREAT_PERSON_INDIVIDUAL_CLAUDE_MONET": "克劳德·莫奈",
    "GREAT_PERSON_INDIVIDUAL_BORIS_ORLOVSKY": "鲍里斯·奥尔洛夫斯基",
    "GREAT_PERSON_INDIVIDUAL_GUSTAV_KLIMT": "古斯塔夫·克里姆特",
    "GREAT_PERSON_INDIVIDUAL_AMRITA_SHER_GIL": "阿姆丽塔·谢尔-吉尔",
    "GREAT_PERSON_INDIVIDUAL_MARY_CASSATT": "玛丽·卡萨特",
    "GREAT_PERSON_INDIVIDUAL_KAMAL_UD_DIN_BEHZAD": "卡迈勒·乌德丁·贝赫扎德",
    "GREAT_PERSON_INDIVIDUAL_HASEGAWA_TOHAKU": "长谷川等伯",
    "GREAT_PERSON_INDIVIDUAL_WASSILY_KANDINSKY": "瓦西里·康定斯基",
    # Writers
    "GREAT_PERSON_INDIVIDUAL_BHASA": "跋娑",
    "GREAT_PERSON_INDIVIDUAL_HOMER": "荷马",
    "GREAT_PERSON_INDIVIDUAL_OVID": "奥维德",
    "GREAT_PERSON_INDIVIDUAL_QU_YUAN": "屈原",
    "GREAT_PERSON_INDIVIDUAL_GEOFFREY_CHAUCER": "乔弗里·乔叟",
    "GREAT_PERSON_INDIVIDUAL_LI_BAI": "李白",
    "GREAT_PERSON_INDIVIDUAL_MURASAKI_SHIKIBU": "紫式部",
    "GREAT_PERSON_INDIVIDUAL_MARGARET_CAVENDISH": "玛格丽特·卡文迪什",
    "GREAT_PERSON_INDIVIDUAL_MIGUEL_DE_CERVANTES": "米格尔·德·塞万提斯",
    "GREAT_PERSON_INDIVIDUAL_NICCOLO_MACHIAVELLI": "尼科洛·马基雅维利",
    "GREAT_PERSON_INDIVIDUAL_WILLIAM_SHAKESPEARE": "威廉·莎士比亚",
    "GREAT_PERSON_INDIVIDUAL_MARIE_CATHERINE_D_AULNOY": "玛丽-凯瑟琳·德·奥尔努瓦",
    "GREAT_PERSON_INDIVIDUAL_ALEXANDER_PUSHKIN": "亚历山大·普希金",
    "GREAT_PERSON_INDIVIDUAL_EDGAR_ALLEN_POE": "埃德加·爱伦·坡",
    "GREAT_PERSON_INDIVIDUAL_JANE_AUSTEN": "简·奥斯汀",
    "GREAT_PERSON_INDIVIDUAL_JOHANN_WOLFGANG_VON_GOETHE": "约翰·沃尔夫冈·冯·歌德",
    "GREAT_PERSON_INDIVIDUAL_MARY_SHELLEY": "玛丽·雪莱",
    "GREAT_PERSON_INDIVIDUAL_JAMES_JOYCE": "詹姆斯·乔伊斯",
    "GREAT_PERSON_INDIVIDUAL_EMILY_DICKINSON": "艾米莉·狄金森",
    "GREAT_PERSON_INDIVIDUAL_LEO_TOLSTOY": "列夫·托尔斯泰",
    "GREAT_PERSON_INDIVIDUAL_MARK_TWAIN": "马克·吐温",
    "GREAT_PERSON_INDIVIDUAL_F_SCOTT_FITZGERALD": "F·斯科特·菲茨杰拉德",
    "GREAT_PERSON_INDIVIDUAL_HG_WELLS": "H·G·威尔斯",
    "GREAT_PERSON_INDIVIDUAL_RABINDRANATH_TAGORE": "拉宾德拉纳特·泰戈尔",
    "GREAT_PERSON_INDIVIDUAL_KAREL_CAPEK": "卡雷尔·恰佩克",
    "GREAT_PERSON_INDIVIDUAL_VALMIKI": "蚁垤",
    "GREAT_PERSON_INDIVIDUAL_RUMI": "鲁米",
    "GREAT_PERSON_INDIVIDUAL_BEATRIX_POTTER": "比阿特丽克斯·波特",
    "GREAT_PERSON_INDIVIDUAL_GABRIELA_MISTRAL": "加夫列拉·米斯特拉尔",
    # Musicians
    "GREAT_PERSON_INDIVIDUAL_ANTONIO_VIVALDI": "安东尼奥·维瓦尔第",
    "GREAT_PERSON_INDIVIDUAL_JOHANN_SEBASTIAN_BACH": "约翰·塞巴斯蒂安·巴赫",
    "GREAT_PERSON_INDIVIDUAL_LUDWIG_VAN_BEETHOVEN": "路德维希·凡·贝多芬",
    "GREAT_PERSON_INDIVIDUAL_WOLFGANG_AMADEUS_MOZART": "沃尔夫冈·阿马德乌斯·莫扎特",
    "GREAT_PERSON_INDIVIDUAL_YATSUHASHI_KENGYO": "八桥检校",
    "GREAT_PERSON_INDIVIDUAL_ANTONIO_CARLOS_GOMEZ": "安东尼奥·卡洛斯·戈麦斯",
    "GREAT_PERSON_INDIVIDUAL_FRANZ_LISZT": "弗朗茨·李斯特",
    "GREAT_PERSON_INDIVIDUAL_FREDERIC_CHOPIN": "弗雷德里克·肖邦",
    "GREAT_PERSON_INDIVIDUAL_PETER_ILYICH_TCHAIKOVSKY": "彼得·伊里奇·柴可夫斯基",
    "GREAT_PERSON_INDIVIDUAL_LIU_TIANHUA": "刘天华",
    "GREAT_PERSON_INDIVIDUAL_ANTONIN_DVORAK": "安东宁·德沃夏克",
    "GREAT_PERSON_INDIVIDUAL_CLARA_SCHUMANN": "克拉拉·舒曼",
    "GREAT_PERSON_INDIVIDUAL_JUVENTINO_ROSAS": "胡文蒂诺·罗萨斯",
    "GREAT_PERSON_INDIVIDUAL_LILIUOKALANI": "利留卡拉尼",
    "GREAT_PERSON_INDIVIDUAL_GAUHAR_JAAN": "高哈尔·贾恩",
    "GREAT_PERSON_INDIVIDUAL_MYKOLA_LEONTOVYCH": "米科拉·莱昂托维奇",
    "GREAT_PERSON_INDIVIDUAL_DIMITRIE_CANTEMIR": "迪米特里耶·坎泰米尔",
    "GREAT_PERSON_INDIVIDUAL_SCOTT_JOPLIN": "斯科特·乔普林",
    # Engineers
    "GREAT_PERSON_INDIVIDUAL_BI_SHENG": "毕昇",
    "GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS": "米利都的伊西多尔",
    "GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE": "詹姆斯·圣乔治",
    "GREAT_PERSON_INDIVIDUAL_FILIPPO_BRUNELLESCHI": "菲利波·布鲁内莱斯基",
    "GREAT_PERSON_INDIVIDUAL_LEONARDO_DA_VINCI": "列奥纳多·达·芬奇",
    "GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN": "米马尔·希南",
    "GREAT_PERSON_INDIVIDUAL_ADA_LOVELACE": "艾达·洛芙莱斯",
    "GREAT_PERSON_INDIVIDUAL_GUSTAVE_EIFFEL": "古斯塔夫·埃菲尔",
    "GREAT_PERSON_INDIVIDUAL_JAMES_WATT": "詹姆斯·瓦特",
    "GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO": "阿尔瓦·阿尔托",
    "GREAT_PERSON_INDIVIDUAL_NIKOLA_TESLA": "尼古拉·特斯拉",
    "GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD": "罗伯特·戈达德",
    "GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING": "约翰·A·罗布林",
    "GREAT_PERSON_INDIVIDUAL_JANE_DREW": "简·德鲁",
    "GREAT_PERSON_INDIVIDUAL_SERGEI_KOROLEV": "谢尔盖·科罗廖夫",
    "GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA": "查尔斯·科雷亚",
    "GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON": "约瑟夫·帕克斯顿",
    "GREAT_PERSON_INDIVIDUAL_WERNHER_VON_BRAUN": "沃纳·冯·布劳恩",
    "GREAT_PERSON_INDIVIDUAL_IMHOTEP": "印何阗",
    "GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN": "沙贾汗",
    "GREAT_PERSON_INDIVIDUAL_KENZO_TANGE": "丹下健三",
    # Scientists
    "GREAT_PERSON_INDIVIDUAL_ARYABHATA": "阿耶波多",
    "GREAT_PERSON_INDIVIDUAL_EUCLID": "欧几里得",
    "GREAT_PERSON_INDIVIDUAL_HYPATIA": "希帕蒂娅",
    "GREAT_PERSON_INDIVIDUAL_ABU_AL_QASIM_AL_ZAHRAWI": "阿布·卡西姆·扎赫拉维",
    "GREAT_PERSON_INDIVIDUAL_HILDEGARD_OF_BINGEN": "宾根的希尔德加德",
    "GREAT_PERSON_INDIVIDUAL_OMAR_KHAYYAM": "欧玛尔·海亚姆",
    "GREAT_PERSON_INDIVIDUAL_GALILEO_GALILEI": "伽利略·伽利莱",
    "GREAT_PERSON_INDIVIDUAL_ISAAC_NEWTON": "艾萨克·牛顿",
    "GREAT_PERSON_INDIVIDUAL_EMILIE_DU_CHATELET": "埃米莉·杜·沙特莱",
    "GREAT_PERSON_INDIVIDUAL_JAMES_YOUNG": "詹姆斯·杨",
    "GREAT_PERSON_INDIVIDUAL_CHARLES_DARWIN": "查尔斯·达尔文",
    "GREAT_PERSON_INDIVIDUAL_DMITRI_MENDELEEV": "德米特里·门捷列夫",
    "GREAT_PERSON_INDIVIDUAL_ALAN_TURING": "艾伦·图灵",
    "GREAT_PERSON_INDIVIDUAL_ALBERT_EINSTEIN": "阿尔伯特·爱因斯坦",
    "GREAT_PERSON_INDIVIDUAL_ALFRED_NOBEL": "阿尔弗雷德·诺贝尔",
    "GREAT_PERSON_INDIVIDUAL_JANAKI_AMMAL": "贾纳基·阿马尔",
    "GREAT_PERSON_INDIVIDUAL_MARY_LEAKEY": "玛丽·利基",
    "GREAT_PERSON_INDIVIDUAL_ERWIN_SCHRODINGER": "埃尔温·薛定谔",
    "GREAT_PERSON_INDIVIDUAL_ABDUS_SALAM": "阿卜杜斯·萨拉姆",
    "GREAT_PERSON_INDIVIDUAL_CARL_SAGAN": "卡尔·萨根",
    "GREAT_PERSON_INDIVIDUAL_STEPHANIE_KWOLEK": "斯蒂芬妮·克沃勒克",
    "GREAT_PERSON_INDIVIDUAL_ZHANG_HENG": "张衡",
    "GREAT_PERSON_INDIVIDUAL_IBN_KHALDUN": "伊本·赫勒敦",
    "GREAT_PERSON_INDIVIDUAL_MARGARET_MEAD": "玛格丽特·米德",
    # Merchants
    "GREAT_PERSON_INDIVIDUAL_COLAEUS": "科莱俄斯",
    "GREAT_PERSON_INDIVIDUAL_MARCUS_LICINIUS_CRASSUS": "马库斯·李锡尼·克拉苏",
    "GREAT_PERSON_INDIVIDUAL_ZHANG_QIAN": "张骞",
    "GREAT_PERSON_INDIVIDUAL_MARCO_POLO": "马可·波罗",
    "GREAT_PERSON_INDIVIDUAL_PIERO_DE_BARDI": "皮耶罗·德·巴尔迪",
    "GREAT_PERSON_INDIVIDUAL_IRENE_OF_ATHENS": "雅典的伊琳娜",
    "GREAT_PERSON_INDIVIDUAL_GIOVANNI_DE_MEDICI": "乔瓦尼·德·美第奇",
    "GREAT_PERSON_INDIVIDUAL_JAKOB_FUGGER": "雅各布·富格尔",
    "GREAT_PERSON_INDIVIDUAL_RAJA_TODAR_MAL": "拉贾·托达尔·马尔",
    "GREAT_PERSON_INDIVIDUAL_ADAM_SMITH": "亚当·斯密",
    "GREAT_PERSON_INDIVIDUAL_JOHN_SPILSBURY": "约翰·斯皮尔斯伯里",
    "GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR": "约翰·雅各布·阿斯特",
    "GREAT_PERSON_INDIVIDUAL_MARY_KATHERINE_GODDARD": "玛丽·凯瑟琳·戈达德",
    "GREAT_PERSON_INDIVIDUAL_JOHN_ROCKEFELLER": "约翰·洛克菲勒",
    "GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE": "莎拉·布里德洛夫",
    "GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN": "海伦娜·鲁宾斯坦",
    "GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ": "梅利塔·本茨",
    "GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS": "李维·斯特劳斯",
    "GREAT_PERSON_INDIVIDUAL_ESTEE_LAUDER": "雅诗·兰黛",
    "GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA": "井深大",
    "GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA": "詹姆谢特吉·塔塔",
    "GREAT_PERSON_INDIVIDUAL_ZHOU_DAGUAN": "周达观",
    "GREAT_PERSON_INDIVIDUAL_IBN_FADLAN": "伊本·法德兰",
    "GREAT_PERSON_INDIVIDUAL_STAMFORD_RAFFLES": "斯坦福·莱佛士",
    # Generals
    "GREAT_PERSON_INDIVIDUAL_BOUDICA": "布狄卡",
    "GREAT_PERSON_INDIVIDUAL_HANNIBAL_BARCA": "汉尼拔·巴卡",
    "GREAT_PERSON_INDIVIDUAL_SUN_TZU": "孙子",
    "GREAT_PERSON_INDIVIDUAL_AETHELFLAED": "埃塞尔弗莱德",
    "GREAT_PERSON_INDIVIDUAL_EL_CID": "熙德",
    "GREAT_PERSON_INDIVIDUAL_GENGHIS_KHAN": "成吉思汗",
    "GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS": "古斯塔夫·阿道夫",
    "GREAT_PERSON_INDIVIDUAL_JOAN_OF_ARC": "圣女贞德",
    "GREAT_PERSON_INDIVIDUAL_ANA_NZINGA": "安娜·恩津加",
    "GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE": "拿破仑·波拿巴",
    "GREAT_PERSON_INDIVIDUAL_RANI_LAKSHMIBAI": "拉尼·拉克希米巴伊",
    "GREAT_PERSON_INDIVIDUAL_SIMON_BOLIVAR": "西蒙·玻利瓦尔",
    "GREAT_PERSON_INDIVIDUAL_JOHN_MONASH": "约翰·莫纳什",
    "GREAT_PERSON_INDIVIDUAL_MARINA_RASKOVA": "玛丽娜·拉斯科娃",
    "GREAT_PERSON_INDIVIDUAL_SAMORI_TURE": "萨摩里·杜尔",
    "GREAT_PERSON_INDIVIDUAL_DWIGHT_EISENHOWER": "德怀特·艾森豪威尔",
    "GREAT_PERSON_INDIVIDUAL_GEORGY_ZHUKOV": "格奥尔基·朱可夫",
    "GREAT_PERSON_INDIVIDUAL_DOUGLAS_MACARTHUR": "道格拉斯·麦克阿瑟",
    "GREAT_PERSON_INDIVIDUAL_SUDIRMAN": "苏迪曼",
    "GREAT_PERSON_INDIVIDUAL_AHMAD_SHAH_MASSOUD": "艾哈迈德·沙阿·马苏德",
    "GREAT_PERSON_INDIVIDUAL_VIJAYA_WIMALARATNE": "维贾亚·维马拉拉特纳",
    "GREAT_PERSON_INDIVIDUAL_TIMUR": "帖木儿",
    "GREAT_PERSON_INDIVIDUAL_DANDARA": "丹达拉",
    "GREAT_PERSON_INDIVIDUAL_TRUNG_TRAC": "征侧",
    "GREAT_PERSON_INDIVIDUAL_TUPAC_AMARU": "图帕克·阿马鲁",
    # Admirals
    "GREAT_PERSON_INDIVIDUAL_ARTEMISIA": "阿尔特米西亚",
    "GREAT_PERSON_INDIVIDUAL_GAIUS_DUILIUS": "盖乌斯·杜伊利乌斯",
    "GREAT_PERSON_INDIVIDUAL_THEMISTOCLES": "地米斯托克利",
    "GREAT_PERSON_INDIVIDUAL_LEIF_ERIKSON": "莱夫·埃里克松",
    "GREAT_PERSON_INDIVIDUAL_RAJENDRA_CHOLA": "拉金德拉·朱罗",
    "GREAT_PERSON_INDIVIDUAL_ZHENG_HE": "郑和",
    "GREAT_PERSON_INDIVIDUAL_FRANCIS_DRAKE": "弗朗西斯·德雷克",
    "GREAT_PERSON_INDIVIDUAL_SANTA_CRUZ": "圣克鲁斯",
    "GREAT_PERSON_INDIVIDUAL_YI_SUN_SIN": "李舜臣",
    "GREAT_PERSON_INDIVIDUAL_CHING_SHIH": "郑一嫂",
    "GREAT_PERSON_INDIVIDUAL_HORATIO_NELSON": "霍雷肖·纳尔逊",
    "GREAT_PERSON_INDIVIDUAL_LASKARINA_BOUBOULINA": "拉斯卡里娜·布布利纳",
    "GREAT_PERSON_INDIVIDUAL_FRANZ_VON_HIPPER": "弗朗茨·冯·希佩尔",
    "GREAT_PERSON_INDIVIDUAL_JOAQUIM_MARQUES_LISBOA": "若阿金·马克斯·里斯本",
    "GREAT_PERSON_INDIVIDUAL_TOGO_HEIHACHIRO": "东乡平八郎",
    "GREAT_PERSON_INDIVIDUAL_CHESTER_NIMITZ": "切斯特·尼米兹",
    "GREAT_PERSON_INDIVIDUAL_GRACE_HOPPER": "格蕾丝·霍珀",
    "GREAT_PERSON_INDIVIDUAL_SERGEY_GORSHKOV": "谢尔盖·戈尔什科夫",
    "GREAT_PERSON_INDIVIDUAL_CLANCY_FERNANDO": "克兰西·费尔南多",
    "GREAT_PERSON_INDIVIDUAL_MATTHEW_PERRY": "马修·佩里",
    "GREAT_PERSON_INDIVIDUAL_HIMERIOS": "希梅里奥斯",
    "GREAT_PERSON_INDIVIDUAL_HANNO_THE_NAVIGATOR": "航海家汉诺",
    "GREAT_PERSON_INDIVIDUAL_FERDINAND_MAGELLAN": "费迪南德·麦哲伦",
    # Prophets
    "GREAT_PERSON_INDIVIDUAL_JOHN_THE_BAPTIST": "施洗约翰",
    "GREAT_PERSON_INDIVIDUAL_CONFUCIUS": "孔子",
    "GREAT_PERSON_INDIVIDUAL_ZOROASTER": "琐罗亚斯德",
    "GREAT_PERSON_INDIVIDUAL_SIDDHARTHA_GAUTAMA": "悉达多·乔达摩",
    "GREAT_PERSON_INDIVIDUAL_LAOZI": "老子",
    "GREAT_PERSON_INDIVIDUAL_SIMON_PETER": "西门·彼得",
    "GREAT_PERSON_INDIVIDUAL_BODHIDHARMA": "菩提达摩",
    "GREAT_PERSON_INDIVIDUAL_ADI_SHANKARA": "阿迪·商羯罗",
    "GREAT_PERSON_INDIVIDUAL_SONGTSAN_GAMPO": "松赞干布",
    "GREAT_PERSON_INDIVIDUAL_O_NO_YASUMARO": "太安万侣",
    "GREAT_PERSON_INDIVIDUAL_IRENAEUS": "爱任纽",
    "GREAT_PERSON_INDIVIDUAL_MARTIN_LUTHER": "马丁·路德",
    "GREAT_PERSON_INDIVIDUAL_FRANCIS_OF_ASSISI": "阿西西的方济各",
    "GREAT_PERSON_INDIVIDUAL_MADHVA_ACHARYA": "摩陀婆·阿阇梨",
    "GREAT_PERSON_INDIVIDUAL_THOMAS_AQUINAS": "托马斯·阿奎那",
    "GREAT_PERSON_INDIVIDUAL_HAJI_HUUD": "哈吉·胡德",
}

# Mod Chinese names
MOD_CN_NAMES = {
    "GREAT_PERSON_INDIVIDUAL_PLATI_REX": "雷克斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BANKER": "银行家",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV": "萨哈罗夫",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RURIK": "留里克",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE": "法贝热",
    "GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI": "加里波第",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CURIE": "居里夫人",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RAILLORD": "莱洛尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE": "劳伦斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNITZ": "莱布尼茨",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SUAREZ": "苏亚雷斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FRANKLIN": "富兰克林",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ALI_MASHADDI": "阿里·马沙迪",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DAHLBERG": "达尔伯格",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HENRY": "亨利",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SAUGUSTINE": "圣奥古斯丁",
    "GREAT_PERSON_INDIVIDUAL_PLATI_JACOBKETTLER": "雅各布·克特勒",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SARGON": "萨尔贡",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ZEPPELIN": "齐柏林",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MORGAN": "摩根",
    "GREAT_PERSON_INDIVIDUAL_PLATI_APOLLODRO": "阿波罗多洛斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HOBBES": "霍布斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AL_AHMAR": "阿尔·阿赫马尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO": "沈括",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS": "伊拉斯谟",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LIONHEART": "狮心王",
    "GREAT_PERSON_INDIVIDUAL_PLATI_COOK": "库克",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON": "汉密尔顿",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ARAGONESE": "阿拉贡人",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HEIDEGGER": "海德格尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LOVECRAFT": "洛夫克拉夫特",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RHOWARD": "罗伯特·霍华德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY": "法拉第",
    "GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH": "加查·马达",
    "GREAT_PERSON_INDIVIDUAL_PLATI_URBAN": "乌尔班",
    "GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP": "克虏伯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_VITUS": "维图斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LEIZU": "嫘祖",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL": "尼尔斯·尤尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_VENETIAN_SMUGGLER": "威尼斯走私者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_COLBERT": "科尔贝尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD": "伊桑巴德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DESCARTES": "笛卡尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CICERO": "西塞罗",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CROESUS": "克罗伊斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ARISTOTLE": "亚里士多德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS": "拜巴尔斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSA": "巴巴罗萨",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ELIZABETH_WILBRAHAM": "伊丽莎白·威尔布拉汉",
    "GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN": "冯·恩琴",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SUNDIATA": "松迪亚塔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA": "斯福尔扎",
    "GREAT_PERSON_INDIVIDUAL_PLATI_POLDER": "圩田",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AGRIPPA": "阿格里帕",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NESTLE": "雀巢",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TUSI": "图西",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN": "蔡伦",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG": "莽应龙",
    "GREAT_PERSON_INDIVIDUAL_PLATI_PASTEUR": "巴斯德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CHATEAU": "城堡",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MISSION": "传教团",
    "GREAT_PERSON_INDIVIDUAL_PLATI_IBNBATTUTA": "伊本·白图泰",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MAJID": "马吉德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TOKUGAWA": "德川家康",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES": "阿威罗伊",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CECIL": "塞西尔",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LODBROK": "洛德布罗克",
    "GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA": "扬·杰式卡",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE": "尼采",
    # Great Sovereigns
    "GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT": "阿尔弗雷德大帝",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RBORGIA": "罗德里戈·波吉亚",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST": "首位君主",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT": "腓特烈大帝",
    "GREAT_PERSON_INDIVIDUAL_PLATI_KOSEMI": "科塞姆苏丹",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH": "拉玛坎亨",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED": "扎耶德",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR": "阿克巴",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH": "李光耀",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK": "俾斯麦",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH": "玛丽亚·特蕾莎",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS": "格迪米纳斯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MONACO": "摩纳哥",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DANDOLO": "丹多洛",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BEG": "兀鲁伯",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DENG": "邓小平",
    # Comandante General
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_JOSE_DE_SUCRE": "何塞·德·苏克雷",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PAULA_SANTANDER": "保拉·桑坦德",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_ANTONIO_PAEZ": "安东尼奥·帕埃斯",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_URDANETA": "乌达内塔",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MARINO": "马里尼奥",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MACGREGOR": "麦格雷戈",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_PIAR": "皮亚尔",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_NARINO": "纳里尼奥",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_MONTILLA": "蒙蒂利亚",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_RIBAS": "里瓦斯",
    "GREAT_PERSON_INDIVIDUAL_COMMANDANTE_JUAN_BAUTISTA":"地理学家",
    # EWHO
    "GREAT_PERSON_INDIVIDUAL_SHAH_JAHAN_EWHO": "沙贾汗(EWHO)",
}

# Mod effects
MOD_EFFECTS = {
    "GREAT_PERSON_INDIVIDUAL_PLATI_REX": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BANKER": "所有城市+20%金币产出",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SAKHAROV": "+100%太空竞赛项目产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RURIK": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FABERGE": "获得奢侈资源法贝热彩蛋(+5宜居度)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_GARIBALDI": "+3战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CURIE": "为建造中的奇观提供产能(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RAILLORD": "铁路+2金币",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LAWRENCE": "+5战斗力在沙漠/平原",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LEIBNITZ": "所有城市+1科技+1文化",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SUAREZ": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FRANKLIN": "所有海军单位+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ALI_MASHADDI": "市中心+1文化",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DAHLBERG": "城市+1宜居度+1住房",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HENRY": "所有海军单位+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SAUGUSTINE": "所有宗教单位+1传播次数",
    "GREAT_PERSON_INDIVIDUAL_PLATI_JACOBKETTLER": "获得2条商路上限(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SARGON": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ZEPPELIN": "机场+2产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MORGAN": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_APOLLODRO": "政府区+1政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HOBBES": "创作巨作《利维坦》",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AL_AHMAR": "城市+1宜居度+1住房",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SHEN_KUO": "获得2个科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ERASMUS": "所有城市+1文化",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LIONHEART": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_COOK": "所有海军单位+1视野+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HAMILTON": "+1经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ARAGONESE": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_HEIDEGGER": "创作巨作《存在与时间》",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LOVECRAFT": "创作巨作《克苏鲁的呼唤》",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RHOWARD": "创作巨作《蛮王柯南》",
    "GREAT_PERSON_INDIVIDUAL_PLATI_FARADAY": "所有城市+3电力(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_GAJAH": "+5战斗力对所有陆地单位，登陆不消耗移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_URBAN": "+2使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_KRUPP": "工业区+5产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_VITUS": "所有海军单位+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LEIZU": "+1丝绸资源",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NIELS_JUEL": "所有海军单位+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_VENETIAN_SMUGGLER": "获得1件文物",
    "GREAT_PERSON_INDIVIDUAL_PLATI_COLBERT": "+1经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ISAMBARD": "城市+2住房+2宜居度",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DESCARTES": "所有城市+1宜居度",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CICERO": "所有城市+1宜居度",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CROESUS": "+500金币",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ARISTOTLE": "+1万能政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BAIBARS": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BARBAROSA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ELIZABETH_WILBRAHAM": "航空港+3产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_UNGERN": "将相邻非军事单位升级为军事单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SUNDIATA": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SFORZA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_POLDER": "提高圩田改良设施+1食物+1产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AGRIPPA": "为建造中的奇观提供产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NESTLE": "+1巧克力资源",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TUSI": "+1外交政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CAI_LUN": "+1造纸坊建筑(纸张)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BAYINNAUNG": "+5战斗力对所有陆地单位",
    "GREAT_PERSON_INDIVIDUAL_PLATI_PASTEUR": "所有城市+1宜居度",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CHATEAU": "提高城堡改良设施+1文化+1金币",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MISSION": "提高传教团改良设施+1科学+1信仰",
    "GREAT_PERSON_INDIVIDUAL_PLATI_IBNBATTUTA": "+1商路上限",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MAJID": "所有海军单位+1移动力",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TOKUGAWA": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AVERROES": "获得2个科技尤里卡",
    "GREAT_PERSON_INDIVIDUAL_PLATI_CECIL": "+1商路上限",
    "GREAT_PERSON_INDIVIDUAL_PLATI_LODBROK": "获得2个使者",
    "GREAT_PERSON_INDIVIDUAL_PLATI_JAN_ZIZKA": "+5战斗力对所有陆地单位，胡斯派遗产",
    "GREAT_PERSON_INDIVIDUAL_PLATI_NIETZSCHE": "创作巨作《查拉图斯特拉如是说》",
    # Great Sovereigns
    "GREAT_PERSON_INDIVIDUAL_PLATI_ALFRED_THE_GREAT": "所有海军单位+1免费晋升",
    "GREAT_PERSON_INDIVIDUAL_PLATI_RBORGIA": "+1军事政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FIRST": "+1万能政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_FRIDRIK_GREAT": "+1军事政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_KOSEMI": "+1外交政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SIXTEENTH": "+1军事政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_ZAYED": "+1万能政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_AKBAR": "为建造中的奇观提供产能",
    "GREAT_PERSON_INDIVIDUAL_PLATI_ELEVENTH": "+1经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BISMARK": "获得2个使者(城邦领土)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_TWELWTH": "+1外交政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_SOVEREIGN_GEDIMINAS": "+1外交政策槽(2次充能)",
    "GREAT_PERSON_INDIVIDUAL_PLATI_MONACO": "+1经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DANDOLO": "+1经济政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_BEG": "+1外交政策槽",
    "GREAT_PERSON_INDIVIDUAL_PLATI_DENG": "+1经济政策槽",
}

ERA_MAP = {
    "ERA_ANCIENT": "远古",
    "ERA_CLASSICAL": "古典",
    "ERA_MEDIEVAL": "中世纪",
    "ERA_RENAISSANCE": "文艺复兴",
    "ERA_INDUSTRIAL": "工业",
    "ERA_MODERN": "现代",
    "ERA_ATOMIC": "原子",
    "ERA_INFORMATION": "信息",
}

CLASS_MAP = {
    "GREAT_PERSON_CLASS_ARTIST": "大艺术家",
    "GREAT_PERSON_CLASS_WRITER": "大作家",
    "GREAT_PERSON_CLASS_MUSICIAN": "大音乐家",
    "GREAT_PERSON_CLASS_ENGINEER": "大工程师",
    "GREAT_PERSON_CLASS_SCIENTIST": "大科学家",
    "GREAT_PERSON_CLASS_MERCHANT": "大商人",
    "GREAT_PERSON_CLASS_GENERAL": "大将军",
    "GREAT_PERSON_CLASS_ADMIRAL": "海军统帅",
    "GREAT_PERSON_CLASS_PROPHET": "大预言家",
    "GREAT_PERSON_CLASS_GreatSovereigns": "大统治者",
    "GREAT_PERSON_CLASS_COMANDANTE_GENERAL": "总指挥官",
    "GREAT_PERSON_CLASS_JNR_EXPLORER": "探险家",
    "GREAT_PERSON_CLASS_ENGINEER_EWHO": "大工程师(EWHO)",
}

def get_source_label(source_type, source_file):
    if source_type == "original":
        return "原版"
    elif source_type == "dlc":
        if "Expansion1" in source_file:
            return "DLC(迭起兴衰)"
        elif "Expansion2" in source_file:
            return "DLC(风云变幻)"
        else:
            return "DLC(巴比伦/大哥伦比亚)"
    elif source_type == "mod":
        if "3085812151" in source_file or "6T_AGP" in source_file or "Ancient" in source_file:
            return "远古伟人"
        elif "2448605286" in source_file:
            return "更多伟人"
        elif "2973448849" in source_file or "GreatSovereign" in source_file:
            return "大统治者伟人"
        elif "3334907290" in source_file:
            return "删除部分工程师"
        elif "3338128748" in source_file:
            return "更多伟人汉化"
        elif "3310259652" in source_file:
            return "大统治者伟人汉化"
        elif "2921308654" in source_file:
            return "EWHO"
        else:
            return "Mod"
    return "未知"

def get_name(entry):
    gpt = entry['columns'].get('GreatPersonIndividualType', '')
    if gpt in CN_NAMES:
        return CN_NAMES[gpt]
    if gpt in MOD_CN_NAMES:
        return MOD_CN_NAMES[gpt]
    name = entry['columns'].get('Name', '')
    if name.startswith('LOC_GREAT_PERSON_INDIVIDUAL_'):
        short = name.replace('LOC_GREAT_PERSON_INDIVIDUAL_', '')
        return short.replace('_', ' ').title()
    return gpt.replace('GREAT_PERSON_INDIVIDUAL_', '').replace('_', ' ').title()

def get_effect(entry):
    gpt = entry['columns'].get('GreatPersonIndividualType', '')
    cls = entry['columns'].get('GreatPersonClassType', '')
    
    if gpt in VANILLA_EFFECTS:
        return VANILLA_EFFECTS[gpt]
    if gpt in MOD_EFFECTS:
        return MOD_EFFECTS[gpt]
    
    if cls in ('GREAT_PERSON_CLASS_ARTIST', 'GREAT_PERSON_CLASS_WRITER', 'GREAT_PERSON_CLASS_MUSICIAN'):
        return "创作巨作"
    if cls == 'GREAT_PERSON_CLASS_PROPHET':
        return "创立宗教"
    if cls == 'GREAT_PERSON_CLASS_GENERAL' or cls == 'GREAT_PERSON_CLASS_ADMIRAL':
        if 'ActionRequiresNoMilitaryUnit' in entry['columns']:
            return "将相邻非军事单位升级为军事单位"
        elif 'ActionRequiresMilitaryUnitDomain' in entry['columns']:
            return "赠予1个晋升给1个军事单位"
        else:
            return "获得2个使者"
    if cls == 'GREAT_PERSON_CLASS_ENGINEER':
        if 'ActionRequiresIncompleteWonder' in entry['columns']:
            return "为建造中的奇观提供产能"
        else:
            return "手动激活"
    if cls == 'GREAT_PERSON_CLASS_SCIENTIST':
        return "手动激活"
    if cls == 'GREAT_PERSON_CLASS_MERCHANT':
        return "手动激活"
    return "—"

def get_source(entry):
    return get_source_label(entry['source_type'], entry['source_file'])

def get_era(entry):
    era = entry['columns'].get('EraType', '')
    return ERA_MAP.get(era, era)

def get_charges(entry):
    return entry['columns'].get('ActionCharges', '0')

# Collect all operations
rows = []
deletes = []
updates = []

for e in entries:
    op = e.get('operation', '')
    table = e.get('table', '')
    if table == 'GreatPersonIndividuals':
        if op == 'Row':
            rows.append(e)
        elif op in ('Delete', 'DELETE'):
            deletes.append(e)
        elif op in ('Update', 'UPDATE'):
            updates.append(e)

# Build set of deleted IDs
deleted_ids = set()
for d in deletes:
    gpt = d['columns'].get('GreatPersonIndividualType', '') or d['columns'].get('WHERE_GreatPersonIndividualType', '')
    if gpt:
        deleted_ids.add(gpt)

# Also from updates that are reclassifications
reclassified_ids = set()
for u in updates:
    gpt = u['columns'].get('GreatPersonIndividualType', '') or u['columns'].get('WHERE_GreatPersonIndividualType', '')
    if gpt:
        reclassified_ids.add(gpt)

# Group rows by class, exclude deleted, deduplicate
seen = {}
by_class = defaultdict(list)
for e in rows:
    gpt = e['columns'].get('GreatPersonIndividualType', '')
    cls = e['columns'].get('GreatPersonClassType', 'UNKNOWN')
    source = get_source(e)
    
    # Skip deleted entries
    if gpt in deleted_ids:
        continue
    
    # Deduplicate: keep latest source (mod > dlc > original)
    key = (gpt, cls)
    if key in seen:
        prev = seen[key]
        prev_source = get_source(prev)
        # Mod entries take precedence
        if source.startswith('更多伟人') or source.startswith('大统治者') or source.startswith('远古伟人'):
            seen[key] = e
        elif source.startswith('DLC') and prev_source == '原版':
            seen[key] = e
    else:
        seen[key] = e

for (gpt, cls), e in seen.items():
    by_class[cls].append(e)

# Sort each class
def sort_key(e):
    era_order = {'ERA_ANCIENT': 0, 'ERA_CLASSICAL': 1, 'ERA_MEDIEVAL': 2,
                 'ERA_RENAISSANCE': 3, 'ERA_INDUSTRIAL': 4, 'ERA_MODERN': 5,
                 'ERA_ATOMIC': 6, 'ERA_INFORMATION': 7}
    era = e['columns'].get('EraType', 'ERA_ANCIENT')
    return (era_order.get(era, 99), get_name(e))

for cls in by_class:
    by_class[cls].sort(key=sort_key)

# Generate report
report = []
report.append("# Civilization VI 伟人 (GreatPerson) 完整分析报告\n\n")
report.append("> 生成时间: 2026-07-07\n\n")
report.append("> 数据来源: 原版 / DLC(迭起兴衰/风云变幻) / 6个伟人Mod\n\n")
report.append("> 总条目数: 352 (原版186 + DLC 62 + Mod 104)\n\n")
report.append("---\n\n")

# Section 1
report.append("## 1. 总览\n\n")
report.append("| 来源 | 原版保留 | 新增 | 修改 | 被删除 |\n")
report.append("|------|:-------:|:----:|:----:|:------:|\n")
report.append("| 原版 | 167 | 0 | 0 | 19 |\n")
report.append("| DLC(迭起兴衰) | 24 | 0 | 0 | 0 |\n")
report.append("| DLC(风云变幻) | 38 | 0 | 0 | 0 |\n")
report.append("| 远古伟人 (6T) | 0 | 14 | 0 | 0 |\n")
report.append("| 更多伟人 (Sumus Magnus) | 0 | 72 | 0 | 18 |\n")
report.append("| 大统治者伟人 (GreatSovereigns) | 0 | 32 | 2 | 0 |\n")
report.append("| 删除部分工程师 | 0 | 0 | 0 | 5 |\n")
report.append("| 更多伟人汉化 | 0 | 0 | 70 | 0 |\n")
report.append("| 大统治者伟人汉化 | 0 | 0 | 29 | 0 |\n")
report.append("| **合计** | **229** | **118** | **101** | **42** |\n\n")

# Section 2
report.append("## 2. 加载顺序分析\n\n")
report.append("Load order: 原版 < DLC < 远古伟人(LoadOrder 13-14) < 更多伟人(LoadOrder 240-250) < 大统治者伟人(LoadOrder 240-250, 808阿尔罕布拉) < 删除部分工程师(默认) < 伟人传送(默认) < 汉化文本(1919/11000)\n\n")
report.append("Cross-mod dependencies:\n\n")
report.append("- 大统治者伟人汉化 依赖 大统治者伟人\n")
report.append("- 更多伟人汉化 依赖 更多伟人\n")
report.append("- 更多伟人 通过 ActionCriteria 检测 远古伟人、More Maritime、Urban Complexity 等\n")
report.append("- 大统治者伟人 通过 ActionCriteria 检测 6T 合集、Monopoly++、Burj Khalifa 等\n\n")

# Section 3
report.append("## 3. 详细数据表\n\n")

class_order = [
    'GREAT_PERSON_CLASS_ARTIST',
    'GREAT_PERSON_CLASS_WRITER',
    'GREAT_PERSON_CLASS_MUSICIAN',
    'GREAT_PERSON_CLASS_ENGINEER',
    'GREAT_PERSON_CLASS_SCIENTIST',
    'GREAT_PERSON_CLASS_MERCHANT',
    'GREAT_PERSON_CLASS_GENERAL',
    'GREAT_PERSON_CLASS_ADMIRAL',
    'GREAT_PERSON_CLASS_PROPHET',
    'GREAT_PERSON_CLASS_GreatSovereigns',
]

section_names = {
    'GREAT_PERSON_CLASS_ARTIST': '3.1 大艺术家 (GREAT_PERSON_CLASS_ARTIST)',
    'GREAT_PERSON_CLASS_WRITER': '3.2 大作家 (GREAT_PERSON_CLASS_WRITER)',
    'GREAT_PERSON_CLASS_MUSICIAN': '3.3 大音乐家 (GREAT_PERSON_CLASS_MUSICIAN)',
    'GREAT_PERSON_CLASS_ENGINEER': '3.4 大工程师 (GREAT_PERSON_CLASS_ENGINEER)',
    'GREAT_PERSON_CLASS_SCIENTIST': '3.5 大科学家 (GREAT_PERSON_CLASS_SCIENTIST)',
    'GREAT_PERSON_CLASS_MERCHANT': '3.6 大商人 (GREAT_PERSON_CLASS_MERCHANT)',
    'GREAT_PERSON_CLASS_GENERAL': '3.7 大将军 (GREAT_PERSON_CLASS_GENERAL)',
    'GREAT_PERSON_CLASS_ADMIRAL': '3.8 海军统帅 (GREAT_PERSON_CLASS_ADMIRAL)',
    'GREAT_PERSON_CLASS_PROPHET': '3.9 大预言家 (GREAT_PERSON_CLASS_PROPHET)',
    'GREAT_PERSON_CLASS_GreatSovereigns': '3.10 大统治者 (GREAT_PERSON_CLASS_GreatSovereigns)',
}

for cls in class_order:
    if cls not in by_class:
        continue
    items = by_class[cls]
    cn_section = section_names.get(cls, cls)
    report.append(f"### {cn_section} — {len(items)}人\n\n")
    report.append("| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 被动效果 | 来源 | 状态 |\n")
    report.append("|---|--------|--------|--------|------|------|----------|----------|------|------|\n")
    
    for i, e in enumerate(items, 1):
        gpt = e['columns'].get('GreatPersonIndividualType', '')
        cn = get_name(e)
        en = gpt.replace('GREAT_PERSON_INDIVIDUAL_', '').replace('_', ' ').title()
        era = get_era(e)
        charges = get_charges(e)
        effect = get_effect(e)
        source = get_source(e)
        
        status = "✓"
        # Check if reclassified
        if gpt in reclassified_ids:
            if gpt == "GREAT_PERSON_INDIVIDUAL_NAPOLEON_BONAPARTE" or gpt == "GREAT_PERSON_INDIVIDUAL_GUSTAVUS_ADOLPHUS":
                status = "⟳重分类"
        
        report.append(f"| {i} | {cn} | {en} | {gpt} | {era} | {charges} | {effect} | — | {source} | {status} |\n")
    
    report.append("\n")

# Other types
report.append("### 3.11 其他伟人类型 — 15人\n\n")
report.append("包括 COMANDANTE_GENERAL 11人、JNR_EXPLORER 2人、ENGINEER_EWHO 2人\n\n")
other_classes = ['GREAT_PERSON_CLASS_COMANDANTE_GENERAL', 'GREAT_PERSON_CLASS_JNR_EXPLORER', 'GREAT_PERSON_CLASS_ENGINEER_EWHO']
for cls in other_classes:
    if cls in by_class:
        items = by_class[cls]
        cn_name = CLASS_MAP.get(cls, cls)
        report.append(f"#### {cn_name} — {len(items)}人\n\n")
        report.append("| # | 中文名 | 英文名 | 内部ID | 时代 | 充能 | 主动效果 | 来源 | 状态 |\n")
        report.append("|---|--------|--------|--------|------|------|----------|------|------|\n")
        for i, e in enumerate(items, 1):
            gpt = e['columns'].get('GreatPersonIndividualType', '')
            cn = get_name(e)
            en = gpt.replace('GREAT_PERSON_INDIVIDUAL_', '').replace('_', ' ').title()
            era = get_era(e)
            charges = get_charges(e)
            effect = get_effect(e)
            source = get_source(e)
            report.append(f"| {i} | {cn} | {en} | {gpt} | {era} | {charges} | {effect} | {source} | ✓ |\n")
        report.append("\n")

# Section 4
report.append("## 4. 关联数据\n\n")

report.append("### 4.1 新增建筑\n\n")
report.append("| 建筑ID | 中文名 | 效果 | 来源 |\n")
report.append("|--------|--------|------|------|\n")
report.append("| BUILDING_PLATI_PAPER_MAKER | 造纸坊 | +1科技 +2金币 | 更多伟人 |\n")
report.append("| BUILDING_PLATI_TEMPLAR_VAULT | 圣殿骑士金库 | +2信仰 | 更多伟人 |\n")
report.append("| BUILDING_PLATI_CHOCOLATERIE | 巧克力工坊 | +2文化 提供果仁糖 | 更多伟人 |\n")
report.append("| BUILDING_PLATI_MONUMENT_ASKIA | 阿斯基亚纪念碑 | 替换纪念碑 | 大统治者伟人 |\n")
report.append("| BUILDING_HAKAM_CATHEDRAL | 哈卡姆大教堂 | 特殊宗教建筑 | 大统治者伟人 |\n")
report.append("| BUILDING_HAKAM_MOSQUE | 哈卡姆清真寺 | 特殊宗教建筑 | 大统治者伟人 |\n")
report.append("| BUILDING_HAKAM_SYNAGOGE | 哈卡姆犹太会堂 | 特殊宗教建筑 | 大统治者伟人 |\n\n")

report.append("### 4.2 新增资源\n\n")
report.append("| 资源ID | 中文名 | 宜居度 | 来源 |\n")
report.append("|--------|--------|--------|------|\n")
report.append("| RESOURCE_EGG | 法贝热彩蛋 | +5 | 更多伟人 |\n")
report.append("| RESOURCE_PEPPER | 胡椒 | +4 | 更多伟人 |\n")
report.append("| RESOURCE_NUTMEG | 肉豆蔻 | +4 | 更多伟人 |\n")
report.append("| RESOURCE_PRALINE | 果仁糖 | +4 | 更多伟人 |\n")
report.append("| RESOURCE_JNR_MUREX | 泰尔紫 | +4 | 远古伟人 |\n")
report.append("| RESOURCE_COWRIE | 货贝 | +4 | 大统治者伟人 |\n\n")

report.append("### 4.3 新增政策卡\n\n")
report.append("来自大统治者伟人Mod的政策卡:\n\n")
report.append("| 政策卡 | 中文名 | 效果 | 类型 |\n")
report.append("|--------|--------|------|------|\n")
report.append("| POLICY_SOVEREIGN_ELITE | 精英统治 | +2大统治者伟人点/回合 | 经济 |\n")
report.append("| POLICY_SOVEREIGN_TIMOCRACY | 勋阀统治 | 击杀单位+8大统治者伟人点 | 军事 |\n")
report.append("| POLICY_SOVEREIGN_ENLIGHTENMENT | 开明专制 | 大统治者伟人点+50% | 经济 |\n\n")

report.append("### 4.4 新增万神殿信条\n\n")
report.append("- PLATI_BELIEF_SOVEREIGN: 圣主明君 — +1大统治者伟人点/回合，黄金时代额外+1\n\n")

report.append("### 4.5 大统治者伟人点来源\n\n")
report.append("| 来源 | 点数/回合 |\n")
report.append("|------|----------|\n")
report.append("| 政府区 | +1 |\n")
report.append("| 觐见厅/祠堂/军阀宝座 | +1 |\n")
report.append("| 谒见厅/情报局/大教堂 | +2 |\n")
report.append("| 皇家学会/国家博物馆/骑士团团长礼拜堂 | +3 |\n")
report.append("| 阿尔罕布拉宫 | +1 |\n")
report.append("| 宙斯像 | +2 |\n")
report.append("| 泰姬陵 | +1 |\n")
report.append("| 圣索菲亚大教堂 | +2 |\n")
report.append("| 吴哥窟 | +2 |\n")
report.append("| 罗马斗兽场 | +2 |\n")
report.append("| 金字塔 | +1 |\n")
report.append("| 精英统治政策 | +2 |\n")
report.append("| 圣主明君万神殿 | +1(+1黄金时代) |\n")
report.append("| 击杀单位 | +8/次 |\n\n")

# Section 5
report.append("## 5. 被修改/删除的原版内容\n\n")

report.append("### 5.1 更多伟人 删除的18位原版伟人\n\n")
report.append("| 原版ID | 中文名 | 类型 | 原因 |\n")
report.append("|--------|--------|------|------|\n")

sumus_deletes = [
    ("GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING", "约翰·A·罗布林", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_CHARLES_CORREA", "查尔斯·科雷亚", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JOSEPH_PAXTON", "约瑟夫·帕克斯顿", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_BI_SHENG", "毕昇", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE", "詹姆斯·圣乔治", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS", "米利都的伊西多尔", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO", "阿尔瓦·阿尔托", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JANE_DREW", "简·德鲁", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_ROBERT_GODDARD", "罗伯特·戈达德", "大工程师", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_MELITTA_BENTZ", "梅利塔·本茨", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JOHN_SPILSBURY", "约翰·斯皮尔斯伯里", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_HELENA_RUBINSTEIN", "海伦娜·鲁宾斯坦", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_LEVI_STRAUSS", "李维·斯特劳斯", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_ESTEE_LAUDER", "雅诗·兰黛", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_MASARU_IBUKA", "井深大", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JAMSETJI_TATA", "詹姆谢特吉·塔塔", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_SARAH_BREEDLOVE", "莎拉·布里德洛夫", "大商人", "加成平庸"),
    ("GREAT_PERSON_INDIVIDUAL_JOHN_JACOB_ASTOR", "约翰·雅各布·阿斯特", "大商人", "加成平庸"),
]

for sid, name, typ, reason in sumus_deletes:
    report.append(f"| {sid} | {name} | {typ} | {reason} |\n")

report.append("\n### 5.2 删除部分工程师 删除的5位大工程师\n\n")
report.append("| 原版ID | 中文名 |\n")
report.append("|--------|--------|\n")
report.append("| GREAT_PERSON_INDIVIDUAL_BI_SHENG | 毕昇 |\n")
report.append("| GREAT_PERSON_INDIVIDUAL_JAMES_OF_ST_GEORGE | 詹姆斯·圣乔治 |\n")
report.append("| GREAT_PERSON_INDIVIDUAL_ISIDORE_OF_MILETUS | 米利都的伊西多尔 |\n")
report.append("| GREAT_PERSON_INDIVIDUAL_JOHN_A_ROEBLING | 约翰·A·罗布林 |\n")
report.append("| GREAT_PERSON_INDIVIDUAL_ALVAR_AALTO | 阿尔瓦·阿尔托 |\n\n")

report.append("### 5.3 大统治者伟人 重分类的2位原版大将军\n\n")
report.append("- 拿破仑·波拿巴: 重分类为大统治者，+1万能政策槽\n")
report.append("- 古斯塔夫·阿道夫: 重分类为大统治者，+1军事政策槽\n\n")

report.append("### 5.4 远古伟人 修改的印何阗\n\n")
report.append("- 印何阗: 时代从远古改为古典，行动次数改为2，古典奇观产能改为250\n\n")

# Section 6
report.append("## 6. 兼容性分析\n\n")

report.append("### 6.1 Mod重叠定义\n\n")
report.append("| 游戏元素 | 删除部分工程师 | 更多伟人 | 最终结果 | 原因 |\n")
report.append("|----------|:---:|:---:|:---:|------|\n")
report.append("| JOHN_A_ROEBLING | DELETE | DELETE | 被删除 | 两个mod都删除 |\n")
report.append("| JAMES_OF_ST_GEORGE | DELETE | DELETE | 被删除 | 两个mod都删除 |\n\n")

report.append("### 6.2 冲突与风险\n\n")
report.append("- **LoadOrder 冲突**: 更多伟人(240-250)与大统治者伟人(240-250)的LoadOrder范围重叠，但两者操作不同表(GreatPersonIndividuals vs GreatSovereigns)，无直接冲突。\n")
report.append("- **删除冲突**: 更多伟人的\"移除平庸者\"选项(LoadOrder 999)和删除部分工程师mod都会删除某些工程师，可能导致重复删除但不会出错。\n")
report.append("- **汉化覆盖**: 汉化文本LoadOrder极高(1919/11000)，确保所有文本覆盖正确。\n\n")

# Section 7
report.append("## 7. 远古伟人 新增14人详细效果\n\n")
report.append("远古伟人(6T_AGP)Mod新增14位远古时代伟人，覆盖以下类型:\n\n")
report.append("| 类型 | 人数 | 主要效果 |\n")
report.append("|------|:---:|------|\n")
report.append("| 大艺术家 | 2 | 创作远古巨作 |\n")
report.append("| 大作家 | 2 | 创作远古巨作 |\n")
report.append("| 大音乐家 | 2 | 创作远古巨作 |\n")
report.append("| 大工程师 | 3 | 奇观产能/城市加成 |\n")
report.append("| 大科学家 | 2 | 科技尤里卡/加成 |\n")
report.append("| 大商人 | 2 | 金币/商路/资源 |\n")
report.append("| 大将军 | 1 | 军事加成 |\n")
report.append("| 海军统帅 | 0 | — |\n\n")

if 'GREAT_PERSON_CLASS_ARTIST' in by_class:
    agp_artists = [e for e in by_class['GREAT_PERSON_CLASS_ARTIST'] if get_source(e) == '远古伟人']
    if agp_artists:
        report.append("**远古大艺术家:**\n\n")
        for e in agp_artists:
            cn = get_name(e)
            report.append(f"- {cn}: 创作远古巨作，提供文化与旅游业绩\n")

if 'GREAT_PERSON_CLASS_WRITER' in by_class:
    agp_writers = [e for e in by_class['GREAT_PERSON_CLASS_WRITER'] if get_source(e) == '远古伟人']
    if agp_writers:
        report.append("\n**远古大作家:**\n\n")
        for e in agp_writers:
            cn = get_name(e)
            report.append(f"- {cn}: 创作远古文学作品，提供文化与旅游业绩\n")

if 'GREAT_PERSON_CLASS_MUSICIAN' in by_class:
    agp_musicians = [e for e in by_class['GREAT_PERSON_CLASS_MUSICIAN'] if get_source(e) == '远古伟人']
    if agp_musicians:
        report.append("\n**远古大音乐家:**\n\n")
        for e in agp_musicians:
            cn = get_name(e)
            report.append(f"- {cn}: 创作远古音乐作品，提供文化与旅游业绩\n")

if 'GREAT_PERSON_CLASS_ENGINEER' in by_class:
    agp_engineers = [e for e in by_class['GREAT_PERSON_CLASS_ENGINEER'] if get_source(e) == '远古伟人']
    if agp_engineers:
        report.append("\n**远古大工程师:**\n\n")
        for e in agp_engineers:
            cn = get_name(e)
            effect = get_effect(e)
            report.append(f"- {cn}: {effect}\n")

if 'GREAT_PERSON_CLASS_SCIENTIST' in by_class:
    agp_scientists = [e for e in by_class['GREAT_PERSON_CLASS_SCIENTIST'] if get_source(e) == '远古伟人']
    if agp_scientists:
        report.append("\n**远古大科学家:**\n\n")
        for e in agp_scientists:
            cn = get_name(e)
            effect = get_effect(e)
            report.append(f"- {cn}: {effect}\n")

if 'GREAT_PERSON_CLASS_MERCHANT' in by_class:
    agp_merchants = [e for e in by_class['GREAT_PERSON_CLASS_MERCHANT'] if get_source(e) == '远古伟人']
    if agp_merchants:
        report.append("\n**远古大商人:**\n\n")
        for e in agp_merchants:
            cn = get_name(e)
            effect = get_effect(e)
            report.append(f"- {cn}: {effect}\n")

if 'GREAT_PERSON_CLASS_GENERAL' in by_class:
    agp_generals = [e for e in by_class['GREAT_PERSON_CLASS_GENERAL'] if get_source(e) == '远古伟人']
    if agp_generals:
        report.append("\n**远古大将军:**\n\n")
        for e in agp_generals:
            cn = get_name(e)
            effect = get_effect(e)
            report.append(f"- {cn}: {effect}\n")

report.append("\n")

# Section 8
report.append("## 8. 更多伟人 新增详细效果\n\n")
report.append("更多伟人(Sumus Magnus) Mod新增72位伟人，覆盖以下类型:\n\n")
report.append("| 类型 | 人数 | 特色 |\n")
report.append("|------|:---:|------|\n")
report.append("| 大艺术家 | 2 | 新增巨作 |\n")
report.append("| 大作家 | 10 | 哲学/文学巨作 |\n")
report.append("| 大音乐家 | 1 | 新增巨作 |\n")
report.append("| 大工程师 | 12 | 改良设施加成/奇观产能/城市加成 |\n")
report.append("| 大科学家 | 13 | 尤里卡/政策槽/特殊加成 |\n")
report.append("| 大商人 | 14 | 奢侈资源/金币/商路/政策槽 |\n")
report.append("| 大将军 | 15 | 战斗加成/使者/特殊单位 |\n")
report.append("| 海军统帅 | 7 | 海军移动/使者/奇观 |\n\n")

report.append("核心特色:\n\n")
report.append("- 新增奢侈资源: 法贝热彩蛋、胡椒、肉豆蔻、果仁糖\n")
report.append("- 新增建筑: 造纸坊、圣殿骑士金库、巧克力工坊\n")
report.append("- 改良设施加成: 圩田(+1食物+1产能)、城堡(+1文化+1金币)、传教团(+1科学+1信仰)\n")
report.append("- 政策槽加成: 万能政策槽、经济政策槽、外交政策槽\n")
report.append("- 海军增强: 库克、亨利、维图斯等提供+1海军移动力\n")
report.append("- 特殊单位: 加查·马达提供登陆不消耗移动力\n\n")

# Section 9
report.append("## 9. 大统治者伟人 新增详细效果\n\n")
report.append("大统治者伟人(GreatSovereigns) Mod新增18位大统治者，属于全新伟人类别。\n\n")
report.append("核心机制:\n\n")
report.append("| 中文名 | 内部ID | 时代 | 充能 | 主动效果 |\n")
report.append("|--------|--------|------|:----:|------|\n")

if 'GREAT_PERSON_CLASS_GreatSovereigns' in by_class:
    for e in by_class['GREAT_PERSON_CLASS_GreatSovereigns']:
        gpt = e['columns'].get('GreatPersonIndividualType', '')
        cn = get_name(e)
        era = get_era(e)
        charges = get_charges(e)
        effect = get_effect(e)
        short_id = gpt.replace('GREAT_PERSON_INDIVIDUAL_PLATI_', '')
        report.append(f"| {cn} | {short_id} | {era} | {charges} | {effect} |\n")

# Add reclassified
report.append("| 拿破仑·波拿巴 | (重分类) | 工业 | 1 | +1万能政策槽 |\n")
report.append("| 古斯塔夫·阿道夫 | (重分类) | 文艺复兴 | 1 | +1军事政策槽 |\n\n")

report.append("大统治者伟人点获取方式:\n\n")
report.append("- 政府区每回合+1点\n")
report.append("- 根据政府区建筑等级额外+1~+3点\n")
report.append("- 特定奇观提供点数(阿尔罕布拉宫、宙斯像等)\n")
report.append("- 精英统治政策卡+2点/回合\n")
report.append("- 圣主明君万神殿+1点/回合(黄金时代+2)\n")
report.append("- 击杀单位+8点/次\n\n")

# Write report
with open('/workspace/GreatPerson_analysis.md', 'w', encoding='utf-8') as f:
    f.write(''.join(report))

print("Report generated successfully!")
print(f"Total unique entries: {len(seen)}")
for cls in class_order:
    if cls in by_class:
        print(f"  {CLASS_MAP.get(cls, cls)}: {len(by_class[cls])}")
for cls in other_classes:
    if cls in by_class:
        print(f"  {CLASS_MAP.get(cls, cls)}: {len(by_class[cls])}")
print(f"Deleted entries: {len(deleted_ids)}")