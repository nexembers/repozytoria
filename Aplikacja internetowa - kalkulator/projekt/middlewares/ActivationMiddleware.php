<?php
namespace AI\Middlewares;

use AI\Core\Session;

class ActivationMiddleware
{
    public static function valid()
    {
        $activation = Session::get('activation');

        if(!$activation) redirect('/login');
    }
}