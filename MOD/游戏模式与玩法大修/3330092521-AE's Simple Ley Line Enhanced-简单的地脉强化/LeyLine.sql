-- LeyLine
-- Author: Another Eve
-- DateCreated: 9/13/2024 9:41:51 AM
--------------------------------------------------------------
update Resources set Frequency = 20 where ResourceType = 'RESOURCE_LEY_LINE';   

insert into Resource_YieldChanges(ResourceType,YieldType,YieldChange)
values
('RESOURCE_LEY_LINE','YIELD_PRODUCTION','1');

insert into Resource_Harvests(ResourceType,YieldType,Amount)
values
('RESOURCE_LEY_LINE','YIELD_PRODUCTION',10);

insert into Improvement_ValidResources(ImprovementType,ResourceType)
values
('IMPROVEMENT_QUARRY','RESOURCE_LEY_LINE'),
('IMPROVEMENT_FARM','RESOURCE_LEY_LINE');