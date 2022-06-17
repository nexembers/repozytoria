<?php

namespace AI\Controllers;

use AI\Core\Config;
use AI\Core\DB;
use AI\Core\Session;

class ChatController
{
    public static function topChatters($search = '', $limit = 100)
    {
        $leaderboard = [];
        $search = '%' . $search . '%';

        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('SELECT users.name AS user_name, users.email AS user_email, COUNT(messages.id) as message_count , MAX(date) as last_send_at' . 
                ' FROM messages' .
                ' JOIN users ON users.id = messages.user_id' . 
                ' WHERE users.email LIKE :search' .
                ' GROUP BY user_id' .
                ' ORDER BY message_count DESC' .
                ' LIMIT ' . $limit);

            $stmt->bindParam(':search', $search, \PDO::PARAM_STR);
            $stmt->execute();

            while($result = $stmt->fetch(\PDO::FETCH_ASSOC)) $leaderboard[] = $result;
        }
        catch(\Exception $e)
        {
            Session::set('error', Config::DEBUG_MODE ? $e->getMessage() : 'Błąd serwera');
        }

        return $leaderboard;
    }
}