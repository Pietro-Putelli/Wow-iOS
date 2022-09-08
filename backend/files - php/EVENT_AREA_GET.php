<?php

    require_once 'GetAreaDB.php';

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $maxDistance = $_POST['maxDistance'];
    $const = $_POST['const'];

    //$latitudeFrom = 45.849609;
    //$longitudeFrom = 10.165230;
    //$maxDistance = 100;

    $getArea1 = new GetAreaDB();
    $events = $getArea1->getEventArea($latitudeFrom,$longitudeFrom,$maxDistance,$const);

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