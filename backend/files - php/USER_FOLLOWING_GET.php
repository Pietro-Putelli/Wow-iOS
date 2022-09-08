<?php

    require_once 'FriendsDB.php';
    
    $friend_id = $_POST['friend_id'];

    $friend = new FriendsDB();
    $friends = $friend->getFollowers($friend_id);
    
    $jsonDict = array();
    
    foreach ($friends as $friend) {
        $jsonArray = array(
            
        "id" => $friend->getID(),
        "email" => $friend->getEmail(),
        "username" => $friend->getUsername(),
        "followers" => $friend->getFollowers(),
        "following" => $friend->getFollowing(),
        "status" => $friend->getStatus(),
        "phone" => $friend->getPhone(),
        "businessEmail" => $friend->getBE(),
        "webSite" => $friend->getWB()
        );
        array_push($jsonDict,$jsonArray);
    }
    
    echo json_encode($jsonDict);