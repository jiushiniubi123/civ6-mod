-- ============================================================
-- Wonders Tweak MOD — WondersTweak_Text.sql
-- 7个奇观完整中文描述 (zh_Hans_CN)
-- ============================================================

-- 【3.大本钟】删除银行前置+金币翻倍；新增城市金币+20%
UPDATE LocalizedText SET Text = '+1经济政策槽位。[NEWLINE][NEWLINE]所在城市[ICON_Gold]金币+20%。[NEWLINE][NEWLINE]必须建在河流旁边。'
WHERE Tag = 'LOC_BUILDING_BIG_BEN_EXPANSION2_DESCRIPTION' AND Language = 'zh_Hans_CN';

-- 【6.基尔瓦基斯瓦尼】两个15%的增幅改为10%
UPDATE LocalizedText SET Text = '建造后+3[ICON_ENVOY]使者。成为1个城邦的宗主国后，其所在城市从城邦处获得的类型加成+10%。如成为2个或更多此类城邦的宗主国后，所有城市额外+10%提升。必须建造在与海岸相邻的平原单元格上。'
WHERE Tag = 'LOC_BUILDING_KILWA_KISIWANI_DESCRIPTION' AND Language = 'zh_Hans_CN';

;