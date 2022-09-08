<?php

	    require_once 'UsersAccountDB.php';
	
	    $email = $_POST['email'];
	    $friendID = $_POST['friendID'];
	    $addElement = $_POST['addElement'];
	    
	    //$friendID = (int) $friendIDPOST;
	    //$addElement = (int) $addElementPOST;
	    
	    $friend = new UsersAccountDB();
	    $arraySerialized = $friend->getFriendIDs($email);
	    
	    if ($arraySerialized != "") {
	        $arrayUnserialized = unserialize($arraySerialized);
	    } else {
	        $arrayUnserialized = array();
	    }
	    
	    if ($addElement == "OK") {
		    array_push($arrayUnserialized,$friendID);
		    $arraySerialized = serialize($arrayUnserialized);
	    } else if ($addElement == "OJ") {
		    $key = array_search($friendID,$arrayUnserialized);
		    unset($arrayUnserialized[$key]);
		    $arraySerialized = serialize($arrayUnserialized);
	    }
	    
	    $friend->setFriendArray($email,$arraySerialized);
	    
	    