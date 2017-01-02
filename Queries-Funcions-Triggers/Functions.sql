/* Funzione per trovare la nave, più vecchia che ha effettuato il più alto numero di viaggi in un determinato periodo di tempo */

DELIMITER //

CREATE FUNCTION	maxViaggi(inizio DATE, fine DATE)
RETURNS CHAR(10)
BEGIN
DECLARE num INT;
DECLARE nav CHAR(10);
SELECT Nave INTO nav
	FROM (SELECT Nave, count(*) cont FROM Viaggi WHERE Inizio_viaggio >= inizio AND Fine_viaggio <= fine GROUP BY Nave) AS cv
		JOIN Navi ON (cv.Nave = IMO_number)
	WHERE cont = (SELECT max(cont)
					FROM (SELECT Nave, count(*) cont
							FROM Viaggi WHERE Inizio_viaggio >= inizio AND Fine_viaggio <= fine
							GROUP BY Nave) AS cv)
	ORDER BY Data_costruzione
	LIMIT 1;
RETURN nav;
END//

DELIMITER ;

/*DELIMITER //

CREATE PROCEDURE	maxViaggi(inzio DATE, fine DATE)
BEGIN
SELECT Nave INTO nav
	FROM (SELECT Nave, count(*) cont FROM Viaggi WHERE Inizio_viaggio >= inizio AND Fine_viaggio <= fine GROUP BY Nave) AS cv
		JOIN Navi ON (cv.Nave = IMO_number)
	WHERE cont = (SELECT max(cont) FROM cv) AND Data_costruzione = (SELECT min(Data_costruzione) FROM Navi);
END//

DELIMITER ; */

select maxViaggi('2016-02-01','2016-05-01');


/* Funzione che ritorna una stringa "compatibile" o "incompatibile" a seconda se una nave può o meno entrare in un certo porto */

DELIMITER //

CREATE FUNCTION compatibilita(nave CHAR(10),port VARCHAR(50))
RETURNS VARCHAR(13)
BEGIN
DECLARE comp VARCHAR(13);
DECLARE class VARCHAR(50);
DECLARE lvlFaci INT(1);
DECLARE lvlPort INT(1);
SELECT Classe INTO class FROM Navi WHERE IMO_number = nave;
SELECT Livello_facilities INTO lvlFaci FROM Classi WHERE Nome = class;
SELECT Livello_facilities INTO lvlPort FROM Porti WHERE Nome = port;
IF lvlFaci <= lvlPort THEN SET comp = "compatibile";
ELSE SET comp = "incompatibile";
END IF;
RETURN comp;
END//

DELIMITER ;
