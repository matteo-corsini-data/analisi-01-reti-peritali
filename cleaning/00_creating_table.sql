-- Creazione delle tabelle caricando i dati dei file .csv

SET GLOBAL local_infile=1;

																					-- ============================================
																					-- ANAGRAFICA PERITI
																					-- ============================================
DROP TABLE IF EXISTS anagrafica_periti;

CREATE TABLE anagrafica_periti (
    id_perito		INT PRIMARY KEY NOT NULL,
    nome      VARCHAR(40) NOT NULL,
    cognome VARCHAR(40) NOT NULL,
    luogo_nascita   VARCHAR(40),
    data_nascita DATE,
    numero_iscrizione   VARCHAR(40),
    data_iscrizione   DATE,
    codice_fiscale   VARCHAR(16),
    sede_operativa_regione   VARCHAR(40),
    telefono   VARCHAR(40),
    email   VARCHAR(40),
    pec   VARCHAR(40),
    specializzazione   VARCHAR(40)
);

LOAD DATA LOCAL INFILE 'D:/data/anagrafica_periti.csv'
INTO TABLE anagrafica_periti
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

																					-- ============================================
																					-- ASSEGNAZIONI PERIZIE
																					-- ============================================
DROP TABLE IF EXISTS assegnazioni_perizie;

CREATE TABLE assegnazioni_perizie (
    id_assegnazione		INT PRIMARY KEY NOT NULL,
    id_sinistro      INT NOT NULL,
    id_perito INT NOT NULL,
    data_assegnazione DATE,
    data_sopralluogo   DATE,
    compenso_perito DECIMAL(10,2)
); 

LOAD DATA LOCAL INFILE 'D:/data/assegnazioni_perizie.csv'
INTO TABLE assegnazioni_perizie
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

																					-- ============================================
																					-- CLIENTI
																					-- ============================================
DROP TABLE IF EXISTS clienti;

CREATE TABLE clienti (
    id_cliente		INT PRIMARY KEY NOT NULL,
    nome      VARCHAR(40) NOT NULL,
    cognome VARCHAR(40) NOT NULL,
    codice_fiscale   VARCHAR(16),
    data_nascita   DATE,
    regione_residenza   VARCHAR(40),
    comune_residenza   VARCHAR(40),
    data_inizio_rapporto   DATE
);

LOAD DATA LOCAL INFILE 'D:/data/clienti.csv'
INTO TABLE clienti
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

																					-- ============================================
																					-- POLIZZE
																					-- ============================================
DROP TABLE IF EXISTS polizze;

CREATE TABLE polizze (
    id_polizza      INT PRIMARY KEY NOT NULL,
    id_cliente      INT NOT NULL,
    id_tipo_polizza INT NOT NULL,
    premio_annuo    DECIMAL(10,2),
    data_decorrenza DATE,
    data_scadenza   DATE
);

LOAD DATA LOCAL INFILE 'D:/data/polizze.csv'
INTO TABLE polizze
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

																					-- ============================================
																					-- SINISTRI
																					-- ============================================
DROP TABLE IF EXISTS sinistri;

CREATE TABLE sinistri (
    id_sinistro                    INT PRIMARY KEY NOT NULL,
    id_polizza                     INT NOT NULL,
    data_denuncia                  DATE,
    tipo_danno                     VARCHAR(40),
    tipo_modulo_cai                VARCHAR(20),
    regione_sinistro                VARCHAR(40),
    importo_stimato_perito         DECIMAL(10,2),
    importo_indennizzo_liquidato   DECIMAL(10,2),
    esito_sinistro                 VARCHAR(40),
    data_offerta                   DATE,
    data_accettazione_danneggiato  DATE,
    data_liquidazione              DATE
);

LOAD DATA LOCAL INFILE 'D:/data/sinistri.csv'
INTO TABLE sinistri
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

																					-- ============================================
																					-- TIPI POLIZZA
																					-- ============================================
DROP TABLE IF EXISTS tipi_polizza;

CREATE TABLE tipi_polizza (
    id_tipo_polizza		INT PRIMARY KEY NOT NULL,
    nome_prodotto      VARCHAR(40) NOT NULL,
    ramo VARCHAR(40) NOT NULL,
    massimale DECIMAL(10,2),
    franchigia   DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'D:/data/tipi_polizza.csv'
INTO TABLE tipi_polizza
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;