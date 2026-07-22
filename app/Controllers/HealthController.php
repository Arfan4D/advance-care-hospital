<?php
namespace App\Controllers;use App\Core\{Database,Request};
final class HealthController{public function index(Request$r):void{header('Content-Type: application/json; charset=utf-8');header('Cache-Control: no-store');$ok=true;try{Database::connection()->query('SELECT 1')->fetchColumn();}catch(\Throwable$e){$ok=false;logger('Health database check failed: '.$e->getMessage());}http_response_code($ok?200:503);echo json_encode(['status'=>$ok?'ok':'unavailable','database'=>$ok?'connected':'unavailable','time'=>date(DATE_ATOM)],JSON_UNESCAPED_SLASHES);}}
