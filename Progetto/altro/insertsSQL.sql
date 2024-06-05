INSERT INTO Paziente (CF, NumeroTessera, Nome, Cognome, dataNascita, CAP, Via, nCiv) VALUES
('RSSMRA85M01H501Z', '12345678901234567890', 'Mario', 'Rossi', '1985-01-01', '00184', 'Via del Corso', 1),
('VRDLGI92F02L219V', '22345678901234567890', 'Luigi', 'Verdi', '1992-06-15', '20121', 'Via Montenapoleone', 15),
('BNCLRA70A01F205Z', '32345678901234567890', 'Laura', 'Bianchi', '1970-04-20', '80121', 'Via Partenope', 45),
('FRNCRL88C01H501B', '42345678901234567890', 'Carlo', 'Ferrari', '1988-03-10', '10121', 'Via Roma', 22),
('SNTGPP95D12M208V', '52345678901234567890', 'Giuseppe', 'Santi', '1995-07-12', '50122', 'Via dei Tornabuoni', 30),
('MNDFRN78B01H501C', '62345678901234567890', 'Francesca', 'Mondi', '1978-02-18', '30121', 'Riva degli Schiavoni', 7),
('RBCSRA85A01L839M', '72345678901234567890', 'Sara', 'Rubini', '1985-11-01', '16121', 'Via Garibaldi', 55),
('LSDFNC90H01H501P', '82345678901234567890', 'Franco', 'Lisi', '1990-08-23', '90133', 'Via Vittorio Emanuele', 12),
('CNTGNN72C01G273N', '92345678901234567890', 'Gennaro', 'Conti', '1972-12-30', '70121', 'Corso Vittorio Emanuele', 20),
('MRTLUI83F01H501A', '10234567890123456789', 'Luisa', 'Martini', '1983-05-05', '10121', 'Via Po', 18),
('BNCLUI90L01H501Y', '11234567890123456789', 'Luigi', 'Bianchi', '1990-12-01', '37121', 'Corso Porta Nuova', 25),
('GRMLRA75H01H501Z', '21234567890123456789', 'Lara', 'Germani', '1975-08-01', '73100', 'Via XXV Luglio', 33),
('PNCMRA68A01F205L', '31234567890123456789', 'Marco', 'Panico', '1968-01-01', '85100', 'Corso XVIII Agosto', 14),
('VRDGNN85C01H501P', '41234567890123456789', 'Gianni', 'Verdi', '1985-03-01', '70121', 'Via Sparano', 28),
('FNTGLL90L01H501B', '51234567890123456789', 'Giulia', 'Fontana', '1990-12-01', '06121', 'Corso Vannucci', 40),
('BLCSRA83M01H501C', '61234567890123456789', 'Sara', 'Bellucci', '1983-01-01', '09124', 'Via Roma', 19),
('RSTPPL92H01H501T', '71234567890123456789', 'Paolo', 'Rossi', '1992-08-01', '91100', 'Via Fardella', 21),
('LNSFNC74L01H501D', '81234567890123456789', 'Franco', 'Lanza', '1974-12-01', '98121', 'Viale San Martino', 17),
('FRNCLL80B01F205N', '91234567890123456789', 'Luca', 'Franchi', '1980-02-01', '42121', 'Corso Garibaldi', 13),
('NVRLUI85L01H501M', '10123456789012345678', 'Luigi', 'Neri', '1985-12-01', '57123', 'Via Grande', 23);


INSERT INTO Ospedale (Codice, Nome, CAP, Via, nCiv) VALUES 
('OS001', 'Ospedale Maggiore', '20100', 'Via Emilia', 15),
('OS002', 'Ospedale Niguarda', '20162', 'Piazza Ospedale Maggiore', 3),
('OS003', 'Ospedale San Raffaele', '20132', 'Via Olgettina', 60),
('OS004', 'Ospedale Bambin Gesù', '00165', 'Piazza Maggiore', 4);


