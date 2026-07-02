-- Suk_RegionDefinitions_ML
-- Author: Maple_Leaves
-- DateCreated: 2/28/2026 9:52:32 PM
--------------------------------------------------------------


include "ML_UrbanIdentities_SupportFunctions"


-------------------------------------
-- Tundra
-- This one is a conditional entry
-------------------------------------
	
	if GameInfo.Terrains.TERRAIN_TUNDRA then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_TUNDRA"] = {
			CheckerFunction =
				function(pPlot)
					--必须是冻土
					local pTerrainType = pPlot:GetTerrainType()
					if GameInfo.Terrains[pTerrainType] == nil then
						return false
					end
					local pTerrainTypeStr = GameInfo.Terrains[pTerrainType].TerrainType
					if not TableIncludeValue_Suk_Urban_Identities_ML({"TERRAIN_TUNDRA", "TERRAIN_TUNDRA_HILLS"}, pTerrainTypeStr) then
						return false
					end

					--必须距离水1格及以上，这会同时排斥湖泊、海岸、大河和大湖
					if HasWaterWithInXTiles(pPlot, 1) then
						return false
					end

					--周围必须没有沼泽、地热、火山、泛滥平原、蕈林
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 5,
			Epsilon		= 1,
			Dilate		= 0,
		}
	end

-------------------------------------
-- Snow
-- This one is a conditional entry
-------------------------------------
	
	if GameInfo.Terrains.TERRAIN_SNOW then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_SNOW"] = {
			CheckerFunction =
				function(pPlot)
					--必须是雪地
					local pTerrainType = pPlot:GetTerrainType()
					if GameInfo.Terrains[pTerrainType] == nil then
						return false
					end
					local pTerrainTypeStr = GameInfo.Terrains[pTerrainType].TerrainType
					if not TableIncludeValue_Suk_Urban_Identities_ML({"TERRAIN_SNOW", "TERRAIN_SNOW_HILLS"}, pTerrainTypeStr) then
						return false
					end

					--周围必须没有沼泽、地热、火山、泛滥平原、蕈林
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 1,
			Dilate		= 0,
		}
	end


-------------------------------------
-- Coast
-- This one is a conditional entry
-------------------------------------
	
	if GameInfo.Terrains.TERRAIN_COAST then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_COAST"] = {
			CheckerFunction =
				function(pPlot)
					--必须是相邻海岸的陆地单元格
					local pTerrainType = pPlot:GetTerrainType()
					if GameInfo.Terrains[pTerrainType] == nil then
						return false
					end
					if not HasCoastWithInXTiles(pPlot, 1) then
						return false
					end
					if not IsLandTerrain(pPlot) then
						return false
					end	

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原、礁石、海藻森林
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH",
						"FEATURE_REEF",
						"FEATURE_SUK_KELP",
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 2,
			Dilate		= 1,
		}
	end

-------------------------------------
-- Half Sand
-- This one is a conditional entry
-------------------------------------
	
	if GameInfo.Terrains.TERRAIN_DESERT then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_HALF_DESERT"] = {
			CheckerFunction =
				function(pPlot)
					--必须是相邻沙漠且不是沙漠的陆地单元格
					local pTerrainType = pPlot:GetTerrainType()
					if GameInfo.Terrains[pTerrainType] == nil then
						return false
					end
					if not IsAdjacentToDesert(pPlot) then
						return false
					end
					if IsDesertTerrain(pPlot) then
						return false
					end
					if not IsLandTerrain(pPlot) then
						return false
					end	

					--周围必须没有沼泽、地热、火山、蕈林
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 2,
			Dilate		= 1,
		}
	end

-------------------------------------
-- Volcano
-- This one is a conditional entry
-------------------------------------
	
	if GameInfo.Features.FEATURE_VOLCANO then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_VOLCANO"] = {
			CheckerFunction =
				function(pPlot)
					--必须是火山或火山土
					local pTerrainType = pPlot:GetTerrainType()
					if GameInfo.Terrains[pTerrainType] == nil then
						return false
					end
					if not IsVolcano(pPlot) then
						return false
					end

					--周围必须没有沼泽、地热、泛滥平原、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_FLOODPLAINS", 
						"FEATURE_FLOODPLAINS_GRASSLAND", 
						"FEATURE_FLOODPLAINS_PLAINS",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 1,
			Epsilon		= 2,
			Dilate		= 1,
		}
	end

