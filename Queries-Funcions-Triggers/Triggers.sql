/*Trigger: BEFORE; prima dell'iserimento di un nuovo viaggio controlla che i porti di partenza e destinazione possano ospitare la nave*/

DROP TRIGGER IF EXISTS comp_viaggi;
DELIMITER //
CREATE TRIGGER comp_viaggi AFTER INSERT ON Viaggi
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

/*Controllo di pertinenza tra il grado e la qualficia dei nuovi aggiunti alla tabella Personale*/
DROP TRIGGER IF EXISTS controlloQualificagrado;
DELIMITER //
CREATE TRIGGER controlloQualificagrado AFTER INSERT ON Personale
FOR EACH ROW
BEGIN

DECLARE msg VARCHAR(128);
SET msg = 'Inserito valore per Grado non coerente con Qualifica.';

IF NEW.Qualifica = 'Cuoco' and NEW.Grado != 'Cuoco' or NEW.Qualifica =  'Cuoco' and NEW.Grado != 'Aiuto Cuoco'
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = msg;

ELSEIF NEW.Qualifica = 'Marinaio' and NEW.Grado != 'Mozzo' or NEW.Qualifica = 'Marinaio' and NEW.Grado != 'Marinaio Scelto'
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = msg;

ELSEIF NEW.Qualifica = 'Tecnico' and NEW.Grado != 'Operaio' or NEW.Qualifica = 'Tecnico' and NEW.Grado != 'Elettricista'
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = msg;

ELSEIF NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Secondo di Macchina'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Secondo di coperta'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Comandante'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Capo Macchinista'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Primo di coperta'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Primo di Macchina'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Allievo di Macchina'
or NEW.Qualifica = 'Ufficiale' and NEW.Grado != 'Allievo di Coperta'
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = msg;

END IF;

END//
DELIMITER ;

THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Inserito valore per Grado non coerente con Qualifica.';

END IF
END//

DELIMITER;
