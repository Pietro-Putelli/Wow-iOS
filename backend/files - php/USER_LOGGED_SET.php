<?php

    require_once 'UsersAccountDB.php';
    
    $email = $_POST['user_email'];
    $logged_string = $_POST['user_logged'];
    $logged = (int) $logged_string;

    $user = new UsersAccountDB();
    $user->setLogged($email,$logged);