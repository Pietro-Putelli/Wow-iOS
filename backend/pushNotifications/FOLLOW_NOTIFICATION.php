<?php

    require_once 'PushNotifications.php';
    require_once '../UsersAccountDB.php';
    require_once '../FriendsDB.php';

    $user_id = $_POST['user_id'];
    $message_content = $_POST['content'];
    $target = $_POST['target'];
    
    $msg_payload = array (
        'mtitle' => "",
        'mdesc' => $message_content
    );
    
    $user = new UsersAccountDB();
    $token = $user->getToken($target);
    
    $logged = $user->getLogged($target);
    $follow = $user->getFollow($target);
    $email = $user->getUserEmailByID($user_id);
    
    $friend = new FriendsDB();
    $owner = $friend->getFriendByEmail($user_id);
    
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

    $data = array(
        "type"=>1,
        "user_data"=>json_encode($jsonArray)
        );
    
    print_r($data);
    
    if ($logged && $follow) {
        PushNotifications::iOS($msg_payload,$token,$data);
    }