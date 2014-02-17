<?php

define('MIN_SIZE', 64);
define('MAX_SIZE', 1024 * 1024);
define('UPLOAD_DIR', '/var/www/html/afarber.de/gc/');
define('UPLOAD_URL', 'http://afarber.de/gc/%s.jpg');

$id   = $_POST['id'];
$auth = $_POST['auth'];
$img  = $_POST['img'];

header('Content-Type: application/json; charset=utf-8');

if (!preg_match('/^G:\d+$/', $id))
        quit('Wrong player id');

$path = UPLOAD_DIR . $id . '.jpg';
$data = base64_decode($img, TRUE);
if ($data === FALSE)
        quit('Wrong image data');

$len = strlen($data);
if ($len < MIN_SIZE || $len > MAX_SIZE)
        quit('Wrong image size');

$fh = fopen($path, 'wb');
if ($fh) {
        flock($fh, LOCK_EX);
        fwrite($fh, $data);
        fclose($fh);
}

$resp = array('url' => sprintf(UPLOAD_URL, urlencode($id)));
print json_encode($resp);

function quit($str) {
        $error = array('error' => $str);
        print json_encode($error);
        exit(1);
}

?> 

