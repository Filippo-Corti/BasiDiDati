CREATE TYPE FasciaUrgenza AS ENUM ('Rosso', 'Giallo', 'Verde');

CREATE TYPE GiornoSettimana AS ENUM 
	(
		'Lunedì',
		'Martedì',
		'Mercoledì',
		'Giovedì',
		'Venerdì',
		'Sabato',
		'Domenica'
	);

CREATE TABLE Paziente (
	CF CHAR(16) PRIMARY KEY,
	NumeroTessera CHAR(20) NOT NULL,
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	DataNascita DATE NOT NULL,
	CAP VARCHAR(5) NOT NULL,
	Via VARCHAR(30) NOT NULL,
	nCiv DECIMAL(3, 0) NOT NULL,
	UNIQUE (NumeroTessera),
	CHECK (nCiv > 0)
);

CREATE TABLE Ospedale (
	Codice CHAR(5) PRIMARY KEY,
	Nome VARCHAR(30) NOT NULL,
	CAP VARCHAR(5) NOT NULL,
	Via VARCHAR(30) NOT NULL,
	nCiv DECIMAL(3, 0) NOT NULL,
	CHECK (nCiv > 0)
);

CREATE TABLE Reparto (
	Codice CHAR(5) PRIMARY KEY,
	Ospedale CHAR(5) NOT NULL REFERENCES Ospedale(Codice) ON UPDATE CASCADE,
	Nome VARCHAR(30) NOT NULL,
	Piano DECIMAL(2, 0) NOT NULL,
	Telefono VARCHAR(10) NOT NULL,
	UNIQUE (Ospedale, Nome)
);

CREATE TABLE Personale (
	CF CHAR(16) PRIMARY KEY,
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	DataNascita DATE NOT NULL,
	CAP VARCHAR(5) NOT NULL,
	Via VARCHAR(30) NOT NULL,
	nCiv DECIMAL(3, 0) NOT NULL,
	Reparto CHAR(5) REFERENCES Reparto(Codice) ON UPDATE CASCADE,
	CHECK (nCiv > 0)
);

CREATE TABLE PersonaleAmministrativo (
	CF CHAR(16) PRIMARY KEY,
	FOREIGN KEY(CF) REFERENCES Personale(CF) ON UPDATE CASCADE
);

CREATE TABLE PersonaleSanitario (
	CF CHAR(16) PRIMARY KEY,
	FOREIGN KEY(CF) REFERENCES Personale(CF) ON UPDATE CASCADE
);

CREATE TABLE Infermiere (
	CF CHAR(16) PRIMARY KEY,
	FOREIGN KEY(CF) REFERENCES PersonaleSanitario(CF) ON UPDATE CASCADE
);

CREATE TABLE PersonaleMedico (
	CF CHAR(16) PRIMARY KEY,
	DataInizioServizio DATE NOT NULL,
	FOREIGN KEY(CF) REFERENCES PersonaleSanitario(CF) ON UPDATE CASCADE
);

CREATE TABLE Primario (
	CF CHAR(16) PRIMARY KEY,
	Reparto CHAR(5) NOT NULL REFERENCES Reparto(Codice) ON UPDATE CASCADE,
	FOREIGN KEY(CF) REFERENCES PersonaleMedico(CF) ON UPDATE CASCADE,
	UNIQUE (Reparto)
);

CREATE TABLE VicePrimario (
	CF CHAR(16) PRIMARY KEY,
	DataAssunzioneRuolo DATE NOT NULL,
	Reparto CHAR(5) NOT NULL REFERENCES Reparto(Codice) ON UPDATE CASCADE,
	FOREIGN KEY(CF) REFERENCES PersonaleMedico(CF) ON UPDATE CASCADE
);

CREATE TABLE Specializzazione (Specializzazione VARCHAR(30) PRIMARY KEY);

CREATE TABLE SpecializzazionePrimario (
	Primario CHAR(16) REFERENCES Primario(CF) ON UPDATE CASCADE,
	Specializzazione VARCHAR(30) REFERENCES Specializzazione(Specializzazione) ON UPDATE CASCADE,
	PRIMARY KEY (Primario, Specializzazione)
);

CREATE TABLE Sostituzione (
	Primario CHAR(16) REFERENCES Primario(CF) ON UPDATE CASCADE,
	VicePrimario CHAR(16) REFERENCES VicePrimario(CF) ON UPDATE CASCADE,
	DataInizio DATE,
	DataFine DATE,
	PRIMARY KEY(Primario, VicePrimario, DataInizio),
	CHECK(
		DataFine IS NULL
		OR DataFine > DataInizio
	)
);

CREATE TABLE SalaOperatoria (
	Reparto CHAR(5) PRIMARY KEY,
	FOREIGN KEY (Reparto) REFERENCES Reparto(Codice) ON UPDATE CASCADE
);

CREATE TABLE Stanza (
	Reparto CHAR(5) REFERENCES Reparto(Codice) ON UPDATE CASCADE,
	Numero DECIMAL(3, 0),
	NumeroLetti DECIMAL(2, 0),
	PRIMARY KEY(Reparto, Numero)
);

CREATE TABLE ProntoSoccorso (
	Ospedale CHAR(5) PRIMARY KEY,
	FOREIGN KEY (Ospedale) REFERENCES Ospedale(Codice) ON UPDATE CASCADE
);

