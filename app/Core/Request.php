<?php
namespace App\Core;
final class Request{public function method():string{return strtoupper($_SERVER['REQUEST_METHOD']??'GET');}public function path():string{$p=parse_url($_SERVER['REQUEST_URI']??'/',PHP_URL_PATH)?:'/';$base=rtrim(str_replace('\\','/',dirname($_SERVER['SCRIPT_NAME']??'')),'/');if($base&&str_starts_with($p,$base))$p=substr($p,strlen($base));return '/'.trim($p,'/');}public function input(string $k,mixed $d=null):mixed{return $_POST[$k]??$_GET[$k]??$d;}public function all():array{return array_merge($_GET,$_POST);}}

