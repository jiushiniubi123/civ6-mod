-- 
create table 'CityPolicyTextMaster'(
    'CityPolicy' TEXT NOT NULL,
    'Name' TEXT,
    'EffectText' TEXT,
    'BuildingText' TEXT,
    'EnableProjectText' TEXT,
    'DisableProjectText' TEXT,
    PRIMARY KEY('CityPolicy')
);

insert or replace into CityPolicyTextMaster
    (CityPolicy)
values
    ('EMPTY'),
    ('LABOR'),
    ('REVISION_ALMANAC'),
    ('AGRICULTURAL_TAX'),
    ('INDUSTRAIL_TAX'),
    ('DIPLOMATIC_MEETING'),
    ('FREIGHT'),
    ('FORGING_IRON');
update CityPolicyTextMaster set
    Name                    = 'LOC_CITY_POLICY_' || CityPolicy,
    EffectText              = 'LOC_CITY_POLICY_' || CityPolicy || '_EFFECT',
    BuildingText            = 'LOC_BUILDING_CITY_POLICY_' || CityPolicy,
    EnableProjectText       = 'LOC_PROJECT_CITY_POLICY_ENABLE_' || CityPolicy,
    DisableProjectText      = 'LOC_PROJECT_CITY_POLICY_DISABLE_' || CityPolicy;

