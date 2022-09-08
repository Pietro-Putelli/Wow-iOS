<?php

    require_once 'EventDB.php';
    
    $user_email = $_POST['user_email'];
    $discussion_id = $_POST['discussion_id'];
    $answer_id = $_POST['answer_id'];
    
    $event = new EventDB();
    $event->deleteDiscussionAnswer($user_email,$discussion_id,$answer_id);