INSERT INTO Reparto (Codice, Ospedale, Nome, Piano, Telefono) VALUES 
('RP001', 'OS001', 'Cardiologia', 2, '0212345678'),
('RP002', 'OS001', 'Oncologia', 1, '0223456789'),
('RP003', 'OS003', 'Ginecologia', 2, '0312345678'),
('RP004', 'OS003', 'Pediatria', 4, '0323456789'),
('RP005', 'OS003', 'Fisioterapia', 2, '0334567890'),
('RP006', 'OS003', 'Cardiologia', 3, '0345678901');


INSERT INTO Personale (CF, Nome, Cognome, dataNascita, CAP, Via, nCiv, Reparto) VALUES
('RSSMRA75A15H501Z', 'Mario', 'Rossi', '1975-01-15', '00184', 'Via del Corso', 10, 'RP001'), 
('VRDLGU80B20H501Y', 'Luigi', 'Verdi', '1980-02-20', '20121', 'Via Montenapoleone', 20, 'RP005'),
('BNCLNN85C25H501X', 'Anna', 'Bianchi', '1985-03-25', '80121', 'Via Partenope', 30, 'RP006'), 
('NRIMRA90D30H501A', 'Maria', 'Neri', '1990-04-30', '10121', 'Via Po', 40, 'RP003'),
('RSSCRL82E10H501B', 'Carlo', 'Russo', '1982-05-10', '50122', 'Via dei Tornabuoni', 50, 'RP005'), 
('SPSLRA78H15H501C', 'Laura', 'Esposito', '1978-06-15', '30121', 'Riva degli Schiavoni', 60, 'RP005'),
('FRRPLO83L20H501D', 'Paolo', 'Ferrari', '1983-07-20', '16121', 'Via Garibaldi', 70, 'RP001'),
('RCCGLI87M25H501E', 'Giulia', 'Ricci', '1987-08-25', '90133', 'Via Vittorio Emanuele', 80, 'RP001'),
('MRNFNC76P30H501F', 'Francesco', 'Marini', '1976-09-30', '70121', 'Corso Vittorio Emanuele', 90, 'RP002'), 
('CSTSRN92R05H501G', 'Sara', 'Costa', '1992-10-05', '10121', 'Via Roma', 100, 'RP006'),
('CSTMRM80A01H501H', 'Mario', 'Costani', '1980-01-01', '40100', 'Via Emilia', 15, 'RP004'),
('VRDLPL75C15H501I', 'Paolo', 'Verdi', '1975-03-15', '40126', 'Via Massarenti', 9, 'RP003'),
('BNCLRA85D07H501J', 'Laura', 'Bianchi', '1985-04-07', '20162', 'Piazza Ospedale Maggiore', 3, 'RP003'),
('CNTFNC78L14H501K', 'Francesca', 'Conti', '1978-07-14', '20122', 'Via Francesco Sforza', 35, 'RP004'), 
('MRNGGI82E18H501L', 'Giorgio', 'Marin', '1982-05-18', '00165', 'Via Celoria', 4, 'RP006'),
('BGNLUC76T22H501M', 'Luca', 'Bagnoli', '1976-12-22', '50100', 'Via della Libertà', 22, 'RP001'),
('RSSFNC81M07H501N', 'Franco', 'Rossi', '1981-11-07', '70123', 'Via del Mare', 45, 'RP001'),
('MRRCLD83R14H501O', 'Claudia', 'Marrone', '1983-10-14', '80100', 'Via Roma', 10, 'RP003'),
('BLRTNG84A12H501P', 'Tania', 'Baldi', '1984-08-12', '90100', 'Via Milano', 28, 'RP002'),
('CNTLCR80S20H501Q', 'Lucia', 'Contini', '1980-09-20', '10121', 'Corso Torino', 12, 'RP001'), 
('TSTMRN70A01H501R', 'Marina', 'Testa', '1970-01-01', '10001', 'Via delle Rose', 5, 'RP003'),
('CLMNDR75B12H501S', 'Andrea', 'Colombo', '1975-02-12', '20002', 'Via Garibaldi', 12, 'RP001'),
('FRNLCN80C23H501T', 'Lorenzo', 'Ferrari', '1980-03-23', '30003', 'Viale della Repubblica', 8, 'RP005'),
('BRGLGN85D04H501D', 'Gianni', 'Brugnone', '1985-04-04', '40004', 'Piazza Libertà', 16, 'RP001'),
('VRNMRC90E15H501E', 'Marco', 'Verona', '1990-05-15', '50005', 'Via Dante', 22, 'RP004'),
('SMNTLL95F26H501F', 'Tullio', 'Simonetti', '1995-06-26', '60006', 'Via Pascoli', 30, 'RP006'),
('RZZMRZ65G07H501G', 'Marzio', 'Rizzi', '1965-07-07', '70007', 'Via Foscolo', 45, 'RP006'),
('BRNLSR70H18H501H', 'Sara', 'Bernini', '1970-08-18', '80008', 'Via Petrarca', 50, 'RP005'),
('CRSLGI75I29H501I', 'Giovanni', 'Corsini', '1975-09-29', '90009', 'Via Ariosto', 60, 'RP003'),
('DLPFNC80L01H501J', 'Fiona', 'Dallaporta', '1980-10-01', '10010', 'Via Boccaccio', 35, 'RP001'),
('PLNTLR72M11H501K', 'Lorenzo', 'Pallante', '1972-11-11', '11011', 'Via Garibaldi', 7, NULL), 
('VRDGLA78C15H501L', 'Giulia', 'Verdi', '1978-03-15', '21021', 'Via Manzoni', 23, NULL),
('MLTLUC81B17H501M', 'Lucia', 'Maltoni', '1981-02-17', '31031', 'Via Carducci', 11, NULL),
('FRNMRZ88D09H501N', 'Marzia', 'Ferrara', '1988-04-09', '41041', 'Via Tasso', 18, NULL),
('BGNLRN70A22H501O', 'Renato', 'Bagnoli', '1970-01-22', '51051', 'Via Leopardi', 24, NULL),
('SMTMLS90E12H501P', 'Michele', 'Simonti', '1990-05-12', '61061', 'Via Montale', 9, NULL),
('FRGLFR95F25H501Q', 'Franco', 'Frugoli', '1995-06-25', '71071', 'Via Ungaretti', 13, NULL),
('MRRCSL85H14H501R', 'Silvia', 'Marroni', '1985-08-14', '81081', 'Via Pascoli', 17, NULL),
('TNDMRZ83I10H501S', 'Maurizio', 'Tandelli', '1983-09-10', '91091', 'Via Monti', 21, NULL),
('VRNZLS88L03H501T', 'Lisa', 'Vernizzi', '1988-12-03', '10101', 'Via Ghiberti', 5, NULL);


