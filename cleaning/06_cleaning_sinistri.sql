-- Ci si rifà alla tabella di lookup lookup_rami_validi e lookup_regioni: rimando al file 01_lookup_tables.sql

DROP VIEW IF EXISTS cleaned_sinistri;

CREATE VIEW cleaned_sinistri AS																			-- Si accetta la possibilità di avere indennizzi senza perizia associata, e quindi senza importo_stimato_perito 
																										-- e che l'importo_stimato_perito possa essere minore dell'importo_indennizzo_liquidato
	SELECT id_sinistro, 
		id_polizza, 
        data_denuncia,
        TRIM(tipo_danno) AS tipo_danno,
        TRIM(tipo_modulo_cai) AS tipo_modulo_cai,
        TRIM(regione_sinistro) AS regione_sinistro,
        importo_stimato_perito,
		importo_indennizzo_liquidato, 
        TRIM(esito_sinistro) AS esito_sinistro, 
        data_offerta,
        data_accettazione_danneggiato,
        data_liquidazione
    FROM (
		SELECT  *,
			CASE										-- Controllo sull'esistenza e correttezza dei valori id_polizza, tipo_danno
				WHEN id_polizza IS NULL OR				-- regione_sinistro, esito_sinistro, tipo_modulo_cai
					regione_sinistro IS NULL OR
					tipo_danno IS NULL
						THEN 'dati mancanti'	
						
				WHEN TRIM(tipo_danno) NOT IN (SELECT ramo FROM lookup_rami_validi) 
					THEN 'ramo non coperto'		-- Controllo tipo_danno
				
				WHEN TRIM(regione_sinistro) NOT IN (SELECT regione FROM lookup_regioni) 
					THEN 'regione non esistente'		-- Controllo regione_sinistro
				
				WHEN esito_sinistro IS NULL 
					THEN 'esito_sinistro mancante'		-- Controllo esito_sinistro
				WHEN TRIM(esito_sinistro) NOT IN ( 'aperto', 'liquidato', 'respinto', 'in_contenzioso') 
					THEN 'esito_sinistro errato'	
					
				WHEN (tipo_modulo_cai != '' AND TRIM(tipo_danno) != 'RC autoveicoli terrestri') OR 
					(TRIM(tipo_modulo_cai) NOT IN ('congiunto', 'unilaterale') AND TRIM(tipo_danno) = 'RC autoveicoli terrestri')
					THEN 'tipo_modulo_cai errato'		-- Controllo tipo_modulo_cai 
				
                WHEN importo_stimato_perito < 0
					THEN 'importo_stimato_perito errato'		-- Controllo sull'importo stimato perito
	
				WHEN importo_indennizzo_liquidato < 0
					THEN 'importo_indennizzo_liquidato errato'		-- Controllo sull'importo indennizzo liquidato
                    
				ELSE ''
			END as value_error,

			CASE 										-- Controllo di validità delle date 

				WHEN data_denuncia IS NULL
					THEN 'data_denuncia mancante'
				WHEN data_offerta IS NULL AND 
					esito_sinistro IN  ('liquidato', 'in_contenzioso') 
						THEN 'data_offerta mancante'
				WHEN data_accettazione_danneggiato IS NULL AND 
					esito_sinistro IN  ('liquidato') 
						THEN 'data_accettazione_danneggiato mancante'
				WHEN data_liquidazione IS NULL AND 
					esito_sinistro IN  ('liquidato') 
						THEN 'data_liquidazione mancante'
				
														-- Controlli logici delle date 
				
				WHEN (TRIM(esito_sinistro) = 'in_contenzioso' AND 
						data_denuncia > data_offerta) OR
					(TRIM(esito_sinistro) = 'liquidato' AND 
						(data_denuncia > data_offerta OR 
						data_offerta > data_accettazione_danneggiato OR
						DATEDIFF(data_liquidazione, data_accettazione_danneggiato) NOT BETWEEN 0 AND 15)) 
					THEN 'errore gestione delle date'
				
				WHEN (TRIM(tipo_modulo_cai) = 'congiunto' AND DATEDIFF(data_offerta, data_denuncia) > 30) OR
					(TRIM(tipo_modulo_cai) = 'unilaterale' AND DATEDIFF(data_offerta, data_denuncia) > 60)
					THEN 'errore gestione modello cai'		-- Gestione logica del tipo_modello_cai
					
				ELSE ''
					
			END as data_error, 
            
			CASE			-- Controllo sugli importi
				
                WHEN importo_stimato_perito < 0 OR importo_indennizzo_liquidato < 0 
					THEN 'errore importi negativi' 
                    
				WHEN (TRIM(esito_sinistro) != 'liquidato' AND importo_indennizzo_liquidato != 0) 
					THEN 'errore indennizzo liquidato in funzione di esito_sinistro'
                    
				ELSE ''
			END as price_error 	
			
		FROM sinistri) AS s
	WHERE value_error = '' AND data_error = '' AND price_error = '';