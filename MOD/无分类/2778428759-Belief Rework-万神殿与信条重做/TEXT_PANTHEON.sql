--------------------------PANTHEON--------------------------------

-- Language: en_US

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_STONE_CIRCLES_NAME',  
'Oral Tradition');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GOD_OF_WAR_NAME',  
'Goddess of Water');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_DISTRICT_COAST_FAITH',  
'+{1_num} [ICON_Faith] Faith from the adjacent Coast and Lake tiles {1_Num : plural 1?tile; other?tiles;}.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_RIVER_GODDESS_H_DESCRIPTION',  
'+1 award adjaceny bonus to specialty districts adjacent to River, +2 [ICON_Amenities] Amenities , +2 [ICON_Housing] Housing to cities if they have a Holy Site district
  adjacent to a River.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GENSHIN_H_DESCRIPTION',  
'+1 Bonus Base Yield for each Unique Improvements in your country. （For [ICON_Gold] Gold +2)');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GODDESS_OF_WATER_H_DESCRIPTION',  
'Holy Site adjacent to Coast and Lake tiles +2 [ICON_Faith] Faith. Coast and Lake tiles provide a standard adjacency bonus for Holy Site.');

-- Language: zh_Hans_CN
INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GOD_OF_WAR_NAME',  
'水之女神');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_DISTRICT_COAST_FAITH',  
'+{1_num} [ICON_Faith] 信仰来自相邻水域单元格 {1_Num : plural 1?tile; other?;}。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_RIVER_GODDESS_H_DESCRIPTION',  
'所有沿河区域+1对应相邻产出，相邻河流的圣地区域为城市+2 [ICON_Amenities] 宜居度、+2 [ICON_Housing] 住房。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_STONE_CIRCLES_NAME',  
'口述传统');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GENSHIN_H_DESCRIPTION',  
'为国境内所有特色改良+1其基础产出，若为 [ICON_Gold] 金币则+2。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GODDESS_OF_WATER_H_DESCRIPTION',  
'相邻水域单元格的圣地+2 [ICON_Faith] 信仰值，并从每块相邻水域单元格获得标准相邻加成。');

--------------------------PANTHEON--------------------------------

-- Language: en_US
INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GOD_OF_HEALING_NAME',  
'God King');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GOD_OF_THE_SEA_H_DESCRIPTION',  
'+1 [ICON_Production] Production and +1 [ICON_Science] Science from Fishing Boats.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_RELIGIOUS_IDOLS_H_DESCRIPTION',  
'+1 [ICON_Food] Food and +1 [ICON_Faith] Faith from Mines over Luxury and Bonus resources.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GOD_OF_THE_FORGE_H_DESCRIPTION',  
"+25% [ICON_Production] Production toward Ancient and Classical military
  units. Gains [ICON_Culture] equal to 20% of the unit's cost when a
  non-civilian is trained.");

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_MONUMENT_TO_THE_GODS_H_DESCRIPTION',  
"Awards a [ICON_GreatPerson] Divine Architect who can grant 110 production
 towards Ancient wonder construction once. This Great People will appear in your
 capital next turn.");

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GOD_OF_HEALING_H_DESCRIPTION',  
"Awards 1 [ICON_Governor] Governor Title");

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_INITIATION_RITES_H_DESCRIPTION',  
"Awards a Tribal Village reward for each Barbarian Outpost cleared. The unit
 cleared the Barbarian Outpost heals + 100 HP.");

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_CITY_PATRON_GODDESS_H_DESCRIPTION',  
'+100% [ICON_Production] Production toward districts in cities without a
  specialty district.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_EARTH_GODDESS_H_DESCRIPTION',  
'+1 Faith [ICON_Faith] from tiles with Charming Appeal, +2 Faith
  [ICON_Faith] from tiles with Breathtaking Appeal.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_DIVINE_SPARK_H_DESCRIPTION',  
'+1 [ICON_GreatPerson] Great Person point from Holy Site (Prophet), Campus
  (Scientist), and Theater Square (Writer) districts.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_GODDESS_OF_FIRE_H_DESCRIPTION',  
'+1 [ICON_CULTURE] Culture, +1 [ICON_FAITH] Faith from Geothermal Fissures and Volcanic Soil.');

-- Language: zh_Hans_CN
INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GOD_OF_HEALING_NAME',  
'君主崇拜');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GOD_OF_THE_SEA_H_DESCRIPTION',  
'渔船+1 [ICON_Production] 生产力, +1 [ICON_Science] 科技值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_RELIGIOUS_IDOLS_H_DESCRIPTION',  
'采集奢侈品资源和加成资源的矿山+1 [ICON_Food] 粮食，+1 [ICON_Faith] 信仰值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GOD_OF_THE_FORGE_H_DESCRIPTION',  
"为远古和古典军事单位+25% [ICON_Production] 生产力。 生产非平民单位时，获得等同于该单位成本20%的 [ICON_Culture] 文化值。");

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GOD_OF_HEALING_H_DESCRIPTION',  
"奖励1个 [ICON_Governor] 总督头衔。");

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_INITIATION_RITES_H_DESCRIPTION',  
"清除每个蛮族哨站后获得一个部落村庄奖励。 清理蛮族哨站的单位回复100点生命值。");

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_INITIATION_RITES_H_DESCRIPTION',  
"清除每个蛮族哨站后获得一个部落村庄奖励。 清理蛮族哨站的单位回复100点生命值。");

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_CITY_PATRON_GODDESS_H_DESCRIPTION',  
'没有特色区域的城市建造区域时，城市每回合 [ICON_Production] 生产力+100%。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_EARTH_GODDESS_H_DESCRIPTION',  
'魅力为迷人的单元格+1 [ICON_Faith] 信仰值，魅力为惊艳的单元格+2 [ICON_Faith] 信仰值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_EARTH_GODDESS_H_DESCRIPTION',  
'魅力为迷人的单元格+1 [ICON_Faith] 信仰值，魅力为惊艳的单元格+2 [ICON_Faith] 信仰值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_DIVINE_SPARK_H_DESCRIPTION',  
'圣地（大预言家）、学院（大科学家）、剧院广场（大作家）+1 [ICON_GreatPerson] 伟人点数');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_GODDESS_OF_FIRE_H_DESCRIPTION',  
'地热裂缝和火山土提供+1 [ICON_CULTURE] 文化值，+1 [ICON_Faith] 信仰值');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_MONUMENT_TO_THE_GODS_H_DESCRIPTION',  
'选择后下一回合即可在首都获得1名 [ICON_GreatPerson] 神圣建筑师，他拥有一次使用次数，能为远古奇观提供110 [ICON_Production] 生产力。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_DANCE_OF_THE_AURORA_H_DESCRIPTION',  
'圣地区域从相邻冻土单元格+1 [ICON_Faith] 信仰值 ，从相邻雪地单元格+1 [ICON_Gold] 金币 。');

INSERT INTO LocalizedText (Language, Tag, Text) VALUES
('zh_Hans_CN', 'LOC_DISTRICT_SNOW_FAITH_TT', '+{1_num} [ICON_Gold] 金币来自相邻雪地{1_Num : plural 1?单元格; other?单元格;}。'),
('zh_Hans_CN', 'LOC_DISTRICT_SNOW_HILLS_FAITH_TT', '+{1_num} [ICON_Gold] 金币来自相邻雪地丘陵{1_Num : plural 1?单元格; other?单元格;}。');


