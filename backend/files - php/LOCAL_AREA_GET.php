<?php

    require_once 'GetAreaDB.php';
    require_once 'LocalDB.php';

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $maxDistance = $_POST['maxDistance'];
    $const = $_POST['const'];

    $getArea1 = new GetAreaDB();
    $locals = $getArea1->getLocalArea($latitudeFrom,$longitudeFrom,$maxDistance,$const);

    $getter = new LocalDB();

    $jsonArray = array();

    foreach ($locals as $local) {
        
        $numberOfReviews = $getter->getNumberOfLocalReviews($local->getID());

        $jsonArray1 = array(

            "id" => $local->getID(),
            "json_local" => $local->getJSON(),
            "rating" => $local->getRating(),
            "owner" => $local->getOwner(),
            "likes" => $local->getLikes(),
            "reviews" => $numberOfReviews
        );

        array_push($jsonArray,$jsonArray1);
    }

    echo json_encode($jsonArray);