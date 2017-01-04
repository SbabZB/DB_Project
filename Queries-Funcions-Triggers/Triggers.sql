/*Trigger: BEFORE; prima dell'iserimento di un nuovo viaggio controlla che i porti di partenza e destinazione possano ospitare la nave*/

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

DROP TRIGGER IF EXISTS num_viaggio;
DELIMITER //
CREATE TRIGGER num_viaggio BEFORE INSERT ON Viaggi
FOR EACH ROW
BEGIN
DECLARE num INT(10);
SELECT MAX(Numero) INTO num FROM Viaggi WHERE Nave = NEW.Nave AND Numero != NEW.Numero;
IF NEW.Numero > num+1 THEN
    SET NEW.Numero = num+1;
    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = "ATTENZIONE: Numero viaggio e' stato coretto", MYSQL_ERRNO = '1000';
END IF;
END//
DELIMITER ;
