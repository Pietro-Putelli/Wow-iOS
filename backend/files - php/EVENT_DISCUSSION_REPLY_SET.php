<?php

    require_once 'EventDB.php';
    
    $user_name = $_POST['user_name'];
    $user_email = $_POST['user_email'];
    $discussion_id = $_POST['discussion_id'];
    $date = $_POST['date'];
    $answer_json = $_POST['answer_json'];

    $event = new EventDB();
    $event->setEventDiscussionAnswer($user_name,$user_email,$discussion_id,$date,$answer_json);