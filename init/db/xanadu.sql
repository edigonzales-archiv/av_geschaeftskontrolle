-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- PostgreSQL version: 9.1
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

-- object: stefan | type: ROLE --
CREATE ROLE stefan WITH 
	LOGIN;
-- ddl-end --

-- object: mspublic | type: ROLE --
CREATE ROLE mspublic WITH ;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: xanadu | type: DATABASE --
-- CREATE DATABASE xanadu
-- ;
-- -- ddl-end --
-- 

-- object: av_geschaeftskontrolle | type: SCHEMA --
CREATE SCHEMA av_geschaeftskontrolle;
ALTER SCHEMA av_geschaeftskontrolle OWNER TO stefan;
-- ddl-end --

SET search_path TO pg_catalog,public,av_geschaeftskontrolle;
-- ddl-end --

-- object: av_geschaeftskontrolle.konto | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.konto(
	id serial,
	nr int4 NOT NULL,
	name varchar,
	bemerkung varchar,
	CONSTRAINT konto_nr_key UNIQUE (id,nr),
	CONSTRAINT konto_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.konto OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.jahr | type: TYPE --
CREATE TYPE av_geschaeftskontrolle.jahr AS
 ENUM ('2012','2013','2014','2015','2016','2017');
-- ddl-end --

-- object: av_geschaeftskontrolle.projekt | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.projekt(
	id serial,
	konto_id int4 NOT NULL,
	name varchar NOT NULL,
	kosten numeric(20,2) NOT NULL,
	datum_start date NOT NULL,
	datum_ende date,
	bemerkung varchar,
	CONSTRAINT projekt_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN av_geschaeftskontrolle.projekt.kosten IS 'exlusive Mehrwertsteuer';
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.projekt OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.unternehmer | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.unternehmer(
	id serial,
	firma varchar NOT NULL,
	uid int4,
	nachname varchar,
	vorname varchar,
	strasse varchar,
	hausnummer varchar,
	plz int4,
	ortschaft varchar,
	bemerkung varchar,
	CONSTRAINT unternehmer_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.unternehmer OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.auftrag | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.auftrag(
	id serial,
	projekt_id int4 NOT NULL,
	name varchar NOT NULL,
	kosten numeric(20,2),
	unternehmer_id int4 NOT NULL,
	datum_start date,
	datum_ende date,
	bemerkung varchar,
	CONSTRAINT auftrag_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.auftrag OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.rechnung | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.rechnung(
	id serial,
	auftrag_id int4 NOT NULL,
	kosten numeric(20,2),
	mwst double precision,
	datum_eingang date,
	datum_ausgang date,
	rechnungsjahr int4,
	bemerkung varchar,
	CONSTRAINT rechnung_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN av_geschaeftskontrolle.rechnung.kosten IS 'exklusive Mehrwertsteuer';
-- ddl-end --
COMMENT ON COLUMN av_geschaeftskontrolle.rechnung.datum_ausgang IS 'Beim Sekretariat im Kistli.';
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.rechnung OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.calculate_order_costs_from_percentage | type: FUNCTION --
CREATE OR REPLACE FUNCTION av_geschaeftskontrolle.calculate_order_costs_from_percentage ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$ BEGIN

UPDATE av_geschaeftskontrolle.planzahlung SET
   kosten = a.kosten * 100 / NEW.prozent
FROM (SELECT kosten FROM av_geschaeftskontrolle.auftrag) as a
WHERE auftrag_id = a.id;
 
 RETURN NEW;
 END;$$;
-- ddl-end --

-- object: av_geschaeftskontrolle.plankostenkonto | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.plankostenkonto(
	id serial,
	konto_id int4 NOT NULL,
	budget numeric(20,2) NOT NULL,
	jahr int4 NOT NULL,
	bemerkung varchar,
	CONSTRAINT plankostenkonto_pkey PRIMARY KEY (id),
	CONSTRAINT plankostenkonto_konto_id_jahr_key UNIQUE (konto_id,jahr)

);
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.plankostenkonto OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.planzahlung | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.planzahlung(
	id serial,
	auftrag_id int4 NOT NULL,
	prozent numeric(6,3),
	kosten numeric(20,2),
	mwst double precision,
	rechnungsjahr int4,
	bemerkung varchar,
	CONSTRAINT planzahlung_pkey PRIMARY KEY (id),
	CONSTRAINT planzahlung_positiv_prozent CHECK ((prozent > 0::numeric))

);
-- ddl-end --
-- object: update_kosten | type: TRIGGER --
CREATE TRIGGER update_kosten
	AFTER INSERT OR UPDATE
	ON av_geschaeftskontrolle.planzahlung
	FOR EACH STATEMENT
	EXECUTE PROCEDURE av_geschaeftskontrolle.calculate_order_costs_from_percentage();
-- ddl-end --


COMMENT ON TABLE av_geschaeftskontrolle.planzahlung IS 'Geplante Zahlung pro Jahr.';
-- ddl-end --
COMMENT ON COLUMN av_geschaeftskontrolle.planzahlung.kosten IS 'exlusive Mehrwertsteuer';
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.planzahlung OWNER TO stefan;
-- ddl-end --

-- object: av_geschaeftskontrolle.rechnungsjahr | type: TABLE --
CREATE TABLE av_geschaeftskontrolle.rechnungsjahr(
	id serial,
	jahr int4 NOT NULL
);
-- ddl-end --
ALTER TABLE av_geschaeftskontrolle.rechnungsjahr OWNER TO stefan;
-- ddl-end --

-- object: projekt_konto_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.projekt ADD CONSTRAINT projekt_konto_id_fkey FOREIGN KEY (konto_id)
REFERENCES av_geschaeftskontrolle.konto (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: auftrag_unternehmer_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.auftrag ADD CONSTRAINT auftrag_unternehmer_id_fkey FOREIGN KEY (unternehmer_id)
REFERENCES av_geschaeftskontrolle.unternehmer (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: auftrag_projekt_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.auftrag ADD CONSTRAINT auftrag_projekt_id_fkey FOREIGN KEY (projekt_id)
REFERENCES av_geschaeftskontrolle.projekt (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: rechnung_auftrag_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.rechnung ADD CONSTRAINT rechnung_auftrag_id_fkey FOREIGN KEY (auftrag_id)
REFERENCES av_geschaeftskontrolle.auftrag (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: planzahlung_projekt_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.planzahlung ADD CONSTRAINT planzahlung_projekt_id_fkey FOREIGN KEY (id)
REFERENCES av_geschaeftskontrolle.auftrag (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: plankostenkonto_konto_id_fkey | type: CONSTRAINT --
ALTER TABLE av_geschaeftskontrolle.plankostenkonto ADD CONSTRAINT plankostenkonto_konto_id_fkey FOREIGN KEY (konto_id)
REFERENCES av_geschaeftskontrolle.konto (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;
-- ddl-end --


-- object: grant_0ce46cd99e | type: PERMISSION --
GRANT SELECT
   ON TABLE av_geschaeftskontrolle.konto
   TO mspublic;
;
-- ddl-end --

-- object: grant_3fc45b5723 | type: PERMISSION --
GRANT SELECT
   ON TABLE av_geschaeftskontrolle.plankostenkonto
   TO mspublic;
;
-- ddl-end --

-- object: grant_208987f042 | type: PERMISSION --
GRANT SELECT
   ON TABLE av_geschaeftskontrolle.projekt
   TO mspublic;
;
-- ddl-end --

-- object: grant_0c785889fb | type: PERMISSION --
GRANT SELECT
   ON TABLE av_geschaeftskontrolle.planzahlung
   TO mspublic;
;
-- ddl-end --

-- object: grant_8b40be769c | type: PERMISSION --
GRANT USAGE
   ON SCHEMA av_geschaeftskontrolle
   TO stefan;
;
-- ddl-end --


