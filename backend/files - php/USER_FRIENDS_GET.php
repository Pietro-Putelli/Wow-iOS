<?php

    require_once 'FriendsDB.php';

    $email = $_POST['user_id'];
    $friends = array();
    $getUsers = new FriendsDB();
    
    $friends = $getUsers->getFriends($email);
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