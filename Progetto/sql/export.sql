--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-06-14 20:44:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 883 (class 1247 OID 21293)
-- Name: fasciaurgenza; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.fasciaurgenza AS ENUM (
    'Rosso',
    'Giallo',
    'Verde'
);


ALTER TYPE public.fasciaurgenza OWNER TO postgres;

--
-- TOC entry 886 (class 1247 OID 21300)
-- Name: giornosettimana; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.giornosettimana AS ENUM (
    'Lunedì',
    'Martedì',
    'Mercoledì',
    'Giovedì',
    'Venerdì',
    'Sabato',
    'Domenica'
);


ALTER TYPE public.giornosettimana OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 21715)
-- Name: check_and_delete_richiesta(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_and_delete_richiesta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Delete from RichiestaPrenotazione where there's a match on Paziente and Esame
    DELETE FROM RichiestaPrenotazione
    WHERE Paziente = NEW.Paziente
      AND Esame = NEW.Esame;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_and_delete_richiesta() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 21693)
-- Name: check_lab(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_lab() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    IF (SELECT numeroLetti FROM Stanza WHERE reparto = NEW.reparto AND numero = NEW.stanza) IS NOT NULL THEN
        RAISE EXCEPTION 'La stanza % del reparto % non ha numeroLetti NULL', NEW.stanza, NEW.reparto;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_lab() OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 21707)
-- Name: check_letti(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_letti() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se la stanza ha un numeroLetti diverso da NULL
    IF (SELECT numeroLetti FROM Stanza WHERE reparto = NEW.reparto AND numero = NEW.stanza) IS NULL THEN
        RAISE EXCEPTION 'La stanza % del reparto % ha numeroLetti NULL', NEW.stanza, NEW.reparto;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_letti() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 21709)
-- Name: check_letti_stanza(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_letti_stanza() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    numero_ricoveri INTEGER;
    numero_letti INTEGER;
BEGIN
    -- Conta il numero di ricoveri attualmente in corso nella stanza
    SELECT COUNT(*)
    INTO numero_ricoveri
    FROM Ricovero
    WHERE reparto = NEW.reparto AND stanza = NEW.stanza AND DataFine IS NULL;

    -- Ottieni il numero di letti nella stanza
    SELECT numeroLetti
    INTO numero_letti
    FROM Stanza
    WHERE reparto = NEW.reparto AND numero = NEW.stanza;

    -- Verifica se il numero di ricoveri attualmente in corso è maggiore o uguale al numero di letti
    IF numero_ricoveri >= numero_letti THEN
        RAISE EXCEPTION 'La stanza % del reparto % ha già tutti i letti occupati.', NEW.stanza, NEW.reparto;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_letti_stanza() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 21713)
-- Name: check_medico_prescrittore(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_medico_prescrittore() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se l'esame è uno specialistico
    IF EXISTS (SELECT 1 FROM EsameSpecialistico WHERE codice = NEW.esame) THEN
        -- Verifica se è stato impostato un medico prescrittore
        IF NEW.Prescrittore IS NULL THEN
            RAISE EXCEPTION 'Devi specificare un medico prescrittore per un esame specialistico. %', NEW.paziente;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_medico_prescrittore() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 21701)
-- Name: check_primario(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_primario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il CF esiste anche nella tabella VicePrimario
    IF EXISTS (SELECT 1 FROM VicePrimario WHERE CF = NEW.CF) THEN
        RAISE EXCEPTION 'Il primario % non può essere anche un viceprimario', NEW.CF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_primario() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 21695)
-- Name: check_reparto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_reparto() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il CF del nuovo record abbia con un reparto associato
    IF (SELECT reparto FROM Personale WHERE CF = NEW.CF) IS NULL THEN
        RAISE EXCEPTION 'Il dipendente % non ha un reparto associato', NEW.CF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reparto() OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 21697)
-- Name: check_reparto_primario(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_reparto_primario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il CF e reparto del nuovo record coincidono con un record nella tabella Personale
    IF NOT EXISTS (SELECT 1 FROM Personale WHERE CF = NEW.CF AND reparto = NEW.reparto) THEN
        RAISE EXCEPTION 'Il primario % non lavora nel reparto associato %', NEW.CF, NEW.reparto;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reparto_primario() OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 21703)
-- Name: check_reparto_sostituzione(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_reparto_sostituzione() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il Primario e il Vice Primario sono dello stesso reparto
    IF (SELECT reparto FROM Primario WHERE CF = NEW.primario) != (SELECT reparto FROM VicePrimario WHERE CF = NEW.viceprimario) THEN
        RAISE EXCEPTION 'Il Primario % e il Vice Primario % non sono dello stesso reparto', NEW.primario, NEW.viceprimario;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reparto_sostituzione() OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 21699)
-- Name: check_reparto_vice_primario(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_reparto_vice_primario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se il CF e reparto del nuovo record coincidono con un record nella tabella Personale
    IF NOT EXISTS (SELECT 1 FROM Personale WHERE CF = NEW.CF AND reparto = NEW.reparto) THEN
        RAISE EXCEPTION 'Il vice primario % non lavora nel reparto associato %', NEW.CF, NEW.reparto;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reparto_vice_primario() OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 21711)
-- Name: check_ricovero_in_corso(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_ricovero_in_corso() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se esiste un ricovero in corso per il paziente
    IF EXISTS (SELECT 1 
               FROM Ricovero
               WHERE paziente = NEW.paziente
                 AND (DataFine IS NULL 
                 OR DataFine > NEW.DataInizio)) THEN
        RAISE EXCEPTION 'Il paziente % è già ricoverato.', NEW.paziente;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_ricovero_in_corso() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 21705)
-- Name: check_turno_in_corso(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_turno_in_corso() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se esiste un ricovero in corso per il paziente
    IF EXISTS (SELECT 1 
               FROM TurnoPS
               WHERE personale = NEW.personale
                 AND (dataOraFine IS NULL 
                 OR dataOraFine > NEW.dataOraInizio)) THEN
        RAISE EXCEPTION 'Il dipendente % è già in turno il %', NEW.personale, NEW.dataOraInizio;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_turno_in_corso() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 21540)
-- Name: collaborazioneospedalelaboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collaborazioneospedalelaboratorio (
    ospedale character(5) NOT NULL,
    laboratorio character(5) NOT NULL
);


ALTER TABLE public.collaborazioneospedalelaboratorio OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 21593)
-- Name: esame; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.esame (
    codice character(5) NOT NULL,
    descrizione character varying(50) NOT NULL,
    costoassistenza numeric(6,2) NOT NULL,
    costoprivato numeric(6,2) NOT NULL
);


ALTER TABLE public.esame OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 21598)
-- Name: esamespecialistico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.esamespecialistico (
    codice character(5) NOT NULL,
    avvertenze character varying(200)
);


ALTER TABLE public.esamespecialistico OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 21372)
-- Name: infermiere; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infermiere (
    cf character(16) NOT NULL
);


ALTER TABLE public.infermiere OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 21507)
-- Name: laboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laboratorio (
    codice character(5) NOT NULL
);


ALTER TABLE public.laboratorio OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 21529)
-- Name: laboratorioesterno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laboratorioesterno (
    codice character(5) NOT NULL,
    telefono character varying(10) NOT NULL,
    cap character varying(5) NOT NULL,
    via character varying(30) NOT NULL,
    nciv numeric(3,0) NOT NULL,
    CONSTRAINT laboratorioesterno_nciv_check CHECK ((nciv > (0)::numeric))
);


ALTER TABLE public.laboratorioesterno OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 21512)
-- Name: laboratoriointerno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laboratoriointerno (
    codice character(5) NOT NULL,
    reparto character(5) NOT NULL,
    stanza numeric(3,0) NOT NULL
);


ALTER TABLE public.laboratoriointerno OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 21636)
-- Name: orarioaperturalaboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orarioaperturalaboratorio (
    laboratorio character(5) NOT NULL,
    giornosettimana public.giornosettimana NOT NULL,
    oraapertura time without time zone NOT NULL,
    orachiusura time without time zone NOT NULL,
    CONSTRAINT orarioaperturalaboratorio_check CHECK ((orachiusura > oraapertura))
);


ALTER TABLE public.orarioaperturalaboratorio OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 21647)
-- Name: orariovisitereparto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orariovisitereparto (
    reparto character(5) NOT NULL,
    giornosettimana public.giornosettimana NOT NULL,
    oraapertura time without time zone NOT NULL,
    orachiusura time without time zone NOT NULL,
    CONSTRAINT orariovisitereparto_check CHECK ((orachiusura > oraapertura))
);


