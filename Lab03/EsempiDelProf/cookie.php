<!--cookie.php-->
<?php
	setcookie("test_cookie","Paolo",time()+10,"/");
	echo "<HTML>";
	echo "<BODY>";
	var_dump($_COOKIE);
	echo("<br>");
	if(isset($_COOKIE["test_cookie"]))
	{
		echo ("Cookie is set.<br>");
	};

	if (isset($_COOKIE["test_cookie"])){
		echo "Ciao " . $_COOKIE["test_cookie"];
	} else {
		echo "Non ho trovato alcun cookie con il nome test_cookie";
	}
	echo "</BODY>";
	echo "</HTML>";
?>