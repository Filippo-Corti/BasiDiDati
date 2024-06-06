<?php
error_reporting(E_ERROR); //Hides Warnings

// General Purpose
function getRequired($r)
{
    return ($r) ? "required" : "";
}

function getEditable($e)
{
    return ($e) ? "" : "disabled";
}

function getValue($v)
{
    return ($v) ? "value='{$v}'" : "";
}

//Connection to Database
function connectToDatabase()
{
    include 'vars.php';

    $connection = pg_connect($connectionString_Admin);
    if (!$connection) {
        echo '<br> Connessione al database fallita. <br>';
        exit();
    }
    return $connection;
}

function executeQuery($connection, $query, $params = NULL)
{
    if (!$params) {
        $result = pg_query($connection, $query);
    } else {
        $result = pg_query_params($connection, $query, $params);
    }
    if (!$result) {
        throw new Exception(pg_last_error($connection));
    }
    return $result;
}

function notifyError($msg)
{
    echo "<br><b>ERRORE: {$msg}</b><br>";
    exit();
}

function getColumnsInformation($connection, $tableName)
{
    $query = "SELECT * FROM information_schema.columns WHERE table_name = $1 ORDER BY ordinal_position";
    try {
        return executeQuery($connection, $query, array($tableName));
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
}

function getPrimaryKey($connection, $tableName)
{
    $query = <<<QRY
    SELECT column_name
    FROM information_schema.table_constraints TC JOIN information_schema.key_column_usage KCU
    ON TC.constraint_name = KCU.constraint_name
    WHERE TC.table_name = $1 AND constraint_type = 'PRIMARY KEY';
    QRY;
    try {
        $results = executeQuery($connection, $query, array($tableName));
        $pkeys = array_map(fn($el) => $el['column_name'], pg_fetch_all($results));
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
    return $pkeys;
}

function buildTable($results, $columns, $table)
{
    //Intestation
    $str = '<table class="w-100">';
    $str .= '<tr>';
    foreach ($columns as $col) {
        $col = ucfirst($col);
        $str .= "<th> {$col} </th>";
    }
    $str .= "<th> Actions </th>";
    $str .= '</tr>';
    foreach ($results as $row) {
        $str .= '<tr><form method="POST" action="opmanager.php">';
        $str .= "<input type='hidden' name='table' value='{$table}'>"; //Table Name
        foreach ($columns as $col) {
            $str .= "<td> <input type='hidden' name='{$col}' value='{$row[$col]}'> {$row[$col]} </td>";
        }
        $str .= "<td><input type='submit' name='operation' value='toupdate' class='btn btn-edit'> <input type='submit' name='operation' value='Delete' class='btn btn-delete'></td>";
        $str .= '</form></tr>';
    }
    return $str . '</table>';
}

//Create Input Form

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
        notifyError($e->getMessage());
    }
    return pg_fetch_all($results);
}

function getStandardInputFields($connection, &$columns, $toedit = false, $primaryKeys = NULL)
{
    $formFields = array();
    foreach ($columns as $col) {
        $formFields[$col['ordinal_position']] = getStandardInputField($connection, $col, $toedit, $primaryKeys);
    }
    return $formFields;
}

function getReferentialInputFields($connection, &$columns, $foreignKeys, $toedit = false, $primaryKeys = NULL)
{
    $formFields = array();
    $referencedTables = array();
    foreach ($foreignKeys as $fk) {
        if ($fk['ordinal_position'] == 1) {
            $referencedTables[] = array('constraint' => $fk['constraint_name'], 'referredtable' => $fk['referredtable']);
        }
    }
    foreach ($referencedTables as $referencedTable) {
        $formField = getReferentialInputField($connection, $columns, $foreignKeys, $referencedTable, $index, $toedit, $primaryKeys);
        $formFields[$index] = $formField;
    }
    return $formFields;
}

