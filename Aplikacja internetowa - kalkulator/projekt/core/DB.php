<?php
namespace AI\Core;

class DB extends \PDO
{
    public function __construct()
    {
        try
        {
            parent::__construct(
                Config::DB_ENGINE . ':' .
                'dbname=' . Config::DB_NAME . ';' .
                'host=' . Config::DB_HOST,
                Config::DB_USER,
                Config::DB_PASSWORD
            );
        }
        catch(\Exception $e)
        {
            abort(500);
        }
    }
}