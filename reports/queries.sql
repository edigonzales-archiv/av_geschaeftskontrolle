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




