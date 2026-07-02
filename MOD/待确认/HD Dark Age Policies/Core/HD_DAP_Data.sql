-- ==========================================================================================================================
-- HD Dark Age Policies - Data
-- [AUDIT] Policies table columns from 01_GameplaySchema.sql:2157-2170
-- [AUDIT] Policies_XP1 table columns from Expansion2_Schema.sql:605-613
-- [AUDIT] Naming prefix "DAP_" per user confirmation
-- [AUDIT] DLC target: Expansion2 (Gathering Storm)
-- [AUDIT] All prerequisites removed per user: PrereqCivic = null, PrereqTech = null
-- [AUDIT] 6 policies: 4 Dark Age + 2 Golden Age (Counter Reformation removed per user)
-- ==========================================================================================================================

-- ==========================================================================================================================
-- TYPES
-- ==========================================================================================================================
-- [AUDIT] All Types must be registered before being referenced
INSERT INTO Types
        (Type,                                  Kind)
VALUES  ('ABILITY_DAP_CHATTEL_SLAVERY',          'KIND_ABILITY'),
        ('POLICY_DAP_CHATTEL_SLAVERY',           'KIND_POLICY'),
        ('POLICY_DAP_CHILD_SOLDIERS',            'KIND_POLICY'),
        ('POLICY_DAP_GREAT_MIGRATION',           'KIND_POLICY'),
        ('POLICY_DAP_LABOUR_CAMPS',              'KIND_POLICY'),
        ('POLICY_DAP_ROYAL_TOMBS',               'KIND_POLICY'),
        ('POLICY_DAP_GREAT_PERSON_ACADEMY',      'KIND_POLICY');

-- ==========================================================================================================================
-- TAGS
-- ==========================================================================================================================
-- [AUDIT] Tag units so abilities apply to correct unit classes
INSERT INTO TypeTags
        (Type,                                  Tag)
VALUES  ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_MELEE'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_RANGED'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_SIEGE'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_HEAVY_CHARIOT'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_LIGHT_CHARIOT'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_HEAVY_CAVALRY'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_RANGED_CAVALRY'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_LIGHT_CAVALRY'),
        ('ABILITY_DAP_CHATTEL_SLAVERY',          'CLASS_ANTI_CAVALRY');

-- ==========================================================================================================================
-- UNIT ABILITIES
-- ==========================================================================================================================
-- [AUDIT] UnitAbilities define special abilities granted to units by policies
INSERT INTO UnitAbilities
        (UnitAbilityType,                       Name,                                           Description,                                        Inactive)
VALUES  ('ABILITY_DAP_CHATTEL_SLAVERY',          'LOC_ABILITY_DAP_CHATTEL_SLAVERY_NAME',         'LOC_ABILITY_DAP_CHATTEL_SLAVERY_DESCRIPTION',       1);

-- [AUDIT] UnitAbilityModifiers links abilities to their modifiers
INSERT INTO UnitAbilityModifiers
        (UnitAbilityType,                       ModifierId)
VALUES  ('ABILITY_DAP_CHATTEL_SLAVERY',          'DAP_CHATTEL_SLAVERY_CAPTURE_UNITS_AS_WORKERS');

-- ==========================================================================================================================
-- POLICIES
-- ==========================================================================================================================
-- [AUDIT] All policies use SLOT_WILDCARD (generic wildcard)
-- [AUDIT] PrereqCivic and PrereqTech are null per user: all policies available from game start
INSERT INTO Policies
        (PolicyType,                            Name,                                           Description,                                        PrereqCivic,    PrereqTech,     GovernmentSlotType)
VALUES  ('POLICY_DAP_CHATTEL_SLAVERY',           'LOC_POLICY_DAP_CHATTEL_SLAVERY_NAME',           'LOC_POLICY_DAP_CHATTEL_SLAVERY_DESCRIPTION',         null,           null,           'SLOT_WILDCARD'),
        ('POLICY_DAP_CHILD_SOLDIERS',            'LOC_POLICY_DAP_CHILD_SOLDIERS_NAME',            'LOC_POLICY_DAP_CHILD_SOLDIERS_DESCRIPTION',          null,           null,           'SLOT_WILDCARD'),
        ('POLICY_DAP_GREAT_MIGRATION',           'LOC_POLICY_DAP_GREAT_MIGRATION_NAME',           'LOC_POLICY_DAP_GREAT_MIGRATION_DESCRIPTION',         null,           null,           'SLOT_WILDCARD'),
        ('POLICY_DAP_LABOUR_CAMPS',              'LOC_POLICY_DAP_LABOUR_CAMPS_NAME',              'LOC_POLICY_DAP_LABOUR_CAMPS_DESCRIPTION',            null,           null,           'SLOT_WILDCARD'),
        ('POLICY_DAP_ROYAL_TOMBS',               'LOC_POLICY_DAP_ROYAL_TOMBS_NAME',               'LOC_POLICY_DAP_ROYAL_TOMBS_DESCRIPTION',             null,           null,           'SLOT_WILDCARD'),
        ('POLICY_DAP_GREAT_PERSON_ACADEMY',      'LOC_POLICY_DAP_GREAT_PERSON_ACADEMY_NAME',      'LOC_POLICY_DAP_GREAT_PERSON_ACADEMY_DESCRIPTION',    null,           null,           'SLOT_WILDCARD');

