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