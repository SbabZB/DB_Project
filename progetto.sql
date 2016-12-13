CREATE TABLE Personale
(
 Matricola CHAR(7),
 Nome VARCHAR(30),
 Cognome VARCHAR(30),
 Data_nascita DATE,
 Cittadinanza VARCHAR(20),
 Qualifica VARCHAR(20),
 Grado VARCHAR(30),
  PRIMARY KEY (Matricola)
);

CREATE TABLE Facilities(
  Nome varchar(50),
  Livello int(1),
  PRIMARY KEY (Nome)
);

CREATE TABLE Classi(
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

CREATE TABLE Navi
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
  FOREIGN KEY (Classe) REFERENCES Classi(Nome)
);

CREATE TABLE Porti(
  Nome varchar(50),
  Livello_facilities int(1),
  Nazione varchar(30),
  PRIMARY KEY (Nome)
);

CREATE TABLE Viaggi
(
 Numero INT(10),
 Nave CHAR(10),
 Tipo_carico VARCHAR(20) DEFAULT NULL,
 Inizio_viaggio DATE,
 Fine_viaggio DATE,
 Porto_partenza VARCHAR(30) REFERENCES Porti(Nome),
 Porto_destinazione VARCHAR(30) REFERENCES Porti(Nome),
 PRIMARY KEY (Numero,Nave),
FOREIGN KEY (Nave) REFERENCES Navi(IMO_number)
);

CREATE TABLE Equipaggio
(
 Nave CHAR(10),
 Membro CHAR(7) REFERENCES Personale(Matricola),
 Data_imbarco DATE,
 Data_sbarco DATE,
 PRIMARY KEY (Membro, Data_imbarco),
 FOREIGN KEY (Nave) REFERENCES Navi(IMO_number)
);

CREATE TABLE Scali(
  ETA DATETIME,
  Nave char(10),
  Numero_viaggio int(10),
  Operazione varchar(50),
  Porto varchar(50),
  Data_arrivo DATETIME,
  Data_partenza DATETIME,
  PRIMARY KEY (Nave,Numero_viaggio,ETA),
  FOREIGN KEY (Numero_viaggio,Nave) REFERENCES Viaggi(Numero,Nave),
  FOREIGN KEY (Porto) REFERENCES Porti(Nome)
);

LOAD DATA LOCAL INFILE './Txt/personale.txt' INTO TABLE  Personale;
LOAD DATA LOCAL INFILE './Txt/facilities.txt' INTO TABLE  Facilities;
LOAD DATA LOCAL INFILE './Txt/classi.txt' INTO TABLE  Classi;
LOAD DATA LOCAL INFILE './Txt/navi.txt' INTO TABLE  Navi;
LOAD DATA LOCAL INFILE './Txt/porti.txt' INTO TABLE  Porti;
LOAD DATA LOCAL INFILE './Txt/viaggi.txt' INTO TABLE  Viaggi;
LOAD DATA LOCAL INFILE './Txt/equipaggio.txt' INTO TABLE  Equipaggio;
LOAD DATA LOCAL INFILE './Txt/scali.txt' INTO TABLE  Scali;
