<?php

    require_once 'LocalDB.php';
    
    $local_id = $_POST['id'];
    
    $setter = new LocalDB();
    $local = $setter->getLocalByID($local_id);
    
    $numberOfReviews = $setter->getNumberOfLocalReviews($local->getID());
    
    $jsonArray = array(
        
            "id" => $local->getID(),
            "json_local" => $local->getJSON(),
            "rating" => $local->getRating(),
            "owner" => $local->getOwner(),
            "likes" => $local->getLikes(),
            "reviews" => $numberOfReviews
        );
        
    echo json_encode($jsonArray);