-------------------------------------
-- Copper
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_COPPER then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_COPPER"] = {
			CheckerFunction =
				function(pPlot)
					--必须在铜资源1个单元格以内
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_COPPER"}, 1) then
						return false
					end

					--不能是山脉
					if IsMountainLandTerrain(pPlot) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 3,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有铜则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_COPPER"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Stone
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_STONE then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_STONE"] = {
			CheckerFunction =
				function(pPlot)
					--必须是石头、大理石、或石膏1个单元格以内
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_STONE", "RESOURCE_GYPSUM", "RESOURCE_MARBLE"}, 1) then
						return false
					end

					--不能是山脉
					if IsMountainLandTerrain(pPlot) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有资源则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_STONE", "RESOURCE_GYPSUM", "RESOURCE_MARBLE"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Deer
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_DEER then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_DEER"] = {
			CheckerFunction =
				function(pPlot)
					--必须是鹿
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_DEER"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有鹿则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_DEER"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end


-------------------------------------
-- Rice
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_RICE then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_RICE"] = {
			CheckerFunction =
				function(pPlot)
					--必须是大米
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_RICE"}) then
						return false
					end

					--周围必须没有地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有大米则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_RICE"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Wheat
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_WHEAT then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_WHEAT"] = {
			CheckerFunction =
				function(pPlot)
					--必须是小麦
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_WHEAT"}) then
						return false
					end

					--周围必须没有地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有小麦则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_WHEAT"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Iron
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_IRON then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_IRON"] = {
			CheckerFunction =
				function(pPlot)
					--必须在铁资源1个单元格以内
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_IRON"}, 1) then
						return false
					end

					--不能是山脉
					if IsMountainLandTerrain(pPlot) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 3,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有铁则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_IRON"}) then
					return false
				end

				--删去靠近马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Horse
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_HORSES then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_HORSES"] = {
			CheckerFunction =
				function(pPlot)
					--必须在马资源1个单元格以内
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_HORSES"}, 1) then
						return false
					end

					--不能是山脉
					if IsMountainLandTerrain(pPlot) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 3,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有马则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_HORSES"}) then
					return false
				end

				--删去靠近铁、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Coal
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_COAL then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_COAL"] = {
			CheckerFunction =
				function(pPlot)
					--必须是煤资源
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_COAL"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有煤则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_COAL"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Oil
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_OIL then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_OIL"] = {
			CheckerFunction =
				function(pPlot)
					--必须是石油资源
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_OIL"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有石油则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_OIL"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Al
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_ALUMINUM then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_ALUMINUM"] = {
			CheckerFunction =
				function(pPlot)
					--必须是铝1个单元格以内(铝实在是太稀有了)
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_ALUMINUM"}, 1) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 1,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有铝则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_ALUMINUM"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- U
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_URANIUM then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_URANIUM"] = {
			CheckerFunction =
				function(pPlot)
					--必须是铀1个单元格以内(铀实在是太稀有了)
					if not HasCertainResourceWithInXTiles(pPlot, {"RESOURCE_URANIUM"}, 1) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 4,
			Epsilon		= 1,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有铀则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_URANIUM"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Niter
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_NITER then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_NITER"] = {
			CheckerFunction =
				function(pPlot)
					--必须是硝石或盐
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_NITER", "RESOURCE_SALT"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有硝石和盐则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_NITER", "RESOURCE_SALT"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Ivory
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_IVORY then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_IVORY"] = {
			CheckerFunction =
				function(pPlot)
					--必须是象牙
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_IVORY"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有象牙则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_IVORY"}) then
					return false
				end

				--删去靠近铁、马、石头的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Gemstone
-- This one is a conditional entry
-------------------------------------
	if GameInfo.Resources.RESOURCE_JADE then
		g_RegionDefinitions["REGION_MAPLE_LEAVES_PRECIOUS_MINERAL"] = {
			CheckerFunction =
				function(pPlot)
					--必须是稀有宝石
					if not HasCertainResourceThisTile(pPlot, {"RESOURCE_JADE", "RESOURCE_DIAMONDS", "RESOURCE_AMBER", "RESOURCE_MERCURY"}) then
						return false
					end

					--周围必须没有沼泽、地热、火山、蕈林、稀树草原
					local inValid_Feature_List = {
						"FEATURE_MARSH", 
						"FEATURE_GEOTHERMAL_FISSURE", 
						"FEATURE_VOLCANO",
						"FEATURE_JNR_SWAMP",
						"FEATURE_HD_SWAMP",
						"FEATURE_OPH_FUNGAL_FOREST",
						"FEATURE_JNR_SAVANNAH"
					}
					if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
						return false
					end

					return true

				end,
			MinSamples	= 2,
			Epsilon		= 2,
			Dilate		= 1,
			CullingFunction	= function(pPlot)

				--如果这个单元格有稀有宝石则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_JADE", "RESOURCE_DIAMONDS", "RESOURCE_AMBER", "RESOURCE_MERCURY"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

				return false
			end,
		}
	end

