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

/* Query per trovare il personale sbarcato in uno scalo x e il personale imbarcato al suo posto */

SELECT K.Nave,K.MatricolaS,K.NomeS,K.CognomeS,K.Qualifica,K.Grado,K.MatricolaI,K.NomeI,K.NomeS,K.CognomeI,ETA,No_Viag,Operazione,Porto FROM(
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
        CAST(Data_partenza AS DATE) AS Data_part FROM Scali) AS S
  WHERE S.Nave = K.Nave
  AND S.Data_arr = "2016-02-22"
;

/* Il Comandante presente a bordo durante l'ultimo scalo con Manutenzione */

SELECT P.Nave,Matricola,Nome,Cognome,Grado,Data_imbarco,Data_sbarco,Viaggio,Data_arrivo,Porto
FROM (SELECT Nave,Matricola,Nome,Cognome,Grado,Data_imbarco,Data_sbarco
        FROM Equipaggio JOIN Personale ON Membro = Matricola) AS P
  JOIN (SELECT Nave,Numero_viaggio AS Viaggio,CAST(Data_arrivo AS DATE)AS Data_arrivo,Porto
        FROM Scali WHERE Operazione LIKE "%Manutenzione%" ORDER BY Data_arrivo DESC LIMIT 1) AS Sc
WHERE P.Nave = Sc.Nave
  AND Data_imbarco < Data_arrivo
  AND Data_sbarco > Data_arrivo
  AND Grado = "Comandante"
  OR P.Nave = Sc.Nave
  AND Data_imbarco < Data_arrivo
  AND Data_sbarco IS NULL
  AND Grado = "Comandante"
;
