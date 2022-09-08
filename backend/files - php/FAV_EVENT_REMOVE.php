<?php

    require_once 'FavouritesDB.php';

    $user_id = $_POST['user_id'];
    $event_id = $_POST['event_id'];
    
    $setter = new FavouritesDB();
    $setter->removeFavEvent($user_id,$event_id);
    
    $addLike = new EventDB();
    $addLike->removeLike($event_id);