<?php session_start() ?>
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
		
		if(isset($_SESSION["logged_user"])) {
			# Correct
			$user = $_SESSION["logged_user"];
			echo "Benvenuto utente $user<br>";
		} else {
			# Incorrect
			echo "Devi fare il login per accedere <br>";
		}
	
		
	?>
	
</body>
</html>