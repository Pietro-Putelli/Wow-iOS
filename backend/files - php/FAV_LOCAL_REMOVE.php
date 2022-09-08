<?php

    require_once 'FavouritesDB.php';
    
    $user_id = $_POST['user_id'];
    $local_id = $_POST['local_id'];

    $setter = new FavouritesDB();
    $setter->removeFavLocal($user_id,$local_id);

    $addLike = new LocalDB();
    $addLike->removeLike($local_id);