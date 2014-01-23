-- Verifikation:
-- Aufträge ohne Ende-Datum
-- Aufträge ohne Planzahlungen


-- to_char(12454.8, E'999\'999\'999\'999D99S')

-- Alle laufenden Projekte.
-- Projekte ohne 'datum_ende'

/*
SELECT proj.*, konto.nr, konto."name" 
FROM av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto
WHERE konto.id = proj.konto_id
AND datum_ende IS NULL or trim('' from datum_ende::text) = ''
ORDER BY datum_start, proj."name";
*/

-- Finanzbedarf für das Jahr XXXX
/*
SELECT a.*, b."name"
FROM
(
 SELECT sum(pz.kosten), auf."name", sum(pz.prozent), auf.projekt_id
 FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf, 
      av_geschaeftskontrolle.projekt as proj 
 WHERE pz.auftrag_id = auf.id
 AND auf.projekt_id = proj.id
 AND rechnungsjahr = 2014
 GROUP BY auf.id
) as a, av_geschaeftskontrolle.projekt as b
WHERE a.projekt_id = b.id
ORDER BY b."name", a."name"
*/

-- IDEE: auch geglieder nach Konto, so entspricht summe - differenz dem was ich noch zur verfügung habe.

/*
SELECT *
FROM
(
SELECT c.nr, c."name", a.*, b."name"
FROM
(
 SELECT sum(pz.kosten), auf."name", sum(pz.prozent), auf.id, auf.projekt_id
 FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf, 
      av_geschaeftskontrolle.projekt as proj 
 WHERE pz.auftrag_id = auf.id
 AND auf.projekt_id = proj.id
 AND rechnungsjahr = 2014
 GROUP BY auf.id
) as a, av_geschaeftskontrolle.projekt as b, av_geschaeftskontrolle.konto as c
WHERE a.projekt_id = b.id
AND b.konto_id = c.id
ORDER BY b."name", a."name"
) as x LEFT JOIN 
(
SELECT c.nr, c."name", a.*, b."name"
FROM
(
 SELECT sum(pz.kosten), auf."name", sum(pz.prozent), auf.id, auf.projekt_id
 FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf, 
      av_geschaeftskontrolle.projekt as proj 
 WHERE pz.auftrag_id = auf.id
 AND auf.projekt_id = proj.id
 AND rechnungsjahr = 2015
 GROUP BY auf.id
) as a, av_geschaeftskontrolle.projekt as b, av_geschaeftskontrolle.konto as c
WHERE a.projekt_id = b.id
AND b.konto_id = c.id
ORDER BY b."name", a."name"
) as y ON (y.id = x.id)
*/


/*
-- laufende Aufträge
--DROP VIEW av_geschaeftskontrolle.vr_laufende_auftraege;

CREATE OR REPLACE VIEW av_geschaeftskontrolle.vr_laufende_auftraege AS 

SELECT * 
FROM
(
 SELECT a.auf_id, a.auftrag_name, a.firma, a.geplant, a.proj_id, a.projekt_name, a.konto, a.datum_start, a.datum_ende, v.verguetungsart, a.kosten_exkl, a.mwst, a.kosten_inkl, a.bezahlt, a.ausstehend
 FROM
 (
  SELECT auftrag.*, rechnung.bezahlt, (auftrag.kosten_inkl - CASE WHEN rechnung.bezahlt IS NULL THEN 0 ELSE rechnung.bezahlt END) as ausstehend
  FROM
  (
   SELECT auf.id as auf_id, auf."name" as auftrag_name, u.firma as firma, auf.geplant, auf.verguetungsart_id, proj.id as proj_id, proj."name" as projekt_name, konto.nr::text as konto, auf.datum_start, auf.datum_ende, auf.kosten as kosten_exkl, auf.mwst, (auf.kosten * (1 + auf.mwst / 100)) as kosten_inkl
   FROM av_geschaeftskontrolle.auftrag as auf, av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto, 
        av_geschaeftskontrolle.unternehmer as u
   WHERE auf.projekt_id = proj.id
   AND proj.konto_id = konto.id
   AND auf.unternehmer_id = u.id
   AND auf.datum_abschluss IS NULL or trim('' from datum_abschluss::text) = ''
   --ORDER BY auf.datum_start, auf."name"
  ) as auftrag LEFT JOIN
  (
   SELECT sum(kosten * (1 + mwst / 100)) as bezahlt, auftrag_id
   FROM av_geschaeftskontrolle.rechnung
   GROUP BY auftrag_id
  ) as rechnung ON (rechnung.auftrag_id = auftrag.auf_id)
 ) as a LEFT JOIN
 (
  SELECT id, art as verguetungsart
  FROM av_geschaeftskontrolle.verguetungsart
 ) as v ON (a.verguetungsart_id = v.id)
) as af LEFT JOIN
(
 SELECT auftrag_id as id_auftrag, array_to_string(array_agg(amo_nr), ', ') as amo_nr
 FROM 
 (
  SELECT *
  FROM av_geschaeftskontrolle.amo
  ORDER BY amo_nr
 ) as ao
 GROUP BY auftrag_id
) as am ON (af.auf_id = am.id_auftrag)
ORDER BY af.datum_start, af.auftrag_name;

GRANT ALL ON TABLE av_geschaeftskontrolle.vr_laufende_auftraege TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.vr_laufende_auftraege TO mspublic;
*/

