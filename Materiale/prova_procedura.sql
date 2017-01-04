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


	SELECT Matricola, Nome, Cognome
	FROM (SELECT * FROM Personale JOIN Equipaggio ON Matricola = Membro) AS x
	WHERE x.Matricola NOT IN (SELECT Membro FROM Equipaggio WHERE Data_sbarco IS NULL)
	AND Qualifica = "Marinaio"
	AND Grado = "Mozzo"
	AND Data_sbarco = (SELECT MIN(Data_sbarco)
	FROM (SELECT * FROM Personale JOIN Equipaggio ON Matricola = Membro) AS x
	WHERE x.Matricola NOT IN (SELECT Membro FROM Equipaggio WHERE Data_sbarco IS NULL)
	AND Qualifica = "Marinaio"
	AND Grado = "Mozzo");
