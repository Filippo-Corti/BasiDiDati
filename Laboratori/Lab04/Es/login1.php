<?php session_start(); ?>
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
	<h1>Risultati del Login:</h1>
	
	<?php
	
		include 'vars.php';
	
		$user = $_POST["user"];
		$pwd = $_POST["password"];
		
		if(areCredentialsCorrect($user, $pwd)) {
			# Correct
			
			$_SESSION["logged_user"] = $user;
		
			echo "Utente $user le credenziali SONO VALIDE <br>";
			echo "Premi il pulsante per accedere al sito <br>";
			echo "<a href='step1.php'><button>Continua</button></a>";
		} else {
			# Incorrect
			echo "Utente $user le credenziali che hai inserito NON SONO VALIDE. <br>";
			echo "Se vuoi puoi <a href='login.html'>riprovare</a> ad accedere";
		}
		
		
		function areCredentialsCorrect($user, $pwd) {
			include 'vars.php';
		
			# Connessione al DB
			$conn = pg_connect($connection_str);
			if(!$conn) {
				return false;
			}
			
			# Interrogazione del DB
			$query = "SELECT * FROM utente WHERE username=$1 AND pwd=$2";
			$result = pg_query_params($conn, $query, array($user, $pwd));
			$found = pg_fetch_array($result, NULL, PGSQL_ASSOC);
			
			# Verifica Risultati
			if(!$found) {
				return false;
			}
			
			return true;
		}
		
	
		
	?>
	
</body>
</html>