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
    <link href="<?= Cache::$relativePath . '/css/chat.css' ?>" rel="stylesheet">
    <link href="<?= Cache::$relativePath . '/css/content.css' ?>" rel="stylesheet">
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
            <div class="chat flex">
                <div class="chat__top flex flex-align-center font-size-s">
                    <span>#główny</span>
                    <span>
                        <span id="chat__user-count">0</span> osoby
                    </span>
                </div>
                <div class="chat__messages">
                </div>
                <div class="chat__input flex">
                    <input id="chat__input-field" placeholder="Wiadomosc..." type="text" class="input-field">
                    <button id="chat__send-button" class="button">Wyślij</button>
                </div>
            </div>
        </div>
    </section>

    <script src="<?= Cache::$relativePath . '/js/nav.js' ?>"></script>
    <script src="<?= Cache::$relativePath . '/js/ws.js' ?>"></script>
</body>
</html>