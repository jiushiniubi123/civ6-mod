
INSERT OR IGNORE INTO Types (Type, Kind) VALUES
('POLICY_ALL_DISTRICTS_BOMB', 'KIND_POLICY');

INSERT OR IGNORE INTO Policies (
    PolicyType,
    Name,
    Description,
    PrereqCivic,
    GovernmentSlotType
) VALUES (
    'POLICY_ALL_DISTRICTS_BOMB',
    'LOC_POLICY_ALL_DISTRICTS_BOMB_NAME',
    'LOC_POLICY_ALL_DISTRICTS_BOMB_DESCRIPTION',
    'CIVIC_NATIONALISM', 
    'SLOT_WILDCARD' 
);

INSERT OR IGNORE INTO Modifiers (
    ModifierId,
    ModifierType,
    SubjectRequirementSetId
) VALUES (
    'POLICY_ALL_DISTRICTS_BOMB_MODIFIER',
    'MODIFIER_PLAYER_ADJUST_ALL_DISTRICTS_CULTURE_BOMB',
    NULL
);

INSERT OR IGNORE INTO PolicyModifiers (
    PolicyType,
    ModifierId
) VALUES (
    'POLICY_ALL_DISTRICTS_BOMB',
    'POLICY_ALL_DISTRICTS_BOMB_MODIFIER'
);
