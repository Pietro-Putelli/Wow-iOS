<?php

    require_once 'FriendsDB.php';
    
    $user_email = $_POST['user_email'];

    $friend = new FriendsDB();
    $owner = $friend->getFriendByEmail($user_email);
    
    $jsonArray = array(
            "id" => $owner->getID(),
            "email" => $owner->getEmail(),
            "username" => $owner->getUsername(),
            "followers" => $owner->getFollowers(),
            "following" => $owner->getFollowing(),
            "status" => $owner->getStatus(),
            "phone" => $owner->getPhone(),
            "businessEmail" => $owner->getBE(),
            "webSite" => $owner->getWB()
    );
    
    echo json_encode($jsonArray);