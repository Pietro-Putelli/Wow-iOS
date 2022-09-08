<?php

    require_once 'GetAreaDB.php';

    //$latitudeFrom = 45.851892;
    //$longitudeFrom = 10.166098199999965;
    //$maxDistance = 20;

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $maxDistance = $_POST['maxDistance'];

    $getArea1 = new GetAreaDB();
    $events = $getArea1->geteventArea($latitudeFrom,$longitudeFrom,$maxDistance);

    $jsonArray = array();

    foreach ($events as $event) {
        
        $jsonArray1 = array(

            "id" => $event->getID(),
            "json_event" => $event->getJSON()
        );

        array_push($jsonArray,$event);
    }

    echo json_encode($jsonArray);