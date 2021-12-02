<?php

$dns='mysql:host=https://plantmonitoringsystem5.000webhostapp.com;dbname=id17966560_plants';
$user='id17966560_root';
$pass='#LDZ^kh2C|NXALZE';

try{
    $db= new PDO ($dns, $user, $pass);
    echo 'connected';
}catch(PDOException $e){
    $error=$e->getMessage();
    echo $error;
}
//echo json_encode();