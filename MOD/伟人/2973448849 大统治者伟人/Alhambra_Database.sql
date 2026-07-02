-- Alhambra the Great Sovereign Wonder

DELETE FROM BuildingModifiers WHERE ModifierId = 'ALHAMBRA_MILITARY_GOVERNMENT_SLOT';
DELETE FROM Building_GreatPersonPoints WHERE BuildingType = 'BUILDING_ALHAMBRA';

UPDATE Buildings
SET AdjacentDistrict = 'DISTRICT_GOVERNMENT'
WHERE BuildingType = 'BUILDING_ALHAMBRA';

INSERT INTO BuildingModifiers
		(BuildingType,						ModifierId)
VALUES	('BUILDING_ALHAMBRA',				'PLATI_GRANT_GREAT_SOVEREIGN'),
		('BUILDING_ALHAMBRA',				'PLATI_UNLOCK_ALCAZAR');