function getStandardInputField($connection, $column_data, $toedit, $primaryKeys)
{
    $name = ucfirst($column_data['column_name']);
    $field_type = $column_data['udt_name'];
    switch ($field_type) {
        case 'bpchar':
            return buildInputText($name, $column_data['character_maximum_length'], $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO');
        case 'varchar':
            return buildInputText($name, 0, $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO');
        case 'numeric':
            return buildInputNumber($name, $column_data['numeric_precision'], $column_data['numeric_scale'], $column_data['is_nullable'] == 'NO');
        case 'date':
            return buildInputDate($name, $column_data['is_nullable'] == 'NO');
        case 'time':
            return buildInputTime($name, $column_data['is_nullable'] == 'NO');
        case 'timestamp':
            return buildInputDateTime($name, $column_data['is_nullable'] == 'NO');
        default:
            //User-defined Enum
            $query = "SELECT enum_range(NULL::{$field_type})";
            try {
                $result = executeQuery($connection, $query);
            } catch (Exception $e) {
                notifyError($e->getMessage());
            }
            $enumValues = substr(pg_fetch_array($result)['enum_range'], 1, -1); //Trim { and }
            return buildInputSelect($name, explode(',', $enumValues), $column_data['is_nullable'] == 'NO');
    }
}

function getReferentialInputField($connection, &$columns, $foreignKeys, $referencedTable, &$index, $toedit, $primaryKeys)
{
    //Find Referenced and Referring Columns
    $referencedData = array();
    $constraintName = $referencedTable['constraint'];
    $referencedTable = $referencedTable['referredtable'];
    foreach ($foreignKeys as $fk) {
        if ($fk['referredtable'] == $referencedTable && $constraintName = $fk['constraint_name']) {
            $referencedData[] = $fk;
        }
    }
    $referencedColumns = array_map(fn($el) => $el['referredcolumn'], $referencedData);
    $referencedColumnsString = implode(", ", $referencedColumns);
    $referringColumns = array_map(fn($el) => ucfirst($el['column_name']), $referencedData);
    $referringColumnsString = implode(", ", $referringColumns);

    //Execute Query to get Selection Data 
    $query = "SELECT {$referencedColumnsString} FROM {$referencedTable}";
    try {
        $dataForSelectInput = executeQuery($connection, $query);
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
    $dataForSelectInput = array_map(fn($el) => implode(', ', $el), pg_fetch_all($dataForSelectInput));

    //Find Correct Index in the Page 
    $positionInPage = array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns));
    $index = max(array_map(fn($el) => $el['ordinal_position'], $positionInPage));
    $isRequired = in_array("NO", array_map(fn($el) => ucfirst($el['is_nullable']), array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns))));

    //Remove Referred Columns so that they don't get evaluated again
    $columns = array_filter($columns, fn($el) => !in_array(ucfirst($el['column_name']), $referringColumns));
    
    if ($toedit) {
        return buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired, true, );
    }
    return buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired);
}

//Build Input
function buildInputText($name, $minsize, $maxsize, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" type="text" name="{$name}" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputNumber($name, $totalDigits, $decimalDigits, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);
    $maxNumber = pow(10, $totalDigits - $decimalDigits) - 1;
    $decimalPrecision = 1 / pow(10, $decimalDigits);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="number" max="{$maxNumber}" step="{$decimalPrecision}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputBoolean($name)
{
    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="checkbox">
        <br>
    EOD;
}

function buildInputDate($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="date" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="time" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputDateTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="datetime-local" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputSelect($name, $options, $required, $editable = true, $value = NULL)
{

    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $optionsStr = "";
    $selected = false;
    foreach ($options as $option) {
        if ($option == $value) {
            $optionsStr .= "<option value='{$option}' selected>{$option}</option>";
            $selected = true;
        } else {
            $optionsStr .= "<option value='{$option}'>{$option}</option>";
        }
    }

    //NON VA
    if (!$selected) {
        $optionsStr = '<option value="" selected>--</option>' . $optionsStr;
    } else {
        $optionsStr = '<option value="">--</option>' . $optionsStr;
    }

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <select class="form-select rounded-pill" name="{$name}" id="{$name}" {$getRequired} {$getEditable}>
        {$optionsStr}
        </select>
        <br>
    EOD;
}
