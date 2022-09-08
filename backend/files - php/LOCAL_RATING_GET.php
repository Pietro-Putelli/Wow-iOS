<?php

    require_once 'LocalDB.php';
    
    $id = $_POST['local_id'];

    $getter = new LocalDB();
    $average = $getter->getLocalRating($id);

    $jsonArray = array("rating"=>$average);
    echo json_encode($jsonArray);