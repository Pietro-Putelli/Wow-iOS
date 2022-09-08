<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $getter = new UsersAccountDB();
    $arrayUnserialized = unserialize($getter->getEventLikesArray($email));

    $commaSeparated = implode(",", $arrayUnserialized);
    $array .= "[";
    $array .= $commaSeparated;
    $array .= "]";

    $jsonArray = array("ids_array" => $array);
    
    echo json_encode($jsonArray);