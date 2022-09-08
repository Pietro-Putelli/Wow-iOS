<?php

	require_once 'UsersAccountDB.php';

	$password = $_POST['password'];
	$email = $_POST['email'];
	
	$editor = new UsersAccountDB();
	$editor->setPasswordByEmail($email,md5($password));