insert or replace into EnglishText (Tag, Text) select
    BuildingText || '_NAME',            '{'||Name||'}{LOC_HD_SPACE}{LOC_POLICY_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    BuildingText || '_DESCRIPTION',     '{'||Name||'}{LOC_HD_SPACE}{LOC_CITY_POLICY_NAME}{LOC_HD_SPACE}{LOC_UNDERGOING_TEXT}[NEWLINE]{'||EffectText||'} {LOC_DISABLE_BY_PROJECT}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_NAME',       '{LOC_MODS_ENABLE}{LOC_HD_SPACE}{'||BuildingText||'_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_SHORT_NAME', '{LOC_MODS_ENABLE}{LOC_HD_SPACE}{'||Name||'}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    EnableProjectText || '_DESCRIPTION', '{LOC_MODS_ENABLE} {'||BuildingText||'_NAME}[NEWLINE]{'||EffectText||'} {LOC_DISABLE_BY_PROJECT}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_NAME',       '{LOC_MODS_DISABLE}{LOC_HD_SPACE}{'||BuildingText||'_NAME}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_SHORT_NAME', '{LOC_MODS_DISABLE}{LOC_HD_SPACE}{'||Name||'}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';
insert or replace into EnglishText (Tag, Text) select
    DisableProjectText || '_DESCRIPTION', '{LOC_MODS_DISABLE} {'||BuildingText||'_NAME}[NEWLINE]{LOC_CITYPOLICY_BACK_TO_NORMAL}'
from CityPolicyTextMaster where CityPolicy != 'EMPTY';

--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                             Text)
values
    ("LOC_CITY_POLICY_NAME",                                          "City Policy"),
    ("LOC_HUD_CITY_CITY_POLICIES",                                    "City Policies"),
    ("LOC_HUD_CITY_NO_CITY_POLICIES",                                 "No City Policies exist."),
    ("LOC_BUILDING_CITY_POLICY_EMPTY_NAME",                           "No City Policy"),
    ("LOC_BUILDING_CITY_POLICY_EMPTY_DESCRIPTION",                    "No City Policy."),

    ("LOC_HD_SPACE",                                                  " "),
    ("LOC_UNDERGOING_TEXT",                                           "undergoing"),
    ("LOC_DISABLE_BY_PROJECT",                                        "This policy can be disabled by a project."),
    ("LOC_CITYPOLICY_BACK_TO_NORMAL",                                 "the yields back to the normal."),

    ("LOC_CITY_POLICY_LABOR",                                         "Labor"),
    ("LOC_CITY_POLICY_LABOR_EFFECT",                                  "Each [ICON_Citizen] Citizen provides 1.5 extra [ICON_Production] Production, but consume extra 1 [ICON_Food] Food. The city growth rate decreased by 75% and cause -1 [ICON_Amenities] Amenity."),
    ("LOC_CITY_POLICY_AGRICULTURAL_TAX",                              "Agricultural Tax"),
    ("LOC_CITY_POLICY_AGRICULTURAL_TAX_EFFECT",                       "Each Farm provides extra 2 [ICON_GOLD] Gold, but -1 [ICON_Food] Food."),
    ("LOC_CITY_POLICY_INDUSTRAIL_TAX",                                "Industrial Tax"),
    ("LOC_CITY_POLICY_INDUSTRAIL_TAX_EFFECT",                         "Each Mine or Quarry provides extra 2 [ICON_GOLD] Gold, but -1 [ICON_PRODUCTION] Production."),
    ("LOC_CITY_POLICY_REVISION_ALMANAC",                              "Revision Almanac"),
    ("LOC_CITY_POLICY_REVISION_ALMANAC_EFFECT",                       "Aqueduct Project. If this city has and Aqueduct, each Plantation and Farm with any resource +1 [ICON_SCIENCE] Science in this city, but need maintenance cost of 8 [ICON_GOLD] Gold."),
    ("LOC_CITY_POLICY_DIPLOMATIC_MEETING",                            "Diplomatic Meeting"),
    ("LOC_CITY_POLICY_DIPLOMATIC_MEETING_EFFECT",                     "Diplomatic Quarter Project. Diplomatic Quarter and each its building consumes 2 [ICON_Favor] Favor per turn, and provides 5 influence points."),
    ("LOC_CITY_POLICY_FREIGHT",                                       "Freight"),
    ("LOC_CITY_POLICY_FREIGHT_EFFECT",                                "Commercial Hub Project. Consumes 2 [ICON_RESOURCE_HORSES] Horses per turn, provides 2 [ICON_FOOD] Food and 3 [ICON_PRODUCTION] Production."),
    ("LOC_CITY_POLICY_FORGING_IRON",                                  "Forging Iron"),
    ("LOC_CITY_POLICY_FORGING_IRON_EFFECT",                           "Industrial Zone Project. Consumes 2 [ICON_RESOURCE_IRON] Iron per turn, provides 5 [ICON_PRODUCTION] Production.");

    -- ("LOC_CITY_POLICY_DACAOGU",                                       "Pillage Preparing"),
    -- ("LOC_CITY_POLICY_DACAOGU_EFFECT",                                "Each trained light cavalry unit of Mediveal or eralier era in this city gains the ability that can pillage tiles using only 1 [ICON_Movement] Movement. Each [ICON_Citizen] Citizen consumes extra 1 [ICON_FOOD] Food. -100% Growth Rate and -1 [ICON_Amenities] Amenity to this city. If the city has at least 3 [ICON_Citizen] Citizens, receives another unit of the same kind when a light cavalry unit of Mediveal or eralier era being trained in this city, at the cost of one [ICON_Citizen] Citizen. This policy can be disabled by a project.");

