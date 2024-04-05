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
	table, td, tr {
		border: 1px solid black;
		border-collapse: collapse;
		padding: 3px 5px;
		text-align: left;
	}
	</style>

	<form method="POST">
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
					<select name="day" id="day">
						<option value="1">1</option>
					</select>
					<label for="month"> mese: </label>
					<select name="month" id="month">
						<option value="1">1</option>
					</select>
					<label for="year"> anno: </label>
					<select name="year" id="year">
						<option value="1970">1970</option>
					</select>
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
		</table>
	</form>

</body>
</html>