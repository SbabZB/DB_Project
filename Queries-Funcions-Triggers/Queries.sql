/* Procedura per trovare tutte le facilities di un determinato porto */

DROP PROCEDURE IF EXISTS livelloFacility;

DELIMITER //

CREATE PROCEDURE livelloFacility(nomeporto VARCHAR(50))
BEGIN
SELECT p.Nome, f.Nome, f.Livello
FROM Porto p, Facility f
WHERE p.Nome = nomeporto AND f.Livello <= p.Livello_facilities
ORDER BY f.Livello;
END//

DELIMITER ;

/* Query per trovare il personale sbarcato in uno scalo x e il personale imbarcato al suo posto */
CREATE OR REPLACE VIEW Sostituzioni AS
SELECT K.Nave,K.MatricolaS,K.NomeS,K.CognomeS,K.Qualifica,K.Grado,K.MatricolaI,K.NomeI,K.CognomeI,ETA,No_Viag,Operazione,Porto FROM(
SELECT P_sbar.Nave as Nave, P_sbar.Matricola as MatricolaS, P_sbar.Nome as NomeS, P_sbar.Cognome as CognomeS,
       P_imb.Matricola AS MatricolaI, P_imb.Nome AS NomeI, P_imb.Cognome AS CognomeI, P_imb.Qualifica, P_imb.Grado
FROM (SELECT *
      FROM Personale JOIN Equipaggio ON Matricola = Membro
      WHERE Data_sbarco = "2016-02-22" AND Nave = "IMO5641147") as P_sbar
JOIN (SELECT *
      FROM Personale JOIN Equipaggio ON Matricola = Membro
      WHERE Data_imbarco = "2016-02-22" AND Nave = "IMO5641147") as P_imb
WHERE P_sbar.Qualifica = P_imb.Qualifica
  AND P_sbar.Grado = P_imb.Grado) AS K
  JOIN (SELECT Nave, CAST(ETA AS DATE) AS ETA, Numero_viaggio AS No_Viag, Operazione, Porto, CAST(Data_arrivo AS DATE) AS Data_arr,
        CAST(Data_partenza AS DATE) AS Data_part FROM Scalo) AS S
  WHERE S.Nave = K.Nave
  AND S.Data_arr = "2016-02-22"
;

/* Il Comandante presente a bordo durante l'ultimo scalo con Manutenzione */

CREATE OR REPLACE VIEW ComUltimaManutenzione AS
SELECT P.Nave,Matricola,Nome,Cognome,Grado,Data_imbarco,Data_sbarco,Viaggio,Data_arrivo,Porto
FROM (SELECT Nave,Matricola,Nome,Cognome,Grado,Data_imbarco,Data_sbarco
        FROM Equipaggio JOIN Personale ON Membro = Matricola) AS P
  JOIN (SELECT Nave,Numero_viaggio AS Viaggio,CAST(Data_arrivo AS DATE)AS Data_arrivo,Porto
        FROM Scalo WHERE Operazione LIKE "%Manutenzione%" ORDER BY Data_arrivo DESC LIMIT 1) AS Sc
WHERE P.Nave = Sc.Nave
  AND Data_imbarco < Data_arrivo
  AND Data_sbarco > Data_arrivo
  AND Grado = "Comandante"
  OR P.Nave = Sc.Nave
  AND Data_imbarco < Data_arrivo
  AND Data_sbarco IS NULL
  AND Grado = "Comandante";

/* Procedura per trovare il membro del personale attualmente imbarcato da più tempo */
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

/* Query che restituisce la nave(IMO_number) il comandante(Matricola, Nome, Cognome),
   il primo ufficiale di copera(Matricola, Nome, Cognome) e il tipo di carico della nave ipiegata in operazioni portuali */

CREATE OR REPLACE VIEW OperazioniPortualiCorrenti AS
SELECT n.IMO_number, n.Nome AS Nome_nave,Numero AS Numero_viaggio, Tipo_carico, Porto_destinazione AS Porto, Matricola_cpt,
       Cognome_cpt, Nome_cpt, Matricola_fmt, Cognome_fmt, Nome_fmt
FROM Nave n,
     (SELECT cpt.Nave, cpt.Matricola AS Matricola_cpt, cpt.Cognome AS Cognome_cpt,
      cpt.Nome AS Nome_cpt, fmt.Matricola AS Matricola_fmt, fmt.Cognome AS Cognome_fmt,
      fmt.Nome AS Nome_fmt
      FROM (SELECT * FROM Equipaggio JOIN Personale ON Membro = Matricola) AS cpt,
           (SELECT * FROM Equipaggio JOIN Personale ON Membro = Matricola) AS fmt
      WHERE cpt.Grado = "Comandante"
	    AND fmt.Grado = "Primo di coperta"
	    AND cpt.Data_sbarco IS NULL
	    AND fmt.Data_sbarco IS NULL
	    AND cpt.Nave = (SELECT IMO_number FROM Nave WHERE Stato_corrente LIKE "%port operations%")
	    AND fmt.Nave = cpt.Nave) AS x,
     Viaggio v
WHERE n.IMO_number = x.Nave
  AND v.Numero = (SELECT Numero
                  FROM Viaggio
                  WHERE Nave = (SELECT IMO_number FROM Nave WHERE Stato_corrente LIKE "%port operations%")
                  ORDER BY Numero DESC LIMIT 1);

/* Procedura per trovare l'equipaggio in una data data di una data nave */

DROP PROCEDURE IF EXISTS trovaEquipaggio;
DELIMITER //
CREATE PROCEDURE trovaEquipaggio(data DATE, nav CHAR(10))
BEGIN
SELECT *
FROM Equipaggio JOIN Personale ON Membro = Matricola
WHERE Nave = nav
  AND Data_imbarco <= data
  AND Data_sbarco >= data
   OR Nave = nav
  AND Data_imbarco <= data
  AND Data_sbarco IS NULL;
END//
DELIMITER ;

/* Query che trova quanta gente si trovava imbarcata su una nave durante un'ispezione portuale in uno scalo
    e quanto personale massimo puo' portare la nave */
DROP PROCEDURE IF EXISTS numeroEquipaggio;
DELIMITER //
CREATE PROCEDURE numeroEquipaggio(data DATE, nav CHAR(10))
BEGIN
SELECT Nave, Numero_viaggio, Operazione, Porto, Data_arrivo AS Data, Numero_imbarcati, Equipaggio_max
FROM (SELECT Equipaggio_max, IMO_number
      FROM Classe JOIN Nave ON Classe.Nome = Nave.Classe) AS eqMax
     JOIN Scalo ON eqMax.IMO_number = Nave
     JOIN (SELECT COUNT(*) AS Numero_imbarcati
           FROM Equipaggio JOIN (SELECT Nave AS NaveS, CAST(Data_arrivo AS DATE) AS Data_arrivo
                                 FROM Scalo
                                 WHERE CAST(Data_arrivo AS DATE) = data AND Nave = nav) AS scl
           WHERE Nave = NaveS
           AND Data_imbarco <= Data_arrivo
           AND Data_sbarco >= Data_arrivo
           OR Nave = NaveS
           AND Data_imbarco <= Data_arrivo
           AND Data_sbarco IS NULL) AS nImb
WHERE CAST(Data_arrivo AS DATE) = data
AND Nave = nav;
END //
DELIMITER ;
