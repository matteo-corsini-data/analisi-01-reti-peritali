-- Materializzazione delle view in tabelle pulite

											-- final_anagrafica_periti


DROP TABLE IF EXISTS final_anagrafica_periti;

CREATE TABLE final_anagrafica_periti AS
SELECT * FROM view_final_anagrafica_periti;

ALTER TABLE final_anagrafica_periti 
	ADD PRIMARY KEY (id_perito);

											-- final_clienti

DROP TABLE IF EXISTS final_clienti;

CREATE TABLE final_clienti AS
SELECT * FROM view_final_clienti;

ALTER TABLE final_clienti 
	ADD PRIMARY KEY (id_cliente);

											-- final_tipi_polizza

DROP TABLE IF EXISTS final_tipi_polizza;

CREATE TABLE final_tipi_polizza AS
SELECT * FROM view_final_tipi_polizza;

ALTER TABLE final_tipi_polizza 
	ADD PRIMARY KEY (id_tipo_polizza);

											-- final_polizze

DROP TABLE IF EXISTS final_polizze;

CREATE TABLE final_polizze AS
SELECT * FROM view_final_polizze;

ALTER TABLE final_polizze 
    ADD PRIMARY KEY (id_polizza);

											-- final_sinistri

DROP TABLE IF EXISTS final_sinistri;

CREATE TABLE final_sinistri AS
SELECT * FROM view_final_sinistri;

ALTER TABLE final_sinistri 
    ADD PRIMARY KEY (id_sinistro);

											-- final_assegnazioni_perizie

DROP TABLE IF EXISTS final_assegnazioni_perizie;

CREATE TABLE final_assegnazioni_perizie AS
SELECT * FROM view_final_assegnazioni_perizie;

ALTER TABLE final_assegnazioni_perizie 
    ADD PRIMARY KEY (id_assegnazione);