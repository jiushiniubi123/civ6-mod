-- ===========================================================================
--	Civilopedia - Governor Promotion Page Layout
-- ===========================================================================

PageLayouts["Suk_Identities" ] = function(page)
	local sectionId = page.SectionId
	local pageId = page.PageId
	SetPageHeader(page.Title)

	local tIdentity = GameInfo.Suk_UrbanIdentities[pageId]
	if(tIdentity == nil) then
		return
	end

	local sIdentityType		= tIdentity.IdentityType
	local sIdentityDesc		= tIdentity.Description	or "LOC_"..sIdentityType.."_DESCRIPTION"
	local sIdentityFlavor	= tIdentity.Flavor		or "LOC_"..sIdentityType.."_FLAVOR"
	local bRegional			= tIdentity.RegionOnly

	-- Get some info!
	local tPrereqRegions = {}
	for tRow in GameInfo.Suk_UrbanIdentity_Regions() do
		if (tRow.IdentityType == sIdentityType) then
			local tRegion = GameInfo.Suk_Regions[tRow.RegionType]
			if tRegion then
				local sRegionName = tRegion.Name or "LOC_"..tRegion.RegionType.."_NAME"
				table.insert(tPrereqRegions, sRegionName)
			end
		end
	end

	-- Right Column!
	AddQuote(sIdentityFlavor)

	if #tPrereqRegions > 0 then
		AddRightColumnStatBox("LOC_UI_PEDIA_SUK_URBAN_IDENTITIES_REGIONS",
			function(s)
				s:AddSeparator()

				for i,v in ipairs(tPrereqRegions) do
					s:AddLabel("[ICON_Bullet] " .. Locale.Lookup(v))
				end

				s:AddSeparator()
			end
		)
	end


	-- Left Column!
	AddChapter("LOC_UI_PEDIA_DESCRIPTION", sIdentityDesc)

	-- This probably won't be used for now.
	local chapters = GetPageChapters(page.PageLayoutId)
	if(chapters) then
		for i, chapter in ipairs(chapters) do
			local chapterId = chapter.ChapterId
			local chapter_header = GetChapterHeader(sectionId, pageId, chapterId)
			local chapter_body = GetChapterBody(sectionId, pageId, chapterId)

			AddChapter(chapter_header, chapter_body)
		end
	end
end
