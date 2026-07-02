
-- 降低游戏进度系数

update GlobalParameters set Value = 200 where Name = 'GAME_COST_ESCALATION';


-- 收获掠夺

update Resource_Harvests set Amount = 20 where YieldType = 'YIELD_FOOD';
update Resource_Harvests set Amount = 20 where YieldType = 'YIELD_PRODUCTION';
update Resource_Harvests set Amount = 40 where YieldType = 'YIELD_GOLD';
update Districts set PlunderAmount = 40 where PlunderType = 'PLUNDER_GOLD';
update Districts set PlunderAmount = 30 where PlunderType = 'PLUNDER_FAITH';
update Districts set PlunderAmount = 20 where PlunderType = 'PLUNDER_CULTURE';
update Districts set PlunderAmount = 20 where PlunderType = 'PLUNDER_SCIENCE';
update Districts set PlunderAmount = 40 where PlunderType = 'PLUNDER_HEAL';
update Improvements set PlunderAmount = 40 where PlunderType = 'PLUNDER_GOLD';
update Improvements set PlunderAmount = 30 where PlunderType = 'PLUNDER_FAITH';
update Improvements set PlunderAmount = 20 where PlunderType = 'PLUNDER_CULTURE';
update Improvements set PlunderAmount = 20 where PlunderType = 'PLUNDER_SCIENCE';
update Improvements set PlunderAmount = 40 where PlunderType = 'PLUNDER_HEAL';


-- 资源可以收获,铝产量+1



insert or replace into Resource_Harvests (ResourceType, YieldType, Amount, PrereqTech) values
	('RESOURCE_HORSES',	'YIELD_PRODUCTION',	30,		'TECH_ANIMAL_HUSBANDRY'),
	('RESOURCE_IRON',	'YIELD_PRODUCTION',	35,		'TECH_BRONZE_WORKING'),
	('RESOURCE_NITER',	'YIELD_PRODUCTION',	40,		'TECH_GUNPOWDER'),
	('RESOURCE_COAL',	'YIELD_PRODUCTION',	45,		'TECH_STEAM_POWER'),
	('RESOURCE_OIL',		'YIELD_PRODUCTION',	50,		'TECH_SCIENTIFIC_THEORY'),
	('RESOURCE_ALUMINUM',	'YIELD_PRODUCTION',	60,		'TECH_REPLACEABLE_PARTS'),
	('RESOURCE_URANIUM',	'YIELD_PRODUCTION',	70,		'TECH_COMBINED_ARMS'),
	('RESOURCE_ANTIQUITY_SITE',	'YIELD_CULTURE',	40,		NULL),
	('RESOURCE_SHIPWRECK',		'YIELD_CULTURE',	40,		NULL);
update Resource_Consumption set ImprovedExtractionRate= 3 where ResourceType="RESOURCE_ALUMINUM";






-- 区域价格

-- progression with number of previous copies

-- update cost progression model and cost
-- specialized districts 
update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 12, Cost = 54 
 where DistrictType = 'DISTRICT_HOLY_SITE'				--圣地
	or DistrictType = 'DISTRICT_CAMPUS'					--学院
	or DistrictType = 'DISTRICT_ENCAMPMENT'				--军营
	or DistrictType = 'DISTRICT_COMMERCIAL_HUB'			--商业
	or DistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or DistrictType = 'DISTRICT_THEATER'				--剧院
	or DistrictType = 'DISTRICT_INDUSTRIAL_ZONE'		--工业
	or DistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
	or DistrictType = 'DISTRICT_HARBOR' --港口
;


-- unique districts
update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 8, Cost = 36 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where
	ReplacesDistrictType = 'DISTRICT_HOLY_SITE'					--圣地
	or ReplacesDistrictType = 'DISTRICT_CAMPUS'					--学院
	or ReplacesDistrictType = 'DISTRICT_ENCAMPMENT'				--军营
	or ReplacesDistrictType = 'DISTRICT_COMMERCIAL_HUB'			--商业
	or ReplacesDistrictType = 'DISTRICT_ENTERTAINMENT_COMPLEX'	--娱乐
	or ReplacesDistrictType = 'DISTRICT_THEATER'				--剧院
	or ReplacesDistrictType = 'DISTRICT_INDUSTRIAL_ZONE'		--工业
	or ReplacesDistrictType = 'DISTRICT_WATER_ENTERTAINMENT_COMPLEX' --水上娱乐
	or ReplacesDistrictType = 'DISTRICT_HARBOR' --港口
);

