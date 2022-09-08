<?php

    require_once 'LocalDB.php';
    
    $id = $_POST['id'];

    $getter = new LocalDB();
    $array = unserialize($getter->getImageIDs($id));
    
    $jsonArray = ["imageIDs"=>$array];
    echo json_encode($jsonArray);
    