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
	
		$user = $_POST["user"];
		$pwd = $_POST["password"];
		
		if($pwd == "abc") {
			# Correct
			
			setcookie("logged_user",$user,time()+30,"/");
		
			echo "Premi il pulsante per accedere al sito <br>";
			echo "<a href='step1.php'><button>Continua</button></a>";
		} else {
			# Incorrect
			echo "Utente $user la password che hai inserito non risulta essere valida. <br>";
			echo "Se vuoi puoi <a href='login.html'>riprovare</a> ad accedere";
		}
		
	
		
	?>
	
</body>
</html>