ALTER TABLE public.orariovisitereparto OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 21323)
-- Name: ospedale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ospedale (
    codice character(5) NOT NULL,
    nome character varying(30) NOT NULL,
    cap character varying(5) NOT NULL,
    via character varying(30) NOT NULL,
    nciv numeric(3,0) NOT NULL,
    CONSTRAINT ospedale_nciv_check CHECK ((nciv > (0)::numeric))
);


ALTER TABLE public.ospedale OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 21573)
-- Name: patologia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patologia (
    patologia character varying(50) NOT NULL
);


ALTER TABLE public.patologia OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 21315)
-- Name: paziente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paziente (
    cf character(16) NOT NULL,
    numerotessera character(20) NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    cap character varying(5) NOT NULL,
    via character varying(30) NOT NULL,
    nciv numeric(3,0) NOT NULL,
    CONSTRAINT paziente_nciv_check CHECK ((nciv > (0)::numeric))
);


ALTER TABLE public.paziente OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 21341)
-- Name: personale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personale (
    cf character(16) NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    datanascita date NOT NULL,
    cap character varying(5) NOT NULL,
    via character varying(30) NOT NULL,
    nciv numeric(3,0) NOT NULL,
    reparto character(5),
    CONSTRAINT personale_nciv_check CHECK ((nciv > (0)::numeric))
);


ALTER TABLE public.personale OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 21352)
-- Name: personaleamministrativo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personaleamministrativo (
    cf character(16) NOT NULL
);


ALTER TABLE public.personaleamministrativo OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 21382)
-- Name: personalemedico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personalemedico (
    cf character(16) NOT NULL,
    datainizioservizio date NOT NULL
);


ALTER TABLE public.personalemedico OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 21362)
-- Name: personalesanitario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personalesanitario (
    cf character(16) NOT NULL
);


ALTER TABLE public.personalesanitario OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 21608)
-- Name: prenotazione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prenotazione (
    paziente character(16) NOT NULL,
    esame character(5) NOT NULL,
    dataesame date NOT NULL,
    oraesame time without time zone NOT NULL,
    laboratorio character(5) NOT NULL,
    dataprenotazione date NOT NULL,
    urgenza public.fasciaurgenza NOT NULL,
    regimeprivato boolean NOT NULL,
    prescrittore character(16),
    CONSTRAINT prenotazione_check CHECK ((dataesame >= dataprenotazione))
);


ALTER TABLE public.prenotazione OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 21392)
-- Name: primario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.primario (
    cf character(16) NOT NULL,
    reparto character(5) NOT NULL
);


ALTER TABLE public.primario OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 21481)
-- Name: prontosoccorso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prontosoccorso (
    ospedale character(5) NOT NULL
);


ALTER TABLE public.prontosoccorso OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 21329)
-- Name: reparto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reparto (
    codice character(5) NOT NULL,
    ospedale character(5) NOT NULL,
    nome character varying(30) NOT NULL,
    piano numeric(2,0) NOT NULL,
    telefono character varying(10) NOT NULL
);


ALTER TABLE public.reparto OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 21678)
-- Name: richiestaprenotazione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.richiestaprenotazione (
    paziente character(16) NOT NULL,
    esame character(5) NOT NULL,
    regimeprivato boolean NOT NULL,
    descrizione character varying(255)
);


ALTER TABLE public.richiestaprenotazione OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 21555)
-- Name: ricovero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ricovero (
    codice character(5) NOT NULL,
    paziente character(16) NOT NULL,
    reparto character(5) NOT NULL,
    stanza numeric(3,0) NOT NULL,
    datainizio date NOT NULL,
    datafine date,
    CONSTRAINT ricovero_check CHECK (((datafine IS NULL) OR (datafine >= datainizio)))
);


ALTER TABLE public.ricovero OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 21578)
-- Name: ricoveropatologia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ricoveropatologia (
    ricovero character(5) NOT NULL,
    patologia character varying(50) NOT NULL
);


ALTER TABLE public.ricoveropatologia OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 21460)
-- Name: salaoperatoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salaoperatoria (
    reparto character(5) NOT NULL
);


ALTER TABLE public.salaoperatoria OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 21444)
-- Name: sostituzione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sostituzione (
    primario character(16) NOT NULL,
    viceprimario character(16) NOT NULL,
    datainizio date NOT NULL,
    datafine date,
    CONSTRAINT sostituzione_check CHECK (((datafine IS NULL) OR (datafine > datainizio)))
);


ALTER TABLE public.sostituzione OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 21424)
-- Name: specializzazione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specializzazione (
    specializzazione character varying(30) NOT NULL
);


ALTER TABLE public.specializzazione OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 21429)
-- Name: specializzazioneprimario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specializzazioneprimario (
    primario character(16) NOT NULL,
    specializzazione character varying(30) NOT NULL
);


ALTER TABLE public.specializzazioneprimario OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 21470)
-- Name: stanza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stanza (
    reparto character(5) NOT NULL,
    numero numeric(3,0) NOT NULL,
    numeroletti numeric(2,0),
    CONSTRAINT stanza_numeroletti_check CHECK (((numeroletti IS NULL) OR (numeroletti >= (0)::numeric)))
);


ALTER TABLE public.stanza OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 21491)
-- Name: turnops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.turnops (
    prontosoccorso character(5) NOT NULL,
    personale character(16) NOT NULL,
    dataorainizio timestamp without time zone NOT NULL,
    dataorafine timestamp without time zone,
    CONSTRAINT turnops_check CHECK (((dataorafine IS NULL) OR (dataorafine > dataorainizio)))
);


ALTER TABLE public.turnops OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 21658)
-- Name: utenzapaziente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utenzapaziente (
    paziente character(16) NOT NULL,
    hashedpassword character varying(255) NOT NULL
);


ALTER TABLE public.utenzapaziente OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 21668)
-- Name: utenzapersonale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utenzapersonale (
    personale character(16) NOT NULL,
    hashedpassword character varying(255) NOT NULL
);


ALTER TABLE public.utenzapersonale OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 21409)
-- Name: viceprimario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.viceprimario (
    cf character(16) NOT NULL,
    dataassunzioneruolo date NOT NULL,
    reparto character(5) NOT NULL
);


ALTER TABLE public.viceprimario OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 21540)
-- Dependencies: 235
-- Data for Name: collaborazioneospedalelaboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collaborazioneospedalelaboratorio (ospedale, laboratorio) FROM stdin;
OS001	LAB11
OS002	LAB09
OS003	LAB10
OS003	LAB12
\.


--
-- TOC entry 5134 (class 0 OID 21593)
-- Dependencies: 239
-- Data for Name: esame; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.esame (codice, descrizione, costoassistenza, costoprivato) FROM stdin;
ES001	Esame del sangue	25.00	50.00
ES002	Radiografia toracica	30.00	75.00
ES003	Risonanza magnetica	120.00	300.00
ES004	Ecografia addominale	50.00	100.00
ES005	Elettrocardiogramma	20.00	45.00
ES006	Test allergologico	40.00	85.00
ES007	Gastroscopia	70.00	150.00
ES008	Colonscopia	80.00	180.00
ES009	TAC cranio	100.00	250.00
ES010	Analisi delle urine	15.00	35.00
ES011	Test di gravidanza	10.00	25.00
ES012	Test HIV	30.00	60.00
ES013	Test delle allergie alimentari	50.00	100.00
ES014	Coltura batterica	40.00	90.00
ES015	Holter cardiaco	100.00	200.00
ES016	Biopsia cutanea	70.00	150.00
ES017	Ecocardiogramma	80.00	180.00
ES018	Tomografia computerizzata	150.00	300.00
ES019	Esame citologico	60.00	120.00
ES020	Test di funzionalità polmonare	90.00	200.00
\.


--
-- TOC entry 5135 (class 0 OID 21598)
-- Dependencies: 240
-- Data for Name: esamespecialistico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.esamespecialistico (codice, avvertenze) FROM stdin;
ES004	Si consiglia di essere a digiuno da almeno 8 ore.
ES005	Evitare di indossare oggetti metallici.
ES007	Informare il medico di eventuali allergie ai mezzi di contrasto.
ES008	Bere molta acqua prima dello esame per una migliore accuratezza.
ES011	Evitare di assumere farmaci nelle 24 ore precedenti.
ES012	Portare con sé eventuali esami precedenti per confronto.
ES013	Non assumere bevande alcoliche nelle 48 ore precedenti.
ES014	Indossare abiti comodi e facilmente rimovibili.
ES017	Informare il personale medico in caso di gravidanza.
ES020	Riposo assoluto per almeno 30 minuti dopo.
\.


