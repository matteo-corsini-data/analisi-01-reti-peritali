-- Ci si rifà alla tabella di lookup lookup_rami_validi: rimando al file lookup_tables.sql

DROP VIEW IF EXISTS final_anagrafica_periti;

CREATE VIEW final_anagrafica_periti AS 
	SELECT id_perito, nome, cognome, luogo_nascita, data_nascita, numero_iscrizione, data_iscrizione,
		codice_fiscale, sede_operativa_regione, telefono, email, pec, specializzazione
    FROM (
		SELECT *,							
			CASE  										-- Controllo sull'esistenza dei dati
				WHEN  luogo_nascita IS NULL OR
					data_nascita IS NULL OR
					numero_iscrizione is NULL OR
					data_iscrizione IS NULL OR
					codice_fiscale IS NULL OR
					sede_operativa_regione IS NULL OR
					telefono IS NULL OR
					email IS NULL OR
					pec IS NULL OR
					specializzazione IS NULL
						THEN 'dati mancanti'
				 ELSE ''
			END as value_error,
			
			CASE  										-- Controllo sulla logica dei dati
				WHEN TIMESTAMPDIFF(YEAR, data_nascita, CURDATE()) <18  
					THEN 'età inferiore a 18 anni'
                    
				WHEN TIMESTAMPDIFF(YEAR, data_nascita, data_iscrizione) <= 0 
					THEN 'errore logico nel rapporto data nascita e iscrizione'		-- Controllo sulla città luogo_nascita
                    
				WHEN YEAR(data_iscrizione) - SUBSTRING_INDEX(numero_iscrizione,'/',-1) != 0 OR NOT
					REGEXP_LIKE(SUBSTRING_INDEX(numero_iscrizione,'/',1) , '^[0-9]+$')
						THEN 'numero_iscrizione errato'		-- Controllo numero iscrizione
                        
				WHEN NOT (	codice_fiscale REGEXP '^[A-Z]{6}[0-9]{2}[ABCDEHLMPRST][0-9]{2}[A-Z][0-9]{3}[A-Z]$'	)
						THEN 'errore codice fiscale'		-- Controllo codice fiscale
                        
				WHEN specializzazione NOT IN (SELECT specializzazione FROM lookup_specializzazioni_perito) 
					THEN 'specializzazione non prevista'		-- Controllo specializzazione
                    
				WHEN (CHAR_LENGTH(telefono) NOT BETWEEN 9 AND 15) OR NOT
					REGEXP_LIKE(telefono, '^[0-9\\+ ]+$') 
						THEN 'telefono non valido'		-- Controllo telefono
                        
				WHEN sede_operativa_regione NOT IN (SELECT regione FROM lookup_regioni) 
					THEN 'sede operativa in regione non esistente'		-- Controllo sede operativa
                    
				WHEN email NOT LIKE '%@%' 
					THEN 'email non valida'		-- Controllo email
                    
				WHEN pec NOT LIKE '%@pec%' 
					THEN 'pec non valida'		-- Controllo pec
                    
				ELSE ''
			END as logic_error
		FROM anagrafica_periti) AS ap
        
	WHERE value_error = '' AND logic_error = '';

