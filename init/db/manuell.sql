CREATE TABLE av_geschaeftskontrolle.rechnungsjahr (
    id SERIAL PRIMARY KEY,
    jahr INTEGER NOT NULL UNIQUE
);

ALTER TABLE av_geschaeftskontrolle.rechnungsjahr OWNER TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.rechnungsjahr TO mspublic;


INSERT INTO av_geschaeftskontrolle.rechnungsjahr (jahr) VALUES (2012);
INSERT INTO av_geschaeftskontrolle.rechnungsjahr (jahr) VALUES (2013);
INSERT INTO av_geschaeftskontrolle.rechnungsjahr (jahr) VALUES (2014);
INSERT INTO av_geschaeftskontrolle.rechnungsjahr (jahr) VALUES (2015);




CREATE TABLE av_geschaeftskontrolle.konto (
    id SERIAL PRIMARY KEY,
    nr INTEGER NOT NULL,
    "name" VARCHAR NOT NULL,
    bemerkung VARCHAR
);

ALTER TABLE av_geschaeftskontrolle.konto OWNER TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.konto TO mspublic;

INSERT INTO av_geschaeftskontrolle.konto (nr, "name", bemerkung) VALUES (3130015, 'Unterhalt und Nachführung', '');
INSERT INTO av_geschaeftskontrolle.konto (nr, "name", bemerkung) VALUES (5640000, 'Oeffentl. Unternehmungen', 'RADAV-Konto');



--DROP TABLE av_geschaeftskontrolle.plankostenkonto;
CREATE TABLE av_geschaeftskontrolle.plankostenkonto (
    id SERIAL PRIMARY KEY,
    konto_id INTEGER NOT NULL REFERENCES konto(id),
    budget DOUBLE PRECISION NOT NULL,
    jahr INTEGER NOT NULL,
    bemerkung VARCHAR,
    UNIQUE (konto_id, jahr)
);

ALTER TABLE av_geschaeftskontrolle.plankostenkonto OWNER TO stefan;
GRANT SELECT ON TABLE av_geschaeftskontrolle.plankostenkonto TO mspublic;


--INSERT INTO av_geschaeftskontrolle.plankostenkonto (konto_id, budget, jahr) VALUES (2, 1500000, 2014);

