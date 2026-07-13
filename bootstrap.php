<?php
declare(strict_types=1);
define('BASE_PATH', __DIR__);
require BASE_PATH.'/app/helpers.php';
load_env(BASE_PATH.'/.env');
spl_autoload_register(function(string $class){$prefix='App\\';if(str_starts_with($class,$prefix)){ $file=BASE_PATH.'/app/'.str_replace('\\','/',substr($class,strlen($prefix))).'.php';if(file_exists($file))require $file;}});
date_default_timezone_set('Asia/Dhaka');
error_reporting(E_ALL); ini_set('display_errors',filter_var(env('APP_DEBUG',false),FILTER_VALIDATE_BOOL)?'1':'0');
set_exception_handler(function(Throwable $e){logger($e->__toString());http_response_code(500);$message=filter_var(env('APP_DEBUG',false),FILTER_VALIDATE_BOOL)?$e->getMessage():'Something went wrong.';require BASE_PATH.'/app/Views/errors/500.php';});
App\Core\Session::start();

