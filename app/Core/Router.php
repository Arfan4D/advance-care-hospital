<?php
namespace App\Core;
final class Router{private array $routes=[];public function get(string $u,array $a,array $m=[]):void{$this->add('GET',$u,$a,$m);}public function post(string $u,array $a,array $m=[]):void{$this->add('POST',$u,$a,$m);}private function add(string $method,string $uri,array $action,array $middleware):void{$this->routes[]=compact('method','uri','action','middleware');}public function dispatch(Request $r):void{foreach($this->routes as$x){if($x['method']!==$r->method()||'/'.trim($x['uri'],'/')!==$r->path())continue;if($r->method()==='POST'&&!Csrf::verify($r->input('_token')))Response::abort(419);foreach($x['middleware']as$m)(new $m)->handle();[$c,$fn]=$x['action'];(new $c)->$fn($r);return;}Response::abort(404);}}

