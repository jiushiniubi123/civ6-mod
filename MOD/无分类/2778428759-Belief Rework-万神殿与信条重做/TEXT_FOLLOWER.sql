--------------------------FOLLOWER--------------------------------

-- Language: en_US
INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_CHORAL_MUSIC_H_DESCRIPTION',  
'Shrines and Temples provide [ICON_Culture] Culture equal to their intrinsic
 [ICON_Faith] Faith output, and both provide +1 [ICON_Culture] Culture for
 tiles adjacent to the Holy Site District.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_FEED_THE_WORLD_H_DESCRIPTION',  
'Shrines and Temples provide 3 [ICON_Food] Food for City Centers within 6 tiles.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_JESUIT_EDUCATION_H_DESCRIPTION',  
'May purchase Campus and Theater Square district buildings with
 [ICON_Faith] Faith, city follows this religion receives [ICON_Science] and
 [ICON_Culture] Culture equal to 15% of its [ICON_Faith] Faith generation.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_RELIGIOUS_COMMUNITY_H_DESCRIPTION',  
'International [ICON_TradeRoute] Trade Routes provide +2 [ICON_GOLD] Gold to
 cities with Holy Sites and an additional +2 [ICON_GOLD] Gold for every
 building in the Holy Site district. Temple +1[ICON_TradeRoute] Trade Route
 Capacity.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_WARRIOR_MONKS_H_DESCRIPTION',  
'Allows spending [ICON_FAITH] Faith to train Warriors Monks (A land combat
 unit) and Culture Bomb adjacent tiles when completing a Holy Site. Allows
 spending [ICON_Faith] Faith to train Civilian Units.');

INSERT OR REPLACE INTO EnglishText (Tag,Text) VALUES
('LOC_BELIEF_ZEN_MEDITATION_H_DESCRIPTION',  
'+2 [ICON_Amenities] Amenity in cities with 2 specialty districts. Increase
  city [ICON_Faith] Faith yield benifits of Happiness to 25% if city is
  happy ,or 50% if ecstatic.');

-- Language: zh_Hans_CN
INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_CHORAL_MUSIC_H_DESCRIPTION',  
'神社和寺庙提供的 [ICON_Culture] 文化值等于其固定产出的 [ICON_Faith] 信仰值,同时分别为相邻圣地的所有单元格+1
 [ICON_Culture] 文化值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_FEED_THE_WORLD_H_DESCRIPTION',  
'神社和寺庙分别为六个单元格内的所有市中心+3 [ICON_Food] 食物。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_JESUIT_EDUCATION_H_DESCRIPTION',  
'可以使用 [ICON_Faith] 信仰值购买学院和剧院广场区域建筑，信仰此宗教的城市获得其 [ICON_Faith] 信仰值产出15%的 [ICON_Science] 科技值和 [ICON_Culture] 文化值。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_WARRIOR_MONKS_H_DESCRIPTION',  
'允许花费 [ICON_Faith] 信仰值来生产陆地战斗单位“武僧”。建成圣地后对相邻单元格施放文化炸弹。允许花费 [ICON_Faith] 信仰值训练平民单位。');

INSERT OR REPLACE INTO LocalizedText(Language,Tag,Text) VALUES
('zh_Hans_CN','LOC_BELIEF_ZEN_MEDITATION_H_DESCRIPTION',  
'拥有2个特色区域的城市+2 [ICON_Amenities] 宜居度。信仰此宗教且 [ICON_Amenities] 宜居度为快乐的城市， [ICON_Amenities] 宜居度的 [ICON_Faith] 信仰值产出加成提升至25%；若 [ICON_Amenities] 宜居度为欣喜若狂，则提升至50%。');

--Work Ethic
UPDATE LocalizedText
SET		Text = "圣地提供 +3 [ICON_Production] 生产力，如果它们至少有 +4 基础邻接加成，则为+5 [ICON_Production] 生产力                       " --literally unplayable
WHERE	Tag = 'LOC_BELIEF_WORK_ETHIC_EXPANSION2_DESCRIPTION' AND Language = 'zh_Hans_CN' ;


