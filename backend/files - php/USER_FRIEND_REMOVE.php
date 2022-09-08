<?php

    require_once 'FriendsDB.php';
    
    $user_email = $_POST['user_email'];
	$friend_id = $_POST['friend_id'];
	
    $friend = new FriendsDB();
    $friend->removeFriend($user_email,$friend_id);