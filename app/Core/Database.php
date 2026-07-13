<?php
namespace App\Core; use PDO;
final class Database{private static ?PDO $pdo=null;public static function connection():PDO{if(self::$pdo)return self::$pdo;$dsn='mysql:host='.env('DB_HOST','127.0.0.1').';port='.env('DB_PORT','3306').';dbname='.env('DB_DATABASE','advance_care_hospital').';charset=utf8mb4';return self::$pdo=new PDO($dsn,(string)env('DB_USERNAME','root'),(string)env('DB_PASSWORD',''),[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]);}}

