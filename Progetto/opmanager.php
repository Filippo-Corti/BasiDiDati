<?php

include 'utils.php';

$operation = strtolower($_POST['operation']);
$table = $_POST['table'];

$attributes = parsePostValues();

$connection = connectToDatabase();

switch ($operation) {
    case 'insert':
        $names = implode(", ", array_keys($attributes));
        $values = implode(", ", array_map(fn($el) => "'" . $el . "'", array_values($attributes)));
        insertIntoDatabase($connection, $table, $names, $values);
        header("Location: /basididati/progetto/index.php");
        exit();
    case 'toupdate': //Redirect to Edit Page
        header("Location: /basididati/progetto/edit.php");
        exit();
    case 'update': //Actually update the DB
        updateIntoDatabase($connection, $table, $names, $values);
        header("Location: /basididati/progetto/index.php");
        exit();
    case 'delete':
        deleteFromDatabase($connection, $table);
        header("Location: /basididati/progetto/index.php");
        exit();

}

function insertIntoDatabase($connection, $table, $attributes, $values)
{
    $query = "INSERT INTO {$table} ({$attributes}) VALUES ({$values});";
    try {
        $results = executeQuery($connection, $query);
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
}

function deleteFromDatabase($connection, $table) {
    $pkeys = getPrimaryKey($connection, $table);
    $findCondition = "WHERE ";
    foreach($_POST as $k => $v) {
        if (in_array($k, $pkeys)) {
            $findCondition .= "{$k} = '{$v}' AND ";
        }
    }
    $findCondition = substr($findCondition, 0, -4);
    $query = "DELETE FROM {$table} " . $findCondition;
    try {
        $results = executeQuery($connection, $query);
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
}

function updateIntoDatabase($connection, $table, $names, $values) {
    $pkeys = getPrimaryKey($connection, $table);
    $findCondition = "WHERE ";
    $editCondition = "";
    foreach($_POST as $k => $v) {
        if (in_array($k, $pkeys)) {
            $findCondition .= "{$k} = '{$v}' AND ";
        } else {
            $editCondition .= "{$k} = '{$v}', ";
        }
    }
    $findCondition = substr($findCondition, 0, -4);
    $editCondition = substr($editCondition, 0, -2);
    $query = "UPDATE {$table} SET {$editCondition} {$findCondition}";
    echo "<br>";
    echo $query;

}

//Adjusts Post array to get all and only attributes for the table
function parsePostValues()
{
    unset($_POST['operation']);
    unset($_POST['table']);

    $attributes = array();

    foreach ($_POST as $k => $v) {
        $ks = explode(",_", $k);
        if (count($ks) > 1) {
            $vs = array_values(explode(",", $v));
        } else {
            $vs = array_values(array($v));
        }
        $i = 0;
        foreach ($ks as $key) {
            $value = $vs[$i++];
            $attributes[$key] = $value;
        }
    }

    return $attributes;

}