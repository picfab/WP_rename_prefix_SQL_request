# MODIFIER Les 3 variables suivantes
# puis copier coller le code dans votre phpMyAdmin
SET @database  = "local"; # NOM_DE_LA_BASE_DE_DONNEES
SET @oldprefix = "wp_"; # ancien prefix
SET @newprefix = "NOUVEAUX_PREFIX_"; # nouveau prefix sous la forme PREFIX_
# Fin

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
    oldPre VARCHAR(255),
    newPre VARCHAR(255),
    INOUT request LONGTEXT
  )
BEGIN
    DECLARE table_rename VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    DECLARE table_cursor CURSOR FOR
         SELECT
                concat(
                    "RENAME TABLE ",
                    TABLE_NAME,
                    " TO ",
                    replace(TABLE_NAME, oldPre, newPre),
                    ';'
                ) AS "SQL"
            FROM information_schema.TABLES WHERE TABLE_SCHEMA = db;
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

CALL while_modification_prefix_wp(@database,@oldprefix,@newprefix,@request );

DROP PROCEDURE IF EXISTS while_modification_prefix_wp;
DROP PROCEDURE IF EXISTS modification_prefix_wp;

SET @query = CONCAT("UPDATE `",@newprefix,"usermeta`
SET meta_key = REPLACE(meta_key, '",@oldprefix,"', '",@newprefix,"')
WHERE meta_key LIKE '",@oldprefix,"%'");
PREPARE stmt FROM @query;
EXECUTE stmt;

SET @query = CONCAT("UPDATE `",@newprefix,"options`
SET option_name = '",@newprefix,"user_roles'
WHERE option_name LIKE '",@oldprefix,"user_roles';");
PREPARE stmt FROM @query;
EXECUTE stmt;

