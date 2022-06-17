<?php
namespace AI\Controllers;

use AI\Core\Cache;
use AI\Core\Config;
use AI\Core\Session;
use AI\Core\DB;

class UserController
{
    public static function changePassword($request)
    {
        $user = Session::get('user');

        $password = $request->password;
        $newPassword = $request->new_password;
        $newPasswordConfirm = $request->new_password_confirm;

        if(!isset($password) || !isset($newPassword) || !isset($newPasswordConfirm))
        {
            Session::set('error', 'Błędne dane');
            redirect(Cache::$prevLocation);
        }

        if($newPassword != $newPasswordConfirm)
        {
            Session::set('error', 'Hasła nie są zgodne');
            redirect(Cache::$prevLocation);
        }

        if(strlen($newPassword) < 3)
        {
            Session::set('error', 'Hasło musi być dłuższe niż 3 znaki');
            redirect(Cache::$prevLocation);
        }

        $password = hash(Config::HASH_ALGORITHM, Config::SECRET . $password);
        $newPassword = hash(Config::HASH_ALGORITHM, Config::SECRET . $newPassword);

        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('UPDATE users SET password = :newPassword WHERE id = :userId AND password = :password');

            $stmt->bindParam(':userId', $user['id'], \PDO::PARAM_INT);
            $stmt->bindParam(':password', $password, \PDO::PARAM_STR);
            $stmt->bindParam(':newPassword', $newPassword, \PDO::PARAM_STR);

            $stmt->execute();

            if($stmt->rowCount()) Session::set('success', 'Hasło zostało pomyślnie zmienione');
            else Session::set('error', 'Nieprawidłowe hasło');
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Bląd serwera');
        }

        redirect(Cache::$prevLocation);
    }
}