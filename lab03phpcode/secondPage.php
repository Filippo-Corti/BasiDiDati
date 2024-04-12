<!--secondPage.php-->
<?php
  session_start();
  echo "<HTML><BODY>";
  if(isset($_SESSION["nome"]))
  {   
      echo "la variabile di sessione 'nome' ha valore: ".$_SESSION["nome"];
  } else {
      echo "la variabile di sessione 'nome' non ha valore";
  };
  echo "<br>";
  unset($_SESSION["nome"]);
  if(isset($_SESSION["nome"]))
  {
      echo "la variabile di sessione 'nome' ha valore: ".$_SESSION["nome"];
  } else {
	  echo "la variabile di sessione 'nome' non ha valore";
  };	
?>
</BODY></HTML>