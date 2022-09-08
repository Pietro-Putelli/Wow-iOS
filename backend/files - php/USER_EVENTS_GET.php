<?php

    require_once 'GetAreaDB.php';
    
    $email = $_POST["owner"];
    
    $getEvent = new GetAreaDB();
    $events = $getEvent->getEvents($email);
    
    $jsonArray = array();
    
    foreach ($events as $event) {
        
        $jsonArray1 = array(
            
            "id" => $event->getID(),
            "going" => $event->getGoing(),
            "likes" => $event->getLikes(),
            "local_id" => $event->getLocalID(),
            "owner" => $event->getOwner(),
            "json_event" => $event->getJSON()
        );
        
        array_push($jsonArray,$jsonArray1);
    }
    
    echo json_encode($jsonArray);