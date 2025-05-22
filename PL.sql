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

