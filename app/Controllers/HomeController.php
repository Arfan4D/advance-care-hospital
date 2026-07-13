<?php
namespace App\Controllers;use App\Core\{Request,View};final class HomeController{public function index(Request$r):void{View::render('home',['title'=>'Home']);}}

