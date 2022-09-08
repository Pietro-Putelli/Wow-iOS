<?php

    require_once '../UsersAccountDB.php';

    $email = $_POST['email'];
    $deviceToken = $_POST['deviceToken'];
    
    $deviceToken1 = new UsersAccountDB();
    $deviceToken1->setDeviceToken($email,$deviceToken);
