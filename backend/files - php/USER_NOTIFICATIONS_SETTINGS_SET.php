<?php

    require_once 'UsersAccountDB.php';
    
    $user_email = $_POST['user_email'];
    $event_set = $_POST["n1"];
    $event_friend = $_POST["n2"];
    $follow = $_POST["n3"];
    $answer = $_POST["n4"];

    $user = new UsersAccountDB();
    $user->setNotificationsSettings($user_email,$event_set,$event_friend,$follow,$answer);
