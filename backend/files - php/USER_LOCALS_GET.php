<?php

    require_once 'GetAreaDB.php';
    require_once 'LocalDB.php';
    
    $email = $_POST['owner'];

    $getLocal = new GetAreaDB();
    $locals = $getLocal->getLocalsByEmail($email);
    
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