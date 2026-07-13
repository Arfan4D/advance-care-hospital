<?php
namespace App\Core;
final class Csrf{public static function token():string{if(!Session::get('_token'))Session::put('_token',bin2hex(random_bytes(32)));return Session::get('_token');}public static function verify(?string $t):bool{return is_string($t)&&hash_equals(self::token(),$t);}}

