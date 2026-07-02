--------------------------------------------------------------------------------
-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                           Text)
values
    -- UI Texts
    ("LOC_TRAIT_CIVILIZATION_MAYAB_DESCRIPTION",                           "instead each Farm provides an additional +1 [ICON_HOUSING] Housing, +1  [ICON_PRODuction]  Production for every adjacent Observatory, and +1 [ICON_GOLD] Gold. +1 [ICON_AMENITIES] Amenity for every Luxury adjacent to the City Center.");

-- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                            Text)
values
    ("zh_Hans_CN",  "LOC_TRAIT_CIVILIZATION_MAYAB_DESCRIPTION",            "每座农场额外+1 [ICON_HOUSING] 住房、每与一座天文台相邻则+1 [ICON_Production] 生产力、+1 [ICON_GOLD] 金币。每有一种奢侈品与市中心相邻，则+1 [ICON_AMENITIES] 宜居度。");



-- Language: en_US
insert or replace into EnglishText
    (Tag,                                                           Text)
values
    -- UI Texts
    ("LOC_TRAIT_LEADER_MUTAL_DESCRIPTION",                                 "Non capital cities within 6 tiles of the [ICON_Capital] Capital gain +10% to all yields and when founded receive a builder.+5 [ICON_Strength] Combat Strength to units within 6 tiles of the [ICON_Capital] Capital.");

    -- Language: zh_Hans_CN
insert or replace into LocalizedText
    (Language,      Tag,                                             Text)
values
    ("zh_Hans_CN",  "LOC_TRAIT_LEADER_MUTAL_DESCRIPTION",                  "[ICON_Capital] 首都6单元格范围内的非首都城市所有产出+10%，且建成时将获得1名建造者。首都6单元格范围内的单位+5 [ICON_Strength] 战斗力。");