<?php

    require_once 'EventDB.php';

    $setupby = $_POST['setupby'];
    $local_id = $_POST['id'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $to_date = $_POST['to_date'];
    $json = $_POST['json'];
    
    //$setupby = "pietrop";
    //$local_id = 32;
    //$latitude = 45.5973863;
    //$longitude = 12.1580929;
    //$to_date = "2018-02-01";
    //$json = "{}";

    $edit = new EventDB();
    $id = $edit->createEvent($local_id,$setupby,$latitude,$longitude,$to_date,$json);

    $path = '../usersAccountData/' . $setupby . '/userEvents/' . $setupby . $id;

    if (!file_exists($path)) {
        mkdir($path, 0755, true);
    }

    $jsonArray = array("id"=>$id);
    echo json_encode($jsonArray);
    
