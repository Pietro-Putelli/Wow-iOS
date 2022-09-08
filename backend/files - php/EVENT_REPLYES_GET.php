<?php

    require_once 'EventDB.php';
    
    $discussion_id = $_POST['discussion_id'];
    
    $event = new EventDB();
    $answers = $event->getDiscussionAnswers($discussion_id);
    
    $jsonArray = array();
    
    foreach ($answers as $answer) {
        $jsonArray1 = array(
            
            "id"=>$answer->getDiscussionID(),
            "user_name"=>$answer->getUsername(),
            "user_email"=>$answer->getUseremail(),
            "date"=>$answer->getDate(),
            "discussion_json"=>$answer->getDiscussionJSON()
            );
            
        array_push($jsonArray,$jsonArray1);
    }
    
    echo json_encode($jsonArray);