<!--opternario.php-->
<?php
	$username = "Non utente";
	$msg = "Ciao " . ( $username ? $username : 'utente' );
	echo $msg;
?>