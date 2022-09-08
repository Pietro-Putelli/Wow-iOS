<?php

    require_once 'UsersAccountDB.php';
    
    $user_name = $_POST['user_name'];

    $user = new UsersAccountDB();
    $response = $user->checkUsernameUnique($user_name);
    
    $jsonArray = array("response" => $response);
    
    echo json_encode($jsonArray);