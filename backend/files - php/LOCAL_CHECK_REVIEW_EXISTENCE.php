<?php

    require_once 'LocalDB.php';
    
    $email = $_POST['user_email'];
    $localID = $_POST['local_id'];
    
    $review = new LocalDB();
    $reviewExiste = $review->checkReviewExistence($email,$localID);
    
    $jsonArray = array("reviewExiste" => $reviewExiste);
    echo json_encode($jsonArray);