<?php

// General Purpose
function getRequired($r)
{
    return ($r) ? "required" : "";
}

//Connection to Database
function connectToDatabase()
{
    include 'vars.php';

    $connection = pg_connect($connectionString);
    if (!$connection) {
        echo 'Connessione al database fallita.';
        exit();
    }
    return $connection;
}

function executeQuery($connection, $query, $params = NULL) {
    if (!$params) {
        $result = pg_query($connection, $query);
    } else {
        $result = pg_query_params($connection, $query, $params);
    }
    if (!$result) {
      echo "Si è verificato un errore.";
      echo pg_last_error($connection);
      exit();
    }
    return $result;
}



//Build Input
function buildInputText($name, $minsize, $maxsize, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input type="{$name}" name="text" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$getRequired}>
        <br>
    EOD;
}

function buildInputNumber($name, $totalDigits, $decimalDigits, $required)
{
    $getRequired = getRequired($required);
    $maxNumber = pow(10, $totalDigits - $decimalDigits) - 1;
    $decimalPrecision = 1 / pow(10, $decimalDigits);

    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input name="{$name}" type="number" max="{$maxNumber}" step="{$decimalPrecision}" {$getRequired}>
        <br>
    EOD;
}

function buildInputBoolean($name)
{
    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input name="{$name}" type="checkbox">
        <br>
    EOD;
}

function buildInputDate($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input name="{$name}" type="date" {$getRequired}>
        <br>
    EOD;
}

function buildInputTime($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input name="{$name}" type="time" {$getRequired}>
        <br>
    EOD;
}

function buildInputDateTime($name, $required)
{
    $getRequired = getRequired($required);

    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <input name="{$name}" type="datetime-local" {$getRequired}>
        <br>
    EOD;
}

function buildInputSelect($name, $options, $required)
{

    $getRequired = getRequired($required);
    $optionsStr = "";
    foreach($options as $option) {
        $optionsStr .= "<option value='{$option}'>{$option}</option>";
    }
    
    return <<<EOD
        <label for="{$name}">{$name}:</label>
        <select name="{$name}" id="{$name}" {$getRequired}>
        <option value="" selected>--</option>
        {$optionsStr}
        </select>
        <br>
    EOD;
}
