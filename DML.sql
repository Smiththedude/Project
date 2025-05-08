-- Query to SELECT all towns
SELECT * FROM Towns;

-- Query to INSERT a new town
INSERT INTO Towns (TownName, Region, Alignment)
VALUES (@TownName, @Region, @Alignment);

-- Query to UPDATE a town's region and alignment
UPDATE Towns
SET Region = @NewRegion, Alignment = @NewAlignment
WHERE TownID = @TownID;

-- Query to DELETE a town by its ID
DELETE FROM Towns
WHERE TownID = @TownID;

-- Query to SELECT a specific town by its ID
SELECT * FROM Towns
WHERE TownID = @TownID;

-- Query to SELECT towns by region
SELECT * FROM Towns
WHERE Region = @Region;