-------------------------------------
-- Silver
-- This one is a conditional entry
-------------------------------------
	g_RegionDefinitions["REGION_MAPLE_LEAVES_SILVER"] = {
		CheckerFunction =
			function(pPlot)

				--必须是银
				if not HasCertainResourceThisTile(pPlot, {"RESOURCE_SILVER"}) then
					return false
				end

				return true

			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
				--如果这个单元格有银则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_SILVER"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

			return false
		end,
	}

-------------------------------------
-- Spice
-- This one is a conditional entry
-------------------------------------
	g_RegionDefinitions["IDENTITY_SUK_ML_SPICE_HOMELAND"] = {
		CheckerFunction =
			function(pPlot)

				--必须是熏香或香料
				if not HasCertainResourceThisTile(pPlot, {"RESOURCE_INCENSE", "RESOURCE_SPICES"}) then
					return false
				end

				return true

			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
				--如果这个单元格有熏香或香料则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_INCENSE", "RESOURCE_SPICES"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

			return false
		end,
	}

-------------------------------------
-- Appeal Land
-- This one is a conditional entry
-------------------------------------
	g_RegionDefinitions["REGION_MAPLE_LEAVES_APPEAL_LAND"] = {
		CheckerFunction =
			function(pPlot)
				--必须是迷人魅力
				local appeal = pPlot:GetAppeal()
				if appeal == nil or appeal < 4 then
					return false
				end

				--必须距离水2格及以上，这会同时排斥湖泊、海岸、大河和大湖
				if HasWaterWithInXTiles(pPlot, 3) then
					return false
				end

				--周围必须没有沼泽、地热、火山、泛滥平原、蕈林、稀树草原
				local inValid_Feature_List = {
					"FEATURE_MARSH", 
					"FEATURE_GEOTHERMAL_FISSURE", 
					"FEATURE_VOLCANO",
					"FEATURE_FLOODPLAINS", 
					"FEATURE_FLOODPLAINS_GRASSLAND", 
					"FEATURE_FLOODPLAINS_PLAINS",
					"FEATURE_JNR_SWAMP",
					"FEATURE_HD_SWAMP",
					"FEATURE_OPH_FUNGAL_FOREST",
					"FEATURE_JNR_SAVANNAH"
				}
				if HasCertainFeatureWithInXTiles(pPlot, inValid_Feature_List, 1) then
					return false
				end

				return true

			end,
		MinSamples	= 3,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
				--删除魅力过低地块
				local appeal = pPlot:GetAppeal()
				if appeal ~= nil and appeal < 0 then
					return true
				end

				--删去水单元格
				if pPlot:IsWater() then
					return true
				end

			return false
		end,
	}

-------------------------------------
-- Appeal Sea
-- This one is a conditional entry
-------------------------------------
	g_RegionDefinitions["REGION_MAPLE_LEAVES_APPEAL_COAST"] = {
		CheckerFunction =
			function(pPlot)
				--必须是迷人魅力
				local appeal = pPlot:GetAppeal()
				if appeal == nil or appeal < 4 then
					return false
				end

				--必须是陆地
				if pPlot:IsWater() then
					return false
				end

				--必须靠近水
				if not IsAdjacentToWater(pPlot) then
					return false
				end

				--不能靠近大河
				if IsAdjacentToGreatRiver(pPlot) then
					return false
				end

				return true

			end,
		MinSamples	= 2,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
				--删除魅力过低地块
				local appeal = pPlot:GetAppeal()
				if appeal ~= nil and appeal < 0 then
					return true
				end

			return false
		end,
	}

-------------------------------------
-- Pasture
-- This one is a conditional entry
-------------------------------------
	g_RegionDefinitions["REGION_MAPLE_LEAVES_PASTURE"] = {
		CheckerFunction =
			function(pPlot)
				--必须是草原和平原
				if (not IsPlainsTerrain(pPlot) ) and (not IsGrassTerrain(pPlot) ) then
					return false
				end

				--必须是牛羊
				if not HasCertainResourceThisTile(pPlot, {"RESOURCE_CATTLE", "RESOURCE_SHEEP"}) then
					return false
				end

				return true

			end,
		MinSamples	= 1,
		Epsilon		= 2,
		Dilate		= 1,
		CullingFunction	= function(pPlot)
				--如果这个单元格有牛羊则不删
				if HasCertainResourceThisTile(pPlot, {"RESOURCE_CATTLE", "RESOURCE_SHEEP"}) then
					return false
				end

				--删去靠近铁、马、石头、象牙的单元格
				local inValid_Resource_List = {
					"RESOURCE_IRON", 
					"RESOURCE_HORSES", 
					"RESOURCE_STONE",
					"RESOURCE_IVORY"
				}
				if HasCertainResourceThisTile(pPlot, inValid_Resource_List) then
					return true
				end

				--删去山脉
				if IsMountainLandTerrain(pPlot) then
					return true
				end

			return false
		end,
	}
	


