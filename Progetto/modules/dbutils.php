<?php

function getColumnsInformation($connection, $tableName)
{
    $query = "SELECT * FROM information_schema.columns WHERE table_name = $1 ORDER BY ordinal_position";
    try {
        return pg_fetch_all(executeQuery($connection, $query, array($tableName)));
    } catch (Exception $e) {
        memorizeError("Lettura dal Database", $e->getMessage());
        header("Refresh:0");
    }
}

function getPrimaryKeys($connection, $tableName)
{
    $query = <<<QRY
    SELECT column_name
    FROM information_schema.table_constraints TC JOIN information_schema.key_column_usage KCU
    ON TC.constraint_name = KCU.constraint_name
    WHERE TC.table_name = $1 AND constraint_type = 'PRIMARY KEY';
    QRY;
    try {
        $results = executeQuery($connection, $query, array($tableName));
        $pkeys = array_map(fn ($el) => $el['column_name'], pg_fetch_all($results));
    } catch (Exception $e) {
        memorizeError("Lettura dal Database", $e->getMessage());
        header("Refresh:0");
    }
    return $pkeys;
}

function getForeignKeyConstraints($connection, $tableName)
{
    $query = <<<QRY
    SELECT A.constraint_name, A.column_name, B.table_name AS referredTable, B.column_name AS referredColumn, B.ordinal_position
    FROM (information_schema.referential_constraints NATURAL JOIN information_schema.key_column_usage) AS A
    JOIN information_schema.key_column_usage B 
    ON A.unique_constraint_name = B.constraint_name
    AND A.position_in_unique_constraint = B.ordinal_position
    WHERE A.constraint_name IN (
      SELECT constraint_name
      FROM information_schema.key_column_usage
      WHERE table_name = $1
      AND constraint_name LIKE '%_fkey'
    )
    ORDER BY B.table_name, B.ordinal_position; 
  QRY;
    try {
        $results = executeQuery($connection, $query, array($tableName));
    } catch (Exception $e) {
        memorizeError("Lettura dal Database", $e->getMessage());
        header("Refresh:0");
    }
    return pg_fetch_all($results);
}

function getColumnsByResults($results)
{
    $fields = array();
    $numFields = pg_num_fields($results);
    for ($i = 0; $i < $numFields; $i++) {
        $fields[] = pg_field_name($results, $i);
    }
    return $fields;
}

function getPatientInfo($connection, $cf)
{
    $query = "SELECT *, DATE_PART('YEAR', AGE(datanascita)) AS eta  FROM Paziente WHERE CF = $1";
    try {
        return pg_fetch_all(executeQuery($connection, $query, array($cf)))[0];
    } catch (Exception $e) {
        memorizeError("Account non riconosciuto", $e->getMessage());
        header("Refresh:0");
    }
}

function getPatientFutureAppointments($connection, $cf) {
    $query = <<<QRY
        SELECT P.*, E.descrizione, 
        CASE
            WHEN LE.cap IS NOT NULL THEN '(' || LE.cap || ') ' || 'Via ' || LE.via || ', ' || LE.cap  
            WHEN O.cap IS NOT NULL THEN '(' || O.cap || ') ' || 'Via ' || O.via || ', ' || O.cap  
        END AS indirizzo,
        CASE
            WHEN regimeprivato THEN E.costoprivato
            ELSE E.costoassistenza
        END AS costo
        FROM Prenotazione P JOIN Esame E ON P.esame = E.codice 
            JOIN Laboratorio L ON P.laboratorio = L.codice 
            LEFT JOIN LaboratorioEsterno LE ON LE.codice = L.codice
            LEFT JOIN LaboratorioInterno LI ON LI.codice = L.codice
            LEFT JOIN Reparto R ON LI.reparto = R.codice
            LEFT JOIN Ospedale O ON R.ospedale = O.codice

        WHERE paziente = $1
        AND dataesame >= CURRENT_DATE;
    QRY;
    try {
        return pg_fetch_all(executeQuery($connection, $query, array($cf)));
    } catch (Exception $e) {
        memorizeError("Impossibile recuperare le Prenotazione", $e->getMessage());
        header("Refresh:0");
    }
}

function getPatientLatestHospitalization($connection, $cf) {
    $query = <<<QRY
        SELECT RI.*, RE.nome AS reparto, O.nome AS ospedale
        FROM ricovero RI JOIN reparto RE ON RI.reparto = RE.codice JOIN ospedale O ON RE.ospedale = O.codice
        WHERE paziente = $1
        AND datainizio >= ALL (
            SELECT datainizio
            FROM ricovero
            WHERE paziente = $1
        )
    QRY;
    try {
        return pg_fetch_all(executeQuery($connection, $query, array($cf)))[0];
    } catch (Exception $e) {
        memorizeError("Impossibile recuperare i Ricoveri", $e->getMessage());
        header("Refresh:0");
    }
}

function getDiagnosis($connection, $hospCode) {
    $query = <<<QRY
        SELECT *
        FROM ricoveropatologia
        WHERE ricovero = $1
    QRY;
    try {
        $results = pg_fetch_all(executeQuery($connection, $query, array($hospCode)));
        $str = implode(", ", array_map(fn($el) => $el['patologia'], $results));
        return $str;
    } catch (Exception $e) {
        memorizeError("Impossibile recuperare i Ricoveri", $e->getMessage());
        header("Refresh:0");
    }
}