--
-- TOC entry 5116 (class 0 OID 21372)
-- Dependencies: 221
-- Data for Name: infermiere; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.infermiere (cf) FROM stdin;
VRDLGU80B20H501Y
NRIMRA90D30H501A
FRRPLO83L20H501D
RCCGLI87M25H501E
CSTSRN92R05H501G
\.


--
-- TOC entry 5127 (class 0 OID 21507)
-- Dependencies: 232
-- Data for Name: laboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laboratorio (codice) FROM stdin;
LAB01
LAB02
LAB03
LAB04
LAB05
LAB06
LAB07
LAB08
LAB09
LAB10
LAB11
LAB12
\.


--
-- TOC entry 5129 (class 0 OID 21529)
-- Dependencies: 234
-- Data for Name: laboratorioesterno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laboratorioesterno (codice, telefono, cap, via, nciv) FROM stdin;
LAB09	1234567890	00100	Via Roma	10
LAB10	2345678901	00200	Via Milano	20
LAB11	3456789012	00300	Via Napoli	30
LAB12	4567890123	00400	Via Torino	40
\.


--
-- TOC entry 5128 (class 0 OID 21512)
-- Dependencies: 233
-- Data for Name: laboratoriointerno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laboratoriointerno (codice, reparto, stanza) FROM stdin;
LAB01	RP001	101
LAB02	RP001	301
LAB03	RP003	301
LAB04	RP004	601
LAB05	RP004	701
LAB06	RP005	801
LAB07	RP001	203
LAB08	RP002	702
\.


--
-- TOC entry 5137 (class 0 OID 21636)
-- Dependencies: 242
-- Data for Name: orarioaperturalaboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orarioaperturalaboratorio (laboratorio, giornosettimana, oraapertura, orachiusura) FROM stdin;
LAB09	Lunedì	08:00:00	18:00:00
LAB09	Martedì	08:00:00	18:00:00
LAB09	Mercoledì	08:00:00	18:00:00
LAB09	Giovedì	08:00:00	18:00:00
LAB09	Venerdì	08:00:00	18:00:00
LAB09	Sabato	09:00:00	13:00:00
LAB09	Domenica	06:00:00	13:30:00
LAB10	Lunedì	09:00:00	17:00:00
LAB10	Mercoledì	09:00:00	17:00:00
LAB10	Venerdì	09:00:00	17:00:00
LAB11	Sabato	09:00:00	13:00:00
LAB12	Domenica	10:00:00	14:00:00
\.


--
-- TOC entry 5138 (class 0 OID 21647)
-- Dependencies: 243
-- Data for Name: orariovisitereparto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orariovisitereparto (reparto, giornosettimana, oraapertura, orachiusura) FROM stdin;
RP001	Lunedì	08:00:00	12:00:00
RP001	Martedì	13:00:00	17:00:00
RP001	Giovedì	13:00:00	17:00:00
RP001	Venerdì	08:00:00	12:00:00
RP002	Lunedì	09:00:00	13:00:00
RP002	Martedì	14:00:00	18:00:00
RP002	Mercoledì	09:00:00	13:00:00
RP003	Sabato	08:00:00	12:00:00
\.


--
-- TOC entry 5111 (class 0 OID 21323)
-- Dependencies: 216
-- Data for Name: ospedale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ospedale (codice, nome, cap, via, nciv) FROM stdin;
OS001	Ospedale Maggiore	20100	Via Emilia	15
OS002	Ospedale Niguarda	20162	Piazza Ospedale Maggiore	3
OS003	Ospedale San Raffaele	20132	Via Olgettina	60
OS004	Ospedale Bambin Gesù	00165	Piazza Maggiore	4
\.


--
-- TOC entry 5132 (class 0 OID 21573)
-- Dependencies: 237
-- Data for Name: patologia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patologia (patologia) FROM stdin;
Diabete tipo 1
Ipertensione arteriosa
Asma bronchiale
Artrite reumatoide
Cancro al seno
Depressione maggiore
Malattia di Alzheimer
HIV/AIDS
Parkinson
Malattia di Crohn
Fibrosi polmonare idiopatica
Sclerosi multipla
Lupus eritematoso sistemico
Epilessia
Osteoporosi
Anoressia nervosa
Bipolarismo
Fibromialgia
Sindrome di Down
Diabete tipo 2
Malattia di Parkinson
Sindrome di Tourette
Sclerosi laterale amiotrofica
Anemia falciforme
\.


--
-- TOC entry 5110 (class 0 OID 21315)
-- Dependencies: 215
-- Data for Name: paziente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paziente (cf, numerotessera, nome, cognome, datanascita, cap, via, nciv) FROM stdin;
RSSMRA85M01H501Z	12345678901234567890	Mario	Rossi	1985-01-01	00184	Via del Corso	1
VRDLGI92F02L219V	22345678901234567890	Luigi	Verdi	1992-06-15	20121	Via Montenapoleone	15
BNCLRA70A01F205Z	32345678901234567890	Laura	Bianchi	1970-04-20	80121	Via Partenope	45
FRNCRL88C01H501B	42345678901234567890	Carlo	Ferrari	1988-03-10	10121	Via Roma	22
SNTGPP95D12M208V	52345678901234567890	Giuseppe	Santi	1995-07-12	50122	Via dei Tornabuoni	30
MNDFRN78B01H501C	62345678901234567890	Francesca	Mondi	1978-02-18	30121	Riva degli Schiavoni	7
RBCSRA85A01L839M	72345678901234567890	Sara	Rubini	1985-11-01	16121	Via Garibaldi	55
LSDFNC90H01H501P	82345678901234567890	Franco	Lisi	1990-08-23	90133	Via Vittorio Emanuele	12
CNTGNN72C01G273N	92345678901234567890	Gennaro	Conti	1972-12-30	70121	Corso Vittorio Emanuele	20
MRTLUI83F01H501A	10234567890123456789	Luisa	Martini	1983-05-05	10121	Via Po	18
BNCLUI90L01H501Y	11234567890123456789	Luigi	Bianchi	1990-12-01	37121	Corso Porta Nuova	25
GRMLRA75H01H501Z	21234567890123456789	Lara	Germani	1975-08-01	73100	Via XXV Luglio	33
PNCMRA68A01F205L	31234567890123456789	Marco	Panico	1968-01-01	85100	Corso XVIII Agosto	14
VRDGNN85C01H501P	41234567890123456789	Gianni	Verdi	1985-03-01	70121	Via Sparano	28
FNTGLL90L01H501B	51234567890123456789	Giulia	Fontana	1990-12-01	06121	Corso Vannucci	40
BLCSRA83M01H501C	61234567890123456789	Sara	Bellucci	1983-01-01	09124	Via Roma	19
RSTPPL92H01H501T	71234567890123456789	Paolo	Rossi	1992-08-01	91100	Via Fardella	21
LNSFNC74L01H501D	81234567890123456789	Franco	Lanza	1974-12-01	98121	Viale San Martino	17
FRNCLL80B01F205N	91234567890123456789	Luca	Franchi	1980-02-01	42121	Corso Garibaldi	13
NVRLUI85L01H501M	10123456789012345678	Luigi	Neri	1985-12-01	57123	Via Grande	23
CRTFPP03S07L319C	10123456789012345656	Filippo	Corti	2003-11-07	22073	Via XXV Aprile	15
\.


