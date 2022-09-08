<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $email = "pietroputelli80@gmail.com";
    $getter = new UsersAccountDB();
    $arrayUnserialized = unserialize($getter->getEventGoingArray($email));

    $commaSeparated = implode(",", $arrayUnserialized);
    $array .= "[";
    $array .= $commaSeparated;
    $array .= "]";

    $jsonArray = array("ids_array" => $array);
    
    echo json_encode($jsonArray);