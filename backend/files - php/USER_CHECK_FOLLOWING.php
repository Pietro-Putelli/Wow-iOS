<?php

    require_once 'FriendsDB.php';
    
    $user_email = $_POST['user_email'];
	$friend_id = $_POST['friend_id'];
	
    $friend = new FriendsDB();
    $following = $friend->checkFollowing($user_email,$friend_id);
    
    $jsonArray = array("following" => $following);
    echo json_encode($jsonArray);