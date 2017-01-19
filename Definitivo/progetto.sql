SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS Personale;
CREATE TABLE Personale
(
 Matricola CHAR(7),
 Nome VARCHAR(30),
 Cognome VARCHAR(30),
 Data_nascita DATE,
 Cittadinanza VARCHAR(20),
 Qualifica ENUM('Cuoco','Marinaio','Tecnico','Ufficiale'),
 Grado VARCHAR(30),
 PRIMARY KEY (Matricola)
);

DROP TABLE IF EXISTS Facility;
CREATE TABLE Facility(
  Nome varchar(50),
  Livello int(1),
  PRIMARY KEY (Nome)
);

DROP TABLE IF EXISTS Classe;
CREATE TABLE Classe(
  Nome varchar(50),
  Tipo varchar(20),
  Cantiere_costruzione varchar(50),
  Lunghezza numeric(4,1),
  Larghezza numeric(3,1),
  Altezza numeric(3,1),
  Livello_facilities int(1),
  Velocita_crociera numeric(3,1),
  Velocita_max numeric (3,1),
  Equipaggio_max INT(2),
  PRIMARY KEY (Nome,Tipo,Cantiere_costruzione)
);

DROP TABLE IF EXISTS Nave;
CREATE TABLE Nave
(
  IMO_number char(10),
  Nome varchar(20),
  Classe varchar(50),
  Stato_di_bandiera varchar(20),
  Data_costruzione date,
  Data_ultima_posizione DATETIME,
  Latitudine_ultima_posizione numeric(8,6),
  Longitudine_ultima_posizione numeric (9,6),
  Stato_corrente varchar(40),
  Velocita_attuale numeric(3,1) DEFAULT 0,
  PRIMARY KEY (IMO_number),
  FOREIGN KEY (Classe) REFERENCES Classe(Nome) ON DELETE SET NULL
);

DROP TABLE IF EXISTS Porto;
CREATE TABLE Porto(
  Nome varchar(50),
  Livello_facilities int(1),
  Nazione varchar(30),
  PRIMARY KEY (Nome)
);

