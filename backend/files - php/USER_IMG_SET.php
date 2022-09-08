<?php
    
    require_once 'LocalDB.php';
    
    $email = $_POST['folderID'];
    $path = $_POST['path'];
    $imgID = $_POST['imgID'];
    $id = (int) $_POST['id'];
    
    $uploader = new LocalDB();
    $uploader->uploadImage($email,$path,$imgID,$id);
    

