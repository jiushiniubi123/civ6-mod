--==========================================================================================================================
-- GAME MODES
--==========================================================================================================================
	-- GAMEMODE_SUK_URBANIDENTITIES
	------------------------------------------------------------------------------------------------------------------------
		-- Parameters
		--------------------------------------------------------------------------
			INSERT INTO Parameters
				(
					ParameterId,

					Name,
					Description,

					Domain,
					DefaultValue,

					ConfigurationGroup,
					ConfigurationId,
					GroupId
				)
			VALUES
				(
					'GameMode_Suk_UrbanIdentities',

					'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',
					'LOC_GAMEMODE_SUK_URBANIDENTITIES_DESCRIPTION',

					'bool',
					1,

					'Game',
					'GAMEMODE_SUK_URBANIDENTITIES',
					'GameModes'
				),
				(
					'GameMode_Suk_UrbanIdentities_RegionCoverage',

					'LOC_GAMEMODE_SUK_URBANIDENTITIES_REGIONCOVERAGE_NAME',
					'LOC_GAMEMODE_SUK_URBANIDENTITIES_REGIONCOVERAGE_DESCRIPTION',

					'Suk_RegionCoverageRange',
					5,

					'Map',
					'Suk_RegionCoverage',
					'MapOptions'
				);
		--------------------------------------------------------------------------
		-- DomainRanges
		--------------------------------------------------------------------------
			INSERT INTO DomainRanges
					(Domain,						MinimumValue,	MaximumValue)
			VALUES	('Suk_RegionCoverageRange',		5,				30);
		--------------------------------------------------------------------------
		-- ParameterCriteria
		--------------------------------------------------------------------------
			INSERT INTO ParameterCriteria
					(
						ParameterId,
						ConfigurationGroup,
						ConfigurationId,
						Operator,
						ConfigurationValue
					)
			VALUES	(
						'GameMode_Suk_UrbanIdentities',
						'Game',
						'GAMEMODE_RANDOM',
						'NotEquals',
						'1'
					);
		--------------------------------------------------------------------------
		-- ParameterDependencies
		--------------------------------------------------------------------------
			INSERT INTO ParameterDependencies
				(
					ParameterId,

					ConfigurationGroup,
					ConfigurationId,

					Operator,
					ConfigurationValue
				)
			VALUES
				(
					'GameMode_Suk_UrbanIdentities',

					'Game',
					'RULESET',

					'Exists',
					'RULESET_EXPANSION_1,RULESET_EXPANSION_2'
				),
				(
					'GameMode_Suk_UrbanIdentities_RegionCoverage',

					'Game',
					'GAMEMODE_SUK_URBANIDENTITIES',

					'Equals',
					1
				);
		--------------------------------------------------------------------------
		-- GameModeItems
		--------------------------------------------------------------------------
			INSERT INTO GameModeItems
				(
					GameModeType,
					Name,

					Icon,
					Portrait,
					Background,

					SortIndex
				)
			VALUES
				(
					'GAMEMODE_SUK_URBANIDENTITIES',
					'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',

					'ICON_GAMEMODE_SUK_URBANIDENTITIES',
					'GAMEMODE_SUK_URBAN_IDENTITIES_NEUTRAL',
					'GAMEMODE_TREE_RANDOMIZER_BACKGROUND',

					10
				);

			-- INSERT INTO GameModeItems
			-- 	(
			-- 		GameModeType,
			-- 		Name,

			-- 		UnitName,
			-- 		UnitDescription,
			-- 		UnitIcon,

			-- 		SortIndex
			-- 	)
			-- VALUES
			-- 	(
			-- 		'GAMEMODE_SUK_URBANIDENTITIES',
			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',

			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',
			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',
			-- 		'ICON_SUK_URBANIDENTITIES_IDENTITY',

			-- 		20
			-- 	),
			-- 	(
			-- 		'GAMEMODE_SUK_URBANIDENTITIES',
			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',

			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',
			-- 		'LOC_GAMEMODE_SUK_URBANIDENTITIES_NAME',
			-- 		'ICON_SUK_URBANIDENTITIES_REGION',

			-- 		30
			-- 	);
--==========================================================================================================================
--==========================================================================================================================