INSERT INTO PersonaleAmministrativo (CF) VALUES
('RSSMRA75A15H501Z'), 
('BNCLNN85C25H501X'), 
('RSSCRL82E10H501B'), 
('MRNFNC76P30H501F'),
('CNTLCR80S20H501Q');


INSERT INTO PersonaleSanitario (CF) VALUES
('VRDLGU80B20H501Y'), 
('NRIMRA90D30H501A'), 
('SPSLRA78H15H501C'), 
('FRRPLO83L20H501D'), 
('RCCGLI87M25H501E'), 
('CSTSRN92R05H501G'),
('CSTMRM80A01H501H'),
('VRDLPL75C15H501I'),
('BNCLRA85D07H501J'),
('CNTFNC78L14H501K'),
('MRNGGI82E18H501L'),
('BGNLUC76T22H501M'),
('RSSFNC81M07H501N'),
('MRRCLD83R14H501O'),
('BLRTNG84A12H501P'),
('TSTMRN70A01H501R'),
('CLMNDR75B12H501S'),
('FRNLCN80C23H501T'),
('BRGLGN85D04H501D'),
('VRNMRC90E15H501E'),
('SMNTLL95F26H501F'),
('RZZMRZ65G07H501G'),
('BRNLSR70H18H501H'),
('CRSLGI75I29H501I'),
('DLPFNC80L01H501J'),
('PLNTLR72M11H501K'),
('VRDGLA78C15H501L'), 
('MLTLUC81B17H501M'),
('FRNMRZ88D09H501N'), 
('BGNLRN70A22H501O'),
('SMTMLS90E12H501P'),
('FRGLFR95F25H501Q'),
('MRRCSL85H14H501R'),
('TNDMRZ83I10H501S'),
('VRNZLS88L03H501T');


