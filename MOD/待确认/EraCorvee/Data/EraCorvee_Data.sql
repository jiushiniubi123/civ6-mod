-- =====================================================
-- Era Corvée - 时代徭役政策卡
-- 每个时代一张政策卡，允许工人加速奇观
-- 
-- 核心机制说明：
-- - MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT（Modifier 层）：
--   启用工人次数→奇观产能的转换能力，仅接受 Amount 参数
-- - UNITCOMMAND_WONDER_PRODUCTION（UnitCommand 层）：
--   控制 UI 按钮显示，MaxEra 限制可加速的奇观时代
--   原版 MaxEra=2（仅远古+古典），本 MOD 改为 8（全时代）
-- =====================================================

-- =====================================================
-- 0. 移除原版 UnitCommand 的时代限制
--    原版: MaxEra=2 (仅远古时代1 + 古典时代2)
--    修改为: MaxEra=8 (允许所有时代奇观)
-- =====================================================
UPDATE UnitCommands SET MaxEra = 8 WHERE CommandType = 'UNITCOMMAND_WONDER_PRODUCTION';

-- =====================================================
-- 1. 注册 Types
-- =====================================================
INSERT INTO Types (Type, Kind) VALUES
    ('POLICY_CORVEE_ANCIENT',       'KIND_POLICY'),
    ('POLICY_CORVEE_CLASSICAL',     'KIND_POLICY'),
    ('POLICY_CORVEE_MEDIEVAL',      'KIND_POLICY'),
    ('POLICY_CORVEE_RENAISSANCE',   'KIND_POLICY'),
    ('POLICY_CORVEE_INDUSTRIAL',    'KIND_POLICY'),
    ('POLICY_CORVEE_MODERN',        'KIND_POLICY'),
    ('POLICY_CORVEE_ATOMIC',        'KIND_POLICY'),
    ('POLICY_CORVEE_INFORMATION',   'KIND_POLICY');

-- =====================================================
-- 2. 创建策略卡
-- =====================================================
INSERT INTO Policies (PolicyType, Name, Description, PrereqCivic, GovernmentSlotType) VALUES
    ('POLICY_CORVEE_ANCIENT',       'LOC_POLICY_CORVEE_ANCIENT_NAME',       'LOC_POLICY_CORVEE_ANCIENT_DESCRIPTION',       'CIVIC_CODE_OF_LAWS',       'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_CLASSICAL',     'LOC_POLICY_CORVEE_CLASSICAL_NAME',     'LOC_POLICY_CORVEE_CLASSICAL_DESCRIPTION',     'CIVIC_GAMES_RECREATION',   'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_MEDIEVAL',      'LOC_POLICY_CORVEE_MEDIEVAL_NAME',      'LOC_POLICY_CORVEE_MEDIEVAL_DESCRIPTION',      'CIVIC_FEUDALISM',          'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_RENAISSANCE',   'LOC_POLICY_CORVEE_RENAISSANCE_NAME',   'LOC_POLICY_CORVEE_RENAISSANCE_DESCRIPTION',   'CIVIC_HUMANISM',           'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_INDUSTRIAL',    'LOC_POLICY_CORVEE_INDUSTRIAL_NAME',    'LOC_POLICY_CORVEE_INDUSTRIAL_DESCRIPTION',    'CIVIC_CIVIL_ENGINEERING',  'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_MODERN',        'LOC_POLICY_CORVEE_MODERN_NAME',        'LOC_POLICY_CORVEE_MODERN_DESCRIPTION',        'CIVIC_CONSERVATION',       'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_ATOMIC',        'LOC_POLICY_CORVEE_ATOMIC_NAME',        'LOC_POLICY_CORVEE_ATOMIC_DESCRIPTION',        'CIVIC_NUCLEAR_PROGRAM',    'SLOT_ECONOMIC'),
    ('POLICY_CORVEE_INFORMATION',   'LOC_POLICY_CORVEE_INFORMATION_NAME',   'LOC_POLICY_CORVEE_INFORMATION_DESCRIPTION',   'CIVIC_GLOBALIZATION',      'SLOT_ECONOMIC');

