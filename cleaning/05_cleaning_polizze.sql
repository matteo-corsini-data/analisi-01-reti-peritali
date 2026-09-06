

DROP VIEW IF EXISTS cleaned_polizze;

CREATE VIEW cleaned_polizze AS 
	SELECT id_polizza, id_cliente, id_tipo_polizza, premio_annuo, data_decorrenza, data_scadenza
    FROM(
		SELECT *,
			CASE  										-- Controllo sull'esistenza dei dati
				WHEN premio_annuo IS NULL OR
					data_decorrenza IS NULL OR
					data_scadenza IS NULL
					THEN 'dati mancanti'
				ELSE ''
			END as value_error,
			
			CASE  										-- Controllo sulla logica dei dati
				WHEN premio_annuo <= 0
					THEN 'premio annuo errato'		-- Controllo premio annuo
					
				WHEN DATEDIFF(data_scadenza, data_decorrenza) != 365 
					THEN 'data scadenza errata'		-- Controllo date
					
				ELSE ''
			END as logic_error
			
		FROM polizze) as p
	WHERE value_error = '' AND logic_error = '';
