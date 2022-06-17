<?php
namespace AI\Core;

class Request
{
    private $url;
    private $method;
    private $parameters     = [];

    public function __construct()
    {
        $this->method = $_SERVER['REQUEST_METHOD'];

        $this->parseUrl();
        $this->unpackQueryString();
        $this->unpackRequestBody();
    }

    public function __get($name)
    {
        return $this->parameters[$name] ?? null;
    }

    public function addParameters($parameters)
    {
        $this->parameters = array_merge($this->parameters, $parameters);
    }

    public function getParameters()
    {
        return $this->parameters;
    }

    public function getPath()
    {
        return $this->url['path'];
    }

    public function getMethod()
    {
        return $this->method;
    }

    private function parseUrl()
    {
        $this->url = parse_url($_SERVER['REQUEST_URI']);

        $relativePath = relativePath();

        if(isset($this->url['path']))
        {
            $this->url['path'] = str_replace(
                $relativePath, 
                '', 
                $this->url['path']
            );
        }
        else $this->url['path'] = '/';

        Cache::$prevLocation = $_SERVER['HTTP_REFERER'] ?? '/';
        Cache::$path = $this->url['path'];
        Cache::$relativePath = $relativePath;
    }

    private function unpackQueryString()
    {
        $queryString = $this->url['query'] ?? '';

        if(!$queryString) return;

        foreach(explode('&', $queryString) as $query)
        {
            $pair = explode('=', $query);
            $this->parameters[$pair[0]] = $pair[1];
        }
    }

    private function unpackRequestBody()
    {
        $bodyRaw = file_get_contents('php://input');

        if(!$bodyRaw) return;

        foreach(explode('&', $bodyRaw) as $body)
        {
            $pair = explode('=', $body);
            $this->parameters[$pair[0]] = urldecode($pair[1]);
        }
    }
}