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
	
	main {
		margin: 0 auto;
		text-align: center;
		padding: 4rem 2rem;
		background-color: #F5EEF8;
	}
	
	table {
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
		<!-- Header -->
		<h1> <?php echo getName() ?> </h1>
		<p> <?php echo getImageByGender($_POST['gender']) ?> </p>
		
		
		<!-- Table con Data Nascita, Sesso, Condizioni di Utilizzo -->
		<?php echo getExtraInfo() ?>
		
		<!-- Attività -->
		<h3> Ciò che ti piace fare: </h3>
		<div class="attivita">
			<?php echo getActivity() ?>
		</div>
		
	</main>
	
	
	
	
	<?php #showResults() ?>

</body>
</html>

<?php

function getName() {
	$name = $_POST['name'];
	$lastname = $_POST['lastname'];
	return $name ? "Benvenuto, " . $name . " " . $lastname : "Nome non inserito";
}

function getImageByGender($gender) {
	if ($gender == 'F') {
		$i = '2';
	} else {
		$i = '';
	}
	return "<img width='300'  src='https://www.w3schools.com/howto/img_avatar" . $i . ".png'>";
}

function getExtraInfo() {
	$str = "<table>";
	$str .= "<tr><th>Data di Nascita:</th><td>" . $_POST["day"] . "/" . $_POST["month"] . "/" . $_POST["year"] . "</td></tr>";
	$str .= "<tr><th>Genere</th><td>" . $_POST["gender"] ? $_POST["gender"] : "Non specificato" . "</td></tr>";
	$str .= "<tr><th>Condizioni di Utilizzo</th><td>" . $_POST["conditions"] ? "Accettate" : "Non Accettate" . "</td></tr>";
	return $str  . "</table>";
}

function getActivity() {
	$str = "";
	$activities = $_POST["activity"];
	foreach($activities as $a) {
		$str .= "<img src='https://source.unsplash.com/random/200x300/?" . $a . " ' >";
	}
	return $str;
}




function showResults() {
	foreach($_POST as $key => $value) {
		if (gettype($value) == "array") {
			echo $key . ": ";
			print_r($value);
			echo "<br>";
		} else {
			echo $key . ": " . $value . "<br>";
		}
	}
}	

?>