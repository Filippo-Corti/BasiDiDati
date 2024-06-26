<?php
session_start();

foreach (glob("modules/*.php") as $filename) {
    include $filename;
}

 
if (isset($_SESSION['query'])) {
    //Personalized Query
    $title = $_SESSION['query_title'];
    $query = $_SESSION['query'];
    $actions = false;
} else {
    //Standard Database Table view
    $table = getTable();
    $title = ucfirst($table);
    $query = "SELECT * FROM {$table}";
    $actions = $_SESSION['logged_user']['type'] == 'worker';
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <title>Visualizzazione | Gestore Aziende Ospedaliere
    </title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="icon" href="img/logo.svg">
    <link rel="stylesheet" href="css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>

<body>

    <header class="container-xxl mx-auto mt-3 px-4 d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-end gap-1">
            <div class="">
                <svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 200 200">
                    <polygon points="100,20 170,60 170,140 100,180 30,140 30,60" stroke="black" fill="transparent" stroke-width="16" stroke-linejoin="round" />
                    <circle cx="100" cy="100" r="25" stroke="black" fill="transparent" stroke-width="16" />
                </svg>
            </div>
            <div class="pb-1 border-bottom fw-semibold">
                <p class="my-0 py-0 text-secondary" style="font-size:10px; transform:translateY(6px);">Dashboard</p>
                <h2 class="my-0 py-0 fw-bold">Gestore Aziende Ospedaliere</h2>
            </div>
        </div>
        <div>
            <a class="d-flex flex-columns align-items-center justify-content-center" href="index.php">
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
                        <p class="my-0 py-0 text-green fw-semibold fs-6" style="transform:translateY(4px);">
                            Visualizzazione
                        </p>
                        <h3 class="m-0 p-0 fw-bold">
                            <?php
                            echo $title;
                            ?>
                        </h3>
                    </div>
                    <?php
                    if ($table && $actions) {
                        echo <<<EOD
                        <div>
                            <a class="d-flex flex-columns align-items-center justify-content-center" href="">
                                <form method="POST" action="opmanager.php">
                                    <input type="hidden" name="operation" value="goto_insert">
                                    <input type="hidden" name="table" value="{$table}">
                                    <button class="btn rounded-pill btn-mine" type="submit">
                                        <span class="poppins fw-normal"> &gt;</span> Inserisci nella Tabella
                                    </button>
                                </form>
                            </a>
                        </div>
                    EOD;
                    } ?>
                </div>
                <div class="d-flex justify-content-center mt-3">
                   <?php echo showTable() ?>
                </div>
            </div>
        </div>

    </section>


    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <?php
        echo notifyNewMessages();
        ?>
    </div>
    <script src="js/activateToasts.js" defer></script>




    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</body>

</html>

<?php

function showTable() {
    global $query, $actions, $table;
    $connection = connectToDatabase();

    try {
        $results = executeQuery($connection, $query);
    } catch (Exception $e) {
        memorizeError("Lettura dal Database", $e->getMessage());
        header("Refresh:0");
        exit();
    }
    $columns = getColumnsByResults($results);
    $resultData = pg_fetch_all($results);

    return buildTable($resultData, $columns, $table, $actions);
}

function getTable()
{
    if (isset($_SESSION['table'])) {
        return $_SESSION['table'];
    }
    return null;
}

?>