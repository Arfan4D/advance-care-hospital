<?php
namespace App\Controllers;use App\Core\{Auth,Request,Response,Session,View};use App\Models\{AiAssistant,Hospital};
final class AdminAiController{
 private function allow(string$p):void{if(!Auth::can($p))Response::abort(403);}
 public function knowledge(Request$r):void{$this->allow('ai.manage');$id=(int)$r->input('id');View::render('admin/ai-knowledge',['title'=>'AI Knowledge Base','rows'=>AiAssistant::knowledge(),'editing'=>$id?AiAssistant::knowledgeOne($id):[]]);}
 public function saveKnowledge(Request$r):void{$this->allow('ai.manage');try{AiAssistant::saveKnowledge($r->all());Session::flash('success','AI knowledge entry saved.');}catch(\Throwable$e){Session::flash('error',$e->getMessage());}redirect('admin/ai-knowledge');}
 public function symptoms(Request$r):void{$this->allow('ai.manage');$id=(int)$r->input('id');View::render('admin/ai-symptoms',['title'=>'Symptom Rules','rows'=>AiAssistant::symptoms(),'editing'=>$id?AiAssistant::symptomOne($id):[],'departments'=>Hospital::all('departments','is_active=1',[],'name')]);}
 public function saveSymptom(Request$r):void{$this->allow('ai.manage');try{AiAssistant::saveSymptom($r->all());Session::flash('success','Symptom and department rule saved.');}catch(\Throwable$e){Session::flash('error',$e->getMessage());}redirect('admin/ai-symptoms');}
 public function unanswered(Request$r):void{$this->allow('ai.reports');View::render('admin/ai-unanswered',['title'=>'Unanswered AI Questions','rows'=>AiAssistant::unanswered()]);}
 public function resolve(Request$r):void{$this->allow('ai.reports');AiAssistant::resolveUnanswered((int)$r->input('id'),(string)$r->input('status'),trim((string)$r->input('note','')));Session::flash('success','Question review status updated.');redirect('admin/ai-unanswered');}
}
