<?php
session_start();

foreach (glob("modules/*.php") as $filename) {
    include $filename;
}

$connection = connectToDatabase();

//Get POST Data
$table = strtolower($_POST['table']);
$operation = strtolower($_POST['operation']);
$attributes = parsePostValues();

//Clear SESSION
$loggedUser = $_SESSION['logged_user'];
session_unset();
$_SESSION['logged_user'] = $loggedUser;

//Do OPERATION
switch ($operation) {
    case 'goto_insert':
        $_SESSION['table'] = $table;
        header("Location: {$DEFAULT_DIR}/insert.php");
        exit();
    case 'goto_update':
        $_SESSION['table'] = $table;
        $_SESSION['edit_data'] = $_POST;
        header("Location: {$DEFAULT_DIR}/edit.php");
        exit();
    case 'insert':
        $attributes = array_filter($attributes, fn ($el) => $el);
        $names = implode(", ", array_keys($attributes));
        $values = implode(", ", array_map(fn ($el) => "'" . $el . "'", array_values($attributes)));
        insertIntoDatabase($connection, $table, $names, $values);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
    case 'update':
        updateIntoDatabase($connection, $table, $attributes);
        unset($_SESSION['edit_data']);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
    case 'delete':
        deleteFromDatabase($connection, $table);
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
    case 'login_as_patient':
        loginAsPatient($connection);
        header("Location: {$DEFAULT_DIR}/index.php");
        exit();
    case 'login_as_worker':
        loginAsWorker($connection);
        header("Location: {$DEFAULT_DIR}/index.php");
        exit();
    case 'logout':
        unset($_SESSION['logged_user']);
        header("Location: {$DEFAULT_DIR}/login.php");
        exit();
    case 'view_appointments':
        $_SESSION['query'] = "SELECT * FROM Prenotazione WHERE Paziente = '{$loggedUser['username']}'";
        $_SESSION['query_title'] = "Prenotazioni per {$loggedUser['username']}";
        header("Location: {$DEFAULT_DIR}/view.php");
        exit();
}

function insertIntoDatabase($connection, $table, $attributes, $values)
{
    global $DEFAULT_DIR;

    $query = "INSERT INTO {$table} ({$attributes}) VALUES ({$values});";
    print_r($query);
    try {
        $results = executeQuery($connection, $query);
        memorizeSuccess("Inserimento in {$table}", "Operazione avvenuta con successo.");
    } catch (Exception $e) {
        memorizeError("Inserimento in {$table}", $e->getMessage());
        $_SESSION['inserted_data'] = $_POST;
        header("Location: {$DEFAULT_DIR}/insert.php");
        exit();
    }
}

function deleteFromDatabase($connection, $table)
{
    $pkeys = getPrimaryKeys($connection, $table);
    $findCondition = "WHERE ";
    foreach ($_POST as $k => $v) {
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

function updateIntoDatabase($connection, $table, $values)
{
    print_r($values);
    $pkeys = getPrimaryKeys($connection, $table);
    $findCondition = "WHERE ";
    $editCondition = "";
    foreach ($values as $k => $v) {
        if (!$v) continue; //Avoid statements like "Attribute = NULL"
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

function loginAsPatient($connection)
{

    global $DEFAULT_DIR;

    $query = "SELECT * FROM UtenzaPaziente WHERE paziente = $1;";
    try {
        $result = pg_fetch_array(executeQuery($connection, $query, array($_POST['Username'])));
        if (password_verify($_POST['Password'], $result['hashedpassword'])) {
            memorizeSuccess("Login", "Operazione avvenuta con successo. Benvenuto {$_POST['Username']}.");
            $_SESSION['logged_user'] = array('username' => $_POST['Username'], 'type' => 'patient');
        } else {
            memorizeError("Login", "Credenziali non valide. Riprovare.");
            header("Location: {$DEFAULT_DIR}/login.php");
            exit();
        }
    } catch (Exception $e) {
        memorizeError("Login", "Credenziali non valide. Riprovare.");
        header("Location: {$DEFAULT_DIR}/login.php");
        exit();
    }
}

function loginAsWorker($connection)
{

    global $DEFAULT_DIR;

    $query = "SELECT * FROM UtenzaPersonale WHERE paziente = $1;";
    try {
        $result = pg_fetch_array(executeQuery($connection, $query, array($_POST['Username'])));
        if (password_verify($_POST['Password'], $result['hashedpassword'])) {
            memorizeSuccess("Login", "Operazione avvenuta con successo. Benvenuto {$_POST['Username']}.");
            $_SESSION['logged_user'] = array('username' => $_POST['Username'], 'type' => 'worker');
        } else {
            memorizeError("Login", "Credenziali non valide. Riprovare.");
            header("Location: {$DEFAULT_DIR}/login.php");
            exit();
        }
    } catch (Exception $e) {
        memorizeError("Login", "Credenziali non valide. Riprovare.");
        header("Location: {$DEFAULT_DIR}/login.php");
        exit();
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
            if (stristr($key, "plaintext")) {
                $key = str_ireplace("plaintext", "Hashed", $key);
                $value = password_hash($value, PASSWORD_DEFAULT);
            }
            $attributes[$key] = $value;
        }
    }


    return $attributes;
}
