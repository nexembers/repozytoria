<?php
namespace AI\Middlewares;

use AI\Core\Session;

class AuthMiddleware
{
    public static function authenticated()
    {
        if(Session::get('authenticated')) redirect('/');
    }

    public static function unauthenticated()
    {
        if(!Session::get('authenticated')) redirect('/login'); 
    }
}