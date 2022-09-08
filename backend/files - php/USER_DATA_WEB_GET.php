<?php
    session_start();

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $checker = new UsersAccountDB();
    $user = $checker->checkUsersExistence($email,$password);
    
    if ($user != NULL) {
        $_SESSION['email']=$email;
        $_SESSION['username']=$user->getUsername();
        echo '<script>window.location.replace("https://www.finixinc.com")</script>';
        exit();
    }else {
        echo '<script>window.location.replace("https://www.finixinc.com/website/account/login.php?error_login")</script>';
        exit();
    }
?>