<?php
namespace App\Core;
final class Response{public static function abort(int $code):never{http_response_code($code);$file=BASE_PATH.'/app/Views/errors/'.$code.'.php';require file_exists($file)?$file:BASE_PATH.'/app/Views/errors/500.php';exit;}}