INSERT INTO Infermiere (CF) VALUES
('VRDLGU80B20H501Y'), 
('NRIMRA90D30H501A'), 
('SPSLRA78H15H501C'),
('FRRPLO83L20H501D'), 
('RCCGLI87M25H501E'), 
('CSTSRN92R05H501G');


INSERT INTO PersonaleMedico (CF, DataInizioServizio) VALUES
('CSTMRM80A01H501H', '2010-09-01'), 
('VRDLPL75C15H501I', '2011-10-15'), 
('BNCLRA85D07H501J', '2012-11-20'),
('CNTFNC78L14H501K', '2010-06-12'),
('MRNGGI82E18H501L', '2015-02-13'),
('BGNLUC76T22H501M', '2010-02-12'),
('RSSFNC81M07H501N', '2006-12-02'),
('MRRCLD83R14H501O', '2010-02-12'),
('BLRTNG84A12H501P', '2000-01-20'),
('TSTMRN70A01H501R', '2010-02-04'),
('CLMNDR75B12H501S', '2013-09-12'),
('FRNLCN80C23H501T', '2016-02-01'),
('BRGLGN85D04H501D', '2010-04-12'),
('VRNMRC90E15H501E', '2009-11-12'),
('SMNTLL95F26H501F', '2018-09-15'),
('RZZMRZ65G07H501G', '2020-05-22'),
('BRNLSR70H18H501H', '2003-07-08'),
('CRSLGI75I29H501I', '2012-12-12'),
('DLPFNC80L01H501J', '2017-10-25'),
('PLNTLR72M11H501K', '1999-11-02'),
('VRDGLA78C15H501L', '2000-01-05'),
('MLTLUC81B17H501M', '2005-04-10'),
('FRNMRZ88D09H501N', '2010-12-19'),
('BGNLRN70A22H501O', '2001-04-12'),
('SMTMLS90E12H501P', '2015-10-02'),
('FRGLFR95F25H501Q', '2021-02-05'),
('MRRCSL85H14H501R', '2000-03-16'),
('TNDMRZ83I10H501S', '2003-12-01'),
('VRNZLS88L03H501T', '2009-07-13');


INSERT INTO Primario (CF, Reparto) VALUES
('VRDLPL75C15H501I', 'RP001'),
('BGNLUC76T22H501M', 'RP002'),
('RSSFNC81M07H501N', 'RP003'),
('MRRCLD83R14H501O', 'RP004'),
('FRNLCN80C23H501T', 'RP005'),
('BRNLSR70H18H501H', 'RP006');


INSERT INTO VicePrimario (CF, DataAssunzioneRuolo, Reparto) VALUES
('CSTMRM80A01H501H', '2015-11-01', 'RP001'), 
('BNCLRA85D07H501J', '2014-04-02', 'RP002'),
('MRNGGI82E18H501L', '2019-06-10', 'RP003'),
('TSTMRN70A01H501R', '2018-08-11', 'RP003'),
('VRNMRC90E15H501E', '2019-09-03', 'RP004'),
('SMNTLL95F26H501F', '2020-11-13', 'RP005'),
('CRSLGI75I29H501I', '2015-10-06', 'RP005'),
('CNTFNC78L14H501K', '2018-03-18', 'RP005'),
('DLPFNC80L01H501J', '2020-12-19', 'RP006');


