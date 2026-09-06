-- In fase di pulizia ci si è accorti che la quasi totalità dei clienti aveva il valore data_inizio_rapporto completamente diverso da qualunque valore di data_decorrenza di ogni polizza a lui associata. 
-- I dati erano stati generati senza mantenere una coerenza tra i due valori
-- Pertanto si è corretto la questione con la query seguente, giacchè l'errore è di tipo strutturale e non rappresenta ciò che ci si aspetta di trovare in un normale lavoro di pulizia dati.

UPDATE clienti c
JOIN (
    SELECT id_cliente, MIN(data_decorrenza) AS prima_polizza
    FROM polizze
    GROUP BY id_cliente
) p ON c.id_cliente = p.id_cliente
SET c.data_inizio_rapporto = p.prima_polizza;

-- Ci si rifà alla tabella di lookup lookup_regioni: rimando al file 01_lookup_tables.sql

DROP VIEW IF EXISTS final_clienti;

CREATE VIEW final_clienti AS 
	SELECT 
		id_cliente, 
		TRIM(nome) AS nome, 
		TRIM(cognome) AS cognome, 
		TRIM(codice_fiscale) AS codice_fiscale, 
		data_nascita, 
		TRIM(regione_residenza) AS regione_residenza, 
		TRIM(comune_residenza) AS comune_residenza,
		data_inizio_rapporto
    FROM(
		SELECT *,
			CASE  										-- Controllo sull'esistenza dei dati
				WHEN codice_fiscale IS NULL OR
					data_nascita IS NULL OR
					regione_residenza IS NULL OR
					comune_residenza IS NULL OR
					data_inizio_rapporto IS NULL 
						THEN 'dati mancanti'
				ELSE ''
			END as value_error,
			
			CASE  										-- Controllo sulla logica dei dati
				WHEN NOT (	TRIM(codice_fiscale) REGEXP '^[A-Z]{6}[0-9]{2}[ABCDEHLMPRST][0-9]{2}[A-Z][0-9]{3}[A-Z]$'	)
					THEN 'errore codice fiscale'		-- Controllo codice fiscale
					
				WHEN TIMESTAMPDIFF(YEAR, data_nascita, data_inizio_rapporto) < 18 
					THEN 'età inferiore a 18 anni'		-- Controllo date
					
				WHEN TRIM(regione_residenza) NOT IN (SELECT regione FROM lookup_regioni)
					THEN 'regione residenza in regione non esistente' 		-- Controllo residenza
					
				ELSE ''
			END as logic_error
		FROM clienti) as cl
	WHERE value_error = '' AND logic_error = '';