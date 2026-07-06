/*
	CSE Modification Text
	Localization for modified city-state abilities.
	LoadOrder: 69
*/

-- ==========================================
-- SCIENTIFIC CITY-STATES
-- ==========================================

-- Geneva
UPDATE LocalizedText SET Text = '未与任何主要文明交战时+10%科技值。' WHERE Tag = 'LOC_LEADER_TRAIT_GENEVA_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = '+10% [ICON_Science] Science while not at war with any major civilization.' WHERE Tag = 'LOC_LEADER_TRAIT_GENEVA_DESCRIPTION' AND Language = 'en_US';

-- Izapa
UPDATE LocalizedText SET Text = '宗主国黄金时代尤里卡额外+5%科技；黑暗时代额外+1时代分。' WHERE Tag = 'LOC_CSE_IZAPA_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Eurekas provide an extra +5% [ICON_Science] during a Golden Age, and an extra +1 [ICON_EraScore] Era Score during a Dark Age.' WHERE Tag = 'LOC_CSE_IZAPA_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- Lima
UPDATE LocalizedText SET Text = '宗主国学院和学院里的建筑建造速度+20%，学院区域+3生产力。' WHERE Tag = 'LOC_CSE_LIMA_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Campuses and their buildings gain +20% [ICON_Production] Production. Campus districts gain +3 [ICON_Production] Production.' WHERE Tag = 'LOC_CSE_LIMA_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- Samarqand
UPDATE LocalizedText SET Text = '宗主国每获得1位伟人+1%科学，最多+30%。' WHERE Tag = 'LOC_CSE_SAMARQAND_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain gains +1% [ICON_Science] Science for each Great Person earned (up to +30%).' WHERE Tag = 'LOC_CSE_SAMARQAND_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- Valabhi
UPDATE LocalizedText SET Text = '宗主国学院区域+2信仰；学院建筑可用信仰购买。' WHERE Tag = 'LOC_CSE_VALABHI_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Campus districts gain +2 [ICON_Faith] Faith. Campus buildings can be purchased with [ICON_Faith] Faith.' WHERE Tag = 'LOC_CSE_VALABHI_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- Gundeshapur
UPDATE LocalizedText SET Text = '宗主国进入新时代时获1免费尤里卡；学院区每相邻2区域+1科学。' WHERE Tag = 'LOC_CSE_GUNDESHAPUR_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain gains 1 free Eureka upon entering a new era. Campus districts gain +1 [ICON_Science] Science for every 2 adjacent districts.' WHERE Tag = 'LOC_CSE_GUNDESHAPUR_TRAIT_DESCRIPTION' AND Language = 'en_US';

UPDATE LocalizedText SET Text = '学院区每相邻2区域+1科学' WHERE Tag = 'LOC_CSE_GUNDESHAPUR_CAMPUS_ADJACENCY' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = '+1 [ICON_Science] Science for every 2 adjacent districts' WHERE Tag = 'LOC_CSE_GUNDESHAPUR_CAMPUS_ADJACENCY' AND Language = 'en_US';

-- ==========================================
-- CULTURAL CITY-STATES
-- ==========================================

-- Antananarivo
UPDATE LocalizedText SET Text = '宗主国每获得1位伟人+1%文化值，最多+30%。' WHERE Tag = 'LOC_LEADER_TRAIT_ANTANANARIVO_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain gains +1% [ICON_Culture] Culture for each Great Person earned (up to +30%).' WHERE Tag = 'LOC_LEADER_TRAIT_ANTANANARIVO_DESCRIPTION' AND Language = 'en_US';

-- Tangier
UPDATE LocalizedText SET Text = '宗主国进入新时代时获1免费灵感；剧院区每相邻2区域+1文化。' WHERE Tag = 'LOC_CSE_TANGIER_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain gains 1 free Inspiration upon entering a new era. Theater Square districts gain +1 [ICON_Culture] Culture for every 2 adjacent districts.' WHERE Tag = 'LOC_CSE_TANGIER_TRAIT_DESCRIPTION' AND Language = 'en_US';

INSERT OR REPLACE INTO LocalizedText (Tag, Language, Text)
VALUES	('LOC_CSE_TANGIER_THEATER_ADJACENCY', 'zh_Hans_CN', '剧院区每相邻2区域+1文化'),
		('LOC_CSE_TANGIER_THEATER_ADJACENCY', 'en_US', '+1 [ICON_Culture] Culture for every 2 adjacent districts');

-- Dodona
UPDATE LocalizedText SET Text = '宗主国黄金时代灵感额外+5%市政；黑暗时代额外+1时代分。' WHERE Tag = 'LOC_CSE_DODONA_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Inspirations provide an extra +5% [ICON_Culture] Culture during a Golden Age, and an extra +1 [ICON_EraScore] Era Score during a Dark Age.' WHERE Tag = 'LOC_CSE_DODONA_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- Shahr-e Sukhté
UPDATE LocalizedText SET Text = '宗主国不处于战争状态时+10%文化。' WHERE Tag = 'LOC_CSE_SHAHR_E_SUKHTE_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain gains +10% [ICON_Culture] Culture while not at war.' WHERE Tag = 'LOC_CSE_SHAHR_E_SUKHTE_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- ==========================================
-- RELIGIOUS CITY-STATES
-- ==========================================

-- Sri Ksetra
UPDATE LocalizedText SET Text = '宗主国圣地区域+3食物。' WHERE Tag = 'LOC_CSE_SRI_KSETRA_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Holy Site districts gain +3 [ICON_Food] Food.' WHERE Tag = 'LOC_CSE_SRI_KSETRA_TRAIT_DESCRIPTION' AND Language = 'en_US';

-- ==========================================
-- TRADE CITY-STATES
-- ==========================================

-- Garama
UPDATE LocalizedText SET Text = '宗主国绿洲及相邻地块+1食物；两格远地块+1食物。' WHERE Tag = 'LOC_CSE_GARAMA_TRAIT_DESCRIPTION' AND Language = 'zh_Hans_CN';
UPDATE LocalizedText SET Text = 'Suzerain Oases and adjacent land tiles gain +1 [ICON_Food] Food. Land tiles two away from Oases gain +1 [ICON_Food] Food.' WHERE Tag = 'LOC_CSE_GARAMA_TRAIT_DESCRIPTION' AND Language = 'en_US';
