-- QUERY PER PHP 


-- Prendere le colonne di una Tabella + Informazione sul Tipo, NOT NULL

SELECT column_name, is_nullable, data_type, character_maximum_length, udt_name
FROM information_schema.columns
WHERE table_name = 'reparto'

-- Prendere i vincoli sulle colonne di una Tabella

SELECT constraint_name, column_name, ordinal_position, constraint_type
FROM information_schema.key_column_usage NATURAL JOIN information_schema.table_constraints
WHERE table_name = 'reparto'


-- Prendo informazioni sui vincoli di integrità referenziale

SELECT A.table_name, A.column_name, B.table_name, B.column_name
FROM (information_schema.referential_constraints NATURAL JOIN information_schema.key_column_usage) AS A
JOIN information_schema.key_column_usage B 
ON A.unique_constraint_name = B.constraint_name
AND A.position_in_unique_constraint = B.ordinal_position
WHERE A.constraint_name IN (
	SELECT constraint_name
	FROM information_schema.key_column_usage
	WHERE table_name = 'ricovero'
	AND constraint_name LIKE '%_fkey'
)


-- Prendere valori per enumerativo (quando data_type è USER DEFINED, usando udt_name)

SELECT enum_range(NULL::fasciaurgenza)


-- Prendere primi N risultati dopo M risultati

SELECT *
FROM information_schema.tables
WHERE table_schema = 'public'
OFFSET M ROWS
FETCH NEXT N ROWS ONLY


-- esempio di trigger

CREATE OR REPLACE FUNCTION check_numero_letti()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se la stanza ha un numeroLetti diverso da NULL
    IF (SELECT numeroLetti FROM Stanza WHERE reparto = NEW.reparto AND numero = NEW.stanza) IS NULL THEN
        RAISE EXCEPTION 'La stanza % del reparto % ha numeroLetti NULL', NEW.stanza, NEW.reparto;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_numero_letti_trigger
BEFORE INSERT ON Ricovero
FOR EACH ROW
EXECUTE FUNCTION check_numero_letti();


-- Primary keys di una tabella
SELECT column_name
FROM information_schema.table_constraints TC JOIN information_schema.key_column_usage KCU
ON TC.constraint_name = KCU.constraint_name
WHERE TC.table_name = 'stanza' AND constraint_type = 'PRIMARY KEY'