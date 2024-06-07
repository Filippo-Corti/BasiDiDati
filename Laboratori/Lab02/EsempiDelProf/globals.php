<!--globals.php-->
<?php
function test(){
  $a = "local";
  echo '$a in global scope: '.$GLOBALS["a"]."<br>";
  echo '$a'." in local scope: $a<br>";
}
  $a = "global"; //Questo inserisce automaticamente in $GLOBAL
  //test();
  var_dump($GLOBALS);
  //print($GLOBALS);
?>
