<?php
namespace App\Core;
final class Validator{private array $errors=[];public function validate(array $d,array $rules):bool{foreach($rules as$f=>$line){$v=trim((string)($d[$f]??''));foreach(explode('|',$line)as$r){[$name,$arg]=array_pad(explode(':',$r,2),2,null);if($name==='required'&&$v==='')$this->errors[$f][]='This field is required.';if($v!==''&&$name==='email'&&!filter_var($v,FILTER_VALIDATE_EMAIL))$this->errors[$f][]='Enter a valid email.';if($v!==''&&$name==='min'&&mb_strlen($v)<(int)$arg)$this->errors[$f][]='Minimum '.$arg.' characters required.';if($name==='confirmed'&&$v!==($d[$f.'_confirmation']??''))$this->errors[$f][]='Confirmation does not match.';}}return !$this->errors;}public function errors():array{return $this->errors;}}

