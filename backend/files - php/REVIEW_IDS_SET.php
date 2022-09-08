<?php

    require_once 'UsersAccountDB.php';

    $review = new UsersAccountDB();

    $email = $_POST["email"];
    $localID = (int)$_POST["localID"];
    $element = (int)$review->getReviewIDByEmail($email);
    $addElement = (int)$_POST["addElement"];

    $arraySerialized = $review->getReviewIDs($localID);

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
    }

    echo $arraySerialized;

    $review->setReviewIDs($localID,$arraySerialized);






