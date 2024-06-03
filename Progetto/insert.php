<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <title>Ospedali | Insert</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="icon" href="favicon.png">
</head>

<body>
  <h1>Inserisci in "<?php echo ucfirst($_GET['table']) ?>":</h1>

  <form action="" method="GET">
    <?php echo fillInsertForm(); ?>
    <input type="submit" value="Send">
  </form>

</body>

</html>


<?php


function fillInsertForm()
{
  include 'utils.php';
  $formFields = array();

  $connection = connectToDatabase();
  $columns = pg_fetch_all(getColumnsInformation($connection, $_GET['table']));

  //Check for eventual Foreign Key Constraints
  $foreignKeys = getForeignKeyConstraints($connection, $_GET['table']);
  $referencedTables = array_unique(array_map(fn ($el) => $el['referredtable'], $foreignKeys));

  foreach ($referencedTables as $referencedTable) {
    //Find Referenced and Referring Columns
    $referencedData = array_filter($foreignKeys, function ($el) use ($referencedTable) {
      return $el['referredtable'] == $referencedTable;
    });
    $referencedColumns = array_map(fn ($el) => $el['referredcolumn'], $referencedData);
    $referringColumns = array_map(fn ($el) => ucfirst($el['column_name']), $referencedData);
    $referencedColumnsString = implode(", ", $referencedColumns);
    $referringColumnsString = implode(" - ", $referringColumns);
    //Execute Query to get Selection Data 
    $query = "SELECT {$referencedColumnsString} FROM {$referencedTable}";
    $dataForSelectInput = executeQuery($connection, $query);
    $dataForSelectInput = array_map(fn ($el) => implode(' - ', $el), pg_fetch_all($dataForSelectInput));
    //Create Selection
    $positionInPage = array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns));
    $index = max(array_map(fn($el) => $el['ordinal_position'], $positionInPage));
    $formFields[$index] = buildInputSelect($referringColumnsString, $dataForSelectInput, false);
    //Remove Referred Columns so that they don't appear again
    $columns = array_filter($columns, fn($el) => !in_array(ucfirst($el['column_name']), $referringColumns));
  }

  foreach ($columns as $row) {
    $name = ucfirst($row['column_name']);

    //Find correct Input
    $field_type = $row['udt_name'];
    switch ($field_type) {
      case 'bpchar':
        $formFields[$row['ordinal_position']] = buildInputText($name, $row['character_maximum_length'], $row['character_maximum_length'], $row['is_nullable'] == 'NO');
        break;
      case 'varchar':
        $formFields[$row['ordinal_position']] = buildInputText($name, 0, $row['character_maximum_length'], $row['is_nullable'] == 'NO');
        break;
      case 'numeric':
        $formFields[$row['ordinal_position']] = buildInputNumber($name, $row['numeric_precision'], $row['numeric_scale'], $row['is_nullable'] == 'NO');
        break;
      case 'date':
        $formFields[$row['ordinal_position']] = buildInputDate($name, $row['is_nullable'] == 'NO');
        break;
      case 'time':
        $formFields[$row['ordinal_position']] = buildInputTime($name, $row['is_nullable'] == 'NO');
        break;
      case 'timestamp':
        $formFields[$row['ordinal_position']] = buildInputDateTime($name, $row['is_nullable'] == 'NO');
        break;
      default:
        //User-defined Enum
        $query = "SELECT enum_range(NULL::{$field_type})";
        $result = executeQuery($connection, $query);
        $enumValues = substr(pg_fetch_array($result)['enum_range'], 1, -1); //Trim { and }
        $formFields[$row['ordinal_position']] = buildInputSelect($name, explode(',', $enumValues), $row['is_nullable'] == 'NO');
    }
  }
  ksort($formFields);
  return implode('', $formFields);
}

function getColumnsInformation($connection, $tableName)
{
  $query = "SELECT * FROM information_schema.columns WHERE table_name = $1 ORDER BY ordinal_position";
  return executeQuery($connection, $query, array($tableName));
}

function getForeignKeyConstraints($connection, $tableName)
{
  $query = <<<QRY
    SELECT A.column_name, B.table_name AS referredTable, B.column_name AS referredColumn
    FROM (information_schema.referential_constraints NATURAL JOIN information_schema.key_column_usage) AS A
    JOIN information_schema.key_column_usage B 
    ON A.unique_constraint_name = B.constraint_name
    AND A.position_in_unique_constraint = B.ordinal_position
    WHERE A.constraint_name IN (
      SELECT constraint_name
      FROM information_schema.key_column_usage
      WHERE table_name = $1
      AND constraint_name LIKE '%_fkey'
  )
  QRY;
  $results = executeQuery($connection, $query, array($tableName));
  return pg_fetch_all($results);
}

?>