INSERT INTO Specializzazione (Specializzazione) VALUES
('Cardiologia'),
('Dermatologia'),
('Ginecologia'),
('Neurologia'),
('Pediatria'),
('Psichiatria'),
('Ortopedia'),
('Oftalmologia'),
('Oncologia'),
('Urologia'),
('Endocrinologia'),
('Gastroenterologia'),
('Reumatologia'),
('Chirurgia Generale'),
('Otorinolaringoiatria'),
('Medicina Interna'),
('Nefrologia'),
('Ematologia'),
('Allergologia'),
('Medicina dello Sport'),
('Chirurgia Plastica'),
('Chirurgia Vascolare'),
('Medicina di Urgenza'),
('Malattie Infettive'),
('Radiologia');


INSERT INTO SpecializzazionePrimario (Primario, Specializzazione) VALUES
('VRDLPL75C15H501I', 'Cardiologia'),
('VRDLPL75C15H501I', 'Medicina Interna'),
('VRDLPL75C15H501I', 'Radiologia'),
('BGNLUC76T22H501M', 'Dermatologia'),
('BGNLUC76T22H501M', 'Chirurgia Plastica'),
('RSSFNC81M07H501N', 'Ginecologia'),
('MRRCLD83R14H501O', 'Neurologia'),
('MRRCLD83R14H501O', 'Chirurgia Vascolare'),
('FRNLCN80C23H501T', 'Pediatria'),
('BRNLSR70H18H501H', 'Psichiatria'),
('BRNLSR70H18H501H', 'Ortopedia'),
('BRNLSR70H18H501H', 'Oftalmologia'),
('BRNLSR70H18H501H', 'Oncologia'),
('FRNLCN80C23H501T', 'Urologia'),
('FRNLCN80C23H501T', 'Endocrinologia'),
('BGNLUC76T22H501M', 'Gastroenterologia'),
('MRRCLD83R14H501O', 'Chirurgia Generale'),
('RSSFNC81M07H501N', 'Medicina Interna'),
('RSSFNC81M07H501N', 'Medicina dello Sport'),
('BGNLUC76T22H501M', 'Malattie Infettive');


INSERT INTO Sostituzione (Primario, VicePrimario, DataInizio, DataFine) VALUES
('RSSFNC81M07H501N', 'TSTMRN70A01H501R', '2020-03-10', '2020-10-10'),
('RSSFNC81M07H501N', 'MRNGGI82E18H501L', '2021-06-02', '2021-12-13'),
('FRNLCN80C23H501T', 'CRSLGI75I29H501I', '2017-09-03', '2018-07-08'),
('BRNLSR70H18H501H', 'DLPFNC80L01H501J', '2021-06-01', '2021-12-28'),
('BRNLSR70H18H501H', 'DLPFNC80L01H501J', '2022-02-08', '2022-04-22'),
('FRNLCN80C23H501T', 'CRSLGI75I29H501I', '2024-05-03', NULL);

INSERT INTO SalaOperatoria (Reparto) VALUES 
('RP001'), 
('RP005'), 
('RP006');


INSERT INTO Stanza (Reparto, Numero, NumeroLetti) VALUES 
('RP001', 201, 2),   
('RP001', 301, NULL), 
('RP003', 301, NULL), 
('RP005', 501, 3), 
('RP006', 601, 2), 
('RP002', 701, 4), 
('RP005', 901, 3), 
('RP001', 101, NULL), 
('RP001', 203, NULL), 
('RP002', 702, NULL), 
('RP002', 703, 4), 
('RP003', 801, 2), 
('RP003', 901, 3), 
('RP003', 902, 3), 
('RP004', 601, NULL), 
('RP004', 107, 1), 
('RP004', 701, NULL), 
('RP005', 801, NULL);


