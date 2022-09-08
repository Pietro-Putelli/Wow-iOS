<?php

    require_once 'FavouritesDB.php';
    
    $user_id = $_POST['user_id'];

    $favLocals = new FavouritesDB();
    $locals = $favLocals->getFavLocals($user_id);

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