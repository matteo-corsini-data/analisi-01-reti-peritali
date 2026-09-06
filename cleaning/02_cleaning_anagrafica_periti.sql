-- Ci si rifà alla tabella di lookup lookup_rami_validi: rimando al file 01_lookup_tables.sql

DROP VIEW IF EXISTS final_anagrafica_periti;

CREATE VIEW final_anagrafica_periti AS 
	SELECT id_perito, 
		TRIM(nome) AS nome, 
        TRIM(cognome) AS cognome, 
        luogo_nascita, 
        data_nascita, 
        TRIM(numero_iscrizione) AS numero_iscrizione, 
        data_iscrizione,
		TRIM(codice_fiscale) AS codice_fiscale, 
        TRIM(sede_operativa_regione) AS sede_operativa_regione, 
        TRIM(telefono) AS telefono, 
        TRIM(email) AS email, 
        TRIM(pec) AS pec,  
        TRIM(specializzazione) AS specializzazione
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
                    
				WHEN YEAR(data_iscrizione) - SUBSTRING_INDEX(TRIM(numero_iscrizione),'/',-1) != 0 OR NOT
					REGEXP_LIKE(SUBSTRING_INDEX(TRIM(numero_iscrizione),'/',1) , '^[0-9]+$')
						THEN 'numero_iscrizione errato'		-- Controllo numero iscrizione
                        
				WHEN NOT ( TRIM(codice_fiscale) REGEXP '^[A-Z]{6}[0-9]{2}[ABCDEHLMPRST][0-9]{2}[A-Z][0-9]{3}[A-Z]$'	)
						THEN 'errore codice fiscale'		-- Controllo codice fiscale
                        
				WHEN TRIM(specializzazione) NOT IN (SELECT specializzazione FROM lookup_specializzazioni_perito) 
					THEN 'specializzazione non prevista'		-- Controllo specializzazione
                    
				WHEN (CHAR_LENGTH(TRIM(telefono)) NOT BETWEEN 9 AND 15) OR NOT
					REGEXP_LIKE(TRIM(telefono), '^[0-9\\+ ]+$') 
						THEN 'telefono non valido'		-- Controllo telefono
                        
				WHEN TRIM(sede_operativa_regione) NOT IN (SELECT regione FROM lookup_regioni) 
					THEN 'sede operativa in regione non esistente'		-- Controllo sede operativa
                    
				WHEN email NOT LIKE '%@%' 
					THEN 'email non valida'		-- Controllo email
                    
				WHEN pec NOT LIKE '%@pec%' 
					THEN 'pec non valida'		-- Controllo pec
                    
				ELSE ''
			END as logic_error
		FROM anagrafica_periti) AS ap
        
	WHERE value_error = '' AND logic_error = '';
