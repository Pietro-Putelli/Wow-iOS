<?php

    require_once 'GetAreaDB.php';
    
    $id = $_POST['id'];
    
    $getLocal = new GetAreaDB();
    $local = $getLocal->getLocalByID($id);
    
    $jsonArray = array(
            
        "id" => $local->getID(),
        "json_local" => $local->getJSON(),
        "rating" => $local->getRating(),
        "owner" => $local->getOwner()
    );
    
    echo json_encode($jsonArray);