--
-- TOC entry 5113 (class 0 OID 21341)
-- Dependencies: 218
-- Data for Name: personale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personale (cf, nome, cognome, datanascita, cap, via, nciv, reparto) FROM stdin;
RSSMRA75A15H501Z	Mario	Rossi	1975-01-15	00184	Via del Corso	10	RP001
VRDLGU80B20H501Y	Luigi	Verdi	1980-02-20	20121	Via Montenapoleone	20	RP005
BNCLNN85C25H501X	Anna	Bianchi	1985-03-25	80121	Via Partenope	30	RP006
NRIMRA90D30H501A	Maria	Neri	1990-04-30	10121	Via Po	40	RP003
RSSCRL82E10H501B	Carlo	Russo	1982-05-10	50122	Via dei Tornabuoni	50	RP005
SPSLRA78H15H501C	Laura	Esposito	1978-06-15	30121	Riva degli Schiavoni	60	RP005
FRRPLO83L20H501D	Paolo	Ferrari	1983-07-20	16121	Via Garibaldi	70	RP001
RCCGLI87M25H501E	Giulia	Ricci	1987-08-25	90133	Via Vittorio Emanuele	80	RP001
MRNFNC76P30H501F	Francesco	Marini	1976-09-30	70121	Corso Vittorio Emanuele	90	RP002
CSTSRN92R05H501G	Sara	Costa	1992-10-05	10121	Via Roma	100	RP006
CSTMRM80A01H501H	Mario	Costani	1980-01-01	40100	Via Emilia	15	RP004
VRDLPL75C15H501I	Paolo	Verdi	1975-03-15	40126	Via Massarenti	9	RP003
BNCLRA85D07H501J	Laura	Bianchi	1985-04-07	20162	Piazza Ospedale Maggiore	3	RP003
CNTFNC78L14H501K	Francesca	Conti	1978-07-14	20122	Via Francesco Sforza	35	RP004
MRNGGI82E18H501L	Giorgio	Marin	1982-05-18	00165	Via Celoria	4	RP006
BGNLUC76T22H501M	Luca	Bagnoli	1976-12-22	50100	Via della Libertà	22	RP001
RSSFNC81M07H501N	Franco	Rossi	1981-11-07	70123	Via del Mare	45	RP001
MRRCLD83R14H501O	Claudia	Marrone	1983-10-14	80100	Via Roma	10	RP003
BLRTNG84A12H501P	Tania	Baldi	1984-08-12	90100	Via Milano	28	RP002
CNTLCR80S20H501Q	Lucia	Contini	1980-09-20	10121	Corso Torino	12	RP001
TSTMRN70A01H501R	Marina	Testa	1970-01-01	10001	Via delle Rose	5	RP003
CLMNDR75B12H501S	Andrea	Colombo	1975-02-12	20002	Via Garibaldi	12	RP001
FRNLCN80C23H501T	Lorenzo	Ferrari	1980-03-23	30003	Viale della Repubblica	8	RP005
BRGLGN85D04H501D	Gianni	Brugnone	1985-04-04	40004	Piazza Libertà	16	RP001
VRNMRC90E15H501E	Marco	Verona	1990-05-15	50005	Via Dante	22	RP004
SMNTLL95F26H501F	Tullio	Simonetti	1995-06-26	60006	Via Pascoli	30	RP006
RZZMRZ65G07H501G	Marzio	Rizzi	1965-07-07	70007	Via Foscolo	45	RP006
BRNLSR70H18H501H	Sara	Bernini	1970-08-18	80008	Via Petrarca	50	RP005
CRSLGI75I29H501I	Giovanni	Corsini	1975-09-29	90009	Via Ariosto	60	RP003
DLPFNC80L01H501J	Fiona	Dallaporta	1980-10-01	10010	Via Boccaccio	35	RP001
TNDMRZ83I10H501S	Maurizio	Tandelli	1983-09-10	91091	Via Monti	21	RP002
PLNTLR72M11H501K	Lorenzo	Pallante	1972-11-11	11011	Via Garibaldi	7	\N
VRDGLA78C15H501L	Giulia	Verdi	1978-03-15	21021	Via Manzoni	23	\N
MLTLUC81B17H501M	Lucia	Maltoni	1981-02-17	31031	Via Carducci	11	\N
FRNMRZ88D09H501N	Marzia	Ferrara	1988-04-09	41041	Via Tasso	18	\N
BGNLRN70A22H501O	Renato	Bagnoli	1970-01-22	51051	Via Leopardi	24	\N
SMTMLS90E12H501P	Michele	Simonti	1990-05-12	61061	Via Montale	9	\N
FRGLFR95F25H501Q	Franco	Frugoli	1995-06-25	71071	Via Ungaretti	13	\N
MRRCSL85H14H501R	Silvia	Marroni	1985-08-14	81081	Via Pascoli	17	\N
VRNZLS88L03H501T	Lisa	Vernizzi	1988-12-03	10101	Via Ghiberti	5	\N
\.


--
-- TOC entry 5114 (class 0 OID 21352)
-- Dependencies: 219
-- Data for Name: personaleamministrativo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personaleamministrativo (cf) FROM stdin;
RSSMRA75A15H501Z
BNCLNN85C25H501X
RSSCRL82E10H501B
MRNFNC76P30H501F
CNTLCR80S20H501Q
\.


--
-- TOC entry 5117 (class 0 OID 21382)
-- Dependencies: 222
-- Data for Name: personalemedico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personalemedico (cf, datainizioservizio) FROM stdin;
CSTMRM80A01H501H	2010-09-01
VRDLPL75C15H501I	2011-10-15
BNCLRA85D07H501J	2012-11-20
CNTFNC78L14H501K	2010-06-12
MRNGGI82E18H501L	2015-02-13
BGNLUC76T22H501M	2010-02-12
RSSFNC81M07H501N	2006-12-02
MRRCLD83R14H501O	2010-02-12
BLRTNG84A12H501P	2000-01-20
TSTMRN70A01H501R	2010-02-04
CLMNDR75B12H501S	2013-09-12
FRNLCN80C23H501T	2016-02-01
BRGLGN85D04H501D	2010-04-12
VRNMRC90E15H501E	2009-11-12
SMNTLL95F26H501F	2018-09-15
RZZMRZ65G07H501G	2020-05-22
BRNLSR70H18H501H	2003-07-08
CRSLGI75I29H501I	2012-12-12
DLPFNC80L01H501J	2017-10-25
PLNTLR72M11H501K	1999-11-02
VRDGLA78C15H501L	2000-01-05
MLTLUC81B17H501M	2005-04-10
FRNMRZ88D09H501N	2010-12-19
BGNLRN70A22H501O	2001-04-12
SMTMLS90E12H501P	2015-10-02
FRGLFR95F25H501Q	2021-02-05
MRRCSL85H14H501R	2000-03-16
TNDMRZ83I10H501S	2003-12-01
VRNZLS88L03H501T	2009-07-13
SPSLRA78H15H501C	2020-10-14
\.


--
-- TOC entry 5115 (class 0 OID 21362)
-- Dependencies: 220
-- Data for Name: personalesanitario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personalesanitario (cf) FROM stdin;
VRDLGU80B20H501Y
NRIMRA90D30H501A
SPSLRA78H15H501C
FRRPLO83L20H501D
RCCGLI87M25H501E
CSTSRN92R05H501G
CSTMRM80A01H501H
VRDLPL75C15H501I
BNCLRA85D07H501J
CNTFNC78L14H501K
MRNGGI82E18H501L
BGNLUC76T22H501M
RSSFNC81M07H501N
MRRCLD83R14H501O
BLRTNG84A12H501P
TSTMRN70A01H501R
CLMNDR75B12H501S
FRNLCN80C23H501T
BRGLGN85D04H501D
VRNMRC90E15H501E
SMNTLL95F26H501F
RZZMRZ65G07H501G
BRNLSR70H18H501H
CRSLGI75I29H501I
DLPFNC80L01H501J
PLNTLR72M11H501K
VRDGLA78C15H501L
MLTLUC81B17H501M
FRNMRZ88D09H501N
BGNLRN70A22H501O
SMTMLS90E12H501P
FRGLFR95F25H501Q
MRRCSL85H14H501R
TNDMRZ83I10H501S
VRNZLS88L03H501T
\.


