<?php

    require_once 'LocalDB.php';
    require_once 'RatingDB.php';

    $username = $_POST['user_name'];
    $useremail = $_POST['user_email'];
    $local_id = $_POST['local_id'];
    $rating = $_POST['rating'];
    $date = $_POST['date'];
    $jsonData = $_POST['json_data'];
    
    $review = new LocalDB();
    $review->setLocalReview($username,$useremail,$local_id,$rating,$jsonData);
    
    $setter = new RatingDB();
    $setter->addRating($local_id,$rating);
    