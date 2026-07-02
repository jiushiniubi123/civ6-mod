-- Do not encode UTF-8 BOM



-- Grand Opera, Rationalism, Simultaneum

UPDATE RequirementArguments SET Value = 4 WHERE Name = 'Amount' AND RequirementId IN
('REQUIRES_THEATER_SQUARE_HAS_HIGH_ADJACENCY', 'REQUIRES_CAMPUS_HAS_HIGH_ADJACENCY', 'REQUIRES_HOLY_SITE_HAS_HIGH_ADJACENCY');



-- Grand Opera, Rationalism, Simultaneum, Free Market

UPDATE RequirementArguments SET Value = 10 WHERE Name = 'Amount' AND RequirementId IN
('REQUIRES_CITY_HAS_HIGH_POPULATION');