--
-- TOC entry 5136 (class 0 OID 21608)
-- Dependencies: 241
-- Data for Name: prenotazione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prenotazione (paziente, esame, dataesame, oraesame, laboratorio, dataprenotazione, urgenza, regimeprivato, prescrittore) FROM stdin;
GRMLRA75H01H501Z	ES001	2024-05-01	08:30:00	LAB01	2024-05-01	Rosso	f	\N
VRDGNN85C01H501P	ES002	2024-05-02	10:15:00	LAB02	2024-05-02	Giallo	f	\N
RSTPPL92H01H501T	ES010	2024-05-03	12:45:00	LAB09	2024-05-03	Verde	t	\N
NVRLUI85L01H501M	ES019	2024-05-04	14:30:00	LAB08	2024-05-04	Rosso	f	\N
BNCLUI90L01H501Y	ES004	2024-05-01	08:30:00	LAB03	2024-05-01	Rosso	t	BNCLRA85D07H501J
VRDGNN85C01H501P	ES005	2024-05-12	10:15:00	LAB04	2024-05-02	Giallo	f	MLTLUC81B17H501M
FRNCRL88C01H501B	ES011	2024-05-03	12:45:00	LAB04	2024-05-03	Rosso	t	BRNLSR70H18H501H
VRDLGI92F02L219V	ES014	2024-05-04	14:30:00	LAB07	2024-05-04	Rosso	f	CLMNDR75B12H501S
RSSMRA85M01H501Z	ES007	2024-05-05	16:00:00	LAB05	2024-05-05	Giallo	t	FRNMRZ88D09H501N
FRNCLL80B01F205N	ES007	2024-05-06	09:45:00	LAB10	2024-05-06	Verde	f	VRNZLS88L03H501T
CRTFPP03S07L319C	ES001	2025-05-06	09:45:00	LAB08	2024-05-06	Verde	f	\N
CRTFPP03S07L319C	ES019	2025-01-08	11:45:00	LAB09	2024-05-06	Giallo	f	\N
CRTFPP03S07L319C	ES014	2024-12-16	12:00:00	LAB10	2024-05-06	Rosso	t	MLTLUC81B17H501M
\.


--
-- TOC entry 5118 (class 0 OID 21392)
-- Dependencies: 223
-- Data for Name: primario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.primario (cf, reparto) FROM stdin;
CLMNDR75B12H501S	RP001
BLRTNG84A12H501P	RP002
TSTMRN70A01H501R	RP003
CSTMRM80A01H501H	RP004
SPSLRA78H15H501C	RP005
MRNGGI82E18H501L	RP006
\.


--
-- TOC entry 5125 (class 0 OID 21481)
-- Dependencies: 230
-- Data for Name: prontosoccorso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prontosoccorso (ospedale) FROM stdin;
OS004
OS001
\.


--
-- TOC entry 5112 (class 0 OID 21329)
-- Dependencies: 217
-- Data for Name: reparto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reparto (codice, ospedale, nome, piano, telefono) FROM stdin;
RP001	OS001	Cardiologia	2	0212345678
RP002	OS001	Oncologia	1	0223456789
RP003	OS003	Ginecologia	2	0312345678
RP004	OS003	Pediatria	4	0323456789
RP005	OS003	Fisioterapia	2	0334567890
RP006	OS003	Cardiologia	3	0345678901
\.


--
-- TOC entry 5141 (class 0 OID 21678)
-- Dependencies: 246
-- Data for Name: richiestaprenotazione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.richiestaprenotazione (paziente, esame, regimeprivato, descrizione) FROM stdin;
\.


--
-- TOC entry 5131 (class 0 OID 21555)
-- Dependencies: 236
-- Data for Name: ricovero; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ricovero (codice, paziente, reparto, stanza, datainizio, datafine) FROM stdin;
RIC01	VRDLGI92F02L219V	RP001	201	2023-05-10	2023-05-20
RIC02	FRNCRL88C01H501B	RP002	701	2023-06-15	\N
RIC03	SNTGPP95D12M208V	RP003	801	2023-07-20	2023-07-25
RIC04	RBCSRA85A01L839M	RP003	901	2023-08-10	2023-08-15
RIC05	LSDFNC90H01H501P	RP003	902	2023-09-05	\N
RIC06	CNTGNN72C01G273N	RP002	703	2023-10-12	\N
RIC07	BNCLUI90L01H501Y	RP004	107	2023-11-20	\N
RIC08	RSTPPL92H01H501T	RP005	501	2023-12-01	\N
RIC09	LNSFNC74L01H501D	RP005	901	2024-01-05	\N
RIC10	FRNCLL80B01F205N	RP006	601	2024-02-15	2024-02-25
RIC11	FRNCLL80B01F205N	RP006	601	2024-06-01	2024-06-01
RIC12	CRTFPP03S07L319C	RP002	703	2024-06-01	2024-06-01
RIC13	CRTFPP03S07L319C	RP002	703	2024-06-02	\N
\.


--
-- TOC entry 5133 (class 0 OID 21578)
-- Dependencies: 238
-- Data for Name: ricoveropatologia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ricoveropatologia (ricovero, patologia) FROM stdin;
RIC01	Depressione maggiore
RIC02	Parkinson
RIC03	Bipolarismo
RIC06	Osteoporosi
RIC07	Diabete tipo 1
RIC10	Diabete tipo 2
RIC12	Bipolarismo
RIC13	Bipolarismo
RIC13	Anoressia nervosa
\.


--
-- TOC entry 5123 (class 0 OID 21460)
-- Dependencies: 228
-- Data for Name: salaoperatoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salaoperatoria (reparto) FROM stdin;
RP001
RP005
RP006
\.


--
-- TOC entry 5122 (class 0 OID 21444)
-- Dependencies: 227
-- Data for Name: sostituzione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sostituzione (primario, viceprimario, datainizio, datafine) FROM stdin;
CLMNDR75B12H501S	BGNLUC76T22H501M	2020-03-10	2020-10-10
CLMNDR75B12H501S	BGNLUC76T22H501M	2021-06-02	2021-12-13
TSTMRN70A01H501R	VRDLPL75C15H501I	2017-09-03	2018-07-08
SPSLRA78H15H501C	BRNLSR70H18H501H	2021-06-01	2021-12-28
SPSLRA78H15H501C	FRNLCN80C23H501T	2022-02-08	2022-04-22
CSTMRM80A01H501H	CNTFNC78L14H501K	2024-05-03	\N
\.


--
-- TOC entry 5120 (class 0 OID 21424)
-- Dependencies: 225
-- Data for Name: specializzazione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specializzazione (specializzazione) FROM stdin;
Cardiologia
Dermatologia
Ginecologia
Neurologia
Pediatria
Psichiatria
Ortopedia
Oftalmologia
Oncologia
Urologia
Endocrinologia
Gastroenterologia
Reumatologia
Chirurgia Generale
Otorinolaringoiatria
Medicina Interna
Nefrologia
Ematologia
Allergologia
Medicina dello Sport
Chirurgia Plastica
Chirurgia Vascolare
Medicina di Urgenza
Malattie Infettive
Radiologia
\.


--
-- TOC entry 5121 (class 0 OID 21429)
-- Dependencies: 226
-- Data for Name: specializzazioneprimario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specializzazioneprimario (primario, specializzazione) FROM stdin;
CLMNDR75B12H501S	Cardiologia
CLMNDR75B12H501S	Medicina Interna
CLMNDR75B12H501S	Radiologia
BLRTNG84A12H501P	Dermatologia
BLRTNG84A12H501P	Chirurgia Plastica
TSTMRN70A01H501R	Ginecologia
SPSLRA78H15H501C	Neurologia
TSTMRN70A01H501R	Chirurgia Vascolare
CLMNDR75B12H501S	Pediatria
SPSLRA78H15H501C	Psichiatria
MRNGGI82E18H501L	Ortopedia
SPSLRA78H15H501C	Oftalmologia
MRNGGI82E18H501L	Oncologia
CLMNDR75B12H501S	Urologia
MRNGGI82E18H501L	Endocrinologia
MRNGGI82E18H501L	Gastroenterologia
SPSLRA78H15H501C	Chirurgia Generale
SPSLRA78H15H501C	Medicina Interna
CSTMRM80A01H501H	Medicina dello Sport
CSTMRM80A01H501H	Malattie Infettive
\.


--
-- TOC entry 5124 (class 0 OID 21470)
-- Dependencies: 229
-- Data for Name: stanza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stanza (reparto, numero, numeroletti) FROM stdin;
RP001	201	2
RP001	301	\N
RP003	301	\N
RP005	501	3
RP006	601	2
RP002	701	4
RP005	901	3
RP001	101	\N
RP001	203	\N
RP002	702	\N
RP002	703	4
RP003	801	2
RP003	901	3
RP003	902	3
RP004	601	\N
RP004	107	1
RP004	701	\N
RP005	801	\N
\.


--
-- TOC entry 5126 (class 0 OID 21491)
-- Dependencies: 231
-- Data for Name: turnops; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.turnops (prontosoccorso, personale, dataorainizio, dataorafine) FROM stdin;
OS001	PLNTLR72M11H501K	2024-05-20 08:00:00	2024-05-20 16:00:00
OS001	PLNTLR72M11H501K	2024-05-22 08:00:00	2024-05-22 19:00:00
OS001	PLNTLR72M11H501K	2024-05-25 16:00:00	2024-05-26 01:00:00
OS001	FRNMRZ88D09H501N	2024-05-20 08:00:00	2024-05-20 16:00:00
OS001	FRNMRZ88D09H501N	2024-05-21 08:00:00	2024-05-22 19:00:00
OS001	FRNMRZ88D09H501N	2024-05-25 15:00:00	2024-05-26 01:00:00
OS001	MRRCSL85H14H501R	2024-05-25 15:00:00	2024-05-26 01:00:00
OS001	MRRCSL85H14H501R	2024-05-26 16:00:00	2024-05-27 01:00:00
OS001	CLMNDR75B12H501S	2024-05-25 16:00:00	\N
\.


