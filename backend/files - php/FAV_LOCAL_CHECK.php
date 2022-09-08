<?php

    require_once 'FavouritesDB.php';
    
    $user_id = $_POST['user_id'];
	$local_id = $_POST['local_id'];
	
    $local = new FavouritesDB();
    $favourite = $local->checkFav($user_id,$local_id);
    
    $jsonArray = array("favourite" => $favourite);
    echo json_encode($jsonArray);