INSERT INTO ProntoSoccorso (Ospedale) VALUES 
('OS004'),
('OS001');


INSERT INTO TurnoPS (ProntoSoccorso, Personale, DataOraInizio, DataOraFine) VALUES
('OS001', 'PLNTLR72M11H501K', '2024-05-20 08:00:00', '2024-05-20 16:00:00'),
('OS001', 'PLNTLR72M11H501K', '2024-05-22 08:00:00', '2024-05-22 19:00:00'),
('OS001', 'PLNTLR72M11H501K', '2024-05-25 16:00:00', '2024-05-26 01:00:00'),
('OS001', 'FRNMRZ88D09H501N', '2024-05-20 08:00:00', '2024-05-20 16:00:00'),
('OS001', 'FRNMRZ88D09H501N', '2024-05-21 08:00:00', '2024-05-22 19:00:00'),
('OS001', 'FRNMRZ88D09H501N', '2024-05-25 15:00:00', '2024-05-26 01:00:00'),
('OS001', 'MRRCSL85H14H501R', '2024-05-25 15:00:00', '2024-05-26 01:00:00'),
('OS001', 'MRRCSL85H14H501R', '2024-05-25 16:00:00', '2024-05-26 01:00:00'),
('OS001', 'CLMNDR75B12H501S', '2024-05-25 16:00:00', NULL);


INSERT INTO Laboratorio (Codice) VALUES
('LAB01'),
('LAB02'),
('LAB03'),
('LAB04'),
('LAB05'),
('LAB06'),
('LAB07'),
('LAB08'),
('LAB09'),
('LAB10'),
('LAB11'),
('LAB12');


INSERT INTO LaboratorioInterno (Codice, Reparto, Stanza) VALUES
('LAB01', 'RP001', 101),
('LAB02', 'RP001', 301),
('LAB03', 'RP003', 301),
('LAB04', 'RP004', 601),
('LAB05', 'RP004', 701),
('LAB06', 'RP005', 801),
('LAB07', 'RP001', 203),
('LAB08', 'RP002', 702);


INSERT INTO LaboratorioEsterno (Codice, Telefono, CAP, Via, nCiv) VALUES
('LAB09', '1234567890', '00100', 'Via Roma', 10),
('LAB10', '2345678901', '00200', 'Via Milano', 20),
('LAB11', '3456789012', '00300', 'Via Napoli', 30),
('LAB12', '4567890123', '00400', 'Via Torino', 40);


INSERT INTO CollaborazioneOspedaleLaboratorio (Ospedale, Laboratorio) VALUES
('OS001', 'LAB11'),
('OS002', 'LAB09'),
('OS003', 'LAB10'),
('OS003', 'LAB12');

INSERT INTO Patologia (Patologia) VALUES
('Diabete tipo 1'),
('Ipertensione arteriosa'),
('Asma bronchiale'),
('Artrite reumatoide'),
('Cancro al seno'),
('Depressione maggiore'),
('Malattia di Alzheimer'),
('HIV/AIDS'),
('Parkinson'),
('Malattia di Crohn'),
('Fibrosi polmonare idiopatica'),
('Sclerosi multipla'),
('Lupus eritematoso sistemico'),
('Epilessia'),
('Osteoporosi'),
('Anoressia nervosa'),
('Bipolarismo'),
('Fibromialgia'),
('Sindrome di Down'),
('Diabete tipo 2'),
('Malattia di Parkinson'),
('Sindrome di Tourette'),
('Sclerosi laterale amiotrofica'),
('Anemia falciforme');

