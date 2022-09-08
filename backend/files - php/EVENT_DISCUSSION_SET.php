<?php

    require_once 'EventDB.php';
    
    $user_name = $_POST['user_name'];
    $user_email = $_POST['user_email'];
    $event_id = $_POST['event_id'];
    $date = $_POST['date'];
    $discussion_json = $_POST['discussion_json'];
    
    $event = new EventDB();
    $event->setEventDiscussion($user_name,$user_email,$event_id,$date,$discussion_json);