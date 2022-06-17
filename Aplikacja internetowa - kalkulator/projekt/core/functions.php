<?php
use AI\Core\Config;
use PHPMailer\PHPMailer\PHPMailer;

function view($path, $props = [])
{
    include __DIR__ . '/../views/' . str_replace('.', '/', $path) . '.php';
}

function redirect($path)
{
    http_response_code(301);
    header('Location: ' . (preg_match('/http(s?)\:\/\//i', $path) ? $path : relativePath() . $path));
    exit();
}

function abort($code) {
    http_response_code($code);
    if(in_array($code, [404, 405, 500])) view("errors.{$code}");
    exit();
}

function relativePath() 
{
    return str_replace('/' . Config::ENTRY_FILE, '', $_SERVER['SCRIPT_NAME']);
}

function pathReplace($path, $params)
{
    foreach($params as $key => $value)
    {
        $path = str_replace('{' . $key . '}', $value, $path);
    }

    return $path;
}

function pathMatch($base, $path)
{
    $base = explode('/', $base);
    $path = explode('/', $path);

    if(count($base) != count($path)) return false;

    for($i = 0; $i < count($base); $i++)
    {
        if($base[$i] != $path[$i])
        {
            if(preg_match('/^{.*}$/', $path[$i])) continue;
            else
            {
                return false;
            }
        }
    }

    return true;
}

function inDefinedPaths($base, $paths)
{
    $found = false;

    foreach($paths as $p)
    {
        if(pathMatch($base, $p))
        {
            $found = true;
            break;
        }
    }

    return $found;
}

function sendMail($config = [])
{
    $mail = new PHPMailer(true);

    $mail->isSMTP();

    $mail->Host = Config::SMTP_SERVER;
    $mail->Port = Config::SMTP_PORT;
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;

    $mail->SMTPAuth = true;
    $mail->Username = Config::SMTP_USER;
    $mail->Password = Config::SMTP_PASSWORD;

    $mail->setFrom(Config::SMTP_USER);
    $mail->addReplyTo(Config::SMTP_USER);
    $mail->addAddress($config['to'] ?? '');

    $mail->Subject = $config['subject'] ?? '';
    $mail->Body = $config['message'] ?? '';

    $mail->isHTML($config['html'] ?? false);
    $mail->send();
}