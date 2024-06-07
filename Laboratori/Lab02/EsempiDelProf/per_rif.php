<!--per_rif.php-->
<?php
function change(&$num1, &$num2)
{
  $tmp=$num1;
  $num1=$num2;
  $num2=$tmp;
}
$a=10;
$b=25;
print "Prima dello scambio a vale $a e b vale $b</br>";
change($a,$b);
echo "Dopo lo scambio a vale $a e b vale $b</br>";
?>