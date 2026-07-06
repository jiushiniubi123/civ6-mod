/*
	CSE_Localisation_Modifications
	Updated localization text for modified city-state suzerain bonuses.
	Loads after CSE_Localisation.sql and CSE_Localisation_XP1.sql (LoadOrder > 41).
*/

-- ============================================================================
-- GENEVA (原版) - 未与任何主要文明交战时+10%科技值
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_GENEVA_TRAIT_DESCRIPTION', 'Your cities earn +10% bonus [ICON_SCIENCE] Science output when you are not at war with any civilization.'),
('de_DE', 'LOC_GENEVA_TRAIT_DESCRIPTION', 'Eure Städte erhalten +10% [ICON_SCIENCE] Wissenschaft, wenn ihr mit keiner Zivilisation Krieg führt.');

-- ============================================================================
-- ANTANANARIVO (原版 DLC2) - 每获得1位伟人+1%文化值，最多+30%
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_ANTANANARIVO_TRAIT_DESCRIPTION', 'Your Civilization gains +1% [ICON_CULTURE] Culture for each [ICON_GREATPERSON] Great Person it has ever earned, up to a total of +30%.'),
('de_DE', 'LOC_ANTANANARIVO_TRAIT_DESCRIPTION', 'Eure Zivilisation erhält +1% [ICON_CULTURE] Kultur für jede [ICON_GREATPERSON] Große Persönlichkeit, die sie je erhalten hat, bis zu einem Maximum von +30%.');

-- ============================================================================
-- CSE_IZAPA (XP1) - 黄金时代尤里卡额外+5%科技；黑暗时代额外+时代分
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_IZAPA_TRAIT_DESCRIPTION', '[ICON_TECHBOOSTED] Eurekas provide +5% of the cost for Technologies during a [ICON_GLORY_GOLDEN_AGE] Golden Age, and additional Era Score during a [ICON_GLORY_DARK_AGE] Dark Age.'),
('de_DE', 'LOC_CSE_IZAPA_TRAIT_DESCRIPTION', '[ICON_TECHBOOSTED] Heureka-Momente liefern +5% der Kosten für Technologien während eines [ICON_GLORY_GOLDEN_AGE] Goldenen Zeitalters und zusätzliche Epochenpunkte während eines [ICON_GLORY_DARK_AGE] Dunklen Zeitalters.');

-- ============================================================================
-- CSE_DODONA (XP1) - 黄金时代灵感额外+5%市政；黑暗时代额外+时代分
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_DODONA_TRAIT_DESCRIPTION', '[ICON_CIVICBOOSTED] Inspirations provide +5% of the cost for Civics during a [ICON_GLORY_GOLDEN_AGE] Golden Age, and additional Era Score during a [ICON_GLORY_DARK_AGE] Dark Age.'),
('de_DE', 'LOC_CSE_DODONA_TRAIT_DESCRIPTION', '[ICON_CIVICBOOSTED] Inspirationen liefern +5% der Kosten für Ausrichtungen während eines [ICON_GLORY_GOLDEN_AGE] Goldenen Zeitalters und zusätzliche Epochenpunkte während eines [ICON_GLORY_DARK_AGE] Dunklen Zeitalters.');

-- ============================================================================
-- CSE_SAMARQAND (Base) - 每个已获得伟人+1%科学，最多+30%
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_SAMARQAND_TRAIT_DESCRIPTION', 'Your Civilization gains +1% [ICON_SCIENCE] Science for each [ICON_GREATPERSON] Great Person it has ever earned, up to a total of +30%.'),
('de_DE', 'LOC_CSE_SAMARQAND_TRAIT_DESCRIPTION', 'Eure Zivilisation erhält +1% [ICON_SCIENCE] Wissenschaft für jede [ICON_GREATPERSON] Große Persönlichkeit, die sie je erhalten hat, bis zu einem Maximum von +30%.');

-- ============================================================================
-- CSE_SHAHR_E_SUKHTE (Base) - 不处于战争状态时+10%文化
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_SHAHR_E_SUKHTE_TRAIT_DESCRIPTION', 'Your cities earn +10% bonus [ICON_CULTURE] Culture output when you are not at war with any civilization.'),
('de_DE', 'LOC_CSE_SHAHR_E_SUKHTE_TRAIT_DESCRIPTION', 'Eure Städte erhalten +10% [ICON_CULTURE] Kultur, wenn ihr mit keiner Zivilisation Krieg führt.');

