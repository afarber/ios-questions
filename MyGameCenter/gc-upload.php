<?php

define('MIN_SIZE', 64);
define('MAX_SIZE', 1024 * 1024);
define('CACHE_DIR', '/var/www/html/afarber.de/gc/');

$id   = $_POST['id'];
$auth = $_POST['auth'];
$img  = $_POST['img'];

header('Content-Type: application/json; charset=utf-8');

if (!preg_match('/^G:\d+$/', $id))
        quit('Wrong player id');

$path = CACHE_DIR . $id . '.jpg';
$data = base64_decode($img, TRUE);

if ($data === FALSE || strlen($data) < MIN_SIZE || strlen($data) > MAX_SIZE)
        quit('Wrong image data');

$fh = fopen($path, 'wb');
if ($fh) {
        flock($fh, LOCK_EX);
        fwrite($fh, $data);
        fclose($fh);
}

$resp = array(
        'id'   => $id,
        'path' => $path,
);

print json_encode($resp);

function quit($str) {
        $error = array('error' => $str);
        print json_encode($error);
        exit(1);
}

?> 

