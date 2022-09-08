<?php

    require_once 'LocalDB.php';

    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $owner = $_POST['owner'];
    $json = $_POST['json'];
    
    $edit = new LocalDB();
    $id = $edit->createLocal($latitude,$longitude,$owner,$json);

    $path = '../usersAccountData/' . $owner . '/userLocals/' . $owner . $id;

    if (!file_exists($path)) {
        mkdir($path, 0755, true);
    }

    $jsonArray = array("id"=>$id);
    echo json_encode($jsonArray);