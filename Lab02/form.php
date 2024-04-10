<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Hello, world!</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="icon" href="favicon.png">
</head>
<body>
	<style>
	* {
		box-sizing: border-box;
	}

	table, td, tr {
		border: 1px solid white;
		border-collapse: collapse;
		padding: 3px 5px;
		text-align: left;
		
		background-color: #618685;
		color: white;
		
	}
	</style>

	<form method="POST" action="results.php">
		<table>
			<tr>
				<th>Nome:</th>
				<td>
					<input type="text" name="name" id="name"> 
				</td>
			</tr>
			<tr>
				<th>Cognome:</th>
				<td>
					<input type="text" name="lastname" id="lastname"> 
				</td>
			</tr>
			<tr>
				<th>Data nascita:</th>
				<td>
					<label for="day"> giorno: </label>
					<?php echo selectRange(1, 31, 'day') ?>
					<label for="month"> mese: </label>
					<?php echo selectRange(1, 12, 'month') ?>
					<label for="year"> anno: </label>
					<?php echo selectRange(1970, 2024, 'year') ?>
				</td>
			</tr>
			<tr>
				<th>Sesso:</th>
				<td>
					<input type="radio" id="male" name="gender" value="M">
					<label for="male">Maschio </label>
					<input type="radio" id="female" name="gender" value="F">
					<label for="female">Femmina </label>
				</td>
			</tr>
			<tr>
				<th>Attività:</th>
				<td>
					<input type="checkbox" id="ski" name="activity[]" value="ski">
					<label for="ski">Sci</label> <br>
					<input type="checkbox" id="tennis" name="activity[]" value="tennis">
					<label for="tennis">Tennis</label> <br>
					<input type="checkbox" id="golf" name="activity[]" value="golf">
					<label for="golf">Golf</label> <br>
					<input type="checkbox" id="canoe" name="activity[]" value="rafting">
					<label for="canoe">Canoa</label> <br>
					<input type="checkbox" id="other" name="activity[]" value="sports">
					<label for="other">Altro</label> <br>
				</td>
			</tr>
			<tr>
				<th>Condizioni di utilizzo</th>
				<td>
					<input style="width:100%" type="text" value="bla bla bla bla bla bla bla bla bla bla bla" disabled>
					<br>
					<input type="checkbox" id="conditions" name="conditions" value="ok">
					<label for="conditions">Accetto</label> <br>
				</td>
			</tr>
			<tr>
				<td style="text-align:center" colspan="2">
					<input type="submit" value="OK">
					<input type="reset" value="Cancella">
				</td>
			</tr>
		</table>
	</form>

</body>

<?php

function selectRange($start, $end, $name) {
	$str = "<select name=$name id=$name>";
	for ($i = $start; $i <= $end; $i++) {
		$str .= "<option value=$i>$i</option>";
	}
	return $str . "</select>";
}

?>

</html>

