DROP TRIGGER IF EXISTS comp_viaggi;
DELIMITER //
CREATE TRIGGER comp_viaggi BEFORE INSERT ON Viaggi
FOR EACH ROW
BEGIN
DECLARE comp VARCHAR(13);
DECLARE valid INT(1);
SELECT compatibilita(NEW.Nave,NEW.Porto_partenza) INTO comp;
IF comp = "compatibile" THEN
    SELECT compatibilita(NEW.Nave,NEW.Porto_destinazione) INTO comp;
    IF comp = "compatibile" THEN SET valid = 1;
    ELSE SET valid = 0;
    END IF;
ELSE SET valid = 0;
END IF;
IF valid = 0 THEN
SIGNAL SQLSTATE VALUE '45000'
SET MESSAGE_TEXT = "INCOMPATIBILITA' PORTI Partenza/Destinazione con la classe";
END IF;
END//
DELIMITER ;
