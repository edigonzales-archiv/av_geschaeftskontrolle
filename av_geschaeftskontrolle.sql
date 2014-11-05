--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2014-11-05 11:43:46 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 8 (class 2615 OID 19335)
-- Name: av_geschaeftskontrolle; Type: SCHEMA; Schema: -; Owner: stefan
--

CREATE SCHEMA av_geschaeftskontrolle;


ALTER SCHEMA av_geschaeftskontrolle OWNER TO stefan;

SET search_path = av_geschaeftskontrolle, pg_catalog;

--
-- TOC entry 1150 (class 1247 OID 19337)
-- Name: jahr; Type: TYPE; Schema: av_geschaeftskontrolle; Owner: postgres
--

CREATE TYPE jahr AS ENUM (
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017'
);


ALTER TYPE av_geschaeftskontrolle.jahr OWNER TO postgres;

--
-- TOC entry 783 (class 1255 OID 19349)
-- Name: calculate_budget_payment_from_total_cost(); Type: FUNCTION; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE FUNCTION calculate_budget_payment_from_total_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
 BEGIN

UPDATE av_geschaeftskontrolle.planzahlung SET kosten = auf.kosten * (prozent/100) 
FROM av_geschaeftskontrolle.auftrag as auf
WHERE auf.id = auftrag_id;
 
 RETURN NULL;
 END;$$;


ALTER FUNCTION av_geschaeftskontrolle.calculate_budget_payment_from_total_cost() OWNER TO stefan;

--
-- TOC entry 784 (class 1255 OID 19350)
-- Name: calculate_order_costs_from_percentage(); Type: FUNCTION; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE FUNCTION calculate_order_costs_from_percentage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ DECLARE gesamtkosten DOUBLE PRECISION;
 BEGIN

SELECT kosten FROM av_geschaeftskontrolle.auftrag WHERE id = NEW.auftrag_id INTO gesamtkosten;
NEW.kosten = gesamtkosten*(NEW.prozent/100);
 
 RETURN NEW;
 END;$$;


ALTER FUNCTION av_geschaeftskontrolle.calculate_order_costs_from_percentage() OWNER TO stefan;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 179 (class 1259 OID 19351)
-- Name: amo; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE amo (
    id integer NOT NULL,
    auftrag_id integer NOT NULL,
    amo_nr character varying
);


ALTER TABLE av_geschaeftskontrolle.amo OWNER TO stefan;

--
-- TOC entry 180 (class 1259 OID 19357)
-- Name: amo_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE amo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.amo_id_seq OWNER TO stefan;

--
-- TOC entry 2822 (class 0 OID 0)
-- Dependencies: 180
-- Name: amo_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE amo_id_seq OWNED BY amo.id;