-- [AUDIT] Policies_XP1: available from Ancient to Future era
INSERT INTO Policies_XP1
        (PolicyType,                            MinimumGameEra,         MaximumGameEra)
VALUES  ('POLICY_DAP_CHATTEL_SLAVERY',           'ERA_ANCIENT',          'ERA_FUTURE'),
        ('POLICY_DAP_CHILD_SOLDIERS',            'ERA_ANCIENT',          'ERA_FUTURE'),
        ('POLICY_DAP_GREAT_MIGRATION',           'ERA_ANCIENT',          'ERA_FUTURE'),
        ('POLICY_DAP_LABOUR_CAMPS',              'ERA_ANCIENT',          'ERA_FUTURE'),
        ('POLICY_DAP_ROYAL_TOMBS',               'ERA_ANCIENT',          'ERA_FUTURE'),
        ('POLICY_DAP_GREAT_PERSON_ACADEMY',      'ERA_ANCIENT',          'ERA_FUTURE');

-- ==========================================================================================================================
-- POLICY MODIFIERS (links policies to their database effects)
-- ==========================================================================================================================
-- [AUDIT] Golden Age policies (Royal Tombs, 英杰辈出) have no database effects - era score handled by Lua only
INSERT INTO PolicyModifiers
        (PolicyType,                            ModifierId)
VALUES  ('POLICY_DAP_CHATTEL_SLAVERY',           'DAP_CHATTEL_SLAVERY_GRANT_ABILITY'),
        ('POLICY_DAP_CHILD_SOLDIERS',            'DAP_CHILD_SOLDIERS_EXPERIENCE'),
        ('POLICY_DAP_LABOUR_CAMPS',              'DAP_LABOUR_CAMPS_CITIZEN_PRODUCTION');

-- ==========================================================================================================================
-- MODIFIERS
-- ==========================================================================================================================
-- [AUDIT] Modifier chain: Types -> Modifiers -> ModifierArguments -> (RequirementSets -> Requirements -> RequirementArguments)
INSERT OR REPLACE INTO Modifiers
        (ModifierId,                                        ModifierType,                                               Permanent,      SubjectRequirementSetId)
VALUES  -- Unit ability modifiers (attached to UnitAbilities)
        ('DAP_CHATTEL_SLAVERY_CAPTURE_UNITS_AS_WORKERS',     'MODIFIER_UNIT_ADJUST_COMBAT_CAPTURE',                      0,              null),
        -- Policy modifiers (attached to Policies)
        ('DAP_CHATTEL_SLAVERY_GRANT_ABILITY',                 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',                      0,              null),
        ('DAP_CHILD_SOLDIERS_EXPERIENCE',                     'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_EXPERIENCE_MODIFIER',    0,              null),
        ('DAP_LABOUR_CAMPS_CITIZEN_PRODUCTION',               'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION',   0,              'CITY_HAS_GOVERNOR');

-- ==========================================================================================================================
-- MODIFIER ARGUMENTS
-- ==========================================================================================================================
-- [AUDIT] Amount values preserved from original JFD mod per user confirmation
INSERT INTO ModifierArguments
        (ModifierId,                                        Name,                       Value)
VALUES  -- Unit ability arguments
        ('DAP_CHATTEL_SLAVERY_CAPTURE_UNITS_AS_WORKERS',     'UnitType',                 'UNIT_BUILDER'),
        ('DAP_CHATTEL_SLAVERY_CAPTURE_UNITS_AS_WORKERS',     'CanCapture',               1),
        -- Policy arguments
        ('DAP_CHATTEL_SLAVERY_GRANT_ABILITY',                 'AbilityType',              'ABILITY_DAP_CHATTEL_SLAVERY'),
        ('DAP_CHILD_SOLDIERS_EXPERIENCE',                     'Amount',                   100),
        ('DAP_LABOUR_CAMPS_CITIZEN_PRODUCTION',               'YieldType',                'YIELD_PRODUCTION'),
        ('DAP_LABOUR_CAMPS_CITIZEN_PRODUCTION',               'Amount',                   0.4);

-- ==========================================================================================================================
-- MODIFIER STRINGS (for UI preview text)
-- ==========================================================================================================================
INSERT INTO ModifierStrings
        (ModifierId,                                            Context,        Text)
VALUES  ('DAP_CHATTEL_SLAVERY_CAPTURE_UNITS_AS_WORKERS',         'Preview',      'LOC_ABILITY_DAP_CHATTEL_SLAVERY_MODIFIER_DESCRIPTION');