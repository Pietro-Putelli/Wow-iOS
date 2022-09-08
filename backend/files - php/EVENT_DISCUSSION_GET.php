<?php

    require_once 'EventDB.php';
    
    $event_id = $_POST['event_id'];
    
    $event = new EventDB();
    $discussions = $event->getEventDiscussion($event_id);
    
    $jsonArray = array();
    
    foreach ($discussions as $discussion) {
        $jsonArray1 = array(
            
            "id"=>$discussion->getDiscussionID(),
            "user_name"=>$discussion->getUsername(),
            "user_email"=>$discussion->getUseremail(),
            "date"=>$discussion->getDate(),
            "discussion_json"=>$discussion->getDiscussionJSON()
            );
            
        array_push($jsonArray,$jsonArray1);
    }
    
    echo json_encode($jsonArray);