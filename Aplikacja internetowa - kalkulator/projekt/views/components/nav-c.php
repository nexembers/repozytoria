<?php
use AI\Core\Cache;
?>
<div class="nav-toggle-button fixed"></div>
<nav class="nav-bar shadow fixed">
    <div class="user-info flex flex-justify-center flex-align-center">
        <img class="user-info__image" src="<?= Cache::$relativePath . '/img/profile.png' ?>">
        <h3 class="text-center">
            <?= $props['name'] ?>
            <span class="user-info__email font-size-xs"><?= $props['email'] ?></span>
        </h3>
    </div>
    <ul class="nav-bar__menu font-size-s">
        <li>
            <a href="<?= Cache::$relativePath . '/' ?>" class="link flex flex-align-center">
                <span <?= Cache::$path == '/' ? 'class="nav--active"' : '' ?>>Czat</span>
                <img src="<?= Cache::$relativePath . '/img/chat.png' ?>">
            </a>
        </li>
        <li>
            <a href="<?= Cache::$relativePath . '/leaderboard' ?>" class="link flex flex-align-center">
                <span <?= Cache::$path == '/leaderboard' ? 'class="nav--active"' : '' ?>>Ranking</span>
                <img src="<?= Cache::$relativePath . '/img/leaderboard.png' ?>">
            </a>
        </li>
        <li>
            <a href="<?= Cache::$relativePath . '/calculator' ?>" class="link flex flex-align-center">
                <span <?= Cache::$path == '/calculator' ? 'class="nav--active"' : '' ?>>Kalkulator</span>
                <img src="<?= Cache::$relativePath . '/img/calculator.png' ?>">
            </a>
        </li>
        <li>
            <a href="<?= Cache::$relativePath . '/account' ?>" class="link flex flex-align-center">
                <span <?= Cache::$path == '/account' ? 'class="nav--active"' : '' ?>>Konto</span>
                <img src="<?= Cache::$relativePath . '/img/account.png' ?>">
            </a>
        </li>
    </ul>
    <div class="nav-bar__logout">
        <a href="<?= Cache::$relativePath . '/logout' ?>" class="button link font-size-xs flex flex-justify-center flex-align-center">Wyloguj</a>
    </div>
</nav>