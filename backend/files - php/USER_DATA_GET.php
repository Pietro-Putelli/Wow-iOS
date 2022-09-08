<?php

  require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $checker = new UsersAccountDB();
    $user = $checker->checkUsersExistence1($email);

    $jsonArray = array(
        
        "id" => $user->getUserID(),
        "username" => $user->getUsername(),
        "email" => $user->getUserEmail(),
        "password" => $user->getUserPassword(),
        "status" => $user->getUserStatus(),
        "business_email" => $user->getBusinessEmail(),
        "phone" => $user->getPhone(),
        "web_site" => $user->getWebSite()
        );
        
        echo json_encode($jsonArray);
