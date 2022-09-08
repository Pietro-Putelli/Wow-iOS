<?php

    require_once 'PushNotifications.php';
    require_once '../UsersAccountDB.php';
    require_once '../FriendsDB.php';
    require_once '../EventDB.php';

    $email = $_POST['target_id'];
    $event_id = $_POST['event_id'];
    $discussion_id = $_POST['discussion_id'];
    $message_content = $_POST['content'];
    
    //$email = "pietroputelli80@gmail.com";
    //$event_id = 69;
    //$discussion_id = 10;
    //$message_content = "TEST";

    $msg_payload = array (
        'mtitle' => "",
        'mdesc' => $message_content
    );
    
    $user = new UsersAccountDB();
    $target = $user->getUserIDByEmail($email);
    $token = $user->getToken($target);
    
    $logged = $user->getLogged($target);
    $answer = $user->getAnswer($target);

    $event = new EventDB();
    $discussion = $event->getEventDiscussionByID($discussion_id);
    
    $jsonArray = array(
            
        "id"=>$discussion_id,
        "user_name"=>$discussion->getUsername(),
        "user_email"=>$discussion->getUseremail(),
        "discussion_json"=>$discussion->getDiscussionJSON()
    );
    
    print_r($jsonArray);

    $data = array(
        "type"=>3,
        "user_data"=>json_encode($jsonArray)
        );
    

    if ($logged && $answer) {
        PushNotifications::iOS($msg_payload,$token,$data);
    }