<?php

define('MIN_SIZE', 64);
define('MAX_SIZE', 1024 * 1024);
define('CACHE_DIR', '/var/www/html/afarber.de/gc/');

$id   = $_POST['id'];
$auth = $_POST['auth'];
$img  = $_POST['img'];

$path = CACHE_DIR . $id . '.jpg';

$fh = fopen($path, 'wb');
if ($fh) {
        flock($fh, LOCK_EX);
        fwrite($fh, base64_decode($img));
        fclose($fh);
}

$resp = array();
$resp['id'] = $id;
$resp['path'] = $path;

header('Content-Type: application/json; charset=utf-8');
print json_encode($resp);

?> 

