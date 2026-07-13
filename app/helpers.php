<?php
function load_env(string $file):void{if(!file_exists($file))return;foreach(file($file,FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES)as $line){if(str_starts_with(trim($line),'#')||!str_contains($line,'='))continue;[$k,$v]=array_map('trim',explode('=',$line,2));$_ENV[$k]=trim($v,"\"'");}}
function env(string $key,mixed $default=null):mixed{return $_ENV[$key]??getenv($key)?:$default;}
function url(string $path=''):string{return rtrim((string)env('APP_URL','http://localhost'),'/').($path?'/'.ltrim($path,'/'):'');}
function asset(string $path):string{return url('assets/'.ltrim($path,'/'));}
function e(mixed $v):string{return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8');}
function redirect(string $path=''):never{header('Location: '.url($path));exit;}
function csrf_field():string{return '<input type="hidden" name="_token" value="'.e(App\Core\Csrf::token()).'">';}
function logger(string $m):void{$d=BASE_PATH.'/storage/logs';if(!is_dir($d))mkdir($d,0775,true);error_log('['.date('c').'] '.$m.PHP_EOL,3,$d.'/app.log');}

