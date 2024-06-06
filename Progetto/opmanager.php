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
    case 'update':
        echo "Update: <br>";
        print_r($_POST);
        break;
    case 'delete':
        deleteDatabase($connection, $table);
        header("Location: /basididati/progetto/index.php");
        break;

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

function deleteDatabase($connection, $table) {
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