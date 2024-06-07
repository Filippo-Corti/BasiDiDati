<!--basic_upd.php-->
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
if (isset($_POST['toupdate']) && isset($_SESSION['tbl'])) {//sono stati passati correttamente i dati
  $conn = pg_connect("host=localhost port=5432 dbname=pizzeria user=postgres password=dbadmin");
  if (!$conn) {
    echo 'Connessione al database fallita.';
    exit();
  }
  else {
    //echo "Connessione riuscita."."<br/>";
    $query = "SELECT * FROM " . $_SESSION['tbl'] . " WHERE telc='" . $_POST['toupdate'] . "';";
    //echo $query;
    $result = pg_query($conn, $query);
    if (!$result) {
      echo "Si è verificato un errore.<br/>";
      echo pg_last_error($conn);
      exit();
    }
    else {
      //$cmdtuples = pg_affected_rows($result);
      $array = pg_fetch_array($result);
      print ($htmlint);
      print ("<table>");
      print ("<form action=\"basic_upd2.php\" method=\"POST\">");
      //una volta raccolte le modifiche, passo i dati al file preposto all'applicazione delle stesse
      //si noti che la chiave non deve essere modificabile
      print ("<tr><th>Telefono</th><td><input type=\"text\" name=\"telc\" value='" . $array['telc'] . "'  required readonly></td></tr>");
      print ("<tr><th>Cognome</th><td><input type=\"text\" name=\"cognomec\" value='" . $array['cognomec'] . "' required></td</tr>");
      print ("<tr><th>Nome</th><td><input type=\"text\" name=\"nomec\" value='" . $array['nomec'] . "' required></td></tr>");
      print ("<tr><th>Password</th><td><input type=\"password\" name=\"password\" value='" . $array['password'] . "' required></td></tr>");
      print ("<tr><th>Via</th><td><input type=\"text\" name=\"via\" value='" . $array['via'] . "' required></td></tr>");
      print ("<tr><th>Numero Civico</th><td><input type=\"number\" name=\"nciv\" value='" . $array['nciv'] . "' required></td></tr>");
      print ("<tr><th>Interno</th><td><input type=\"text\" name=\"nint\" value='" . $array['nint'] . "' required></td></tr>");
      print ("<tr><td><input type=\"submit\" name=\"toupdate2\" value=\"Send\"></td></tr>");
      print ("</form>");
      print ("</table>");
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