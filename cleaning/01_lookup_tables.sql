																			-- Rami delle polizze validi
DROP TABLE IF EXISTS lookup_rami_validi;
CREATE TABLE lookup_rami_validi (
    ramo VARCHAR(40) PRIMARY KEY
);

INSERT INTO lookup_rami_validi (ramo) VALUES
    ('Corpi di veicoli terrestri'),
    ('Incendio ed elementi naturali'),
    ('Altri danni ai beni'),
    ('RC autoveicoli terrestri'),
    ('RC generale');

																			-- Regioni italiane
DROP TABLE IF EXISTS lookup_regioni;
CREATE TABLE lookup_regioni (
    regione VARCHAR(30) PRIMARY KEY
);

INSERT INTO lookup_regioni (regione) VALUES
    ('Piemonte'),
    ('Valle d''Aosta'),
    ('Lombardia'),
    ('Trentino-Alto Adige'),
    ('Veneto'),
    ('Friuli-Venezia Giulia'),
    ('Liguria'),
    ('Emilia-Romagna'),
    ('Toscana'),
    ('Umbria'),
    ('Marche'),
    ('Lazio'),
    ('Abruzzo'),
    ('Molise'),
    ('Campania'),
    ('Puglia'),
    ('Basilicata'),
    ('Calabria'),
    ('Sicilia'),
    ('Sardegna');
    
																			-- Specializzazione perito
                                                                            
DROP TABLE IF EXISTS lookup_specializzazioni_perito;
CREATE TABLE lookup_specializzazioni_perito (
    specializzazione VARCHAR(30) PRIMARY KEY
);

INSERT INTO lookup_specializzazioni_perito (specializzazione) VALUES
    ('Multirischio'),
    ('Auto'),
    ('Furto'),
    ('Incendio'),
    ('RE / Immobili');



    