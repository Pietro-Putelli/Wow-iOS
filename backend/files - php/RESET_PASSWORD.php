<?php

     require_once 'reset_password/ResetPasswordDB.php';
     require_once 'UsersAccountDB.php';

    $email = $_POST['email'];
    $token = $_POST['token'];
    $new_password = $_POST['newPassword'];

    $user = new UsersAccountDB();
    $user->setPasswordByEmail($email,md5($new_password));
    $user_id = $user->getUserIDByEmail($email);
    
    $setter = new ResetPasswordDB($user_id,$email);
    $setter->resetPassword($token);
?>

<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">

    <link rel="shortcut icon" href="https://.finixinc.com/website/images/FinixIcon.png">
    <style>
        @font-face {
            font-family: 'myFont';
            src: url('https://finixinc.com/website/font/accuratist.ttf');
        }

        html,
        body {
            height: 100%;
        }

        body {
            font-family: myfont;
            display: -ms-flexbox;
            display: -webkit-box;
            display: flex;
            -ms-flex-align: center;
            -ms-flex-pack: center;
            -webkit-box-align: center;
            align-items: center;
            -webkit-box-pack: center;
            justify-content: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }
        
        .finix {
            font-size: 20px;
        }
        
        .legal {
            font-size: 16px;
        }
        
        .image {
            content: url("https://finixinc.com/website/images/FinixIcon.png");
            width: 15%;
            height: auto;
        }

    </style>

    <title>Success</title>
</head>

<body class="text-center">
    <div>
        <div class="alert alert-success" role="alert">
            <h1 class="alert-heading">Well done </h1>
            <h4>Your password has been reset, enjoy </h4>
        </div>
        <div> 
            <img class="image">
        </div>
        <p class="finix"> FINIX </p> 
        <p class="legal">&copy; 2018 Gianfranco Putelli</p>
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script src=""></script>

</body>

</html>
