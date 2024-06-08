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
        <div class="timeline p-4 block mb-4">
            <div class="tl-item">
                <div class="tl-dot b-warning"></div>
                <div class="tl-content">
                    <div class="fw-semibold">Titolo</div>
                    <div>Descrizione</div>
                    <div class="tl-date text-muted mt-1">Data</div>
                </div>
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

function loadPatientHomePage()
{
    echo <<<EOD
    <div class="my-5 mx-2">
        <div class="rounded-5 py-3 px-3 bg-white shadow-accent">
            <div class="px-3 d-flex justify-content-between gap-1">
                <div class="pb-1 pt-4 ps-3">
                    <p class="my-0 py-0 text-green fw-semibold fs-6">
                        Home Page
                    </p>
                    <h3 class="m-0 p-0 fw-bold">
                        Bentornato Filippo Corti
                    </h3>
                    <div class="mt-3 fs-5 ms-2">
                        <p class="pb-1 m-0"> I tuoi dati:</p>
                        <ul>
                            <li> Codice Fiscale: CRTFPP03S07L319C </li>
                            <li> Data di Nascita: 2003-11-07 (Età 20 anni) </li>
                            <li> Indirizzo: (22075) Via XXV Aprile, 15 </li>
                        </ul>
                    </div>
                </div>
                <div>
                    <img src="img/patient.webp">
                </div>
            </div>
        </div>
    </div>
    <div class="row my-5">
        <div class="col-lg mx-2">
            <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
                <a class="d-flex flex-columns align-items-center justify-content-center" href="">
                    <form method="POST" action="opmanager.php">
                        <input type="hidden" name="operation" value="view_appointments">
                        <button class="btn rounded-pill btn-mine" type="submit">
                            <span class="poppins fw-normal"> &gt;</span> Richiedi una Prenotazione
                        </button>
                    </form>
                </a>
            </div>
        </div>
        <div class="col-lg mx-2">
            <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
            </div>
        </div>
    </div>
    <div class="my-5 mx-2">
        <div class="rounded-5 py-5 px-3 bg-white shadow-accent">
        </div>
    </div>
    EOD;
}

function loadWorkerHomePage()
{
    echo "Benvenuto medico";
}

?>