<?php

    require_once 'UsersAccountDB.php';
    
    $user_email = $_POST['user_email'];

    $user = new UsersAccountDB();
    $response = $user->checkUserExistence($user_email);
    
    $jsonArray = array("response"=>$response);
    
    echo json_encode($jsonArray);