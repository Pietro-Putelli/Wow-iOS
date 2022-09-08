<?php

    require_once 'FavouritesDB.php';
    
    $user_id = $_POST['user_id'];
    $event_id = $_POST['event_id'];

    $setter = new FavouritesDB();
    $setter->addGoingEvent($user_id,$event_id);
    
    $addGoing = new EventDB();
    $addGoing->addGoing($event_id);