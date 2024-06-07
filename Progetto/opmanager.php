<?php
session_start();

foreach (glob("modules/*.php") as $filename) {
	include $filename;	
}

$operation = strtolower($_POST['operation']);
$table = $_POST['table'];

$attributes = parsePostValues();

$connection = connectToDatabase();

switch ($operation) {
    case 'insert':
		$attributes = array_filter($attributes, fn($el) => $el);
		print_r($attributes);
        $names = implode(", ", array_keys($attributes));
        $values = implode(", ", array_map(fn($el) => "'" . $el . "'" , array_values($attributes)));
        insertIntoDatabase($connection, $table, $names, $values);
        header("Location: /basididati/progetto/view.php?table={$table}");
        exit();
    case 'edit': //Redirect to Edit Page
		$_SESSION['edit_data'] = $_POST;
        header("Location: /basididati/progetto/edit.php?table={$table}");
        exit();
    case 'update': //Actually update the DB
        updateIntoDatabase($connection, $table, $attributes);
		unset($_SESSION['edit_data']);
        header("Location: /basididati/progetto/view.php?table={$table}");
        exit();
    case 'delete':
        deleteFromDatabase($connection, $table);
        header("Location: /basididati/progetto/view.php?table={$table}");
        exit();

}

function insertIntoDatabase($connection, $table, $attributes, $values)
{
    $query = "INSERT INTO {$table} ({$attributes}) VALUES ({$values});";
	print_r($query);
    try {
        $results = executeQuery($connection, $query);
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
}

function deleteFromDatabase($connection, $table) {
    $pkeys = getPrimaryKeys($connection, $table);
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

function updateIntoDatabase($connection, $table, $values) {
    $pkeys = getPrimaryKeys($connection, $table);
    $findCondition = "WHERE ";
    $editCondition = "";
    foreach($values as $k => $v) {
        if (in_array(strtolower($k), $pkeys)) {
            $findCondition .= "{$k} = '{$v}' AND ";
        } else {
            $editCondition .= "{$k} = '{$v}', ";
        }
    }
    $findCondition = substr($findCondition, 0, -4);
    $editCondition = substr($editCondition, 0, -2);
    $query = "UPDATE {$table} SET {$editCondition} {$findCondition}";
	echo $query;
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