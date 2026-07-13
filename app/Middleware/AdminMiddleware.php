<?php
namespace App\Middleware;use App\Core\{Auth,Response};final class AdminMiddleware{public function handle():void{if(!Auth::check())redirect('login');if(!Auth::hasRole('admin'))Response::abort(403);}}

