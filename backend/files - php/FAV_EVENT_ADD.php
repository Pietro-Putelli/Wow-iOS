<?php

    require_once 'FavouritesDB.php';

    $user_id = $_POST['user_id'];
    $event_id = $_POST['event_id'];
    
    $setter = new FavouritesDB();
    $setter->addFavEvent($user_id,$event_id);
    
    $addLike = new EventDB();
    $addLike->addLike($event_id);