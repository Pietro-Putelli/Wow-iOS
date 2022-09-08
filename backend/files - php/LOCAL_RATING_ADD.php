<?php

    require_once 'RatingDB.php';
    
    $local_id = $_POST['local_id'];
    $rating = $_POST['rating'];
    
    $setter = new RatingDB();
    $setter->addRating($local_id,$rating);