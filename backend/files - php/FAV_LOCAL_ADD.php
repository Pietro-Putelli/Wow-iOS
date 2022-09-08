<?php

    require_once 'FavouritesDB.php';

    $user_id = $_POST['user_id'];
    $local_id = $_POST['local_id'];

    $setter = new FavouritesDB();
    $setter->addFavLocal($user_id,$local_id);
    
    $addLike = new LocalDB();
    $addLike->addLike($local_id);