CREATE TABLE TurnoPS (
	ProntoSoccorso CHAR(5) REFERENCES ProntoSoccorso(Ospedale) ON UPDATE CASCADE,
	Personale CHAR(16) REFERENCES PersonaleSanitario(CF) ON UPDATE CASCADE,
	DataOraInizio TIMESTAMP,
	DataOraFine TIMESTAMP,
	PRIMARY KEY(ProntoSoccorso, Personale, DataOraInizio),
	CHECK(
		DataOraFine IS NULL
		OR DataOraFine > DataOraInizio
	)
);

CREATE TABLE Laboratorio (Codice CHAR(5) PRIMARY KEY);

CREATE TABLE LaboratorioInterno (
	Codice CHAR(5) PRIMARY KEY,
	Reparto CHAR(5) NOT NULL,
	Stanza DECIMAL(3, 0) NOT NULL,
	FOREIGN KEY (Codice) REFERENCES Laboratorio(Codice) ON UPDATE CASCADE,
	FOREIGN KEY (Reparto, Stanza) REFERENCES Stanza(Reparto, Numero) ON UPDATE CASCADE,
	UNIQUE (Reparto, Stanza)
);

CREATE TABLE LaboratorioEsterno (
	Codice CHAR(5) PRIMARY KEY,
	Telefono VARCHAR(10) NOT NULL,
	CAP VARCHAR(5) NOT NULL,
	Via VARCHAR(30) NOT NULL,
	nCiv DECIMAL(3, 0) NOT NULL,
	FOREIGN KEY (Codice) REFERENCES Laboratorio(Codice) ON UPDATE CASCADE,
	CHECK (nCiv > 0)
);

CREATE TABLE CollaborazioneOspedaleLaboratorio (
	Ospedale CHAR(5) REFERENCES Ospedale(Codice) ON UPDATE CASCADE,
	Laboratorio CHAR(5) REFERENCES LaboratorioEsterno(Codice) ON UPDATE CASCADE,
	PRIMARY KEY (Ospedale, Laboratorio)
);

CREATE TABLE Ricovero (
	Codice CHAR(5) PRIMARY KEY,
	Paziente CHAR(16) NOT NULL REFERENCES Paziente(CF) ON UPDATE CASCADE,
	Reparto CHAR(5) NOT NULL,
	Stanza DECIMAL(3, 0) NOT NULL,
	DataInizio DATE NOT NULL,
	DataFine DATE,
	FOREIGN KEY (Reparto, Stanza) REFERENCES Stanza(Reparto, Numero) ON UPDATE CASCADE,
	UNIQUE (Paziente, Reparto, Stanza, DataInizio),
	CHECK (
		DataFine IS NULL
		OR DataFine >= DataInizio
	)
);

CREATE TABLE Patologia (Patologia VARCHAR(50) PRIMARY KEY);

CREATE TABLE RicoveroPatologia (
	Ricovero CHAR(5) REFERENCES Ricovero(Codice) ON UPDATE CASCADE,
	Patologia VARCHAR(50) REFERENCES Patologia(Patologia) ON UPDATE CASCADE,
	PRIMARY KEY(Ricovero, Patologia)
);

CREATE TABLE Esame (
	Codice CHAR(5) PRIMARY KEY,
	Descrizione VARCHAR(50) NOT NULL,
	CostoAssistenza DECIMAL(6, 2) NOT NULL,
	CostoPrivato DECIMAL (6, 2) NOT NULL
);

CREATE TABLE EsameSpecialistico (
	Codice CHAR(5) PRIMARY KEY,
	Avvertenze VARCHAR(200),
	FOREIGN KEY (Codice) REFERENCES Esame(Codice) ON UPDATE CASCADE
);

CREATE TABLE Prenotazione (
	Paziente CHAR(16) REFERENCES Paziente(CF) ON UPDATE CASCADE,
	Esame CHAR(5) REFERENCES Esame(Codice) ON UPDATE CASCADE,
	DataEsame DATE NOT NULL,
	OraEsame TIME NOT NULL,
	Laboratorio CHAR(5) NOT NULL REFERENCES Laboratorio(Codice) ON UPDATE CASCADE,
	DataPrenotazione DATE NOT NULL,
	Urgenza FasciaUrgenza NOT NULL,
	RegimePrivato BOOLEAN NOT NULL,
	-- True = Regime Privato, False = Regime Assistenza
	Prescrittore CHAR(16) REFERENCES PersonaleMedico(CF) ON UPDATE CASCADE,
	PRIMARY KEY (Paziente, Esame, DataEsame),
	UNIQUE(Paziente, DataEsame, OraEsame),
	CHECK (DataEsame >= DataPrenotazione)
);

CREATE TABLE OrarioAperturaLaboratorio (
	Laboratorio CHAR(5) REFERENCES LaboratorioEsterno(Codice) ON UPDATE CASCADE,
	GiornoSettimana GiornoSettimana NOT NULL,
	OraApertura TIME NOT NULL,
	OraChiusura TIME NOT NULL,
	PRIMARY KEY(Laboratorio, GiornoSettimana),
	CHECK (OraChiusura > OraApertura)
);

CREATE TABLE OrarioVisiteReparto (
	Reparto CHAR(5) REFERENCES Reparto(Codice) ON UPDATE CASCADE,
	GiornoSettimana GiornoSettimana NOT NULL,
	OraApertura TIME NOT NULL,
	OraChiusura TIME NOT NULL,
	PRIMARY KEY(Reparto, GiornoSettimana),
	CHECK (OraChiusura > OraApertura)
);