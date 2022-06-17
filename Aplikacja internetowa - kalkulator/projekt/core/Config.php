<?php
namespace AI\Core;

class Config
{
    const DB_ENGINE         = 'mysql';
    const DB_HOST           = 'localhost';
    const DB_NAME           = 'ai';
    const DB_USER           = 'root';
    const DB_PASSWORD       = '';

    const HASH_ALGORITHM    = 'sha256';
    const SECRET            = 'tajny.kod';

    const DEBUG_MODE        = true;
    
    const ENTRY_FILE        = 'index.php';
    const HTML_TITLE        = 'ai';

    const SMTP_SERVER       = 'smtp.gmail.com';
    const SMTP_PORT         = 587;
    const SMTP_SECURE       = 'tls';
    const SMTP_USER         = 'aplikacje.internetowe.ur@gmail.com';
    const SMTP_PASSWORD     = 'ai123321';
}