-- ============================================================================
-- CSE_GUNDESHAPUR (XP2) - 新时代获1免费尤里卡；学院区每相邻2区域+1科学
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_GUNDESHAPUR_TRAIT_DESCRIPTION', 'Receive one free [ICON_TECHBOOSTED] Eureka upon entering a new era. Campus districts receive +1 [ICON_SCIENCE] Science for every two adjacent districts.'),
('de_DE', 'LOC_CSE_GUNDESHAPUR_TRAIT_DESCRIPTION', 'Erhaltet einen kostenlosen [ICON_TECHBOOSTED] Heureka-Moment beim Eintritt in ein neues Zeitalter. Campus-Bezirke erhalten +1 [ICON_SCIENCE] Wissenschaft für je zwei angrenzende Bezirke.');

-- ============================================================================
-- CSE_TANGIER (XP2) - 新时代获1免费灵感；剧院区每相邻2区域+1文化
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_TANGIER_TRAIT_DESCRIPTION', 'Receive one free [ICON_CIVICBOOSTED] Inspiration upon entering a new era. Theater districts receive +1 [ICON_CULTURE] Culture for every two adjacent districts.'),
('de_DE', 'LOC_CSE_TANGIER_TRAIT_DESCRIPTION', 'Erhaltet eine kostenlose [ICON_CIVICBOOSTED] Inspiration beim Eintritt in ein neues Zeitalter. Theater-Bezirke erhalten +1 [ICON_CULTURE] Kultur für je zwei angrenzende Bezirke.');

-- ============================================================================
-- CSE_GARAMA (Base) - 绿洲及相邻+1食物；两格远+1食物
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_GARAMA_TRAIT_DESCRIPTION', '+1 [ICON_FOOD] Food on Oases and adjacent land tiles. +1 [ICON_FOOD] Food on land tiles two away.'),
('de_DE', 'LOC_CSE_GARAMA_TRAIT_DESCRIPTION', '+1 [ICON_FOOD] Nahrung auf Oasen und angrenzenden Landfeldern. +1 [ICON_FOOD] Nahrung auf Landfeldern in zwei Feldern Entfernung.');

-- ============================================================================
-- CSE_LIMA (Base) - 学院和学院里的建筑建造速度+20%，学院区域+3生产力
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_LIMA_TRAIT_DESCRIPTION', 'Receive +20% [ICON_PRODUCTION] Production toward Campus districts and their buildings. Campus districts receive +3 [ICON_PRODUCTION] Production.'),
('de_DE', 'LOC_CSE_LIMA_TRAIT_DESCRIPTION', 'Erhaltet +20% [ICON_PRODUCTION] Produktion für Campus-Bezirke und deren Gebäude. Campus-Bezirke erhalten +3 [ICON_PRODUCTION] Produktion.');

-- ============================================================================
-- CSE_VALABHI (Base) - 学院区域+2信仰；建筑可用信仰购买
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_VALABHI_TRAIT_DESCRIPTION', 'Campus districts receive +2 [ICON_FAITH] Faith and their buildings may be purchased with [ICON_FAITH] Faith.'),
('de_DE', 'LOC_CSE_VALABHI_TRAIT_DESCRIPTION', 'Campus-Bezirke erhalten +2 [ICON_FAITH] Glauben und ihre Gebäude können mit [ICON_FAITH] Glauben gekauft werden.');

-- ============================================================================
-- CSE_SRI_KSETRA (Base) - AGRICULTURAL→RELIGIOUS 圣地区域+3食物
-- ============================================================================
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
('en_US', 'LOC_CSE_SRI_KSETRA_TRAIT_DESCRIPTION', 'Holy Site districts receive +3 [ICON_FOOD] Food.'),
('de_DE', 'LOC_CSE_SRI_KSETRA_TRAIT_DESCRIPTION', 'Heilige Stätten erhalten +3 [ICON_FOOD] Nahrung.');