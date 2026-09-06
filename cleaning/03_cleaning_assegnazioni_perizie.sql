

DROP VIEW IF EXISTS cleaned_assegnazioni_perizie;

CREATE VIEW cleaned_assegnazioni_perizie AS 
	SELECT id_assegnazione,
		id_sinistro, 
		id_perito, 
		data_assegnazione, 
		data_sopralluogo, 
		compenso_perito
    FROM (
		SELECT *, 
			CASE  										-- Controllo sull'esistenza dei dati
				WHEN data_assegnazione IS NULL OR
					data_sopralluogo IS NULL OR
					compenso_perito IS NULL
						THEN 'dati mancanti'
				ELSE ''
			END as value_error,
			
			CASE  										-- Controllo sulla logica dei dati
				WHEN DATEDIFF(data_sopralluogo, data_assegnazione) < 0 
					THEN 'errore logico nel rapporto data assegnazione e sopralluogo'		-- Controllo date
					
				WHEN compenso_perito <= 0 
					THEN 'compenso perito errato'		-- Controllo compenso perito
					
				ELSE ''
			END as logic_error
			
		FROM assegnazioni_perizie) as ap
	WHERE value_error = '' AND logic_error = '';