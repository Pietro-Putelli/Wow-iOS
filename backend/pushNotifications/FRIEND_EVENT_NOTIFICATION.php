<?php

    require_once 'PushNotifications.php';
    require_once '../UsersAccountDB.php';
    require_once '../FriendsDB.php';
    require_once '../EventDB.php';
    
    $email = $_POST['user_id'];
    $event_id = $_POST['event_id'];
    $message_content = $_POST['content'];
    
    $user = new UsersAccountDB();
    $user_id = $user->getUserIDByEmail($email);

    $msg_payload = array (
        'mtitle' => "",
        'mdesc' => $message_content,
    );

    $friend = new FriendsDB();
    $tokens = $friend->getEventFriendTokens($user_id);
    
    $logged = $user->getLogged($user_id);
    
    $event_obj = new EventDB();
    $event = $event_obj->getEventByID($event_id);
    
    $jsonArray = array(

        "id" => $event->getID(),
        "going" => $event->getGoing(),
        "likes" => $event->getLikes(),
        "owner" => $event->getOwner(),
        "local_id" => $event->getLocalID(),
        "json_event" => $event->getJSON()
    );
    
    $data = array(
        "type"=>2,
        "user_data"=>json_encode($jsonArray)
        );
    
    foreach($tokens as $tokenNot) {
        if ($tokenNot->getNotificationActive() && $logged) {
            $token = $tokenNot->getToken();
            PushNotifications::iOS($msg_payload, $token, $data);
        }
    }