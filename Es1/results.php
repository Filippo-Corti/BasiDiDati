<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Lab03</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="icon" href="favicon.png">
</head>
<body>
	<style>
	
	main {
		margin: 0 auto;
		text-align: left;
		padding: 4rem 2rem;
	}
	
	table, tr, td, th {
		border: 1px solid black;
		border-collapse: collapse;
		padding: 3px 5px;
		text-align: left;
	}
	
	.attivita {
		grid-template-columns: repeat(3, auto); 
		justify-content: center;
		gap: 0.4rem;
	}
	
	</style>
	
	<main>
	
	<?php showResults() ?>
		
	</main>
	

</body>
</html>

<?php


function showResults() {
	$expected = array("name", "lastname", "day", "month", "year", "gender", "activity", "conditions");
	
	$missing_fields = array_filter($expected, function($s) {
		return empty($_POST[$s]);
	});
	
	$compiled_fields = array_filter($expected, function($s) {
		return !empty($_POST[$s]);
	});
	
	echo "Sono stati rilevati " . count($missing_fields) . " errori. <br>";
	
	if(count($missing_fields) != 0) {
		echo "Non sono stati inseriti i dati per i seguenti campi: <br>";
		echo build_list($missing_fields, "ol");
	}
	
	if(!empty($_POST["activity"])){
		echo "Hai inserito i seguenti dati relativi alle attività:";
		echo build_list($_POST["activity"], "ul");
		$activities_count = count($_POST["activity"]);
	
		function get_activites_row() {
			$str = "";
			foreach($_POST["activity"] as $v){
				$str .= "<td>$v</td>";
			}
			return $str;
		}
		
		$activites_cells = get_activites_row();
	}
	
	
	
	
	if(count($missing_fields) != 0) {
		echo "Per favore <a href='form.php'> riprova </a>";
	} else {
		echo "<p>Riepilogo dei dati inseriti:</p>";
		echo <<<EOD
		<table>
		</tr>
			<th>Utente</th>
			<th>Data di nascita</th>
			<th>Sesso</th>
			<th colspan="$activities_count">Attività</th>
		</tr>
		<tr>
			<td>{$_POST["lastname"]} {$_POST["name"]}</td>
			<td>{$_POST["day"]}-{$_POST["month"]}-{$_POST["year"]}</td>
			<td>{$_POST["gender"]}</td>
			$activites_cells
		</tr>
		</table>
		EOD;
		
	}
	
}	

function build_list($array, $type) {
	$str = "<$type>";
	foreach($array as $v) {
		$str .= "<li>$v</li>";
	}
	return $str . "</$type>";
}

?>