<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $email = $_POST['email'];
    $web_site = $_POST['web_site'];
    $phone = $_POST['phone_number'];
    
    $user = new UsersAccountDB();
    $user->uploadBusinessInfo($user_id,$email,$web_site,$phone);