INSERT INTO Ricovero (Codice, Paziente, Reparto, Stanza, DataInizio, DataFine) VALUES 
('RIC01', 'VRDLGI92F02L219V', 'RP001', 201, '2023-05-10', '2023-05-20'),
('RIC02', 'FRNCRL88C01H501B', 'RP002', 701, '2023-06-15', NULL),
('RIC03', 'SNTGPP95D12M208V', 'RP003', 801, '2023-07-20', '2023-07-25'),
('RIC04', 'RBCSRA85A01L839M', 'RP003', 901, '2023-08-10', '2023-08-15'),
('RIC05', 'LSDFNC90H01H501P', 'RP003', 902, '2023-09-05', NULL),
('RIC06', 'CNTGNN72C01G273N', 'RP002', 703, '2023-10-12', NULL),
('RIC07', 'BNCLUI90L01H501Y', 'RP004', 107, '2023-11-20', NULL),
('RIC08', 'RSTPPL92H01H501T', 'RP005', 501, '2023-12-01', NULL),
('RIC09', 'LNSFNC74L01H501D', 'RP005', 901, '2024-01-05', NULL),
('RIC10', 'FRNCLL80B01F205N', 'RP006', 601, '2024-02-15', '2024-02-25'),
('RIC11', 'FRNCLL80B01F205N', 'RP006', 601, '2024-06-01', '2024-06-01');


INSERT INTO RicoveroPatologia (Ricovero, Patologia) VALUES 
('RIC01', 'Depressione maggiore'),
('RIC02', 'Parkinson'),
('RIC03', 'Bipolarismo'),
('RIC06', 'Osteoporosi'),
('RIC07', 'Diabete tipo 1'),
('RIC10','Diabete tipo 2');


INSERT INTO Esame (Codice, Descrizione, CostoAssistenza, CostoPrivato) VALUES
('ES001', 'Esame del sangue', 25.00, 50.00),
('ES002', 'Radiografia toracica', 30.00, 75.00),
('ES003', 'Risonanza magnetica', 120.00, 300.00),
('ES004', 'Ecografia addominale', 50.00, 100.00),
('ES005', 'Elettrocardiogramma', 20.00, 45.00),
('ES006', 'Test allergologico', 40.00, 85.00),
('ES007', 'Gastroscopia', 70.00, 150.00),
('ES008', 'Colonscopia', 80.00, 180.00),
('ES009', 'TAC cranio', 100.00, 250.00),
('ES010', 'Analisi delle urine', 15.00, 35.00),
('ES011', 'Test di gravidanza', 10.00, 25.00),
('ES012', 'Test HIV', 30.00, 60.00),
('ES013', 'Test delle allergie alimentari', 50.00, 100.00),
('ES014', 'Coltura batterica', 40.00, 90.00),
('ES015', 'Holter cardiaco', 100.00, 200.00),
('ES016', 'Biopsia cutanea', 70.00, 150.00),
('ES017', 'Ecocardiogramma', 80.00, 180.00),
('ES018', 'Tomografia computerizzata', 150.00, 300.00),
('ES019', 'Esame citologico', 60.00, 120.00),
('ES020', 'Test di funzionalità polmonare', 90.00, 200.00);


INSERT INTO EsameSpecialistico (Codice, Avvertenze) VALUES
('ES004', 'Si consiglia di essere a digiuno da almeno 8 ore.'),
('ES005', 'Evitare di indossare oggetti metallici.'),
('ES007', 'Informare il medico di eventuali allergie ai mezzi di contrasto.'),
('ES008', 'Bere molta acqua prima dello esame per una migliore accuratezza.'),
('ES011', 'Evitare di assumere farmaci nelle 24 ore precedenti.'),
('ES012', 'Portare con sé eventuali esami precedenti per confronto.'),
('ES013', 'Non assumere bevande alcoliche nelle 48 ore precedenti.'),
('ES014', 'Indossare abiti comodi e facilmente rimovibili.'),
('ES017', 'Informare il personale medico in caso di gravidanza.'),
('ES020', 'Riposo assoluto per almeno 30 minuti dopo.');


