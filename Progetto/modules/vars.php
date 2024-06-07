<?php

$DEFAULT_DIR = "/basididati/progetto";

$CONNECTION_STRING = "host=localhost port=5432 dbname=ospedali user=postgres password=dbadmin";

enum NotificationType {
    case Error;
    case Success;
}

//$connectionString_Paziente = "host=localhost port=5432 dbname=ospedali user=paziente password=dbpaziente";