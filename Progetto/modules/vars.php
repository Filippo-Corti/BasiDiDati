<?php

$DEFAULT_DIR = "/basididati/progetto";

$CONNECTION_STRING = "host=localhost port=5432 dbname=ospedali user=postgres password=dbadmin";

if (!(enum_exists("NotificationType"))) {
    enum NotificationType : string {
        case Error = 'error';
        case Success = 'success';
    }
    
}
//$connectionString_Paziente = "host=localhost port=5432 dbname=ospedali user=paziente password=dbpaziente";