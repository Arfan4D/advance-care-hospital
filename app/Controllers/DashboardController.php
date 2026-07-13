<?php
namespace App\Controllers;use App\Core\{Auth,Request,View};final class DashboardController{public function patient(Request$r):void{View::render('dashboard/patient',['title'=>'Patient Dashboard','user'=>Auth::user()]);}public function admin(Request$r):void{View::render('dashboard/admin',['title'=>'Admin Dashboard','user'=>Auth::user()]);}}

