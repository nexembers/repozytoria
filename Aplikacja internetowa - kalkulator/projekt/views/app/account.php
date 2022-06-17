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
                <h2>Konto</h2>
                <form method="POST" action="<?= Cache::$relativePath .  '/change-password' ?>">
                    <p>Zmień hasło</p>
                    <?php
                        view('components.message-c');
                    ?>
                    <div class="input-container">
                        <label for="email-input" class="input-label font-size-s">E-mail</label>
                        <input disabled required value="<?= $user['email'] ?>" id="email-input" type="email" name="email" class="input-field">
                    </div>
                    <div class="input-container">
                        <label for="password-input" class="input-label font-size-s">Hasło</label>
                        <input required id="password-input" type="password" name="password" class="input-field">
                    </div>
                    <div class="input-container">
                        <label for="new-password-input" class="input-label font-size-s">Nowe hasło</label>
                        <input required id="new-password-input" type="password" name="new_password" class="input-field">
                    </div>
                    <div class="input-container">
                        <label for="new-password-confirm-input" class="input-label font-size-s">Powtórz nowe hasło</label>
                        <input required id="new-password-confirm-input" type="password" name="new_password_confirm" class="input-field">
                    </div>
                    <div class="submit-container">
                        <input style="width: 150px;" type="submit" value="Zapisz" class="button uppercase pointer">
                    </div>
                </form>
            </div>
        </div>
    </section>

    <script src="<?= Cache::$relativePath . '/js/nav.js' ?>"></script>
</body>
</html>