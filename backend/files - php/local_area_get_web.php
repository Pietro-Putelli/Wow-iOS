<?php

    require_once 'GetAreaDB_web.php';

    //$latitudeFrom = 45.851892;
    //$longitudeFrom = 10.166098199999965;
    //$maxDistance = 100;

    $latitudeFrom = $_POST['latitudeFrom'];
    $longitudeFrom = $_POST['longitudeFrom'];
    $maxDistance = $_POST['maxDistance'];

    // isset($_POST['latitudeFrom']) && isset($_POST['longitudeFrom']) && isset($_POST['maxDistance'])

        $getArea1 = new GetAreaDB();
        $locals = $getArea1->getlocalArea($latitudeFrom,$longitudeFrom,$maxDistance);

        $jsonArray = array();

        foreach ($locals as $local) {


            $jsonArray1 = array(

                "id" => $local->getID(),
                "json_local" => $local->getJSON()
            );
            
            array_push($jsonArray,$local);
            
        }

        echo json_decode($jsonArray);