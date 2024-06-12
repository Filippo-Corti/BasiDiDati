<?php
session_start();

foreach (glob("modules/*.php") as $filename) {
    include $filename;
}


?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <title>Dashboard | Gestore Aziende Ospedaliere
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
            <form action="opmanager.php" method="POST">
                <input type="hidden" name="operation" value="logout">
                <button type="submit" class="btn rounded-pill btn-mine-light ">
                    <span class="poppins fw-normal"> &gt;</span> Disconnettiti
                </button>
            </form>
        </div>
    </header>

    <section class="container mx-auto">
        <?php

        if (!isset($_SESSION['logged_user'])) {
            memorizeError("Accesso", "Accedi per poter accedere alla Home Page");
            header("Location: {$DEFAULT_DIR}/login.php");
            exit();
        }

        $loggedUser = $_SESSION['logged_user'];

        switch ($loggedUser['type']) {
            case 'patient':
                echo loadPatientHomePage();
                break;
            case 'worker':
                echo loadWorkerHomePage();
                break;
        }

        ?>
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

function loadPatientHomePage()
{

    global $loggedUser;

    $connection = connectToDatabase();

    $userData = getPatientInfo($connection, $loggedUser['username']);
    $userAppointments = getPatientFutureAppointments($connection, $loggedUser['username']);
    $latestHospitalization = getPatientLatestHospitalization($connection, $loggedUser['username']);
    $diagnosis = getDiagnosis($connection, $latestHospitalization['codice']);


    $userTimeline = buildAppointmentsTimeline($userAppointments);
    $dataFine = $latestHospitalization['ospedale'] or "IN CORSO";

    echo <<<EOD
    <div class="my-5 mx-2">
        <div class="bg-accent-gradient rounded-5 p-1">
            <div class="rounded-5 py-3 px-3 bg-white shadow-accent">
                <div class="px-3 d-flex justify-content-between gap-1">
                    <div class="pb-1 pt-4 ps-3">
                        <p class="my-0 py-0 text-green fw-semibold fs-6">
                            Home Page
                        </p>
                        <h3 class="m-0 p-0 fw-bold">
                            Bentornato {$userData['nome']} {$userData['cognome']}
                        </h3>
                        <div class="mt-3 fs-5 ms-2">
                            <table class="ps-5">
                                <tr> <th class="text-uppercase fw-semibold"> Codice Fiscale </th><td class="my-1"> {$userData['cf']} </td> </tr>
                                <tr> <th class="text-uppercase fw-semibold"> Data di Nascita </th><td class="my-1"> {$userData['datanascita']} (Età {$userData['eta']} anni) </td> </tr>
                                <tr> <th class="text-uppercase fw-semibold"> Indirizzo </th><td class="my-1"> ({$userData['cap']}) Via {$userData['via']}, {$userData['nciv']} </td> </tr>
                            </table>
                        </div>
                    </div>
                    <div>
                        <img src="img/patient.webp">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div>
        <div class="d-flex align-items-center justify-content-center">
            <form method="POST" action="opmanager.php">
                <input type="hidden" name="operation" value="request_appointment">
                <button class="btn rounded-pill btn-mine" type="submit">
                    <span class="poppins fw-normal"> &gt;</span> Richiedi una Prenotazione
                </button>
            </form>
        </div>
        <p class="text-secondary text-center pt-3 mb-0"> Per prenotare per un Esame è necessario effettuare una Richiesta. <br>
        Le richieste vengono elaborate il prima possibile dal nostro Personale. </p>
    </div>
    <div class="row my-5">
        <div class="col-lg mx-2">
            <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
                <h4 class="fw-bold ps-4">
                    Il tuo ultimo Ricovero:
                </h4>
                <div class="row ps-4">
                    <table class="ps-5">
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Ospedale </th><td class="my-1"> {$latestHospitalization['ospedale']} </td> </tr>
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Reparto </th><td class="my-1"> {$latestHospitalization['reparto']} </td> </tr>
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Stanza </th><td class="my-1"> {$latestHospitalization['stanza']} </td> </tr>
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Data di Accettazione </th><td class="my-1"> {$latestHospitalization['datainizio']} </td> </tr>
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Data di Dimissione </th><td class="my-1"> {$dataFine} </td> </tr>
                        <tr> <th style="max-width:70px" class="text-uppercase fw-semibold"> Diagnosi </th><td class="my-1">  {$diagnosis}  </td> </tr>
                    </table>
                </div>
                <div class="mt-4 d-flex justify-content-end">
                    <form method="POST" action="opmanager.php">
                        <input type="hidden" name="operation" value="view_hospitalizations">
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span> Visualizza tutti i Ricoveri
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg mx-2">
            <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
                <h4 class="m-0 p-0 fw-bold ps-4">
                    Le tue Prenotazioni future:
                </h4>
                <div class="timeline p-3 block mb-4">
                    {$userTimeline}
                </div>
                <div class="d-flex justify-content-end">
                    <form method="POST" action="opmanager.php">
                        <input type="hidden" name="operation" value="view_appointments">
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span> Visualizza tutte le Prenotazioni
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    EOD;
}

