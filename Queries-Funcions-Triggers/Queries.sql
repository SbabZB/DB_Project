/* Procedura per trovare tutte le facilities di un determinato porto */

DROP PROCEDURE IF EXIST 'portfacilities';

DELIMITER //

CREATE PROCEDURE portfacilities (nomeporto VARCHAR(50))
BEGIN
SELECT p.Nome, f.Nome, f.Livello
FROM Porti p, Facilities f
WHERE p.Nome = nomeporto AND f.Livello <= p.Livello_facilities
ORDER BY f.Livello;
END//

DELIMITER ;

