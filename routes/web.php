<?php
use App\Controllers\{AuthController,DashboardController,HomeController};use App\Middleware\{AdminMiddleware,AuthMiddleware,GuestMiddleware};
$router->get('/',[HomeController::class,'index']);
$router->get('/login',[AuthController::class,'loginForm'],[GuestMiddleware::class]);
$router->post('/login',[AuthController::class,'login'],[GuestMiddleware::class]);
$router->get('/register',[AuthController::class,'registerForm'],[GuestMiddleware::class]);
$router->post('/register',[AuthController::class,'register'],[GuestMiddleware::class]);
$router->post('/logout',[AuthController::class,'logout'],[AuthMiddleware::class]);
$router->get('/dashboard',[DashboardController::class,'patient'],[AuthMiddleware::class]);
$router->get('/admin',[DashboardController::class,'admin'],[AdminMiddleware::class]);

