USE cs340_smithaa5;

-- ###########
-- CREATE TOWN
-- ###########

DROP PROCEDURE IF EXISTS sp_create_town;

DELIMITER //
CREATE PROCEDURE sp_create_town(
    IN t_name VARCHAR(50),
    IN t_region VARCHAR(50),
    IN t_alignment VARCHAR(50),
    OUT t_id INT
)

BEGIN
    -- Insert the new town into the Towns table
    INSERT INTO Towns (TownName, Region, Alignment)
    VALUES (t_name, t_region, t_alignment);

    -- Get the ID of the newly created town
    SELECT LAST_INSERT_ID() INTO t_id;
    -- Display the ID of the newly created town
    SELECT LAST_INSERT_ID() AS 'new_t_id';

    -- Example procedure call
    -- CALL sp_create_town('Icewind Dale', 'Sword Coast', 'LG', @t_id);
    -- SELECT @t_id AS 'TownID';
END //
DELIMITER ;

-- ###########
-- CREATE SHOP
-- ###########

DROP PROCEDURE IF EXISTS sp_create_shop;

DELIMITER //
CREATE PROCEDURE sp_create_shop(
    IN shop_name VARCHAR(50),
    IN shop_owner VARCHAR(50),
    IN shop_type VARCHAR(50),
    OUT new_s_id INT
)

BEGIN
    -- Insert the new shop into the Shops table
    INSERT INTO Shops (ShopName, ShopOwner, ShopType)
    VALUES (shop_name, shop_owner, shop_type);

    -- Get the ID of the newly created shop
    SELECT LAST_INSERT_ID() INTO new_s_id;
    -- Display the ID of the newly created shop
    SELECT LAST_INSERT_ID() AS 'new_s_id';

    -- Example procedure call
    -- CALL sp_create_shop('Grog''s Grogs', 'Grog', 'Tavern', @new_s_id);
    -- SELECT @new_s_id AS 'ShopID';
END //
DELIMITER ;


-- ##############################
-- CREATE TOWN-QUEST RELATIONSHIP
-- ##############################

DROP PROCEDURE IF EXISTS sp_add_town_quest;

DELIMITER //
CREATE PROCEDURE sp_add_town_quest (
    IN t_id INT,
    IN q_id INT,
    OUT msg VARCHAR(255)
)
BEGIN
    DECLARE rel_unique INT;

    -- Check if the town-quest relationship already exists
    SELECT COUNT(*) INTO rel_unique
    FROM Town_Quests
    WHERE Towns_TownID = t_id AND Quests_QuestID = q_id;

    IF rel_unique > 0 THEN
        SET msg = 'Relationship already exists.';
    ELSE
        INSERT INTO Town_Quests (Towns_TownID, Quests_QuestID)
        VALUES (t_id, q_id);
        SET msg = 'Relationship added successfully.';
    END IF;
END //

DELIMITER ;

-- #####################
-- UPDATE TOWN ALIGNMENT
-- #####################

DROP PROCEDURE IF EXISTS sp_update_town_alignment;

DELIMITER //
CREATE PROCEDURE sp_update_town_alignment(
    IN t_id INT,
    IN new_alignment VARCHAR(50)
)
BEGIN
    -- Update the alignment of the specified town
    UPDATE Towns
    SET Alignment = new_alignment
    WHERE TownID = t_id;

    -- Example procedure call
    -- CALL sp_update_town_alignment(1, 'CG');
END //
DELIMITER ;

-- ###########
-- UPDATE SHOP
-- ###########

DROP PROCEDURE IF EXISTS sp_update_shop;

DELIMITER //
CREATE PROCEDURE sp_update_shop(
    IN s_id INT,
    IN shop_name VARCHAR(50),
    IN shop_owner VARCHAR(50),
    IN shop_type VARCHAR(50),
    OUT msg VARCHAR(255)
)
BEGIN
    -- Update the name, owner and type of the specified shop
    -- Only update fields that are not NULL (none are required)
    IF shop_name IS NOT NULL AND shop_name != '' THEN
        UPDATE Shops
        SET ShopName = shop_name
        WHERE ShopID = s_id;
    END IF;

    IF shop_owner IS NOT NULL AND shop_owner != '' THEN
        UPDATE Shops
        SET ShopOwner = shop_owner
        WHERE ShopID = s_id;
    END IF;

    IF shop_type IS NOT NULL AND shop_type != '' THEN
        UPDATE Shops
        SET ShopType = shop_type
        WHERE ShopID = s_id;
    END IF;

    -- Example procedure call
    -- CALL sp_update_shop(1, 'Grog''s Grogs', 'Grog', 'Tavern');
    -- SELECT @msg AS 'Message';
    SET msg = 'Shop updated successfully.';
    SELECT msg AS 'Message';
