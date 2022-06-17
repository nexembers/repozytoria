<?php
namespace AI\Core;

class Router
{
    private static $routes = [];

    public static function get($path, $callback, $middleware = null)
    {
        self::addRoute('GET', $path, $callback, $middleware);
    }

    public static function post($path, $callback, $middleware = null)
    {
        self::addRoute('POST', $path, $callback, $middleware);
    }

    public static function put($path, $callback, $middleware = null)
    {
        self::addRoute('PUT', $path, $callback, $middleware);
    }

    public static function delete($path, $callback, $middleware = null)
    {
        self::addRoute('DELETE', $path, $callback, $middleware);
    }

    public static function middleware($middleware, $group)
    {
        $routesBefore = count(self::$routes);

        $group();

        for($i = count(self::$routes) - 1; $i >= $routesBefore; $i--)
        {
            self::$routes[$i]['middleware'] = $middleware;
        }
    }

    public static function run()
    {
        $request = new Request();

        $path = explode('/', $request->getPath());
        $routeFound = false;

        foreach(self::$routes as $route)
        {
            $routePath = explode('/', $route['path']);

            if(count($path) != count($routePath)) continue;

            $routeMatch = true;
            $parameters = [];

            for($i = 0; $i < count($path); $i++)
            {
                if($path[$i] != $routePath[$i])
                {
                    if(preg_match('/^{.*}$/', $routePath[$i]))
                    {
                        $parameters[substr($routePath[$i], 1, strlen($routePath[$i]) - 2)] = $path[$i];
                        continue;
                    }
                    else
                    {
                        $routeMatch = false;
                        break;
                    }
                }
            }

            if($routeMatch)
            {
                if($route['method'] == $request->getMethod())
                {
                    $request->addParameters($parameters);

                    if(is_callable($route['middleware'])) $route['middleware']($request);
                    $route['callback']($request);
                    return;
                }

                $routeFound = true;
            }
        }

        $routeFound ? abort(405) : abort(404);
    }

    private static function addRoute($method, $path, $callback, $middleware)
    {
        self::$routes[] = [
            'method'            => $method,
            'path'              => $path,
            'callback'          => $callback,
            'middleware'        => $middleware
        ];
    }
}