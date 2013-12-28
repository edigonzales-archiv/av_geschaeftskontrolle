﻿-- Verifikation:
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

-- laufende Aufträge

SELECT auftrag.*, rechnung.bezahlt, (auftrag.kosten_inkl - rechnung.bezahlt) as ausstehend
FROM
(
 SELECT auf.id as auf_id, auf."name" as auftrag_name, auf.geplant, proj.id as proj_id, proj."name" as projekt_name, konto.nr || ' (' || konto."name" || ')' as konto, auf.datum_start, auf.datum_ende, auf.kosten as kosten_exkl, auf.mwst, (auf.kosten * (1 + auf.mwst / 100)) as kosten_inkl
 FROM av_geschaeftskontrolle.auftrag as auf, av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto
 WHERE auf.projekt_id = proj.id
 AND proj.konto_id = konto.id
 AND auf.datum_abschluss IS NULL or trim('' from datum_abschluss::text) = ''
 ORDER BY auf.datum_start, auf."name"
) as auftrag LEFT JOIN
(
 SELECT sum(kosten * (1 + mwst / 100)) as bezahlt, auftrag_id
 FROM av_geschaeftskontrolle.rechnung
 GROUP BY auftrag_id
) as rechnung ON (rechnung.auftrag_id = auftrag.auf_id);