--normal districts
update Districts set CostProgressionModel = 'NO_COST_PROGRESSION', CostProgressionParam1 = 0
 where DistrictType = 'DISTRICT_GOVERNMENT'				--政府区
	or DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER'		--外交区
	or DistrictType = 'DISTRICT_AERODROME'				--空港
	or DistrictType = 'DISTRICT_AQUEDUCT'				--水渠
	or DistrictType = 'DISTRICT_NEIGHBORHOOD'			--社区
	or DistrictType = 'DISTRICT_CANAL'					--运河
	or DistrictType = 'DISTRICT_DAM'					--大坝
	or DistrictType = 'DISTRICT_THANH'					--城池（越南）
	or DistrictType = 'DISTRICT_PRESERVE'				--保护区
;

update Districts set Cost = 60 where DistrictType = 'DISTRICT_GOVERNMENT';
update Districts set Cost = 60 where DistrictType = 'DISTRICT_DIPLOMATIC_QUARTER';
update Districts set Cost = 60 where DistrictType = 'DISTRICT_HARBOR';
update Districts set Cost = 60 where DistrictType = 'DISTRICT_AQUEDUCT';
update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 0, Cost = 50 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where
	ReplacesDistrictType = 'DISTRICT_AQUEDUCT'
	or ReplacesDistrictType = 'DISTRICT_PRESERVE'
	or ReplacesDistrictType = 'DISTRICT_GOVERNMENT'
	or ReplacesDistrictType = 'DISTRICT_DIPLOMATIC_QUARTER'
);

update Districts set CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 0, Cost = 90 where DistrictType in 
(select CivUniqueDistrictType from DistrictReplaces where ReplacesDistrictType = 'DISTRICT_NEIGHBORHOOD');

update Districts set Cost = 60 where DistrictType = 'DISTRICT_THANH';

update Districts set Cost = 150 where DistrictType = 'DISTRICT_AERODROME';
update Districts set Cost = 100 where DistrictType = 'DISTRICT_CANAL';
update Districts set Cost = 100 where DistrictType = 'DISTRICT_DAM';

-- Ally 同盟点数需求
update GlobalParameters set Value = 240 where Name = 'ALLIANCE_LEVEL_TWO_XP'; --60点数到2级
update GlobalParameters set Value = 360 where Name = 'ALLIANCE_LEVEL_THREE_XP';--原版风云960




--开拓者费用
update Units set Cost="20", CostProgressionParam1="50" where UnitType = 'UNIT_SETTLER';

--扩地7环，人口增长
update GlobalParameters set Value = 7 where Name = 'PLOT_INFLUENCE_MAX_ACQUIRE_DISTANCE';
update Boosts set NumItems = 5 where CivicType = 'CIVIC_EARLY_EMPIRE';
update Boosts set NumItems = 8 where CivicType = 'CIVIC_CIVIL_SERVICE';
update GlobalParameters set Value = 12 where Name = 'CITY_GROWTH_THRESHOLD';
update GlobalParameters set Value = 10 where Name = 'CITY_GROWTH_MULTIPLIER';
update GlobalParameters set Value = 1.6 where Name = 'CITY_GROWTH_EXPONENT';


-- 远程单位对城墙造成70%的伤害，而不是50%（但-17攻击力仍然存在）野蛮人科技
update GlobalParameters set Value = 70 where Name = 'COMBAT_DEFENSE_DAMAGE_PERCENT_RANGED';
update GlobalParameters set Value = 80 where Name = 'BARBARIAN_TECH_PERCENT';


--用来降低遗物的价格（顺便降低了其他的
 insert or replace into PseudoYields
     (PseudoYieldType,                       DefaultValue)
 values
     ('PSEUDOYIELD_TOURISM',                 0);


-- 2倍二氧化碳
--------------------------------------------------------------
UPDATE Maps_XP2 SET CO2For1DegreeTempRise=CO2For1DegreeTempRise*3;




-- 战略储存增加
update Resource_Consumption set StockpileCap = 100 where StockpileCap = 50;



-- 奇观修改
insert or replace into Feature_YieldChanges(FeatureType,YieldType,YieldChange)
values
('FEATURE_CRATER_LAKE','YIELD_PRODUCTION',2),
('FEATURE_CRATER_LAKE','YIELD_FOOD',2),
('FEATURE_CRATER_LAKE','YIELD_SCIENCE',2),
('FEATURE_CRATER_LAKE','YIELD_FAITH',1);





