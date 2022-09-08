<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];

    $user = new UsersAccountDB();
    $following = $user->getFollowingNumber($user_id);
    
    $jsonArray = array("following"=>$following);
    echo json_encode($jsonArray);