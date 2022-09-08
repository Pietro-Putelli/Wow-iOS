<?php

	require_once 'UsersAccountDB.php';

	$status = $_POST['status'];
	$email = $_POST['email'];
	
	$editor = new UsersAccountDB();
	$editor->setStatusByEmail($email,$status);
?>