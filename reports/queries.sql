-- to_char(12454.8, E'999\'999\'999\'999D99S')

-- Alle laufenden Projekte.
-- Projekte ohne 'datum_ende'

SELECT proj.*, konto.nr, konto."name" 
FROM av_geschaeftskontrolle.projekt as proj, av_geschaeftskontrolle.konto as konto
WHERE konto.id = proj.konto_id
AND datum_ende IS NULL or trim('' from datum_ende::text) = ''
ORDER BY datum_start, proj."name";