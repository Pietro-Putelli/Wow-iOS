<?php

	require_once 'UsersAccountDB.php';

	$username = $_POST['username'];
	$email = $_POST['email'];

	$editor = new UsersAccountDB();
	$editor->setUsernameByEmail($email,$username);
?>