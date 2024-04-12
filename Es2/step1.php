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
	
	</style>
	<h1>I tuoi Dati:</h1>
	
	<?php	
		
		if(isset($_COOKIE["logged_user"])) {
			# Correct
			$user = $_COOKIE["logged_user"];
			echo "Utente $user le tue credenziali sono valide<br>";
		} else {
			# Incorrect
			echo "Devi fare il login per accedere <br>";
		}
	
		
	?>
	
</body>
</html>