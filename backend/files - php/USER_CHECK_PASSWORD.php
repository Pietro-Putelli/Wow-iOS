<?php

    require_once 'UsersAccountDB.php';

    $user_email = $_POST['user_email'];
    $user_password = $_POST['user_password'];
    $new_password = $_POST['new_password'];
	
	$user = new UsersAccountDB();
	$response = $user->checkSetPassword($user_email,$user_password,$new_password);
	$return = array('response'=>$response);
    echo json_encode($return);