END //
DELIMITER ;

-- ##############################
-- UPDATE TOWN-QUEST RELATIONSHIP
-- ##############################
DROP PROCEDURE IF EXISTS sp_update_town_quest;
DELIMITER //
CREATE PROCEDURE sp_update_town_quest (
    IN old_t_id INT,
    IN old_q_id INT,
    IN new_t_id INT,
    IN new_q_id INT,
    OUT msg VARCHAR(255)
)
BEGIN
    DECLARE old_exists INT;
    DECLARE new_exists INT;

    -- Check if the old town-quest relationship exists
    SELECT COUNT(*) INTO old_exists
    FROM Town_Quests
    WHERE Towns_TownID = old_t_id AND Quests_QuestID = old_q_id;

    -- Check if the new town-quest relationship already exists
    SELECT COUNT(*) INTO new_exists
    FROM Town_Quests
    WHERE Towns_TownID = new_t_id AND Quests_QuestID = new_q_id;

    IF old_exists = 0 THEN
        SET msg = 'Relationship does not exist.';

    ELSEIF new_exists > 0 THEN
        SET msg = 'New relationship already exists.';

    ELSE
        UPDATE Town_Quests
        SET Towns_TownID = new_t_id,
            Quests_QuestID = new_q_id
        WHERE Towns_TownID = old_t_id AND Quests_QuestID = old_q_id;

        SET msg = 'Relationship updated successfully.';
    END IF;

END //
DELIMITER ;

-- ###########
-- CREATE QUEST
-- ###########

DROP PROCEDURE IF EXISTS sp_create_quest;
DELIMITER //
CREATE PROCEDURE sp_create_quest(
    IN q_name VARCHAR(50),
    IN q_giver VARCHAR(50),
    IN q_desc TEXT,
    IN q_reward VARCHAR(100),
    IN q_status VARCHAR(50),
    IN q_diff INT,
    IN shop_id INT,
    IN poi_id INT,
    OUT q_id INT
)
BEGIN
    -- Insert the new quest into the Quests table
    INSERT INTO Quests (QuestName, QuestGiver, QuestDesc, QuestReward, QuestStatus, QuestDiff, Shops_ShopID, Points_of_Interest_POIID)
    VALUES (q_name, q_giver, q_desc, q_reward, q_status, q_diff, shop_id, poi_id);

    -- Get the ID of the newly created quest
    SELECT LAST_INSERT_ID() INTO q_id;
    
    -- Display the ID of the newly created quest
    SELECT LAST_INSERT_ID() AS 'new_q_id';
END //
DELIMITER ;

-- ###########
-- UPDATE QUEST
-- ###########

DROP PROCEDURE IF EXISTS sp_update_quest;
DELIMITER //
CREATE PROCEDURE sp_update_quest(
    IN q_id INT,
    IN q_status VARCHAR(50),
    IN q_reward VARCHAR(100),
    IN q_diff INT,
    OUT msg VARCHAR(255)
)
BEGIN
    -- Update the quest in the Quests table
    UPDATE Quests
    SET QuestStatus = CASE WHEN q_status IS NOT NULL AND q_status != '' THEN q_status ELSE QuestStatus END,
        QuestReward = CASE WHEN q_reward IS NOT NULL AND q_reward != '' THEN q_reward ELSE QuestReward END,
        QuestDiff = CASE WHEN q_diff IS NOT NULL AND q_diff != '' THEN q_diff ELSE QuestDiff END
    WHERE QuestID = q_id;

    SET msg = 'Quest updated successfully.';
END //
DELIMITER ;

-- ###########
-- CREATE POI
-- ###########

DROP PROCEDURE IF EXISTS sp_create_poi;
DELIMITER //
CREATE PROCEDURE sp_create_poi(
    IN poi_name VARCHAR(100),
    IN poi_type VARCHAR(50),
    IN poi_history TEXT,
    IN poi_desc TEXT,
    IN town_id INT,
    OUT new_poi_id INT
)
BEGIN
    -- Insert the new POI into the Points_of_Interest table
    INSERT INTO Points_of_Interest (POI_Name, POI_Type, POI_History, POI_Desc, Towns_TownID)
    VALUES (poi_name, poi_type, poi_history, poi_desc, town_id);

    -- Get the ID of the newly created POI
    SELECT LAST_INSERT_ID() INTO new_poi_id;
    
    -- Display the ID of the newly created POI
    SELECT LAST_INSERT_ID() AS 'new_poi_id';
    
    -- Example procedure call
    -- CALL sp_create_poi('Dragon Cave', 'Cave', 'Ancient dragon lair', 'Dark and dangerous cave', 1, @poi_id);
    -- SELECT @poi_id AS 'POIID';
END //
DELIMITER ;