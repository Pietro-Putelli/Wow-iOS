<?php

    require_once 'UsersAccountDB.php';
    
    $friend_id = $_POST['friend_id'];
    
    $user = new UsersAccountDB();
    $followers = $user->getFollowersNumber($friend_id);
    
    $jsonArray = array("followers"=>$followers);
    echo json_encode($jsonArray);
    