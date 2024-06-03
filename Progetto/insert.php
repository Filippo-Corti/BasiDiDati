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
  $foreignKeys = getForeignKeyConstraints($connection, $_GET['table']);

  $formFields = array_merge($formFields, getReferentialInputFields($connection, $columns, $foreignKeys));
  $formFields = array_merge($formFields, getStandardInputFields($connection, $columns));

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

function getStandardInputFields($connection, &$columns)
{
  $formFields = array();
  foreach ($columns as $col) {
    $formFields[$col['ordinal_position']] = getCorrectInputField($connection, $col);
  }
  return $formFields;
}

function getCorrectInputField($connection, $column_data)
{
  $name = ucfirst($column_data['column_name']);
  $field_type = $column_data['udt_name'];
  switch ($field_type) {
    case 'bpchar':
      return buildInputText($name, $column_data['character_maximum_length'], $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO');
      break;
    case 'varchar':
      return buildInputText($name, 0, $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO');
      break;
    case 'numeric':
      return buildInputNumber($name, $column_data['numeric_precision'], $column_data['numeric_scale'], $column_data['is_nullable'] == 'NO');
      break;
    case 'date':
      return buildInputDate($name, $column_data['is_nullable'] == 'NO');
      break;
    case 'time':
      return buildInputTime($name, $column_data['is_nullable'] == 'NO');
      break;
    case 'timestamp':
      return buildInputDateTime($name, $column_data['is_nullable'] == 'NO');
      break;
    default:
      //User-defined Enum
      $query = "SELECT enum_range(NULL::{$field_type})";
      $result = executeQuery($connection, $query);
      $enumValues = substr(pg_fetch_array($result)['enum_range'], 1, -1); //Trim { and }
      return buildInputSelect($name, explode(',', $enumValues), $column_data['is_nullable'] == 'NO');
  }
}

function getReferentialInputFields($connection, &$columns, $foreignKeys)
{
  $formFields = array();
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
    $positionInPage = array_filter($columns, fn ($el) => in_array(ucfirst($el['column_name']), $referringColumns));
    $index = max(array_map(fn ($el) => $el['ordinal_position'], $positionInPage));
    $isRequired = in_array("NO", array_map(fn ($el) => ucfirst($el['is_nullable']), array_filter($columns, fn ($el) => in_array(ucfirst($el['column_name']), $referringColumns))));
    $formFields[$index] = buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired);
    //Remove Referred Columns so that they don't appear again
    $columns = array_filter($columns, fn ($el) => !in_array(ucfirst($el['column_name']), $referringColumns));
  }
  return $formFields;
}

?>