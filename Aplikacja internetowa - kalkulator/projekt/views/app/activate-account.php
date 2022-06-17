<?php
use AI\Core\Cache;
use AI\Core\Config;
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= Config::HTML_TITLE ?></title>
    <link href="<?= Cache::$relativePath . '/css/app.css' ?>" rel="stylesheet">
    <link href="<?= Cache::$relativePath . '/css/login.css' ?>" rel="stylesheet">
</head>
<body>
    <div class="limiter flex flex-justify-center flex-align-center">
        <form class="login-form shadow" method="POST" action="<?= Cache::$relativePath .  '/activate-account' ?>">
            <h2 class="uppercase">Aktywuj konto</h2>
            <?php
                view('components.message-c');
            ?>
            <div class="input-container">
                <label for="activation-code-input" class="input-label font-size-s">Kod</label>
                <input required id="activation-code-input" type="number" name="activation_code" class="input-field">
            </div>
            <div class="submit-container">
                <input type="submit" value="Aktywuj" class="button uppercase pointer">
            </div>
            <p class="font-size-xs">Nie otrzymałeś e-maila? 
                <a href="<?= Cache::$relativePath . '/send-activation-code' ?>">Wyślij</a>
            </p>
        </form>
    </div>
</body>
</html>