INSERT INTO Prenotazione (Paziente, Esame, DataEsame, OraEsame, Laboratorio, DataPrenotazione, Urgenza, RegimePrivato, Prescrittore) VALUES
('GRMLRA75H01H501Z', 'ES005', '2024-05-01', '08:30:00', 'LAB01', '2024-05-01', 'Rosso', FALSE, NULL),
('VRDGNN85C01H501P', 'ES004', '2024-05-02', '10:15:00', 'LAB02', '2024-05-02', 'Giallo', FALSE, NULL),
('RSTPPL92H01H501T', 'ES014', '2024-05-03', '12:45:00', 'LAB09', '2024-05-03', 'Verde', TRUE, NULL),
('NVRLUI85L01H501M', 'ES020', '2024-05-04', '14:30:00', 'LAB08', '2024-05-04', 'Rosso', FALSE, NULL),
('BNCLUI90L01H501Y', 'ES001', '2024-05-01', '08:30:00', 'LAB03', '2024-05-01', 'Rosso', TRUE, 'BNCLRA85D07H501J'),
('VRDGNN85C01H501P', 'ES002', '2024-05-12', '10:15:00', 'LAB04', '2024-05-02', 'Giallo', FALSE, 'MLTLUC81B17H501M'),
('FRNCRL88C01H501B', 'ES010', '2024-05-03', '12:45:00', 'LAB04', '2024-05-03', 'Rosso', TRUE, 'BRNLSR70H18H501H'),
('VRDLGI92F02L219V', 'ES016', '2024-05-04', '14:30:00', 'LAB07', '2024-05-04', 'Rosso', FALSE, 'CLMNDR75B12H501S'),
('RSSMRA85M01H501Z', 'ES003', '2024-05-05', '16:00:00', 'LAB05', '2024-05-05', 'Giallo', TRUE, 'FRNMRZ88D09H501N'),
('FRNCLL80B01F205N', 'ES009', '2024-05-06', '09:45:00', 'LAB10', '2024-05-06', 'Verde', FALSE, 'VRNZLS88L03H501T');


INSERT INTO OrarioAperturaLaboratorio (Laboratorio, GiornoSettimana, OraApertura, OraChiusura) VALUES
('LAB09', 'Lunedì', '08:00:00', '18:00:00'),
('LAB09', 'Martedì', '08:00:00', '18:00:00'),
('LAB09', 'Mercoledì', '08:00:00', '18:00:00'),
('LAB09', 'Giovedì', '08:00:00', '18:00:00'),
('LAB09', 'Venerdì', '08:00:00', '18:00:00'),
('LAB09', 'Sabato', '09:00:00', '13:00:00'),
('LAB09', 'Domenica', '06:00:00', '13:30:00'),
('LAB10', 'Lunedì', '09:00:00', '17:00:00'),
('LAB10', 'Mercoledì', '09:00:00', '17:00:00'),
('LAB10', 'Venerdì', '09:00:00', '17:00:00'),
('LAB11', 'Sabato', '09:00:00', '13:00:00'),
('LAB12', 'Domenica', '10:00:00', '14:00:00');

INSERT INTO OrarioVisiteReparto (Reparto, GiornoSettimana, OraApertura, OraChiusura) VALUES
('RP001', 'Lunedì', '08:00:00', '12:00:00'),
('RP001', 'Martedì', '13:00:00', '17:00:00'),
('RP001', 'Giovedì', '13:00:00', '17:00:00'),
('RP001', 'Venerdì', '08:00:00', '12:00:00'),
('RP002', 'Lunedì', '09:00:00', '13:00:00'),
('RP002', 'Martedì', '14:00:00', '18:00:00'),
('RP002', 'Mercoledì', '09:00:00', '13:00:00'),
('RP003', 'Sabato', '08:00:00', '12:00:00');
