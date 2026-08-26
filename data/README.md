## Descrizione dei file

**tipi_polizza.csv** — Il file contenente il catalogo dei prodotti assicurativi offerti.
- id_tipo_polizza
- nome_prodotto
- ramo — classificazione ufficiale del rischio, secondo l'art. 2 del Codice delle Assicurazioni Private (D.lgs. 209/2005)
- massimale — importo massimo che la compagnia si impegna a risarcire per un sinistro coperto da quel prodotto
- franchigia — quota di danno che resta sempre a carico dell'assicurato, sottratta dall'indennizzo prima del pagamento

**anagrafica_periti.csv** — Il file contenente i dati anagrafici e professionali dei periti della rete.
- id_perito
- nome
- cognome
- luogo_nascita
- data_nascita
- numero_iscrizione — riferimento al Ruolo Unico Nazionale dei Periti Assicurativi, gestito da CONSAP
- data_iscrizione — riferimento al Ruolo Unico Nazionale dei Periti Assicurativi, gestito da CONSAP
- codice_fiscale
- sede_operativa_regione — regione di riferimento operativo del perito; è la base con cui i sinistri vengono assegnati a periti della stessa zona
- telefono
- email
- pec
- specializzazione — ambito di perizia prevalente del perito

**clienti.csv** — Il file contenente i dati anagrafici dei clienti.
- id_cliente
- nome
- cognome
- codice_fiscale
- data_nascita
- regione_residenza
- comune_residenza
- data_inizio_rapporto — la data della stipulazione della prima polizza

**polizze.csv** — Il file contenente i contratti attivi, che collegano ogni cliente al prodotto sottoscritto.
- id_polizza
- id_cliente
- id_tipo_polizza — riferimento al prodotto sottoscritto (da cui derivano massimale e franchigia applicabili)
- premio_annuo — importo pagato annualmente dal cliente; calcolato a partire da un premio base di prodotto, corretto da un fattore di rischio legato alla regione del cliente
- data_decorrenza — periodo di validità del contratto (durata standard: 1 anno)
- data_scadenza — periodo di validità del contratto (durata standard: 1 anno)

**sinistri.csv** — Il file contenente gli eventi denunciati dai clienti, dalla denuncia alla chiusura.
- id_sinistro
- id_polizza
- data_denuncia
- tipo_danno — ramo assicurativo coinvolto nel sinistro; può non coincidere col ramo della polizza sottoscritta (sinistro non conforme alla copertura)
- tipo_modulo_cai — determina se va applicato il termine di offerta a 30 o 60 giorni; valorizzato solo per i sinistri di ramo RC autoveicoli terrestri (vuoto per tutti gli altri rami, per cui non è un campo applicabile)
- regione_sinistro — regione in cui è avvenuto il sinistro; può differire dalla regione di residenza del cliente (es. sinistro avvenuto in viaggio/trasferta)
- importo_stimato_perito — valutazione tecnica del danno formulata dal perito incaricato
- importo_indennizzo_liquidato — importo effettivamente pagato dalla compagnia: importo stimato meno franchigia, con tetto al massimale di polizza
- esito_sinistro — stato del sinistro (liquidato / respinto / aperto / in_contenzioso); determina quali altri campi della riga devono essere valorizzati o restare vuoti
- data_offerta — data in cui la compagnia formula l'offerta di risarcimento (termine normato dall'art. 149 del Codice delle Assicurazioni)
- data_accettazione_danneggiato — data in cui il danneggiato accetta l'offerta ricevuta
- data_liquidazione — data dell'effettivo pagamento dell'indennizzo (termine normato: entro 15 giorni dall'accettazione)

**assegnazioni_perizie.csv** — Il file contenente l'incarico affidato al perito per un determinato sinistro.
- id_assegnazione
- id_sinistro
- id_perito
- data_assegnazione — data in cui il sinistro viene affidato al perito
- data_sopralluogo — data dell'ispezione fisica del danno da parte del perito
- compenso_perito — importo corrisposto al perito per l'attività di perizia svolta
