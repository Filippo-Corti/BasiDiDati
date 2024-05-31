<!--basic_del.php-->
<?php
session_start();
$htmlint = <<<NOW
<HTML>
  <HEAD>
    <style>
      table, th, td {
        text-align: left;
        border: 1px solid;
      }
    </style>
  </HEAD>
<BODY> 
NOW;
//print_R($_POST);
if (isset($_POST['todelete']) && isset($_SESSION['tbl'])) {//sono stati passati correttamente i dati
  $conn = pg_connect("host=localhost port=5432 dbname=pizzeria user=postgres password=dbadmin");
  if (!$conn) {
    echo 'Connessione al database fallita.';
    exit();
  }
  else {
    //echo "Connessione riuscita."."<br/>";
    //preparo la query di eliminazione sfruttando il valore di pk passato relativo alla tupla da eliminare
    $query = "DELETE FROM " . $_SESSION['tbl'] . " WHERE telc='" . $_POST['todelete'] . "';";
    //echo $query;
    $result = pg_query($conn, $query);
    if (!$result) {
      echo "Si è verificato un errore.<br/>";
      echo pg_last_error($conn);
      exit();
    }
    else {//dato che la cancellazione non produce output, avviso l'utente
      //$cmdtuples = pg_affected_rows($result);
      echo "Cancellazione avvenuta con successo<br><a href='select_basic.php'>ritorna</a>";
    };
  };
}
else {//non sono stati passati correttamente i dati
  print ($htmlint);
  echo "Non risultano dati passati<br>";
  echo "Se vuoi puoi <a href='select_basic.php'>riprovare</a>";
}
?>
</BODY>
</HTML>