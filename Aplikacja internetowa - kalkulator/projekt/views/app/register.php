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
        <form class="login-form shadow" method="POST" action="<?= Cache::$relativePath .  '/register' ?>">
            <h2 class="uppercase">Rejestracja</h2>
            <?php
                view('components.message-c');
            ?>
            <div class="input-container">
                <label for="name-input" class="input-label font-size-s">Nazwa</label>
                <input required id="name-input" type="text" name="name" class="input-field">
            </div>
            <div class="input-container">
                <label for="email-input" class="input-label font-size-s">E-mail</label>
                <input required id="email-input" type="email" name="email" class="input-field">
            </div>
            <div class="input-container">
                <label for="password-input" class="input-label font-size-s">Hasło</label>
                <input required id="password-input" type="password" name="password" class="input-field">
            </div>
            <div class="input-container">
                <label for="password-confirm-input" class="input-label font-size-s">Powtórz hasło</label>
                <input required id="password-confirm-input" type="password" name="password_confirm" class="input-field">
            </div>
            <div class="submit-container">
                <input type="submit" value="Zarejestruj" class="button uppercase pointer">
            </div>
            <p class="font-size-xs">Posiadasz konto? 
                <a href="<?= Cache::$relativePath . '/login' ?>">Zaloguj się</a>
            </p>
        </form>
    </div>
</body>
</html>