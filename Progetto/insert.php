<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <title>Inserimento | Gestore Aziende Ospedaliere
  </title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="icon" href="img/logo.svg">
  <link rel="stylesheet" href="css/style.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>

<body>

  <header class="container-xxl mx-auto mt-3 px-4 d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-end gap-1">
      <div class="">
        <svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 200 200">
          <polygon points="100,20 170,60 170,140 100,180 30,140 30,60" stroke="black" fill="transparent"
            stroke-width="16" stroke-linejoin="round" />
          <circle cx="100" cy="100" r="25" stroke="black" fill="transparent" stroke-width="16" />
        </svg>
      </div>
      <div class="pb-1 border-bottom fw-semibold">
        <p class="my-0 py-0 text-secondary" style="font-size:10px; transform:translateY(6px);">Dashboard</p>
        <h2 class="my-0 py-0 fw-bold">Gestore Aziende Ospedaliere</h2>
      </div>
    </div>
    <div>
      <a class="d-flex flex-columns align-items-center justify-content-center" href="">
        <button class="btn rounded-pill btn-mine-light ">
          <span class="poppins fw-normal"> &lt;</span> Torna alla Home
        </button>
      </a>
    </div>
  </header>

  <section class="container mx-auto">
    <div class="my-5 mx-2">
      <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
        <div class="px-3 d-flex align-items-center justify-content-between gap-1">
          <div class="pb-1 fw-semibold">
            <p class="my-0 py-0 text-green fw-semibold fs-6" style="transform:translateY(4px);">Inserimento
            </p>
            <h3 class="m-0 p-0 fw-bold">
              <?php echo ucfirst($_GET['table']) ?>
            </h3>
          </div>
          <div>
            <a class="d-flex flex-columns align-items-center justify-content-center" href="">
              <button class="btn rounded-pill btn-mine ">
                <span class="poppins fw-normal"> &gt;</span> Visualizza la Tabella
              </button>
            </a>
          </div>
        </div>
        <div class="m-3">
          <form method="POST" action="opmanager.php">
            <input type="hidden" name="operation" value="insert">
            <input type="hidden" name="table" value="<?php echo $_GET['table'] ?>">
            <?php echo buildInsertForm(); ?>

            <input class="btn rounded-pill btn-mine" type="submit" value="Inserisci">

          </form>

        </div>
      </div>
    </div>

  </section>


  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
    integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
    integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
    crossorigin="anonymous"></script>
</body>

</html>

<?php


function buildInsertForm()
{
  include 'utils.php';
  $formFields = array();

  $connection = connectToDatabase();

  $columns = pg_fetch_all(getColumnsInformation($connection, $_GET['table']));
  $foreignKeys = getForeignKeyConstraints($connection, $_GET['table']);

  $formFields += getReferentialInputFields($connection, $columns, $foreignKeys);
  $formFields += getStandardInputFields($connection, $columns);

  ksort($formFields);


  return implode('', $formFields);
}


function getForeignKeyConstraints($connection, $tableName)
{
  $query = <<<QRY
    SELECT A.constraint_name, A.column_name, B.table_name AS referredTable, B.column_name AS referredColumn, B.ordinal_position
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
    ORDER BY B.table_name, B.ordinal_position; 
  QRY;
  try {
    $results = executeQuery($connection, $query, array($tableName));
  } catch (Exception $e) {
    notifyError($e->getMessage());
  }
  return pg_fetch_all($results);
}

function getStandardInputFields($connection, &$columns)
{
  $formFields = array();
  foreach ($columns as $col) {
    $formFields[$col['ordinal_position']] = getStandardInputField($connection, $col);
  }
  return $formFields;
}

function getReferentialInputFields($connection, &$columns, $foreignKeys)
{
  $formFields = array();
  $referencedTables = array();
  foreach ($foreignKeys as $fk) {
    if ($fk['ordinal_position'] == 1) {
      $referencedTables[] = array('constraint' => $fk['constraint_name'], 'referredtable' => $fk['referredtable']);
    }
  }
  foreach ($referencedTables as $referencedTable) {
    $formField = getReferentialInputField($connection, $columns, $foreignKeys, $referencedTable, $index);
    $formFields[$index] = $formField;
  }
  return $formFields;
}

function getStandardInputField($connection, $column_data)
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
      try {
        $result = executeQuery($connection, $query);
      } catch (Exception $e) {
        notifyError($e->getMessage());
      }
      $enumValues = substr(pg_fetch_array($result)['enum_range'], 1, -1); //Trim { and }
      return buildInputSelect($name, explode(',', $enumValues), $column_data['is_nullable'] == 'NO');
  }
}

function getReferentialInputField($connection, &$columns, $foreignKeys, $referencedTable, &$index)
{
  //Find Referenced and Referring Columns
  $referencedData = array();
  $constraintName = $referencedTable['constraint'];
  $referencedTable = $referencedTable['referredtable'];
  foreach ($foreignKeys as $fk) {
    if ($fk['referredtable'] == $referencedTable && $constraintName = $fk['constraint_name']) {
      $referencedData[] = $fk;
    }
  }
  $referencedColumns = array_map(fn($el) => $el['referredcolumn'], $referencedData);
  $referencedColumnsString = implode(", ", $referencedColumns);
  $referringColumns = array_map(fn($el) => ucfirst($el['column_name']), $referencedData);
  $referringColumnsString = implode(", ", $referringColumns);

  //Execute Query to get Selection Data 
  $query = "SELECT {$referencedColumnsString} FROM {$referencedTable}";
  try {
    $dataForSelectInput = executeQuery($connection, $query);
  } catch (Exception $e) {
    notifyError($e->getMessage());
  }
  $dataForSelectInput = array_map(fn($el) => implode(', ', $el), pg_fetch_all($dataForSelectInput));

  //Find Correct Index in the Page 
  $positionInPage = array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns));
  $index = max(array_map(fn($el) => $el['ordinal_position'], $positionInPage));
  $isRequired = in_array("NO", array_map(fn($el) => ucfirst($el['is_nullable']), array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns))));

  //Remove Referred Columns so that they don't get evaluated again
  $columns = array_filter($columns, fn($el) => !in_array(ucfirst($el['column_name']), $referringColumns));

  return buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired);
}


?>