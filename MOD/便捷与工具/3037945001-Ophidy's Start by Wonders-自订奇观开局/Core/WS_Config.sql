-- Config
-- Author: Lazire
-- DateCreated: 9/18/2023 10:21:52 PM
--------------------------------------------------------------
INSERT INTO Parameters
(Key1,				
Key2,				
ParameterId,		
Name,							
Description,	
Domain,
Hash,	
Array,				
ConfigurationGroup,	
ConfigurationId,	
GroupId,	
UxHint,			
SortIndex)
SELECT
Key1,				
Key2,				
'StartWonders',		
'LOC_START_NATURAL_WONDERS_NAME',
'LOC_START_NATURAL_WONDERS_DESCRIPTION',
Domain,
Hash,
Array,
ConfigurationGroup,
'START_NATURAL_WONDERS',
GroupId,
NULL,
SortIndex
FROM Parameters WHERE ConfigurationId = 'EXCLUDE_NATURAL_WONDERS';