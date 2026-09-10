-- Si accetta la possibilità che esistano Clienti, Tipi Polizza e Periti senza Polizze Sinistri o Assegnazioni Perizie associate


																	-- FINAL POLIZZE

DROP VIEW IF EXISTS view_final_polizze;

CREATE VIEW view_final_polizze AS(			-- Polizze senza clienti o tipi polizza coerenti vanno rimosse
	SELECT id_polizza, p.id_cliente, p.id_tipo_polizza, premio_annuo, data_decorrenza, data_scadenza
	FROM cleaned_polizze as p
	INNER JOIN view_final_clienti as c
		ON	p.id_cliente = c.id_cliente
	INNER JOIN view_final_tipi_polizza AS tp
		ON p.id_tipo_polizza = tp.id_tipo_polizza
);

																	-- FINAL SINISTRI

DROP VIEW IF EXISTS view_final_sinistri;

CREATE VIEW view_final_sinistri AS(			-- Sinistri con polizze inesistenti vanno rimosse
	SELECT id_sinistro, id_polizza, data_denuncia, tipo_danno, tipo_modulo_cai, regione_sinistro, importo_stimato_perito,
		importo_indennizzo_liquidato, esito_sinistro, data_offerta, data_accettazione_danneggiato, data_liquidazione
	FROM (
		SELECT 
			id_sinistro, s.id_polizza, data_denuncia, tipo_danno, tipo_modulo_cai, regione_sinistro, importo_stimato_perito,
			importo_indennizzo_liquidato, esito_sinistro, data_offerta, data_accettazione_danneggiato, data_liquidazione,
			CASE 
            
				WHEN importo_indennizzo_liquidato > massimale 
					THEN 'indennizzo maggiore del massimale prestabilito'
	
				-- Come già notato si considera la possibilità di avere liquidazioni superiore al valore dettato dal perito e di liquidazioni senza perizia,
				-- quindi il valore importo_stimato_perito non risulta vincolante per importo_indennizzo_liquidato
				
                ELSE ''
            END as price_error
        FROM cleaned_sinistri AS s
		INNER JOIN view_final_polizze as p
			ON s.id_polizza = p.id_polizza
		INNER JOIN view_final_tipi_polizza as tp
			ON p.id_tipo_polizza = tp.id_tipo_polizza	) AS tab
	WHERE price_error = ''
);

																	-- FINAL ASSEGNAZIONI PERIZIE

DROP VIEW IF EXISTS view_final_assegnazioni_perizie;

CREATE VIEW view_final_assegnazioni_perizie AS(			-- Assegnazione Perizie senza sinistro va rimossa. Senza perito? 
			-- Un perito non presente in DB può essere un perito che ha lasciato l'azienda o che fa parte di un'azienda di consulenza esterna pertanto si accetta la possibilità che ci siano 
            -- Assegnazioni Perizie senza perito. Ciò permette quindi anche al sinistro collegato all'assegnazione di non avere un perito indirettamente associato
            
	SELECT  id_assegnazione, ap.id_sinistro, ap.id_perito, data_assegnazione, data_sopralluogo, compenso_perito
    FROM cleaned_assegnazioni_perizie AS ap
    INNER JOIN view_final_sinistri AS s
		ON ap.id_sinistro = s.id_sinistro
);

