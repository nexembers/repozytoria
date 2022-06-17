<?php
use AI\Controllers\ChatController;
use AI\Core\Cache;
use AI\Core\Config;
use AI\Core\Session;

$user = Session::get('user');

$search = $props['search'] ?? '';
$topChatters = ChatController::topChatters($search);
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
                <h2>Ranking</h2>
                <form method="GET" action="<?= Cache::$relativePath . '/leaderboard' ?>">
                    <?php
                        view('components.message-c');
                    ?>
                    <p>Szukaj</p>
                    <div class="input-container flex flex-align-center">
                        <input value="<?= $search ?>" placeholder="Email..." required type="text" name="search" class="input-field">
                        <input style="width: 150px;" type="submit" value="Szukaj" class="button uppercase pointer">
                    </div>
                </form>
                <?php
                    view('components.leaderboard-table-c', [
                        'data' => $topChatters 
                    ]);
                ?>
            </div>
        </div>
    </section>
    
    <script src="<?= Cache::$relativePath . '/js/nav.js' ?>"></script>
</body>
</html>