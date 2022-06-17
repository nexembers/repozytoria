<?php
namespace AI\Core;

class Session
{
    public static function start()
    {
        session_start();
    }

    public static function set($key, $value)
    {
        $_SESSION[$key] = $value;
    }

    public static function get($key)
    {
        return $_SESSION[$key] ?? null;
    }

    public static function unset($key)
    {
        unset($_SESSION[$key]);
    }

    public static function unsetAll()
    {
        session_unset();
    }

    public static function getId()
    {
        return session_id();
    }

    public static function destroy()
    {
        session_destroy();
    }
}