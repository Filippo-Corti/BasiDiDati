<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Lab 03</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="icon" href="favicon.png">
</head>
<body>
	<style>
	</style>

    <?php

    # Read JSON from File
    $libri_json = file_get_contents("libri.json");
    echo "<h2>Contenuto letto dal file JSON: </h2> $libri_json <br>";

    # Print File Content
    $libri_decoded = json_decode($libri_json, true);
    echo "<h2> Contenuto riformattato: </h2>";
    echo build_list($libri_decoded, "ul");

    # Write CSV on File
    $fp = fopen("libri.csv", 'w');
    foreach($libri_decoded["libri"] as $libro) {
        fputcsv($fp, $libro);
    }

    # Print New File Content
    echo "<h2> Contenuto scritto sul file CSV: </h2>";
    echo file_get_contents("libri.csv");
    

    function build_list($array, $type) {
        $str = "<$type>";
        foreach($array as $v) {
            if (gettype($v) == "array") {
                $str .= "<li><br>" . build_list($v, $type) . "</li>";
            } else {
                $str .= "<li>$v</li>";
            }
        }
        return $str . "</$type>";
    }


    ?>

</body>
</html>