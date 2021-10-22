# MODIFIER Les 3 variables suivantes
# puis copier coller le code dans votre phpMyAdmin
SET @db  = "local";
SET @oldProto = "http://";
SET @oldUrl = "localhost:10005";
SET @newProto = "http://";
SET @newUrl = "localhost:10004";

SET @request = "";
DROP PROCEDURE IF EXISTS modification_prefix_wp;
DROP PROCEDURE IF EXISTS while_modification_prefix_wp;

DELIMITER //
CREATE PROCEDURE modification_prefix_wp( p_sql LONGTEXT)
BEGIN
  SET @tquery = p_sql;
  PREPARE stmt FROM @tquery;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE while_modification_prefix_wp(
    db VARCHAR(255),
    oldProto VARCHAR(255),
    oldUrl VARCHAR(255),
    newProto VARCHAR(255),
    newUrl VARCHAR(255),
    INOUT request LONGTEXT
  )
BEGIN
    DECLARE table_rename LONGTEXT;
    DECLARE done INT DEFAULT 0;

    DECLARE table_cursor CURSOR FOR
         SELECT
            concat(
                "UPDATE ",
                TABLE_NAME,
                " SET ",COLUMN_NAME,"=",
                "REPLACE(",COLUMN_NAME,",'", oldProto, oldUrl,"','", newProto, newUrl,"')",
                " WHERE ",
                COLUMN_NAME," LIKE '%",
                oldProto,
                oldUrl,
                "%';"
            ) AS "SQL"
        FROM information_schema.columns WHERE TABLE_SCHEMA = db  AND DATA_TYPE IN ('varchar','longtext','tinytext','mediumtext')
        order by table_name,ordinal_position;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN table_cursor;
		table_loop: LOOP
              FETCH table_cursor INTO table_rename;
              IF done THEN
                LEAVE table_loop;
              END IF;
			SET request = table_rename;
            	CALL modification_prefix_wp(request);
         END LOOP;

    CLOSE table_cursor;
END//

DELIMITER ;

CALL while_modification_prefix_wp(@db,@oldProto,@oldUrl,@newProto,@newUrl,@request );
CALL while_modification_prefix_wp(@db,'',@oldUrl,'',@newUrl,@request );

DROP PROCEDURE IF EXISTS while_modification_prefix_wp;
DROP PROCEDURE IF EXISTS modification_prefix_wp;


