--OSU CS340 Project
-- DnD Towns/Quests Database
-- PL/SQL to drop procedure
DROP PROCEDURE IF EXISTS sp_load_townsdb;
DELIMITER //
CREATE PROCEDURE sp_load_townsdb()
BEGIN
  -- Drop the database if it exists
  -- Create database if not exisiting

  SET FOREIGN_KEY_CHECKS=0;
  SET AUTOCOMMIT = 0;

  /* Drop tables and existing foreign-key depending tables in correct order to avoid errors */

  DROP TABLE IF EXISTS `Town_Quests`;
  DROP TABLE IF EXISTS `Town_Shops`;
  DROP TABLE IF EXISTS `Quests`;
  DROP TABLE IF EXISTS `Points_of_Interest`;
  DROP TABLE IF EXISTS `Shops`;
  DROP TABLE IF EXISTS `Towns`;


  /* Create 'Towns' Table */

  CREATE TABLE `Towns` (
    `TownID` int(11) NOT NULL AUTO_INCREMENT,         /* Unique ID for each Town */
    `TownName` varchar(45) NOT NULL,                  /* Name of the town */
    `Region` varchar(45) NOT NULL,                    /* Region the town is in */
    `Alignment` varchar(45) NOT NULL,                 /* Moral alignment of each town */
    PRIMARY KEY (`TownID`),
    UNIQUE KEY `TownID_UNIQUE` (`TownID`),
    UNIQUE KEY `TownName_UNIQUE` (`TownName`)
  );


  /* Sample data to insert into 'Towns' */

  INSERT INTO `Towns` 
  VALUES 
    (1, 'Neverwinter', 'Sword Coast', 'NG'),
    (2, 'Baldur''s Gate', 'Forgotten Realms', 'NN'),
    (3, 'Radiant Citadel', 'Ethereal Plane', 'LG'),
    (4, 'Menzoberranzan', 'Forgotten Realms', 'CE');


  /* Table to store notable landmarks or areas within each town */
  CREATE TABLE `Points_of_Interest` (
    `POIID` int(11) NOT NULL AUTO_INCREMENT,              /* Unique ID for each POI */
    `Towns_TownID` int(11) NOT NULL,                      /* FK to Towns */
    `POI_Name` varchar(45) NOT NULL,                      /* Name of POI */
    `POI_Type` varchar(45) NOT NULL,                      /* Type of POI */
    `POI_History` text NOT NULL,                          /* Background on each POI */
    `POI_Desc` text NOT NULL,                             /* Description text */
    PRIMARY KEY (`POIID`),
    UNIQUE KEY `poiID_UNIQUE` (`POIID`),
    UNIQUE KEY `poiName_UNIQUE` (`POI_Name`),
    KEY `fk_Points_of_Interest_Towns1_idx` (`Towns_TownID`),
    CONSTRAINT `fk_Points_of_Interest_Towns1` FOREIGN KEY (`Towns_TownID`) REFERENCES `Towns` (`TownID`) ON DELETE CASCADE ON UPDATE CASCADE
  );


  /* Sample Data for POI */
  INSERT INTO `Points_of_Interest` VALUES (5,1,'Statue of Lorde','Quest Point','','A tall statue of an ancient warrior cast in brone and weathered over the ages.'),
  (6,3,'Menthre''s Peak','Viewpoint','','The highest point of Baldur''s Gate that looks out over the area.'),
  (7,1,'Emerald Cove','Quest Point','','An old cove used by pirates of the Sword Coast to hide themselves from patrolling Imperial ships.'),
  (8,4,'Thay Hatchery','Misc.','','An ancient hatching ground used by the Thay to grow their numbers.');

  /* All available Shops in the world */
  CREATE TABLE `Shops` (
      `ShopID` INT NOT NULL AUTO_INCREMENT,           /* Unique ID for each Shop */
      `ShopName` VARCHAR(45) NOT NULL,                /* Name of the shop */
      `ShopOwner` VARCHAR(45) NOT NULL,               /* Owner of the shop */
      `ShopType` VARCHAR(45) NOT NULL,                /* Type of shop */
      `ShopInventory` TEXT DEFAULT NULL,              /* Items the shop sells */
      PRIMARY KEY (`ShopID`)
  );

  /* Sample data for Shops */

  INSERT INTO `Shops` 
  VALUES 
  (1, 'Arm & Mint', 'Burg', 'Armaments', 'Broadsword, Dagger, Dirk, Wooden Shield, Leather Cuirass, Chainmail, Leather Helmet, Leather Boots'),
  (2, 'What Ales You', 'Lambert', 'Tavern', 'Ale, Lager, Rum, Mead'),
  (3, 'Plane ol'' Beds', 'Krul''un', 'Inn', NULL),
  (4, 'Blain''s', 'David', 'Magics', 'Eldritch Blast, Create Bonfire, Flaming Touch, Ray of Frost, Prestidigitation, Healing Word');




  /* Intersection table for Towns and Shops for the many-to-many relationship */

  CREATE TABLE `Town_Shops` (
    `Towns_TownID` int(11) NOT NULL,                          /* Town ID */
    `Shops_ShopID` int(11) NOT NULL,                          /* Shop ID */
    PRIMARY KEY (`Towns_TownID`,`Shops_ShopID`),
    KEY `fk_Towns_has_Shops_Shops1_idx` (`Shops_ShopID`),
    KEY `fk_Towns_has_Shops_Towns_idx` (`Towns_TownID`),
    CONSTRAINT `fk_Towns_has_Shops_Shops1` FOREIGN KEY (`Shops_ShopID`) REFERENCES `Shops` (`ShopID`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_Towns_has_Shops_Towns` FOREIGN KEY (`Towns_TownID`) REFERENCES `Towns` (`TownID`) ON DELETE CASCADE ON UPDATE CASCADE
  ) ;



  /* Sample data for Town_Shops */
  INSERT INTO `Town_Shops` VALUES (1,1),(1,3),(2,1),(2,3),(3,3),(4,2),(4,3);




  /* Available quests in the world */
  CREATE TABLE `Quests` (
    `QuestID` int(11) NOT NULL AUTO_INCREMENT,            /* Quest ID */
    `Points_of_Interest_POIID` int(11) DEFAULT NULL,
    `Shops_ShopID` int(11) DEFAULT NULL,
    `QuestName` varchar(45) NOT NULL,
    `QuestGiver` varchar(45) NOT NULL,
    `QuestDesc` varchar(255) NOT NULL,
    `QuestReward` varchar(255) NOT NULL,
    `QuestStatus` varchar(45) NOT NULL,
    `QuestDiff` int(11) NOT NULL,               /* Difficulty of the quest (scale of 10) */
    PRIMARY KEY (`QuestID`),
    UNIQUE KEY `QuestID_UNIQUE` (`QuestID`),
    UNIQUE KEY `QuestName_UNIQUE` (`QuestName`),
    UNIQUE KEY `QuestGiver_UNIQUE` (`QuestGiver`),
    KEY `fk_Quests_Points_of_Interest1_idx` (`Points_of_Interest_POIID`),
    KEY `fk_Quests_Shops1_idx` (`Shops_ShopID`),
    CONSTRAINT `Quests_POI` FOREIGN KEY (`Points_of_Interest_POIID`) REFERENCES `Points_of_Interest` (`POIID`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `Quests_Shop` FOREIGN KEY (`Shops_ShopID`) REFERENCES `Shops` (`ShopID`) ON DELETE CASCADE ON UPDATE CASCADE
  ) ;



  /* Sample data for Quests */
  INSERT INTO `Quests` 
  VALUES 
  (18, NULL, NULL, 'Hard Knock Lives', 'Automatic', 'A fateful meeting of a motley crue of unlikely heroes', '20xp', 'Started', 1),
  (19, NULL, 2, 'A Feast of Flavor', 'Lambert', 'The city of Neverwinter is holding their annual tavern crawl. The party that manages to finish an ale at every tavern in the city gets a nice prize.', '30xp, 500 gold', 'Not Started', 2),
  (20, 5, NULL, 'The Sword of 1000 Truths', 'Statue of Lorde', 'A clue left on the statue at the edge of town holds promise of a great weapon, should one be able to decipher it.', '50xp, Sword of 1000 Truths', 'Not Started', 5),
  (21, NULL, NULL, 'Hit the Town', 'Quest Board', 'Explore the town, meet the people and see the sights.', '15xp', 'Not Started', 1);


  /* Intersection table for the many-to-many relationship between Towns and Quests */
  CREATE TABLE `Town_Quests` (
    `Towns_TownID` int(11) NOT NULL,
    `Quests_QuestID` int(11) NOT NULL,
    PRIMARY KEY (`Towns_TownID`,`Quests_QuestID`),
    KEY `Town_Quests_Quests_idx` (`Quests_QuestID`),
    CONSTRAINT `Town_Quests_Quests` FOREIGN KEY (`Quests_QuestID`) REFERENCES `Quests` (`QuestID`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `Town_Quests_Towns` FOREIGN KEY (`Towns_TownID`) REFERENCES `Towns` (`TownID`) ON DELETE CASCADE ON UPDATE CASCADE
  ) ;


  /* Sample data for Town_Quests */
  INSERT INTO `Town_Quests` VALUES (1,19),(1,20),(1,21),(2,21),(3,21),(4,21);

  SET FOREIGN_KEY_CHECKS=1;

END //
DELIMITER ;
-- Call the procedure to load/reset the database
-- CALL sp_load_townsdb();
