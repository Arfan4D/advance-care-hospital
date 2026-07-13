<?php
require dirname(__DIR__).'/bootstrap.php';use App\Models\User;$email=$argv[1]??'admin@advancecare.com';$password=$argv[2]??'StrongPassword123!';if(User::byEmail($email)){echo"Admin already exists.\n";exit;}$id=User::create(['name'=>'System Administrator','email'=>$email,'phone'=>'','password'=>$password]);User::assignRole($id,'admin');echo"Admin created: $email\n";