DROP TABLE IF EXISTS Viaggio;
CREATE TABLE Viaggio
(
 Numero INT(10),
 Nave CHAR(10),
 Tipo_carico VARCHAR(20) DEFAULT NULL,
 Inizio_viaggio DATE,
 Fine_viaggio DATE,
 Porto_partenza VARCHAR(30),
 Porto_destinazione VARCHAR(30),
 PRIMARY KEY (Numero,Nave),
 FOREIGN KEY (Nave) REFERENCES Nave(IMO_number) ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (Porto_partenza) REFERENCES Porto(Nome) ON DELETE RESTRICT,
 FOREIGN KEY (Porto_destinazione) REFERENCES Porto(Nome) ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Equipaggio;
CREATE TABLE Equipaggio
(
 Nave CHAR(10),
 Membro CHAR(7),
 Data_imbarco DATE,
 Data_sbarco DATE,
 PRIMARY KEY (Membro, Data_imbarco),
 FOREIGN KEY (Nave) REFERENCES Nave(IMO_number) ON DELETE CASCADE,
 FOREIGN KEY (Membro) REFERENCES Personale(Matricola) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Scalo;
CREATE TABLE Scalo(
  ETA DATETIME,
  Nave char(10),
  Numero_viaggio int(10),
  Operazione varchar(50),
  Porto varchar(50),
  Data_arrivo DATETIME,
  Data_partenza DATETIME,
  PRIMARY KEY (Nave,Numero_viaggio,ETA),
  FOREIGN KEY (Numero_viaggio,Nave) REFERENCES Viaggio(Numero,Nave) ON DELETE CASCADE,
  FOREIGN KEY (Porto) REFERENCES Porto(Nome) ON DELETE RESTRICT
);

INSERT INTO Classe (Nome,Tipo,Cantiere_costruzione,Lunghezza,Larghezza,Altezza,Livello_facilities,Velocita_crociera,Velocita_max,Equipaggio_max) VALUES
('Medusa','Oil/Chemical Tanker','STX Shipbuilding Co. Ltd., Pusan, Korea','215.2','35.8','52.8','4','11.0','17.8','35'),
('Venere','Ore carrier','Oshima Shipbuilding Co., Ltd. Japan','182.0','33.5','44.7','3','10.5','13.2','28');

INSERT INTO Nave (IMO_number,Nome,Classe,Stato_di_bandiera,Data_costruzione,Data_ultima_posizione,Latitudine_ultima_posizione,Longitudine_ultima_posizione,Stato_corrente,Velocita_attuale) VALUES
('IMO4438756','Medusa','Medusa','Italy','2007-10-23','2016-06-20 09:30:11','35.151364','-67.051525','under way/using engine','11.8'),
('IMO4439254','Calypso','Medusa','Italy','2008-03-01','2016-06-20 10:05:16','34.855917','139.725495','adrift/waiting for pilot','0.6'),
('IMO5641147','Venere','Venere','Italy','2014-01-30','2016-05-10 00:01:41','38.138786','13.370468','dry dock/maintenance','0.0'),
('IMO5641234','Giunone','Venere','Italy','2014-06-17','2016-06-20 10:15:15','-37.823759','144.901729','port operations','0.0');

INSERT INTO Personale (Matricola,Nome,Cognome,Data_nascita,Cittadinanza,Qualifica,Grado) VALUES
('VE21745','Gianluca','Zanella','1974-5-24','Italiana','Marinaio','Mozzo'),
('AN54214','Roberto','Rossi','1962-12-1','Italiana','Marinaio','Mozzo'),
('PA58954','Rosario','DeDomenico','1955-8-5','Italiana','Marinaio','Mozzo'),
('PA75461','Salvatore','Savio','1982-5-11','Italiana','Marinaio','Mozzo'),
('CTT3242','Grigore','Gheorgescu','1976-10-9','Rumena','Marinaio','Mozzo'),
('NA75413','Lucio','Livio','1967-6-6','Italiana','Marinaio','Mozzo'),
('LT42001','Fabrizio','Pisani','1962-8-10','Italiana','Marinaio','Mozzo'),
('SR41597','Giulio','Mattei','1978-3-22','Italiana','Marinaio','Mozzo'),
('CTT3751','Dumitru','Ionesco','1984-6-11','Rumena','Marinaio','Marinaio Scelto'),
('CT84200','Raffaele','Coco','1983-12-23','Italiana','Marinaio','Marinaio Scelto'),
('VE14783','Roberto','Furlan','1964-04-12','Italiana','Marinaio','Marinaio Scelto'),
('GE45671','Nicola','Ceppi','1987-2-16','Italiana','Marinaio','Marinaio Scelto'),
('TA86039','Salvatore','Solitro','1977-6-29','Italiana','Marinaio','Marinaio Scelto'),
('CA53610','Giovanni','Pusceddu','1972-12-4','Italiana','Marinaio','Marinaio Scelto'),
('VE21084','Luca','Scarpa','1969-11-2','Italiana','Marinaio','Marinaio Scelto'),
('AN59708','Filippo','Guglielmi','1985-1-13','Italiana','Marinaio','Marinaio Scelto'),
('PA71054','Gabriele','Solitro','1970-4-1','Italiana','Marinaio','Marinaio Scelto'),
('VE22411','Giacomo','Lattanzio','1978-3-16','Italiana','Marinaio','Marinaio Scelto'),
('NA84111','Fulvio','Giacomelli','1971-8-4','Italiana','Marinaio','Marinaio Scelto'),
('PA65917','Ignazio','Petra','1968-11-16','Italiana','Marinaio','Marinaio Scelto'),
('VE20477','Lorenzo','Sacca','1967-01-14','Italiana','Marinaio','Marinaio Scelto'),
('GE40993','Massimo','Nove','1980-10-01','Italiana','Marinaio','Marinaio Scelto'),
('CTT3413','Gustav','Valenti','1970-4-8','Rumena','Marinaio','Marinaio Scelto'),
('PA74810','Cosimo','Rizzo','1970-9-12','Italiana','Marinaio','Marinaio Scelto'),
('PA67802','Paolo','Costa','1966-9-6','Italiana','Tecnico','Operaio'),
('VE25436','Giorgio','Bianchi','1978-7-3','Italiana','Tecnico','Operaio'),
('CTT3587','Damian','Vasile','1972-10-16','Rumena','Tecnico','Operaio'),
('NA94531','Fabrizio','Libera','1991-4-22','Italiana','Tecnico','Operaio'),
('GE40437','Giuliano','Rosi','1968-2-8','Italiana','Tecnico','Operaio'),
('AN59877','Marino','Casa','1989-3-5','Italiana','Tecnico','Operaio'),
('CTT3970','Aurel','Dragan','1990-5-19','Rumena','Tecnico','Operaio'),
('CTT3994','Mugur','Horia','1989-10-30','Rumena','Tecnico','Operaio'),
('PA72541','Matteo','Costa','1980-1-15','Italiana','Tecnico','Operaio'),
('CA57834','Raffaele','Piras','1985-1-9','Italiana','Tecnico','Elettricista'),
('SR31240','Fabio','Privitera','1961-3-7','Italiana','Tecnico','Elettricista'),
('CZ74046','Martino','Pietra','1989-7-4','Italiana','Tecnico','Elettricista'),
('TA78549','Enrico','Fava','1967-5-25','Italiana','Tecnico','Elettricista'),
('VE21840','Matteo','Visentin','1973-4-8','Italiana','Tecnico','Elettricista'),
('AN57778','Corrado','Baldo','1974-3-14','Italiana','Tecnico','Elettricista'),
('CTT3678','Boris','Ureche','1976-12-24','Rumena','Tecnico','Elettricista'),
('GE46832','Luca','Massi','1989-6-7','Italiana','Tecnico','Elettricista'),
('PA79541','Libero','Mazzanti','1984-8-25','Italiana','Cuoco','Cuoco'),
('NA87949','Giordano','De Luca','1977-6-17','Italiana','Cuoco','Cuoco'),
('CZ70103','Marcello','Dellucci','1974-3-8','Italiana','Cuoco','Cuoco'),
('VE19447','Giorgio','Manna','1968-11-2','Italiana','Cuoco','Cuoco'),
('PA70546','Alvise','Esposito','1976-4-30','Italiana','Cuoco','Cuoco'),
('TA78945','Leonardo','Li Fonti','1970-1-31','Italiana','Cuoco','Cuoco'),
('AN50014','Giacomo','Fiorentino','1971-7-22','Italiana','Cuoco','Cuoco'),
('CA54612','Gianni','Spano','1975-4-1','Italiana','Cuoco','Cuoco'),
('GE40870','Angelo','Calabresi','1967-3-16','Italiana','Cuoco','Cuoco'),
('PA79117','Gian Nicola','Colombo','1988-11-11','Italiana','Cuoco','Aiuto Cuoco'),
('VE34681','Davide','Angelo','1996-7-24','Italiana','Ufficiale','Allievo di Coperta'),
('PA89401','Massimiliano','Dellucci','1992-4-9','Italiana','Ufficiale','Allievo di Coperta'),
('GE52109','Jacopo','Rossi','1995-5-21','Italiana','Ufficiale','Allievo di Coperta'),
('NA89849','Andrea','Lucchese','1995-2-18','Italiana','Ufficiale','Allievo di Macchina'),
('TA85401','Diego','Boni','1994-6-8','Italiana','Ufficiale','Allievo di Macchina'),
('VE34574','Giovanni','Schiavon','1996-7-3','Italiana','Ufficiale','Allievo di Macchina'),
('SR38941','Stefano','Palerma','1984-6-3','Italiana','Ufficiale','Secondo di Coperta'),
('VE32157','Valerio','Miola','1987-4-29','Italiana','Ufficiale','Secondo di Coperta'),
('VE32147','Michele','Masiero','1987-11-23','Italiana','Ufficiale','Secondo di Coperta'),
('CA57192','Nicola','Floris','1986-4-17','Italiana','Ufficiale','Secondo di Coperta'),
('PA77460','Renzo','Costa','1987-10-4','Italiana','Ufficiale','Secondo di Coperta'),
('PA77412','Sergio','Barese','1987-1-20','Italiana','Ufficiale','Secondo di Coperta'),
('TA82106','Edoardo','Moretti','1982-8-19','Italiana','Ufficiale','Secondo di Coperta'),
('AN52940','Federico','Romani','1984-10-10','Italiana','Ufficiale','Secondo di Coperta'),
('VE31481','Damiano','Trevisan','1987-3-9','Italiana','Ufficiale','Secondo di Macchina'),
('PA76143','Salvatore','Ferri','1988-2-24','Italiana','Ufficiale','Secondo di Macchina'),
('GE50187','Alberto','Greco','1984-6-5','Italiana','Ufficiale','Secondo di Macchina'),
('VE30481','Umberto','Russo','1979-7-5','Italiana','Ufficiale','Secondo di Macchina'),
('PA76824','Carlo','Milano','1975-3-27','Italiana','Ufficiale','Secondo di Macchina'),
('AN50884','Fabrizio','Piani','1972-4-7','Italiana','Ufficiale','Secondo di Macchina'),
('SR38977','Mario','Castiglione','1980-6-3','Italiana','Ufficiale','Secondo di Macchina'),
('VE31240','Gianni','Vianello','1984-8-25','Italiana','Ufficiale','Secondo di Macchina'),
('PA70015','Mauro','Carta','1962-4-14','Italiana','Ufficiale','Primo di Coperta'),
('NA84809','Luca','Sasso','1976-3-6','Italiana','Ufficiale','Primo di Coperta'),
('VE29802','Marco','Ballarin','1972-9-29','Italiana','Ufficiale','Primo di Coperta'),
('PA72508','Dario','Messina','1974-3-2','Italiana','Ufficiale','Primo di Coperta'),
('CTT3612','Stan','Longu','1972-5-7','Rumena','Ufficiale','Primo di Coperta'),
('VE30192','Daniele','Vianello','1973-9-12','Italiana','Ufficiale','Primo di Coperta'),
('GE49860','Stefano','Cozzani','1977-6-26','Italiana','Ufficiale','Primo di Coperta'),
('SR35417','Giovanni','Vella','1974-7-8','Italiana','Ufficiale','Primo di Coperta'),
('NA84454','Guido','Desiderio','1970-3-18','Italiana','Ufficiale','Primo di Macchina'),
('ME64190','Fulvio','Guarracino','1973-7-6','Italiana','Ufficiale','Primo di Macchina'),
('VE29470','Paolo','Lombardo','1972-1-29','Italiana','Ufficiale','Primo di Macchina'),
('PA71541','Romeo','Giacalone','1970-6-3','Italiana','Ufficiale','Primo di Macchina'),
('PA72800','Donato','Occhipinti','1976-4-14','Italiana','Ufficiale','Primo di Macchina'),
('VE29113','Gianmarco','Rampazzo','1975-9-23','Italiana','Ufficiale','Primo di Macchina'),
('GE48371','Roberto','Traverso','1976-2-17','Italiana','Ufficiale','Primo di Macchina'),
('TA76282','Ciro','Greco','1978-8-24','Italiana','Ufficiale','Primo di Macchina'),
('PA70659','Francesco','Illano','1960-8-11','Italiana','Ufficiale','Capo Macchinista'),
('PA64089','Giuliano','Serafino','1955-7-16','Italiana','Ufficiale','Capo Macchinista'),
('TA55921','Silvano','Pagano','1959-4-13','Italiana','Ufficiale','Capo Macchinista'),
('VE24859','Sandro','Zanatta','1957-7-27','Italiana','Ufficiale','Capo Macchinista'),
('VE25403','Enrico','Scarparo','1959-11-4','Italiana','Ufficiale','Capo Macchinista'),
('CTT3047','Valentin','Blaga','1968-8-31','Italiana','Ufficiale','Capo Macchinista'),
('CTT3154','Iohan','Grigore','1971-6-12','Italiana','Ufficiale','Capo Macchinista'),
('NA84010','Giovanni','Salvatore','1970-1-4','Italiana','Ufficiale','Capo Macchinista'),
('VE27487','Marcello','Schiavone','1972-9-23','Italiana','Ufficiale','Comandante'),
('PA69771','Valentino','Lombardo','1968-3-4','Italiana','Ufficiale','Comandante'),
('PA68107','Silvio','Rizzo','1963-7-19','Italiana','Ufficiale','Comandante'),
('CTT2944','Stere','Lovinescu','1964-7-3','Italiana','Ufficiale','Comandante'),
('VE27844','Laura','Bedin','1973-6-30','Italiana','Ufficiale','Comandante'),
('VE26410','Marino','Ballarini','1970-2-22','Italiana','Ufficiale','Comandante'),
('TA59777','Luigi','Manfrini','1969-9-12','Italiana','Ufficiale','Comandante'),
('VE27249','Simone','Rizzato','1973-12-30','Italiana','Ufficiale','Comandante');

INSERT INTO Equipaggio (Nave,Membro,Data_imbarco,Data_sbarco) VALUES
('IMO4438756','VE21745','2015-11-22','2016-03-28'),
('IMO4438756','CT84200','2015-11-22','2016-03-15'),
('IMO4438756','CTT3751','2015-12-16','2016-03-28'),
('IMO4438756','PA67802','2015-11-22','2016-03-28'),
('IMO4438756','CA57834','2016-01-23','2016-02-20'),
('IMO4438756','PA79541','2015-11-22','2016-02-20'),
('IMO4438756','PA79117','2015-11-22','2016-02-15'),
('IMO4438756','VE34681','2015-12-16','2016-03-28'),
('IMO4438756','NA89849','2015-11-22','2016-03-28'),
('IMO4438756','SR38941','2015-11-22','2016-03-15'),
('IMO4438756','VE31481','2015-11-22','2016-03-15'),
('IMO4438756','PA70015','2015-11-22','2016-04-04'),
('IMO4438756','NA84454','2015-11-22','2016-03-28'),
('IMO4438756','PA70659','2015-11-22','2016-03-15'),
('IMO4438756','VE27487','2015-11-22','2016-03-15'),
('IMO4439254','AN54214','2015-12-10','2016-03-03'),
('IMO4439254','VE14783','2015-12-10','2016-03-03'),
('IMO4439254','GE45671','2015-12-10','2016-02-18'),
('IMO4439254','VE25436','2015-12-10','2016-03-10'),
('IMO4439254','SR31240','2015-12-10','2016-02-18'),
('IMO4439254','NA87949','2015-12-10','2016-03-03'),
('IMO4439254','PA89401','2015-12-10','2016-03-10'),
('IMO4439254','TA85401','2015-12-10','2016-03-14'),
('IMO4439254','VE32157','2015-12-10','2016-03-03'),
('IMO4439254','PA76143','2015-12-10','2016-03-10'),
('IMO4439254','NA84809','2015-12-10','2016-03-10'),
('IMO4439254','ME64190','2015-12-10','2016-03-03'),
('IMO4439254','PA64089','2015-12-10','2016-02-18'),
('IMO4439254','PA69771','2015-12-10','2016-03-10'),
('IMO5641147','PA58954','2015-11-29','2016-02-22'),
('IMO5641147','TA86039','2015-11-29','2016-03-14'),
('IMO5641147','CA53610','2015-11-29','2016-03-14'),
('IMO5641147','CTT3587','2015-11-29','2016-02-22'),
('IMO5641147','CZ74046','2015-11-29','2016-03-04'),
('IMO5641147','CZ70103','2015-11-29','2016-03-04'),
('IMO5641147','GE52109','2015-11-29','2016-02-22'),
('IMO5641147','VE34574','2015-11-29','2016-02-22'),
('IMO5641147','VE32147','2015-11-29','2016-03-04'),
('IMO5641147','GE50187','2015-11-29','2016-03-14'),
('IMO5641147','VE29802','2015-11-29','2016-03-04'),
('IMO5641147','VE29470','2015-11-29','2016-02-23'),
('IMO5641147','TA55921','2015-11-29','2016-03-04'),
('IMO5641147','PA68107','2015-11-29','2016-03-14'),
('IMO5641234','PA75461','2015-12-02','2016-03-07'),
('IMO5641234','VE21084','2015-12-02','2016-03-07'),
('IMO5641234','AN59708','2015-12-02','2016-03-07'),
('IMO5641234','NA94531','2015-12-02','2016-03-17'),
('IMO5641234','TA78549','2015-12-02','2016-03-07'),
('IMO5641234','VE19447','2015-12-02','2016-03-07'),
('IMO5641234','CA57192','2015-12-02','2016-03-17'),
('IMO5641234','VE30481','2015-12-02','2016-03-17'),
('IMO5641234','PA72508','2015-12-02','2016-03-17'),
('IMO5641234','PA71541','2015-12-02','2016-02-11'),
('IMO5641234','VE24859','2015-12-02','2016-03-07'),
('IMO5641234','CTT2944','2015-12-02','2016-03-17'),
('IMO4438756','CTT3242','2016-03-28',NULL),
('IMO4438756','GE45671','2016-03-28',NULL),
('IMO4438756','VE22411','2016-03-15','2016-05-17'),
('IMO4438756','GE40437','2016-02-20','2016-05-10'),
('IMO4438756','VE21840','2016-02-20',NULL),
('IMO4438756','PA70546','2016-02-15','2016-05-06'),
('IMO4438756','GE52109','2016-04-11',NULL),
('IMO4438756','VE34574','2016-05-06',NULL),
('IMO4438756','PA77460','2016-03-15',NULL),
('IMO4438756','PA76824','2016-03-15','2016-05-17'),
('IMO4438756','CTT3612','2016-03-28',NULL),
('IMO4438756','PA72800','2016-03-15',NULL),
('IMO4438756','VE25403','2016-03-15','2016-05-10'),
('IMO4438756','VE27844','2016-02-20',NULL),
('IMO4439254','NA75413','2016-03-03',NULL),
('IMO4439254','NA84111','2016-02-18','2016-05-31'),
('IMO4439254','PA65917','2016-03-03',NULL),
('IMO4439254','AN59877','2016-03-10',NULL),
('IMO4439254','AN57778','2016-02-18',NULL),
('IMO4439254','TA78945','2016-03-03',NULL),
('IMO4439254','PA79117','2016-03-14',NULL),
('IMO4439254','VE34681','2016-05-15',NULL),
('IMO4439254','TA85401','2016-04-18',NULL),
('IMO4439254','PA77412','2016-02-22','2016-05-31'),
('IMO4439254','AN50884','2016-03-03',NULL),
('IMO4439254','VE30192','2016-02-18',NULL),
('IMO4439254','VE29113','2016-02-18','2016-05-15'),
('IMO4439254','CTT3047','2016-02-02','2016-05-15'),
('IMO4439254','VE26410','2016-03-03',NULL),
('IMO5641147','LT42001','2016-02-22','2016-05-09'),
('IMO5641147','VE20477','2016-03-14','2016-05-10'),
('IMO5641147','GE40993','2016-03-14','2016-05-10'),
('IMO5641147','PA72541','2016-02-22','2016-05-10'),
('IMO5641147','CTT3678','2016-03-04','2016-05-10'),
('IMO5641147','AN50014','2016-03-04',NULL),
('IMO5641147','TA82106','2016-02-22',NULL),
('IMO5641147','SR38977','2016-03-04',NULL),
('IMO5641147','GE49860','2016-02-22',NULL),
('IMO5641147','CTT3154','2016-03-04',NULL),
('IMO5641147','TA59777','2016-03-04',NULL),
('IMO5641234','SR41597','2016-03-07','2016-05-10'),
('IMO5641234','CTT3413','2016-03-07',NULL),
('IMO5641234','PA74810','2016-03-07',NULL),
('IMO5641234','CTT3994','2016-03-17',NULL),
('IMO5641234','GE46832','2016-03-07',NULL),
('IMO5641234','GE40870','2016-03-07',NULL),
('IMO5641234','PA89401','2016-05-10',NULL),
('IMO5641234','NA89849','2016-05-10',NULL),
('IMO5641234','AN52940','2016-03-07',NULL),
('IMO5641234','VE31240','2016-03-07',NULL),
('IMO5641234','SR35417','2016-03-07',NULL),
('IMO5641234','TA76282','2016-01-23',NULL),
('IMO5641234','NA84010','2016-03-07',NULL),
('IMO5641234','VE27249','2016-03-07','2016-05-10'),
('IMO4438756','CT84200','2016-05-17',NULL),
('IMO4438756','PA67802','2016-05-10',NULL),
('IMO4438756','CA54612','2016-05-06',NULL),
('IMO4438756','PA76143','2016-05-17',NULL),
('IMO4438756','TA55921','2016-05-10',NULL),
('IMO4439254','TA86039','2016-05-31',NULL),
('IMO4439254','CA57192','2016-05-15',NULL),
('IMO4439254','NA84454','2016-04-29',NULL),
('IMO4439254','PA70659','2016-04-29',NULL),
('IMO5641234','PA58954','2016-05-10',NULL),
('IMO5641234','PA68107','2016-05-10',NULL);

INSERT INTO Porto (Nome,Livello_facilities,Nazione) VALUES
('Port of Rotterdam','4','Netherlands'),
('Port of Antwerp','3','Belgium'),
('Port of Immingham','4','United Kingdom'),
('Port of Melbourne','4','Australia'),
('Port of New York & New Jersey','3','USA'),
('Port of Genoa','4','Italy'),
('Port of Venice','4','Italy'),
('Port of Palermo','4','Italy'),
('Port of Naples','4','Italy'),
('Port of Taranto','4','Italy'),
('Port of Trieste','4','Italy'),
('Port of Tobruk','4','Libya'),
('Port of Alexandria','4','Egypt'),
('Port of Ashdod','4','Israel'),
('Port of Istanbul','4','Turkey'),
('Port of Tuapse','4','Russia'),
('Sevastopol Marine Trade Port','3','Russia/Ukraine'),
('Port of Costanta','4','Romania'),
('Port of Hamburg','3','Germany'),
('Murmansk Commercial Seaport','4','Russia'),
('Port of Osaka','4','Japan'),
('Port of Tokio','4','Japan'),
('Port of San Francisco','4','USA'),
('Port of Barcelona','4','Spain'),
('Port of Los Angeles','4','USA'),
('Port of Kobe','3','Japan'),
('Port of Hong Kong','4','PRC'),
('Port of Shangai','4','PRC'),
('Port of Taichung','4','Taiwan'),
('Port of Bari','4','Italy'),
('Port of Ancona','3','Italy'),
('Port of Thessaloniki','4','Greece'),
('Odessa Marine Trade Port','4','Ukraine'),
('Port of Donges','4','France'),
('Port of Marseille','3','France'),
('Port of Valencia','4','Spain'),
('Port of Cagliari','4','Italy'),
('Port of Milazzo','4','Italy'),
('Port of Augusta','4','Italy'),
('Port of Izmit','4','Turkey'),
('Port of Fukuyama','4','Japan'),
('Port of Busan','4','South Korea'),
('Port of Port Said','2','Egypt'),
('Port of Siracusa','4','Italy');

INSERT INTO Facility (Nome,Livello) VALUES
('Police portuale','0'),
('Fire Department','0'),
('Capitaneria di porto','0'),
('Tug service','0'),
('Pilots','0'),
('Dry dock','1'),
('Bulk terminal','1'),
('Container terminal','2'),
('Passenger terminal','2'),
('Ore terminal','3'),
('Oil terminal','4'),
('Chemical terminal','4'),
('LPG terminal','4'),
('LNG terminal','4'),
('Fire Department CDS','4');

INSERT INTO Viaggio (Numero,Nave,Tipo_carico,Inizio_viaggio,Fine_viaggio,Porto_partenza,Porto_destinazione) VALUES
('96','IMO4438756','Gasoline','2015-11-22','2016-12-16','Port of Rotterdam','Port of Genoa'),
('97','IMO4438756','Gasoline','2016-1-23','2016-02-08','Port of Barcelona','Port of Augusta'),
('98','IMO4438756','Jet fuel','2016-2-10','2016-02-20','Port of Augusta','Port of Ashdod'),
('99','IMO4438756','Gasoil','2016-3-15','2016-4-4','Port of Taranto','Port of Tuapse'),
('100','IMO4438756','Gasoline','2016-4-11','2016-5-6','Port of Izmit','Port of Rotterdam'),
('101','IMO4438756','Jet fuel','2016-5-10','2016-5-17','Port of Rotterdam','Port of Immingham'),
('81','IMO4439254','Gasoline','2015-12-10','2016-01-11','Port of Shanghai','Port of Melbourne'),
('82','IMO4439254','MTBE','2016-02-02','2016-02-22','Port of Taichung','Port of Kobe'),
('83','IMO4439254','Jet fuel','2016-02-22','2016-03-3','Port of Kobe','Port of Tokyo'),
('84','IMO4439254','Jet fuel','2016-03-10','2016-03-14','Port of Osaka','Port of Fukuyama'),
('85','IMO4439254','MTBE','2016-04-2','2016-04-18','Port of Taichung','Port of Busan'),
('86','IMO4439254','Gasoline','2016-04-29','2016-05-15','Port of Busan','Port of Tokyo'),
('87','IMO4439254','MTBE','2016-05-31',NULL,'Port of Shanghai','Port of Tokyo'),
('38','IMO5641147','Phosphate','2015-11-29','2015-12-30','Port of Taranto','Port of Melbourne'),
('39','IMO5641147','Bauxite','2016-01-28','2016-3-04','Port of Melbourne','Port of Taranto'),
('40','IMO5641147','Phosphate','2016-03-14','2016-04-3','Port of Taranto','Port of Odessa'),
('41','IMO5641147','Coal','2016-04-19','2016-05-9','Port of Odessa','Port of Taranto'),
('32','IMO5641234','Bauxite','2015-12-02','2015-12-29','Port of Melbourne','Port of Hong Kong'),
('33','IMO5641234','Coal','2016-01-08','2016-01-23','Port of Hong Kong','Port of Shanghai'),
('34','IMO5641234','Coal','2016-02-11','2016-03-7','Port of Hong Kong','Port of Melbourne'),
('35','IMO5641234','Bauxite','2016-03-17','2016-04-16','Port of Melbourne','Port of Osaka'),
('36','IMO5641234','Grain','2016-05-10','2016-06-17','Port of Shanghai','Port of Melbourne');

INSERT INTO Scalo (ETA,Nave,Numero_viaggio,Operazione,Porto,Data_arrivo,Data_partenza) VALUES
('2016-03-28 01:00','IMO4438756','99','Personale/Provviste','Port of Istanbul','2016-03-28 00:20','2016-03-28 08:32'),
('2016-04-23 16:00','IMO4438756','100','Rifornimento','Port of Palermo','2016-4-23 16:21','2016-04-24 05:50'),
('2016-02-18 05:30','IMO4439254','82','Personale/Rifornimento','Port of Fukuyama','2016-02-18 05:26','2016-02-18 15:11'),
('2016-02-12 20:00','IMO5641147','39','Rifornimento/Provviste','Port of Port Said','2016-02-13 12:52','2016-02-13 23:05'),
('2016-02-22 10:00','IMO5641147','39','Ispezione/Personale','Port of Siracusa','2016-02-22 11:10','2016-02-23 00:15'),
('2016-02-24 22:00','IMO5641147','39','Manutenzione','Port of Palermo','2016-02-24 20:18','2016-03-01 11:20'),
('2016-04-24 03:00','IMO5641147','41','Personale/Provviste','Port of Istanbul','2016-04-24 03:01','2016-04-24 06:15');

SET FOREIGN_KEY_CHECKS=1;



DROP TRIGGER IF EXISTS comp_viaggi;
DELIMITER //
CREATE TRIGGER comp_viaggi AFTER INSERT ON Viaggio
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
CREATE TRIGGER num_viaggio BEFORE INSERT ON Viaggio
FOR EACH ROW
BEGIN
DECLARE num INT(10);
SELECT MAX(Numero) INTO num FROM Viaggio WHERE Nave = NEW.Nave AND Numero != NEW.Numero;
IF NEW.Numero > num+1 THEN
    SET NEW.Numero = num+1;
    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = "ATTENZIONE: Numero viaggio e' stato coretto", MYSQL_ERRNO = '1000';
END IF;
END//
DELIMITER ;

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



DROP FUNCTION IF EXISTS maxViaggi;
DELIMITER //
CREATE FUNCTION	maxViaggi(inizio DATE, fine DATE)
RETURNS CHAR(10)
BEGIN
DECLARE num INT;
DECLARE nav CHAR(10);
SELECT Nave INTO nav
FROM (SELECT Nave, count(*) cont FROM Viaggio WHERE Inizio_viaggio >= inizio AND Fine_viaggio <= fine GROUP BY Nave) AS cv
JOIN Nave ON (cv.Nave = IMO_number)
WHERE cont = (SELECT max(cont)
FROM (SELECT Nave, count(*) cont
      FROM Viaggio WHERE Inizio_viaggio >= inizio AND Fine_viaggio <= fine
      GROUP BY Nave) AS cv)
ORDER BY Data_costruzione
LIMIT 1;
RETURN nav;
END//
DELIMITER ;



DELIMITER //
CREATE FUNCTION compatibilita(nave CHAR(10),port VARCHAR(50))
RETURNS VARCHAR(13)
BEGIN
DECLARE comp VARCHAR(13);
DECLARE class VARCHAR(50);
DECLARE lvlFaci INT(1);
DECLARE lvlPort INT(1);
SELECT Classe INTO class FROM Nave WHERE IMO_number = nave;
SELECT Livello_facilities INTO lvlFaci FROM Classe WHERE Nome = class;
SELECT Livello_facilities INTO lvlPort FROM Porto WHERE Nome = port;
IF lvlFaci <= lvlPort THEN SET comp = "compatibile";
ELSE SET comp = "incompatibile";
END IF;
RETURN comp;
END//
DELIMITER ;



DROP FUNCTION IF EXISTS anzianitaMembro;
DELIMITER //
CREATE FUNCTION anzianitaMembro(matricola CHAR(7))
RETURNS INT

BEGIN
DECLARE sommaDate INT;
DECLARE differenzaDate INT;
SET differenzaDate = 0;

  SELECT SUM(DATEDIFF(Data_sbarco,Data_imbarco)) INTO sommaDate
  FROM Equipaggio
  WHERE Membro = matricola
    AND Data_sbarco IS NOT NULL;

  SELECT DATEDIFF(CURDATE(),Data_imbarco) INTO differenzaDate FROM Equipaggio WHERE Membro = matricola AND Data_sbarco IS NULL;
  SET sommaDate = sommaDate + differenzaDate;


RETURN sommaDate;
END//
DELIMITER ;



DROP PROCEDURE IF EXISTS livelloFacility;

DELIMITER //

CREATE PROCEDURE facilitiesPresenti(nomeporto VARCHAR(50))
BEGIN
SELECT p.Nome, f.Nome, f.Livello
FROM Porto p, Facility f
WHERE p.Nome = nomeporto AND f.Livello <= p.Livello_facilities
ORDER BY f.Livello;
END//

DELIMITER ;

CREATE OR REPLACE VIEW Sostituzioni AS
SELECT K.Nave,K.MatricolaS,K.CognomeS,K.Qualifica,K.Grado,K.MatricolaI,K.CognomeI,ETA,No_Viag,Operazione,Porto FROM(
SELECT P_sbar.Nave as Nave, P_sbar.Matricola as MatricolaS, P_sbar.Cognome as CognomeS,
       P_imb.Matricola AS MatricolaI, P_imb.Cognome AS CognomeI, P_imb.Qualifica, P_imb.Grado
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
  AND S.Data_arr = "2016-02-22";



CREATE OR REPLACE VIEW ComUltimaManutenzione AS
SELECT P.Nave,Matricola,Nome,Cognome,Data_imbarco,Data_sbarco,Viaggio,Data_arrivo,Porto
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



CREATE OR REPLACE VIEW OperazioniPortualiCorrenti AS
SELECT n.IMO_number, Tipo_carico, Porto_destinazione AS Porto, Matricola_cpt,
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



DROP PROCEDURE IF EXISTS numeroEquipaggio;
DELIMITER //
CREATE PROCEDURE numeroEquipaggio(data DATE, nav CHAR(10))
BEGIN
SELECT Nave, Numero_viaggio, Operazione, Porto, Numero_imbarcati, Equipaggio_max
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

