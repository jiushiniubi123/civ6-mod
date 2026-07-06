--========================================================================================================================
-- Kinds
--========================================================================================================================
	INSERT INTO Kinds
			(Kind)
	VALUES	('KIND_SUK_REGION'),
			('KIND_SUK_URBANIDENTITY');
--========================================================================================================================
-- Regions
--========================================================================================================================
	CREATE TABLE "Suk_Regions" (
		"RegionType"			TEXT NOT NULL,	-- Should match the Lua entry as well
		"Name"					TEXT,			-- If left empty, the game will look for "LOC_REGIONTYPE_NAME"

		PRIMARY KEY (RegionType),
		FOREIGN KEY (RegionType) REFERENCES Types(Type) ON DELETE CASCADE ON UPDATE CASCADE);
--========================================================================================================================
-- Urban Identities
--========================================================================================================================
	-- Urban Identities
	-------------------------------------
		CREATE TABLE "Suk_UrbanIdentities" (
			"IdentityType"			TEXT NOT NULL,

			"Name"					TEXT,			-- If left empty, the game will look for "LOC_IDENTITYTYPE_NAME"
			"Description"			TEXT,			-- If left empty, the game will look for "LOC_IDENTITYTYPE_DESCRIPTION"
			"Flavor"				TEXT,			-- If left empty, the game will look for "LOC_IDENTITYTYPE_FLAVOR"

			"RegionOnly"			BOOLEAN NOT NULL DEFAULT 0, -- Is the Identity only obtainable via Regions?

			PRIMARY KEY (IdentityType),
			FOREIGN KEY (IdentityType) REFERENCES Types(Type) ON DELETE CASCADE ON UPDATE CASCADE);
	-------------------------------------
	-- Urban Identities Regions
	-------------------------------------
		CREATE TABLE "Suk_UrbanIdentity_Regions" (
			"IdentityType"			TEXT NOT NULL,
			"RegionType"			TEXT NOT NULL,

			PRIMARY KEY (IdentityType, RegionType),
			FOREIGN KEY (IdentityType)	REFERENCES Suk_UrbanIdentities(IdentityType) ON DELETE CASCADE ON UPDATE CASCADE,
			FOREIGN KEY (RegionType)	REFERENCES Suk_Regions(RegionType) ON DELETE CASCADE ON UPDATE CASCADE);
	-------------------------------------
	-- Urban Identities - Modifiers
	-- Modifiers are attached to the City directly via Lua
	-------------------------------------
		CREATE TABLE "Suk_UrbanIdentity_Modifiers" (
			"IdentityType"			TEXT NOT NULL,
			"ModifierId"			TEXT NOT NULL,

			PRIMARY KEY (IdentityType, ModifierId),
			FOREIGN KEY (IdentityType)	REFERENCES Suk_UrbanIdentities(IdentityType) ON DELETE CASCADE ON UPDATE CASCADE,
			FOREIGN KEY (ModifierId)	REFERENCES Modifiers(ModifierId) ON DELETE CASCADE ON UPDATE CASCADE);
	-------------------------------------
	-- Urban Identities - Properties

	-- IF CITY ONLY IS FALSE:
		-- Plot properties to be applied to all
		-- plots within a region with this Identity

		-- Must be a RegionOnly Identitiy for
		-- this to do anything

	-- IF CITY ONLY IS TRUE:
		-- The Plot Property is applied to the
		-- Plot where the City founded when
		-- It gains the Identity
	-------------------------------------
		CREATE TABLE "Suk_UrbanIdentity_PlotProperties" (
			"IdentityType"			TEXT NOT NULL,
			"PropertyName"			TEXT NOT NULL,
			"PropertyValue"			TEXT NOT NULL,
			"CityOnly"				BOOLEAN NOT NULL DEFAULT 0,

			PRIMARY KEY (IdentityType, PropertyName),
			FOREIGN KEY (IdentityType)	REFERENCES Suk_UrbanIdentities(IdentityType) ON DELETE CASCADE ON UPDATE CASCADE);
--==========================================================================================================================
-- District Adjacency Requirements (Set-Up)
--==========================================================================================================================
	-- This is a temporary table. It WILL be deleted when setup for Urban Identities is complete
	-- Modders SHOULD NOT USE.
	-------------------------------------
		CREATE TABLE "Suk_Identities_DistrictAdjacencyRequirements"(
			"RequirementId"		TEXT,
			"DistrictType"		TEXT NOT NULL,
			"MinRange"			INT,
			"MaxRange"			INT,
			PRIMARY KEY (RequirementId)
		);
--==========================================================================================================================
--==========================================================================================================================