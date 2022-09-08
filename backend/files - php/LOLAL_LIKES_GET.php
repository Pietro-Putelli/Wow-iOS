<?php

    require_once 'LocalDB.php';
    
    $local_id = $_POST['local_id'];
    
    $local = new LocalDB();
    $local_likes = $local->getLikes($local_id);
    
    $jsonArray = array("likes"=>$local_likes);
    echo json_encode($jsonArray);