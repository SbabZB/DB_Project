select E.*
from
	(select Membro, max(Data_sbarco) as Data_sbarco, Nome, Cognome
	from Equipaggio join Personale on Membro = Matricola
	where Qualifica = 'Marinaio' and Grado = 'Mozzo'
	group by Membro) as E
	where E.Data_sbarco = (select min(E1.Data_sbarco) from (select Membro, max(Data_sbarco) as Data_sbarco, Nome, Cognome
	from Equipaggio join Personale on Membro = Matricola
	where Qualifica = 'Marinaio' and Grado = 'Mozzo'
	group by Membro) as E1);

select Membro, max(Data_sbarco) as Data_sbarco, Nome, Cognome
from Equipaggio join Personale on Membro = Matricola
where Qualifica = 'Marinaio' and Grado = 'Mozzo'
group by Membro
where Data_sbarco = (select min(E1.Data_sbarco) from (select Membro, max(Data_sbarco) as Data_sbarco, Nome, Cognome
	from Equipaggio join Personale on Membro = Matricola
	where Qualifica = 'Marinaio' and Grado = 'Mozzo'
	group by Membro) as E1)

DROP PROCEDURE IF EXISTS membroDaSbarcare;
DELIMITER //
CREATE PROCEDURE membroDaSbarcare(qual VARCHAR(20), gr VARCHAR(30))
BEGIN
	SELECT Matricola, Nome, Cognome
	FROM (SELECT * FROM Personale JOIN Equipaggio ON Matricola = Membro) AS x
	WHERE x.Matricola NOT IN (SELECT Membro FROM Equipaggio WHERE Data_sbarco IS NULL)
	AND Qualifica = qual
	AND Grado = gr
	AND Data_sbarco = (SELECT MIN(Data_sbarco)
	FROM (SELECT * FROM Personale JOIN Equipaggio ON Matricola = Membro) AS x
	WHERE x.Matricola NOT IN (SELECT Membro FROM Equipaggio WHERE Data_sbarco IS NULL)
	AND Qualifica = qual
	AND Grado = gr);
END//
DELIMITER ;

/**procedura per tirare fuori com e primo da un viaggio ancora in corso*/
SELECT cpt.Nave, cpt.Matricola AS Matricola_cpt, cpt.Cognome AS Cognome_cpt,
       cpt.Nome AS Nome_cpt, fmt.Matricola AS Matricola_fmt, fmt.Cognome AS Cognome_fmt,
       fmt.Nome AS Nome_fmt
FROM (SELECT * FROM Equipaggio JOIN Personale ON Membro = Matricola) AS cpt,
     (SELECT * FROM Equipaggio JOIN Personale ON Membro = Matricola) AS fmt
WHERE cpt.Grado = "Comandante"
	AND fmt.Grado = "Primo di coperta"
	AND cpt.Data_sbarco IS NULL
	AND fmt.Data_sbarco IS NULL
	AND cpt.Nave = (SELECT IMO_number FROM Navi WHERE Stato_corrente LIKE "%port operations%")
	AND fmt.Nave = cpt.Nave
