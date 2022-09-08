<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $element = (int) $_POST['element'];
    $addElement = (int)$_POST['addElement'];
    
    $favLocals = new UsersAccountDB();

    $arraySerialized = $favLocals->getLikedEventIDs($email);
    
    echo $arraySerialized;
    
    if ($arraySerialized != "") {
        $arrayUnserialized = unserialize($arraySerialized);
    } else {
        $arrayUnserialized = array();
    }
    
    if ($addElement == 1) {
        array_push($arrayUnserialized,$element);
        $arraySerialized = serialize($arrayUnserialized);

    } else {
        
        if (in_array($element,$arrayUnserialized)) {
            $key = array_search($element,$arrayUnserialized);
            unset($arrayUnserialized[$key]);
            $arraySerialized = serialize($arrayUnserialized);
        }
        
        /*
        $key = array_search($element,$arrayUnserialized);
        echo "cc".$key;
        unset($arrayUnserialized[$key]);
        $arraySerialized = serialize($arrayUnserialized);
        */
    }
    
    echo $arraySerialized;

    $favLocals->setLikedEventsArray($email,$arraySerialized);
