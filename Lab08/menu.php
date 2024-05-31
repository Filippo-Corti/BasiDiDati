<!--select_basic.php-->
<html>
  <head>
    <title>Operazioni</title>
  </head>
<body>
<?php
print ("<form action=\"opt_basic.php\" method=\"POST\">");
//definisco un selettore statico per le tabelle del db
print ("<select name=\"tabella\">");
//inserisco le tabelle che voglio gestire
echo getTablesOption();
print ("</select>");
//definisco un selettore statico per le operazioni sulle tabelle
print ("<select name=\"operazione\">");
print ("<option value=\"select\">select</option>");
print ("<option value=\"insert\">insert</option>");
print ("<option value=\"update\">update</option>");
print ("<option value=\"delete\">delete</option>");
print ("</select>");
print ("<input  type=\"submit\" >");
print ("</form>");


function getTablesOption() {
	$str = "";
	$conn = pg_connect("host=localhost port=5432 dbname=pizzeria user=postgres password=dbadmin");
  
	  if (!$conn) {
		echo 'Connessione al database fallita.';
		exit();
	  }
	//echo "Connessione riuscita."."<br/>";
	$query = "SELECT * FROM information_schema.tables WHERE table_schema = 'public';";
	//echo $query;
	$result = pg_query($conn, $query);
	if (!$result) {
      echo "Si è verificato un errore.<br/>";
      echo pg_last_error($conn);
      exit();
    }
	while ($row = pg_fetch_array($result)) {
      $str .= "<option value='{$row['table_name']}'>{$row['table_name']}</option>";
    };
	
	return $str;
  
}



?>
</body>
</html>
