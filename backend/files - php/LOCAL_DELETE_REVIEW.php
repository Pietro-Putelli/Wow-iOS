<?php

    require_once 'LocalDB.php';
    require_once 'RatingDB.php';
    
    $email = $_POST['user_email'];
    $local_id = $_POST['local_id'];
    $rating = $_POST['rating'];

    $removeReview = new LocalDB();
    $removeReview->deleteReview($email,$local_id);
    
    $setter = new RatingDB();
    $setter->removeRating($local_id,$rating);