-- =====================================================
-- 3. 创建 Modifiers（全部使用 MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT）
-- =====================================================
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('CORVEE_ANCIENT_WONDER_PERCENT',       'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_CLASSICAL_WONDER_PERCENT',     'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_MEDIEVAL_WONDER_PERCENT',      'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_RENAISSANCE_WONDER_PERCENT',   'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_INDUSTRIAL_WONDER_PERCENT',    'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_MODERN_WONDER_PERCENT',        'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_ATOMIC_WONDER_PERCENT',        'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT'),
    ('CORVEE_INFORMATION_WONDER_PERCENT',   'MODIFIER_PLAYER_ADJUST_UNIT_WONDER_PERCENT');

-- =====================================================
-- 4. 设置 ModifierArguments（Amount = 每个工人次数提供的产能百分比）
-- =====================================================
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('CORVEE_ANCIENT_WONDER_PERCENT',       'Amount', '10'),
    ('CORVEE_CLASSICAL_WONDER_PERCENT',     'Amount', '12'),
    ('CORVEE_MEDIEVAL_WONDER_PERCENT',      'Amount', '15'),
    ('CORVEE_RENAISSANCE_WONDER_PERCENT',   'Amount', '18'),
    ('CORVEE_INDUSTRIAL_WONDER_PERCENT',    'Amount', '22'),
    ('CORVEE_MODERN_WONDER_PERCENT',        'Amount', '25'),
    ('CORVEE_ATOMIC_WONDER_PERCENT',        'Amount', '30'),
    ('CORVEE_INFORMATION_WONDER_PERCENT',   'Amount', '35');

-- =====================================================
-- 5. 绑定策略卡与 Modifier
-- =====================================================
INSERT INTO PolicyModifiers (PolicyType, ModifierId) VALUES
    ('POLICY_CORVEE_ANCIENT',       'CORVEE_ANCIENT_WONDER_PERCENT'),
    ('POLICY_CORVEE_CLASSICAL',     'CORVEE_CLASSICAL_WONDER_PERCENT'),
    ('POLICY_CORVEE_MEDIEVAL',      'CORVEE_MEDIEVAL_WONDER_PERCENT'),
    ('POLICY_CORVEE_RENAISSANCE',   'CORVEE_RENAISSANCE_WONDER_PERCENT'),
    ('POLICY_CORVEE_INDUSTRIAL',    'CORVEE_INDUSTRIAL_WONDER_PERCENT'),
    ('POLICY_CORVEE_MODERN',        'CORVEE_MODERN_WONDER_PERCENT'),
    ('POLICY_CORVEE_ATOMIC',        'CORVEE_ATOMIC_WONDER_PERCENT'),
    ('POLICY_CORVEE_INFORMATION',   'CORVEE_INFORMATION_WONDER_PERCENT');

-- =====================================================
-- 6. 设置淘汰链（下一时代的政策卡淘汰上一时代）
--    Additional Content 中的 POLICIES 表要求所有外键插入在同一个事务中，
--    因此分步 INSERT 确保所有引用存在
-- =====================================================
INSERT INTO ObsoletePolicies (PolicyType, ObsoletePolicy) VALUES
    ('POLICY_CORVEE_ANCIENT',       'POLICY_CORVEE_CLASSICAL'),
    ('POLICY_CORVEE_CLASSICAL',     'POLICY_CORVEE_MEDIEVAL'),
    ('POLICY_CORVEE_MEDIEVAL',      'POLICY_CORVEE_RENAISSANCE'),
    ('POLICY_CORVEE_RENAISSANCE',   'POLICY_CORVEE_INDUSTRIAL'),
    ('POLICY_CORVEE_INDUSTRIAL',    'POLICY_CORVEE_MODERN'),
    ('POLICY_CORVEE_MODERN',        'POLICY_CORVEE_ATOMIC'),
    ('POLICY_CORVEE_ATOMIC',        'POLICY_CORVEE_INFORMATION');