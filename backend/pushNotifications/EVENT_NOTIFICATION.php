<?php

    require_once 'PushNotifications.php';
    require_once '../UsersAccountDB.php';
    require_once '../FriendsDB.php';
    require_once '../FavouritesDB.php';
    
    $local_id = $_POST['local_id'];
    $event_id = $_POST['event_id'];
    $content = $_POST['content'];

    $msg_payload = array (
        'mtitle' => "",
        'mdesc' => $content
    );

    $favourite = new FavouritesDB();
    $userIDs = $favourite->getUserIDsByLocalID($local_id);

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
        "type"=>4,
        "user_data"=>json_encode($jsonArray)
    );
    
    $user = new UsersAccountDB();
    
    foreach($userIDs as $user_email) {
        $logged = $user->getLoggedByEmail($user_email);
        $event_set = $user->getEventSetByEmail($user_email);

        if ($logged && $event_set) {
            $token = $user->getTokenByEmail($user_email);
            PushNotifications::iOS($msg_payload,$token,$data);
        }
    }
    
    
    
    
    
    
    
    