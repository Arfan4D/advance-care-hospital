<?php

require_once 'config/database.php';

$db=new Database();

$conn=$db->connect();

echo "<h2 style='color:green'>Database Connected Successfully</h2>";