--
-- TOC entry 5139 (class 0 OID 21658)
-- Dependencies: 244
-- Data for Name: utenzapaziente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utenzapaziente (paziente, hashedpassword) FROM stdin;
RSSMRA85M01H501Z	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
VRDLGI92F02L219V	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
BNCLRA70A01F205Z	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
FRNCRL88C01H501B	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
SNTGPP95D12M208V	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
CRTFPP03S07L319C	$2y$10$PS9.85xHgvwHBmfGq1PQ9uGVicvWUPp3lrshlWhUvntU2JbZrQWYW
\.


--
-- TOC entry 5140 (class 0 OID 21668)
-- Dependencies: 245
-- Data for Name: utenzapersonale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utenzapersonale (personale, hashedpassword) FROM stdin;
RSSMRA75A15H501Z	$2y$10$/grW.BeNby.FmwHC6RA/VesJN6VgbLjCgiivVnyeIA4K2bcY547sW
VRDLGU80B20H501Y	$2y$10$/grW.BeNby.FmwHC6RA/VesJN6VgbLjCgiivVnyeIA4K2bcY547sW
BNCLNN85C25H501X	$2y$10$/grW.BeNby.FmwHC6RA/VesJN6VgbLjCgiivVnyeIA4K2bcY547sW
NRIMRA90D30H501A	$2y$10$/grW.BeNby.FmwHC6RA/VesJN6VgbLjCgiivVnyeIA4K2bcY547sW
RSSCRL82E10H501B	$2y$10$/grW.BeNby.FmwHC6RA/VesJN6VgbLjCgiivVnyeIA4K2bcY547sW
\.


--
-- TOC entry 5119 (class 0 OID 21409)
-- Dependencies: 224
-- Data for Name: viceprimario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.viceprimario (cf, dataassunzioneruolo, reparto) FROM stdin;
BGNLUC76T22H501M	2015-11-01	RP001
TNDMRZ83I10H501S	2014-04-02	RP002
VRDLPL75C15H501I	2019-06-10	RP003
BNCLRA85D07H501J	2018-08-11	RP003
CNTFNC78L14H501K	2019-09-03	RP004
BRNLSR70H18H501H	2020-11-13	RP005
FRNLCN80C23H501T	2015-10-06	RP005
SMNTLL95F26H501F	2020-12-19	RP006
\.


--
-- TOC entry 4889 (class 2606 OID 21544)
-- Name: collaborazioneospedalelaboratorio collaborazioneospedalelaboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborazioneospedalelaboratorio
    ADD CONSTRAINT collaborazioneospedalelaboratorio_pkey PRIMARY KEY (ospedale, laboratorio);


--
-- TOC entry 4899 (class 2606 OID 21597)
-- Name: esame esame_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY (codice);


--
-- TOC entry 4901 (class 2606 OID 21602)
-- Name: esamespecialistico esamespecialistico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esamespecialistico
    ADD CONSTRAINT esamespecialistico_pkey PRIMARY KEY (codice);


--
-- TOC entry 4857 (class 2606 OID 21376)
-- Name: infermiere infermiere_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infermiere
    ADD CONSTRAINT infermiere_pkey PRIMARY KEY (cf);


--
-- TOC entry 4881 (class 2606 OID 21511)
-- Name: laboratorio laboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorio
    ADD CONSTRAINT laboratorio_pkey PRIMARY KEY (codice);


--
-- TOC entry 4887 (class 2606 OID 21534)
-- Name: laboratorioesterno laboratorioesterno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorioesterno
    ADD CONSTRAINT laboratorioesterno_pkey PRIMARY KEY (codice);


--
-- TOC entry 4883 (class 2606 OID 21516)
-- Name: laboratoriointerno laboratoriointerno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratoriointerno
    ADD CONSTRAINT laboratoriointerno_pkey PRIMARY KEY (codice);


--
-- TOC entry 4885 (class 2606 OID 21518)
-- Name: laboratoriointerno laboratoriointerno_reparto_stanza_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratoriointerno
    ADD CONSTRAINT laboratoriointerno_reparto_stanza_key UNIQUE (reparto, stanza);


--
-- TOC entry 4907 (class 2606 OID 21641)
-- Name: orarioaperturalaboratorio orarioaperturalaboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orarioaperturalaboratorio
    ADD CONSTRAINT orarioaperturalaboratorio_pkey PRIMARY KEY (laboratorio, giornosettimana);


--
-- TOC entry 4909 (class 2606 OID 21652)
-- Name: orariovisitereparto orariovisitereparto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orariovisitereparto
    ADD CONSTRAINT orariovisitereparto_pkey PRIMARY KEY (reparto, giornosettimana);


--
-- TOC entry 4845 (class 2606 OID 21328)
-- Name: ospedale ospedale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ospedale
    ADD CONSTRAINT ospedale_pkey PRIMARY KEY (codice);


--
-- TOC entry 4895 (class 2606 OID 21577)
-- Name: patologia patologia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patologia
    ADD CONSTRAINT patologia_pkey PRIMARY KEY (patologia);


--
-- TOC entry 4841 (class 2606 OID 21322)
-- Name: paziente paziente_numerotessera_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paziente
    ADD CONSTRAINT paziente_numerotessera_key UNIQUE (numerotessera);


--
-- TOC entry 4843 (class 2606 OID 21320)
-- Name: paziente paziente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paziente
    ADD CONSTRAINT paziente_pkey PRIMARY KEY (cf);


--
-- TOC entry 4851 (class 2606 OID 21346)
-- Name: personale personale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personale
    ADD CONSTRAINT personale_pkey PRIMARY KEY (cf);


--
-- TOC entry 4853 (class 2606 OID 21356)
-- Name: personaleamministrativo personaleamministrativo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personaleamministrativo
    ADD CONSTRAINT personaleamministrativo_pkey PRIMARY KEY (cf);


--
-- TOC entry 4859 (class 2606 OID 21386)
-- Name: personalemedico personalemedico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personalemedico
    ADD CONSTRAINT personalemedico_pkey PRIMARY KEY (cf);


--
-- TOC entry 4855 (class 2606 OID 21366)
-- Name: personalesanitario personalesanitario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personalesanitario
    ADD CONSTRAINT personalesanitario_pkey PRIMARY KEY (cf);


--
-- TOC entry 4903 (class 2606 OID 21615)
-- Name: prenotazione prenotazione_paziente_dataesame_oraesame_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_paziente_dataesame_oraesame_key UNIQUE (paziente, dataesame, oraesame);


--
-- TOC entry 4905 (class 2606 OID 21613)
-- Name: prenotazione prenotazione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_pkey PRIMARY KEY (paziente, esame, dataesame);


--
-- TOC entry 4861 (class 2606 OID 21396)
-- Name: primario primario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.primario
    ADD CONSTRAINT primario_pkey PRIMARY KEY (cf);


--
-- TOC entry 4863 (class 2606 OID 21398)
-- Name: primario primario_reparto_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.primario
    ADD CONSTRAINT primario_reparto_key UNIQUE (reparto);


--
-- TOC entry 4877 (class 2606 OID 21485)
-- Name: prontosoccorso prontosoccorso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prontosoccorso
    ADD CONSTRAINT prontosoccorso_pkey PRIMARY KEY (ospedale);


--
-- TOC entry 4847 (class 2606 OID 21335)
-- Name: reparto reparto_ospedale_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparto
    ADD CONSTRAINT reparto_ospedale_nome_key UNIQUE (ospedale, nome);


--
-- TOC entry 4849 (class 2606 OID 21333)
-- Name: reparto reparto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparto
    ADD CONSTRAINT reparto_pkey PRIMARY KEY (codice);


--
-- TOC entry 4915 (class 2606 OID 21682)
-- Name: richiestaprenotazione richiestaprenotazione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.richiestaprenotazione
    ADD CONSTRAINT richiestaprenotazione_pkey PRIMARY KEY (paziente, esame);


