<!--opt_basic.php-->
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
if (isset($_POST['tabella']) && isset($_POST['operazione'])) {//sono stati passati correttamente i dati
  $tbl = $_POST['tabella'];
  $op = $_POST['operazione'];
  $_SESSION['tbl'] = $tbl;
  //$_SESSION['op'] = $op;
  $conn = pg_connect("host=localhost port=5432 dbname=pizzeria user=postgres password=dbadmin");
  if (!$conn) {//caso connessione fallita
    echo 'Connessione al database fallita.';
    exit();
  }
  else {//caso connessione riuscita
    //echo "Connessione riuscita."."<br/>";
    switch ($op) {//stabilisco cosa fare in base all'operazione selezionata
      case 'select':
      //la selezione richiede la visualizzazione del resultset in forma tabellare
        //devo gestire tutte le combinazioni possibili operazione-tabella
		$table = $tbl;
		$query = "SELECT * FROM information_schema.columns WHERE table_schema = 'public' AND table_name='{$table}';";
		
		$result = pg_query($conn, $query);
		if (!$result) {
		  echo "Si è verificato un errore.<br/>";
		  echo pg_last_error($conn);
		  exit();
		}
		
		$columns = array();
		while ($row = pg_fetch_array($result)) {
		  $columns[] = $row['column_name'];
		};
		
		
		$query = "SELECT * FROM {$table}";
		$result = pg_query($conn, $query);
		if (!$result) {//la query ha generato errori
		  echo "Si è verificato un errore.<br/>";
		  echo pg_last_error($conn);
		  exit();
		}
		  print ($htmlint);
		  //costruisco una tabella per visualizzare i dati
		  echo "<br>";
		 echo showTable($result, $columns);
		  echo "Se vuoi puoi <a href='select_basic.php'>riprovare</a>";
	  break;
        //
        
      case 'delete':
        //la cancellazione richiede la selezione preliminare della tupla da cancellare
        switch ($tbl) {
          case 'cliente':
            $query = "SELECT * FROM Cliente";
            $result = pg_query($conn, $query);
            if (!$result) {
              echo "Si è verificato un errore.<br/>";
              echo pg_last_error($conn);
              exit();
            }
            else {
              print ($htmlint);
              echo '<br><table>
        <tr>
          <th>Telefono</th>
          <th>Nome</td>
          <th>Cognome</th>
          <th>Via</th>
          <th>Numero</th>
          <th>Interno</th>
        </tr>';
              print ("<form action=\"basic_del.php\" method=\"POST\">");
              //passo le informazioni della tupla selezionata da cancellare
              while ($row = pg_fetch_array($result)) {
                echo '<tr>
            <td>' . $row['telc'] . '</td>
            <td>' . $row['nomec'] . '</td>
            <td>' . $row['cognomec'] . '</td>
            <td>' . $row['via'] . '</td>          
            <td>' . $row['nciv'] . '</td>
            <td>' . $row[6] . '</td>             
            <td><input type="radio" name="todelete" value=' . $row['telc'] . ' required></td>
          </tr>';
              };
              echo '</table>';
              echo "<input type=\"submit\" name=\"delete\" value=\"Delete\">";
              echo "</form>";
            };
          break;
        };
      break;
        //
        
      case 'insert':
        //l'inserimento richiede l'operazione preliminare di raccolta dei dati da inserire
        switch ($tbl) {
          case 'cliente':
            print ($htmlint);
            echo '<br><table>';
            print ("<form action=\"basic_ins.php\" method=\"POST\">");
            //passo le informazioni oggetto dell'inserimento
            print ("<tr><th>Telefono</th><td><input type=\"text\" name=\"telc\" required></td></tr>");
            print ("<tr><th>Cognome</th><td><input type=\"text\" name=\"cognomec\" required></td</tr>");
            print ("<tr><th>Nome</th><td><input type=\"text\" name=\"nomec\" required></td></tr>");
            print ("<tr><th>Password</th><td><input type=\"password\" name=\"password\" required></td></tr>");
            print ("<tr><th>Via</th><td><input type=\"text\" name=\"via\" required></td></tr>");
            print ("<tr><th>Numero Civico</th><td><input type=\"number\" name=\"nciv\" required></td></tr>");
            print ("<tr><th>Interno</th><td><input type=\"text\" name=\"nint\" required></td></tr>");
            print ("<tr><td><input type=\"submit\" name=\"toinsert\" value=\"Insert\"></td></tr>");
            print ("</form>");
            print ("</table>");
          break;
        };
      break;
        //
        
      case 'update':
        //l'operazione di aggiornamento richiede la scelta preliminare della tupla da aggiornare
        switch ($tbl) {
          case 'cliente':
            $query = "SELECT * FROM Cliente";
            $result = pg_query($conn, $query);
            if (!$result) {
              echo "Si è verificato un errore.<br/>";
              echo pg_last_error($conn);
              exit();
            }
            else {
              print ($htmlint);
              echo '<br><table>
        <tr>
          <th>Telefono</th>
          <th>Nome</td>
          <th>Cognome</th>
          <th>Via</th>
          <th>Numero</th>
          <th>Interno</th>
        </tr>';
              print ("<form action=\"basic_upd.php\" method=\"POST\">");
              //passo le informazioni della tupla selezionata da aggiornare
              while ($row = pg_fetch_array($result)) {
                echo '<tr>
            <td>' . $row['telc'] . '</td>
            <td>' . $row['nomec'] . '</td>
            <td>' . $row['cognomec'] . '</td>
            <td>' . $row['via'] . '</td>          
            <td>' . $row['nciv'] . '</td>
            <td>' . $row[6] . '</td>             
            <td><input type="radio" name="toupdate" value=' . $row['telc'] . ' required></td>
          </tr>';
              };
              echo '</table>';
              echo "<input type=\"submit\" name=\"update\" value=\"Update\">";
              echo "</form>";
            };
          break;
        };
      break;
    };
  };
}
else {//non sono stati passati correttamente i dati
  print ($htmlint);
  echo "Non risultano dati passati<br>";
  echo "Se vuoi puoi <a href='select_basic.php'>riprovare</a>";
}


function showTable($result, $columns) {
	//Intestation
	$str = '<table>';
	$str .= '<tr>';
	foreach ($columns as $col) {
		$str .= "<th> {$col} </th>";
	}
	$str .= '</tr>';
	while ($row = pg_fetch_array($result)) {
		$str .= '<tr>';
		foreach ($columns as $col) {
		$str .= "<td> {$row[$col]} </td>";
		}
	$str .= '</tr>';
	};
	return $str . '</table>';
}


?>
</BODY>
</HTML>