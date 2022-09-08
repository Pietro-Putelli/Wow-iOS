<?php

    require_once 'FavouritesDB.php';
    
    $user_id = $_POST['user_id'];
    $event_id = $_POST['event_id'];
    
    $checker = new FavouritesDB();
    $bool = $checker->checkEventGoing($user_id,$event_id);
    
    $jsonArray = array("bool"=>$bool);
    echo json_encode($jsonArray);