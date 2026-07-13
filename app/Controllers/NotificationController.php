<?php
namespace App\Controllers;use App\Core\{Auth,Request,View};use App\Models\Patient;
final class NotificationController{public function index(Request$r):void{View::render('patient/notifications',['title'=>'Notifications','notifications'=>Patient::notifications(Auth::id())]);}public function read(Request$r):void{Patient::markNotification(Auth::id(),(int)$r->input('id'));redirect((string)$r->input('redirect','notifications'));}public function readAll(Request$r):void{Patient::markAll(Auth::id());redirect('notifications');}}
