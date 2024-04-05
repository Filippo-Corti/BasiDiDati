<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Prove</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="icon" href="favicon.png">
</head>
<body>
<style>

table, tr, td {
	border: 2px solid black;
	border-collapse: collapse;
	padding: 10px 20px;
	text-align: center;
}

</style>
  <h2>Tabella 1:</h2>
  <?php echo printTable() ?>
  <h2>Tabella 2:</h2>
  <?php echo printTable() ?>
  <h2>Input:</h2>
  <?php echo selectRange(2, 10, 'prova') ?>
  </body>
</html>

<?php

	function printTable() {
		$str = "<table>";
		for ($i = 0; $i < 5; $i++){
			$str .= "<tr>";
			for ($j =0; $j < 5; $j++) {
				$str .= "<td>" . $i*$j . "</td>";
			}
			$str .= "</tr>";
		}
		return $str . "</table>";
	}
	
	function selectRange($start, $end, $name) {
		$str = "<select name=$name id=$name>";
		for ($i = $start; $i <= $end; $i++) {
			$str .= "<option value=$i>$i</option>";
		}
		return $str . "</select>";
	}

?>