--DROP VIEW av_geschaeftskontrolle.vr_zahlungsplan_14_17;
/*
CREATE OR REPLACE VIEW av_geschaeftskontrolle.vr_zahlungsplan_14_17 AS 

SELECT auf_name, auf_geplant, proj."name" as proj_name, konto."nr" as konto, auf_start, auf_ende, auf_abschluss, plan_summe_a, plan_prozent_a, re_summe_a, (re_summe_a / auf_summe) * 100 as re_prozent_a,  plan_summe_b, plan_prozent_b, plan_summe_c, plan_prozent_c, plan_summe_d, plan_prozent_d, a_id, projekt_id
FROM
(
 SELECT *
 FROM
 (
  SELECT auf."name" as auf_name, auf.geplant as auf_geplant, auf.datum_start as auf_start, auf.datum_ende as auf_ende, auf.datum_abschluss as auf_abschluss, (auf.kosten * (1 + (auf.mwst/100))) as auf_summe, sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_a, sum(pz.prozent) as plan_prozent_a, auf.id as a_id, auf.projekt_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2014
  GROUP BY auf.id
 ) as a LEFT JOIN
 (
  SELECT sum(re.kosten * (1 + (re.mwst/100))) as re_summe_a, auf.id as r_id
  FROM av_geschaeftskontrolle.rechnung as re, av_geschaeftskontrolle.auftrag as auf
  WHERE re.auftrag_id = auf.id
  AND re.rechnungsjahr = 2014
  GROUP BY auf.id
 ) as r ON (a.a_id = r.r_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_b, sum(pz.prozent) as plan_prozent_b, auf.id as b_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2015
  GROUP BY auf.id
 ) as b ON (a.a_id = b.b_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_c, sum(pz.prozent) as plan_prozent_c, auf.id as c_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2016
  GROUP BY auf.id
 ) as c ON (a.a_id = c.c_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_d, sum(pz.prozent) as plan_prozent_d, auf.id as d_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2017
  GROUP BY auf.id
 ) as d ON (a.a_id = d.d_id)
) as foo, av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto
WHERE foo.projekt_id = proj.id
AND proj.konto_id = konto.id
ORDER BY konto, auf_name;

GRANT ALL ON TABLE av_geschaeftskontrolle.vr_zahlungsplan_14_17 TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.vr_zahlungsplan_14_17 TO mspublic;
*/

CREATE OR REPLACE VIEW av_geschaeftskontrolle.vr_zahlungsplan_13_16 AS 

