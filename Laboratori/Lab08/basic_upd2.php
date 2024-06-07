<!--basic_updt2.php-->
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
if (isset($_POST['toupdate2']) && isset($_SESSION['tbl'])) {//sono stati passati correttamente i dati
  $conn = pg_connect("host=localhost port=5432 dbname=pizzeria user=postgres password=dbadmin");
  if (!$conn) {
    echo 'Connessione al database fallita.';
    exit();
  }
  else {
    //echo "Connessione riuscita."."<br/>";
    $tel = isset($_POST['telc']) ? $_POST['telc'] : NULL;
    //testo anche la composizione
    $pattern = '/^[0-9]+$/';
    $tel = preg_match($pattern, $tel) ? $tel : 'not valid';
    $cognome = isset($_POST['cognomec']) ? $_POST['cognomec'] : NULL;
    $nome = isset($_POST['nomec']) ? $_POST['nomec'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : NULL;
    $via = isset($_POST['via']) ? $_POST['via'] : '';
    $nciv = (isset($_POST['nciv']) and is_numeric($_POST['nciv'])) ? $_POST['nciv'] : NULL;
    $int = isset($_POST['nint']) ? $_POST['nint'] : NULL;
    $query = "UPDATE " . $_SESSION['tbl'] . " set  cognomeC='$cognome', nomeC='$nome', password='$password', via='$via', nCiv=$nciv, nInt='$int' where telC='$tel'";
    //echo $query;
    if($tel!='not valid'){
      $result = pg_query($conn, $query);
      if (!$result) {
        echo "Si è verificato un errore.<br/>";
        echo pg_last_error($conn);
        exit();
      }
      else {
        //$cmdtuples = pg_affected_rows($result);
        echo "Aggiornamento avvenuto con successo<br><a href='select_basic.php'>ritorna</a>";
      };
    }
    else {
      echo "I dati passati non sono conformi alle richieste.<br>";
      echo "Se vuoi puoi <a href='select_basic.php'>riprovare</a>";
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
