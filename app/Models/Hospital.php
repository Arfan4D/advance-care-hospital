<?php
namespace App\Models;
use App\Core\Database;
use PDO;

final class Hospital{
 public static function all(string $table,string $where='1',array $params=[],string $order='id DESC'):array{
  $allowed=['pages','leaders','departments','doctors','diagnostic_tests','diagnostic_categories','facilities','cabin_types','news','patient_video_reviews'];
  if(!in_array($table,$allowed,true))throw new \InvalidArgumentException('Invalid table.');
  $s=Database::connection()->prepare("SELECT * FROM {$table} WHERE {$where} ORDER BY {$order}");$s->execute($params);return$s->fetchAll();
 }
 public static function one(string$table,string$field,mixed$value):?array{
  if(!in_array($field,['id','slug'],true))throw new \InvalidArgumentException('Invalid field.');$rows=self::all($table,"{$field}=?",[$value],'id DESC');return$rows[0]??null;
 }
 public static function doctors(?string$q=null,?int$department=null):array{$sql='SELECT DISTINCT d.*,GROUP_CONCAT(dp.name SEPARATOR ", ") departments FROM doctors d LEFT JOIN doctor_departments dd ON dd.doctor_id=d.id LEFT JOIN departments dp ON dp.id=dd.department_id WHERE d.is_active=1';$p=[];if($q){$sql.=' AND (d.name LIKE ? OR d.specialization LIKE ? OR d.qualifications LIKE ?)';$like="%{$q}%";$p=[$like,$like,$like];}if($department){$sql.=' AND dd.department_id=?';$p[]=$department;}$sql.=' GROUP BY d.id ORDER BY d.is_featured DESC,d.name';$s=Database::connection()->prepare($sql);$s->execute($p);return$s->fetchAll();}
 public static function departmentDoctors(int$id):array{$s=Database::connection()->prepare('SELECT d.* FROM doctors d JOIN doctor_departments dd ON dd.doctor_id=d.id WHERE dd.department_id=? AND d.is_active=1 ORDER BY d.name');$s->execute([$id]);return$s->fetchAll();}
 public static function diagnostics(?int$category=null,?string$q=null):array{$sql='SELECT t.*,c.name category FROM diagnostic_tests t JOIN diagnostic_categories c ON c.id=t.category_id WHERE t.is_active=1';$p=[];if($category){$sql.=' AND t.category_id=?';$p[]=$category;}if($q){$sql.=' AND t.name LIKE ?';$p[]="%{$q}%";}$sql.=' ORDER BY c.name,t.name';$s=Database::connection()->prepare($sql);$s->execute($p);return$s->fetchAll();}
 public static function videoReviews():array{$s=Database::connection()->query('SELECT v.*,d.name department FROM patient_video_reviews v LEFT JOIN departments d ON d.id=v.department_id WHERE v.is_published=1 AND v.consent_recorded=1 ORDER BY v.is_featured DESC,v.published_at DESC');return$s->fetchAll();}
 public static function createContact(array$d):void{$s=Database::connection()->prepare('INSERT INTO contact_messages(name,email,phone,subject,message)VALUES(?,?,?,?,?)');$s->execute([$d['name'],$d['email']?:null,$d['phone'],$d['subject'],$d['message']]);}
 public static function createFeedback(array$d):void{$s=Database::connection()->prepare('INSERT INTO feedback(name,phone,service,rating,comments,is_anonymous)VALUES(?,?,?,?,?,?)');$s->execute([$d['name']?:null,$d['phone']?:null,$d['service']?:null,(int)$d['rating'],$d['comments'],isset($d['is_anonymous'])]);}
}