SELECT auf_name, auf_geplant, proj."name" as proj_name, konto."nr" as konto, auf_start, auf_ende, auf_abschluss, plan_summe_a, plan_prozent_a, re_summe_a, (re_summe_a / auf_summe) * 100 as re_prozent_a,  plan_summe_b, plan_prozent_b, plan_summe_c, plan_prozent_c, plan_summe_d, plan_prozent_d, a_id, projekt_id
FROM
(
 SELECT *
 FROM
 (
  SELECT auf."name" as auf_name, auf.geplant as auf_geplant, auf.datum_start as auf_start, auf.datum_ende as auf_ende, auf.datum_abschluss as auf_abschluss, (auf.kosten * (1 + (auf.mwst/100))) as auf_summe, sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_a, sum(pz.prozent) as plan_prozent_a, auf.id as a_id, auf.projekt_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2013
  GROUP BY auf.id
 ) as a LEFT JOIN
 (
  SELECT sum(re.kosten * (1 + (re.mwst/100))) as re_summe_a, auf.id as r_id
  FROM av_geschaeftskontrolle.rechnung as re, av_geschaeftskontrolle.auftrag as auf
  WHERE re.auftrag_id = auf.id
  AND re.rechnungsjahr = 2013
  GROUP BY auf.id
 ) as r ON (a.a_id = r.r_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_b, sum(pz.prozent) as plan_prozent_b, auf.id as b_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2014
  GROUP BY auf.id
 ) as b ON (a.a_id = b.b_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_c, sum(pz.prozent) as plan_prozent_c, auf.id as c_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2015
  GROUP BY auf.id
 ) as c ON (a.a_id = c.c_id) LEFT JOIN
 (
  SELECT sum(pz.kosten * (1 + (pz.mwst/100))) as plan_summe_d, sum(pz.prozent) as plan_prozent_d, auf.id as d_id
  FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf
  WHERE pz.auftrag_id = auf.id
  AND pz.rechnungsjahr = 2016
  GROUP BY auf.id
 ) as d ON (a.a_id = d.d_id)
) as foo, av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto
WHERE foo.projekt_id = proj.id
AND proj.konto_id = konto.id
ORDER BY konto, auf_name;

GRANT ALL ON TABLE av_geschaeftskontrolle.vr_zahlungsplan_13_16 TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.vr_zahlungsplan_13_16 TO mspublic;



/*
CREATE OR REPLACE VIEW av_geschaeftskontrolle.vr_kontr_planprozent AS 

SELECT a."name" as auf_name, d.firma, b."name" as proj_name, c.nr as konto_nr, a.sum_planprozent
FROM
(
 SELECT sum(pz.kosten) as sum_plankosten_exkl, auf."name", sum(pz.prozent) as sum_planprozent, auf.projekt_id, auf.unternehmer_id
 FROM av_geschaeftskontrolle.planzahlung as pz, av_geschaeftskontrolle.auftrag as auf, 
      av_geschaeftskontrolle.projekt as proj 
 WHERE pz.auftrag_id = auf.id
 AND auf.projekt_id = proj.id
 AND auf.datum_abschluss IS NULL or trim('' from datum_abschluss::text) = ''
 GROUP BY auf.id
) as a, av_geschaeftskontrolle.projekt as b, av_geschaeftskontrolle.konto as c, av_geschaeftskontrolle.unternehmer as d
WHERE a.projekt_id = b.id
AND c.id = b.konto_id
AND a.unternehmer_id = d.id
ORDER BY b."name", a."name";

GRANT ALL ON TABLE av_geschaeftskontrolle.vr_kontr_planprozent TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.vr_kontr_planprozent TO mspublic;
*/


/*
CREATE OR REPLACE VIEW av_geschaeftskontrolle.vr_firma_verpflichtungen AS 

SELECT CASE WHEN foo.firma IS NULL THEN bar.firma ELSE foo.firma END as firma, CASE WHEN foo.jahr IS NULL THEN bar.jahr ELSE foo.jahr END as jahr, foo.kosten_vertrag_inkl, bar.kosten_bezahlt_inkl
FROM
(
 SELECT a.*, un.firma
 FROM
 (
  SELECT sum(kosten * (1 + mwst/100)) as kosten_vertrag_inkl, unternehmer_id, EXTRACT(YEAR FROM datum_start) as jahr 
  FROM av_geschaeftskontrolle.auftrag as auf
  WHERE geplant = false
  GROUP BY unternehmer_id, EXTRACT(YEAR FROM datum_start)
 ) as a, av_geschaeftskontrolle.unternehmer as un
 WHERE a.unternehmer_id = un.id
) as foo

FULL JOIN

(
 SELECT a.*, auf.id, auf.unternehmer_id, un.firma 
 FROM 
 (
  SELECT sum(kosten * (1 + mwst/100)) as kosten_bezahlt_inkl, auftrag_id, rechnungsjahr as jahr
  FROM av_geschaeftskontrolle.rechnung
  GROUP BY auftrag_id, rechnungsjahr
 ) as a, av_geschaeftskontrolle.auftrag as auf, av_geschaeftskontrolle.unternehmer as un
 WHERE a.auftrag_id = auf.id
 AND auf.unternehmer_id = un.id
) bar 

ON (foo.unternehmer_id = bar.unternehmer_id AND foo.jahr = bar.jahr);


GRANT ALL ON TABLE av_geschaeftskontrolle.vr_firma_verpflichtungen TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.vr_firma_verpflichtungen TO mspublic;
*/
