<?php

    require_once 'GetAreaDB.php';

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $const = $_POST['const'];

    $getArea1 = new GetAreaDB();
    $events = $getArea1->getTopEventArea($latitudeFrom,$longitudeFrom,$const);

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