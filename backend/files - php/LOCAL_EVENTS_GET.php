<?php

    require_once 'LocalDB.php';
    
    $id = $_POST['id'];
    
    $getter = new LocalDB();
    $events = $getter->getLocalEvents($id);
    
    $jsonArray = array();
    foreach ($events as $event) {
        
        $jsonArray1 = array(

            "id" => $event->getID(),
            "going" => $event->getGoing(),
            "likes" => $event->getLikes(),
            "owner" => $event->getOwner(),
            "local_id" => $event->getLocalID(),
            "json_event" => $event->getJSON()
        );

        array_push($jsonArray,$jsonArray1);
    }

    echo json_encode($jsonArray);