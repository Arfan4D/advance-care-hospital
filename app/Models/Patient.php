<?php
namespace App\Models;use App\Core\Database;
final class Patient{
 public static function profile(int$userId):?array{$s=Database::connection()->prepare('SELECT u.id,u.name,u.email,u.phone,u.email_verified_at,p.* FROM users u LEFT JOIN patient_profiles p ON p.user_id=u.id WHERE u.id=?');$s->execute([$userId]);return$s->fetch()?:null;}
 public static function ensureProfile(int$userId):void{$s=Database::connection()->prepare('INSERT IGNORE INTO patient_profiles(user_id)VALUES(?)');$s->execute([$userId]);}
 public static function update(int$userId,array$d):void{$pdo=Database::connection();$pdo->beginTransaction();try{$s=$pdo->prepare('UPDATE users SET name=?,phone=? WHERE id=?');$s->execute([$d['name'],$d['phone']?:null,$userId]);self::ensureProfile($userId);$s=$pdo->prepare('UPDATE patient_profiles SET date_of_birth=?,gender=?,address=?,emergency_contact_name=?,emergency_contact_phone=?,blood_group=? WHERE user_id=?');$s->execute([$d['date_of_birth']?:null,$d['gender']?:null,$d['address']?:null,$d['emergency_contact_name']?:null,$d['emergency_contact_phone']?:null,$d['blood_group']?:null,$userId]);$pdo->commit();}catch(\Throwable$e){$pdo->rollBack();throw$e;}}
 public static function notifications(int$userId):array{$s=Database::connection()->prepare('SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 50');$s->execute([$userId]);return$s->fetchAll();}
 public static function unreadCount(int$userId):int{$s=Database::connection()->prepare('SELECT COUNT(*) FROM notifications WHERE user_id=? AND read_at IS NULL');$s->execute([$userId]);return(int)$s->fetchColumn();}
 public static function notify(int$userId,string$type,string$title,string$message,?string$url=null):void{$s=Database::connection()->prepare('INSERT INTO notifications(user_id,type,title,message,action_url)VALUES(?,?,?,?,?)');$s->execute([$userId,$type,$title,$message,$url]);}
 public static function markNotification(int$userId,int$id):void{$s=Database::connection()->prepare('UPDATE notifications SET read_at=NOW() WHERE id=? AND user_id=?');$s->execute([$id,$userId]);}
 public static function markAll(int$userId):void{$s=Database::connection()->prepare('UPDATE notifications SET read_at=NOW() WHERE user_id=? AND read_at IS NULL');$s->execute([$userId]);}
}

