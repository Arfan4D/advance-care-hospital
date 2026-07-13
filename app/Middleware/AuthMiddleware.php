<?php
namespace App\Middleware;use App\Core\Auth;final class AuthMiddleware{public function handle():void{if(!Auth::check())redirect('login');}}
