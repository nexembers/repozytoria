<?php
use AI\Core\Cache;
use AI\Core\Config;
use AI\Core\Session;

$user = Session::get('user');
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= Config::HTML_TITLE ?></title>
    <link href="<?= Cache::$relativePath . '/css/app.css' ?>" rel="stylesheet">
    <link href="<?= Cache::$relativePath . '/css/nav.css' ?>" rel="stylesheet">
    <link href="<?= Cache::$relativePath . '/css/content.css' ?>" rel="stylesheet">
    <link href="<?= Cache::$relativePath . '/css/calculator.css' ?>" rel="stylesheet">
</head>
<body>
<?php
        view('components.nav-c', [
            'name'  => $user['name'],
            'email' => $user['email']
        ]);
    ?>
    
    <section class="content flex flex-justify-center">
        <div class="content__wrapper">
            <div class="content__panel">
                <h2>Kalkulator zużycia</h2>
                <p>Prąd</p>
                <div class="input-container">
                    <label for="e-price-input" class="input-label font-size-s">Cena za [zł/kWh]</label>
                    <input required id="e-price-input" type="number" class="input-field">
                </div>
                <div class="input-container">
                    <label for="e-usage-input" class="input-label font-size-s">Zużycie [W]</label>
                    <input required id="e-usage-input" type="number" class="input-field">
                </div>
                <div class="calculator-button-wrapper flex flex-align-center">
                    <button id="e-button" class="button">Przelicz</button>
                    <span id="e-result">0 zł</span>
                </div>
                <p>Gaz</p>
                <div class="input-container">
                    <label for="g-price-input" class="input-label font-size-s">Cena za [zł/kWh]</label>
                    <input required id="g-price-input" type="number" class="input-field">
                </div>
                <div class="input-container">
                    <label for="g-usage-input" class="input-label font-size-s">Zużycie [W]</label>
                    <input required id="g-usage-input" type="number" class="input-field">
                </div>
                <div class="calculator-button-wrapper flex flex-align-center">
                    <button id="g-button" class="button">Przelicz</button>
                    <span id="g-result">0 zł</span>
                </div>
            </div>
        </div>
    </section>

    <script src="<?= Cache::$relativePath . '/js/nav.js' ?>"></script>
    <script src="<?= Cache::$relativePath . '/js/calculator.js' ?>"></script>
</body>
</html>