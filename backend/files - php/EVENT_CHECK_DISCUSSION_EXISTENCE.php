<?php

    require_once 'EventDB.php';
    
    $user_email = $_POST['user_email'];
    $event_id = $_POST['event_id'];
    
    
    $user_email = "pietroputelli80@gmail.com";
    $event_id = 69;
    
    $discussion = new EventDB();
    $discussion_existe = $discussion->checkDiscussionExistence($user_email,$event_id);
    
    $jsonArray = array("discussionExiste" => $discussion_existe);
    echo json_encode($jsonArray);