--=============================================================
-- CivilopediaSections
--=============================================================
	INSERT INTO CivilopediaSections
		(
			SectionId,
			Name,
			Icon,
			SortIndex
		)
	VALUES
		(
			'SUK_IDENTITIES',
			'LOC_PEDIA_SUK_URBAN_IDENTITIES_TITLE',
			'ICON_CIVILOPEDIA_SUK_URBANIDENTITIES',
			61
		);
--=============================================================
-- CivilopediaPages
--=============================================================
	INSERT INTO CivilopediaPageGroups
		(
			SectionID,
			PageGroupId,

			Name,
			Tooltip,

			VisibleIfEmpty,
			SortIndex
		)
	VALUES
		(
			'SUK_IDENTITIES',
			'SUK_IDENTITIES_REGIONAL',

			'LOC_PEDIA_SUK_URBAN_IDENTITIES_PAGEGROUP_REGIONAL_NAME',
			'',

			1,
			5
		),
		(
			'SUK_IDENTITIES',
			'SUK_IDENTITIES_URBAN',

			'LOC_PEDIA_SUK_URBAN_IDENTITIES_PAGEGROUP_URBAN_NAME',
			'',

			1,
			10
		);
--=============================================================
-- CivilopediaPages
--=============================================================
	INSERT INTO CivilopediaPages
		(
			SectionId,
			PageGroupId,
			PageId,
			PageLayoutId,

			Name,
			TextKeyPrefix,
			Tooltip,

			SortIndex
		)
	VALUES
		(
			'SUK_IDENTITIES',
			NULL,
			'INTRO',
			'Simple',

			'LOC_PEDIA_PAGE_INTRO_TITLE',
			'LOC_PEDIA_CONCEPTS_PAGE_SUK_URBAN_IDENTITIES_1',
			'',

			10
		);
--=============================================================
-- CivilopediaPageQueries
--=============================================================
	INSERT INTO CivilopediaPageQueries
		(
			SectionId,
			PageGroupIdColumn,
			TooltipColumn,
			SortIndex,

			SQL
		)
	VALUES
		(
			'SUK_IDENTITIES',
			'PageGroupId',
			'Tooltip',
			10,

			'SELECT DISTINCT IdentityType AS PageId, "SUK_IDENTITIES_REGIONAL" AS PageGroupId, "Suk_Identities" AS PageLayoutId, CASE WHEN Name IS NULL THEN "LOC_"||IdentityType||"_NAME" ELSE Name END AS Name, NULL AS Tooltip FROM Suk_UrbanIdentities WHERE RegionOnly = 1'
		);
--=============================================================
-- CivilopediaPageLayouts
--=============================================================
	INSERT INTO CivilopediaPageLayouts
		(
			PageLayoutId,
			ScriptTemplate
		)
	VALUES
		(
			'Suk_Identities',
			'Suk_Identities'
		);
--=============================================================
-- CivilopediaPageLayoutChapters
--=============================================================
	INSERT INTO CivilopediaPageLayoutChapters
		(
			PageLayoutId,
			ChapterId,
			SortIndex
		)
	VALUES
		(
			'Suk_Identities',
			'HISTORY',
			10
		);
--=============================================================
--=============================================================