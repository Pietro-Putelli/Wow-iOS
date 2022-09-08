<?php

	require_once 'UsersAccountDB.php';
	require_once 'confirmMail/activationsTable.php';
    
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $account = new UsersAccountDB();
    $user_id = $account->createAccount($username,$email,md5($password));
    
    $activation = new Activations($user_id,$email);
    $activation->createNewToken();