--
-- TOC entry 4891 (class 2606 OID 21562)
-- Name: ricovero ricovero_paziente_reparto_stanza_datainizio_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricovero
    ADD CONSTRAINT ricovero_paziente_reparto_stanza_datainizio_key UNIQUE (paziente, reparto, stanza, datainizio);


--
-- TOC entry 4893 (class 2606 OID 21560)
-- Name: ricovero ricovero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricovero
    ADD CONSTRAINT ricovero_pkey PRIMARY KEY (codice);


--
-- TOC entry 4897 (class 2606 OID 21582)
-- Name: ricoveropatologia ricoveropatologia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricoveropatologia
    ADD CONSTRAINT ricoveropatologia_pkey PRIMARY KEY (ricovero, patologia);


--
-- TOC entry 4873 (class 2606 OID 21464)
-- Name: salaoperatoria salaoperatoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salaoperatoria
    ADD CONSTRAINT salaoperatoria_pkey PRIMARY KEY (reparto);


--
-- TOC entry 4871 (class 2606 OID 21449)
-- Name: sostituzione sostituzione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sostituzione
    ADD CONSTRAINT sostituzione_pkey PRIMARY KEY (primario, viceprimario, datainizio);


--
-- TOC entry 4867 (class 2606 OID 21428)
-- Name: specializzazione specializzazione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializzazione
    ADD CONSTRAINT specializzazione_pkey PRIMARY KEY (specializzazione);


--
-- TOC entry 4869 (class 2606 OID 21433)
-- Name: specializzazioneprimario specializzazioneprimario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializzazioneprimario
    ADD CONSTRAINT specializzazioneprimario_pkey PRIMARY KEY (primario, specializzazione);


--
-- TOC entry 4875 (class 2606 OID 21475)
-- Name: stanza stanza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stanza
    ADD CONSTRAINT stanza_pkey PRIMARY KEY (reparto, numero);


--
-- TOC entry 4879 (class 2606 OID 21496)
-- Name: turnops turnops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turnops
    ADD CONSTRAINT turnops_pkey PRIMARY KEY (prontosoccorso, personale, dataorainizio);


--
-- TOC entry 4911 (class 2606 OID 21662)
-- Name: utenzapaziente utenzapaziente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenzapaziente
    ADD CONSTRAINT utenzapaziente_pkey PRIMARY KEY (paziente);


--
-- TOC entry 4913 (class 2606 OID 21672)
-- Name: utenzapersonale utenzapersonale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenzapersonale
    ADD CONSTRAINT utenzapersonale_pkey PRIMARY KEY (personale);


--
-- TOC entry 4865 (class 2606 OID 21413)
-- Name: viceprimario viceprimario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viceprimario
    ADD CONSTRAINT viceprimario_pkey PRIMARY KEY (cf);


--
-- TOC entry 4961 (class 2620 OID 21694)
-- Name: laboratoriointerno check_lab_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_lab_trigger BEFORE INSERT OR UPDATE ON public.laboratoriointerno FOR EACH ROW EXECUTE FUNCTION public.check_lab();


--
-- TOC entry 4962 (class 2620 OID 21710)
-- Name: ricovero check_letti_stanza_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_letti_stanza_trigger BEFORE INSERT OR UPDATE ON public.ricovero FOR EACH ROW EXECUTE FUNCTION public.check_letti_stanza();


--
-- TOC entry 4963 (class 2620 OID 21708)
-- Name: ricovero check_letti_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_letti_trigger BEFORE INSERT OR UPDATE ON public.ricovero FOR EACH ROW EXECUTE FUNCTION public.check_letti();


--
-- TOC entry 4965 (class 2620 OID 21714)
-- Name: prenotazione check_medico_prescrittore_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_medico_prescrittore_trigger BEFORE INSERT OR UPDATE ON public.prenotazione FOR EACH ROW EXECUTE FUNCTION public.check_medico_prescrittore();


--
-- TOC entry 4956 (class 2620 OID 21702)
-- Name: primario check_primario_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_primario_trigger BEFORE INSERT OR UPDATE ON public.primario FOR EACH ROW EXECUTE FUNCTION public.check_primario();


--
-- TOC entry 4957 (class 2620 OID 21698)
-- Name: primario check_reparto_primario_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_reparto_primario_trigger BEFORE INSERT OR UPDATE ON public.primario FOR EACH ROW EXECUTE FUNCTION public.check_reparto_primario();


--
-- TOC entry 4959 (class 2620 OID 21704)
-- Name: sostituzione check_reparto_sostituzione_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_reparto_sostituzione_trigger BEFORE INSERT OR UPDATE ON public.sostituzione FOR EACH ROW EXECUTE FUNCTION public.check_reparto_sostituzione();


--
-- TOC entry 4955 (class 2620 OID 21696)
-- Name: personaleamministrativo check_reparto_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_reparto_trigger BEFORE INSERT OR UPDATE ON public.personaleamministrativo FOR EACH ROW EXECUTE FUNCTION public.check_reparto();


--
-- TOC entry 4958 (class 2620 OID 21700)
-- Name: viceprimario check_reparto_vice_primario_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_reparto_vice_primario_trigger BEFORE INSERT OR UPDATE ON public.viceprimario FOR EACH ROW EXECUTE FUNCTION public.check_reparto_vice_primario();


--
-- TOC entry 4964 (class 2620 OID 21712)
-- Name: ricovero check_ricovero_in_corso_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_ricovero_in_corso_trigger BEFORE INSERT OR UPDATE ON public.ricovero FOR EACH ROW EXECUTE FUNCTION public.check_ricovero_in_corso();


--
-- TOC entry 4960 (class 2620 OID 21706)
-- Name: turnops check_turno_in_corso_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_turno_in_corso_trigger BEFORE INSERT OR UPDATE ON public.turnops FOR EACH ROW EXECUTE FUNCTION public.check_turno_in_corso();


--
-- TOC entry 4966 (class 2620 OID 21716)
-- Name: prenotazione trigger_check_and_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_check_and_delete AFTER INSERT OR UPDATE ON public.prenotazione FOR EACH ROW EXECUTE FUNCTION public.check_and_delete_richiesta();


--
-- TOC entry 4938 (class 2606 OID 21550)
-- Name: collaborazioneospedalelaboratorio collaborazioneospedalelaboratorio_laboratorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborazioneospedalelaboratorio
    ADD CONSTRAINT collaborazioneospedalelaboratorio_laboratorio_fkey FOREIGN KEY (laboratorio) REFERENCES public.laboratorioesterno(codice) ON UPDATE CASCADE;


--
-- TOC entry 4939 (class 2606 OID 21545)
-- Name: collaborazioneospedalelaboratorio collaborazioneospedalelaboratorio_ospedale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborazioneospedalelaboratorio
    ADD CONSTRAINT collaborazioneospedalelaboratorio_ospedale_fkey FOREIGN KEY (ospedale) REFERENCES public.ospedale(codice) ON UPDATE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 21603)
-- Name: esamespecialistico esamespecialistico_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esamespecialistico
    ADD CONSTRAINT esamespecialistico_codice_fkey FOREIGN KEY (codice) REFERENCES public.esame(codice) ON UPDATE CASCADE;


--
-- TOC entry 4920 (class 2606 OID 21377)
-- Name: infermiere infermiere_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infermiere
    ADD CONSTRAINT infermiere_cf_fkey FOREIGN KEY (cf) REFERENCES public.personalesanitario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 21535)
-- Name: laboratorioesterno laboratorioesterno_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorioesterno
    ADD CONSTRAINT laboratorioesterno_codice_fkey FOREIGN KEY (codice) REFERENCES public.laboratorio(codice) ON UPDATE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 21519)
-- Name: laboratoriointerno laboratoriointerno_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratoriointerno
    ADD CONSTRAINT laboratoriointerno_codice_fkey FOREIGN KEY (codice) REFERENCES public.laboratorio(codice) ON UPDATE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 21524)
-- Name: laboratoriointerno laboratoriointerno_reparto_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratoriointerno
    ADD CONSTRAINT laboratoriointerno_reparto_stanza_fkey FOREIGN KEY (reparto, stanza) REFERENCES public.stanza(reparto, numero) ON UPDATE CASCADE;


--
-- TOC entry 4949 (class 2606 OID 21642)
-- Name: orarioaperturalaboratorio orarioaperturalaboratorio_laboratorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orarioaperturalaboratorio
    ADD CONSTRAINT orarioaperturalaboratorio_laboratorio_fkey FOREIGN KEY (laboratorio) REFERENCES public.laboratorioesterno(codice) ON UPDATE CASCADE;


