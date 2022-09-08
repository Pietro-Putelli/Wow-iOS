<?php

    require_once 'EventDB.php';
    
    $discussion_id = $_POST['discussion_id'];
    
    $event = new EventDB();
    $event->deleteDiscussion($discussion_id);