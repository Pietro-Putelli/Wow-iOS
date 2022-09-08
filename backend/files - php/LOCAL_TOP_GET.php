<?php

    require_once 'GetAreaDB.php';
    require_once 'LocalDB.php';

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $const = $_POST['const'];

    $getArea1 = new GetAreaDB();
    $locals = $getArea1->getTopLocalArea($latitudeFrom,$longitudeFrom,$const);

    $jsonArray = array();
    $getter = new LocalDB();

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