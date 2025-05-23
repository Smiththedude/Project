USE cs340_smithaa5;

-- ###########
-- CREATE Town
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

-- #####################
-- Update Town Alignment
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