function loadWorkerHomePage()
{

    global $loggedUser;

    $connection = connectToDatabase();

    $userData = getWorkerInfo($connection, $loggedUser['username']);

    $appointmentRequests = getAppointmentRequests($connection);
    $countRequests = count($appointmentRequests);

    $appointmentsTable = buildAppointmentRequestsTable($appointmentRequests);

    $tables = array_map(fn ($el) => $el['table'], getAllTables($connection));
    $tablesSelection = buildInputSelect("Tabella", array_map('ucfirst', $tables), true);

    echo <<<EOD
    <div class="my-5 mx-2">
        <div class="bg-accent-gradient rounded-5 p-1">
            <div class="rounded-5 py-3 px-3 bg-white shadow-accent">
                <div class="px-3 d-flex justify-content-between gap-1">
                    <div class="pb-1 pt-4 ps-3">
                        <p class="my-0 py-0 text-green fw-semibold fs-6">
                            Home Page
                        </p>
                        <h3 class="m-0 p-0 fw-bold">
                            Bentornato {$userData['nome']} {$userData['cognome']}
                        </h3>
                        <div class="mt-3 fs-5 ms-2">
                            <table class="ps-5">
                                <tr> <th class="text-uppercase fw-semibold"> Codice Fiscale </th><td class="my-1"> {$userData['cf']} </td> </tr>
                                <tr> <th class="text-uppercase fw-semibold"> Data di Nascita </th><td class="my-1"> {$userData['datanascita']} (Età {$userData['eta']} anni) </td> </tr>
                                <tr> <th class="text-uppercase fw-semibold"> Indirizzo </th><td class="my-1"> ({$userData['cap']}) Via {$userData['via']}, {$userData['nciv']} </td> </tr>
                            </table>
                        </div>
                    </div>
                    <div>
                        <img src="img/worker.webp">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="my-5 mx-2">
        <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
            <h4 class="m-0 p-0 fw-bold ps-4">
                Ci sono {$countRequests} Richieste di Prenotazione:
            </h4>
            <div class="mt-3 fs-5 ms-2">
                {$appointmentsTable}
            </div>
        </div>
    </div>

    <div class="my-5 mx-2 d-flex justify-content-around flex-wrap gap-4">
        <div class="action-card rounded-5 p-1">
            <div class="rounded-5 py-5 m px-3 bg-white shadow-accent" style="max-width:15rem">
                <h5 class="m-0 p-0 fw-bold text-center" style="min-height:3lh">
                    Visualizza Personale per Reparto
                </h5>
                <div class="mt-4 fs-5 ms-2 ps-4 d-flex justify-content-start">
                    <a href="pages/personalereparto.php">
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span>  Vai alla pagina
                        </button>
                    </a>
                </div>
            </div>
        </div>
        <div class="action-card rounded-5 p-1">
            <div class="rounded-5 py-5 m px-3 bg-white shadow-accent" style="max-width:15rem">
                <h5 class="m-0 p-0 fw-bold text-center" style="min-height:3lh">
                    Visualizza Ricoveri per Paziente
                </h5>
                <div class="mt-4 fs-5 ms-2 ps-4 d-flex justify-content-start">
                    <a href="pages/ricoveripaziente.php">
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span>  Vai alla pagina
                        </button>
                    </a>
                </div>
            </div>
        </div>
        <div class="action-card rounded-5 p-1">
            <div class="rounded-5 py-5 m px-3 bg-white shadow-accent" style="max-width:15rem">
                <h5 class="m-0 p-0 fw-bold text-center" style="min-height:3lh">
                    Visualizza Vice Primari per Numero di Sostituzioni
                </h5>
                <div class="mt-4 fs-5 ms-2 ps-4 d-flex justify-content-start">
                    <a href="pages/viceprimariinfo.php">
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span>  Vai alla pagina
                        </button>
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="my-5 mx-2 d-flex justify-content-around flex-wrap gap-4">
        <div class="action-card rounded-5 p-1">
            <div class="rounded-5 py-5 m px-3 bg-white shadow-accent" style="min-width:25rem">
                <h5 class="m-0 p-0 fw-bold text-center">
                    Visualizza una Tabella del DB
                </h5>
                <div class="mt-4 fs-5 ms-2 d-flex flex-column align-items-center justify-content-center gap-3">
                    <form method="POST" action="opmanager.php">
                        <input type="hidden" name="operation" value="view_table_by_select">
                        {$tablesSelection}
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span>  Vai alla pagina
                        </button>
                    </form>
                </div>
            </div>
        </div>
        <div class="action-card rounded-5 p-1">
            <div class="rounded-5 py-5 m px-3 bg-white shadow-accent" style="min-width:25rem">
                <h5 class="m-0 p-0 fw-bold text-center">
                    Inserisci in una Tabella del DB
                </h5>
                 <div class="mt-4 fs-5 ms-2 d-flex flex-column align-items-center justify-content-center gap-3">
                    <form method="POST" action="opmanager.php">
                        <input type="hidden" name="operation" value="insert_by_select">
                        {$tablesSelection}
                        <button class="btn rounded-pill btn-mine-light" type="submit">
                            <span class="poppins fw-normal"> &gt;</span>  Vai alla pagina
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    EOD;
}

?>