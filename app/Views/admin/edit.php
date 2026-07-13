<?php
$textareaFields=['bio','description','short_description','services','facilities','excerpt','body','amenities','message'];
$booleanFields=['is_featured','is_active','is_published','consent_recorded'];
?>
<section class="admin-shell">
 <?php require __DIR__.'/_nav.php';?>
 <div class="admin-main">
  <div class="admin-head"><div><span class="eyebrow">ADMIN EDITOR</span><h1><?=e($title)?></h1></div><a class="btn outline" href="<?=url('admin/module?module='.$module)?>">Back to List</a></div>
  <?php if($error):?><div class="notice error-notice"><?=e($error)?></div><?php endif;?>
  <form class="admin-panel admin-form" method="post" action="<?=url('admin/save')?>">
   <?=csrf_field()?><input type="hidden" name="module" value="<?=e($module)?>"><input type="hidden" name="id" value="<?=e($row['id']??'')?>">
   <div class="form-grid">
   <?php foreach($config['fields']as$f): $label=ucwords(str_replace('_',' ',$f));?>
    <label class="<?=in_array($f,$textareaFields,true)?'full':''?>"><?=$label?>
     <?php if(in_array($f,$booleanFields,true)):?>
      <span class="toggle"><input type="checkbox" name="<?=$f?>" value="1" <?=!empty($row[$f])?'checked':''?>> Enabled</span>
     <?php elseif(isset($options[$f])):?>
      <select name="<?=$f?>"><option value="">Select <?=$label?></option><?php foreach($options[$f]as$o):?><option value="<?=$o['id']?>" <?=($row[$f]??'')==$o['id']?'selected':''?>><?=e($o['name'])?></option><?php endforeach;?></select>
     <?php elseif($f==='platform'):?>
      <select name="platform"><option value="youtube" <?=($row[$f]??'')==='youtube'?'selected':''?>>YouTube</option><option value="facebook" <?=($row[$f]??'')==='facebook'?'selected':''?>>Facebook</option></select>
     <?php elseif($f==='category'&&$module==='leaders'):?>
      <select name="category"><?php foreach(['chairman'=>'Chairman','managing_director'=>'Managing Director','board'=>'Board Member','administration'=>'Administration']as$k=>$v):?><option value="<?=$k?>" <?=($row[$f]??'')===$k?'selected':''?>><?=$v?></option><?php endforeach;?></select>
     <?php elseif($f==='availability'):?>
      <select name="availability"><?php foreach(['available','limited','unavailable','24/7','Daily','Scheduled and emergency']as$v):?><option <?=($row[$f]??'')===$v?'selected':''?>><?=$v?></option><?php endforeach;?></select>
     <?php elseif(in_array($f,$textareaFields,true)):?>
      <textarea name="<?=$f?>" rows="<?=in_array($f,['body','description','bio'])?8:4?>"><?=e($row[$f]??'')?></textarea>
     <?php else:?>
      <input type="<?=str_contains($f,'price')||str_contains($f,'fee')||$f==='daily_charge'?'number':($f==='published_at'?'datetime-local':'text')?>" name="<?=$f?>" value="<?=e($f==='published_at'&&!empty($row[$f])?date('Y-m-d\TH:i',strtotime($row[$f])):($row[$f]??''))?>" <?=in_array($f,$config['required'],true)?'required':''?>>
     <?php endif;?>
    </label>
   <?php endforeach;?>
   </div><button class="btn">Save <?=e($config['title'])?></button>
  </form>
 </div>
</section>
