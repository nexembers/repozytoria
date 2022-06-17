<?php
require __DIR__ . '/vendor/autoload.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

use AI\Core\DB;

class Chat implements MessageComponentInterface 
{
    protected $clients;
    protected $storage;

    public function __construct() 
    {
        $this->clients = new \SplObjectStorage;
    }

    public function onOpen(ConnectionInterface $conn) 
    {
        $this->authenticate($conn);
    }

    public function onMessage(ConnectionInterface $from, $msg) 
    {
        try
        {
            $msgJson = json_decode($msg, false, 512, \JSON_THROW_ON_ERROR);

            switch($msgJson->action ?? '')
            {
                case 'message':
                    foreach ($this->clients as $client) 
                        {
                            if($from != $client) 
                            {
                                $client->send(json_encode([
                                    'action'    => 'message',
                                    'message'   => $msgJson->message,
                                    'user'      => $this->storage[$from->resourceId]
                                ]));
                            }
                        }
                    break;

                default:
                    throw new \Exception('wrong_action');
                    break;
            }

            $this->saveMessage($this->storage[$from->resourceId], $msgJson->message);
        }
        catch(\Exception $e)
        {
            $from->send(json_encode([
                'action'        => 'close',
                'error'         => '400',
                'error_message' => 'Bad Request'
            ]));

            $from->close();
        }
    }

    public function onClose(ConnectionInterface $conn) 
    {
        $this->clients->detach($conn);

        $this->sendToAll([
            'action' => 'client_left',
            'user' => $this->storage[$conn->resourceId],
            'users_count' => count($this->clients)
        ]);

        unset($this->storage[$conn->resourceId]);
    }

    public function onError(ConnectionInterface $conn, \Exception $e) 
    {
        $conn->close();
    }

    private function sendToAll($message)
    {
        foreach($this->clients as $client) $client->send(json_encode($message));
    }

    private function saveMessage($user, $msg) 
    {
        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('INSERT INTO messages VALUES(DEFAULT, :message, DEFAULT, :user_id)');

            $stmt->bindParam(':message', $msg, \PDO::PARAM_STR);
            $stmt->bindParam(':user_id', $user['id'], \PDO::PARAM_INT);

            $stmt->execute();
        }
        catch(\Exception $e) {}
    }

    private function authenticate(ConnectionInterface $conn) 
    {
        $token = null;

        foreach(explode(';', $conn->httpRequest->getHeader('Cookie')[0]) as $cookie)
        {
            if(strpos($cookie, 'ws_token') !== false) 
            {
                $token = explode('=', $cookie)[1];
                break;
            }
        }

        $error = false;
        $DB = new DB;

        try
        {
            $stmt = $DB->prepare('SELECT id, name, email FROM users WHERE ws_token = :ws_token');

            $stmt->bindParam(':ws_token', $token, \PDO::PARAM_STR);
            $stmt->execute();

            if(!$result = $stmt->fetch(\PDO::FETCH_ASSOC)) $error = true;
            else
            {
                $this->clients->attach($conn);

                $this->sendToAll([
                    'action' => 'client_join',
                    'user' => $result,
                    'users_count' => count($this->clients)
                ]);

                $this->storage[$conn->resourceId] = array_merge($result, [
                    'color' => '#' . str_pad(dechex(mt_rand(0, 0xFFFFFF)), 6, '0', STR_PAD_LEFT)
                ]);
            }
        }
        catch(\Exception $e)
        {
            $error = true;
        }
        
        if($error)
        {
            $conn->send(json_encode([
                'action'        => 'close',
                'error'         => '401',
                'error_message' => 'unauthenticated'
            ]));
    
            $conn->close();
        }
    }
}

$app = new Ratchet\App('localhost', 8080);
$app->route('/chat', new Chat, array('*'));
$app->run();