<?php
	
	require_once 'UsersAccountDB.php';
	
	$email = $_POST['email'];
		
	$confirmAccount = new UsersAccountDB();
	$confirmAccount->confirmAccount($email);
	