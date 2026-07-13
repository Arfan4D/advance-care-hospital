<?php
namespace App\Controllers;use App\Core\{Auth,Request,Session,View};use App\Models\AiAssistant;
final class AiController{
 private function key():string{$key=Session::get('ai_conversation_key');if(!$key){$key=bin2hex(random_bytes(20));Session::put('ai_conversation_key',$key);}return$key;}
 public function chat(Request$r):void{$key=$this->key();View::render('ai/chat',['title'=>'AI Healthcare Assistant','conversationKey'=>$key,'history'=>AiAssistant::history($key)]);}
 public function respond(Request$r):void{header('Content-Type: application/json; charset=utf-8');$message=trim((string)$r->input('message',''));if($message===''||mb_strlen($message)>1000){http_response_code(422);echo json_encode(['error'=>'Enter a message between 1 and 1000 characters.']);return;}try{echo json_encode(AiAssistant::respond($this->key(),Auth::id(),$message),JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);}catch(\Throwable$e){logger($e->__toString());http_response_code(500);echo json_encode(['error'=>'The assistant is temporarily unavailable. Please contact the hospital directly.']);}}
}

