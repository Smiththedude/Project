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

--###################################
--TOWNS PAGE
--###################################

-- get all towns data for towns with specific alignment
SELECT TownID, TownName, Region, Alignment WHERE
Alignment = :user_chosen_alignemnt

--get a town's data for the Update Town form
SELECT TownID, TownName, Region, Alignment FROM Towns WHERE
TownID = town_id_selected_from_page

--add new town
INSERT INTO Towns (TownID, TownName, Region, Alignment) VALUES
(:TownIDinput, :TownNameinput, :Regioninput, :Alignmentinput)

--associate a town with a shop (M:M)
INSERT INTO Town_Shops (Towns_TownID, Shops_ShopID) VALUES
(:town_id_from_dropdown_input, :shop_id_from_dropdown_input)

--assocoiate a town with a quest (M:M)
INSERT INTO Town_Quests (Towns_TownID, Quests_QuestID) VALUES
(:town_id_from_dropdown_input, :quest_id_from_dropdown_input)

--update a selected town's data based on submission of Update Town form
UPDATE Towns SET TownName = :TownNameinput, Region = Regioninput, 
Alignment = Alignmentinput WHERE TownID = :town_id_from_form

--delete a town
DELETE FROM Towns WHERE TownID = :town_id_selected_from_page

--disassociate a town from a shop
DELETE FROM Town_Shops WHERE
TownID = :town_id_selected_from_town_list AND
ShopID = :shop_id_selected_from_shop_list

--disassociate a town from a quest
DELETE FROM Town_Quests WHERE
TownID = :town_id_selected_from_town_list AND
QuestID = :quest_id_selected_from_shop_list

--###################################
--SHOPS PAGE
--###################################

-- get all shops data for towns with specific type
SELECT ShopID, ShopName, ShopOwner, ShopType, ShopInventory WHERE
ShopType = :user_chosen_type

--get a shop's data for the Update Town form
SELECT ShopID, ShopName, ShopOwner, ShopType, ShopInventory FROM Towns WHERE
ShopID = shop_id_selected_from_page

--get all shops with their associated towns
SELECT Shops.ShopID, Shops.ShopName, Shops.ShopInventory, Towns.TownName
FROM Shops
INNER JOIN Town_Shops ON Shops.ShopID = Town_Shops.ShopID
INNER JOIN Towns ON Town_Shops.TownID = Towns.TownID
GROUP BY TownName
ORDER BY TownName

--add new shop
INSERT INTO Shops (ShopID, ShopName, ShopOwner, ShopType, ShopInventory) VALUES (:ShopIDinput, :ShopNameinput, :ShopOwnerinput, :ShopTypeinput, :ShopInventoryinput)

--associate a shop with a town (M:M)
INSERT INTO Town_Shops (Towns_TownID, Shops_ShopID) VALUES
(:town_id_from_dropdown_input, :shop_id_from_dropdown_input)

--update a selected shop's data based on submission of Update Shop form
UPDATE Shops SET ShopName = :ShopNameinput, ShopOwner = ShopOwnerinput, 
ShopType = ShopTypeinput, ShopInventory = ShopInventoryinput
WHERE ShopID = :shop_id_from_form

--delete a shop
DELETE FROM Shops WHERE ShopID = :shop_id_selected_from_page

--disassociate a shop from a town
DELETE FROM Town_Shops WHERE
TownID = :town_id_selected_from_town_list AND
ShopID = :shop_id_selected_from_shop_list

--###################################
-- POINTS OF INTEREST PAGE
--###################################

-- Query to SELECT all points of interest
SELECT * FROM Points_of_Interest;

-- Query to INSERT a new point of interest
INSERT INTO Points_of_Interest (TownID, POI_Name, POI_Type, POI_History, POI_Desc)
VALUES (@TownID, @POI_Name, @POI_Type, @POI_History, @POI_Desc);

-- Query to UPDATE a point of interest
UPDATE Points_of_Interest
SET POI_Name = @NewPOI_Name, POI_Type = @NewPOI_Type, POI_History = @NewPOI_History, POI_Desc = @NewPOI_Desc
WHERE POI_ID = @POI_ID;

-- Query to DELETE a point of interest
DELETE FROM Points_of_Interest
WHERE POI_ID = @POI_ID;

-- Query to SELECT points of interest by town
SELECT POI_ID, POI_Name, POI_Type, POI_History, POI_Desc
FROM Points_of_Interest
WHERE TownID = @TownID;

--###################################
-- QUESTS PAGE
--###################################

-- Query to SELECT all quests
SELECT * FROM Quests;

-- Query to INSERT a new quest
INSERT INTO Quests (ShopID, POI_ID, QuestName, QuestGiver, QuestDesc, QuestReward, QuestStatus, QuestDiff)
VALUES (@ShopID, @POI_ID, @QuestName, @QuestGiver, @QuestDesc, @QuestReward, @QuestStatus, @QuestDiff);

-- Query to UPDATE a quest
UPDATE Quests
SET QuestName = @NewQuestName, QuestGiver = @NewQuestGiver, QuestDesc = @NewQuestDesc, 
    QuestReward = @NewQuestReward, QuestStatus = @NewQuestStatus, QuestDiff = @NewQuestDiff
WHERE QuestID = @QuestID;

-- Query to DELETE a quest
DELETE FROM Quests
WHERE QuestID = @QuestID;

-- Query to SELECT quests by town
SELECT Quests.QuestID, Quests.QuestName, Quests.QuestGiver, Quests.QuestDesc, Quests.QuestReward, Quests.QuestStatus, Quests.QuestDiff
FROM Quests
INNER JOIN Town_Quests ON Quests.QuestID = Town_Quests.Quests_QuestID
WHERE Town_Quests.Towns_TownID = @TownID;

--###################################
-- RELATIONSHIP TABLES
--###################################

-- Query to associate a town with a shop (M:N)
INSERT INTO Town_Shops (Towns_TownID, Shops_ShopID)
VALUES (@TownID, @ShopID);

-- Query to disassociate a town from a shop
DELETE FROM Town_Shops
WHERE Towns_TownID = @TownID AND Shops_ShopID = @ShopID;

-- Query to associate a town with a quest (M:N)
INSERT INTO Town_Quests (Towns_TownID, Quests_QuestID)
VALUES (@TownID, @QuestID);

-- Query to disassociate a town from a quest
DELETE FROM Town_Quests
WHERE Towns_TownID = @TownID AND Quests_QuestID = @QuestID;