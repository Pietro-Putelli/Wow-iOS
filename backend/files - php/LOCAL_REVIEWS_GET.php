<?php

    require_once 'LocalDB.php';

    $id = $_POST['id'];
    $review = new LocalDB();
    $reviews = $review->getLocalReviews($id);

    $jsonArray = array();

    foreach ($reviews as $review) {
        
        $jsonArray1 = array(
            
            "id" => $review->getID(),
            "username" => $review->getUsername(),
            "useremail" => $review->getUseremail(),
            "rating" => $review->getUserRating(),
            "date" => $review->getDate(),
            "reviewJSON" => $review->getReviewJSON()
            );
            
            array_push($jsonArray,$jsonArray1);
    }
    
    echo json_encode($jsonArray);