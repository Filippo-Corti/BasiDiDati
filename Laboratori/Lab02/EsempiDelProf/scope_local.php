<!--scope_local.php-->
<?php
$a=1; /* global scope */
function test()
{
  $a=2; 
  echo $a; /* reference to local scope variable */
}
test();
?>