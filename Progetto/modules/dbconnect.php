<?php
//error_reporting(E_ERROR); //Hides Warnings

//Connection to Database
function connectToDatabase()
{
	$connectionString_Admin = "host=localhost port=5432 dbname=ospedali user=postgres password=dbadmin";
	$connectionString_Paziente = "host=localhost port=5432 dbname=ospedali user=paziente password=dbpaziente";
	
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

