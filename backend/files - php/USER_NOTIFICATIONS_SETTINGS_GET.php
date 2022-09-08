<?php

	require_once 'UsersAccountDB.php';
	
	$user_email = $_POST['user_email'];

	$user = new UsersAccountDB();
	$responses = $user->getNotificationsSettings($user_email);
	
	$jsonArray = array("notification_settings" => $responses);
	
	echo json_encode($jsonArray);