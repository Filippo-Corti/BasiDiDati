<?php
error_reporting(E_ERROR); //Hides Warnings

// General Purpose
function getRequired($r)
{
    return ($r) ? "required" : "";
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
        $str .= "<td><input type='submit' name='operation' value='Update' class='btn btn-edit'> <input type='submit' name='operation' value='Delete' class='btn btn-delete'></td>";
        $str .= '</form></tr>';
    }
    return $str . '</table>';
}

//Build Input
function buildInputText($name, $minsize, $maxsize, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" type="text" name="{$name}" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$getRequired}>
        <br>
    EOD;
}

function buildInputNumber($name, $totalDigits, $decimalDigits, $required)
{
    $getRequired = getRequired($required);
    $maxNumber = pow(10, $totalDigits - $decimalDigits) - 1;
    $decimalPrecision = 1 / pow(10, $decimalDigits);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="number" max="{$maxNumber}" step="{$decimalPrecision}" {$getRequired}>
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

function buildInputDate($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="date" {$getRequired}>
        <br>
    EOD;
}

function buildInputTime($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="time" {$getRequired}>
        <br>
    EOD;
}

function buildInputDateTime($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="datetime-local" {$getRequired}>
        <br>
    EOD;
}

function buildInputSelect($name, $options, $required)
{

    $getRequired = getRequired($required);
    $optionsStr = "";
    foreach ($options as $option) {
        $optionsStr .= "<option value='{$option}'>{$option}</option>";
    }

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <select class="form-select rounded-pill" name="{$name}" id="{$name}" {$getRequired}>
        <option value="" selected>--</option>
        {$optionsStr}
        </select>
        <br>
    EOD;
}
