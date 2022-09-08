<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    
    $checkEmail = new UsersAccountDB();
    $response = array('response'=>$checkEmail->checkEmailForRegistration($email));
    echo json_encode($response);
    
    