<?php

    require_once 'FriendsDB.php';
    
    $usernamePost = $_POST['searchText'];
    $user_email = $_POST['user_email'];
    $username = preg_replace('/\s+/', '', $usernamePost);
    
    if (!empty($username)) {
        
        $getUsers = new FriendsDB();
        $friends = $getUsers->searchUsers($username,$user_email);
        $jsonDict = array();
        
        foreach($friends as $friend) {
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
    }