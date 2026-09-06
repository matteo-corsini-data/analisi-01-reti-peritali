-- Ci si rifà alla tabella di lookup lookup_rami_validi: rimando al file 01_lookup_regioni.sql

DROP VIEW IF EXISTS final_tipi_polizza;

CREATE VIEW final_tipi_polizza AS
	SELECT id_tipo_polizza, nome_prodotto, ramo, massimale, franchigia
    FROM (
		SELECT *,
			CASE   										-- Controllo sull'esistenza dei dati
				WHEN ramo IS NULL OR
					massimale IS NULL OR
					franchigia IS NULL
						THEN 'dati mancanti'	
				ELSE ''
			END as value_error,	
						
			CASE   										-- Controllo sulla logica dei dati
				WHEN ramo NOT IN (SELECT ramo FROM lookup_rami_validi) 
					THEN 'ramo non coperto'		-- Controllo ramo
                    
				WHEN massimale <= franchigia 
					THEN 'massimale minore o uguale alla franchigia'		-- Controllo massimale e franchigia
                    
				WHEN franchigia < 0 
					THEN "franchigia sottosoglia"		-- Controllo franchigia
                    
				WHEN massimale < 10000 OR massimale > 7000000 
					THEN 'massimale sottosoglia'		-- Stimiamo il massimale tra 10000 e 7000000
				ELSE ''
			END logic_error
		FROM tipi_polizza) AS tp
	WHERE value_error = '' AND logic_error ='';
        