<?php

require_once __DIR__ . '/vendor/autoload.php';

use AI\Core\Session;
use AI\Core\Router;

use AI\Middlewares\ActivationMiddleware;
use AI\Middlewares\AuthMiddleware;

use AI\Controllers\AuthController;
use AI\Controllers\UserController;

Session::start();

Router::middleware([AuthMiddleware::class, 'authenticated'], function() {
    Router::get('/login', function() {
        view('app.login');
    });
    
    Router::post('/login', [AuthController::class, 'login']);
    
    Router::get('/register', function() {
        view('app.register');
    });

    Router::post('/register', [AuthController::class, 'register']);
});

Router::middleware([AuthMiddleware::class, 'unauthenticated'], function() {
    Router::get('/logout', [AuthController::class, 'logout']);
    Router::post('/change-password', [UserController::class, 'changePassword']);

    Router::get('/', function() {
        view('app.index');
    });

    Router::get('/leaderboard', function($request) {
        view('app.leaderboard', [
            'search' => $request->search
        ]);
    });

    Router::get('/calculator', function() {
        view('app.calculator');
    });

    Router::get('/account', function() {
        view('app.account');
    });
});

Router::middleware([ActivationMiddleware::class, 'valid'], function() {
    Router::get('/activate-account', function() {
        view('app.activate-account');
    });
    
    Router::post('/activate-account', [AuthController::class, 'activateAccount']);
    Router::get('/send-activation-code', [AuthController::class, 'sendActivationCode']);
});

Router::run();