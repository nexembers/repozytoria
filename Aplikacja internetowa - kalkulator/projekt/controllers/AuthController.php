<?php
namespace AI\Controllers;

use AI\Core\Session;
use AI\Core\Cache;
use AI\Core\Config;
use AI\Core\DB;

class AuthController
{
    public static function login($request)
    {
        $email = $request->email;
        $password = $request->password;

        if(!filter_var($email, FILTER_VALIDATE_EMAIL))
        {
            Session::set('error', 'Niepoprawny email');
            redirect(Cache::$prevLocation);
        }

        $password = hash(Config::HASH_ALGORITHM, Config::SECRET . $password);

        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('SELECT users.id, users.name, email, ws_token, roles.name as role, email_verified_at ' . 
                    'FROM users '. 
                    'JOIN roles ON users.role_id = roles.id '.
                    'WHERE users.email = :email AND users.password = :password'
                );
            
            $stmt->bindParam(':email', $email, \PDO::PARAM_STR);
            $stmt->bindParam(':password', $password, \PDO::PARAM_STR);

            $stmt->execute();

            if(!$result = $stmt->fetch(\PDO::FETCH_ASSOC)) Session::set('error', 'Błędne dane');
            else
            {
                if(!$result['email_verified_at'])
                {
                    Session::set('activation', [
                        'email'     => $email,
                        'user_id'   => $result['id'],
                        'user_name' => $result['name']
                    ]);
                    
                    redirect('/activate-account');
                }
                else
                {
                    Session::set('authenticated', true);
                    Session::set('user', $result);

                    setcookie('ws_token', $result['ws_token'], time() + (86400 * 30), "/");

                    redirect('/');
                }
            }
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Błąd serwera');
        }

        redirect(Cache::$prevLocation);
    }

    public static function logout()
    {
        Session::unsetAll();
        Session::set('success', 'Wylogowano pomyślnie');

        redirect('/login');
    }

    public static function register($request)
    {
        $name = $request->name;
        $email = $request->email;
        $password = $request->password;
        $passwordConfirm = $request->password_confirm;

        $nameLen = strlen($name);

        if($nameLen < 4 || $nameLen > 16)
        {
            Session::set('error', 'Niepoprawna nazwa użytkownika');
            redirect(Cache::$prevLocation);
        }

        if(!filter_var($email, FILTER_VALIDATE_EMAIL))
        {
            Session::set('error', 'Niepoprawny email');
            redirect(Cache::$prevLocation); 
        }

        $passwordLen = strlen($password);

        if(($passwordLen < 4 || $passwordLen > 32) || $password != $passwordConfirm)
        {
            Session::set('error', 'Niepoprawne hasło');
            redirect(Cache::$prevLocation); 
        }

        $password = hash(Config::HASH_ALGORITHM, Config::SECRET . $password);
        $wsToken = hash(Config::HASH_ALGORITHM, Config::SECRET . $email . time());
        $activationCode = random_int(100000, 999999);

        $DB = new DB;

        try 
        {
            $stmt = $DB->prepare('INSERT INTO users VALUES(NULL, :name, :password, :email, NULL, :activation_code, :ws_token, 1)');
            
            $stmt->bindParam(':name', $name, \PDO::PARAM_STR);
            $stmt->bindParam(':password', $password, \PDO::PARAM_STR);
            $stmt->bindParam(':email', $email, \PDO::PARAM_STR);
            $stmt->bindParam(':activation_code', $activationCode, \PDO::PARAM_STR);
            $stmt->bindParam(':ws_token', $wsToken, \PDO::PARAM_STR);

            if(!$stmt->execute()) Session::set('error', 'Bład serwera');
            else
            {
                sendMail([
                    'to'        => $email,
                    'subject'   => 'Kod aktywacyjny',
                    'html'      => true,
                    'message'   => '<h2>Witaj, ' . $name . '</h2>' . '<p>Twoj kod aktywacyjny: <b>' . $activationCode . '</b></p>'
                ]);

                Session::set('success', 'Pomyślnie zarejestrowano');
            }
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Bład serwera');
        }

        redirect(Cache::$prevLocation);
    }

    public static function activateAccount($request)
    {
        $activation = Session::get('activation');
        $activationCode = $request->activation_code;
        
        if(strlen($activationCode) != 6)
        {
            Session::set('error', 'Niepoprawny format kodu');
            redirect(Cache::$prevLocation);
        }

        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('UPDATE users SET email_verified_at = NOW() WHERE id = :id AND activation_code = :activation_code');

            $stmt->bindParam(':id', $activation['user_id'], \PDO::PARAM_INT);
            $stmt->bindParam('activation_code', $activationCode, \PDO::PARAM_STR);

            $stmt->execute();

            if(!$stmt->rowCount()) Session::set('error', 'Błędny kod');
            else
            {
                Session::unset('activation');
                Session::set('success', 'Konto zostało aktywowane');
                
                redirect('/login');
            }
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Błąd serwera');
        }

        redirect(Cache::$prevLocation);
    }

    public static function sendActivationCode()
    {
        $activation = Session::get('activation');

        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('SELECT activation_code FROM users WHERE id = :id');
            $stmt->bindParam(':id', $activation['user_id'], \PDO::PARAM_INT);
            $stmt->execute();

            if(!$result = $stmt->fetch()) Session::get('error', 'Błędne dane');
            else
            {
                sendMail([
                    'to'        => $activation['email'],
                    'subject'   => 'Kod aktywacyjny',
                    'html'      => true,
                    'message'   => '<h2>Witaj, ' . $activation['user_name'] . '</h2>' . '<p>Twoj kod aktywacyjny: <b>' . $result[0] . '</b></p>'
                ]);

                Session::set('success', 'Pomyślnie wysłano');
            }
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Błąd serwera');
        }

        redirect(Cache::$prevLocation);
    }
}