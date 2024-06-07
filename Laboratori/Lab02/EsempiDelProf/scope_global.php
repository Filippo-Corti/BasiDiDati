<!--scope_global.php-->
<?php
$a=1; /* global scope */
function test()
{
  global $a; // NECESSARIO
  echo $a; /* reference to global scope variable */
}
test();
?>