--
-- TOC entry 181 (class 1259 OID 19359)
-- Name: auftrag; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE auftrag (
    id integer NOT NULL,
    projekt_id integer NOT NULL,
    name character varying NOT NULL,
    kosten numeric(20,2),
    mwst double precision,
    verguetungsart_id integer,
    unternehmer_id integer NOT NULL,
    datum_start date,
    datum_ende date,
    datum_abschluss date,
    geplant boolean,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.auftrag OWNER TO stefan;

--
-- TOC entry 182 (class 1259 OID 19365)
-- Name: auftrag_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE auftrag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.auftrag_id_seq OWNER TO stefan;

--
-- TOC entry 2823 (class 0 OID 0)
-- Dependencies: 182
-- Name: auftrag_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE auftrag_id_seq OWNED BY auftrag.id;


--
-- TOC entry 183 (class 1259 OID 19367)
-- Name: konto; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE konto (
    id integer NOT NULL,
    nr integer NOT NULL,
    name character varying,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.konto OWNER TO stefan;

--
-- TOC entry 184 (class 1259 OID 19373)
-- Name: konto_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE konto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.konto_id_seq OWNER TO stefan;

--
-- TOC entry 2825 (class 0 OID 0)
-- Dependencies: 184
-- Name: konto_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE konto_id_seq OWNED BY konto.id;


--
-- TOC entry 185 (class 1259 OID 19375)
-- Name: perimeter; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE perimeter (
    id integer NOT NULL,
    projekt_id integer NOT NULL,
    perimeter public.geometry(MultiPolygon,21781)
);


ALTER TABLE av_geschaeftskontrolle.perimeter OWNER TO stefan;

--
-- TOC entry 186 (class 1259 OID 19381)
-- Name: perimeter_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE perimeter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.perimeter_id_seq OWNER TO stefan;

--
-- TOC entry 2826 (class 0 OID 0)
-- Dependencies: 186
-- Name: perimeter_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE perimeter_id_seq OWNED BY perimeter.id;


--
-- TOC entry 187 (class 1259 OID 19383)
-- Name: plankostenkonto; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE plankostenkonto (
    id integer NOT NULL,
    konto_id integer NOT NULL,
    budget numeric(20,2) NOT NULL,
    jahr integer NOT NULL,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.plankostenkonto OWNER TO stefan;

--
-- TOC entry 188 (class 1259 OID 19389)
-- Name: plankostenkonto_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE plankostenkonto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.plankostenkonto_id_seq OWNER TO stefan;

--
-- TOC entry 2828 (class 0 OID 0)
-- Dependencies: 188
-- Name: plankostenkonto_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE plankostenkonto_id_seq OWNED BY plankostenkonto.id;


--
-- TOC entry 189 (class 1259 OID 19391)
-- Name: planzahlung; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE planzahlung (
    id integer NOT NULL,
    auftrag_id integer NOT NULL,
    prozent numeric(6,3),
    kosten numeric(20,2),
    mwst double precision,
    rechnungsjahr integer,
    bemerkung character varying,
    CONSTRAINT planzahlung_positiv_prozent CHECK ((prozent > (0)::numeric))
);


ALTER TABLE av_geschaeftskontrolle.planzahlung OWNER TO stefan;

--
-- TOC entry 2829 (class 0 OID 0)
-- Dependencies: 189
-- Name: TABLE planzahlung; Type: COMMENT; Schema: av_geschaeftskontrolle; Owner: stefan
--

COMMENT ON TABLE planzahlung IS 'Geplante Zahlung pro Jahr.';


--
-- TOC entry 2830 (class 0 OID 0)
-- Dependencies: 189
-- Name: COLUMN planzahlung.kosten; Type: COMMENT; Schema: av_geschaeftskontrolle; Owner: stefan
--

COMMENT ON COLUMN planzahlung.kosten IS 'exlusive Mehrwertsteuer';


--
-- TOC entry 190 (class 1259 OID 19398)
-- Name: planzahlung_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE planzahlung_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.planzahlung_id_seq OWNER TO stefan;

--
-- TOC entry 2832 (class 0 OID 0)
-- Dependencies: 190
-- Name: planzahlung_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE planzahlung_id_seq OWNED BY planzahlung.id;


--
-- TOC entry 191 (class 1259 OID 19400)
-- Name: projekt; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE projekt (
    id integer NOT NULL,
    konto_id integer NOT NULL,
    name character varying NOT NULL,
    kosten numeric(20,2),
    mwst double precision,
    datum_start date NOT NULL,
    datum_ende date,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.projekt OWNER TO stefan;

--
-- TOC entry 2833 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN projekt.kosten; Type: COMMENT; Schema: av_geschaeftskontrolle; Owner: stefan
--

COMMENT ON COLUMN projekt.kosten IS 'exlusive Mehrwertsteuer';


--
-- TOC entry 192 (class 1259 OID 19406)
-- Name: projekt_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE projekt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.projekt_id_seq OWNER TO stefan;

--
-- TOC entry 2835 (class 0 OID 0)
-- Dependencies: 192
-- Name: projekt_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE projekt_id_seq OWNED BY projekt.id;


--
-- TOC entry 193 (class 1259 OID 19408)
-- Name: rechnung; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE rechnung (
    id integer NOT NULL,
    auftrag_id integer NOT NULL,
    kosten numeric(20,2),
    mwst double precision,
    datum_eingang date,
    datum_ausgang date,
    rechnungsjahr integer,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.rechnung OWNER TO stefan;

--
-- TOC entry 2836 (class 0 OID 0)
-- Dependencies: 193
-- Name: COLUMN rechnung.kosten; Type: COMMENT; Schema: av_geschaeftskontrolle; Owner: stefan
--

COMMENT ON COLUMN rechnung.kosten IS 'exklusive Mehrwertsteuer';


--
-- TOC entry 2837 (class 0 OID 0)
-- Dependencies: 193
-- Name: COLUMN rechnung.datum_ausgang; Type: COMMENT; Schema: av_geschaeftskontrolle; Owner: stefan
--

COMMENT ON COLUMN rechnung.datum_ausgang IS 'Beim Sekretariat im Kistli.';


--
-- TOC entry 194 (class 1259 OID 19414)
-- Name: rechnung_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE rechnung_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.rechnung_id_seq OWNER TO stefan;

--
-- TOC entry 2838 (class 0 OID 0)
-- Dependencies: 194
-- Name: rechnung_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE rechnung_id_seq OWNED BY rechnung.id;


--
-- TOC entry 195 (class 1259 OID 19416)
-- Name: rechnungsjahr; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE rechnungsjahr (
    id integer NOT NULL,
    jahr integer NOT NULL
);


ALTER TABLE av_geschaeftskontrolle.rechnungsjahr OWNER TO stefan;

--
-- TOC entry 196 (class 1259 OID 19419)
-- Name: rechnungsjahr_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE rechnungsjahr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.rechnungsjahr_id_seq OWNER TO stefan;

--
-- TOC entry 2839 (class 0 OID 0)
-- Dependencies: 196
-- Name: rechnungsjahr_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE rechnungsjahr_id_seq OWNED BY rechnungsjahr.id;


--
-- TOC entry 197 (class 1259 OID 19421)
-- Name: unternehmer; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE unternehmer (
    id integer NOT NULL,
    firma character varying NOT NULL,
    uid integer,
    nachname character varying,
    vorname character varying,
    strasse character varying,
    hausnummer character varying,
    plz integer,
    ortschaft character varying,
    bemerkung character varying
);


ALTER TABLE av_geschaeftskontrolle.unternehmer OWNER TO stefan;

--
-- TOC entry 198 (class 1259 OID 19427)
-- Name: unternehmer_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE unternehmer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.unternehmer_id_seq OWNER TO stefan;

--
-- TOC entry 2840 (class 0 OID 0)
-- Dependencies: 198
-- Name: unternehmer_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE unternehmer_id_seq OWNED BY unternehmer.id;


--
-- TOC entry 199 (class 1259 OID 19429)
-- Name: verguetungsart; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE verguetungsart (
    id integer NOT NULL,
    art character varying NOT NULL
);


ALTER TABLE av_geschaeftskontrolle.verguetungsart OWNER TO stefan;

--
-- TOC entry 200 (class 1259 OID 19435)
-- Name: verguetungsart_id_seq; Type: SEQUENCE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE SEQUENCE verguetungsart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE av_geschaeftskontrolle.verguetungsart_id_seq OWNER TO stefan;

--
-- TOC entry 2842 (class 0 OID 0)
-- Dependencies: 200
-- Name: verguetungsart_id_seq; Type: SEQUENCE OWNED BY; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER SEQUENCE verguetungsart_id_seq OWNED BY verguetungsart.id;


--
-- TOC entry 201 (class 1259 OID 19437)
-- Name: vr_firma_verpflichtungen; Type: VIEW; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE VIEW vr_firma_verpflichtungen AS
 SELECT
        CASE
            WHEN (foo.firma IS NULL) THEN bar.firma
            ELSE foo.firma
        END AS firma,
        CASE
            WHEN (foo.jahr IS NULL) THEN (bar.jahr)::double precision
            ELSE foo.jahr
        END AS jahr,
    foo.kosten_vertrag_inkl,
    bar.kosten_bezahlt_inkl
   FROM (( SELECT a.kosten_vertrag_inkl,
            a.unternehmer_id,
            a.jahr,
            un.firma
           FROM ( SELECT sum(((auf.kosten)::double precision * ((1)::double precision + (auf.mwst / (100)::double precision)))) AS kosten_vertrag_inkl,
                    auf.unternehmer_id,
                    date_part('year'::text, auf.datum_start) AS jahr
                   FROM auftrag auf
                  WHERE (auf.geplant = false)
                  GROUP BY auf.unternehmer_id, date_part('year'::text, auf.datum_start)) a,
            unternehmer un
          WHERE (a.unternehmer_id = un.id)) foo
     FULL JOIN ( SELECT sum(a.kosten_bezahlt_inkl) AS kosten_bezahlt_inkl,
            a.jahr,
            auf.unternehmer_id,
            un.firma
           FROM ( SELECT sum(((rechnung.kosten)::double precision * ((1)::double precision + (rechnung.mwst / (100)::double precision)))) AS kosten_bezahlt_inkl,
                    rechnung.auftrag_id,
                    rechnung.rechnungsjahr AS jahr
                   FROM rechnung
                  GROUP BY rechnung.auftrag_id, rechnung.rechnungsjahr) a,
            auftrag auf,
            unternehmer un
          WHERE ((a.auftrag_id = auf.id) AND (auf.unternehmer_id = un.id))
          GROUP BY auf.unternehmer_id, un.firma, a.jahr) bar ON (((foo.unternehmer_id = bar.unternehmer_id) AND (foo.jahr = (bar.jahr)::double precision))));


ALTER TABLE av_geschaeftskontrolle.vr_firma_verpflichtungen OWNER TO stefan;

--
-- TOC entry 202 (class 1259 OID 19442)
-- Name: vr_kontr_planprozent; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE vr_kontr_planprozent (
    auf_name character varying,
    firma character varying,
    proj_name character varying,
    konto_nr integer,
    sum_planprozent numeric
);


ALTER TABLE av_geschaeftskontrolle.vr_kontr_planprozent OWNER TO stefan;

--
-- TOC entry 203 (class 1259 OID 19448)
-- Name: vr_laufende_auftraege; Type: VIEW; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE VIEW vr_laufende_auftraege AS
 SELECT af.auf_id,
    af.auftrag_name,
    af.firma,
    af.geplant,
    af.proj_id,
    af.projekt_name,
    af.konto,
    af.datum_start,
    af.datum_ende,
    af.verguetungsart,
    af.kosten_exkl,
    af.mwst,
    af.kosten_inkl,
    af.bezahlt,
    af.ausstehend,
    am.id_auftrag,
    am.amo_nr
   FROM (( SELECT a.auf_id,
            a.auftrag_name,
            a.firma,
            a.geplant,
            a.proj_id,
            a.projekt_name,
            a.konto,
            a.datum_start,
            a.datum_ende,
            v.verguetungsart,
            a.kosten_exkl,
            a.mwst,
            a.kosten_inkl,
            a.bezahlt,
            a.ausstehend
           FROM (( SELECT auftrag.auf_id,
                    auftrag.auftrag_name,
                    auftrag.firma,
                    auftrag.geplant,
                    auftrag.verguetungsart_id,
                    auftrag.proj_id,
                    auftrag.projekt_name,
                    auftrag.konto,
                    auftrag.datum_start,
                    auftrag.datum_ende,
                    auftrag.kosten_exkl,
                    auftrag.mwst,
                    auftrag.kosten_inkl,
                    rechnung.bezahlt,
                    (auftrag.kosten_inkl -
                        CASE
                            WHEN (rechnung.bezahlt IS NULL) THEN (0)::double precision
                            ELSE rechnung.bezahlt
                        END) AS ausstehend
                   FROM (( SELECT auf.id AS auf_id,
                            auf.name AS auftrag_name,
                            u.firma,
                            auf.geplant,
                            auf.verguetungsart_id,
                            proj.id AS proj_id,
                            proj.name AS projekt_name,
                            (konto.nr)::text AS konto,
                            auf.datum_start,
                            auf.datum_ende,
                            auf.kosten AS kosten_exkl,
                            auf.mwst,
                            ((auf.kosten)::double precision * ((1)::double precision + (auf.mwst / (100)::double precision))) AS kosten_inkl
                           FROM auftrag auf,
                            projekt proj,
                            konto konto,
                            unternehmer u
                          WHERE (((((auf.projekt_id = proj.id) AND (proj.konto_id = konto.id)) AND (auf.unternehmer_id = u.id)) AND (auf.datum_abschluss IS NULL)) OR (btrim((auf.datum_abschluss)::text, ''::text) = ''::text))) auftrag
                     LEFT JOIN ( SELECT sum(((rechnung_1.kosten)::double precision * ((1)::double precision + (rechnung_1.mwst / (100)::double precision)))) AS bezahlt,
                            rechnung_1.auftrag_id
                           FROM rechnung rechnung_1
                          GROUP BY rechnung_1.auftrag_id) rechnung ON ((rechnung.auftrag_id = auftrag.auf_id)))) a
             LEFT JOIN ( SELECT verguetungsart.id,
                    verguetungsart.art AS verguetungsart
                   FROM verguetungsart) v ON ((a.verguetungsart_id = v.id)))) af
     LEFT JOIN ( SELECT ao.auftrag_id AS id_auftrag,
            array_to_string(array_agg(ao.amo_nr), ', '::text) AS amo_nr
           FROM ( SELECT amo.id,
                    amo.auftrag_id,
                    amo.amo_nr
                   FROM amo
                  ORDER BY amo.amo_nr) ao
          GROUP BY ao.auftrag_id) am ON ((af.auf_id = am.id_auftrag)))
  ORDER BY af.datum_start, af.auftrag_name;


ALTER TABLE av_geschaeftskontrolle.vr_laufende_auftraege OWNER TO stefan;

--
-- TOC entry 204 (class 1259 OID 19453)
-- Name: vr_zahlungsplan_13_16; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE vr_zahlungsplan_13_16 (
    auf_name character varying,
    auf_geplant boolean,
    proj_name character varying,
    konto integer,
    auf_start date,
    auf_ende date,
    auf_abschluss date,
    plan_summe_a double precision,
    plan_prozent_a numeric,
    re_summe_a double precision,
    re_prozent_a double precision,
    plan_summe_b double precision,
    plan_prozent_b numeric,
    plan_summe_c double precision,
    plan_prozent_c numeric,
    plan_summe_d double precision,
    plan_prozent_d numeric,
    a_id integer,
    projekt_id integer
);


ALTER TABLE av_geschaeftskontrolle.vr_zahlungsplan_13_16 OWNER TO stefan;

--
-- TOC entry 205 (class 1259 OID 19459)
-- Name: vr_zahlungsplan_14_17; Type: TABLE; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

CREATE TABLE vr_zahlungsplan_14_17 (
    auf_name character varying,
    auf_geplant boolean,
    proj_name character varying,
    konto integer,
    auf_start date,
    auf_ende date,
    auf_abschluss date,
    plan_summe_a double precision,
    plan_prozent_a numeric,
    re_summe_a double precision,
    re_prozent_a double precision,
    plan_summe_b double precision,
    plan_prozent_b numeric,
    plan_summe_c double precision,
    plan_prozent_c numeric,
    plan_summe_d double precision,
    plan_prozent_d numeric,
    a_id integer,
    projekt_id integer
);


ALTER TABLE av_geschaeftskontrolle.vr_zahlungsplan_14_17 OWNER TO stefan;

--
-- TOC entry 2630 (class 2604 OID 19465)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY amo ALTER COLUMN id SET DEFAULT nextval('amo_id_seq'::regclass);


--
-- TOC entry 2631 (class 2604 OID 19466)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY auftrag ALTER COLUMN id SET DEFAULT nextval('auftrag_id_seq'::regclass);


--
-- TOC entry 2632 (class 2604 OID 19467)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY konto ALTER COLUMN id SET DEFAULT nextval('konto_id_seq'::regclass);


--
-- TOC entry 2633 (class 2604 OID 19468)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY perimeter ALTER COLUMN id SET DEFAULT nextval('perimeter_id_seq'::regclass);


--
-- TOC entry 2634 (class 2604 OID 19469)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY plankostenkonto ALTER COLUMN id SET DEFAULT nextval('plankostenkonto_id_seq'::regclass);


--
-- TOC entry 2635 (class 2604 OID 19470)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY planzahlung ALTER COLUMN id SET DEFAULT nextval('planzahlung_id_seq'::regclass);


--
-- TOC entry 2637 (class 2604 OID 19471)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY projekt ALTER COLUMN id SET DEFAULT nextval('projekt_id_seq'::regclass);


--
-- TOC entry 2638 (class 2604 OID 19472)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY rechnung ALTER COLUMN id SET DEFAULT nextval('rechnung_id_seq'::regclass);


--
-- TOC entry 2639 (class 2604 OID 19473)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY rechnungsjahr ALTER COLUMN id SET DEFAULT nextval('rechnungsjahr_id_seq'::regclass);


--
-- TOC entry 2640 (class 2604 OID 19474)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY unternehmer ALTER COLUMN id SET DEFAULT nextval('unternehmer_id_seq'::regclass);


--
-- TOC entry 2641 (class 2604 OID 19475)
-- Name: id; Type: DEFAULT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY verguetungsart ALTER COLUMN id SET DEFAULT nextval('verguetungsart_id_seq'::regclass);


--
-- TOC entry 2794 (class 0 OID 19351)
-- Dependencies: 179
-- Data for Name: amo; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO amo (id, auftrag_id, amo_nr) VALUES (1, 8, 'SO2650');
INSERT INTO amo (id, auftrag_id, amo_nr) VALUES (5, 9, 'SO2064');


--
-- TOC entry 2848 (class 0 OID 0)
-- Dependencies: 180
-- Name: amo_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('amo_id_seq', 5, true);


--
-- TOC entry 2796 (class 0 OID 19359)
-- Dependencies: 181
-- Data for Name: auftrag; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (6, 5, 'Kleinlützel Los 2', 54305.10, 8, NULL, 7, '2014-01-01', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (1, 1, 'Fusion Buchegg (Zusammenführen der AV-Operate)', 35040.00, 8, NULL, 3, '2013-10-03', '2014-02-28', NULL, false, 'Kostendach, Abrechnung nach Aufwand mit KBOB95%-Ansätzen');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (13, 7, 'Digitalisierung Nutzungspläne (2014)', 200000.00, 8, NULL, 8, '2014-01-01', '2014-12-31', NULL, true, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (8, 5, 'Mümliswil-Ramiswil Los 4', 10000.00, 8, 2, 2, '2014-01-01', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (9, 5, 'Mümliswil-Ramiswil Los 2', 23574.00, 8, 2, 2, '2014-01-01', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (12, 6, 'LRO - Zweitvermessung nach LU', 198000.00, 8, 3, 3, '2006-03-28', '2015-12-31', NULL, false, 'Höhere Kosten aufgrund des definitiven Perimeters (hochgerechnet). Die Abrechnung erfolgt auf Grund
der effektiven Elemente.

Abgabetermin gemäss Vertrag "1 Jahr nach Arbeitsbeginn". In dieser Form nicht umsetzbar. Geschätzter Abschluss ist Ende 2015.');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (36, 21, 'Berichtigung Breitenbach GB-Nr. 76, 77', 501.60, 8, 2, 11, '2014-02-17', '2014-02-28', '2014-03-10', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (19, 12, 'AVGBS-Workshop 2014 (BSB + Partner)', 5000.00, 8, NULL, 2, '2014-01-01', '2014-12-31', NULL, false, 'Schätzung. Auftrag?');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (39, 13, 'Teilrückmutation Mutation Ord. Nr. 7518 (Bootshafen)', 450.00, 8, 1, 13, '2014-03-17', '2014-04-30', '2014-04-07', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (47, 23, 'Bereinigung Gebäudegrundriss Dulliken GB-Nr. 277/755', 1400.00, 8, 1, 9, '2014-05-28', '2014-06-30', '2014-07-08', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (20, 12, 'AVGBS-Workshop 2014 (Emch + Berger AG Vermessungen)', 5000.00, 8, NULL, 3, '2014-01-01', '2014-12-31', NULL, false, 'Schätzung. Auftrag?');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (21, 12, 'AVGBS-Workshop 2014 (Lerch Weber AG)', 5000.00, 8, NULL, 9, '2014-01-01', '2014-12-31', NULL, false, 'Schätzung. Auftrag?');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (22, 13, 'Herkunft Flächendifferenzen eruieren 2013/2014 (Emch + Berger AG Vermessungen)', 3000.00, 8, 1, 3, '2013-11-18', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (23, 13, 'Herkunft Flächendifferenzen eruieren 2013/2014 (W+H AG)', 3000.00, 8, 1, 1, '2013-11-18', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (65, 13, 'Herkunft Flächendifferenzen eruieren (Lerch Weber, Zusatzauftrag)', 5600.00, 8, 1, 9, '2014-09-01', '2014-09-23', '2014-10-06', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (15, 8, 'Bereinigung Kantonsgrenze SO - BL / Zusatzauftrag (Armin Weber)', 4300.00, 8, 1, 9, '2013-11-19', '2013-12-31', '2014-04-07', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (40, 13, 'Teilgrundstück Nr. 5141.02 als eigenständiges Grundstück erfassen', 750.00, 8, 1, 13, '2014-03-18', '2014-04-30', '2014-06-26', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (44, 13, 'Herkunft Flächendifferenzen eruieren 2014 (2. Auftrag) (Emch + Berger AG Vermessungen)', 3000.00, 8, 1, 3, '2014-04-09', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (60, 27, 'Passpunkte- und Kontrollpunktmessung Drei Höfe', 6000.00, 8, 1, 1, '2014-07-15', '2014-08-31', '2014-09-26', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (45, 22, 'Abgleich und Bereinigung Liegenschafts- und Hoheitsgrenzen (Lebern ohne Grenchen u. Bettlach)', 5472.00, 8, 1, 3, '2011-12-22', '2014-05-19', '2014-05-19', false, 'Auftragsende und -abschluss nicht korrekt.');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (16, 9, 'Abgleich und Bereinigung der Liegenschafts- und Hoheitsgrenzen (Wasseramt)', 5000.00, 8, 2, 1, '2012-01-01', '2012-06-30', '2014-06-12', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (27, 16, 'PNF/Homogenisierung Wasseramt Etappe 2014-1 / Phase 2', 140000.00, 8, 1, 1, '2014-08-01', '2015-02-28', NULL, true, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (17, 10, 'Checkservice MOCHECKSO (2014)', 10000.00, 8, 2, 10, '2014-01-01', '2014-01-31', '2014-02-03', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (31, 18, 'swipos-GIS/GEO 2014', 2150.00, 8, 2, 12, '2014-01-29', '2014-01-29', '2014-02-03', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (28, 17, 'PNF/Homogenisierung Bucheggberg Etappe 2014-1 / Phase 1', 36000.00, 8, 1, 3, '2014-02-01', '2014-04-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (42, 20, 'PNF/Homogenisierung Gäu Etappe 2014-1 Phase 1 (Pilot)', 22000.00, 8, 1, 2, '2014-03-24', '2014-05-03', '2014-05-03', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (59, 26, 'Umnummerierung 90''000er Grunstücke mit Index (Zullwil)', 500.00, 8, 2, 11, '2014-07-09', '2014-07-18', '2014-10-06', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (35, 20, 'PNF/Homogenisierung Gäu Etappe 2014-1 Phase 2 (Rest)', 147000.00, 8, 1, 2, '2014-02-14', '2015-02-12', NULL, true, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (3, 3, 'Beratungsmandat lokale Spannungen', 20130.00, 8, NULL, 2, '2012-09-03', '2015-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (49, 20, 'PNF/Homogenisierung Gäu Etappe 2014-1 Phase 1 (Rest)', 49000.00, 8, 1, 2, '2014-06-09', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (58, 25, 'Bereinigung der Flächendifferenzen Etappe 1 AV - GB (Wasseramt)', 1200.00, 8, 1, 1, '2014-06-30', '2014-08-31', '2014-07-08', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (18, 11, 'Korrektur der Kantonsgrenze Schönenwerd SO - Unterentfelden AG', 4600.00, 8, 1, 9, '2013-12-16', '2014-02-28', '2014-06-26', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (56, 9, 'Bereinigung Kantonsgrenze Bolken, Subingen', 800.00, 8, 2, 1, '2014-06-17', '2014-06-30', '2014-06-24', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (57, 24, 'Bereinigung der Differenzen zwischen Grundbuch und der amtlichen Vermessung (Thal / Gäu)', 4479.60, 8, 1, 2, '2014-06-24', '2014-07-31', '2014-07-02', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (25, 15, 'Operat-Einrichtung nach Datenübernahme von Ersterhebungsoperaten (Beinwil, Meltingen, Zullwil)', 2300.00, 8, 2, 11, '2014-01-21', '2014-02-28', '2014-01-30', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (7, 5, 'Gänsbrunnen Los 1', 7325.00, 8, NULL, 2, '2014-01-01', '2014-12-31', '2014-02-06', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (24, 14, 'Abgleich und Bereinigung der Liegenschafts- und Hoheitsgrenzen - Zusatzauftrag (Wasseramt)', 2500.00, 8, 2, 1, '2014-01-20', '2014-04-30', '2014-06-12', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (33, 19, 'Berichtigung Beinwil GB-Nr. 282, 90032', 620.00, 8, 2, 11, '2014-02-05', '2014-02-28', '2014-02-24', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (34, 19, 'Berichtigung Beinwil GB-Nr. 83, 84, 240', 465.00, 8, 2, 11, '2014-02-05', '2014-02-28', '2014-02-24', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (38, 5, 'Einsprachebehandlung Zullwil (Gasser)', 2080.60, 8, 2, 9, '2014-02-28', '2014-03-21', '2014-03-27', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (41, 13, 'Herkunft Flächendifferenzen eruieren > 5m2 2014 (BSB + Partner, Oensingen)', 5335.20, 8, 1, 2, '2014-03-18', '2014-04-18', '2014-06-24', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (43, 10, 'Erweiterung 2014-03 (error.log)', 2270.00, 8, 2, 10, '2014-03-31', '2014-04-25', '2014-05-28', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (29, 17, 'PNF/Homogenisierung Bucheggberg Etappe 2014-1 / Phase 2', 116400.00, 8, 1, 3, '2014-08-01', '2015-03-31', NULL, true, '2014-07-02 / sz: Kosten und Auftragsbeginn und -ende an Offerte angepasst.');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (4, 4, 'Lidar-Befliegung Kanton Solothurn', 211500.00, 8, 2, 4, '2014-01-01', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (14, 8, 'Bereinigung Kantonsgrenze SO - BL (Armin Weber)', 14800.00, 8, 1, 9, '2013-09-09', '2013-12-31', '2014-04-07', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (61, 28, 'Umnummerierung der 90''000er mit Index (Lerch Weber AG)', 886.50, 8, 1, 9, '2014-07-01', '2014-07-18', '2014-07-14', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (48, 20, 'PNF/Homogenisierung Gäu Etappe 2014-1 Phase 2 (Pilot)', 35000.00, 8, 1, 2, '2014-06-02', '2014-08-15', '2014-08-05', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (62, 29, 'Passpunkt- und Kontrollpunktmessung Hessigkofen', 5900.00, 8, 1, 3, '2014-08-25', '2014-11-14', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (63, 30, 'Kreisbogen in QGIS', 49000.00, 8, 2, 14, '2014-08-25', '2015-01-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (64, 31, 'Trimble Servicearbeiten Kontrolle für TSC2', 320.00, 8, 2, 12, '2014-08-25', '2014-08-25', '2014-08-25', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (2, 2, 'Luftbildbefliegung und Orthofotoerstellung Kanton Solothurn (Teilgebiet West)', 85600.00, 8, NULL, 4, '2014-01-01', '2014-09-01', '2014-10-06', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (66, 13, 'Herkunft der Flächendifferenzen eruieren (Sutter AG)', 3600.00, 8, 1, 11, '2014-09-02', '2014-09-12', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (26, 16, 'PNF/Homogenisierung Wasseramt Etappe 2014-1 / Phase 1', 50000.00, 8, 1, 1, '2014-02-01', '2014-06-30', '2014-08-02', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (67, 32, 'Abgleich Hoheitsgrenze Grenchen - Court', 1500.00, 8, 2, 13, '2014-09-10', '2014-10-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (68, 25, 'Recherchen Flächendifferenzen > 5m2 (Wasseramt) Zusatzauftrag', 3800.00, 8, 1, 1, '2014-09-26', '2014-12-31', '2014-10-06', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (69, 33, 'Pilotprojekt Bezugsrahmenwechsel LV03 -> LV95', 16000.00, 8, 1, 2, '2014-10-06', '2015-01-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (70, 30, 'Erweiterung ili2pg um Flächenbildung', 5000.00, 8, 2, 15, '2014-10-06', '2015-03-31', NULL, false, '* Gesamtkosten 15''000.- 
* Kosten wurden gedrittelt (GL, BE, SO)');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (32, 13, 'Herkunft Flächendifferenzen eruieren > 5m2 2014 (Lerch Weber AG)', 8000.00, 8, 1, 9, '2014-02-05', '2014-07-31', '2014-10-06', false, '* Zusatzauftrag am 28. März 2014 / Fr. 2''000.-
* Auftragsende verschoben von 14.3.14 auf 30. April 2014
* nochmals Zusatzauftrag. Mehraufwand Dulliken. 26. 6. 2014 / Fr. 1''900.-
* 1 Rechnung für alle Aufträge

');
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (71, 34, 'Strassenachsen bereinigen (AVT) - W+H', 1365.00, 8, 2, 1, '2014-10-06', '2014-11-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (72, 34, 'Strassenachsen bereinigen (AVT) - Emch + Berger AG Vermessungen', 1815.00, 8, 2, 3, '2014-10-06', '2014-11-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (73, 34, 'Strassenachsen bereinigen (AVT) - Lerch Weber AG', 1680.00, 8, 2, 9, '2014-10-06', '2014-11-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (74, 34, 'Strassenachsen bereinigen (AVT) - BSB Oe/Gr', 420.00, 8, 2, 2, '2014-10-06', '2014-11-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (75, 34, 'Strassenachsen bereinigen (AVT) - Sutter AG', 1695.00, 8, 2, 11, '2014-10-06', '2014-11-30', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (76, 35, 'Ergänzung Mutationsplan mit öffentlichen Grundstücksnummern (BSB Oe/Gr)', 143.15, 8, 2, 2, '2014-10-07', '2014-10-07', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (77, 10, 'Erweiterung Checkservice MOCHECKSO mit DM01AVSOLV95', 800.00, 8, 2, 10, '2014-10-13', '2014-11-28', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (79, 37, 'Abänderung Mutationspläne und Mitteilungsschreiben Flächen alt/neu (BSB Oe)', 1608.50, 8, 2, 2, '2014-10-29', '2014-10-29', '2014-10-29', false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (78, 36, 'PNF/Homogenisierung Grenchen/Bettlach Etappe 2014-1 Phase 1 (Pilot)', 30000.00, 8, 1, 2, '2014-10-13', '2014-12-31', NULL, false, NULL);
INSERT INTO auftrag (id, projekt_id, name, kosten, mwst, verguetungsart_id, unternehmer_id, datum_start, datum_ende, datum_abschluss, geplant, bemerkung) VALUES (80, 38, 'Berichtungsmutation Erschwil GB-Nr. 8,10, 1446', 1693.60, 8, 2, 11, '2014-11-05', '2014-11-30', NULL, false, NULL);


--
-- TOC entry 2849 (class 0 OID 0)
-- Dependencies: 182
-- Name: auftrag_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('auftrag_id_seq', 80, true);


--
-- TOC entry 2798 (class 0 OID 19367)
-- Dependencies: 183
-- Data for Name: konto; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO konto (id, nr, name, bemerkung) VALUES (1, 3130015, 'Unterhalt und Nachführung', '');
INSERT INTO konto (id, nr, name, bemerkung) VALUES (2, 5640000, 'Oeffentl. Unternehmungen', 'RADAV-Konto');


--
-- TOC entry 2850 (class 0 OID 0)
-- Dependencies: 184
-- Name: konto_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('konto_id_seq', 2, true);


--
-- TOC entry 2800 (class 0 OID 19375)
-- Dependencies: 185
-- Data for Name: perimeter; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO perimeter (id, projekt_id, perimeter) VALUES (1, 1, '010600002015550000010000000103000000010000007C030000A245B6F3B97C2241D578E92602EA0A41CBA14536087C2241C74B378929E30A417F6ABC74FF7B2241F4FDD478B8E20A416DE7FBE9FC7B22413789416042E20A413BDF4F8D167C22415839B4C8A8D80A410AD7A330167C2241295C8FC254D80A41F4FDD438137C22413F355EBA01D80A41A69BC4E00C7C2241F853E3A5B1D70A4183C0CAE1027C22411283C0CA5BD70A41CDCCCC8CBB792241AE47E17AAAC80A412E83080BBA792241D375FEDCA0C80A41E29B5982B87922413BA1AA5097C80A418FDBCCF2B6792241D46B35D68DC80A41A6446F5CB579224151D7ED6D84C80A4167124EBFB3792241DE4D22187BC80A4174B8761BB2792241919F20D571C80A4163E2F670B0792241E8FF35A568C80A414673DCBFAE7922413C03AF885FC80A413E853508AD7922414D9CD77F56C80A410169104AAB792241BE19FB8A4DC80A414E621018AB7922413BDF4F8D4CC80A4164A57B85A9792241AC2364AA44C80A41E3F685BAA779224136B95CDE3BC80A41234F3EE9A57922411E2E2E2733C80A417BD4B311A47922415B2821852AC80A416FE1F533A2792241C69D7DF821C80A4135041450A0792241BAD18A8119C80A4132FE1D669E792241C6528F2011C80A4174C323769C79224160F8D0D508C80A41337A35809A792241A0E094A100C80A41437A638498792241FE6D1F84F8C70A418D976E129879224185EB51B8F6C70A41C3F5285C5A78224179E92631E4C30A41F2D24DE2BD76224146B6F3FD99BE0A41E9263148A67622418B6CE7FB58BE0A41F4FDD4F895762241CBA145B63BBE0A415C8FC2F590762241E17A14AE2FBE0A415C8FC2758976224185EB51B824BE0A4166666666CD742241986E128317BC0A41FA7E6AFC49732241EE7C3F354DBA0A412EF38D9F4773224170C98C8D4ABA0A41F4BEF54445732241492B5DC647BA0A414D1CBCEC427322417594CFDF44BA0A41B42AFB9640732241335604DA41BA0A411CEECC433E732241D71D1DB53EBA0A41CB4D4BF33B7322414DF33C713BBA0A413E1390A5397322419837880E38BA0A414E6210983873224139B4C87636BA0A4105E9B45A377322413CA3248D34BA0A41A859D31235732241984439ED30BA0A4189CE04CE32732241327EEE2E2DBA0A41CA8E628C30732241F9046E5229BA0A4131BE054E2E73224172DEE25725BA0A41145C07132C732241D65E793F21BA0A413F4280DB2973224129275F091DBA0A41931804D6277322418D976E1219BA0A41AFA255A225732241E219AEA014BA0A410B166472237322419005C51110BA0A41E88D474621732241A8D6E5650BBA0A417A01181E1F7322417116449D06BA0A41AA3CEDF91C732241798B14B801BA0A410ADFDED91A73224155378DB6FCB90A41D05A04BE187322414954E598F7B90A41F2D24DE217732241F4FDD478F5B90A41D7F374A616732241E952555FF2B90A419ABE479314732241A8D7160AEDB90A41399F9384127322415EB86499E7B90A417B486F7A10732241C0F97A0DE2B90A41D33AF1740E732241C5CC9666DCB90A4169C32F740C732241098CF6A4D6B90A4123FB40780A73224118B9D9C8D0B90A41C3F528DC08732241FED478E9CBB90A413F4316F00673224127A830EBC5B90A41A1B0170905732241067832D3BFB90A4116BA422703732241F327C3A1B9B90A416FA3AC4A0173224173B02857B3B90A413A756A73FF7222416626AAF3ACB90A41D4FB90A1FD722241E6B78F77A6B90A417CC634D5FB72224114A922E39FB90A413108AC9CFA7222411F85EB519BB90A416E266A0EFA722241E250AD3699B90A41F82D454DF8722241C3157B7292B90A419FAFD991F6722241606AD8968BB90A41373D3BDCF472224132CA12A484B90A410D277D2CF372224118B6789A7DB90A41077BB282F1722241E2B0597A76B90A41D103EEDEEF722241CD3B06446FB90A4104484241EE722241F5D2CFF767B90A418FC2F5A8ED7222411D5A643B65B90A410E2DB29DE5712241713D0AD735B50A41DD2406414C7022417B14AE47B3AE0A41508D97AE546F224179E92631C1AA0A410E2DB2DD486F2241B29DEFA7A8AA0A415A643BDF426F22419EEFA7C6CDAA0A41A69BC420366F22418B6CE7FB06AB0A41355EBAC9E26E224160E5D022A7AC0A419EEFA786CA6E2241F2D24D6226AD0A41333333B3B56E2241CFF753E3AEAD0A4191ED7C7FA56E2241022B871641AE0A41E3A59B049A6E2241560E2DB2DAAE0A410AD7A3B0936E2241F6285C8F6EAF0A41EC51B85E916E22416F1283C005B00A4191ED7C3F926E22411F85EB5139B00A41D34D62D0936E2241B29DEFA79AB00A411F85EBD1926E2241560E2DB2D6B00A415839B4C8976E22413333333350B10A41A4703D8A9F6E22414260E5D088B10A419EEFA706B06E2241F6285C8F2EB20A4133333333B26E22413333333344B20A4114AE4721CA6E2241A01A2FDDE8B20A41B6F3FD54DC6E22415EBA490C55B30A41C520B0B2186F2241643BDF4FBCB40A4191ED7C7F2A6F2241CDCCCCCC2BB50A419A9999D9396F224162105839A0B50A41E7FBA9713E6F224185EB51B8CAB50A411F85EBD1466F2241EE7C3F3519B60A41A245B6734F6F2241713D0AD798B60A41DF4F8DD7556F22418716D9CE1BB70A41DBF97E2A386F224191ED7C3F8FB70A41E3A59B04FE6E224152B81E853AB70A41EE7C3FB59B6E22414C378941AEB60A415EBA49CC8C6E2241FCA9F1D2C4B70A41560E2DB24B6E2241CDCCCCCC77B70A41EE7C3F35F66D224146B6F3FDF7B60A41F2D24D22F76D22413F355EBA34B70A419A999959E76D2241000000001EB80A413108ACDC026E22412FDD240643B80A41D578E9A6046E22411B2FDD24B6B80A41D9CEF753046E224125068195E5B80A4196438B6CFD6D2241F2D24D62FBB80A41B4C876FEF96D224114AE47E12CB90A41560E2DB2F76D22418D976E124FB90A4133333373F16D2241BC749318AFB90A41F2D24D22E16D2241A69BC420ABBA0A4139B4C8F6AF6D22419EEFA7C6A3BC0A41986E1203986D22413BDF4F8D09BD0A41621058799D6D22412506819516BD0A41000000806F6D22413F355EBA34BE0A4160E5D022496D2241355EBA4956BF0A411B2FDDE4316D224100000000C8BF0A4104560EAD286D22411F85EB5187C00A41C520B0B21D6D2241A8C64B37BEC20A41378941E05D6D2241BA490C0298C30A415839B448636D2241BE9F1A2FAAC30A41CFF753A3716D2241355EBA49DAC30A4148E17A14BC6D2241B81E85EB3FC50A41736891ADC46D22413789416032C50A417F6ABC74DF6D2241A8C64B3757C60A416DE7FB29E86D2241986E1283DAC60A41643BDF4FE66D2241A245B6F31FC70A41A245B673D86D22411904560E63C70A41295C8F42C66D224114AE47E180C70A41759318C4C66D2241AE47E17AB9C70A4125068195BE6D2241F6285C8F21C80A413108AC9CAB6D2241E5D022DB7EC80A41C520B0B27F6D224123DBF97E8DC80A41F2D24DE2326D2241C74B378907C80A411D5A647BEC6C22414A0C022B87C80A41986E1243C06C2241D7A3703D88C80A415A643BDFA26C2241355EBA494DC80A41DF4F8D97826C22415C8FC2F515C80A416DE7FBE9666C2241A4703D0ABBC70A41333333334A6C2241CDCCCCCC2CC70A41F853E3A5266C2241A245B6F3CAC60A4185EB51B8BE6B2241C3F5285CABC50A4114AE4761A26B22419A99999962C60A417B14AEC7906B224166666666B2C60A41AE47E1FA726B224185EB51B886C60A41BC749358516B2241508D976E32C60A41CFF753A31D6B224179E92631B0C50A418FC2F568006B2241A01A2FDD65C50A4100000080E56A2241AE47E17A22C50A412B871619976A22412DB29DEF5FC40A418FC2F5A8936A224152B81E8557C40A41333333F3606A22410AD7A370D6C30A41A69BC4203A6A22416F1283C094C30A41FCA9F152076A22411904560E6EC30A41E17A14AEE26922410AD7A3704FC30A4152B81E05EA692241F6285C8F10C30A41295C8FC292692241295C8FC2B1C20A41A8C64BB71F692241F4FDD4780AC20A41CDCCCCCC15692241C3F5285CFBC10A4183C0CAE1E468224162105839B2C10A41295C8FC2A96822419A99999961C10A4139B4C8366668224123DBF97E0FC10A413D0AD7A360682241CFF753E30BC10A41E17A142E176822415C8FC2F5D4C00A4114AE47A107682241D34D6210C9C00A41AC1C5A64D867224175931804ABC00A4114AE4761986722410AD7A3707FC00A41666666E68C6722415C8FC2F578C00A41D7A3703D43672241295C8FC24FC00A41D7A370BD0667224148E17A1436C00A4114AE47E1DB662241A4703D0A2DC00A41D7A3703DC1662241713D0AD727C00A413333333374662241666666661AC00A41AE47E1FA046622413333333349C00A41D122DBB9FA652241C3F5285C4AC00A4114AE47E1E6652241295C8FC251C00A418FC2F528AD652241F6285C8F62C00A4177BE9FDA4B652241931804569AC00A415C8FC2F522652241E9263108A6C00A413D0AD7A3066522410AD7A370B5C00A41C1CAA1C5E56422413108AC1CC7C00A41EC51B89EE0642241F6285C8FB0C00A4152B81E45B1642241E5D022DBE8BF0A41AE47E1FA99642241B81E85EB81BF0A413D0AD7236E6422410AD7A370ABBE0A41666666E650642241CDCCCCCC06BE0A418FC2F5A8866422411F85EB511EBD0A417F6ABC346F6422412DB29DEFC6BC0A41666666664C642241AE47E17A9EBC0A41F6285C0F14642241D7A3703DE6BB0A415C8FC275FB632241D7A3703D86BB0A415C8FC275AD63224133333333EFBA0A41F0A7C6CBC76322414C37894115BA0A4108AC1C5A92632241B29DEFA778B80A412DB29DAF6C632241EC51B81EEAB70A4100000080466322419A999999B9B70A4185EB5138FF62224152B81E855FB70A4185EB51B8F86222411F85EB5181B70A4185EB5138F3622241CDCCCCCC8FB70A41105839F4CE622241378941609AB70A410C022B076F622241DBF97E6A2EB70A41D7A370BD6162224114AE47E10AB70A413D0AD723226222411F85EB5160B60A41C3F528DC09622241B29DEFA71EB60A4133333333D1612241C3F5285C81B50A418195438BBE612241D7A3703D97B50A418716D94E7D612241295C8FC221B50A41EC51B89E46612241C3F5285CC5B50A41CDCCCC4CE060224148E17A14F4B60A41FED478699A6022413108AC1CF5B60A416ABC74938F602241713D0AD7DAB60A41F2D24D627A602241894160E5C0B60A41CDCCCC4C0D60224114AE47E1B2B50A4148E17A949A5F2241EC51B81E3BB50A41CDCCCC4C525F22411F85EB5120B50A4100000000FF5E224114AE47E1BAB40A41C3F5285CB75E224114AE47E164B40A41560E2D729A5E2241AC1C5A645EB40A41E17A142E5C5E22411F85EB5152B40A41C3F5285C385E224185EB51B828B40A411F85EB51EF5D22413D0AD7A368B40A4152B81E85C85D22416666666624B40A41295C8F427C5D2241AE47E17A68B30A413BDF4F4D3E5D2241DBF97E6A07B30A4100000000055D2241CDCCCCCCD6B20A41295C8F42855C2241AE47E17A1CB20A4185EB5138075C2241D7A3703D00B10A4114AE47E1955B22413BDF4F8D64AF0A4148E17A14705B224100000000EAAE0A41C3F528DC225B2241E17A14AEA9AD0A41713D0AD7E15A22418FC2F5289AAC0A41FA7E6A3C7E5A22419CC420B0DFAB0A41EC51B81E5E5A22417B14AE476DAB0A41355EBA09565A2241BE9F1A2FAEAA0A41AE47E1FA5A5A2241B81E85EB4FAA0A417B14AE471D5A224114AE47E17CA90A41F6285C8FD259224152B81E85B1A80A41EC51B81E8C592241EC51B81EF1A70A419A99999958592241F6285C8F7CA70A41B81E856B125922413D0AD7A3DCA60A41333333B3BE582241CDCCCCCC08A60A41CBA145B6AE58224177BE9F1AE1A50A4185EB51389358224148E17A147EA50A41F0A7C64B90582241A8C64B3773A50A41A4703D8A68582241B81E85EBADA40A4152B81E855D5822410000000004A40A41621058392D582241C976BE9F2FA30A4160E5D0221F582241AE47E17A16A30A41022B8756FB572241A4703D0A6BA30A41A245B6F3B65722413108AC1C09A40A412FDD24C66157224152B81E858FA50A41FED4782935572241C976BE9F56A70A41F2D24D2217572241B4C876BE6AA90A4152B81EC5FE562241643BDF4FFEAA0A416ABC7413C656224123DBF97ED7AC0A41FCA9F1528956224104560E2D44AE0A4139B4C8F64F5622416F1283C08DAF0A4154E3A55B3555224152B81E8556AF0A41355EBA890C5522418195438B4DB30A41AAF1D28D0A55224125068195CBB30A4123DBF93EFD542241FED478E959B90A418FC2F56803552241E3A59BC470B90A41AE47E17A0355224154E3A59B90B90A4152B81E45A65522412FDD240668B90A415839B48854572241643BDF4FEFB80A411904564E60572241643BDF4FDEBA0A4148E17A54685722413D0AD7A358BB0A41DD24064111582241A4703D0A66BB0A4137894120DB5722410681954327BD0A4121B07268A8572241D9CEF75386BE0A4152B81E8588572241BC749318A0BF0A41EC51B89EDC582241894160E5DEC30A4108AC1CDA805922412DB29DEFA9C50A4160E5D0E2925922418D976E1245C60A413D0AD7E38B592241B29DEFA771C60A417B14AE47AF59224177BE9F1AD8C60A417B14AE471F5A22411D5A643B84C70A417B14AE072E5A224185EB51B8ECC70A41B07268D1C3592241894160E5FAC80A4160E5D0629F5922413789416050C90A41273108AC945922410AD7A37065C90A41CBA145B673592241FED478E9A6C90A412DB29D6F295922416891ED7C33CA0A41BE9F1AEF935822410E2DB29D4ECB0A41F6285C0FB75722415839B4C8F0CC0A41BA490CC2755722410AD7A37095CD0A4104560E6D0E572241D578E9269BCE0A41A01A2FDDB3562241A69BC42080CF0A4123DBF93EC256224185EB51B8D4CF0A41819543CB5F56224191ED7C3F6FD10A4139B4C836C4562241F853E3A536D20A415EBA494CC556224179E9263139D20A41FED47869FD5622418B6CE7FBAAD20A41CFF75363605722414C3789417DD30A410E2DB21DCC57224177BE9F1A00D50A41713D0AD7C7572241A4703D0A17D50A41A4703D0A24572241F6285C8F74D80A4177BE9F1AC3562241448B6CE778DA0A41E17A142EBF5622413D0AD7A38ADA0A4185EB51388B562241F6285C8F7EDB0A41AE47E17A6F562241E17A14AEF3DB0A41B81E856B18562241AE47E17A54DD0A41AE47E1FA13562241CDCCCCCCC8DD0A41A4703D8A5D562241B81E85EB9FDF0A4114AE47E18F562241EC51B81E21E10A41C3F528DCA856224100000000F6E10A413D0AD723C656224114AE47E1F2E20A411F85EBD14556224114AE47E17AE50A41B81E856B015622410000000050E40A41C3F528DCD7552241C3F5285CA3E30A4114AE47E1AC552241AE47E17AFCE20A41E17A142E7F552241B81E85EB5FE20A41F6285C0F505522410AD7A370CBE10A41E17A14AE46552241C3F5285CFDE10A41B81E85EB11552241295C8FC2CDE20A4185EB51386F542241A4703D0A63E10A41713D0A57D75322413D0AD7A310E00A410AD7A3F04B532241295C8FC2E1DE0A415C8FC275C75222419A999999C1DD0A41666666E6465222413D0AD7A3A8DC0A41A4703D8A2F522241713D0AD703DC0A4185EB5138FA512241EC51B81E89DA0A410AD7A3F0B5512241CDCCCCCCA4D80A411F85EB51AA512241B81E85EB51D80A41F6285C0FDE5022417B14AE474FD60A4148E17A14815022410AD7A370E9D50A411F85EBD15E50224133333333C3D50A41B81E856BC74F2241AE47E17A1AD50A41E17A142E0C4F22416666666656D40A41295C8F42654E224114AE47E1A6D30A419A999919CB4D2241EC51B81E6DD30A41666666E6254E2241EC51B81E0DD60A41666666E6E64D22413D0AD7A3AED80A41B81E856B964D224152B81E8503DC0A41F6285C8F024D2241EC51B81E3BDA0A4152B81E85884C224148E17A14C4D80A41713D0AD70C4C2241EC51B81E49D70A41333333B37A4B2241713D0AD78BD50A41A4703D0A1B4B2241A4703D0A6DD40A418FC2F5A80D4B2241713D0AD79BD40A4148E17A14C54A2241F6285C8FF0D40A41F6285C8FB44A224114AE47E11ED50A41295C8F42A84A22411F85EB515ED50A41CDCCCC4CA04A22410AD7A370A5D50A4185EB51B8984A2241333333339DD50A415C8FC275834A224100000000C8D50A41F6285C0FA24A22416666666688D70A41295C8FC2D94A2241EC51B81EDBD90A41D7A3703DDC4A2241E17A14AEF5D90A41AE47E1FAE94A22418FC2F52888DA0A413D0AD7A3BA4A224152B81E853FDB0A41C3F528DCB24A2241E17A14AE5DDB0A411F85EBD1AD4A22413333333371DB0A4100000000804A2241B81E85EB25DC0A41B81E856B364A2241295C8FC247DD0A41B81E856BB7492241E17A14AEF7DC0A41A4703D0AA8492241D7A3703DF0DC0A41E17A142E9E4922417B14AE47EBDC0A41C3F5285C494822413D0AD7A33EDC0A4185EB51B8D4472241A4703D0A3FDF0A4114AE4761834722410AD7A37057E10A41713D0AD77E472241666666668EE10A41E17A142E1A4722419A99999955E60A41F6285C8F174722418FC2F52876E60A4148E17A9414472241B81E85EB9BE60A417B14AE47BA462241D7A3703DA4E80A410AD7A370AE462241AE47E17AE8E80A41C3F5285C85452241EC51B81EF3EB0A41F6285C0FE74522417B14AE4747ED0A41E17A142E514622413D0AD7A3BAEE0A415C8FC2F5AD4622418FC2F52800F00A411F85EB51FF462241A4703D0A21F10A418FC2F5A85E472241295C8FC225F20A41E17A14AEB9472241B81E85EB1FF30A41C3F5285C14482241E17A14AE17F40A41713D0AD76A482241F6285C8F04F50A41CDCCCCCC364822411F85EB514AF70A41EC51B89EEE4722418FC2F5287EFA0A4148E17A9463482241295C8FC225FE0A41AE47E17ADD48224152B81E8567FF0A411F85EB514F492241C3F5285C8F000B41333333B3B74922419A999999A5010B41EC51B89E0E4A22419A9999998B020B415C8FC2F5B34A2241F6285C8F40040B417B14AEC7A44B2241A4703D0AD1050B410AD7A3700D4D2241E17A14AE55070B41F6285C0F524E2241295C8FC299060B4148E17A94334F2241EC51B81E65070B410AD7A370774F2241F6285C8FA2070B41C3F5285CC14F224166666666E4070B41295C8F4215502241333333332F080B4100000080285022413D0AD7A3BA080B41295C8F42535022419A999999EB090B41F6285C8F8A502241C3F5285C770B0B41B81E856BDA502241CDCCCCCCB60D0B4148E17A14005122419A999999C30E0B4114AE47E1FF502241713D0AD7690F0B413D0AD7A3FB5022411F85EB51E20F0B4185EB5138EF50224114AE47E1D2100B4185EB5138D450224152B81E85C7120B4152B81E85C25022416666666602140B41E17A142EB5502241E17A14AE01150B4148E17A949650224114AE47E138170B41A4703D8A8350224152B81E8513190B4185EB51B875502241AE47E17A3E1A0B4185EB51B86B502241CDCCCCCC5C1B0B415C8FC2F569502241666666668A1B0B417B14AEC762502241295C8FC23D1C0B4152B81E0556502241666666667A1D0B410AD7A370485022415C8FC2F5CA1E0B41713D0A5705512241CDCCCCCC32220B410AD7A3F012512241AE47E17A5E220B417B14AE47FF51224114AE47E154250B4152B81E05F95222418FC2F52876280B41A4703D8A9953224133333333792A0B4152B81E0545542241C3F5285C9F2C0B410AD7A370EC54224166666666B82E0B41333333B3AB55224114AE47E1542F0B4152B81E052956224100000000C0300B410AD7A370705722416666666632320B4152B81E05935822417B14AE47D7320B41B81E85EBA05822419A999999DF320B41AE47E1FAA5582241B81E85EBE1320B41713D0AD7F958224152B81E8511330B417B14AE472C592241713D0AD7AD320B4148E17A94AE5922415C8FC2F5AA310B4152B81E85B95922417B14AE4795310B4152B81E05A55A2241F6285C8FC02F0B4148E17A94B45A22417B14AE47A12F0B41295C8F42455B224166666666822E0B41295C8F426C5B2241A4703D0A352E0B4185EB51B8755B224100000000222E0B410AD7A3F08E5B224114AE47E1522D0B411F85EBD1C55B22410AD7A370912B0B410AD7A3F0EF5B2241D7A3703D342A0B41295C8FC21E5C22413D0AD7A3B2280B4152B81E05935C2241A4703D0AF5280B41F6285C0FA75C22419A999999FF280B417B14AE47E45C22411F85EB5120290B4100000080445D22418FC2F52854290B41A4703D0A835D22411F85EB5174290B417B14AE47F35D2241E17A14AEE5290B4166666666FA5D224100000000B0280B41EC51B81E025E22410AD7A3705B270B4133333333265E224148E17A1464270B41F6285C8F4A5E2241713D0AD747270B410AD7A3F0A75E2241295C8FC2ED260B4185EB5138EA5E2241A4703D0AB5260B41713D0A57035F2241E17A14AE93260B41C3F528DC195F22419A9999995B260B41CDCCCC4C2F5F2241295C8FC215260B410AD7A370485F22417B14AE47D3250B418FC2F5A85E5F2241713D0AD7A5250B41A4703D0A6E5F22418FC2F5285C250B4148E17A147A5F22418FC2F52808250B41295C8FC2AB5F22411F85EB516C230B4152B81E85D15F2241E17A14AEE3230B410AD7A3F0246022410AD7A3708F220B41B81E856BAF602241D7A3703D88210B413D0AD7A3B9602241D7A3703D96210B41295C8F42FD602241EC51B81ED3210B4114AE47E12A612241EC51B81E05220B41AE47E17A386122419A99999923220B418FC2F52884612241C3F5285C31230B41F6285C0FC5612241D7A3703D98230B41295C8FC2E3612241AE47E17A5E230B4114AE4761F6612241CDCCCCCC70230B41AE47E17A60622241EC51B81EDF230B41A4703D0AB6622241E17A14AE5D240B417B14AE47DB62224152B81E8593240B417B14AE47066322411F85EB51D2240B41C3F528DC0C632241A4703D0AE5240B4114AE47612863224152B81E8523250B41A4703D8A796322410000000094250B4185EB5138C063224152B81E85FB250B413D0AD7A3D36322410AD7A370BF260B41E17A14AE0E642241D7A3703D78270B41713D0A575B6422413333333369280B41AE47E17A67642241CDCCCCCC14290B41EC51B81EF364224185EB51B8D6290B41CDCCCCCC4665224100000000062A0B41CDCCCCCCA065224114AE47E1382A0B41666666E6F965224133333333952A0B41AE47E1FA1466224133333333B12A0B415C8FC27560662241C3F5285CFF2A0B41C3F528DCAB662241EC51B81E692B0B41C3F528DCB1662241A4703D0A712B0B41CDCCCC4CEC662241F6285C8FDC2B0B41295C8F4232672241CDCCCCCC902C0B41AE47E17A74672241A4703D0AE32D0B4148E17A948F672241CDCCCCCCAC2E0B4166666666C5672241B81E85EB632F0B41B81E85EB0E682241E17A14AE3D2F0B419A9999194568224152B81E85212F0B41666666E66168224166666666522F0B41CDCCCC4C8D682241B81E85EB672E0B413D0AD72390682241A4703D0A572E0B41C3F528DCC368224148E17A14D42E0B411F85EBD1F9682241AE47E17A402F0B413333333332692241AE47E17A9A2F0B41AE47E1FA6B6922411F85EB51E22F0B4185EB51B8A6692241A4703D0A19300B4148E17A14AA692241AE47E17ADA2F0B4114AE47E1AC69224100000000C42F0B4133333333A56A224133333333AB300B417B14AEC7D76A224133333333E9300B4185EB51B8F96A2241D7A3703DA62E0B4152B81E05FD6A2241AE47E17A6E2E0B41F6285C0F566B22415C8FC2F5D42E0B41B81E856B726B224148E17A144A2D0B4152B81E85856B2241EC51B81E452C0B4100000080AB6B224152B81E85452C0B4148E17A14BE6B2241295C8FC25D2C0B415C8FC275EA6B224133333333C72C0B418FC2F5A80F6C2241CDCCCCCC0C2D0B41C3F5285C236C2241D7A3703D1A2D0B418FC2F528376C22413D0AD7A30C2D0B41A4703D8A476C2241713D0AD7DF2C0B4152B81E05576C22411F85EB51A02C0B41F6285C8F656C2241295C8FC2772C0B41C3F5285C766C22419A9999997B2C0B41F6285C8F786C2241CDCCCCCC582C0B41CDCCCC4C8C6C22418FC2F528802C0B4152B81E85AE6C2241713D0AD7F92C0B419A999919C16C2241E17A14AE272D0B41F6285C8FD46C2241F6285C8F4A2D0B417B14AE47DE6C22418FC2F5285C2D0B4152B81E85366D22418FC2F528C02D0B413D0AD7A3616D2241295C8FC2D72D0B41C3F528DC886D22417B14AE47AF2B0B4148E17A949A6D224148E17A14B82A0B4152B81E05D26D22410AD7A370FD2A0B415C8FC2F5F96D22410AD7A370292B0B41EC51B81E236E2241B81E85EB452B0B41CDCCCCCC9B6E2241295C8FC27F2B0B41666666E69D6E22410AD7A370632B0B41C3F5285CB66E2241333333331D2A0B411F85EB51BA6E224152B81E85E1290B4152B81E85DA6E22415C8FC2F572280B41E17A142EFB6E2241E17A14AEFF260B418FC2F5A8016F2241E17A14AEE5260B41C3F528DC656F22417B14AE4735240B41B81E856B926F224152B81E855B240B41E17A14AE946F2241AE47E17A86240B41E17A14AEA06F2241713D0AD791240B415C8FC275A46F2241000000006C240B413333333312702241F6285C8FCC240B41333333333D7022415C8FC2F5F6240B41333333B3677022411F85EB5128250B41D7A3703DA3702241EC51B81E79250B411F85EBD1147122413D0AD7A328260B41AE47E17A177122410AD7A3700D260B413D0AD7A3697122413D0AD7A382260B4100000080B3712241295C8FC205270B41F6285C0FCD712241F6285C8F28270B4148E17A14E871224114AE47E13E270B417B14AE47377222410000000072270B419A999919627222417B14AE478D270B41CDCCCCCC9A72224185EB51B8BA270B4185EB51B8CB7222417B14AE47EF270B41295C8FC2F272224148E17A141A280B410AD7A370037322415C8FC2F52C280B41D7A370BD13732241B81E85EB33280B419A99999931732241713D0AD757280B4148E17A943F73224152B81E8575280B417B14AEC774732241F6285C8FB4280B4114AE47E172732241CDCCCCCCD0280B415C8FC2F51674224152B81E8589290B41A4703D0A3E742241A4703D0AB5290B4114AE4761AD74224185EB51B8442A0B4152B81E85C6742241E17A14AE6F2A0B4166666666DB7422419A999999932A0B419A9999190D752241295C8FC2E72A0B415C8FC27550752241EC51B81E6F2B0B410AD7A370A97522419A999999232C0B41000000803B7622413D0AD7A35C2D0B4114AE47E1C87622411F85EB51842E0B4166666666ED7622419A999999CF2E0B41295C8FC2177722410AD7A370192F0B41333333336A772241CDCCCCCC8E2F0B411F85EBD1C477224114AE47E114300B417B14AEC7C777224152B81E85F72F0B41E17A142E877822413D0AD7A314310B419A9999194C79224185EB51B822320B4148E17A146F792241EC51B81E69320B4148E17A148F792241AE47E17AC6320B4114AE47E1FF792241E17A14AE77340B415C8FC2F5267A2241EC51B81EEB340B41D7A370BD4F7A2241E17A14AE55350B41AE47E1FAB87A22413D0AD7A340360B41C3F5285CE27A2241A4703D0A93360B41CDCCCCCC0D7B224148E17A14D6360B418FC2F5A8557B2241713D0AD719370B41713D0A57727B224185EB51B82A370B4152B81E05727B2241E17A14AE4B370B4152B81E05907B2241F6285C8F36370B4100000080DB7B22413D0AD7A326370B41EC51B89E227C2241EC51B81EFB360B415C8FC2F5577C22417B14AE47E1360B415C8FC2F5997C2241B81E85EB69360B41713D0AD7E07C224152B81E85EB350B41333333B3F07C2241F6285C8FBA350B41666666E6F77C22413D0AD7A3A4350B417B14AEC7117D22415C8FC2F554350B415C8FC2754A7D22413D0AD7A3FC350B4185EB51384F7D2241D7A3703DEA350B41295C8F42D67D2241E17A14AEFF370B41C3F5285CF37D2241CDCCCCCC6A380B41333333B3117E224148E17A14CE380B418FC2F5A82A7E22411F85EB510A390B41D7A370BD457E22410000000034390B41B81E85EB617E2241295C8FC257390B41D7A3703D987E2241000000009C390B410AD7A370D07E2241EC51B81ED5390B41CDCCCCCCCE7E2241AE47E17AEE390B4185EB5138FB7E2241333333331B3A0B41D7A370BD227F22410AD7A3702F3A0B41CDCCCCCC4A7F2241295C8FC22F3A0B41333333339B7F22418FC2F5280E3A0B41AE47E1FAE87F2241EC51B81EE3390B41713D0AD7F67F2241AE47E17AEA390B413D0AD7A30A802241CDCCCCCC3A3A0B415C8FC2F5298022411F85EB51883A0B41B81E856B478022417B14AE47B33A0B413D0AD7234E80224148E17A14B83A0B419A999999968022413D0AD7A3E63A0B411F85EB51A68022413D0AD7A30A3B0B4100000000A980224185EB51B81E3B0B41F6285C8FA8802241AE47E17A343B0B4114AE47E1AE802241C3F5285C293B0B4152B81E05C5802241E17A14AEDF3A0B410AD7A3F0D380224152B81E857B3A0B4166666666078122410AD7A3707B380B419A9999992D8122410000000000370B41333333B32881224166666666DA360B41C3F5285C2A812241D7A3703DC0360B41713D0AD74A81224185EB51B84A350B41CDCCCC4C6B812241AE47E17AD4330B41295C8FC2968122410AD7A3700D320B4185EB51B8978122411F85EB5102320B4148E17A94C3812241C3F5285C07300B41EC51B89EDA81224133333333FD2E0B41713D0AD7E38122411F85EB51922E0B4100000080FC81224148E17A14742D0B41D7A370BD168222419A999999432C0B413D0AD7A31F822241CDCCCCCCDC2B0B41666666E61882224100000000A02B0B41C3F5285C1782224114AE47E15E2B0B41000000001B822241EC51B81E1F2B0B41666666E621822241295C8FC2E12A0B418FC2F5282F82224133333333672A0B410AD7A3704082224133333333C7290B41EC51B89E43822241B81E85EBA9290B41B81E856B1A8322417B14AE47312A0B41D7A3703D1B8322417B14AE4703280B41295C8F421B832241A4703D0AEF270B411F85EBD1CB8322410000000020260B41C3F528DCDB832241B81E85EBF5250B41666666E60C84224185EB51B856250B4185EB51B8778422413D0AD7A3FA230B415C8FC2F57E84224114AE47E1E2230B41EC51B81E9D8422413D0AD7A376230B4133333333C184224100000000E6220B41C3F528DC02852241713D0AD787210B419A9999991F8522413333333339200B4114AE47E1248522410AD7A3700D200B41713D0AD72E852241A01A2FDDE81F0B41A245B6B36485224185EB51B8B01F0B41BE9F1AAF628522416891ED7C891F0B4106819503628522417F6ABC747C1F0B41E17A14EE68852241105839B4CA1E0B41FA7E6ABC6D852241A245B6F3251E0B41986E12036F8522411F85EB51A61D0B41E7FBA9316E852241AE47E17A051D0B41022B879668852241FED478E9151C0B413F355EFA648522416DE7FBA9E51B0B41E3A59BC4748522412B8716D9DB1A0B416F12838078852241C3F5285C781A0B41B81E856B7A852241E7FBA9F1481A0B41E3A59B447D8522411B2FDD24C6190B414A0C022B7E852241508D976E35190B41C3F5285C7E852241B6F3FDD417190B413D0AD7637E8522410E2DB29DCD180B419A999919568522415C8FC2F58E180B41FA7E6A7CE2842241355EBA49E1170B41CFF753639F842241508D976E7C170B41273108EC7A84224185EB51B845170B4162105879C683224148E17A1435160B414E62101847832241D34D621075150B416891EDBCFE8222419CC420B008150B41DDE887E6FC82224122B2BACA05150B4115D13213FB822241E96DF1C602150B41C7B40D43F98222412CBBF8A4FF140B413EC53776F7822241497F0665FC140B41D5FACFACF582224150A35207F9140B41E612F5E6F38222413F10178CF5140B41B38DC524F282224123AB8FF3F1140B415FAC5F66F08222410C51FA3DEE140B41BA490C02EF82224104560E2DEB140B41E26EE1ABEE822241E6D2966BEA140B41059268F5EC82224132F1A67CE6140B41658D1243EB82224199576E71E2140B417591FC94E98222415D98324ADE140B418A8543EBE7822241B2273B07DA140B41E9050446E6822241EA56D1A8D5140B41D9615AA5E48222418E4F402FD1140B41BF996209E38222414B0ED59ACC140B413B5D3872E1822241CB5DDEEBC7140B41FA7E6A7CE082224175931804C5140B412CA667EDDE82224152ACFB2BC0140B4169E87863DD8222419992283ABB140B4166BFB8DEDB8222417199F42EB6140B413053415FDA82224140A1B60AB1140B41D4702CE5D8822241B739C7CDAB140B419B889370D7822241DD9B8078A6140B4157AC8F01D6822241F8A33E0BA1140B41B78D3998D482224162CB5E869B140B4106819583D382224104560E2D97140B41957CA934D3822241402240EA95140B415C65F7D6D18222411B49433790140B4166CF3A7FD08222415E6ACA6D8A140B416ADB8A2DCF822241BE33398E84140B41EC41FEE1CD82224185CFF4987E140B41B751AB9CCC822241C2DD638E78140B4159EEA75DCB822241616DEE6E72140B41B18E0925CA8222412CF5FD3A6C140B41763BE5F2C8822241B24CFDF265140B415EBA494CC88222410AD7A37062140B41621058795182224183C0CAA1DD110B4146B6F37DCC8122416DE7FBA90C0F0B41881C263CCB812241999B0FE5050F0B415979F500CA812241D97FCC0CFF0E0B41B15E74CCC881224198009A21F80E0B4117FFB49EC78122418B97E023F10E0B410927C977C68122412AD60914EA0E0B41F03BC257C5812241775F80F2E20E0B411E3BB13EC4812241B3E1AFBFDB0E0B41C5B8A62CC38122410510057CD40E0B4104DFB221C28122410E9CED27CD0E0B41D578E9A6C1812241560E2DB2C90E0B41ED6CE51DC1812241742FD8C3C50E0B419FB54D21C08122415A653450BE0E0B41559FFA2BBF812241C9C372CDB60E0B418CA2FA3DBE8122410DB5043CAF0E0B4126C95B57BD81224108815C9CA70E0B4198AD2B78BC8122417046EDEE9F0E0B41187A77A0BB81224107F42A34980E0B41DCE74BD0BA812241C2418A6C900E0B41543EB507BA812241EBA98098880E0B418D976E52B9812241EE7C3F35810E0B41DFF37798B88122419F60F448790E0B412C9F37E6B7812241DACD9C51710E0B41A119B83BB7812241BEDDB04F690E0B41C66D0399B6812241104AA943610E0B41A53023FEB5812241F964FF2D590E0B413D81206BB5812241E3112D0F510E0B41F80704E0B481224149BEACE7480E0B4128F6D55CB4812241815AF9B7400E0B418A059EE1B381224182528E80380E0B41CFF753A3B3812241EC51B81E340E0B41D577636EB38122419B86E741300E0B4149162D03B38122412B4481FC270E0B414C3101A0B28122414B3ED8B01F0E0B4108A0E544B28122417A86695F170E0B4114C0DFF1B18122413D85B2080F0E0B412375F4A6B1812241BCF230AD060E0B41BA282864B18122415CCF624DFE0D0B41F1C97E29B1812241545CC6E9F50D0B4131CDFBF6B08122413B14DA82ED0D0B41042CA2CCB081224196A31C19E50D0B41A4703DCAB0812241B0726891E40D0B41F4FDD478A38122418FC2F5283E0B0B41B81E852B8F81224121B0726827070B41F2D24D227F812241986E1283EF030B41A8E52CF07E812241BDC3E510E7030B418957E5B57E812241B9B1FEA1DE030B41EA8A7A737E812241CD13DB36D6030B41F55EF0287E812241EA8BF8CFCD030B410E2C4BD67D812241847CD46DC5030B418DC38F7B7D8122414001EC10BD030B41796FC3187D812241B1E7BBB9B4030B4139F2EBAD7C81224108A8C068AC030B413D860F3B7C812241DA5D761EA4030B41A3DD34C07B812241DFC058DB9B030B41D021633D7B812241BF1DE39F93030B4107F3A1B27A812241DE4E906C8B030B41F967F91F7A81224139B5DA4183030B41DD2406C179812241EE7C3F357E030B41490D7285798122413E313C207B030B410EE514E378812241B11B2E0873030B414B66EB38788122419F3E29FA6A030B41657CFF86778122414CCEA5F662030B418D865BCD7681224138621BFE5A030B4124570A0C7681224120EE001153030B411B3317437581224114BBCC2F4B030B414CD18D72748122418F60F45A43030B41C8597A9A738122419CBDEC923B030B412565E9BA7281224108F229D833030B41BEFBE7D3718122419A571F2B2C030B41F69483E5708122415D7B3F8C24030B416A16CAEF6F812241F016FCFB1C030B4124D3C9F26E812241E509C67A15030B417F6ABCB46E812241E17A14AE13030B4123DBABAE6D812241DD7757400C030B41166576A16C812241392AA3E204030B4181B92B8D6B812241D07D6595FD020B415EF3DB716A81224186680B59F6020B416D96974F6981224139E4002EEF020B41338E6F266881224174E8B014E8020B410A2D75F6668122413164850DE1020B41122BBABF65812241B337E718DA020B4133A5508264812241602E3E37D3020B41091C4B3E63812241BDF8F068CC020B41CF72BCF3618122416A2665AEC5020B414BEEB7A2608122413C20FF07BF020B41A733514B5F8122415E222276B8020B412731086C5E812241F0A7C64BB4020B4154479CED5D8122418C3630F9B1020B41D78BAD895C8122415B2E8A91AB020B419EC0991F5B812241949D8F3FA5020B41CB0076AF598122419FD49E039F020B41F5C157395881224108DB14DE98020B41E9D254BD56812241126A4DCF92020B41695A833B558122415AE7A2D78C020B41DCD5F9B353812241985F6EF786020B41FF17CF26528122416A81072F81020B4194471A94508122413898C47E7B020B4105DEF2FB4E8122413087FAE675020B4108A6705E4D8122414DC4FC6770020B413ABAABBB4B8122417F531D026B020B41BA83BC134A812241E0C1ACB565020B41E5D0229B498122411D5A643B64020B418B6CE7FB938022411283C0CA37000B41FED478A9557F22413108AC1C68FC0A418C3D2CDF537F2241B33198AA62FC0A41B5E6E019527F2241CD9B931E5DFC0A411352AE59507F22416DC8E77857FC0A41B6B9AB9E4E7F2241BEA2DFB951FC0A41DC12F0E84C7F22415C66C7E14BFC0A41C30C92384B7F2241669BECF045FC0A41C1CAA1854A7F2241508D976E43FC0A41770FA88D497F224174129EE73FFC0A41AD3A48E8477F224184E02BC639FC0A419C648848467F2241D45AE78C33FC0A41D9187EAE447F2241AA12233C2DFC0A413D973E1A437F22410BD132D426FC0A41CAD2DE8B417F224168926B5520FC0A4175931844407F22412B8716D91AFC0A419259B7C03E7F2241CBEC113114FC0A4169A86F433D7F2241AF282E730DFC0A419D4755CC3B7F2241F292C49F06FC0A41F2A67B5B3A7F224118B72FB7FFFB0A4138E3F5F0387F22417839CBB9F8FB0A4153C5D68C377F224174D2F3A7F1FB0A41E3A59B04377F2241894160E5EEFB0A4139C1302F367F2241B2490782EAFB0A4107F515D8347F22413E716448E3FB0A410A289887337F22419D206BFBDBFB0A41D6C9C83D327F2241DB2F7C9BD4FB0A415DF1B8FA307F22418072F928CDFB0A410F5C79BE2F7F224186B245A4C5FB0A41AAF1D2CD2E7F2241295C8FC2BFFB0A41F4FDD438807E2241273108AC57F70A41F0A7C68B4C7E22418B6CE7FB0AF60A41560E2D32BA7D2241DBF97E6A51F20A415EBA498C507D2241CFF753E3A9EF0A41D578E926407D2241931804562DEF0A4146B6F3BDBB7C2241CDCCCCCC13EA0A41A245B6F3B97C2241D578E92602EA0A41');


--
-- TOC entry 2851 (class 0 OID 0)
-- Dependencies: 186
-- Name: perimeter_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('perimeter_id_seq', 1, true);


--
-- TOC entry 2802 (class 0 OID 19383)
-- Dependencies: 187
-- Data for Name: plankostenkonto; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO plankostenkonto (id, konto_id, budget, jahr, bemerkung) VALUES (1, 2, 400000.00, 2014, 'RADAV');
INSERT INTO plankostenkonto (id, konto_id, budget, jahr, bemerkung) VALUES (2, 1, 700000.00, 2014, 'Nachführung');
INSERT INTO plankostenkonto (id, konto_id, budget, jahr, bemerkung) VALUES (3, 1, 500000.00, 2013, 'Nachführung');


--
-- TOC entry 2852 (class 0 OID 0)
-- Dependencies: 188
-- Name: plankostenkonto_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('plankostenkonto_id_seq', 3, true);


--
-- TOC entry 2804 (class 0 OID 19391)
-- Dependencies: 189
-- Data for Name: planzahlung; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (80, 69, 20.000, 3200.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (81, 69, 80.000, 12800.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (73, 62, 100.000, 5900.00, 0, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (74, 63, 10.000, 4900.00, 0, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (79, 68, 100.000, 3800.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (77, 65, 100.000, 5600.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (78, 66, 100.000, 3600.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (75, 63, 90.000, 44100.00, 0, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (10, 12, 44.000, 87120.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (9, 12, 28.000, 55440.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (71, 60, 100.000, 6000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (72, 61, 100.000, 886.50, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (69, 59, 100.000, 500.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (68, 3, 25.000, 5032.50, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (27, 21, 100.000, 5000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (7, 4, 100.000, 211500.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (66, 57, 100.000, 4479.60, 0, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (67, 58, 100.000, 1200.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (8, 12, 28.000, 55440.00, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (83, 71, 100.000, 1365.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (84, 72, 100.000, 1815.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (85, 73, 100.000, 1680.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (86, 74, 100.000, 420.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (87, 75, 100.000, 1695.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (88, 76, 100.000, 143.15, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (89, 77, 100.000, 800.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (90, 78, 10.000, 3000.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (91, 78, 90.000, 27000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (44, 38, 100.000, 2080.60, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (45, 39, 100.000, 450.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (82, 70, 100.000, 5000.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (46, 40, 100.000, 750.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (47, 41, 100.000, 5335.20, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (48, 42, 100.000, 22000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (60, 48, 100.000, 35000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (57, 45, 33.000, 1805.76, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (58, 45, 67.000, 3666.24, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (11, 7, 100.000, 7325.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (12, 6, 100.000, 54305.10, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (70, 23, 100.000, 3000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (76, 64, 100.000, 320.00, 0, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (35, 29, 60.000, 69840.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (13, 8, 100.000, 10000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (14, 9, 100.000, 23574.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (15, 13, 100.000, 200000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (19, 15, 23.000, 989.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (20, 15, 77.000, 3311.00, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (17, 14, 77.000, 11396.00, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (36, 31, 100.000, 2150.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (5, 3, 75.000, 15097.50, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (37, 32, 100.000, 8000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (63, 56, 100.000, 800.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (40, 35, 10.000, 14700.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (41, 35, 90.000, 132300.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (61, 49, 90.000, 44100.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (62, 49, 10.000, 4900.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (59, 47, 100.000, 1400.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (56, 44, 100.000, 3000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (55, 43, 100.000, 2270.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (42, 36, 100.000, 501.60, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (29, 25, 100.000, 2300.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (3, 2, 100.000, 85600.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (30, 26, 100.000, 50000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (34, 29, 40.000, 46560.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (31, 27, 40.000, 56000.00, 8, 2015, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (32, 27, 60.000, 84000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (38, 33, 100.000, 620.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (39, 34, 100.000, 465.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (28, 24, 100.000, 2500.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (33, 28, 100.000, 36000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (1, 1, 90.000, 31536.00, 8, 2013, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (2, 1, 10.000, 3504.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (18, 14, 23.000, 3404.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (21, 16, 10.000, 500.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (22, 16, 90.000, 4500.00, 8, 2012, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (23, 17, 100.000, 10000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (24, 18, 100.000, 4600.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (25, 19, 100.000, 5000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (26, 20, 100.000, 5000.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (92, 79, 100.000, 1608.50, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (93, 67, 100.000, 1500.00, 8, 2014, NULL);
INSERT INTO planzahlung (id, auftrag_id, prozent, kosten, mwst, rechnungsjahr, bemerkung) VALUES (94, 80, 100.000, 1693.60, 8, 2014, NULL);


--
-- TOC entry 2853 (class 0 OID 0)
-- Dependencies: 190
-- Name: planzahlung_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('planzahlung_id_seq', 94, true);


--
-- TOC entry 2806 (class 0 OID 19400)
-- Dependencies: 191
-- Data for Name: projekt; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (1, 1, 'Fusion Buchegg (Zusammenführen der AV-Operate)', 35040.00, 8, '2013-10-03', NULL, '');
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (2, 2, 'Luftbildbefliegung und Orthofotoerstellung Kanton Solothurn (Teilgebiet West)', 85600.00, 8, '2014-01-01', NULL, '');
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (3, 1, 'Beratungsmandat lokale Spannungen', 20130.00, 8, '2012-09-03', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (5, 2, 'Schlusszahlungen RADAV-Operate', 95204.10, 8, '2014-01-01', NULL, 'Sammelprojekt für die ausstehenden Schlusszahlungen der RADAV-Operate. Verschiedene Gemeinden und verschiedene Unternehmer.

Achtung: LRO noch ergänzen!!!');
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (4, 1, 'Lidar-Befliegung Kanton Solothurn', 250000.00, 8, '2014-01-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (6, 2, 'LRO', 198000.00, 8, '2006-03-28', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (7, 2, 'Digitalisierung Nutzungspläne (2014)', 200000.00, 8, '2014-01-01', NULL, 'Budgetiert sind Fr. 300''000. Es ist davon auszugehen, dass im ersten Jahr nicht alles ausgeschöpft wird.

Anmerkung: Oder ein ''Projekt'' für das gesamte Projekt? In diesem Fall ist es ja von geringerem Interesse, da kein AGI-/AV-Projekt...');
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (8, 1, 'Bereinigung Kantonsgrenze SO - BL (Armin Weber)', 19100.00, 8, '2013-09-09', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (9, 1, 'Abgleich und Bereinigung der Liegenschafts- und Hoheitsgrenzen (Wasseramt)', 5000.00, 8, '2012-01-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (10, 1, 'Checkservice MOCHECKSO', 10000.00, 8, '2014-01-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (11, 1, 'Korrektur der Kantonsgrenze Schönenwerd SO - Unterentfelden AG', 4600.00, 8, '2013-12-16', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (12, 1, 'AVGBS-Workshop', 15000.00, 8, '2014-01-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (13, 1, 'Herkunft Flächendifferenzen eruieren', 6000.00, 8, '2013-11-18', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (14, 1, 'Abgleich und Bereinigung der Liegenschafts- und Hoheitsgrenzen - Zusatzauftrag (Wasseramt)', 2500.00, 8, '2014-01-21', '2014-04-30', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (15, 1, 'Operat-Einrichtung nach Datenübernahme von Ersterhebungsoperaten (Beinwil, Meltingen, Zullwil)', 2300.00, 8, '2014-01-21', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (17, 1, 'PNF/Homogenisierung Bucheggberg Etappe 2014-1', 170000.00, 8, '2014-02-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (18, 1, 'swipos-GIS/GEO', 10000.00, 8, '2013-01-01', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (19, 1, 'Berichtigungen Beinwil', 2000.00, 8, '2014-02-05', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (16, 1, 'PNF/Homogenisierung Wasseramt Etappe 2014-1', 190000.00, 8, '2014-01-15', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (20, 1, 'PNF/Homogenisierung Gäu Etappe 2014-1', 200000.00, 8, '2014-02-14', NULL, NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (21, 1, 'Berichtigung Breitenbach GB-Nr. 76, 77', 501.60, 8, '2014-02-17', '2014-02-28', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (22, 1, 'Abgleich und Bereinigung Liegenschafts- und Hoheitsgrenzen (Lebern ohne Grenchen u. Bettlach)', 5472.00, 8, '2011-12-22', '2014-05-19', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (23, 1, 'Bereinigung Gebäudegrundriss Dulliken GB-Nr. 277/755', 1400.00, 8, '2014-05-28', '2014-06-30', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (24, 1, 'Bereinigung der Differenzen zwischen Grundbuch und der amtlichen Vermessung (Thal / Gäu)', 4479.60, 8, '2014-06-24', '2014-07-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (25, 1, 'Bereinigung der Flächendifferenzen AV - GB (Wasseramt)', 5000.00, 8, '2014-06-30', '2014-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (26, 1, 'Umnummerierung 90''000er Grundstücke mit Index (Zullwil)', 500.00, 8, '2014-07-09', '2014-07-18', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (27, 1, 'Passpunkte- und Kontrollpunktmessung Drei Höfe', 6000.00, 8, '2014-07-15', '2014-09-30', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (28, 1, 'Umnummerierung der 90''000er mit Index (Lerch Weber AG)', 900.00, 8, '2014-07-01', '2014-07-18', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (29, 1, 'Passpunkt- und Kontrollpunktmessung Hessigkofen', 5900.00, 8, '2014-08-25', '2014-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (30, 1, 'Kreisbogen in Open Source GIS', 200000.00, 8, '2014-08-25', '2016-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (31, 1, 'Trimble Service', 10000.00, 8, '2014-08-25', '2017-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (32, 1, 'Abgleich Hoheits- und Liegenschaftsgrenzen Grenchen/Bettlach', 1500.00, 8, '2014-09-10', '2015-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (33, 1, 'Bezugsrahmenwechsel', 600000.00, 8, '2014-10-06', '2017-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (34, 1, 'Strassenachsen bereinigen (AVT)', 7000.00, 8, '2014-10-06', '2014-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (35, 1, 'Ergänzung Mutationsplan mit öffentlichen Grundstücksnummern', 5000.00, 8, '2014-10-07', '2014-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (36, 1, 'PNF/Homogenisierung Grenchen/Bettlach Etappe 2014-1', 150000.00, 8, '2014-10-13', '2014-10-13', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (37, 1, 'Einführung Capitastra', 6000.00, 8, '2014-10-29', '2015-12-31', NULL);
INSERT INTO projekt (id, konto_id, name, kosten, mwst, datum_start, datum_ende, bemerkung) VALUES (38, 1, 'Berichtigungen Erschwil', 1693.60, 8, '2014-11-05', '2014-11-05', NULL);


--
-- TOC entry 2854 (class 0 OID 0)
-- Dependencies: 192
-- Name: projekt_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('projekt_id_seq', 38, true);


--
-- TOC entry 2808 (class 0 OID 19408)
-- Dependencies: 193
-- Data for Name: rechnung; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (2, 1, 30660.00, 8, '2014-01-13', '2014-01-13', 2013, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (1, 3, 5000.00, 8, '2014-01-14', '2014-01-15', 2013, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (3, 12, 54796.50, 8, '2014-01-14', '2014-01-14', 2013, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (5, 14, 11473.30, 8, '2014-01-20', '2014-01-20', 2013, 'Hoffentlich reichts noch für Rechnungsjahr 2013.
Gemeinsame Rechung für Auftrag und Zusatzauftrag. -> Gesplittet für Geschäftskontrolle.');
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (6, 15, 3333.45, 8, '2014-01-20', '2014-01-20', 2013, 'Hoffentlich reichts für 2013.
Gemeinsame Rechnung für Auftrag und Zusatzauftrag. -> Gesplittet für Geschäftskontrolle.');
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (7, 16, 4500.00, 8, '2012-10-29', '2012-10-29', 2012, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (8, 22, 1187.50, 8, '2013-11-26', '2013-11-26', 2013, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (10, 25, 2300.00, 8, '2014-01-28', '2014-01-28', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (11, 31, 2150.00, 8, '2014-01-29', '2014-01-29', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (12, 7, 7325.00, 8, '2013-12-02', '2014-02-05', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (13, 33, 620.00, 8, '2014-02-14', '2014-02-14', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (14, 34, 465.00, 8, '2014-02-14', '2014-02-14', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (15, 36, 501.60, 8, '2014-03-10', '2014-03-10', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (16, 20, 1650.00, 8, '2014-03-19', '2014-03-24', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (17, 38, 2080.60, 8, '2014-03-19', '2014-03-24', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (18, 39, 380.50, 8, '2014-04-07', '2014-04-07', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (19, 14, 2719.40, 8, '2014-04-07', '2014-04-07', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (20, 15, 790.10, 8, '2014-04-07', '2014-04-07', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (21, 22, 1919.00, 8, '2014-04-08', '2014-04-08', 2014, 'Kostendach wird leicht überschritten. Kein Problem, da eigentlich sowas wie eine "Dauerauftrag".');
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (23, 45, 1824.00, 8, '2014-05-08', '2014-05-19', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (24, 45, 3648.95, 8, '2013-03-26', '2013-07-11', 2013, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (25, 28, 32400.00, 8, '2014-05-02', '2014-05-19', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (26, 26, 26606.25, 8, '2014-04-16', '2014-04-16', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (27, 19, 3956.00, 8, '2014-04-25', '2014-05-19', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (28, 4, 105750.00, 8, '2014-04-28', '2014-05-19', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (29, 43, 2270.00, 8, '2014-04-29', '2014-05-19', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (30, 2, 25600.00, 8, '2014-06-03', '2015-06-03', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (31, 42, 22000.00, 8, '2014-05-26', '2014-05-27', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (32, 20, 1102.00, 0, '2014-05-28', '2014-05-28', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (33, 16, 500.00, 8, '2014-06-06', '2014-06-12', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (34, 24, 2500.00, 8, '2014-06-12', '2014-06-12', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (35, 41, 5335.20, 8, '2014-06-17', '2014-06-24', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (36, 56, 800.00, 8, '2014-06-24', '2014-06-24', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (37, 18, 4093.25, 0, '2014-06-11', '2014-06-26', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (38, 40, 733.30, 8, '2014-06-26', '2014-06-30', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (39, 57, 4294.75, 8, '2014-07-01', '2014-07-02', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (40, 17, 10000.00, 8, '2014-01-31', '2014-01-31', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (41, 49, 10530.00, 8, '2014-07-04', '2014-07-04', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (42, 48, 29293.25, 8, '2014-07-04', '2014-07-04', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (43, 3, 12442.00, 8, '2014-07-04', '2014-07-04', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (44, 2, 17120.00, 8, '2014-07-04', '2014-07-07', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (45, 58, 1200.00, 8, '2014-07-08', '2014-07-08', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (46, 47, 588.60, 8, '2014-07-08', '2014-07-08', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (47, 26, 18393.75, 8, '2014-07-10', '2014-07-10', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (48, 23, 2992.50, 8, '2014-07-10', '2014-07-11', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (49, 12, 36992.25, 8, '2014-07-11', '2014-07-14', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (50, 61, 886.50, 8, '2014-07-17', '2014-07-17', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (51, 4, 42300.00, 8, '2014-08-04', '2014-08-05', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (52, 48, 1647.25, 8, '2014-07-25', '2014-08-05', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (53, 64, 320.00, 8, '2014-08-25', '2014-08-25', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (54, 26, 5000.00, 8, '2014-09-02', '2014-09-02', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (55, 2, 34240.00, 8, '2014-09-02', '2014-09-02', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (56, 60, 5734.00, 8, '2014-10-01', '2014-10-06', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (57, 68, 3762.00, 8, '2014-10-06', '2014-10-06', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (58, 2, 8560.00, 8, '2014-10-06', '2014-10-06', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (59, 59, 500.00, 8, '2014-10-06', '2014-10-06', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (60, 32, 8000.00, 8, '2014-10-06', '2014-10-06', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (61, 65, 5600.00, 8, '2014-10-06', '2014-10-06', 2014, '1 Rechnung (13''600.-)');
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (62, 76, 143.15, 8, '2014-10-07', '2014-10-07', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (63, 77, 1050.00, 8, '2014-10-24', '2014-10-24', 2014, 'Zu Pauschale kommt noch pro rata eines neuen Datenmodells.');
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (64, 79, 1608.50, 8, '2014-10-28', '2014-10-29', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (65, 67, 1500.00, 8, '2014-10-16', '2014-11-03', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (66, 71, 1365.00, 8, '2014-10-14', '2014-11-03', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (67, 74, 420.00, 8, '2014-10-09', '2014-11-03', 2014, NULL);
INSERT INTO rechnung (id, auftrag_id, kosten, mwst, datum_eingang, datum_ausgang, rechnungsjahr, bemerkung) VALUES (68, 80, 1693.60, 8, '2014-11-05', '2014-11-05', 2014, NULL);


--
-- TOC entry 2855 (class 0 OID 0)
-- Dependencies: 194
-- Name: rechnung_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('rechnung_id_seq', 68, true);


--
-- TOC entry 2810 (class 0 OID 19416)
-- Dependencies: 195
-- Data for Name: rechnungsjahr; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO rechnungsjahr (id, jahr) VALUES (2, 2013);
INSERT INTO rechnungsjahr (id, jahr) VALUES (3, 2014);
INSERT INTO rechnungsjahr (id, jahr) VALUES (4, 2015);
INSERT INTO rechnungsjahr (id, jahr) VALUES (5, 2016);
INSERT INTO rechnungsjahr (id, jahr) VALUES (6, 2017);
INSERT INTO rechnungsjahr (id, jahr) VALUES (7, 2012);


--
-- TOC entry 2856 (class 0 OID 0)
-- Dependencies: 196
-- Name: rechnungsjahr_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('rechnungsjahr_id_seq', 7, true);


--
-- TOC entry 2812 (class 0 OID 19421)
-- Dependencies: 197
-- Data for Name: unternehmer; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (1, 'W+H AG', NULL, 'Meile', 'Reto', 'Blümlisalpstrasse ', '6', 4562, 'Biberist', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (2, 'BSB + Partner, Ingenieure und Planer', NULL, 'Schor', 'Urs', 'Von Roll-Strasse', '29', 4702, 'Oensingen', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (3, 'Emch + Berger AG Vermessungen', NULL, 'Cantaluppi', 'Dominik', 'Schöngrünstrasse ', '35', 4500, 'Solothurn', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (4, 'BSF Swissphoto', NULL, 'Stengele', 'Roland', 'Dorfstrasse', '53', 8105, 'Regensdorf-Watt', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (5, 'Submission', NULL, 'Submission', 'Submission', NULL, NULL, NULL, NULL, NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (6, 'Einladung', NULL, 'Einladung', 'Einladung', NULL, NULL, NULL, NULL, NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (7, 'Geocad + Partner AG', NULL, 'Tschudin', 'Peter', 'Gitterlistrasse', '5', 4410, 'Liestal', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (8, 'Platzhalter', NULL, 'Platzhalter', 'Platzhalter', NULL, NULL, NULL, NULL, NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (9, 'Lerch Weber AG', NULL, 'Weber', 'Armin', 'Einschlagweg', '47', 4632, 'Trimbach', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (10, 'Infogrips GmbH', NULL, 'Infogrips', 'Infogrips', 'Technostrasse', '1', 8005, 'Zürich', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (11, 'Sutter Ingenieur- und Planungsbüro AG', NULL, 'Kägi', 'Dominik', 'Grellingerstrasse', '21', 4208, 'Nunningen', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (12, 'allnav ag', NULL, 'FRE', 'FRE', 'Ahornweg', '5a', 5504, 'Othmarsingen', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (13, 'BSB + Partner, Ingenieure und Planer', NULL, 'Kohli', 'Alexander', 'Dammstrasse', '14', 2540, 'Grenchen', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (14, 'Sourcepole AG', NULL, 'Hugentobler', 'Marco', 'Weberstrasse', '5', 8004, 'Zürich', NULL);
INSERT INTO unternehmer (id, firma, uid, nachname, vorname, strasse, hausnummer, plz, ortschaft, bemerkung) VALUES (15, 'Eisenhut Informatik AG', NULL, 'Eisenhut', 'Claude', 'Kirchbergstrasse', '107', 3401, 'Burgdorf', NULL);


--
-- TOC entry 2857 (class 0 OID 0)
-- Dependencies: 198
-- Name: unternehmer_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('unternehmer_id_seq', 15, true);


--
-- TOC entry 2814 (class 0 OID 19429)
-- Dependencies: 199
-- Data for Name: verguetungsart; Type: TABLE DATA; Schema: av_geschaeftskontrolle; Owner: stefan
--

INSERT INTO verguetungsart (id, art) VALUES (1, 'Kostendach');
INSERT INTO verguetungsart (id, art) VALUES (2, 'pauschal');
INSERT INTO verguetungsart (id, art) VALUES (3, 'effektive Elemente');


--
-- TOC entry 2858 (class 0 OID 0)
-- Dependencies: 200
-- Name: verguetungsart_id_seq; Type: SEQUENCE SET; Schema: av_geschaeftskontrolle; Owner: stefan
--

SELECT pg_catalog.setval('verguetungsart_id_seq', 3, true);


--
-- TOC entry 2643 (class 2606 OID 19478)
-- Name: amo_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY amo
    ADD CONSTRAINT amo_pkey PRIMARY KEY (id);


--
-- TOC entry 2645 (class 2606 OID 19480)
-- Name: auftrag_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY auftrag
    ADD CONSTRAINT auftrag_pkey PRIMARY KEY (id);


--
-- TOC entry 2647 (class 2606 OID 19482)
-- Name: konto_nr_key; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY konto
    ADD CONSTRAINT konto_nr_key UNIQUE (id, nr);


--
-- TOC entry 2649 (class 2606 OID 19484)
-- Name: konto_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY konto
    ADD CONSTRAINT konto_pkey PRIMARY KEY (id);


--
-- TOC entry 2651 (class 2606 OID 19486)
-- Name: perimeter_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY perimeter
    ADD CONSTRAINT perimeter_pkey PRIMARY KEY (id);


--
-- TOC entry 2653 (class 2606 OID 19488)
-- Name: plankostenkonto_konto_id_jahr_key; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY plankostenkonto
    ADD CONSTRAINT plankostenkonto_konto_id_jahr_key UNIQUE (konto_id, jahr);


--
-- TOC entry 2655 (class 2606 OID 19490)
-- Name: plankostenkonto_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY plankostenkonto
    ADD CONSTRAINT plankostenkonto_pkey PRIMARY KEY (id);


--
-- TOC entry 2657 (class 2606 OID 19492)
-- Name: planzahlung_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY planzahlung
    ADD CONSTRAINT planzahlung_pkey PRIMARY KEY (id);


--
-- TOC entry 2659 (class 2606 OID 19494)
-- Name: projekt_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY projekt
    ADD CONSTRAINT projekt_pkey PRIMARY KEY (id);


--
-- TOC entry 2661 (class 2606 OID 19496)
-- Name: rechnung_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY rechnung
    ADD CONSTRAINT rechnung_pkey PRIMARY KEY (id);


--
-- TOC entry 2663 (class 2606 OID 19498)
-- Name: unternehmer_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY unternehmer
    ADD CONSTRAINT unternehmer_pkey PRIMARY KEY (id);


--
-- TOC entry 2665 (class 2606 OID 19500)
-- Name: verguetungsart_pkey; Type: CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan; Tablespace: 
--

ALTER TABLE ONLY verguetungsart
    ADD CONSTRAINT verguetungsart_pkey PRIMARY KEY (id);


--
-- TOC entry 2791 (class 2618 OID 19501)
-- Name: _RETURN; Type: RULE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE RULE "_RETURN" AS
    ON SELECT TO vr_kontr_planprozent DO INSTEAD  SELECT a.name AS auf_name,
    d.firma,
    b.name AS proj_name,
    c.nr AS konto_nr,
    a.sum_planprozent
   FROM ( SELECT sum(pz.kosten) AS sum_plankosten_exkl,
            auf.name,
            sum(pz.prozent) AS sum_planprozent,
            auf.projekt_id,
            auf.unternehmer_id
           FROM planzahlung pz,
            auftrag auf,
            projekt proj
          WHERE ((((pz.auftrag_id = auf.id) AND (auf.projekt_id = proj.id)) AND (auf.datum_abschluss IS NULL)) OR (btrim((auf.datum_abschluss)::text, ''::text) = ''::text))
          GROUP BY auf.id) a,
    projekt b,
    konto c,
    unternehmer d
  WHERE (((a.projekt_id = b.id) AND (c.id = b.konto_id)) AND (a.unternehmer_id = d.id))
  ORDER BY b.name, a.name;


--
-- TOC entry 2792 (class 2618 OID 19503)
-- Name: _RETURN; Type: RULE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE RULE "_RETURN" AS
    ON SELECT TO vr_zahlungsplan_14_17 DO INSTEAD  SELECT foo.auf_name,
    foo.auf_geplant,
    proj.name AS proj_name,
    konto.nr AS konto,
    foo.auf_start,
    foo.auf_ende,
    foo.auf_abschluss,
    foo.plan_summe_a,
    foo.plan_prozent_a,
    foo.re_summe_a,
    ((foo.re_summe_a / foo.auf_summe) * (100)::double precision) AS re_prozent_a,
    foo.plan_summe_b,
    foo.plan_prozent_b,
    foo.plan_summe_c,
    foo.plan_prozent_c,
    foo.plan_summe_d,
    foo.plan_prozent_d,
    foo.a_id,
    foo.projekt_id
   FROM ( SELECT a.auf_name,
            a.auf_geplant,
            a.auf_start,
            a.auf_ende,
            a.auf_abschluss,
            a.auf_summe,
            a.plan_summe_a,
            a.plan_prozent_a,
            a.a_id,
            a.projekt_id,
            r.re_summe_a,
            r.r_id,
            b.plan_summe_b,
            b.plan_prozent_b,
            b.b_id,
            c.plan_summe_c,
            c.plan_prozent_c,
            c.c_id,
            d.plan_summe_d,
            d.plan_prozent_d,
            d.d_id
           FROM ((((( SELECT auf.name AS auf_name,
                    auf.geplant AS auf_geplant,
                    auf.datum_start AS auf_start,
                    auf.datum_ende AS auf_ende,
                    auf.datum_abschluss AS auf_abschluss,
                    ((auf.kosten)::double precision * ((1)::double precision + (auf.mwst / (100)::double precision))) AS auf_summe,
                    sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_a,
                    sum(pz.prozent) AS plan_prozent_a,
                    auf.id AS a_id,
                    auf.projekt_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2014))
                  GROUP BY auf.id) a
             LEFT JOIN ( SELECT sum(((re.kosten)::double precision * ((1)::double precision + (re.mwst / (100)::double precision)))) AS re_summe_a,
                    auf.id AS r_id
                   FROM rechnung re,
                    auftrag auf
                  WHERE ((re.auftrag_id = auf.id) AND (re.rechnungsjahr = 2014))
                  GROUP BY auf.id) r ON ((a.a_id = r.r_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_b,
                    sum(pz.prozent) AS plan_prozent_b,
                    auf.id AS b_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2015))
                  GROUP BY auf.id) b ON ((a.a_id = b.b_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_c,
                    sum(pz.prozent) AS plan_prozent_c,
                    auf.id AS c_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2016))
                  GROUP BY auf.id) c ON ((a.a_id = c.c_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_d,
                    sum(pz.prozent) AS plan_prozent_d,
                    auf.id AS d_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2017))
                  GROUP BY auf.id) d ON ((a.a_id = d.d_id)))) foo,
    projekt proj,
    konto konto
  WHERE ((foo.projekt_id = proj.id) AND (proj.konto_id = konto.id))
  ORDER BY konto.nr, foo.auf_name;


--
-- TOC entry 2793 (class 2618 OID 19505)
-- Name: _RETURN; Type: RULE; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE RULE "_RETURN" AS
    ON SELECT TO vr_zahlungsplan_13_16 DO INSTEAD  SELECT foo.auf_name,
    foo.auf_geplant,
    proj.name AS proj_name,
    konto.nr AS konto,
    foo.auf_start,
    foo.auf_ende,
    foo.auf_abschluss,
    foo.plan_summe_a,
    foo.plan_prozent_a,
    foo.re_summe_a,
    ((foo.re_summe_a / foo.auf_summe) * (100)::double precision) AS re_prozent_a,
    foo.plan_summe_b,
    foo.plan_prozent_b,
    foo.plan_summe_c,
    foo.plan_prozent_c,
    foo.plan_summe_d,
    foo.plan_prozent_d,
    foo.a_id,
    foo.projekt_id
   FROM ( SELECT a.auf_name,
            a.auf_geplant,
            a.auf_start,
            a.auf_ende,
            a.auf_abschluss,
            a.auf_summe,
            a.plan_summe_a,
            a.plan_prozent_a,
            a.a_id,
            a.projekt_id,
            r.re_summe_a,
            r.r_id,
            b.plan_summe_b,
            b.plan_prozent_b,
            b.b_id,
            c.plan_summe_c,
            c.plan_prozent_c,
            c.c_id,
            d.plan_summe_d,
            d.plan_prozent_d,
            d.d_id
           FROM ((((( SELECT auf.name AS auf_name,
                    auf.geplant AS auf_geplant,
                    auf.datum_start AS auf_start,
                    auf.datum_ende AS auf_ende,
                    auf.datum_abschluss AS auf_abschluss,
                    ((auf.kosten)::double precision * ((1)::double precision + (auf.mwst / (100)::double precision))) AS auf_summe,
                    sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_a,
                    sum(pz.prozent) AS plan_prozent_a,
                    auf.id AS a_id,
                    auf.projekt_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2013))
                  GROUP BY auf.id) a
             LEFT JOIN ( SELECT sum(((re.kosten)::double precision * ((1)::double precision + (re.mwst / (100)::double precision)))) AS re_summe_a,
                    auf.id AS r_id
                   FROM rechnung re,
                    auftrag auf
                  WHERE ((re.auftrag_id = auf.id) AND (re.rechnungsjahr = 2013))
                  GROUP BY auf.id) r ON ((a.a_id = r.r_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_b,
                    sum(pz.prozent) AS plan_prozent_b,
                    auf.id AS b_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2014))
                  GROUP BY auf.id) b ON ((a.a_id = b.b_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_c,
                    sum(pz.prozent) AS plan_prozent_c,
                    auf.id AS c_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2015))
                  GROUP BY auf.id) c ON ((a.a_id = c.c_id)))
             LEFT JOIN ( SELECT sum(((pz.kosten)::double precision * ((1)::double precision + (pz.mwst / (100)::double precision)))) AS plan_summe_d,
                    sum(pz.prozent) AS plan_prozent_d,
                    auf.id AS d_id
                   FROM planzahlung pz,
                    auftrag auf
                  WHERE ((pz.auftrag_id = auf.id) AND (pz.rechnungsjahr = 2016))
                  GROUP BY auf.id) d ON ((a.a_id = d.d_id)))) foo,
    projekt proj,
    konto konto
  WHERE ((foo.projekt_id = proj.id) AND (proj.konto_id = konto.id))
  ORDER BY konto.nr, foo.auf_name;


--
-- TOC entry 2676 (class 2620 OID 19507)
-- Name: update_kosten; Type: TRIGGER; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE TRIGGER update_kosten BEFORE INSERT OR UPDATE ON planzahlung FOR EACH ROW EXECUTE PROCEDURE calculate_order_costs_from_percentage();


--
-- TOC entry 2675 (class 2620 OID 19508)
-- Name: update_planzahlungskosten; Type: TRIGGER; Schema: av_geschaeftskontrolle; Owner: stefan
--

CREATE TRIGGER update_planzahlungskosten AFTER UPDATE ON auftrag FOR EACH ROW EXECUTE PROCEDURE calculate_budget_payment_from_total_cost();


--
-- TOC entry 2666 (class 2606 OID 19509)
-- Name: amo_auftrag_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY amo
    ADD CONSTRAINT amo_auftrag_id_fkey FOREIGN KEY (auftrag_id) REFERENCES auftrag(id) MATCH FULL;


--
-- TOC entry 2667 (class 2606 OID 19514)
-- Name: auftrag_projekt_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY auftrag
    ADD CONSTRAINT auftrag_projekt_id_fkey FOREIGN KEY (projekt_id) REFERENCES projekt(id) MATCH FULL;


--
-- TOC entry 2668 (class 2606 OID 19519)
-- Name: auftrag_unternehmer_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY auftrag
    ADD CONSTRAINT auftrag_unternehmer_id_fkey FOREIGN KEY (unternehmer_id) REFERENCES unternehmer(id) MATCH FULL;


--
-- TOC entry 2669 (class 2606 OID 19524)
-- Name: auftrag_verguetungsart_id; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY auftrag
    ADD CONSTRAINT auftrag_verguetungsart_id FOREIGN KEY (verguetungsart_id) REFERENCES verguetungsart(id) MATCH FULL;


--
-- TOC entry 2670 (class 2606 OID 19529)
-- Name: perimeter_projekt_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY perimeter
    ADD CONSTRAINT perimeter_projekt_id_fkey FOREIGN KEY (projekt_id) REFERENCES projekt(id) MATCH FULL;


--
-- TOC entry 2671 (class 2606 OID 19534)
-- Name: plankostenkonto_konto_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY plankostenkonto
    ADD CONSTRAINT plankostenkonto_konto_id_fkey FOREIGN KEY (konto_id) REFERENCES konto(id) MATCH FULL;


--
-- TOC entry 2672 (class 2606 OID 19539)
-- Name: planzahlung_projekt_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY planzahlung
    ADD CONSTRAINT planzahlung_projekt_id_fkey FOREIGN KEY (auftrag_id) REFERENCES auftrag(id) MATCH FULL;


--
-- TOC entry 2673 (class 2606 OID 19544)
-- Name: projekt_konto_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY projekt
    ADD CONSTRAINT projekt_konto_id_fkey FOREIGN KEY (konto_id) REFERENCES konto(id) MATCH FULL;


--
-- TOC entry 2674 (class 2606 OID 19549)
-- Name: rechnung_auftrag_id_fkey; Type: FK CONSTRAINT; Schema: av_geschaeftskontrolle; Owner: stefan
--

ALTER TABLE ONLY rechnung
    ADD CONSTRAINT rechnung_auftrag_id_fkey FOREIGN KEY (auftrag_id) REFERENCES auftrag(id) MATCH FULL;


--
-- TOC entry 2820 (class 0 OID 0)
-- Dependencies: 8
-- Name: av_geschaeftskontrolle; Type: ACL; Schema: -; Owner: stefan
--

REVOKE ALL ON SCHEMA av_geschaeftskontrolle FROM PUBLIC;
REVOKE ALL ON SCHEMA av_geschaeftskontrolle FROM stefan;
GRANT ALL ON SCHEMA av_geschaeftskontrolle TO stefan;


--
-- TOC entry 2821 (class 0 OID 0)
-- Dependencies: 179
-- Name: amo; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE amo FROM PUBLIC;
REVOKE ALL ON TABLE amo FROM stefan;
GRANT ALL ON TABLE amo TO stefan;
GRANT SELECT ON TABLE amo TO mspublic;


--
-- TOC entry 2824 (class 0 OID 0)
-- Dependencies: 183
-- Name: konto; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE konto FROM PUBLIC;
REVOKE ALL ON TABLE konto FROM stefan;
GRANT ALL ON TABLE konto TO stefan;
GRANT SELECT ON TABLE konto TO mspublic;


--
-- TOC entry 2827 (class 0 OID 0)
-- Dependencies: 187
-- Name: plankostenkonto; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE plankostenkonto FROM PUBLIC;
REVOKE ALL ON TABLE plankostenkonto FROM stefan;
GRANT ALL ON TABLE plankostenkonto TO stefan;
GRANT SELECT ON TABLE plankostenkonto TO mspublic;


--
-- TOC entry 2831 (class 0 OID 0)
-- Dependencies: 189
-- Name: planzahlung; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE planzahlung FROM PUBLIC;
REVOKE ALL ON TABLE planzahlung FROM stefan;
GRANT ALL ON TABLE planzahlung TO stefan;
GRANT SELECT ON TABLE planzahlung TO mspublic;


--
-- TOC entry 2834 (class 0 OID 0)
-- Dependencies: 191
-- Name: projekt; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE projekt FROM PUBLIC;
REVOKE ALL ON TABLE projekt FROM stefan;
GRANT ALL ON TABLE projekt TO stefan;
GRANT SELECT ON TABLE projekt TO mspublic;


--
-- TOC entry 2841 (class 0 OID 0)
-- Dependencies: 199
-- Name: verguetungsart; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE verguetungsart FROM PUBLIC;
REVOKE ALL ON TABLE verguetungsart FROM stefan;
GRANT ALL ON TABLE verguetungsart TO stefan;
GRANT SELECT ON TABLE verguetungsart TO mspublic;


--
-- TOC entry 2843 (class 0 OID 0)
-- Dependencies: 201
-- Name: vr_firma_verpflichtungen; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE vr_firma_verpflichtungen FROM PUBLIC;
REVOKE ALL ON TABLE vr_firma_verpflichtungen FROM stefan;
GRANT ALL ON TABLE vr_firma_verpflichtungen TO stefan;
GRANT SELECT ON TABLE vr_firma_verpflichtungen TO mspublic;


--
-- TOC entry 2844 (class 0 OID 0)
-- Dependencies: 202
-- Name: vr_kontr_planprozent; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE vr_kontr_planprozent FROM PUBLIC;
REVOKE ALL ON TABLE vr_kontr_planprozent FROM stefan;
GRANT ALL ON TABLE vr_kontr_planprozent TO stefan;
GRANT SELECT ON TABLE vr_kontr_planprozent TO mspublic;


--
-- TOC entry 2845 (class 0 OID 0)
-- Dependencies: 203
-- Name: vr_laufende_auftraege; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE vr_laufende_auftraege FROM PUBLIC;
REVOKE ALL ON TABLE vr_laufende_auftraege FROM stefan;
GRANT ALL ON TABLE vr_laufende_auftraege TO stefan;
GRANT SELECT ON TABLE vr_laufende_auftraege TO mspublic;


--
-- TOC entry 2846 (class 0 OID 0)
-- Dependencies: 204
-- Name: vr_zahlungsplan_13_16; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE vr_zahlungsplan_13_16 FROM PUBLIC;
REVOKE ALL ON TABLE vr_zahlungsplan_13_16 FROM stefan;
GRANT ALL ON TABLE vr_zahlungsplan_13_16 TO stefan;
GRANT SELECT ON TABLE vr_zahlungsplan_13_16 TO mspublic;


--
-- TOC entry 2847 (class 0 OID 0)
-- Dependencies: 205
-- Name: vr_zahlungsplan_14_17; Type: ACL; Schema: av_geschaeftskontrolle; Owner: stefan
--

REVOKE ALL ON TABLE vr_zahlungsplan_14_17 FROM PUBLIC;
REVOKE ALL ON TABLE vr_zahlungsplan_14_17 FROM stefan;
GRANT ALL ON TABLE vr_zahlungsplan_14_17 TO stefan;
GRANT SELECT ON TABLE vr_zahlungsplan_14_17 TO mspublic;


-- Completed on 2014-11-05 11:43:47 CET

--
-- PostgreSQL database dump complete
--

