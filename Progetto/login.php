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
    <title>Login | Gestore Aziende Ospedaliere
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
    </header>

    <section class="container row mx-auto">

        <div class="col my-5 mx-4">
            <div class="rounded-5 p-5 bg-white shadow-accent">
                <div class="pb-1 fw-semibold">
                    <p class="my-0 py-0 text-green fw-semibold fs-6" style="transform:translateY(4px);">Log In
                    </p>
                    <h3 class="m-0 p-0 fw-bold">Accedi come Personale</h3>
                </div>
                <div class="mt-4">
                    <form action="opmanager.php" method="POST">
                        <input type="hidden" name="operation" value="login_as_worker">
                        <?php

                        echo buildInputText("Username", 0, 16, true);
                        echo buildInputPassword("Password", 0, 255, true);
                        ?>
                        <div class="d-flex justify-content-center me-4">
                            <button type="submit" class="btn rounded-pill btn-mine">
                                <span class="poppins fw-normal"> &gt;</span> Accedi al Portale
                            </button>
                        </div>
                    </form>
                    <p class="mt-3 fs-6 text-secondary fw-ligher text-center">Ricorda: il tuo Username corrisponde al tuo Codice Fiscale</p>
                </div>
            </div>
        </div>
        <div class="col my-5 mx-4">
            <div class="bg-accent-gradient rounded-5 p-1">
                <div class="rounded-5 p-5 bg-white shadow-accent">
                    <div class="pb-1 fw-semibold">
                        <p class="my-0 py-0 text-green fw-semibold fs-6" style="transform:translateY(4px);">Log In
                        </p>
                        <h3 class="m-0 p-0 fw-bold">Accedi come Paziente</h3>
                    </div>
                    <div class="mt-4">
                        <form action="opmanager.php" method="POST">
                            <input type="hidden" name="operation" value="login_as_patient">
                            <?php

                            echo buildInputText("Username", 0, 16, true);
                            echo buildInputPassword("Password", 0, 255, true);
                            ?>
                            <div class="d-flex justify-content-center me-4">
                                <button type="submit" class="btn rounded-pill btn-mine">
                                    <span class="poppins fw-normal"> &gt;</span> Accedi al Portale
                                </button>
                            </div>
                        </form>
                        <p class="mt-3 fs-6 text-secondary fw-ligher text-center">Ricorda: il tuo Username corrisponde al tuo Codice Fiscale</p>
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