--
-- TOC entry 4950 (class 2606 OID 21653)
-- Name: orariovisitereparto orariovisitereparto_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orariovisitereparto
    ADD CONSTRAINT orariovisitereparto_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


--
-- TOC entry 4917 (class 2606 OID 21347)
-- Name: personale personale_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personale
    ADD CONSTRAINT personale_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


--
-- TOC entry 4918 (class 2606 OID 21357)
-- Name: personaleamministrativo personaleamministrativo_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personaleamministrativo
    ADD CONSTRAINT personaleamministrativo_cf_fkey FOREIGN KEY (cf) REFERENCES public.personale(cf) ON UPDATE CASCADE;


--
-- TOC entry 4921 (class 2606 OID 21387)
-- Name: personalemedico personalemedico_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personalemedico
    ADD CONSTRAINT personalemedico_cf_fkey FOREIGN KEY (cf) REFERENCES public.personalesanitario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4919 (class 2606 OID 21367)
-- Name: personalesanitario personalesanitario_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personalesanitario
    ADD CONSTRAINT personalesanitario_cf_fkey FOREIGN KEY (cf) REFERENCES public.personale(cf) ON UPDATE CASCADE;


--
-- TOC entry 4945 (class 2606 OID 21621)
-- Name: prenotazione prenotazione_esame_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_esame_fkey FOREIGN KEY (esame) REFERENCES public.esame(codice) ON UPDATE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 21626)
-- Name: prenotazione prenotazione_laboratorio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_laboratorio_fkey FOREIGN KEY (laboratorio) REFERENCES public.laboratorio(codice) ON UPDATE CASCADE;


--
-- TOC entry 4947 (class 2606 OID 21616)
-- Name: prenotazione prenotazione_paziente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_paziente_fkey FOREIGN KEY (paziente) REFERENCES public.paziente(cf) ON UPDATE CASCADE;


--
-- TOC entry 4948 (class 2606 OID 21631)
-- Name: prenotazione prenotazione_prescrittore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prenotazione
    ADD CONSTRAINT prenotazione_prescrittore_fkey FOREIGN KEY (prescrittore) REFERENCES public.personalemedico(cf) ON UPDATE CASCADE;


--
-- TOC entry 4922 (class 2606 OID 21404)
-- Name: primario primario_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.primario
    ADD CONSTRAINT primario_cf_fkey FOREIGN KEY (cf) REFERENCES public.personalemedico(cf) ON UPDATE CASCADE;


--
-- TOC entry 4923 (class 2606 OID 21399)
-- Name: primario primario_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.primario
    ADD CONSTRAINT primario_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


--
-- TOC entry 4932 (class 2606 OID 21486)
-- Name: prontosoccorso prontosoccorso_ospedale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prontosoccorso
    ADD CONSTRAINT prontosoccorso_ospedale_fkey FOREIGN KEY (ospedale) REFERENCES public.ospedale(codice) ON UPDATE CASCADE;


--
-- TOC entry 4916 (class 2606 OID 21336)
-- Name: reparto reparto_ospedale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reparto
    ADD CONSTRAINT reparto_ospedale_fkey FOREIGN KEY (ospedale) REFERENCES public.ospedale(codice) ON UPDATE CASCADE;


--
-- TOC entry 4953 (class 2606 OID 21688)
-- Name: richiestaprenotazione richiestaprenotazione_esame_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.richiestaprenotazione
    ADD CONSTRAINT richiestaprenotazione_esame_fkey FOREIGN KEY (esame) REFERENCES public.esame(codice) ON UPDATE CASCADE;


--
-- TOC entry 4954 (class 2606 OID 21683)
-- Name: richiestaprenotazione richiestaprenotazione_paziente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.richiestaprenotazione
    ADD CONSTRAINT richiestaprenotazione_paziente_fkey FOREIGN KEY (paziente) REFERENCES public.paziente(cf) ON UPDATE CASCADE;


--
-- TOC entry 4940 (class 2606 OID 21563)
-- Name: ricovero ricovero_paziente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricovero
    ADD CONSTRAINT ricovero_paziente_fkey FOREIGN KEY (paziente) REFERENCES public.paziente(cf) ON UPDATE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 21568)
-- Name: ricovero ricovero_reparto_stanza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricovero
    ADD CONSTRAINT ricovero_reparto_stanza_fkey FOREIGN KEY (reparto, stanza) REFERENCES public.stanza(reparto, numero) ON UPDATE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 21588)
-- Name: ricoveropatologia ricoveropatologia_patologia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricoveropatologia
    ADD CONSTRAINT ricoveropatologia_patologia_fkey FOREIGN KEY (patologia) REFERENCES public.patologia(patologia) ON UPDATE CASCADE;


--
-- TOC entry 4943 (class 2606 OID 21583)
-- Name: ricoveropatologia ricoveropatologia_ricovero_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ricoveropatologia
    ADD CONSTRAINT ricoveropatologia_ricovero_fkey FOREIGN KEY (ricovero) REFERENCES public.ricovero(codice) ON UPDATE CASCADE;


--
-- TOC entry 4930 (class 2606 OID 21465)
-- Name: salaoperatoria salaoperatoria_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salaoperatoria
    ADD CONSTRAINT salaoperatoria_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


--
-- TOC entry 4928 (class 2606 OID 21450)
-- Name: sostituzione sostituzione_primario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sostituzione
    ADD CONSTRAINT sostituzione_primario_fkey FOREIGN KEY (primario) REFERENCES public.primario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4929 (class 2606 OID 21455)
-- Name: sostituzione sostituzione_viceprimario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sostituzione
    ADD CONSTRAINT sostituzione_viceprimario_fkey FOREIGN KEY (viceprimario) REFERENCES public.viceprimario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4926 (class 2606 OID 21434)
-- Name: specializzazioneprimario specializzazioneprimario_primario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializzazioneprimario
    ADD CONSTRAINT specializzazioneprimario_primario_fkey FOREIGN KEY (primario) REFERENCES public.primario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4927 (class 2606 OID 21439)
-- Name: specializzazioneprimario specializzazioneprimario_specializzazione_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializzazioneprimario
    ADD CONSTRAINT specializzazioneprimario_specializzazione_fkey FOREIGN KEY (specializzazione) REFERENCES public.specializzazione(specializzazione) ON UPDATE CASCADE;


--
-- TOC entry 4931 (class 2606 OID 21476)
-- Name: stanza stanza_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stanza
    ADD CONSTRAINT stanza_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


--
-- TOC entry 4933 (class 2606 OID 21502)
-- Name: turnops turnops_personale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turnops
    ADD CONSTRAINT turnops_personale_fkey FOREIGN KEY (personale) REFERENCES public.personalesanitario(cf) ON UPDATE CASCADE;


--
-- TOC entry 4934 (class 2606 OID 21497)
-- Name: turnops turnops_prontosoccorso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.turnops
    ADD CONSTRAINT turnops_prontosoccorso_fkey FOREIGN KEY (prontosoccorso) REFERENCES public.prontosoccorso(ospedale) ON UPDATE CASCADE;


--
-- TOC entry 4951 (class 2606 OID 21663)
-- Name: utenzapaziente utenzapaziente_paziente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenzapaziente
    ADD CONSTRAINT utenzapaziente_paziente_fkey FOREIGN KEY (paziente) REFERENCES public.paziente(cf) ON UPDATE CASCADE;


--
-- TOC entry 4952 (class 2606 OID 21673)
-- Name: utenzapersonale utenzapersonale_personale_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utenzapersonale
    ADD CONSTRAINT utenzapersonale_personale_fkey FOREIGN KEY (personale) REFERENCES public.personale(cf) ON UPDATE CASCADE;


--
-- TOC entry 4924 (class 2606 OID 21419)
-- Name: viceprimario viceprimario_cf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viceprimario
    ADD CONSTRAINT viceprimario_cf_fkey FOREIGN KEY (cf) REFERENCES public.personalemedico(cf) ON UPDATE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 21414)
-- Name: viceprimario viceprimario_reparto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viceprimario
    ADD CONSTRAINT viceprimario_reparto_fkey FOREIGN KEY (reparto) REFERENCES public.reparto(codice) ON UPDATE CASCADE;


-- Completed on 2024-06-14 20:44:34

--
-- PostgreSQL database dump complete
--

