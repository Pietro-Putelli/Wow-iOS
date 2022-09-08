<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $getFavLocalsArray = new UsersAccountDB();
    $arrayUnserialized = unserialize($getFavLocalsArray->getLikedLocalIDs($email));

    $commaSeparated = implode(",", $arrayUnserialized);
    $array .= "[";
    $array .= $commaSeparated;
    $array .= "]";

    $jsonArray = array("ids_array" => $array);
    
    echo json_encode($jsonArray);