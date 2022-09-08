<?php
    
    $email = $_POST['folderID'];
    $path = $_POST['path'];
    
    $target_dir = "../usersAccountData/".$email."/".$path;
    
    if(!file_exists($target_dir)) {
    mkdir($target_dir, 0755, true);
    }
    
    $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);
    $target_dir = "../usersAccountData/pietroputelli80@gmail.com/userLocals/pietroputelli80@gmail.com11/IMG_1.jpg";
    unlink($target_dir);