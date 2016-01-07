\set ECHO none
\i sql/base36_4b.sql
\set ECHO all

CREATE TABLE base36_4bs(id serial primary key, base36_4b base36_4b unique);
INSERT INTO base36_4bs(base36_4b) VALUES('012345');
INSERT INTO base36_4bs(base36_4b) VALUES('6789AB');
INSERT INTO base36_4bs(base36_4b) VALUES('CDEFGH');
INSERT INTO base36_4bs(base36_4b) VALUES('IJKLMN');
INSERT INTO base36_4bs(base36_4b) VALUES('OPQRST');
INSERT INTO base36_4bs(base36_4b) VALUES('UVWXYZ');
INSERT INTO base36_4bs(base36_4b) VALUES('200004');
INSERT INTO base36_4bs(base36_4b) VALUES('400002');
INSERT INTO base36_4bs(base36_4b) VALUES('300003');
INSERT INTO base36_4bs(base36_4b) VALUES('abcxyz');
INSERT INTO base36_4bs(base36_4b) VALUES('0'); -- test limits
INSERT INTO base36_4bs(base36_4b) VALUES('1Z141Z3');

SELECT * FROM base36_4bs ORDER BY base36_4b;

SELECT MIN(base36_4b) AS min FROM base36_4bs;
SELECT MAX(base36_4b) AS max FROM base36_4bs;

-- index scan
TRUNCATE base36_4bs;
INSERT INTO base36_4bs(base36_4b) SELECT '44'||id FROM generate_series(5678, 8000) id;

SET enable_seqscan = false;
SELECT id,base36_4b::text FROM base36_4bs WHERE base36_4b = '446000';
SELECT id,base36_4b FROM base36_4bs WHERE base36_4b >= '447000' LIMIT 5;
SELECT count(id) FROM base36_4bs;
SELECT count(id) FROM base36_4bs WHERE base36_4b <> ('446500'::text)::base36_4b;
RESET enable_seqscan;

-- operators and conversions
SELECT '0'::base36_4b < '0'::base36_4b;
SELECT '0'::base36_4b > '0'::base36_4b;
SELECT '0'::base36_4b < '1'::base36_4b;
SELECT '0'::base36_4b > '1'::base36_4b;
SELECT '0'::base36_4b <= '0'::base36_4b;
SELECT '0'::base36_4b >= '0'::base36_4b;
SELECT '0'::base36_4b <= '1'::base36_4b;
SELECT '0'::base36_4b >= '1'::base36_4b;
SELECT '0'::base36_4b <> '0'::base36_4b;
SELECT '0'::base36_4b <> '1'::base36_4b;
SELECT '0'::base36_4b = '0'::base36_4b;
SELECT '0'::base36_4b = '1'::base36_4b;

-- COPY FROM/TO
TRUNCATE base36_4bs;
COPY base36_4bs(base36_4b) FROM STDIN;
00000000
VVVVVV
\.
COPY base36_4bs TO STDOUT;

-- clean up --
DROP TABLE base36_4bs;

-- errors
SELECT ''::base36_4b;
SELECT '1Z141Z4'::base36_4b;
SELECT '!'::base36_4b;
