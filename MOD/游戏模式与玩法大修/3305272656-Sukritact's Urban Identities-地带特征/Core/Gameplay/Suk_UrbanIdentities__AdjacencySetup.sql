--==========================================================================================================================
-- Process Entries
--==========================================================================================================================
	-- Requirements
	----------------------
		INSERT INTO Requirements
			(
				RequirementId,
				RequirementType
			)
		SELECT
				RequirementId,
				'REQUIREMENT_REQUIREMENTSET_IS_MET'
		FROM Suk_Identities_DistrictAdjacencyRequirements;
	-------------------------------------
	-- RequirementArguments
	-------------------------------------
		INSERT INTO RequirementArguments
			(
				RequirementId,
				Name,
				Value
			)
		SELECT
				RequirementId,
				'RequirementSetId',
				RequirementId||'__REQUIREMENTS'
		FROM Suk_Identities_DistrictAdjacencyRequirements;
	----------------------
	-- RequirementSets
	----------------------
		INSERT INTO RequirementSets
			(
				RequirementSetId,
				RequirementSetType
			)
		SELECT
				RequirementId||'__REQUIREMENTS',
				'REQUIREMENTSET_TEST_ANY'
		FROM Suk_Identities_DistrictAdjacencyRequirements;
	----------------------
	-- RequirementSetRequirements
	----------------------
		INSERT INTO RequirementSetRequirements
			(
				RequirementSetId,
				RequirementId
			)
		SELECT
				RequirementId||'__REQUIREMENTS',
				RequirementId||'__'||Districts.DistrictType
		FROM Suk_Identities_DistrictAdjacencyRequirements
			JOIN
				(
					SELECT
						DistrictType,
						DistrictType AS BaseDistrictType FROM Districts
					UNION
					SELECT
						CivUniqueDistrictType AS DistrictType,
						ReplacesDistrictType AS BaseDistrictType FROM DistrictReplaces
				)
			AS Districts ON Suk_Identities_DistrictAdjacencyRequirements.DistrictType == Districts.BaseDistrictType;

		CREATE TRIGGER Suk_Identities_UniqueDistrict_RequirementSets AFTER INSERT ON DistrictReplaces
			WHEN NEW.ReplacesDistrictType IN (SELECT DistrictType FROM Suk_Identities_DistrictAdjacencyRequirements)
		BEGIN
			INSERT OR REPLACE INTO RequirementSetRequirements
				(
					RequirementSetId,
					RequirementId
				)
			SELECT
					RequirementId||'__REQUIREMENTS',
					RequirementId||'__'||NEW.CivUniqueDistrictType
			FROM Suk_Identities_DistrictAdjacencyRequirements WHERE DistrictType == NEW.ReplacesDistrictType;
		END;
	----------------------
	-- Requirements
	----------------------
		INSERT INTO Requirements
			(
				RequirementId,
				RequirementType
			)
		SELECT
				RequirementId||'__'||Districts.DistrictType,
				'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES'
		FROM Suk_Identities_DistrictAdjacencyRequirements
			JOIN
				(
					SELECT
						DistrictType,
						DistrictType AS BaseDistrictType FROM Districts
					UNION
					SELECT
						CivUniqueDistrictType AS DistrictType,
						ReplacesDistrictType AS BaseDistrictType FROM DistrictReplaces
				)
			AS Districts ON Suk_Identities_DistrictAdjacencyRequirements.DistrictType == Districts.BaseDistrictType;

		-----------------------------------------

		CREATE TRIGGER Suk_Identities_UniqueDistrict_Requirements AFTER INSERT ON DistrictReplaces
			WHEN NEW.ReplacesDistrictType IN (SELECT DistrictType FROM Suk_Identities_DistrictAdjacencyRequirements)
		BEGIN
			INSERT OR REPLACE INTO Requirements
				(
					RequirementId,
					RequirementType
				)
			SELECT
					RequirementId||'__'||NEW.CivUniqueDistrictType,
					'REQUIREMENT_PLOT_ADJACENT_DISTRICT_TYPE_MATCHES'
			FROM Suk_Identities_DistrictAdjacencyRequirements WHERE DistrictType == NEW.ReplacesDistrictType;
		END;
	-------------------------------------
	-- RequirementArguments
	-------------------------------------
		-- DistrictType
		-------------------------------------
			INSERT INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			SELECT
					RequirementId||'__'||Districts.DistrictType,
					'DistrictType',
					Districts.DistrictType
			FROM Suk_Identities_DistrictAdjacencyRequirements
				JOIN
					(
						SELECT
							DistrictType,
							DistrictType AS BaseDistrictType FROM Districts
						UNION
						SELECT
							CivUniqueDistrictType AS DistrictType,
							ReplacesDistrictType AS BaseDistrictType FROM DistrictReplaces
					)
				AS Districts ON Suk_Identities_DistrictAdjacencyRequirements.DistrictType == Districts.BaseDistrictType;
		-------------------------------------
		-- MinRange
		-------------------------------------
			INSERT INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			SELECT
					RequirementId||'__'||Districts.DistrictType,
					'MinRange',
					MinRange
			FROM Suk_Identities_DistrictAdjacencyRequirements
				JOIN
					(
						SELECT
							DistrictType,
							DistrictType AS BaseDistrictType FROM Districts
						UNION
						SELECT
							CivUniqueDistrictType AS DistrictType,
							ReplacesDistrictType AS BaseDistrictType FROM DistrictReplaces
					)
				AS Districts ON Suk_Identities_DistrictAdjacencyRequirements.DistrictType == Districts.BaseDistrictType
				WHERE MinRange IS NOT NULL;
		-------------------------------------
		-- MaxRange
		-------------------------------------
			INSERT INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
			SELECT
					RequirementId||'__'||Districts.DistrictType,
					'MaxRange',
					MaxRange
			FROM Suk_Identities_DistrictAdjacencyRequirements
				JOIN
					(
						SELECT
							DistrictType,
							DistrictType AS BaseDistrictType FROM Districts
						UNION
						SELECT
							CivUniqueDistrictType AS DistrictType,
							ReplacesDistrictType AS BaseDistrictType FROM DistrictReplaces
					)
				AS Districts ON Suk_Identities_DistrictAdjacencyRequirements.DistrictType == Districts.BaseDistrictType
				WHERE MaxRange IS NOT NULL;
		-------------------------------------
		-- DistrictType | Trigger
		-------------------------------------
			CREATE TRIGGER Suk_Identities_UniqueDistrict_Requirements_DistrictArg AFTER INSERT ON DistrictReplaces
				WHEN NEW.ReplacesDistrictType IN (SELECT DistrictType FROM Suk_Identities_DistrictAdjacencyRequirements)
			BEGIN
				INSERT OR REPLACE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
				SELECT
					RequirementId||'__'||NEW.CivUniqueDistrictType,
					'DistrictType',
					NEW.CivUniqueDistrictType
				FROM Suk_Identities_DistrictAdjacencyRequirements WHERE DistrictType == NEW.ReplacesDistrictType;
			END;
		-------------------------------------
		-- MinRange | Trigger
		-------------------------------------
			CREATE TRIGGER Suk_Identities_UniqueDistrict_Requirements_MinArg AFTER INSERT ON DistrictReplaces
				WHEN NEW.ReplacesDistrictType IN (SELECT DistrictType FROM Suk_Identities_DistrictAdjacencyRequirements)
			BEGIN
				INSERT OR REPLACE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
				SELECT
					RequirementId||'__'||NEW.CivUniqueDistrictType,
					'MinRange',
					MinRange
				FROM Suk_Identities_DistrictAdjacencyRequirements WHERE
					DistrictType == NEW.ReplacesDistrictType
					AND MinRange IS NOT NULL;
			END;
		-------------------------------------
		-- MaxRange | Trigger
		-------------------------------------
			CREATE TRIGGER Suk_Identities_UniqueDistrict_Requirements_MaxArg AFTER INSERT ON DistrictReplaces
				WHEN NEW.ReplacesDistrictType IN (SELECT DistrictType FROM Suk_Identities_DistrictAdjacencyRequirements)
			BEGIN
				INSERT OR REPLACE INTO RequirementArguments
				(
					RequirementId,
					Name,
					Value
				)
				SELECT
					RequirementId||'__'||NEW.CivUniqueDistrictType,
					'MaxRange',
					MaxRange
				FROM Suk_Identities_DistrictAdjacencyRequirements WHERE
					DistrictType == NEW.ReplacesDistrictType
					AND MaxRange IS NOT NULL;
			END;