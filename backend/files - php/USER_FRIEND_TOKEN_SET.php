<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $friendEmail = $_POST['friendEmail'];
    $addElement = (int)$_POST['addElement'];

    $token = new UsersAccountDB();
    
    $friendToken = $token->selectTokenByEmail($friendEmail);
    $arraySerialized = $token->getFriendsToken($email);

    if (!empty($arraySerialized)) {
        $arrayUnserialized = unserialize($arraySerialized);
    } else {
        $arrayUnserialized = array();
    }
    
    if ($addElement == 1) {
        array_push($arrayUnserialized,$friendToken);
        $arraySerialized = serialize($arrayUnserialized);

    } else {
        $key = array_search($friendToken,$arrayUnserialized);
        unset($arrayUnserialized[$key]);
        $arraySerialized = serialize($arrayUnserialized);
    }
    
    $token->setFriendArray($email,$arraySerialized);

