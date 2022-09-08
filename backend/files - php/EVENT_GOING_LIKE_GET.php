<?php

    require_once 'EventDB.php';
    
    $event_id = $_POST['event_id'];

    $event = new EventDB();
    $jsonArray = $event->getLikesGoing($event_id);
    
    echo json_encode($jsonArray);