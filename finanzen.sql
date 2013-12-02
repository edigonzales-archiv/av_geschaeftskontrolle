Bemerkungen:
- Schlaue Namen wählen für Layer und Gruppen
- Dito für Attributnamen in Formular
- Unnötige Attribute verstecken
- Was passiert wenn z.B. Kontonummern ändern???? -> Neues Konto erfassen -> Auswertungen werden komplizierter... -> oder gar kein Problem? (nur in Theorie)


-- DROP TABLE public.rechungsjahr
CREATE TABLE public.rechnungsjahr (
    id SERIAL PRIMARY KEY,
    jahr INTEGER NOT NULL UNIQUE
);

INSERT INTO public.rechnungsjahr (jahr) VALUES (2012);
INSERT INTO public.rechnungsjahr (jahr) VALUES (2013);
INSERT INTO public.rechnungsjahr (jahr) VALUES (2014);
INSERT INTO public.rechnungsjahr (jahr) VALUES (2015);



-- DROP TABLE public.konto;
CREATE TABLE public.konto (
    id SERIAL PRIMARY KEY,
    nr INTEGER NOT NULL,
    "name" VARCHAR NOT NULL,
    bemerkung VARCHAR
);

INSERT INTO public.konto (nr, "name", bemerkung) VALUES (3130015, 'Unterhalt und Nachführung', '');
INSERT INTO public.konto (nr, "name", bemerkung) VALUES (5640000, 'Oeffentl. Unternehmungen', 'RADAV-Konto');

-- View für Kombination "nr" und "name"
-- DROP VIEW public.v_konto
CREATE OR REPLACE VIEW v_konto AS
 SELECT id, nr, "name", nr::text || ' - ' || "name"::text as nr_name, bemerkung
 FROM public.konto



--DROP TABLE public.plankostenkonto;
CREATE TABLE public.plankostenkonto (
    id SERIAL PRIMARY KEY,
    kontoid INTEGER NOT NULL REFERENCES konto(id),
    budget DOUBLE PRECISION NOT NULL,
    jahr INTEGER NOT NULL,
    bemerkung VARCHAR,
    UNIQUE (kontoid, jahr)
);


--INSERT INTO public.plankostenkonto (kontoid, budget, jahr) VALUES (2, 1500000, 2013);

Vorgehen:
- Konten in Tabelle "konto" erfassen.
- Plankosten (pro Rechnungsjahr und pro Konto) erfassen. Tabellen "plankostenkonto" mit "v_konto" joinen, sonst sieht man (Mensch) gar nicht mit welchem Konto es verknüpft ist.
- -> Mutation werden so möglich (vorallem wichtig anschliessend in anderen Tabellen, z.B. Rechungen)


-- DROP TABLE public.projekt;
CREATE TABLE public.projekt (
    id SERIAL PRIMARY KEY,
    kontoid INTEGER NOT NULL REFERENCES konto(id),
    "name" VARCHAR NOT NULL,
    kosten_exkl_mwst DOUBLE PRECISION,
    mwst DOUBLE PRECISION,
    datum_start DATE NOT NULL,
    datum_end DATE, -- Abschlussdatum: erst vergeben, falls Projekt *wirklich* abgeschlossen. (Was heisst das?)
    bemerkung VARCHAR    
);

-- DROP TABLE public.vertrag;
CREATE TABLE public.vertrag (
    id SERIAL PRIMARY KEY,
    projektid INTEGER NOT NULL REFERENCES projekt(id),
    "name" VARCHAR NOT NULL,
    kosten_exkl_mwst DOUBLE PRECISION,
    mwst DOUBLE PRECISION,
    unternehmerid INTEGER REFERENCES unternehmer(id),
    datum_start DATE NOT NULL,
    datum_ende DATE,
    bemerkung VARCHAR    
);

-- DROP VIEW public.v_projekt_vertrag
CREATE OR REPLACE VIEW v_projekt_vertrag AS
 SELECT v.id as v_id, p."name" as projekt_name, v."name" as vertrag_name, p."name" || ' - ' || v."name" as projekt_vertrag
 FROM public.vertrag as v, public.projekt as p
 WHERE v.projektid = p.id


-- DROP TABLE public.unternehmer;
CREATE TABLE public.unternehmer (
    id SERIAL PRIMARY KEY,
    firma VARCHAR NOT NULL,
    uid INTEGER,
    person VARCHAR,
    strasse VARCHAR NOT NULL,
    hausnummer VARCHAR NOT NULL,
    plz INTEGER NOT NULL,
    ortschaft VARCHAR NOT NULL,
    bemerkung VARCHAR    
);

-- DROP TABLE public.v_unternehmer;
CREATE OR REPLACE VIEW public.v_unternehmer AS
 SELECT id, firma, uid, person, firma::text || ' - ' || person::text as firma_person, strasse, hausnummer, plz, ortschaft, bemerkung
 FROM public.unternehmer

INSERT INTO public.unternehmer (firma, person, strasse, hausnummer, plz, ortschaft) VALUES ('BSB + Partner AG', 'Urs Schor', 'Von Roll-Strasse', '29', 4702, 'Oensingen');
INSERT INTO public.unternehmer (firma, person, strasse, hausnummer, plz, ortschaft) VALUES ('W+H AG', 'Reto Meile', 'Blümlisalpstrasse', '6', 4562, 'Biberist');
INSERT INTO public.unternehmer (firma, person, strasse, hausnummer, plz, ortschaft) VALUES ('Emch + Berger AG Vermessungen', 'Dominik Cantaluppi', 'Schöngrünstrasse', '35', 4500, 'Solothurn');


-- DROP TABLE public.rechnung;
CREATE TABLE public.rechnung (
    id SERIAL PRIMARY KEY,
    vertragid INTEGER NOT NULL REFERENCES public.vertrag(id),
    kosten_exkl_mwst DOUBLE PRECISION,
    mwst DOUBLE PRECISION NOT NULL,
    datum_eingang DATE NOT NULL,
    datum_ausgang DATE, -- Beim Sekretatriat im Kistli
    rechnungsjahr INTEGER REFERENCES public.rechnungsjahr(jahr),
    bemerkung VARCHAR
);


-- DROP TABLE public.plankostenrechnung
CREATE TABLE public.plankostenrechnung (
    id SERIAL PRIMARY KEY,
    projektid INTEGER NOT NULL REFERENCES projekt(id),
    kosten_exkl_mwst DOUBLE PRECISION,
    mwst DOUBLE PRECISION NOT NULL,
    rechnungsjahr INTEGER REFERENCES public.rechnungsjahr(jahr),
    bemerkung VARCHAR
);
