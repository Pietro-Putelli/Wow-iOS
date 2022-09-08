<?php
session_start();
	require_once 'UsersAccountDB.php';
	

    $user = new UsersAccountDB();
	$username = $_POST['username'];
	$email = $_POST['email'];
	$password = $_POST['password'];
	//$profilePicturePath = $_POST['profilePicturePath'];


    //$username = "Vincent Vega";
	//$email = "rediesirae@gmail.com";
	//$password = "miawallace";
	//$profilePicturePath = "/path";
   
    
    $response = $user->checkEmailForRegistration($email);
    $response = json_encode($response);
    
    echo $response;

    if ($response == 'false')
    {
    $id = $user->createAccount($username, $email, $password); // id utente per token
        
    
    
	/*$query = "INSERT INTO `usersaccount` (username, email, password) VALUES ('".$username."','".$email."','".$password."')";
	$result = mysqli_query($mysqli,$query);
	
	echo $result;
	*/
	
	if (!file_exists('../usersAccountData/' . $email)) {
        mkdir('../usersAccountData/' . $email, 0755, true);
    	}
    	
    if (!file_exists('../usersAccountData/'.$email.'/userLocals')) {
        mkdir('../usersAccountData/'.$email.'/userLocals', 0755, true);
    	}
    	
    if (!file_exists('../usersAccountData/'.$email.'/userEvents')) {
        mkdir('../usersAccountData/'.$email.'/userEvents', 0755, true);
    	}
    	
    	
    	
    	$user->sendConfirmEmail($email,$id);
    	
    	$_SESSION['email']=$email;
        $_SESSION['username']= $username;
    	
    	header("Location: https://finixinc.com/website/account/register_success.php");
    	
	return 1;
    }
    else
    {
        header("Location: https://finixinc.com/website/account/register_error_email_existing.php");
        exit();
    }





	
?>
