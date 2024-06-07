<?php
session_start();

if (isset($_SESSION['table']) && $_SESSION['table'] != "") {
    echo "Dal SESSION";
    $table = $_SESSION['table'];
} else if (isset($_POST['table'])){
    $table = $_POST['table'];
    $_SESSION['table'] = $table;
    echo "Dal POST";
} else { 
    echo "DAL NIENTE";
}
echo "<br>";
print_r($_SESSION);
foreach (glob("modules/*.php") as $filename) {
	include $filename;
}

$operation = strtolower($_POST['operation']);

$attributes = parsePostValues();

$connection = connectToDatabase();


switch ($operation) {
    case 'insert':
		$attributes = array_filter($attributes, fn($el) => $el);
        $names = implode(", ", array_keys($attributes));
        $values = implode(", ", array_map(fn($el) => "'" . $el . "'" , array_values($attributes)));
        insertIntoDatabase($connection, $table, $names, $values);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
    case 'edit': //Redirect to Edit Page
		$_SESSION['edit_data'] = $_POST;
        header("Location: {$DEFAULT_DIR}/edit.php");
        exit();
    case 'update': //Actually update the DB
        updateIntoDatabase($connection, $table, $attributes);
		unset($_SESSION['edit_data']);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
    case 'delete':
        deleteFromDatabase($connection, $table);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();

}

function insertIntoDatabase($connection, $table, $attributes, $values)
{
    $query = "INSERT INTO {$table} ({$attributes}) VALUES ({$values});";
	print_r($query);
    try {
        $results = executeQuery($connection, $query);
        memorizeSuccess("Inserimento in {$table}", "Operazione avvenuta con successo.");
    } catch (Exception $e) {
        memorizeError("Inserimento in {$table}", $e->getMessage());
        return;
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
        memorizeSuccess("Cancellazione da {$table}", "Operazione avvenuta con successo.");
    } catch (Exception $e) {
        memorizeError("Cancellazione da {$table}", $e->getMessage());
        return;
    }
}

function updateIntoDatabase($connection, $table, $values) {
    print_r($values);
    $pkeys = getPrimaryKeys($connection, $table);
    $findCondition = "WHERE ";
    $editCondition = "";
    foreach($values as $k => $v) {
        if (in_array(strtolower($k), $pkeys)) {
            $findCondition .= "{$k} = '{$v}' AND ";
        }
        $editCondition .= "{$k} = '{$v}', ";
    }
    $findCondition = substr($findCondition, 0, -4);
    $editCondition = substr($editCondition, 0, -2);
    $query = "UPDATE {$table} SET {$editCondition} {$findCondition}";
	echo $query;
    try {
        $results = executeQuery($connection, $query);
        memorizeSuccess("Aggiornamento di {$table}", "Operazione avvenuta con successo.");
    } catch (Exception $e) {
        memorizeError("Aggiornamento di {$table}", $e->getMessage());
        return;
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