--------------------------------------------------------------------------------
-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                                             Text)
values
    ("zh_Hans_CN",  "LOC_CITY_POLICY_NAME",                                          "城市政策"),
    ("zh_Hans_CN",  "LOC_HUD_CITY_CITY_POLICIES",                                    "城市政策"),
    ("zh_Hans_CN",  "LOC_HUD_CITY_NO_CITY_POLICIES",                                 "尚未开启城市政策"),
    ("zh_Hans_CN",  "LOC_BUILDING_CITY_POLICY_EMPTY_NAME",                           "无城市政策"),
    ("zh_Hans_CN",  "LOC_BUILDING_CITY_POLICY_EMPTY_DESCRIPTION",                    "无城市政策。"),

    ("zh_Hans_CN",  "LOC_HD_SPACE",                                                  ""),
    ("zh_Hans_CN",  "LOC_UNDERGOING_TEXT",                                           "已启用"),
    ("zh_Hans_CN",  "LOC_DISABLE_BY_PROJECT",                                        "该政策可通过项目关闭。"),
    ("zh_Hans_CN",  "LOC_CITYPOLICY_BACK_TO_NORMAL",                                 "产出恢复正常。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_LABOR",                                         "徭役"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_LABOR_EFFECT",                                  "城市中每位 [ICON_Citizen] 公民提供1.5 [ICON_Production] 生产力，但额外增加1 [ICON_Food] 食物消耗。城市余粮减少75%且-1 [ICON_Amenities] 宜居度。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_AGRICULTURAL_TAX",                              "农业税"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_AGRICULTURAL_TAX_EFFECT",                       "每个农场多2 [ICON_GOLD] 金币，但额外减少1 [ICON_Food] 食物。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_INDUSTRAIL_TAX",                                "工业税"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_INDUSTRAIL_TAX_EFFECT",                         "每个矿山或采石场多2 [ICON_GOLD] 金币，但额外减少1 [ICON_PRODUCTION] 生产力。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_REVISION_ALMANAC",                              "观星制历"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_REVISION_ALMANAC_EFFECT",                       "+1 [ICON_Housing] 住房，但-1 [ICON_Amenities] 宜居度。若城市邻近山脉，额外+1 [ICON_Amenities] 宜居度。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_DIPLOMATIC_MEETING",                            "图腾崇拜"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_DIPLOMATIC_MEETING_EFFECT",                     "+1 [ICON_Faith] 信仰值。若城市邻近森林或山脉，+1 [ICON_GreatProphet] 大预言家点数。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FREIGHT",                                       "官营手工业"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FREIGHT_EFFECT",                                "+1 [ICON_Production] 生产力。若城市拥有已改良的奢侈品或加成资源的矿山/采石场，建造建筑+1 [ICON_Production] 生产力，建造区域+1 [ICON_Production] 生产力。"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FORGING_IRON",                                  "新兵训练营"),
    ("zh_Hans_CN",  "LOC_CITY_POLICY_FORGING_IRON_EFFECT",                           "+1 [ICON_Production] 生产力。若城市拥有已改良的牧场、营地或战略资源，训练单位+2 [ICON_Production] 生产力。"),
    ("zh_Hans_CN",  "LOC_BELIEF_FERTILITY_RITES_EXPANSION2_DESCRIPTION",                                  "选择后即可在首都中获得1个建造者，城市人口增长速度+20%。"),
    ("zh_Hans_CN",  "LOC_BELIEF_RELIGIOUS_SETTLEMENTS_EXPANSION2_DESCRIPTION",                                  "选择后即可在首都中获得1个建造者，城市发展速度+20%。"),
    ("zh_Hans_CN",  "LOC_BOOST_TRIGGER_EARLY_EMPIRE",                                  "文明人口至少达到5。"),
    ("zh_Hans_CN",  "LOC_BOOST_TRIGGER_CIVIL_SERVICE",                                  "一个城市的人口增长到8。"),
    ("zh_Hans_CN",  "LOC_GOVERNOR_PROMOTION_VOIDSINGERS_2_DESCRIPTION",                                  "在中世纪解锁。城市每回合获得等同于其每回合所获 [ICON_Faith] 信仰值10%的 [ICON_Gold] 金币、[ICON_Science] 科技值和 [ICON_Culture] 文化值。");

    -- ("zh_Hans_CN",  "LOC_CITY_POLICY_DACAOGU",                                       "打草谷政策"),
    -- ("zh_Hans_CN",  "LOC_CITY_POLICY_DACAOGU_EFFECT",                                "本城生产的中古及更早时代的轻骑兵获得劫掠地块只消耗1 [ICON_Movement] 移动力的能力。若本城有3 [ICON_Citizen] 人口或以上，则生产该类型的轻骑兵以后，额外获得一个免费的相同类型的单位，但减少一个 [ICON_Citizen] 人口。[NEWLINE]城市中每位公民 [ICON_Citizen] 额外消耗1 [ICON_Food] 食物。本城减少100%余粮，并-1 [ICON_Amenities] 宜居度。该政策可通过项目关闭。");
