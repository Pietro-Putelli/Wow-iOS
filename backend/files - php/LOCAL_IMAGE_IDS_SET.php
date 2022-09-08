<?php

    require_once 'LocalDB.php';
    
    $email = $_POST['email'];
    $id = $_POST['id'];
    $index = $_POST['index'];

    $setter = new LocalDB();
    $setter->deleteImage($email,$id,$index);
    
    